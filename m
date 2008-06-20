Return-Path: <linux-kernel-owner+w=401wt.eu-S1754680AbYFTSJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680AbYFTSJu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 14:09:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752823AbYFTSJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 14:09:38 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:57625 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbYFTSJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 14:09:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:user-agent:cc:mime-version:content-disposition:date
         :message-id:content-type:content-transfer-encoding;
        b=E99tK5PEdZbml3y5EPW/3HMreEVy/+caYKaqxY4x7OGsyKjH8Q8MUuhxkuOOobGboY
         fUtgHPX4aLrApDKyWCtbQVA/QJE/snZ6N1ue1aU3rpZjHV+h4YclroRbcIpPMAWiZODN
         wp1kObhSW0PxvO28Z9ACjV99WN+TpeMU0nuYw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git patches] IDE fixes
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Date: Fri, 20 Jun 2008 20:07:37 +0200
Message-Id: <200806202007.38081.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

some final "polishing" for 2.6.26:

- wait_drive_not_busy() timeout increase needed for some ATAPI devices,
  (issue debugged by Masanari Iida)

- resource management fix for palm_bk3710 (from Sergei Shtylyov)

- new IDs for ide-cs/pata_pcmcia (from various developers, details below)

- removal of old BAST IDE driver (from Ben Dooks)

  [ not strictly -rc stuff but as we are now using the platform-pata
    support lets not confuse people with having this driver around ]


Linus, please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 drivers/ata/pata_pcmcia.c     |    2 +
 drivers/ide/Kconfig           |    7 ---
 drivers/ide/arm/Makefile      |    1 -
 drivers/ide/arm/bast-ide.c    |   90 -----------------------------------------
 drivers/ide/arm/palm_bk3710.c |   22 ++++++----
 drivers/ide/ide-taskfile.c    |    6 +-
 drivers/ide/legacy/ide-cs.c   |    3 +
 7 files changed, 21 insertions(+), 110 deletions(-)
 delete mode 100644 drivers/ide/arm/bast-ide.c


Bartlomiej Zolnierkiewicz (1):
      ide: increase timeout in wait_drive_not_busy()

Ben Dooks (1):
      BAST: Remove old IDE driver

Christophe Niclaes (1):
      pcmcia ide kingston compactflash's have a new manufacturer id

Kristoffer Ericson (1):
      pcmcia: add another pata/ide ID

Matt Reimer (1):
      pcmcia: add an pata/ide ID

Sergei Shtylyov (1):
      palm_bk3710: fix resource management


diff --git a/drivers/ata/pata_pcmcia.c b/drivers/ata/pata_pcmcia.c
index 3d39f9d..41b4361 100644
--- a/drivers/ata/pata_pcmcia.c
+++ b/drivers/ata/pata_pcmcia.c
@@ -414,6 +414,7 @@ static struct pcmcia_device_id pcmcia_devices[] = {
 	PCMCIA_DEVICE_PROD_ID12("IO DATA", "PCIDE", 0x547e66dc, 0x5c5ab149),
 	PCMCIA_DEVICE_PROD_ID12("IO DATA", "PCIDEII", 0x547e66dc, 0xb3662674),
 	PCMCIA_DEVICE_PROD_ID12("LOOKMEET", "CBIDE2      ", 0xe37be2b5, 0x8671043b),
+	PCMCIA_DEVICE_PROD_ID12("M-Systems", "CF300", 0x7ed2ad87, 0x7e9e78ee),
 	PCMCIA_DEVICE_PROD_ID12("M-Systems", "CF500", 0x7ed2ad87, 0x7a13045c),
 	PCMCIA_DEVICE_PROD_ID2("NinjaATA-", 0xebe0bd79),
 	PCMCIA_DEVICE_PROD_ID12("PCMCIA", "CD-ROM", 0x281f1c5d, 0x66536591),
@@ -424,6 +425,7 @@ static struct pcmcia_device_id pcmcia_devices[] = {
 	PCMCIA_DEVICE_PROD_ID12("SMI VENDOR", "SMI PRODUCT", 0x30896c92, 0x703cc5f6),
 	PCMCIA_DEVICE_PROD_ID12("TOSHIBA", "MK2001MPL", 0xb4585a1a, 0x3489e003),
 	PCMCIA_DEVICE_PROD_ID1("TRANSCEND    512M   ", 0xd0909443),
+	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS1GCF45", 0x709b1bf1, 0xf68b6f32),
 	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS1GCF80", 0x709b1bf1, 0x2a54d4b1),
 	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS2GCF120", 0x709b1bf1, 0x969aa4f2),
 	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS4GCF120", 0x709b1bf1, 0xf54a91c8),
diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index 1607536..8e07de2 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -823,13 +823,6 @@ config BLK_DEV_IDE_RAPIDE
 	  Say Y here if you want to support the Yellowstone RapIDE controller
 	  manufactured for use with Acorn computers.
 
-config BLK_DEV_IDE_BAST
-	tristate "Simtec BAST / Thorcom VR1000 IDE support"
-	depends on ARM && (ARCH_BAST || MACH_VR1000)
-	help
-	  Say Y here if you want to support the onboard IDE channels on the
-	  Simtec BAST or the Thorcom VR1000
-
 config IDE_H8300
 	tristate "H8300 IDE support"
 	depends on H8300
diff --git a/drivers/ide/arm/Makefile b/drivers/ide/arm/Makefile
index 936e7b0..5bc2605 100644
--- a/drivers/ide/arm/Makefile
+++ b/drivers/ide/arm/Makefile
@@ -1,7 +1,6 @@
 
 obj-$(CONFIG_BLK_DEV_IDE_ICSIDE)	+= icside.o
 obj-$(CONFIG_BLK_DEV_IDE_RAPIDE)	+= rapide.o
-obj-$(CONFIG_BLK_DEV_IDE_BAST)		+= bast-ide.o
 obj-$(CONFIG_BLK_DEV_PALMCHIP_BK3710)	+= palm_bk3710.o
 
 ifeq ($(CONFIG_IDE_ARM), m)
diff --git a/drivers/ide/arm/bast-ide.c b/drivers/ide/arm/bast-ide.c
deleted file mode 100644
index 8e8c281..0000000
--- a/drivers/ide/arm/bast-ide.c
+++ /dev/null
@@ -1,90 +0,0 @@
-/*
- * Copyright (c) 2003-2004 Simtec Electronics
- *  Ben Dooks <ben@simtec.co.uk>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
-*/
-
-#include <linux/module.h>
-#include <linux/errno.h>
-#include <linux/ide.h>
-#include <linux/init.h>
-
-#include <asm/mach-types.h>
-
-#include <asm/io.h>
-#include <asm/irq.h>
-#include <asm/arch/map.h>
-#include <asm/arch/bast-map.h>
-#include <asm/arch/bast-irq.h>
-
-#define DRV_NAME "bast-ide"
-
-static int __init bastide_register(unsigned int base, unsigned int aux, int irq)
-{
-	ide_hwif_t *hwif;
-	hw_regs_t hw;
-	int i;
-	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
-
-	memset(&hw, 0, sizeof(hw));
-
-	base += BAST_IDE_CS;
-	aux  += BAST_IDE_CS;
-
-	for (i = 0; i <= 7; i++) {
-		hw.io_ports_array[i] = (unsigned long)base;
-		base += 0x20;
-	}
-
-	hw.io_ports.ctl_addr = aux + (6 * 0x20);
-	hw.irq = irq;
-	hw.chipset = ide_generic;
-
-	hwif = ide_find_port();
-	if (hwif == NULL)
-		goto out;
-
-	i = hwif->index;
-
-	ide_init_port_data(hwif, i);
-	ide_init_port_hw(hwif, &hw);
-	hwif->port_ops = NULL;
-
-	idx[0] = i;
-
-	ide_device_add(idx, NULL);
-out:
-	return 0;
-}
-
-static int __init bastide_init(void)
-{
-	unsigned long base = BAST_VA_IDEPRI + BAST_IDE_CS;
-
-	/* we can treat the VR1000 and the BAST the same */
-
-	if (!(machine_is_bast() || machine_is_vr1000()))
-		return 0;
-
-	printk("BAST: IDE driver, (c) 2003-2004 Simtec Electronics\n");
-
-	if (!request_mem_region(base, 0x400000, DRV_NAME)) {
-		printk(KERN_ERR "%s: resources busy\n", DRV_NAME);
-		return -EBUSY;
-	}
-
-	bastide_register(BAST_VA_IDEPRI, BAST_VA_IDEPRIAUX, IRQ_IDE0);
-	bastide_register(BAST_VA_IDESEC, BAST_VA_IDESECAUX, IRQ_IDE1);
-
-	return 0;
-}
-
-module_init(bastide_init);
-
-MODULE_AUTHOR("Ben Dooks <ben@simtec.co.uk>");
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("Simtec BAST / Thorcom VR1000 IDE driver");
diff --git a/drivers/ide/arm/palm_bk3710.c b/drivers/ide/arm/palm_bk3710.c
index d024ac8..cc24803 100644
--- a/drivers/ide/arm/palm_bk3710.c
+++ b/drivers/ide/arm/palm_bk3710.c
@@ -353,8 +353,8 @@ static int __devinit palm_bk3710_probe(struct platform_device *pdev)
 	struct clk *clkp;
 	struct resource *mem, *irq;
 	ide_hwif_t *hwif;
-	void __iomem *base;
-	int pribase, i;
+	unsigned long base;
+	int i;
 	hw_regs_t hw;
 	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 
@@ -374,22 +374,27 @@ static int __devinit palm_bk3710_probe(struct platform_device *pdev)
 		printk(KERN_ERR "failed to get memory region resource\n");
 		return -ENODEV;
 	}
+
 	irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (irq == NULL) {
 		printk(KERN_ERR "failed to get IRQ resource\n");
 		return -ENODEV;
 	}
 
-	base = (void *)mem->start;
+	if (request_mem_region(mem->start, mem->end - mem->start + 1,
+			       "palm_bk3710") == NULL) {
+		printk(KERN_ERR "failed to request memory region\n");
+		return -EBUSY;
+	}
+
+	base = IO_ADDRESS(mem->start);
 
 	/* Configure the Palm Chip controller */
-	palm_bk3710_chipinit(base);
+	palm_bk3710_chipinit((void __iomem *)base);
 
-	pribase = mem->start + IDE_PALM_ATA_PRI_REG_OFFSET;
 	for (i = 0; i < IDE_NR_PORTS - 2; i++)
-		hw.io_ports_array[i] = pribase + i;
-	hw.io_ports.ctl_addr = mem->start +
-			IDE_PALM_ATA_PRI_CTL_OFFSET;
+		hw.io_ports_array[i] = base + IDE_PALM_ATA_PRI_REG_OFFSET + i;
+	hw.io_ports.ctl_addr = base + IDE_PALM_ATA_PRI_CTL_OFFSET;
 	hw.irq = irq->start;
 	hw.chipset = ide_palm3710;
 
@@ -434,4 +439,3 @@ static int __init palm_bk3710_init(void)
 
 module_init(palm_bk3710_init);
 MODULE_LICENSE("GPL");
-
diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
index 0c908ca..ab545ff 100644
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -225,10 +225,10 @@ static u8 wait_drive_not_busy(ide_drive_t *drive)
 	u8 stat;
 
 	/*
-	 * Last sector was transfered, wait until drive is ready.
-	 * This can take up to 10 usec, but we will wait max 1 ms.
+	 * Last sector was transfered, wait until device is ready.  This can
+	 * take up to 6 ms on some ATAPI devices, so we will wait max 10 ms.
 	 */
-	for (retries = 0; retries < 100; retries++) {
+	for (retries = 0; retries < 1000; retries++) {
 		stat = ide_read_status(drive);
 
 		if (stat & BUSY_STAT)
diff --git a/drivers/ide/legacy/ide-cs.c b/drivers/ide/legacy/ide-cs.c
index f633b6b..1acb2c9 100644
--- a/drivers/ide/legacy/ide-cs.c
+++ b/drivers/ide/legacy/ide-cs.c
@@ -410,6 +410,7 @@ static struct pcmcia_device_id ide_ids[] = {
 	PCMCIA_DEVICE_MANF_CARD(0x001c, 0x0001),	/* Mitsubishi CFA */
 	PCMCIA_DEVICE_MANF_CARD(0x0032, 0x0704),
 	PCMCIA_DEVICE_MANF_CARD(0x0045, 0x0401),	/* SanDisk CFA */
+	PCMCIA_DEVICE_MANF_CARD(0x004f, 0x0000),	/* Kingston */
 	PCMCIA_DEVICE_MANF_CARD(0x0098, 0x0000),	/* Toshiba */
 	PCMCIA_DEVICE_MANF_CARD(0x00a4, 0x002d),
 	PCMCIA_DEVICE_MANF_CARD(0x00ce, 0x0000),	/* Samsung */
@@ -439,6 +440,7 @@ static struct pcmcia_device_id ide_ids[] = {
 	PCMCIA_DEVICE_PROD_ID12("IO DATA", "PCIDE", 0x547e66dc, 0x5c5ab149),
 	PCMCIA_DEVICE_PROD_ID12("IO DATA", "PCIDEII", 0x547e66dc, 0xb3662674),
 	PCMCIA_DEVICE_PROD_ID12("LOOKMEET", "CBIDE2      ", 0xe37be2b5, 0x8671043b),
+	PCMCIA_DEVICE_PROD_ID12("M-Systems", "CF300", 0x7ed2ad87, 0x7e9e78ee),
 	PCMCIA_DEVICE_PROD_ID12("M-Systems", "CF500", 0x7ed2ad87, 0x7a13045c),
 	PCMCIA_DEVICE_PROD_ID2("NinjaATA-", 0xebe0bd79),
 	PCMCIA_DEVICE_PROD_ID12("PCMCIA", "CD-ROM", 0x281f1c5d, 0x66536591),
@@ -449,6 +451,7 @@ static struct pcmcia_device_id ide_ids[] = {
 	PCMCIA_DEVICE_PROD_ID12("SMI VENDOR", "SMI PRODUCT", 0x30896c92, 0x703cc5f6),
 	PCMCIA_DEVICE_PROD_ID12("TOSHIBA", "MK2001MPL", 0xb4585a1a, 0x3489e003),
 	PCMCIA_DEVICE_PROD_ID1("TRANSCEND    512M   ", 0xd0909443),
+	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS1GCF45", 0x709b1bf1, 0xf68b632),
 	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS1GCF80", 0x709b1bf1, 0x2a54d4b1),
 	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS2GCF120", 0x709b1bf1, 0x969aa4f2),
 	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS4GCF120", 0x709b1bf1, 0xf54a91c8),
