Return-Path: <linux-kernel-owner+w=401wt.eu-S1761593AbYAKMJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761593AbYAKMJO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 07:09:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760866AbYAKMEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 07:04:16 -0500
Received: from smtp116.plus.mail.re1.yahoo.com ([69.147.102.79]:39115 "HELO
	smtp116.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760377AbYAKMDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 07:03:51 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References;
  b=HvjPUx5IBLrJFEuKKnb+OsCnRDcYiqJdIzGODMw0rjs0GSK6q/B+PZlrsvem3rqFeuExF0GW/CfhHUd5S3k3803BXHhCfezlgwN1C9nzlncu//SAycJBIZ30wqD9TIB5OwrawtT5xWvshj2ZMibkeYCyZv4iY6fVDruIXs8+CrM=  ;
X-YMail-OSG: N0jY7fMVM1kr1UuuOdDS6UoM_ELsX1ODpB87_tdB69DpHBcDnQvDxrnFpq2YMqU8vt490Nv9ng--
X-Yahoo-Newman-Property: ymail-3
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Bartlomiej@gollum.tnic, Zolnierkiewicz@gollum.tnic, <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>
Subject: [PATCH 21/21] ide-floppy: remove atomic test_*bit macros
Date: Fri, 11 Jan 2008 12:58:19 +0100
Message-Id: <1200052699-28420-22-git-send-email-bbpetkov@yahoo.de>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1200052699-28420-21-git-send-email-bbpetkov@yahoo.de>
References: <1200052699-28420-1-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-2-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-3-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-4-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-5-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-6-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-7-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-8-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-9-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-10-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-11-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-12-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-13-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-14-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-15-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-16-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-17-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-18-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-19-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-20-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-21-git-send-email-bbpetkov@yahoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change is temporary and after unification of the IDE subsystem proper
bit setting and testing macros will be introduced.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
---
 drivers/ide/ide-floppy.c |   82 +++++++++++++++++++++++++---------------------
 1 files changed, 45 insertions(+), 37 deletions(-)

diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 4106eb4..29c1983 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -479,12 +479,12 @@ static ide_startstop_t idefloppy_pc_intr(ide_drive_t *drive)
 
 	debug_log("Reached %s interrupt handler\n", __FUNCTION__);
 
-	if (test_bit(PC_DMA_IN_PROGRESS, &pc->flags)) {
+	if ((1UL << PC_DMA_IN_PROGRESS) & pc->flags) {
 		dma_error = HWIF(drive)->ide_dma_end(drive);
 		if (dma_error) {
 			printk(KERN_ERR "%s: DMA %s error\n", drive->name,
 					write ?	"write" : "read");
-			set_bit(PC_DMA_ERROR, &pc->flags);
+			pc->flags |= (1UL << PC_DMA_ERROR);
 		} else {
 			pc->actually_transferred = pc->request_transfer;
 			idefloppy_update_buffers(drive, pc);
@@ -499,11 +499,11 @@ static ide_startstop_t idefloppy_pc_intr(ide_drive_t *drive)
 		/* No more interrupts */
 		debug_log("Packet command completed, %d bytes transferred\n",
 				pc->actually_transferred);
-		clear_bit(PC_DMA_IN_PROGRESS, &pc->flags);
+		pc->flags &= ((1UL << PC_DMA_IN_PROGRESS) ^ ~0UL);
 
 		local_irq_enable_in_hardirq();
 
-		if ((stat & ERR_STAT) || test_bit(PC_DMA_ERROR, &pc->flags)) {
+		if ((stat & ERR_STAT) || ((1UL << PC_DMA_ERROR) & pc->flags)) {
 			/* Error detected */
 			debug_log("I/O error\n", drive->name);
 			rq->errors++;
@@ -525,7 +525,8 @@ static ide_startstop_t idefloppy_pc_intr(ide_drive_t *drive)
 		return ide_stopped;
 	}
 
-	if (test_and_clear_bit(PC_DMA_IN_PROGRESS, &pc->flags)) {
+	if ((1UL << PC_DMA_IN_PROGRESS) & pc->flags) {
+		pc->flags &= ((1UL << PC_DMA_IN_PROGRESS) ^ ~0UL);
 		printk(KERN_ERR "ide-floppy: The floppy wants to issue "
 			"more interrupts in DMA mode\n");
 		ide_dma_off(drive);
@@ -704,13 +705,13 @@ static ide_startstop_t idefloppy_issue_pc(ide_drive_t *drive,
 	floppy->pc = pc;
 
 	if (pc->retries > IDEFLOPPY_MAX_PC_RETRIES ||
-	    test_bit(PC_ABORT, &pc->flags)) {
+			((1UL << PC_ABORT) & pc->flags)) {
 		/*
 		 *	We will "abort" retrying a packet command in case
 		 *	a legitimate error code was received.
 		 */
-		if (!test_bit(PC_ABORT, &pc->flags)) {
-			if (!test_bit(PC_SUPPRESS_ERROR, &pc->flags))
+		if (!((1UL << PC_ABORT) & pc->flags)) {
+			if (!((1UL << PC_SUPPRESS_ERROR) & pc->flags))
 				idefloppy_report_error(floppy, pc);
 			/* Giving up */
 			pc->error = IDEFLOPPY_ERROR_GENERAL;
@@ -728,12 +729,14 @@ static ide_startstop_t idefloppy_issue_pc(ide_drive_t *drive,
 	pc->current_position = pc->buffer;
 	bcount = min(pc->request_transfer, 63 * 1024);
 
-	if (test_and_clear_bit(PC_DMA_ERROR, &pc->flags))
+	if ((1UL << PC_DMA_ERROR) & pc->flags) {
+		pc->flags &= ((1UL << PC_DMA_ERROR) ^ ~0UL);
 		ide_dma_off(drive);
+	}
 
 	dma = 0;
 
-	if (test_bit(PC_DMA_RECOMMENDED, &pc->flags) && drive->using_dma)
+	if (((1UL << PC_DMA_RECOMMENDED) & pc->flags) && drive->using_dma)
 		dma = !hwif->dma_setup(drive);
 
 	ide_pktcmd_tf_load(drive, IDE_TFLAG_NO_SELECT_MASK |
@@ -741,12 +744,12 @@ static ide_startstop_t idefloppy_issue_pc(ide_drive_t *drive,
 
 	if (dma) {
 		/* Begin DMA, if necessary */
-		set_bit(PC_DMA_IN_PROGRESS, &pc->flags);
+		pc->flags |= 1UL << PC_DMA_IN_PROGRESS;
 		hwif->dma_start(drive);
 	}
 
 	/* Can we transfer the packet when we get the interrupt or wait? */
-	if (test_bit(IDEFLOPPY_ZIP_DRIVE, &floppy->flags)) {
+	if ((1UL << IDEFLOPPY_ZIP_DRIVE) & floppy->flags) {
 		/* wait */
 		pkt_xfer_routine = &idefloppy_transfer_pc1;
 	} else {
@@ -754,7 +757,7 @@ static ide_startstop_t idefloppy_issue_pc(ide_drive_t *drive,
 		pkt_xfer_routine = &idefloppy_transfer_pc;
 	}
 
-	if (test_bit(IDEFLOPPY_DRQ_INTERRUPT, &floppy->flags)) {
+	if ((1UL << IDEFLOPPY_DRQ_INTERRUPT) & floppy->flags) {
 		/* Issue the packet command */
 		ide_execute_command(drive, WIN_PACKETCMD,
 				pkt_xfer_routine,
@@ -812,7 +815,7 @@ static void idefloppy_create_format_unit_cmd(idefloppy_pc_t *pc, int b, int l,
 	put_unaligned(cpu_to_be32(b), (unsigned int *)(&pc->buffer[4]));
 	put_unaligned(cpu_to_be32(l), (unsigned int *)(&pc->buffer[8]));
 	pc->buffer_size = 12;
-	set_bit(PC_WRITING, &pc->flags);
+	pc->flags |= 1 << PC_WRITING;
 }
 
 /* A mode sense command is used to "sense" floppy parameters. */
@@ -862,11 +865,11 @@ static void idefloppy_create_rw_cmd(idefloppy_floppy_t *floppy,
 	int cmd = rq_data_dir(rq);
 
 	debug_log("create_rw1%d_cmd: block == %d, blocks == %d\n",
-		2 * test_bit(IDEFLOPPY_USE_READ12, &floppy->flags),
+		2 * ((1UL << IDEFLOPPY_USE_READ12) & floppy->flags),
 		block, blocks);
 
 	idefloppy_init_pc(pc);
-	if (test_bit(IDEFLOPPY_USE_READ12, &floppy->flags)) {
+	if ((1UL << IDEFLOPPY_USE_READ12) & floppy->flags) {
 		pc->c[0] = cmd == READ ? GPCMD_READ_12 : GPCMD_WRITE_12;
 		put_unaligned(cpu_to_be32(blocks), (unsigned int *) &pc->c[6]);
 	} else {
@@ -878,10 +881,10 @@ static void idefloppy_create_rw_cmd(idefloppy_floppy_t *floppy,
 	pc->rq = rq;
 	pc->b_count = cmd == READ ? 0 : rq->bio->bi_size;
 	if (rq->cmd_flags & REQ_RW)
-		set_bit(PC_WRITING, &pc->flags);
+		pc->flags |= 1UL << PC_WRITING;
 	pc->buffer = NULL;
 	pc->request_transfer = pc->buffer_size = blocks * floppy->block_size;
-	set_bit(PC_DMA_RECOMMENDED, &pc->flags);
+	pc->flags |= 1UL << PC_DMA_RECOMMENDED;
 }
 
 static void idefloppy_blockpc_cmd(idefloppy_floppy_t *floppy,
@@ -893,10 +896,10 @@ static void idefloppy_blockpc_cmd(idefloppy_floppy_t *floppy,
 	pc->rq = rq;
 	pc->b_count = rq->data_len;
 	if (rq->data_len && rq_data_dir(rq) == WRITE)
-		set_bit(PC_WRITING, &pc->flags);
+		pc->flags |= 1UL << PC_WRITING;
 	pc->buffer = rq->data;
 	if (rq->bio)
-		set_bit(PC_DMA_RECOMMENDED, &pc->flags);
+		pc->flags |= 1UL << PC_DMA_RECOMMENDED;
 
 	/*
 	 * possibly problematic, doesn't look like ide-floppy correctly handled
@@ -1035,7 +1038,7 @@ static int idefloppy_get_sfrp_bit(ide_drive_t *drive)
 	idefloppy_create_mode_sense_cmd(&pc, IDEFLOPPY_CAPABILITIES_PAGE,
 						 MODE_SENSE_CURRENT);
 
-	set_bit(PC_SUPPRESS_ERROR, &pc.flags);
+	pc.flags |= 1UL << PC_SUPPRESS_ERROR;
 	if (idefloppy_queue_pc_tail(drive, &pc))
 		return 1;
 
@@ -1078,7 +1081,7 @@ static int idefloppy_get_capacity(ide_drive_t *drive)
 		switch (pc.buffer[desc_start + 4] & 0x03) {
 		/* Clik! drive returns this instead of CAPACITY_CURRENT */
 		case CAPACITY_UNFORMATTED:
-			if (!test_bit(IDEFLOPPY_CLIK_DRIVE, &floppy->flags))
+			if (!((1UL << IDEFLOPPY_CLIK_DRIVE) & floppy->flags))
 				/*
 				 * If it is not a clik drive, break out
 				 * (maintains previous driver behaviour)
@@ -1126,7 +1129,7 @@ static int idefloppy_get_capacity(ide_drive_t *drive)
 	}
 
 	/* Clik! disk does not support get_flexible_disk_page */
-	if (!test_bit(IDEFLOPPY_CLIK_DRIVE, &floppy->flags))
+	if (!((1UL << IDEFLOPPY_CLIK_DRIVE) & floppy->flags))
 		(void) idefloppy_get_flexible_disk_page(drive);
 
 	set_capacity(floppy->disk, floppy->blocks * floppy->bs_factor);
@@ -1356,7 +1359,7 @@ static void idefloppy_setup(ide_drive_t *drive, idefloppy_floppy_t *floppy)
 	*((u16 *) &gcw) = drive->id->config;
 	floppy->pc = floppy->pc_stack;
 	if (gcw.drq_type == 1)
-		set_bit(IDEFLOPPY_DRQ_INTERRUPT, &floppy->flags);
+		floppy->flags |= 1UL << IDEFLOPPY_DRQ_INTERRUPT;
 
 	/*
 	 * We used to check revisions here. At this point however I'm giving up.
@@ -1369,7 +1372,7 @@ static void idefloppy_setup(ide_drive_t *drive, idefloppy_floppy_t *floppy)
 	 */
 
 	if (!strncmp(drive->id->model, "IOMEGA ZIP 100 ATAPI", 20)) {
-		set_bit(IDEFLOPPY_ZIP_DRIVE, &floppy->flags);
+		floppy->flags |= 1UL << IDEFLOPPY_ZIP_DRIVE;
 		/* This value will be visible in the /proc/ide/hdx/settings */
 		floppy->ticks = IDEFLOPPY_TICKS_DELAY;
 		blk_queue_max_sectors(drive->queue, 64);
@@ -1381,7 +1384,7 @@ static void idefloppy_setup(ide_drive_t *drive, idefloppy_floppy_t *floppy)
 	 */
 	if (strncmp(drive->id->model, "IOMEGA Clik!", 11) == 0) {
 		blk_queue_max_sectors(drive->queue, 64);
-		set_bit(IDEFLOPPY_CLIK_DRIVE, &floppy->flags);
+		floppy->flags |= 1UL << IDEFLOPPY_CLIK_DRIVE;
 	}
 
 	(void) idefloppy_get_capacity(drive);
@@ -1471,7 +1474,7 @@ static int idefloppy_open(struct inode *inode, struct file *filp)
 	floppy->openers++;
 
 	if (floppy->openers == 1) {
-		clear_bit(IDEFLOPPY_FORMAT_IN_PROGRESS, &floppy->flags);
+		floppy->flags &= (1UL << IDEFLOPPY_FORMAT_IN_PROGRESS) ^ ~0UL;
 		/* Just in case */
 
 		idefloppy_create_test_unit_ready_cmd(&pc);
@@ -1496,14 +1499,14 @@ static int idefloppy_open(struct inode *inode, struct file *filp)
 			ret = -EROFS;
 			goto out_put_floppy;
 		}
-		set_bit(IDEFLOPPY_MEDIA_CHANGED, &floppy->flags);
+		floppy->flags |= 1UL << IDEFLOPPY_MEDIA_CHANGED;
 		/* IOMEGA Clik! drives do not support lock/unlock commands */
-		if (!test_bit(IDEFLOPPY_CLIK_DRIVE, &floppy->flags)) {
+		if (!((1UL << IDEFLOPPY_CLIK_DRIVE) & floppy->flags)) {
 			idefloppy_create_prevent_cmd(&pc, 1);
 			(void) idefloppy_queue_pc_tail(drive, &pc);
 		}
 		check_disk_change(inode->i_bdev);
-	} else if (test_bit(IDEFLOPPY_FORMAT_IN_PROGRESS, &floppy->flags)) {
+	} else if ((1UL << IDEFLOPPY_FORMAT_IN_PROGRESS) & floppy->flags) {
 		ret = -EBUSY;
 		goto out_put_floppy;
 	}
@@ -1526,12 +1529,12 @@ static int idefloppy_release(struct inode *inode, struct file *filp)
 
 	if (floppy->openers == 1) {
 		/* IOMEGA Clik! drives do not support lock/unlock commands */
-		if (!test_bit(IDEFLOPPY_CLIK_DRIVE, &floppy->flags)) {
+		if (!((1UL << IDEFLOPPY_CLIK_DRIVE) & floppy->flags)) {
 			idefloppy_create_prevent_cmd(&pc, 0);
 			(void) idefloppy_queue_pc_tail(drive, &pc);
 		}
 
-		clear_bit(IDEFLOPPY_FORMAT_IN_PROGRESS, &floppy->flags);
+		floppy->flags &= (1UL << IDEFLOPPY_FORMAT_IN_PROGRESS) ^ ~0UL;
 	}
 
 	floppy->openers--;
@@ -1560,7 +1563,7 @@ static int idefloppy_lockdoor(idefloppy_floppy_t *floppy, idefloppy_pc_t *pc,
 
 	/* The IOMEGA Clik! Drive doesn't support this command -
 	 * no room for an eject mechanism */
-	if (!test_bit(IDEFLOPPY_CLIK_DRIVE, &floppy->flags)) {
+	if (!((1UL << IDEFLOPPY_CLIK_DRIVE) & floppy->flags)) {
 		int prevent = (arg) ? 1 : 0;
 
 		if (cmd == CDROMEJECT)
@@ -1586,11 +1589,11 @@ static int idefloppy_format_unit(idefloppy_floppy_t *floppy, unsigned long arg)
 
 	if (floppy->openers > 1) {
 		/* Don't format if someone is using the disk */
-		clear_bit(IDEFLOPPY_FORMAT_IN_PROGRESS, &floppy->flags);
+		floppy->flags &= (1UL << IDEFLOPPY_FORMAT_IN_PROGRESS) ^ ~0UL;
 		return -EBUSY;
 	}
 
-	set_bit(IDEFLOPPY_FORMAT_IN_PROGRESS, &floppy->flags);
+	floppy->flags |= 1UL << IDEFLOPPY_FORMAT_IN_PROGRESS;
 
 	/*
 	 * Send ATAPI_FORMAT_UNIT to the drive.
@@ -1624,7 +1627,7 @@ static int idefloppy_format_unit(idefloppy_floppy_t *floppy, unsigned long arg)
 
 out:
 	if (err)
-		clear_bit(IDEFLOPPY_FORMAT_IN_PROGRESS, &floppy->flags);
+		floppy->flags &= (1UL << IDEFLOPPY_FORMAT_IN_PROGRESS) ^ ~0UL;
 	return err;
 }
 
@@ -1661,13 +1664,18 @@ static int idefloppy_media_changed(struct gendisk *disk)
 {
 	struct ide_floppy_obj *floppy = ide_floppy_g(disk);
 	ide_drive_t *drive = floppy->drive;
+	int ret;
 
 	/* do not scan partitions twice if this is a removable device */
 	if (drive->attach) {
 		drive->attach = 0;
 		return 0;
 	}
-	return test_and_clear_bit(IDEFLOPPY_MEDIA_CHANGED, &floppy->flags);
+	/* test_and_clear_bit */
+	ret = (1UL << IDEFLOPPY_MEDIA_CHANGED) & floppy->flags;
+	floppy->flags &= (1UL << IDEFLOPPY_MEDIA_CHANGED) ^ ~0UL;
+
+	return ret;
 }
 
 static int idefloppy_revalidate_disk(struct gendisk *disk)
-- 
1.5.3.7

