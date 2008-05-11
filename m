Return-Path: <linux-kernel-owner+w=401wt.eu-S1758058AbYEKUXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758058AbYEKUXT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 16:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753612AbYEKUXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 16:23:05 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:49315 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbYEKUXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 16:23:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=lt8RC+LKm6GzFAzPNyR4BuvjVUKnjQT7YXB3E/e8m2mfISjqneAzJwyaqUedzNdMUenImQrjml0LX2NngQvJPHsayAWDn1b4rEikDvxPemtAfD9HDXcCBj2h5db6e/gx1VL9tdQ6MnJFShnIqCYvdd1bRRDrWfzHnSqeQxGnzng=
Date: Sun, 11 May 2008 22:22:26 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org
Subject: drivers/usb/misc/usbtest.c weirdness
Message-ID: <20080511202222.GP19058@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

test_ctrl_queue expects (?) positive and negative errnos.
what is going on here?

diff --git a/drivers/usb/misc/usbtest.c b/drivers/usb/misc/usbtest.c
index 742be3c..5a65991 100644
--- a/drivers/usb/misc/usbtest.c
+++ b/drivers/usb/misc/usbtest.c
@@ -880,7 +880,7 @@ test_ctrl_queue (struct usbtest_dev *dev, struct usbtest_param *param)
 			req.bRequestType = USB_DIR_IN|USB_RECIP_INTERFACE;
 			// index = 0 means first interface
 			len = 1;
-			expected = EPIPE;
+			expected = EPIPE; //??
 			break;
 		case 3:		// get interface status
 			req.bRequest = USB_REQ_GET_STATUS;
@@ -897,7 +897,7 @@ test_ctrl_queue (struct usbtest_dev *dev, struct usbtest_param *param)
 			req.wValue = cpu_to_le16 (USB_DT_DEVICE_QUALIFIER << 8);
 			len = sizeof (struct usb_qualifier_descriptor);
 			if (udev->speed != USB_SPEED_HIGH)
-				expected = EPIPE;
+				expected = EPIPE; // ??
 			break;
 		case 6:		// get first config descriptor, plus interface
 			req.wValue = cpu_to_le16 ((USB_DT_CONFIG << 8) | 0);
@@ -908,7 +908,7 @@ test_ctrl_queue (struct usbtest_dev *dev, struct usbtest_param *param)
 			req.wValue = cpu_to_le16 (USB_DT_INTERFACE << 8);
 			// interface == 0
 			len = sizeof (struct usb_interface_descriptor);
-			expected = -EPIPE;
+			expected = -EPIPE; // ok
 			break;
 		// NOTE: two consecutive stalls in the queue here.
 		// that tests fault recovery a bit more aggressively.
@@ -919,7 +919,7 @@ test_ctrl_queue (struct usbtest_dev *dev, struct usbtest_param *param)
 			// wIndex 0 == ep0 (shouldn't halt!)
 			len = 0;
 			pipe = usb_sndctrlpipe (udev, 0);
-			expected = EPIPE;
+			expected = EPIPE; // ??
 			break;
 		case 9:		// get endpoint status
 			req.bRequest = USB_REQ_GET_STATUS;
@@ -930,14 +930,14 @@ test_ctrl_queue (struct usbtest_dev *dev, struct usbtest_param *param)
 		case 10:	// trigger short read (EREMOTEIO)
 			req.wValue = cpu_to_le16 ((USB_DT_CONFIG << 8) | 0);
 			len = 1024;
-			expected = -EREMOTEIO;
+			expected = -EREMOTEIO; // ok
 			break;
 		// NOTE: two consecutive _different_ faults in the queue.
 		case 11:	// get endpoint descriptor (ALWAYS STALLS)
 			req.wValue = cpu_to_le16 (USB_DT_ENDPOINT << 8);
 			// endpoint == 0
 			len = sizeof (struct usb_interface_descriptor);
-			expected = EPIPE;
+			expected = EPIPE; // ??
 			break;
 		// NOTE: sometimes even a third fault in the queue!
 		case 12:	// get string 0 descriptor (MAY STALL)
@@ -945,13 +945,13 @@ test_ctrl_queue (struct usbtest_dev *dev, struct usbtest_param *param)
 			// string == 0, for language IDs
 			len = sizeof (struct usb_interface_descriptor);
 			// may succeed when > 4 languages
-			expected = EREMOTEIO;	// or EPIPE, if no strings
+			expected = EREMOTEIO;	// or EPIPE, if no strings // ??
 			break;
 		case 13:	// short read, resembling case 10
 			req.wValue = cpu_to_le16 ((USB_DT_CONFIG << 8) | 0);
 			// last data packet "should" be DATA1, not DATA0
 			len = 1024 - udev->descriptor.bMaxPacketSize0;
-			expected = -EREMOTEIO;
+			expected = -EREMOTEIO; // ok
 			break;
 		case 14:	// short read; try to fill the last packet
 			req.wValue = cpu_to_le16 ((USB_DT_DEVICE << 8) | 0);
@@ -961,11 +961,11 @@ test_ctrl_queue (struct usbtest_dev *dev, struct usbtest_param *param)
 			case 8:		len = 24; break;
 			case 16:	len = 32; break;
 			}
-			expected = -EREMOTEIO;
+			expected = -EREMOTEIO; // ok
 			break;
 		default:
 			ERROR(dev, "bogus number of ctrl queue testcases!\n");
-			context.status = -EINVAL;
+			context.status = -EINVAL; // ok
 			goto cleanup;
 		}
 		req.wLength = cpu_to_le16 (len);
-- 

