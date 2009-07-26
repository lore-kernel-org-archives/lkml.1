Return-Path: <linux-kernel-owner+w=401wt.eu-S1753408AbZGZMUF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408AbZGZMUF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 08:20:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753386AbZGZMUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 08:20:05 -0400
Received: from mail.atlantis.sk ([80.94.52.35]:48758 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753364AbZGZMUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 08:20:04 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: gregkh@suse.de
Subject: [PATCH] [RFC] ark3116: add IrDA support (for Gembird UIR-22)
Date: Sun, 26 Jul 2009 14:19:47 +0200
User-Agent: KMail/1.9.10
Cc: linux-usb@vger.kernel.org, "linux-kernel" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907261419.50702.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
I got a Gembird UIR-22 USB to IrDA adapter (vendor ID 0x18ec, device ID 0x3118)
that did not work in Linux at all. So I opened it and found ARK3116T chip and
IrDA transceiver inside. Adding the IDs to ark3116 driver was not enough -
irdadump did not show any received data.

The next step was usbsnoop to find what windows driver does with the device.
The result is the patch below. Now the device works after plugging and running
"irattach /dev/ttyUSB0 -s".

But how to make it appear as a real IrDA device by itself? Another problem is
mixing IrDA with USB serial driver. Is a separate driver (something like
ark3116-irda) needed?


Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- linux-2.6.30-orig/drivers/usb/serial/ark3116.c	2009-07-19 19:21:54.000000000 +0200
+++ linux/drivers/usb/serial/ark3116.c	2009-07-26 13:58:04.000000000 +0200
@@ -31,6 +31,7 @@
 
 static struct usb_device_id id_table [] = {
 	{ USB_DEVICE(0x6547, 0x0232) },
+	{ USB_DEVICE(0x18ec, 0x3118) },		/* USB to IrDA adapter */
 	{ },
 };
 MODULE_DEVICE_TABLE(usb, id_table);
@@ -83,7 +84,7 @@
 {
 	char *buf;
 	struct ark3116_private *priv;
-	int i;
+	int i, irda;
 
 	for (i = 0; i < serial->num_ports; ++i) {
 		priv = kzalloc(sizeof(struct ark3116_private), GFP_KERNEL);
@@ -100,11 +101,21 @@
 		goto cleanup;
 	}
 
+	irda = le16_to_cpu(serial->dev->descriptor.idProduct) == 0x3118;
+	if (irda)
+		dbg("IrDA mode");
+
 	/* 3 */
 	ARK3116_SND(serial, 3, 0xFE, 0x40, 0x0008, 0x0002);
 	ARK3116_SND(serial, 4, 0xFE, 0x40, 0x0008, 0x0001);
 	ARK3116_SND(serial, 5, 0xFE, 0x40, 0x0000, 0x0008);
-	ARK3116_SND(serial, 6, 0xFE, 0x40, 0x0000, 0x000B);
+	ARK3116_SND(serial, 6, 0xFE, 0x40, irda ? 0x0001 : 0x0000, 0x000B);
+
+	if (irda) {
+		ARK3116_SND(serial, 1001, 0xFE, 0x40, 0x0000, 0x000C);
+		ARK3116_SND(serial, 1002, 0xFE, 0x40, 0x0041, 0x000D);
+		ARK3116_SND(serial, 1003, 0xFE, 0x40, 0x0001, 0x000A);
+	}
 
 	/* <-- seq7 */
 	ARK3116_RCV(serial,  7, 0xFE, 0xC0, 0x0000, 0x0003, 0x00, buf);
@@ -141,6 +152,8 @@
 	ARK3116_SND(serial, 147, 0xFE, 0x40, 0x0083, 0x0003);
 	ARK3116_SND(serial, 148, 0xFE, 0x40, 0x0038, 0x0000);
 	ARK3116_SND(serial, 149, 0xFE, 0x40, 0x0001, 0x0001);
+	if (irda)
+		ARK3116_SND(serial, 1004, 0xFE, 0x40, 0x0000, 0x0009);
 	ARK3116_SND(serial, 150, 0xFE, 0x40, 0x0003, 0x0003);
 	ARK3116_RCV(serial, 151, 0xFE, 0xC0, 0x0000, 0x0004, 0x03, buf);
 	ARK3116_SND(serial, 152, 0xFE, 0x40, 0x0000, 0x0003);

-- 
Ondrej Zary
