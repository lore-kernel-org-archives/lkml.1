Return-Path: <linux-kernel-owner+w=401wt.eu-S933053AbYDUN2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933053AbYDUN2v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 09:28:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757650AbYDUNTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 09:19:34 -0400
Received: from rn-out-0910.google.com ([64.233.170.189]:35324 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760199AbYDUNTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 09:19:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:in-reply-to:references:date:subject:cc:from;
        b=x808QqBst1BREP1IFUJiMXdE7qD/YR6MnAUB/pwE/aJomPeJ8OUHAJ0g23bv7Zr0kG3yjx1VtAtDmCrOV8HIbtLpiXuZGOkDuxlom/ZZOVrCrS54qT6kfzAiWHQIQO+YKlHFVAvqLyyPUU/qOcRwM92h6AVV0Ftbc8taIPmmr40=
Message-Id: <99de0912be6f384fc31c8e8e7ba0850d0d670385.1208783694.git.dmitry.torokhov@gmail.com>
In-Reply-To: <cover.1208783694.git.dmitry.torokhov@gmail.com>
References: <cover.1208783694.git.dmitry.torokhov@gmail.com>
Date: Thu, 3 Apr 2008 16:19:23 -0400
Subject: [PATCH 18/37] Input: xpad - add support for wireless xbox360 controllers
Cc: linux-kernel@vger.kernel.org, jkosina@suse.cz, akpm@linux-foundation.org
From: Brian Magnuson <dmitry.torokhov@gmail.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Brian Magnuson <bdmagnuson@gmail.com>
Signed-off-by: Anssi Hannula <anssi.hannula@gmail.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---
 drivers/input/joystick/xpad.c |  164 +++++++++++++++++++++++++++++++++++++----
 1 files changed, 148 insertions(+), 16 deletions(-)

diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index 7188eec..ebf8303 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -92,7 +92,8 @@
 
 #define XTYPE_XBOX        0
 #define XTYPE_XBOX360     1
-#define XTYPE_UNKNOWN     2
+#define XTYPE_XBOX360W    2
+#define XTYPE_UNKNOWN     3
 
 static int dpad_to_buttons;
 module_param(dpad_to_buttons, bool, S_IRUGO);
@@ -109,6 +110,7 @@ static const struct xpad_device {
 	{ 0x045e, 0x0289, "Microsoft X-Box pad v2 (US)", MAP_DPAD_TO_AXES, XTYPE_XBOX },
 	{ 0x045e, 0x0285, "Microsoft X-Box pad (Japan)", MAP_DPAD_TO_AXES, XTYPE_XBOX },
 	{ 0x045e, 0x0287, "Microsoft Xbox Controller S", MAP_DPAD_TO_AXES, XTYPE_XBOX },
+	{ 0x045e, 0x0719, "Xbox 360 Wireless Receiver", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX360W },
 	{ 0x0c12, 0x8809, "RedOctane Xbox Dance Pad", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX },
 	{ 0x044f, 0x0f07, "Thrustmaster, Inc. Controller", MAP_DPAD_TO_AXES, XTYPE_XBOX },
 	{ 0x046d, 0xc242, "Logitech Chillstream Controller", MAP_DPAD_TO_AXES, XTYPE_XBOX360 },
@@ -186,22 +188,25 @@ static const signed short xpad_abs_pad[] = {
 
 /* Xbox 360 has a vendor-specific class, so we cannot match it with only
  * USB_INTERFACE_INFO (also specifically refused by USB subsystem), so we
- * match against vendor id as well. Also, some Xbox 360 devices have multiple
- * interface protocols, we only need protocol 1. */
-#define XPAD_XBOX360_VENDOR(vend) \
+ * match against vendor id as well. Wired Xbox 360 devices have protocol 1,
+ * wireless controllers have protocol 129. */
+#define XPAD_XBOX360_VENDOR_PROTOCOL(vend,pr) \
 	.match_flags = USB_DEVICE_ID_MATCH_VENDOR | USB_DEVICE_ID_MATCH_INT_INFO, \
 	.idVendor = (vend), \
 	.bInterfaceClass = USB_CLASS_VENDOR_SPEC, \
 	.bInterfaceSubClass = 93, \
-	.bInterfaceProtocol = 1
+	.bInterfaceProtocol = (pr)
+#define XPAD_XBOX360_VENDOR(vend) \
+	{ XPAD_XBOX360_VENDOR_PROTOCOL(vend,1) }, \
+	{ XPAD_XBOX360_VENDOR_PROTOCOL(vend,129) }
 
 static struct usb_device_id xpad_table [] = {
 	{ USB_INTERFACE_INFO('X', 'B', 0) },	/* X-Box USB-IF not approved class */
-	{ XPAD_XBOX360_VENDOR(0x045e) },	/* Microsoft X-Box 360 controllers */
-	{ XPAD_XBOX360_VENDOR(0x046d) },	/* Logitech X-Box 360 style controllers */
-	{ XPAD_XBOX360_VENDOR(0x0738) },	/* Mad Catz X-Box 360 controllers */
-	{ XPAD_XBOX360_VENDOR(0x0e6f) },	/* 0x0e6f X-Box 360 controllers */
-	{ XPAD_XBOX360_VENDOR(0x1430) },	/* RedOctane X-Box 360 controllers */
+	XPAD_XBOX360_VENDOR(0x045e),		/* Microsoft X-Box 360 controllers */
+	XPAD_XBOX360_VENDOR(0x046d),		/* Logitech X-Box 360 style controllers */
+	XPAD_XBOX360_VENDOR(0x0738),		/* Mad Catz X-Box 360 controllers */
+	XPAD_XBOX360_VENDOR(0x0e6f),		/* 0x0e6f X-Box 360 controllers */
+	XPAD_XBOX360_VENDOR(0x1430),		/* RedOctane X-Box 360 controllers */
 	{ }
 };
 
@@ -211,10 +216,15 @@ struct usb_xpad {
 	struct input_dev *dev;		/* input device interface */
 	struct usb_device *udev;	/* usb device */
 
+	int pad_present;
+
 	struct urb *irq_in;		/* urb for interrupt in report */
 	unsigned char *idata;		/* input data */
 	dma_addr_t idata_dma;
 
+	struct urb *bulk_out;
+	unsigned char *bdata;
+
 #if defined(CONFIG_JOYSTICK_XPAD_FF) || defined(CONFIG_JOYSTICK_XPAD_LEDS)
 	struct urb *irq_out;		/* urb for interrupt out report */
 	unsigned char *odata;		/* output data */
@@ -359,6 +369,39 @@ static void xpad360_process_packet(struct usb_xpad *xpad,
 	input_sync(dev);
 }
 
+/*
+ * xpad360w_process_packet
+ *
+ * Completes a request by converting the data into events for the
+ * input subsystem. It is version for xbox 360 wireless controller.
+ *
+ * Byte.Bit
+ * 00.1 - Status change: The controller or headset has connected/disconnected
+ *                       Bits 01.7 and 01.6 are valid
+ * 01.7 - Controller present
+ * 01.6 - Headset present
+ * 01.1 - Pad state (Bytes 4+) valid
+ *
+ */
+
+static void xpad360w_process_packet(struct usb_xpad *xpad, u16 cmd, unsigned char *data)
+{
+	/* Presence change */
+	if (data[0] & 0x08) {
+		if (data[1] & 0x80) {
+			xpad->pad_present = 1;
+			usb_submit_urb(xpad->bulk_out, GFP_ATOMIC);
+		} else
+			xpad->pad_present = 0;
+	}
+
+	/* Valid pad data */
+	if (!(data[1] & 0x1))
+		return;
+
+	xpad360_process_packet(xpad, cmd, &data[4]);
+}
+
 static void xpad_irq_in(struct urb *urb)
 {
 	struct usb_xpad *xpad = urb->context;
@@ -381,10 +424,16 @@ static void xpad_irq_in(struct urb *urb)
 		goto exit;
 	}
 
-	if (xpad->xtype == XTYPE_XBOX360)
+	switch (xpad->xtype) {
+	case XTYPE_XBOX360:
 		xpad360_process_packet(xpad, 0, xpad->idata);
-	else
+		break;
+	case XTYPE_XBOX360W:
+		xpad360w_process_packet(xpad, 0, xpad->idata);
+		break;
+	default:
 		xpad_process_packet(xpad, 0, xpad->idata);
+	}
 
 exit:
 	retval = usb_submit_urb (urb, GFP_ATOMIC);
@@ -422,6 +471,23 @@ exit:
 		    __FUNCTION__, retval);
 }
 
+static void xpad_bulk_out(struct urb *urb)
+{
+	switch (urb->status) {
+	case 0:
+		/* success */
+		break;
+	case -ECONNRESET:
+	case -ENOENT:
+	case -ESHUTDOWN:
+		/* this urb is terminated, clean up */
+		dbg("%s - urb shutting down with status: %d", __FUNCTION__, urb->status);
+		break;
+	default:
+		dbg("%s - nonzero urb status received: %d", __FUNCTION__, urb->status);
+	}
+}
+
 static int xpad_init_output(struct usb_interface *intf, struct usb_xpad *xpad)
 {
 	struct usb_endpoint_descriptor *ep_irq_out;
@@ -600,6 +666,10 @@ static int xpad_open(struct input_dev *dev)
 {
 	struct usb_xpad *xpad = input_get_drvdata(dev);
 
+	/* URB was submitted in probe */
+	if(xpad->xtype == XTYPE_XBOX360W)
+		return 0;
+
 	xpad->irq_in->dev = xpad->udev;
 	if (usb_submit_urb(xpad->irq_in, GFP_KERNEL))
 		return -EIO;
@@ -611,7 +681,8 @@ static void xpad_close(struct input_dev *dev)
 {
 	struct usb_xpad *xpad = input_get_drvdata(dev);
 
-	usb_kill_urb(xpad->irq_in);
+	if(xpad->xtype != XTYPE_XBOX360W)
+		usb_kill_urb(xpad->irq_in);
 	xpad_stop_output(xpad);
 }
 
@@ -671,8 +742,15 @@ static int xpad_probe(struct usb_interface *intf, const struct usb_device_id *id
 	xpad->xtype = xpad_device[i].xtype;
 	if (xpad->dpad_mapping == MAP_DPAD_UNKNOWN)
 		xpad->dpad_mapping = !dpad_to_buttons;
-	if (xpad->xtype == XTYPE_UNKNOWN)
-		xpad->xtype = (intf->cur_altsetting->desc.bInterfaceClass == USB_CLASS_VENDOR_SPEC);
+	if (xpad->xtype == XTYPE_UNKNOWN) {
+		if (intf->cur_altsetting->desc.bInterfaceClass == USB_CLASS_VENDOR_SPEC) {
+			if (intf->cur_altsetting->desc.bInterfaceProtocol == 129)
+				xpad->xtype = XTYPE_XBOX360W;
+			else
+				xpad->xtype = XTYPE_XBOX360;
+		} else
+			xpad->xtype = XTYPE_XBOX;
+	}
 	xpad->dev = input_dev;
 	usb_make_path(udev, xpad->phys, sizeof(xpad->phys));
 	strlcat(xpad->phys, "/input0", sizeof(xpad->phys));
@@ -692,7 +770,7 @@ static int xpad_probe(struct usb_interface *intf, const struct usb_device_id *id
 	/* set up buttons */
 	for (i = 0; xpad_common_btn[i] >= 0; i++)
 		set_bit(xpad_common_btn[i], input_dev->keybit);
-	if (xpad->xtype == XTYPE_XBOX360)
+	if ((xpad->xtype == XTYPE_XBOX360) || (xpad->xtype == XTYPE_XBOX360W))
 		for (i = 0; xpad360_btn[i] >= 0; i++)
 			set_bit(xpad360_btn[i], input_dev->keybit);
 	else
@@ -734,8 +812,57 @@ static int xpad_probe(struct usb_interface *intf, const struct usb_device_id *id
 		goto fail4;
 
 	usb_set_intfdata(intf, xpad);
+
+	/*
+	 * Submit the int URB immediatly rather than waiting for open
+	 * because we get status messages from the device whether
+	 * or not any controllers are attached.  In fact, it's
+	 * exactly the message that a controller has arrived that
+	 * we're waiting for.
+	 */
+	if (xpad->xtype == XTYPE_XBOX360W) {
+		xpad->irq_in->dev = xpad->udev;
+		error = usb_submit_urb(xpad->irq_in, GFP_KERNEL);
+		if (error)
+			goto fail4;
+
+		/*
+		 * Setup the message to set the LEDs on the
+		 * controller when it shows up
+		 */
+		xpad->bulk_out = usb_alloc_urb(0, GFP_KERNEL);
+		if(!xpad->bulk_out)
+			goto fail5;
+
+		xpad->bdata = kzalloc(XPAD_PKT_LEN, GFP_KERNEL);
+		if(!xpad->bdata)
+			goto fail6;
+
+		xpad->bdata[2] = 0x08;
+		switch (intf->cur_altsetting->desc.bInterfaceNumber) {
+		case 0:
+			xpad->bdata[3] = 0x42;
+			break;
+		case 2:
+			xpad->bdata[3] = 0x43;
+			break;
+		case 4:
+			xpad->bdata[3] = 0x44;
+			break;
+		case 6:
+			xpad->bdata[3] = 0x45;
+		}
+
+		ep_irq_in = &intf->cur_altsetting->endpoint[1].desc;
+		usb_fill_bulk_urb(xpad->bulk_out, udev,
+				usb_sndbulkpipe(udev, ep_irq_in->bEndpointAddress),
+				xpad->bdata, XPAD_PKT_LEN, xpad_bulk_out, xpad);
+	}
+
 	return 0;
 
+ fail6:	usb_free_urb(xpad->bulk_out);
+ fail5:	usb_kill_urb(xpad->irq_in);
  fail4:	usb_free_urb(xpad->irq_in);
  fail3:	xpad_deinit_output(xpad);
  fail2:	usb_buffer_free(udev, XPAD_PKT_LEN, xpad->idata, xpad->idata_dma);
@@ -754,6 +881,11 @@ static void xpad_disconnect(struct usb_interface *intf)
 		xpad_led_disconnect(xpad);
 		input_unregister_device(xpad->dev);
 		xpad_deinit_output(xpad);
+		if (xpad->xtype == XTYPE_XBOX360W) {
+			usb_kill_urb(xpad->bulk_out);
+			usb_free_urb(xpad->bulk_out);
+			usb_kill_urb(xpad->irq_in);
+		}
 		usb_free_urb(xpad->irq_in);
 		usb_buffer_free(xpad->udev, XPAD_PKT_LEN,
 				xpad->idata, xpad->idata_dma);
-- 
1.5.5.rc2.6.gf58d


