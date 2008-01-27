Return-Path: <linux-kernel-owner+w=401wt.eu-S1760724AbYA0J72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760724AbYA0J72 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 04:59:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756369AbYA0JuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 04:50:24 -0500
Received: from [212.23.103.76] ([212.23.103.76]:59290 "EHLO gollum.tnic"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756764AbYA0JuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 04:50:06 -0500
From: Borislav Petkov <petkovbb@gmail.com>
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>
Subject: [PATCH 30/32] ide-tape: remove atomic test/set macros
Date: Sun, 27 Jan 2008 10:48:18 +0100
Message-Id: <1201427300-3954-25-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1201427300-3954-1-git-send-email-petkovbb@gmail.com>
References: <1201427300-3954-1-git-send-email-petkovbb@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bbpetkov@yahoo.de>

Also remove flag IDETAPE_READ_ERROR since it is unused.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
---
 drivers/ide/ide-tape.c |  222 +++++++++++++++++++++++++-----------------------
 1 files changed, 117 insertions(+), 105 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index cfb26d9..c22d7f6 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -204,25 +204,24 @@ typedef struct idetape_packet_command_s {
 	ide_startstop_t (*callback) (ide_drive_t *);
 	u8 pc_buffer[IDETAPE_PC_BUFFER_SIZE];	/* Temporary buffer */
 
-	/* Status/Action bit flags: long for set_bit */
-	unsigned long flags;
+	unsigned int flags;
 } idetape_pc_t;
 
-/*
- *	Packet command flag bits.
- */
-/* Set when an error is considered normal - We won't retry */
-#define	PC_ABORT			0
-/* 1 When polling for DSC on a media access command */
-#define PC_WAIT_FOR_DSC			1
-/* 1 when we prefer to use DMA if possible */
-#define PC_DMA_RECOMMENDED		2
-/* 1 while DMA in progress */
-#define	PC_DMA_IN_PROGRESS		3
-/* 1 when encountered problem during DMA */
-#define	PC_DMA_ERROR			4
-/* Data direction */
-#define	PC_WRITING			5
+/* Packet command flag bits. */
+enum {
+	/* Set when an error is considered normal - We won't retry */
+	PC_FL_ABORT		= (1 << 0),
+	/* 1 When polling for DSC on a media access command */
+	PC_FL_WAIT_FOR_DSC	= (1 << 1),
+	/* 1 when we prefer to use DMA if possible */
+	PC_FL_DMA_RECOMMENDED	= (1 << 2),
+	/* 1 while DMA in progress */
+	PC_FL_DMA_IN_PROGRESS	= (1 << 3),
+	/* 1 when encountered problem during DMA */
+	PC_FL_DMA_ERROR		= (1 << 4),
+	/* Data direction */
+	PC_FL_WRITING		= (1 <<	5),
+};
 
 /*
  *	A pipeline stage.
@@ -350,8 +349,7 @@ typedef struct ide_tape_obj {
 	/* Wasted space in each stage */
 	int excess_bh_size;
 
-	/* Status/Action flags: long for set_bit */
-	unsigned long flags;
+	unsigned int flags;
 	/* protects the ide-tape queue */
 	spinlock_t que_lock;
 
@@ -460,20 +458,26 @@ static void ide_tape_put(struct ide_tape_obj *tape)
 #define DOOR_LOCKED			1
 #define DOOR_EXPLICITLY_LOCKED		2
 
-/*
- *	Tape flag bits values.
- */
-#define IDETAPE_IGNORE_DSC		0
-#define IDETAPE_ADDRESS_VALID		1	/* 0 When the tape position is unknown */
-#define IDETAPE_BUSY			2	/* Device already opened */
-#define IDETAPE_PIPELINE_ERROR		3	/* Error detected in a pipeline stage */
-#define IDETAPE_DETECT_BS		4	/* Attempt to auto-detect the current user block size */
-#define IDETAPE_FILEMARK		5	/* Currently on a filemark */
-#define IDETAPE_DRQ_INTERRUPT		6	/* DRQ interrupt device */
-#define IDETAPE_READ_ERROR		7
-#define IDETAPE_PIPELINE_ACTIVE		8	/* pipeline active */
-/* 0 = no tape is loaded, so we don't rewind after ejecting */
-#define IDETAPE_MEDIUM_PRESENT		9
+/* Tape flag bits values. */
+enum {
+	IDETAPE_FL_IGNORE_DSC		= (1 << 0),
+	/* 0 When the tape position is unknown */
+	IDETAPE_FL_ADDRESS_VALID	= (1 <<	1),
+	/* Device already opened */
+	IDETAPE_FL_BUSY			= (1 << 2),
+	/* Error detected in a pipeline stage */
+	IDETAPE_FL_PIPELINE_ERR	= (1 <<	3),
+	/* Attempt to auto-detect the current user block size */
+	IDETAPE_FL_DETECT_BS		= (1 << 4),
+	/* Currently on a filemark */
+	IDETAPE_FL_FILEMARK		= (1 << 5),
+	/* DRQ interrupt device */
+	IDETAPE_FL_DRQ_INTERRUPT	= (1 << 6),
+	/* pipeline active */
+	IDETAPE_FL_PIPELINE_ACTIVE	= (1 << 7),
+	/* 0 = no tape is loaded, so we don't rewind after ejecting */
+	IDETAPE_FL_MEDIUM_PRESENT	= (1 << 8),
+};
 
 /*
  *	Some defines for the READ BUFFER command
@@ -638,7 +642,7 @@ static void idetape_update_buffers (idetape_pc_t *pc)
 	int count;
 	unsigned int bcount = pc->xferred;
 
-	if (test_bit(PC_WRITING, &pc->flags))
+	if (pc->flags & PC_FL_WRITING)
 		return;
 	while (bcount) {
 		if (bh == NULL) {
@@ -715,7 +719,7 @@ static void idetape_analyze_error(ide_drive_t *drive, u8 *sense)
 		 pc->c[0], tape->sense_key, tape->asc, tape->ascq);
 
 	/* Correct pc->xferred by asking the tape.	 */
-	if (test_bit(PC_DMA_ERROR, &pc->flags)) {
+	if (pc->flags & PC_FL_DMA_ERROR) {
 		pc->xferred = pc->rq_xfer -
 			tape->blk_sz *
 			be32_to_cpu(get_unaligned((u32 *)&sense[3]));
@@ -734,12 +738,12 @@ static void idetape_analyze_error(ide_drive_t *drive, u8 *sense)
 			/* don't report an error, everything's ok */
 			pc->error = 0;
 			/* don't retry read/write */
-			set_bit(PC_ABORT, &pc->flags);
+			pc->flags |= PC_FL_ABORT;
 		}
 	}
 	if (pc->c[0] == READ_6 && !!(sense[2] & 0x80)) {
 		pc->error = IDETAPE_ERROR_FILEMARK;
-		set_bit(PC_ABORT, &pc->flags);
+		pc->flags |= PC_FL_ABORT;
 	}
 	if (pc->c[0] == WRITE_6) {
 		if (!!(sense[2] & 0x40) ||
@@ -747,16 +751,15 @@ static void idetape_analyze_error(ide_drive_t *drive, u8 *sense)
 				 tape->asc == 0x0 &&
 				 tape->ascq == 0x2)) {
 			pc->error = IDETAPE_ERROR_EOD;
-			set_bit(PC_ABORT, &pc->flags);
+			pc->flags |= PC_FL_ABORT;
 		}
 	}
 	if (pc->c[0] == READ_6 || pc->c[0] == WRITE_6) {
 		if (tape->sense_key == 8) {
 			pc->error = IDETAPE_ERROR_EOD;
-			set_bit(PC_ABORT, &pc->flags);
+			pc->flags |= PC_FL_ABORT;
 		}
-		if (!test_bit(PC_ABORT, &pc->flags) &&
-		    pc->xferred)
+		if (!(pc->flags & PC_FL_ABORT) && pc->xferred)
 			pc->retries = IDETAPE_MAX_PC_RETRIES + 1;
 	}
 }
@@ -912,13 +915,13 @@ static int idetape_end_request(ide_drive_t *drive, int uptodate, int nr_sects)
 		if (rq->cmd[0] & REQ_IDETAPE_WRITE) {
 			remove_stage = 1;
 			if (error) {
-				set_bit(IDETAPE_PIPELINE_ERROR, &tape->flags);
+				tape->flags |= IDETAPE_FL_PIPELINE_ERR;
 				if (error == IDETAPE_ERROR_EOD)
 					idetape_abort_pipeline(drive, active_stage);
 			}
 		} else if (rq->cmd[0] & REQ_IDETAPE_READ) {
 			if (error == IDETAPE_ERROR_EOD) {
-				set_bit(IDETAPE_PIPELINE_ERROR, &tape->flags);
+				tape->flags |= IDETAPE_FL_PIPELINE_ERR;
 				idetape_abort_pipeline(drive, active_stage);
 			}
 		}
@@ -956,7 +959,7 @@ static int idetape_end_request(ide_drive_t *drive, int uptodate, int nr_sects)
 	if (remove_stage)
 		idetape_remove_stage_head(drive);
 	if (tape->act_data_rq == NULL)
-		clear_bit(IDETAPE_PIPELINE_ACTIVE, &tape->flags);
+		tape->flags &= ~IDETAPE_FL_PIPELINE_ACTIVE;
 	spin_unlock_irqrestore(&tape->que_lock, flags);
 	return 0;
 }
@@ -1041,7 +1044,7 @@ static ide_startstop_t idetape_retry_pc(ide_drive_t *drive)
 	}
 
 	idetape_create_request_sense_cmd(pc);
-	set_bit(IDETAPE_IGNORE_DSC, &tape->flags);
+	tape->flags |= IDETAPE_FL_IGNORE_DSC;
 	idetape_queue_pc_head(drive, pc, rq);
 	return ide_stopped;
 }
@@ -1090,7 +1093,7 @@ static ide_startstop_t idetape_pc_intr(ide_drive_t *drive)
 	/* Clear the interrupt */
 	stat = hwif->INB(IDE_STATUS_REG);
 
-	if (test_bit(PC_DMA_IN_PROGRESS, &pc->flags)) {
+	if (pc->flags & PC_FL_DMA_IN_PROGRESS) {
 		if (hwif->ide_dma_end(drive) || (stat & ERR_STAT)) {
 			/*
 			 * A DMA error is sometimes expected. For example,
@@ -1113,7 +1116,7 @@ static ide_startstop_t idetape_pc_intr(ide_drive_t *drive)
 			 * data transfer will occur, but no DMA error.
 			 * (AS, 19 Apr 2001)
 			 */
-			set_bit(PC_DMA_ERROR, &pc->flags);
+			pc->flags |= PC_FL_DMA_ERROR;
 		} else {
 			pc->xferred = pc->rq_xfer;
 			idetape_update_buffers(pc);
@@ -1127,7 +1130,7 @@ static ide_startstop_t idetape_pc_intr(ide_drive_t *drive)
 		debug_log(DBG_SENSE, "Packet command completed, %d bytes"
 				" transferred\n", pc->xferred);
 
-		clear_bit(PC_DMA_IN_PROGRESS, &pc->flags);
+		pc->flags &= ~PC_FL_DMA_IN_PROGRESS;
 		local_irq_enable();
 
 #if SIMULATE_ERRORS
@@ -1141,7 +1144,7 @@ static ide_startstop_t idetape_pc_intr(ide_drive_t *drive)
 #endif
 		if ((stat & ERR_STAT) && pc->c[0] == REQUEST_SENSE)
 			stat &= ~ERR_STAT;
-		if ((stat & ERR_STAT) || test_bit(PC_DMA_ERROR, &pc->flags)) {
+		if ((stat & ERR_STAT) || (pc->flags & PC_FL_DMA_ERROR)) {
 
 			/* Error detected */
 			debug_log(DBG_ERR, "%s: I/O error\n", tape->name);
@@ -1158,8 +1161,8 @@ static ide_startstop_t idetape_pc_intr(ide_drive_t *drive)
 			return idetape_retry_pc(drive);
 		}
 		pc->error = 0;
-		if (test_bit(PC_WAIT_FOR_DSC, &pc->flags) &&
-		    (stat & SEEK_STAT) == 0) {
+		if ((pc->flags & PC_FL_WAIT_FOR_DSC) &&
+				(stat & SEEK_STAT) == 0) {
 			/* Media access command */
 			tape->dsc_polling_start = jiffies;
 			tape->dsc_poll_freq = IDETAPE_DSC_MA_FAST;
@@ -1173,7 +1176,8 @@ static ide_startstop_t idetape_pc_intr(ide_drive_t *drive)
 		/* Command finished - Call the callback function */
 		return pc->callback(drive);
 	}
-	if (test_and_clear_bit(PC_DMA_IN_PROGRESS, &pc->flags)) {
+	if (pc->flags & PC_FL_DMA_IN_PROGRESS) {
+		pc->flags &= ~PC_FL_DMA_IN_PROGRESS;
 		printk(KERN_ERR "ide-tape: The tape wants to issue more "
 				"interrupts in DMA mode\n");
 		printk(KERN_ERR "ide-tape: DMA disabled, reverting to PIO\n");
@@ -1190,7 +1194,7 @@ static ide_startstop_t idetape_pc_intr(ide_drive_t *drive)
 		printk(KERN_ERR "ide-tape: CoD != 0 in %s\n", __func__);
 		return ide_do_reset(drive);
 	}
-	if (((ireason & IO) == IO) == test_bit(PC_WRITING, &pc->flags)) {
+	if (((ireason & IO) == IO) == !!(pc->flags & PC_FL_WRITING)) {
 		/* Hopefully, we will never get here */
 		printk(KERN_ERR "ide-tape: We wanted to %s, ",
 				(ireason & IO) ? "Write" : "Read");
@@ -1198,7 +1202,7 @@ static ide_startstop_t idetape_pc_intr(ide_drive_t *drive)
 				(ireason & IO) ? "Read" : "Write");
 		return ide_do_reset(drive);
 	}
-	if (!test_bit(PC_WRITING, &pc->flags)) {
+	if (!(pc->flags & PC_FL_WRITING)) {
 		/* Reading - Check that we have enough space */
 		temp = pc->xferred + bcount;
 		if (temp > pc->rq_xfer) {
@@ -1316,7 +1320,7 @@ static ide_startstop_t idetape_transfer_pc(ide_drive_t *drive)
 	ide_set_handler(drive, &idetape_pc_intr, IDETAPE_WAIT_CMD, NULL);
 #ifdef CONFIG_BLK_DEV_IDEDMA
 	/* Begin DMA, if necessary */
-	if (test_bit(PC_DMA_IN_PROGRESS, &pc->flags))
+	if (pc->flags & PC_FL_DMA_IN_PROGRESS)
 		hwif->dma_start(drive);
 #endif
 	/* Send the actual packet */
@@ -1342,14 +1346,13 @@ static ide_startstop_t idetape_issue_pc(ide_drive_t *drive, idetape_pc_t *pc)
 	/* Set the current packet command */
 	tape->pc = pc;
 
-	if (pc->retries > IDETAPE_MAX_PC_RETRIES ||
-	    test_bit(PC_ABORT, &pc->flags)) {
+	if (pc->retries > IDETAPE_MAX_PC_RETRIES || (pc->flags & PC_FL_ABORT)) {
 		/*
 		 *	We will "abort" retrying a packet command in case
 		 *	a legitimate error code was received (crossing a
 		 *	filemark, or end of the media, for example).
 		 */
-		if (!test_bit(PC_ABORT, &pc->flags)) {
+		if (!(pc->flags & PC_FL_ABORT)) {
 			if (!(pc->c[0] == TEST_UNIT_READY &&
 			      tape->sense_key == 2 && tape->asc == 4 &&
 			     (tape->ascq == 1 || tape->ascq == 8))) {
@@ -1375,20 +1378,21 @@ static ide_startstop_t idetape_issue_pc(ide_drive_t *drive, idetape_pc_t *pc)
 	/* Request to transfer the entire buffer at once */
 	bcount = pc->rq_xfer;
 
-	if (test_and_clear_bit(PC_DMA_ERROR, &pc->flags)) {
+	if (pc->flags & PC_FL_DMA_ERROR) {
+		pc->flags &= ~PC_FL_DMA_ERROR;
 		printk(KERN_WARNING "ide-tape: DMA disabled, "
 				"reverting to PIO\n");
 		ide_dma_off(drive);
 	}
-	if (test_bit(PC_DMA_RECOMMENDED, &pc->flags) && drive->using_dma)
+	if ((pc->flags & PC_FL_DMA_RECOMMENDED) && drive->using_dma)
 		dma_ok = !hwif->dma_setup(drive);
 
 	ide_pktcmd_tf_load(drive, IDE_TFLAG_NO_SELECT_MASK |
 			   IDE_TFLAG_OUT_DEVICE, bcount, dma_ok);
 
 	if (dma_ok)			/* Will begin DMA later */
-		set_bit(PC_DMA_IN_PROGRESS, &pc->flags);
-	if (test_bit(IDETAPE_DRQ_INTERRUPT, &tape->flags)) {
+		pc->flags |= PC_FL_DMA_IN_PROGRESS;
+	if (tape->flags & IDETAPE_FL_DRQ_INTERRUPT) {
 		ide_set_handler(drive, &idetape_transfer_pc, IDETAPE_WAIT_CMD, NULL);
 		hwif->OUTB(WIN_PACKETCMD, IDE_COMMAND_REG);
 		return ide_started;
@@ -1567,7 +1571,7 @@ static void idetape_create_read_cmd(idetape_tape_t *tape, idetape_pc_t *pc, unsi
 	pc->buf_size = length * tape->blk_sz;
 	pc->rq_xfer = pc->buf_size;
 	if (pc->rq_xfer == tape->stage_size)
-		set_bit(PC_DMA_RECOMMENDED, &pc->flags);
+		pc->flags |= PC_FL_DMA_RECOMMENDED;
 }
 
 static void idetape_create_read_buffer_cmd(idetape_tape_t *tape, idetape_pc_t *pc, unsigned int length, struct idetape_bh *bh)
@@ -1598,14 +1602,14 @@ static void idetape_create_write_cmd(idetape_tape_t *tape, idetape_pc_t *pc, uns
 	put_unaligned(cpu_to_be32(length), (unsigned int *) &pc->c[1]);
 	pc->c[1] = 1;
 	pc->callback = &idetape_rw_callback;
-	set_bit(PC_WRITING, &pc->flags);
+	pc->flags |= PC_FL_WRITING;
 	pc->bh = bh;
 	pc->b_data = bh->b_data;
 	pc->b_count = atomic_read(&bh->b_count);
 	pc->buffer = NULL;
 	pc->rq_xfer = pc->buf_size = length * tape->blk_sz;
 	if (pc->rq_xfer == tape->stage_size)
-		set_bit(PC_DMA_RECOMMENDED, &pc->flags);
+		pc->flags |= PC_FL_DMA_RECOMMENDED;
 }
 
 /*
@@ -1657,10 +1661,10 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 	stat = drive->hwif->INB(IDE_STATUS_REG);
 
 	if (!drive->dsc_overlap && !(rq->cmd[0] & REQ_IDETAPE_PC2))
-		set_bit(IDETAPE_IGNORE_DSC, &tape->flags);
+		tape->flags |= IDETAPE_FL_IGNORE_DSC;
 
 	if (drive->post_reset == 1) {
-		set_bit(IDETAPE_IGNORE_DSC, &tape->flags);
+		tape->flags |= IDETAPE_FL_IGNORE_DSC;
 		drive->post_reset = 0;
 	}
 
@@ -1668,8 +1672,8 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 		tape->ins_speed = tape->ins_size / 1024 * HZ /
 			(jiffies - tape->ins_time);
 	idetape_calculate_speeds(drive);
-	if (!test_and_clear_bit(IDETAPE_IGNORE_DSC, &tape->flags) &&
-	    (stat & SEEK_STAT) == 0) {
+	if ((tape->flags & IDETAPE_FL_IGNORE_DSC) && (stat & SEEK_STAT) == 0) {
+		tape->flags &= ~IDETAPE_FL_IGNORE_DSC;
 		if (postponed_rq == NULL) {
 			tape->dsc_polling_start = jiffies;
 			tape->dsc_poll_freq = tape->best_dsc_rw_freq;
@@ -1747,7 +1751,7 @@ static inline int idetape_pipeline_active (idetape_tape_t *tape)
 {
 	int rc1, rc2;
 
-	rc1 = test_bit(IDETAPE_PIPELINE_ACTIVE, &tape->flags);
+	rc1 = !!(tape->flags & IDETAPE_FL_PIPELINE_ACTIVE);
 	rc2 = (tape->act_data_rq != NULL);
 	return rc1;
 }
@@ -1985,7 +1989,7 @@ static ide_startstop_t idetape_read_position_callback(ide_drive_t *drive)
 			printk(KERN_INFO "ide-tape: Block location is unknown"
 					"to the tape\n");
 
-			clear_bit(IDETAPE_ADDRESS_VALID, &tape->flags);
+			tape->flags &= ~IDETAPE_FL_ADDRESS_VALID;
 			idetape_end_request(drive, 0, 0);
 		} else {
 			debug_log(DBG_SENSE, "Block Location - %u\n",
@@ -1995,7 +1999,7 @@ static ide_startstop_t idetape_read_position_callback(ide_drive_t *drive)
 			tape->first_frm_pos =
 				be32_to_cpu(*(u32 *)&readpos[4]);
 			tape->blocks_in_buffer = readpos[15];
-			set_bit(IDETAPE_ADDRESS_VALID, &tape->flags);
+			tape->flags |= IDETAPE_FL_ADDRESS_VALID;
 			idetape_end_request(drive, 1, 0);
 		}
 	} else {
@@ -2017,7 +2021,7 @@ static void idetape_create_write_filemark_cmd (ide_drive_t *drive, idetape_pc_t
 	idetape_init_pc(pc);
 	pc->c[0] = WRITE_FILEMARKS;
 	pc->c[4] = write_filemark;
-	set_bit(PC_WAIT_FOR_DSC, &pc->flags);
+	pc->flags |= PC_FL_WAIT_FOR_DSC;
 	pc->callback = &idetape_pc_callback;
 }
 
@@ -2064,7 +2068,7 @@ static void idetape_create_load_unload_cmd (ide_drive_t *drive, idetape_pc_t *pc
 	idetape_init_pc(pc);
 	pc->c[0] = START_STOP;
 	pc->c[4] = cmd;
-	set_bit(PC_WAIT_FOR_DSC, &pc->flags);
+	pc->flags |= PC_FL_WAIT_FOR_DSC;
 	pc->callback = &idetape_pc_callback;
 }
 
@@ -2077,7 +2081,7 @@ static int idetape_wait_ready(ide_drive_t *drive, unsigned long timeout)
 	/*
 	 * Wait for the tape to become ready
 	 */
-	set_bit(IDETAPE_MEDIUM_PRESENT, &tape->flags);
+	tape->flags |= IDETAPE_FL_MEDIUM_PRESENT;
 	timeout += jiffies;
 	while (time_before(jiffies, timeout)) {
 		idetape_create_test_unit_ready_cmd(&pc);
@@ -2146,7 +2150,7 @@ static void idetape_create_locate_cmd (ide_drive_t *drive, idetape_pc_t *pc, uns
 	pc->c[1] = 2;
 	put_unaligned(cpu_to_be32(block), (unsigned int *) &pc->c[3]);
 	pc->c[8] = partition;
-	set_bit(PC_WAIT_FOR_DSC, &pc->flags);
+	pc->flags |= PC_FL_WAIT_FOR_DSC;
 	pc->callback = &idetape_pc_callback;
 }
 
@@ -2176,8 +2180,10 @@ static int __idetape_discard_read_pipeline (ide_drive_t *drive)
 
 	/* Remove merge stage. */
 	cnt = tape->merge_stage_sz / tape->blk_sz;
-	if (test_and_clear_bit(IDETAPE_FILEMARK, &tape->flags))
+	if (tape->flags & IDETAPE_FL_FILEMARK) {
+		tape->flags &= ~IDETAPE_FL_FILEMARK;
 		++cnt;		/* Filemarks count as 1 sector */
+	}
 	tape->merge_stage_sz = 0;
 	if (tape->merge_stage != NULL) {
 		__idetape_kfree_stage(tape->merge_stage);
@@ -2185,7 +2191,7 @@ static int __idetape_discard_read_pipeline (ide_drive_t *drive)
 	}
 
 	/* Clear pipeline flags. */
-	clear_bit(IDETAPE_PIPELINE_ERROR, &tape->flags);
+	tape->flags &= ~IDETAPE_FL_PIPELINE_ERR;
 	tape->chrdev_dir = idetape_dir_none;
 
 	/* Remove pipeline stages. */
@@ -2300,7 +2306,7 @@ static void idetape_ins_ppl_into_queue(ide_drive_t *drive)
 	if (tape->next_stage == NULL)
 		return;
 	if (!idetape_pipeline_active(tape)) {
-		set_bit(IDETAPE_PIPELINE_ACTIVE, &tape->flags);
+		tape->flags |= IDETAPE_FL_PIPELINE_ACTIVE;
 		idetape_activate_next_stage(drive);
 		(void) ide_do_drive_cmd(drive, tape->act_data_rq, ide_end);
 	}
@@ -2318,7 +2324,7 @@ static void idetape_create_rewind_cmd (ide_drive_t *drive, idetape_pc_t *pc)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = REZERO_UNIT;
-	set_bit(PC_WAIT_FOR_DSC, &pc->flags);
+	pc->flags |= PC_FL_WAIT_FOR_DSC;
 	pc->callback = &idetape_pc_callback;
 }
 
@@ -2327,7 +2333,7 @@ static void idetape_create_erase_cmd (idetape_pc_t *pc)
 	idetape_init_pc(pc);
 	pc->c[0] = ERASE;
 	pc->c[1] = 1;
-	set_bit(PC_WAIT_FOR_DSC, &pc->flags);
+	pc->flags |= PC_FL_WAIT_FOR_DSC;
 	pc->callback = &idetape_pc_callback;
 }
 
@@ -2337,7 +2343,7 @@ static void idetape_create_space_cmd (idetape_pc_t *pc,int count, u8 cmd)
 	pc->c[0] = SPACE;
 	put_unaligned(cpu_to_be32(count), (unsigned int *) &pc->c[1]);
 	pc->c[1] = cmd;
-	set_bit(PC_WAIT_FOR_DSC, &pc->flags);
+	pc->flags |= PC_FL_WAIT_FOR_DSC;
 	pc->callback = &idetape_pc_callback;
 }
 
@@ -2424,9 +2430,11 @@ static int idetape_add_chrdev_write_request (ide_drive_t *drive, int blocks)
 			idetape_ins_ppl_into_queue(drive);
 		}
 	}
-	if (test_and_clear_bit(IDETAPE_PIPELINE_ERROR, &tape->flags))
+	if (tape->flags & IDETAPE_FL_PIPELINE_ERR) {
+		tape->flags &= ~IDETAPE_FL_PIPELINE_ERR;
 		/* Return a deferred error */
 		return -EIO;
+	}
 	return blocks;
 }
 
@@ -2496,7 +2504,7 @@ static void idetape_empty_write_pipeline (ide_drive_t *drive)
 		__idetape_kfree_stage(tape->merge_stage);
 		tape->merge_stage = NULL;
 	}
-	clear_bit(IDETAPE_PIPELINE_ERROR, &tape->flags);
+	tape->flags &= ~IDETAPE_FL_PIPELINE_ERR;
 	tape->chrdev_dir = idetape_dir_none;
 
 	/*
@@ -2576,8 +2584,8 @@ static int idetape_init_read(ide_drive_t *drive, int max_stages)
 	idetape_init_rq(&rq, REQ_IDETAPE_READ);
 	rq.sector = tape->first_frm_pos;
 	rq.nr_sectors = rq.current_nr_sectors = blocks;
-	if (!test_bit(IDETAPE_PIPELINE_ERROR, &tape->flags) &&
-	    tape->nr_stages < max_stages) {
+	if (!(tape->flags & IDETAPE_FL_PIPELINE_ERR) &&
+			tape->nr_stages < max_stages) {
 		new_stage = idetape_kmalloc_stage(tape);
 		while (new_stage != NULL) {
 			new_stage->rq = rq;
@@ -2616,7 +2624,7 @@ static int idetape_add_chrdev_read_request (ide_drive_t *drive,int blocks)
 	/*
 	 * If we are at a filemark, return a read length of 0
 	 */
-	if (test_bit(IDETAPE_FILEMARK, &tape->flags))
+	if (tape->flags & IDETAPE_FL_FILEMARK)
 		return 0;
 
 	/*
@@ -2625,7 +2633,7 @@ static int idetape_add_chrdev_read_request (ide_drive_t *drive,int blocks)
 	 */
 	idetape_init_read(drive, tape->max_stages);
 	if (tape->first_stage == NULL) {
-		if (test_bit(IDETAPE_PIPELINE_ERROR, &tape->flags))
+		if (tape->flags & IDETAPE_FL_PIPELINE_ERR)
 			return 0;
 		return idetape_queue_rw_tail(drive, REQ_IDETAPE_READ, blocks, tape->merge_stage->bh);
 	}
@@ -2641,7 +2649,7 @@ static int idetape_add_chrdev_read_request (ide_drive_t *drive,int blocks)
 	else {
 		idetape_switch_buffers(tape, tape->first_stage);
 		if (rq_ptr->errors == IDETAPE_ERROR_FILEMARK)
-			set_bit(IDETAPE_FILEMARK, &tape->flags);
+			tape->flags |= IDETAPE_FL_FILEMARK;
 		spin_lock_irqsave(&tape->que_lock, flags);
 		idetape_remove_stage_head(drive);
 		spin_unlock_irqrestore(&tape->que_lock, flags);
@@ -2789,12 +2797,14 @@ static int idetape_space_over_filemarks (ide_drive_t *drive,short mt_op,int mt_c
 		 *	filemarks.
 		 */
 		tape->merge_stage_sz = 0;
-		if (test_and_clear_bit(IDETAPE_FILEMARK, &tape->flags))
+		if (tape->flags & IDETAPE_FL_FILEMARK) {
+			tape->flags &= ~IDETAPE_FL_FILEMARK;
 			++count;
+		}
 		while (tape->first_stage != NULL) {
 			if (count == mt_count) {
 				if (mt_op == MTFSFM)
-					set_bit(IDETAPE_FILEMARK, &tape->flags);
+					tape->flags |= IDETAPE_FL_FILEMARK;
 				return 0;
 			}
 			spin_lock_irqsave(&tape->que_lock, flags);
@@ -2874,7 +2884,7 @@ static ssize_t idetape_chrdev_read (struct file *file, char __user *buf,
 	debug_log(DBG_CHRDEV, "Enter %s, count %Zd\n", __func__, count);
 
 	if (tape->chrdev_dir != idetape_dir_read) {
-		if (test_bit(IDETAPE_DETECT_BS, &tape->flags))
+		if (tape->flags & IDETAPE_FL_DETECT_BS)
 			if (count > tape->blk_sz &&
 			    (count % tape->blk_sz) == 0)
 				tape->user_bs_factor = count / tape->blk_sz;
@@ -2913,7 +2923,7 @@ static ssize_t idetape_chrdev_read (struct file *file, char __user *buf,
 		tape->merge_stage_sz = bytes_read-temp;
 	}
 finish:
-	if (!actually_read && test_bit(IDETAPE_FILEMARK, &tape->flags)) {
+	if (!actually_read && (tape->flags & IDETAPE_FL_FILEMARK)) {
 		debug_log(DBG_SENSE, "%s: spacing over filemark\n", tape->name);
 
 		idetape_space_over_filemarks(drive, MTFSF, 1);
@@ -3098,7 +3108,7 @@ static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
 			idetape_create_load_unload_cmd(drive, &pc,!IDETAPE_LU_LOAD_MASK);
 			retval = idetape_queue_pc_tail(drive, &pc);
 			if (!retval)
-				clear_bit(IDETAPE_MEDIUM_PRESENT, &tape->flags);
+				tape->flags &= ~IDETAPE_FL_MEDIUM_PRESENT;
 			return retval;
 		case MTNOP:
 			idetape_discard_read_pipeline(drive, 0);
@@ -3120,9 +3130,9 @@ static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
 						mt_count % tape->blk_sz)
 					return -EIO;
 				tape->user_bs_factor = mt_count / tape->blk_sz;
-				clear_bit(IDETAPE_DETECT_BS, &tape->flags);
+				tape->flags &= ~IDETAPE_FL_DETECT_BS;
 			} else
-				set_bit(IDETAPE_DETECT_BS, &tape->flags);
+				tape->flags |= IDETAPE_FL_DETECT_BS;
 			return 0;
 		case MTSEEK:
 			idetape_discard_read_pipeline(drive, 0);
@@ -3248,7 +3258,7 @@ static int idetape_chrdev_open (struct inode *inode, struct file *filp)
 	ide_drive_t *drive;
 	idetape_tape_t *tape;
 	idetape_pc_t pc;
-	int retval;
+	int retval, testval;
 
 	/*
 	 * We really want to do nonseekable_open(inode, filp); here, but some
@@ -3269,24 +3279,26 @@ static int idetape_chrdev_open (struct inode *inode, struct file *filp)
 
 	filp->private_data = tape;
 
-	if (test_and_set_bit(IDETAPE_BUSY, &tape->flags)) {
+	testval = tape->flags & IDETAPE_FL_BUSY;
+	tape->flags |= IDETAPE_FL_BUSY;
+	if (testval) {
 		retval = -EBUSY;
 		goto out_put_tape;
 	}
 
 	retval = idetape_wait_ready(drive, 60 * HZ);
 	if (retval) {
-		clear_bit(IDETAPE_BUSY, &tape->flags);
+		tape->flags &= ~IDETAPE_FL_BUSY;
 		printk(KERN_ERR "ide-tape: %s: drive not ready\n", tape->name);
 		goto out_put_tape;
 	}
 
 	idetape_read_position(drive);
-	if (!test_bit(IDETAPE_ADDRESS_VALID, &tape->flags))
+	if (!(tape->flags & IDETAPE_FL_ADDRESS_VALID))
 		(void)idetape_rewind_tape(drive);
 
 	if (tape->chrdev_dir != idetape_dir_read)
-		clear_bit(IDETAPE_PIPELINE_ERROR, &tape->flags);
+		tape->flags &= ~IDETAPE_FL_PIPELINE_ERR;
 
 	/* Read block size and write protect status from drive. */
 	ide_tape_get_bsize_from_bdesc(drive);
@@ -3301,7 +3313,7 @@ static int idetape_chrdev_open (struct inode *inode, struct file *filp)
 	if (tape->write_prot) {
 		if ((filp->f_flags & O_ACCMODE) == O_WRONLY ||
 		    (filp->f_flags & O_ACCMODE) == O_RDWR) {
-			clear_bit(IDETAPE_BUSY, &tape->flags);
+			tape->flags &= ~IDETAPE_FL_BUSY;
 			retval = -EROFS;
 			goto out_put_tape;
 		}
@@ -3371,7 +3383,7 @@ static int idetape_chrdev_release (struct inode *inode, struct file *filp)
 		__idetape_kfree_stage(tape->cache_stage);
 		tape->cache_stage = NULL;
 	}
-	if (minor < 128 && test_bit(IDETAPE_MEDIUM_PRESENT, &tape->flags))
+	if (minor < 128 && (tape->flags & IDETAPE_FL_MEDIUM_PRESENT))
 		(void) idetape_rewind_tape(drive);
 	if (tape->chrdev_dir == idetape_dir_none) {
 		if (tape->door_locked == DOOR_LOCKED) {
@@ -3381,7 +3393,7 @@ static int idetape_chrdev_release (struct inode *inode, struct file *filp)
 			}
 		}
 	}
-	clear_bit(IDETAPE_BUSY, &tape->flags);
+	tape->flags &= ~IDETAPE_FL_BUSY;
 	ide_tape_put(tape);
 	unlock_kernel();
 	return 0;
@@ -3572,7 +3584,7 @@ static void idetape_setup (ide_drive_t *drive, idetape_tape_t *tape, int minor)
 	tape->speed_ctl = 1;
 	*((unsigned short *) &gcw) = drive->id->config;
 	if (gcw.drq_type == 1)
-		set_bit(IDETAPE_DRQ_INTERRUPT, &tape->flags);
+		tape->flags |= IDETAPE_FL_DRQ_INTERRUPT;
 
 	tape->min_pipeline = tape->max_pipeline = tape->max_stages = 10;
 	
-- 
1.5.3.7

