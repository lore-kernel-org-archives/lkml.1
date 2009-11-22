Return-Path: <linux-kernel-owner+w=401wt.eu-S1752406AbZKVII6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406AbZKVII6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 03:08:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751614AbZKVII6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 03:08:58 -0500
Received: from h3281.serverkompetenz.net ([81.169.158.52]:56692 "EHLO
	h3281.serverkompetenz.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbZKVII5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 03:08:57 -0500
Message-ID: <4B08F18C.3040904@hillier.de>
Date: Sun, 22 Nov 2009 09:08:44 +0100
From: Gernot Hillier <gernot@hillier.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Matthias Urlichs <smurf@smurf.noris.de>,
       Greg Kroah-Hartman <gregkh@suse.de>, Oliver Neukum <oliver@neukum.org>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Add support for Mobilcom Debitel USB UMTS Surf-Stick to option
 driver
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gernot Hillier <gernot@hillier.de>

This patch adds the vendor and device id for the Mobilcom Debitel UMTS surf
stick (a.k.a. 4G Systems XSStick W14, MobiData MBD-200HU, ...).

To see these ids, you need to switch the stick to modem operation first with the
help of usb_modeswitch. This makes it switch from 1c9e:f000 to 1c9e:9603 and
thus be recognized by the option driver.

In addition, this device seems to ignore setting of RTS/DTR by option_send_
setup and doesn't answer the usb_control_msg leading to a 5 s timeout
(USB_CTRL_SET_TIMEOUT) in userspace open() and other operations. As this
confused several impatient userspace applications like Minicom and ModemManager,
I decided to reduce the timeout to more reasonable 1000 ms. I don't think the
usual USB GSM stick needs longer, so this should be safe.

Signed-off-by: Gernot Hillier <gernot@hillier.de>

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 319aaf9..296009f 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -336,6 +336,11 @@ static int  option_resume(struct usb_serial *serial);
 #define AIRPLUS_VENDOR_ID			0x1011
 #define AIRPLUS_PRODUCT_MCD650			0x3198
 
+/* 4G Systems XS W14 a.k.a Mobilcom Debitel Surf-Stick a.k.a. 
+   MobiData MBD-200HU a.k.a. ST Mobile Connect HSUPA USB Modem ... */
+#define FOUR_G_SYSTEMS_VENDOR_ID		0x1c9e
+#define FOUR_G_SYSTEMS_PRODUCT_W14		0x9603
+
 static struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_COLT) },
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_RICOLA) },
@@ -599,6 +604,7 @@ static struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(ALCATEL_VENDOR_ID, ALCATEL_PRODUCT_X060S) },
 	{ USB_DEVICE(AIRPLUS_VENDOR_ID, AIRPLUS_PRODUCT_MCD650) },
 	{ USB_DEVICE(TLAYTECH_VENDOR_ID, TLAYTECH_PRODUCT_TEU800) },
+	{ USB_DEVICE(FOUR_G_SYSTEMS_VENDOR_ID, FOUR_G_SYSTEMS_PRODUCT_W14) },
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);
@@ -1176,9 +1182,11 @@ static int option_send_setup(struct usb_serial_port *port)
 	if (portdata->rts_state)
 		val |= 0x02;
 
+	/* use a short timeout of 1 s here to not block userspace too long when
+           device ignores this message (as 4GS W14 does) */
 	return usb_control_msg(serial->dev,
 		usb_rcvctrlpipe(serial->dev, 0),
-		0x22, 0x21, val, ifNum, NULL, 0, USB_CTRL_SET_TIMEOUT);
+		0x22, 0x21, val, ifNum, NULL, 0, 1000);
 }
 
 static int option_startup(struct usb_serial *serial)
