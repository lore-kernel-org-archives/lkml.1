Return-Path: <linux-kernel-owner+w=401wt.eu-S1756672AbYBIToZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672AbYBIToZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 14:44:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755142AbYBIToP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 14:44:15 -0500
Received: from py-out-1112.google.com ([64.233.166.180]:48414 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755205AbYBIToM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 14:44:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent:from;
        b=SKsk4HYAHelRC92gI6036cO7A6j9wF9k8m4bh4K/ZmLXq5i7g/TNrveDLYdlq2saMipStZVyNvhClmx49QZ4dbgYd6Yk8Od0BEy/iVK8APTN1ThBbmAxielp1Xyr7xYw3qNi/25mDvRryKtYRmD9LdPMfsiMtlD78aCkv5aBHS8=
Date: Sat, 9 Feb 2008 20:43:45 +0100
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [PATCH 2/2] ide-tape: remove atomic test/set macros for packet
	commands
Message-ID: <20080209194345.GF23177@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1202132440-26648-1-git-send-email-petkovbb@gmail.com> <200802050220.22637.bzolnier@gmail.com> <20080206052343.GA14349@gollum.tnic> <200802091725.23372.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200802091725.23372.bzolnier@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 92dd5c1cfb27c0945894a3a055098290047d1ff0 Mon Sep 17 00:00:00 2001
From: Borislav Petkov <petkovbb@gmail.com>
Date: Sat, 9 Feb 2008 20:33:48 +0100
Subject: [PATCH 2/2] ide-tape: remove atomic test/set macros for packet commands

Removing the atomic tests for pc's is unobjectionable. Since this driver will
probably go to /dev/null soon, the atomic tests for tape->flags are left in
place for there are some situations where they're needed (chrdev DSC handling,
low level pipeline operation and so on). While at it, rename all test/set flag
bit defines explicitly to *_FLAG_* for clarity.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |  208 +++++++++++++++++++++++++-----------------------
 1 files changed, 109 insertions(+), 99 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 1fff560..09ff9b0 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -209,44 +209,47 @@ typedef struct idetape_packet_command_s {
 	unsigned long flags;
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
+	PC_FLAG_ABORT		= (1 << 0),
+	/* 1 When polling for DSC on a media access command */
+	PC_FLAG_WAIT_FOR_DSC	= (1 << 1),
+	/* 1 when we prefer to use DMA if possible */
+	PC_FLAG_DMA_RECOMMENDED	= (1 << 2),
+	/* 1 while DMA in progress */
+	PC_FLAG_DMA_IN_PROGRESS	= (1 << 3),
+	/* 1 when encountered problem during DMA */
+	PC_FLAG_DMA_ERROR		= (1 << 4),
+	/* Data direction */
+	PC_FLAG_WRITING		= (1 <<	5),
+};
 
 /* Tape door status */
 #define DOOR_UNLOCKED			0
 #define DOOR_LOCKED			1
 #define DOOR_EXPLICITLY_LOCKED		2
 
-/*
- *	Tape flag bits values.
- */
-#define IDETAPE_IGNORE_DSC		0
-/* 0 When the tape position is unknown */
-#define IDETAPE_ADDRESS_VALID		1
-#define IDETAPE_BUSY			2	/* Device already opened */
-/* Error detected in a pipeline stage */
-#define IDETAPE_PIPELINE_ERROR		3
-/* Attempt to auto-detect the current user block size */
-#define IDETAPE_DETECT_BS		4
-#define IDETAPE_FILEMARK		5	/* Currently on a filemark */
-#define IDETAPE_DRQ_INTERRUPT		6	/* DRQ interrupt device */
-#define IDETAPE_READ_ERROR		7
-#define IDETAPE_PIPELINE_ACTIVE		8	/* pipeline active */
-/* 0 = no tape is loaded, so we don't rewind after ejecting */
-#define IDETAPE_MEDIUM_PRESENT		9
+/* Tape flag bits values. */
+enum {
+	IDETAPE_FLAG_IGNORE_DSC		= (1 << 0),
+	/* 0 When the tape position is unknown */
+	IDETAPE_FLAG_ADDRESS_VALID	= (1 <<	1),
+	/* Device already opened */
+	IDETAPE_FLAG_BUSY			= (1 << 2),
+	/* Error detected in a pipeline stage */
+	IDETAPE_FLAG_PIPELINE_ERR	= (1 <<	3),
+	/* Attempt to auto-detect the current user block size */
+	IDETAPE_FLAG_DETECT_BS		= (1 << 4),
+	/* Currently on a filemark */
+	IDETAPE_FLAG_FILEMARK		= (1 << 5),
+	/* DRQ interrupt device */
+	IDETAPE_FLAG_DRQ_INTERRUPT	= (1 << 6),
+	/* pipeline active */
+	IDETAPE_FLAG_PIPELINE_ACTIVE	= (1 << 7),
+	/* 0 = no tape is loaded, so we don't rewind after ejecting */
+	IDETAPE_FLAG_MEDIUM_PRESENT	= (1 << 8),
+};
 
 /* Some defines for the SPACE command */
 #define IDETAPE_SPACE_OVER_FILEMARK	1
@@ -584,7 +587,7 @@ static void idetape_update_buffers(idetape_pc_t *pc)
 	int count;
 	unsigned int bcount = pc->actually_transferred;
 
-	if (test_bit(PC_WRITING, &pc->flags))
+	if (pc->flags & PC_FLAG_WRITING)
 		return;
 	while (bcount) {
 		if (bh == NULL) {
@@ -671,7 +674,7 @@ static void idetape_analyze_error(ide_drive_t *drive, u8 *sense)
 		 pc->c[0], tape->sense_key, tape->asc, tape->ascq);
 
 	/* Correct pc->actually_transferred by asking the tape.	 */
-	if (test_bit(PC_DMA_ERROR, &pc->flags)) {
+	if (pc->flags & PC_FLAG_DMA_ERROR) {
 		pc->actually_transferred = pc->request_transfer -
 			tape->blk_size *
 			be32_to_cpu(get_unaligned((u32 *)&sense[3]));
@@ -690,26 +693,26 @@ static void idetape_analyze_error(ide_drive_t *drive, u8 *sense)
 			/* don't report an error, everything's ok */
 			pc->error = 0;
 			/* don't retry read/write */
-			set_bit(PC_ABORT, &pc->flags);
+			pc->flags |= PC_FLAG_ABORT;
 		}
 	}
 	if (pc->c[0] == READ_6 && (sense[2] & 0x80)) {
 		pc->error = IDETAPE_ERROR_FILEMARK;
-		set_bit(PC_ABORT, &pc->flags);
+		pc->flags |= PC_FLAG_ABORT;
 	}
 	if (pc->c[0] == WRITE_6) {
 		if ((sense[2] & 0x40) || (tape->sense_key == 0xd
 		     && tape->asc == 0x0 && tape->ascq == 0x2)) {
 			pc->error = IDETAPE_ERROR_EOD;
-			set_bit(PC_ABORT, &pc->flags);
+			pc->flags |= PC_FLAG_ABORT;
 		}
 	}
 	if (pc->c[0] == READ_6 || pc->c[0] == WRITE_6) {
 		if (tape->sense_key == 8) {
 			pc->error = IDETAPE_ERROR_EOD;
-			set_bit(PC_ABORT, &pc->flags);
+			pc->flags |= PC_FLAG_ABORT;
 		}
-		if (!test_bit(PC_ABORT, &pc->flags) &&
+		if (!(pc->flags & PC_FLAG_ABORT) &&
 		    pc->actually_transferred)
 			pc->retries = IDETAPE_MAX_PC_RETRIES + 1;
 	}
@@ -865,14 +868,16 @@ static int idetape_end_request(ide_drive_t *drive, int uptodate, int nr_sects)
 		if (rq->cmd[0] & REQ_IDETAPE_WRITE) {
 			remove_stage = 1;
 			if (error) {
-				set_bit(IDETAPE_PIPELINE_ERROR, &tape->flags);
+				set_bit(IDETAPE_FLAG_PIPELINE_ERR,
+					&tape->flags);
 				if (error == IDETAPE_ERROR_EOD)
 					idetape_abort_pipeline(drive,
 								active_stage);
 			}
 		} else if (rq->cmd[0] & REQ_IDETAPE_READ) {
 			if (error == IDETAPE_ERROR_EOD) {
-				set_bit(IDETAPE_PIPELINE_ERROR, &tape->flags);
+				set_bit(IDETAPE_FLAG_PIPELINE_ERR,
+					&tape->flags);
 				idetape_abort_pipeline(drive, active_stage);
 			}
 		}
@@ -905,7 +910,7 @@ static int idetape_end_request(ide_drive_t *drive, int uptodate, int nr_sects)
 	if (remove_stage)
 		idetape_remove_stage_head(drive);
 	if (tape->active_data_rq == NULL)
-		clear_bit(IDETAPE_PIPELINE_ACTIVE, &tape->flags);
+		clear_bit(IDETAPE_FLAG_PIPELINE_ACTIVE, &tape->flags);
 	spin_unlock_irqrestore(&tape->lock, flags);
 	return 0;
 }
@@ -984,7 +989,7 @@ static ide_startstop_t idetape_retry_pc (ide_drive_t *drive)
 	pc = idetape_next_pc_storage(drive);
 	rq = idetape_next_rq_storage(drive);
 	idetape_create_request_sense_cmd(pc);
-	set_bit(IDETAPE_IGNORE_DSC, &tape->flags);
+	set_bit(IDETAPE_FLAG_IGNORE_DSC, &tape->flags);
 	idetape_queue_pc_head(drive, pc, rq);
 	return ide_stopped;
 }
@@ -1031,7 +1036,7 @@ static ide_startstop_t idetape_pc_intr(ide_drive_t *drive)
 	/* Clear the interrupt */
 	stat = ide_read_status(drive);
 
-	if (test_bit(PC_DMA_IN_PROGRESS, &pc->flags)) {
+	if (pc->flags & PC_FLAG_DMA_IN_PROGRESS) {
 		if (hwif->ide_dma_end(drive) || (stat & ERR_STAT)) {
 			/*
 			 * A DMA error is sometimes expected. For example,
@@ -1054,7 +1059,7 @@ static ide_startstop_t idetape_pc_intr(ide_drive_t *drive)
 			 * data transfer will occur, but no DMA error.
 			 * (AS, 19 Apr 2001)
 			 */
-			set_bit(PC_DMA_ERROR, &pc->flags);
+			pc->flags |= PC_FLAG_DMA_ERROR;
 		} else {
 			pc->actually_transferred = pc->request_transfer;
 			idetape_update_buffers(pc);
@@ -1068,7 +1073,7 @@ static ide_startstop_t idetape_pc_intr(ide_drive_t *drive)
 		debug_log(DBG_SENSE, "Packet command completed, %d bytes"
 				" transferred\n", pc->actually_transferred);
 
-		clear_bit(PC_DMA_IN_PROGRESS, &pc->flags);
+		pc->flags &= ~PC_FLAG_DMA_IN_PROGRESS;
 		local_irq_enable();
 
 #if SIMULATE_ERRORS
@@ -1081,7 +1086,7 @@ static ide_startstop_t idetape_pc_intr(ide_drive_t *drive)
 #endif
 		if ((stat & ERR_STAT) && pc->c[0] == REQUEST_SENSE)
 			stat &= ~ERR_STAT;
-		if ((stat & ERR_STAT) || test_bit(PC_DMA_ERROR, &pc->flags)) {
+		if ((stat & ERR_STAT) || (pc->flags & PC_FLAG_DMA_ERROR)) {
 			/* Error detected */
 			debug_log(DBG_ERR, "%s: I/O error\n", tape->name);
 
@@ -1097,7 +1102,7 @@ static ide_startstop_t idetape_pc_intr(ide_drive_t *drive)
 			return idetape_retry_pc(drive);
 		}
 		pc->error = 0;
-		if (test_bit(PC_WAIT_FOR_DSC, &pc->flags) &&
+		if ((pc->flags & PC_FLAG_WAIT_FOR_DSC) &&
 		    (stat & SEEK_STAT) == 0) {
 			/* Media access command */
 			tape->dsc_polling_start = jiffies;
@@ -1112,7 +1117,9 @@ static ide_startstop_t idetape_pc_intr(ide_drive_t *drive)
 		/* Command finished - Call the callback function */
 		return pc->callback(drive);
 	}
-	if (test_and_clear_bit(PC_DMA_IN_PROGRESS, &pc->flags)) {
+
+	if (pc->flags & PC_FLAG_DMA_IN_PROGRESS) {
+		pc->flags &= ~PC_FLAG_DMA_IN_PROGRESS;
 		printk(KERN_ERR "ide-tape: The tape wants to issue more "
 				"interrupts in DMA mode\n");
 		printk(KERN_ERR "ide-tape: DMA disabled, reverting to PIO\n");
@@ -1129,7 +1136,7 @@ static ide_startstop_t idetape_pc_intr(ide_drive_t *drive)
 		printk(KERN_ERR "ide-tape: CoD != 0 in %s\n", __func__);
 		return ide_do_reset(drive);
 	}
-	if (((ireason & IO) == IO) == test_bit(PC_WRITING, &pc->flags)) {
+	if (((ireason & IO) == IO) == !!(pc->flags & PC_FLAG_WRITING)) {
 		/* Hopefully, we will never get here */
 		printk(KERN_ERR "ide-tape: We wanted to %s, ",
 				(ireason & IO) ? "Write" : "Read");
@@ -1137,7 +1144,7 @@ static ide_startstop_t idetape_pc_intr(ide_drive_t *drive)
 				(ireason & IO) ? "Read" : "Write");
 		return ide_do_reset(drive);
 	}
-	if (!test_bit(PC_WRITING, &pc->flags)) {
+	if (!(pc->flags & PC_FLAG_WRITING)) {
 		/* Reading - Check that we have enough space */
 		temp = pc->actually_transferred + bcount;
 		if (temp > pc->request_transfer) {
@@ -1249,7 +1256,7 @@ static ide_startstop_t idetape_transfer_pc(ide_drive_t *drive)
 	ide_set_handler(drive, &idetape_pc_intr, IDETAPE_WAIT_CMD, NULL);
 #ifdef CONFIG_BLK_DEV_IDEDMA
 	/* Begin DMA, if necessary */
-	if (test_bit(PC_DMA_IN_PROGRESS, &pc->flags))
+	if (pc->flags & PC_FLAG_DMA_IN_PROGRESS)
 		hwif->dma_start(drive);
 #endif
 	/* Send the actual packet */
@@ -1276,13 +1283,13 @@ static ide_startstop_t idetape_issue_pc(ide_drive_t *drive, idetape_pc_t *pc)
 	tape->pc = pc;
 
 	if (pc->retries > IDETAPE_MAX_PC_RETRIES ||
-	    test_bit(PC_ABORT, &pc->flags)) {
+		(pc->flags & PC_FLAG_ABORT)) {
 		/*
 		 * We will "abort" retrying a packet command in case legitimate
 		 * error code was received (crossing a filemark, or end of the
 		 * media, for example).
 		 */
-		if (!test_bit(PC_ABORT, &pc->flags)) {
+		if (!(pc->flags & PC_FLAG_ABORT)) {
 			if (!(pc->c[0] == TEST_UNIT_READY &&
 			      tape->sense_key == 2 && tape->asc == 4 &&
 			     (tape->ascq == 1 || tape->ascq == 8))) {
@@ -1308,20 +1315,22 @@ static ide_startstop_t idetape_issue_pc(ide_drive_t *drive, idetape_pc_t *pc)
 	/* Request to transfer the entire buffer at once */
 	bcount = pc->request_transfer;
 
-	if (test_and_clear_bit(PC_DMA_ERROR, &pc->flags)) {
+	if (pc->flags & PC_FLAG_DMA_ERROR) {
+		pc->flags &= ~PC_FLAG_DMA_ERROR;
 		printk(KERN_WARNING "ide-tape: DMA disabled, "
 				"reverting to PIO\n");
 		ide_dma_off(drive);
 	}
-	if (test_bit(PC_DMA_RECOMMENDED, &pc->flags) && drive->using_dma)
+	if ((pc->flags & PC_FLAG_DMA_RECOMMENDED) && drive->using_dma)
 		dma_ok = !hwif->dma_setup(drive);
 
 	ide_pktcmd_tf_load(drive, IDE_TFLAG_NO_SELECT_MASK |
 			   IDE_TFLAG_OUT_DEVICE, bcount, dma_ok);
 
-	if (dma_ok)			/* Will begin DMA later */
-		set_bit(PC_DMA_IN_PROGRESS, &pc->flags);
-	if (test_bit(IDETAPE_DRQ_INTERRUPT, &tape->flags)) {
+	if (dma_ok)
+		/* Will begin DMA later */
+		pc->flags |= PC_FLAG_DMA_IN_PROGRESS;
+	if (test_bit(IDETAPE_FLAG_DRQ_INTERRUPT, &tape->flags)) {
 		ide_execute_command(drive, WIN_PACKETCMD, &idetape_transfer_pc,
 				    IDETAPE_WAIT_CMD, NULL);
 		return ide_started;
@@ -1509,7 +1518,7 @@ static void idetape_create_read_cmd(idetape_tape_t *tape, idetape_pc_t *pc,
 	pc->buffer_size = length * tape->blk_size;
 	pc->request_transfer = pc->buffer_size;
 	if (pc->request_transfer == tape->stage_size)
-		set_bit(PC_DMA_RECOMMENDED, &pc->flags);
+		pc->flags |= PC_FLAG_DMA_RECOMMENDED;
 }
 
 static void idetape_create_write_cmd(idetape_tape_t *tape, idetape_pc_t *pc,
@@ -1520,7 +1529,7 @@ static void idetape_create_write_cmd(idetape_tape_t *tape, idetape_pc_t *pc,
 	put_unaligned(cpu_to_be32(length), (unsigned int *) &pc->c[1]);
 	pc->c[1] = 1;
 	pc->callback = &idetape_rw_callback;
-	set_bit(PC_WRITING, &pc->flags);
+	pc->flags |= PC_FLAG_WRITING;
 	pc->bh = bh;
 	pc->b_data = bh->b_data;
 	pc->b_count = atomic_read(&bh->b_count);
@@ -1528,7 +1537,7 @@ static void idetape_create_write_cmd(idetape_tape_t *tape, idetape_pc_t *pc,
 	pc->buffer_size = length * tape->blk_size;
 	pc->request_transfer = pc->buffer_size;
 	if (pc->request_transfer == tape->stage_size)
-		set_bit(PC_DMA_RECOMMENDED, &pc->flags);
+		pc->flags |= PC_FLAG_DMA_RECOMMENDED;
 }
 
 static ide_startstop_t idetape_do_request(ide_drive_t *drive,
@@ -1572,10 +1581,10 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 	stat = ide_read_status(drive);
 
 	if (!drive->dsc_overlap && !(rq->cmd[0] & REQ_IDETAPE_PC2))
-		set_bit(IDETAPE_IGNORE_DSC, &tape->flags);
+		set_bit(IDETAPE_FLAG_IGNORE_DSC, &tape->flags);
 
 	if (drive->post_reset == 1) {
-		set_bit(IDETAPE_IGNORE_DSC, &tape->flags);
+		set_bit(IDETAPE_FLAG_IGNORE_DSC, &tape->flags);
 		drive->post_reset = 0;
 	}
 
@@ -1583,7 +1592,7 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 		tape->insert_speed = tape->insert_size / 1024 * HZ /
 					(jiffies - tape->insert_time);
 	idetape_calculate_speeds(drive);
-	if (!test_and_clear_bit(IDETAPE_IGNORE_DSC, &tape->flags) &&
+	if (!test_and_clear_bit(IDETAPE_FLAG_IGNORE_DSC, &tape->flags) &&
 	    (stat & SEEK_STAT) == 0) {
 		if (postponed_rq == NULL) {
 			tape->dsc_polling_start = jiffies;
@@ -1641,7 +1650,7 @@ static inline int idetape_pipeline_active(idetape_tape_t *tape)
 {
 	int rc1, rc2;
 
-	rc1 = test_bit(IDETAPE_PIPELINE_ACTIVE, &tape->flags);
+	rc1 = test_bit(IDETAPE_FLAG_PIPELINE_ACTIVE, &tape->flags);
 	rc2 = (tape->active_data_rq != NULL);
 	return rc1;
 }
@@ -1887,7 +1896,7 @@ static ide_startstop_t idetape_read_position_callback(ide_drive_t *drive)
 		if (readpos[0] & 0x4) {
 			printk(KERN_INFO "ide-tape: Block location is unknown"
 					 "to the tape\n");
-			clear_bit(IDETAPE_ADDRESS_VALID, &tape->flags);
+			clear_bit(IDETAPE_FLAG_ADDRESS_VALID, &tape->flags);
 			idetape_end_request(drive, 0, 0);
 		} else {
 			debug_log(DBG_SENSE, "Block Location - %u\n",
@@ -1896,7 +1905,7 @@ static ide_startstop_t idetape_read_position_callback(ide_drive_t *drive)
 			tape->partition = readpos[1];
 			tape->first_frame =
 				be32_to_cpu(*(u32 *)&readpos[4]);
-			set_bit(IDETAPE_ADDRESS_VALID, &tape->flags);
+			set_bit(IDETAPE_FLAG_ADDRESS_VALID, &tape->flags);
 			idetape_end_request(drive, 1, 0);
 		}
 	} else {
@@ -1915,7 +1924,7 @@ static void idetape_create_write_filemark_cmd(ide_drive_t *drive,
 	idetape_init_pc(pc);
 	pc->c[0] = WRITE_FILEMARKS;
 	pc->c[4] = write_filemark;
-	set_bit(PC_WAIT_FOR_DSC, &pc->flags);
+	pc->flags |= PC_FLAG_WAIT_FOR_DSC;
 	pc->callback = &idetape_pc_callback;
 }
 
@@ -1956,7 +1965,7 @@ static void idetape_create_load_unload_cmd(ide_drive_t *drive, idetape_pc_t *pc,
 	idetape_init_pc(pc);
 	pc->c[0] = START_STOP;
 	pc->c[4] = cmd;
-	set_bit(PC_WAIT_FOR_DSC, &pc->flags);
+	pc->flags |= PC_FLAG_WAIT_FOR_DSC;
 	pc->callback = &idetape_pc_callback;
 }
 
@@ -1967,7 +1976,7 @@ static int idetape_wait_ready(ide_drive_t *drive, unsigned long timeout)
 	int load_attempted = 0;
 
 	/* Wait for the tape to become ready */
-	set_bit(IDETAPE_MEDIUM_PRESENT, &tape->flags);
+	set_bit(IDETAPE_FLAG_MEDIUM_PRESENT, &tape->flags);
 	timeout += jiffies;
 	while (time_before(jiffies, timeout)) {
 		idetape_create_test_unit_ready_cmd(&pc);
@@ -2040,7 +2049,7 @@ static void idetape_create_locate_cmd(ide_drive_t *drive, idetape_pc_t *pc,
 	pc->c[1] = 2;
 	put_unaligned(cpu_to_be32(block), (unsigned int *) &pc->c[3]);
 	pc->c[8] = partition;
-	set_bit(PC_WAIT_FOR_DSC, &pc->flags);
+	pc->flags |= PC_FLAG_WAIT_FOR_DSC;
 	pc->callback = &idetape_pc_callback;
 }
 
@@ -2071,7 +2080,7 @@ static int __idetape_discard_read_pipeline(ide_drive_t *drive)
 
 	/* Remove merge stage. */
 	cnt = tape->merge_stage_size / tape->blk_size;
-	if (test_and_clear_bit(IDETAPE_FILEMARK, &tape->flags))
+	if (test_and_clear_bit(IDETAPE_FLAG_FILEMARK, &tape->flags))
 		++cnt;		/* Filemarks count as 1 sector */
 	tape->merge_stage_size = 0;
 	if (tape->merge_stage != NULL) {
@@ -2080,7 +2089,7 @@ static int __idetape_discard_read_pipeline(ide_drive_t *drive)
 	}
 
 	/* Clear pipeline flags. */
-	clear_bit(IDETAPE_PIPELINE_ERROR, &tape->flags);
+	clear_bit(IDETAPE_FLAG_PIPELINE_ERR, &tape->flags);
 	tape->chrdev_dir = IDETAPE_DIR_NONE;
 
 	/* Remove pipeline stages. */
@@ -2194,7 +2203,7 @@ static void idetape_plug_pipeline(ide_drive_t *drive)
 	if (tape->next_stage == NULL)
 		return;
 	if (!idetape_pipeline_active(tape)) {
-		set_bit(IDETAPE_PIPELINE_ACTIVE, &tape->flags);
+		set_bit(IDETAPE_FLAG_PIPELINE_ACTIVE, &tape->flags);
 		idetape_activate_next_stage(drive);
 		(void) ide_do_drive_cmd(drive, tape->active_data_rq, ide_end);
 	}
@@ -2213,7 +2222,7 @@ static void idetape_create_rewind_cmd(ide_drive_t *drive, idetape_pc_t *pc)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = REZERO_UNIT;
-	set_bit(PC_WAIT_FOR_DSC, &pc->flags);
+	pc->flags |= PC_FLAG_WAIT_FOR_DSC;
 	pc->callback = &idetape_pc_callback;
 }
 
@@ -2222,7 +2231,7 @@ static void idetape_create_erase_cmd(idetape_pc_t *pc)
 	idetape_init_pc(pc);
 	pc->c[0] = ERASE;
 	pc->c[1] = 1;
-	set_bit(PC_WAIT_FOR_DSC, &pc->flags);
+	pc->flags |= PC_FLAG_WAIT_FOR_DSC;
 	pc->callback = &idetape_pc_callback;
 }
 
@@ -2232,7 +2241,7 @@ static void idetape_create_space_cmd(idetape_pc_t *pc, int count, u8 cmd)
 	pc->c[0] = SPACE;
 	put_unaligned(cpu_to_be32(count), (unsigned int *) &pc->c[1]);
 	pc->c[1] = cmd;
-	set_bit(PC_WAIT_FOR_DSC, &pc->flags);
+	pc->flags |= PC_FLAG_WAIT_FOR_DSC;
 	pc->callback = &idetape_pc_callback;
 }
 
@@ -2319,7 +2328,7 @@ static int idetape_add_chrdev_write_request(ide_drive_t *drive, int blocks)
 			idetape_plug_pipeline(drive);
 		}
 	}
-	if (test_and_clear_bit(IDETAPE_PIPELINE_ERROR, &tape->flags))
+	if (test_and_clear_bit(IDETAPE_FLAG_PIPELINE_ERR, &tape->flags))
 		/* Return a deferred error */
 		return -EIO;
 	return blocks;
@@ -2395,7 +2404,7 @@ static void idetape_empty_write_pipeline(ide_drive_t *drive)
 		__idetape_kfree_stage(tape->merge_stage);
 		tape->merge_stage = NULL;
 	}
-	clear_bit(IDETAPE_PIPELINE_ERROR, &tape->flags);
+	clear_bit(IDETAPE_FLAG_PIPELINE_ERR, &tape->flags);
 	tape->chrdev_dir = IDETAPE_DIR_NONE;
 
 	/*
@@ -2483,7 +2492,7 @@ static int idetape_init_read(ide_drive_t *drive, int max_stages)
 	rq.sector = tape->first_frame;
 	rq.nr_sectors = blocks;
 	rq.current_nr_sectors = blocks;
-	if (!test_bit(IDETAPE_PIPELINE_ERROR, &tape->flags) &&
+	if (!test_bit(IDETAPE_FLAG_PIPELINE_ERR, &tape->flags) &&
 	    tape->nr_stages < max_stages) {
 		new_stage = idetape_kmalloc_stage(tape);
 		while (new_stage != NULL) {
@@ -2520,13 +2529,13 @@ static int idetape_add_chrdev_read_request(ide_drive_t *drive, int blocks)
 	debug_log(DBG_PROCS, "Enter %s, %d blocks\n", __func__, blocks);
 
 	/* If we are at a filemark, return a read length of 0 */
-	if (test_bit(IDETAPE_FILEMARK, &tape->flags))
+	if (test_bit(IDETAPE_FLAG_FILEMARK, &tape->flags))
 		return 0;
 
 	/* Wait for the next block to reach the head of the pipeline. */
 	idetape_init_read(drive, tape->max_stages);
 	if (tape->first_stage == NULL) {
-		if (test_bit(IDETAPE_PIPELINE_ERROR, &tape->flags))
+		if (test_bit(IDETAPE_FLAG_PIPELINE_ERR, &tape->flags))
 			return 0;
 		return idetape_queue_rw_tail(drive, REQ_IDETAPE_READ, blocks,
 					tape->merge_stage->bh);
@@ -2543,7 +2552,7 @@ static int idetape_add_chrdev_read_request(ide_drive_t *drive, int blocks)
 	else {
 		idetape_switch_buffers(tape, tape->first_stage);
 		if (rq_ptr->errors == IDETAPE_ERROR_FILEMARK)
-			set_bit(IDETAPE_FILEMARK, &tape->flags);
+			set_bit(IDETAPE_FLAG_FILEMARK, &tape->flags);
 		spin_lock_irqsave(&tape->lock, flags);
 		idetape_remove_stage_head(drive);
 		spin_unlock_irqrestore(&tape->lock, flags);
@@ -2690,12 +2699,13 @@ static int idetape_space_over_filemarks(ide_drive_t *drive, short mt_op,
 	if (tape->chrdev_dir == IDETAPE_DIR_READ) {
 		/* its a read-ahead buffer, scan it for crossed filemarks. */
 		tape->merge_stage_size = 0;
-		if (test_and_clear_bit(IDETAPE_FILEMARK, &tape->flags))
+		if (test_and_clear_bit(IDETAPE_FLAG_FILEMARK, &tape->flags))
 			++count;
 		while (tape->first_stage != NULL) {
 			if (count == mt_count) {
 				if (mt_op == MTFSFM)
-					set_bit(IDETAPE_FILEMARK, &tape->flags);
+					set_bit(IDETAPE_FLAG_FILEMARK,
+						&tape->flags);
 				return 0;
 			}
 			spin_lock_irqsave(&tape->lock, flags);
@@ -2779,7 +2789,7 @@ static ssize_t idetape_chrdev_read(struct file *file, char __user *buf,
 	debug_log(DBG_CHRDEV, "Enter %s, count %Zd\n", __func__, count);
 
 	if (tape->chrdev_dir != IDETAPE_DIR_READ) {
-		if (test_bit(IDETAPE_DETECT_BS, &tape->flags))
+		if (test_bit(IDETAPE_FLAG_DETECT_BS, &tape->flags))
 			if (count > tape->blk_size &&
 			    (count % tape->blk_size) == 0)
 				tape->user_bs_factor = count / tape->blk_size;
@@ -2822,7 +2832,7 @@ static ssize_t idetape_chrdev_read(struct file *file, char __user *buf,
 		tape->merge_stage_size = bytes_read-temp;
 	}
 finish:
-	if (!actually_read && test_bit(IDETAPE_FILEMARK, &tape->flags)) {
+	if (!actually_read && test_bit(IDETAPE_FLAG_FILEMARK, &tape->flags)) {
 		debug_log(DBG_SENSE, "%s: spacing over filemark\n", tape->name);
 
 		idetape_space_over_filemarks(drive, MTFSF, 1);
@@ -3015,7 +3025,7 @@ static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
 					      !IDETAPE_LU_LOAD_MASK);
 		retval = idetape_queue_pc_tail(drive, &pc);
 		if (!retval)
-			clear_bit(IDETAPE_MEDIUM_PRESENT, &tape->flags);
+			clear_bit(IDETAPE_FLAG_MEDIUM_PRESENT, &tape->flags);
 		return retval;
 	case MTNOP:
 		idetape_discard_read_pipeline(drive, 0);
@@ -3038,9 +3048,9 @@ static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
 			    mt_count % tape->blk_size)
 				return -EIO;
 			tape->user_bs_factor = mt_count / tape->blk_size;
-			clear_bit(IDETAPE_DETECT_BS, &tape->flags);
+			clear_bit(IDETAPE_FLAG_DETECT_BS, &tape->flags);
 		} else
-			set_bit(IDETAPE_DETECT_BS, &tape->flags);
+			set_bit(IDETAPE_FLAG_DETECT_BS, &tape->flags);
 		return 0;
 	case MTSEEK:
 		idetape_discard_read_pipeline(drive, 0);
@@ -3188,24 +3198,24 @@ static int idetape_chrdev_open(struct inode *inode, struct file *filp)
 
 	filp->private_data = tape;
 
-	if (test_and_set_bit(IDETAPE_BUSY, &tape->flags)) {
+	if (test_and_set_bit(IDETAPE_FLAG_BUSY, &tape->flags)) {
 		retval = -EBUSY;
 		goto out_put_tape;
 	}
 
 	retval = idetape_wait_ready(drive, 60 * HZ);
 	if (retval) {
-		clear_bit(IDETAPE_BUSY, &tape->flags);
+		clear_bit(IDETAPE_FLAG_BUSY, &tape->flags);
 		printk(KERN_ERR "ide-tape: %s: drive not ready\n", tape->name);
 		goto out_put_tape;
 	}
 
 	idetape_read_position(drive);
-	if (!test_bit(IDETAPE_ADDRESS_VALID, &tape->flags))
+	if (!test_bit(IDETAPE_FLAG_ADDRESS_VALID, &tape->flags))
 		(void)idetape_rewind_tape(drive);
 
 	if (tape->chrdev_dir != IDETAPE_DIR_READ)
-		clear_bit(IDETAPE_PIPELINE_ERROR, &tape->flags);
+		clear_bit(IDETAPE_FLAG_PIPELINE_ERR, &tape->flags);
 
 	/* Read block size and write protect status from drive. */
 	ide_tape_get_bsize_from_bdesc(drive);
@@ -3220,7 +3230,7 @@ static int idetape_chrdev_open(struct inode *inode, struct file *filp)
 	if (tape->write_prot) {
 		if ((filp->f_flags & O_ACCMODE) == O_WRONLY ||
 		    (filp->f_flags & O_ACCMODE) == O_RDWR) {
-			clear_bit(IDETAPE_BUSY, &tape->flags);
+			clear_bit(IDETAPE_FLAG_BUSY, &tape->flags);
 			retval = -EROFS;
 			goto out_put_tape;
 		}
@@ -3285,7 +3295,7 @@ static int idetape_chrdev_release(struct inode *inode, struct file *filp)
 		__idetape_kfree_stage(tape->cache_stage);
 		tape->cache_stage = NULL;
 	}
-	if (minor < 128 && test_bit(IDETAPE_MEDIUM_PRESENT, &tape->flags))
+	if (minor < 128 && test_bit(IDETAPE_FLAG_MEDIUM_PRESENT, &tape->flags))
 		(void) idetape_rewind_tape(drive);
 	if (tape->chrdev_dir == IDETAPE_DIR_NONE) {
 		if (tape->door_locked == DOOR_LOCKED) {
@@ -3295,7 +3305,7 @@ static int idetape_chrdev_release(struct inode *inode, struct file *filp)
 			}
 		}
 	}
-	clear_bit(IDETAPE_BUSY, &tape->flags);
+	clear_bit(IDETAPE_FLAG_BUSY, &tape->flags);
 	ide_tape_put(tape);
 	unlock_kernel();
 	return 0;
@@ -3499,7 +3509,7 @@ static void idetape_setup(ide_drive_t *drive, idetape_tape_t *tape, int minor)
 
 	/* Command packet DRQ type */
 	if (((gcw[0] & 0x60) >> 5) == 1)
-		set_bit(IDETAPE_DRQ_INTERRUPT, &tape->flags);
+		set_bit(IDETAPE_FLAG_DRQ_INTERRUPT, &tape->flags);
 
 	tape->min_pipeline = 10;
 	tape->max_pipeline = 10;
-- 
1.5.3.7

-- 
Regards/Gruﬂ,
    Boris.
