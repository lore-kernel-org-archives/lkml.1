Return-Path: <linux-kernel-owner+w=401wt.eu-S1752833AbYLPHhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833AbYLPHhT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 02:37:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751802AbYLPHgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 02:36:20 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:50296 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbYLPHgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 02:36:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=B89urdrbyDCCd1to3qc3ZIErsuqZurxfb6bg9pO1f8T9FRZTCoPFWOubNpMo07eMIX
         AeLqvBy2Jrw6cfofmSWciBKgNRzG97/1Mo9GuaAEiMfU9rjxk6wVb0JL9TIpPkE2wiK5
         +Ny1EJ+vFcvmJdtO7mADJi+j6euULA9IcYWoU=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 4/9] ide-atapi: replace pc->req_xfer with drive->pc_req_xfer
Date: Tue, 16 Dec 2008 08:36:04 +0100
Message-Id: <1229412969-3552-5-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1229412969-3552-1-git-send-email-petkovbb@gmail.com>
References: <1229412969-3552-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functionality change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-atapi.c  |   14 +++++++-------
 drivers/ide/ide-floppy.c |    8 ++++----
 drivers/ide/ide-tape.c   |   16 ++++++++--------
 include/linux/ide.h      |    5 +++--
 4 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index 964a7e2..1b4d157 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -123,6 +123,7 @@ void ide_init_pc(ide_drive_t *drive, struct ide_atapi_pc *pc)
 	pc->buf = pc->pc_buf;
 	pc->buf_size = IDE_PC_BUFFER_SIZE;
 	drive->pc_flags = 0;
+	drive->pc_req_xfer = 0;
 }
 EXPORT_SYMBOL_GPL(ide_init_pc);
 
@@ -219,10 +220,10 @@ void ide_create_request_sense_cmd(ide_drive_t *drive, struct ide_atapi_pc *pc)
 	pc->c[0] = REQUEST_SENSE;
 	if (drive->media == ide_floppy) {
 		pc->c[4] = 255;
-		pc->req_xfer = 18;
+		drive->pc_req_xfer = 18;
 	} else {
 		pc->c[4] = 20;
-		pc->req_xfer = 20;
+		drive->pc_req_xfer = 20;
 	}
 }
 EXPORT_SYMBOL_GPL(ide_create_request_sense_cmd);
@@ -335,7 +336,7 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 						     ? "write" : "read");
 			drive->pc_flags |= PC_FLAG_DMA_ERROR;
 		} else {
-			rq->data_len = pc->req_xfer;
+			rq->data_len = drive->pc_req_xfer;
 			if (drive->pc_update_buffers)
 				drive->pc_update_buffers(drive, pc);
 		}
@@ -416,7 +417,7 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 	if (!write) {
 		/* Reading - Check that we have enough space */
 		temp = rq->data_len + bcount;
-		if (temp > pc->req_xfer) {
+		if (temp > drive->pc_req_xfer) {
 			if (temp > pc->buf_size) {
 
 				printk(KERN_ERR "%s: The device wants to send "
@@ -564,7 +565,6 @@ static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
 
 ide_startstop_t ide_issue_pc(ide_drive_t *drive, unsigned int timeout)
 {
-	struct ide_atapi_pc *pc = drive->pc;
 	ide_hwif_t *hwif = drive->hwif;
 	ide_expiry_t *expiry = NULL;
 	u32 tf_flags;
@@ -577,8 +577,8 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive, unsigned int timeout)
 	} else {
 		tf_flags = IDE_TFLAG_OUT_DEVICE;
 		bcount = ((drive->media == ide_tape) ?
-				pc->req_xfer :
-				min(pc->req_xfer, 63 * 1024));
+				drive->pc_req_xfer :
+				min(drive->pc_req_xfer, 63 * 1024));
 	}
 
 	if (drive->pc_flags & PC_FLAG_DMA_ERROR) {
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index f88ccd1..99f0c49 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -207,7 +207,7 @@ void ide_floppy_create_read_capacity_cmd(ide_drive_t *drive,
 	pc->c[0] = GPCMD_READ_FORMAT_CAPACITIES;
 	pc->c[7] = 255;
 	pc->c[8] = 255;
-	pc->req_xfer = 255;
+	drive->pc_req_xfer = 255;
 }
 
 /* A mode sense command is used to "sense" floppy parameters. */
@@ -232,7 +232,7 @@ void ide_floppy_create_mode_sense_cmd(ide_drive_t *drive,
 		printk(KERN_ERR PFX "unsupported page code in %s\n", __func__);
 	}
 	put_unaligned(cpu_to_be16(length), (u16 *) &pc->c[7]);
-	pc->req_xfer = length;
+	drive->pc_req_xfer = length;
 }
 
 static void idefloppy_create_rw_cmd(ide_drive_t *drive,
@@ -258,7 +258,7 @@ static void idefloppy_create_rw_cmd(ide_drive_t *drive,
 	pc->b_count = 0;
 	rq->data = NULL;
 	rq->data_len = 0;
-	pc->req_xfer = pc->buf_size = blocks * floppy->block_size;
+	drive->pc_req_xfer = pc->buf_size = blocks * floppy->block_size;
 	drive->pc_flags |= PC_FLAG_DMA_OK;
 }
 
@@ -276,7 +276,7 @@ static void idefloppy_blockpc_cmd(ide_drive_t *drive, struct ide_atapi_pc *pc,
 	 * possibly problematic, doesn't look like ide-floppy correctly
 	 * handled scattered requests if dma fails...
 	 */
-	pc->req_xfer = pc->buf_size = rq->data_len;
+	drive->pc_req_xfer = pc->buf_size = rq->data_len;
 }
 
 static ide_startstop_t ide_floppy_do_request(ide_drive_t *drive,
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 1890f9f..35a41e2 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -413,7 +413,7 @@ static void idetape_analyze_error(ide_drive_t *drive, u8 *sense)
 
 	/* Correct rq->data_len by asking the tape.	 */
 	if (drive->pc_flags & PC_FLAG_DMA_ERROR) {
-		rq->data_len = pc->req_xfer -
+		rq->data_len = drive->pc_req_xfer -
 			tape->blk_size *
 			get_unaligned_be32(&sense[3]);
 		idetape_update_buffers(drive, pc);
@@ -720,11 +720,11 @@ static void idetape_create_mode_sense_cmd(ide_drive_t *drive,
 	/* We will just discard data in that case */
 	pc->c[4] = 255;
 	if (page_code == IDETAPE_BLOCK_DESCRIPTOR)
-		pc->req_xfer = 12;
+		drive->pc_req_xfer = 12;
 	else if (page_code == IDETAPE_CAPABILITIES_PAGE)
-		pc->req_xfer = 24;
+		drive->pc_req_xfer = 24;
 	else
-		pc->req_xfer = 50;
+		drive->pc_req_xfer = 50;
 }
 
 static ide_startstop_t idetape_media_access_finished(ide_drive_t *drive)
@@ -768,8 +768,8 @@ static void ide_tape_create_rw_cmd(ide_drive_t *drive, struct ide_atapi_pc *pc,
 	pc->bh = bh;
 	pc->buf = NULL;
 	pc->buf_size = length * tape->blk_size;
-	pc->req_xfer = pc->buf_size;
-	if (pc->req_xfer == tape->buffer_size)
+	drive->pc_req_xfer = pc->buf_size;
+	if (drive->pc_req_xfer == tape->buffer_size)
 		drive->pc_flags |= PC_FLAG_DMA_OK;
 
 	if (opcode == READ_6) {
@@ -1105,7 +1105,7 @@ static void idetape_create_read_position_cmd(ide_drive_t *drive,
 {
 	ide_init_pc(drive, pc);
 	pc->c[0] = READ_POSITION;
-	pc->req_xfer = 20;
+	drive->pc_req_xfer = 20;
 }
 
 static int idetape_read_position(ide_drive_t *drive)
@@ -1239,7 +1239,7 @@ static void idetape_create_inquiry_cmd(ide_drive_t *drive,
 	ide_init_pc(drive, pc);
 	pc->c[0] = INQUIRY;
 	pc->c[4] = 254;
-	pc->req_xfer = 254;
+	drive->pc_req_xfer = 254;
 }
 
 static void idetape_create_rewind_cmd(ide_drive_t *drive,
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 57afe1f..7874ac5 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -587,7 +587,7 @@ struct ide_drive_s {
 	struct request_queue	*queue;	/* request queue */
 
 	struct request		*rq;	/* current request */
-	struct ide_drive_s 	*next;	/* circular list of hwgroup drives */
+	struct ide_drive_s	*next;	/* circular list of hwgroup drives */
 	void		*driver_data;	/* extra driver data */
 	u16			*id;	/* identification info */
 #ifdef CONFIG_IDE_PROC_FS
@@ -654,8 +654,9 @@ struct ide_drive_s {
 	/* current packet command */
 	struct ide_atapi_pc *pc;
 
-	/* atapi pc flags: temporary */
+	/* atapi pc members: temporarily harbored here */
 	unsigned long pc_flags;
+	int pc_req_xfer;
 
 	/* callback for packet commands */
 	void (*pc_callback)(struct ide_drive_s *, int);
-- 
1.6.0.4

