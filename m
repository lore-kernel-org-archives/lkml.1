Return-Path: <linux-kernel-owner+w=401wt.eu-S1756496AbYBDNnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756496AbYBDNnj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 08:43:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755519AbYBDNmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 08:42:21 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:25871 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754685AbYBDNmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 08:42:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=QdB2Be75JOpcJkbFq8571vyyLY6FhlX7mVmHPNtBmsopN7fLIeHsCdWxMRQJSFRBUsHriDfYmmgLcaq33OsL0FEszquK4UIAVQUCIKb1DAwD9nTHH1+JCUeolizDOACm28YwpBCvEePFJZ/OHeI6FJ2lND964DSuh48FW5D+KLI=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 01/22] ide-tape: refactor the debug logging facility
Date: Mon,  4 Feb 2008 14:40:19 +0100
Message-Id: <1202132440-26648-2-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1202132440-26648-1-git-send-email-petkovbb@gmail.com>
References: <1202132440-26648-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Teach the debug logging macro to differentiate between log levels based on the
type of debug level enabled specifically instead of a threshold-based one.
Thus, convert tape->debug_level to a bitmask that is written to over /proc.

Also,
- cleanup and simplify the debug macro thus removing a lot of code lines,
- get rid of unused debug levels,
- adjust the loglevel at several places where it was simply missing (e.g.
  idetape_chrdev_open())
- move the tape ptr initialization up in idetape_chrdev_open() so that we can
  use it in the debug_log macro earlier in the function.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |  344 +++++++++++++++++-------------------------------
 1 files changed, 122 insertions(+), 222 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 4168a06..442d71c 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -45,6 +45,32 @@
 #include <asm/unaligned.h>
 #include <linux/mtio.h>
 
+enum {
+	/* output errors only */
+	DBG_ERR =		(1 << 0),
+	/* output all sense key/asc */
+	DBG_SENSE =		(1 << 1),
+	/* info regarding all chrdev-related procedures */
+	DBG_CHRDEV =		(1 << 2),
+	/* all remaining procedures */
+	DBG_PROCS =		(1 << 3),
+	/* buffer alloc info (pc_stack & rq_stack) */
+	DBG_PCRQ_STACK =	(1 << 4),
+};
+
+/* define to see debug info */
+#define IDETAPE_DEBUG_LOG		0
+
+#if IDETAPE_DEBUG_LOG
+#define debug_log(lvl, fmt, args...)			\
+{							\
+	if (tape->debug_mask & lvl)			\
+	printk(KERN_INFO "ide-tape: " fmt, ## args);	\
+}
+#else
+#define debug_log(lvl, fmt, args...) do {} while (0)
+#endif
+
 /**************************** Tunable parameters *****************************/
 
 
@@ -68,23 +94,6 @@
 #define IDETAPE_INCREASE_STAGES_RATE	 20
 
 /*
- *	The following are used to debug the driver:
- *
- *	Setting IDETAPE_DEBUG_LOG to 1 will log driver flow control.s
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
-#define IDETAPE_DEBUG_LOG		0
-
-/*
  *	After each failed packet command we issue a request sense command
  *	and retry the packet command IDETAPE_MAX_PC_RETRIES times.
  *
@@ -451,18 +460,7 @@ typedef struct ide_tape_obj {
 	unsigned long uncontrolled_previous_head_time;
 	int restart_speed_control_req;
 
-        /*
-         * Debug_level determines amount of debugging output;
-         * can be changed using /proc/ide/hdx/settings
-         * 0 : almost no debugging output
-         * 1 : 0+output errors only
-         * 2 : 1+output all sensekey/asc
-         * 3 : 2+follow all chrdev related procedures
-         * 4 : 3+follow all procedures
-         * 5 : 4+include pc_stack rq_stack info
-         * 6 : 5+USE_COUNT updates
-         */
-         int debug_level; 
+	u32 debug_mask;
 } idetape_tape_t;
 
 static DEFINE_MUTEX(idetape_ref_mutex);
@@ -716,11 +714,8 @@ static idetape_pc_t *idetape_next_pc_storage (ide_drive_t *drive)
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
@@ -743,11 +738,8 @@ static struct request *idetape_next_rq_storage (ide_drive_t *drive)
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
@@ -780,17 +772,9 @@ static void idetape_analyze_error(ide_drive_t *drive, u8 *sense)
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
@@ -843,12 +827,11 @@ static void idetape_activate_next_stage(ide_drive_t *drive)
 	idetape_stage_t *stage = tape->next_stage;
 	struct request *rq = &stage->rq;
 
-#if IDETAPE_DEBUG_LOG
-	if (tape->debug_level >= 4)
-		printk(KERN_INFO "ide-tape: Reached idetape_active_next_stage\n");
-#endif /* IDETAPE_DEBUG_LOG */
+	debug_log(DBG_PROCS, "Enter %s\n", __func__);
+
 	if (stage == NULL) {
-		printk(KERN_ERR "ide-tape: bug: Trying to activate a non existing stage\n");
+		printk(KERN_ERR "ide-tape: bug: Trying to activate a non"
+				" existing stage\n");
 		return;
 	}
 
@@ -871,11 +854,8 @@ static void idetape_increase_max_pipeline_stages (ide_drive_t *drive)
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
@@ -920,17 +900,16 @@ static void idetape_remove_stage_head (ide_drive_t *drive)
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
@@ -957,10 +936,8 @@ static void idetape_abort_pipeline(ide_drive_t *drive,
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
@@ -987,10 +964,7 @@ static int idetape_end_request(ide_drive_t *drive, int uptodate, int nr_sects)
 	int remove_stage = 0;
 	idetape_stage_t *active_stage;
 
-#if IDETAPE_DEBUG_LOG
-        if (tape->debug_level >= 4)
-	printk(KERN_INFO "ide-tape: Reached idetape_end_request\n");
-#endif /* IDETAPE_DEBUG_LOG */
+	debug_log(DBG_PROCS, "Enter %s\n", __func__);
 
 	switch (uptodate) {
 		case 0:	error = IDETAPE_ERROR_GENERAL; break;
@@ -1055,10 +1029,8 @@ static ide_startstop_t idetape_request_sense_callback (ide_drive_t *drive)
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
@@ -1143,10 +1115,8 @@ static void idetape_postpone_request (ide_drive_t *drive)
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
@@ -1171,11 +1141,7 @@ static ide_startstop_t idetape_pc_intr (ide_drive_t *drive)
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
@@ -1208,20 +1174,16 @@ static ide_startstop_t idetape_pc_intr (ide_drive_t *drive)
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
@@ -1236,19 +1198,15 @@ static ide_startstop_t idetape_pc_intr (ide_drive_t *drive)
 			stat &= ~ERR_STAT;
 		if ((stat & ERR_STAT) || test_bit(PC_DMA_ERROR, &pc->flags)) {
 			/* Error detected */
-#if IDETAPE_DEBUG_LOG
-			if (tape->debug_level >= 1)
-				printk(KERN_INFO "ide-tape: %s: I/O error\n",
-					tape->name);
-#endif /* IDETAPE_DEBUG_LOG */
+			debug_log(DBG_ERR, "%s: I/O error\n", tape->name);
+
 			if (pc->c[0] == REQUEST_SENSE) {
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
@@ -1303,10 +1261,9 @@ static ide_startstop_t idetape_pc_intr (ide_drive_t *drive)
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
@@ -1327,11 +1284,10 @@ static ide_startstop_t idetape_pc_intr (ide_drive_t *drive)
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
@@ -1464,10 +1420,7 @@ static ide_startstop_t idetape_issue_packet_command (ide_drive_t *drive, idetape
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
@@ -1505,11 +1458,8 @@ static ide_startstop_t idetape_issue_packet_command (ide_drive_t *drive, idetape
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
@@ -1640,11 +1590,7 @@ static ide_startstop_t idetape_rw_callback (ide_drive_t *drive)
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
@@ -1720,12 +1666,9 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
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
@@ -1916,10 +1859,7 @@ static idetape_stage_t *idetape_kmalloc_stage (idetape_tape_t *tape)
 {
 	idetape_stage_t *cache_stage = tape->cache_stage;
 
-#if IDETAPE_DEBUG_LOG
-	if (tape->debug_level >= 4)
-		printk(KERN_INFO "ide-tape: Reached idetape_kmalloc_stage\n");
-#endif /* IDETAPE_DEBUG_LOG */
+	debug_log(DBG_PROCS, "Enter %s\n", __func__);
 
 	if (tape->nr_stages >= tape->max_stages)
 		return NULL;
@@ -2018,11 +1958,9 @@ static void idetape_add_stage_tail (ide_drive_t *drive,idetape_stage_t *stage)
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
@@ -2065,29 +2003,22 @@ static ide_startstop_t idetape_read_position_callback (ide_drive_t *drive)
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
@@ -2227,10 +2158,7 @@ static int idetape_read_position (ide_drive_t *drive)
 	idetape_pc_t pc;
 	int position;
 
-#if IDETAPE_DEBUG_LOG
-        if (tape->debug_level >= 4)
-		printk(KERN_INFO "ide-tape: Reached idetape_read_position\n");
-#endif /* IDETAPE_DEBUG_LOG */
+	debug_log(DBG_PROCS, "Enter %s\n", __func__);
 
 	idetape_create_read_position_cmd(&pc);
 	if (idetape_queue_pc_tail(drive, &pc))
@@ -2364,12 +2292,11 @@ static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int blocks, struct
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
 
@@ -2473,10 +2400,7 @@ static int idetape_add_chrdev_write_request (ide_drive_t *drive, int blocks)
 	unsigned long flags;
 	struct request *rq;
 
-#if IDETAPE_DEBUG_LOG
-	if (tape->debug_level >= 3)
-		printk(KERN_INFO "ide-tape: Reached idetape_add_chrdev_write_request\n");
-#endif /* IDETAPE_DEBUG_LOG */
+	debug_log(DBG_CHRDEV, "Enter %s\n", __func__);
 
      	/*
      	 *	Attempt to allocate a new stage.
@@ -2714,10 +2638,7 @@ static int idetape_add_chrdev_read_request (ide_drive_t *drive,int blocks)
 	struct request *rq_ptr;
 	int bytes_read;
 
-#if IDETAPE_DEBUG_LOG
-	if (tape->debug_level >= 4)
-		printk(KERN_INFO "ide-tape: Reached idetape_add_chrdev_read_request, %d blocks\n", blocks);
-#endif /* IDETAPE_DEBUG_LOG */
+	debug_log(DBG_PROCS, "Enter %s, %d blocks\n", __func__, blocks);
 
 	/*
 	 * If we are at a filemark, return a read length of 0
@@ -2812,12 +2733,11 @@ static int idetape_rewind_tape (ide_drive_t *drive)
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
@@ -2848,10 +2768,8 @@ static int idetape_blkdev_ioctl(ide_drive_t *drive, unsigned int cmd, unsigned l
 		int nr_stages;
 	} config;
 
-#if IDETAPE_DEBUG_LOG	
-	if (tape->debug_level >= 4)
-		printk(KERN_INFO "ide-tape: Reached idetape_blkdev_ioctl\n");
-#endif /* IDETAPE_DEBUG_LOG */
+	debug_log(DBG_PROCS, "Enter %s\n", __func__);
+
 	switch (cmd) {
 		case 0x0340:
 			if (copy_from_user(&config, argp, sizeof(config)))
@@ -2984,10 +2902,7 @@ static ssize_t idetape_chrdev_read (struct file *file, char __user *buf,
 	ssize_t ret = 0;
 	u16 ctl = *(u16 *)&tape->caps[12];
 
-#if IDETAPE_DEBUG_LOG
-	if (tape->debug_level >= 3)
-		printk(KERN_INFO "ide-tape: Reached idetape_chrdev_read, count %Zd\n", count);
-#endif /* IDETAPE_DEBUG_LOG */
+	debug_log(DBG_CHRDEV, "Enter %s, count %Zd\n", __func__, count);
 
 	if (tape->chrdev_direction != idetape_direction_read) {
 		if (test_bit(IDETAPE_DETECT_BS, &tape->flags))
@@ -3029,10 +2944,8 @@ static ssize_t idetape_chrdev_read (struct file *file, char __user *buf,
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
@@ -3053,11 +2966,7 @@ static ssize_t idetape_chrdev_write (struct file *file, const char __user *buf,
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
@@ -3167,11 +3076,8 @@ static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
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
@@ -3291,11 +3197,7 @@ static int idetape_chrdev_ioctl(struct inode *inode, struct file *file,
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
@@ -3371,6 +3273,15 @@ static int idetape_chrdev_open (struct inode *inode, struct file *filp)
 	idetape_pc_t pc;
 	int retval;
 
+	if (i >= MAX_HWIFS * MAX_DRIVES)
+		return -ENXIO;
+
+	tape = ide_tape_chrdev_get(i);
+	if (!tape)
+		return -ENXIO;
+
+	debug_log(DBG_CHRDEV, "Enter %s\n", __func__);
+
 	/*
 	 * We really want to do nonseekable_open(inode, filp); here, but some
 	 * versions of tar incorrectly call lseek on tapes and bail out if that
@@ -3378,16 +3289,6 @@ static int idetape_chrdev_open (struct inode *inode, struct file *filp)
 	 */
 	filp->f_mode &= ~(FMODE_PREAD | FMODE_PWRITE);
 
-#if IDETAPE_DEBUG_LOG
-	printk(KERN_INFO "ide-tape: Reached idetape_chrdev_open\n");
-#endif /* IDETAPE_DEBUG_LOG */
-	
-	if (i >= MAX_HWIFS * MAX_DRIVES)
-		return -ENXIO;
-
-	if (!(tape = ide_tape_chrdev_get(i)))
-		return -ENXIO;
-
 	drive = tape->drive;
 
 	filp->private_data = tape;
@@ -3478,10 +3379,8 @@ static int idetape_chrdev_release (struct inode *inode, struct file *filp)
 
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
@@ -3648,7 +3547,8 @@ static void idetape_add_settings (ide_drive_t *drive)
 	ide_add_setting(drive,	"pipeline_head_speed_c",SETTING_READ,	TYPE_INT,	0,			0xffff,			1,				1,		&tape->controlled_pipeline_head_speed,	NULL);
 	ide_add_setting(drive,	"pipeline_head_speed_u",SETTING_READ,	TYPE_INT,	0,			0xffff,			1,				1,		&tape->uncontrolled_pipeline_head_speed,NULL);
 	ide_add_setting(drive,	"avg_speed",		SETTING_READ,	TYPE_INT,	0,			0xffff,			1,				1,		&tape->avg_speed,			NULL);
-	ide_add_setting(drive,	"debug_level",		SETTING_RW,	TYPE_INT,	0,			0xffff,			1,				1,		&tape->debug_level,			NULL);
+	ide_add_setting(drive, "debug_mask", SETTING_RW, TYPE_INT, 0, 0xffff, 1,
+			1, &tape->debug_mask, NULL);
 }
 #else
 static inline void idetape_add_settings(ide_drive_t *drive) { ; }
-- 
1.5.3.7

