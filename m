Return-Path: <linux-kernel-owner+w=401wt.eu-S1755119AbZBTRN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119AbZBTRN5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 12:13:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758481AbZBTRLD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 12:11:03 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:46563 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759134AbZBTRLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 12:11:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=W7KsDjHlqlKCEJyrLWMMh1FtDojJLLQA2Dd5OMZ+a4uoT54b/E1OOuaBrXP6UV4qBi
         hutAvS3lGJb6N91O1p0C+jw8ENUVkjYmRGfwKU3qAwXaKBWbgY6AZp9ZJGrvA8pwrXLf
         1/38a1ESpmxa2clS3GR8Ir+DR0T2HYTr5VVl4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 20 Feb 2009 18:12:54 +0100
Message-Id: <20090220171254.25429.6029.sendpatchset@localhost.localdomain>
In-Reply-To: <20090220171139.25429.26702.sendpatchset@localhost.localdomain>
References: <20090220171139.25429.26702.sendpatchset@localhost.localdomain>
Subject: [PATCH 10/10] ide: sanitize ide_build_sglist() and ide_destroy_dmatable()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: sanitize ide_build_sglist() and ide_destroy_dmatable()

* Move ide_map_sg() calls out from ide_build_sglist()
  to ide_dma_prepare().

* Pass command to ide_destroy_dmatable().

* Rename ide_build_sglist() to ide_dma_map_sg()
  and ide_destroy_dmatable() to ide_dma_unmap_sg().

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-atapi.c |    2 -
 drivers/ide/ide-cd.c    |    2 -
 drivers/ide/ide-dma.c   |   50 ++++++++++++++++++++++++------------------------
 drivers/ide/sgiioc4.c   |    7 +++---
 include/linux/ide.h     |    3 --
 5 files changed, 32 insertions(+), 32 deletions(-)

Index: b/drivers/ide/ide-atapi.c
===================================================================
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -284,7 +284,7 @@ static ide_startstop_t ide_pc_intr(ide_d
 
 		drive->waiting_for_dma = 0;
 		rc = hwif->dma_ops->dma_end(drive);
-		ide_destroy_dmatable(drive);
+		ide_dma_unmap_sg(drive, cmd);
 
 		if (rc || (drive->media == ide_tape && (stat & ATA_ERR))) {
 			if (drive->media == ide_floppy)
Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -640,7 +640,7 @@ static ide_startstop_t cdrom_newpc_intr(
 		drive->dma = 0;
 		drive->waiting_for_dma = 0;
 		dma_error = hwif->dma_ops->dma_end(drive);
-		ide_destroy_dmatable(drive);
+		ide_dma_unmap_sg(drive, cmd);
 		if (dma_error) {
 			printk(KERN_ERR PFX "%s: DMA %s error\n", drive->name,
 					write ? "write" : "read");
Index: b/drivers/ide/ide-dma.c
===================================================================
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -89,17 +89,16 @@ static const struct drive_list_entry dri
 ide_startstop_t ide_dma_intr(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
+	struct ide_cmd *cmd = &hwif->cmd;
 	u8 stat = 0, dma_stat = 0;
 
 	drive->waiting_for_dma = 0;
 	dma_stat = hwif->dma_ops->dma_end(drive);
-	ide_destroy_dmatable(drive);
+	ide_dma_unmap_sg(drive, cmd);
 	stat = hwif->tp_ops->read_status(hwif);
 
 	if (OK_STAT(stat, DRIVE_READY, drive->bad_wstat | ATA_DRQ)) {
 		if (!dma_stat) {
-			struct ide_cmd *cmd = &hwif->cmd;
-
 			if ((cmd->tf_flags & IDE_TFLAG_FS) == 0)
 				ide_finish_cmd(drive, cmd, stat);
 			else
@@ -119,8 +118,8 @@ int ide_dma_good_drive(ide_drive_t *driv
 }
 
 /**
- *	ide_build_sglist	-	map IDE scatter gather for DMA I/O
- *	@drive: the drive to build the DMA table for
+ *	ide_dma_map_sg	-	map IDE scatter gather for DMA I/O
+ *	@drive: the drive to map the DMA table for
  *	@cmd: command
  *
  *	Perform the DMA mapping magic necessary to access the source or
@@ -129,23 +128,19 @@ int ide_dma_good_drive(ide_drive_t *driv
  *	operate in a portable fashion.
  */
 
-static int ide_build_sglist(ide_drive_t *drive, struct ide_cmd *cmd)
+static int ide_dma_map_sg(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct scatterlist *sg = hwif->sg_table;
 	int i;
 
-	ide_map_sg(drive, cmd);
-
 	if (cmd->tf_flags & IDE_TFLAG_WRITE)
 		cmd->sg_dma_direction = DMA_TO_DEVICE;
 	else
 		cmd->sg_dma_direction = DMA_FROM_DEVICE;
 
 	i = dma_map_sg(hwif->dev, sg, cmd->sg_nents, cmd->sg_dma_direction);
-	if (i == 0)
-		ide_map_sg(drive, cmd);
-	else {
+	if (i) {
 		cmd->orig_sg_nents = cmd->sg_nents;
 		cmd->sg_nents = i;
 	}
@@ -154,7 +149,7 @@ static int ide_build_sglist(ide_drive_t 
 }
 
 /**
- *	ide_destroy_dmatable	-	clean up DMA mapping
+ *	ide_dma_unmap_sg	-	clean up DMA mapping
  *	@drive: The drive to unmap
  *
  *	Teardown mappings after DMA has completed. This must be called
@@ -164,15 +159,14 @@ static int ide_build_sglist(ide_drive_t 
  *	time.
  */
 
-void ide_destroy_dmatable(ide_drive_t *drive)
+void ide_dma_unmap_sg(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	struct ide_cmd *cmd = &hwif->cmd;
 
 	dma_unmap_sg(hwif->dev, hwif->sg_table, cmd->orig_sg_nents,
 		     cmd->sg_dma_direction);
 }
-EXPORT_SYMBOL_GPL(ide_destroy_dmatable);
+EXPORT_SYMBOL_GPL(ide_dma_unmap_sg);
 
 /**
  *	ide_dma_off_quietly	-	Generic DMA kill
@@ -471,6 +465,7 @@ ide_startstop_t ide_dma_timeout_retry(id
 {
 	ide_hwif_t *hwif = drive->hwif;
 	const struct ide_dma_ops *dma_ops = hwif->dma_ops;
+	struct ide_cmd *cmd = &hwif->cmd;
 	struct request *rq;
 	ide_startstop_t ret = ide_stopped;
 
@@ -482,7 +477,7 @@ ide_startstop_t ide_dma_timeout_retry(id
 		printk(KERN_WARNING "%s: DMA timeout error\n", drive->name);
 		drive->waiting_for_dma = 0;
 		(void)dma_ops->dma_end(drive);
-		ide_destroy_dmatable(drive);
+		ide_dma_unmap_sg(drive, cmd);
 		ret = ide_error(drive, "dma timeout error",
 				hwif->tp_ops->read_status(hwif));
 	} else {
@@ -495,7 +490,7 @@ ide_startstop_t ide_dma_timeout_retry(id
 					hwif->tp_ops->read_status(hwif));
 			drive->waiting_for_dma = 0;
 			(void)dma_ops->dma_end(drive);
-			ide_destroy_dmatable(drive);
+			ide_dma_unmap_sg(drive, cmd);
 		}
 	}
 
@@ -572,14 +567,19 @@ int ide_dma_prepare(ide_drive_t *drive, 
 	const struct ide_dma_ops *dma_ops = drive->hwif->dma_ops;
 
 	if ((drive->dev_flags & IDE_DFLAG_USING_DMA) == 0 ||
-	    (dma_ops->dma_check && dma_ops->dma_check(drive, cmd)) ||
-	    ide_build_sglist(drive, cmd) == 0)
-		return 1;
-	if (dma_ops->dma_setup(drive, cmd)) {
-		ide_destroy_dmatable(drive);
-		ide_map_sg(drive, cmd);
-		return 1;
-	}
+	    (dma_ops->dma_check && dma_ops->dma_check(drive, cmd)))
+		goto out;
+	ide_map_sg(drive, cmd);
+	if (ide_dma_map_sg(drive, cmd) == 0)
+		goto out_map;
+	if (dma_ops->dma_setup(drive, cmd))
+		goto out_dma_unmap;
 	drive->waiting_for_dma = 1;
 	return 0;
+out_dma_unmap:
+	ide_dma_unmap_sg(drive, cmd);
+out_map:
+	ide_map_sg(drive, cmd);
+out:
+	return 1;
 }
Index: b/drivers/ide/sgiioc4.c
===================================================================
--- a/drivers/ide/sgiioc4.c
+++ b/drivers/ide/sgiioc4.c
@@ -277,11 +277,12 @@ static void sgiioc4_dma_host_set(ide_dri
 		sgiioc4_clearirq(drive);
 }
 
-static void
-sgiioc4_resetproc(ide_drive_t * drive)
+static void sgiioc4_resetproc(ide_drive_t *drive)
 {
+	struct ide_cmd *cmd = &drive->hwif->cmd;
+
 	sgiioc4_dma_end(drive);
-	ide_destroy_dmatable(drive);
+	ide_dma_unmap_sg(drive, cmd);
 	sgiioc4_clearirq(drive);
 }
 
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1438,8 +1438,7 @@ int ide_allocate_dma_engine(ide_hwif_t *
 void ide_release_dma_engine(ide_hwif_t *);
 
 int ide_dma_prepare(ide_drive_t *, struct ide_cmd *);
-
-void ide_destroy_dmatable(ide_drive_t *);
+void ide_dma_unmap_sg(ide_drive_t *, struct ide_cmd *);
 
 #ifdef CONFIG_BLK_DEV_IDEDMA_SFF
 int config_drive_for_dma(ide_drive_t *);
