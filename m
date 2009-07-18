Return-Path: <linux-kernel-owner+w=401wt.eu-S1758114AbZGRJzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758114AbZGRJzm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 05:55:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758068AbZGRJzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 05:55:40 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:48456 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbZGRJzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 05:55:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ScFures+3/pXQ2j+RW30eZxAcKOo+A06J1COqR5f2r9jjFu14dJhBCE2eKUF/SUzLu
         zSc1kxetrvrmOrwhchleqXX08W0SDtETthpknWar+BNiEuAOoxeovKFb754FQ66DerkO
         xnVrAQwJ4EqQl2LvBzxVoH2g/OwlVihH0TgSs=
From: Borislav Petkov <petkovbb@googlemail.com>
To: <davem@davemloft.net>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] ide-tape: convert to ide_debug_log macro
Date: Sat, 18 Jul 2009 11:55:16 +0200
Message-Id: <1247910917-5237-3-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1247910917-5237-1-git-send-email-petkovbb@gmail.com>
References: <1247910917-5237-1-git-send-email-petkovbb@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove tape->debug_mask and use drive->debug_mask instead.

There should be no functional change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |  102 +++++++++++++++++++++++-------------------------
 1 files changed, 49 insertions(+), 53 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 60d5c41..08f09f5 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -47,28 +47,13 @@
 #include <asm/unaligned.h>
 #include <linux/mtio.h>
 
-enum {
-	/* output errors only */
-	DBG_ERR =		(1 << 0),
-	/* output all sense key/asc */
-	DBG_SENSE =		(1 << 1),
-	/* info regarding all chrdev-related procedures */
-	DBG_CHRDEV =		(1 << 2),
-	/* all remaining procedures */
-	DBG_PROCS =		(1 << 3),
-};
-
 /* define to see debug info */
-#define IDETAPE_DEBUG_LOG		0
+#undef IDETAPE_DEBUG_LOG
 
-#if IDETAPE_DEBUG_LOG
-#define debug_log(lvl, fmt, args...)			\
-{							\
-	if (tape->debug_mask & lvl)			\
-	printk(KERN_INFO "ide-tape: " fmt, ## args);	\
-}
+#ifdef IDETAPE_DEBUG_LOG
+#define ide_debug_log(lvl, fmt, args...) __ide_debug_log(lvl, fmt, ## args)
 #else
-#define debug_log(lvl, fmt, args...) do {} while (0)
+#define ide_debug_log(lvl, fmt, args...) do {} while (0)
 #endif
 
 /**************************** Tunable parameters *****************************/
@@ -230,8 +215,6 @@ typedef struct ide_tape_obj {
 	char drv_write_prot;
 	/* the tape is write protected (hardware or opened as read-only) */
 	char write_prot;
-
-	u32 debug_mask;
 } idetape_tape_t;
 
 static DEFINE_MUTEX(idetape_ref_mutex);
@@ -290,8 +273,9 @@ static void idetape_analyze_error(ide_drive_t *drive)
 	tape->asc       = sense[12];
 	tape->ascq      = sense[13];
 
-	debug_log(DBG_ERR, "pc = %x, sense key = %x, asc = %x, ascq = %x\n",
-		 pc->c[0], tape->sense_key, tape->asc, tape->ascq);
+	ide_debug_log(IDE_DBG_FUNC,
+		      "cmd: 0x%x, sense key = %x, asc = %x, ascq = %x",
+		      rq->cmd[0], tape->sense_key, tape->asc, tape->ascq);
 
 	/* correct remaining bytes to transfer */
 	if (pc->flags & PC_FLAG_DMA_ERROR)
@@ -344,7 +328,8 @@ static int ide_tape_callback(ide_drive_t *drive, int dsc)
 	int uptodate = pc->error ? 0 : 1;
 	int err = uptodate ? 0 : IDE_DRV_ERROR_GENERAL;
 
-	debug_log(DBG_PROCS, "Enter %s\n", __func__);
+	ide_debug_log(IDE_DBG_FUNC, "cmd: 0x%x, dsc: %d, err: %d", rq->cmd[0],
+		      dsc, err);
 
 	if (dsc)
 		ide_tape_handle_dsc(drive);
@@ -390,10 +375,12 @@ static int ide_tape_callback(ide_drive_t *drive, int dsc)
 static void idetape_postpone_request(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
+	struct request *rq = drive->hwif->rq;
 
-	debug_log(DBG_PROCS, "Enter %s\n", __func__);
+	ide_debug_log(IDE_DBG_FUNC, "cmd: 0x%x, dsc_poll_freq: %lu",
+		      rq->cmd[0], tape->dsc_poll_freq);
 
-	tape->postponed_rq = drive->hwif->rq;
+	tape->postponed_rq = rq;
 
 	ide_stall_queue(drive, tape->dsc_poll_freq);
 }
@@ -488,7 +475,8 @@ static ide_startstop_t ide_tape_issue_pc(ide_drive_t *drive,
 		ide_complete_rq(drive, -EIO, blk_rq_bytes(rq));
 		return ide_stopped;
 	}
-	debug_log(DBG_SENSE, "Retry #%d, cmd = %02X\n", pc->retries, pc->c[0]);
+	ide_debug_log(IDE_DBG_SENSE, "retry #%d, cmd: 0x%02x", pc->retries,
+		      pc->c[0]);
 
 	pc->retries++;
 
@@ -583,8 +571,9 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 	struct ide_cmd cmd;
 	u8 stat;
 
-	debug_log(DBG_SENSE, "sector: %llu, nr_sectors: %u\n",
-		  (unsigned long long)blk_rq_pos(rq), blk_rq_sectors(rq));
+	ide_debug_log(IDE_DBG_RQ, "cmd: 0x%x, sector: %llu, nr_sectors: %u",
+		      rq->cmd[0], (unsigned long long)blk_rq_pos(rq),
+		      blk_rq_sectors(rq));
 
 	BUG_ON(!(blk_special_request(rq) || blk_sense_request(rq)));
 
@@ -745,7 +734,7 @@ static int ide_tape_read_position(ide_drive_t *drive)
 	struct ide_atapi_pc pc;
 	u8 buf[20];
 
-	debug_log(DBG_PROCS, "Enter %s\n", __func__);
+	ide_debug_log(IDE_DBG_FUNC, "enter");
 
 	/* prep cmd */
 	ide_init_pc(&pc);
@@ -756,9 +745,9 @@ static int ide_tape_read_position(ide_drive_t *drive)
 		return -1;
 
 	if (!pc.error) {
-		debug_log(DBG_SENSE, "BOP - %s\n",
+		ide_debug_log(IDE_DBG_FUNC, "BOP - %s",
 				(buf[0] & 0x80) ? "Yes" : "No");
-		debug_log(DBG_SENSE, "EOP - %s\n",
+		ide_debug_log(IDE_DBG_FUNC, "EOP - %s",
 				(buf[0] & 0x40) ? "Yes" : "No");
 
 		if (buf[0] & 0x4) {
@@ -768,8 +757,8 @@ static int ide_tape_read_position(ide_drive_t *drive)
 				  &drive->atapi_flags);
 			return -1;
 		} else {
-			debug_log(DBG_SENSE, "Block Location - %u\n",
-					be32_to_cpup((__be32 *)&buf[4]));
+			ide_debug_log(IDE_DBG_FUNC, "Block Location: %u",
+				      be32_to_cpup((__be32 *)&buf[4]));
 
 			tape->partition = buf[1];
 			tape->first_frame = be32_to_cpup((__be32 *)&buf[4]);
@@ -866,7 +855,8 @@ static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int size)
 	struct request *rq;
 	int ret;
 
-	debug_log(DBG_SENSE, "%s: cmd=%d\n", __func__, cmd);
+	ide_debug_log(IDE_DBG_FUNC, "cmd: 0x%x, size: %d", cmd, size);
+
 	BUG_ON(cmd != REQ_IDETAPE_READ && cmd != REQ_IDETAPE_WRITE);
 	BUG_ON(size < 0 || size % tape->blk_size);
 
@@ -1029,7 +1019,7 @@ static int idetape_rewind_tape(ide_drive_t *drive)
 	struct ide_atapi_pc pc;
 	int ret;
 
-	debug_log(DBG_SENSE, "Enter %s\n", __func__);
+	ide_debug_log(IDE_DBG_FUNC, "enter");
 
 	idetape_create_rewind_cmd(drive, &pc);
 	ret = ide_queue_pc_tail(drive, disk, &pc, NULL, 0);
@@ -1055,7 +1045,7 @@ static int idetape_blkdev_ioctl(ide_drive_t *drive, unsigned int cmd,
 		int nr_stages;
 	} config;
 
-	debug_log(DBG_PROCS, "Enter %s\n", __func__);
+	ide_debug_log(IDE_DBG_FUNC, "cmd: 0x%04x", cmd);
 
 	switch (cmd) {
 	case 0x0340:
@@ -1084,6 +1074,9 @@ static int idetape_space_over_filemarks(ide_drive_t *drive, short mt_op,
 	int retval, count = 0;
 	int sprev = !!(tape->caps[4] & 0x20);
 
+
+	ide_debug_log(IDE_DBG_FUNC, "mt_op: %d, mt_count: %d", mt_op, mt_count);
+
 	if (mt_count == 0)
 		return 0;
 	if (MTBSF == mt_op || MTBSFM == mt_op) {
@@ -1147,7 +1140,7 @@ static ssize_t idetape_chrdev_read(struct file *file, char __user *buf,
 	ssize_t ret = 0;
 	int rc;
 
-	debug_log(DBG_CHRDEV, "Enter %s, count %Zd\n", __func__, count);
+	ide_debug_log(IDE_DBG_FUNC, "count %Zd", count);
 
 	if (tape->chrdev_dir != IDETAPE_DIR_READ) {
 		if (test_bit(ilog2(IDE_AFLAG_DETECT_BS), &drive->atapi_flags))
@@ -1186,8 +1179,6 @@ static ssize_t idetape_chrdev_read(struct file *file, char __user *buf,
 	}
 
 	if (!done && test_bit(ilog2(IDE_AFLAG_FILEMARK), &drive->atapi_flags)) {
-		debug_log(DBG_SENSE, "%s: spacing over filemark\n", tape->name);
-
 		idetape_space_over_filemarks(drive, MTFSF, 1);
 		return 0;
 	}
@@ -1208,7 +1199,7 @@ static ssize_t idetape_chrdev_write(struct file *file, const char __user *buf,
 	if (tape->write_prot)
 		return -EACCES;
 
-	debug_log(DBG_CHRDEV, "Enter %s, count %Zd\n", __func__, count);
+	ide_debug_log(IDE_DBG_FUNC, "count %Zd", count);
 
 	/* Initialize write operation */
 	rc = idetape_init_rw(drive, IDETAPE_DIR_WRITE);
@@ -1272,8 +1263,8 @@ static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
 	struct ide_atapi_pc pc;
 	int i, retval;
 
-	debug_log(DBG_ERR, "Handling MTIOCTOP ioctl: mt_op=%d, mt_count=%d\n",
-			mt_op, mt_count);
+	ide_debug_log(IDE_DBG_FUNC, "MTIOCTOP ioctl: mt_op: %d, mt_count: %d",
+		      mt_op, mt_count);
 
 	switch (mt_op) {
 	case MTFSF:
@@ -1392,7 +1383,7 @@ static int idetape_chrdev_ioctl(struct inode *inode, struct file *file,
 	int block_offset = 0, position = tape->first_frame;
 	void __user *argp = (void __user *)arg;
 
-	debug_log(DBG_CHRDEV, "Enter %s, cmd=%u\n", __func__, cmd);
+	ide_debug_log(IDE_DBG_FUNC, "cmd: 0x%x", cmd);
 
 	if (tape->chrdev_dir == IDETAPE_DIR_WRITE) {
 		ide_tape_flush_merge_buffer(drive);
@@ -1460,6 +1451,9 @@ static void ide_tape_get_bsize_from_bdesc(ide_drive_t *drive)
 				(buf[4 + 6] << 8)  +
 				 buf[4 + 7];
 	tape->drv_write_prot = (buf[2] & 0x80) >> 7;
+
+	ide_debug_log(IDE_DBG_FUNC, "blk_size: %d, write_prot: %d",
+		      tape->blk_size, tape->drv_write_prot);
 }
 
 static int idetape_chrdev_open(struct inode *inode, struct file *filp)
@@ -1479,7 +1473,10 @@ static int idetape_chrdev_open(struct inode *inode, struct file *filp)
 		return -ENXIO;
 	}
 
-	debug_log(DBG_CHRDEV, "Enter %s\n", __func__);
+	drive = tape->drive;
+	filp->private_data = tape;
+
+	ide_debug_log(IDE_DBG_FUNC, "enter");
 
 	/*
 	 * We really want to do nonseekable_open(inode, filp); here, but some
@@ -1488,9 +1485,6 @@ static int idetape_chrdev_open(struct inode *inode, struct file *filp)
 	 */
 	filp->f_mode &= ~(FMODE_PREAD | FMODE_PWRITE);
 
-	drive = tape->drive;
-
-	filp->private_data = tape;
 
 	if (test_and_set_bit(ilog2(IDE_AFLAG_BUSY), &drive->atapi_flags)) {
 		retval = -EBUSY;
@@ -1569,7 +1563,7 @@ static int idetape_chrdev_release(struct inode *inode, struct file *filp)
 	lock_kernel();
 	tape = drive->driver_data;
 
-	debug_log(DBG_CHRDEV, "Enter %s\n", __func__);
+	ide_debug_log(IDE_DBG_FUNC, "enter");
 
 	if (tape->chrdev_dir == IDETAPE_DIR_WRITE)
 		idetape_write_release(drive, minor);
@@ -1706,7 +1700,6 @@ static int divf_buffer_size(ide_drive_t *drive)	{ return 1024; }
 
 ide_devset_rw_flag(dsc_overlap, IDE_DFLAG_DSC_OVERLAP);
 
-ide_tape_devset_rw_field(debug_mask, debug_mask);
 ide_tape_devset_rw_field(tdsc, best_dsc_rw_freq);
 
 ide_tape_devset_r_field(avg_speed, avg_speed);
@@ -1718,7 +1711,6 @@ static const struct ide_proc_devset idetape_settings[] = {
 	__IDE_PROC_DEVSET(avg_speed,	0, 0xffff, NULL, NULL),
 	__IDE_PROC_DEVSET(buffer,	0, 0xffff, NULL, divf_buffer),
 	__IDE_PROC_DEVSET(buffer_size,	0, 0xffff, NULL, divf_buffer_size),
-	__IDE_PROC_DEVSET(debug_mask,	0, 0xffff, NULL, NULL),
 	__IDE_PROC_DEVSET(dsc_overlap,	0,      1, NULL, NULL),
 	__IDE_PROC_DEVSET(speed,	0, 0xffff, NULL, NULL),
 	__IDE_PROC_DEVSET(tdsc,		IDETAPE_DSC_RW_MIN, IDETAPE_DSC_RW_MAX,
@@ -1745,7 +1737,9 @@ static void idetape_setup(ide_drive_t *drive, idetape_tape_t *tape, int minor)
 	int buffer_size;
 	u16 *ctl = (u16 *)&tape->caps[12];
 
-	drive->pc_callback	 = ide_tape_callback;
+	ide_debug_log(IDE_DBG_FUNC, "minor: %d", minor);
+
+	drive->pc_callback = ide_tape_callback;
 
 	drive->dev_flags |= IDE_DFLAG_DSC_OVERLAP;
 
@@ -1931,7 +1925,9 @@ static int ide_tape_probe(ide_drive_t *drive)
 	struct gendisk *g;
 	int minor;
 
-	if (!strstr("ide-tape", drive->driver_req))
+	ide_debug_log(IDE_DBG_FUNC, "enter");
+
+	if (!strstr(DRV_NAME, drive->driver_req))
 		goto failed;
 
 	if (drive->media != ide_tape)
-- 
1.6.3.3

