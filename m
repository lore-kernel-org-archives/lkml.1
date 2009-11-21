Return-Path: <linux-kernel-owner+w=401wt.eu-S1755087AbZKUNka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087AbZKUNka (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 08:40:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755079AbZKUNk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 08:40:26 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:24671 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755024AbZKUNkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 08:40:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=iy3+2F2k/94vq1bN76jpaDARwnHClqd46AHiaCPIDclyhnv1uacVUKH6bg6LRxLqJq
         ypmEfIeOkh3pckqnwtW/4H1VZGT8b5pNyZTCOa4/0cgc4AcY+QQWzfdasNPpGvP7WlwG
         iGOF/589O8B4Bz/mBebNzgtxb8qLmhrYeP+OI=
From: Martin Fuzzey <mfuzzey@gmail.com>
Subject: [RFC PATCH 9/9] Serial: sc26xx - introduce a structure for platform
	data.
To: tsbogend@alpha.franken.de, linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Date: Sat, 21 Nov 2009 14:40:27 +0100
Message-ID: <20091121134027.16090.86655.stgit@srv002.fuzzey.net>
In-Reply-To: <20091121133951.16090.74411.stgit@srv002.fuzzey.net>
References: <20091121133951.16090.74411.stgit@srv002.fuzzey.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Encapsulates the existing array of uint for signal mapping
and adds baudrate group selection.

Signed-off-by: Martin Fuzzey <mfuzzey@gmail.com>

---

 arch/mips/sni/a20r.c          |   15 ++++++++----
 drivers/serial/sc26xx.c       |   49 +++++++++++++++++++++++++++++++++++----
 include/linux/serial_sc2xxx.h |   52 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 107 insertions(+), 9 deletions(-)
 create mode 100644 include/linux/serial_sc2xxx.h

diff --git a/arch/mips/sni/a20r.c b/arch/mips/sni/a20r.c
index 7dd76fb..6fac5b2 100644
--- a/arch/mips/sni/a20r.c
+++ b/arch/mips/sni/a20r.c
@@ -12,6 +12,7 @@
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
 #include <linux/serial_8250.h>
+#include <linux/serial_sc2xxx.h>
 
 #include <asm/sni.h>
 #include <asm/time.h>
@@ -117,10 +118,14 @@ static struct resource sc26xx_rsrc[] = {
 	}
 };
 
-static unsigned int sc26xx_data[2] = {
-	/* DTR   |   RTS    |   DSR    |   CTS     |   DCD     |   RI    */
-	(8 << 0) | (4 << 4) | (6 << 8) | (0 << 12) | (6 << 16) | (0 << 20),
-	(3 << 0) | (2 << 4) | (1 << 8) | (2 << 12) | (3 << 16) | (4 << 20)
+static struct plat_serial_sc2xxx sc26xx_data = {
+	.signal_map = {
+		/* DTR   |   RTS    |   DSR    |   CTS     |   DCD     |   RI    */
+		(8 << 0) | (4 << 4) | (6 << 8) | (0 << 12) | (6 << 16) | (0 << 20),
+		(3 << 0) | (2 << 4) | (1 << 8) | (2 << 12) | (3 << 16) | (4 << 20)
+	},
+	.baud_mode = 1,
+	.baud_group = 2,
 };
 
 static struct platform_device sc26xx_pdev = {
@@ -128,7 +133,7 @@ static struct platform_device sc26xx_pdev = {
 	.num_resources  = ARRAY_SIZE(sc26xx_rsrc),
 	.resource       = sc26xx_rsrc,
 	.dev			= {
-		.platform_data	= sc26xx_data,
+		.platform_data	= &sc26xx_data,
 	}
 };
 
diff --git a/drivers/serial/sc26xx.c b/drivers/serial/sc26xx.c
index 6764082..842692f 100644
--- a/drivers/serial/sc26xx.c
+++ b/drivers/serial/sc26xx.c
@@ -22,6 +22,7 @@
 #include <linux/platform_device.h>
 #include <linux/irq.h>
 #include <linux/io.h>
+#include <linux/serial_sc2xxx.h>
 
 #if defined(CONFIG_MAGIC_SYSRQ)
 #define SUPPORT_SYSRQ
@@ -170,6 +171,10 @@ static struct chip_def chip_2892 = {
 	.init_mr1 = (1 << 6),
 };
 
+static const struct chip_def *chips[] = {
+	&chip_26xx,
+	&chip_2892
+};
 
 static struct uart_sc26xx_port *driver_info(struct uart_port *port)
 {
@@ -736,9 +741,17 @@ static void __devinit sc26xx_init_masks(struct uart_sc26xx_port *up,
 
 static int __devinit init_baudgroup(struct uart_sc26xx_port *up)
 {
+	struct plat_serial_sc2xxx *pdata = up->port[0].dev->platform_data;
+
 	u8 baud_mode = up->chip->default_baud_mode;
 	u8 baud_group = up->chip->default_baud_group;
 
+	if (pdata->baud_mode > 0)
+		baud_mode = pdata->baud_mode - 1;
+
+	if (pdata->baud_group > 0)
+		baud_group = pdata->baud_group - 1;
+
 	if (baud_mode > up->chip->max_baud_mode) {
 		printk(KERN_ERR "Baud mode %d not supported for %s\n",
 			baud_mode, up->chip->name);
@@ -762,6 +775,20 @@ static int __devinit init_baudgroup(struct uart_sc26xx_port *up)
 	return 0;
 }
 
+static const struct chip_def * __devinit chip_by_name(const char *name)
+{
+	int i;
+	const struct chip_def *chip;
+
+	for (i = 0; i < ARRAY_SIZE(chips); i++) {
+		chip = chips[i];
+		if (!strcmp(chip->name, name))
+			return chip;
+	}
+
+	return NULL;
+}
+
 static const struct chip_def * __devinit detect_chip_type(
 	struct uart_sc26xx_port *up)
 {
@@ -792,9 +819,14 @@ static int __devinit sc26xx_probe(struct platform_device *dev)
 {
 	struct resource *res, *irq_res;
 	struct uart_sc26xx_port *up;
-	unsigned int *sc26xx_data = dev->dev.platform_data;
+	struct plat_serial_sc2xxx *pdata = dev->dev.platform_data;
 	int err;
 
+	if (!pdata) {
+		dev_err(&dev->dev, "No platform data\n");
+		return -EINVAL;
+	}
+
 	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
 	if (!res)
 		return -ENODEV;
@@ -819,16 +851,25 @@ static int __devinit sc26xx_probe(struct platform_device *dev)
 
 	up->port[0].dev = &dev->dev;
 
-	sc26xx_init_masks(up, 0, sc26xx_data[0]);
+	sc26xx_init_masks(up, 0, pdata->signal_map[0]);
 
 	sc26xx_port = &up->port[0];
 
 	memcpy(&up->port[1], &up->port[0], sizeof(up->port[0]));
 	up->port[1].line = 1;
 
-	sc26xx_init_masks(up, 1, sc26xx_data[1]);
+	sc26xx_init_masks(up, 1, pdata->signal_map[1]);
+
+	if (pdata->chip_name)
+		up->chip = chip_by_name(pdata->chip_name);
+	if (!up->chip) {
+		if (pdata->chip_name)
+			dev_warn(&dev->dev,
+				"Unknown chip %s requested - use autodetect\n",
+				pdata->chip_name);
+		up->chip = detect_chip_type(up);
+	}
 
-	up->chip = detect_chip_type(up);
 	err = init_baudgroup(up);
 	if (err)
 		goto out_free_port;
diff --git a/include/linux/serial_sc2xxx.h b/include/linux/serial_sc2xxx.h
new file mode 100644
index 0000000..d93977f
--- /dev/null
+++ b/include/linux/serial_sc2xxx.h
@@ -0,0 +1,52 @@
+/*
+ *
+ *  Copyright (C) 2009 Martin Fuzzey
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+
+#ifndef _LINUX_SERIAL_SC26XX_H
+#define _LINUX_SERIAL_SC26XX_H 1
+
+
+/**
+ * struct plat_sc2xxx - Philips UART platform data
+ * @signal_map:		Hardware signal mapping (see below)
+ *
+ * @chip_name:		One of "SC26xx", "SC2892" or NULL for autodetect
+ *
+ * @baud_mode:		Baudrate mode + 1 (1,2,3) must be 1 for SC26xx see
+ *			datasheet or baud_rates[] in driver code for available
+ * 			baudrates in each mode
+ *			0 = use driver default
+ *
+ * @baud_group: 	Baudrate group + 1 (1, 2) within mode
+ *			0 = use driver default
+ *
+ * For each port signal_map is a bitfield defined as follows:
+ *	bits 0-3	DTR
+ *	bits 4-7	RTS
+ *	bits 8-11	DSR
+ *	bits 12-15	CTS
+ *	bits 16-19	DCD
+ *	bits 20-23	RI
+ *
+ *	Value of each field is 1 + corresponding IP/OP pin or 0 if not connected
+ *	Eg:
+ *	(3 << 0) | (1 << 4) | (3 << 8) | (1 << 12) | (4 << 16) | (0 << 20),
+ *	=>
+ *		DTR=OP2, RTS=OP0, DSR=IP2, CTS=IP0, DCD=IP3, RI=NC
+ *
+ **/
+struct plat_serial_sc2xxx {
+	unsigned int signal_map[2];
+	const char *chip_name;
+	u8 baud_mode;
+	u8 baud_group;
+};
+
+#endif

