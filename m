Return-Path: <linux-kernel-owner+w=401wt.eu-S1761812AbZEOFO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761812AbZEOFO1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 01:14:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757184AbZEOFLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 01:11:52 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:33282 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755560AbZEOFLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 01:11:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=wsITQ7RPqcnhwZo1hXFrVtgFrOq5xYvTbK/Mh4c2LGpHromQ52IRAgCp7o1nNlSIlV
         Tn71V5bxsFk/b5PlUzQRD9T8AqwWFRutw25JW2broeYlzXrZykJ7upR4Levq6gb5DFgp
         tz/qNsAEBGkFE0u2+zKYgkPxJoCxbZkcniy9U=
From: Borislav Petkov <petkovbb@googlemail.com>
To: <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 12/15] ide-tape: fix READ POSITION cmd handling
Date: Fri, 15 May 2009 07:11:30 +0200
Message-Id: <1242364293-29223-13-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.3
In-Reply-To: <1242364293-29223-1-git-send-email-petkovbb@gmail.com>
References: <1242364293-29223-1-git-send-email-petkovbb@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ide-tape used to issue READ POSITION in several places and the
evaluation of the returned READ POSITION data was done in the
->pc_callback. Convert it to use local buffer and move that
evaluation chunk in the idetape_read_position(). Additionally, fold
idetape_create_read_position_cmd() into it, too, thus concentrating READ
POSITION handling in one method only and making all places call that.

Finally, mv {idetape,ide_tape}_read_position.

There should be no functional change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |  102 +++++++++++++++++++++++-------------------------
 1 files changed, 49 insertions(+), 53 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 1a8c940..ead2734 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -386,30 +386,7 @@ static int ide_tape_callback(ide_drive_t *drive, int dsc)
 			uptodate = 0;
 			err = pc->error;
 		}
-	} else if (pc->c[0] == READ_POSITION && uptodate) {
-		u8 *readpos = pc->buf;
-
-		debug_log(DBG_SENSE, "BOP - %s\n",
-				(readpos[0] & 0x80) ? "Yes" : "No");
-		debug_log(DBG_SENSE, "EOP - %s\n",
-				(readpos[0] & 0x40) ? "Yes" : "No");
-
-		if (readpos[0] & 0x4) {
-			printk(KERN_INFO "ide-tape: Block location is unknown"
-					 "to the tape\n");
-			clear_bit(IDE_AFLAG_ADDRESS_VALID, &drive->atapi_flags);
-			uptodate = 0;
-			err = IDE_DRV_ERROR_GENERAL;
-		} else {
-			debug_log(DBG_SENSE, "Block Location - %u\n",
-					be32_to_cpup((__be32 *)&readpos[4]));
-
-			tape->partition = readpos[1];
-			tape->first_frame = be32_to_cpup((__be32 *)&readpos[4]);
-			set_bit(IDE_AFLAG_ADDRESS_VALID, &drive->atapi_flags);
-		}
 	}
-
 	rq->errors = err;
 
 	return uptodate;
@@ -778,26 +755,44 @@ static int idetape_flush_tape_buffers(ide_drive_t *drive)
 	return 0;
 }
 
-static void idetape_create_read_position_cmd(struct ide_atapi_pc *pc)
-{
-	ide_init_pc(pc);
-	pc->c[0] = READ_POSITION;
-	pc->req_xfer = 20;
-}
-
-static int idetape_read_position(ide_drive_t *drive)
+static int ide_tape_read_position(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	struct ide_atapi_pc pc;
-	int position;
+	u8 buf[20];
 
 	debug_log(DBG_PROCS, "Enter %s\n", __func__);
 
-	idetape_create_read_position_cmd(&pc);
-	if (ide_queue_pc_tail(drive, tape->disk, &pc, pc.buf, pc.req_xfer))
+	/* prep cmd */
+	ide_init_pc(&pc);
+	pc.c[0] = READ_POSITION;
+	pc.req_xfer = 20;
+
+	if (ide_queue_pc_tail(drive, tape->disk, &pc, buf, pc.req_xfer))
 		return -1;
-	position = tape->first_frame;
-	return position;
+
+	if (!pc.error) {
+		debug_log(DBG_SENSE, "BOP - %s\n",
+				(buf[0] & 0x80) ? "Yes" : "No");
+		debug_log(DBG_SENSE, "EOP - %s\n",
+				(buf[0] & 0x40) ? "Yes" : "No");
+
+		if (buf[0] & 0x4) {
+			printk(KERN_INFO "ide-tape: Block location is unknown"
+					 "to the tape\n");
+			clear_bit(IDE_AFLAG_ADDRESS_VALID, &drive->atapi_flags);
+			return -1;
+		} else {
+			debug_log(DBG_SENSE, "Block Location - %u\n",
+					be32_to_cpup((__be32 *)&buf[4]));
+
+			tape->partition = buf[1];
+			tape->first_frame = be32_to_cpup((__be32 *)&buf[4]);
+			set_bit(IDE_AFLAG_ADDRESS_VALID, &drive->atapi_flags);
+		}
+	}
+
+	return tape->first_frame;
 }
 
 static void idetape_create_locate_cmd(ide_drive_t *drive,
@@ -840,19 +835,21 @@ static int idetape_position_tape(ide_drive_t *drive, unsigned int block,
 {
 	idetape_tape_t *tape = drive->driver_data;
 	struct gendisk *disk = tape->disk;
-	int retval;
+	int ret;
 	struct ide_atapi_pc pc;
 
 	if (tape->chrdev_dir == IDETAPE_DIR_READ)
 		__ide_tape_discard_merge_buffer(drive);
 	idetape_wait_ready(drive, 60 * 5 * HZ);
 	idetape_create_locate_cmd(drive, &pc, block, partition, skip);
-	retval = ide_queue_pc_tail(drive, disk, &pc, NULL, 0);
-	if (retval)
-		return (retval);
+	ret = ide_queue_pc_tail(drive, disk, &pc, NULL, 0);
+	if (ret)
+		return ret;
 
-	idetape_create_read_position_cmd(&pc);
-	return ide_queue_pc_tail(drive, disk, &pc, pc.buf, pc.req_xfer);
+	ret = ide_tape_read_position(drive);
+	if (ret < 0)
+		return ret;
+	return 0;
 }
 
 static void ide_tape_discard_merge_buffer(ide_drive_t *drive,
@@ -863,7 +860,7 @@ static void ide_tape_discard_merge_buffer(ide_drive_t *drive,
 
 	__ide_tape_discard_merge_buffer(drive);
 	if (restore_position) {
-		position = idetape_read_position(drive);
+		position = ide_tape_read_position(drive);
 		seek = position > 0 ? position : 0;
 		if (idetape_position_tape(drive, seek, 0, 0)) {
 			printk(KERN_INFO "ide-tape: %s: position_tape failed in"
@@ -1042,20 +1039,19 @@ static int idetape_rewind_tape(ide_drive_t *drive)
 {
 	struct ide_tape_obj *tape = drive->driver_data;
 	struct gendisk *disk = tape->disk;
-	int retval;
 	struct ide_atapi_pc pc;
+	int ret;
 
 	debug_log(DBG_SENSE, "Enter %s\n", __func__);
 
 	idetape_create_rewind_cmd(drive, &pc);
-	retval = ide_queue_pc_tail(drive, disk, &pc, NULL, 0);
-	if (retval)
-		return retval;
+	ret = ide_queue_pc_tail(drive, disk, &pc, NULL, 0);
+	if (ret)
+		return ret;
 
-	idetape_create_read_position_cmd(&pc);
-	retval = ide_queue_pc_tail(drive, disk, &pc, pc.buf, pc.req_xfer);
-	if (retval)
-		return retval;
+	ret = ide_tape_read_position(drive);
+	if (ret < 0)
+		return ret;
 	return 0;
 }
 
@@ -1413,7 +1409,7 @@ static int idetape_chrdev_ioctl(struct inode *inode, struct file *file,
 	if (cmd == MTIOCGET || cmd == MTIOCPOS) {
 		block_offset = tape->valid /
 			(tape->blk_size * tape->user_bs_factor);
-		position = idetape_read_position(drive);
+		position = ide_tape_read_position(drive);
 		if (position < 0)
 			return -EIO;
 	}
@@ -1516,7 +1512,7 @@ static int idetape_chrdev_open(struct inode *inode, struct file *filp)
 		goto out_put_tape;
 	}
 
-	idetape_read_position(drive);
+	ide_tape_read_position(drive);
 	if (!test_bit(IDE_AFLAG_ADDRESS_VALID, &drive->atapi_flags))
 		(void)idetape_rewind_tape(drive);
 
-- 
1.6.3

