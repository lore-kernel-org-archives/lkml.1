Return-Path: <linux-kernel-owner+w=401wt.eu-S1754165AbZEIHrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165AbZEIHrX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 03:47:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752391AbZEIHpr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 03:45:47 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:60855 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbZEIHph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 03:45:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=jMFeJu1AeEPvlWxpX72pB8jWoFVE1n2wk8cqgatYh59i9X99L8T6zUKgw+USrqOt2G
         +AX92nrjmbvRLlba8Enn4VHdRFYnXNHOjpPVfVLuCXkBXxpC/P0vvUcmFMenkvFfa/wU
         Rk0EWov0U9gm/35D6CdXKGmZa6PMWdp/5ykg0=
From: Borislav Petkov <petkovbb@googlemail.com>
To: <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 04/14] ide-atapi: add a len-parameter to ide_queue_pc_tail
Date: Sat,  9 May 2009 09:45:24 +0200
Message-Id: <1241855134-4984-5-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1241855134-4984-1-git-send-email-petkovbb@gmail.com>
References: <1241855134-4984-1-git-send-email-petkovbb@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is in preparation for removing ide_atapi_pc.

There should be no functional change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-atapi.c        |   12 ++++++------
 drivers/ide/ide-floppy.c       |    4 ++--
 drivers/ide/ide-floppy_ioctl.c |    8 ++++----
 drivers/ide/ide-tape.c         |   26 +++++++++++++-------------
 include/linux/ide.h            |    3 ++-
 5 files changed, 27 insertions(+), 26 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index 1f2af8b..27690f1 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -84,7 +84,7 @@ EXPORT_SYMBOL_GPL(ide_init_pc);
  * and wait for it to be serviced.
  */
 int ide_queue_pc_tail(ide_drive_t *drive, struct gendisk *disk,
-		      struct ide_atapi_pc *pc)
+		      struct ide_atapi_pc *pc, unsigned int bufflen)
 {
 	struct request *rq;
 	int error;
@@ -93,8 +93,8 @@ int ide_queue_pc_tail(ide_drive_t *drive, struct gendisk *disk,
 	rq->cmd_type = REQ_TYPE_SPECIAL;
 	rq->special = (char *)pc;
 
-	if (pc->req_xfer) {
-		error = blk_rq_map_kern(drive->queue, rq, pc->buf, pc->req_xfer,
+	if (bufflen) {
+		error = blk_rq_map_kern(drive->queue, rq, pc->buf, bufflen,
 					GFP_NOIO);
 		if (error)
 			goto put_req;
@@ -117,7 +117,7 @@ int ide_do_test_unit_ready(ide_drive_t *drive, struct gendisk *disk)
 	ide_init_pc(&pc);
 	pc.c[0] = TEST_UNIT_READY;
 
-	return ide_queue_pc_tail(drive, disk, &pc);
+	return ide_queue_pc_tail(drive, disk, &pc, 0);
 }
 EXPORT_SYMBOL_GPL(ide_do_test_unit_ready);
 
@@ -132,7 +132,7 @@ int ide_do_start_stop(ide_drive_t *drive, struct gendisk *disk, int start)
 	if (drive->media == ide_tape)
 		pc.flags |= PC_FLAG_WAIT_FOR_DSC;
 
-	return ide_queue_pc_tail(drive, disk, &pc);
+	return ide_queue_pc_tail(drive, disk, &pc, 0);
 }
 EXPORT_SYMBOL_GPL(ide_do_start_stop);
 
@@ -147,7 +147,7 @@ int ide_set_media_lock(ide_drive_t *drive, struct gendisk *disk, int on)
 	pc.c[0] = ALLOW_MEDIUM_REMOVAL;
 	pc.c[4] = on;
 
-	return ide_queue_pc_tail(drive, disk, &pc);
+	return ide_queue_pc_tail(drive, disk, &pc, 0);
 }
 EXPORT_SYMBOL_GPL(ide_set_media_lock);
 
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index a1c5598..5df00d4 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -318,7 +318,7 @@ static int ide_floppy_get_flexible_disk_page(ide_drive_t *drive,
 
 	ide_floppy_create_mode_sense_cmd(pc, IDEFLOPPY_FLEXIBLE_DISK_PAGE);
 
-	if (ide_queue_pc_tail(drive, disk, pc)) {
+	if (ide_queue_pc_tail(drive, disk, pc, pc->req_xfer)) {
 		printk(KERN_ERR PFX "Can't get flexible disk page params\n");
 		return 1;
 	}
@@ -390,7 +390,7 @@ static int ide_floppy_get_capacity(ide_drive_t *drive)
 	pc.buf = &pc_buf[0];
 	pc.buf_size = sizeof(pc_buf);
 
-	if (ide_queue_pc_tail(drive, disk, &pc)) {
+	if (ide_queue_pc_tail(drive, disk, &pc, pc.req_xfer)) {
 		printk(KERN_ERR PFX "Can't get floppy parameters\n");
 		return 1;
 	}
diff --git a/drivers/ide/ide-floppy_ioctl.c b/drivers/ide/ide-floppy_ioctl.c
index cd8a420..75f1d50 100644
--- a/drivers/ide/ide-floppy_ioctl.c
+++ b/drivers/ide/ide-floppy_ioctl.c
@@ -50,7 +50,7 @@ static int ide_floppy_get_format_capacities(ide_drive_t *drive,
 	pc->buf = &pc_buf[0];
 	pc->buf_size = sizeof(pc_buf);
 
-	if (ide_queue_pc_tail(drive, floppy->disk, pc)) {
+	if (ide_queue_pc_tail(drive, floppy->disk, pc, pc->req_xfer)) {
 		printk(KERN_ERR "ide-floppy: Can't get floppy parameters\n");
 		return -EIO;
 	}
@@ -124,7 +124,7 @@ static int ide_floppy_get_sfrp_bit(ide_drive_t *drive, struct ide_atapi_pc *pc)
 	ide_floppy_create_mode_sense_cmd(pc, IDEFLOPPY_CAPABILITIES_PAGE);
 	pc->flags |= PC_FLAG_SUPPRESS_ERROR;
 
-	if (ide_queue_pc_tail(drive, floppy->disk, pc))
+	if (ide_queue_pc_tail(drive, floppy->disk, pc, pc->req_xfer))
 		return 1;
 
 	if (pc->buf[8 + 2] & 0x40)
@@ -172,7 +172,7 @@ static int ide_floppy_format_unit(ide_drive_t *drive, struct ide_atapi_pc *pc,
 	ide_floppy_get_sfrp_bit(drive, pc);
 	ide_floppy_create_format_unit_cmd(pc, blocks, length, flags);
 
-	if (ide_queue_pc_tail(drive, floppy->disk, pc))
+	if (ide_queue_pc_tail(drive, floppy->disk, pc, pc->req_xfer))
 		err = -EIO;
 
 out:
@@ -200,7 +200,7 @@ static int ide_floppy_get_format_progress(ide_drive_t *drive,
 
 	if (drive->atapi_flags & IDE_AFLAG_SRFP) {
 		ide_create_request_sense_cmd(drive, pc);
-		if (ide_queue_pc_tail(drive, floppy->disk, pc))
+		if (ide_queue_pc_tail(drive, floppy->disk, pc, pc->req_xfer))
 			return -EIO;
 
 		if (floppy->sense_key == 2 &&
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 35c188a..e17fd47 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -769,7 +769,7 @@ static int idetape_flush_tape_buffers(ide_drive_t *drive)
 	int rc;
 
 	idetape_create_write_filemark_cmd(drive, &pc, 0);
-	rc = ide_queue_pc_tail(drive, tape->disk, &pc);
+	rc = ide_queue_pc_tail(drive, tape->disk, &pc, pc.req_xfer);
 	if (rc)
 		return rc;
 	idetape_wait_ready(drive, 60 * 5 * HZ);
@@ -792,7 +792,7 @@ static int idetape_read_position(ide_drive_t *drive)
 	debug_log(DBG_PROCS, "Enter %s\n", __func__);
 
 	idetape_create_read_position_cmd(&pc);
-	if (ide_queue_pc_tail(drive, tape->disk, &pc))
+	if (ide_queue_pc_tail(drive, tape->disk, &pc, pc.req_xfer))
 		return -1;
 	position = tape->first_frame;
 	return position;
@@ -845,12 +845,12 @@ static int idetape_position_tape(ide_drive_t *drive, unsigned int block,
 		__ide_tape_discard_merge_buffer(drive);
 	idetape_wait_ready(drive, 60 * 5 * HZ);
 	idetape_create_locate_cmd(drive, &pc, block, partition, skip);
-	retval = ide_queue_pc_tail(drive, disk, &pc);
+	retval = ide_queue_pc_tail(drive, disk, &pc, pc.req_xfer);
 	if (retval)
 		return (retval);
 
 	idetape_create_read_position_cmd(&pc);
-	return ide_queue_pc_tail(drive, disk, &pc);
+	return ide_queue_pc_tail(drive, disk, &pc, pc.req_xfer);
 }
 
 static void ide_tape_discard_merge_buffer(ide_drive_t *drive,
@@ -1046,12 +1046,12 @@ static int idetape_rewind_tape(ide_drive_t *drive)
 	debug_log(DBG_SENSE, "Enter %s\n", __func__);
 
 	idetape_create_rewind_cmd(drive, &pc);
-	retval = ide_queue_pc_tail(drive, disk, &pc);
+	retval = ide_queue_pc_tail(drive, disk, &pc, pc.req_xfer);
 	if (retval)
 		return retval;
 
 	idetape_create_read_position_cmd(&pc);
-	retval = ide_queue_pc_tail(drive, disk, &pc);
+	retval = ide_queue_pc_tail(drive, disk, &pc, pc.req_xfer);
 	if (retval)
 		return retval;
 	return 0;
@@ -1119,7 +1119,7 @@ static int idetape_space_over_filemarks(ide_drive_t *drive, short mt_op,
 	case MTBSF:
 		idetape_create_space_cmd(&pc, mt_count - count,
 					 IDETAPE_SPACE_OVER_FILEMARK);
-		return ide_queue_pc_tail(drive, disk, &pc);
+		return ide_queue_pc_tail(drive, disk, &pc, pc.req_xfer);
 	case MTFSFM:
 	case MTBSFM:
 		if (!sprev)
@@ -1258,7 +1258,7 @@ static int idetape_write_filemark(ide_drive_t *drive)
 
 	/* Write a filemark */
 	idetape_create_write_filemark_cmd(drive, &pc, 1);
-	if (ide_queue_pc_tail(drive, tape->disk, &pc)) {
+	if (ide_queue_pc_tail(drive, tape->disk, &pc, pc.req_xfer)) {
 		printk(KERN_ERR "ide-tape: Couldn't write a filemark\n");
 		return -EIO;
 	}
@@ -1343,11 +1343,11 @@ static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
 			IDETAPE_LU_RETENSION_MASK | IDETAPE_LU_LOAD_MASK);
 	case MTEOM:
 		idetape_create_space_cmd(&pc, 0, IDETAPE_SPACE_TO_EOD);
-		return ide_queue_pc_tail(drive, disk, &pc);
+		return ide_queue_pc_tail(drive, disk, &pc, pc.req_xfer);
 	case MTERASE:
 		(void)idetape_rewind_tape(drive);
 		idetape_create_erase_cmd(&pc);
-		return ide_queue_pc_tail(drive, disk, &pc);
+		return ide_queue_pc_tail(drive, disk, &pc, pc.req_xfer);
 	case MTSETBLK:
 		if (mt_count) {
 			if (mt_count < tape->blk_size ||
@@ -1456,7 +1456,7 @@ static void ide_tape_get_bsize_from_bdesc(ide_drive_t *drive)
 	struct ide_atapi_pc pc;
 
 	idetape_create_mode_sense_cmd(&pc, IDETAPE_BLOCK_DESCRIPTOR);
-	if (ide_queue_pc_tail(drive, tape->disk, &pc)) {
+	if (ide_queue_pc_tail(drive, tape->disk, &pc, pc.req_xfer)) {
 		printk(KERN_ERR "ide-tape: Can't get block descriptor\n");
 		if (tape->blk_size == 0) {
 			printk(KERN_WARNING "ide-tape: Cannot deal with zero "
@@ -1612,7 +1612,7 @@ static void idetape_get_inquiry_results(ide_drive_t *drive)
 	pc.buf = &pc_buf[0];
 	pc.buf_size = sizeof(pc_buf);
 
-	if (ide_queue_pc_tail(drive, tape->disk, &pc)) {
+	if (ide_queue_pc_tail(drive, tape->disk, &pc, pc.req_xfer)) {
 		printk(KERN_ERR "ide-tape: %s: can't get INQUIRY results\n",
 				tape->name);
 		return;
@@ -1641,7 +1641,7 @@ static void idetape_get_mode_sense_results(ide_drive_t *drive)
 	u8 speed, max_speed;
 
 	idetape_create_mode_sense_cmd(&pc, IDETAPE_CAPABILITIES_PAGE);
-	if (ide_queue_pc_tail(drive, tape->disk, &pc)) {
+	if (ide_queue_pc_tail(drive, tape->disk, &pc, pc.req_xfer)) {
 		printk(KERN_ERR "ide-tape: Can't get tape parameters - assuming"
 				" some default values\n");
 		tape->blk_size = 512;
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 745a393..7e15bd1 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1160,7 +1160,8 @@ enum {
 	REQ_IDETAPE_WRITE	= (1 << 3),
 };
 
-int ide_queue_pc_tail(ide_drive_t *, struct gendisk *, struct ide_atapi_pc *);
+int ide_queue_pc_tail(ide_drive_t *, struct gendisk *, struct ide_atapi_pc *,
+		      unsigned int);
 
 int ide_do_test_unit_ready(ide_drive_t *, struct gendisk *);
 int ide_do_start_stop(ide_drive_t *, struct gendisk *, int);
-- 
1.6.2.4

