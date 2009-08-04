Return-Path: <linux-kernel-owner+w=401wt.eu-S932801AbZHDKeF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932801AbZHDKeF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 06:34:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932791AbZHDKeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 06:34:04 -0400
Received: from mail.atlantis.sk ([80.94.52.35]:41303 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932451AbZHDKeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 06:34:03 -0400
To: gregkh@suse.de
Subject: [PATCH v2] [resend] ark3116: add IrDA support (for Gembird UIR-22)
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-usb@vger.kernel.org,
       "linux-kernel" <linux-kernel@vger.kernel.org>
Content-Disposition: inline
From: Ondrej Zary <linux@rainbow-software.org>
Date: Tue, 4 Aug 2009 12:33:55 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908041233.56592.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add IrDA support to ark3116 driver. This makes Gembird UIR-22 USB to
IrDA adapter work (vendor ID 0x18ec, device ID 0x3118). This adapter
contains ARK3116T USB serial chip and an IrDA transceiver, thus
a command like "irattach /dev/ttyUSB0 -s" is needed.

All magic numbers were captured using usbsnoop from windows driver
that came with the device.


Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- linux-2.6.30-orig/drivers/usb/serial/ark3116.c	2009-07-19 19:21:54.000000000 +0200
+++ linux/drivers/usb/serial/ark3116.c	2009-08-01 22:04:48.000000000 +0200
@@ -31,10 +31,20 @@
 
 static struct usb_device_id id_table [] = {
 	{ USB_DEVICE(0x6547, 0x0232) },
+	{ USB_DEVICE(0x18ec, 0x3118) },		/* USB to IrDA adapter */
 	{ },
 };
 MODULE_DEVICE_TABLE(usb, id_table);
 
+static int is_irda(struct usb_serial *serial)
+{
+	struct usb_device *dev = serial->dev;
+	if (le16_to_cpu(dev->descriptor.idVendor) == 0x18ec &&
+			le16_to_cpu(dev->descriptor.idProduct) == 0x3118)
+		return 1;
+	return 0;
+}
+
 struct ark3116_private {
 	spinlock_t lock;
 	u8 termios_initialized;
@@ -100,11 +110,21 @@
 		goto cleanup;
 	}
 
+	if (is_irda(serial))
+		dbg("IrDA mode");
+
 	/* 3 */
 	ARK3116_SND(serial, 3, 0xFE, 0x40, 0x0008, 0x0002);
 	ARK3116_SND(serial, 4, 0xFE, 0x40, 0x0008, 0x0001);
 	ARK3116_SND(serial, 5, 0xFE, 0x40, 0x0000, 0x0008);
-	ARK3116_SND(serial, 6, 0xFE, 0x40, 0x0000, 0x000B);
+	ARK3116_SND(serial, 6, 0xFE, 0x40, is_irda(serial) ? 0x0001 : 0x0000,
+		    0x000B);
+
+	if (is_irda(serial)) {
+		ARK3116_SND(serial, 1001, 0xFE, 0x40, 0x0000, 0x000C);
+		ARK3116_SND(serial, 1002, 0xFE, 0x40, 0x0041, 0x000D);
+		ARK3116_SND(serial, 1003, 0xFE, 0x40, 0x0001, 0x000A);
+	}
 
 	/* <-- seq7 */
 	ARK3116_RCV(serial,  7, 0xFE, 0xC0, 0x0000, 0x0003, 0x00, buf);
@@ -141,6 +161,8 @@
 	ARK3116_SND(serial, 147, 0xFE, 0x40, 0x0083, 0x0003);
 	ARK3116_SND(serial, 148, 0xFE, 0x40, 0x0038, 0x0000);
 	ARK3116_SND(serial, 149, 0xFE, 0x40, 0x0001, 0x0001);
+	if (is_irda(serial))
+		ARK3116_SND(serial, 1004, 0xFE, 0x40, 0x0000, 0x0009);
 	ARK3116_SND(serial, 150, 0xFE, 0x40, 0x0003, 0x0003);
 	ARK3116_RCV(serial, 151, 0xFE, 0xC0, 0x0000, 0x0004, 0x03, buf);
 	ARK3116_SND(serial, 152, 0xFE, 0x40, 0x0000, 0x0003);



-- 
Ondrej Zary
