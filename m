Return-Path: <linux-kernel-owner+w=401wt.eu-S1756422AbZKWKEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756422AbZKWKEP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 05:04:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756145AbZKWKEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 05:04:13 -0500
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:49357 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756656AbZKWKEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 05:04:12 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Oliver Neukum <oliver@neukum.org>
Subject: [PATCH 1/3] usbtouchscreen: convert from usb_device to usb_interface
Date: Mon, 23 Nov 2009 11:04:10 +0100
User-Agent: KMail/1.9.10
Cc: linux-usb@vger.kernel.org, daniel.ritz@gmx.ch,
       linux-kernel@vger.kernel.org
References: <200911161515.00907.linux@rainbow-software.org> <200911202341.31496.linux@rainbow-software.org> <200911211017.58399.oliver@neukum.org>
In-Reply-To: <200911211017.58399.oliver@neukum.org>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 4209
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911231104.12451.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert usbtouchscreen from storing usb_device to usb_interface. This is
needed for multi-interface touchscreen devices such as iNexio.


Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- linux-source-2.6.31/drivers/input/touchscreen/usbtouchscreen.c.orig	2009-11-23 09:56:27.000000000 +0100
+++ linux-source-2.6.31/drivers/input/touchscreen/usbtouchscreen.c	2009-11-23 09:58:20.000000000 +0100
@@ -93,7 +93,7 @@ struct usbtouch_usb {
 	unsigned char *buffer;
 	int buf_len;
 	struct urb *irq;
-	struct usb_device *udev;
+	struct usb_interface *interface;
 	struct input_dev *input;
 	struct usbtouch_device_info *type;
 	char name[128];
@@ -280,8 +280,9 @@ static int mtouch_read_data(struct usbto
 static int mtouch_init(struct usbtouch_usb *usbtouch)
 {
 	int ret, i;
+	struct usb_device *udev = interface_to_usbdev(usbtouch->interface);
 
-	ret = usb_control_msg(usbtouch->udev, usb_rcvctrlpipe(usbtouch->udev, 0),
+	ret = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
 	                      MTOUCHUSB_RESET,
 	                      USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 	                      1, 0, NULL, 0, USB_CTRL_SET_TIMEOUT);
@@ -292,7 +293,7 @@ static int mtouch_init(struct usbtouch_u
 	msleep(150);
 
 	for (i = 0; i < 3; i++) {
-		ret = usb_control_msg(usbtouch->udev, usb_rcvctrlpipe(usbtouch->udev, 0),
+		ret = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
 				      MTOUCHUSB_ASYNC_REPORT,
 				      USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 				      1, 1, NULL, 0, USB_CTRL_SET_TIMEOUT);
@@ -425,7 +426,7 @@ static int gunze_read_data(struct usbtou
 
 static int dmc_tsc10_init(struct usbtouch_usb *usbtouch)
 {
-	struct usb_device *dev = usbtouch->udev;
+	struct usb_device *dev = interface_to_usbdev(usbtouch->interface);
 	int ret = -ENOMEM;
 	unsigned char *buf;
 
@@ -850,7 +851,7 @@ static int usbtouch_open(struct input_de
 {
 	struct usbtouch_usb *usbtouch = input_get_drvdata(input);
 
-	usbtouch->irq->dev = usbtouch->udev;
+	usbtouch->irq->dev = interface_to_usbdev(usbtouch->interface);
 
 	if (usb_submit_urb(usbtouch->irq, GFP_KERNEL))
 		return -EIO;
@@ -920,7 +921,7 @@ static int usbtouch_probe(struct usb_int
 		goto out_free_buffers;
 	}
 
-	usbtouch->udev = udev;
+	usbtouch->interface = intf;
 	usbtouch->input = input_dev;
 
 	if (udev->manufacturer)
@@ -959,12 +960,12 @@ static int usbtouch_probe(struct usb_int
 		input_set_abs_params(input_dev, ABS_PRESSURE, type->min_press,
 		                     type->max_press, 0, 0);
 
-	usb_fill_int_urb(usbtouch->irq, usbtouch->udev,
-			 usb_rcvintpipe(usbtouch->udev, endpoint->bEndpointAddress),
+	usb_fill_int_urb(usbtouch->irq, udev,
+			 usb_rcvintpipe(udev, endpoint->bEndpointAddress),
 			 usbtouch->data, type->rept_size,
 			 usbtouch_irq, usbtouch, endpoint->bInterval);
 
-	usbtouch->irq->dev = usbtouch->udev;
+	usbtouch->irq->dev = udev;
 	usbtouch->irq->transfer_dma = usbtouch->data_dma;
 	usbtouch->irq->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
 

-- 
Ondrej Zary
