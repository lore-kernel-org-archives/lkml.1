Return-Path: <linux-kernel-owner+w=401wt.eu-S1757470AbYA0JvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757470AbYA0JvV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 04:51:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755897AbYA0JtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 04:49:11 -0500
Received: from [212.23.103.76] ([212.23.103.76]:58580 "EHLO gollum.tnic"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751749AbYA0JtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 04:49:04 -0500
X-Greylist: delayed 1586 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Jan 2008 04:48:51 EST
From: Borislav Petkov <petkovbb@gmail.com>
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>
Subject: [PATCH 07/32] ide-tape: refactor the debug logging facility
Date: Sun, 27 Jan 2008 10:47:55 +0100
Message-Id: <1201427300-3954-2-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1201427300-3954-1-git-send-email-petkovbb@gmail.com>
References: <1201427300-3954-1-git-send-email-petkovbb@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bbpetkov@yahoo.de>

Teach the debug logging macro to differentiate different log levels based on the
type of debug level enabled specifically instead of a threshold-based one.
Thus, convert tape->debug_level to a bitmask that is written to over /proc.

Also,
- Cleanup and simplify debug macro thus removing a lot of code lines,
- Get rid of unused debug levels,
- Adjust the loglevel at several places where it was simply missing (e.g.
idetape_chrdev_open() etc.)

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
---
 drivers/ide/ide-tape.c |  310 +++++++++++++++++-------------------------------
 1 files changed, 107 insertions(+), 203 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index efb9d25..a2e7df0 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -103,24 +103,27 @@ typedef struct os_dat_s {
 #define IDETAPE_MAX_PIPELINE_STAGES	400
 #define IDETAPE_INCREASE_STAGES_RATE	 20
 
-/*
- *	The following are used to debug the driver:
- *
- *	Setting IDETAPE_DEBUG_LOG to 1 will log driver flow control.
- *	some places.
- *
- *	Setting them to 0 will restore normal operation mode:
- *
- *		1.	Disable logging normal successful operations.
- *		2.	Disable self-sanity checks.
- *		3.	Errors will still be logged, of course.
- *
- *	All the #if DEBUG code will be removed some day, when the driver
- *	is verified to be stable enough. This will make it much more
- *	esthetic.
- */
+enum {
+	DBG_ERR =		(1 << 0),
+	DBG_SENSE =		(1 << 1),
+	DBG_CHRDEV =		(1 << 2),
+	DBG_PROCS =		(1 << 3),
+	DBG_PCRQ_STACK =	(1 << 4),
+};
+
+/* define to see debug info */
 #define IDETAPE_DEBUG_LOG		0
 
+#if IDETAPE_DEBUG_LOG
+#define debug_log(lvl, fmt, args...)			\
+{							\
+	if (tape->debug_level & lvl)			\
+	printk(KERN_INFO "ide-tape: " fmt, ## args)	\
+}
+#else
+#define debug_log(lvl, fmt, args...) do {} while (0)
+#endif
+
 /*
  *	After each failed packet command we issue a request sense command
  *	and retry the packet command IDETAPE_MAX_PC_RETRIES times.
@@ -557,7 +560,7 @@ typedef struct ide_tape_obj {
          * 5 : 4+include pc_stack rq_stack info
          * 6 : 5+USE_COUNT updates
          */
-         int debug_level; 
+         u32 debug_level;
 } idetape_tape_t;
 
 static DEFINE_MUTEX(idetape_ref_mutex);
@@ -923,11 +926,8 @@ static idetape_pc_t *idetape_next_pc_storage (ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 
-#if IDETAPE_DEBUG_LOG
-	if (tape->debug_level >= 5)
-		printk(KERN_INFO "ide-tape: pc_stack_index=%d\n",
-			tape->pc_stack_index);
-#endif /* IDETAPE_DEBUG_LOG */
+	debug_log(DBG_PCRQ_STACK, "pc_stack_index=%d\n", tape->pc_stack_index);
+
 	if (tape->pc_stack_index == IDETAPE_PC_STACK)
 		tape->pc_stack_index=0;
 	return (&tape->pc_stack[tape->pc_stack_index++]);
@@ -950,11 +950,8 @@ static struct request *idetape_next_rq_storage (ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 
-#if IDETAPE_DEBUG_LOG
-	if (tape->debug_level >= 5)
-		printk(KERN_INFO "ide-tape: rq_stack_index=%d\n",
-			tape->rq_stack_index);
-#endif /* IDETAPE_DEBUG_LOG */
+	debug_log(DBG_PCRQ_STACK, "rq_stack_index=%d\n", tape->rq_stack_index);
+
 	if (tape->rq_stack_index == IDETAPE_PC_STACK)
 		tape->rq_stack_index=0;
 	return (&tape->rq_stack[tape->rq_stack_index++]);
@@ -987,17 +984,9 @@ static void idetape_analyze_error(ide_drive_t *drive, u8 *sense)
 	tape->sense_key = sense[2] & 0xF;
 	tape->asc       = sense[12];
 	tape->ascq      = sense[13];
-#if IDETAPE_DEBUG_LOG
-	/*
-	 * Without debugging, we only log an error if we decided to give up
-	 * retrying.
-	 */
-	if (tape->debug_level >= 1)
-		printk(KERN_INFO "ide-tape: pc = %x, sense key = %x, "
-			"asc = %x, ascq = %x\n",
-			pc->c[0], tape->sense_key,
-			tape->asc, tape->ascq);
-#endif /* IDETAPE_DEBUG_LOG */
+
+	debug_log(DBG_ERR, "pc = %x, sense key = %x, asc = %x, ascq = %x\n",
+		 pc->c[0], tape->sense_key, tape->asc, tape->ascq);
 
 	/* Correct pc->actually_transferred by asking the tape.	 */
 	if (test_bit(PC_DMA_ERROR, &pc->flags)) {
@@ -1055,12 +1044,11 @@ static void idetape_active_next_stage (ide_drive_t *drive)
 	idetape_stage_t *stage = tape->next_stage;
 	struct request *rq = &stage->rq;
 
-#if IDETAPE_DEBUG_LOG
-	if (tape->debug_level >= 4)
-		printk(KERN_INFO "ide-tape: Reached idetape_active_next_stage\n");
-#endif /* IDETAPE_DEBUG_LOG */
+	debug_log(DBG_PROCS, "Enter %f\n", __func__);
+
 	if (stage == NULL) {
-		printk(KERN_ERR "ide-tape: bug: Trying to activate a non existing stage\n");
+		printk(KERN_ERR "ide-tape: bug: Trying to activate a non"
+				" existing stage\n");
 		return;
 	}
 
@@ -1083,11 +1071,8 @@ static void idetape_increase_max_pipeline_stages (ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	int increase = (tape->max_pipeline - tape->min_pipeline) / 10;
-	
-#if IDETAPE_DEBUG_LOG
-	if (tape->debug_level >= 4)
-		printk (KERN_INFO "ide-tape: Reached idetape_increase_max_pipeline_stages\n");
-#endif /* IDETAPE_DEBUG_LOG */
+
+	debug_log(DBG_PROCS, "Enter %s\n", __func__);
 
 	tape->max_stages += max(increase, 1);
 	tape->max_stages = max(tape->max_stages, tape->min_pipeline);
@@ -1132,17 +1117,16 @@ static void idetape_remove_stage_head (ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	idetape_stage_t *stage;
-	
-#if IDETAPE_DEBUG_LOG
-	if (tape->debug_level >= 4)
-		printk(KERN_INFO "ide-tape: Reached idetape_remove_stage_head\n");
-#endif /* IDETAPE_DEBUG_LOG */
+
+	debug_log(DBG_PROCS, "Enter %s\n", __func__);
+
 	if (tape->first_stage == NULL) {
 		printk(KERN_ERR "ide-tape: bug: tape->first_stage is NULL\n");
 		return;
 	}
 	if (tape->active_stage == tape->first_stage) {
-		printk(KERN_ERR "ide-tape: bug: Trying to free our active pipeline stage\n");
+		printk(KERN_ERR "ide-tape: bug: Trying to free our active "
+				"pipeline stage\n");
 		return;
 	}
 	stage = tape->first_stage;
@@ -1169,10 +1153,8 @@ static void idetape_abort_pipeline(ide_drive_t *drive,
 	idetape_stage_t *stage = new_last_stage->next;
 	idetape_stage_t *nstage;
 
-#if IDETAPE_DEBUG_LOG
-	if (tape->debug_level >= 4)
-		printk(KERN_INFO "ide-tape: %s: idetape_abort_pipeline called\n", tape->name);
-#endif
+	debug_log(DBG_PROCS, "%s: Enter %s\n", tape->name, __func__);
+
 	while (stage) {
 		nstage = stage->next;
 		idetape_kfree_stage(tape, stage);
@@ -1199,10 +1181,7 @@ static int idetape_end_request(ide_drive_t *drive, int uptodate, int nr_sects)
 	int remove_stage = 0;
 	idetape_stage_t *active_stage;
 
-#if IDETAPE_DEBUG_LOG
-        if (tape->debug_level >= 4)
-	printk(KERN_INFO "ide-tape: Reached idetape_end_request\n");
-#endif /* IDETAPE_DEBUG_LOG */
+	debug_log(DBG_PROCS, "Enter %s\n", __func__);
 
 	switch (uptodate) {
 		case 0:	error = IDETAPE_ERROR_GENERAL; break;
@@ -1267,10 +1246,8 @@ static ide_startstop_t idetape_request_sense_callback (ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 
-#if IDETAPE_DEBUG_LOG
-	if (tape->debug_level >= 4)
-		printk(KERN_INFO "ide-tape: Reached idetape_request_sense_callback\n");
-#endif /* IDETAPE_DEBUG_LOG */
+	debug_log(DBG_PROCS, "Enter %s\n", __func__);
+
 	if (!tape->pc->error) {
 		idetape_analyze_error(drive, tape->pc->buffer);
 		idetape_end_request(drive, 1, 0);
@@ -1355,10 +1332,8 @@ static void idetape_postpone_request (ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 
-#if IDETAPE_DEBUG_LOG
-	if (tape->debug_level >= 4)
-		printk(KERN_INFO "ide-tape: idetape_postpone_request\n");
-#endif
+	debug_log(DBG_PROCS, "Enter %s\n", __func__);
+
 	tape->postponed_rq = HWGROUP(drive)->rq;
 	ide_stall_queue(drive, tape->dsc_polling_frequency);
 }
@@ -1383,11 +1358,7 @@ static ide_startstop_t idetape_pc_intr (ide_drive_t *drive)
 	u16 bcount;
 	u8 stat, ireason;
 
-#if IDETAPE_DEBUG_LOG
-	if (tape->debug_level >= 4)
-		printk(KERN_INFO "ide-tape: Reached idetape_pc_intr "
-				"interrupt handler\n");
-#endif /* IDETAPE_DEBUG_LOG */	
+	debug_log(DBG_PROCS, "Enter %s - interrupt handler\n", __func__);
 
 	/* Clear the interrupt */
 	stat = hwif->INB(IDE_STATUS_REG);
@@ -1420,20 +1391,16 @@ static ide_startstop_t idetape_pc_intr (ide_drive_t *drive)
 			pc->actually_transferred = pc->request_transfer;
 			idetape_update_buffers(pc);
 		}
-#if IDETAPE_DEBUG_LOG
-		if (tape->debug_level >= 4)
-			printk(KERN_INFO "ide-tape: DMA finished\n");
-#endif /* IDETAPE_DEBUG_LOG */
+		debug_log(DBG_PROCS, "DMA finished\n");
+
 	}
 
 	/* No more interrupts */
 	if ((stat & DRQ_STAT) == 0) {
-#if IDETAPE_DEBUG_LOG
-		if (tape->debug_level >= 2)
-			printk(KERN_INFO "ide-tape: Packet command completed, %d bytes transferred\n", pc->actually_transferred);
-#endif /* IDETAPE_DEBUG_LOG */
-		clear_bit(PC_DMA_IN_PROGRESS, &pc->flags);
+		debug_log(DBG_SENSE, "Packet command completed, %d bytes"
+				" transferred\n", pc->actually_transferred);
 
+		clear_bit(PC_DMA_IN_PROGRESS, &pc->flags);
 		local_irq_enable();
 
 #if SIMULATE_ERRORS
@@ -1448,20 +1415,17 @@ static ide_startstop_t idetape_pc_intr (ide_drive_t *drive)
 		if ((stat & ERR_STAT) && pc->c[0] == IDETAPE_REQUEST_SENSE_CMD)
 			stat &= ~ERR_STAT;
 		if ((stat & ERR_STAT) || test_bit(PC_DMA_ERROR, &pc->flags)) {
+
 			/* Error detected */
-#if IDETAPE_DEBUG_LOG
-			if (tape->debug_level >= 1)
-				printk(KERN_INFO "ide-tape: %s: I/O error\n",
-					tape->name);
-#endif /* IDETAPE_DEBUG_LOG */
+			debug_log(DBG_ERR, "%s: I/O error\n", tape->name);
+
 			if (pc->c[0] == IDETAPE_REQUEST_SENSE_CMD) {
 				printk(KERN_ERR "ide-tape: I/O error in request sense command\n");
 				return ide_do_reset(drive);
 			}
-#if IDETAPE_DEBUG_LOG
-			if (tape->debug_level >= 1)
-				printk(KERN_INFO "ide-tape: [cmd %x]: check condition\n", pc->c[0]);
-#endif
+			debug_log(DBG_ERR, "[cmd %x]: check condition\n",
+					pc->c[0]);
+
 			/* Retry operation */
 			return idetape_retry_pc(drive);
 		}
@@ -1516,10 +1480,9 @@ static ide_startstop_t idetape_pc_intr (ide_drive_t *drive)
 				ide_set_handler(drive, &idetape_pc_intr, IDETAPE_WAIT_CMD, NULL);
 				return ide_started;
 			}
-#if IDETAPE_DEBUG_LOG
-			if (tape->debug_level >= 2)
-				printk(KERN_NOTICE "ide-tape: The tape wants to send us more data than expected - allowing transfer\n");
-#endif /* IDETAPE_DEBUG_LOG */
+			debug_log(DBG_SENSE, "The tape wants to send us more "
+				"data than expected - allowing transfer\n");
+
 		}
 	}
 	if (test_bit(PC_WRITING, &pc->flags)) {
@@ -1540,11 +1503,10 @@ static ide_startstop_t idetape_pc_intr (ide_drive_t *drive)
 	/* Update the current position */
 	pc->actually_transferred += bcount;
 	pc->current_position += bcount;
-#if IDETAPE_DEBUG_LOG
-	if (tape->debug_level >= 2)
-		printk(KERN_INFO "ide-tape: [cmd %x] transferred %d bytes "
-				 "on that interrupt\n", pc->c[0], bcount);
-#endif
+
+	debug_log(DBG_SENSE, "[cmd %x] transferred %d bytes on that intr.\n",
+			pc->c[0], bcount);
+
 	/* And set the interrupt handler again */
 	ide_set_handler(drive, &idetape_pc_intr, IDETAPE_WAIT_CMD, NULL);
 	return ide_started;
@@ -1677,10 +1639,7 @@ static ide_startstop_t idetape_issue_packet_command (ide_drive_t *drive, idetape
 		tape->failed_pc = NULL;
 		return pc->callback(drive);
 	}
-#if IDETAPE_DEBUG_LOG
-	if (tape->debug_level >= 2)
-		printk(KERN_INFO "ide-tape: Retry number - %d, cmd = %02X\n", pc->retries, pc->c[0]);
-#endif /* IDETAPE_DEBUG_LOG */
+	debug_log(DBG_SENSE, "Retry #%d, cmd = %02X\n", pc->retries, pc->c[0]);
 
 	pc->retries++;
 	/* We haven't transferred any data yet */
@@ -1718,11 +1677,8 @@ static ide_startstop_t idetape_issue_packet_command (ide_drive_t *drive, idetape
 static ide_startstop_t idetape_pc_callback (ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
-	
-#if IDETAPE_DEBUG_LOG
-	if (tape->debug_level >= 4)
-		printk(KERN_INFO "ide-tape: Reached idetape_pc_callback\n");
-#endif /* IDETAPE_DEBUG_LOG */
+
+	debug_log(DBG_PROCS, "Enter %s\n", __func__);
 
 	idetape_end_request(drive, tape->pc->error ? 0 : 1, 0);
 	return ide_stopped;
@@ -1853,11 +1809,7 @@ static ide_startstop_t idetape_rw_callback (ide_drive_t *drive)
 		tape->avg_size = 0;
 		tape->avg_time = jiffies;
 	}
-
-#if IDETAPE_DEBUG_LOG	
-	if (tape->debug_level >= 4)
-		printk(KERN_INFO "ide-tape: Reached idetape_rw_callback\n");
-#endif /* IDETAPE_DEBUG_LOG */
+	debug_log(DBG_PROCS, "Enter %s\n", __func__);
 
 	tape->first_frame_position += blocks;
 	rq->current_nr_sectors -= blocks;
@@ -1933,12 +1885,9 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 	struct request *postponed_rq = tape->postponed_rq;
 	u8 stat;
 
-#if IDETAPE_DEBUG_LOG
-	if (tape->debug_level >= 2)
-		printk(KERN_INFO "ide-tape: sector: %ld, "
-			"nr_sectors: %ld, current_nr_sectors: %d\n",
+	debug_log(DBG_SENSE, "sector: %ld, nr_sectors: %ld,"
+			" current_nr_sectors: %d\n",
 			rq->sector, rq->nr_sectors, rq->current_nr_sectors);
-#endif /* IDETAPE_DEBUG_LOG */
 
 	if (!blk_special_request(rq)) {
 		/*
@@ -2129,10 +2078,7 @@ static idetape_stage_t *idetape_kmalloc_stage (idetape_tape_t *tape)
 {
 	idetape_stage_t *cache_stage = tape->cache_stage;
 
-#if IDETAPE_DEBUG_LOG
-	if (tape->debug_level >= 4)
-		printk(KERN_INFO "ide-tape: Reached idetape_kmalloc_stage\n");
-#endif /* IDETAPE_DEBUG_LOG */
+	debug_log(DBG_PROCS, "Enter %s\n", __func__);
 
 	if (tape->nr_stages >= tape->max_stages)
 		return NULL;
@@ -2231,11 +2177,9 @@ static void idetape_add_stage_tail (ide_drive_t *drive,idetape_stage_t *stage)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	unsigned long flags;
-	
-#if IDETAPE_DEBUG_LOG
-	if (tape->debug_level >= 4)
-		printk (KERN_INFO "ide-tape: Reached idetape_add_stage_tail\n");
-#endif /* IDETAPE_DEBUG_LOG */
+
+	debug_log(DBG_PROCS, "Enter %s\n", __func__);
+
 	spin_lock_irqsave(&tape->spinlock, flags);
 	stage->next = NULL;
 	if (tape->last_stage != NULL)
@@ -2278,29 +2222,22 @@ static ide_startstop_t idetape_read_position_callback (ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	idetape_read_position_result_t *result;
-	
-#if IDETAPE_DEBUG_LOG
-	if (tape->debug_level >= 4)
-		printk(KERN_INFO "ide-tape: Reached idetape_read_position_callback\n");
-#endif /* IDETAPE_DEBUG_LOG */
+
+	debug_log(DBG_PROCS, "Enter %s\n", __func__);
 
 	if (!tape->pc->error) {
 		result = (idetape_read_position_result_t *) tape->pc->buffer;
-#if IDETAPE_DEBUG_LOG
-		if (tape->debug_level >= 2)
-			printk(KERN_INFO "ide-tape: BOP - %s\n",result->bop ? "Yes":"No");
-		if (tape->debug_level >= 2)
-			printk(KERN_INFO "ide-tape: EOP - %s\n",result->eop ? "Yes":"No");
-#endif /* IDETAPE_DEBUG_LOG */
+		debug_log(DBG_SENSE, "BOP - %s\n", result->bop ? "Yes" : "No");
+		debug_log(DBG_SENSE, "EOP - %s\n", result->eop ? "Yes" : "No");
+
 		if (result->bpu) {
 			printk(KERN_INFO "ide-tape: Block location is unknown to the tape\n");
 			clear_bit(IDETAPE_ADDRESS_VALID, &tape->flags);
 			idetape_end_request(drive, 0, 0);
 		} else {
-#if IDETAPE_DEBUG_LOG
-			if (tape->debug_level >= 2)
-				printk(KERN_INFO "ide-tape: Block Location - %u\n", ntohl(result->first_block));
-#endif /* IDETAPE_DEBUG_LOG */
+			debug_log(DBG_SENSE, "Block Location - %u\n",
+					ntohl(result->first_block));
+
 			tape->partition = result->partition;
 			tape->first_frame_position = ntohl(result->first_block);
 			tape->last_frame_position = ntohl(result->last_block);
@@ -2440,10 +2377,7 @@ static int idetape_read_position (ide_drive_t *drive)
 	idetape_pc_t pc;
 	int position;
 
-#if IDETAPE_DEBUG_LOG
-        if (tape->debug_level >= 4)
-		printk(KERN_INFO "ide-tape: Reached idetape_read_position\n");
-#endif /* IDETAPE_DEBUG_LOG */
+	debug_log(DBG_PROCS, "Enter %s\n", __func__);
 
 	idetape_create_read_position_cmd(&pc);
 	if (idetape_queue_pc_tail(drive, &pc))
@@ -2576,12 +2510,11 @@ static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int blocks, struct
 	idetape_tape_t *tape = drive->driver_data;
 	struct request rq;
 
-#if IDETAPE_DEBUG_LOG
-	if (tape->debug_level >= 2)
-		printk(KERN_INFO "ide-tape: idetape_queue_rw_tail: cmd=%d\n",cmd);
-#endif /* IDETAPE_DEBUG_LOG */
+	debug_log(DBG_SENSE, "%s: cmd=%d\n", __func__, cmd);
+
 	if (idetape_pipeline_active(tape)) {
-		printk(KERN_ERR "ide-tape: bug: the pipeline is active in idetape_queue_rw_tail\n");
+		printk(KERN_ERR "ide-tape: bug: the pipeline is active in %s\n",
+				__func__);
 		return (0);
 	}
 
@@ -2685,10 +2618,7 @@ static int idetape_add_chrdev_write_request (ide_drive_t *drive, int blocks)
 	unsigned long flags;
 	struct request *rq;
 
-#if IDETAPE_DEBUG_LOG
-	if (tape->debug_level >= 3)
-		printk(KERN_INFO "ide-tape: Reached idetape_add_chrdev_write_request\n");
-#endif /* IDETAPE_DEBUG_LOG */
+	debug_log(DBG_CHRDEV, "Enter %s\n", __func__);
 
      	/*
      	 *	Attempt to allocate a new stage.
@@ -2926,10 +2856,7 @@ static int idetape_add_chrdev_read_request (ide_drive_t *drive,int blocks)
 	struct request *rq_ptr;
 	int bytes_read;
 
-#if IDETAPE_DEBUG_LOG
-	if (tape->debug_level >= 4)
-		printk(KERN_INFO "ide-tape: Reached idetape_add_chrdev_read_request, %d blocks\n", blocks);
-#endif /* IDETAPE_DEBUG_LOG */
+	debug_log(DBG_PROCS, "Enter %s, %d blocks\n", __func__, blocks);
 
 	/*
 	 * If we are at a filemark, return a read length of 0
@@ -3024,12 +2951,11 @@ static int idetape_rewind_tape (ide_drive_t *drive)
 {
 	int retval;
 	idetape_pc_t pc;
-#if IDETAPE_DEBUG_LOG
-	idetape_tape_t *tape = drive->driver_data;
-	if (tape->debug_level >= 2)
-		printk(KERN_INFO "ide-tape: Reached idetape_rewind_tape\n");
-#endif /* IDETAPE_DEBUG_LOG */	
-	
+	idetape_tape_t *tape;
+	tape = drive->driver_data;
+
+	debug_log(DBG_SENSE, "Enter %s\n", __func__);
+
 	idetape_create_rewind_cmd(drive, &pc);
 	retval = idetape_queue_pc_tail(drive, &pc);
 	if (retval)
@@ -3055,10 +2981,8 @@ static int idetape_blkdev_ioctl(ide_drive_t *drive, unsigned int cmd, unsigned l
 	idetape_config_t config;
 	void __user *argp = (void __user *)arg;
 
-#if IDETAPE_DEBUG_LOG	
-	if (tape->debug_level >= 4)
-		printk(KERN_INFO "ide-tape: Reached idetape_blkdev_ioctl\n");
-#endif /* IDETAPE_DEBUG_LOG */
+	debug_log(DBG_PROCS, "Enter %s\n", __func__);
+
 	switch (cmd) {
 		case 0x0340:
 			if (copy_from_user(&config, argp, sizeof (idetape_config_t)))
@@ -3189,10 +3113,7 @@ static ssize_t idetape_chrdev_read (struct file *file, char __user *buf,
 	ssize_t bytes_read,temp, actually_read = 0, rc;
 	ssize_t ret = 0;
 
-#if IDETAPE_DEBUG_LOG
-	if (tape->debug_level >= 3)
-		printk(KERN_INFO "ide-tape: Reached idetape_chrdev_read, count %Zd\n", count);
-#endif /* IDETAPE_DEBUG_LOG */
+	debug_log(DBG_CHRDEV, "Enter %s, count %Zd\n", __func__, count);
 
 	if (tape->chrdev_direction != idetape_direction_read) {
 		if (test_bit(IDETAPE_DETECT_BS, &tape->flags))
@@ -3234,10 +3155,8 @@ static ssize_t idetape_chrdev_read (struct file *file, char __user *buf,
 	}
 finish:
 	if (!actually_read && test_bit(IDETAPE_FILEMARK, &tape->flags)) {
-#if IDETAPE_DEBUG_LOG
-		if (tape->debug_level >= 2)
-			printk(KERN_INFO "ide-tape: %s: spacing over filemark\n", tape->name);
-#endif
+		debug_log(DBG_SENSE, "%s: spacing over filemark\n", tape->name);
+
 		idetape_space_over_filemarks(drive, MTFSF, 1);
 		return 0;
 	}
@@ -3257,11 +3176,7 @@ static ssize_t idetape_chrdev_write (struct file *file, const char __user *buf,
 	if (tape->write_prot)
 		return -EACCES;
 
-#if IDETAPE_DEBUG_LOG
-	if (tape->debug_level >= 3)
-		printk(KERN_INFO "ide-tape: Reached idetape_chrdev_write, "
-			"count %Zd\n", count);
-#endif /* IDETAPE_DEBUG_LOG */
+	debug_log(DBG_CHRDEV, "Enter %s, count %Zd\n", __func__, count);
 
 	/* Initialize write operation */
 	if (tape->chrdev_direction != idetape_direction_write) {
@@ -3420,11 +3335,8 @@ static int idetape_mtioctop (ide_drive_t *drive,short mt_op,int mt_count)
 	idetape_pc_t pc;
 	int i,retval;
 
-#if IDETAPE_DEBUG_LOG
-	if (tape->debug_level >= 1)
-		printk(KERN_INFO "ide-tape: Handling MTIOCTOP ioctl: "
-			"mt_op=%d, mt_count=%d\n", mt_op, mt_count);
-#endif /* IDETAPE_DEBUG_LOG */
+	debug_log(DBG_ERR, "Handling MTIOCTOP ioctl: mt_op=%d, mt_count=%d\n",
+			mt_op, mt_count);
 	/*
 	 *	Commands which need our pipelined read-ahead stages.
 	 */
@@ -3561,11 +3473,7 @@ static int idetape_chrdev_ioctl (struct inode *inode, struct file *file, unsigne
 	int block_offset = 0, position = tape->first_frame_position;
 	void __user *argp = (void __user *)arg;
 
-#if IDETAPE_DEBUG_LOG
-	if (tape->debug_level >= 3)
-		printk(KERN_INFO "ide-tape: Reached idetape_chrdev_ioctl, "
-			"cmd=%u\n", cmd);
-#endif /* IDETAPE_DEBUG_LOG */
+	debug_log(DBG_CHRDEV, "Enter %s, cmd=%u\n", __func__, cmd);
 
 	tape->restart_speed_control_req = 1;
 	if (tape->chrdev_direction == idetape_direction_write) {
@@ -3625,10 +3533,8 @@ static int idetape_chrdev_open (struct inode *inode, struct file *filp)
 	 */
 	filp->f_mode &= ~(FMODE_PREAD | FMODE_PWRITE);
 
-#if IDETAPE_DEBUG_LOG
-	printk(KERN_INFO "ide-tape: Reached idetape_chrdev_open\n");
-#endif /* IDETAPE_DEBUG_LOG */
-	
+	debug_log(DBG_CHRDEV, "Enter %s\n", __func__);
+
 	if (i >= MAX_HWIFS * MAX_DRIVES)
 		return -ENXIO;
 
@@ -3725,10 +3631,8 @@ static int idetape_chrdev_release (struct inode *inode, struct file *filp)
 
 	lock_kernel();
 	tape = drive->driver_data;
-#if IDETAPE_DEBUG_LOG
-	if (tape->debug_level >= 3)
-		printk(KERN_INFO "ide-tape: Reached idetape_chrdev_release\n");
-#endif /* IDETAPE_DEBUG_LOG */
+
+	debug_log(DBG_CHRDEV, "Enter %s\n", __func__);
 
 	if (tape->chrdev_direction == idetape_direction_write)
 		idetape_write_release(drive, minor);
-- 
1.5.3.7

