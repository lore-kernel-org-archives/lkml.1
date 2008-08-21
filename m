Return-Path: <linux-kernel-owner+w=401wt.eu-S1756189AbYHUEuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189AbYHUEuu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 00:50:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752979AbYHUErR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 00:47:17 -0400
Received: from gate.crashing.org ([63.228.1.57]:60669 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752409AbYHUErL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 00:47:11 -0400
From: Kumar Gala <galak@kernel.crashing.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [PATCH 9/9] mtd: remove code associated with !CONFIG_PPC_MERGE
Date: Wed, 20 Aug 2008 23:46:58 -0500
Message-Id: <1219294018-12557-10-git-send-email-galak@kernel.crashing.org>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1219294018-12557-9-git-send-email-galak@kernel.crashing.org>
References: <1219294018-12557-1-git-send-email-galak@kernel.crashing.org>
 <1219294018-12557-2-git-send-email-galak@kernel.crashing.org>
 <1219294018-12557-3-git-send-email-galak@kernel.crashing.org>
 <1219294018-12557-4-git-send-email-galak@kernel.crashing.org>
 <1219294018-12557-5-git-send-email-galak@kernel.crashing.org>
 <1219294018-12557-6-git-send-email-galak@kernel.crashing.org>
 <1219294018-12557-7-git-send-email-galak@kernel.crashing.org>
 <1219294018-12557-8-git-send-email-galak@kernel.crashing.org>
 <1219294018-12557-9-git-send-email-galak@kernel.crashing.org>
CC: dwmw2@infradead.org
CC: linux-mtd@lists.infradead.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that arch/ppc is gone we don't need CONFIG_PPC_MERGE anymore
remove the dead code associated with !CONFIG_PPC_MERGE.

The mtd maps should be using the OF based mechanism.

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
Acked-by: Josh Boyer <jwboyer@linux.vnet.ibm.com>
---
 drivers/mtd/maps/Kconfig  |   24 -------
 drivers/mtd/maps/Makefile |    3 -
 drivers/mtd/maps/ebony.c  |  163 ---------------------------------------------
 drivers/mtd/maps/ocotea.c |  154 ------------------------------------------
 drivers/mtd/maps/walnut.c |  122 ---------------------------------
 5 files changed, 0 insertions(+), 466 deletions(-)
 delete mode 100644 drivers/mtd/maps/ebony.c
 delete mode 100644 drivers/mtd/maps/ocotea.c
 delete mode 100644 drivers/mtd/maps/walnut.c

diff --git a/drivers/mtd/maps/Kconfig b/drivers/mtd/maps/Kconfig
index df8e00b..db667b1 100644
--- a/drivers/mtd/maps/Kconfig
+++ b/drivers/mtd/maps/Kconfig
@@ -332,30 +332,6 @@ config MTD_CFI_FLAGADM
 	  Mapping for the Flaga digital module. If you don't have one, ignore
 	  this setting.
 
-config MTD_WALNUT
-	tristate "Flash device mapped on IBM 405GP Walnut"
-	depends on MTD_JEDECPROBE && WALNUT && !PPC_MERGE
-	help
-	  This enables access routines for the flash chips on the IBM 405GP
-	  Walnut board. If you have one of these boards and would like to
-	  use the flash chips on it, say 'Y'.
-
-config MTD_EBONY
-	tristate "Flash devices mapped on IBM 440GP Ebony"
-	depends on MTD_JEDECPROBE && EBONY && !PPC_MERGE
-	help
-	  This enables access routines for the flash chips on the IBM 440GP
-	  Ebony board. If you have one of these boards and would like to
-	  use the flash chips on it, say 'Y'.
-
-config MTD_OCOTEA
-	tristate "Flash devices mapped on IBM 440GX Ocotea"
-	depends on MTD_CFI && OCOTEA && !PPC_MERGE
-	help
-	  This enables access routines for the flash chips on the IBM 440GX
-	  Ocotea board. If you have one of these boards and would like to
-	  use the flash chips on it, say 'Y'.
-
 config MTD_REDWOOD
 	tristate "CFI Flash devices mapped on IBM Redwood"
 	depends on MTD_CFI && ( REDWOOD_4 || REDWOOD_5 || REDWOOD_6 )
diff --git a/drivers/mtd/maps/Makefile b/drivers/mtd/maps/Makefile
index 6cda6df..b258250 100644
--- a/drivers/mtd/maps/Makefile
+++ b/drivers/mtd/maps/Makefile
@@ -50,9 +50,6 @@ obj-$(CONFIG_MTD_REDWOOD)	+= redwood.o
 obj-$(CONFIG_MTD_UCLINUX)	+= uclinux.o
 obj-$(CONFIG_MTD_NETtel)	+= nettel.o
 obj-$(CONFIG_MTD_SCB2_FLASH)	+= scb2_flash.o
-obj-$(CONFIG_MTD_EBONY)		+= ebony.o
-obj-$(CONFIG_MTD_OCOTEA)	+= ocotea.o
-obj-$(CONFIG_MTD_WALNUT)        += walnut.o
 obj-$(CONFIG_MTD_H720X)		+= h720x-flash.o
 obj-$(CONFIG_MTD_SBC8240)	+= sbc8240.o
 obj-$(CONFIG_MTD_NOR_TOTO)	+= omap-toto-flash.o
diff --git a/drivers/mtd/maps/ebony.c b/drivers/mtd/maps/ebony.c
deleted file mode 100644
index d92b7c7..0000000
--- a/drivers/mtd/maps/ebony.c
+++ /dev/null
@@ -1,163 +0,0 @@
-/*
- * Mapping for Ebony user flash
- *
- * Matt Porter <mporter@kernel.crashing.org>
- *
- * Copyright 2002-2004 MontaVista Software Inc.
- *
- * This program is free software; you can redistribute  it and/or modify it
- * under  the terms of  the GNU General  Public License as published by the
- * Free Software Foundation;  either version 2 of the  License, or (at your
- * option) any later version.
- */
-
-#include <linux/module.h>
-#include <linux/types.h>
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/mtd/mtd.h>
-#include <linux/mtd/map.h>
-#include <linux/mtd/partitions.h>
-#include <asm/io.h>
-#include <asm/ibm44x.h>
-#include <platforms/4xx/ebony.h>
-
-static struct mtd_info *flash;
-
-static struct map_info ebony_small_map = {
-	.name =		"Ebony small flash",
-	.size =		EBONY_SMALL_FLASH_SIZE,
-	.bankwidth =	1,
-};
-
-static struct map_info ebony_large_map = {
-	.name =		"Ebony large flash",
-	.size =		EBONY_LARGE_FLASH_SIZE,
-	.bankwidth =	1,
-};
-
-static struct mtd_partition ebony_small_partitions[] = {
-	{
-		.name =   "OpenBIOS",
-		.offset = 0x0,
-		.size =   0x80000,
-	}
-};
-
-static struct mtd_partition ebony_large_partitions[] = {
-	{
-		.name =   "fs",
-		.offset = 0,
-		.size =   0x380000,
-	},
-	{
-		.name =   "firmware",
-		.offset = 0x380000,
-		.size =   0x80000,
-	}
-};
-
-int __init init_ebony(void)
-{
-	u8 fpga0_reg;
-	u8 __iomem *fpga0_adr;
-	unsigned long long small_flash_base, large_flash_base;
-
-	fpga0_adr = ioremap64(EBONY_FPGA_ADDR, 16);
-	if (!fpga0_adr)
-		return -ENOMEM;
-
-	fpga0_reg = readb(fpga0_adr);
-	iounmap(fpga0_adr);
-
-	if (EBONY_BOOT_SMALL_FLASH(fpga0_reg) &&
-			!EBONY_FLASH_SEL(fpga0_reg))
-		small_flash_base = EBONY_SMALL_FLASH_HIGH2;
-	else if (EBONY_BOOT_SMALL_FLASH(fpga0_reg) &&
-			EBONY_FLASH_SEL(fpga0_reg))
-		small_flash_base = EBONY_SMALL_FLASH_HIGH1;
-	else if (!EBONY_BOOT_SMALL_FLASH(fpga0_reg) &&
-			!EBONY_FLASH_SEL(fpga0_reg))
-		small_flash_base = EBONY_SMALL_FLASH_LOW2;
-	else
-		small_flash_base = EBONY_SMALL_FLASH_LOW1;
-
-	if (EBONY_BOOT_SMALL_FLASH(fpga0_reg) &&
-			!EBONY_ONBRD_FLASH_EN(fpga0_reg))
-		large_flash_base = EBONY_LARGE_FLASH_LOW;
-	else
-		large_flash_base = EBONY_LARGE_FLASH_HIGH;
-
-	ebony_small_map.phys = small_flash_base;
-	ebony_small_map.virt = ioremap64(small_flash_base,
-					 ebony_small_map.size);
-
-	if (!ebony_small_map.virt) {
-		printk("Failed to ioremap flash\n");
-		return -EIO;
-	}
-
-	simple_map_init(&ebony_small_map);
-
-	flash = do_map_probe("jedec_probe", &ebony_small_map);
-	if (flash) {
-		flash->owner = THIS_MODULE;
-		add_mtd_partitions(flash, ebony_small_partitions,
-					ARRAY_SIZE(ebony_small_partitions));
-	} else {
-		printk("map probe failed for flash\n");
-		iounmap(ebony_small_map.virt);
-		return -ENXIO;
-	}
-
-	ebony_large_map.phys = large_flash_base;
-	ebony_large_map.virt = ioremap64(large_flash_base,
-					 ebony_large_map.size);
-
-	if (!ebony_large_map.virt) {
-		printk("Failed to ioremap flash\n");
-		iounmap(ebony_small_map.virt);
-		return -EIO;
-	}
-
-	simple_map_init(&ebony_large_map);
-
-	flash = do_map_probe("jedec_probe", &ebony_large_map);
-	if (flash) {
-		flash->owner = THIS_MODULE;
-		add_mtd_partitions(flash, ebony_large_partitions,
-					ARRAY_SIZE(ebony_large_partitions));
-	} else {
-		printk("map probe failed for flash\n");
-		iounmap(ebony_small_map.virt);
-		iounmap(ebony_large_map.virt);
-		return -ENXIO;
-	}
-
-	return 0;
-}
-
-static void __exit cleanup_ebony(void)
-{
-	if (flash) {
-		del_mtd_partitions(flash);
-		map_destroy(flash);
-	}
-
-	if (ebony_small_map.virt) {
-		iounmap(ebony_small_map.virt);
-		ebony_small_map.virt = NULL;
-	}
-
-	if (ebony_large_map.virt) {
-		iounmap(ebony_large_map.virt);
-		ebony_large_map.virt = NULL;
-	}
-}
-
-module_init(init_ebony);
-module_exit(cleanup_ebony);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Matt Porter <mporter@kernel.crashing.org>");
-MODULE_DESCRIPTION("MTD map and partitions for IBM 440GP Ebony boards");
diff --git a/drivers/mtd/maps/ocotea.c b/drivers/mtd/maps/ocotea.c
deleted file mode 100644
index 5522eac..0000000
--- a/drivers/mtd/maps/ocotea.c
+++ /dev/null
@@ -1,154 +0,0 @@
-/*
- * Mapping for Ocotea user flash
- *
- * Matt Porter <mporter@kernel.crashing.org>
- *
- * Copyright 2002-2004 MontaVista Software Inc.
- *
- * This program is free software; you can redistribute  it and/or modify it
- * under  the terms of  the GNU General  Public License as published by the
- * Free Software Foundation;  either version 2 of the  License, or (at your
- * option) any later version.
- */
-
-#include <linux/module.h>
-#include <linux/types.h>
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/mtd/mtd.h>
-#include <linux/mtd/map.h>
-#include <linux/mtd/partitions.h>
-#include <asm/io.h>
-#include <asm/ibm44x.h>
-#include <platforms/4xx/ocotea.h>
-
-static struct mtd_info *flash;
-
-static struct map_info ocotea_small_map = {
-	.name =		"Ocotea small flash",
-	.size =		OCOTEA_SMALL_FLASH_SIZE,
-	.buswidth =	1,
-};
-
-static struct map_info ocotea_large_map = {
-	.name =		"Ocotea large flash",
-	.size =		OCOTEA_LARGE_FLASH_SIZE,
-	.buswidth =	1,
-};
-
-static struct mtd_partition ocotea_small_partitions[] = {
-	{
-		.name =   "pibs",
-		.offset = 0x0,
-		.size =   0x100000,
-	}
-};
-
-static struct mtd_partition ocotea_large_partitions[] = {
-	{
-		.name =   "fs",
-		.offset = 0,
-		.size =   0x300000,
-	},
-	{
-		.name =   "firmware",
-		.offset = 0x300000,
-		.size =   0x100000,
-	}
-};
-
-int __init init_ocotea(void)
-{
-	u8 fpga0_reg;
-	u8 *fpga0_adr;
-	unsigned long long small_flash_base, large_flash_base;
-
-	fpga0_adr = ioremap64(OCOTEA_FPGA_ADDR, 16);
-	if (!fpga0_adr)
-		return -ENOMEM;
-
-	fpga0_reg = readb((unsigned long)fpga0_adr);
-	iounmap(fpga0_adr);
-
-	if (OCOTEA_BOOT_LARGE_FLASH(fpga0_reg)) {
-		small_flash_base = OCOTEA_SMALL_FLASH_HIGH;
-		large_flash_base = OCOTEA_LARGE_FLASH_LOW;
-	}
-	else {
-		small_flash_base = OCOTEA_SMALL_FLASH_LOW;
-		large_flash_base = OCOTEA_LARGE_FLASH_HIGH;
-	}
-
-	ocotea_small_map.phys = small_flash_base;
-	ocotea_small_map.virt = ioremap64(small_flash_base,
-					 ocotea_small_map.size);
-
-	if (!ocotea_small_map.virt) {
-		printk("Failed to ioremap flash\n");
-		return -EIO;
-	}
-
-	simple_map_init(&ocotea_small_map);
-
-	flash = do_map_probe("map_rom", &ocotea_small_map);
-	if (flash) {
-		flash->owner = THIS_MODULE;
-		add_mtd_partitions(flash, ocotea_small_partitions,
-					ARRAY_SIZE(ocotea_small_partitions));
-	} else {
-		printk("map probe failed for flash\n");
-		iounmap(ocotea_small_map.virt);
-		return -ENXIO;
-	}
-
-	ocotea_large_map.phys = large_flash_base;
-	ocotea_large_map.virt = ioremap64(large_flash_base,
-					 ocotea_large_map.size);
-
-	if (!ocotea_large_map.virt) {
-		printk("Failed to ioremap flash\n");
-		iounmap(ocotea_small_map.virt);
-		return -EIO;
-	}
-
-	simple_map_init(&ocotea_large_map);
-
-	flash = do_map_probe("cfi_probe", &ocotea_large_map);
-	if (flash) {
-		flash->owner = THIS_MODULE;
-		add_mtd_partitions(flash, ocotea_large_partitions,
-					ARRAY_SIZE(ocotea_large_partitions));
-	} else {
-		printk("map probe failed for flash\n");
-		iounmap(ocotea_small_map.virt);
-		iounmap(ocotea_large_map.virt);
-		return -ENXIO;
-	}
-
-	return 0;
-}
-
-static void __exit cleanup_ocotea(void)
-{
-	if (flash) {
-		del_mtd_partitions(flash);
-		map_destroy(flash);
-	}
-
-	if (ocotea_small_map.virt) {
-		iounmap((void *)ocotea_small_map.virt);
-		ocotea_small_map.virt = 0;
-	}
-
-	if (ocotea_large_map.virt) {
-		iounmap((void *)ocotea_large_map.virt);
-		ocotea_large_map.virt = 0;
-	}
-}
-
-module_init(init_ocotea);
-module_exit(cleanup_ocotea);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Matt Porter <mporter@kernel.crashing.org>");
-MODULE_DESCRIPTION("MTD map and partitions for IBM 440GX Ocotea boards");
diff --git a/drivers/mtd/maps/walnut.c b/drivers/mtd/maps/walnut.c
deleted file mode 100644
index e243476..0000000
--- a/drivers/mtd/maps/walnut.c
+++ /dev/null
@@ -1,122 +0,0 @@
-/*
- * Mapping for Walnut flash
- * (used ebony.c as a "framework")
- *
- * Heikki Lindholm <holindho@infradead.org>
- *
- *
- * This program is free software; you can redistribute  it and/or modify it
- * under  the terms of  the GNU General  Public License as published by the
- * Free Software Foundation;  either version 2 of the  License, or (at your
- * option) any later version.
- */
-
-#include <linux/module.h>
-#include <linux/types.h>
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/mtd/mtd.h>
-#include <linux/mtd/map.h>
-#include <linux/mtd/partitions.h>
-#include <asm/io.h>
-#include <asm/ibm4xx.h>
-#include <platforms/4xx/walnut.h>
-
-/* these should be in platforms/4xx/walnut.h ? */
-#define WALNUT_FLASH_ONBD_N(x)		(x & 0x02)
-#define WALNUT_FLASH_SRAM_SEL(x)	(x & 0x01)
-#define WALNUT_FLASH_LOW		0xFFF00000
-#define WALNUT_FLASH_HIGH		0xFFF80000
-#define WALNUT_FLASH_SIZE		0x80000
-
-static struct mtd_info *flash;
-
-static struct map_info walnut_map = {
-	.name =		"Walnut flash",
-	.size =		WALNUT_FLASH_SIZE,
-	.bankwidth =	1,
-};
-
-/* Actually, OpenBIOS is the last 128 KiB of the flash - better
- * partitioning could be made */
-static struct mtd_partition walnut_partitions[] = {
-	{
-		.name =   "OpenBIOS",
-		.offset = 0x0,
-		.size =   WALNUT_FLASH_SIZE,
-		/*.mask_flags = MTD_WRITEABLE, */ /* force read-only */
-	}
-};
-
-int __init init_walnut(void)
-{
-	u8 fpga_brds1;
-	void *fpga_brds1_adr;
-	void *fpga_status_adr;
-	unsigned long flash_base;
-
-	/* this should already be mapped (platform/4xx/walnut.c) */
-	fpga_status_adr = ioremap(WALNUT_FPGA_BASE, 8);
-	if (!fpga_status_adr)
-		return -ENOMEM;
-
-	fpga_brds1_adr = fpga_status_adr+5;
-	fpga_brds1 = readb(fpga_brds1_adr);
-	/* iounmap(fpga_status_adr); */
-
-	if (WALNUT_FLASH_ONBD_N(fpga_brds1)) {
-		printk("The on-board flash is disabled (U79 sw 5)!");
-		iounmap(fpga_status_adr);
-		return -EIO;
-	}
-	if (WALNUT_FLASH_SRAM_SEL(fpga_brds1))
-		flash_base = WALNUT_FLASH_LOW;
-	else
-		flash_base = WALNUT_FLASH_HIGH;
-
-	walnut_map.phys = flash_base;
-	walnut_map.virt =
-		(void __iomem *)ioremap(flash_base, walnut_map.size);
-
-	if (!walnut_map.virt) {
-		printk("Failed to ioremap flash.\n");
-		iounmap(fpga_status_adr);
-		return -EIO;
-	}
-
-	simple_map_init(&walnut_map);
-
-	flash = do_map_probe("jedec_probe", &walnut_map);
-	if (flash) {
-		flash->owner = THIS_MODULE;
-		add_mtd_partitions(flash, walnut_partitions,
-					ARRAY_SIZE(walnut_partitions));
-	} else {
-		printk("map probe failed for flash\n");
-		iounmap(fpga_status_adr);
-		return -ENXIO;
-	}
-
-	iounmap(fpga_status_adr);
-	return 0;
-}
-
-static void __exit cleanup_walnut(void)
-{
-	if (flash) {
-		del_mtd_partitions(flash);
-		map_destroy(flash);
-	}
-
-	if (walnut_map.virt) {
-		iounmap((void *)walnut_map.virt);
-		walnut_map.virt = 0;
-	}
-}
-
-module_init(init_walnut);
-module_exit(cleanup_walnut);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Heikki Lindholm <holindho@infradead.org>");
-MODULE_DESCRIPTION("MTD map and partitions for IBM 405GP Walnut boards");
-- 
1.5.5.1

