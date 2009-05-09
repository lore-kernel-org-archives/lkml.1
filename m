Return-Path: <linux-kernel-owner+w=401wt.eu-S1755693AbZEIHtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693AbZEIHtd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 03:49:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbZEIHqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 03:46:00 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:64706 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbZEIHpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 03:45:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=OwwY8/eDD3vI2Pl3CVATxapuNo7hhjNM/A+9/m5D8US/UMadutXh4yIyy2f6KwjyOm
         9WufCdeV6dAve8cUud3XHmuRBnyexDJ5WJYbPT1x3bmd5DZlrDH+wsQb+2MCZYNDwKST
         XmnPuh8I+N6nNvH2v30aSROVs1hxRlUvL8CBo=
From: Borislav Petkov <petkovbb@googlemail.com>
To: <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 09/14] ide-atapi: use local sense buffer
Date: Sat,  9 May 2009 09:45:29 +0200
Message-Id: <1241855134-4984-10-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1241855134-4984-1-git-send-email-petkovbb@gmail.com>
References: <1241855134-4984-1-git-send-email-petkovbb@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Save a pointer to the sense buffer in rq->sense in order to access it
later in the ->pc_callback method. Also, remove remaining references to
pc->buf in ide-floppy code.

There should be no functional change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-atapi.c        |   10 ++++++++--
 drivers/ide/ide-floppy.c       |   12 ++++++------
 drivers/ide/ide-floppy_ioctl.c |    4 ++--
 drivers/ide/ide-tape.c         |    5 +++--
 4 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index bd59fea..df3e3bb 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -93,6 +93,13 @@ int ide_queue_pc_tail(ide_drive_t *drive, struct gendisk *disk,
 	rq->cmd_type = REQ_TYPE_SPECIAL;
 	rq->special = (char *)pc;
 
+	/*
+	 * FIXME: temporarily save a ptr to the sense buffer in rq->sense for
+	 * the ->do_callback sense massaging. Will remove later.
+	 */
+	if (pc->c[0] == REQUEST_SENSE)
+		rq->sense = buf;
+
 	if (buf && bufflen) {
 		error = blk_rq_map_kern(drive->queue, rq, buf, bufflen,
 					GFP_NOIO);
@@ -252,8 +259,7 @@ void ide_retry_pc(ide_drive_t *drive)
 	/* init pc from sense_rq */
 	ide_init_pc(pc);
 	memcpy(pc->c, sense_rq->cmd, 12);
-	pc->buf = bio_data(sense_rq->bio);	/* pointer to mapped address */
-	pc->req_xfer = blk_rq_bytes(sense_rq);
+	sense_rq->sense = bio_data(sense_rq->bio);	/* pointer to mapped address */
 
 	if (drive->media == ide_tape)
 		set_bit(IDE_AFLAG_IGNORE_DSC, &drive->atapi_flags);
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 060c893..cb6c6f8 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -77,7 +77,12 @@ static int ide_floppy_callback(ide_drive_t *drive, int dsc)
 	    (rq && blk_pc_request(rq)))
 		uptodate = 1; /* FIXME */
 	else if (pc->c[0] == GPCMD_REQUEST_SENSE) {
-		u8 *buf = pc->buf;
+
+		u8 *buf;
+
+		BUG_ON(!rq->sense);
+
+		buf = rq->sense;
 
 		if (!pc->error) {
 			floppy->sense_key = buf[2] & 0x0F;
@@ -209,8 +214,6 @@ static void idefloppy_create_rw_cmd(ide_drive_t *drive,
 	pc->rq = rq;
 	if (rq->cmd_flags & REQ_RW)
 		pc->flags |= PC_FLAG_WRITING;
-	pc->buf = NULL;
-	pc->buf_size = blk_rq_bytes(rq);
 	pc->flags |= PC_FLAG_DMA_OK;
 }
 
@@ -225,9 +228,6 @@ static void idefloppy_blockpc_cmd(struct ide_disk_obj *floppy,
 		if (rq_data_dir(rq) == WRITE)
 			pc->flags |= PC_FLAG_WRITING;
 	}
-	/* pio will be performed by ide_pio_bytes() which handles sg fine */
-	pc->buf = NULL;
-	pc->buf_size = blk_rq_bytes(rq);
 }
 
 static ide_startstop_t ide_floppy_do_request(ide_drive_t *drive,
diff --git a/drivers/ide/ide-floppy_ioctl.c b/drivers/ide/ide-floppy_ioctl.c
index 7a03d34..9c22882 100644
--- a/drivers/ide/ide-floppy_ioctl.c
+++ b/drivers/ide/ide-floppy_ioctl.c
@@ -47,7 +47,6 @@ static int ide_floppy_get_format_capacities(ide_drive_t *drive,
 		return -EINVAL;
 
 	ide_floppy_create_read_capacity_cmd(pc);
-	pc->buf_size = sizeof(pc_buf);
 
 	if (ide_queue_pc_tail(drive, floppy->disk, pc, pc_buf, pc->req_xfer)) {
 		printk(KERN_ERR "ide-floppy: Can't get floppy parameters\n");
@@ -198,11 +197,12 @@ static int ide_floppy_get_format_progress(ide_drive_t *drive,
 					  int __user *arg)
 {
 	struct ide_disk_obj *floppy = drive->driver_data;
+	u8 sense_buf[18];
 	int progress_indication = 0x10000;
 
 	if (drive->atapi_flags & IDE_AFLAG_SRFP) {
 		ide_create_request_sense_cmd(drive, pc);
-		if (ide_queue_pc_tail(drive, floppy->disk, pc, pc->buf,
+		if (ide_queue_pc_tail(drive, floppy->disk, pc, sense_buf,
 				      pc->req_xfer))
 			return -EIO;
 
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 7c9e0c7..badc9cb 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -288,11 +288,12 @@ static struct ide_tape_obj *ide_tape_chrdev_get(unsigned int i)
  * called on each failed packet command retry to analyze the request sense. We
  * currently do not utilize this information.
  */
-static void idetape_analyze_error(ide_drive_t *drive, u8 *sense)
+static void idetape_analyze_error(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	struct ide_atapi_pc *pc = drive->failed_pc;
 	struct request *rq = drive->hwif->rq;
+	u8 *sense = rq->sense;
 
 	tape->sense_key = sense[2] & 0xF;
 	tape->asc       = sense[12];
@@ -362,7 +363,7 @@ static int ide_tape_callback(ide_drive_t *drive, int dsc)
 
 	if (pc->c[0] == REQUEST_SENSE) {
 		if (uptodate)
-			idetape_analyze_error(drive, pc->buf);
+			idetape_analyze_error(drive);
 		else
 			printk(KERN_ERR "ide-tape: Error in REQUEST SENSE "
 					"itself - Aborting request!\n");
-- 
1.6.2.4

