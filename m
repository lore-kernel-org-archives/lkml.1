Return-Path: <linux-kernel-owner+w=401wt.eu-S1756108AbZBBVhB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108AbZBBVhB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 16:37:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757232AbZBBVga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 16:36:30 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:13673 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754775AbZBBVgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 16:36:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=tlP1R2fJUHqWZGjO+X2AVRxExHOyjoIQbb5kgMLNYlTSKxwiRzkPpKOutb8j1C+frd
         Mp/m4KtguZKBsStn45HW6ztTWUkTVTJonCpk7hm7Rt0KE8Oos0AXQlHB/RxFBUhxG7xp
         ApbbcEsBTiVwb3pua1Nf5KLJP9RvfigCVOdh4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 02 Feb 2009 22:37:20 +0100
Message-Id: <20090202213720.17960.10624.sendpatchset@localhost.localdomain>
In-Reply-To: <20090202213707.17960.61897.sendpatchset@localhost.localdomain>
References: <20090202213707.17960.61897.sendpatchset@localhost.localdomain>
Subject: [PATCH 02/14] ide: call ide_build_sglist() prior to ->dma_setup
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: call ide_build_sglist() prior to ->dma_setup

* Re-map sg table if needed in ide_build_sglist().

* Move ide_build_sglist() call from ->dma_setup to its users.

* Un-export ide_build_sglist().

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/au1xxx-ide.c   |    7 +------
 drivers/ide/icside.c       |    6 ------
 drivers/ide/ide-atapi.c    |   19 ++++++++++++++-----
 drivers/ide/ide-dma-sff.c  |    4 ----
 drivers/ide/ide-dma.c      |    9 ++++++---
 drivers/ide/ide-taskfile.c |    1 +
 drivers/ide/pmac.c         |    7 +------
 drivers/ide/sgiioc4.c      |   10 ++--------
 drivers/ide/tx4939ide.c    |    4 ----
 9 files changed, 25 insertions(+), 42 deletions(-)

Index: b/drivers/ide/au1xxx-ide.c
===================================================================
--- a/drivers/ide/au1xxx-ide.c
+++ b/drivers/ide/au1xxx-ide.c
@@ -211,21 +211,16 @@ static void auide_set_dma_mode(ide_drive
 #ifdef CONFIG_BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA
 static int auide_build_dmatable(ide_drive_t *drive)
 {
-	int i, iswrite, count = 0;
 	ide_hwif_t *hwif = drive->hwif;
 	struct request *rq = hwif->rq;
 	_auide_hwif *ahwif = &auide_hwif;
 	struct scatterlist *sg;
+	int i = hwif->sg_nents, iswrite, count = 0;
 
 	iswrite = (rq_data_dir(rq) == WRITE);
 	/* Save for interrupt context */
 	ahwif->drive = drive;
 
-	hwif->sg_nents = i = ide_build_sglist(drive, rq);
-
-	if (!i)
-		return 0;
-
 	/* fill the descriptors */
 	sg = hwif->sg_table;
 	while (i && sg_dma_len(sg)) {
Index: b/drivers/ide/icside.c
===================================================================
--- a/drivers/ide/icside.c
+++ b/drivers/ide/icside.c
@@ -325,12 +325,6 @@ static int icside_dma_setup(ide_drive_t 
 	 */
 	BUG_ON(dma_channel_active(ec->dma));
 
-	hwif->sg_nents = ide_build_sglist(drive, rq);
-	if (hwif->sg_nents == 0) {
-		ide_map_sg(drive, rq);
-		return 1;
-	}
-
 	/*
 	 * Ensure that we have the right interrupt routed.
 	 */
Index: b/drivers/ide/ide-atapi.c
===================================================================
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -619,18 +619,23 @@ ide_startstop_t ide_issue_pc(ide_drive_t
 	struct ide_atapi_pc *pc;
 	ide_hwif_t *hwif = drive->hwif;
 	ide_expiry_t *expiry = NULL;
+	struct request *rq = hwif->rq;
 	unsigned int timeout;
 	u32 tf_flags;
 	u16 bcount;
 
 	if (dev_is_idecd(drive)) {
 		tf_flags = IDE_TFLAG_OUT_NSECT | IDE_TFLAG_OUT_LBAL;
-		bcount = ide_cd_get_xferlen(hwif->rq);
+		bcount = ide_cd_get_xferlen(rq);
 		expiry = ide_cd_expiry;
 		timeout = ATAPI_WAIT_PC;
 
-		if (drive->dma)
-			drive->dma = !hwif->dma_ops->dma_setup(drive);
+		if (drive->dma) {
+			if (ide_build_sglist(drive, rq))
+				drive->dma = !hwif->dma_ops->dma_setup(drive);
+			else
+				drive->dma = 0;
+		}
 	} else {
 		pc = drive->pc;
 
@@ -649,8 +654,12 @@ ide_startstop_t ide_issue_pc(ide_drive_t
 		}
 
 		if ((pc->flags & PC_FLAG_DMA_OK) &&
-		     (drive->dev_flags & IDE_DFLAG_USING_DMA))
-			drive->dma = !hwif->dma_ops->dma_setup(drive);
+		     (drive->dev_flags & IDE_DFLAG_USING_DMA)) {
+			if (ide_build_sglist(drive, rq))
+				drive->dma = !hwif->dma_ops->dma_setup(drive);
+			else
+				drive->dma = 0;
+		}
 
 		if (!drive->dma)
 			pc->flags &= ~PC_FLAG_DMA_OK;
Index: b/drivers/ide/ide-dma-sff.c
===================================================================
--- a/drivers/ide/ide-dma-sff.c
+++ b/drivers/ide/ide-dma-sff.c
@@ -120,10 +120,6 @@ int ide_build_dmatable(ide_drive_t *driv
 	struct scatterlist *sg;
 	u8 is_trm290 = !!(hwif->host_flags & IDE_HFLAG_TRM290);
 
-	hwif->sg_nents = ide_build_sglist(drive, rq);
-	if (hwif->sg_nents == 0)
-		return 0;
-
 	for_each_sg(hwif->sg_table, sg, hwif->sg_nents, i) {
 		u32 cur_addr, cur_len, xcount, bcount;
 
Index: b/drivers/ide/ide-dma.c
===================================================================
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -128,6 +128,7 @@ int ide_build_sglist(ide_drive_t *drive,
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct scatterlist *sg = hwif->sg_table;
+	int i;
 
 	ide_map_sg(drive, rq);
 
@@ -136,10 +137,12 @@ int ide_build_sglist(ide_drive_t *drive,
 	else
 		hwif->sg_dma_direction = DMA_TO_DEVICE;
 
-	return dma_map_sg(hwif->dev, sg, hwif->sg_nents,
-			  hwif->sg_dma_direction);
+	i = dma_map_sg(hwif->dev, sg, hwif->sg_nents, hwif->sg_dma_direction);
+	if (i == 0)
+		ide_map_sg(drive, rq);
+
+	return i;
 }
-EXPORT_SYMBOL_GPL(ide_build_sglist);
 
 /**
  *	ide_destroy_dmatable	-	clean up DMA mapping
Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -103,6 +103,7 @@ ide_startstop_t do_rw_taskfile (ide_driv
 		return ide_started;
 	default:
 		if ((drive->dev_flags & IDE_DFLAG_USING_DMA) == 0 ||
+		    ide_build_sglist(drive, hwif->rq) == 0 ||
 		    dma_ops->dma_setup(drive))
 			return ide_stopped;
 		dma_ops->dma_exec_cmd(drive, tf->command);
Index: b/drivers/ide/pmac.c
===================================================================
--- a/drivers/ide/pmac.c
+++ b/drivers/ide/pmac.c
@@ -1429,10 +1429,10 @@ pmac_ide_build_dmatable(ide_drive_t *dri
 	pmac_ide_hwif_t *pmif =
 		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
 	struct dbdma_cmd *table;
-	int i, count = 0;
 	volatile struct dbdma_regs __iomem *dma = pmif->dma_regs;
 	struct scatterlist *sg;
 	int wr = (rq_data_dir(rq) == WRITE);
+	int i = hwif->sg_nents, count = 0;
 
 	/* DMA table is already aligned */
 	table = (struct dbdma_cmd *) pmif->dma_table_cpu;
@@ -1442,11 +1442,6 @@ pmac_ide_build_dmatable(ide_drive_t *dri
 	while (readl(&dma->status) & RUN)
 		udelay(1);
 
-	hwif->sg_nents = i = ide_build_sglist(drive, rq);
-
-	if (!i)
-		return 0;
-
 	/* Build DBDMA commands list */
 	sg = hwif->sg_table;
 	while (i && sg_dma_len(sg)) {
Index: b/drivers/ide/sgiioc4.c
===================================================================
--- a/drivers/ide/sgiioc4.c
+++ b/drivers/ide/sgiioc4.c
@@ -429,15 +429,9 @@ sgiioc4_build_dma_table(ide_drive_t * dr
 {
 	ide_hwif_t *hwif = drive->hwif;
 	unsigned int *table = hwif->dmatable_cpu;
-	unsigned int count = 0, i = 1;
-	struct scatterlist *sg;
+	unsigned int count = 0, i = hwif->sg_nents;
+	struct scatterlist *sg = hwif->sg_table;
 
-	hwif->sg_nents = i = ide_build_sglist(drive, rq);
-
-	if (!i)
-		return 0;	/* sglist of length Zero */
-
-	sg = hwif->sg_table;
 	while (i && sg_dma_len(sg)) {
 		dma_addr_t cur_addr;
 		int cur_len;
Index: b/drivers/ide/tx4939ide.c
===================================================================
--- a/drivers/ide/tx4939ide.c
+++ b/drivers/ide/tx4939ide.c
@@ -240,10 +240,6 @@ static int tx4939ide_build_dmatable(ide_
 	int i;
 	struct scatterlist *sg;
 
-	hwif->sg_nents = ide_build_sglist(drive, rq);
-	if (hwif->sg_nents == 0)
-		return 0;
-
 	for_each_sg(hwif->sg_table, sg, hwif->sg_nents, i) {
 		u32 cur_addr, cur_len, bcount;
 
