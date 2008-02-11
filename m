Return-Path: <linux-kernel-owner+w=401wt.eu-S1756531AbYBKIgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531AbYBKIgj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 03:36:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753637AbYBKIf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 03:35:26 -0500
Received: from hs-out-0708.google.com ([64.233.178.250]:35579 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752966AbYBKIfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 03:35:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=ohO601a6raojxDv6vX64WOGMbDn+4VS/VrPDsXV0J+pMljzXeLa4PYU6/qjCKrr5b2nA9AiM7FsZKPMVTOoZ2+HxWMy3xVf71VovDvHuWNIgOiHqZyoamA5yHZvEY2Szn8mMcbQIVD9IqLp6dpG8Fs5L8DKYVVtzSYrIuB1KjDI=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 3/4] ide-tape: convert driver to using generic ide_atapi_pc
Date: Mon, 11 Feb 2008 09:34:39 +0100
Message-Id: <1202718880-1793-4-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1202718880-1793-1-git-send-email-petkovbb@gmail.com>
References: <1202718880-1793-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |  251 ++++++++++++++++++++++--------------------------
 1 files changed, 114 insertions(+), 137 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 09ff9b0..aefbb47 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -181,34 +181,6 @@ struct idetape_bh {
 	char *b_data;
 };
 
-typedef struct idetape_packet_command_s {
-	/* Actual packet bytes */
-	u8 c[12];
-	/* On each retry, we increment retries */
-	int retries;
-	/* Error code */
-	int error;
-	/* Bytes to transfer */
-	int request_transfer;
-	/* Bytes actually transferred */
-	int actually_transferred;
-	/* Size of our data buffer */
-	int buffer_size;
-	struct idetape_bh *bh;
-	char *b_data;
-	int b_count;
-	/* Data buffer */
-	u8 *buffer;
-	/* Pointer into the above buffer */
-	u8 *current_position;
-	/* Called when this packet command is completed */
-	ide_startstop_t (*callback) (ide_drive_t *);
-	/* Temporary buffer */
-	u8 pc_buffer[IDETAPE_PC_BUFFER_SIZE];
-	/* Status/Action bit flags: long for set_bit */
-	unsigned long flags;
-} idetape_pc_t;
-
 /* Packet command flag bits. */
 enum {
 	/* Set when an error is considered normal - We won't retry */
@@ -316,11 +288,11 @@ typedef struct ide_tape_obj {
 	 *	retry, to get detailed information on what went wrong.
 	 */
 	/* Current packet command */
-	idetape_pc_t *pc;
+	struct ide_atapi_pc *pc;
 	/* Last failed packet command */
-	idetape_pc_t *failed_pc;
+	struct ide_atapi_pc *failed_pc;
 	/* Packet command stack */
-	idetape_pc_t pc_stack[IDETAPE_PC_STACK];
+	struct ide_atapi_pc pc_stack[IDETAPE_PC_STACK];
 	/* Next free packet command storage space */
 	int pc_stack_index;
 	struct request rq_stack[IDETAPE_PC_STACK];
@@ -524,7 +496,7 @@ static struct ide_tape_obj *ide_tape_chrdev_get(unsigned int i)
 	return tape;
 }
 
-static void idetape_input_buffers(ide_drive_t *drive, idetape_pc_t *pc,
+static void idetape_input_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
 				  unsigned int bcount)
 {
 	struct idetape_bh *bh = pc->bh;
@@ -553,7 +525,7 @@ static void idetape_input_buffers(ide_drive_t *drive, idetape_pc_t *pc,
 	pc->bh = bh;
 }
 
-static void idetape_output_buffers(ide_drive_t *drive, idetape_pc_t *pc,
+static void idetape_output_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
 				   unsigned int bcount)
 {
 	struct idetape_bh *bh = pc->bh;
@@ -581,11 +553,11 @@ static void idetape_output_buffers(ide_drive_t *drive, idetape_pc_t *pc,
 	}
 }
 
-static void idetape_update_buffers(idetape_pc_t *pc)
+static void idetape_update_buffers(struct ide_atapi_pc *pc)
 {
 	struct idetape_bh *bh = pc->bh;
 	int count;
-	unsigned int bcount = pc->actually_transferred;
+	unsigned int bcount = pc->xferred;
 
 	if (pc->flags & PC_FLAG_WRITING)
 		return;
@@ -610,7 +582,7 @@ static void idetape_update_buffers(idetape_pc_t *pc)
  *	driver. A storage space for a maximum of IDETAPE_PC_STACK packet
  *	commands is allocated at initialization time.
  */
-static idetape_pc_t *idetape_next_pc_storage(ide_drive_t *drive)
+static struct ide_atapi_pc *idetape_next_pc_storage(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 
@@ -645,14 +617,14 @@ static struct request *idetape_next_rq_storage(ide_drive_t *drive)
 	return (&tape->rq_stack[tape->rq_stack_index++]);
 }
 
-static void idetape_init_pc(idetape_pc_t *pc)
+static void idetape_init_pc(struct ide_atapi_pc *pc)
 {
 	memset(pc->c, 0, 12);
 	pc->retries = 0;
 	pc->flags = 0;
-	pc->request_transfer = 0;
-	pc->buffer = pc->pc_buffer;
-	pc->buffer_size = IDETAPE_PC_BUFFER_SIZE;
+	pc->req_xfer = 0;
+	pc->buf = pc->pc_buf;
+	pc->buf_size = IDETAPE_PC_BUFFER_SIZE;
 	pc->bh = NULL;
 	pc->b_data = NULL;
 }
@@ -664,7 +636,7 @@ static void idetape_init_pc(idetape_pc_t *pc)
 static void idetape_analyze_error(ide_drive_t *drive, u8 *sense)
 {
 	idetape_tape_t *tape = drive->driver_data;
-	idetape_pc_t *pc = tape->failed_pc;
+	struct ide_atapi_pc *pc = tape->failed_pc;
 
 	tape->sense_key = sense[2] & 0xF;
 	tape->asc       = sense[12];
@@ -673,9 +645,9 @@ static void idetape_analyze_error(ide_drive_t *drive, u8 *sense)
 	debug_log(DBG_ERR, "pc = %x, sense key = %x, asc = %x, ascq = %x\n",
 		 pc->c[0], tape->sense_key, tape->asc, tape->ascq);
 
-	/* Correct pc->actually_transferred by asking the tape.	 */
+	/* Correct pc->xferred by asking the tape.	 */
 	if (pc->flags & PC_FLAG_DMA_ERROR) {
-		pc->actually_transferred = pc->request_transfer -
+		pc->xferred = pc->req_xfer -
 			tape->blk_size *
 			be32_to_cpu(get_unaligned((u32 *)&sense[3]));
 		idetape_update_buffers(pc);
@@ -713,7 +685,7 @@ static void idetape_analyze_error(ide_drive_t *drive, u8 *sense)
 			pc->flags |= PC_FLAG_ABORT;
 		}
 		if (!(pc->flags & PC_FLAG_ABORT) &&
-		    pc->actually_transferred)
+		    pc->xferred)
 			pc->retries = IDETAPE_MAX_PC_RETRIES + 1;
 	}
 }
@@ -922,7 +894,7 @@ static ide_startstop_t idetape_request_sense_callback(ide_drive_t *drive)
 	debug_log(DBG_PROCS, "Enter %s\n", __func__);
 
 	if (!tape->pc->error) {
-		idetape_analyze_error(drive, tape->pc->buffer);
+		idetape_analyze_error(drive, tape->pc->buf);
 		idetape_end_request(drive, 1, 0);
 	} else {
 		printk(KERN_ERR "ide-tape: Error in REQUEST SENSE itself - "
@@ -932,13 +904,13 @@ static ide_startstop_t idetape_request_sense_callback(ide_drive_t *drive)
 	return ide_stopped;
 }
 
-static void idetape_create_request_sense_cmd(idetape_pc_t *pc)
+static void idetape_create_request_sense_cmd(struct ide_atapi_pc *pc)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = REQUEST_SENSE;
 	pc->c[4] = 20;
-	pc->request_transfer = 20;
-	pc->callback = &idetape_request_sense_callback;
+	pc->req_xfer = 20;
+	pc->idetape_callback = &idetape_request_sense_callback;
 }
 
 static void idetape_init_rq(struct request *rq, u8 cmd)
@@ -963,7 +935,7 @@ static void idetape_init_rq(struct request *rq, u8 cmd)
  * handling functions should queue request to the lower level part and wait for
  * their completion using idetape_queue_pc_tail or idetape_queue_rw_tail.
  */
-static void idetape_queue_pc_head(ide_drive_t *drive, idetape_pc_t *pc,
+static void idetape_queue_pc_head(ide_drive_t *drive, struct ide_atapi_pc *pc,
 				  struct request *rq)
 {
 	struct ide_tape_obj *tape = drive->driver_data;
@@ -982,7 +954,7 @@ static void idetape_queue_pc_head(ide_drive_t *drive, idetape_pc_t *pc,
 static ide_startstop_t idetape_retry_pc (ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
-	idetape_pc_t *pc;
+	struct ide_atapi_pc *pc;
 	struct request *rq;
 
 	(void)ide_read_error(drive);
@@ -1008,7 +980,7 @@ static void idetape_postpone_request(ide_drive_t *drive)
 	ide_stall_queue(drive, tape->dsc_poll_freq);
 }
 
-typedef void idetape_io_buf(ide_drive_t *, idetape_pc_t *, unsigned int);
+typedef void idetape_io_buf(ide_drive_t *, struct ide_atapi_pc *, unsigned int);
 
 /*
  * This is the usual interrupt handler which will be called during a packet
@@ -1021,7 +993,7 @@ static ide_startstop_t idetape_pc_intr(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	idetape_tape_t *tape = drive->driver_data;
-	idetape_pc_t *pc = tape->pc;
+	struct ide_atapi_pc *pc = tape->pc;
 	xfer_func_t *xferfunc;
 	idetape_io_buf *iobuf;
 	unsigned int temp;
@@ -1061,7 +1033,7 @@ static ide_startstop_t idetape_pc_intr(ide_drive_t *drive)
 			 */
 			pc->flags |= PC_FLAG_DMA_ERROR;
 		} else {
-			pc->actually_transferred = pc->request_transfer;
+			pc->xferred = pc->req_xfer;
 			idetape_update_buffers(pc);
 		}
 		debug_log(DBG_PROCS, "DMA finished\n");
@@ -1071,7 +1043,7 @@ static ide_startstop_t idetape_pc_intr(ide_drive_t *drive)
 	/* No more interrupts */
 	if ((stat & DRQ_STAT) == 0) {
 		debug_log(DBG_SENSE, "Packet command completed, %d bytes"
-				" transferred\n", pc->actually_transferred);
+				" transferred\n", pc->xferred);
 
 		pc->flags &= ~PC_FLAG_DMA_IN_PROGRESS;
 		local_irq_enable();
@@ -1115,7 +1087,7 @@ static ide_startstop_t idetape_pc_intr(ide_drive_t *drive)
 		if (tape->failed_pc == pc)
 			tape->failed_pc = NULL;
 		/* Command finished - Call the callback function */
-		return pc->callback(drive);
+		return pc->idetape_callback(drive);
 	}
 
 	if (pc->flags & PC_FLAG_DMA_IN_PROGRESS) {
@@ -1146,9 +1118,9 @@ static ide_startstop_t idetape_pc_intr(ide_drive_t *drive)
 	}
 	if (!(pc->flags & PC_FLAG_WRITING)) {
 		/* Reading - Check that we have enough space */
-		temp = pc->actually_transferred + bcount;
-		if (temp > pc->request_transfer) {
-			if (temp > pc->buffer_size) {
+		temp = pc->xferred + bcount;
+		if (temp > pc->req_xfer) {
+			if (temp > pc->buf_size) {
 				printk(KERN_ERR "ide-tape: The tape wants to "
 					"send us more data than expected "
 					"- discarding data\n");
@@ -1170,11 +1142,11 @@ static ide_startstop_t idetape_pc_intr(ide_drive_t *drive)
 	if (pc->bh)
 		iobuf(drive, pc, bcount);
 	else
-		xferfunc(drive, pc->current_position, bcount);
+		xferfunc(drive, pc->cur_pos, bcount);
 
 	/* Update the current position */
-	pc->actually_transferred += bcount;
-	pc->current_position += bcount;
+	pc->xferred += bcount;
+	pc->cur_pos += bcount;
 
 	debug_log(DBG_SENSE, "[cmd %x] transferred %d bytes on that intr.\n",
 			pc->c[0], bcount);
@@ -1224,7 +1196,7 @@ static ide_startstop_t idetape_transfer_pc(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	idetape_tape_t *tape = drive->driver_data;
-	idetape_pc_t *pc = tape->pc;
+	struct ide_atapi_pc *pc = tape->pc;
 	int retries = 100;
 	ide_startstop_t startstop;
 	u8 ireason;
@@ -1264,7 +1236,8 @@ static ide_startstop_t idetape_transfer_pc(ide_drive_t *drive)
 	return ide_started;
 }
 
-static ide_startstop_t idetape_issue_pc(ide_drive_t *drive, idetape_pc_t *pc)
+static ide_startstop_t idetape_issue_pc(ide_drive_t *drive,
+		struct ide_atapi_pc *pc)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	idetape_tape_t *tape = drive->driver_data;
@@ -1304,16 +1277,16 @@ static ide_startstop_t idetape_issue_pc(ide_drive_t *drive, idetape_pc_t *pc)
 			pc->error = IDETAPE_ERROR_GENERAL;
 		}
 		tape->failed_pc = NULL;
-		return pc->callback(drive);
+		return pc->idetape_callback(drive);
 	}
 	debug_log(DBG_SENSE, "Retry #%d, cmd = %02X\n", pc->retries, pc->c[0]);
 
 	pc->retries++;
 	/* We haven't transferred any data yet */
-	pc->actually_transferred = 0;
-	pc->current_position = pc->buffer;
+	pc->xferred = 0;
+	pc->cur_pos = pc->buf;
 	/* Request to transfer the entire buffer at once */
-	bcount = pc->request_transfer;
+	bcount = pc->req_xfer;
 
 	if (pc->flags & PC_FLAG_DMA_ERROR) {
 		pc->flags &= ~PC_FLAG_DMA_ERROR;
@@ -1351,7 +1324,7 @@ static ide_startstop_t idetape_pc_callback(ide_drive_t *drive)
 }
 
 /* A mode sense command is used to "sense" tape parameters. */
-static void idetape_create_mode_sense_cmd(idetape_pc_t *pc, u8 page_code)
+static void idetape_create_mode_sense_cmd(struct ide_atapi_pc *pc, u8 page_code)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = MODE_SENSE;
@@ -1370,12 +1343,12 @@ static void idetape_create_mode_sense_cmd(idetape_pc_t *pc, u8 page_code)
 	/* We will just discard data in that case */
 	pc->c[4] = 255;
 	if (page_code == IDETAPE_BLOCK_DESCRIPTOR)
-		pc->request_transfer = 12;
+		pc->req_xfer = 12;
 	else if (page_code == IDETAPE_CAPABILITIES_PAGE)
-		pc->request_transfer = 24;
+		pc->req_xfer = 24;
 	else
-		pc->request_transfer = 50;
-	pc->callback = &idetape_pc_callback;
+		pc->req_xfer = 50;
+	pc->idetape_callback = &idetape_pc_callback;
 }
 
 static void idetape_calculate_speeds(ide_drive_t *drive)
@@ -1444,7 +1417,7 @@ static void idetape_calculate_speeds(ide_drive_t *drive)
 static ide_startstop_t idetape_media_access_finished(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
-	idetape_pc_t *pc = tape->pc;
+	struct ide_atapi_pc *pc = tape->pc;
 	u8 stat;
 
 	stat = ide_read_status(drive);
@@ -1465,14 +1438,14 @@ static ide_startstop_t idetape_media_access_finished(ide_drive_t *drive)
 		pc->error = IDETAPE_ERROR_GENERAL;
 		tape->failed_pc = NULL;
 	}
-	return pc->callback(drive);
+	return pc->idetape_callback(drive);
 }
 
 static ide_startstop_t idetape_rw_callback(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	struct request *rq = HWGROUP(drive)->rq;
-	int blocks = tape->pc->actually_transferred / tape->blk_size;
+	int blocks = tape->pc->xferred / tape->blk_size;
 
 	tape->avg_size += blocks * tape->blk_size;
 	tape->insert_size += blocks * tape->blk_size;
@@ -1504,39 +1477,41 @@ static ide_startstop_t idetape_rw_callback(ide_drive_t *drive)
 	return ide_stopped;
 }
 
-static void idetape_create_read_cmd(idetape_tape_t *tape, idetape_pc_t *pc,
+static void idetape_create_read_cmd(idetape_tape_t *tape,
+		struct ide_atapi_pc *pc,
 		unsigned int length, struct idetape_bh *bh)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = READ_6;
 	put_unaligned(cpu_to_be32(length), (unsigned int *) &pc->c[1]);
 	pc->c[1] = 1;
-	pc->callback = &idetape_rw_callback;
+	pc->idetape_callback = &idetape_rw_callback;
 	pc->bh = bh;
 	atomic_set(&bh->b_count, 0);
-	pc->buffer = NULL;
-	pc->buffer_size = length * tape->blk_size;
-	pc->request_transfer = pc->buffer_size;
-	if (pc->request_transfer == tape->stage_size)
+	pc->buf = NULL;
+	pc->buf_size = length * tape->blk_size;
+	pc->req_xfer = pc->buf_size;
+	if (pc->req_xfer == tape->stage_size)
 		pc->flags |= PC_FLAG_DMA_RECOMMENDED;
 }
 
-static void idetape_create_write_cmd(idetape_tape_t *tape, idetape_pc_t *pc,
+static void idetape_create_write_cmd(idetape_tape_t *tape,
+		struct ide_atapi_pc *pc,
 		unsigned int length, struct idetape_bh *bh)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = WRITE_6;
 	put_unaligned(cpu_to_be32(length), (unsigned int *) &pc->c[1]);
 	pc->c[1] = 1;
-	pc->callback = &idetape_rw_callback;
+	pc->idetape_callback = &idetape_rw_callback;
 	pc->flags |= PC_FLAG_WRITING;
 	pc->bh = bh;
 	pc->b_data = bh->b_data;
 	pc->b_count = atomic_read(&bh->b_count);
-	pc->buffer = NULL;
-	pc->buffer_size = length * tape->blk_size;
-	pc->request_transfer = pc->buffer_size;
-	if (pc->request_transfer == tape->stage_size)
+	pc->buf = NULL;
+	pc->buf_size = length * tape->blk_size;
+	pc->req_xfer = pc->buf_size;
+	if (pc->req_xfer == tape->stage_size)
 		pc->flags |= PC_FLAG_DMA_RECOMMENDED;
 }
 
@@ -1544,7 +1519,7 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 					  struct request *rq, sector_t block)
 {
 	idetape_tape_t *tape = drive->driver_data;
-	idetape_pc_t *pc = NULL;
+	struct ide_atapi_pc *pc = NULL;
 	struct request *postponed_rq = tape->postponed_rq;
 	u8 stat;
 
@@ -1631,7 +1606,7 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 		goto out;
 	}
 	if (rq->cmd[0] & REQ_IDETAPE_PC1) {
-		pc = (idetape_pc_t *) rq->buffer;
+		pc = (struct ide_atapi_pc *) rq->buffer;
 		rq->cmd[0] &= ~(REQ_IDETAPE_PC1);
 		rq->cmd[0] |= REQ_IDETAPE_PC2;
 		goto out;
@@ -1883,7 +1858,7 @@ static void idetape_wait_for_request(ide_drive_t *drive, struct request *rq)
 static ide_startstop_t idetape_read_position_callback(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
-	u8 *readpos = tape->pc->buffer;
+	u8 *readpos = tape->pc->buf;
 
 	debug_log(DBG_PROCS, "Enter %s\n", __func__);
 
@@ -1919,20 +1894,20 @@ static ide_startstop_t idetape_read_position_callback(ide_drive_t *drive)
  * writing a filemark otherwise.
  */
 static void idetape_create_write_filemark_cmd(ide_drive_t *drive,
-		idetape_pc_t *pc, int write_filemark)
+		struct ide_atapi_pc *pc, int write_filemark)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = WRITE_FILEMARKS;
 	pc->c[4] = write_filemark;
 	pc->flags |= PC_FLAG_WAIT_FOR_DSC;
-	pc->callback = &idetape_pc_callback;
+	pc->idetape_callback = &idetape_pc_callback;
 }
 
-static void idetape_create_test_unit_ready_cmd(idetape_pc_t *pc)
+static void idetape_create_test_unit_ready_cmd(struct ide_atapi_pc *pc)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = TEST_UNIT_READY;
-	pc->callback = &idetape_pc_callback;
+	pc->idetape_callback = &idetape_pc_callback;
 }
 
 /*
@@ -1948,7 +1923,7 @@ static void idetape_create_test_unit_ready_cmd(idetape_pc_t *pc)
  * to the request list without waiting for it to be serviced! In that case, we
  * usually use idetape_queue_pc_head().
  */
-static int __idetape_queue_pc_tail(ide_drive_t *drive, idetape_pc_t *pc)
+static int __idetape_queue_pc_tail(ide_drive_t *drive, struct ide_atapi_pc *pc)
 {
 	struct ide_tape_obj *tape = drive->driver_data;
 	struct request rq;
@@ -1959,20 +1934,20 @@ static int __idetape_queue_pc_tail(ide_drive_t *drive, idetape_pc_t *pc)
 	return ide_do_drive_cmd(drive, &rq, ide_wait);
 }
 
-static void idetape_create_load_unload_cmd(ide_drive_t *drive, idetape_pc_t *pc,
-		int cmd)
+static void idetape_create_load_unload_cmd(ide_drive_t *drive,
+		struct ide_atapi_pc *pc, int cmd)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = START_STOP;
 	pc->c[4] = cmd;
 	pc->flags |= PC_FLAG_WAIT_FOR_DSC;
-	pc->callback = &idetape_pc_callback;
+	pc->idetape_callback = &idetape_pc_callback;
 }
 
 static int idetape_wait_ready(ide_drive_t *drive, unsigned long timeout)
 {
 	idetape_tape_t *tape = drive->driver_data;
-	idetape_pc_t pc;
+	struct ide_atapi_pc pc;
 	int load_attempted = 0;
 
 	/* Wait for the tape to become ready */
@@ -2000,14 +1975,14 @@ static int idetape_wait_ready(ide_drive_t *drive, unsigned long timeout)
 	return -EIO;
 }
 
-static int idetape_queue_pc_tail(ide_drive_t *drive, idetape_pc_t *pc)
+static int idetape_queue_pc_tail(ide_drive_t *drive, struct ide_atapi_pc *pc)
 {
 	return __idetape_queue_pc_tail(drive, pc);
 }
 
 static int idetape_flush_tape_buffers(ide_drive_t *drive)
 {
-	idetape_pc_t pc;
+	struct ide_atapi_pc pc;
 	int rc;
 
 	idetape_create_write_filemark_cmd(drive, &pc, 0);
@@ -2018,18 +1993,18 @@ static int idetape_flush_tape_buffers(ide_drive_t *drive)
 	return 0;
 }
 
-static void idetape_create_read_position_cmd(idetape_pc_t *pc)
+static void idetape_create_read_position_cmd(struct ide_atapi_pc *pc)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = READ_POSITION;
-	pc->request_transfer = 20;
-	pc->callback = &idetape_read_position_callback;
+	pc->req_xfer = 20;
+	pc->idetape_callback = &idetape_read_position_callback;
 }
 
 static int idetape_read_position(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
-	idetape_pc_t pc;
+	struct ide_atapi_pc pc;
 	int position;
 
 	debug_log(DBG_PROCS, "Enter %s\n", __func__);
@@ -2041,7 +2016,8 @@ static int idetape_read_position(ide_drive_t *drive)
 	return position;
 }
 
-static void idetape_create_locate_cmd(ide_drive_t *drive, idetape_pc_t *pc,
+static void idetape_create_locate_cmd(ide_drive_t *drive,
+		struct ide_atapi_pc *pc,
 		unsigned int block, u8 partition, int skip)
 {
 	idetape_init_pc(pc);
@@ -2050,11 +2026,11 @@ static void idetape_create_locate_cmd(ide_drive_t *drive, idetape_pc_t *pc,
 	put_unaligned(cpu_to_be32(block), (unsigned int *) &pc->c[3]);
 	pc->c[8] = partition;
 	pc->flags |= PC_FLAG_WAIT_FOR_DSC;
-	pc->callback = &idetape_pc_callback;
+	pc->idetape_callback = &idetape_pc_callback;
 }
 
-static int idetape_create_prevent_cmd(ide_drive_t *drive, idetape_pc_t *pc,
-				      int prevent)
+static int idetape_create_prevent_cmd(ide_drive_t *drive,
+		struct ide_atapi_pc *pc, int prevent)
 {
 	idetape_tape_t *tape = drive->driver_data;
 
@@ -2065,7 +2041,7 @@ static int idetape_create_prevent_cmd(ide_drive_t *drive, idetape_pc_t *pc,
 	idetape_init_pc(pc);
 	pc->c[0] = ALLOW_MEDIUM_REMOVAL;
 	pc->c[4] = prevent;
-	pc->callback = &idetape_pc_callback;
+	pc->idetape_callback = &idetape_pc_callback;
 	return 1;
 }
 
@@ -2126,7 +2102,7 @@ static int idetape_position_tape(ide_drive_t *drive, unsigned int block,
 {
 	idetape_tape_t *tape = drive->driver_data;
 	int retval;
-	idetape_pc_t pc;
+	struct ide_atapi_pc pc;
 
 	if (tape->chrdev_dir == IDETAPE_DIR_READ)
 		__idetape_discard_read_pipeline(drive);
@@ -2209,40 +2185,41 @@ static void idetape_plug_pipeline(ide_drive_t *drive)
 	}
 }
 
-static void idetape_create_inquiry_cmd(idetape_pc_t *pc)
+static void idetape_create_inquiry_cmd(struct ide_atapi_pc *pc)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = INQUIRY;
 	pc->c[4] = 254;
-	pc->request_transfer = 254;
-	pc->callback = &idetape_pc_callback;
+	pc->req_xfer = 254;
+	pc->idetape_callback = &idetape_pc_callback;
 }
 
-static void idetape_create_rewind_cmd(ide_drive_t *drive, idetape_pc_t *pc)
+static void idetape_create_rewind_cmd(ide_drive_t *drive,
+		struct ide_atapi_pc *pc)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = REZERO_UNIT;
 	pc->flags |= PC_FLAG_WAIT_FOR_DSC;
-	pc->callback = &idetape_pc_callback;
+	pc->idetape_callback = &idetape_pc_callback;
 }
 
-static void idetape_create_erase_cmd(idetape_pc_t *pc)
+static void idetape_create_erase_cmd(struct ide_atapi_pc *pc)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = ERASE;
 	pc->c[1] = 1;
 	pc->flags |= PC_FLAG_WAIT_FOR_DSC;
-	pc->callback = &idetape_pc_callback;
+	pc->idetape_callback = &idetape_pc_callback;
 }
 
-static void idetape_create_space_cmd(idetape_pc_t *pc, int count, u8 cmd)
+static void idetape_create_space_cmd(struct ide_atapi_pc *pc, int count, u8 cmd)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = SPACE;
 	put_unaligned(cpu_to_be32(count), (unsigned int *) &pc->c[1]);
 	pc->c[1] = cmd;
 	pc->flags |= PC_FLAG_WAIT_FOR_DSC;
-	pc->callback = &idetape_pc_callback;
+	pc->idetape_callback = &idetape_pc_callback;
 }
 
 static void idetape_wait_first_stage(ide_drive_t *drive)
@@ -2620,7 +2597,7 @@ static int idetape_pipeline_size(ide_drive_t *drive)
 static int idetape_rewind_tape(ide_drive_t *drive)
 {
 	int retval;
-	idetape_pc_t pc;
+	struct ide_atapi_pc pc;
 	idetape_tape_t *tape;
 	tape = drive->driver_data;
 
@@ -2683,7 +2660,7 @@ static int idetape_space_over_filemarks(ide_drive_t *drive, short mt_op,
 					int mt_count)
 {
 	idetape_tape_t *tape = drive->driver_data;
-	idetape_pc_t pc;
+	struct ide_atapi_pc pc;
 	unsigned long flags;
 	int retval, count = 0;
 	int sprev = !!(tape->caps[4] & 0x20);
@@ -2941,7 +2918,7 @@ static ssize_t idetape_chrdev_write(struct file *file, const char __user *buf,
 
 static int idetape_write_filemark(ide_drive_t *drive)
 {
-	idetape_pc_t pc;
+	struct ide_atapi_pc pc;
 
 	/* Write a filemark */
 	idetape_create_write_filemark_cmd(drive, &pc, 1);
@@ -2969,7 +2946,7 @@ static int idetape_write_filemark(ide_drive_t *drive)
 static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
 {
 	idetape_tape_t *tape = drive->driver_data;
-	idetape_pc_t pc;
+	struct ide_atapi_pc pc;
 	int i, retval;
 
 	debug_log(DBG_ERR, "Handling MTIOCTOP ioctl: mt_op=%d, mt_count=%d\n",
@@ -3152,7 +3129,7 @@ static int idetape_chrdev_ioctl(struct inode *inode, struct file *file,
 static void ide_tape_get_bsize_from_bdesc(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
-	idetape_pc_t pc;
+	struct ide_atapi_pc pc;
 
 	idetape_create_mode_sense_cmd(&pc, IDETAPE_BLOCK_DESCRIPTOR);
 	if (idetape_queue_pc_tail(drive, &pc)) {
@@ -3164,10 +3141,10 @@ static void ide_tape_get_bsize_from_bdesc(ide_drive_t *drive)
 		}
 		return;
 	}
-	tape->blk_size = (pc.buffer[4 + 5] << 16) +
-				(pc.buffer[4 + 6] << 8)  +
-				 pc.buffer[4 + 7];
-	tape->drv_write_prot = (pc.buffer[2] & 0x80) >> 7;
+	tape->blk_size = (pc.buf[4 + 5] << 16) +
+				(pc.buf[4 + 6] << 8)  +
+				 pc.buf[4 + 7];
+	tape->drv_write_prot = (pc.buf[2] & 0x80) >> 7;
 }
 
 static int idetape_chrdev_open(struct inode *inode, struct file *filp)
@@ -3175,7 +3152,7 @@ static int idetape_chrdev_open(struct inode *inode, struct file *filp)
 	unsigned int minor = iminor(inode), i = minor & ~0xc0;
 	ide_drive_t *drive;
 	idetape_tape_t *tape;
-	idetape_pc_t pc;
+	struct ide_atapi_pc pc;
 	int retval;
 
 	if (i >= MAX_HWIFS * MAX_DRIVES)
@@ -3275,7 +3252,7 @@ static int idetape_chrdev_release(struct inode *inode, struct file *filp)
 {
 	struct ide_tape_obj *tape = ide_tape_f(filp);
 	ide_drive_t *drive = tape->drive;
-	idetape_pc_t pc;
+	struct ide_atapi_pc pc;
 	unsigned int minor = iminor(inode);
 
 	lock_kernel();
@@ -3353,7 +3330,7 @@ static int idetape_identify_device(ide_drive_t *drive)
 static void idetape_get_inquiry_results(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
-	idetape_pc_t pc;
+	struct ide_atapi_pc pc;
 	char fw_rev[6], vendor_id[10], product_id[18];
 
 	idetape_create_inquiry_cmd(&pc);
@@ -3362,9 +3339,9 @@ static void idetape_get_inquiry_results(ide_drive_t *drive)
 				tape->name);
 		return;
 	}
-	memcpy(vendor_id, &pc.buffer[8], 8);
-	memcpy(product_id, &pc.buffer[16], 16);
-	memcpy(fw_rev, &pc.buffer[32], 4);
+	memcpy(vendor_id, &pc.buf[8], 8);
+	memcpy(product_id, &pc.buf[16], 16);
+	memcpy(fw_rev, &pc.buf[32], 4);
 
 	ide_fixstring(vendor_id, 10, 0);
 	ide_fixstring(product_id, 18, 0);
@@ -3381,7 +3358,7 @@ static void idetape_get_inquiry_results(ide_drive_t *drive)
 static void idetape_get_mode_sense_results(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
-	idetape_pc_t pc;
+	struct ide_atapi_pc pc;
 	u8 *caps;
 	u8 speed, max_speed;
 
@@ -3395,7 +3372,7 @@ static void idetape_get_mode_sense_results(ide_drive_t *drive)
 		put_unaligned(6*52, (u16 *)&tape->caps[16]);
 		return;
 	}
-	caps = pc.buffer + 4 + pc.buffer[3];
+	caps = pc.buf + 4 + pc.buf[3];
 
 	/* convert to host order and save for later use */
 	speed = be16_to_cpu(*(u16 *)&caps[14]);
-- 
1.5.3.7

