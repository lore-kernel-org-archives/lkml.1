Return-Path: <linux-kernel-owner+w=401wt.eu-S1756485AbYJUV1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756485AbYJUV1B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 17:27:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753222AbYJUV0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 17:26:51 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:41716 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555AbYJUV0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 17:26:49 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: jkosina@suse.cz
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Steven Noonan" <steven@uplinklabs.net>,
       "Justin Mattock" <justinmattock@gmail.com>,
       "Sven Anders" <anders@anduras.de>,
       Marcel Holtmann <marcel@holtmann.org>, linux-bluetooth@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 2/4] HID: fix appletouch regression
Date: Tue, 21 Oct 2008 23:26:03 +0200
Message-Id: <1224624363-16471-2-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1224624363-16471-1-git-send-email-jirislaby@gmail.com>
References: <1224624363-16471-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The appletouch mouse devices are grabbed by the hid bus and not
released even if apple driver says ENODEV (as expected).

Move the ignoration one level upper to deny the hid layer to grab
the device and return error to the usb hid which, as a result,
releases the device.

Otherwise input/mouse/appletouch and others needn't be attached.

Reported-by: Justin Mattock <justinmattock@gmail.com>
Reported-by: Steven Noonan <steven@uplinklabs.net>
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/hid/hid-apple.c |   63 ++++++++++++++++------------------------------
 drivers/hid/hid-core.c  |   38 ++++++++++++++++++++++++++++
 2 files changed, 60 insertions(+), 41 deletions(-)

diff --git a/drivers/hid/hid-apple.c b/drivers/hid/hid-apple.c
index fd7f896..c6ab4ba 100644
--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -312,13 +312,6 @@ static int apple_probe(struct hid_device *hdev,
 	unsigned int connect_mask = HID_CONNECT_DEFAULT;
 	int ret;
 
-	/* return something else or move to hid layer? device will reside
-	   allocated */
-	if (id->bus == BUS_USB && (quirks & APPLE_IGNORE_MOUSE) &&
-			to_usb_interface(hdev->dev.parent)->cur_altsetting->
-			desc.bInterfaceProtocol == USB_INTERFACE_PROTOCOL_MOUSE)
-		return -ENODEV;
-
 	asc = kzalloc(sizeof(*asc), GFP_KERNEL);
 	if (asc == NULL) {
 		dev_err(&hdev->dev, "can't alloc apple descriptor\n");
@@ -367,38 +360,32 @@ static const struct hid_device_id apple_devices[] = {
 		.driver_data = APPLE_MIGHTYMOUSE | APPLE_INVERT_HWHEEL },
 
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_ANSI),
-		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN |
-			APPLE_IGNORE_MOUSE },
+		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_ISO),
-		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN |
-			APPLE_IGNORE_MOUSE },
+		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER_ANSI),
-		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN |
-			APPLE_IGNORE_MOUSE },
+		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER_ISO),
 		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN |
-			APPLE_IGNORE_MOUSE | APPLE_ISO_KEYBOARD },
+			APPLE_ISO_KEYBOARD },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER_JIS),
-		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN |
-			APPLE_IGNORE_MOUSE },
+		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER3_ANSI),
-		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN |
-			APPLE_IGNORE_MOUSE },
+		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER3_ISO),
 		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN |
-			APPLE_IGNORE_MOUSE | APPLE_ISO_KEYBOARD },
+			APPLE_ISO_KEYBOARD },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER3_JIS),
 		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN |
-			APPLE_IGNORE_MOUSE | APPLE_RDESC_JIS },
+			APPLE_RDESC_JIS },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_ANSI),
-		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN |
-			APPLE_IGNORE_MOUSE },
+		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_ISO),
 		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN |
-			APPLE_IGNORE_MOUSE | APPLE_ISO_KEYBOARD },
+			APPLE_ISO_KEYBOARD },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_JIS),
 		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN |
-			APPLE_IGNORE_MOUSE | APPLE_RDESC_JIS},
+			APPLE_RDESC_JIS },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_ANSI),
 		.driver_data = APPLE_HAS_FN },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_ISO),
@@ -406,14 +393,12 @@ static const struct hid_device_id apple_devices[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_JIS),
 		.driver_data = APPLE_HAS_FN },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_HF_ANSI),
-		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN |
-			APPLE_IGNORE_MOUSE },
+		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_HF_ISO),
-		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN |
-			APPLE_IGNORE_MOUSE },
+		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_HF_JIS),
 		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN |
-			APPLE_IGNORE_MOUSE | APPLE_RDESC_JIS },
+			APPLE_RDESC_JIS },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_ANSI),
 		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_ISO),
@@ -422,25 +407,21 @@ static const struct hid_device_id apple_devices[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_JIS),
 		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING_ANSI),
-		.driver_data = APPLE_HAS_FN | APPLE_IGNORE_MOUSE },
+		.driver_data = APPLE_HAS_FN },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING_ISO),
-		.driver_data = APPLE_HAS_FN | APPLE_ISO_KEYBOARD |
-			APPLE_IGNORE_MOUSE },
+		.driver_data = APPLE_HAS_FN | APPLE_ISO_KEYBOARD },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING_JIS),
-		.driver_data = APPLE_HAS_FN | APPLE_IGNORE_MOUSE | APPLE_RDESC_JIS },
+		.driver_data = APPLE_HAS_FN | APPLE_RDESC_JIS },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING2_ANSI),
-		.driver_data = APPLE_HAS_FN | APPLE_IGNORE_MOUSE },
+		.driver_data = APPLE_HAS_FN },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING2_ISO),
-		.driver_data = APPLE_HAS_FN | APPLE_ISO_KEYBOARD |
-			APPLE_IGNORE_MOUSE },
+		.driver_data = APPLE_HAS_FN | APPLE_ISO_KEYBOARD },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING2_JIS),
-		.driver_data = APPLE_HAS_FN | APPLE_IGNORE_MOUSE | APPLE_RDESC_JIS },
+		.driver_data = APPLE_HAS_FN | APPLE_RDESC_JIS },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_TP_ONLY),
-		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN |
-			APPLE_IGNORE_MOUSE },
+		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY),
-		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN |
-			APPLE_IGNORE_MOUSE },
+		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN },
 
 	/* Apple wireless Mighty Mouse */
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, 0x030c),
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 8a7d9db..e5f8427 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1539,6 +1539,40 @@ static const struct hid_device_id hid_ignore_list[] = {
 	{ }
 };
 
+/**
+ * hid_mouse_ignore_list - mouse devices which must not be held by the hid layer
+ *
+ * There are composite devices for which we want to ignore only a certain
+ * interface. This is a list of devices for which only the mouse interface will
+ * be ignored. There is likely an input driver for it, so we must refuse
+ * mastering.
+ */
+static const struct hid_device_id hid_mouse_ignore_list[] = {
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_ANSI) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_ISO) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER_ANSI) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER_ISO) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER_JIS) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER3_ANSI) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER3_ISO) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER3_JIS) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_ANSI) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_ISO) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_JIS) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_HF_ANSI) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_HF_ISO) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_HF_JIS) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING_ANSI) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING_ISO) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING_JIS) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING2_ANSI) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING2_ISO) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING2_JIS) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_TP_ONLY) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY) },
+	{ }
+};
+
 static bool hid_ignore(struct hid_device *hdev)
 {
 	switch (hdev->vendor) {
@@ -1555,6 +1589,10 @@ static bool hid_ignore(struct hid_device *hdev)
 		break;
 	}
 
+	if (hdev->type == HID_TYPE_USBMOUSE &&
+			hid_match_id(hdev, hid_mouse_ignore_list))
+		return true;
+
 	return !!hid_match_id(hdev, hid_ignore_list);
 }
 
-- 
1.6.0.2

