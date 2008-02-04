Return-Path: <linux-kernel-owner+w=401wt.eu-S1758578AbYBDNt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758578AbYBDNt2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 08:49:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754795AbYBDNnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 08:43:19 -0500
Received: from ti-out-0910.google.com ([209.85.142.190]:58531 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103AbYBDNnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 08:43:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=uD7Wk8xQ5dIUpruveIN3oUpam/1z0yJ4k+AzjAo6yKS9ptbARwGznUFhO03bPB/3wIRXF17l0TuZqPlBGyhDE/MWmlpMDPQotRmfzUO+y3HZ+SodABtDLbnh1MLKs+px5nX2oJx6U96y91sN1Gjsq4zXCIRqgBI1ZL3p5XnsP7U=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 07/22] ide-tape: struct idetape_tape_t: shorten member names v2
Date: Mon,  4 Feb 2008 14:40:25 +0100
Message-Id: <1202132440-26648-8-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1202132440-26648-1-git-send-email-petkovbb@gmail.com>
References: <1202132440-26648-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shorten some member names not too aggressively since this driver might be gone
anyway soon.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |  210 ++++++++++++++++++++++++++----------------------
 1 files changed, 113 insertions(+), 97 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 126e8a9..0b5ccce 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -299,10 +299,8 @@ typedef struct ide_tape_obj {
 	/* Timer used to poll for dsc */
 	struct timer_list dsc_timer;
 	/* Read/Write dsc polling frequency */
-	unsigned long best_dsc_rw_frequency;
-	/* The current polling frequency */
-	unsigned long dsc_polling_frequency;
-	/* Maximum waiting time */
+	unsigned long best_dsc_rw_freq;
+	unsigned long dsc_poll_freq;
 	unsigned long dsc_timeout;
 
 	/*
@@ -310,7 +308,7 @@ typedef struct ide_tape_obj {
 	 */
 	u8 partition;
 	/* Current block */
-	unsigned int first_frame_position;
+	unsigned int first_frame;
 
 	/*
 	 *	Last error information
@@ -326,11 +324,8 @@ typedef struct ide_tape_obj {
 	/* Current character device data transfer direction */
 	u8 chrdev_dir;
 
-	/*
-	 *	Device information
-	 */
-	/* Usually 512 or 1024 bytes */
-	unsigned short tape_block_size;
+	/* tape block size, usu. 512 or 1024 bytes */
+	unsigned short blk_size;
 	int user_bs_factor;
 
 	/* Copy of the tape's Capabilities and Mechanical Page */
@@ -349,8 +344,8 @@ typedef struct ide_tape_obj {
 	 *	The data buffer size is chosen based on the tape's
 	 *	recommendation.
 	 */
-	/* Pointer to the request which is waiting in the device request queue */
-	struct request *active_data_request;
+	/* Ptr to the request which is waiting in the device request queue */
+	struct request *active_data_rq;
 	/* Data buffer size (chosen based on the tape's recommendation */
 	int stage_size;
 	idetape_stage_t *merge_stage;
@@ -388,7 +383,7 @@ typedef struct ide_tape_obj {
 	/* Status/Action flags: long for set_bit */
 	unsigned long flags;
 	/* protects the ide-tape queue */
-	spinlock_t spinlock;
+	spinlock_t lock;
 
 	/*
 	 * Measures average tape speed
@@ -750,7 +745,7 @@ static void idetape_analyze_error(ide_drive_t *drive, u8 *sense)
 	/* Correct pc->actually_transferred by asking the tape.	 */
 	if (test_bit(PC_DMA_ERROR, &pc->flags)) {
 		pc->actually_transferred = pc->request_transfer -
-			tape->tape_block_size *
+			tape->blk_size *
 			be32_to_cpu(get_unaligned((u32 *)&sense[3]));
 		idetape_update_buffers(pc);
 	}
@@ -809,7 +804,7 @@ static void idetape_activate_next_stage(ide_drive_t *drive)
 	rq->rq_disk = tape->disk;
 	rq->buffer = NULL;
 	rq->special = (void *)stage->bh;
-	tape->active_data_request = rq;
+	tape->active_data_rq = rq;
 	tape->active_stage = stage;
 	tape->next_stage = stage->next;
 }
@@ -951,13 +946,13 @@ static int idetape_end_request(ide_drive_t *drive, int uptodate, int nr_sects)
 		return 0;
 	}
 
-	spin_lock_irqsave(&tape->spinlock, flags);
+	spin_lock_irqsave(&tape->lock, flags);
 
 	/* The request was a pipelined data transfer request */
-	if (tape->active_data_request == rq) {
+	if (tape->active_data_rq == rq) {
 		active_stage = tape->active_stage;
 		tape->active_stage = NULL;
-		tape->active_data_request = NULL;
+		tape->active_data_rq = NULL;
 		tape->nr_pending_stages--;
 		if (rq->cmd[0] & REQ_IDETAPE_WRITE) {
 			remove_stage = 1;
@@ -978,7 +973,8 @@ static int idetape_end_request(ide_drive_t *drive, int uptodate, int nr_sects)
 			/*
 			 * Insert the next request into the request queue.
 			 */
-			(void) ide_do_drive_cmd(drive, tape->active_data_request, ide_end);
+			(void)ide_do_drive_cmd(drive, tape->active_data_rq,
+						ide_end);
 		} else if (!error) {
 				idetape_increase_max_pipeline_stages(drive);
 		}
@@ -990,9 +986,9 @@ static int idetape_end_request(ide_drive_t *drive, int uptodate, int nr_sects)
 
 	if (remove_stage)
 		idetape_remove_stage_head(drive);
-	if (tape->active_data_request == NULL)
+	if (tape->active_data_rq == NULL)
 		clear_bit(IDETAPE_PIPELINE_ACTIVE, &tape->flags);
-	spin_unlock_irqrestore(&tape->spinlock, flags);
+	spin_unlock_irqrestore(&tape->lock, flags);
 	return 0;
 }
 
@@ -1089,7 +1085,7 @@ static void idetape_postpone_request (ide_drive_t *drive)
 	debug_log(DBG_PROCS, "Enter %s\n", __func__);
 
 	tape->postponed_rq = HWGROUP(drive)->rq;
-	ide_stall_queue(drive, tape->dsc_polling_frequency);
+	ide_stall_queue(drive, tape->dsc_poll_freq);
 }
 
 /*
@@ -1191,7 +1187,7 @@ static ide_startstop_t idetape_pc_intr(ide_drive_t *drive)
 		    (stat & SEEK_STAT) == 0) {
 			/* Media access command */
 			tape->dsc_polling_start = jiffies;
-			tape->dsc_polling_frequency = IDETAPE_DSC_MA_FAST;
+			tape->dsc_poll_freq = IDETAPE_DSC_MA_FAST;
 			tape->dsc_timeout = jiffies + IDETAPE_DSC_MA_TIMEOUT;
 			/* Allow ide.c to handle other requests */
 			idetape_postpone_request(drive);
@@ -1543,10 +1539,10 @@ static ide_startstop_t idetape_rw_callback (ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	struct request *rq = HWGROUP(drive)->rq;
-	int blocks = tape->pc->actually_transferred / tape->tape_block_size;
+	int blocks = tape->pc->actually_transferred / tape->blk_size;
 
-	tape->avg_size += blocks * tape->tape_block_size;
-	tape->insert_size += blocks * tape->tape_block_size;
+	tape->avg_size += blocks * tape->blk_size;
+	tape->insert_size += blocks * tape->blk_size;
 	if (tape->insert_size > 1024 * 1024)
 		tape->measure_insert_time = 1;
 	if (tape->measure_insert_time) {
@@ -1563,7 +1559,7 @@ static ide_startstop_t idetape_rw_callback (ide_drive_t *drive)
 	}
 	debug_log(DBG_PROCS, "Enter %s\n", __func__);
 
-	tape->first_frame_position += blocks;
+	tape->first_frame += blocks;
 	rq->current_nr_sectors -= blocks;
 
 	if (!tape->pc->error)
@@ -1583,7 +1579,8 @@ static void idetape_create_read_cmd(idetape_tape_t *tape, idetape_pc_t *pc, unsi
 	pc->bh = bh;
 	atomic_set(&bh->b_count, 0);
 	pc->buffer = NULL;
-	pc->request_transfer = pc->buffer_size = length * tape->tape_block_size;
+	pc->buffer_size		= length * tape->blk_size;
+	pc->request_transfer	= length * tape->blk_size;
 	if (pc->request_transfer == tape->stage_size)
 		set_bit(PC_DMA_RECOMMENDED, &pc->flags);
 }
@@ -1621,7 +1618,8 @@ static void idetape_create_write_cmd(idetape_tape_t *tape, idetape_pc_t *pc, uns
 	pc->b_data = bh->b_data;
 	pc->b_count = atomic_read(&bh->b_count);
 	pc->buffer = NULL;
-	pc->request_transfer = pc->buffer_size = length * tape->tape_block_size;
+	pc->request_transfer	= length * tape->blk_size;
+	pc->buffer_size		= length * tape->blk_size;
 	if (pc->request_transfer == tape->stage_size)
 		set_bit(PC_DMA_RECOMMENDED, &pc->flags);
 }
@@ -1689,7 +1687,7 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 	    (stat & SEEK_STAT) == 0) {
 		if (postponed_rq == NULL) {
 			tape->dsc_polling_start = jiffies;
-			tape->dsc_polling_frequency = tape->best_dsc_rw_frequency;
+			tape->dsc_poll_freq = tape->best_dsc_rw_freq;
 			tape->dsc_timeout = jiffies + IDETAPE_DSC_RW_TIMEOUT;
 		} else if (time_after(jiffies, tape->dsc_timeout)) {
 			printk(KERN_ERR "ide-tape: %s: DSC timeout\n",
@@ -1701,7 +1699,7 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 				return ide_do_reset(drive);
 			}
 		} else if (time_after(jiffies, tape->dsc_polling_start + IDETAPE_DSC_MA_THRESHOLD))
-			tape->dsc_polling_frequency = IDETAPE_DSC_MA_SLOW;
+			tape->dsc_poll_freq = IDETAPE_DSC_MA_SLOW;
 		idetape_postpone_request(drive);
 		return ide_stopped;
 	}
@@ -1748,7 +1746,7 @@ static inline int idetape_pipeline_active (idetape_tape_t *tape)
 	int rc1, rc2;
 
 	rc1 = test_bit(IDETAPE_PIPELINE_ACTIVE, &tape->flags);
-	rc2 = (tape->active_data_request != NULL);
+	rc2 = (tape->active_data_rq != NULL);
 	return rc1;
 }
 
@@ -1930,7 +1928,7 @@ static void idetape_add_stage_tail (ide_drive_t *drive,idetape_stage_t *stage)
 
 	debug_log(DBG_PROCS, "Enter %s\n", __func__);
 
-	spin_lock_irqsave(&tape->spinlock, flags);
+	spin_lock_irqsave(&tape->lock, flags);
 	stage->next = NULL;
 	if (tape->last_stage != NULL)
 		tape->last_stage->next=stage;
@@ -1941,7 +1939,7 @@ static void idetape_add_stage_tail (ide_drive_t *drive,idetape_stage_t *stage)
 		tape->next_stage = tape->last_stage;
 	tape->nr_stages++;
 	tape->nr_pending_stages++;
-	spin_unlock_irqrestore(&tape->spinlock, flags);
+	spin_unlock_irqrestore(&tape->lock, flags);
 }
 
 /*
@@ -1962,10 +1960,10 @@ static void idetape_wait_for_request (ide_drive_t *drive, struct request *rq)
 	}
 	rq->end_io_data = &wait;
 	rq->end_io = blk_end_sync_rq;
-	spin_unlock_irq(&tape->spinlock);
+	spin_unlock_irq(&tape->lock);
 	wait_for_completion(&wait);
 	/* The stage and its struct request have been deallocated */
-	spin_lock_irq(&tape->spinlock);
+	spin_lock_irq(&tape->lock);
 }
 
 static ide_startstop_t idetape_read_position_callback(ide_drive_t *drive)
@@ -1992,7 +1990,7 @@ static ide_startstop_t idetape_read_position_callback(ide_drive_t *drive)
 					be32_to_cpu(*(u32 *)&readpos[4]));
 
 			tape->partition = readpos[1];
-			tape->first_frame_position =
+			tape->first_frame =
 				be32_to_cpu(*(u32 *)&readpos[4]);
 			set_bit(IDETAPE_ADDRESS_VALID, &tape->flags);
 			idetape_end_request(drive, 1, 0);
@@ -2134,7 +2132,7 @@ static int idetape_read_position (ide_drive_t *drive)
 	idetape_create_read_position_cmd(&pc);
 	if (idetape_queue_pc_tail(drive, &pc))
 		return -1;
-	position = tape->first_frame_position;
+	position = tape->first_frame;
 	return position;
 }
 
@@ -2174,7 +2172,7 @@ static int __idetape_discard_read_pipeline (ide_drive_t *drive)
 		return 0;
 
 	/* Remove merge stage. */
-	cnt = tape->merge_stage_size / tape->tape_block_size;
+	cnt = tape->merge_stage_size / tape->blk_size;
 	if (test_and_clear_bit(IDETAPE_FILEMARK, &tape->flags))
 		++cnt;		/* Filemarks count as 1 sector */
 	tape->merge_stage_size = 0;
@@ -2191,11 +2189,11 @@ static int __idetape_discard_read_pipeline (ide_drive_t *drive)
 	if (tape->first_stage == NULL)
 		return 0;
 
-	spin_lock_irqsave(&tape->spinlock, flags);
+	spin_lock_irqsave(&tape->lock, flags);
 	tape->next_stage = NULL;
 	if (idetape_pipeline_active(tape))
-		idetape_wait_for_request(drive, tape->active_data_request);
-	spin_unlock_irqrestore(&tape->spinlock, flags);
+		idetape_wait_for_request(drive, tape->active_data_rq);
+	spin_unlock_irqrestore(&tape->lock, flags);
 
 	while (tape->first_stage != NULL) {
 		struct request *rq_ptr = &tape->first_stage->rq;
@@ -2274,7 +2272,7 @@ static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int blocks, struct
 	idetape_init_rq(&rq, cmd);
 	rq.rq_disk = tape->disk;
 	rq.special = (void *)bh;
-	rq.sector = tape->first_frame_position;
+	rq.sector = tape->first_frame;
 	rq.nr_sectors = rq.current_nr_sectors = blocks;
 	(void) ide_do_drive_cmd(drive, &rq, ide_wait);
 
@@ -2285,7 +2283,7 @@ static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int blocks, struct
 		idetape_init_merge_stage(tape);
 	if (rq.errors == IDETAPE_ERROR_GENERAL)
 		return -EIO;
-	return (tape->tape_block_size * (blocks-rq.current_nr_sectors));
+	return (tape->blk_size * (blocks-rq.current_nr_sectors));
 }
 
 /*
@@ -2301,7 +2299,7 @@ static void idetape_insert_pipeline_into_queue (ide_drive_t *drive)
 	if (!idetape_pipeline_active(tape)) {
 		set_bit(IDETAPE_PIPELINE_ACTIVE, &tape->flags);
 		idetape_activate_next_stage(drive);
-		(void) ide_do_drive_cmd(drive, tape->active_data_request, ide_end);
+		(void) ide_do_drive_cmd(drive, tape->active_data_rq, ide_end);
 	}
 }
 
@@ -2347,10 +2345,10 @@ static void idetape_wait_first_stage (ide_drive_t *drive)
 
 	if (tape->first_stage == NULL)
 		return;
-	spin_lock_irqsave(&tape->spinlock, flags);
+	spin_lock_irqsave(&tape->lock, flags);
 	if (tape->active_stage == tape->first_stage)
-		idetape_wait_for_request(drive, tape->active_data_request);
-	spin_unlock_irqrestore(&tape->spinlock, flags);
+		idetape_wait_for_request(drive, tape->active_data_rq);
+	spin_unlock_irqrestore(&tape->lock, flags);
 }
 
 /*
@@ -2378,12 +2376,12 @@ static int idetape_add_chrdev_write_request (ide_drive_t *drive, int blocks)
 	 *	Pay special attention to possible race conditions.
 	 */
 	while ((new_stage = idetape_kmalloc_stage(tape)) == NULL) {
-		spin_lock_irqsave(&tape->spinlock, flags);
+		spin_lock_irqsave(&tape->lock, flags);
 		if (idetape_pipeline_active(tape)) {
-			idetape_wait_for_request(drive, tape->active_data_request);
-			spin_unlock_irqrestore(&tape->spinlock, flags);
+			idetape_wait_for_request(drive, tape->active_data_rq);
+			spin_unlock_irqrestore(&tape->lock, flags);
 		} else {
-			spin_unlock_irqrestore(&tape->spinlock, flags);
+			spin_unlock_irqrestore(&tape->lock, flags);
 			idetape_insert_pipeline_into_queue(drive);
 			if (idetape_pipeline_active(tape))
 				continue;
@@ -2397,7 +2395,7 @@ static int idetape_add_chrdev_write_request (ide_drive_t *drive, int blocks)
 	rq = &new_stage->rq;
 	idetape_init_rq(rq, REQ_IDETAPE_WRITE);
 	/* Doesn't actually matter - We always assume sequential access */
-	rq->sector = tape->first_frame_position;
+	rq->sector = tape->first_frame;
 	rq->nr_sectors = rq->current_nr_sectors = blocks;
 
 	idetape_switch_buffers(tape, new_stage);
@@ -2414,7 +2412,9 @@ static int idetape_add_chrdev_write_request (ide_drive_t *drive, int blocks)
 	 */
 	if (!idetape_pipeline_active(tape)) {
 		if (tape->nr_stages >= tape->max_stages * 9 / 10 ||
-		    tape->nr_stages >= tape->max_stages - tape->uncontrolled_pipeline_head_speed * 3 * 1024 / tape->tape_block_size) {
+			tape->nr_stages >= tape->max_stages -
+			tape->uncontrolled_pipeline_head_speed * 3 * 1024 /
+			tape->blk_size) {
 			tape->measure_insert_time = 1;
 			tape->insert_time = jiffies;
 			tape->insert_size = 0;
@@ -2439,10 +2439,10 @@ static void idetape_wait_for_pipeline (ide_drive_t *drive)
 
 	while (tape->next_stage || idetape_pipeline_active(tape)) {
 		idetape_insert_pipeline_into_queue(drive);
-		spin_lock_irqsave(&tape->spinlock, flags);
+		spin_lock_irqsave(&tape->lock, flags);
 		if (idetape_pipeline_active(tape))
-			idetape_wait_for_request(drive, tape->active_data_request);
-		spin_unlock_irqrestore(&tape->spinlock, flags);
+			idetape_wait_for_request(drive, tape->active_data_rq);
+		spin_unlock_irqrestore(&tape->lock, flags);
 	}
 }
 
@@ -2461,12 +2461,13 @@ static void idetape_empty_write_pipeline (ide_drive_t *drive)
 		tape->merge_stage_size = tape->stage_size;
 	}
 	if (tape->merge_stage_size) {
-		blocks = tape->merge_stage_size / tape->tape_block_size;
-		if (tape->merge_stage_size % tape->tape_block_size) {
+		blocks = tape->merge_stage_size / tape->blk_size;
+		if (tape->merge_stage_size % tape->blk_size) {
 			unsigned int i;
 
 			blocks++;
-			i = tape->tape_block_size - tape->merge_stage_size % tape->tape_block_size;
+			i = tape->blk_size - tape->merge_stage_size %
+				tape->blk_size;
 			bh = tape->bh->b_reqnext;
 			while (bh) {
 				atomic_set(&bh->b_count, 0);
@@ -2572,7 +2573,7 @@ static int idetape_initiate_read (ide_drive_t *drive, int max_stages)
 	if (tape->restart_speed_control_req)
 		idetape_restart_speed_control(drive);
 	idetape_init_rq(&rq, REQ_IDETAPE_READ);
-	rq.sector = tape->first_frame_position;
+	rq.sector = tape->first_frame;
 	rq.nr_sectors = rq.current_nr_sectors = blocks;
 	if (!test_bit(IDETAPE_PIPELINE_ERROR, &tape->flags) &&
 	    tape->nr_stages < max_stages) {
@@ -2625,11 +2626,13 @@ static int idetape_add_chrdev_read_request (ide_drive_t *drive,int blocks)
 	if (tape->first_stage == NULL) {
 		if (test_bit(IDETAPE_PIPELINE_ERROR, &tape->flags))
 			return 0;
-		return idetape_queue_rw_tail(drive, REQ_IDETAPE_READ, blocks, tape->merge_stage->bh);
+		return idetape_queue_rw_tail(drive, REQ_IDETAPE_READ, blocks,
+					tape->merge_stage->bh);
 	}
 	idetape_wait_first_stage(drive);
 	rq_ptr = &tape->first_stage->rq;
-	bytes_read = tape->tape_block_size * (rq_ptr->nr_sectors - rq_ptr->current_nr_sectors);
+	bytes_read = tape->blk_size * (rq_ptr->nr_sectors -
+					rq_ptr->current_nr_sectors);
 	rq_ptr->nr_sectors = rq_ptr->current_nr_sectors = 0;
 
 
@@ -2639,15 +2642,15 @@ static int idetape_add_chrdev_read_request (ide_drive_t *drive,int blocks)
 		idetape_switch_buffers(tape, tape->first_stage);
 		if (rq_ptr->errors == IDETAPE_ERROR_FILEMARK)
 			set_bit(IDETAPE_FILEMARK, &tape->flags);
-		spin_lock_irqsave(&tape->spinlock, flags);
+		spin_lock_irqsave(&tape->lock, flags);
 		idetape_remove_stage_head(drive);
-		spin_unlock_irqrestore(&tape->spinlock, flags);
+		spin_unlock_irqrestore(&tape->lock, flags);
 		tape->pipeline_head++;
 		idetape_calculate_speeds(drive);
 	}
-	if (bytes_read > blocks * tape->tape_block_size) {
+	if (bytes_read > blocks * tape->blk_size) {
 		printk(KERN_ERR "ide-tape: bug: trying to return more bytes than requested\n");
-		bytes_read = blocks * tape->tape_block_size;
+		bytes_read = blocks * tape->blk_size;
 	}
 	return (bytes_read);
 }
@@ -2664,7 +2667,7 @@ static void idetape_pad_zeros (ide_drive_t *drive, int bcount)
 		bh = tape->merge_stage->bh;
 		count = min(tape->stage_size, bcount);
 		bcount -= count;
-		blocks = count / tape->tape_block_size;
+		blocks = count / tape->blk_size;
 		while (count) {
 			atomic_set(&bh->b_count, min(count, (unsigned int)bh->b_size));
 			memset(bh->b_data, 0, atomic_read(&bh->b_count));
@@ -2686,9 +2689,10 @@ static int idetape_pipeline_size (ide_drive_t *drive)
 	stage = tape->first_stage;
 	while (stage != NULL) {
 		rq = &stage->rq;
-		size += tape->tape_block_size * (rq->nr_sectors-rq->current_nr_sectors);
+		size += tape->blk_size * (rq->nr_sectors -
+				rq->current_nr_sectors);
 		if (rq->errors == IDETAPE_ERROR_FILEMARK)
-			size += tape->tape_block_size;
+			size += tape->blk_size;
 		stage = stage->next;
 	}
 	size += tape->merge_stage_size;
@@ -2745,11 +2749,11 @@ static int idetape_blkdev_ioctl(ide_drive_t *drive, unsigned int cmd, unsigned l
 		case 0x0340:
 			if (copy_from_user(&config, argp, sizeof(config)))
 				return -EFAULT;
-			tape->best_dsc_rw_frequency = config.dsc_rw_frequency;
+			tape->best_dsc_rw_freq = config.dsc_rw_frequency;
 			tape->max_stages = config.nr_stages;
 			break;
 		case 0x0350:
-			config.dsc_rw_frequency = (int) tape->best_dsc_rw_frequency;
+			config.dsc_rw_frequency = (int) tape->best_dsc_rw_freq;
 			config.nr_stages = tape->max_stages; 
 			if (copy_to_user(argp, &config, sizeof(config)))
 				return -EFAULT;
@@ -2799,7 +2803,7 @@ static int idetape_space_over_filemarks (ide_drive_t *drive,short mt_op,int mt_c
 					set_bit(IDETAPE_FILEMARK, &tape->flags);
 				return 0;
 			}
-			spin_lock_irqsave(&tape->spinlock, flags);
+			spin_lock_irqsave(&tape->lock, flags);
 			if (tape->first_stage == tape->active_stage) {
 				/*
 				 *	We have reached the active stage in the read pipeline.
@@ -2811,11 +2815,11 @@ static int idetape_space_over_filemarks (ide_drive_t *drive,short mt_op,int mt_c
 				 *	__idetape_discard_read_pipeline(), for example.
 				 */
 				tape->next_stage = NULL;
-				spin_unlock_irqrestore(&tape->spinlock, flags);
+				spin_unlock_irqrestore(&tape->lock, flags);
 				idetape_wait_first_stage(drive);
 				tape->next_stage = tape->first_stage->next;
 			} else
-				spin_unlock_irqrestore(&tape->spinlock, flags);
+				spin_unlock_irqrestore(&tape->lock, flags);
 			if (tape->first_stage->rq.errors == IDETAPE_ERROR_FILEMARK)
 				++count;
 			idetape_remove_stage_head(drive);
@@ -2877,9 +2881,9 @@ static ssize_t idetape_chrdev_read (struct file *file, char __user *buf,
 
 	if (tape->chrdev_dir != IDETAPE_DIR_READ) {
 		if (test_bit(IDETAPE_DETECT_BS, &tape->flags))
-			if (count > tape->tape_block_size &&
-			    (count % tape->tape_block_size) == 0)
-				tape->user_bs_factor = count / tape->tape_block_size;
+			if (count > tape->blk_size &&
+			    (count % tape->blk_size) == 0)
+				tape->user_bs_factor = count / tape->blk_size;
 	}
 	if ((rc = idetape_initiate_read(drive, tape->max_stages)) < 0)
 		return rc;
@@ -3116,9 +3120,11 @@ static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
 			return (idetape_queue_pc_tail(drive, &pc));
 		case MTSETBLK:
 			if (mt_count) {
-				if (mt_count < tape->tape_block_size || mt_count % tape->tape_block_size)
+				if (mt_count < tape->blk_size ||
+				    mt_count % tape->blk_size)
 					return -EIO;
-				tape->user_bs_factor = mt_count / tape->tape_block_size;
+				tape->user_bs_factor = mt_count /
+							tape->blk_size;
 				clear_bit(IDETAPE_DETECT_BS, &tape->flags);
 			} else
 				set_bit(IDETAPE_DETECT_BS, &tape->flags);
@@ -3165,7 +3171,7 @@ static int idetape_chrdev_ioctl(struct inode *inode, struct file *file,
 	struct mtop mtop;
 	struct mtget mtget;
 	struct mtpos mtpos;
-	int block_offset = 0, position = tape->first_frame_position;
+	int block_offset = 0, position = tape->first_frame;
 	void __user *argp = (void __user *)arg;
 
 	debug_log(DBG_CHRDEV, "Enter %s, cmd=%u\n", __func__, cmd);
@@ -3176,7 +3182,8 @@ static int idetape_chrdev_ioctl(struct inode *inode, struct file *file,
 		idetape_flush_tape_buffers(drive);
 	}
 	if (cmd == MTIOCGET || cmd == MTIOCPOS) {
-		block_offset = idetape_pipeline_size(drive) / (tape->tape_block_size * tape->user_bs_factor);
+		block_offset = idetape_pipeline_size(drive) /
+			(tape->blk_size * tape->user_bs_factor);
 		if ((position = idetape_read_position(drive)) < 0)
 			return -EIO;
 	}
@@ -3189,7 +3196,10 @@ static int idetape_chrdev_ioctl(struct inode *inode, struct file *file,
 			memset(&mtget, 0, sizeof (struct mtget));
 			mtget.mt_type = MT_ISSCSI2;
 			mtget.mt_blkno = position / tape->user_bs_factor - block_offset;
-			mtget.mt_dsreg = ((tape->tape_block_size * tape->user_bs_factor) << MT_ST_BLKSIZE_SHIFT) & MT_ST_BLKSIZE_MASK;
+			mtget.mt_dsreg =
+				((tape->blk_size * tape->user_bs_factor)
+				 << MT_ST_BLKSIZE_SHIFT) & MT_ST_BLKSIZE_MASK;
+
 			if (tape->drv_write_prot) {
 				mtget.mt_gstat |= GMT_WR_PROT(0xffffffff);
 			}
@@ -3220,14 +3230,14 @@ static void ide_tape_get_bsize_from_bdesc(ide_drive_t *drive)
 	idetape_create_mode_sense_cmd(&pc, IDETAPE_BLOCK_DESCRIPTOR);
 	if (idetape_queue_pc_tail(drive, &pc)) {
 		printk(KERN_ERR "ide-tape: Can't get block descriptor\n");
-		if (tape->tape_block_size == 0) {
+		if (tape->blk_size == 0) {
 			printk(KERN_WARNING "ide-tape: Cannot deal with zero "
 					    "block size, assuming 32k\n");
-			tape->tape_block_size = 32768;
+			tape->blk_size = 32768;
 		}
 		return;
 	}
-	tape->tape_block_size = (pc.buffer[4 + 5] << 16) +
+	tape->blk_size = (pc.buffer[4 + 5] << 16) +
 				(pc.buffer[4 + 6] << 8)  +
 				 pc.buffer[4 + 7];
 	tape->drv_write_prot = (pc.buffer[2] & 0x80) >> 7;
@@ -3329,7 +3339,8 @@ static void idetape_write_release (ide_drive_t *drive, unsigned int minor)
 	idetape_empty_write_pipeline(drive);
 	tape->merge_stage = __idetape_kmalloc_stage(tape, 1, 0);
 	if (tape->merge_stage != NULL) {
-		idetape_pad_zeros(drive, tape->tape_block_size * (tape->user_bs_factor - 1));
+		idetape_pad_zeros(drive, tape->blk_size *
+				(tape->user_bs_factor - 1));
 		__idetape_kfree_stage(tape->merge_stage);
 		tape->merge_stage = NULL;
 	}
@@ -3456,7 +3467,7 @@ static void idetape_get_mode_sense_results (ide_drive_t *drive)
 	if (idetape_queue_pc_tail(drive, &pc)) {
 		printk(KERN_ERR "ide-tape: Can't get tape parameters - assuming"
 				" some default values\n");
-		tape->tape_block_size = 512;
+		tape->blk_size = 512;
 		put_unaligned(52,   (u16 *)&tape->caps[12]);
 		put_unaligned(540,  (u16 *)&tape->caps[14]);
 		put_unaligned(6*52, (u16 *)&tape->caps[16]);
@@ -3486,9 +3497,9 @@ static void idetape_get_mode_sense_results (ide_drive_t *drive)
 
 	memcpy(&tape->caps, caps, 20);
 	if (caps[7] & 0x02)
-		tape->tape_block_size = 512;
+		tape->blk_size = 512;
 	else if (caps[7] & 0x04)
-		tape->tape_block_size = 1024;
+		tape->blk_size = 1024;
 }
 
 #ifdef CONFIG_IDE_PROC_FS
@@ -3508,8 +3519,11 @@ static void idetape_add_settings (ide_drive_t *drive)
 	ide_add_setting(drive,	"pipeline_pending",	SETTING_READ,	TYPE_INT,	0,			0xffff,			tape->stage_size / 1024,	1,		&tape->nr_pending_stages,		NULL);
 	ide_add_setting(drive, "speed", SETTING_READ, TYPE_SHORT, 0, 0xffff,
 			1, 1, (u16 *)&tape->caps[14], NULL);
-	ide_add_setting(drive,	"stage",		SETTING_READ,	TYPE_INT,	0,			0xffff,			1,				1024,		&tape->stage_size,			NULL);
-	ide_add_setting(drive,	"tdsc",			SETTING_RW,	TYPE_INT,	IDETAPE_DSC_RW_MIN,	IDETAPE_DSC_RW_MAX,	1000,				HZ,		&tape->best_dsc_rw_frequency,		NULL);
+	ide_add_setting(drive, "stage", SETTING_READ, TYPE_INT,	0, 0xffff, 1,
+			1024, &tape->stage_size, NULL);
+	ide_add_setting(drive, "tdsc", SETTING_RW, TYPE_INT, IDETAPE_DSC_RW_MIN,
+			IDETAPE_DSC_RW_MAX, 1000, HZ, &tape->best_dsc_rw_freq,
+			NULL);
 	ide_add_setting(drive,	"dsc_overlap",		SETTING_RW,	TYPE_BYTE,	0,			1,			1,				1,		&drive->dsc_overlap,			NULL);
 	ide_add_setting(drive,	"pipeline_head_speed_c",SETTING_READ,	TYPE_INT,	0,			0xffff,			1,				1,		&tape->controlled_pipeline_head_speed,	NULL);
 	ide_add_setting(drive,	"pipeline_head_speed_u",SETTING_READ,	TYPE_INT,	0,			0xffff,			1,				1,		&tape->uncontrolled_pipeline_head_speed,NULL);
@@ -3542,7 +3556,7 @@ static void idetape_setup (ide_drive_t *drive, idetape_tape_t *tape, int minor)
 	struct sysinfo si;
 	u16 *ctl = (u16 *)&tape->caps[12];
 
-	spin_lock_init(&tape->spinlock);
+	spin_lock_init(&tape->lock);
 	drive->dsc_overlap = 1;
 	if (drive->hwif->host_flags & IDE_HFLAG_NO_DSC) {
 		printk(KERN_INFO "ide-tape: %s: disabling DSC overlap\n",
@@ -3570,11 +3584,11 @@ static void idetape_setup (ide_drive_t *drive, idetape_tape_t *tape, int minor)
 	idetape_get_mode_sense_results(drive);
 	ide_tape_get_bsize_from_bdesc(drive);
 	tape->user_bs_factor = 1;
-	tape->stage_size = *ctl * tape->tape_block_size;
+	tape->stage_size = *ctl * tape->blk_size;
 	while (tape->stage_size > 0xffff) {
 		printk(KERN_NOTICE "ide-tape: decreasing stage size\n");
 		*ctl /= 2;
-		tape->stage_size = *ctl * tape->tape_block_size;
+		tape->stage_size = *ctl * tape->blk_size;
 	}
 	stage_size = tape->stage_size;
 	tape->pages_per_stage = stage_size / PAGE_SIZE;
@@ -3613,14 +3627,16 @@ static void idetape_setup (ide_drive_t *drive, idetape_tape_t *tape, int minor)
 	 *	Ensure that the number we got makes sense; limit
 	 *	it within IDETAPE_DSC_RW_MIN and IDETAPE_DSC_RW_MAX.
 	 */
-	tape->best_dsc_rw_frequency = max_t(unsigned long, min_t(unsigned long, t, IDETAPE_DSC_RW_MAX), IDETAPE_DSC_RW_MIN);
+	tape->best_dsc_rw_freq = max_t(unsigned long,
+				min_t(unsigned long, t, IDETAPE_DSC_RW_MAX),
+				IDETAPE_DSC_RW_MIN);
 	printk(KERN_INFO "ide-tape: %s <-> %s: %dKBps, %d*%dkB buffer, "
 		"%dkB pipeline, %lums tDSC%s\n",
 		drive->name, tape->name, *(u16 *)&tape->caps[14],
 		(*(u16 *)&tape->caps[16] * 512) / tape->stage_size,
 		tape->stage_size / 1024,
 		tape->max_stages * tape->stage_size / 1024,
-		tape->best_dsc_rw_frequency * 1000 / HZ,
+		tape->best_dsc_rw_freq * 1000 / HZ,
 		drive->using_dma ? ", DMA":"");
 
 	idetape_add_settings(drive);
-- 
1.5.3.7

