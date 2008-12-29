Return-Path: <linux-kernel-owner+w=401wt.eu-S1755302AbYL2KUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302AbYL2KUl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 05:20:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753583AbYL2KUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 05:20:25 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:51639 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754474AbYL2KUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 05:20:23 -0500
Date: Mon, 29 Dec 2008 11:20:19 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: mchehab@infradead.org, v4l-dvb-maintainer@linuxtv.org,
       video4linux-list@redhat.com, gregkh@suse.de,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 4/13] drivers/media/video: use USB API functions rather than
 constants
Message-ID: <Pine.LNX.4.64.0812291120000.9555@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

This set of patches introduces calls to the following set of functions:

usb_endpoint_dir_in(epd)
usb_endpoint_dir_out(epd)
usb_endpoint_is_bulk_in(epd)
usb_endpoint_is_bulk_out(epd)
usb_endpoint_is_int_in(epd)
usb_endpoint_is_int_out(epd)
usb_endpoint_num(epd)
usb_endpoint_type(epd)
usb_endpoint_xfer_bulk(epd)
usb_endpoint_xfer_control(epd)
usb_endpoint_xfer_int(epd)
usb_endpoint_xfer_isoc(epd)

In some cases, introducing one of these functions is not possible, and it
just replaces an explicit integer value by one of the following constants:

USB_ENDPOINT_XFER_BULK
USB_ENDPOINT_XFER_CONTROL
USB_ENDPOINT_XFER_INT
USB_ENDPOINT_XFER_ISOC

An extract of the semantic patch that makes these changes is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r1@ struct usb_endpoint_descriptor *epd; @@

- ((epd->bmAttributes & \(USB_ENDPOINT_XFERTYPE_MASK\|3\)) ==
- \(USB_ENDPOINT_XFER_CONTROL\|0\))
+ usb_endpoint_xfer_control(epd)

@r5@ struct usb_endpoint_descriptor *epd; @@

- ((epd->bEndpointAddress & \(USB_ENDPOINT_DIR_MASK\|0x80\)) ==
-  \(USB_DIR_IN\|0x80\))
+ usb_endpoint_dir_in(epd)

@inc@
@@

#include <linux/usb.h>

@depends on !inc && (r1||r5)@
@@

+ #include <linux/usb.h>
  #include <linux/usb/...>
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/media/video/em28xx/em28xx-video.c         |    8 ++++----
 drivers/media/video/stk-webcam.c                  |    8 +++-----
 drivers/media/video/usbvideo/ibmcam.c             |    4 ++--
 drivers/media/video/usbvideo/konicawc.c           |    4 ++--
 drivers/media/video/usbvideo/quickcam_messenger.c |    7 ++-----
 drivers/media/video/usbvideo/ultracam.c           |    4 ++--
 drivers/media/video/usbvideo/vicam.c              |    3 +--
 drivers/media/video/usbvision/usbvision-video.c   |    5 ++---
 8 files changed, 18 insertions(+), 25 deletions(-)

diff --git a/drivers/media/video/em28xx/em28xx-video.c b/drivers/media/video/em28xx/em28xx-video.c
index 3eef6e3..2627ff1 100644
--- a/drivers/media/video/em28xx/em28xx-video.c
+++ b/drivers/media/video/em28xx/em28xx-video.c
@@ -2207,8 +2207,8 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 	endpoint = &interface->cur_altsetting->endpoint[0].desc;
 
 	/* check if the device has the iso in endpoint at the correct place */
-	if ((endpoint->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) ==
-	    USB_ENDPOINT_XFER_ISOC &&
+	if (usb_endpoint_xfer_isoc(endpoint)
+	     &&
 	    (interface->altsetting[1].endpoint[0].desc.wMaxPacketSize == 940))
 	{
 		/* It's a newer em2874/em2875 device */
@@ -2217,11 +2217,11 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 		int check_interface = 1;
 		isoc_pipe = 1;
 		endpoint = &interface->cur_altsetting->endpoint[1].desc;
-		if ((endpoint->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) !=
+		if (usb_endpoint_type(endpoint) !=
 		    USB_ENDPOINT_XFER_ISOC)
 			check_interface = 0;
 
-		if ((endpoint->bEndpointAddress & USB_ENDPOINT_DIR_MASK) == USB_DIR_OUT)
+		if (usb_endpoint_dir_out(endpoint))
 			check_interface = 0;
 
 		if (!check_interface) {
diff --git a/drivers/media/video/stk-webcam.c b/drivers/media/video/stk-webcam.c
index e9eb6d7..fec1544 100644
--- a/drivers/media/video/stk-webcam.c
+++ b/drivers/media/video/stk-webcam.c
@@ -1376,12 +1376,10 @@ static int stk_camera_probe(struct usb_interface *interface,
 		endpoint = &iface_desc->endpoint[i].desc;
 
 		if (!dev->isoc_ep
-			&& ((endpoint->bEndpointAddress
-				& USB_ENDPOINT_DIR_MASK) == USB_DIR_IN)
-			&& ((endpoint->bmAttributes
-				& USB_ENDPOINT_XFERTYPE_MASK) == USB_ENDPOINT_XFER_ISOC)) {
+			&& usb_endpoint_dir_in(endpoint)
+			&& usb_endpoint_xfer_isoc(endpoint)) {
 			/* we found an isoc in endpoint */
-			dev->isoc_ep = (endpoint->bEndpointAddress & 0xF);
+			dev->isoc_ep = usb_endpoint_num(endpoint);
 			break;
 		}
 	}
diff --git a/drivers/media/video/usbvideo/ibmcam.c b/drivers/media/video/usbvideo/ibmcam.c
index c710bcd..f8d85dd 100644
--- a/drivers/media/video/usbvideo/ibmcam.c
+++ b/drivers/media/video/usbvideo/ibmcam.c
@@ -3779,11 +3779,11 @@ static int ibmcam_probe(struct usb_interface *intf, const struct usb_device_id *
 			err("Alternate settings have different endpoint addresses!");
 			return -ENODEV;
 		}
-		if ((endpoint->bmAttributes & 0x03) != 0x01) {
+		if (usb_endpoint_type(endpoint) != USB_ENDPOINT_XFER_ISOC) {
 			err("Interface %d. has non-ISO endpoint!", ifnum);
 			return -ENODEV;
 		}
-		if ((endpoint->bEndpointAddress & 0x80) == 0) {
+		if (usb_endpoint_dir_out(endpoint)) {
 			err("Interface %d. has ISO OUT endpoint!", ifnum);
 			return -ENODEV;
 		}
diff --git a/drivers/media/video/usbvideo/konicawc.c b/drivers/media/video/usbvideo/konicawc.c
index da27a52..90f0ce6 100644
--- a/drivers/media/video/usbvideo/konicawc.c
+++ b/drivers/media/video/usbvideo/konicawc.c
@@ -823,12 +823,12 @@ static int konicawc_probe(struct usb_interface *intf, const struct usb_device_id
 			err("Alternate settings have different endpoint addresses!");
 			return -ENODEV;
 		}
-		if ((endpoint->bmAttributes & 0x03) != 0x01) {
+		if (usb_endpoint_type(endpoint) != USB_ENDPOINT_XFER_ISOC) {
 			err("Interface %d. has non-ISO endpoint!",
 			    interface->desc.bInterfaceNumber);
 			return -ENODEV;
 		}
-		if ((endpoint->bEndpointAddress & 0x80) == 0) {
+		if (usb_endpoint_dir_out(endpoint)) {
 			err("Interface %d. has ISO OUT endpoint!",
 			    interface->desc.bInterfaceNumber);
 			return -ENODEV;
diff --git a/drivers/media/video/usbvideo/quickcam_messenger.c b/drivers/media/video/usbvideo/quickcam_messenger.c
index 4459b8a..354bd2e 100644
--- a/drivers/media/video/usbvideo/quickcam_messenger.c
+++ b/drivers/media/video/usbvideo/quickcam_messenger.c
@@ -955,8 +955,7 @@ static int qcm_probe(struct usb_interface *intf,
 		for (j=0; j < interface->desc.bNumEndpoints; j++) {
 			endpoint = &interface->endpoint[j].desc;
 
-			if ((endpoint->bEndpointAddress &
-				USB_ENDPOINT_DIR_MASK) != USB_DIR_IN)
+			if (usb_endpoint_dir_out(endpoint))
 				continue; /* not input then not good */
 
 			buffer_size = le16_to_cpu(endpoint->wMaxPacketSize);
@@ -965,9 +964,7 @@ static int qcm_probe(struct usb_interface *intf,
 				continue; /* 0 pkt size is not what we want */
 			}
 
-			if ((endpoint->bmAttributes &
-				USB_ENDPOINT_XFERTYPE_MASK) ==
-				USB_ENDPOINT_XFER_ISOC) {
+			if (usb_endpoint_xfer_isoc(endpoint)) {
 				video_ep = endpoint->bEndpointAddress;
 				/* break out of the search */
 				goto good_videoep;
diff --git a/drivers/media/video/usbvideo/ultracam.c b/drivers/media/video/usbvideo/ultracam.c
index 9714baa..839a082 100644
--- a/drivers/media/video/usbvideo/ultracam.c
+++ b/drivers/media/video/usbvideo/ultracam.c
@@ -556,12 +556,12 @@ static int ultracam_probe(struct usb_interface *intf, const struct usb_device_id
 			err("Alternate settings have different endpoint addresses!");
 			return -ENODEV;
 		}
-		if ((endpoint->bmAttributes & 0x03) != 0x01) {
+		if (usb_endpoint_type(endpoint) != USB_ENDPOINT_XFER_ISOC) {
 			err("Interface %d. has non-ISO endpoint!",
 			    interface->desc.bInterfaceNumber);
 			return -ENODEV;
 		}
-		if ((endpoint->bEndpointAddress & 0x80) == 0) {
+		if (usb_endpoint_dir_out(endpoint)) {
 			err("Interface %d. has ISO OUT endpoint!",
 			    interface->desc.bInterfaceNumber);
 			return -ENODEV;
diff --git a/drivers/media/video/usbvideo/vicam.c b/drivers/media/video/usbvideo/vicam.c
index 8e2d58b..4602597 100644
--- a/drivers/media/video/usbvideo/vicam.c
+++ b/drivers/media/video/usbvideo/vicam.c
@@ -844,8 +844,7 @@ vicam_probe( struct usb_interface *intf, const struct usb_device_id *id)
 	       interface->desc.bInterfaceNumber, (unsigned) (interface->desc.bNumEndpoints));
 	endpoint = &interface->endpoint[0].desc;
 
-	if ((endpoint->bEndpointAddress & 0x80) &&
-	    ((endpoint->bmAttributes & 3) == 0x02)) {
+	if (usb_endpoint_is_bulk_in(endpoint)) {
 		/* we found a bulk in endpoint */
 		bulkEndpoint = endpoint->bEndpointAddress;
 	} else {
diff --git a/drivers/media/video/usbvision/usbvision-video.c b/drivers/media/video/usbvision/usbvision-video.c
index 48c8c43..85661b1 100644
--- a/drivers/media/video/usbvision/usbvision-video.c
+++ b/drivers/media/video/usbvision/usbvision-video.c
@@ -1679,7 +1679,7 @@ static int __devinit usbvision_probe(struct usb_interface *intf,
 		interface = &dev->actconfig->interface[ifnum]->altsetting[0];
 	}
 	endpoint = &interface->endpoint[1].desc;
-	if ((endpoint->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) !=
+	if (usb_endpoint_type(endpoint) !=
 	    USB_ENDPOINT_XFER_ISOC) {
 		err("%s: interface %d. has non-ISO endpoint!",
 		    __func__, ifnum);
@@ -1687,8 +1687,7 @@ static int __devinit usbvision_probe(struct usb_interface *intf,
 		    __func__, endpoint->bmAttributes);
 		return -ENODEV;
 	}
-	if ((endpoint->bEndpointAddress & USB_ENDPOINT_DIR_MASK) ==
-	    USB_DIR_OUT) {
+	if (usb_endpoint_dir_out(endpoint)) {
 		err("%s: interface %d. has ISO OUT endpoint!",
 		    __func__, ifnum);
 		return -ENODEV;
