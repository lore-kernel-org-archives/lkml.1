Return-Path: <linux-kernel-owner+w=401wt.eu-S1758895AbYFLGrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758895AbYFLGrk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 02:47:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757594AbYFLGrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 02:47:20 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:21650 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756905AbYFLGrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 02:47:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=T2smZHro4V8ulnuZEs1TBfVzpPi6K2dpeiZx5HiN71NTzZSabU5HJLQMBG2Wb8nkas
         VezkEN5LfEX943RH8ZfmBZaQBVkKYv1G524InOvitI0eLVvanh2mvcgYe1rV9KrsjbGG
         KjsyJuSgQ6ahBE+Mvt016s36667rXcTWIcoAs=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 13/18] ide-floppy: replace pc->c with rq->cmd
Date: Thu, 12 Jun 2008 08:41:05 +0200
Message-Id: <1213252870-20474-14-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1213252870-20474-1-git-send-email-petkovbb@gmail.com>
References: <1213252870-20474-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the first one in the series attempting to phase out ide_atapi_pc and use
block request structs. Also, the pc request type is now REQ_TYPE_BLOCK_PC. As a result,
idefloppy_blockpc_cmd becomes unused and can go.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

---
 drivers/ide/ide-atapi.c  |   22 ++++-
 drivers/ide/ide-floppy.c |  207 +++++++++++++++++++++++-----------------------
 2 files changed, 120 insertions(+), 109 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index 2802031..3a6ae79 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -26,6 +26,12 @@ ide_startstop_t ide_pc_intr(ide_drive_t *drive, struct ide_atapi_pc *pc,
 	unsigned int temp;
 	u16 bcount;
 	u8 stat, ireason, scsi = drive->scsi;
+	unsigned char *cmd;
+
+	if (drive->media == ide_floppy)
+		cmd = pc->rq->cmd;
+	else
+		cmd = pc->c;
 
 	debug_log("Enter %s - interrupt handler\n", __func__);
 
@@ -63,7 +69,7 @@ ide_startstop_t ide_pc_intr(ide_drive_t *drive, struct ide_atapi_pc *pc,
 		local_irq_enable_in_hardirq();
 
 		if (drive->media == ide_tape && !scsi &&
-		    (stat & ERR_STAT) && pc->c[0] == REQUEST_SENSE)
+		    (stat & ERR_STAT) && cmd[0] == REQUEST_SENSE)
 			stat &= ~ERR_STAT;
 		if ((stat & ERR_STAT) || (pc->flags & PC_FLAG_DMA_ERROR)) {
 			/* Error detected */
@@ -75,13 +81,13 @@ ide_startstop_t ide_pc_intr(ide_drive_t *drive, struct ide_atapi_pc *pc,
 					goto cmd_finished;
 			}
 
-			if (pc->c[0] == REQUEST_SENSE) {
+			if (cmd[0] == REQUEST_SENSE) {
 				printk(KERN_ERR "%s: I/O error in request sense"
 						" command\n", drive->name);
 				return ide_do_reset(drive);
 			}
 
-			debug_log("[cmd %x]: check condition\n", pc->c[0]);
+			debug_log("[cmd %x]: check condition\n", cmd[0]);
 
 			/* Retry operation */
 			retry_pc(drive);
@@ -175,7 +181,7 @@ cmd_finished:
 	pc->cur_pos += bcount;
 
 	debug_log("[cmd %x] transferred %d bytes on that intr.\n",
-		  pc->c[0], bcount);
+		  cmd[0], bcount);
 
 	/* And set the interrupt handler again */
 	ide_set_handler(drive, handler, timeout, expiry);
@@ -212,6 +218,12 @@ ide_startstop_t ide_transfer_pc(ide_drive_t *drive, struct ide_atapi_pc *pc,
 	ide_hwif_t *hwif = drive->hwif;
 	ide_startstop_t startstop;
 	u8 ireason;
+	unsigned char *cmd;
+
+	if (drive->media == ide_floppy)
+		cmd = pc->rq->cmd;
+	else
+		cmd = pc->c;
 
 	if (ide_wait_stat(&startstop, drive, DRQ_STAT, BUSY_STAT, WAIT_READY)) {
 		printk(KERN_ERR "%s: Strange, packet command initiated yet "
@@ -240,7 +252,7 @@ ide_startstop_t ide_transfer_pc(ide_drive_t *drive, struct ide_atapi_pc *pc,
 
 	/* Send the actual packet */
 	if ((pc->flags & PC_FLAG_ZIP_DRIVE) == 0)
-		hwif->output_data(drive, NULL, pc->c, 12);
+		hwif->output_data(drive, NULL, cmd, 12);
 
 	return ide_started;
 }
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index b368943..ffebf83 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -217,7 +217,7 @@ static int idefloppy_end_request(ide_drive_t *drive, int uptodate, int nsecs)
 	/* Why does this happen? */
 	if (!rq)
 		return 0;
-	if (!blk_special_request(rq)) {
+	if (!blk_pc_request(rq)) {
 		/* our real local end request function */
 		ide_end_request(drive, uptodate, nsecs);
 		return 0;
@@ -282,13 +282,14 @@ static void idefloppy_update_buffers(ide_drive_t *drive,
  * pass through the driver.
  */
 static void idefloppy_queue_pc_head(ide_drive_t *drive, struct ide_atapi_pc *pc,
-		struct request *rq)
+		struct request *rq, unsigned char *cmd)
 {
 	struct ide_floppy_obj *floppy = drive->driver_data;
 
 	blk_rq_init(NULL, rq);
 	rq->buffer = (char *) pc;
-	rq->cmd_type = REQ_TYPE_SPECIAL;
+	rq->cmd_type = REQ_TYPE_BLOCK_PC;
+	memcpy(rq->cmd, cmd, 12);
 	rq->cmd_flags |= REQ_PREEMPT;
 	rq->rq_disk = floppy->disk;
 	ide_do_drive_cmd(drive, rq);
@@ -323,10 +324,10 @@ static void ide_floppy_callback(ide_drive_t *drive)
 	if (floppy->failed_pc == pc)
 		floppy->failed_pc = NULL;
 
-	if (pc->c[0] == GPCMD_READ_10 || pc->c[0] == GPCMD_WRITE_10 ||
-	    (pc->rq && blk_pc_request(pc->rq)))
+	if (pc->rq->cmd[0] == GPCMD_READ_10 || pc->rq->cmd[0] == GPCMD_WRITE_10
+			|| (pc->rq && blk_pc_request(pc->rq)))
 		uptodate = 1; /* FIXME */
-	else if (pc->c[0] == GPCMD_REQUEST_SENSE) {
+	else if (pc->rq->cmd[0] == GPCMD_REQUEST_SENSE) {
 		u8 *buf = floppy->pc->buf;
 
 		if (!pc->error) {
@@ -349,9 +350,11 @@ static void ide_floppy_callback(ide_drive_t *drive)
 	idefloppy_end_request(drive, uptodate, 0);
 }
 
-static void idefloppy_init_pc(struct ide_atapi_pc *pc)
+static void idefloppy_init_pc(struct ide_atapi_pc *pc, unsigned char *cmd)
 {
-	memset(pc->c, 0, 12);
+	if (cmd)
+		memset(cmd, 0, 12);
+
 	pc->retries = 0;
 	pc->flags = 0;
 	pc->req_xfer = 0;
@@ -360,11 +363,12 @@ static void idefloppy_init_pc(struct ide_atapi_pc *pc)
 	pc->callback = ide_floppy_callback;
 }
 
-static void idefloppy_create_request_sense_cmd(struct ide_atapi_pc *pc)
+static void idefloppy_create_request_sense_cmd(struct ide_atapi_pc *pc,
+					       unsigned char *cmd)
 {
-	idefloppy_init_pc(pc);
-	pc->c[0] = GPCMD_REQUEST_SENSE;
-	pc->c[4] = 255;
+	idefloppy_init_pc(pc, cmd);
+	cmd[0] = GPCMD_REQUEST_SENSE;
+	cmd[4] = 18;
 	pc->req_xfer = 18;
 }
 
@@ -376,12 +380,13 @@ static void idefloppy_retry_pc(ide_drive_t *drive)
 {
 	struct ide_atapi_pc *pc;
 	struct request *rq;
+	unsigned char cmd[12];
 
 	(void)ide_read_error(drive);
 	pc = idefloppy_next_pc_storage(drive);
 	rq = idefloppy_next_rq_storage(drive);
-	idefloppy_create_request_sense_cmd(pc);
-	idefloppy_queue_pc_head(drive, pc, rq);
+	idefloppy_create_request_sense_cmd(pc, cmd);
+	idefloppy_queue_pc_head(drive, pc, rq, cmd);
 }
 
 /* The usual interrupt handler called during a packet command. */
@@ -405,7 +410,7 @@ static int idefloppy_transfer_pc(ide_drive_t *drive)
 	idefloppy_floppy_t *floppy = drive->driver_data;
 
 	/* Send the actual packet */
-	drive->hwif->output_data(drive, NULL, floppy->pc->c, 12);
+	drive->hwif->output_data(drive, NULL, floppy->pc->rq->cmd, 12);
 
 	/* Timeout for the packet command */
 	return IDEFLOPPY_WAIT_CMD;
@@ -454,7 +459,7 @@ static void ide_floppy_report_error(idefloppy_floppy_t *floppy,
 
 	printk(KERN_ERR "ide-floppy: %s: I/O error, pc = %2x, key = %2x, "
 			"asc = %2x, ascq = %2x\n",
-			floppy->drive->name, pc->c[0], floppy->sense_key,
+			floppy->drive->name, pc->rq->cmd[0], floppy->sense_key,
 			floppy->asc, floppy->ascq);
 
 }
@@ -465,7 +470,7 @@ static ide_startstop_t idefloppy_issue_pc(ide_drive_t *drive,
 	idefloppy_floppy_t *floppy = drive->driver_data;
 
 	if (floppy->failed_pc == NULL &&
-	    pc->c[0] != GPCMD_REQUEST_SENSE)
+	    pc->rq->cmd[0] != GPCMD_REQUEST_SENSE)
 		floppy->failed_pc = pc;
 	/* Set the current packet command */
 	floppy->pc = pc;
@@ -489,30 +494,31 @@ static ide_startstop_t idefloppy_issue_pc(ide_drive_t *drive,
 			    IDEFLOPPY_WAIT_CMD, NULL);
 }
 
-static void idefloppy_create_prevent_cmd(struct ide_atapi_pc *pc, int prevent)
+static void idefloppy_create_prevent_cmd(struct ide_atapi_pc *pc, int prevent,
+					 unsigned char *cmd)
 {
-	debug_log("creating prevent removal command, prevent = %d\n", prevent);
-
-	idefloppy_init_pc(pc);
-	pc->c[0] = GPCMD_PREVENT_ALLOW_MEDIUM_REMOVAL;
-	pc->c[4] = prevent;
+	idefloppy_init_pc(pc, cmd);
+	cmd[0] = GPCMD_PREVENT_ALLOW_MEDIUM_REMOVAL;
+	cmd[4] = prevent;
 }
 
-static void idefloppy_create_read_capacity_cmd(struct ide_atapi_pc *pc)
+static void idefloppy_create_read_capacity_cmd(struct ide_atapi_pc *pc,
+					       unsigned char *cmd)
 {
-	idefloppy_init_pc(pc);
-	pc->c[0] = GPCMD_READ_FORMAT_CAPACITIES;
-	pc->c[7] = 255;
-	pc->c[8] = 255;
+	idefloppy_init_pc(pc, cmd);
+	cmd[0] = GPCMD_READ_FORMAT_CAPACITIES;
+	cmd[7] = 255;
+	cmd[8] = 255;
 	pc->req_xfer = 255;
 }
 
 static void idefloppy_create_format_unit_cmd(struct ide_atapi_pc *pc, int b,
-		int l, int flags)
+					     int l, int flags,
+					     unsigned char *cmd)
 {
-	idefloppy_init_pc(pc);
-	pc->c[0] = GPCMD_FORMAT_UNIT;
-	pc->c[1] = 0x17;
+	idefloppy_init_pc(pc, cmd);
+	cmd[0] = GPCMD_FORMAT_UNIT;
+	cmd[1] = 0x17;
 
 	memset(pc->buf, 0, 12);
 	pc->buf[1] = 0xA2;
@@ -530,14 +536,15 @@ static void idefloppy_create_format_unit_cmd(struct ide_atapi_pc *pc, int b,
 
 /* A mode sense command is used to "sense" floppy parameters. */
 static void idefloppy_create_mode_sense_cmd(struct ide_atapi_pc *pc,
-		u8 page_code, u8 type)
+					    u8 page_code, u8 type,
+					    unsigned char *cmd)
 {
 	u16 length = 8; /* sizeof(Mode Parameter Header) = 8 Bytes */
 
-	idefloppy_init_pc(pc);
-	pc->c[0] = GPCMD_MODE_SENSE_10;
-	pc->c[1] = 0;
-	pc->c[2] = page_code + (type << 6);
+	idefloppy_init_pc(pc, cmd);
+	cmd[0] = GPCMD_MODE_SENSE_10;
+	cmd[1] = 0;
+	cmd[2] = page_code + (type << 6);
 
 	switch (page_code) {
 	case IDEFLOPPY_CAPABILITIES_PAGE:
@@ -550,21 +557,23 @@ static void idefloppy_create_mode_sense_cmd(struct ide_atapi_pc *pc,
 		printk(KERN_ERR "ide-floppy: unsupported page code "
 				"in create_mode_sense_cmd\n");
 	}
-	put_unaligned(cpu_to_be16(length), (u16 *) &pc->c[7]);
+	put_unaligned(cpu_to_be16(length), (u16 *) &cmd[7]);
 	pc->req_xfer = length;
 }
 
-static void idefloppy_create_start_stop_cmd(struct ide_atapi_pc *pc, int start)
+static void idefloppy_create_start_stop_cmd(struct ide_atapi_pc *pc, int start,
+					    unsigned char *cmd)
 {
-	idefloppy_init_pc(pc);
-	pc->c[0] = GPCMD_START_STOP_UNIT;
-	pc->c[4] = start;
+	idefloppy_init_pc(pc, cmd);
+	cmd[0] = GPCMD_START_STOP_UNIT;
+	cmd[4] = start;
 }
 
-static void idefloppy_create_test_unit_ready_cmd(struct ide_atapi_pc *pc)
+static void idefloppy_create_test_unit_ready_cmd(struct ide_atapi_pc *pc,
+						 unsigned char *cmd)
 {
-	idefloppy_init_pc(pc);
-	pc->c[0] = GPCMD_TEST_UNIT_READY;
+	idefloppy_init_pc(pc, cmd);
+	cmd[0] = GPCMD_TEST_UNIT_READY;
 }
 
 static void idefloppy_create_rw_cmd(idefloppy_floppy_t *floppy,
@@ -573,18 +582,18 @@ static void idefloppy_create_rw_cmd(idefloppy_floppy_t *floppy,
 {
 	int block = sector / floppy->bs_factor;
 	int blocks = rq->nr_sectors / floppy->bs_factor;
-	int cmd = rq_data_dir(rq);
+	int rw_dir = rq_data_dir(rq);
 
 	debug_log("create_rw10_cmd: block == %d, blocks == %d\n",
-		block, blocks);
+		  block, blocks);
 
-	idefloppy_init_pc(pc);
-	pc->c[0] = cmd == READ ? GPCMD_READ_10 : GPCMD_WRITE_10;
-	put_unaligned(cpu_to_be16(blocks), (unsigned short *)&pc->c[7]);
-	put_unaligned(cpu_to_be32(block), (unsigned int *) &pc->c[2]);
+	idefloppy_init_pc(pc, NULL);
+	rq->cmd[0] = rw_dir == READ ? GPCMD_READ_10 : GPCMD_WRITE_10;
+	put_unaligned(cpu_to_be16(blocks), (unsigned short *)&rq->cmd[7]);
+	put_unaligned(cpu_to_be32(block), (unsigned int *) &rq->cmd[2]);
 
 	pc->rq = rq;
-	pc->b_count = cmd == READ ? 0 : rq->bio->bi_size;
+	pc->b_count = rw_dir == READ ? 0 : rq->bio->bi_size;
 	if (rq->cmd_flags & REQ_RW)
 		pc->flags |= PC_FLAG_WRITING;
 	pc->buf = NULL;
@@ -592,25 +601,6 @@ static void idefloppy_create_rw_cmd(idefloppy_floppy_t *floppy,
 	pc->flags |= PC_FLAG_DMA_OK;
 }
 
-static void idefloppy_blockpc_cmd(idefloppy_floppy_t *floppy,
-		struct ide_atapi_pc *pc, struct request *rq)
-{
-	idefloppy_init_pc(pc);
-	memcpy(pc->c, rq->cmd, sizeof(pc->c));
-	pc->rq = rq;
-	pc->b_count = rq->data_len;
-	if (rq->data_len && rq_data_dir(rq) == WRITE)
-		pc->flags |= PC_FLAG_WRITING;
-	pc->buf = rq->data;
-	if (rq->bio)
-		pc->flags |= PC_FLAG_DMA_OK;
-	/*
-	 * possibly problematic, doesn't look like ide-floppy correctly
-	 * handled scattered requests if dma fails...
-	 */
-	pc->req_xfer = pc->buf_size = rq->data_len;
-}
-
 static ide_startstop_t idefloppy_do_request(ide_drive_t *drive,
 		struct request *rq, sector_t block_s)
 {
@@ -618,9 +608,9 @@ static ide_startstop_t idefloppy_do_request(ide_drive_t *drive,
 	struct ide_atapi_pc *pc;
 	unsigned long block = (unsigned long)block_s;
 
-	debug_log("dev: %s, cmd_type: %x, errors: %d\n",
+	debug_log("dev: %s, cmd: %x, cmd_type: %x, errors: %d\n",
 			rq->rq_disk ? rq->rq_disk->disk_name : "?",
-			rq->cmd_type, rq->errors);
+			rq->cmd[0], rq->cmd_type, rq->errors);
 	debug_log("sector: %ld, nr_sectors: %ld, "
 			"current_nr_sectors: %d\n", (long)rq->sector,
 			rq->nr_sectors, rq->current_nr_sectors);
@@ -644,12 +634,9 @@ static ide_startstop_t idefloppy_do_request(ide_drive_t *drive,
 		}
 		pc = idefloppy_next_pc_storage(drive);
 		idefloppy_create_rw_cmd(floppy, pc, rq, block);
-	} else if (blk_special_request(rq)) {
+	} else if (blk_pc_request(rq))
 		pc = (struct ide_atapi_pc *) rq->buffer;
-	} else if (blk_pc_request(rq)) {
-		pc = idefloppy_next_pc_storage(drive);
-		idefloppy_blockpc_cmd(floppy, pc, rq);
-	} else {
+	else {
 		blk_dump_rq_flags(rq,
 			"ide-floppy: unsupported command in queue");
 		idefloppy_end_request(drive, 0, 0);
@@ -671,7 +658,8 @@ static ide_startstop_t idefloppy_do_request(ide_drive_t *drive,
  * Add a special packet command request to the tail of the request queue,
  * and wait for it to be serviced.
  */
-static int idefloppy_queue_pc_tail(ide_drive_t *drive, struct ide_atapi_pc *pc)
+static int idefloppy_queue_pc_tail(ide_drive_t *drive, struct ide_atapi_pc *pc,
+				   unsigned char *cmd)
 {
 	struct ide_floppy_obj *floppy = drive->driver_data;
 	struct request *rq;
@@ -679,7 +667,8 @@ static int idefloppy_queue_pc_tail(ide_drive_t *drive, struct ide_atapi_pc *pc)
 
 	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
 	rq->buffer = (char *) pc;
-	rq->cmd_type = REQ_TYPE_SPECIAL;
+	memcpy(rq->cmd, cmd, 12);
+	rq->cmd_type = REQ_TYPE_BLOCK_PC;
 	error = blk_execute_rq(drive->queue, floppy->disk, rq, 0);
 	blk_put_request(rq);
 
@@ -694,15 +683,16 @@ static int ide_floppy_get_flexible_disk_page(ide_drive_t *drive)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
 	struct ide_atapi_pc pc;
+	unsigned char cmd[12];
 	u8 *page;
 	int capacity, lba_capacity;
 	u16 transfer_rate, sector_size, cyls, rpm;
 	u8 heads, sectors;
 
 	idefloppy_create_mode_sense_cmd(&pc, IDEFLOPPY_FLEXIBLE_DISK_PAGE,
-					MODE_SENSE_CURRENT);
+					MODE_SENSE_CURRENT, cmd);
 
-	if (idefloppy_queue_pc_tail(drive, &pc)) {
+	if (idefloppy_queue_pc_tail(drive, &pc, cmd)) {
 		printk(KERN_ERR "ide-floppy: Can't get flexible disk page"
 				" parameters\n");
 		return 1;
@@ -746,13 +736,14 @@ static int idefloppy_get_sfrp_bit(ide_drive_t *drive)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
 	struct ide_atapi_pc pc;
+	unsigned char cmd[12];
 
 	floppy->srfp = 0;
 	idefloppy_create_mode_sense_cmd(&pc, IDEFLOPPY_CAPABILITIES_PAGE,
-						 MODE_SENSE_CURRENT);
+						 MODE_SENSE_CURRENT, cmd);
 
 	pc.flags |= PC_FLAG_SUPPRESS_ERROR;
-	if (idefloppy_queue_pc_tail(drive, &pc))
+	if (idefloppy_queue_pc_tail(drive, &pc, cmd))
 		return 1;
 
 	floppy->srfp = pc.buf[8 + 2] & 0x40;
@@ -767,6 +758,7 @@ static int ide_floppy_get_capacity(ide_drive_t *drive)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
 	struct ide_atapi_pc pc;
+	unsigned char cmd[12];
 	u8 *cap_desc;
 	u8 header_len, desc_cnt;
 	int i, rc = 1, blocks, length;
@@ -777,8 +769,8 @@ static int ide_floppy_get_capacity(ide_drive_t *drive)
 	floppy->bs_factor = 1;
 	set_capacity(floppy->disk, 0);
 
-	idefloppy_create_read_capacity_cmd(&pc);
-	if (idefloppy_queue_pc_tail(drive, &pc)) {
+	idefloppy_create_read_capacity_cmd(&pc, cmd);
+	if (idefloppy_queue_pc_tail(drive, &pc, cmd)) {
 		printk(KERN_ERR "ide-floppy: Can't get floppy parameters\n");
 		return 1;
 	}
@@ -882,6 +874,7 @@ static int ide_floppy_get_format_capacities(ide_drive_t *drive, int __user *arg)
 	u8 header_len, desc_cnt;
 	int i, blocks, length, u_array_size, u_index;
 	int __user *argp;
+	unsigned char cmd[12];
 
 	if (get_user(u_array_size, arg))
 		return (-EFAULT);
@@ -889,8 +882,8 @@ static int ide_floppy_get_format_capacities(ide_drive_t *drive, int __user *arg)
 	if (u_array_size <= 0)
 		return (-EINVAL);
 
-	idefloppy_create_read_capacity_cmd(&pc);
-	if (idefloppy_queue_pc_tail(drive, &pc)) {
+	idefloppy_create_read_capacity_cmd(&pc, cmd);
+	if (idefloppy_queue_pc_tail(drive, &pc, cmd)) {
 		printk(KERN_ERR "ide-floppy: Can't get floppy parameters\n");
 		return (-EIO);
 	}
@@ -944,11 +937,12 @@ static int idefloppy_get_format_progress(ide_drive_t *drive, int __user *arg)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
 	struct ide_atapi_pc pc;
+	unsigned char cmd[12];
 	int progress_indication = 0x10000;
 
 	if (floppy->srfp) {
-		idefloppy_create_request_sense_cmd(&pc);
-		if (idefloppy_queue_pc_tail(drive, &pc))
+		idefloppy_create_request_sense_cmd(&pc, cmd);
+		if (idefloppy_queue_pc_tail(drive, &pc, cmd))
 			return (-EIO);
 
 		if (floppy->sense_key == 2 &&
@@ -1150,6 +1144,7 @@ static int idefloppy_open(struct inode *inode, struct file *filp)
 	struct ide_floppy_obj *floppy;
 	ide_drive_t *drive;
 	struct ide_atapi_pc pc;
+	unsigned char cmd[12];
 	int ret = 0;
 
 	debug_log("Reached %s\n", __func__);
@@ -1166,10 +1161,10 @@ static int idefloppy_open(struct inode *inode, struct file *filp)
 		floppy->flags &= ~IDEFLOPPY_FLAG_FORMAT_IN_PROGRESS;
 		/* Just in case */
 
-		idefloppy_create_test_unit_ready_cmd(&pc);
-		if (idefloppy_queue_pc_tail(drive, &pc)) {
-			idefloppy_create_start_stop_cmd(&pc, 1);
-			(void) idefloppy_queue_pc_tail(drive, &pc);
+		idefloppy_create_test_unit_ready_cmd(&pc, cmd);
+		if (idefloppy_queue_pc_tail(drive, &pc, cmd)) {
+			idefloppy_create_start_stop_cmd(&pc, 1, cmd);
+			(void) idefloppy_queue_pc_tail(drive, &pc, cmd);
 		}
 
 		if (ide_floppy_get_capacity(drive)
@@ -1191,8 +1186,8 @@ static int idefloppy_open(struct inode *inode, struct file *filp)
 		floppy->flags |= IDEFLOPPY_FLAG_MEDIA_CHANGED;
 		/* IOMEGA Clik! drives do not support lock/unlock commands */
 		if (!(floppy->flags & IDEFLOPPY_FLAG_CLIK_DRIVE)) {
-			idefloppy_create_prevent_cmd(&pc, 1);
-			(void) idefloppy_queue_pc_tail(drive, &pc);
+			idefloppy_create_prevent_cmd(&pc, 1, cmd);
+			(void) idefloppy_queue_pc_tail(drive, &pc, cmd);
 		}
 		check_disk_change(inode->i_bdev);
 	} else if (floppy->flags & IDEFLOPPY_FLAG_FORMAT_IN_PROGRESS) {
@@ -1213,14 +1208,15 @@ static int idefloppy_release(struct inode *inode, struct file *filp)
 	struct ide_floppy_obj *floppy = ide_floppy_g(disk);
 	ide_drive_t *drive = floppy->drive;
 	struct ide_atapi_pc pc;
+	unsigned char cmd[12];
 
 	debug_log("Reached %s\n", __func__);
 
 	if (floppy->openers == 1) {
 		/* IOMEGA Clik! drives do not support lock/unlock commands */
 		if (!(floppy->flags & IDEFLOPPY_FLAG_CLIK_DRIVE)) {
-			idefloppy_create_prevent_cmd(&pc, 0);
-			(void) idefloppy_queue_pc_tail(drive, &pc);
+			idefloppy_create_prevent_cmd(&pc, 0, cmd);
+			(void) idefloppy_queue_pc_tail(drive, &pc, cmd);
 		}
 
 		floppy->flags &= ~IDEFLOPPY_FLAG_FORMAT_IN_PROGRESS;
@@ -1247,6 +1243,8 @@ static int idefloppy_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 static int ide_floppy_lockdoor(idefloppy_floppy_t *floppy,
 		struct ide_atapi_pc *pc, unsigned long arg, unsigned int cmd)
 {
+	unsigned char pc_cmd[12];
+
 	if (floppy->openers > 1)
 		return -EBUSY;
 
@@ -1258,13 +1256,13 @@ static int ide_floppy_lockdoor(idefloppy_floppy_t *floppy,
 		if (cmd == CDROMEJECT)
 			prevent = 0;
 
-		idefloppy_create_prevent_cmd(pc, prevent);
-		(void) idefloppy_queue_pc_tail(floppy->drive, pc);
+		idefloppy_create_prevent_cmd(pc, prevent, pc_cmd);
+		(void) idefloppy_queue_pc_tail(floppy->drive, pc, pc_cmd);
 	}
 
 	if (cmd == CDROMEJECT) {
-		idefloppy_create_start_stop_cmd(pc, 2);
-		(void) idefloppy_queue_pc_tail(floppy->drive, pc);
+		idefloppy_create_start_stop_cmd(pc, 2, pc_cmd);
+		(void) idefloppy_queue_pc_tail(floppy->drive, pc, pc_cmd);
 	}
 
 	return 0;
@@ -1275,6 +1273,7 @@ static int ide_floppy_format_unit(idefloppy_floppy_t *floppy,
 {
 	int blocks, length, flags, err = 0;
 	struct ide_atapi_pc pc;
+	unsigned char cmd[12];
 
 	if (floppy->openers > 1) {
 		/* Don't format if someone is using the disk */
@@ -1307,9 +1306,9 @@ static int ide_floppy_format_unit(idefloppy_floppy_t *floppy,
 	}
 
 	(void) idefloppy_get_sfrp_bit(floppy->drive);
-	idefloppy_create_format_unit_cmd(&pc, blocks, length, flags);
+	idefloppy_create_format_unit_cmd(&pc, blocks, length, flags, cmd);
 
-	if (idefloppy_queue_pc_tail(floppy->drive, &pc))
+	if (idefloppy_queue_pc_tail(floppy->drive, &pc, cmd))
 		err = -EIO;
 
 out:
-- 
1.5.5.1

