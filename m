Return-Path: <linux-kernel-owner+w=401wt.eu-S1757132AbXLKUDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757132AbXLKUDS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 15:03:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754079AbXLKUC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 15:02:58 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:36836 "EHLO
	viefep24-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754703AbXLKUC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 15:02:57 -0500
From: Daniel Ritz <daniel.ritz-ml@swissonline.ch>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH] usbtouchscreen: fix buffer overflow, make more egalax work
Date: Tue, 11 Dec 2007 21:05:10 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, daniel.ritz@gmx.ch
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712112105.11184.daniel.ritz-ml@swissonline.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] usbtouchscreen: fix buffer overflow, make more egalax work

fixes a buffer overflow in mutli-packet handling code. the overflow can only
happen with eGalax devices and is even there very unlikely (only non-report
packet are affected any only when truncated after the first byte).

it also changes the mutli-packet handling code not to drop unknown packets,
but rather just drop one byte. this allows synchronizing on report packets
in the data stream. it's required for some egalax devices to work at all.

also removes the pointless 'flags' member of the device struct and sets the
version number to 0.6. and some minor cleanups.

Signed-off-by: Daniel Ritz <daniel.ritz@gmx.ch>

diff --git a/drivers/input/touchscreen/usbtouchscreen.c b/drivers/input/touchscreen/usbtouchscreen.c
index 19055e7..b5a6358 100644
--- a/drivers/input/touchscreen/usbtouchscreen.c
+++ b/drivers/input/touchscreen/usbtouchscreen.c
@@ -11,6 +11,7 @@
  *  - DMC TSC-10/25
  *  - IRTOUCHSYSTEMS/UNITOP
  *  - IdealTEK URTC1000
+ *  - General Touch
  *  - GoTop Super_Q2/GogoPen/PenPower tablets
  *
  * Copyright (C) 2004-2007 by Daniel Ritz <daniel.ritz@gmx.ch>
@@ -50,7 +51,7 @@
 #include <linux/usb/input.h>
 
 
-#define DRIVER_VERSION		"v0.5"
+#define DRIVER_VERSION		"v0.6"
 #define DRIVER_AUTHOR		"Daniel Ritz <daniel.ritz@gmx.ch>"
 #define DRIVER_DESC		"USB Touchscreen Driver"
 
@@ -65,17 +66,21 @@ struct usbtouch_device_info {
 	int min_yc, max_yc;
 	int min_press, max_press;
 	int rept_size;
-	int flags;
 
 	void (*process_pkt) (struct usbtouch_usb *usbtouch, unsigned char *pkt, int len);
+
+	/*
+	 * used to get the packet len. possible return values:
+	 * > 0: packet len
+	 * = 0: skip one byte
+	 * < 0: -return value more bytes needed
+	 */
 	int  (*get_pkt_len) (unsigned char *pkt, int len);
+
 	int  (*read_data)   (struct usbtouch_usb *usbtouch, unsigned char *pkt);
 	int  (*init)        (struct usbtouch_usb *usbtouch);
 };
 
-#define USBTOUCH_FLG_BUFFER	0x01
-
-
 /* a usbtouch device */
 struct usbtouch_usb {
 	unsigned char *data;
@@ -94,15 +99,6 @@ struct usbtouch_usb {
 };
 
 
-#if defined(CONFIG_TOUCHSCREEN_USB_EGALAX) || defined(CONFIG_TOUCHSCREEN_USB_ETURBO) || defined(CONFIG_TOUCHSCREEN_USB_IDEALTEK)
-#define MULTI_PACKET
-#endif
-
-#ifdef MULTI_PACKET
-static void usbtouch_process_multi(struct usbtouch_usb *usbtouch,
-                                   unsigned char *pkt, int len);
-#endif
-
 /* device types */
 enum {
 	DEVTPYE_DUMMY = -1,
@@ -186,6 +182,10 @@ static struct usb_device_id usbtouch_devices[] = {
 
 #ifdef CONFIG_TOUCHSCREEN_USB_EGALAX
 
+#ifndef MULTI_PACKET
+#define MULTI_PACKET
+#endif
+
 #define EGALAX_PKT_TYPE_MASK		0xFE
 #define EGALAX_PKT_TYPE_REPT		0x80
 #define EGALAX_PKT_TYPE_DIAG		0x0A
@@ -323,6 +323,9 @@ static int itm_read_data(struct usbtouch_usb *dev, unsigned char *pkt)
  * eTurboTouch part
  */
 #ifdef CONFIG_TOUCHSCREEN_USB_ETURBO
+#ifndef MULTI_PACKET
+#define MULTI_PACKET
+#endif
 static int eturbo_read_data(struct usbtouch_usb *dev, unsigned char *pkt)
 {
 	unsigned int shift;
@@ -461,6 +464,9 @@ static int irtouch_read_data(struct usbtouch_usb *dev, unsigned char *pkt)
  * IdealTEK URTC1000 Part
  */
 #ifdef CONFIG_TOUCHSCREEN_USB_IDEALTEK
+#ifndef MULTI_PACKET
+#define MULTI_PACKET
+#endif
 static int idealtek_get_pkt_len(unsigned char *buf, int len)
 {
 	if (buf[0] & 0x80)
@@ -525,6 +531,11 @@ static int gotop_read_data(struct usbtouch_usb *dev, unsigned char *pkt)
 /*****************************************************************************
  * the different device descriptors
  */
+#ifdef MULTI_PACKET
+static void usbtouch_process_multi(struct usbtouch_usb *usbtouch,
+                                   unsigned char *pkt, int len);
+#endif
+
 static struct usbtouch_device_info usbtouch_dev_info[] = {
 #ifdef CONFIG_TOUCHSCREEN_USB_EGALAX
 	[DEVTYPE_EGALAX] = {
@@ -533,7 +544,6 @@ static struct usbtouch_device_info usbtouch_dev_info[] = {
 		.min_yc		= 0x0,
 		.max_yc		= 0x07ff,
 		.rept_size	= 16,
-		.flags		= USBTOUCH_FLG_BUFFER,
 		.process_pkt	= usbtouch_process_multi,
 		.get_pkt_len	= egalax_get_pkt_len,
 		.read_data	= egalax_read_data,
@@ -582,7 +592,6 @@ static struct usbtouch_device_info usbtouch_dev_info[] = {
 		.min_yc		= 0x0,
 		.max_yc		= 0x07ff,
 		.rept_size	= 8,
-		.flags		= USBTOUCH_FLG_BUFFER,
 		.process_pkt	= usbtouch_process_multi,
 		.get_pkt_len	= eturbo_get_pkt_len,
 		.read_data	= eturbo_read_data,
@@ -630,7 +639,6 @@ static struct usbtouch_device_info usbtouch_dev_info[] = {
 		.min_yc		= 0x0,
 		.max_yc		= 0x0fff,
 		.rept_size	= 8,
-		.flags		= USBTOUCH_FLG_BUFFER,
 		.process_pkt	= usbtouch_process_multi,
 		.get_pkt_len	= idealtek_get_pkt_len,
 		.read_data	= idealtek_read_data,
@@ -738,11 +746,13 @@ static void usbtouch_process_multi(struct usbtouch_usb *usbtouch,
 	pos = 0;
 	while (pos < buf_len) {
 		/* get packet len */
-		pkt_len = usbtouch->type->get_pkt_len(buffer + pos, len);
+		pkt_len = usbtouch->type->get_pkt_len(buffer + pos, buf_len - pos);
 
-		/* unknown packet: drop everything */
-		if (unlikely(!pkt_len))
-			goto out_flush_buf;
+		/* unknown packet: skip one byte */
+		if (unlikely(!pkt_len)) {
+			pos++;
+			continue;
+		}
 
 		/* full packet: process */
 		if (likely((pkt_len > 0) && (pkt_len <= buf_len - pos))) {
@@ -857,7 +867,7 @@ static int usbtouch_probe(struct usb_interface *intf,
 	if (!usbtouch->data)
 		goto out_free;
 
-	if (type->flags & USBTOUCH_FLG_BUFFER) {
+	if (type->get_pkt_len) {
 		usbtouch->buffer = kmalloc(type->rept_size, GFP_KERNEL);
 		if (!usbtouch->buffer)
 			goto out_free_buffers;
