Return-Path: <linux-kernel-owner+w=401wt.eu-S1760030AbZACQx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760030AbZACQx1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 11:53:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759261AbZACQxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 11:53:18 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:41866 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758019AbZACQxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 11:53:15 -0500
Date: Sat, 3 Jan 2009 17:53:10 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: mchehab@infradead.org, v4l-dvb-maintainer@linuxtv.org,
       video4linux-list@redhat.com, gregkh@suse.de,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 1/2] drivers/media/video: Use negated usb_endpoint_xfer_control,
 etc
Message-ID: <Pine.LNX.4.64.0901031751530.9811@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

This patch extends 134179823b3ca9c8b98e0631906459dbb022ff9b by using
usb_endpoint_xfer_control, usb_endpoint_xfer_isoc, usb_endpoint_xfer_bulk,
and usb_endpoint_xfer_int in the negated case as well.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@ struct usb_endpoint_descriptor *epd; @@

- (usb_endpoint_type(epd) != \(USB_ENDPOINT_XFER_CONTROL\|0\))
+ !usb_endpoint_xfer_control(epd)

@@ struct usb_endpoint_descriptor *epd; @@

- (usb_endpoint_type(epd) != \(USB_ENDPOINT_XFER_ISOC\|1\))
+ !usb_endpoint_xfer_isoc(epd)

@@ struct usb_endpoint_descriptor *epd; @@

- (usb_endpoint_type(epd) != \(USB_ENDPOINT_XFER_BULK\|2\))
+ !usb_endpoint_xfer_bulk(epd)

@@ struct usb_endpoint_descriptor *epd; @@

- (usb_endpoint_type(epd) != \(USB_ENDPOINT_XFER_INT\|3\))
+ !usb_endpoint_xfer_int(epd)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
index e776699..1fc4e78 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -1990,8 +1990,7 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 		int check_interface = 1;
 		isoc_pipe = 1;
 		endpoint = &interface->cur_altsetting->endpoint[1].desc;
-		if (usb_endpoint_type(endpoint) !=
-		    USB_ENDPOINT_XFER_ISOC)
+		if (!usb_endpoint_xfer_isoc(endpoint))
 			check_interface = 0;
 
 		if (usb_endpoint_dir_out(endpoint))
diff --git a/drivers/media/video/usbvideo/ibmcam.c b/drivers/media/video/usbvideo/ibmcam.c
index f8d85dd..b085496 100644
--- a/drivers/media/video/usbvideo/ibmcam.c
+++ b/drivers/media/video/usbvideo/ibmcam.c
@@ -3779,7 +3779,7 @@ static int ibmcam_probe(struct usb_interface *intf, const struct usb_device_id *
 			err("Alternate settings have different endpoint addresses!");
 			return -ENODEV;
 		}
-		if (usb_endpoint_type(endpoint) != USB_ENDPOINT_XFER_ISOC) {
+		if (!usb_endpoint_xfer_isoc(endpoint)) {
 			err("Interface %d. has non-ISO endpoint!", ifnum);
 			return -ENODEV;
 		}
diff --git a/drivers/media/video/usbvideo/konicawc.c b/drivers/media/video/usbvideo/konicawc.c
index 90f0ce6..900ec21 100644
--- a/drivers/media/video/usbvideo/konicawc.c
+++ b/drivers/media/video/usbvideo/konicawc.c
@@ -823,7 +823,7 @@ static int konicawc_probe(struct usb_interface *intf, const struct usb_device_id
 			err("Alternate settings have different endpoint addresses!");
 			return -ENODEV;
 		}
-		if (usb_endpoint_type(endpoint) != USB_ENDPOINT_XFER_ISOC) {
+		if (!usb_endpoint_xfer_isoc(endpoint)) {
 			err("Interface %d. has non-ISO endpoint!",
 			    interface->desc.bInterfaceNumber);
 			return -ENODEV;
diff --git a/drivers/media/video/usbvideo/ultracam.c b/drivers/media/video/usbvideo/ultracam.c
index 839a082..fbd1b63 100644
--- a/drivers/media/video/usbvideo/ultracam.c
+++ b/drivers/media/video/usbvideo/ultracam.c
@@ -556,7 +556,7 @@ static int ultracam_probe(struct usb_interface *intf, const struct usb_device_id
 			err("Alternate settings have different endpoint addresses!");
 			return -ENODEV;
 		}
-		if (usb_endpoint_type(endpoint) != USB_ENDPOINT_XFER_ISOC) {
+		if (!usb_endpoint_xfer_isoc(endpoint)) {
 			err("Interface %d. has non-ISO endpoint!",
 			    interface->desc.bInterfaceNumber);
 			return -ENODEV;
diff --git a/drivers/media/video/usbvision/usbvision-video.c b/drivers/media/video/usbvision/usbvision-video.c
index 85661b1..70d34b2 100644
--- a/drivers/media/video/usbvision/usbvision-video.c
+++ b/drivers/media/video/usbvision/usbvision-video.c
@@ -1679,8 +1679,7 @@ static int __devinit usbvision_probe(struct usb_interface *intf,
 		interface = &dev->actconfig->interface[ifnum]->altsetting[0];
 	}
 	endpoint = &interface->endpoint[1].desc;
-	if (usb_endpoint_type(endpoint) !=
-	    USB_ENDPOINT_XFER_ISOC) {
+	if (!usb_endpoint_xfer_isoc(endpoint)) {
 		err("%s: interface %d. has non-ISO endpoint!",
 		    __func__, ifnum);
 		err("%s: Endpoint attributes %d",
