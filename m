Return-Path: <linux-kernel-owner+w=401wt.eu-S1759563AbZBBVke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759563AbZBBVke (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 16:40:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758935AbZBBVjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 16:39:17 -0500
Received: from mail-bw0-f12.google.com ([209.85.218.12]:40432 "EHLO
	mail-bw0-f12.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758941AbZBBVjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 16:39:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=l+7s4p+vj37+Ms68/ybwtKu5013tZ9G5DZlsWWvhmPNZu3RMLQS5Ug8RqD79zT+qvh
         /jQv/2wqP94L3oeuJsN5P4N9+KCb5qYlO15l5cCbrMhJhcNZngzds/lgPzAKHq4BsL5z
         6Kkvj+aaLHn+LxFYnfJd9nrelgDxcbAvcutdE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 02 Feb 2009 22:37:41 +0100
Message-Id: <20090202213741.17960.8352.sendpatchset@localhost.localdomain>
In-Reply-To: <20090202213707.17960.61897.sendpatchset@localhost.localdomain>
References: <20090202213707.17960.61897.sendpatchset@localhost.localdomain>
Subject: [PATCH 05/14] ide: move command related fields from ide_hwif_t to struct ide_cmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: move command related fields from ide_hwif_t to struct ide_cmd

* Move command related fields from ide_hwif_t to struct ide_cmd.

* Make ide_init_sg_cmd() take command and sectors number as arguments.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/au1xxx-ide.c   |    2 +-
 drivers/ide/icside.c       |    2 +-
 drivers/ide/ide-disk.c     |   12 ++++++------
 drivers/ide/ide-dma-sff.c  |    2 +-
 drivers/ide/ide-dma.c      |   12 +++++++-----
 drivers/ide/ide-floppy.c   |    5 +++--
 drivers/ide/ide-io.c       |   24 ++++++++++--------------
 drivers/ide/ide-taskfile.c |   33 ++++++++++++++++-----------------
 drivers/ide/pmac.c         |    2 +-
 drivers/ide/sgiioc4.c      |    2 +-
 drivers/ide/tx4939ide.c    |    2 +-
 include/linux/ide.h        |   18 ++++++++++--------
 12 files changed, 58 insertions(+), 58 deletions(-)

Index: b/drivers/ide/au1xxx-ide.c
===================================================================
--- a/drivers/ide/au1xxx-ide.c
+++ b/drivers/ide/au1xxx-ide.c
@@ -215,7 +215,7 @@ static int auide_build_dmatable(ide_driv
 	struct request *rq = hwif->rq;
 	_auide_hwif *ahwif = &auide_hwif;
 	struct scatterlist *sg;
-	int i = hwif->sg_nents, iswrite, count = 0;
+	int i = hwif->cmd.sg_nents, iswrite, count = 0;
 
 	iswrite = (rq_data_dir(rq) == WRITE);
 	/* Save for interrupt context */
Index: b/drivers/ide/icside.c
===================================================================
--- a/drivers/ide/icside.c
+++ b/drivers/ide/icside.c
@@ -344,7 +344,7 @@ static int icside_dma_setup(ide_drive_t 
 	 * Tell the DMA engine about the SG table and
 	 * data direction.
 	 */
-	set_dma_sg(ec->dma, hwif->sg_table, hwif->sg_nents);
+	set_dma_sg(ec->dma, hwif->sg_table, hwif->cmd.sg_nents);
 	set_dma_mode(ec->dma, dma_mode);
 
 	drive->waiting_for_dma = 1;
Index: b/drivers/ide/ide-disk.c
===================================================================
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -104,14 +104,14 @@ static ide_startstop_t __ide_do_rw_disk(
 			lba48 = 0;
 	}
 
-	if (!dma) {
-		ide_init_sg_cmd(drive, rq);
-		ide_map_sg(drive, rq);
-	}
-
 	memset(&cmd, 0, sizeof(cmd));
 	cmd.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
 
+	if (dma == 0) {
+		ide_init_sg_cmd(&cmd, nsectors);
+		ide_map_sg(drive, rq);
+	}
+
 	if (drive->dev_flags & IDE_DFLAG_LBA) {
 		if (lba48) {
 			pr_debug("%s: LBA=0x%012llx\n", drive->name,
@@ -170,7 +170,7 @@ static ide_startstop_t __ide_do_rw_disk(
 		/* fallback to PIO */
 		cmd.tf_flags |= IDE_TFLAG_DMA_PIO_FALLBACK;
 		ide_tf_set_cmd(drive, &cmd, 0);
-		ide_init_sg_cmd(drive, rq);
+		ide_init_sg_cmd(&cmd, nsectors);
 		rc = do_rw_taskfile(drive, &cmd);
 	}
 
Index: b/drivers/ide/ide-dma-sff.c
===================================================================
--- a/drivers/ide/ide-dma-sff.c
+++ b/drivers/ide/ide-dma-sff.c
@@ -120,7 +120,7 @@ int ide_build_dmatable(ide_drive_t *driv
 	struct scatterlist *sg;
 	u8 is_trm290 = !!(hwif->host_flags & IDE_HFLAG_TRM290);
 
-	for_each_sg(hwif->sg_table, sg, hwif->sg_nents, i) {
+	for_each_sg(hwif->sg_table, sg, hwif->cmd.sg_nents, i) {
 		u32 cur_addr, cur_len, xcount, bcount;
 
 		cur_addr = sg_dma_address(sg);
Index: b/drivers/ide/ide-dma.c
===================================================================
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -128,16 +128,17 @@ int ide_build_sglist(ide_drive_t *drive,
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct scatterlist *sg = hwif->sg_table;
+	struct ide_cmd *cmd = &hwif->cmd;
 	int i;
 
 	ide_map_sg(drive, rq);
 
 	if (rq_data_dir(rq) == READ)
-		hwif->sg_dma_direction = DMA_FROM_DEVICE;
+		cmd->sg_dma_direction = DMA_FROM_DEVICE;
 	else
-		hwif->sg_dma_direction = DMA_TO_DEVICE;
+		cmd->sg_dma_direction = DMA_TO_DEVICE;
 
-	i = dma_map_sg(hwif->dev, sg, hwif->sg_nents, hwif->sg_dma_direction);
+	i = dma_map_sg(hwif->dev, sg, cmd->sg_nents, cmd->sg_dma_direction);
 	if (i == 0)
 		ide_map_sg(drive, rq);
 
@@ -158,9 +159,10 @@ int ide_build_sglist(ide_drive_t *drive,
 void ide_destroy_dmatable(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
+	struct ide_cmd *cmd = &hwif->cmd;
 
-	dma_unmap_sg(hwif->dev, hwif->sg_table, hwif->sg_nents,
-		     hwif->sg_dma_direction);
+	dma_unmap_sg(hwif->dev, hwif->sg_table, cmd->sg_nents,
+		     cmd->sg_dma_direction);
 }
 EXPORT_SYMBOL_GPL(ide_destroy_dmatable);
 
Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -244,6 +244,7 @@ static ide_startstop_t ide_floppy_do_req
 {
 	struct ide_disk_obj *floppy = drive->driver_data;
 	ide_hwif_t *hwif = drive->hwif;
+	struct ide_cmd *cmd = &hwif->cmd;
 	struct ide_atapi_pc *pc;
 
 	if (drive->debug_mask & IDE_DBG_RQ)
@@ -284,11 +285,11 @@ static ide_startstop_t ide_floppy_do_req
 		goto out_end;
 	}
 
-	ide_init_sg_cmd(drive, rq);
+	ide_init_sg_cmd(cmd, rq->nr_sectors);
 	ide_map_sg(drive, rq);
 
 	pc->sg = hwif->sg_table;
-	pc->sg_cnt = hwif->sg_nents;
+	pc->sg_cnt = cmd->sg_nents;
 
 	pc->rq = rq;
 
Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -270,30 +270,26 @@ static ide_startstop_t do_special (ide_d
 void ide_map_sg(ide_drive_t *drive, struct request *rq)
 {
 	ide_hwif_t *hwif = drive->hwif;
+	struct ide_cmd *cmd = &hwif->cmd;
 	struct scatterlist *sg = hwif->sg_table;
 
 	if (rq->cmd_type == REQ_TYPE_ATA_TASKFILE) {
 		sg_init_one(sg, rq->buffer, rq->nr_sectors * SECTOR_SIZE);
-		hwif->sg_nents = 1;
+		cmd->sg_nents = 1;
 	} else if (!rq->bio) {
 		sg_init_one(sg, rq->data, rq->data_len);
-		hwif->sg_nents = 1;
-	} else {
-		hwif->sg_nents = blk_rq_map_sg(drive->queue, rq, sg);
-	}
+		cmd->sg_nents = 1;
+	} else
+		cmd->sg_nents = blk_rq_map_sg(drive->queue, rq, sg);
 }
-
 EXPORT_SYMBOL_GPL(ide_map_sg);
 
-void ide_init_sg_cmd(ide_drive_t *drive, struct request *rq)
+void ide_init_sg_cmd(struct ide_cmd *cmd, int nsect)
 {
-	ide_hwif_t *hwif = drive->hwif;
-
-	hwif->nsect = hwif->nleft = rq->nr_sectors;
-	hwif->cursg_ofs = 0;
-	hwif->cursg = NULL;
+	cmd->nsect = cmd->nleft = nsect;
+	cmd->cursg_ofs = 0;
+	cmd->cursg = NULL;
 }
-
 EXPORT_SYMBOL_GPL(ide_init_sg_cmd);
 
 /**
@@ -319,7 +315,7 @@ static ide_startstop_t execute_drive_cmd
 		case TASKFILE_OUT:
 		case TASKFILE_MULTI_IN:
 		case TASKFILE_IN:
-			ide_init_sg_cmd(drive, rq);
+			ide_init_sg_cmd(cmd, rq->nr_sectors);
 			ide_map_sg(drive, rq);
 		default:
 			break;
Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -205,7 +205,7 @@ static void ide_pio_sector(ide_drive_t *
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct scatterlist *sg = hwif->sg_table;
-	struct scatterlist *cursg = hwif->cursg;
+	struct scatterlist *cursg = cmd->cursg;
 	struct page *page;
 #ifdef CONFIG_HIGHMEM
 	unsigned long flags;
@@ -213,14 +213,14 @@ static void ide_pio_sector(ide_drive_t *
 	unsigned int offset;
 	u8 *buf;
 
-	cursg = hwif->cursg;
+	cursg = cmd->cursg;
 	if (!cursg) {
 		cursg = sg;
-		hwif->cursg = sg;
+		cmd->cursg = sg;
 	}
 
 	page = sg_page(cursg);
-	offset = cursg->offset + hwif->cursg_ofs * SECTOR_SIZE;
+	offset = cursg->offset + cmd->cursg_ofs * SECTOR_SIZE;
 
 	/* get the current page and offset */
 	page = nth_page(page, (offset >> PAGE_SHIFT));
@@ -231,12 +231,12 @@ static void ide_pio_sector(ide_drive_t *
 #endif
 	buf = kmap_atomic(page, KM_BIO_SRC_IRQ) + offset;
 
-	hwif->nleft--;
-	hwif->cursg_ofs++;
+	cmd->nleft--;
+	cmd->cursg_ofs++;
 
-	if ((hwif->cursg_ofs * SECTOR_SIZE) == cursg->length) {
-		hwif->cursg = sg_next(hwif->cursg);
-		hwif->cursg_ofs = 0;
+	if ((cmd->cursg_ofs * SECTOR_SIZE) == cursg->length) {
+		cmd->cursg = sg_next(cmd->cursg);
+		cmd->cursg_ofs = 0;
 	}
 
 	/* do the actual data transfer */
@@ -256,7 +256,7 @@ static void ide_pio_multi(ide_drive_t *d
 {
 	unsigned int nsect;
 
-	nsect = min_t(unsigned int, drive->hwif->nleft, drive->mult_count);
+	nsect = min_t(unsigned int, cmd->nleft, drive->mult_count);
 	while (nsect--)
 		ide_pio_sector(drive, cmd, write);
 }
@@ -291,19 +291,18 @@ static ide_startstop_t task_error(ide_dr
 				  const char *s, u8 stat)
 {
 	if (cmd->tf_flags & IDE_TFLAG_FS) {
-		ide_hwif_t *hwif = drive->hwif;
-		int sectors = hwif->nsect - hwif->nleft;
+		int sectors = cmd->nsect - cmd->nleft;
 
 		switch (cmd->data_phase) {
 		case TASKFILE_IN:
-			if (hwif->nleft)
+			if (cmd->nleft)
 				break;
 			/* fall through */
 		case TASKFILE_OUT:
 			sectors--;
 			break;
 		case TASKFILE_MULTI_IN:
-			if (hwif->nleft)
+			if (cmd->nleft)
 				break;
 			/* fall through */
 		case TASKFILE_MULTI_OUT:
@@ -371,7 +370,7 @@ static ide_startstop_t task_in_intr(ide_
 	ide_pio_datablock(drive, cmd, 0);
 
 	/* Are we done? Check status and finish transfer. */
-	if (!hwif->nleft) {
+	if (cmd->nleft == 0) {
 		stat = wait_drive_not_busy(drive);
 		if (!OK_STAT(stat, 0, BAD_STAT))
 			return task_error(drive, cmd, __func__, stat);
@@ -398,10 +397,10 @@ static ide_startstop_t task_out_intr (id
 		return task_error(drive, cmd, __func__, stat);
 
 	/* Deal with unexpected ATA data phase. */
-	if (((stat & ATA_DRQ) == 0) ^ !hwif->nleft)
+	if (((stat & ATA_DRQ) == 0) ^ (cmd->nleft == 0))
 		return task_error(drive, cmd, __func__, stat);
 
-	if (!hwif->nleft) {
+	if (cmd->nleft == 0) {
 		ide_finish_cmd(drive, cmd, stat);
 		return ide_stopped;
 	}
Index: b/drivers/ide/pmac.c
===================================================================
--- a/drivers/ide/pmac.c
+++ b/drivers/ide/pmac.c
@@ -1432,7 +1432,7 @@ pmac_ide_build_dmatable(ide_drive_t *dri
 	volatile struct dbdma_regs __iomem *dma = pmif->dma_regs;
 	struct scatterlist *sg;
 	int wr = (rq_data_dir(rq) == WRITE);
-	int i = hwif->sg_nents, count = 0;
+	int i = hwif->cmd.sg_nents, count = 0;
 
 	/* DMA table is already aligned */
 	table = (struct dbdma_cmd *) pmif->dma_table_cpu;
Index: b/drivers/ide/sgiioc4.c
===================================================================
--- a/drivers/ide/sgiioc4.c
+++ b/drivers/ide/sgiioc4.c
@@ -429,7 +429,7 @@ sgiioc4_build_dma_table(ide_drive_t * dr
 {
 	ide_hwif_t *hwif = drive->hwif;
 	unsigned int *table = hwif->dmatable_cpu;
-	unsigned int count = 0, i = hwif->sg_nents;
+	unsigned int count = 0, i = hwif->cmd.sg_nents;
 	struct scatterlist *sg = hwif->sg_table;
 
 	while (i && sg_dma_len(sg)) {
Index: b/drivers/ide/tx4939ide.c
===================================================================
--- a/drivers/ide/tx4939ide.c
+++ b/drivers/ide/tx4939ide.c
@@ -240,7 +240,7 @@ static int tx4939ide_build_dmatable(ide_
 	int i;
 	struct scatterlist *sg;
 
-	for_each_sg(hwif->sg_table, sg, hwif->sg_nents, i) {
+	for_each_sg(hwif->sg_table, sg, hwif->cmd.sg_nents, i) {
 		u32 cur_addr, cur_len, bcount;
 
 		cur_addr = sg_dma_address(sg);
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -344,6 +344,15 @@ struct ide_cmd {
 	u8			ftf_flags;	/* for TASKFILE ioctl */
 	u32			tf_flags;
 	int			data_phase;
+
+	int			sg_nents;	  /* number of sg entries */
+	int			sg_dma_direction; /* DMA transfer direction */
+
+	unsigned int		nsect;
+	unsigned int		nleft;
+	struct scatterlist	*cursg;
+	unsigned int		cursg_ofs;
+
 	struct request		*rq;		/* copy of request */
 	void			*special;	/* valid_t generally */
 };
@@ -772,16 +781,9 @@ typedef struct hwif_s {
 	/* Scatter-gather list used to build the above */
 	struct scatterlist *sg_table;
 	int sg_max_nents;		/* Maximum number of entries in it */
-	int sg_nents;			/* Current number of entries in it */
-	int sg_dma_direction;		/* dma transfer direction */
 
 	struct ide_cmd cmd;		/* current command */
 
-	unsigned int nsect;
-	unsigned int nleft;
-	struct scatterlist *cursg;
-	unsigned int cursg_ofs;
-
 	int		rqsize;		/* max sectors per request */
 	int		irq;		/* our irq number */
 
@@ -1407,7 +1409,7 @@ int ide_pci_resume(struct pci_dev *);
 #endif
 
 void ide_map_sg(ide_drive_t *, struct request *);
-void ide_init_sg_cmd(ide_drive_t *, struct request *);
+void ide_init_sg_cmd(struct ide_cmd *, int);
 
 #define BAD_DMA_DRIVE		0
 #define GOOD_DMA_DRIVE		1
