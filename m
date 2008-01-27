Return-Path: <linux-kernel-owner+w=401wt.eu-S1759139AbYA0J6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759139AbYA0J6Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 04:58:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757299AbYA0Jt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 04:49:56 -0500
Received: from [212.23.103.76] ([212.23.103.76]:58878 "EHLO gollum.tnic"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756576AbYA0Jto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 04:49:44 -0500
From: Borislav Petkov <petkovbb@gmail.com>
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>
Subject: [PATCH 22/32] ide-tape: struct idetape_packet_command_s: shorten member names
Date: Sun, 27 Jan 2008 10:48:10 +0100
Message-Id: <1201427300-3954-17-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1201427300-3954-1-git-send-email-petkovbb@gmail.com>
References: <1201427300-3954-1-git-send-email-petkovbb@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bbpetkov@yahoo.de>

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
---
 drivers/ide/ide-tape.c |   88 ++++++++++++++++++++++++-----------------------
 1 files changed, 45 insertions(+), 43 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index b487d56..4690f71 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -193,24 +193,25 @@ struct idetape_bh {
 	char *b_data;
 };
 
-/*
- *	Our view of a packet command.
- */
 typedef struct idetape_packet_command_s {
-	u8 c[12];				/* Actual packet bytes */
-	int retries;				/* On each retry, we increment retries */
-	int error;				/* Error code */
-	int request_transfer;			/* Bytes to transfer */
-	int actually_transferred;		/* Bytes actually transferred */
-	int buffer_size;			/* Size of our data buffer */
+	u8 c[12];		/* Actual packet bytes */
+	int retries;		/* On each retry, we increment retries */
+	int error;		/* Error code */
+	int rq_xfer;		/* Request bytes to transfer */
+	int xferred;		/* Bytes actually transferred */
+	int buf_size;		/* Size of our data buffer */
 	struct idetape_bh *bh;
 	char *b_data;
 	int b_count;
-	u8 *buffer;				/* Data buffer */
-	u8 *current_position;			/* Pointer into the above buffer */
-	ide_startstop_t (*callback) (ide_drive_t *);	/* Called when this packet command is completed */
+	u8 *buffer;		/* Data buffer */
+	u8 *cur_pos;		/* Pointer into the above buffer */
+
+	/* Called when this packet command is completed */
+	ide_startstop_t (*callback) (ide_drive_t *);
 	u8 pc_buffer[IDETAPE_PC_BUFFER_SIZE];	/* Temporary buffer */
-	unsigned long flags;			/* Status/Action bit flags: long for set_bit */
+
+	/* Status/Action bit flags: long for set_bit */
+	unsigned long flags;
 } idetape_pc_t;
 
 /*
@@ -684,7 +685,7 @@ static void idetape_update_buffers (idetape_pc_t *pc)
 {
 	struct idetape_bh *bh = pc->bh;
 	int count;
-	unsigned int bcount = pc->actually_transferred;
+	unsigned int bcount = pc->xferred;
 
 	if (test_bit(PC_WRITING, &pc->flags))
 		return;
@@ -752,9 +753,9 @@ static void idetape_init_pc (idetape_pc_t *pc)
 	memset(pc->c, 0, 12);
 	pc->retries = 0;
 	pc->flags = 0;
-	pc->request_transfer = 0;
+	pc->rq_xfer = 0;
 	pc->buffer = pc->pc_buffer;
-	pc->buffer_size = IDETAPE_PC_BUFFER_SIZE;
+	pc->buf_size = IDETAPE_PC_BUFFER_SIZE;
 	pc->bh = NULL;
 	pc->b_data = NULL;
 }
@@ -775,9 +776,9 @@ static void idetape_analyze_error(ide_drive_t *drive, u8 *sense)
 	debug_log(DBG_ERR, "pc = %x, sense key = %x, asc = %x, ascq = %x\n",
 		 pc->c[0], tape->sense_key, tape->asc, tape->ascq);
 
-	/* Correct pc->actually_transferred by asking the tape.	 */
+	/* Correct pc->xferred by asking the tape.	 */
 	if (test_bit(PC_DMA_ERROR, &pc->flags)) {
-		pc->actually_transferred = pc->request_transfer -
+		pc->xferred = pc->rq_xfer -
 			tape->tape_block_size *
 			be32_to_cpu(get_unaligned((u32 *)&sense[3]));
 		idetape_update_buffers(pc);
@@ -817,7 +818,7 @@ static void idetape_analyze_error(ide_drive_t *drive, u8 *sense)
 			set_bit(PC_ABORT, &pc->flags);
 		}
 		if (!test_bit(PC_ABORT, &pc->flags) &&
-		    pc->actually_transferred)
+		    pc->xferred)
 			pc->retries = IDETAPE_MAX_PC_RETRIES + 1;
 	}
 }
@@ -1047,7 +1048,7 @@ static void idetape_create_request_sense_cmd (idetape_pc_t *pc)
 	idetape_init_pc(pc);	
 	pc->c[0] = REQUEST_SENSE;
 	pc->c[4] = 20;
-	pc->request_transfer = 20;
+	pc->rq_xfer = 20;
 	pc->callback = &idetape_request_sense_callback;
 }
 
@@ -1172,7 +1173,7 @@ static ide_startstop_t idetape_pc_intr (ide_drive_t *drive)
 			 */
 			set_bit(PC_DMA_ERROR, &pc->flags);
 		} else {
-			pc->actually_transferred = pc->request_transfer;
+			pc->xferred = pc->rq_xfer;
 			idetape_update_buffers(pc);
 		}
 		debug_log(DBG_PROCS, "DMA finished\n");
@@ -1182,7 +1183,7 @@ static ide_startstop_t idetape_pc_intr (ide_drive_t *drive)
 	/* No more interrupts */
 	if ((stat & DRQ_STAT) == 0) {
 		debug_log(DBG_SENSE, "Packet command completed, %d bytes"
-				" transferred\n", pc->actually_transferred);
+				" transferred\n", pc->xferred);
 
 		clear_bit(PC_DMA_IN_PROGRESS, &pc->flags);
 		local_irq_enable();
@@ -1256,9 +1257,9 @@ static ide_startstop_t idetape_pc_intr (ide_drive_t *drive)
 	}
 	if (!test_bit(PC_WRITING, &pc->flags)) {
 		/* Reading - Check that we have enough space */
-		temp = pc->actually_transferred + bcount;
-		if (temp > pc->request_transfer) {
-			if (temp > pc->buffer_size) {
+		temp = pc->xferred + bcount;
+		if (temp > pc->rq_xfer) {
+			if (temp > pc->buf_size) {
 				printk(KERN_ERR "ide-tape: The tape wants to send us more data than expected - discarding data\n");
 				idetape_discard_data(drive, bcount);
 				ide_set_handler(drive, &idetape_pc_intr, IDETAPE_WAIT_CMD, NULL);
@@ -1274,19 +1275,19 @@ static ide_startstop_t idetape_pc_intr (ide_drive_t *drive)
 			idetape_output_buffers(drive, pc, bcount);
 		else
 			/* Write the current buffer */
-			hwif->atapi_output_bytes(drive, pc->current_position,
+			hwif->atapi_output_bytes(drive, pc->cur_pos,
 						 bcount);
 	} else {
 		if (pc->bh != NULL)
 			idetape_input_buffers(drive, pc, bcount);
 		else
 			/* Read the current buffer */
-			hwif->atapi_input_bytes(drive, pc->current_position,
+			hwif->atapi_input_bytes(drive, pc->cur_pos,
 						bcount);
 	}
 	/* Update the current position */
-	pc->actually_transferred += bcount;
-	pc->current_position += bcount;
+	pc->xferred += bcount;
+	pc->cur_pos += bcount;
 
 	debug_log(DBG_SENSE, "[cmd %x] transferred %d bytes on that intr.\n",
 			pc->c[0], bcount);
@@ -1427,10 +1428,10 @@ static ide_startstop_t idetape_issue_packet_command (ide_drive_t *drive, idetape
 
 	pc->retries++;
 	/* We haven't transferred any data yet */
-	pc->actually_transferred = 0;
-	pc->current_position = pc->buffer;
+	pc->xferred = 0;
+	pc->cur_pos = pc->buffer;
 	/* Request to transfer the entire buffer at once */
-	bcount = pc->request_transfer;
+	bcount = pc->rq_xfer;
 
 	if (test_and_clear_bit(PC_DMA_ERROR, &pc->flags)) {
 		printk(KERN_WARNING "ide-tape: DMA disabled, "
@@ -1488,11 +1489,11 @@ static void idetape_create_mode_sense_cmd (idetape_pc_t *pc, u8 page_code)
 	pc->c[3] = 0;
 	pc->c[4] = 255;		/* (We will just discard data in that case) */
 	if (page_code == IDETAPE_BLOCK_DESCRIPTOR)
-		pc->request_transfer = 12;
+		pc->rq_xfer = 12;
 	else if (page_code == IDETAPE_CAPABILITIES_PAGE)
-		pc->request_transfer = 24;
+		pc->rq_xfer = 24;
 	else
-		pc->request_transfer = 50;
+		pc->rq_xfer = 50;
 	pc->callback = &idetape_pc_callback;
 }
 
@@ -1575,7 +1576,7 @@ static ide_startstop_t idetape_rw_callback (ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	struct request *rq = HWGROUP(drive)->rq;
-	int blocks = tape->pc->actually_transferred / tape->tape_block_size;
+	int blocks = tape->pc->xferred / tape->tape_block_size;
 
 	tape->avg_size += blocks * tape->tape_block_size;
 	tape->insert_size += blocks * tape->tape_block_size;
@@ -1615,8 +1616,9 @@ static void idetape_create_read_cmd(idetape_tape_t *tape, idetape_pc_t *pc, unsi
 	pc->bh = bh;
 	atomic_set(&bh->b_count, 0);
 	pc->buffer = NULL;
-	pc->request_transfer = pc->buffer_size = length * tape->tape_block_size;
-	if (pc->request_transfer == tape->stage_size)
+	pc->buf_size = length * tape->tape_block_size;
+	pc->rq_xfer = pc->buf_size;
+	if (pc->rq_xfer == tape->stage_size)
 		set_bit(PC_DMA_RECOMMENDED, &pc->flags);
 }
 
@@ -1638,7 +1640,7 @@ static void idetape_create_read_buffer_cmd(idetape_tape_t *tape, idetape_pc_t *p
 		atomic_set(&p->b_count, 0);
 		p = p->b_reqnext;
 	}
-	pc->request_transfer = pc->buffer_size = size;
+	pc->rq_xfer = pc->buf_size = size;
 }
 
 static void idetape_create_write_cmd(idetape_tape_t *tape, idetape_pc_t *pc, unsigned int length, struct idetape_bh *bh)
@@ -1653,8 +1655,8 @@ static void idetape_create_write_cmd(idetape_tape_t *tape, idetape_pc_t *pc, uns
 	pc->b_data = bh->b_data;
 	pc->b_count = atomic_read(&bh->b_count);
 	pc->buffer = NULL;
-	pc->request_transfer = pc->buffer_size = length * tape->tape_block_size;
-	if (pc->request_transfer == tape->stage_size)
+	pc->rq_xfer = pc->buf_size = length * tape->tape_block_size;
+	if (pc->rq_xfer == tape->stage_size)
 		set_bit(PC_DMA_RECOMMENDED, &pc->flags);
 }
 
@@ -2156,7 +2158,7 @@ static void idetape_create_read_position_cmd (idetape_pc_t *pc)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = READ_POSITION;
-	pc->request_transfer = 20;
+	pc->rq_xfer = 20;
 	pc->callback = &idetape_read_position_callback;
 }
 
@@ -2346,7 +2348,7 @@ static void idetape_create_inquiry_cmd (idetape_pc_t *pc)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = INQUIRY;
-	pc->c[4] = pc->request_transfer = 254;
+	pc->c[4] = pc->rq_xfer = 254;
 	pc->callback = &idetape_pc_callback;
 }
 
-- 
1.5.3.7

