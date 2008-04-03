Return-Path: <linux-kernel-owner+w=401wt.eu-S932760AbYDUN1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932760AbYDUN1o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 09:27:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757926AbYDUNT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 09:19:26 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:9129 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760098AbYDUNTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 09:19:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:in-reply-to:references:date:subject:cc:from;
        b=k3+brEbQm6mnrDv5RhJHyXYyzH9+84wDk/4ikWhKzgmKGEqXYBUsXneaEOtjV7m+OK9G0RZ0QaVn3/tQyOuKjAnHepliFyeYbI6DnHQBFm23xQcU96daGu/tD2A1ROP6eJhM/Q34VZrIO/jNMSv1sVQIw9Yjmnob4vFYp85ou6A=
Message-Id: <8a0f83eacc1bb8899094b17483de95ddf2d8fcc6.1208783694.git.dmitry.torokhov@gmail.com>
In-Reply-To: <cover.1208783694.git.dmitry.torokhov@gmail.com>
References: <cover.1208783694.git.dmitry.torokhov@gmail.com>
Date: Thu, 3 Apr 2008 16:17:52 -0400
Subject: [PATCH 11/37] Input: xpad - match xbox 360 devices with interface info
Cc: linux-kernel@vger.kernel.org, jkosina@suse.cz, akpm@linux-foundation.org
From: Anssi Hannula <dmitry.torokhov@gmail.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Match Xbox 360 controllers using the interface info, i.e. interface
class 255 (Vendor specific), subclass 93 and protocol 1, instead of
specifying the device ids individually. As the class is vendor-specific,
we have to still match against vendor id as well, though.

Signed-off-by: Anssi Hannula <anssi.hannula@gmail.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---
 drivers/input/joystick/xpad.c |   21 ++++++++++++++++-----
 1 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index 0380597..8804ad3 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -91,6 +91,7 @@
 
 #define XTYPE_XBOX        0
 #define XTYPE_XBOX360     1
+#define XTYPE_UNKNOWN     2
 
 static int dpad_to_buttons;
 module_param(dpad_to_buttons, bool, S_IRUGO);
@@ -138,7 +139,7 @@ static const struct xpad_device {
 	{ 0x1430, 0x8888, "TX6500+ Dance Pad (first generation)", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX },
 	{ 0x045e, 0x028e, "Microsoft X-Box 360 pad", MAP_DPAD_TO_AXES, XTYPE_XBOX360 },
 	{ 0xffff, 0xffff, "Chinese-made Xbox Controller", MAP_DPAD_TO_AXES, XTYPE_XBOX },
-	{ 0x0000, 0x0000, "Generic X-Box pad", MAP_DPAD_UNKNOWN, XTYPE_XBOX }
+	{ 0x0000, 0x0000, "Generic X-Box pad", MAP_DPAD_UNKNOWN, XTYPE_UNKNOWN }
 };
 
 static const signed short xpad_btn[] = {
@@ -173,12 +174,20 @@ static const signed short xpad_abs_pad[] = {
 	-1			/* terminating entry */
 };
 
-/* Xbox 360 has a vendor-specific (sub)class, so we cannot match it with only
- * USB_INTERFACE_INFO, more to that this device has 4 InterfaceProtocols,
- * but we need only one of them. */
+/* Xbox 360 has a vendor-specific class, so we cannot match it with only
+ * USB_INTERFACE_INFO (also specifically refused by USB subsystem), so we
+ * match against vendor id as well. Also, some Xbox 360 devices have multiple
+ * interface protocols, we only need protocol 1. */
+#define XPAD_XBOX360_VENDOR(vend) \
+	.match_flags = USB_DEVICE_ID_MATCH_VENDOR | USB_DEVICE_ID_MATCH_INT_INFO, \
+	.idVendor = (vend), \
+	.bInterfaceClass = USB_CLASS_VENDOR_SPEC, \
+	.bInterfaceSubClass = 93, \
+	.bInterfaceProtocol = 1
+
 static struct usb_device_id xpad_table [] = {
 	{ USB_INTERFACE_INFO('X', 'B', 0) },	/* X-Box USB-IF not approved class */
-	{ USB_DEVICE_INTERFACE_PROTOCOL(0x045e, 0x028e, 1) },	/* X-Box 360 controller */
+	{ XPAD_XBOX360_VENDOR(0x045e) },	/* Microsoft X-Box 360 controllers */
 	{ }
 };
 
@@ -645,6 +654,8 @@ static int xpad_probe(struct usb_interface *intf, const struct usb_device_id *id
 	xpad->xtype = xpad_device[i].xtype;
 	if (xpad->dpad_mapping == MAP_DPAD_UNKNOWN)
 		xpad->dpad_mapping = dpad_to_buttons;
+	if (xpad->xtype == XTYPE_UNKNOWN)
+		xpad->xtype = (intf->cur_altsetting->desc.bInterfaceClass == USB_CLASS_VENDOR_SPEC);
 	xpad->dev = input_dev;
 	usb_make_path(udev, xpad->phys, sizeof(xpad->phys));
 	strlcat(xpad->phys, "/input0", sizeof(xpad->phys));
-- 
1.5.5.rc2.6.gf58d


