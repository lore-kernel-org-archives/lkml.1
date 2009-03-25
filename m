Return-Path: <linux-kernel-owner+w=401wt.eu-S1759881AbZCYKs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759881AbZCYKs4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 06:48:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758258AbZCYKsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 06:48:18 -0400
Received: from mx1.emlix.com ([193.175.82.87]:54150 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754669AbZCYKsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 06:48:16 -0400
From: Oskar Schirmer <os@emlix.com>
To: Chris Zankel <chris@zankel.net>
Cc: linux-kernel@vger.kernel.org, linux-xtensa@linux-xtensa.org,
       Oskar Schirmer <os@emlix.com>
Subject: [patch 2/4] xtensa: platform declarations for s6000 isef driver
Date: Wed, 25 Mar 2009 11:49:16 +0100
Message-Id: <1237978158-23603-2-git-send-email-os@emlix.com>
In-Reply-To: <1237978158-23603-1-git-send-email-os@emlix.com>
References: <1237978158-23603-1-git-send-email-os@emlix.com>
Organization: emlix gmbh, Goettingen, Germany"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add platform specific irq and dma declarations for use of ISEF on s6000.

Signed-off-by: Oskar Schirmer <os@emlix.com>
---
 arch/xtensa/platforms/s6105/device.c               |   41 ++++++++++++++++++++
 .../platforms/s6105/include/platform/ioctl.h       |   17 ++++++++
 2 files changed, 58 insertions(+), 0 deletions(-)
 create mode 100644 arch/xtensa/platforms/s6105/include/platform/ioctl.h

diff --git a/arch/xtensa/platforms/s6105/device.c b/arch/xtensa/platforms/s6105/device.c
index bc254ac..a55d054 100644
--- a/arch/xtensa/platforms/s6105/device.c
+++ b/arch/xtensa/platforms/s6105/device.c
@@ -31,6 +31,7 @@
 #define UART_INTNUM		4
 #define GMAC_INTNUM		5
 #define I2C_INTNUM		6
+#define ISEF_INTNUM		8
 #define SPI_INTNUM		11
 
 static const signed char gpio3_irq_mappings[] = {
@@ -57,6 +58,11 @@ static const signed char i2c_irq_mappings[] = {
 	-1
 };
 
+static const signed char isef_irq_mappings[] = {
+	S6_INTC_DMA_LMSPENDCNT(11),
+	-1
+};
+
 static const signed char spi_irq_mappings[] = {
 	S6_INTC_SPI,
 	-1
@@ -67,6 +73,7 @@ const signed char *platform_irq_mappings[NR_IRQS] = {
 	[UART_INTNUM] = uart_irq_mappings,
 	[GMAC_INTNUM] = gmac_irq_mappings,
 	[I2C_INTNUM] = i2c_irq_mappings,
+	[ISEF_INTNUM] = isef_irq_mappings,
 	[SPI_INTNUM] = spi_irq_mappings,
 };
 
@@ -187,6 +194,34 @@ static struct i2c_board_info __initdata s6_i2c_devices[] = {
 	},
 };
 
+static struct resource s6_isef_resource[] = {
+	{
+		.name   = "mem",
+		.start  = (resource_size_t)S6_MEM_EFI,
+		.end    = (resource_size_t)S6_MEM_EFI + 0x100000 - 1,
+		.flags  = IORESOURCE_MEM,
+	},
+	{
+		.name   = "mem",
+		.start  = (resource_size_t)S6_REG_XAD,
+		.end    = (resource_size_t)S6_REG_XAD + 0x40000 - 1,
+		.flags  = IORESOURCE_MEM,
+	},
+	{
+		.name   = "dma",
+		.start  = (resource_size_t)
+			DMA_CHNL(S6_REG_LMSDMA, 11),
+		.end    = (resource_size_t)
+			DMA_CHNL(S6_REG_LMSDMA, 11) + 0x100 - 1,
+		.flags  = IORESOURCE_DMA,
+	},
+	{
+		.name   = "irq",
+		.start  = (resource_size_t)ISEF_INTNUM,
+		.flags  = IORESOURCE_IRQ,
+	},
+};
+
 static struct resource s6_spi_resource[] = {
 	{
 		.name   = "mem",
@@ -337,6 +372,12 @@ static struct platform_device platform_devices[] = {
 		},
 	},
 	{
+		.name = "s6isef",
+		.id = 0,
+		.resource = s6_isef_resource,
+		.num_resources = ARRAY_SIZE(s6_isef_resource),
+	},
+	{
 		.name = "spi_s6000",
 		.resource = s6_spi_resource,
 		.num_resources = ARRAY_SIZE(s6_spi_resource),
diff --git a/arch/xtensa/platforms/s6105/include/platform/ioctl.h b/arch/xtensa/platforms/s6105/include/platform/ioctl.h
new file mode 100644
index 0000000..0fc6e2c
--- /dev/null
+++ b/arch/xtensa/platforms/s6105/include/platform/ioctl.h
@@ -0,0 +1,17 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2008 Emlix GmbH http://www.emlix.com
+ */
+
+#ifndef __XTENSA_S6105_IOCTL_H
+#define __XTENSA_S6105_IOCTL_H
+
+#include <linux/ioctl.h>
+
+#define S6IOCTL_ISEF_PRELOAD		_IO(56, 1)
+#define S6IOCTL_ISEF_INVALIDATE		_IO(56, 2)
+
+#endif /* __XTENSA_S6105_IOCTL_H */
-- 
1.6.2.107.ge47ee

