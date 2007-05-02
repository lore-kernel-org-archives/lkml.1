Return-Path: <linux-kernel-owner+w=401wt.eu-S2993312AbXEBPFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993312AbXEBPFl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 11:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993314AbXEBPFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 11:05:41 -0400
Received: from twin.jikos.cz ([213.151.79.26]:37412 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993312AbXEBPFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 11:05:39 -0400
Date: Wed, 2 May 2007 17:04:16 +0200 (CEST)
From: Jan Kratochvil <honza@jikos.cz>
To: Greg Kroah-Hartman <gregkh@suse.de>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: linux-input@atrey.karlin.mff.cuni.cz,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 2/3] xpad.c: Initial support for xbox360 gamepad.
Message-ID: <Pine.LNX.4.64.0705021703090.13550@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Xbox 360 gamepad is slightly different then the previous model so it has
its own version of process_packet method.

Detection of this new device relies on USB_DEVICE_INTERFACE_PROTOCOL macro.
This device got vendor specific subclass so it can't be matched with
USB_INTERFACE_INFO and we need only one interface protocol from four
availaible. It means USB_DEVICE can't be used either.

Added xpad360_btn structure with additional buttons for x360 gamepad.

Signed-off-by: Jan Kratochvil <honza@jikos.cz>
---
 drivers/usb/input/xpad.c |   80 +++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 79 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/input/xpad.c b/drivers/usb/input/xpad.c
index 2a20aa2..bac9ec2 100644
--- a/drivers/usb/input/xpad.c
+++ b/drivers/usb/input/xpad.c
@@ -8,6 +8,7 @@
  *                    Ivan Hawkes <blackhawk@ivanhawkes.com>
  *               2005 Dominic Cerquetti <binary1230@yahoo.com>
  *               2006 Adam Buchbinder <adam.buchbinder@gmail.com>
+ *               2007 Jan Kratochvil <honza@jikos.cz>
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License as
@@ -28,6 +29,7 @@
  *  - information from     http://euc.jp/periphs/xbox-controller.ja.html
  *  - the iForce driver    drivers/char/joystick/iforce.c
  *  - the skeleton-driver  drivers/usb/usb-skeleton.c
+ *  - Xbox 360 information http://www.free60.org/wiki/Gamepad
  *
  * Thanks to:
  *  - ITO Takayuki for providing essential xpad information on his website
@@ -88,6 +90,7 @@
 #define XPAD_FLAGS_DPAD_TO_BUTTONS    (1 << 0)
 #define XPAD_FLAGS_DPAD_TO_AXES       (1 << 1)
 #define XPAD_FLAGS_DPAD_UNKNOWN       (1 << 2)
+#define XPAD_FLAGS_XBOX360            (1 << 3)
 
 static int dpad_to_buttons;
 module_param(dpad_to_buttons, bool, S_IRUGO);
@@ -130,6 +133,7 @@ static const struct xpad_device {
 	{ 0x102c, 0xff0c, "Joytech Wireless Advanced Controller", XPAD_FLAGS_DPAD_TO_AXES },
 	{ 0x12ab, 0x8809, "Xbox DDR dancepad", XPAD_FLAGS_DPAD_TO_BUTTONS },
 	{ 0x1430, 0x8888, "TX6500+ Dance Pad (first generation)", XPAD_FLAGS_DPAD_TO_BUTTONS },
+	{ 0x045e, 0x028e, "Microsoft X-Box 360 pad", XPAD_FLAGS_DPAD_TO_AXES | XPAD_FLAGS_XBOX360 },
 	{ 0xffff, 0xffff, "Chinese-made Xbox Controller", XPAD_FLAGS_DPAD_TO_AXES },
 	{ 0x0000, 0x0000, "Generic X-Box pad", XPAD_FLAGS_DPAD_UNKNOWN }
 };
@@ -140,6 +144,12 @@ static const signed short xpad_btn[] = {
 	-1						/* terminating entry */
 };
 
+static const signed short xpad360_btn[] = {  /* buttons for x360 controller */
+	BTN_TL, BTN_TR, 	/* Button LB/RB */
+	BTN_MODE,		/* The big X button */
+	-1
+};
+
 /* only used if XPAD_FLAGS_DPAD_TO_BUTTONS */
 static const signed short xpad_btn_pad[] = {
 	BTN_LEFT, BTN_RIGHT,		/* d-pad left, right */
@@ -160,8 +170,12 @@ static const signed short xpad_abs_pad[] = {
 	-1			/* terminating entry */
 };
 
+/* Xbox 360 has a vendor-specific (sub)class, so we cannot match it with only 
+ * USB_INTERFACE_INFO, more to that this device has 4 InterfaceProtocols,
+ * but we need only one of them. */ 
 static struct usb_device_id xpad_table [] = {
 	{ USB_INTERFACE_INFO('X', 'B', 0) },	/* X-Box USB-IF not approved class */
+	{ USB_DEVICE_INTERFACE_PROTOCOL(0x045e, 0x028e, 1) },	/* X-Box 360 controller */
 	{ }
 };
 
@@ -236,6 +250,64 @@ static void xpad_process_packet(struct usb_xpad *xpad, u16 cmd, unsigned char *d
 	input_sync(dev);
 }
 
+/*
+ *	xpad360_process_packet
+ *
+ *	Completes a request by converting the data into events for the
+ *	input subsystem. It is version for xbox 360 controller
+ *
+ *	The used report descriptor was taken from:
+ *		http://www.free60.org/wiki/Gamepad
+ */
+
+static void xpad360_process_packet(struct usb_xpad *xpad, u16 cmd, unsigned char *data)
+{
+	struct input_dev *dev = xpad->dev;
+
+	/* digital pad */
+	if (xpad->flags & XPAD_FLAGS_DPAD_TO_AXES) {
+		input_report_abs(dev, ABS_HAT0X, !!(data[2] & 0x01) - !!((data[2] & 0x08) >> 3));
+		input_report_abs(dev, ABS_HAT0Y, !!((data[2] & 0x02) >> 1) - !!((data[2] & 0x04) >> 2));
+	} else if ( xpad->flags & XPAD_FLAGS_DPAD_TO_BUTTONS ) {
+		/* dpad as buttons (right, left, down, up) */
+		input_report_key(dev, BTN_RIGHT, (data[2] & 0x01));
+		input_report_key(dev, BTN_LEFT, (data[2] & 0x08) >> 3);
+		input_report_key(dev, BTN_0, (data[2] & 0x02) >> 1);
+		input_report_key(dev, BTN_1, (data[2] & 0x04) >> 2);
+	}
+
+	/* start/back buttons */
+	input_report_key(dev, BTN_START,  (data[2] & 0x10) >> 4);
+	input_report_key(dev, BTN_BACK,   (data[2] & 0x20) >> 5);
+
+	/* stick press left/right */
+	input_report_key(dev, BTN_THUMBL, data[2] & 0x40);
+	input_report_key(dev, BTN_THUMBR, data[2] & 0x80);
+
+	/* buttons A,B,X,Y,TL,TR and MODE */
+	input_report_key(dev, BTN_A, (data[3] & 0x10) >> 4);
+	input_report_key(dev, BTN_B, (data[3] & 0x20) >> 5);
+	input_report_key(dev, BTN_X, (data[3] & 0x40) >> 6);
+	input_report_key(dev, BTN_Y, (data[3] & 0x80) >> 7);
+	input_report_key(dev, BTN_TL, data[3] & 0x01 );
+	input_report_key(dev, BTN_TR, (data[3] & 0x02) >> 1);
+	input_report_key(dev, BTN_MODE, (data[3] & 0x04) >> 2);
+
+	/* left stick */
+	input_report_abs(dev, ABS_X, (__s16) (((__s16)data[7] << 8) | (__s16)data[6]));
+	input_report_abs(dev, ABS_Y, ~(__s16) (((__s16)data[9] << 8) | (__s16)data[8]));
+
+	/* right stick */
+	input_report_abs(dev, ABS_RY, ~(__s16) (((__s16)data[13] << 8) | (__s16)data[12]));
+	input_report_abs(dev, ABS_RX, (__s16) (((__s16)data[11] << 8) | (__s16)data[10]));
+
+	/* triggers left/right */
+	input_report_abs(dev, ABS_Z, data[4]);
+	input_report_abs(dev, ABS_RZ, data[5]);
+
+	input_sync(dev);
+}
+
 static void xpad_irq_in(struct urb *urb)
 {
 	struct usb_xpad *xpad = urb->context;
@@ -256,7 +328,10 @@ static void xpad_irq_in(struct urb *urb)
 		goto exit;
 	}
 
-	xpad_process_packet(xpad, 0, xpad->idata);
+	if (xpad->flags & XPAD_FLAGS_XBOX360)
+		xpad360_process_packet(xpad, 0, xpad->idata);
+	else
+		xpad_process_packet(xpad, 0, xpad->idata);
 
 exit:
 	retval = usb_submit_urb (urb, GFP_ATOMIC);
@@ -360,6 +435,9 @@ static int xpad_probe(struct usb_interface *intf, const struct usb_device_id *id
 	/* set up buttons */
 	for (i = 0; xpad_btn[i] >= 0; i++)
 		set_bit(xpad_btn[i], input_dev->keybit);
+	if (xpad->flags & XPAD_FLAGS_XBOX360)
+		for (i = 0; xpad360_btn[i] >= 0; i++)
+			set_bit(xpad360_btn[i], input_dev->keybit);
 	if (xpad->flags & XPAD_FLAGS_DPAD_TO_BUTTONS)
 		for (i = 0; xpad_btn_pad[i] >= 0; i++)
 			set_bit(xpad_btn_pad[i], input_dev->keybit);
-- 
1.5.0.6


