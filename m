Return-Path: <linux-kernel-owner+w=401wt.eu-S1756429AbYJUV0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756429AbYJUV0Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 17:26:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752461AbYJUV0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 17:26:14 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:41708 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbYJUV0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 17:26:13 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: jkosina@suse.cz
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Steven Noonan" <steven@uplinklabs.net>,
       "Justin Mattock" <justinmattock@gmail.com>,
       "Sven Anders" <anders@anduras.de>,
       Marcel Holtmann <marcel@holtmann.org>, linux-bluetooth@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/4] HID: add hid_type
Date: Tue, 21 Oct 2008 23:26:02 +0200
Message-Id: <1224624363-16471-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add type to the hid structure to distinguish to which device type
(now only mouse) we are talking to. Needed for per device type ignore
list support.

Note: this patch leaves the type as unknown for bluetooth devices,
there is not support for this in the hidp code.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/hid/usbhid/hid-core.c |    3 +++
 include/linux/hid.h           |    6 ++++++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index 1d3b8a3..1dc341a 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -972,6 +972,9 @@ static int hid_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	hid->vendor = le16_to_cpu(dev->descriptor.idVendor);
 	hid->product = le16_to_cpu(dev->descriptor.idProduct);
 	hid->name[0] = 0;
+	if (intf->cur_altsetting->desc.bInterfaceProtocol ==
+			USB_INTERFACE_PROTOCOL_MOUSE)
+		hid->type = HID_TYPE_USBMOUSE;
 
 	if (dev->manufacturer)
 		strlcpy(hid->name, dev->manufacturer, sizeof(hid->name));
diff --git a/include/linux/hid.h b/include/linux/hid.h
index f13bca2..5355ca4 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -417,6 +417,11 @@ struct hid_input {
 	struct input_dev *input;
 };
 
+enum hid_type {
+	HID_TYPE_OTHER = 0,
+	HID_TYPE_USBMOUSE
+};
+
 struct hid_driver;
 struct hid_ll_driver;
 
@@ -431,6 +436,7 @@ struct hid_device {							/* device report descriptor */
 	__u32 vendor;							/* Vendor ID */
 	__u32 product;							/* Product ID */
 	__u32 version;							/* HID version */
+	enum hid_type type;						/* device type (mouse, kbd, ...) */
 	unsigned country;						/* HID country */
 	struct hid_report_enum report_enum[HID_REPORT_TYPES];
 
-- 
1.6.0.2

