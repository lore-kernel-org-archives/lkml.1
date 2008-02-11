Return-Path: <linux-kernel-owner+w=401wt.eu-S1755576AbYBKIgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576AbYBKIgB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 03:36:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753274AbYBKIfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 03:35:18 -0500
Received: from fk-out-0910.google.com ([209.85.128.189]:13868 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243AbYBKIfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 03:35:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=vfJsDPxQjDc5FByQyiQ9gSK72Ztrq440ttWoqY8DCLi1neyD3+rd7ORV3WzJ8hDsi45VHqYWQbSdkwd51O+v+YH2FyzVDS9rtxKcKgy2pT5QQiiXlcakYTrbXz0VPv7F1+/i/i5JxaZnW6c5Hwoshe8UoSBZWztLFKrSIMtuZeU=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 2/4] ide-floppy: convert driver to using generic ide_atapi_pc
Date: Mon, 11 Feb 2008 09:34:38 +0100
Message-Id: <1202718880-1793-3-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1202718880-1793-1-git-send-email-petkovbb@gmail.com>
References: <1202718880-1793-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-floppy.c |  205 +++++++++++++++++++++-------------------------
 1 files changed, 93 insertions(+), 112 deletions(-)

diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 4ce67bd..7e62dfc 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -78,26 +78,6 @@
  */
 #define IDEFLOPPY_PC_STACK		(10 + IDEFLOPPY_MAX_PC_RETRIES)
 
-typedef struct idefloppy_packet_command_s {
-	u8 c[12];				/* Actual packet bytes */
-	int retries;				/* On each retry, we increment
-						   retries */
-	int error;				/* Error code */
-	int request_transfer;			/* Bytes to transfer */
-	int actually_transferred;		/* Bytes actually transferred */
-	int buffer_size;			/* Size of our data buffer */
-	int b_count;				/* Missing/Available data on
-						   the current buffer */
-	struct request *rq;			/* The corresponding request */
-	u8 *buffer;				/* Data buffer */
-	u8 *current_position;			/* Pointer into above buffer */
-	void (*callback) (ide_drive_t *);	/* Called when this packet
-						   command is completed */
-	u8 pc_buffer[IDEFLOPPY_PC_BUFFER_SIZE];	/* Temporary buffer */
-	unsigned long flags;			/* Status/Action bit flags: long
-						   for set_bit */
-} idefloppy_pc_t;
-
 /* Packet command flag bits. */
 enum {
 	/* 1 when we prefer to use DMA if possible */
@@ -131,11 +111,11 @@ typedef struct ide_floppy_obj {
 	unsigned int	openers;	/* protected by BKL for now */
 
 	/* Current packet command */
-	idefloppy_pc_t *pc;
+	struct ide_atapi_pc *pc;
 	/* Last failed packet command */
-	idefloppy_pc_t *failed_pc;
+	struct ide_atapi_pc *failed_pc;
 	/* Packet command stack */
-	idefloppy_pc_t pc_stack[IDEFLOPPY_PC_STACK];
+	struct ide_atapi_pc pc_stack[IDEFLOPPY_PC_STACK];
 	/* Next free packet command storage space */
 	int pc_stack_index;
 	struct request rq_stack[IDEFLOPPY_PC_STACK];
@@ -262,7 +242,7 @@ static int idefloppy_do_end_request(ide_drive_t *drive, int uptodate, int nsecs)
 	return 0;
 }
 
-static void ide_floppy_io_buffers(ide_drive_t *drive, idefloppy_pc_t *pc,
+static void ide_floppy_io_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
 				  unsigned int bcount, int direction)
 {
 	struct request *rq = pc->rq;
@@ -302,7 +282,8 @@ static void ide_floppy_io_buffers(ide_drive_t *drive, idefloppy_pc_t *pc,
 	}
 }
 
-static void idefloppy_update_buffers(ide_drive_t *drive, idefloppy_pc_t *pc)
+static void idefloppy_update_buffers(ide_drive_t *drive,
+				struct ide_atapi_pc *pc)
 {
 	struct request *rq = pc->rq;
 	struct bio *bio = rq->bio;
@@ -316,7 +297,7 @@ static void idefloppy_update_buffers(ide_drive_t *drive, idefloppy_pc_t *pc)
  * the current request so that it will be processed immediately, on the next
  * pass through the driver.
  */
-static void idefloppy_queue_pc_head(ide_drive_t *drive, idefloppy_pc_t *pc,
+static void idefloppy_queue_pc_head(ide_drive_t *drive, struct ide_atapi_pc *pc,
 		struct request *rq)
 {
 	struct ide_floppy_obj *floppy = drive->driver_data;
@@ -328,7 +309,7 @@ static void idefloppy_queue_pc_head(ide_drive_t *drive, idefloppy_pc_t *pc,
 	(void) ide_do_drive_cmd(drive, rq, ide_preempt);
 }
 
-static idefloppy_pc_t *idefloppy_next_pc_storage(ide_drive_t *drive)
+static struct ide_atapi_pc *idefloppy_next_pc_storage(ide_drive_t *drive)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
 
@@ -349,7 +330,7 @@ static struct request *idefloppy_next_rq_storage(ide_drive_t *drive)
 static void idefloppy_request_sense_callback(ide_drive_t *drive)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
-	u8 *buf = floppy->pc->buffer;
+	u8 *buf = floppy->pc->buf;
 
 	debug_log("Reached %s\n", __func__);
 
@@ -392,24 +373,24 @@ static void idefloppy_pc_callback(ide_drive_t *drive)
 	idefloppy_do_end_request(drive, floppy->pc->error ? 0 : 1, 0);
 }
 
-static void idefloppy_init_pc(idefloppy_pc_t *pc)
+static void idefloppy_init_pc(struct ide_atapi_pc *pc)
 {
 	memset(pc->c, 0, 12);
 	pc->retries = 0;
 	pc->flags = 0;
-	pc->request_transfer = 0;
-	pc->buffer = pc->pc_buffer;
-	pc->buffer_size = IDEFLOPPY_PC_BUFFER_SIZE;
-	pc->callback = &idefloppy_pc_callback;
+	pc->req_xfer = 0;
+	pc->buf = pc->pc_buf;
+	pc->buf_size = IDEFLOPPY_PC_BUFFER_SIZE;
+	pc->idefloppy_callback = &idefloppy_pc_callback;
 }
 
-static void idefloppy_create_request_sense_cmd(idefloppy_pc_t *pc)
+static void idefloppy_create_request_sense_cmd(struct ide_atapi_pc *pc)
 {
 	idefloppy_init_pc(pc);
 	pc->c[0] = GPCMD_REQUEST_SENSE;
 	pc->c[4] = 255;
-	pc->request_transfer = 18;
-	pc->callback = &idefloppy_request_sense_callback;
+	pc->req_xfer = 18;
+	pc->idefloppy_callback = &idefloppy_request_sense_callback;
 }
 
 /*
@@ -418,7 +399,7 @@ static void idefloppy_create_request_sense_cmd(idefloppy_pc_t *pc)
  */
 static void idefloppy_retry_pc(ide_drive_t *drive)
 {
-	idefloppy_pc_t *pc;
+	struct ide_atapi_pc *pc;
 	struct request *rq;
 
 	(void)ide_read_error(drive);
@@ -433,7 +414,7 @@ static ide_startstop_t idefloppy_pc_intr (ide_drive_t *drive)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
 	ide_hwif_t *hwif = drive->hwif;
-	idefloppy_pc_t *pc = floppy->pc;
+	struct ide_atapi_pc *pc = floppy->pc;
 	struct request *rq = pc->rq;
 	xfer_func_t *xferfunc;
 	unsigned int temp;
@@ -450,7 +431,7 @@ static ide_startstop_t idefloppy_pc_intr (ide_drive_t *drive)
 					rq_data_dir(rq) ? "write" : "read");
 			pc->flags |= PC_FLAG_DMA_ERROR;
 		} else {
-			pc->actually_transferred = pc->request_transfer;
+			pc->xferred = pc->req_xfer;
 			idefloppy_update_buffers(drive, pc);
 		}
 		debug_log("DMA finished\n");
@@ -462,7 +443,7 @@ static ide_startstop_t idefloppy_pc_intr (ide_drive_t *drive)
 	/* No more interrupts */
 	if ((stat & DRQ_STAT) == 0) {
 		debug_log("Packet command completed, %d bytes transferred\n",
-				pc->actually_transferred);
+				pc->xferred);
 		pc->flags &= ~PC_FLAG_DMA_IN_PROGRESS;
 
 		local_irq_enable_in_hardirq();
@@ -485,7 +466,7 @@ static ide_startstop_t idefloppy_pc_intr (ide_drive_t *drive)
 		if (floppy->failed_pc == pc)
 			floppy->failed_pc = NULL;
 		/* Command finished - Call the callback function */
-		pc->callback(drive);
+		pc->idefloppy_callback(drive);
 		return ide_stopped;
 	}
 
@@ -517,9 +498,9 @@ static ide_startstop_t idefloppy_pc_intr (ide_drive_t *drive)
 	}
 	if (!(pc->flags & PC_FLAG_WRITING)) {
 		/* Reading - Check that we have enough space */
-		temp = pc->actually_transferred + bcount;
-		if (temp > pc->request_transfer) {
-			if (temp > pc->buffer_size) {
+		temp = pc->xferred + bcount;
+		if (temp > pc->req_xfer) {
+			if (temp > pc->buf_size) {
 				printk(KERN_ERR "ide-floppy: The floppy wants "
 					"to send us more data than expected "
 					"- discarding data\n");
@@ -540,15 +521,15 @@ static ide_startstop_t idefloppy_pc_intr (ide_drive_t *drive)
 	else
 		xferfunc = hwif->atapi_input_bytes;
 
-	if (pc->buffer)
-		xferfunc(drive, pc->current_position, bcount);
+	if (pc->buf)
+		xferfunc(drive, pc->cur_pos, bcount);
 	else
 		ide_floppy_io_buffers(drive, pc, bcount,
 				      !!(pc->flags & PC_FLAG_WRITING));
 
 	/* Update the current position */
-	pc->actually_transferred += bcount;
-	pc->current_position += bcount;
+	pc->xferred += bcount;
+	pc->cur_pos += bcount;
 
 	/* And set the interrupt handler again */
 	ide_set_handler(drive, &idefloppy_pc_intr, IDEFLOPPY_WAIT_CMD, NULL);
@@ -640,7 +621,7 @@ static ide_startstop_t idefloppy_transfer_pc1(ide_drive_t *drive)
 }
 
 static void ide_floppy_report_error(idefloppy_floppy_t *floppy,
-				    idefloppy_pc_t *pc)
+				    struct ide_atapi_pc *pc)
 {
 	/* supress error messages resulting from Medium not present */
 	if (floppy->sense_key == 0x02 &&
@@ -656,7 +637,7 @@ static void ide_floppy_report_error(idefloppy_floppy_t *floppy,
 }
 
 static ide_startstop_t idefloppy_issue_pc(ide_drive_t *drive,
-		idefloppy_pc_t *pc)
+		struct ide_atapi_pc *pc)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
 	ide_hwif_t *hwif = drive->hwif;
@@ -677,7 +658,7 @@ static ide_startstop_t idefloppy_issue_pc(ide_drive_t *drive,
 		pc->error = IDEFLOPPY_ERROR_GENERAL;
 
 		floppy->failed_pc = NULL;
-		pc->callback(drive);
+		pc->idefloppy_callback(drive);
 		return ide_stopped;
 	}
 
@@ -685,9 +666,9 @@ static ide_startstop_t idefloppy_issue_pc(ide_drive_t *drive,
 
 	pc->retries++;
 	/* We haven't transferred any data yet */
-	pc->actually_transferred = 0;
-	pc->current_position = pc->buffer;
-	bcount = min(pc->request_transfer, 63 * 1024);
+	pc->xferred = 0;
+	pc->cur_pos = pc->buf;
+	bcount = min(pc->req_xfer, 63 * 1024);
 
 	if (pc->flags & PC_FLAG_DMA_ERROR) {
 		pc->flags &= ~PC_FLAG_DMA_ERROR;
@@ -715,7 +696,7 @@ static ide_startstop_t idefloppy_issue_pc(ide_drive_t *drive,
 		/* immediate */
 		pkt_xfer_routine = &idefloppy_transfer_pc;
 	}
-	
+
 	if (floppy->flags & IDEFLOPPY_FLAG_DRQ_INTERRUPT) {
 		/* Issue the packet command */
 		ide_execute_command(drive, WIN_PACKETCMD,
@@ -738,7 +719,7 @@ static void idefloppy_rw_callback(ide_drive_t *drive)
 	return;
 }
 
-static void idefloppy_create_prevent_cmd(idefloppy_pc_t *pc, int prevent)
+static void idefloppy_create_prevent_cmd(struct ide_atapi_pc *pc, int prevent)
 {
 	debug_log("creating prevent removal command, prevent = %d\n", prevent);
 
@@ -747,39 +728,39 @@ static void idefloppy_create_prevent_cmd(idefloppy_pc_t *pc, int prevent)
 	pc->c[4] = prevent;
 }
 
-static void idefloppy_create_read_capacity_cmd(idefloppy_pc_t *pc)
+static void idefloppy_create_read_capacity_cmd(struct ide_atapi_pc *pc)
 {
 	idefloppy_init_pc(pc);
 	pc->c[0] = GPCMD_READ_FORMAT_CAPACITIES;
 	pc->c[7] = 255;
 	pc->c[8] = 255;
-	pc->request_transfer = 255;
+	pc->req_xfer = 255;
 }
 
-static void idefloppy_create_format_unit_cmd(idefloppy_pc_t *pc, int b, int l,
-					      int flags)
+static void idefloppy_create_format_unit_cmd(struct ide_atapi_pc *pc, int b,
+		int l, int flags)
 {
 	idefloppy_init_pc(pc);
 	pc->c[0] = GPCMD_FORMAT_UNIT;
 	pc->c[1] = 0x17;
 
-	memset(pc->buffer, 0, 12);
-	pc->buffer[1] = 0xA2;
+	memset(pc->buf, 0, 12);
+	pc->buf[1] = 0xA2;
 	/* Default format list header, u8 1: FOV/DCRT/IMM bits set */
 
 	if (flags & 1)				/* Verify bit on... */
-		pc->buffer[1] ^= 0x20;		/* ... turn off DCRT bit */
-	pc->buffer[3] = 8;
+		pc->buf[1] ^= 0x20;		/* ... turn off DCRT bit */
+	pc->buf[3] = 8;
 
-	put_unaligned(cpu_to_be32(b), (unsigned int *)(&pc->buffer[4]));
-	put_unaligned(cpu_to_be32(l), (unsigned int *)(&pc->buffer[8]));
-	pc->buffer_size = 12;
+	put_unaligned(cpu_to_be32(b), (unsigned int *)(&pc->buf[4]));
+	put_unaligned(cpu_to_be32(l), (unsigned int *)(&pc->buf[8]));
+	pc->buf_size = 12;
 	pc->flags |= PC_FLAG_WRITING;
 }
 
 /* A mode sense command is used to "sense" floppy parameters. */
-static void idefloppy_create_mode_sense_cmd(idefloppy_pc_t *pc, u8 page_code,
-		u8 type)
+static void idefloppy_create_mode_sense_cmd(struct ide_atapi_pc *pc,
+		u8 page_code, u8 type)
 {
 	u16 length = 8; /* sizeof(Mode Parameter Header) = 8 Bytes */
 
@@ -800,24 +781,24 @@ static void idefloppy_create_mode_sense_cmd(idefloppy_pc_t *pc, u8 page_code,
 				"in create_mode_sense_cmd\n");
 	}
 	put_unaligned(cpu_to_be16(length), (u16 *) &pc->c[7]);
-	pc->request_transfer = length;
+	pc->req_xfer = length;
 }
 
-static void idefloppy_create_start_stop_cmd(idefloppy_pc_t *pc, int start)
+static void idefloppy_create_start_stop_cmd(struct ide_atapi_pc *pc, int start)
 {
 	idefloppy_init_pc(pc);
 	pc->c[0] = GPCMD_START_STOP_UNIT;
 	pc->c[4] = start;
 }
 
-static void idefloppy_create_test_unit_ready_cmd(idefloppy_pc_t *pc)
+static void idefloppy_create_test_unit_ready_cmd(struct ide_atapi_pc *pc)
 {
 	idefloppy_init_pc(pc);
 	pc->c[0] = GPCMD_TEST_UNIT_READY;
 }
 
 static void idefloppy_create_rw_cmd(idefloppy_floppy_t *floppy,
-				    idefloppy_pc_t *pc, struct request *rq,
+				    struct ide_atapi_pc *pc, struct request *rq,
 				    unsigned long sector)
 {
 	int block = sector / floppy->bs_factor;
@@ -832,41 +813,41 @@ static void idefloppy_create_rw_cmd(idefloppy_floppy_t *floppy,
 	put_unaligned(cpu_to_be16(blocks), (unsigned short *)&pc->c[7]);
 	put_unaligned(cpu_to_be32(block), (unsigned int *) &pc->c[2]);
 
-	pc->callback = &idefloppy_rw_callback;
+	pc->idefloppy_callback = &idefloppy_rw_callback;
 	pc->rq = rq;
 	pc->b_count = cmd == READ ? 0 : rq->bio->bi_size;
 	if (rq->cmd_flags & REQ_RW)
 		pc->flags |= PC_FLAG_WRITING;
-	pc->buffer = NULL;
-	pc->request_transfer = pc->buffer_size = blocks * floppy->block_size;
+	pc->buf = NULL;
+	pc->req_xfer = pc->buf_size = blocks * floppy->block_size;
 	pc->flags |= PC_FLAG_DMA_RECOMMENDED;
 }
 
 static void idefloppy_blockpc_cmd(idefloppy_floppy_t *floppy,
-		idefloppy_pc_t *pc, struct request *rq)
+		struct ide_atapi_pc *pc, struct request *rq)
 {
 	idefloppy_init_pc(pc);
-	pc->callback = &idefloppy_rw_callback;
+	pc->idefloppy_callback = &idefloppy_rw_callback;
 	memcpy(pc->c, rq->cmd, sizeof(pc->c));
 	pc->rq = rq;
 	pc->b_count = rq->data_len;
 	if (rq->data_len && rq_data_dir(rq) == WRITE)
 		pc->flags |= PC_FLAG_WRITING;
-	pc->buffer = rq->data;
+	pc->buf = rq->data;
 	if (rq->bio)
 		pc->flags |= PC_FLAG_DMA_RECOMMENDED;
 	/*
 	 * possibly problematic, doesn't look like ide-floppy correctly
 	 * handled scattered requests if dma fails...
 	 */
-	pc->request_transfer = pc->buffer_size = rq->data_len;
+	pc->req_xfer = pc->buf_size = rq->data_len;
 }
 
 static ide_startstop_t idefloppy_do_request(ide_drive_t *drive,
 		struct request *rq, sector_t block_s)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
-	idefloppy_pc_t *pc;
+	struct ide_atapi_pc *pc;
 	unsigned long block = (unsigned long)block_s;
 
 	debug_log("dev: %s, cmd_type: %x, errors: %d\n",
@@ -896,7 +877,7 @@ static ide_startstop_t idefloppy_do_request(ide_drive_t *drive,
 		pc = idefloppy_next_pc_storage(drive);
 		idefloppy_create_rw_cmd(floppy, pc, rq, block);
 	} else if (blk_special_request(rq)) {
-		pc = (idefloppy_pc_t *) rq->buffer;
+		pc = (struct ide_atapi_pc *) rq->buffer;
 	} else if (blk_pc_request(rq)) {
 		pc = idefloppy_next_pc_storage(drive);
 		idefloppy_blockpc_cmd(floppy, pc, rq);
@@ -915,7 +896,7 @@ static ide_startstop_t idefloppy_do_request(ide_drive_t *drive,
  * Add a special packet command request to the tail of the request queue,
  * and wait for it to be serviced.
  */
-static int idefloppy_queue_pc_tail(ide_drive_t *drive, idefloppy_pc_t *pc)
+static int idefloppy_queue_pc_tail(ide_drive_t *drive, struct ide_atapi_pc *pc)
 {
 	struct ide_floppy_obj *floppy = drive->driver_data;
 	struct request rq;
@@ -935,7 +916,7 @@ static int idefloppy_queue_pc_tail(ide_drive_t *drive, idefloppy_pc_t *pc)
 static int ide_floppy_get_flexible_disk_page(ide_drive_t *drive)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
-	idefloppy_pc_t pc;
+	struct ide_atapi_pc pc;
 	u8 *page;
 	int capacity, lba_capacity;
 	u16 transfer_rate, sector_size, cyls, rpm;
@@ -949,16 +930,16 @@ static int ide_floppy_get_flexible_disk_page(ide_drive_t *drive)
 				" parameters\n");
 		return 1;
 	}
-	floppy->wp = !!(pc.buffer[3] & 0x80);
+	floppy->wp = !!(pc.buf[3] & 0x80);
 	set_disk_ro(floppy->disk, floppy->wp);
-	page = &pc.buffer[8];
+	page = &pc.buf[8];
 
-	transfer_rate = be16_to_cpu(*(u16 *)&pc.buffer[8 + 2]);
-	sector_size   = be16_to_cpu(*(u16 *)&pc.buffer[8 + 6]);
-	cyls          = be16_to_cpu(*(u16 *)&pc.buffer[8 + 8]);
-	rpm           = be16_to_cpu(*(u16 *)&pc.buffer[8 + 28]);
-	heads         = pc.buffer[8 + 4];
-	sectors       = pc.buffer[8 + 5];
+	transfer_rate = be16_to_cpu(*(u16 *)&pc.buf[8 + 2]);
+	sector_size   = be16_to_cpu(*(u16 *)&pc.buf[8 + 6]);
+	cyls          = be16_to_cpu(*(u16 *)&pc.buf[8 + 8]);
+	rpm           = be16_to_cpu(*(u16 *)&pc.buf[8 + 28]);
+	heads         = pc.buf[8 + 4];
+	sectors       = pc.buf[8 + 5];
 
 	capacity = cyls * heads * sectors * sector_size;
 
@@ -987,7 +968,7 @@ static int ide_floppy_get_flexible_disk_page(ide_drive_t *drive)
 static int idefloppy_get_sfrp_bit(ide_drive_t *drive)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
-	idefloppy_pc_t pc;
+	struct ide_atapi_pc pc;
 
 	floppy->srfp = 0;
 	idefloppy_create_mode_sense_cmd(&pc, IDEFLOPPY_CAPABILITIES_PAGE,
@@ -997,7 +978,7 @@ static int idefloppy_get_sfrp_bit(ide_drive_t *drive)
 	if (idefloppy_queue_pc_tail(drive, &pc))
 		return 1;
 
-	floppy->srfp = pc.buffer[8 + 2] & 0x40;
+	floppy->srfp = pc.buf[8 + 2] & 0x40;
 	return (0);
 }
 
@@ -1008,7 +989,7 @@ static int idefloppy_get_sfrp_bit(ide_drive_t *drive)
 static int ide_floppy_get_capacity(ide_drive_t *drive)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
-	idefloppy_pc_t pc;
+	struct ide_atapi_pc pc;
 	u8 *cap_desc;
 	u8 header_len, desc_cnt;
 	int i, rc = 1, blocks, length;
@@ -1024,15 +1005,15 @@ static int ide_floppy_get_capacity(ide_drive_t *drive)
 		printk(KERN_ERR "ide-floppy: Can't get floppy parameters\n");
 		return 1;
 	}
-	header_len = pc.buffer[3];
-	cap_desc = &pc.buffer[4];
+	header_len = pc.buf[3];
+	cap_desc = &pc.buf[4];
 	desc_cnt = header_len / 8; /* capacity descriptor of 8 bytes */
 
 	for (i = 0; i < desc_cnt; i++) {
 		unsigned int desc_start = 4 + i*8;
 
-		blocks = be32_to_cpu(*(u32 *)&pc.buffer[desc_start]);
-		length = be16_to_cpu(*(u16 *)&pc.buffer[desc_start + 6]);
+		blocks = be32_to_cpu(*(u32 *)&pc.buf[desc_start]);
+		length = be16_to_cpu(*(u16 *)&pc.buf[desc_start + 6]);
 
 		debug_log("Descriptor %d: %dkB, %d blocks, %d sector size\n",
 				i, blocks * length / 1024, blocks, length);
@@ -1043,7 +1024,7 @@ static int ide_floppy_get_capacity(ide_drive_t *drive)
 		 * the code below is valid only for the 1st descriptor, ie i=0
 		 */
 
-		switch (pc.buffer[desc_start + 4] & 0x03) {
+		switch (pc.buf[desc_start + 4] & 0x03) {
 		/* Clik! drive returns this instead of CAPACITY_CURRENT */
 		case CAPACITY_UNFORMATTED:
 			if (!(floppy->flags & IDEFLOPPY_FLAG_CLIK_DRIVE))
@@ -1088,7 +1069,7 @@ static int ide_floppy_get_capacity(ide_drive_t *drive)
 			break;
 		}
 		debug_log("Descriptor 0 Code: %d\n",
-			  pc.buffer[desc_start + 4] & 0x03);
+			  pc.buf[desc_start + 4] & 0x03);
 	}
 
 	/* Clik! disk does not support get_flexible_disk_page */
@@ -1120,7 +1101,7 @@ static int ide_floppy_get_capacity(ide_drive_t *drive)
 
 static int ide_floppy_get_format_capacities(ide_drive_t *drive, int __user *arg)
 {
-	idefloppy_pc_t pc;
+	struct ide_atapi_pc pc;
 	u8 header_len, desc_cnt;
 	int i, blocks, length, u_array_size, u_index;
 	int __user *argp;
@@ -1136,7 +1117,7 @@ static int ide_floppy_get_format_capacities(ide_drive_t *drive, int __user *arg)
 		printk(KERN_ERR "ide-floppy: Can't get floppy parameters\n");
 		return (-EIO);
 	}
-	header_len = pc.buffer[3];
+	header_len = pc.buf[3];
 	desc_cnt = header_len / 8; /* capacity descriptor of 8 bytes */
 
 	u_index = 0;
@@ -1153,8 +1134,8 @@ static int ide_floppy_get_format_capacities(ide_drive_t *drive, int __user *arg)
 		if (u_index >= u_array_size)
 			break;	/* User-supplied buffer too small */
 
-		blocks = be32_to_cpu(*(u32 *)&pc.buffer[desc_start]);
-		length = be16_to_cpu(*(u16 *)&pc.buffer[desc_start + 6]);
+		blocks = be32_to_cpu(*(u32 *)&pc.buf[desc_start]);
+		length = be16_to_cpu(*(u16 *)&pc.buf[desc_start + 6]);
 
 		if (put_user(blocks, argp))
 			return(-EFAULT);
@@ -1185,7 +1166,7 @@ static int ide_floppy_get_format_capacities(ide_drive_t *drive, int __user *arg)
 static int idefloppy_get_format_progress(ide_drive_t *drive, int __user *arg)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
-	idefloppy_pc_t pc;
+	struct ide_atapi_pc pc;
 	int progress_indication = 0x10000;
 
 	if (floppy->srfp) {
@@ -1391,7 +1372,7 @@ static int idefloppy_open(struct inode *inode, struct file *filp)
 	struct gendisk *disk = inode->i_bdev->bd_disk;
 	struct ide_floppy_obj *floppy;
 	ide_drive_t *drive;
-	idefloppy_pc_t pc;
+	struct ide_atapi_pc pc;
 	int ret = 0;
 
 	debug_log("Reached %s\n", __func__);
@@ -1454,7 +1435,7 @@ static int idefloppy_release(struct inode *inode, struct file *filp)
 	struct gendisk *disk = inode->i_bdev->bd_disk;
 	struct ide_floppy_obj *floppy = ide_floppy_g(disk);
 	ide_drive_t *drive = floppy->drive;
-	idefloppy_pc_t pc;
+	struct ide_atapi_pc pc;
 
 	debug_log("Reached %s\n", __func__);
 
@@ -1486,8 +1467,8 @@ static int idefloppy_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 	return 0;
 }
 
-static int ide_floppy_lockdoor(idefloppy_floppy_t *floppy, idefloppy_pc_t *pc,
-			       unsigned long arg, unsigned int cmd)
+static int ide_floppy_lockdoor(idefloppy_floppy_t *floppy,
+		struct ide_atapi_pc *pc, unsigned long arg, unsigned int cmd)
 {
 	if (floppy->openers > 1)
 		return -EBUSY;
@@ -1516,7 +1497,7 @@ static int ide_floppy_format_unit(idefloppy_floppy_t *floppy,
 				  int __user *arg)
 {
 	int blocks, length, flags, err = 0;
-	idefloppy_pc_t pc;
+	struct ide_atapi_pc pc;
 
 	if (floppy->openers > 1) {
 		/* Don't format if someone is using the disk */
@@ -1567,7 +1548,7 @@ static int idefloppy_ioctl(struct inode *inode, struct file *file,
 	struct block_device *bdev = inode->i_bdev;
 	struct ide_floppy_obj *floppy = ide_floppy_g(bdev->bd_disk);
 	ide_drive_t *drive = floppy->drive;
-	idefloppy_pc_t pc;
+	struct ide_atapi_pc pc;
 	void __user *argp = (void __user *)arg;
 	int err;
 
-- 
1.5.3.7

