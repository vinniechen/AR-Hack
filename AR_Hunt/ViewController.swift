/*
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import SceneKit
import AVFoundation

class ViewController: UIViewController {
  
  @IBOutlet weak var sceneView: SCNView!
  @IBOutlet weak var leftIndicator: UILabel!
  @IBOutlet weak var rightIndicator: UILabel!
  
  // Use AVCaptureSession to connect video input and output (preview layer)
  var cameraSession: AVCaptureSession?
  var cameraLayer: AVCaptureVideoPreviewLayer?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    loadCamera()
    self.cameraSession?.startRunning()
    
  }
  
  func createCaptureSession() -> (session: AVCaptureSession?, error: NSError) {
    // Return values
    var error: NSError?
    var captureSession: AVCaptureSession?
    
    
    // Get the rear camera of the device
    let backVideoDevice = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .back)
    
    // If camera exists, get its input
    if backVideoDevice != nil {
      var videoInput: AVCaptureDeviceInput!
      do {
        videoInput = try AVCaptureDeviceInput(device: backVideoDevice)
      } catch let error1 as NSError {
        error = error1
        videoInput = nil
      }
    
      // Create an instance of AVCaptureSession
      if error == nil {
        captureSession = AVCaptureSession()
        
        // Add the video device as input
        if captureSession!.canAddInput(videoInput) {
          captureSession!.addInput(videoInput)
        } else {
          error = NSError(domain: "", code: 0, userInfo: ["description": "Error adding video input"])
        }
      } else {
        error = NSError(domain: "", code: 1, userInfo: ["description" : "Error creating capture device input"])
      }
      
    } else {
      error = NSError(domain: "", code: 2, userInfo: ["description" : "Back video device not found"])
    }
  
    return (session: captureSession, error: error!)
  }
  
  func loadCamera() {
    // Get a capture session
    let captureSessionResult = createCaptureSession()
    
    // If there was an error or captureSession is nil, return/end
    guard captureSessionResult.error == nil, let session = captureSessionResult.session else {
      print("Error creating capture session")
      return
    }
    
    // Store capture session in cameraSession
    self.cameraSession = session
    
    // Create a video preview layer
    if let cameraLayer = AVCaptureVideoPreviewLayer(session: self.cameraSession) {
      
      // Set videoGravity and sets the frame of the layer to views bounds (fullscreen)
      cameraLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
    
      // Add the layer as a sublayer and store it in cameraLayer
      self.view.layer.insertSublayer(cameraLayer, at: 0)
      self.cameraLayer = cameraLayer
    }
  }
  
  
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
}

