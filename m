Return-Path: <linux-kernel-owner+w=401wt.eu-S1754777Ab0AVE54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777Ab0AVE54 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 23:57:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752699Ab0AVE43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 23:56:29 -0500
Received: from mail.perches.com ([173.55.12.10]:1354 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752888Ab0AVExA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 23:53:00 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 13/24] drivers/block/floppy.c: Remove macro LOCK_FDC
Date: Thu, 21 Jan 2010 20:52:43 -0800
Message-Id: <e2b1f0b8c466662d276252c8dcd56a6675a8352f.1264133863.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1264133863.git.joe@perches.com>
References: <cover.1264133863.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Macros with hidden returns aren't nice.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/floppy.c |   43 ++++++++++++++++++++++++++-----------------
 1 files changed, 26 insertions(+), 17 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 24a4a22..de7b222 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -908,10 +908,6 @@ static int _lock_fdc(int drive, int interruptible, int line)
 #define lock_fdc(drive, interruptible)			\
 	_lock_fdc(drive, interruptible, __LINE__)
 
-#define LOCK_FDC(drive, interruptible)	    \
-	if (lock_fdc(drive, interruptible)) \
-		return -EINTR;
-
 /* unlocks the driver */
 static inline void unlock_fdc(void)
 {
@@ -2276,7 +2272,9 @@ static int do_format(int drive, struct format_descr *tmp_format_req)
 {
 	int ret;
 
-	LOCK_FDC(drive, 1);
+	if (lock_fdc(drive, 1))
+		return -EINTR;
+
 	set_floppy(drive);
 	if (!_floppy ||
 	    _floppy->track > DP->tracks ||
@@ -3056,8 +3054,9 @@ static int user_reset_fdc(int drive, int arg, int interruptible)
 {
 	int ret;
 
-	ret = 0;
-	LOCK_FDC(drive, interruptible);
+	if (lock_fdc(drive, interruptible))
+		return -EINTR;
+
 	if (arg == FD_RESET_ALWAYS)
 		FDCS->reset = 1;
 	if (FDCS->reset) {
@@ -3065,7 +3064,7 @@ static int user_reset_fdc(int drive, int arg, int interruptible)
 		WAIT(reset_fdc);
 	}
 	process_fd_request();
-	return ret;
+	return 0;
 }
 
 /*
@@ -3352,7 +3351,9 @@ static inline int set_geometry(unsigned int cmd, struct floppy_struct *g,
 		mutex_unlock(&open_lock);
 	} else {
 		int oldStretch;
-		LOCK_FDC(drive, 1);
+
+		if (lock_fdc(drive, 1))
+			return -EINTR;
 		if (cmd != FDDEFPRM)
 			/* notice a disk change immediately, else
 			 * we lose our settings immediately*/
@@ -3435,7 +3436,8 @@ static int get_floppy_geometry(int drive, int type, struct floppy_struct **g)
 	if (type)
 		*g = &floppy_type[type];
 	else {
-		LOCK_FDC(drive, 0);
+		if (lock_fdc(drive, 0))
+			return -EINTR;
 		CALL(poll_drive(0, 0));
 		process_fd_request();
 		*g = current_type[drive];
@@ -3514,7 +3516,8 @@ static int fd_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd,
 		if (UDRS->fd_ref != 1)
 			/* somebody else has this drive open */
 			return -EBUSY;
-		LOCK_FDC(drive, 1);
+		if (lock_fdc(drive, 1))
+			return -EINTR;
 
 		/* do the actual eject. Fails on
 		 * non-Sparc architectures */
@@ -3525,7 +3528,8 @@ static int fd_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd,
 		process_fd_request();
 		return ret;
 	case FDCLRPRM:
-		LOCK_FDC(drive, 1);
+		if (lock_fdc(drive, 1))
+			return -EINTR;
 		current_type[drive] = NULL;
 		floppy_sizes[drive] = MAX_DISK_SIZE << 1;
 		UDRS->keep_data = 0;
@@ -3545,7 +3549,8 @@ static int fd_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd,
 		UDP->flags &= ~FTD_MSG;
 		return 0;
 	case FDFMTBEG:
-		LOCK_FDC(drive, 1);
+		if (lock_fdc(drive, 1))
+			return -EINTR;
 		CALL(poll_drive(1, FD_RAW_NEED_DISK));
 		ret = UDRS->flags;
 		process_fd_request();
@@ -3560,7 +3565,8 @@ static int fd_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd,
 		return do_format(drive, &inparam.f);
 	case FDFMTEND:
 	case FDFLUSH:
-		LOCK_FDC(drive, 1);
+		if (lock_fdc(drive, 1))
+			return -EINTR;
 		return invalidate_drive(bdev);
 	case FDSETEMSGTRESH:
 		UDP->max_errors.reporting = (unsigned short)(param & 0x0f);
@@ -3582,7 +3588,8 @@ static int fd_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd,
 		outparam = (const char *)UDP;
 		break;
 	case FDPOLLDRVSTAT:
-		LOCK_FDC(drive, 1);
+		if (lock_fdc(drive, 1))
+			return -EINTR;
 		CALL(poll_drive(1, FD_RAW_NEED_DISK));
 		process_fd_request();
 		/* fall through */
@@ -3603,13 +3610,15 @@ static int fd_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd,
 	case FDRAWCMD:
 		if (type)
 			return -EINVAL;
-		LOCK_FDC(drive, 1);
+		if (lock_fdc(drive, 1))
+			return -EINTR;
 		set_floppy(drive);
 		CALL(i = raw_cmd_ioctl(cmd, (void __user *)param));
 		process_fd_request();
 		return i;
 	case FDTWADDLE:
-		LOCK_FDC(drive, 1);
+		if (lock_fdc(drive, 1))
+			return -EINTR;
 		twaddle();
 		process_fd_request();
 		return 0;
-- 
1.6.6.rc0.57.gad7a

