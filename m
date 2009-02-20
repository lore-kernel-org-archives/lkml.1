Return-Path: <linux-kernel-owner+w=401wt.eu-S1758795AbZBTRLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758795AbZBTRLk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 12:11:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758847AbZBTRKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 12:10:18 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:7784 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758829AbZBTRKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 12:10:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=fZPtSDOS8tgs6n2kxkrm3tzNX5UW66pUOWmalynHtiUFjvlCWOwo0ShsUs65zMgxWy
         D65ya3KANZu0ZRIk76+du57327MItmq0CnqPm59gISCA5rNsuZdrRk5Wu6AtvR0moxu5
         SRYxeFlZu7Q7yIX4+8dy5az+bqxMCBq1ouMXg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 20 Feb 2009 18:12:09 +0100
Message-Id: <20090220171209.25429.87753.sendpatchset@localhost.localdomain>
In-Reply-To: <20090220171139.25429.26702.sendpatchset@localhost.localdomain>
References: <20090220171139.25429.26702.sendpatchset@localhost.localdomain>
Subject: [PATCH 04/10] ide: add ide_dma_prepare() helper
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: add ide_dma_prepare() helper

* Add ide_dma_prepare() helper.

* Convert ide_issue_pc() and do_rw_taskfile() to use it.

* Make ide_build_sglist() static.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-atapi.c    |   18 ++++--------------
 drivers/ide/ide-dma.c      |   11 ++++++++++-
 drivers/ide/ide-taskfile.c |    4 +---
 include/linux/ide.h        |    7 ++++---
 4 files changed, 19 insertions(+), 21 deletions(-)

Index: b/drivers/ide/ide-atapi.c
===================================================================
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -605,7 +605,6 @@ ide_startstop_t ide_issue_pc(ide_drive_t
 {
 	struct ide_atapi_pc *pc;
 	ide_hwif_t *hwif = drive->hwif;
-	const struct ide_dma_ops *dma_ops = hwif->dma_ops;
 	ide_expiry_t *expiry = NULL;
 	struct request *rq = hwif->rq;
 	unsigned int timeout;
@@ -619,12 +618,8 @@ ide_startstop_t ide_issue_pc(ide_drive_t
 		expiry = ide_cd_expiry;
 		timeout = ATAPI_WAIT_PC;
 
-		if (drive->dma) {
-			if (ide_build_sglist(drive, cmd))
-				drive->dma = !dma_ops->dma_setup(drive, cmd);
-			else
-				drive->dma = 0;
-		}
+		if (drive->dma)
+			drive->dma = !ide_dma_prepare(drive, cmd);
 	} else {
 		pc = drive->pc;
 
@@ -642,13 +637,8 @@ ide_startstop_t ide_issue_pc(ide_drive_t
 			ide_dma_off(drive);
 		}
 
-		if ((pc->flags & PC_FLAG_DMA_OK) &&
-		     (drive->dev_flags & IDE_DFLAG_USING_DMA)) {
-			if (ide_build_sglist(drive, cmd))
-				drive->dma = !dma_ops->dma_setup(drive, cmd);
-			else
-				drive->dma = 0;
-		}
+		if (pc->flags & PC_FLAG_DMA_OK)
+			drive->dma = !ide_dma_prepare(drive, cmd);
 
 		if (!drive->dma)
 			pc->flags &= ~PC_FLAG_DMA_OK;
Index: b/drivers/ide/ide-dma.c
===================================================================
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -128,7 +128,7 @@ int ide_dma_good_drive(ide_drive_t *driv
  *	operate in a portable fashion.
  */
 
-int ide_build_sglist(ide_drive_t *drive, struct ide_cmd *cmd)
+static int ide_build_sglist(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct scatterlist *sg = hwif->sg_table;
@@ -559,3 +559,12 @@ int ide_allocate_dma_engine(ide_hwif_t *
 	return 0;
 }
 EXPORT_SYMBOL_GPL(ide_allocate_dma_engine);
+
+int ide_dma_prepare(ide_drive_t *drive, struct ide_cmd *cmd)
+{
+	if ((drive->dev_flags & IDE_DFLAG_USING_DMA) == 0 ||
+	    ide_build_sglist(drive, cmd) == 0 ||
+	    drive->hwif->dma_ops->dma_setup(drive, cmd))
+		return 1;
+	return 0;
+}
Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -100,9 +100,7 @@ ide_startstop_t do_rw_taskfile(ide_drive
 		ide_execute_command(drive, cmd, handler, WAIT_WORSTCASE);
 		return ide_started;
 	case ATA_PROT_DMA:
-		if ((drive->dev_flags & IDE_DFLAG_USING_DMA) == 0 ||
-		    ide_build_sglist(drive, cmd) == 0 ||
-		    dma_ops->dma_setup(drive, cmd))
+		if (ide_dma_prepare(drive, cmd))
 			return ide_stopped;
 		hwif->expiry = dma_ops->dma_timer_expiry;
 		ide_execute_command(drive, cmd, ide_dma_intr, 2 * WAIT_CMD);
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1440,7 +1440,8 @@ ide_startstop_t ide_dma_intr(ide_drive_t
 int ide_allocate_dma_engine(ide_hwif_t *);
 void ide_release_dma_engine(ide_hwif_t *);
 
-int ide_build_sglist(ide_drive_t *, struct ide_cmd *);
+int ide_dma_prepare(ide_drive_t *, struct ide_cmd *);
+
 void ide_destroy_dmatable(ide_drive_t *);
 
 #ifdef CONFIG_BLK_DEV_IDEDMA_SFF
@@ -1474,8 +1475,8 @@ static inline void ide_check_dma_crc(ide
 static inline ide_startstop_t ide_dma_intr(ide_drive_t *drive) { return ide_stopped; }
 static inline ide_startstop_t ide_dma_timeout_retry(ide_drive_t *drive, int error) { return ide_stopped; }
 static inline void ide_release_dma_engine(ide_hwif_t *hwif) { ; }
-static inline int ide_build_sglist(ide_drive_t *drive,
-				   struct ide_cmd *cmd) { return 0; }
+static int ide_dma_prepare(ide_drive_t *drive,
+			   struct ide_cmd *cmd) { return 1; }
 #endif /* CONFIG_BLK_DEV_IDEDMA */
 
 #ifdef CONFIG_BLK_DEV_IDEACPI
