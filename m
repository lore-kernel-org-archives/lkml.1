Return-Path: <linux-kernel-owner+w=401wt.eu-S1756206AbYAPXQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206AbYAPXQd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 18:16:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754814AbYAPXOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 18:14:19 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:10411 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754882AbYAPXOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 18:14:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=DUC3WfxVwLPpVS4A9ViWlr/1d6qbrj71XsiG1jUL+Tdu4dbORH7bQKaF2fLFnFrx0KJJb1tBVrmhgirR8NAjkBpsk1N/5RM+/eCw3Kl5UzkextE4Q/c4xz9yMtJmZqe469xfNiE3hZjnLqbVtlGJhn3S5oMxYJSLhJnBGOIBVOw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 17 Jan 2008 00:26:55 +0100
Message-Id: <20080116232655.9166.55635.sendpatchset@localhost.localdomain>
In-Reply-To: <20080116232556.9166.13457.sendpatchset@localhost.localdomain>
References: <20080116232556.9166.13457.sendpatchset@localhost.localdomain>
Subject: [PATCH 07/22] ide: add IDE_HFLAG_NO_{IO32_BIT,UNMASK_IRQS} host flags
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Use the same bit for IDE_HFLAG_CS5520 and IDE_HFLAG_VDMA host flags
  (both are used only by cs5520 host driver currently).

* Add IDE_HFLAG_NO_IO32_BIT host flag and use it instead of ->no_io_32bit
  ide_hwif_t field.

* Add IDE_HFLAG_NO_UNMASK_IRQS host flag, then convert dtc2278 and rz1000
  host drivers to use it.

There should be no functionality changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c       |    4 +++-
 drivers/ide/legacy/dtc2278.c  |   10 +++-------
 drivers/ide/mips/au1xxx-ide.c |    3 +--
 drivers/ide/pci/rz1000.c      |    3 +--
 include/linux/ide.h           |   13 ++++++++-----
 5 files changed, 16 insertions(+), 17 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -822,7 +822,7 @@ static void ide_port_tune_devices(ide_hw
 	for (unit = 0; unit < MAX_DRIVES; ++unit) {
 		ide_drive_t *drive = &hwif->drives[unit];
 
-		if (hwif->no_io_32bit)
+		if (hwif->host_flags & IDE_HFLAG_NO_IO_32BIT)
 			drive->no_io_32bit = 1;
 		else
 			drive->no_io_32bit = drive->id->dword_io ? 1 : 0;
@@ -1300,6 +1300,8 @@ static void ide_port_init_devices(ide_hw
 			drive->io_32bit = 1;
 		if (hwif->host_flags & IDE_HFLAG_UNMASK_IRQS)
 			drive->unmask = 1;
+		if (hwif->host_flags & IDE_HFLAG_NO_UNMASK_IRQS)
+			drive->no_unmask = 1;
 		if ((hwif->host_flags & IDE_HFLAG_NO_AUTOTUNE) == 0)
 			drive->autotune = 1;
 	}
Index: b/drivers/ide/legacy/dtc2278.c
===================================================================
--- a/drivers/ide/legacy/dtc2278.c
+++ b/drivers/ide/legacy/dtc2278.c
@@ -89,7 +89,10 @@ static void dtc2278_set_pio_mode(ide_dri
 static const struct ide_port_info dtc2278_port_info __initdata = {
 	.chipset		= ide_dtc2278,
 	.host_flags		= IDE_HFLAG_SERIALIZE |
+				  IDE_HFLAG_NO_UNMASK_IRQS |
 				  IDE_HFLAG_IO_32BIT |
+				  /* disallow ->io_32bit changes */
+				  IDE_HFLAG_NO_IO_32BIT |
 				  IDE_HFLAG_NO_DMA |
 				  IDE_HFLAG_NO_AUTOTUNE,
 	.pio_mask		= ATA_PIO4,
@@ -125,14 +128,7 @@ static int __init dtc2278_probe(void)
 #endif
 	local_irq_restore(flags);
 
-	hwif->no_io_32bit = 1;	/* disallow ->io_32bit changes */
 	hwif->set_pio_mode = &dtc2278_set_pio_mode;
-	hwif->drives[0].no_unmask = 1;
-	hwif->drives[1].no_unmask = 1;
-
-	mate->no_io_32bit = 1;
-	mate->drives[0].no_unmask = 1;
-	mate->drives[1].no_unmask = 1;
 
 	ide_device_add(idx, &dtc2278_port_info);
 
Index: b/drivers/ide/mips/au1xxx-ide.c
===================================================================
--- a/drivers/ide/mips/au1xxx-ide.c
+++ b/drivers/ide/mips/au1xxx-ide.c
@@ -551,6 +551,7 @@ static void auide_setup_ports(hw_regs_t 
 static const struct ide_port_info au1xxx_port_info = {
 	.host_flags		= IDE_HFLAG_POST_SET_MODE |
 				  IDE_HFLAG_NO_DMA | /* no SFF-style DMA */
+				  IDE_HFLAG_NO_IO_32BIT |
 				  IDE_HFLAG_UNMASK_IRQS,
 	.pio_mask		= ATA_PIO4,
 #ifdef CONFIG_BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA
@@ -649,8 +650,6 @@ static int au_ide_probe(struct device *d
 	hwif->select_data               = 0;    /* no chipset-specific code */
 	hwif->config_data               = 0;    /* no chipset-specific code */
 
-	hwif->no_io_32bit		= 1;
-
 	auide_hwif.hwif                 = hwif;
 	hwif->hwif_data                 = &auide_hwif;
 
Index: b/drivers/ide/pci/rz1000.c
===================================================================
--- a/drivers/ide/pci/rz1000.c
+++ b/drivers/ide/pci/rz1000.c
@@ -33,8 +33,7 @@ static void __devinit init_hwif_rz1000 (
 	} else {
 		if (hwif->mate)
 			hwif->mate->serialized = hwif->serialized = 1;
-		hwif->drives[0].no_unmask = 1;
-		hwif->drives[1].no_unmask = 1;
+		hwif->host_flags |= IDE_HFLAG_NO_UNMASK_IRQS;
 		printk(KERN_INFO "%s: serialized, disabled unmasking "
 			"(buggy RZ1000/RZ1001)\n", hwif->name);
 	}
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -607,7 +607,6 @@ typedef struct hwif_s {
 	unsigned	reset      : 1;	/* reset after probe */
 	unsigned	auto_poll  : 1; /* supports nop auto-poll */
 	unsigned	sg_mapped  : 1;	/* sg_table and sg_nents are ready */
-	unsigned	no_io_32bit : 1; /* 1 = can not do 32-bit IO ops */
 	unsigned	mmio       : 1; /* host uses MMIO */
 
 	struct device	gendev;
@@ -1068,7 +1067,7 @@ enum {
 	IDE_HFLAG_NO_SET_MODE		= (1 << 9),
 	/* trust BIOS for programming chipset/device for DMA */
 	IDE_HFLAG_TRUST_BIOS_FOR_DMA	= (1 << 10),
-	/* host uses VDMA */
+	/* host uses VDMA (tied with IDE_HFLAG_CS5520 for now) */
 	IDE_HFLAG_VDMA			= (1 << 11),
 	/* ATAPI DMA is unsupported */
 	IDE_HFLAG_NO_ATAPI_DMA		= (1 << 12),
@@ -1078,8 +1077,10 @@ enum {
 	IDE_HFLAG_NO_DMA		= (1 << 14),
 	/* check if host is PCI IDE device before allowing DMA */
 	IDE_HFLAG_NO_AUTODMA		= (1 << 15),
+	/* don't autotune PIO */
+	IDE_HFLAG_NO_AUTOTUNE		= (1 << 16),
 	/* host is CS5510/CS5520 */
-	IDE_HFLAG_CS5520		= (1 << 16),
+	IDE_HFLAG_CS5520		= IDE_HFLAG_VDMA,
 	/* no LBA48 */
 	IDE_HFLAG_NO_LBA48		= (1 << 17),
 	/* no LBA48 DMA */
@@ -1105,8 +1106,10 @@ enum {
 	IDE_HFLAG_CLEAR_SIMPLEX		= (1 << 28),
 	/* DSC overlap is unsupported */
 	IDE_HFLAG_NO_DSC		= (1 << 29),
-	/* don't autotune PIO */
-	IDE_HFLAG_NO_AUTOTUNE		= (1 << 30),
+	/* never use 32-bit I/O ops */
+	IDE_HFLAG_NO_IO_32BIT		= (1 << 30),
+	/* never unmask IRQs */
+	IDE_HFLAG_NO_UNMASK_IRQS	= (1 << 31),
 };
 
 #ifdef CONFIG_BLK_DEV_OFFBOARD
