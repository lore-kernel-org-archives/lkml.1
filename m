Return-Path: <linux-kernel-owner+w=401wt.eu-S1754702AbXL0TEO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702AbXL0TEO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 14:04:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754695AbXL0TCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 14:02:08 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:6105 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690AbXL0TCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 14:02:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=aBKZbra00fzVgzfnbdwWW2Ufkmijdhs6HTsvjX6tRNmfhaCTuqvvyfWDcVIWEt5oysSr4reY1DqFmwp2D8URiJPCsGBh5lCLjVbILKCd1CfHcAUMBT0sCYYIcwh+GUngIKluGJeRMbBB1cRvGGqsJJwtlZJFUDMQ3s8Vt1005OQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org, bzolnier@gmail.com
Cc: Bryan Wu <bryan.wu@analog.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>
Date: Thu, 27 Dec 2007 20:12:59 +0100
Message-Id: <20071227191259.1357.30444.sendpatchset@localhost.localdomain>
In-Reply-To: <20071227191153.1357.63211.sendpatchset@localhost.localdomain>
References: <20071227191153.1357.63211.sendpatchset@localhost.localdomain>
Subject: [PATCH 9/9] ide: use ide_build_sglist() and ide_destroy_dmatable() in non-PCI host drivers
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Make ide_build_sglist() and ide_destroy_dmatable() available also when
  CONFIG_BLK_DEV_IDEDMA_PCI=n.

* Use ide_build_sglist() and ide_destroy_dmatable() in {ics,au1xxx-}ide.c
  and remove no longer needed {ics,au}ide_build_sglist().

There should be no functionality changes caused by this patch.

Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/arm/icside.c      |   21 ++-------------------
 drivers/ide/ide-dma.c         |    4 +++-
 drivers/ide/mips/au1xxx-ide.c |   28 +++-------------------------
 include/linux/ide.h           |    5 +++--
 4 files changed, 11 insertions(+), 47 deletions(-)

Index: b/drivers/ide/arm/icside.c
===================================================================
--- a/drivers/ide/arm/icside.c
+++ b/drivers/ide/arm/icside.c
@@ -204,22 +204,6 @@ static void icside_maskproc(ide_drive_t 
  * interfaces use the same IRQ, which should guarantee this.
  */
 
-static void icside_build_sglist(ide_drive_t *drive, struct request *rq)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	struct scatterlist *sg = hwif->sg_table;
-
-	ide_map_sg(drive, rq);
-
-	if (rq_data_dir(rq) == READ)
-		hwif->sg_dma_direction = DMA_FROM_DEVICE;
-	else
-		hwif->sg_dma_direction = DMA_TO_DEVICE;
-
-	hwif->sg_nents = dma_map_sg(hwif->dev, sg, hwif->sg_nents,
-				    hwif->sg_dma_direction);
-}
-
 /*
  * Configure the IOMD to give the appropriate timings for the transfer
  * mode being requested.  We take the advice of the ATA standards, and
@@ -298,8 +282,7 @@ static int icside_dma_end(ide_drive_t *d
 	disable_dma(ec->dma);
 
 	/* Teardown mappings after DMA has completed. */
-	dma_unmap_sg(hwif->dev, hwif->sg_table, hwif->sg_nents,
-		     hwif->sg_dma_direction);
+	ide_destroy_dmatable(drive);
 
 	return get_dma_residue(ec->dma) != 0;
 }
@@ -331,7 +314,7 @@ static int icside_dma_setup(ide_drive_t 
 	 */
 	BUG_ON(dma_channel_active(ec->dma));
 
-	icside_build_sglist(drive, rq);
+	hwif->sg_nents = ide_build_sglist(drive, rq);
 
 	/*
 	 * Ensure that we have the right interrupt routed.
Index: b/drivers/ide/ide-dma.c
===================================================================
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -170,7 +170,6 @@ static int ide_dma_good_drive(ide_drive_
 	return ide_in_drive_list(drive->id, drive_whitelist);
 }
 
-#ifdef CONFIG_BLK_DEV_IDEDMA_PCI
 /**
  *	ide_build_sglist	-	map IDE scatter gather for DMA I/O
  *	@drive: the drive to build the DMA table for
@@ -200,6 +199,7 @@ int ide_build_sglist(ide_drive_t *drive,
 
 EXPORT_SYMBOL_GPL(ide_build_sglist);
 
+#ifdef CONFIG_BLK_DEV_IDEDMA_PCI
 /**
  *	ide_build_dmatable	-	build IDE DMA table
  *
@@ -294,6 +294,7 @@ use_pio_instead:
 }
 
 EXPORT_SYMBOL_GPL(ide_build_dmatable);
+#endif
 
 /**
  *	ide_destroy_dmatable	-	clean up DMA mapping
@@ -316,6 +317,7 @@ void ide_destroy_dmatable (ide_drive_t *
 
 EXPORT_SYMBOL_GPL(ide_destroy_dmatable);
 
+#ifdef CONFIG_BLK_DEV_IDEDMA_PCI
 /**
  *	config_drive_for_dma	-	attempt to activate IDE DMA
  *	@drive: the drive to place in DMA mode
Index: b/drivers/ide/mips/au1xxx-ide.c
===================================================================
--- a/drivers/ide/mips/au1xxx-ide.c
+++ b/drivers/ide/mips/au1xxx-ide.c
@@ -209,23 +209,6 @@ static void auide_set_dma_mode(ide_drive
  */
 
 #ifdef CONFIG_BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA
-
-static int auide_build_sglist(ide_drive_t *drive,  struct request *rq)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	struct scatterlist *sg = hwif->sg_table;
-
-	ide_map_sg(drive, rq);
-
-	if (rq_data_dir(rq) == READ)
-		hwif->sg_dma_direction = DMA_FROM_DEVICE;
-	else
-		hwif->sg_dma_direction = DMA_TO_DEVICE;
-
-	return dma_map_sg(hwif->dev, sg, hwif->sg_nents,
-			  hwif->sg_dma_direction);
-}
-
 static int auide_build_dmatable(ide_drive_t *drive)
 {
 	int i, iswrite, count = 0;
@@ -240,8 +223,7 @@ static int auide_build_dmatable(ide_driv
 	/* Save for interrupt context */
 	ahwif->drive = drive;
 
-	/* Build sglist */
-	hwif->sg_nents = i = auide_build_sglist(drive, rq);
+	hwif->sg_nents = i = ide_build_sglist(drive, rq);
 
 	if (!i)
 		return 0;
@@ -299,10 +281,7 @@ static int auide_build_dmatable(ide_driv
 		return 1;
 
  use_pio_instead:
-	dma_unmap_sg(hwif->dev,
-		     hwif->sg_table,
-		     hwif->sg_nents,
-		     hwif->sg_dma_direction);
+	ide_destroy_dmatable(drive);
 
 	return 0; /* revert to PIO for this request */
 }
@@ -312,8 +291,7 @@ static int auide_dma_end(ide_drive_t *dr
 	ide_hwif_t *hwif = HWIF(drive);
 
 	if (hwif->sg_nents) {
-		dma_unmap_sg(hwif->dev, hwif->sg_table, hwif->sg_nents,
-			     hwif->sg_dma_direction);
+		ide_destroy_dmatable(drive);
 		hwif->sg_nents = 0;
 	}
 
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1158,10 +1158,11 @@ void ide_dma_on(ide_drive_t *);
 int ide_set_dma(ide_drive_t *);
 ide_startstop_t ide_dma_intr(ide_drive_t *);
 
+int ide_build_sglist(ide_drive_t *, struct request *);
+void ide_destroy_dmatable(ide_drive_t *);
+
 #ifdef CONFIG_BLK_DEV_IDEDMA_PCI
-extern int ide_build_sglist(ide_drive_t *, struct request *);
 extern int ide_build_dmatable(ide_drive_t *, struct request *);
-extern void ide_destroy_dmatable(ide_drive_t *);
 extern int ide_release_dma(ide_hwif_t *);
 extern void ide_setup_dma(ide_hwif_t *, unsigned long, unsigned int);
 
