Return-Path: <linux-kernel-owner+w=401wt.eu-S1759984AbZFBHFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759984AbZFBHFs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 03:05:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759469AbZFBHFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 03:05:17 -0400
Received: from mail-fx0-f216.google.com ([209.85.220.216]:41835 "EHLO
	mail-fx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758301AbZFBHFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 03:05:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=TXPO89/U36rIjmGkUlAhuvmvk/OzE/mYex05N/lW5VDiCOEMebIUdg7EaEtce5Vw3n
         ntnDh2V5qDhaOuii6W68nt+qj1rWyEJsXwBoB4TjZgQ9iUACM/zoDiCHLRnUL1xMWqqX
         0OV7xb6NCNkSHYn3gA7VIDJOruOKB4shYt7tQ=
From: Borislav Petkov <petkovbb@googlemail.com>
To: <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ide-tape: fix IDE_AFLAG_* atomic accesses
Date: Tue,  2 Jun 2009 09:05:08 +0200
Message-Id: <1243926308-32385-3-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1243926308-32385-1-git-send-email-petkovbb@gmail.com>
References: <1243926308-32385-1-git-send-email-petkovbb@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These flags used to be bit numbers and now are single bits in the
->atapi_flags vector. Use them properly.

Spotted-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |   43 ++++++++++++++++++++++++++-----------------
 1 files changed, 26 insertions(+), 17 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 4ff50cc..a305a88 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -397,7 +397,8 @@ static int ide_tape_callback(ide_drive_t *drive, int dsc)
 		if (readpos[0] & 0x4) {
 			printk(KERN_INFO "ide-tape: Block location is unknown"
 					 "to the tape\n");
-			clear_bit(IDE_AFLAG_ADDRESS_VALID, &drive->atapi_flags);
+			clear_bit(ilog2(IDE_AFLAG_ADDRESS_VALID),
+				  &drive->atapi_flags);
 			uptodate = 0;
 			err = IDE_DRV_ERROR_GENERAL;
 		} else {
@@ -406,7 +407,8 @@ static int ide_tape_callback(ide_drive_t *drive, int dsc)
 
 			tape->partition = readpos[1];
 			tape->first_frame = be32_to_cpup((__be32 *)&readpos[4]);
-			set_bit(IDE_AFLAG_ADDRESS_VALID, &drive->atapi_flags);
+			set_bit(ilog2(IDE_AFLAG_ADDRESS_VALID),
+				&drive->atapi_flags);
 		}
 	}
 
@@ -755,7 +757,7 @@ static int idetape_wait_ready(ide_drive_t *drive, unsigned long timeout)
 	int load_attempted = 0;
 
 	/* Wait for the tape to become ready */
-	set_bit(IDE_AFLAG_MEDIUM_PRESENT, &drive->atapi_flags);
+	set_bit(ilog2(IDE_AFLAG_MEDIUM_PRESENT), &drive->atapi_flags);
 	timeout += jiffies;
 	while (time_before(jiffies, timeout)) {
 		if (ide_do_test_unit_ready(drive, disk) == 0)
@@ -831,7 +833,7 @@ static void __ide_tape_discard_merge_buffer(ide_drive_t *drive)
 	if (tape->chrdev_dir != IDETAPE_DIR_READ)
 		return;
 
-	clear_bit(IDE_AFLAG_FILEMARK, &drive->atapi_flags);
+	clear_bit(ilog2(IDE_AFLAG_FILEMARK), &drive->atapi_flags);
 	tape->valid = 0;
 	if (tape->buf != NULL) {
 		kfree(tape->buf);
@@ -1124,7 +1126,8 @@ static int idetape_space_over_filemarks(ide_drive_t *drive, short mt_op,
 
 	if (tape->chrdev_dir == IDETAPE_DIR_READ) {
 		tape->valid = 0;
-		if (test_and_clear_bit(IDE_AFLAG_FILEMARK, &drive->atapi_flags))
+		if (test_and_clear_bit(ilog2(IDE_AFLAG_FILEMARK),
+				       &drive->atapi_flags))
 			++count;
 		ide_tape_discard_merge_buffer(drive, 0);
 	}
@@ -1179,7 +1182,7 @@ static ssize_t idetape_chrdev_read(struct file *file, char __user *buf,
 	debug_log(DBG_CHRDEV, "Enter %s, count %Zd\n", __func__, count);
 
 	if (tape->chrdev_dir != IDETAPE_DIR_READ) {
-		if (test_bit(IDE_AFLAG_DETECT_BS, &drive->atapi_flags))
+		if (test_bit(ilog2(IDE_AFLAG_DETECT_BS), &drive->atapi_flags))
 			if (count > tape->blk_size &&
 			    (count % tape->blk_size) == 0)
 				tape->user_bs_factor = count / tape->blk_size;
@@ -1195,7 +1198,8 @@ static ssize_t idetape_chrdev_read(struct file *file, char __user *buf,
 		/* refill if staging buffer is empty */
 		if (!tape->valid) {
 			/* If we are at a filemark, nothing more to read */
-			if (test_bit(IDE_AFLAG_FILEMARK, &drive->atapi_flags))
+			if (test_bit(ilog2(IDE_AFLAG_FILEMARK),
+				     &drive->atapi_flags))
 				break;
 			/* read */
 			if (idetape_queue_rw_tail(drive, REQ_IDETAPE_READ,
@@ -1213,7 +1217,7 @@ static ssize_t idetape_chrdev_read(struct file *file, char __user *buf,
 		done += todo;
 	}
 
-	if (!done && test_bit(IDE_AFLAG_FILEMARK, &drive->atapi_flags)) {
+	if (!done && test_bit(ilog2(IDE_AFLAG_FILEMARK), &drive->atapi_flags)) {
 		debug_log(DBG_SENSE, "%s: spacing over filemark\n", tape->name);
 
 		idetape_space_over_filemarks(drive, MTFSF, 1);
@@ -1347,7 +1351,8 @@ static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
 		ide_tape_discard_merge_buffer(drive, 0);
 		retval = ide_do_start_stop(drive, disk, !IDETAPE_LU_LOAD_MASK);
 		if (!retval)
-			clear_bit(IDE_AFLAG_MEDIUM_PRESENT, &drive->atapi_flags);
+			clear_bit(ilog2(IDE_AFLAG_MEDIUM_PRESENT),
+				  &drive->atapi_flags);
 		return retval;
 	case MTNOP:
 		ide_tape_discard_merge_buffer(drive, 0);
@@ -1369,9 +1374,11 @@ static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
 			    mt_count % tape->blk_size)
 				return -EIO;
 			tape->user_bs_factor = mt_count / tape->blk_size;
-			clear_bit(IDE_AFLAG_DETECT_BS, &drive->atapi_flags);
+			clear_bit(ilog2(IDE_AFLAG_DETECT_BS),
+				  &drive->atapi_flags);
 		} else
-			set_bit(IDE_AFLAG_DETECT_BS, &drive->atapi_flags);
+			set_bit(ilog2(IDE_AFLAG_DETECT_BS),
+				&drive->atapi_flags);
 		return 0;
 	case MTSEEK:
 		ide_tape_discard_merge_buffer(drive, 0);
@@ -1516,20 +1523,20 @@ static int idetape_chrdev_open(struct inode *inode, struct file *filp)
 
 	filp->private_data = tape;
 
-	if (test_and_set_bit(IDE_AFLAG_BUSY, &drive->atapi_flags)) {
+	if (test_and_set_bit(ilog2(IDE_AFLAG_BUSY), &drive->atapi_flags)) {
 		retval = -EBUSY;
 		goto out_put_tape;
 	}
 
 	retval = idetape_wait_ready(drive, 60 * HZ);
 	if (retval) {
-		clear_bit(IDE_AFLAG_BUSY, &drive->atapi_flags);
+		clear_bit(ilog2(IDE_AFLAG_BUSY), &drive->atapi_flags);
 		printk(KERN_ERR "ide-tape: %s: drive not ready\n", tape->name);
 		goto out_put_tape;
 	}
 
 	idetape_read_position(drive);
-	if (!test_bit(IDE_AFLAG_ADDRESS_VALID, &drive->atapi_flags))
+	if (!test_bit(ilog2(IDE_AFLAG_ADDRESS_VALID), &drive->atapi_flags))
 		(void)idetape_rewind_tape(drive);
 
 	/* Read block size and write protect status from drive. */
@@ -1545,7 +1552,7 @@ static int idetape_chrdev_open(struct inode *inode, struct file *filp)
 	if (tape->write_prot) {
 		if ((filp->f_flags & O_ACCMODE) == O_WRONLY ||
 		    (filp->f_flags & O_ACCMODE) == O_RDWR) {
-			clear_bit(IDE_AFLAG_BUSY, &drive->atapi_flags);
+			clear_bit(ilog2(IDE_AFLAG_BUSY), &drive->atapi_flags);
 			retval = -EROFS;
 			goto out_put_tape;
 		}
@@ -1602,15 +1609,17 @@ static int idetape_chrdev_release(struct inode *inode, struct file *filp)
 			ide_tape_discard_merge_buffer(drive, 1);
 	}
 
-	if (minor < 128 && test_bit(IDE_AFLAG_MEDIUM_PRESENT, &drive->atapi_flags))
+	if (minor < 128 && test_bit(ilog2(IDE_AFLAG_MEDIUM_PRESENT),
+				    &drive->atapi_flags))
 		(void) idetape_rewind_tape(drive);
+
 	if (tape->chrdev_dir == IDETAPE_DIR_NONE) {
 		if (tape->door_locked == DOOR_LOCKED) {
 			if (!ide_set_media_lock(drive, tape->disk, 0))
 				tape->door_locked = DOOR_UNLOCKED;
 		}
 	}
-	clear_bit(IDE_AFLAG_BUSY, &drive->atapi_flags);
+	clear_bit(ilog2(IDE_AFLAG_BUSY), &drive->atapi_flags);
 	ide_tape_put(tape);
 	unlock_kernel();
 	return 0;
-- 
1.6.3.1

