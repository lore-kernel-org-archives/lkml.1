Return-Path: <linux-kernel-owner+w=401wt.eu-S1753966AbZEIHuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966AbZEIHuP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 03:50:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752385AbZEIHqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 03:46:06 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:38547 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbZEIHpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 03:45:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=k6t+N4qUPKE1V4TYcfMRv8XD5Zk23onfV5MAPzSeK+/3fyCHjMomvcKiRlQtS4fxGI
         NtmhJNeNoaG2Q2nK7328i504fMBGdFajRAeV1OfRbIAYs36aqHioTCijPJu8CbaFqU/4
         g8mJggOVLGs7uX+1mZD4A5HwjyjKFa3wDM7sM=
From: Borislav Petkov <petkovbb@googlemail.com>
To: <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 05/14] ide-atapi: add a buffer-arg to ide_queue_pc_tail
Date: Sat,  9 May 2009 09:45:25 +0200
Message-Id: <1241855134-4984-6-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1241855134-4984-1-git-send-email-petkovbb@gmail.com>
References: <1241855134-4984-1-git-send-email-petkovbb@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is in preparation of removing ide_atapi_pc. Expose the buffer as an
argument to ide_queue_pc_tail with later replacing it with local buffer
or even kmalloc'ed one if needed due to stack usage constraints.

Also, add the possibility of passing a NULL-ptr buffer for cmds which
don't transfer data besides the cdb.

There should be no functional change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-atapi.c        |   12 ++++++------
 drivers/ide/ide-floppy.c       |   17 ++++++++---------
 drivers/ide/ide-floppy_ioctl.c |   16 ++++++++--------
 drivers/ide/ide-tape.c         |   37 ++++++++++++++++++-------------------
 include/linux/ide.h            |    2 +-
 5 files changed, 41 insertions(+), 43 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index 27690f1..bd59fea 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -84,7 +84,7 @@ EXPORT_SYMBOL_GPL(ide_init_pc);
  * and wait for it to be serviced.
  */
 int ide_queue_pc_tail(ide_drive_t *drive, struct gendisk *disk,
-		      struct ide_atapi_pc *pc, unsigned int bufflen)
+		      struct ide_atapi_pc *pc, void *buf, unsigned int bufflen)
 {
 	struct request *rq;
 	int error;
@@ -93,8 +93,8 @@ int ide_queue_pc_tail(ide_drive_t *drive, struct gendisk *disk,
 	rq->cmd_type = REQ_TYPE_SPECIAL;
 	rq->special = (char *)pc;
 
-	if (bufflen) {
-		error = blk_rq_map_kern(drive->queue, rq, pc->buf, bufflen,
+	if (buf && bufflen) {
+		error = blk_rq_map_kern(drive->queue, rq, buf, bufflen,
 					GFP_NOIO);
 		if (error)
 			goto put_req;
@@ -117,7 +117,7 @@ int ide_do_test_unit_ready(ide_drive_t *drive, struct gendisk *disk)
 	ide_init_pc(&pc);
 	pc.c[0] = TEST_UNIT_READY;
 
-	return ide_queue_pc_tail(drive, disk, &pc, 0);
+	return ide_queue_pc_tail(drive, disk, &pc, NULL, 0);
 }
 EXPORT_SYMBOL_GPL(ide_do_test_unit_ready);
 
@@ -132,7 +132,7 @@ int ide_do_start_stop(ide_drive_t *drive, struct gendisk *disk, int start)
 	if (drive->media == ide_tape)
 		pc.flags |= PC_FLAG_WAIT_FOR_DSC;
 
-	return ide_queue_pc_tail(drive, disk, &pc, 0);
+	return ide_queue_pc_tail(drive, disk, &pc, NULL, 0);
 }
 EXPORT_SYMBOL_GPL(ide_do_start_stop);
 
@@ -147,7 +147,7 @@ int ide_set_media_lock(ide_drive_t *drive, struct gendisk *disk, int on)
 	pc.c[0] = ALLOW_MEDIUM_REMOVAL;
 	pc.c[4] = on;
 
-	return ide_queue_pc_tail(drive, disk, &pc, 0);
+	return ide_queue_pc_tail(drive, disk, &pc, NULL, 0);
 }
 EXPORT_SYMBOL_GPL(ide_set_media_lock);
 
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 5df00d4..be21cf2 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -318,7 +318,7 @@ static int ide_floppy_get_flexible_disk_page(ide_drive_t *drive,
 
 	ide_floppy_create_mode_sense_cmd(pc, IDEFLOPPY_FLEXIBLE_DISK_PAGE);
 
-	if (ide_queue_pc_tail(drive, disk, pc, pc->req_xfer)) {
+	if (ide_queue_pc_tail(drive, disk, pc, pc->buf, pc->req_xfer)) {
 		printk(KERN_ERR PFX "Can't get flexible disk page params\n");
 		return 1;
 	}
@@ -387,22 +387,21 @@ static int ide_floppy_get_capacity(ide_drive_t *drive)
 	drive->capacity64 = 0;
 
 	ide_floppy_create_read_capacity_cmd(&pc);
-	pc.buf = &pc_buf[0];
 	pc.buf_size = sizeof(pc_buf);
 
-	if (ide_queue_pc_tail(drive, disk, &pc, pc.req_xfer)) {
+	if (ide_queue_pc_tail(drive, disk, &pc, pc_buf, pc.req_xfer)) {
 		printk(KERN_ERR PFX "Can't get floppy parameters\n");
 		return 1;
 	}
-	header_len = pc.buf[3];
-	cap_desc = &pc.buf[4];
+	header_len = pc_buf[3];
+	cap_desc = &pc_buf[4];
 	desc_cnt = header_len / 8; /* capacity descriptor of 8 bytes */
 
 	for (i = 0; i < desc_cnt; i++) {
 		unsigned int desc_start = 4 + i*8;
 
-		blocks = be32_to_cpup((__be32 *)&pc.buf[desc_start]);
-		length = be16_to_cpup((__be16 *)&pc.buf[desc_start + 6]);
+		blocks = be32_to_cpup((__be32 *)&pc_buf[desc_start]);
+		length = be16_to_cpup((__be16 *)&pc_buf[desc_start + 6]);
 
 		ide_debug_log(IDE_DBG_PROBE, "Descriptor %d: %dkB, %d blocks, "
 					     "%d sector size",
@@ -415,7 +414,7 @@ static int ide_floppy_get_capacity(ide_drive_t *drive)
 		 * the code below is valid only for the 1st descriptor, ie i=0
 		 */
 
-		switch (pc.buf[desc_start + 4] & 0x03) {
+		switch (pc_buf[desc_start + 4] & 0x03) {
 		/* Clik! drive returns this instead of CAPACITY_CURRENT */
 		case CAPACITY_UNFORMATTED:
 			if (!(drive->atapi_flags & IDE_AFLAG_CLIK_DRIVE))
@@ -464,7 +463,7 @@ static int ide_floppy_get_capacity(ide_drive_t *drive)
 			break;
 		}
 		ide_debug_log(IDE_DBG_PROBE, "Descriptor 0 Code: %d",
-					     pc.buf[desc_start + 4] & 0x03);
+					     pc_buf[desc_start + 4] & 0x03);
 	}
 
 	/* Clik! disk does not support get_flexible_disk_page */
diff --git a/drivers/ide/ide-floppy_ioctl.c b/drivers/ide/ide-floppy_ioctl.c
index 75f1d50..9c2518d 100644
--- a/drivers/ide/ide-floppy_ioctl.c
+++ b/drivers/ide/ide-floppy_ioctl.c
@@ -47,15 +47,14 @@ static int ide_floppy_get_format_capacities(ide_drive_t *drive,
 		return -EINVAL;
 
 	ide_floppy_create_read_capacity_cmd(pc);
-	pc->buf = &pc_buf[0];
 	pc->buf_size = sizeof(pc_buf);
 
-	if (ide_queue_pc_tail(drive, floppy->disk, pc, pc->req_xfer)) {
+	if (ide_queue_pc_tail(drive, floppy->disk, pc, pc_buf, pc->req_xfer)) {
 		printk(KERN_ERR "ide-floppy: Can't get floppy parameters\n");
 		return -EIO;
 	}
 
-	header_len = pc->buf[3];
+	header_len = pc_buf[3];
 	desc_cnt = header_len / 8; /* capacity descriptor of 8 bytes */
 
 	u_index = 0;
@@ -72,8 +71,8 @@ static int ide_floppy_get_format_capacities(ide_drive_t *drive,
 		if (u_index >= u_array_size)
 			break;	/* User-supplied buffer too small */
 
-		blocks = be32_to_cpup((__be32 *)&pc->buf[desc_start]);
-		length = be16_to_cpup((__be16 *)&pc->buf[desc_start + 6]);
+		blocks = be32_to_cpup((__be32 *)&pc_buf[desc_start]);
+		length = be16_to_cpup((__be16 *)&pc_buf[desc_start + 6]);
 
 		if (put_user(blocks, argp))
 			return -EFAULT;
@@ -124,7 +123,7 @@ static int ide_floppy_get_sfrp_bit(ide_drive_t *drive, struct ide_atapi_pc *pc)
 	ide_floppy_create_mode_sense_cmd(pc, IDEFLOPPY_CAPABILITIES_PAGE);
 	pc->flags |= PC_FLAG_SUPPRESS_ERROR;
 
-	if (ide_queue_pc_tail(drive, floppy->disk, pc, pc->req_xfer))
+	if (ide_queue_pc_tail(drive, floppy->disk, pc, pc->buf, pc->req_xfer))
 		return 1;
 
 	if (pc->buf[8 + 2] & 0x40)
@@ -172,7 +171,7 @@ static int ide_floppy_format_unit(ide_drive_t *drive, struct ide_atapi_pc *pc,
 	ide_floppy_get_sfrp_bit(drive, pc);
 	ide_floppy_create_format_unit_cmd(pc, blocks, length, flags);
 
-	if (ide_queue_pc_tail(drive, floppy->disk, pc, pc->req_xfer))
+	if (ide_queue_pc_tail(drive, floppy->disk, pc, pc->buf, pc->req_xfer))
 		err = -EIO;
 
 out:
@@ -200,7 +199,8 @@ static int ide_floppy_get_format_progress(ide_drive_t *drive,
 
 	if (drive->atapi_flags & IDE_AFLAG_SRFP) {
 		ide_create_request_sense_cmd(drive, pc);
-		if (ide_queue_pc_tail(drive, floppy->disk, pc, pc->req_xfer))
+		if (ide_queue_pc_tail(drive, floppy->disk, pc, pc->buf,
+				      pc->req_xfer))
 			return -EIO;
 
 		if (floppy->sense_key == 2 &&
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index e17fd47..7c9e0c7 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -769,7 +769,7 @@ static int idetape_flush_tape_buffers(ide_drive_t *drive)
 	int rc;
 
 	idetape_create_write_filemark_cmd(drive, &pc, 0);
-	rc = ide_queue_pc_tail(drive, tape->disk, &pc, pc.req_xfer);
+	rc = ide_queue_pc_tail(drive, tape->disk, &pc, NULL, 0);
 	if (rc)
 		return rc;
 	idetape_wait_ready(drive, 60 * 5 * HZ);
@@ -792,7 +792,7 @@ static int idetape_read_position(ide_drive_t *drive)
 	debug_log(DBG_PROCS, "Enter %s\n", __func__);
 
 	idetape_create_read_position_cmd(&pc);
-	if (ide_queue_pc_tail(drive, tape->disk, &pc, pc.req_xfer))
+	if (ide_queue_pc_tail(drive, tape->disk, &pc, pc.buf, pc.req_xfer))
 		return -1;
 	position = tape->first_frame;
 	return position;
@@ -845,12 +845,12 @@ static int idetape_position_tape(ide_drive_t *drive, unsigned int block,
 		__ide_tape_discard_merge_buffer(drive);
 	idetape_wait_ready(drive, 60 * 5 * HZ);
 	idetape_create_locate_cmd(drive, &pc, block, partition, skip);
-	retval = ide_queue_pc_tail(drive, disk, &pc, pc.req_xfer);
+	retval = ide_queue_pc_tail(drive, disk, &pc, NULL, 0);
 	if (retval)
 		return (retval);
 
 	idetape_create_read_position_cmd(&pc);
-	return ide_queue_pc_tail(drive, disk, &pc, pc.req_xfer);
+	return ide_queue_pc_tail(drive, disk, &pc, pc.buf, pc.req_xfer);
 }
 
 static void ide_tape_discard_merge_buffer(ide_drive_t *drive,
@@ -1046,12 +1046,12 @@ static int idetape_rewind_tape(ide_drive_t *drive)
 	debug_log(DBG_SENSE, "Enter %s\n", __func__);
 
 	idetape_create_rewind_cmd(drive, &pc);
-	retval = ide_queue_pc_tail(drive, disk, &pc, pc.req_xfer);
+	retval = ide_queue_pc_tail(drive, disk, &pc, NULL, 0);
 	if (retval)
 		return retval;
 
 	idetape_create_read_position_cmd(&pc);
-	retval = ide_queue_pc_tail(drive, disk, &pc, pc.req_xfer);
+	retval = ide_queue_pc_tail(drive, disk, &pc, pc.buf, pc.req_xfer);
 	if (retval)
 		return retval;
 	return 0;
@@ -1119,7 +1119,7 @@ static int idetape_space_over_filemarks(ide_drive_t *drive, short mt_op,
 	case MTBSF:
 		idetape_create_space_cmd(&pc, mt_count - count,
 					 IDETAPE_SPACE_OVER_FILEMARK);
-		return ide_queue_pc_tail(drive, disk, &pc, pc.req_xfer);
+		return ide_queue_pc_tail(drive, disk, &pc, NULL, 0);
 	case MTFSFM:
 	case MTBSFM:
 		if (!sprev)
@@ -1258,7 +1258,7 @@ static int idetape_write_filemark(ide_drive_t *drive)
 
 	/* Write a filemark */
 	idetape_create_write_filemark_cmd(drive, &pc, 1);
-	if (ide_queue_pc_tail(drive, tape->disk, &pc, pc.req_xfer)) {
+	if (ide_queue_pc_tail(drive, tape->disk, &pc, NULL, 0)) {
 		printk(KERN_ERR "ide-tape: Couldn't write a filemark\n");
 		return -EIO;
 	}
@@ -1343,11 +1343,11 @@ static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
 			IDETAPE_LU_RETENSION_MASK | IDETAPE_LU_LOAD_MASK);
 	case MTEOM:
 		idetape_create_space_cmd(&pc, 0, IDETAPE_SPACE_TO_EOD);
-		return ide_queue_pc_tail(drive, disk, &pc, pc.req_xfer);
+		return ide_queue_pc_tail(drive, disk, &pc, NULL, 0);
 	case MTERASE:
 		(void)idetape_rewind_tape(drive);
 		idetape_create_erase_cmd(&pc);
-		return ide_queue_pc_tail(drive, disk, &pc, pc.req_xfer);
+		return ide_queue_pc_tail(drive, disk, &pc, NULL, 0);
 	case MTSETBLK:
 		if (mt_count) {
 			if (mt_count < tape->blk_size ||
@@ -1456,7 +1456,7 @@ static void ide_tape_get_bsize_from_bdesc(ide_drive_t *drive)
 	struct ide_atapi_pc pc;
 
 	idetape_create_mode_sense_cmd(&pc, IDETAPE_BLOCK_DESCRIPTOR);
-	if (ide_queue_pc_tail(drive, tape->disk, &pc, pc.req_xfer)) {
+	if (ide_queue_pc_tail(drive, tape->disk, &pc, pc.buf, pc.req_xfer)) {
 		printk(KERN_ERR "ide-tape: Can't get block descriptor\n");
 		if (tape->blk_size == 0) {
 			printk(KERN_WARNING "ide-tape: Cannot deal with zero "
@@ -1609,17 +1609,16 @@ static void idetape_get_inquiry_results(ide_drive_t *drive)
 	char fw_rev[4], vendor_id[8], product_id[16];
 
 	idetape_create_inquiry_cmd(&pc);
-	pc.buf = &pc_buf[0];
 	pc.buf_size = sizeof(pc_buf);
 
-	if (ide_queue_pc_tail(drive, tape->disk, &pc, pc.req_xfer)) {
+	if (ide_queue_pc_tail(drive, tape->disk, &pc, pc_buf, pc.req_xfer)) {
 		printk(KERN_ERR "ide-tape: %s: can't get INQUIRY results\n",
 				tape->name);
 		return;
 	}
-	memcpy(vendor_id, &pc.buf[8], 8);
-	memcpy(product_id, &pc.buf[16], 16);
-	memcpy(fw_rev, &pc.buf[32], 4);
+	memcpy(vendor_id, &pc_buf[8], 8);
+	memcpy(product_id, &pc_buf[16], 16);
+	memcpy(fw_rev, &pc_buf[32], 4);
 
 	ide_fixstring(vendor_id, 8, 0);
 	ide_fixstring(product_id, 16, 0);
@@ -1637,11 +1636,11 @@ static void idetape_get_mode_sense_results(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	struct ide_atapi_pc pc;
-	u8 *caps;
+	u8 buf[24], *caps;
 	u8 speed, max_speed;
 
 	idetape_create_mode_sense_cmd(&pc, IDETAPE_CAPABILITIES_PAGE);
-	if (ide_queue_pc_tail(drive, tape->disk, &pc, pc.req_xfer)) {
+	if (ide_queue_pc_tail(drive, tape->disk, &pc, buf, pc.req_xfer)) {
 		printk(KERN_ERR "ide-tape: Can't get tape parameters - assuming"
 				" some default values\n");
 		tape->blk_size = 512;
@@ -1650,7 +1649,7 @@ static void idetape_get_mode_sense_results(ide_drive_t *drive)
 		put_unaligned(6*52, (u16 *)&tape->caps[16]);
 		return;
 	}
-	caps = pc.buf + 4 + pc.buf[3];
+	caps = buf + 4 + buf[3];
 
 	/* convert to host order and save for later use */
 	speed = be16_to_cpup((__be16 *)&caps[14]);
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 7e15bd1..4cd7157 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1161,7 +1161,7 @@ enum {
 };
 
 int ide_queue_pc_tail(ide_drive_t *, struct gendisk *, struct ide_atapi_pc *,
-		      unsigned int);
+		      void *, unsigned int);
 
 int ide_do_test_unit_ready(ide_drive_t *, struct gendisk *);
 int ide_do_start_stop(ide_drive_t *, struct gendisk *, int);
-- 
1.6.2.4

