Return-Path: <linux-kernel-owner+w=401wt.eu-S1755451AbZLCJHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451AbZLCJHg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 04:07:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752742AbZLCJHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 04:07:35 -0500
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:47693 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751953AbZLCJHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 04:07:30 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/3 -next] usbtouchscreen: convert from usb_device to usb_interface
Date: Thu, 3 Dec 2009 10:07:30 +0100
User-Agent: KMail/1.9.10
Cc: Oliver Neukum <oliver@neukum.org>, linux-usb@vger.kernel.org,
       daniel.ritz@gmx.ch, linux-kernel@vger.kernel.org
References: <200911301306.43364.zary@gsystems.sk> <20091202134053.4eb5f8dc.akpm@linux-foundation.org>
In-Reply-To: <20091202134053.4eb5f8dc.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200912031007.32699.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert usbtouchscreen from storing usb_device to usb_interface. This is
needed for multi-interface touchscreen devices such as iNexio.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- linux-2.6.32-rc8-next-20091202-orig/drivers/input/touchscreen/usbtouchscreen.c	2009-12-02 23:52:15.000000000 +0100
+++ linux-2.6.32-rc8-next-20091202/drivers/input/touchscreen/usbtouchscreen.c	2009-12-03 09:19:23.000000000 +0100
@@ -104,7 +104,7 @@ struct usbtouch_usb {
 	unsigned char *buffer;
 	int buf_len;
 	struct urb *irq;
-	struct usb_device *udev;
+	struct usb_interface *interface;
 	struct input_dev *input;
 	struct usbtouch_device_info *type;
 	char name[128];
@@ -234,8 +234,9 @@ static struct usb_device_id usbtouch_dev
 static int e2i_init(struct usbtouch_usb *usbtouch)
 {
 	int ret;
+	struct usb_device *udev = interface_to_usbdev(usbtouch->interface);
 
-	ret = usb_control_msg(usbtouch->udev, usb_rcvctrlpipe(usbtouch->udev, 0),
+	ret = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
 	                      0x01, 0x02, 0x0000, 0x0081,
 	                      NULL, 0, USB_CTRL_SET_TIMEOUT);
 
@@ -344,8 +345,9 @@ static int mtouch_read_data(struct usbto
 static int mtouch_init(struct usbtouch_usb *usbtouch)
 {
 	int ret, i;
+	struct usb_device *udev = interface_to_usbdev(usbtouch->interface);
 
-	ret = usb_control_msg(usbtouch->udev, usb_rcvctrlpipe(usbtouch->udev, 0),
+	ret = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
 	                      MTOUCHUSB_RESET,
 	                      USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 	                      1, 0, NULL, 0, USB_CTRL_SET_TIMEOUT);
@@ -356,7 +358,7 @@ static int mtouch_init(struct usbtouch_u
 	msleep(150);
 
 	for (i = 0; i < 3; i++) {
-		ret = usb_control_msg(usbtouch->udev, usb_rcvctrlpipe(usbtouch->udev, 0),
+		ret = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
 				      MTOUCHUSB_ASYNC_REPORT,
 				      USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 				      1, 1, NULL, 0, USB_CTRL_SET_TIMEOUT);
@@ -489,7 +491,7 @@ static int gunze_read_data(struct usbtou
 
 static int dmc_tsc10_init(struct usbtouch_usb *usbtouch)
 {
-	struct usb_device *dev = usbtouch->udev;
+	struct usb_device *dev = interface_to_usbdev(usbtouch->interface);
 	int ret = -ENOMEM;
 	unsigned char *buf;
 
@@ -1021,7 +1023,7 @@ static int usbtouch_open(struct input_de
 {
 	struct usbtouch_usb *usbtouch = input_get_drvdata(input);
 
-	usbtouch->irq->dev = usbtouch->udev;
+	usbtouch->irq->dev = interface_to_usbdev(usbtouch->interface);
 
 	if (!usbtouch->type->irq_always) {
 		if (usb_submit_urb(usbtouch->irq, GFP_KERNEL))
@@ -1094,7 +1096,7 @@ static int usbtouch_probe(struct usb_int
 		goto out_free_buffers;
 	}
 
-	usbtouch->udev = udev;
+	usbtouch->interface = intf;
 	usbtouch->input = input_dev;
 
 	if (udev->manufacturer)
@@ -1133,12 +1135,12 @@ static int usbtouch_probe(struct usb_int
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
