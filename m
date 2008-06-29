Return-Path: <linux-kernel-owner+w=401wt.eu-S1761567AbYF2LEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761567AbYF2LEc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 07:04:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756042AbYF2K7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 06:59:50 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:56745 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754705AbYF2K7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 06:59:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=OH6JzehLJuy+6BRYEQR0eFADFyfn9BGP29ukH/SoWbcq9HcPEOoyjqovVtqzBhafOD
         aa1OqRqTerY5t9nKvxmEma/liQgH+UlwhELvpELPspSi6YPyaqWpzlTeswSXZ390fa3z
         Esl42GRuEsdZTpDb+yHkykDx8/x+pTo5Cme6k=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 13/16] ide-tape: convert to using the new dev_flags
Date: Sun, 29 Jun 2008 12:59:16 +0200
Message-Id: <1214737159-1078-14-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1214737159-1078-1-git-send-email-petkovbb@gmail.com>
References: <1214737159-1078-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functionality change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |   68 ++++++++++++++++-------------------------------
 1 files changed, 23 insertions(+), 45 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index e60faf3..09d8fc4 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -195,23 +195,6 @@ enum {
 #define IDETAPE_BLOCK_DESCRIPTOR	0
 #define IDETAPE_CAPABILITIES_PAGE	0x2a
 
-/* Tape flag bits values. */
-enum {
-	IDETAPE_FLAG_IGNORE_DSC		= (1 << 0),
-	/* 0 When the tape position is unknown */
-	IDETAPE_FLAG_ADDRESS_VALID	= (1 <<	1),
-	/* Device already opened */
-	IDETAPE_FLAG_BUSY		= (1 << 2),
-	/* Attempt to auto-detect the current user block size */
-	IDETAPE_FLAG_DETECT_BS		= (1 << 3),
-	/* Currently on a filemark */
-	IDETAPE_FLAG_FILEMARK		= (1 << 4),
-	/* DRQ interrupt device */
-	IDETAPE_FLAG_DRQ_INTERRUPT	= (1 << 5),
-	/* 0 = no tape is loaded, so we don't rewind after ejecting */
-	IDETAPE_FLAG_MEDIUM_PRESENT	= (1 << 6),
-};
-
 /*
  * Most of our global data which we need to save even as we leave the driver due
  * to an interrupt or a timer event is stored in the struct defined below.
@@ -312,8 +295,6 @@ typedef struct ide_tape_obj {
 	/* Wasted space in each stage */
 	int excess_bh_size;
 
-	/* Status/Action flags: long for set_bit */
-	unsigned long flags;
 	/* protects the ide-tape queue */
 	spinlock_t lock;
 
@@ -665,7 +646,7 @@ static void ide_tape_callback(ide_drive_t *drive)
 		if (readpos[0] & 0x4) {
 			printk(KERN_INFO "ide-tape: Block location is unknown"
 					 "to the tape\n");
-			clear_bit(IDETAPE_FLAG_ADDRESS_VALID, &tape->flags);
+			clear_bit(IDE_FLAG_ADDRESS_VALID, &drive->dev_flags);
 			uptodate = 0;
 		} else {
 			debug_log(DBG_SENSE, "Block Location - %u\n",
@@ -673,7 +654,7 @@ static void ide_tape_callback(ide_drive_t *drive)
 
 			tape->partition = readpos[1];
 			tape->first_frame = be32_to_cpu(*(u32 *)&readpos[4]);
-			set_bit(IDETAPE_FLAG_ADDRESS_VALID, &tape->flags);
+			set_bit(IDE_FLAG_ADDRESS_VALID, &drive->dev_flags);
 		}
 	}
 
@@ -742,7 +723,6 @@ static void idetape_queue_pc_head(ide_drive_t *drive, struct ide_atapi_pc *pc,
  */
 static void idetape_retry_pc(ide_drive_t *drive)
 {
-	idetape_tape_t *tape = drive->driver_data;
 	struct ide_atapi_pc *pc;
 	struct request *rq;
 
@@ -750,7 +730,7 @@ static void idetape_retry_pc(ide_drive_t *drive)
 	pc = idetape_next_pc_storage(drive);
 	rq = idetape_next_rq_storage(drive);
 	idetape_create_request_sense_cmd(pc);
-	set_bit(IDETAPE_FLAG_IGNORE_DSC, &tape->flags);
+	set_bit(IDE_FLAG_IGNORE_DSC, &drive->dev_flags);
 	idetape_queue_pc_head(drive, pc, rq);
 }
 
@@ -1025,14 +1005,14 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 	stat = ide_read_status(drive);
 
 	if (!drive->dsc_overlap && !(rq->cmd[13] & REQ_IDETAPE_PC2))
-		set_bit(IDETAPE_FLAG_IGNORE_DSC, &tape->flags);
+		set_bit(IDE_FLAG_IGNORE_DSC, &drive->dev_flags);
 
 	if (drive->post_reset == 1) {
-		set_bit(IDETAPE_FLAG_IGNORE_DSC, &tape->flags);
+		set_bit(IDE_FLAG_IGNORE_DSC, &drive->dev_flags);
 		drive->post_reset = 0;
 	}
 
-	if (!test_and_clear_bit(IDETAPE_FLAG_IGNORE_DSC, &tape->flags) &&
+	if (!test_and_clear_bit(IDE_FLAG_IGNORE_DSC, &drive->dev_flags) &&
 	    (stat & SEEK_STAT) == 0) {
 		if (postponed_rq == NULL) {
 			tape->dsc_polling_start = jiffies;
@@ -1075,10 +1055,8 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 		return ide_stopped;
 	}
 	BUG();
-out:
-	if (test_bit(IDETAPE_FLAG_DRQ_INTERRUPT, &tape->flags))
-		pc->flags |= PC_FLAG_DRQ_INTERRUPT;
 
+out:
 	return idetape_issue_pc(drive, pc);
 }
 
@@ -1306,7 +1284,7 @@ static int idetape_wait_ready(ide_drive_t *drive, unsigned long timeout)
 	int load_attempted = 0;
 
 	/* Wait for the tape to become ready */
-	set_bit(IDETAPE_FLAG_MEDIUM_PRESENT, &tape->flags);
+	set_bit(IDE_FLAG_MEDIUM_PRESENT, &drive->dev_flags);
 	timeout += jiffies;
 	while (time_before(jiffies, timeout)) {
 		idetape_create_test_unit_ready_cmd(&pc);
@@ -1399,7 +1377,7 @@ static void __ide_tape_discard_merge_buffer(ide_drive_t *drive)
 	if (tape->chrdev_dir != IDETAPE_DIR_READ)
 		return;
 
-	clear_bit(IDETAPE_FLAG_FILEMARK, &tape->flags);
+	clear_bit(IDE_FLAG_FILEMARK, &drive->dev_flags);
 	tape->merge_bh_size = 0;
 	if (tape->merge_bh != NULL) {
 		ide_tape_kfree_buffer(tape);
@@ -1638,7 +1616,7 @@ static int idetape_add_chrdev_read_request(ide_drive_t *drive, int blocks)
 	debug_log(DBG_PROCS, "Enter %s, %d blocks\n", __func__, blocks);
 
 	/* If we are at a filemark, return a read length of 0 */
-	if (test_bit(IDETAPE_FLAG_FILEMARK, &tape->flags))
+	if (test_bit(IDE_FLAG_FILEMARK, &drive->dev_flags))
 		return 0;
 
 	idetape_init_read(drive);
@@ -1748,7 +1726,7 @@ static int idetape_space_over_filemarks(ide_drive_t *drive, short mt_op,
 
 	if (tape->chrdev_dir == IDETAPE_DIR_READ) {
 		tape->merge_bh_size = 0;
-		if (test_and_clear_bit(IDETAPE_FLAG_FILEMARK, &tape->flags))
+		if (test_and_clear_bit(IDE_FLAG_FILEMARK, &drive->dev_flags))
 			++count;
 		ide_tape_discard_merge_buffer(drive, 0);
 	}
@@ -1803,7 +1781,7 @@ static ssize_t idetape_chrdev_read(struct file *file, char __user *buf,
 	debug_log(DBG_CHRDEV, "Enter %s, count %Zd\n", __func__, count);
 
 	if (tape->chrdev_dir != IDETAPE_DIR_READ) {
-		if (test_bit(IDETAPE_FLAG_DETECT_BS, &tape->flags))
+		if (test_bit(IDE_FLAG_DETECT_BS, &drive->dev_flags))
 			if (count > tape->blk_size &&
 			    (count % tape->blk_size) == 0)
 				tape->user_bs_factor = count / tape->blk_size;
@@ -1843,7 +1821,7 @@ static ssize_t idetape_chrdev_read(struct file *file, char __user *buf,
 		tape->merge_bh_size = bytes_read-temp;
 	}
 finish:
-	if (!actually_read && test_bit(IDETAPE_FLAG_FILEMARK, &tape->flags)) {
+	if (!actually_read && test_bit(IDE_FLAG_FILEMARK, &drive->dev_flags)) {
 		debug_log(DBG_SENSE, "%s: spacing over filemark\n", tape->name);
 
 		idetape_space_over_filemarks(drive, MTFSF, 1);
@@ -2029,7 +2007,7 @@ static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
 					      !IDETAPE_LU_LOAD_MASK);
 		retval = idetape_queue_pc_tail(drive, &pc);
 		if (!retval)
-			clear_bit(IDETAPE_FLAG_MEDIUM_PRESENT, &tape->flags);
+			clear_bit(IDE_FLAG_MEDIUM_PRESENT, &drive->dev_flags);
 		return retval;
 	case MTNOP:
 		ide_tape_discard_merge_buffer(drive, 0);
@@ -2052,9 +2030,9 @@ static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
 			    mt_count % tape->blk_size)
 				return -EIO;
 			tape->user_bs_factor = mt_count / tape->blk_size;
-			clear_bit(IDETAPE_FLAG_DETECT_BS, &tape->flags);
+			clear_bit(IDE_FLAG_DETECT_BS, &drive->dev_flags);
 		} else
-			set_bit(IDETAPE_FLAG_DETECT_BS, &tape->flags);
+			set_bit(IDE_FLAG_DETECT_BS, &drive->dev_flags);
 		return 0;
 	case MTSEEK:
 		ide_tape_discard_merge_buffer(drive, 0);
@@ -2201,20 +2179,20 @@ static int idetape_chrdev_open(struct inode *inode, struct file *filp)
 
 	filp->private_data = tape;
 
-	if (test_and_set_bit(IDETAPE_FLAG_BUSY, &tape->flags)) {
+	if (test_and_set_bit(IDE_FLAG_BUSY, &drive->dev_flags)) {
 		retval = -EBUSY;
 		goto out_put_tape;
 	}
 
 	retval = idetape_wait_ready(drive, 60 * HZ);
 	if (retval) {
-		clear_bit(IDETAPE_FLAG_BUSY, &tape->flags);
+		clear_bit(IDE_FLAG_BUSY, &drive->dev_flags);
 		printk(KERN_ERR "ide-tape: %s: drive not ready\n", tape->name);
 		goto out_put_tape;
 	}
 
 	idetape_read_position(drive);
-	if (!test_bit(IDETAPE_FLAG_ADDRESS_VALID, &tape->flags))
+	if (!test_bit(IDE_FLAG_ADDRESS_VALID, &drive->dev_flags))
 		(void)idetape_rewind_tape(drive);
 
 	/* Read block size and write protect status from drive. */
@@ -2230,7 +2208,7 @@ static int idetape_chrdev_open(struct inode *inode, struct file *filp)
 	if (tape->write_prot) {
 		if ((filp->f_flags & O_ACCMODE) == O_WRONLY ||
 		    (filp->f_flags & O_ACCMODE) == O_RDWR) {
-			clear_bit(IDETAPE_FLAG_BUSY, &tape->flags);
+			clear_bit(IDE_FLAG_BUSY, &drive->dev_flags);
 			retval = -EROFS;
 			goto out_put_tape;
 		}
@@ -2288,7 +2266,7 @@ static int idetape_chrdev_release(struct inode *inode, struct file *filp)
 			ide_tape_discard_merge_buffer(drive, 1);
 	}
 
-	if (minor < 128 && test_bit(IDETAPE_FLAG_MEDIUM_PRESENT, &tape->flags))
+	if (minor < 128 && test_bit(IDE_FLAG_MEDIUM_PRESENT, &drive->dev_flags))
 		(void) idetape_rewind_tape(drive);
 	if (tape->chrdev_dir == IDETAPE_DIR_NONE) {
 		if (tape->door_locked == DOOR_LOCKED) {
@@ -2298,7 +2276,7 @@ static int idetape_chrdev_release(struct inode *inode, struct file *filp)
 			}
 		}
 	}
-	clear_bit(IDETAPE_FLAG_BUSY, &tape->flags);
+	clear_bit(IDE_FLAG_BUSY, &drive->dev_flags);
 	ide_tape_put(tape);
 	unlock_kernel();
 	return 0;
@@ -2483,7 +2461,7 @@ static void idetape_setup(ide_drive_t *drive, idetape_tape_t *tape, int minor)
 
 	/* Command packet DRQ type */
 	if (((gcw[0] & 0x60) >> 5) == 1)
-		set_bit(IDETAPE_FLAG_DRQ_INTERRUPT, &tape->flags);
+		set_bit(IDE_FLAG_DRQ_INTERRUPT, &drive->dev_flags);
 
 	idetape_get_inquiry_results(drive);
 	idetape_get_mode_sense_results(drive);
-- 
1.5.5.4

