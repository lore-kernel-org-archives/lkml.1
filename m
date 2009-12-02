Return-Path: <linux-kernel-owner+w=401wt.eu-S1754137AbZLBGJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137AbZLBGJx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 01:09:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753272AbZLBGJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 01:09:52 -0500
Received: from mail.perches.com ([173.55.12.10]:1225 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752518AbZLBGHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 01:07:49 -0500
From: Joe Perches <joe@perches.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH 03/13] drivers/block/floppy.c: Remove [U]CLEARF, [U]SETF, and [U]TESTF macros
Date: Tue,  1 Dec 2009 22:07:43 -0800
Message-Id: <a8934ba57fa14328af10e7f93f1b18b1690cf1b2.1259733457.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1259733456.git.joe@perches.com>
References: <cover.1259733456.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use clear_bit, set_bit, and test_bit functions directly

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/floppy.c |   94 ++++++++++++++++++++++++------------------------
 1 files changed, 47 insertions(+), 47 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index cacb0dd..afbbd7d 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -305,17 +305,11 @@ static int initialising = 1;
 #define DRS	(&drive_state[current_drive])
 #define DRWE	(&write_errors[current_drive])
 #define FDCS	(&fdc_state[fdc])
-#define CLEARF(x)	clear_bit(x##_BIT, &DRS->flags)
-#define SETF(x)		set_bit(x##_BIT, &DRS->flags)
-#define TESTF(x)	test_bit(x##_BIT, &DRS->flags)
 
 #define UDP	(&drive_params[drive])
 #define UDRS	(&drive_state[drive])
 #define UDRWE	(&write_errors[drive])
 #define UFDCS	(&fdc_state[FDC(drive)])
-#define UCLEARF(x)	clear_bit(x##_BIT, &UDRS->flags)
-#define USETF(x)	set_bit(x##_BIT, &UDRS->flags)
-#define UTESTF(x)	test_bit(x##_BIT, &UDRS->flags)
 
 #define DPRINT(format, args...) \
 	pr_info(DEVICE_NAME "%d: " format, current_drive, ##args)
@@ -1290,13 +1284,13 @@ static int disk_change(int drive)
 	debug_dcl(UDP->flags, "flags=%lx\n", UDRS->flags);
 
 	if (UDP->flags & FD_BROKEN_DCL)
-		return UTESTF(FD_DISK_CHANGED);
+		return test_bit(FD_DISK_CHANGED_BIT, &UDRS->flags);
 	if ((fd_inb(FD_DIR) ^ UDP->flags) & 0x80) {
-		USETF(FD_VERIFY);	/* verify write protection */
-		if (UDRS->maxblock) {
-			/* mark it changed */
-			USETF(FD_DISK_CHANGED);
-		}
+		set_bit(FD_VERIFY_BIT, &UDRS->flags);
+					/* verify write protection */
+
+		if (UDRS->maxblock)	/* mark it changed */
+			set_bit(FD_DISK_CHANGED_BIT, &UDRS->flags);
 
 		/* invalidate its geometry */
 		if (UDRS->keep_data >= 0) {
@@ -1311,7 +1305,7 @@ static int disk_change(int drive)
 		return 1;
 	} else {
 		UDRS->last_checked = jiffies;
-		UCLEARF(FD_DISK_NEWCHANGE);
+		clear_bit(FD_DISK_NEWCHANGE_BIT, &UDRS->flags);
 	}
 	return 0;
 }
@@ -2005,11 +1999,11 @@ static int interpret_errors(void)
 		bad = 1;
 		if (ST1 & ST1_WP) {
 			DPRINT("Drive is write protected\n");
-			CLEARF(FD_DISK_WRITABLE);
+			clear_bit(FD_DISK_WRITABLE_BIT, &DRS->flags);
 			cont->done(0);
 			bad = 2;
 		} else if (ST1 & ST1_ND) {
-			SETF(FD_NEED_TWADDLE);
+			set_bit(FD_NEED_TWADDLE_BIT, &DRS->flags);
 		} else if (ST1 & ST1_OR) {
 			if (DP->flags & FTD_MSG)
 				DPRINT("Over/Underrun - retrying\n");
@@ -2115,7 +2109,8 @@ static void seek_interrupt(void)
 		debug_dcl(DP->flags,
 			  "clearing NEWCHANGE flag because of effective seek\n");
 		debug_dcl(DP->flags, "jiffies=%lu\n", jiffies);
-		CLEARF(FD_DISK_NEWCHANGE);	/* effective seek */
+		clear_bit(FD_DISK_NEWCHANGE_BIT, &DRS->flags);
+					/* effective seek */
 		DRS->select_date = jiffies;
 	}
 	DRS->track = ST1;
@@ -2124,23 +2119,23 @@ static void seek_interrupt(void)
 
 static void check_wp(void)
 {
-	if (TESTF(FD_VERIFY)) {
-		/* check write protection */
+	if (test_bit(FD_VERIFY_BIT, &DRS->flags)) {
+					/* check write protection */
 		output_byte(FD_GETSTATUS);
 		output_byte(UNIT(current_drive));
 		if (result() != 1) {
 			FDCS->reset = 1;
 			return;
 		}
-		CLEARF(FD_VERIFY);
-		CLEARF(FD_NEED_TWADDLE);
+		clear_bit(FD_VERIFY_BIT, &DRS->flags);
+		clear_bit(FD_NEED_TWADDLE_BIT, &DRS->flags);
 		debug_dcl(DP->flags,
 			  "checking whether disk is write protected\n");
 		debug_dcl(DP->flags, "wp=%x\n", ST3 & 0x40);
 		if (!(ST3 & 0x40))
-			SETF(FD_DISK_WRITABLE);
+			set_bit(FD_DISK_WRITABLE_BIT, &DRS->flags);
 		else
-			CLEARF(FD_DISK_WRITABLE);
+			clear_bit(FD_DISK_WRITABLE_BIT, &DRS->flags);
 	}
 }
 
@@ -2152,13 +2147,13 @@ static void seek_floppy(void)
 
 	debug_dcl(DP->flags, "calling disk change from seek\n");
 
-	if (!TESTF(FD_DISK_NEWCHANGE) &&
+	if (!test_bit(FD_DISK_NEWCHANGE_BIT, &DRS->flags) &&
 	    disk_change(current_drive) && (raw_cmd->flags & FD_RAW_NEED_DISK)) {
 		/* the media changed flag should be cleared after the seek.
 		 * If it isn't, this means that there is really no disk in
 		 * the drive.
 		 */
-		SETF(FD_DISK_CHANGED);
+		set_bit(FD_DISK_CHANGED_BIT, &DRS->flags);
 		cont->done(0);
 		cont->redo();
 		return;
@@ -2166,7 +2161,7 @@ static void seek_floppy(void)
 	if (DRS->track <= NEED_1_RECAL) {
 		recalibrate_floppy();
 		return;
-	} else if (TESTF(FD_DISK_NEWCHANGE) &&
+	} else if (test_bit(FD_DISK_NEWCHANGE_BIT, &DRS->flags) &&
 		   (raw_cmd->flags & FD_RAW_NEED_DISK) &&
 		   (DRS->track <= NO_TRACK || DRS->track == raw_cmd->track)) {
 		/* we seek to clear the media-changed condition. Does anybody
@@ -2229,7 +2224,7 @@ static void recal_interrupt(void)
 			debug_dcl(DP->flags,
 				  "clearing NEWCHANGE flag because of second recalibrate\n");
 
-			CLEARF(FD_DISK_NEWCHANGE);
+			clear_bit(FD_DISK_NEWCHANGE_BIT, &DRS->flags);
 			DRS->select_date = jiffies;
 			/* fall through */
 		default:
@@ -2519,7 +2514,7 @@ static void floppy_start(void)
 
 	scandrives();
 	debug_dcl(DP->flags, "setting NEWCHANGE in floppy_start\n");
-	SETF(FD_DISK_NEWCHANGE);
+	set_bit(FD_DISK_NEWCHANGE_BIT, &DRS->flags);
 	floppy_ready();
 }
 
@@ -3175,7 +3170,8 @@ static int make_raw_rw_request(void)
 	HEAD = fsector_t / _floppy->sect;
 
 	if (((_floppy->stretch & (FD_SWAPSIDES | FD_SECTBASEMASK)) ||
-	     TESTF(FD_NEED_TWADDLE)) && fsector_t < _floppy->sect)
+	     test_bit(FD_NEED_TWADDLE_BIT, &DRS->flags)) &&
+	    fsector_t < _floppy->sect)
 		max_sector = _floppy->sect;
 
 	/* 2M disks have phantom sectors on the first track */
@@ -3447,7 +3443,7 @@ static void redo_fd_request(void)
 			return;
 		disk_change(current_drive);
 		if (test_bit(current_drive, &fake_change) ||
-		    TESTF(FD_DISK_CHANGED)) {
+		    test_bit(FD_DISK_CHANGED_BIT, &DRS->flags)) {
 			DPRINT("disk absent or changed during operation\n");
 			REPEAT;
 		}
@@ -3472,7 +3468,7 @@ static void redo_fd_request(void)
 			continue;
 		}
 
-		if (TESTF(FD_NEED_TWADDLE))
+		if (test_bit(FD_NEED_TWADDLE_BIT, &DRS->flags))
 			twaddle();
 		schedule_bh(floppy_start);
 		debugt("queue fd request");
@@ -3538,7 +3534,7 @@ static int poll_drive(int interruptible, int flag)
 	raw_cmd->cmd_count = 0;
 	cont = &poll_cont;
 	debug_dcl(DP->flags, "setting NEWCHANGE in poll_drive\n");
-	SETF(FD_DISK_NEWCHANGE);
+	set_bit(FD_DISK_NEWCHANGE_BIT, &DRS->flags);
 	WAIT(floppy_ready);
 	return ret;
 }
@@ -4025,8 +4021,8 @@ static int fd_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd,
 		 * non-Sparc architectures */
 		ret = fd_eject(UNIT(drive));
 
-		USETF(FD_DISK_CHANGED);
-		USETF(FD_VERIFY);
+		set_bit(FD_DISK_CHANGED_BIT, &UDRS->flags);
+		set_bit(FD_VERIFY_BIT, &UDRS->flags);
 		process_fd_request();
 		return ret;
 
@@ -4242,8 +4238,8 @@ static int floppy_open(struct block_device *bdev, fmode_t mode)
 		goto out2;
 
 	if (!UDRS->fd_ref && (UDP->flags & FD_BROKEN_DCL)) {
-		USETF(FD_DISK_CHANGED);
-		USETF(FD_VERIFY);
+		set_bit(FD_DISK_CHANGED_BIT, &UDRS->flags);
+		set_bit(FD_VERIFY_BIT, &UDRS->flags);
 	}
 
 	if (UDRS->fd_ref == -1 || (UDRS->fd_ref && (mode & FMODE_EXCL)))
@@ -4303,11 +4299,12 @@ static int floppy_open(struct block_device *bdev, fmode_t mode)
 		if (mode & (FMODE_READ | FMODE_WRITE)) {
 			UDRS->last_checked = 0;
 			check_disk_change(bdev);
-			if (UTESTF(FD_DISK_CHANGED))
+			if (test_bit(FD_DISK_CHANGED_BIT, &UDRS->flags))
 				goto out;
 		}
 		res = -EROFS;
-		if ((mode & FMODE_WRITE) && !(UTESTF(FD_DISK_WRITABLE)))
+		if ((mode & FMODE_WRITE) &&
+		    !test_bit(FD_DISK_WRITABLE_BIT, &UDRS->flags))
 			goto out;
 	}
 	mutex_unlock(&open_lock);
@@ -4331,7 +4328,8 @@ static int check_floppy_change(struct gendisk *disk)
 {
 	int drive = (long)disk->private_data;
 
-	if (UTESTF(FD_DISK_CHANGED) || UTESTF(FD_VERIFY))
+	if (test_bit(FD_DISK_CHANGED_BIT, &UDRS->flags) ||
+	    test_bit(FD_VERIFY_BIT, &UDRS->flags))
 		return 1;
 
 	if (time_after(jiffies, UDRS->last_checked + UDP->checkfreq)) {
@@ -4340,8 +4338,8 @@ static int check_floppy_change(struct gendisk *disk)
 		process_fd_request();
 	}
 
-	if (UTESTF(FD_DISK_CHANGED) ||
-	    UTESTF(FD_VERIFY) ||
+	if (test_bit(FD_DISK_CHANGED_BIT, &UDRS->flags) ||
+	    test_bit(FD_VERIFY_BIT, &UDRS->flags) ||
 	    test_bit(drive, &fake_change) ||
 	    (!ITYPE(UDRS->fd_device) && !current_type[drive]))
 		return 1;
@@ -4412,14 +4410,16 @@ static int floppy_revalidate(struct gendisk *disk)
 	int cf;
 	int res = 0;
 
-	if (UTESTF(FD_DISK_CHANGED) ||
-	    UTESTF(FD_VERIFY) || test_bit(drive, &fake_change) || NO_GEOM) {
+	if (test_bit(FD_DISK_CHANGED_BIT, &UDRS->flags) ||
+	    test_bit(FD_VERIFY_BIT, &UDRS->flags) ||
+	    test_bit(drive, &fake_change) || NO_GEOM) {
 		if (usage_count == 0) {
 			pr_info("VFS: revalidate called on non-open device.\n");
 			return -EFAULT;
 		}
 		lock_fdc(drive, 0);
-		cf = UTESTF(FD_DISK_CHANGED) || UTESTF(FD_VERIFY);
+		cf = (test_bit(FD_DISK_CHANGED_BIT, &UDRS->flags) ||
+		      test_bit(FD_VERIFY_BIT, &UDRS->flags));
 		if (!(cf || test_bit(drive, &fake_change) || NO_GEOM)) {
 			process_fd_request();
 					/*already done by another thread */
@@ -4430,7 +4430,7 @@ static int floppy_revalidate(struct gendisk *disk)
 		if (buffer_drive == drive)
 			buffer_track = -1;
 		clear_bit(drive, &fake_change);
-		UCLEARF(FD_DISK_CHANGED);
+		clear_bit(FD_DISK_CHANGED_BIT, &UDRS->flags);
 		if (cf)
 			UDRS->generation++;
 		if (NO_GEOM) {
@@ -4965,9 +4965,9 @@ static int __init floppy_init(void)
 	for (drive = 0; drive < N_DRIVE; drive++) {
 		memset(UDRS, 0, sizeof(*UDRS));
 		memset(UDRWE, 0, sizeof(*UDRWE));
-		USETF(FD_DISK_NEWCHANGE);
-		USETF(FD_DISK_CHANGED);
-		USETF(FD_VERIFY);
+		set_bit(FD_DISK_NEWCHANGE_BIT, &UDRS->flags);
+		set_bit(FD_DISK_CHANGED_BIT, &UDRS->flags);
+		set_bit(FD_VERIFY_BIT, &UDRS->flags);
 		UDRS->fd_device = -1;
 		floppy_track_buffer = NULL;
 		max_buffer_sectors = 0;
-- 
1.6.6.rc0.57.gad7a

