Return-Path: <linux-kernel-owner+w=401wt.eu-S1752784AbXECMwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784AbXECMwo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 08:52:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753981AbXECMwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 08:52:44 -0400
Received: from twin.jikos.cz ([213.151.79.26]:59938 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752784AbXECMwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 08:52:43 -0400
Date: Thu, 3 May 2007 14:52:22 +0200 (CEST)
From: Jan Kratochvil <honza@jikos.cz>
To: Greg Kroah-Hartman <gregkh@suse.de>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: linux-input@atrey.karlin.mff.cuni.cz,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 2/3] xpad.c: Initial support for xbox360 gamepad.
In-Reply-To: <Pine.LNX.4.64.0705021703090.13550@twin.jikos.cz>
Message-ID: <alpine.LRH.0.98.0705031447250.22353@twin.jikos.cz>
References: <Pine.LNX.4.64.0705021703090.13550@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
   now this patch doesn't need flags but rather adds new member xtype.


Xbox 360 gamepad is slightly different then the previous model so it has
its own version of process_packet method.

Detection of this new device relies on USB_DEVICE_INTERFACE_PROTOCOL macro.
This device got vendor specific subclass so it can't be matched with
USB_INTERFACE_INFO and we need only one interface protocol from four
availaible. It means USB_DEVICE can't be used either.

Added xpad360_btn structure with additional buttons for x360 gamepad.
Added xtype into xpad_device structure to distinguish between different
types of xbox devices.

Signed-off-by: Jan Kratochvil <honza@jikos.cz>
---
  drivers/usb/input/xpad.c |  151 +++++++++++++++++++++++++++++++++++----------
  1 files changed, 117 insertions(+), 34 deletions(-)

diff --git a/drivers/usb/input/xpad.c b/drivers/usb/input/xpad.c
index e4bc76e..75d1a62 100644
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
@@ -89,6 +91,9 @@
  #define MAP_DPAD_TO_AXES       1
  #define MAP_DPAD_UNKNOWN       -1

+#define XTYPE_XBOX        0
+#define XTYPE_XBOX360     1
+
  static int dpad_to_buttons;
  module_param(dpad_to_buttons, bool, S_IRUGO);
  MODULE_PARM_DESC(dpad_to_buttons, "Map D-PAD to buttons rather than axes for unknown pads");
@@ -98,40 +103,42 @@ static const struct xpad_device {
  	u16 idProduct;
  	char *name;
  	u8 dpad_mapping;
+	u8 xtype;
  } xpad_device[] = {
-	{ 0x045e, 0x0202, "Microsoft X-Box pad v1 (US)", MAP_DPAD_TO_AXES },
-	{ 0x045e, 0x0289, "Microsoft X-Box pad v2 (US)", MAP_DPAD_TO_AXES },
-	{ 0x045e, 0x0285, "Microsoft X-Box pad (Japan)", MAP_DPAD_TO_AXES },
-	{ 0x045e, 0x0287, "Microsoft Xbox Controller S", MAP_DPAD_TO_AXES },
-	{ 0x0c12, 0x8809, "RedOctane Xbox Dance Pad", MAP_DPAD_TO_BUTTONS },
-	{ 0x044f, 0x0f07, "Thrustmaster, Inc. Controller", MAP_DPAD_TO_AXES },
-	{ 0x046d, 0xca84, "Logitech Xbox Cordless Controller", MAP_DPAD_TO_AXES },
-	{ 0x046d, 0xca88, "Logitech Compact Controller for Xbox", MAP_DPAD_TO_AXES },
-	{ 0x05fd, 0x1007, "Mad Catz Controller (unverified)", MAP_DPAD_TO_AXES },
-	{ 0x05fd, 0x107a, "InterAct 'PowerPad Pro' X-Box pad (Germany)", MAP_DPAD_TO_AXES },
-	{ 0x0738, 0x4516, "Mad Catz Control Pad", MAP_DPAD_TO_AXES },
-	{ 0x0738, 0x4522, "Mad Catz LumiCON", MAP_DPAD_TO_AXES },
-	{ 0x0738, 0x4526, "Mad Catz Control Pad Pro", MAP_DPAD_TO_AXES },
-	{ 0x0738, 0x4536, "Mad Catz MicroCON", MAP_DPAD_TO_AXES },
-	{ 0x0738, 0x4540, "Mad Catz Beat Pad", MAP_DPAD_TO_BUTTONS },
-	{ 0x0738, 0x4556, "Mad Catz Lynx Wireless Controller", MAP_DPAD_TO_AXES },
-	{ 0x0738, 0x6040, "Mad Catz Beat Pad Pro", MAP_DPAD_TO_BUTTONS },
-	{ 0x0c12, 0x8802, "Zeroplus Xbox Controller", MAP_DPAD_TO_AXES },
-	{ 0x0c12, 0x8810, "Zeroplus Xbox Controller", MAP_DPAD_TO_AXES },
-	{ 0x0c12, 0x9902, "HAMA VibraX - *FAULTY HARDWARE*", MAP_DPAD_TO_AXES },
-	{ 0x0e4c, 0x1097, "Radica Gamester Controller", MAP_DPAD_TO_AXES },
-	{ 0x0e4c, 0x2390, "Radica Games Jtech Controller", MAP_DPAD_TO_AXES},
-	{ 0x0e6f, 0x0003, "Logic3 Freebird wireless Controller", MAP_DPAD_TO_AXES },
-	{ 0x0e6f, 0x0005, "Eclipse wireless Controller", MAP_DPAD_TO_AXES },
-	{ 0x0e6f, 0x0006, "Edge wireless Controller", MAP_DPAD_TO_AXES },
-	{ 0x0e8f, 0x0201, "SmartJoy Frag Xpad/PS2 adaptor", MAP_DPAD_TO_AXES },
-	{ 0x0f30, 0x0202, "Joytech Advanced Controller", MAP_DPAD_TO_AXES },
-	{ 0x0f30, 0x8888, "BigBen XBMiniPad Controller", MAP_DPAD_TO_AXES },
-	{ 0x102c, 0xff0c, "Joytech Wireless Advanced Controller", MAP_DPAD_TO_AXES },
-	{ 0x12ab, 0x8809, "Xbox DDR dancepad", MAP_DPAD_TO_BUTTONS },
-	{ 0x1430, 0x8888, "TX6500+ Dance Pad (first generation)", MAP_DPAD_TO_BUTTONS },
-	{ 0xffff, 0xffff, "Chinese-made Xbox Controller", MAP_DPAD_TO_AXES },
-	{ 0x0000, 0x0000, "Generic X-Box pad", MAP_DPAD_UNKNOWN }
+	{ 0x045e, 0x0202, "Microsoft X-Box pad v1 (US)", MAP_DPAD_TO_AXES, XTYPE_XBOX },
+	{ 0x045e, 0x0289, "Microsoft X-Box pad v2 (US)", MAP_DPAD_TO_AXES, XTYPE_XBOX },
+	{ 0x045e, 0x0285, "Microsoft X-Box pad (Japan)", MAP_DPAD_TO_AXES, XTYPE_XBOX },
+	{ 0x045e, 0x0287, "Microsoft Xbox Controller S", MAP_DPAD_TO_AXES, XTYPE_XBOX },
+	{ 0x0c12, 0x8809, "RedOctane Xbox Dance Pad", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX },
+	{ 0x044f, 0x0f07, "Thrustmaster, Inc. Controller", MAP_DPAD_TO_AXES, XTYPE_XBOX },
+	{ 0x046d, 0xca84, "Logitech Xbox Cordless Controller", MAP_DPAD_TO_AXES, XTYPE_XBOX },
+	{ 0x046d, 0xca88, "Logitech Compact Controller for Xbox", MAP_DPAD_TO_AXES, XTYPE_XBOX },
+	{ 0x05fd, 0x1007, "Mad Catz Controller (unverified)", MAP_DPAD_TO_AXES, XTYPE_XBOX },
+	{ 0x05fd, 0x107a, "InterAct 'PowerPad Pro' X-Box pad (Germany)", MAP_DPAD_TO_AXES, XTYPE_XBOX },
+	{ 0x0738, 0x4516, "Mad Catz Control Pad", MAP_DPAD_TO_AXES, XTYPE_XBOX },
+	{ 0x0738, 0x4522, "Mad Catz LumiCON", MAP_DPAD_TO_AXES, XTYPE_XBOX },
+	{ 0x0738, 0x4526, "Mad Catz Control Pad Pro", MAP_DPAD_TO_AXES, XTYPE_XBOX },
+	{ 0x0738, 0x4536, "Mad Catz MicroCON", MAP_DPAD_TO_AXES, XTYPE_XBOX },
+	{ 0x0738, 0x4540, "Mad Catz Beat Pad", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX },
+	{ 0x0738, 0x4556, "Mad Catz Lynx Wireless Controller", MAP_DPAD_TO_AXES, XTYPE_XBOX },
+	{ 0x0738, 0x6040, "Mad Catz Beat Pad Pro", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX },
+	{ 0x0c12, 0x8802, "Zeroplus Xbox Controller", MAP_DPAD_TO_AXES, XTYPE_XBOX },
+	{ 0x0c12, 0x8810, "Zeroplus Xbox Controller", MAP_DPAD_TO_AXES, XTYPE_XBOX },
+	{ 0x0c12, 0x9902, "HAMA VibraX - *FAULTY HARDWARE*", MAP_DPAD_TO_AXES, XTYPE_XBOX },
+	{ 0x0e4c, 0x1097, "Radica Gamester Controller", MAP_DPAD_TO_AXES, XTYPE_XBOX },
+	{ 0x0e4c, 0x2390, "Radica Games Jtech Controller", MAP_DPAD_TO_AXES, XTYPE_XBOX },
+	{ 0x0e6f, 0x0003, "Logic3 Freebird wireless Controller", MAP_DPAD_TO_AXES, XTYPE_XBOX },
+	{ 0x0e6f, 0x0005, "Eclipse wireless Controller", MAP_DPAD_TO_AXES, XTYPE_XBOX },
+	{ 0x0e6f, 0x0006, "Edge wireless Controller", MAP_DPAD_TO_AXES, XTYPE_XBOX },
+	{ 0x0e8f, 0x0201, "SmartJoy Frag Xpad/PS2 adaptor", MAP_DPAD_TO_AXES, XTYPE_XBOX },
+	{ 0x0f30, 0x0202, "Joytech Advanced Controller", MAP_DPAD_TO_AXES, XTYPE_XBOX },
+	{ 0x0f30, 0x8888, "BigBen XBMiniPad Controller", MAP_DPAD_TO_AXES, XTYPE_XBOX },
+	{ 0x102c, 0xff0c, "Joytech Wireless Advanced Controller", MAP_DPAD_TO_AXES, XTYPE_XBOX },
+	{ 0x12ab, 0x8809, "Xbox DDR dancepad", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX },
+	{ 0x1430, 0x8888, "TX6500+ Dance Pad (first generation)", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX },
+ 	{ 0x045e, 0x028e, "Microsoft X-Box 360 pad", MAP_DPAD_TO_AXES, XTYPE_XBOX360 },
+	{ 0xffff, 0xffff, "Chinese-made Xbox Controller", MAP_DPAD_TO_AXES, XTYPE_XBOX },
+	{ 0x0000, 0x0000, "Generic X-Box pad", MAP_DPAD_UNKNOWN, XTYPE_XBOX }
  };

  static const signed short xpad_btn[] = {
@@ -147,6 +154,12 @@ static const signed short xpad_btn_pad[] = {
  	-1				/* terminating entry */
  };

+static const signed short xpad360_btn[] = {  /* buttons for x360 controller */
+	BTN_TL, BTN_TR, 	/* Button LB/RB */
+	BTN_MODE,		/* The big X button */
+	-1
+};
+
  static const signed short xpad_abs[] = {
  	ABS_X, ABS_Y,		/* left stick */
  	ABS_RX, ABS_RY,		/* right stick */
@@ -160,8 +173,12 @@ static const signed short xpad_abs_pad[] = {
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

@@ -178,6 +195,7 @@ struct usb_xpad {
  	char phys[65];			/* physical device path */

  	int dpad_mapping;		/* map d-pad to buttons or to axes */
+	int xtype;			/* type of xbox device */
  };

  /*
@@ -236,6 +254,64 @@ static void xpad_process_packet(struct usb_xpad *xpad, u16 cmd, unsigned char *d
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
+	if (xpad->dpad_mapping == MAP_DPAD_TO_AXES) {
+		input_report_abs(dev, ABS_HAT0X, !!(data[2] & 0x01) - !!((data[2] & 0x08) >> 3));
+		input_report_abs(dev, ABS_HAT0Y, !!((data[2] & 0x02) >> 1) - !!((data[2] & 0x04) >> 2));
+	} else if ( xpad->dpad_mapping == MAP_DPAD_TO_BUTTONS ) {
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
@@ -256,7 +332,10 @@ static void xpad_irq_in(struct urb *urb)
  		goto exit;
  	}

-	xpad_process_packet(xpad, 0, xpad->idata);
+	if (xpad->xtype == XTYPE_XBOX360)
+		xpad360_process_packet(xpad, 0, xpad->idata);
+	else
+		xpad_process_packet(xpad, 0, xpad->idata);

  exit:
  	retval = usb_submit_urb (urb, GFP_ATOMIC);
@@ -335,6 +414,7 @@ static int xpad_probe(struct usb_interface *intf, const struct usb_device_id *id

  	xpad->udev = udev;
  	xpad->dpad_mapping = xpad_device[i].dpad_mapping;
+	xpad->xtype = xpad_device[i].xtype;
  	if (xpad->dpad_mapping == MAP_DPAD_UNKNOWN)
  		xpad->dpad_mapping = dpad_to_buttons;
  	xpad->dev = input_dev;
@@ -354,6 +434,9 @@ static int xpad_probe(struct usb_interface *intf, const struct usb_device_id *id
  	/* set up buttons */
  	for (i = 0; xpad_btn[i] >= 0; i++)
  		set_bit(xpad_btn[i], input_dev->keybit);
+	if (xpad->xtype == XTYPE_XBOX360)
+		for (i = 0; xpad360_btn[i] >= 0; i++)
+			set_bit(xpad360_btn[i], input_dev->keybit);
  	if (xpad->dpad_mapping == MAP_DPAD_TO_BUTTONS)
  		for (i = 0; xpad_btn_pad[i] >= 0; i++)
  			set_bit(xpad_btn_pad[i], input_dev->keybit);
-- 
1.5.0.6



