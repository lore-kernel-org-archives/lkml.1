Return-Path: <linux-kernel-owner+w=401wt.eu-S1757886AbXJCV5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757886AbXJCV5n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 17:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755124AbXJCV5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 17:57:36 -0400
Received: from ms.is.s.u-tokyo.ac.jp ([133.11.8.3]:40002 "EHLO
	ms.is.s.u-tokyo.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754958AbXJCV5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 17:57:35 -0400
X-Greylist: delayed 1980 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Oct 2007 17:57:35 EDT
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
From: Tomoya Adachi <adachi@il.is.s.u-tokyo.ac.jp>
Reply-To: adachi@il.is.s.u-tokyo.ac.jp
Message-Id: <41620071003212350adachi@il.is.s.u-tokyo.ac.jp>
Subject: [PATCH] usbhid: report descriptor fix for MacBook JIS keyboard
Date: Thu, 04 Oct 2007 06:23:50 +0900
MIME-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Mailer: QMAIL 3.0.1.3977 / Windows XP Service Pack 2 / x86
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomoya Adachi <adachi@il.is.s.u-tokyo.ac.jp>

This patch fixes the problem, that Japanese MacBook doesn't recognize some keys
like '\'(yen, or backslash), '|'(pipe), and '_'(underscore).

It is due to that MacBook JIS keyboard (jp106) sends wrong report descriptor.
It saids "logical maximum = 0x65", so Keyboard.0089 is mapped to Key.Unknown,
while it should be accepted as Key.Yen.

Signed-off-by: Tomoya Adachi <adachi@il.is.s.u-tokyo.ac.jp>

---

diff -uprN -X linux-2.6.23-rc9/Documentation/dontdiff linux-2.6.23-rc9/drivers/hid/usbhid/hid-quirks.c linux-2.6.23-rc9-patched/drivers/hid/usbhid/hid-quirks.c
--- linux-2.6.23-rc9/drivers/hid/usbhid/hid-quirks.c	2007-10-04 02:52:01.000000000 +0900
+++ linux-2.6.23-rc9-patched/drivers/hid/usbhid/hid-quirks.c	2007-10-04 06:03:45.000000000 +0900
@@ -619,6 +619,8 @@ static const struct hid_rdesc_blacklist 
 	{ USB_VENDOR_ID_CYPRESS, USB_DEVICE_ID_CYPRESS_BARCODE_1, HID_QUIRK_RDESC_SWAPPED_MIN_MAX },
 	{ USB_VENDOR_ID_CYPRESS, USB_DEVICE_ID_CYPRESS_BARCODE_2, HID_QUIRK_RDESC_SWAPPED_MIN_MAX },
 
+	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_JIS, HID_QUIRK_RDESC_MACBOOK_JIS },
+
 	{ 0, 0 }
 };
 
@@ -927,6 +929,18 @@ static void usbhid_fixup_cypress_descrip
 		printk(KERN_INFO "Fixing up Cypress report descriptor\n");
 }
 
+/*
+ * MacBook JIS keyboard has wrong logical maximum
+ */
+static void usbhid_fixup_macbook_descriptor(unsigned char *rdesc, int rsize)
+{
+	if (rsize >= 60 && rdesc[53] == 0x65
+			&& rdesc[59] == 0x65) {
+		printk(KERN_INFO "Fixing up MacBook JIS keyboard report descriptor\n");
+		rdesc[53] = rdesc[59] = 0xe7;
+	}
+}
+
 
 static void __usbhid_fixup_report_descriptor(__u32 quirks, char *rdesc, unsigned rsize)
 {
@@ -941,6 +955,9 @@ static void __usbhid_fixup_report_descri
 
 	if (quirks & HID_QUIRK_RDESC_PETALYNX)
 		usbhid_fixup_petalynx_descriptor(rdesc, rsize);
+
+	if (quirks & HID_QUIRK_RDESC_MACBOOK_JIS)
+		usbhid_fixup_macbook_descriptor(rdesc, rsize);
 }
 
 /**
diff -uprN -X linux-2.6.23-rc9/Documentation/dontdiff linux-2.6.23-rc9/include/linux/hid.h linux-2.6.23-rc9-patched/include/linux/hid.h
--- linux-2.6.23-rc9/include/linux/hid.h	2007-10-04 02:52:03.000000000 +0900
+++ linux-2.6.23-rc9-patched/include/linux/hid.h	2007-10-04 06:00:57.000000000 +0900
@@ -285,6 +285,7 @@ struct hid_item {
 #define HID_QUIRK_RDESC_LOGITECH		0x00000002
 #define HID_QUIRK_RDESC_SWAPPED_MIN_MAX		0x00000004
 #define HID_QUIRK_RDESC_PETALYNX		0x00000008
+#define HID_QUIRK_RDESC_MACBOOK_JIS		0x00000010
 
 /*
  * This is the global environment of the parser. This information is
