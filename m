Return-Path: <linux-kernel-owner+w=401wt.eu-S1753847Ab0AJOd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847Ab0AJOd4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 09:33:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753547Ab0AJOdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 09:33:54 -0500
Received: from mail01a.mail.t-online.hu ([84.2.40.6]:58819 "EHLO
	mail01a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523Ab0AJOdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 09:33:53 -0500
X-Authuid: nmarci
Message-ID: <4B49E549.3000103@freemail.hu>
Date: Sun, 10 Jan 2010 15:33:45 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>
CC: linux-usb@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Julia Lawall <julia@diku.dk>, cocci@diku.dk
Subject: [PATCH 2/9] USB class: make USB device id constant
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail01a.mail.t-online.hu 32721; Body=5 Fuz1=5
	Fuz2=5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

The id_table field of the struct usb_device_id is constant in <linux/usb.h>
so it is worth to make the initialization data also constant.

The semantic match that finds this kind of pattern is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r@
disable decl_init,const_decl_init;
identifier I1, I2, x;
@@
	struct I1 {
	  ...
	  const struct I2 *x;
	  ...
	};
@s@
identifier r.I1, y;
identifier r.x, E;
@@
	struct I1 y = {
	  .x = E,
	};
@c@
identifier r.I2;
identifier s.E;
@@
	const struct I2 E[] = ... ;
@depends on !c@
identifier r.I2;
identifier s.E;
@@
+	const
	struct I2 E[] = ...;
// </smpl>

Signed-off-by: Márton Németh <nm127@freemail.hu>
Cc: Julia Lawall <julia@diku.dk>
Cc: cocci@diku.dk
---
diff -u -p a/drivers/usb/class/usblp.c b/drivers/usb/class/usblp.c
--- a/drivers/usb/class/usblp.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/usb/class/usblp.c 2010-01-08 17:21:36.000000000 +0100
@@ -1404,7 +1404,7 @@ static int usblp_resume (struct usb_inte
 	return r;
 }

-static struct usb_device_id usblp_ids [] = {
+static const struct usb_device_id usblp_ids[] = {
 	{ USB_DEVICE_INFO(7, 1, 1) },
 	{ USB_DEVICE_INFO(7, 1, 2) },
 	{ USB_DEVICE_INFO(7, 1, 3) },
diff -u -p a/drivers/usb/class/cdc-wdm.c b/drivers/usb/class/cdc-wdm.c
--- a/drivers/usb/class/cdc-wdm.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/usb/class/cdc-wdm.c 2010-01-08 17:21:43.000000000 +0100
@@ -31,7 +31,7 @@
 #define DRIVER_AUTHOR "Oliver Neukum"
 #define DRIVER_DESC "USB Abstract Control Model driver for USB WCM Device Management"

-static struct usb_device_id wdm_ids[] = {
+static const struct usb_device_id wdm_ids[] = {
 	{
 		.match_flags = USB_DEVICE_ID_MATCH_INT_CLASS |
 				 USB_DEVICE_ID_MATCH_INT_SUBCLASS,
diff -u -p a/drivers/usb/class/usbtmc.c b/drivers/usb/class/usbtmc.c
--- a/drivers/usb/class/usbtmc.c 2010-01-07 19:08:47.000000000 +0100
+++ b/drivers/usb/class/usbtmc.c 2010-01-08 17:22:01.000000000 +0100
@@ -48,7 +48,7 @@
  */
 #define USBTMC_MAX_READS_TO_CLEAR_BULK_IN	100

-static struct usb_device_id usbtmc_devices[] = {
+static const struct usb_device_id usbtmc_devices[] = {
 	{ USB_INTERFACE_INFO(USB_CLASS_APP_SPEC, 3, 0), },
 	{ USB_INTERFACE_INFO(USB_CLASS_APP_SPEC, 3, 1), },
 	{ 0, } /* terminating entry */
diff -u -p a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
--- a/drivers/usb/class/cdc-acm.c 2010-01-07 19:08:47.000000000 +0100
+++ b/drivers/usb/class/cdc-acm.c 2010-01-08 17:22:15.000000000 +0100
@@ -1471,7 +1471,7 @@ err_out:
  * USB driver structure.
  */

-static struct usb_device_id acm_ids[] = {
+static const struct usb_device_id acm_ids[] = {
 	/* quirky and broken devices */
 	{ USB_DEVICE(0x0870, 0x0001), /* Metricom GS Modem */
 	.driver_info = NO_UNION_NORMAL, /* has no union descriptor */
diff -u -p a/drivers/usb/wusbcore/cbaf.c b/drivers/usb/wusbcore/cbaf.c
--- a/drivers/usb/wusbcore/cbaf.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/usb/wusbcore/cbaf.c 2010-01-08 17:22:34.000000000 +0100
@@ -641,7 +641,7 @@ static void cbaf_disconnect(struct usb_i
 	kzfree(cbaf);
 }

-static struct usb_device_id cbaf_id_table[] = {
+static const struct usb_device_id cbaf_id_table[] = {
 	{ USB_INTERFACE_INFO(0xef, 0x03, 0x01), },
 	{ },
 };
