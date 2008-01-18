Return-Path: <linux-kernel-owner+w=401wt.eu-S1762269AbYAROfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762269AbYAROfi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 09:35:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760667AbYAROfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 09:35:22 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:38005 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761728AbYAROfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 09:35:20 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 7/7] Char: mxser, add support for CP-114UL
Date: Fri, 18 Jan 2008 15:31:16 +0100
Message-Id: <1200666676-1234-7-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1200666676-1234-1-git-send-email-jirislaby@gmail.com>
References: <1200666676-1234-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add new card (0x1393:0x1143) support added in 1.11 original driver, also
allow rate change in set_serial_info ioctl (as per 1.11 too).

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/char/mxser.c |   29 +++++++++++++++++++----------
 1 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/char/mxser.c b/drivers/char/mxser.c
index dd1b0ab..68c2e92 100644
--- a/drivers/char/mxser.c
+++ b/drivers/char/mxser.c
@@ -1,8 +1,8 @@
 /*
  *          mxser.c  -- MOXA Smartio/Industio family multiport serial driver.
  *
- *      Copyright (C) 1999-2006  Moxa Technologies (support@moxa.com.tw).
- *	Copyright (C) 2006-2007  Jiri Slaby <jirislaby@gmail.com>
+ *      Copyright (C) 1999-2006  Moxa Technologies (support@moxa.com).
+ *	Copyright (C) 2006-2008  Jiri Slaby <jirislaby@gmail.com>
  *
  *      This code is loosely based on the 1.8 moxa driver which is based on
  *	Linux serial driver, written by Linus Torvalds, Theodore T'so and
@@ -47,7 +47,7 @@
 
 #include "mxser.h"
 
-#define	MXSER_VERSION	"2.0.2"		/* 1.10 */
+#define	MXSER_VERSION	"2.0.3"		/* 1.11 */
 #define	MXSERMAJOR	 174
 #define	MXSERCUMAJOR	 175
 
@@ -73,6 +73,7 @@
 
 #define PCI_DEVICE_ID_CB108	0x1080
 #define PCI_DEVICE_ID_CB114	0x1142
+#define PCI_DEVICE_ID_CP114UL	0x1143
 #define PCI_DEVICE_ID_CB134I	0x1341
 #define PCI_DEVICE_ID_CP138U	0x1380
 #define PCI_DEVICE_ID_POS104UL	0x1044
@@ -140,7 +141,8 @@ static const struct mxser_cardinfo mxser_cards[] = {
 /*25*/	{ "CB-114 series",	4, },
 	{ "CB-134I series",	4, },
 	{ "CP-138U series",	8, },
-	{ "POS-104UL series",	4, }
+	{ "POS-104UL series",	4, },
+	{ "CP-114UL series",	4, }
 };
 
 /* driver_data correspond to the lines in the structure above
@@ -169,6 +171,7 @@ static struct pci_device_id mxser_pcibrds[] = {
 	{ PCI_VDEVICE(MOXA, PCI_DEVICE_ID_CB134I),	.driver_data = 26 },
 	{ PCI_VDEVICE(MOXA, PCI_DEVICE_ID_CP138U),	.driver_data = 27 },
 	{ PCI_VDEVICE(MOXA, PCI_DEVICE_ID_POS104UL),	.driver_data = 28 },
+	{ PCI_VDEVICE(MOXA, PCI_DEVICE_ID_CP114UL),	.driver_data = 29 },
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, mxser_pcibrds);
@@ -1188,20 +1191,19 @@ static int mxser_set_serial_info(struct mxser_port *info,
 		struct serial_struct __user *new_info)
 {
 	struct serial_struct new_serial;
+	speed_t baud;
 	unsigned long sl_flags;
 	unsigned int flags;
 	int retval = 0;
 
 	if (!new_info || !info->ioaddr)
-		return -EFAULT;
+		return -ENODEV;
 	if (copy_from_user(&new_serial, new_info, sizeof(new_serial)))
 		return -EFAULT;
 
-	if ((new_serial.irq != info->board->irq) ||
-			(new_serial.port != info->ioaddr) ||
-			(new_serial.custom_divisor != info->custom_divisor) ||
-			(new_serial.baud_base != info->baud_base))
-		return -EPERM;
+	if (new_serial.irq != info->board->irq ||
+			new_serial.port != info->ioaddr)
+		return -EINVAL;
 
 	flags = info->flags & ASYNC_SPD_MASK;
 
@@ -1224,6 +1226,13 @@ static int mxser_set_serial_info(struct mxser_port *info,
 		info->tty->low_latency =
 				(info->flags & ASYNC_LOW_LATENCY) ? 1 : 0;
 		info->tty->low_latency = 0;
+		if ((info->flags & ASYNC_SPD_MASK) == ASYNC_SPD_CUST &&
+				(new_serial.baud_base != info->baud_base ||
+				new_serial.custom_divisor !=
+				info->custom_divisor)) {
+			baud = new_serial.baud_base / new_serial.custom_divisor;
+			tty_encode_baud_rate(info->tty, baud, baud);
+		}
 	}
 
 	info->type = new_serial.type;
-- 
1.5.3.7

