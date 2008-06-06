Return-Path: <linux-kernel-owner+w=401wt.eu-S1765189AbYFFQO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765189AbYFFQO5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 12:14:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763614AbYFFQMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 12:12:42 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:39492 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763239AbYFFQMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 12:12:40 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: linux-mtd@lists.infradead.org, kernel@avr32linux.org
Cc: Andrew Victor <avictor.za@gmail.com>,
       Nicolas Ferre <nicolas.ferre@atmel.com>,
       Patrice VILCHEZ <patrice.vilchez@atmel.com>,
       linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH 8/8] avr32: Add support for ATSTK1006
Date: Fri,  6 Jun 2008 18:04:58 +0200
Message-Id: <1212768298-13614-9-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1212768298-13614-8-git-send-email-haavard.skinnemoen@atmel.com>
References: <1212768298-13614-1-git-send-email-haavard.skinnemoen@atmel.com>
 <1212768298-13614-2-git-send-email-haavard.skinnemoen@atmel.com>
 <1212768298-13614-3-git-send-email-haavard.skinnemoen@atmel.com>
 <1212768298-13614-4-git-send-email-haavard.skinnemoen@atmel.com>
 <1212768298-13614-5-git-send-email-haavard.skinnemoen@atmel.com>
 <1212768298-13614-6-git-send-email-haavard.skinnemoen@atmel.com>
 <1212768298-13614-7-git-send-email-haavard.skinnemoen@atmel.com>
 <1212768298-13614-8-git-send-email-haavard.skinnemoen@atmel.com>
X-OriginalArrivalTime: 06 Jun 2008 16:04:19.0639 (UTC) FILETIME=[FA59C470:01C8C7EE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ATSTK1006 is basically an upgraded version of ATSTK1002 with 128
MB SDRAM and 256 MB NAND flash on board.

Otherwise, the board is very similar to the ATSTK1002, so it uses the
same board support file.

Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
---
 arch/avr32/boards/atstk1000/Kconfig     |    4 ++
 arch/avr32/boards/atstk1000/Makefile    |    1 +
 arch/avr32/boards/atstk1000/atstk1002.c |   78 ++++++++++++++++++++++++++++++-
 3 files changed, 81 insertions(+), 2 deletions(-)

diff --git a/arch/avr32/boards/atstk1000/Kconfig b/arch/avr32/boards/atstk1000/Kconfig
index af90b00..8dc4821 100644
--- a/arch/avr32/boards/atstk1000/Kconfig
+++ b/arch/avr32/boards/atstk1000/Kconfig
@@ -18,6 +18,10 @@ config BOARD_ATSTK1004
 	bool "ATSTK1004"
 	select CPU_AT32AP7002
 
+config BOARD_ATSTK1006
+	bool "ATSTK1006"
+	select CPU_AT32AP7000
+
 endchoice
 
 
diff --git a/arch/avr32/boards/atstk1000/Makefile b/arch/avr32/boards/atstk1000/Makefile
index beead86..edecee0 100644
--- a/arch/avr32/boards/atstk1000/Makefile
+++ b/arch/avr32/boards/atstk1000/Makefile
@@ -2,3 +2,4 @@ obj-y				+= setup.o flash.o
 obj-$(CONFIG_BOARD_ATSTK1002)	+= atstk1002.o
 obj-$(CONFIG_BOARD_ATSTK1003)	+= atstk1003.o
 obj-$(CONFIG_BOARD_ATSTK1004)	+= atstk1004.o
+obj-$(CONFIG_BOARD_ATSTK1006)	+= atstk1002.o
diff --git a/arch/avr32/boards/atstk1000/atstk1002.c b/arch/avr32/boards/atstk1000/atstk1002.c
index 000eb42..5bfaf4d 100644
--- a/arch/avr32/boards/atstk1000/atstk1002.c
+++ b/arch/avr32/boards/atstk1000/atstk1002.c
@@ -1,7 +1,7 @@
 /*
- * ATSTK1002 daughterboard-specific init code
+ * ATSTK1002/ATSTK1006 daughterboard-specific init code
  *
- * Copyright (C) 2005-2006 Atmel Corporation
+ * Copyright (C) 2005-2007 Atmel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -29,6 +29,74 @@
 #include "atstk1000.h"
 
 
+/*
+ * The ATSTK1006 daughterboard is very similar to the ATSTK1002. Both
+ * have the AT32AP7000 chip on board; the difference is that the
+ * STK1006 has 128 MB SDRAM (the STK1002 uses the 8 MB SDRAM chip on
+ * the STK1000 motherboard) and 256 MB NAND flash (the STK1002 has
+ * none.)
+ *
+ * The RAM difference is handled by the boot loader, so the only
+ * difference we end up handling here is the NAND flash.
+ */
+#ifdef CONFIG_BOARD_ATSTK1006
+#include <linux/mtd/partitions.h>
+#include <asm/arch/smc.h>
+
+static struct smc_timing nand_timing __initdata = {
+	.ncs_read_setup		= 0,
+	.nrd_setup		= 10,
+	.ncs_write_setup	= 0,
+	.nwe_setup		= 10,
+
+	.ncs_read_pulse		= 30,
+	.nrd_pulse		= 15,
+	.ncs_write_pulse	= 30,
+	.nwe_pulse		= 15,
+
+	.read_cycle		= 30,
+	.write_cycle		= 30,
+
+	.ncs_read_recover	= 0,
+	.nrd_recover		= 15,
+	.ncs_write_recover	= 0,
+	/* WE# high -> RE# low min 60 ns */
+	.nwe_recover		= 50,
+};
+
+static struct smc_config nand_config __initdata = {
+	.bus_width		= 1,
+	.nrd_controlled		= 1,
+	.nwe_controlled		= 1,
+	.nwait_mode		= 0,
+	.byte_write		= 0,
+	.tdf_cycles		= 2,
+	.tdf_mode		= 0,
+};
+
+static struct mtd_partition nand_partitions[] = {
+	{
+		.name		= "main",
+		.offset		= 0x00000000,
+		.size		= MTDPART_SIZ_FULL,
+	},
+};
+
+static struct mtd_partition *nand_part_info(int size, int *num_partitions)
+{
+	*num_partitions = ARRAY_SIZE(nand_partitions);
+	return nand_partitions;
+}
+
+struct atmel_nand_data atstk1006_nand_data __initdata = {
+	.cle		= 21,
+	.ale		= 22,
+	.rdy_pin	= GPIO_PIN_PB(30),
+	.enable_pin	= GPIO_PIN_PB(29),
+	.partition_info	= nand_part_info,
+};
+#endif
+
 struct eth_addr {
 	u8 addr[6];
 };
@@ -212,6 +280,12 @@ static int __init atstk1002_init(void)
 
 	at32_add_system_devices();
 
+#ifdef CONFIG_BOARD_ATSTK1006
+	smc_set_timing(&nand_config, &nand_timing);
+	smc_set_configuration(3, &nand_config);
+	at32_add_device_nand(0, &atstk1006_nand_data);
+#endif
+
 #ifdef	CONFIG_BOARD_ATSTK100X_SW2_CUSTOM
 	at32_add_device_usart(1);
 #else
-- 
1.5.5.1

