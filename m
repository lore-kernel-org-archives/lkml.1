Return-Path: <linux-kernel-owner+w=401wt.eu-S932110AbZGOPSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110AbZGOPSg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 11:18:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932076AbZGOPSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 11:18:31 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:10206 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191AbZGOPS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 11:18:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=qVGNRe9znVbV7MkSEohdS/OU7zUmjPcIGEwYujxhAbk/1VaGDM76fWOPHi6RXTm0xU
         zkfOOaztMqH+fKRLGQo9ju9NhIOw8RYUOBU4HCfkqWV0LxLGtI6w6dWZdvKhOfo08zAF
         gW0WhsmHgXsMql8eif0dm9HCs8E1aWCF370QA=
From: Borislav Petkov <petkovbb@googlemail.com>
To: <davem@davemloft.net>
Cc: <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] ide-tape: use PFX to all printks
Date: Wed, 15 Jul 2009 17:18:18 +0200
Message-Id: <1247671100-8173-3-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1247671100-8173-1-git-send-email-petkovbb@gmail.com>
References: <1247671100-8173-1-git-send-email-petkovbb@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functional change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |   95 ++++++++++++++++++++++++------------------------
 1 files changed, 47 insertions(+), 48 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 60d5c41..db05a95 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -16,6 +16,7 @@
  */
 
 #define DRV_NAME "ide-tape"
+#define PFX DRV_NAME ": "
 
 #define IDETAPE_VERSION "1.20"
 
@@ -356,8 +357,8 @@ static int ide_tape_callback(ide_drive_t *drive, int dsc)
 		if (uptodate)
 			idetape_analyze_error(drive);
 		else
-			printk(KERN_ERR "ide-tape: Error in REQUEST SENSE "
-					"itself - Aborting request!\n");
+			printk(KERN_ERR PFX "Error in REQUEST SENSE itself -  "
+			       "Aborting request!\n");
 	} else if (pc->c[0] == READ_6 || pc->c[0] == WRITE_6) {
 		unsigned int blocks =
 			(blk_rq_bytes(rq) - rq->resid_len) / tape->blk_size;
@@ -472,9 +473,9 @@ static ide_startstop_t ide_tape_issue_pc(ide_drive_t *drive,
 			if (!(pc->c[0] == TEST_UNIT_READY &&
 			      tape->sense_key == 2 && tape->asc == 4 &&
 			     (tape->ascq == 1 || tape->ascq == 8))) {
-				printk(KERN_ERR "ide-tape: %s: I/O error, "
-						"pc = %2x, key = %2x, "
-						"asc = %2x, ascq = %2x\n",
+				printk(KERN_ERR PFX "%s: I/O error, pc = %2x, "
+						"key = %2x, asc = %2x, "
+						"ascq = %2x\n",
 						tape->name, pc->c[0],
 						tape->sense_key, tape->asc,
 						tape->ascq);
@@ -535,8 +536,8 @@ static ide_startstop_t idetape_media_access_finished(ide_drive_t *drive)
 		if (stat & ATA_ERR) {
 			/* Error detected */
 			if (pc->c[0] != TEST_UNIT_READY)
-				printk(KERN_ERR "ide-tape: %s: I/O error, ",
-						tape->name);
+				printk(KERN_ERR PFX "%s: I/O error, ",
+				       tape->name);
 			/* Retry operation */
 			ide_retry_pc(drive);
 			return ide_stopped;
@@ -596,8 +597,9 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 
 	if (postponed_rq != NULL)
 		if (rq != postponed_rq) {
-			printk(KERN_ERR "ide-tape: ide-tape.c bug - "
-					"Two DSC requests were queued\n");
+			printk(KERN_ERR PFX "%s: BUG: Two DSC requests "
+					    "queued!\n",
+					    tape->name);
 			drive->failed_pc = NULL;
 			rq->errors = 0;
 			ide_complete_rq(drive, 0, blk_rq_bytes(rq));
@@ -628,8 +630,8 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 			tape->dsc_poll_freq = tape->best_dsc_rw_freq;
 			tape->dsc_timeout = jiffies + IDETAPE_DSC_RW_TIMEOUT;
 		} else if (time_after(jiffies, tape->dsc_timeout)) {
-			printk(KERN_ERR "ide-tape: %s: DSC timeout\n",
-				tape->name);
+			printk(KERN_ERR PFX "%s: DSC timeout\n", tape->name);
+
 			if (rq->cmd[13] & REQ_IDETAPE_PC2) {
 				idetape_media_access_finished(drive);
 				return ide_stopped;
@@ -762,8 +764,8 @@ static int ide_tape_read_position(ide_drive_t *drive)
 				(buf[0] & 0x40) ? "Yes" : "No");
 
 		if (buf[0] & 0x4) {
-			printk(KERN_INFO "ide-tape: Block location is unknown"
-					 "to the tape\n");
+			printk(KERN_INFO PFX "%s: Block location unknown\n",
+			       tape->name);
 			clear_bit(ilog2(IDE_AFLAG_ADDRESS_VALID),
 				  &drive->atapi_flags);
 			return -1;
@@ -849,8 +851,8 @@ static void ide_tape_discard_merge_buffer(ide_drive_t *drive,
 		position = ide_tape_read_position(drive);
 		seek = position > 0 ? position : 0;
 		if (idetape_position_tape(drive, seek, 0, 0)) {
-			printk(KERN_INFO "ide-tape: %s: position_tape failed in"
-					 " %s\n", tape->name, __func__);
+			printk(KERN_INFO PFX "position_tape failed in %s\n",
+			       tape->name);
 			return;
 		}
 	}
@@ -939,8 +941,8 @@ static void ide_tape_flush_merge_buffer(ide_drive_t *drive)
 	idetape_tape_t *tape = drive->driver_data;
 
 	if (tape->chrdev_dir != IDETAPE_DIR_WRITE) {
-		printk(KERN_ERR "ide-tape: bug: Trying to empty merge buffer"
-				" but we are not writing.\n");
+		printk(KERN_ERR PFX "BUG: Trying to empty merge buffer"
+			" but we are not writing.\n");
 		return;
 	}
 	if (tape->buf) {
@@ -972,7 +974,7 @@ static int idetape_init_rw(ide_drive_t *drive, int dir)
 	}
 
 	if (tape->buf || tape->valid) {
-		printk(KERN_ERR "ide-tape: valid should be 0 now\n");
+		printk(KERN_ERR PFX "valid should be 0 now\n");
 		tape->valid = 0;
 	}
 
@@ -1117,7 +1119,7 @@ static int idetape_space_over_filemarks(ide_drive_t *drive, short mt_op,
 		count = (MTBSFM == mt_op ? 1 : -1);
 		return idetape_space_over_filemarks(drive, MTFSF, count);
 	default:
-		printk(KERN_ERR "ide-tape: MTIO operation %d not supported\n",
+		printk(KERN_ERR PFX "MTIO operation %d not supported\n",
 				mt_op);
 		return -EIO;
 	}
@@ -1246,7 +1248,7 @@ static int idetape_write_filemark(ide_drive_t *drive)
 	/* Write a filemark */
 	idetape_create_write_filemark_cmd(drive, &pc, 1);
 	if (ide_queue_pc_tail(drive, tape->disk, &pc, NULL, 0)) {
-		printk(KERN_ERR "ide-tape: Couldn't write a filemark\n");
+		printk(KERN_ERR PFX "Couldn't write a filemark\n");
 		return -EIO;
 	}
 	return 0;
@@ -1370,8 +1372,7 @@ static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
 		tape->door_locked = DOOR_UNLOCKED;
 		return 0;
 	default:
-		printk(KERN_ERR "ide-tape: MTIO operation %d not supported\n",
-				mt_op);
+		printk(KERN_ERR PFX "MTIO operation %d not supported\n", mt_op);
 		return -EIO;
 	}
 }
@@ -1448,10 +1449,10 @@ static void ide_tape_get_bsize_from_bdesc(ide_drive_t *drive)
 
 	idetape_create_mode_sense_cmd(&pc, IDETAPE_BLOCK_DESCRIPTOR);
 	if (ide_queue_pc_tail(drive, tape->disk, &pc, buf, pc.req_xfer)) {
-		printk(KERN_ERR "ide-tape: Can't get block descriptor\n");
+		printk(KERN_ERR PFX "Can't get block descriptor\n");
 		if (tape->blk_size == 0) {
-			printk(KERN_WARNING "ide-tape: Cannot deal with zero "
-					    "block size, assuming 32k\n");
+			printk(KERN_WARNING PFX "Cannot deal with zero block "
+						"size, assuming 32k\n");
 			tape->blk_size = 32768;
 		}
 		return;
@@ -1500,7 +1501,7 @@ static int idetape_chrdev_open(struct inode *inode, struct file *filp)
 	retval = idetape_wait_ready(drive, 60 * HZ);
 	if (retval) {
 		clear_bit(ilog2(IDE_AFLAG_BUSY), &drive->atapi_flags);
-		printk(KERN_ERR "ide-tape: %s: drive not ready\n", tape->name);
+		printk(KERN_ERR PFX "%s: drive not ready\n", tape->name);
 		goto out_put_tape;
 	}
 
@@ -1603,8 +1604,8 @@ static void idetape_get_inquiry_results(ide_drive_t *drive)
 
 	idetape_create_inquiry_cmd(&pc);
 	if (ide_queue_pc_tail(drive, tape->disk, &pc, pc_buf, pc.req_xfer)) {
-		printk(KERN_ERR "ide-tape: %s: can't get INQUIRY results\n",
-				tape->name);
+		printk(KERN_ERR PFX "%s: can't get INQUIRY results\n",
+		       tape->name);
 		return;
 	}
 	memcpy(vendor_id, &pc_buf[8], 8);
@@ -1615,8 +1616,8 @@ static void idetape_get_inquiry_results(ide_drive_t *drive)
 	ide_fixstring(product_id, 16, 0);
 	ide_fixstring(fw_rev, 4, 0);
 
-	printk(KERN_INFO "ide-tape: %s <-> %s: %.8s %.16s rev %.4s\n",
-			drive->name, tape->name, vendor_id, product_id, fw_rev);
+	printk(KERN_INFO PFX "%s <-> %s: %.8s %.16s rev %.4s\n",
+	       drive->name, tape->name, vendor_id, product_id, fw_rev);
 }
 
 /*
@@ -1632,8 +1633,8 @@ static void idetape_get_mode_sense_results(ide_drive_t *drive)
 
 	idetape_create_mode_sense_cmd(&pc, IDETAPE_CAPABILITIES_PAGE);
 	if (ide_queue_pc_tail(drive, tape->disk, &pc, buf, pc.req_xfer)) {
-		printk(KERN_ERR "ide-tape: Can't get tape parameters - assuming"
-				" some default values\n");
+		printk(KERN_ERR PFX "Can't get tape parameters - assuming"
+				    " some default values\n");
 		tape->blk_size = 512;
 		put_unaligned(52,   (u16 *)&tape->caps[12]);
 		put_unaligned(540,  (u16 *)&tape->caps[14]);
@@ -1652,13 +1653,13 @@ static void idetape_get_mode_sense_results(ide_drive_t *drive)
 	*(u16 *)&caps[16] = be16_to_cpup((__be16 *)&caps[16]);
 
 	if (!speed) {
-		printk(KERN_INFO "ide-tape: %s: invalid tape speed "
-				"(assuming 650KB/sec)\n", drive->name);
+		printk(KERN_INFO PFX "%s: invalid tape speed "
+		       "(assuming 650KB/sec)\n", drive->name);
 		*(u16 *)&caps[14] = 650;
 	}
 	if (!max_speed) {
-		printk(KERN_INFO "ide-tape: %s: invalid max_speed "
-				"(assuming 650KB/sec)\n", drive->name);
+		printk(KERN_INFO PFX "%s: invalid max_speed "
+		       "(assuming 650KB/sec)\n", drive->name);
 		*(u16 *)&caps[8] = 650;
 	}
 
@@ -1750,8 +1751,7 @@ static void idetape_setup(ide_drive_t *drive, idetape_tape_t *tape, int minor)
 	drive->dev_flags |= IDE_DFLAG_DSC_OVERLAP;
 
 	if (drive->hwif->host_flags & IDE_HFLAG_NO_DSC) {
-		printk(KERN_INFO "ide-tape: %s: disabling DSC overlap\n",
-				 tape->name);
+		printk(KERN_INFO PFX "%s: disabling DSC overlap\n", tape->name);
 		drive->dev_flags &= ~IDE_DFLAG_DSC_OVERLAP;
 	}
 
@@ -1771,7 +1771,7 @@ static void idetape_setup(ide_drive_t *drive, idetape_tape_t *tape, int minor)
 	tape->user_bs_factor = 1;
 	tape->buffer_size = *ctl * tape->blk_size;
 	while (tape->buffer_size > 0xffff) {
-		printk(KERN_NOTICE "ide-tape: decreasing stage size\n");
+		printk(KERN_NOTICE PFX "decreasing stage size\n");
 		*ctl /= 2;
 		tape->buffer_size = *ctl * tape->blk_size;
 	}
@@ -1788,7 +1788,7 @@ static void idetape_setup(ide_drive_t *drive, idetape_tape_t *tape, int minor)
 	 */
 	tape->best_dsc_rw_freq = clamp_t(unsigned long, t, IDETAPE_DSC_RW_MIN,
 					 IDETAPE_DSC_RW_MAX);
-	printk(KERN_INFO "ide-tape: %s <-> %s: %dKBps, %d*%dkB buffer, "
+	printk(KERN_INFO PFX "%s <-> %s: %dKBps, %d*%dkB buffer, "
 		"%lums tDSC%s\n",
 		drive->name, tape->name, *(u16 *)&tape->caps[14],
 		(*(u16 *)&tape->caps[16] * 512) / tape->buffer_size,
@@ -1866,7 +1866,7 @@ static int ide_tape_probe(ide_drive_t *);
 static struct ide_driver idetape_driver = {
 	.gen_driver = {
 		.owner		= THIS_MODULE,
-		.name		= "ide-tape",
+		.name		= DRV_NAME,
 		.bus		= &ide_bus_type,
 	},
 	.probe			= ide_tape_probe,
@@ -1939,14 +1939,14 @@ static int ide_tape_probe(ide_drive_t *drive)
 
 	if ((drive->dev_flags & IDE_DFLAG_ID_READ) &&
 	    ide_check_atapi_device(drive, DRV_NAME) == 0) {
-		printk(KERN_ERR "ide-tape: %s: not supported by this version of"
-				" the driver\n", drive->name);
+		printk(KERN_ERR PFX "%s: not supported by this version of"
+		       " the driver\n", drive->name);
 		goto failed;
 	}
 	tape = kzalloc(sizeof(idetape_tape_t), GFP_KERNEL);
 	if (tape == NULL) {
-		printk(KERN_ERR "ide-tape: %s: Can't allocate a tape struct\n",
-				drive->name);
+		printk(KERN_ERR PFX "%s: Can't allocate a tape struct\n",
+		       drive->name);
 		goto failed;
 	}
 
@@ -2011,14 +2011,13 @@ static int __init idetape_init(void)
 	idetape_sysfs_class = class_create(THIS_MODULE, "ide_tape");
 	if (IS_ERR(idetape_sysfs_class)) {
 		idetape_sysfs_class = NULL;
-		printk(KERN_ERR "Unable to create sysfs class for ide tapes\n");
+		printk(KERN_ERR PFX "Unable to create sysfs class\n");
 		error = -EBUSY;
 		goto out;
 	}
 
 	if (register_chrdev(IDETAPE_MAJOR, "ht", &idetape_fops)) {
-		printk(KERN_ERR "ide-tape: Failed to register chrdev"
-				" interface\n");
+		printk(KERN_ERR PFX "Failed to register chrdev interface\n");
 		error = -EBUSY;
 		goto out_free_class;
 	}
-- 
1.6.3.1

