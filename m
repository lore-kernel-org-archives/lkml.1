Return-Path: <linux-kernel-owner+w=401wt.eu-S1759775AbYBFFYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759775AbYBFFYX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 00:24:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751232AbYBFFYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 00:24:07 -0500
Received: from hu-out-0506.google.com ([72.14.214.229]:37818 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbYBFFYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 00:24:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent:from;
        b=VjU427VkcJNV8KuNroGhrX+Snn1FS5WTNKGzUhl/iYr0MscHuFThljlkrTBKBhU/39SxVZTuiI7+48BfwXuekcVO0aqq6IhrmGt0ZNOPqxx2B+EHSlH8TTQUkKJLCgTvsdkka+dF1hsi0wnDKAyjEOpypAvSyatQZNl9EQMvOzU=
Date: Wed, 6 Feb 2008 06:23:43 +0100
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: ide-tape redux (was: Re:)
Message-ID: <20080206052343.GA14349@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1202132440-26648-1-git-send-email-petkovbb@gmail.com> <200802050220.22637.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200802050220.22637.bzolnier@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2008 at 02:20:22AM +0100, Bartlomiej Zolnierkiewicz wrote:

[...]

> w.r.t. #11 ide-tape uses char devices and supports DSC so it is not as obvious
> as in ide-floppy case that all atomic bitops can be just removed (extra audit
> and some time -mm are required) so please resync/resubmit

Ok, here's what i think we should do here: There are two flags that handle DSC:
PC_FL_WAIT_FOR_DSC and IDETAPE_FL_IGNORE_DSC. The first one is per pc and is set in
all the packet command init functions ..create_bla_cmd() after their callers have
created a pc on the stack and reached its ptr down for initialization. This case
is carefree since the bit will be tested first in the interrupt handler and this
happens only after the pc is queued (ide_do_drive_cmd()) into the request buffer.

The other flag, IDETAPE_FL_IGNORE_DSC, is polled for in the request handler and
can be set when a pc is being retried and we should leave only those atomic
tests intact, imho, but i'm definitely gonna need a second opinion here.

---

commit 1ed8ae92249d5dff7af4ee88710ea08ff3f3356f
Author: Borislav Petkov <petkovbb@gmail.com>
Date:   Tue Feb 5 08:05:35 2008 +0100

    ide-tape: remove atomic test/set macros
    
    Also, since the driver supports DSC, leave the atomic tests
    for the IDETAPE_FL_IGNORE_DSC bit untouched because this is polled
    for in the request handler and can be set in the interrupt
    handler through idetape_retry_pc() after enabling interrupts.
    
    Finally, remove flag IDETAPE_READ_ERROR since it is unused.
    
    Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index e59e49e..9455ce4 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -206,24 +206,24 @@ typedef struct idetape_packet_command_s {
 	/* Temporary buffer */
 	u8 pc_buffer[IDETAPE_PC_BUFFER_SIZE];
 	/* Status/Action bit flags: long for set_bit */
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
 
 /* A pipeline stage. */
 typedef struct idetape_stage_s {
@@ -357,8 +357,7 @@ typedef struct ide_tape_obj {
 	/* Wasted space in each stage */
 	int excess_bh_size;
 
-	/* Status/Action flags: long for set_bit */
-	unsigned long flags;
+	unsigned int flags;
 	/* protects the ide-tape queue */
 	spinlock_t lock;
 
@@ -451,20 +450,26 @@ static void ide_tape_put(struct ide_tape_obj *tape)
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
 
 /* A define for the READ BUFFER command */
 #define IDETAPE_RETRIEVE_FAULTY_BLOCK	6
@@ -595,7 +600,7 @@ static void idetape_update_buffers(idetape_pc_t *pc)
 	int count;
 	unsigned int bcount = pc->actually_transferred;
 
-	if (test_bit(PC_WRITING, &pc->flags))
+	if (pc->flags & PC_FL_WRITING)
 		return;
 	while (bcount) {
 		if (bh == NULL) {
@@ -681,8 +686,8 @@ static void idetape_analyze_error(ide_drive_t *drive, u8 *sense)
 	debug_log(DBG_ERR, "pc = %x, sense key = %x, asc = %x, ascq = %x\n",
 		 pc->c[0], tape->sense_key, tape->asc, tape->ascq);
 
-	/* Correct pc->actually_transferred by asking the tape.	 */
-	if (test_bit(PC_DMA_ERROR, &pc->flags)) {
+	/* Correct pc->actually_transferred by asking the tape. */
+	if (pc->flags & PC_FL_DMA_ERROR) {
 		pc->actually_transferred = pc->request_transfer -
 			tape->blk_size *
 			be32_to_cpu(get_unaligned((u32 *)&sense[3]));
@@ -701,27 +706,26 @@ static void idetape_analyze_error(ide_drive_t *drive, u8 *sense)
 			/* don't report an error, everything's ok */
 			pc->error = 0;
 			/* don't retry read/write */
-			set_bit(PC_ABORT, &pc->flags);
+			pc->flags |= PC_FL_ABORT;
 		}
 	}
 	if (pc->c[0] == READ_6 && (sense[2] & 0x80)) {
 		pc->error = IDETAPE_ERROR_FILEMARK;
-		set_bit(PC_ABORT, &pc->flags);
+		pc->flags |= PC_FL_ABORT;
 	}
 	if (pc->c[0] == WRITE_6) {
 		if ((sense[2] & 0x40) || (tape->sense_key == 0xd
 		     && tape->asc == 0x0 && tape->ascq == 0x2)) {
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
-		    pc->actually_transferred)
+		if (!(pc->flags & PC_FL_ABORT) && pc->actually_transferred)
 			pc->retries = IDETAPE_MAX_PC_RETRIES + 1;
 	}
 }
@@ -876,14 +880,14 @@ static int idetape_end_request(ide_drive_t *drive, int uptodate, int nr_sects)
 		if (rq->cmd[0] & REQ_IDETAPE_WRITE) {
 			remove_stage = 1;
 			if (error) {
-				set_bit(IDETAPE_PIPELINE_ERROR, &tape->flags);
+				tape->flags |= IDETAPE_FL_PIPELINE_ERR;
 				if (error == IDETAPE_ERROR_EOD)
 					idetape_abort_pipeline(drive,
 								active_stage);
 			}
 		} else if (rq->cmd[0] & REQ_IDETAPE_READ) {
 			if (error == IDETAPE_ERROR_EOD) {
-				set_bit(IDETAPE_PIPELINE_ERROR, &tape->flags);
+				tape->flags |= IDETAPE_FL_PIPELINE_ERR;
 				idetape_abort_pipeline(drive, active_stage);
 			}
 		}
@@ -916,7 +920,7 @@ static int idetape_end_request(ide_drive_t *drive, int uptodate, int nr_sects)
 	if (remove_stage)
 		idetape_remove_stage_head(drive);
 	if (tape->active_data_rq == NULL)
-		clear_bit(IDETAPE_PIPELINE_ACTIVE, &tape->flags);
+		tape->flags &= ~IDETAPE_FL_PIPELINE_ACTIVE;
 	spin_unlock_irqrestore(&tape->lock, flags);
 	return 0;
 }
@@ -995,7 +999,7 @@ static ide_startstop_t idetape_retry_pc (ide_drive_t *drive)
 	pc = idetape_next_pc_storage(drive);
 	rq = idetape_next_rq_storage(drive);
 	idetape_create_request_sense_cmd(pc);
-	set_bit(IDETAPE_IGNORE_DSC, &tape->flags);
+	set_bit(IDETAPE_FL_IGNORE_DSC, &tape->flags);
 	idetape_queue_pc_head(drive, pc, rq);
 	return ide_stopped;
 }
@@ -1042,7 +1046,7 @@ static ide_startstop_t idetape_pc_intr(ide_drive_t *drive)
 	/* Clear the interrupt */
 	stat = ide_read_status(drive);
 
-	if (test_bit(PC_DMA_IN_PROGRESS, &pc->flags)) {
+	if (pc->flags & PC_FL_DMA_IN_PROGRESS) {
 		if (hwif->ide_dma_end(drive) || (stat & ERR_STAT)) {
 			/*
 			 * A DMA error is sometimes expected. For example,
@@ -1065,7 +1069,7 @@ static ide_startstop_t idetape_pc_intr(ide_drive_t *drive)
 			 * data transfer will occur, but no DMA error.
 			 * (AS, 19 Apr 2001)
 			 */
-			set_bit(PC_DMA_ERROR, &pc->flags);
+			pc->flags |= PC_FL_DMA_ERROR;
 		} else {
 			pc->actually_transferred = pc->request_transfer;
 			idetape_update_buffers(pc);
@@ -1079,7 +1083,7 @@ static ide_startstop_t idetape_pc_intr(ide_drive_t *drive)
 		debug_log(DBG_SENSE, "Packet command completed, %d bytes"
 				" transferred\n", pc->actually_transferred);
 
-		clear_bit(PC_DMA_IN_PROGRESS, &pc->flags);
+		pc->flags &= ~PC_FL_DMA_IN_PROGRESS;
 		local_irq_enable();
 
 #if SIMULATE_ERRORS
@@ -1092,7 +1096,7 @@ static ide_startstop_t idetape_pc_intr(ide_drive_t *drive)
 #endif
 		if ((stat & ERR_STAT) && pc->c[0] == REQUEST_SENSE)
 			stat &= ~ERR_STAT;
-		if ((stat & ERR_STAT) || test_bit(PC_DMA_ERROR, &pc->flags)) {
+		if ((stat & ERR_STAT) || (pc->flags & PC_FL_DMA_ERROR)) {
 			/* Error detected */
 			debug_log(DBG_ERR, "%s: I/O error\n", tape->name);
 
@@ -1108,8 +1112,8 @@ static ide_startstop_t idetape_pc_intr(ide_drive_t *drive)
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
@@ -1123,7 +1127,8 @@ static ide_startstop_t idetape_pc_intr(ide_drive_t *drive)
 		/* Command finished - Call the callback function */
 		return pc->callback(drive);
 	}
-	if (test_and_clear_bit(PC_DMA_IN_PROGRESS, &pc->flags)) {
+	if (pc->flags & PC_FL_DMA_IN_PROGRESS) {
+		pc->flags &= ~PC_FL_DMA_IN_PROGRESS;
 		printk(KERN_ERR "ide-tape: The tape wants to issue more "
 				"interrupts in DMA mode\n");
 		printk(KERN_ERR "ide-tape: DMA disabled, reverting to PIO\n");
@@ -1140,7 +1145,7 @@ static ide_startstop_t idetape_pc_intr(ide_drive_t *drive)
 		printk(KERN_ERR "ide-tape: CoD != 0 in %s\n", __func__);
 		return ide_do_reset(drive);
 	}
-	if (((ireason & IO) == IO) == test_bit(PC_WRITING, &pc->flags)) {
+	if (((ireason & IO) == IO) == !!(pc->flags & PC_FL_WRITING)) {
 		/* Hopefully, we will never get here */
 		printk(KERN_ERR "ide-tape: We wanted to %s, ",
 				(ireason & IO) ? "Write" : "Read");
@@ -1148,7 +1153,7 @@ static ide_startstop_t idetape_pc_intr(ide_drive_t *drive)
 				(ireason & IO) ? "Read" : "Write");
 		return ide_do_reset(drive);
 	}
-	if (!test_bit(PC_WRITING, &pc->flags)) {
+	if (!(pc->flags & PC_FL_WRITING)) {
 		/* Reading - Check that we have enough space */
 		temp = pc->actually_transferred + bcount;
 		if (temp > pc->request_transfer) {
@@ -1260,7 +1265,7 @@ static ide_startstop_t idetape_transfer_pc(ide_drive_t *drive)
 	ide_set_handler(drive, &idetape_pc_intr, IDETAPE_WAIT_CMD, NULL);
 #ifdef CONFIG_BLK_DEV_IDEDMA
 	/* Begin DMA, if necessary */
-	if (test_bit(PC_DMA_IN_PROGRESS, &pc->flags))
+	if (pc->flags & PC_FL_DMA_IN_PROGRESS)
 		hwif->dma_start(drive);
 #endif
 	/* Send the actual packet */
@@ -1286,14 +1291,13 @@ static ide_startstop_t idetape_issue_pc(ide_drive_t *drive, idetape_pc_t *pc)
 	/* Set the current packet command */
 	tape->pc = pc;
 
-	if (pc->retries > IDETAPE_MAX_PC_RETRIES ||
-	    test_bit(PC_ABORT, &pc->flags)) {
+	if (pc->retries > IDETAPE_MAX_PC_RETRIES || (pc->flags & PC_FL_ABORT)) {
 		/*
 		 * We will "abort" retrying a packet command in case legitimate
 		 * error code was received (crossing a filemark, or end of the
 		 * media, for example).
 		 */
-		if (!test_bit(PC_ABORT, &pc->flags)) {
+		if (!(pc->flags & PC_FL_ABORT)) {
 			if (!(pc->c[0] == TEST_UNIT_READY &&
 			      tape->sense_key == 2 && tape->asc == 4 &&
 			     (tape->ascq == 1 || tape->ascq == 8))) {
@@ -1319,20 +1323,21 @@ static ide_startstop_t idetape_issue_pc(ide_drive_t *drive, idetape_pc_t *pc)
 	/* Request to transfer the entire buffer at once */
 	bcount = pc->request_transfer;
 
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
 		ide_execute_command(drive, WIN_PACKETCMD, &idetape_transfer_pc,
 				    IDETAPE_WAIT_CMD, NULL);
 		return ide_started;
@@ -1520,7 +1525,7 @@ static void idetape_create_read_cmd(idetape_tape_t *tape, idetape_pc_t *pc,
 	pc->buffer_size = length * tape->blk_size;
 	pc->request_transfer = pc->buffer_size;
 	if (pc->request_transfer == tape->stage_size)
-		set_bit(PC_DMA_RECOMMENDED, &pc->flags);
+		pc->flags |= PC_FL_DMA_RECOMMENDED;
 }
 
 static void idetape_create_read_buffer_cmd(idetape_tape_t *tape,
@@ -1554,7 +1559,7 @@ static void idetape_create_write_cmd(idetape_tape_t *tape, idetape_pc_t *pc,
 	put_unaligned(cpu_to_be32(length), (unsigned int *) &pc->c[1]);
 	pc->c[1] = 1;
 	pc->callback = &idetape_rw_callback;
-	set_bit(PC_WRITING, &pc->flags);
+	pc->flags |= PC_FL_WRITING;
 	pc->bh = bh;
 	pc->b_data = bh->b_data;
 	pc->b_count = atomic_read(&bh->b_count);
@@ -1562,7 +1567,7 @@ static void idetape_create_write_cmd(idetape_tape_t *tape, idetape_pc_t *pc,
 	pc->buffer_size = length * tape->blk_size;
 	pc->request_transfer = pc->buffer_size;
 	if (pc->request_transfer == tape->stage_size)
-		set_bit(PC_DMA_RECOMMENDED, &pc->flags);
+		pc->flags |= PC_FL_DMA_RECOMMENDED;
 }
 
 static ide_startstop_t idetape_do_request(ide_drive_t *drive,
@@ -1606,10 +1611,10 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 	stat = ide_read_status(drive);
 
 	if (!drive->dsc_overlap && !(rq->cmd[0] & REQ_IDETAPE_PC2))
-		set_bit(IDETAPE_IGNORE_DSC, &tape->flags);
+		set_bit(IDETAPE_FL_IGNORE_DSC, &tape->flags);
 
 	if (drive->post_reset == 1) {
-		set_bit(IDETAPE_IGNORE_DSC, &tape->flags);
+		set_bit(IDETAPE_FL_IGNORE_DSC, &tape->flags);
 		drive->post_reset = 0;
 	}
 
@@ -1617,7 +1622,7 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 		tape->insert_speed = tape->insert_size / 1024 * HZ /
 					(jiffies - tape->insert_time);
 	idetape_calculate_speeds(drive);
-	if (!test_and_clear_bit(IDETAPE_IGNORE_DSC, &tape->flags) &&
+	if (!test_and_clear_bit(IDETAPE_FL_IGNORE_DSC, &tape->flags) &&
 	    (stat & SEEK_STAT) == 0) {
 		if (postponed_rq == NULL) {
 			tape->dsc_polling_start = jiffies;
@@ -1682,7 +1687,7 @@ static inline int idetape_pipeline_active(idetape_tape_t *tape)
 {
 	int rc1, rc2;
 
-	rc1 = test_bit(IDETAPE_PIPELINE_ACTIVE, &tape->flags);
+	rc1 = !!(tape->flags & IDETAPE_FL_PIPELINE_ACTIVE);
 	rc2 = (tape->active_data_rq != NULL);
 	return rc1;
 }
@@ -1928,7 +1933,7 @@ static ide_startstop_t idetape_read_position_callback(ide_drive_t *drive)
 		if (readpos[0] & 0x4) {
 			printk(KERN_INFO "ide-tape: Block location is unknown"
 					 "to the tape\n");
-			clear_bit(IDETAPE_ADDRESS_VALID, &tape->flags);
+			tape->flags &= ~IDETAPE_FL_ADDRESS_VALID;
 			idetape_end_request(drive, 0, 0);
 		} else {
 			debug_log(DBG_SENSE, "Block Location - %u\n",
@@ -1937,7 +1942,7 @@ static ide_startstop_t idetape_read_position_callback(ide_drive_t *drive)
 			tape->partition = readpos[1];
 			tape->first_frame =
 				be32_to_cpu(*(u32 *)&readpos[4]);
-			set_bit(IDETAPE_ADDRESS_VALID, &tape->flags);
+			tape->flags |= IDETAPE_FL_ADDRESS_VALID;
 			idetape_end_request(drive, 1, 0);
 		}
 	} else {
@@ -1956,7 +1961,7 @@ static void idetape_create_write_filemark_cmd(ide_drive_t *drive,
 	idetape_init_pc(pc);
 	pc->c[0] = WRITE_FILEMARKS;
 	pc->c[4] = write_filemark;
-	set_bit(PC_WAIT_FOR_DSC, &pc->flags);
+	pc->flags |= PC_FL_WAIT_FOR_DSC;
 	pc->callback = &idetape_pc_callback;
 }
 
@@ -1997,7 +2002,7 @@ static void idetape_create_load_unload_cmd(ide_drive_t *drive, idetape_pc_t *pc,
 	idetape_init_pc(pc);
 	pc->c[0] = START_STOP;
 	pc->c[4] = cmd;
-	set_bit(PC_WAIT_FOR_DSC, &pc->flags);
+	pc->flags |= PC_FL_WAIT_FOR_DSC;
 	pc->callback = &idetape_pc_callback;
 }
 
@@ -2008,7 +2013,7 @@ static int idetape_wait_ready(ide_drive_t *drive, unsigned long timeout)
 	int load_attempted = 0;
 
 	/* Wait for the tape to become ready */
-	set_bit(IDETAPE_MEDIUM_PRESENT, &tape->flags);
+	tape->flags |= IDETAPE_FL_MEDIUM_PRESENT;
 	timeout += jiffies;
 	while (time_before(jiffies, timeout)) {
 		idetape_create_test_unit_ready_cmd(&pc);
@@ -2081,7 +2086,7 @@ static void idetape_create_locate_cmd(ide_drive_t *drive, idetape_pc_t *pc,
 	pc->c[1] = 2;
 	put_unaligned(cpu_to_be32(block), (unsigned int *) &pc->c[3]);
 	pc->c[8] = partition;
-	set_bit(PC_WAIT_FOR_DSC, &pc->flags);
+	pc->flags |= PC_FL_WAIT_FOR_DSC;
 	pc->callback = &idetape_pc_callback;
 }
 
@@ -2112,8 +2117,11 @@ static int __idetape_discard_read_pipeline(ide_drive_t *drive)
 
 	/* Remove merge stage. */
 	cnt = tape->merge_stage_size / tape->blk_size;
-	if (test_and_clear_bit(IDETAPE_FILEMARK, &tape->flags))
-		++cnt;		/* Filemarks count as 1 sector */
+	if (tape->flags & IDETAPE_FL_FILEMARK) {
+		tape->flags &= ~IDETAPE_FL_FILEMARK;
+		/* Filemarks count as 1 sector */
+		++cnt;
+	}
 	tape->merge_stage_size = 0;
 	if (tape->merge_stage != NULL) {
 		__idetape_kfree_stage(tape->merge_stage);
@@ -2121,7 +2129,7 @@ static int __idetape_discard_read_pipeline(ide_drive_t *drive)
 	}
 
 	/* Clear pipeline flags. */
-	clear_bit(IDETAPE_PIPELINE_ERROR, &tape->flags);
+	tape->flags &= ~IDETAPE_FL_PIPELINE_ERR;
 	tape->chrdev_dir = IDETAPE_DIR_NONE;
 
 	/* Remove pipeline stages. */
@@ -2235,7 +2243,7 @@ static void idetape_plug_pipeline(ide_drive_t *drive)
 	if (tape->next_stage == NULL)
 		return;
 	if (!idetape_pipeline_active(tape)) {
-		set_bit(IDETAPE_PIPELINE_ACTIVE, &tape->flags);
+		tape->flags |= IDETAPE_FL_PIPELINE_ACTIVE;
 		idetape_activate_next_stage(drive);
 		(void) ide_do_drive_cmd(drive, tape->active_data_rq, ide_end);
 	}
@@ -2254,7 +2262,7 @@ static void idetape_create_rewind_cmd(ide_drive_t *drive, idetape_pc_t *pc)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = REZERO_UNIT;
-	set_bit(PC_WAIT_FOR_DSC, &pc->flags);
+	pc->flags |= PC_FL_WAIT_FOR_DSC;
 	pc->callback = &idetape_pc_callback;
 }
 
@@ -2263,7 +2271,7 @@ static void idetape_create_erase_cmd(idetape_pc_t *pc)
 	idetape_init_pc(pc);
 	pc->c[0] = ERASE;
 	pc->c[1] = 1;
-	set_bit(PC_WAIT_FOR_DSC, &pc->flags);
+	pc->flags |= PC_FL_WAIT_FOR_DSC;
 	pc->callback = &idetape_pc_callback;
 }
 
@@ -2273,7 +2281,7 @@ static void idetape_create_space_cmd(idetape_pc_t *pc, int count, u8 cmd)
 	pc->c[0] = SPACE;
 	put_unaligned(cpu_to_be32(count), (unsigned int *) &pc->c[1]);
 	pc->c[1] = cmd;
-	set_bit(PC_WAIT_FOR_DSC, &pc->flags);
+	pc->flags |= PC_FL_WAIT_FOR_DSC;
 	pc->callback = &idetape_pc_callback;
 }
 
@@ -2360,9 +2368,11 @@ static int idetape_add_chrdev_write_request(ide_drive_t *drive, int blocks)
 			idetape_plug_pipeline(drive);
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
 
@@ -2436,7 +2446,7 @@ static void idetape_empty_write_pipeline(ide_drive_t *drive)
 		__idetape_kfree_stage(tape->merge_stage);
 		tape->merge_stage = NULL;
 	}
-	clear_bit(IDETAPE_PIPELINE_ERROR, &tape->flags);
+	tape->flags &= ~IDETAPE_FL_PIPELINE_ERR;
 	tape->chrdev_dir = IDETAPE_DIR_NONE;
 
 	/*
@@ -2524,8 +2534,8 @@ static int idetape_init_read(ide_drive_t *drive, int max_stages)
 	rq.sector = tape->first_frame;
 	rq.nr_sectors = blocks;
 	rq.current_nr_sectors = blocks;
-	if (!test_bit(IDETAPE_PIPELINE_ERROR, &tape->flags) &&
-	    tape->nr_stages < max_stages) {
+	if (!(tape->flags & IDETAPE_FL_PIPELINE_ERR) &&
+			tape->nr_stages < max_stages) {
 		new_stage = idetape_kmalloc_stage(tape);
 		while (new_stage != NULL) {
 			new_stage->rq = rq;
@@ -2561,13 +2571,13 @@ static int idetape_add_chrdev_read_request(ide_drive_t *drive, int blocks)
 	debug_log(DBG_PROCS, "Enter %s, %d blocks\n", __func__, blocks);
 
 	/* If we are at a filemark, return a read length of 0 */
-	if (test_bit(IDETAPE_FILEMARK, &tape->flags))
+	if (tape->flags & IDETAPE_FL_FILEMARK)
 		return 0;
 
 	/* Wait for the next block to reach the head of the pipeline. */
 	idetape_init_read(drive, tape->max_stages);
 	if (tape->first_stage == NULL) {
-		if (test_bit(IDETAPE_PIPELINE_ERROR, &tape->flags))
+		if (tape->flags & IDETAPE_FL_PIPELINE_ERR)
 			return 0;
 		return idetape_queue_rw_tail(drive, REQ_IDETAPE_READ, blocks,
 					tape->merge_stage->bh);
@@ -2584,7 +2594,7 @@ static int idetape_add_chrdev_read_request(ide_drive_t *drive, int blocks)
 	else {
 		idetape_switch_buffers(tape, tape->first_stage);
 		if (rq_ptr->errors == IDETAPE_ERROR_FILEMARK)
-			set_bit(IDETAPE_FILEMARK, &tape->flags);
+			tape->flags |= IDETAPE_FL_FILEMARK;
 		spin_lock_irqsave(&tape->lock, flags);
 		idetape_remove_stage_head(drive);
 		spin_unlock_irqrestore(&tape->lock, flags);
@@ -2731,12 +2741,14 @@ static int idetape_space_over_filemarks(ide_drive_t *drive, short mt_op,
 	if (tape->chrdev_dir == IDETAPE_DIR_READ) {
 		/* its a read-ahead buffer, scan it for crossed filemarks. */
 		tape->merge_stage_size = 0;
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
 			spin_lock_irqsave(&tape->lock, flags);
@@ -2820,7 +2832,7 @@ static ssize_t idetape_chrdev_read(struct file *file, char __user *buf,
 	debug_log(DBG_CHRDEV, "Enter %s, count %Zd\n", __func__, count);
 
 	if (tape->chrdev_dir != IDETAPE_DIR_READ) {
-		if (test_bit(IDETAPE_DETECT_BS, &tape->flags))
+		if (tape->flags & IDETAPE_FL_DETECT_BS)
 			if (count > tape->blk_size &&
 			    (count % tape->blk_size) == 0)
 				tape->user_bs_factor = count / tape->blk_size;
@@ -2863,7 +2875,7 @@ static ssize_t idetape_chrdev_read(struct file *file, char __user *buf,
 		tape->merge_stage_size = bytes_read-temp;
 	}
 finish:
-	if (!actually_read && test_bit(IDETAPE_FILEMARK, &tape->flags)) {
+	if (!actually_read && (tape->flags & IDETAPE_FL_FILEMARK)) {
 		debug_log(DBG_SENSE, "%s: spacing over filemark\n", tape->name);
 
 		idetape_space_over_filemarks(drive, MTFSF, 1);
@@ -3056,7 +3068,7 @@ static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
 					      !IDETAPE_LU_LOAD_MASK);
 		retval = idetape_queue_pc_tail(drive, &pc);
 		if (!retval)
-			clear_bit(IDETAPE_MEDIUM_PRESENT, &tape->flags);
+			tape->flags &= ~IDETAPE_FL_MEDIUM_PRESENT;
 		return retval;
 	case MTNOP:
 		idetape_discard_read_pipeline(drive, 0);
@@ -3079,9 +3091,9 @@ static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
 			    mt_count % tape->blk_size)
 				return -EIO;
 			tape->user_bs_factor = mt_count / tape->blk_size;
-			clear_bit(IDETAPE_DETECT_BS, &tape->flags);
+			tape->flags &= ~IDETAPE_FL_DETECT_BS;
 		} else
-			set_bit(IDETAPE_DETECT_BS, &tape->flags);
+			tape->flags |= IDETAPE_FL_DETECT_BS;
 		return 0;
 	case MTSEEK:
 		idetape_discard_read_pipeline(drive, 0);
@@ -3207,7 +3219,7 @@ static int idetape_chrdev_open(struct inode *inode, struct file *filp)
 	ide_drive_t *drive;
 	idetape_tape_t *tape;
 	idetape_pc_t pc;
-	int retval;
+	int retval, testval;
 
 	if (i >= MAX_HWIFS * MAX_DRIVES)
 		return -ENXIO;
@@ -3229,24 +3241,26 @@ static int idetape_chrdev_open(struct inode *inode, struct file *filp)
 
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
 
 	if (tape->chrdev_dir != IDETAPE_DIR_READ)
-		clear_bit(IDETAPE_PIPELINE_ERROR, &tape->flags);
+		tape->flags &= ~IDETAPE_FL_PIPELINE_ERR;
 
 	/* Read block size and write protect status from drive. */
 	ide_tape_get_bsize_from_bdesc(drive);
@@ -3261,7 +3275,7 @@ static int idetape_chrdev_open(struct inode *inode, struct file *filp)
 	if (tape->write_prot) {
 		if ((filp->f_flags & O_ACCMODE) == O_WRONLY ||
 		    (filp->f_flags & O_ACCMODE) == O_RDWR) {
-			clear_bit(IDETAPE_BUSY, &tape->flags);
+			tape->flags &= ~IDETAPE_FL_BUSY;
 			retval = -EROFS;
 			goto out_put_tape;
 		}
@@ -3326,7 +3340,7 @@ static int idetape_chrdev_release(struct inode *inode, struct file *filp)
 		__idetape_kfree_stage(tape->cache_stage);
 		tape->cache_stage = NULL;
 	}
-	if (minor < 128 && test_bit(IDETAPE_MEDIUM_PRESENT, &tape->flags))
+	if (minor < 128 && (tape->flags & IDETAPE_FL_MEDIUM_PRESENT))
 		(void) idetape_rewind_tape(drive);
 	if (tape->chrdev_dir == IDETAPE_DIR_NONE) {
 		if (tape->door_locked == DOOR_LOCKED) {
@@ -3336,7 +3350,7 @@ static int idetape_chrdev_release(struct inode *inode, struct file *filp)
 			}
 		}
 	}
-	clear_bit(IDETAPE_BUSY, &tape->flags);
+	tape->flags &= ~IDETAPE_FL_BUSY;
 	ide_tape_put(tape);
 	unlock_kernel();
 	return 0;
@@ -3540,7 +3554,7 @@ static void idetape_setup(ide_drive_t *drive, idetape_tape_t *tape, int minor)
 
 	/* Command packet DRQ type */
 	if (((gcw[0] & 0x60) >> 5) == 1)
-		set_bit(IDETAPE_DRQ_INTERRUPT, &tape->flags);
+		tape->flags |= IDETAPE_FL_DRQ_INTERRUPT;
 
 	tape->min_pipeline = 10;
 	tape->max_pipeline = 10;

-- 
Regards/Gruﬂ,
    Boris.
