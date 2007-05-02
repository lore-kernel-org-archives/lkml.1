Return-Path: <linux-kernel-owner+w=401wt.eu-S2993301AbXEBPDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993301AbXEBPDg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 11:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993302AbXEBPDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 11:03:36 -0400
Received: from twin.jikos.cz ([213.151.79.26]:37311 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993301AbXEBPDe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 11:03:34 -0400
Date: Wed, 2 May 2007 17:01:59 +0200 (CEST)
From: Jan Kratochvil <honza@jikos.cz>
To: Greg Kroah-Hartman <gregkh@suse.de>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: linux-input@atrey.karlin.mff.cuni.cz,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 1/3] xpad.c: Added flags into xpad_device structure and
 removed dpad_mapping.
Message-ID: <Pine.LNX.4.64.0705021644580.13550@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This changes are expected to simplify further improves of this driver,
We will need to add information if the driver is xbox360 device or not.

Second option was to simply add u8 is_360, but what if we'll need to know
if device is a wheel? Or if the device can have keyboard (or headset) attached.

Signed-off-by: Jan Kratochvil <honza@jikos.cz>
---
 drivers/usb/input/xpad.c |  102 ++++++++++++++++++++++++---------------------
 1 files changed, 54 insertions(+), 48 deletions(-)

diff --git a/drivers/usb/input/xpad.c b/drivers/usb/input/xpad.c
index e4bc76e..2a20aa2 100644
--- a/drivers/usb/input/xpad.c
+++ b/drivers/usb/input/xpad.c
@@ -85,9 +85,9 @@
 
 /* xbox d-pads should map to buttons, as is required for DDR pads
    but we map them to axes when possible to simplify things */
-#define MAP_DPAD_TO_BUTTONS    0
-#define MAP_DPAD_TO_AXES       1
-#define MAP_DPAD_UNKNOWN       -1
+#define XPAD_FLAGS_DPAD_TO_BUTTONS    (1 << 0)
+#define XPAD_FLAGS_DPAD_TO_AXES       (1 << 1)
+#define XPAD_FLAGS_DPAD_UNKNOWN       (1 << 2)
 
 static int dpad_to_buttons;
 module_param(dpad_to_buttons, bool, S_IRUGO);
@@ -97,41 +97,41 @@ static const struct xpad_device {
 	u16 idVendor;
 	u16 idProduct;
 	char *name;
-	u8 dpad_mapping;
+	u8 flags;
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
+	{ 0x045e, 0x0202, "Microsoft X-Box pad v1 (US)", XPAD_FLAGS_DPAD_TO_AXES },
+	{ 0x045e, 0x0289, "Microsoft X-Box pad v2 (US)", XPAD_FLAGS_DPAD_TO_AXES },
+	{ 0x045e, 0x0285, "Microsoft X-Box pad (Japan)", XPAD_FLAGS_DPAD_TO_AXES },
+	{ 0x045e, 0x0287, "Microsoft Xbox Controller S", XPAD_FLAGS_DPAD_TO_AXES },
+	{ 0x0c12, 0x8809, "RedOctane Xbox Dance Pad", XPAD_FLAGS_DPAD_TO_BUTTONS },
+	{ 0x044f, 0x0f07, "Thrustmaster, Inc. Controller", XPAD_FLAGS_DPAD_TO_AXES },
+	{ 0x046d, 0xca84, "Logitech Xbox Cordless Controller", XPAD_FLAGS_DPAD_TO_AXES },
+	{ 0x046d, 0xca88, "Logitech Compact Controller for Xbox", XPAD_FLAGS_DPAD_TO_AXES },
+	{ 0x05fd, 0x1007, "Mad Catz Controller (unverified)", XPAD_FLAGS_DPAD_TO_AXES },
+	{ 0x05fd, 0x107a, "InterAct 'PowerPad Pro' X-Box pad (Germany)", XPAD_FLAGS_DPAD_TO_AXES },
+	{ 0x0738, 0x4516, "Mad Catz Control Pad", XPAD_FLAGS_DPAD_TO_AXES },
+	{ 0x0738, 0x4522, "Mad Catz LumiCON", XPAD_FLAGS_DPAD_TO_AXES },
+	{ 0x0738, 0x4526, "Mad Catz Control Pad Pro", XPAD_FLAGS_DPAD_TO_AXES },
+	{ 0x0738, 0x4536, "Mad Catz MicroCON", XPAD_FLAGS_DPAD_TO_AXES },
+	{ 0x0738, 0x4540, "Mad Catz Beat Pad", XPAD_FLAGS_DPAD_TO_BUTTONS },
+	{ 0x0738, 0x4556, "Mad Catz Lynx Wireless Controller", XPAD_FLAGS_DPAD_TO_AXES },
+	{ 0x0738, 0x6040, "Mad Catz Beat Pad Pro", XPAD_FLAGS_DPAD_TO_BUTTONS },
+	{ 0x0c12, 0x8802, "Zeroplus Xbox Controller", XPAD_FLAGS_DPAD_TO_AXES },
+	{ 0x0c12, 0x8810, "Zeroplus Xbox Controller", XPAD_FLAGS_DPAD_TO_AXES },
+	{ 0x0c12, 0x9902, "HAMA VibraX - *FAULTY HARDWARE*", XPAD_FLAGS_DPAD_TO_AXES },
+	{ 0x0e4c, 0x1097, "Radica Gamester Controller", XPAD_FLAGS_DPAD_TO_AXES },
+	{ 0x0e4c, 0x2390, "Radica Games Jtech Controller", XPAD_FLAGS_DPAD_TO_AXES},
+	{ 0x0e6f, 0x0003, "Logic3 Freebird wireless Controller", XPAD_FLAGS_DPAD_TO_AXES },
+	{ 0x0e6f, 0x0005, "Eclipse wireless Controller", XPAD_FLAGS_DPAD_TO_AXES },
+	{ 0x0e6f, 0x0006, "Edge wireless Controller", XPAD_FLAGS_DPAD_TO_AXES },
+	{ 0x0e8f, 0x0201, "SmartJoy Frag Xpad/PS2 adaptor", XPAD_FLAGS_DPAD_TO_AXES },
+	{ 0x0f30, 0x0202, "Joytech Advanced Controller", XPAD_FLAGS_DPAD_TO_AXES },
+	{ 0x0f30, 0x8888, "BigBen XBMiniPad Controller", XPAD_FLAGS_DPAD_TO_AXES },
+	{ 0x102c, 0xff0c, "Joytech Wireless Advanced Controller", XPAD_FLAGS_DPAD_TO_AXES },
+	{ 0x12ab, 0x8809, "Xbox DDR dancepad", XPAD_FLAGS_DPAD_TO_BUTTONS },
+	{ 0x1430, 0x8888, "TX6500+ Dance Pad (first generation)", XPAD_FLAGS_DPAD_TO_BUTTONS },
+	{ 0xffff, 0xffff, "Chinese-made Xbox Controller", XPAD_FLAGS_DPAD_TO_AXES },
+	{ 0x0000, 0x0000, "Generic X-Box pad", XPAD_FLAGS_DPAD_UNKNOWN }
 };
 
 static const signed short xpad_btn[] = {
@@ -140,7 +140,7 @@ static const signed short xpad_btn[] = {
 	-1						/* terminating entry */
 };
 
-/* only used if MAP_DPAD_TO_BUTTONS */
+/* only used if XPAD_FLAGS_DPAD_TO_BUTTONS */
 static const signed short xpad_btn_pad[] = {
 	BTN_LEFT, BTN_RIGHT,		/* d-pad left, right */
 	BTN_0, BTN_1,			/* d-pad up, down (XXX names??) */
@@ -154,7 +154,7 @@ static const signed short xpad_abs[] = {
 	-1			/* terminating entry */
 };
 
-/* only used if MAP_DPAD_TO_AXES */
+/* only used if XPAD_FLAGS_DPAD_TO_AXES */
 static const signed short xpad_abs_pad[] = {
 	ABS_HAT0X, ABS_HAT0Y,	/* d-pad axes */
 	-1			/* terminating entry */
@@ -177,7 +177,7 @@ struct usb_xpad {
 
 	char phys[65];			/* physical device path */
 
-	int dpad_mapping;		/* map d-pad to buttons or to axes */
+	u8 flags;			/* combination of XPAD_FLAGS_* */
 };
 
 /*
@@ -207,10 +207,10 @@ static void xpad_process_packet(struct usb_xpad *xpad, u16 cmd, unsigned char *d
 	input_report_abs(dev, ABS_RZ, data[11]);
 
 	/* digital pad */
-	if (xpad->dpad_mapping == MAP_DPAD_TO_AXES) {
+	if (xpad->flags & XPAD_FLAGS_DPAD_TO_AXES) {
 		input_report_abs(dev, ABS_HAT0X, !!(data[2] & 0x08) - !!(data[2] & 0x04));
 		input_report_abs(dev, ABS_HAT0Y, !!(data[2] & 0x02) - !!(data[2] & 0x01));
-	} else /* xpad->dpad_mapping == MAP_DPAD_TO_BUTTONS */ {
+	} else if ( xpad->flags & XPAD_FLAGS_DPAD_TO_BUTTONS ) {
 		input_report_key(dev, BTN_LEFT,  data[2] & 0x04);
 		input_report_key(dev, BTN_RIGHT, data[2] & 0x08);
 		input_report_key(dev, BTN_0,     data[2] & 0x01); // up
@@ -299,7 +299,7 @@ static void xpad_set_up_abs(struct input_dev *input_dev, signed short abs)
 		input_set_abs_params(input_dev, abs, 0, 255, 0, 0);
 		break;
 	case ABS_HAT0X:
-	case ABS_HAT0Y:	/* the d-pad (only if MAP_DPAD_TO_AXES) */
+	case ABS_HAT0Y:	/* the d-pad (only if XPAD_FLAGS_DPAD_TO_AXES) */
 		input_set_abs_params(input_dev, abs, -1, 1, 0, 0);
 		break;
 	}
@@ -334,9 +334,15 @@ static int xpad_probe(struct usb_interface *intf, const struct usb_device_id *id
 		goto fail2;
 
 	xpad->udev = udev;
-	xpad->dpad_mapping = xpad_device[i].dpad_mapping;
-	if (xpad->dpad_mapping == MAP_DPAD_UNKNOWN)
-		xpad->dpad_mapping = dpad_to_buttons;
+	xpad->flags = xpad_device[i].flags;
+	if (xpad->flags & XPAD_FLAGS_DPAD_UNKNOWN) {
+		xpad->flags &= ~XPAD_FLAGS_DPAD_UNKNOWN;
+		if (dpad_to_buttons)
+			xpad->flags |= XPAD_FLAGS_DPAD_TO_AXES;
+		else
+			xpad->flags |= XPAD_FLAGS_DPAD_TO_BUTTONS;
+	}
+
 	xpad->dev = input_dev;
 	usb_make_path(udev, xpad->phys, sizeof(xpad->phys));
 	strlcat(xpad->phys, "/input0", sizeof(xpad->phys));
@@ -354,14 +360,14 @@ static int xpad_probe(struct usb_interface *intf, const struct usb_device_id *id
 	/* set up buttons */
 	for (i = 0; xpad_btn[i] >= 0; i++)
 		set_bit(xpad_btn[i], input_dev->keybit);
-	if (xpad->dpad_mapping == MAP_DPAD_TO_BUTTONS)
+	if (xpad->flags & XPAD_FLAGS_DPAD_TO_BUTTONS)
 		for (i = 0; xpad_btn_pad[i] >= 0; i++)
 			set_bit(xpad_btn_pad[i], input_dev->keybit);
 
 	/* set up axes */
 	for (i = 0; xpad_abs[i] >= 0; i++)
 		xpad_set_up_abs(input_dev, xpad_abs[i]);
-	if (xpad->dpad_mapping == MAP_DPAD_TO_AXES)
+	if (xpad->flags & XPAD_FLAGS_DPAD_TO_AXES)
 		for (i = 0; xpad_abs_pad[i] >= 0; i++)
 		    xpad_set_up_abs(input_dev, xpad_abs_pad[i]);
 
-- 
1.5.0.6


