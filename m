Return-Path: <linux-kernel-owner+w=401wt.eu-S1761653AbYFTVcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761653AbYFTVcy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 17:32:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758613AbYFTVb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 17:31:56 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:6668 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761203AbYFTVby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 17:31:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=pq3G+929YnnDdJx32BtNXVJQDSAr/ScIvWyK3ESA3ZhBoJ1mcApk+FP8/69TU+qLmz
         Jp0zNWY9Q2eD1qN7/2sfew38QC2dS3mynievEVZXTCeZKSKdw7o0HWix4TV+WfeJZD2y
         YNhLCqyddDYka/SuknYLRMTg5r2ziMnen0o1Q=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2008 23:33:50 +0200
Message-Id: <20080620213350.13202.73557.sendpatchset@localhost.localdomain>
In-Reply-To: <20080620213323.13202.71450.sendpatchset@localhost.localdomain>
References: <20080620213323.13202.71450.sendpatchset@localhost.localdomain>
Subject: [PATCH 04/18] ide: remove ide_setup_dma()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export sff_dma_ops and then remove ide_setup_dma().

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/arm/palm_bk3710.c |    7 +++----
 drivers/ide/ide-dma.c         |   12 ++----------
 drivers/ide/pci/alim15x3.c    |    4 +++-
 drivers/ide/pci/hpt366.c      |    4 +++-
 drivers/ide/setup-pci.c       |    4 +++-
 include/linux/ide.h           |    2 +-
 6 files changed, 15 insertions(+), 18 deletions(-)

Index: b/drivers/ide/arm/palm_bk3710.c
===================================================================
--- a/drivers/ide/arm/palm_bk3710.c
+++ b/drivers/ide/arm/palm_bk3710.c
@@ -318,15 +318,14 @@ static u8 __devinit palm_bk3710_cable_de
 static int __devinit palm_bk3710_init_dma(ide_hwif_t *hwif,
 					  const struct ide_port_info *d)
 {
-	unsigned long base =
-		hwif->io_ports.data_addr - IDE_PALM_ATA_PRI_REG_OFFSET;
-
 	printk(KERN_INFO "    %s: MMIO-DMA\n", hwif->name);
 
 	if (ide_allocate_dma_engine(hwif))
 		return -1;
 
-	ide_setup_dma(hwif, base);
+	hwif->dma_base = hwif->io_ports.data_addr - IDE_PALM_ATA_PRI_REG_OFFSET;
+
+	hwif->dma_ops = &sff_dma_ops;
 
 	return 0;
 }
Index: b/drivers/ide/ide-dma.c
===================================================================
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -878,7 +878,7 @@ int ide_allocate_dma_engine(ide_hwif_t *
 }
 EXPORT_SYMBOL_GPL(ide_allocate_dma_engine);
 
-static const struct ide_dma_ops sff_dma_ops = {
+const struct ide_dma_ops sff_dma_ops = {
 	.dma_host_set		= ide_dma_host_set,
 	.dma_setup		= ide_dma_setup,
 	.dma_exec_cmd		= ide_dma_exec_cmd,
@@ -888,13 +888,5 @@ static const struct ide_dma_ops sff_dma_
 	.dma_timeout		= ide_dma_timeout,
 	.dma_lost_irq		= ide_dma_lost_irq,
 };
-
-void ide_setup_dma(ide_hwif_t *hwif, unsigned long base)
-{
-	hwif->dma_base = base;
-
-	hwif->dma_ops = &sff_dma_ops;
-}
-
-EXPORT_SYMBOL_GPL(ide_setup_dma);
+EXPORT_SYMBOL_GPL(sff_dma_ops);
 #endif /* CONFIG_BLK_DEV_IDEDMA_SFF */
Index: b/drivers/ide/pci/alim15x3.c
===================================================================
--- a/drivers/ide/pci/alim15x3.c
+++ b/drivers/ide/pci/alim15x3.c
@@ -483,7 +483,9 @@ static int __devinit init_dma_ali15x3(id
 	if (ide_allocate_dma_engine(hwif))
 		return -1;
 
-	ide_setup_dma(hwif, base);
+	hwif->dma_base = base;
+
+	hwif->dma_ops = &sff_dma_ops;
 
 	return 0;
 }
Index: b/drivers/ide/pci/hpt366.c
===================================================================
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -1346,7 +1346,9 @@ static int __devinit init_dma_hpt366(ide
 	if (ide_allocate_dma_engine(hwif))
 		return -1;
 
-	ide_setup_dma(hwif, base);
+	hwif->dma_base = base;
+
+	hwif->dma_ops = &sff_dma_ops;
 
 	return 0;
 }
Index: b/drivers/ide/setup-pci.c
===================================================================
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -376,7 +376,9 @@ int ide_hwif_setup_dma(ide_hwif_t *hwif,
 		if (ide_allocate_dma_engine(hwif))
 			return -1;
 
-		ide_setup_dma(hwif, base);
+		hwif->dma_base = base;
+
+		hwif->dma_ops = &sff_dma_ops;
 	}
 
 	return 0;
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -993,6 +993,7 @@ void ide_setup_pci_noise(struct pci_dev 
 #ifdef CONFIG_BLK_DEV_IDEDMA_PCI
 int ide_pci_set_master(struct pci_dev *, const char *);
 unsigned long ide_pci_dma_base(ide_hwif_t *, const struct ide_port_info *);
+extern const struct ide_dma_ops sff_dma_ops;
 int ide_hwif_setup_dma(ide_hwif_t *, const struct ide_port_info *);
 #else
 static inline int ide_hwif_setup_dma(ide_hwif_t *hwif,
@@ -1150,7 +1151,6 @@ void ide_destroy_dmatable(ide_drive_t *)
 extern int ide_build_dmatable(ide_drive_t *, struct request *);
 int ide_allocate_dma_engine(ide_hwif_t *);
 void ide_release_dma_engine(ide_hwif_t *);
-void ide_setup_dma(ide_hwif_t *, unsigned long);
 
 void ide_dma_host_set(ide_drive_t *, int);
 extern int ide_dma_setup(ide_drive_t *);
