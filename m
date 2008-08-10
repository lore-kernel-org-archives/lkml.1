Return-Path: <linux-kernel-owner+w=401wt.eu-S1755813AbYHJPk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813AbYHJPk4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 11:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756012AbYHJPik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 11:38:40 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:3925 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755824AbYHJPig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 11:38:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=KN8urgC+mBQbnW0XsPLFis0060+96HfEUd9FrSabCpHoejXjN+X1hlTFIZOydp7RMd
         H+vJB80tcLmSQplQhxVFtbkJPqH2ShtTB94q4yAC8aMiikskXlnxirsqYgsN3w4qczr3
         9tFmxcsC8zrEpvzvpORir/JuIEG3vkHW6qTzc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 10 Aug 2008 17:36:23 +0200
Message-Id: <20080810153623.16255.96138.sendpatchset@localhost.localdomain>
In-Reply-To: <20080810153527.16255.2504.sendpatchset@localhost.localdomain>
References: <20080810153527.16255.2504.sendpatchset@localhost.localdomain>
Subject: [PATCH 08/22] ide: add ide_queue_pc_tail() helper
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Add ide_queue_pc_tail() and convert ide-{floppy,tape}.c to use it
  instead of ide*_queue_pc_tail().

* Remove no longer used ide*_queue_pc_tail().

There should be no functional changes caused by this patch.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-atapi.c  |   23 +++++++++++++++
 drivers/ide/ide-floppy.c |   49 +++++++++++----------------------
 drivers/ide/ide-tape.c   |   69 +++++++++++++++++++----------------------------
 include/linux/ide.h      |    1 
 4 files changed, 69 insertions(+), 73 deletions(-)

Index: b/drivers/ide/ide-atapi.c
===================================================================
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -139,6 +139,29 @@ void ide_queue_pc_head(ide_drive_t *driv
 }
 EXPORT_SYMBOL_GPL(ide_queue_pc_head);
 
+/*
+ * Add a special packet command request to the tail of the request queue,
+ * and wait for it to be serviced.
+ */
+int ide_queue_pc_tail(ide_drive_t *drive, struct gendisk *disk,
+		      struct ide_atapi_pc *pc)
+{
+	struct request *rq;
+	int error;
+
+	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
+	rq->cmd_type = REQ_TYPE_SPECIAL;
+	rq->buffer = (char *)pc;
+	memcpy(rq->cmd, pc->c, 12);
+	if (drive->media == ide_tape)
+		rq->cmd[13] = REQ_IDETAPE_PC1;
+	error = blk_execute_rq(drive->queue, disk, rq, 0);
+	blk_put_request(rq);
+
+	return error;
+}
+EXPORT_SYMBOL_GPL(ide_queue_pc_tail);
+
 /* TODO: unify the code thus making some arguments go away */
 ide_startstop_t ide_pc_intr(ide_drive_t *drive, struct ide_atapi_pc *pc,
 	ide_handler_t *handler, unsigned int timeout, ide_expiry_t *expiry,
Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -553,32 +553,13 @@ static ide_startstop_t idefloppy_do_requ
 }
 
 /*
- * Add a special packet command request to the tail of the request queue,
- * and wait for it to be serviced.
- */
-static int idefloppy_queue_pc_tail(ide_drive_t *drive, struct ide_atapi_pc *pc)
-{
-	struct ide_floppy_obj *floppy = drive->driver_data;
-	struct request *rq;
-	int error;
-
-	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
-	rq->buffer = (char *) pc;
-	rq->cmd_type = REQ_TYPE_SPECIAL;
-	memcpy(rq->cmd, pc->c, 12);
-	error = blk_execute_rq(drive->queue, floppy->disk, rq, 0);
-	blk_put_request(rq);
-
-	return error;
-}
-
-/*
  * Look at the flexible disk page parameters. We ignore the CHS capacity
  * parameters and use the LBA parameters instead.
  */
 static int ide_floppy_get_flexible_disk_page(ide_drive_t *drive)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
+	struct gendisk *disk = floppy->disk;
 	struct ide_atapi_pc pc;
 	u8 *page;
 	int capacity, lba_capacity;
@@ -587,13 +568,13 @@ static int ide_floppy_get_flexible_disk_
 
 	idefloppy_create_mode_sense_cmd(&pc, IDEFLOPPY_FLEXIBLE_DISK_PAGE);
 
-	if (idefloppy_queue_pc_tail(drive, &pc)) {
+	if (ide_queue_pc_tail(drive, disk, &pc)) {
 		printk(KERN_ERR "ide-floppy: Can't get flexible disk page"
 				" parameters\n");
 		return 1;
 	}
 	floppy->wp = !!(pc.buf[3] & 0x80);
-	set_disk_ro(floppy->disk, floppy->wp);
+	set_disk_ro(disk, floppy->wp);
 	page = &pc.buf[8];
 
 	transfer_rate = be16_to_cpup((__be16 *)&pc.buf[8 + 2]);
@@ -637,7 +618,7 @@ static int idefloppy_get_sfrp_bit(ide_dr
 	idefloppy_create_mode_sense_cmd(&pc, IDEFLOPPY_CAPABILITIES_PAGE);
 	pc.flags |= PC_FLAG_SUPPRESS_ERROR;
 
-	if (idefloppy_queue_pc_tail(drive, &pc))
+	if (ide_queue_pc_tail(drive, floppy->disk, &pc))
 		return 1;
 
 	floppy->srfp = pc.buf[8 + 2] & 0x40;
@@ -651,6 +632,7 @@ static int idefloppy_get_sfrp_bit(ide_dr
 static int ide_floppy_get_capacity(ide_drive_t *drive)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
+	struct gendisk *disk = floppy->disk;
 	struct ide_atapi_pc pc;
 	u8 *cap_desc;
 	u8 header_len, desc_cnt;
@@ -663,7 +645,7 @@ static int ide_floppy_get_capacity(ide_d
 	set_capacity(floppy->disk, 0);
 
 	idefloppy_create_read_capacity_cmd(&pc);
-	if (idefloppy_queue_pc_tail(drive, &pc)) {
+	if (ide_queue_pc_tail(drive, disk, &pc)) {
 		printk(KERN_ERR "ide-floppy: Can't get floppy parameters\n");
 		return 1;
 	}
@@ -738,7 +720,8 @@ static int ide_floppy_get_capacity(ide_d
 	if (!(drive->atapi_flags & IDE_AFLAG_CLIK_DRIVE))
 		(void) ide_floppy_get_flexible_disk_page(drive);
 
-	set_capacity(floppy->disk, floppy->blocks * floppy->bs_factor);
+	set_capacity(disk, floppy->blocks * floppy->bs_factor);
+
 	return rc;
 }
 
@@ -763,6 +746,7 @@ static int ide_floppy_get_capacity(ide_d
 
 static int ide_floppy_get_format_capacities(ide_drive_t *drive, int __user *arg)
 {
+	struct ide_floppy_obj *floppy = drive->driver_data;
 	struct ide_atapi_pc pc;
 	u8 header_len, desc_cnt;
 	int i, blocks, length, u_array_size, u_index;
@@ -775,7 +759,7 @@ static int ide_floppy_get_format_capacit
 		return -EINVAL;
 
 	idefloppy_create_read_capacity_cmd(&pc);
-	if (idefloppy_queue_pc_tail(drive, &pc)) {
+	if (ide_queue_pc_tail(drive, floppy->disk, &pc)) {
 		printk(KERN_ERR "ide-floppy: Can't get floppy parameters\n");
 		return -EIO;
 	}
@@ -837,7 +821,7 @@ static int ide_floppy_get_format_progres
 
 	if (floppy->srfp) {
 		idefloppy_create_request_sense_cmd(&pc);
-		if (idefloppy_queue_pc_tail(drive, &pc))
+		if (ide_queue_pc_tail(drive, floppy->disk, &pc))
 			return -EIO;
 
 		if (floppy->sense_key == 2 &&
@@ -1007,12 +991,13 @@ static ide_driver_t idefloppy_driver = {
 
 static void ide_floppy_set_media_lock(ide_drive_t *drive, int on)
 {
+	struct ide_floppy_obj *floppy = drive->driver_data;
 	struct ide_atapi_pc pc;
 
 	/* IOMEGA Clik! drives do not support lock/unlock commands */
 	if ((drive->atapi_flags & IDE_AFLAG_CLIK_DRIVE) == 0) {
 		idefloppy_create_prevent_cmd(&pc, on);
-		(void)idefloppy_queue_pc_tail(drive, &pc);
+		(void)ide_queue_pc_tail(drive, floppy->disk, &pc);
 	}
 }
 
@@ -1041,9 +1026,9 @@ static int idefloppy_open(struct inode *
 		ide_init_pc(&pc);
 		pc.c[0] = GPCMD_TEST_UNIT_READY;
 
-		if (idefloppy_queue_pc_tail(drive, &pc)) {
+		if (ide_queue_pc_tail(drive, disk, &pc)) {
 			idefloppy_create_start_stop_cmd(&pc, 1);
-			(void) idefloppy_queue_pc_tail(drive, &pc);
+			(void)ide_queue_pc_tail(drive, disk, &pc);
 		}
 
 		if (ide_floppy_get_capacity(drive)
@@ -1122,7 +1107,7 @@ static int ide_floppy_lockdoor(ide_drive
 
 	if (cmd == CDROMEJECT) {
 		idefloppy_create_start_stop_cmd(pc, 2);
-		(void) idefloppy_queue_pc_tail(floppy->drive, pc);
+		(void)ide_queue_pc_tail(drive, floppy->disk, pc);
 	}
 
 	return 0;
@@ -1167,7 +1152,7 @@ static int ide_floppy_format_unit(ide_dr
 	(void) idefloppy_get_sfrp_bit(drive);
 	idefloppy_create_format_unit_cmd(&pc, blocks, length, flags);
 
-	if (idefloppy_queue_pc_tail(drive, &pc))
+	if (ide_queue_pc_tail(drive, floppy->disk, &pc))
 		err = -EIO;
 
 out:
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -1124,26 +1124,6 @@ static void idetape_create_test_unit_rea
 	pc->c[0] = TEST_UNIT_READY;
 }
 
-/*
- * We add a special packet command request to the tail of the request queue, and
- * wait for it to be serviced.
- */
-static int idetape_queue_pc_tail(ide_drive_t *drive, struct ide_atapi_pc *pc)
-{
-	struct ide_tape_obj *tape = drive->driver_data;
-	struct request *rq;
-	int error;
-
-	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
-	rq->cmd_type = REQ_TYPE_SPECIAL;
-	rq->cmd[13] = REQ_IDETAPE_PC1;
-	rq->buffer = (char *)pc;
-	memcpy(rq->cmd, pc->c, 12);
-	error = blk_execute_rq(drive->queue, tape->disk, rq, 0);
-	blk_put_request(rq);
-	return error;
-}
-
 static void idetape_create_load_unload_cmd(ide_drive_t *drive,
 		struct ide_atapi_pc *pc, int cmd)
 {
@@ -1156,6 +1136,7 @@ static void idetape_create_load_unload_c
 static int idetape_wait_ready(ide_drive_t *drive, unsigned long timeout)
 {
 	idetape_tape_t *tape = drive->driver_data;
+	struct gendisk *disk = tape->disk;
 	struct ide_atapi_pc pc;
 	int load_attempted = 0;
 
@@ -1164,7 +1145,7 @@ static int idetape_wait_ready(ide_drive_
 	timeout += jiffies;
 	while (time_before(jiffies, timeout)) {
 		idetape_create_test_unit_ready_cmd(&pc);
-		if (!idetape_queue_pc_tail(drive, &pc))
+		if (!ide_queue_pc_tail(drive, disk, &pc))
 			return 0;
 		if ((tape->sense_key == 2 && tape->asc == 4 && tape->ascq == 2)
 		    || (tape->asc == 0x3A)) {
@@ -1173,7 +1154,7 @@ static int idetape_wait_ready(ide_drive_
 				return -ENOMEDIUM;
 			idetape_create_load_unload_cmd(drive, &pc,
 							IDETAPE_LU_LOAD_MASK);
-			idetape_queue_pc_tail(drive, &pc);
+			ide_queue_pc_tail(drive, disk, &pc);
 			load_attempted = 1;
 		/* not about to be ready */
 		} else if (!(tape->sense_key == 2 && tape->asc == 4 &&
@@ -1186,11 +1167,12 @@ static int idetape_wait_ready(ide_drive_
 
 static int idetape_flush_tape_buffers(ide_drive_t *drive)
 {
+	struct ide_tape_obj *tape = drive->driver_data;
 	struct ide_atapi_pc pc;
 	int rc;
 
 	idetape_create_write_filemark_cmd(drive, &pc, 0);
-	rc = idetape_queue_pc_tail(drive, &pc);
+	rc = ide_queue_pc_tail(drive, tape->disk, &pc);
 	if (rc)
 		return rc;
 	idetape_wait_ready(drive, 60 * 5 * HZ);
@@ -1213,7 +1195,7 @@ static int idetape_read_position(ide_dri
 	debug_log(DBG_PROCS, "Enter %s\n", __func__);
 
 	idetape_create_read_position_cmd(&pc);
-	if (idetape_queue_pc_tail(drive, &pc))
+	if (ide_queue_pc_tail(drive, tape->disk, &pc))
 		return -1;
 	position = tape->first_frame;
 	return position;
@@ -1248,12 +1230,13 @@ static int idetape_create_prevent_cmd(id
 
 static int ide_tape_set_media_lock(ide_drive_t *drive, int on)
 {
+	struct ide_tape_obj *tape = drive->driver_data;
 	struct ide_atapi_pc pc;
 
 	if (!idetape_create_prevent_cmd(drive, &pc, on))
 		return 0;
 
-	return idetape_queue_pc_tail(drive, &pc);
+	return ide_queue_pc_tail(drive, tape->disk, &pc);
 }
 
 static void __ide_tape_discard_merge_buffer(ide_drive_t *drive)
@@ -1283,6 +1266,7 @@ static int idetape_position_tape(ide_dri
 		u8 partition, int skip)
 {
 	idetape_tape_t *tape = drive->driver_data;
+	struct gendisk *disk = tape->disk;
 	int retval;
 	struct ide_atapi_pc pc;
 
@@ -1290,12 +1274,12 @@ static int idetape_position_tape(ide_dri
 		__ide_tape_discard_merge_buffer(drive);
 	idetape_wait_ready(drive, 60 * 5 * HZ);
 	idetape_create_locate_cmd(drive, &pc, block, partition, skip);
-	retval = idetape_queue_pc_tail(drive, &pc);
+	retval = ide_queue_pc_tail(drive, disk, &pc);
 	if (retval)
 		return (retval);
 
 	idetape_create_read_position_cmd(&pc);
-	return (idetape_queue_pc_tail(drive, &pc));
+	return ide_queue_pc_tail(drive, disk, &pc);
 }
 
 static void ide_tape_discard_merge_buffer(ide_drive_t *drive,
@@ -1542,20 +1526,20 @@ static void idetape_pad_zeros(ide_drive_
  */
 static int idetape_rewind_tape(ide_drive_t *drive)
 {
+	struct ide_tape_obj *tape = drive->driver_data;
+	struct gendisk *disk = tape->disk;
 	int retval;
 	struct ide_atapi_pc pc;
-	idetape_tape_t *tape;
-	tape = drive->driver_data;
 
 	debug_log(DBG_SENSE, "Enter %s\n", __func__);
 
 	idetape_create_rewind_cmd(drive, &pc);
-	retval = idetape_queue_pc_tail(drive, &pc);
+	retval = ide_queue_pc_tail(drive, disk, &pc);
 	if (retval)
 		return retval;
 
 	idetape_create_read_position_cmd(&pc);
-	retval = idetape_queue_pc_tail(drive, &pc);
+	retval = ide_queue_pc_tail(drive, disk, &pc);
 	if (retval)
 		return retval;
 	return 0;
@@ -1598,6 +1582,7 @@ static int idetape_space_over_filemarks(
 					int mt_count)
 {
 	idetape_tape_t *tape = drive->driver_data;
+	struct gendisk *disk = tape->disk;
 	struct ide_atapi_pc pc;
 	int retval, count = 0;
 	int sprev = !!(tape->caps[4] & 0x20);
@@ -1622,7 +1607,7 @@ static int idetape_space_over_filemarks(
 	case MTBSF:
 		idetape_create_space_cmd(&pc, mt_count - count,
 					 IDETAPE_SPACE_OVER_FILEMARK);
-		return idetape_queue_pc_tail(drive, &pc);
+		return ide_queue_pc_tail(drive, disk, &pc);
 	case MTFSFM:
 	case MTBSFM:
 		if (!sprev)
@@ -1811,11 +1796,12 @@ static ssize_t idetape_chrdev_write(stru
 
 static int idetape_write_filemark(ide_drive_t *drive)
 {
+	struct ide_tape_obj *tape = drive->driver_data;
 	struct ide_atapi_pc pc;
 
 	/* Write a filemark */
 	idetape_create_write_filemark_cmd(drive, &pc, 1);
-	if (idetape_queue_pc_tail(drive, &pc)) {
+	if (ide_queue_pc_tail(drive, tape->disk, &pc)) {
 		printk(KERN_ERR "ide-tape: Couldn't write a filemark\n");
 		return -EIO;
 	}
@@ -1838,6 +1824,7 @@ static int idetape_write_filemark(ide_dr
 static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
 {
 	idetape_tape_t *tape = drive->driver_data;
+	struct gendisk *disk = tape->disk;
 	struct ide_atapi_pc pc;
 	int i, retval;
 
@@ -1876,7 +1863,7 @@ static int idetape_mtioctop(ide_drive_t 
 		ide_tape_discard_merge_buffer(drive, 0);
 		idetape_create_load_unload_cmd(drive, &pc,
 					       IDETAPE_LU_LOAD_MASK);
-		return idetape_queue_pc_tail(drive, &pc);
+		return ide_queue_pc_tail(drive, disk, &pc);
 	case MTUNLOAD:
 	case MTOFFL:
 		/*
@@ -1890,7 +1877,7 @@ static int idetape_mtioctop(ide_drive_t 
 		ide_tape_discard_merge_buffer(drive, 0);
 		idetape_create_load_unload_cmd(drive, &pc,
 					      !IDETAPE_LU_LOAD_MASK);
-		retval = idetape_queue_pc_tail(drive, &pc);
+		retval = ide_queue_pc_tail(drive, disk, &pc);
 		if (!retval)
 			clear_bit(IDE_AFLAG_MEDIUM_PRESENT, &drive->atapi_flags);
 		return retval;
@@ -1901,14 +1888,14 @@ static int idetape_mtioctop(ide_drive_t 
 		ide_tape_discard_merge_buffer(drive, 0);
 		idetape_create_load_unload_cmd(drive, &pc,
 			IDETAPE_LU_RETENSION_MASK | IDETAPE_LU_LOAD_MASK);
-		return idetape_queue_pc_tail(drive, &pc);
+		return ide_queue_pc_tail(drive, disk, &pc);
 	case MTEOM:
 		idetape_create_space_cmd(&pc, 0, IDETAPE_SPACE_TO_EOD);
-		return idetape_queue_pc_tail(drive, &pc);
+		return ide_queue_pc_tail(drive, disk, &pc);
 	case MTERASE:
 		(void)idetape_rewind_tape(drive);
 		idetape_create_erase_cmd(&pc);
-		return idetape_queue_pc_tail(drive, &pc);
+		return ide_queue_pc_tail(drive, disk, &pc);
 	case MTSETBLK:
 		if (mt_count) {
 			if (mt_count < tape->blk_size ||
@@ -2017,7 +2004,7 @@ static void ide_tape_get_bsize_from_bdes
 	struct ide_atapi_pc pc;
 
 	idetape_create_mode_sense_cmd(&pc, IDETAPE_BLOCK_DESCRIPTOR);
-	if (idetape_queue_pc_tail(drive, &pc)) {
+	if (ide_queue_pc_tail(drive, tape->disk, &pc)) {
 		printk(KERN_ERR "ide-tape: Can't get block descriptor\n");
 		if (tape->blk_size == 0) {
 			printk(KERN_WARNING "ide-tape: Cannot deal with zero "
@@ -2169,7 +2156,7 @@ static void idetape_get_inquiry_results(
 	char fw_rev[6], vendor_id[10], product_id[18];
 
 	idetape_create_inquiry_cmd(&pc);
-	if (idetape_queue_pc_tail(drive, &pc)) {
+	if (ide_queue_pc_tail(drive, tape->disk, &pc)) {
 		printk(KERN_ERR "ide-tape: %s: can't get INQUIRY results\n",
 				tape->name);
 		return;
@@ -2198,7 +2185,7 @@ static void idetape_get_mode_sense_resul
 	u8 speed, max_speed;
 
 	idetape_create_mode_sense_cmd(&pc, IDETAPE_CAPABILITIES_PAGE);
-	if (idetape_queue_pc_tail(drive, &pc)) {
+	if (ide_queue_pc_tail(drive, tape->disk, &pc)) {
 		printk(KERN_ERR "ide-tape: Can't get tape parameters - assuming"
 				" some default values\n");
 		tape->blk_size = 512;
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1134,6 +1134,7 @@ enum {
 
 void ide_queue_pc_head(ide_drive_t *, struct gendisk *, struct ide_atapi_pc *,
 		       struct request *);
+int ide_queue_pc_tail(ide_drive_t *, struct gendisk *, struct ide_atapi_pc *);
 
 ide_startstop_t ide_pc_intr(ide_drive_t *drive, struct ide_atapi_pc *pc,
 	ide_handler_t *handler, unsigned int timeout, ide_expiry_t *expiry,
