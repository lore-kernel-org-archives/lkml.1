Return-Path: <linux-kernel-owner+w=401wt.eu-S1757465AbYLPHja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757465AbYLPHja (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 02:39:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753918AbYLPHgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 02:36:33 -0500
Received: from fk-out-0910.google.com ([209.85.128.185]:17024 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbYLPHgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 02:36:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=Jyz6B2wUzAXu/PE6CI1rKc4rO8LyRdY7R0wAp6Fl8y0jntg1C7Y7HW+A8dRKl21vxn
         qm1Vyy/cpdtlhIeJnXMddZcrSViDX6YDPjSYaRYus0rbXp3iJJwPJDPy//fjrBoOY4AB
         v4I65sq0Y46Q5RZW1TflBpUH9Zz2LQNl0FF4U=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 2/9] ide-atapi: replace pc->flags with drive->pc_flags
Date: Tue, 16 Dec 2008 08:36:02 +0100
Message-Id: <1229412969-3552-3-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1229412969-3552-1-git-send-email-petkovbb@gmail.com>
References: <1229412969-3552-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functionality change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-atapi.c        |   43 ++++++++++---------
 drivers/ide/ide-floppy.c       |   31 +++++++------
 drivers/ide/ide-floppy.h       |    4 +-
 drivers/ide/ide-floppy_ioctl.c |   16 ++++---
 drivers/ide/ide-tape.c         |   92 +++++++++++++++++++++-------------------
 include/linux/ide.h            |    5 ++-
 6 files changed, 103 insertions(+), 88 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index 2f0d5e7..ec29133 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -117,11 +117,12 @@ int ide_io_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
 }
 EXPORT_SYMBOL_GPL(ide_io_buffers);
 
-void ide_init_pc(struct ide_atapi_pc *pc)
+void ide_init_pc(ide_drive_t *drive, struct ide_atapi_pc *pc)
 {
 	memset(pc, 0, sizeof(*pc));
 	pc->buf = pc->pc_buf;
 	pc->buf_size = IDE_PC_BUFFER_SIZE;
+	drive->pc_flags = 0;
 }
 EXPORT_SYMBOL_GPL(ide_init_pc);
 
@@ -171,7 +172,7 @@ int ide_do_test_unit_ready(ide_drive_t *drive, struct gendisk *disk)
 {
 	struct ide_atapi_pc pc;
 
-	ide_init_pc(&pc);
+	ide_init_pc(drive, &pc);
 	pc.c[0] = TEST_UNIT_READY;
 
 	return ide_queue_pc_tail(drive, disk, &pc);
@@ -182,12 +183,12 @@ int ide_do_start_stop(ide_drive_t *drive, struct gendisk *disk, int start)
 {
 	struct ide_atapi_pc pc;
 
-	ide_init_pc(&pc);
+	ide_init_pc(drive, &pc);
 	pc.c[0] = START_STOP;
 	pc.c[4] = start;
 
 	if (drive->media == ide_tape)
-		pc.flags |= PC_FLAG_WAIT_FOR_DSC;
+		drive->pc_flags |= PC_FLAG_WAIT_FOR_DSC;
 
 	return ide_queue_pc_tail(drive, disk, &pc);
 }
@@ -200,7 +201,7 @@ int ide_set_media_lock(ide_drive_t *drive, struct gendisk *disk, int on)
 	if ((drive->dev_flags & IDE_DFLAG_DOORLOCKING) == 0)
 		return 0;
 
-	ide_init_pc(&pc);
+	ide_init_pc(drive, &pc);
 	pc.c[0] = ALLOW_MEDIUM_REMOVAL;
 	pc.c[4] = on;
 
@@ -210,7 +211,7 @@ EXPORT_SYMBOL_GPL(ide_set_media_lock);
 
 void ide_create_request_sense_cmd(ide_drive_t *drive, struct ide_atapi_pc *pc)
 {
-	ide_init_pc(pc);
+	ide_init_pc(drive, pc);
 	pc->c[0] = REQUEST_SENSE;
 	if (drive->media == ide_floppy) {
 		pc->c[4] = 255;
@@ -308,7 +309,7 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 	timeout = (drive->media == ide_floppy) ? WAIT_FLOPPY_CMD
 					       : WAIT_TAPE_CMD;
 
-	if (pc->flags & PC_FLAG_TIMEDOUT) {
+	if (drive->pc_flags & PC_FLAG_TIMEDOUT) {
 		drive->pc_callback(drive, 0);
 		return ide_stopped;
 	}
@@ -316,14 +317,14 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 	/* Clear the interrupt */
 	stat = tp_ops->read_status(hwif);
 
-	if (pc->flags & PC_FLAG_DMA_IN_PROGRESS) {
+	if (drive->pc_flags & PC_FLAG_DMA_IN_PROGRESS) {
 		if (hwif->dma_ops->dma_end(drive) ||
 		    (drive->media == ide_tape && (stat & ATA_ERR))) {
 			if (drive->media == ide_floppy)
 				printk(KERN_ERR "%s: DMA %s error\n",
 					drive->name, rq_data_dir(pc->rq)
 						     ? "write" : "read");
-			pc->flags |= PC_FLAG_DMA_ERROR;
+			drive->pc_flags |= PC_FLAG_DMA_ERROR;
 		} else {
 			pc->xferred = pc->req_xfer;
 			if (drive->pc_update_buffers)
@@ -337,7 +338,7 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 		debug_log("Packet command completed, %d bytes transferred\n",
 			  pc->xferred);
 
-		pc->flags &= ~PC_FLAG_DMA_IN_PROGRESS;
+		drive->pc_flags &= ~PC_FLAG_DMA_IN_PROGRESS;
 
 		local_irq_enable_in_hardirq();
 
@@ -345,7 +346,7 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 		    (stat & ATA_ERR) && rq->cmd[0] == REQUEST_SENSE)
 			stat &= ~ATA_ERR;
 
-		if ((stat & ATA_ERR) || (pc->flags & PC_FLAG_DMA_ERROR)) {
+		if ((stat & ATA_ERR) || (drive->pc_flags & PC_FLAG_DMA_ERROR)) {
 			/* Error detected */
 			debug_log("%s: I/O error\n", drive->name);
 
@@ -368,7 +369,8 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 		}
 		pc->error = 0;
 
-		if ((pc->flags & PC_FLAG_WAIT_FOR_DSC) && (stat & ATA_DSC) == 0)
+		if ((drive->pc_flags & PC_FLAG_WAIT_FOR_DSC) &&
+		    (stat & ATA_DSC) == 0)
 			dsc = 1;
 
 		/* Command finished - Call the callback function */
@@ -377,8 +379,8 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 		return ide_stopped;
 	}
 
-	if (pc->flags & PC_FLAG_DMA_IN_PROGRESS) {
-		pc->flags &= ~PC_FLAG_DMA_IN_PROGRESS;
+	if (drive->pc_flags & PC_FLAG_DMA_IN_PROGRESS) {
+		drive->pc_flags &= ~PC_FLAG_DMA_IN_PROGRESS;
 		printk(KERN_ERR "%s: The device wants to issue more interrupts "
 				"in DMA mode\n", drive->name);
 		ide_dma_off(drive);
@@ -489,7 +491,6 @@ static int ide_delayed_transfer_pc(ide_drive_t *drive)
 
 static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
 {
-	struct ide_atapi_pc *pc = drive->pc;
 	ide_hwif_t *hwif = drive->hwif;
 	struct request *rq = hwif->hwgroup->rq;
 	ide_expiry_t *expiry;
@@ -536,8 +537,8 @@ static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
 	ide_set_handler(drive, ide_pc_intr, timeout, expiry);
 
 	/* Begin DMA, if necessary */
-	if (pc->flags & PC_FLAG_DMA_OK) {
-		pc->flags |= PC_FLAG_DMA_IN_PROGRESS;
+	if (drive->pc_flags & PC_FLAG_DMA_OK) {
+		drive->pc_flags |= PC_FLAG_DMA_IN_PROGRESS;
 		hwif->dma_ops->dma_start(drive);
 	}
 
@@ -571,18 +572,18 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive, unsigned int timeout)
 				min(pc->req_xfer, 63 * 1024));
 	}
 
-	if (pc->flags & PC_FLAG_DMA_ERROR) {
-		pc->flags &= ~PC_FLAG_DMA_ERROR;
+	if (drive->pc_flags & PC_FLAG_DMA_ERROR) {
+		drive->pc_flags &= ~PC_FLAG_DMA_ERROR;
 		ide_dma_off(drive);
 	}
 
-	if (((pc->flags & PC_FLAG_DMA_OK) &&
+	if (((drive->pc_flags & PC_FLAG_DMA_OK) &&
 		(drive->dev_flags & IDE_DFLAG_USING_DMA)) ||
 	    drive->dma)
 		drive->dma = !hwif->dma_ops->dma_setup(drive);
 
 	if (!drive->dma)
-		pc->flags &= ~PC_FLAG_DMA_OK;
+		drive->pc_flags &= ~PC_FLAG_DMA_OK;
 
 	ide_pktcmd_tf_load(drive, tf_flags, bcount, drive->dma);
 
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 3ebe75a..44e5b8a 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -183,7 +183,7 @@ static ide_startstop_t idefloppy_issue_pc(ide_drive_t *drive,
 	drive->pc = pc;
 
 	if (pc->retries > IDEFLOPPY_MAX_PC_RETRIES) {
-		if (!(pc->flags & PC_FLAG_SUPPRESS_ERROR))
+		if (!(drive->pc_flags & PC_FLAG_SUPPRESS_ERROR))
 			ide_floppy_report_error(floppy, pc);
 		/* Giving up */
 		pc->error = IDEFLOPPY_ERROR_GENERAL;
@@ -200,9 +200,10 @@ static ide_startstop_t idefloppy_issue_pc(ide_drive_t *drive,
 	return ide_issue_pc(drive, WAIT_FLOPPY_CMD);
 }
 
-void ide_floppy_create_read_capacity_cmd(struct ide_atapi_pc *pc)
+void ide_floppy_create_read_capacity_cmd(ide_drive_t *drive,
+					 struct ide_atapi_pc *pc)
 {
-	ide_init_pc(pc);
+	ide_init_pc(drive, pc);
 	pc->c[0] = GPCMD_READ_FORMAT_CAPACITIES;
 	pc->c[7] = 255;
 	pc->c[8] = 255;
@@ -210,11 +211,12 @@ void ide_floppy_create_read_capacity_cmd(struct ide_atapi_pc *pc)
 }
 
 /* A mode sense command is used to "sense" floppy parameters. */
-void ide_floppy_create_mode_sense_cmd(struct ide_atapi_pc *pc, u8 page_code)
+void ide_floppy_create_mode_sense_cmd(ide_drive_t *drive,
+				      struct ide_atapi_pc *pc, u8 page_code)
 {
 	u16 length = 8; /* sizeof(Mode Parameter Header) = 8 Bytes */
 
-	ide_init_pc(pc);
+	ide_init_pc(drive, pc);
 	pc->c[0] = GPCMD_MODE_SENSE_10;
 	pc->c[1] = 0;
 	pc->c[2] = page_code;
@@ -245,7 +247,7 @@ static void idefloppy_create_rw_cmd(ide_drive_t *drive,
 	ide_debug_log(IDE_DBG_FUNC, "%s: block: %d, blocks: %d\n", __func__,
 		      block, blocks);
 
-	ide_init_pc(pc);
+	ide_init_pc(drive, pc);
 	pc->c[0] = cmd == READ ? GPCMD_READ_10 : GPCMD_WRITE_10;
 	put_unaligned(cpu_to_be16(blocks), (unsigned short *)&pc->c[7]);
 	put_unaligned(cpu_to_be32(block), (unsigned int *) &pc->c[2]);
@@ -256,19 +258,19 @@ static void idefloppy_create_rw_cmd(ide_drive_t *drive,
 	pc->b_count = 0;
 	pc->buf = NULL;
 	pc->req_xfer = pc->buf_size = blocks * floppy->block_size;
-	pc->flags |= PC_FLAG_DMA_OK;
+	drive->pc_flags |= PC_FLAG_DMA_OK;
 }
 
-static void idefloppy_blockpc_cmd(struct ide_disk_obj *floppy,
-		struct ide_atapi_pc *pc, struct request *rq)
+static void idefloppy_blockpc_cmd(ide_drive_t *drive, struct ide_atapi_pc *pc,
+				  struct request *rq)
 {
-	ide_init_pc(pc);
+	ide_init_pc(drive, pc);
 	memcpy(pc->c, rq->cmd, sizeof(pc->c));
 	pc->rq = rq;
 	pc->b_count = 0;
 	pc->buf = rq->data;
 	if (rq->bio)
-		pc->flags |= PC_FLAG_DMA_OK;
+		drive->pc_flags |= PC_FLAG_DMA_OK;
 	/*
 	 * possibly problematic, doesn't look like ide-floppy correctly
 	 * handled scattered requests if dma fails...
@@ -316,7 +318,7 @@ static ide_startstop_t ide_floppy_do_request(ide_drive_t *drive,
 		pc = (struct ide_atapi_pc *) rq->buffer;
 	} else if (blk_pc_request(rq)) {
 		pc = &floppy->queued_pc;
-		idefloppy_blockpc_cmd(floppy, pc, rq);
+		idefloppy_blockpc_cmd(drive, pc, rq);
 	} else {
 		blk_dump_rq_flags(rq, PFX "unsupported command in queue");
 		ide_floppy_end_request(drive, 0, 0);
@@ -348,7 +350,8 @@ static int ide_floppy_get_flexible_disk_page(ide_drive_t *drive,
 	u16 transfer_rate, sector_size, cyls, rpm;
 	u8 heads, sectors;
 
-	ide_floppy_create_mode_sense_cmd(pc, IDEFLOPPY_FLEXIBLE_DISK_PAGE);
+	ide_floppy_create_mode_sense_cmd(drive, pc,
+					 IDEFLOPPY_FLEXIBLE_DISK_PAGE);
 
 	if (ide_queue_pc_tail(drive, disk, pc)) {
 		printk(KERN_ERR PFX "Can't get flexible disk page params\n");
@@ -416,7 +419,7 @@ static int ide_floppy_get_capacity(ide_drive_t *drive)
 	floppy->bs_factor = 1;
 	drive->capacity64 = 0;
 
-	ide_floppy_create_read_capacity_cmd(&pc);
+	ide_floppy_create_read_capacity_cmd(drive, &pc);
 	if (ide_queue_pc_tail(drive, disk, &pc)) {
 		printk(KERN_ERR PFX "Can't get floppy parameters\n");
 		return 1;
diff --git a/drivers/ide/ide-floppy.h b/drivers/ide/ide-floppy.h
index 6dd2beb..cbc7bbe 100644
--- a/drivers/ide/ide-floppy.h
+++ b/drivers/ide/ide-floppy.h
@@ -19,8 +19,8 @@
 
 /* ide-floppy.c */
 extern const struct ide_disk_ops ide_atapi_disk_ops;
-void ide_floppy_create_mode_sense_cmd(struct ide_atapi_pc *, u8);
-void ide_floppy_create_read_capacity_cmd(struct ide_atapi_pc *);
+void ide_floppy_create_mode_sense_cmd(ide_drive_t *, struct ide_atapi_pc *, u8);
+void ide_floppy_create_read_capacity_cmd(ide_drive_t *, struct ide_atapi_pc *);
 
 /* ide-floppy_ioctl.c */
 int ide_floppy_ioctl(ide_drive_t *, struct block_device *, fmode_t,
diff --git a/drivers/ide/ide-floppy_ioctl.c b/drivers/ide/ide-floppy_ioctl.c
index 513f651..88e14e4 100644
--- a/drivers/ide/ide-floppy_ioctl.c
+++ b/drivers/ide/ide-floppy_ioctl.c
@@ -46,7 +46,7 @@ static int ide_floppy_get_format_capacities(ide_drive_t *drive,
 	if (u_array_size <= 0)
 		return -EINVAL;
 
-	ide_floppy_create_read_capacity_cmd(pc);
+	ide_floppy_create_read_capacity_cmd(drive, pc);
 	if (ide_queue_pc_tail(drive, floppy->disk, pc)) {
 		printk(KERN_ERR "ide-floppy: Can't get floppy parameters\n");
 		return -EIO;
@@ -91,10 +91,11 @@ static int ide_floppy_get_format_capacities(ide_drive_t *drive,
 	return 0;
 }
 
-static void ide_floppy_create_format_unit_cmd(struct ide_atapi_pc *pc, int b,
-		int l, int flags)
+static void ide_floppy_create_format_unit_cmd(ide_drive_t *drive,
+					      struct ide_atapi_pc *pc, int b,
+					      int l, int flags)
 {
-	ide_init_pc(pc);
+	ide_init_pc(drive, pc);
 	pc->c[0] = GPCMD_FORMAT_UNIT;
 	pc->c[1] = 0x17;
 
@@ -117,8 +118,9 @@ static int ide_floppy_get_sfrp_bit(ide_drive_t *drive, struct ide_atapi_pc *pc)
 
 	drive->atapi_flags &= ~IDE_AFLAG_SRFP;
 
-	ide_floppy_create_mode_sense_cmd(pc, IDEFLOPPY_CAPABILITIES_PAGE);
-	pc->flags |= PC_FLAG_SUPPRESS_ERROR;
+	ide_floppy_create_mode_sense_cmd(drive, pc,
+					 IDEFLOPPY_CAPABILITIES_PAGE);
+	drive->pc_flags |= PC_FLAG_SUPPRESS_ERROR;
 
 	if (ide_queue_pc_tail(drive, floppy->disk, pc))
 		return 1;
@@ -166,7 +168,7 @@ static int ide_floppy_format_unit(ide_drive_t *drive, struct ide_atapi_pc *pc,
 	}
 
 	ide_floppy_get_sfrp_bit(drive, pc);
-	ide_floppy_create_format_unit_cmd(pc, blocks, length, flags);
+	ide_floppy_create_format_unit_cmd(drive, pc, blocks, length, flags);
 
 	if (ide_queue_pc_tail(drive, floppy->disk, pc))
 		err = -EIO;
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index ba89d6a..caccb82 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -411,7 +411,7 @@ static void idetape_analyze_error(ide_drive_t *drive, u8 *sense)
 		 pc->c[0], tape->sense_key, tape->asc, tape->ascq);
 
 	/* Correct pc->xferred by asking the tape.	 */
-	if (pc->flags & PC_FLAG_DMA_ERROR) {
+	if (drive->pc_flags & PC_FLAG_DMA_ERROR) {
 		pc->xferred = pc->req_xfer -
 			tape->blk_size *
 			get_unaligned_be32(&sense[3]);
@@ -430,26 +430,26 @@ static void idetape_analyze_error(ide_drive_t *drive, u8 *sense)
 			/* don't report an error, everything's ok */
 			pc->error = 0;
 			/* don't retry read/write */
-			pc->flags |= PC_FLAG_ABORT;
+			drive->pc_flags |= PC_FLAG_ABORT;
 		}
 	}
 	if (pc->c[0] == READ_6 && (sense[2] & 0x80)) {
 		pc->error = IDETAPE_ERROR_FILEMARK;
-		pc->flags |= PC_FLAG_ABORT;
+		drive->pc_flags |= PC_FLAG_ABORT;
 	}
 	if (pc->c[0] == WRITE_6) {
 		if ((sense[2] & 0x40) || (tape->sense_key == 0xd
 		     && tape->asc == 0x0 && tape->ascq == 0x2)) {
 			pc->error = IDETAPE_ERROR_EOD;
-			pc->flags |= PC_FLAG_ABORT;
+			drive->pc_flags |= PC_FLAG_ABORT;
 		}
 	}
 	if (pc->c[0] == READ_6 || pc->c[0] == WRITE_6) {
 		if (tape->sense_key == 8) {
 			pc->error = IDETAPE_ERROR_EOD;
-			pc->flags |= PC_FLAG_ABORT;
+			drive->pc_flags |= PC_FLAG_ABORT;
 		}
-		if (!(pc->flags & PC_FLAG_ABORT) &&
+		if (!(drive->pc_flags & PC_FLAG_ABORT) &&
 		    pc->xferred)
 			pc->retries = IDETAPE_MAX_PC_RETRIES + 1;
 	}
@@ -667,13 +667,13 @@ static ide_startstop_t idetape_issue_pc(ide_drive_t *drive,
 	drive->pc = pc;
 
 	if (pc->retries > IDETAPE_MAX_PC_RETRIES ||
-		(pc->flags & PC_FLAG_ABORT)) {
+		(drive->pc_flags & PC_FLAG_ABORT)) {
 		/*
 		 * We will "abort" retrying a packet command in case legitimate
 		 * error code was received (crossing a filemark, or end of the
 		 * media, for example).
 		 */
-		if (!(pc->flags & PC_FLAG_ABORT)) {
+		if (!(drive->pc_flags & PC_FLAG_ABORT)) {
 			if (!(pc->c[0] == TEST_UNIT_READY &&
 			      tape->sense_key == 2 && tape->asc == 4 &&
 			     (tape->ascq == 1 || tape->ascq == 8))) {
@@ -699,9 +699,11 @@ static ide_startstop_t idetape_issue_pc(ide_drive_t *drive,
 }
 
 /* A mode sense command is used to "sense" tape parameters. */
-static void idetape_create_mode_sense_cmd(struct ide_atapi_pc *pc, u8 page_code)
+static void idetape_create_mode_sense_cmd(ide_drive_t *drive,
+					  struct ide_atapi_pc *pc,
+					  u8 page_code)
 {
-	ide_init_pc(pc);
+	ide_init_pc(drive, pc);
 	pc->c[0] = MODE_SENSE;
 	if (page_code != IDETAPE_BLOCK_DESCRIPTOR)
 		/* DBD = 1 - Don't return block descriptors */
@@ -753,14 +755,14 @@ static ide_startstop_t idetape_media_access_finished(ide_drive_t *drive)
 	return ide_stopped;
 }
 
-static void ide_tape_create_rw_cmd(idetape_tape_t *tape,
-				   struct ide_atapi_pc *pc, struct request *rq,
-				   u8 opcode)
+static void ide_tape_create_rw_cmd(ide_drive_t *drive, struct ide_atapi_pc *pc,
+				   struct request *rq, u8 opcode)
 {
+	idetape_tape_t *tape = drive->driver_data;
 	struct idetape_bh *bh = (struct idetape_bh *)rq->special;
 	unsigned int length = rq->current_nr_sectors;
 
-	ide_init_pc(pc);
+	ide_init_pc(drive, pc);
 	put_unaligned(cpu_to_be32(length), (unsigned int *) &pc->c[1]);
 	pc->c[1] = 1;
 	pc->bh = bh;
@@ -768,7 +770,7 @@ static void ide_tape_create_rw_cmd(idetape_tape_t *tape,
 	pc->buf_size = length * tape->blk_size;
 	pc->req_xfer = pc->buf_size;
 	if (pc->req_xfer == tape->buffer_size)
-		pc->flags |= PC_FLAG_DMA_OK;
+		drive->pc_flags |= PC_FLAG_DMA_OK;
 
 	if (opcode == READ_6) {
 		pc->c[0] = READ_6;
@@ -859,12 +861,12 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 	}
 	if (rq->cmd[13] & REQ_IDETAPE_READ) {
 		pc = &tape->queued_pc;
-		ide_tape_create_rw_cmd(tape, pc, rq, READ_6);
+		ide_tape_create_rw_cmd(drive, pc, rq, READ_6);
 		goto out;
 	}
 	if (rq->cmd[13] & REQ_IDETAPE_WRITE) {
 		pc = &tape->queued_pc;
-		ide_tape_create_rw_cmd(tape, pc, rq, WRITE_6);
+		ide_tape_create_rw_cmd(drive, pc, rq, WRITE_6);
 		goto out;
 	}
 	if (rq->cmd[13] & REQ_IDETAPE_PC1) {
@@ -1050,10 +1052,10 @@ static void idetape_init_merge_buffer(idetape_tape_t *tape)
 static void idetape_create_write_filemark_cmd(ide_drive_t *drive,
 		struct ide_atapi_pc *pc, int write_filemark)
 {
-	ide_init_pc(pc);
+	ide_init_pc(drive, pc);
 	pc->c[0] = WRITE_FILEMARKS;
 	pc->c[4] = write_filemark;
-	pc->flags |= PC_FLAG_WAIT_FOR_DSC;
+	drive->pc_flags |= PC_FLAG_WAIT_FOR_DSC;
 }
 
 static int idetape_wait_ready(ide_drive_t *drive, unsigned long timeout)
@@ -1098,9 +1100,10 @@ static int idetape_flush_tape_buffers(ide_drive_t *drive)
 	return 0;
 }
 
-static void idetape_create_read_position_cmd(struct ide_atapi_pc *pc)
+static void idetape_create_read_position_cmd(ide_drive_t *drive,
+					     struct ide_atapi_pc *pc)
 {
-	ide_init_pc(pc);
+	ide_init_pc(drive, pc);
 	pc->c[0] = READ_POSITION;
 	pc->req_xfer = 20;
 }
@@ -1113,7 +1116,7 @@ static int idetape_read_position(ide_drive_t *drive)
 
 	debug_log(DBG_PROCS, "Enter %s\n", __func__);
 
-	idetape_create_read_position_cmd(&pc);
+	idetape_create_read_position_cmd(drive, &pc);
 	if (ide_queue_pc_tail(drive, tape->disk, &pc))
 		return -1;
 	position = tape->first_frame;
@@ -1124,12 +1127,12 @@ static void idetape_create_locate_cmd(ide_drive_t *drive,
 		struct ide_atapi_pc *pc,
 		unsigned int block, u8 partition, int skip)
 {
-	ide_init_pc(pc);
+	ide_init_pc(drive, pc);
 	pc->c[0] = POSITION_TO_ELEMENT;
 	pc->c[1] = 2;
 	put_unaligned(cpu_to_be32(block), (unsigned int *) &pc->c[3]);
 	pc->c[8] = partition;
-	pc->flags |= PC_FLAG_WAIT_FOR_DSC;
+	drive->pc_flags |= PC_FLAG_WAIT_FOR_DSC;
 }
 
 static void __ide_tape_discard_merge_buffer(ide_drive_t *drive)
@@ -1171,7 +1174,7 @@ static int idetape_position_tape(ide_drive_t *drive, unsigned int block,
 	if (retval)
 		return (retval);
 
-	idetape_create_read_position_cmd(&pc);
+	idetape_create_read_position_cmd(drive, &pc);
 	return ide_queue_pc_tail(drive, disk, &pc);
 }
 
@@ -1230,37 +1233,40 @@ static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int blocks,
 	return ret;
 }
 
-static void idetape_create_inquiry_cmd(struct ide_atapi_pc *pc)
+static void idetape_create_inquiry_cmd(ide_drive_t *drive,
+				       struct ide_atapi_pc *pc)
 {
-	ide_init_pc(pc);
+	ide_init_pc(drive, pc);
 	pc->c[0] = INQUIRY;
 	pc->c[4] = 254;
 	pc->req_xfer = 254;
 }
 
 static void idetape_create_rewind_cmd(ide_drive_t *drive,
-		struct ide_atapi_pc *pc)
+				      struct ide_atapi_pc *pc)
 {
-	ide_init_pc(pc);
+	ide_init_pc(drive, pc);
 	pc->c[0] = REZERO_UNIT;
-	pc->flags |= PC_FLAG_WAIT_FOR_DSC;
+	drive->pc_flags |= PC_FLAG_WAIT_FOR_DSC;
 }
 
-static void idetape_create_erase_cmd(struct ide_atapi_pc *pc)
+static void idetape_create_erase_cmd(ide_drive_t *drive,
+				     struct ide_atapi_pc *pc)
 {
-	ide_init_pc(pc);
+	ide_init_pc(drive, pc);
 	pc->c[0] = ERASE;
 	pc->c[1] = 1;
-	pc->flags |= PC_FLAG_WAIT_FOR_DSC;
+	drive->pc_flags |= PC_FLAG_WAIT_FOR_DSC;
 }
 
-static void idetape_create_space_cmd(struct ide_atapi_pc *pc, int count, u8 cmd)
+static void idetape_create_space_cmd(ide_drive_t *drive,
+				     struct ide_atapi_pc *pc, int count, u8 cmd)
 {
-	ide_init_pc(pc);
+	ide_init_pc(drive, pc);
 	pc->c[0] = SPACE;
 	put_unaligned(cpu_to_be32(count), (unsigned int *) &pc->c[1]);
 	pc->c[1] = cmd;
-	pc->flags |= PC_FLAG_WAIT_FOR_DSC;
+	drive->pc_flags |= PC_FLAG_WAIT_FOR_DSC;
 }
 
 /* Queue up a character device originated write request. */
@@ -1431,7 +1437,7 @@ static int idetape_rewind_tape(ide_drive_t *drive)
 	if (retval)
 		return retval;
 
-	idetape_create_read_position_cmd(&pc);
+	idetape_create_read_position_cmd(drive, &pc);
 	retval = ide_queue_pc_tail(drive, disk, &pc);
 	if (retval)
 		return retval;
@@ -1498,7 +1504,7 @@ static int idetape_space_over_filemarks(ide_drive_t *drive, short mt_op,
 	switch (mt_op) {
 	case MTFSF:
 	case MTBSF:
-		idetape_create_space_cmd(&pc, mt_count - count,
+		idetape_create_space_cmd(drive, &pc, mt_count - count,
 					 IDETAPE_SPACE_OVER_FILEMARK);
 		return ide_queue_pc_tail(drive, disk, &pc);
 	case MTFSFM:
@@ -1778,11 +1784,11 @@ static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
 		return ide_do_start_stop(drive, disk,
 			IDETAPE_LU_RETENSION_MASK | IDETAPE_LU_LOAD_MASK);
 	case MTEOM:
-		idetape_create_space_cmd(&pc, 0, IDETAPE_SPACE_TO_EOD);
+		idetape_create_space_cmd(drive, &pc, 0, IDETAPE_SPACE_TO_EOD);
 		return ide_queue_pc_tail(drive, disk, &pc);
 	case MTERASE:
 		(void)idetape_rewind_tape(drive);
-		idetape_create_erase_cmd(&pc);
+		idetape_create_erase_cmd(drive, &pc);
 		return ide_queue_pc_tail(drive, disk, &pc);
 	case MTSETBLK:
 		if (mt_count) {
@@ -1891,7 +1897,7 @@ static void ide_tape_get_bsize_from_bdesc(ide_drive_t *drive)
 	idetape_tape_t *tape = drive->driver_data;
 	struct ide_atapi_pc pc;
 
-	idetape_create_mode_sense_cmd(&pc, IDETAPE_BLOCK_DESCRIPTOR);
+	idetape_create_mode_sense_cmd(drive, &pc, IDETAPE_BLOCK_DESCRIPTOR);
 	if (ide_queue_pc_tail(drive, tape->disk, &pc)) {
 		printk(KERN_ERR "ide-tape: Can't get block descriptor\n");
 		if (tape->blk_size == 0) {
@@ -2043,7 +2049,7 @@ static void idetape_get_inquiry_results(ide_drive_t *drive)
 	struct ide_atapi_pc pc;
 	char fw_rev[4], vendor_id[8], product_id[16];
 
-	idetape_create_inquiry_cmd(&pc);
+	idetape_create_inquiry_cmd(drive, &pc);
 	if (ide_queue_pc_tail(drive, tape->disk, &pc)) {
 		printk(KERN_ERR "ide-tape: %s: can't get INQUIRY results\n",
 				tape->name);
@@ -2072,7 +2078,7 @@ static void idetape_get_mode_sense_results(ide_drive_t *drive)
 	u8 *caps;
 	u8 speed, max_speed;
 
-	idetape_create_mode_sense_cmd(&pc, IDETAPE_CAPABILITIES_PAGE);
+	idetape_create_mode_sense_cmd(drive, &pc, IDETAPE_CAPABILITIES_PAGE);
 	if (ide_queue_pc_tail(drive, tape->disk, &pc)) {
 		printk(KERN_ERR "ide-tape: Can't get tape parameters - assuming"
 				" some default values\n");
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 2041073..57afe1f 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -654,6 +654,9 @@ struct ide_drive_s {
 	/* current packet command */
 	struct ide_atapi_pc *pc;
 
+	/* atapi pc flags: temporary */
+	unsigned long pc_flags;
+
 	/* callback for packet commands */
 	void (*pc_callback)(struct ide_drive_s *, int);
 
@@ -1215,7 +1218,7 @@ void ide_pktcmd_tf_load(ide_drive_t *, u32, u16, u8);
 
 int ide_check_atapi_device(ide_drive_t *, const char *);
 
-void ide_init_pc(struct ide_atapi_pc *);
+void ide_init_pc(ide_drive_t *, struct ide_atapi_pc *);
 
 /* Disk head parking */
 extern wait_queue_head_t ide_park_wq;
-- 
1.6.0.4

