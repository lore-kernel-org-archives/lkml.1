Return-Path: <linux-kernel-owner+w=401wt.eu-S1756125AbYBKIgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125AbYBKIgY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 03:36:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753519AbYBKIfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 03:35:23 -0500
Received: from an-out-0708.google.com ([209.85.132.243]:53103 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654AbYBKIfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 03:35:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=rwJDo8qFOgdupqnrei0QLkx3ORtiAUrRi4dMPO/29Eu13zpfo7NUdP5Q5KNUStjLNEjb4MIL63V/VbDqD1p1ggKRsL1FsUHRgzdsBDd+QJ2MYd8UV/+r4OTqM0Lxki55YvYIk8D5l/SeU6OknaKiQmdF5Dqo0seegNL6bXx3zO4=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 4/4] ide-scsi: convert driver to using generic ide_atapi_pc
Date: Mon, 11 Feb 2008 09:34:40 +0100
Message-Id: <1202718880-1793-5-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1202718880-1793-1-git-send-email-petkovbb@gmail.com>
References: <1202718880-1793-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/scsi/ide-scsi.c |  133 ++++++++++++++++++++++-------------------------
 1 files changed, 62 insertions(+), 71 deletions(-)

diff --git a/drivers/scsi/ide-scsi.c b/drivers/scsi/ide-scsi.c
index 7fea769..5ec421c 100644
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -60,23 +60,6 @@
 
 #define IDESCSI_DEBUG_LOG		0
 
-typedef struct idescsi_pc_s {
-	u8 c[12];				/* Actual packet bytes */
-	int request_transfer;			/* Bytes to transfer */
-	int actually_transferred;		/* Bytes actually transferred */
-	int buffer_size;			/* Size of our data buffer */
-	struct request *rq;			/* The corresponding request */
-	u8 *buffer;				/* Data buffer */
-	u8 *current_position;			/* Pointer into the above buffer */
-	struct scatterlist *sg;			/* Scatter gather table */
-	unsigned int sg_cnt;			/* Number of entries in sg */
-	int b_count;				/* Bytes transferred from current entry */
-	struct scsi_cmnd *scsi_cmd;		/* SCSI command */
-	void (*done)(struct scsi_cmnd *);	/* Scsi completion routine */
-	unsigned long flags;			/* Status/Action flags */
-	unsigned long timeout;			/* Command timeout */
-} idescsi_pc_t;
-
 /*
  *	Packet command status bits.
  */
@@ -101,14 +84,15 @@ typedef struct ide_scsi_obj {
 	struct gendisk		*disk;
 	struct Scsi_Host	*host;
 
-	idescsi_pc_t *pc;			/* Current packet command */
+	struct ide_atapi_pc *pc;		/* Current packet command */
 	unsigned long flags;			/* Status/Action flags */
 	unsigned long transform;		/* SCSI cmd translation layer */
 	unsigned long log;			/* log flags */
 } idescsi_scsi_t;
 
 static DEFINE_MUTEX(idescsi_ref_mutex);
-static int idescsi_nocd;			/* Set by module param to skip cd */
+/* Set by module param to skip cd */
+static int idescsi_nocd;
 
 #define ide_scsi_g(disk) \
 	container_of((disk)->private_data, struct ide_scsi_obj, driver)
@@ -155,7 +139,8 @@ static inline idescsi_scsi_t *drive_to_idescsi(ide_drive_t *ide_drive)
 /*
  *	PIO data transfer routines using the scatter gather table.
  */
-static void idescsi_input_buffers (ide_drive_t *drive, idescsi_pc_t *pc, unsigned int bcount)
+static void idescsi_input_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
+		unsigned int bcount)
 {
 	int count;
 	char *buf;
@@ -192,7 +177,8 @@ static void idescsi_input_buffers (ide_drive_t *drive, idescsi_pc_t *pc, unsigne
 	}
 }
 
-static void idescsi_output_buffers (ide_drive_t *drive, idescsi_pc_t *pc, unsigned int bcount)
+static void idescsi_output_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
+		unsigned int bcount)
 {
 	int count;
 	char *buf;
@@ -234,15 +220,16 @@ static void ide_scsi_hex_dump(u8 *data, int len)
 	print_hex_dump(KERN_CONT, "", DUMP_PREFIX_NONE, 16, 1, data, len, 0);
 }
 
-static int idescsi_check_condition(ide_drive_t *drive, struct request *failed_command)
+static int idescsi_check_condition(ide_drive_t *drive,
+		struct request *failed_cmd)
 {
 	idescsi_scsi_t *scsi = drive_to_idescsi(drive);
-	idescsi_pc_t   *pc;
+	struct ide_atapi_pc   *pc;
 	struct request *rq;
 	u8             *buf;
 
 	/* stuff a sense request in front of our current request */
-	pc = kzalloc(sizeof(idescsi_pc_t), GFP_ATOMIC);
+	pc = kzalloc(sizeof(struct ide_atapi_pc), GFP_ATOMIC);
 	rq = kmalloc(sizeof(struct request), GFP_ATOMIC);
 	buf = kzalloc(SCSI_SENSE_BUFFERSIZE, GFP_ATOMIC);
 	if (!pc || !rq || !buf) {
@@ -254,14 +241,14 @@ static int idescsi_check_condition(ide_drive_t *drive, struct request *failed_co
 	ide_init_drive_cmd(rq);
 	rq->special = (char *) pc;
 	pc->rq = rq;
-	pc->buffer = buf;
+	pc->buf = buf;
 	pc->c[0] = REQUEST_SENSE;
-	pc->c[4] = pc->request_transfer = pc->buffer_size = SCSI_SENSE_BUFFERSIZE;
+	pc->c[4] = pc->req_xfer = pc->buf_size = SCSI_SENSE_BUFFERSIZE;
 	rq->cmd_type = REQ_TYPE_SENSE;
 	pc->timeout = jiffies + WAIT_READY;
 	/* NOTE! Save the failed packet command in "rq->buffer" */
-	rq->buffer = (void *) failed_command->special;
-	pc->scsi_cmd = ((idescsi_pc_t *) failed_command->special)->scsi_cmd;
+	rq->buffer = (void *) failed_cmd->special;
+	pc->scsi_cmd = ((struct ide_atapi_pc *) failed_cmd->special)->scsi_cmd;
 	if (test_bit(IDESCSI_LOG_CMD, &scsi->log)) {
 		printk ("ide-scsi: %s: queue cmd = ", drive->name);
 		ide_scsi_hex_dump(pc->c, 6);
@@ -294,7 +281,7 @@ idescsi_atapi_abort(ide_drive_t *drive, struct request *rq)
 {
 #if IDESCSI_DEBUG_LOG
 	printk(KERN_WARNING "idescsi_atapi_abort called for %lu\n",
-			((idescsi_pc_t *) rq->special)->scsi_cmd->serial_number);
+		((struct ide_atapi_pc *) rq->special)->scsi_cmd->serial_number);
 #endif
 	rq->errors |= ERROR_MAX;
 
@@ -307,7 +294,7 @@ static int idescsi_end_request (ide_drive_t *drive, int uptodate, int nrsecs)
 {
 	idescsi_scsi_t *scsi = drive_to_idescsi(drive);
 	struct request *rq = HWGROUP(drive)->rq;
-	idescsi_pc_t *pc = (idescsi_pc_t *) rq->special;
+	struct ide_atapi_pc *pc = (struct ide_atapi_pc *) rq->special;
 	int log = test_bit(IDESCSI_LOG_CMD, &scsi->log);
 	struct Scsi_Host *host;
 	int errors = rq->errors;
@@ -319,13 +306,14 @@ static int idescsi_end_request (ide_drive_t *drive, int uptodate, int nrsecs)
 	}
 	ide_end_drive_cmd (drive, 0, 0);
 	if (blk_sense_request(rq)) {
-		idescsi_pc_t *opc = (idescsi_pc_t *) rq->buffer;
+		struct ide_atapi_pc *opc = (struct ide_atapi_pc *) rq->buffer;
 		if (log) {
 			printk ("ide-scsi: %s: wrap up check %lu, rst = ", drive->name, opc->scsi_cmd->serial_number);
-			ide_scsi_hex_dump(pc->buffer, 16);
+			ide_scsi_hex_dump(pc->buf, 16);
 		}
-		memcpy((void *) opc->scsi_cmd->sense_buffer, pc->buffer, SCSI_SENSE_BUFFERSIZE);
-		kfree(pc->buffer);
+		memcpy((void *) opc->scsi_cmd->sense_buffer, pc->buf,
+			SCSI_SENSE_BUFFERSIZE);
+		kfree(pc->buf);
 		kfree(pc);
 		kfree(rq);
 		pc = opc;
@@ -361,7 +349,7 @@ static int idescsi_end_request (ide_drive_t *drive, int uptodate, int nrsecs)
 	return 0;
 }
 
-static inline unsigned long get_timeout(idescsi_pc_t *pc)
+static inline unsigned long get_timeout(struct ide_atapi_pc *pc)
 {
 	return max_t(unsigned long, WAIT_CMD, pc->timeout - jiffies);
 }
@@ -369,7 +357,7 @@ static inline unsigned long get_timeout(idescsi_pc_t *pc)
 static int idescsi_expiry(ide_drive_t *drive)
 {
 	idescsi_scsi_t *scsi = drive_to_idescsi(drive);
-	idescsi_pc_t   *pc   = scsi->pc;
+	struct ide_atapi_pc   *pc   = scsi->pc;
 
 #if IDESCSI_DEBUG_LOG
 	printk(KERN_WARNING "idescsi_expiry called for %lu at %lu\n", pc->scsi_cmd->serial_number, jiffies);
@@ -386,7 +374,7 @@ static ide_startstop_t idescsi_pc_intr (ide_drive_t *drive)
 {
 	idescsi_scsi_t *scsi = drive_to_idescsi(drive);
 	ide_hwif_t *hwif = drive->hwif;
-	idescsi_pc_t *pc = scsi->pc;
+	struct ide_atapi_pc *pc = scsi->pc;
 	struct request *rq = pc->rq;
 	unsigned int temp;
 	u16 bcount;
@@ -409,7 +397,7 @@ static ide_startstop_t idescsi_pc_intr (ide_drive_t *drive)
 #if IDESCSI_DEBUG_LOG
 		printk ("ide-scsi: %s: DMA complete\n", drive->name);
 #endif /* IDESCSI_DEBUG_LOG */
-		pc->actually_transferred=pc->request_transfer;
+		pc->xferred = pc->req_xfer;
 		(void) HWIF(drive)->ide_dma_end(drive);
 	}
 
@@ -419,7 +407,8 @@ static ide_startstop_t idescsi_pc_intr (ide_drive_t *drive)
 	if ((stat & DRQ_STAT) == 0) {
 		/* No more interrupts */
 		if (test_bit(IDESCSI_LOG_CMD, &scsi->log))
-			printk (KERN_INFO "Packet command completed, %d bytes transferred\n", pc->actually_transferred);
+			printk(KERN_INFO "Packet command completed, %d bytes"
+					" transferred\n", pc->xferred);
 		local_irq_enable_in_hardirq();
 		if (stat & ERR_STAT)
 			rq->errors++;
@@ -435,25 +424,26 @@ static ide_startstop_t idescsi_pc_intr (ide_drive_t *drive)
 		return ide_do_reset (drive);
 	}
 	if (ireason & IO) {
-		temp = pc->actually_transferred + bcount;
-		if (temp > pc->request_transfer) {
-			if (temp > pc->buffer_size) {
+		temp = pc->xferred + bcount;
+		if (temp > pc->req_xfer) {
+			if (temp > pc->buf_size) {
 				printk(KERN_ERR "ide-scsi: The scsi wants to "
 					"send us more data than expected "
 					"- discarding data\n");
-				temp = pc->buffer_size - pc->actually_transferred;
+				temp = pc->buf_size - pc->xferred;
 				if (temp) {
 					clear_bit(PC_WRITING, &pc->flags);
 					if (pc->sg)
-						idescsi_input_buffers(drive, pc, temp);
+						idescsi_input_buffers(drive, pc,
+									temp);
 					else
-						drive->hwif->atapi_input_bytes(drive, pc->current_position, temp);
+						drive->hwif->atapi_input_bytes(drive, pc->cur_pos, temp);
 					printk(KERN_ERR "ide-scsi: transferred"
 							" %d of %d bytes\n",
 							temp, bcount);
 				}
-				pc->actually_transferred += temp;
-				pc->current_position += temp;
+				pc->xferred += temp;
+				pc->cur_pos += temp;
 				ide_atapi_discard_data(drive, bcount - temp);
 				ide_set_handler(drive, &idescsi_pc_intr, get_timeout(pc), idescsi_expiry);
 				return ide_started;
@@ -468,19 +458,19 @@ static ide_startstop_t idescsi_pc_intr (ide_drive_t *drive)
 		if (pc->sg)
 			idescsi_input_buffers(drive, pc, bcount);
 		else
-			hwif->atapi_input_bytes(drive, pc->current_position,
+			hwif->atapi_input_bytes(drive, pc->cur_pos,
 						bcount);
 	} else {
 		set_bit(PC_WRITING, &pc->flags);
 		if (pc->sg)
 			idescsi_output_buffers(drive, pc, bcount);
 		else
-			hwif->atapi_output_bytes(drive, pc->current_position,
+			hwif->atapi_output_bytes(drive, pc->cur_pos,
 						 bcount);
 	}
 	/* Update the current position */
-	pc->actually_transferred += bcount;
-	pc->current_position += bcount;
+	pc->xferred += bcount;
+	pc->cur_pos += bcount;
 
 	/* And set the interrupt handler again */
 	ide_set_handler(drive, &idescsi_pc_intr, get_timeout(pc), idescsi_expiry);
@@ -491,7 +481,7 @@ static ide_startstop_t idescsi_transfer_pc(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	idescsi_scsi_t *scsi = drive_to_idescsi(drive);
-	idescsi_pc_t *pc = scsi->pc;
+	struct ide_atapi_pc *pc = scsi->pc;
 	ide_startstop_t startstop;
 	u8 ireason;
 
@@ -518,7 +508,7 @@ static ide_startstop_t idescsi_transfer_pc(ide_drive_t *drive)
 	return ide_started;
 }
 
-static inline int idescsi_set_direction(idescsi_pc_t *pc)
+static inline int idescsi_set_direction(struct ide_atapi_pc *pc)
 {
 	switch (pc->c[0]) {
 		case READ_6: case READ_10: case READ_12:
@@ -532,13 +522,13 @@ static inline int idescsi_set_direction(idescsi_pc_t *pc)
 	}
 }
 
-static int idescsi_map_sg(ide_drive_t *drive, idescsi_pc_t *pc)
+static int idescsi_map_sg(ide_drive_t *drive, struct ide_atapi_pc *pc)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct scatterlist *sg, *scsi_sg;
 	int segments;
 
-	if (!pc->request_transfer || pc->request_transfer % 1024)
+	if (!pc->req_xfer || pc->req_xfer % 1024)
 		return 1;
 
 	if (idescsi_set_direction(pc))
@@ -557,21 +547,21 @@ static int idescsi_map_sg(ide_drive_t *drive, idescsi_pc_t *pc)
 	return 0;
 }
 
-/*
- *	Issue a packet command
- */
-static ide_startstop_t idescsi_issue_pc (ide_drive_t *drive, idescsi_pc_t *pc)
+static ide_startstop_t idescsi_issue_pc(ide_drive_t *drive,
+		struct ide_atapi_pc *pc)
 {
 	idescsi_scsi_t *scsi = drive_to_idescsi(drive);
 	ide_hwif_t *hwif = drive->hwif;
 	u16 bcount;
 	u8 dma = 0;
 
-	scsi->pc=pc;							/* Set the current packet command */
-	pc->actually_transferred=0;					/* We haven't transferred any data yet */
-	pc->current_position=pc->buffer;
+	/* Set the current packet command */
+	scsi->pc = pc;
+	/* We haven't transferred any data yet */
+	pc->xferred = 0;
+	pc->cur_pos = pc->buf;
 	/* Request to transfer the entire buffer at once */
-	bcount = min(pc->request_transfer, 63 * 1024);
+	bcount = min(pc->req_xfer, 63 * 1024);
 
 	if (drive->using_dma && !idescsi_map_sg(drive, pc)) {
 		hwif->sg_mapped = 1;
@@ -606,7 +596,8 @@ static ide_startstop_t idescsi_do_request (ide_drive_t *drive, struct request *r
 #endif /* IDESCSI_DEBUG_LOG */
 
 	if (blk_sense_request(rq) || blk_special_request(rq)) {
-		return idescsi_issue_pc (drive, (idescsi_pc_t *) rq->special);
+		return idescsi_issue_pc(drive,
+				(struct ide_atapi_pc *) rq->special);
 	}
 	blk_dump_rq_flags(rq, "ide-scsi: unsup command");
 	idescsi_end_request (drive, 0, 0);
@@ -764,15 +755,15 @@ static int idescsi_queue (struct scsi_cmnd *cmd,
 	idescsi_scsi_t *scsi = scsihost_to_idescsi(host);
 	ide_drive_t *drive = scsi->drive;
 	struct request *rq = NULL;
-	idescsi_pc_t *pc = NULL;
+	struct ide_atapi_pc *pc = NULL;
 
 	if (!drive) {
 		scmd_printk (KERN_ERR, cmd, "drive not present\n");
 		goto abort;
 	}
 	scsi = drive_to_idescsi(drive);
-	pc = kmalloc (sizeof (idescsi_pc_t), GFP_ATOMIC);
-	rq = kmalloc (sizeof (struct request), GFP_ATOMIC);
+	pc = kmalloc(sizeof(struct ide_atapi_pc), GFP_ATOMIC);
+	rq = kmalloc(sizeof(struct request), GFP_ATOMIC);
 	if (rq == NULL || pc == NULL) {
 		printk (KERN_ERR "ide-scsi: %s: out of memory\n", drive->name);
 		goto abort;
@@ -782,11 +773,11 @@ static int idescsi_queue (struct scsi_cmnd *cmd,
 	pc->flags = 0;
 	pc->rq = rq;
 	memcpy (pc->c, cmd->cmnd, cmd->cmd_len);
-	pc->buffer = NULL;
+	pc->buf = NULL;
 	pc->sg = scsi_sglist(cmd);
 	pc->sg_cnt = scsi_sg_count(cmd);
 	pc->b_count = 0;
-	pc->request_transfer = pc->buffer_size = scsi_bufflen(cmd);
+	pc->req_xfer = pc->buf_size = scsi_bufflen(cmd);
 	pc->scsi_cmd = cmd;
 	pc->done = done;
 	pc->timeout = jiffies + cmd->timeout_per_command;
@@ -857,7 +848,7 @@ static int idescsi_eh_abort (struct scsi_cmnd *cmd)
 		printk (KERN_ERR "ide-scsi: cmd aborted!\n");
 
 		if (blk_sense_request(scsi->pc->rq))
-			kfree(scsi->pc->buffer);
+			kfree(scsi->pc->buf);
 		kfree(scsi->pc->rq);
 		kfree(scsi->pc);
 		scsi->pc = NULL;
@@ -907,7 +898,7 @@ static int idescsi_eh_reset (struct scsi_cmnd *cmd)
 	if (__blk_end_request(req, -EIO, 0))
 		BUG();
 	if (blk_sense_request(req))
-		kfree(scsi->pc->buffer);
+		kfree(scsi->pc->buf);
 	kfree(scsi->pc);
 	scsi->pc = NULL;
 	kfree(req);
-- 
1.5.3.7

