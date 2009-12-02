Return-Path: <linux-kernel-owner+w=401wt.eu-S1753935AbZLBGK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935AbZLBGK1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 01:10:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753093AbZLBGKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 01:10:11 -0500
Received: from mail.perches.com ([173.55.12.10]:1218 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906AbZLBGHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 01:07:48 -0500
From: Joe Perches <joe@perches.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH 01/13] drivers/block/floppy.c: Remove macro LOCK_FDC
Date: Tue,  1 Dec 2009 22:07:41 -0800
Message-Id: <367e23a585d34a5556a52cb7e12570c4f7c0cae5.1259733456.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1259733456.git.joe@perches.com>
References: <cover.1259733456.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Macros with hidden returns aren't nice.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/floppy.c |   43 ++++++++++++++++++++++++++-----------------
 1 files changed, 26 insertions(+), 17 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 4521582..3e3e5fe 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -1434,10 +1434,6 @@ static int _lock_fdc(int drive, int interruptible, int line)
 #define lock_fdc(drive, interruptible)			\
 	_lock_fdc(drive, interruptible, __LINE__)
 
-#define LOCK_FDC(drive, interruptible)	    \
-	if (lock_fdc(drive, interruptible)) \
-		return -EINTR;
-
 /* unlocks the driver */
 static inline void unlock_fdc(void)
 {
@@ -2804,7 +2800,9 @@ static int do_format(int drive, struct format_descr *tmp_format_req)
 {
 	int ret;
 
-	LOCK_FDC(drive, 1);
+	if (lock_fdc(drive, 1))
+		return -EINTR;
+
 	set_floppy(drive);
 	if (!_floppy ||
 	    _floppy->track > DP->tracks ||
@@ -3584,8 +3582,9 @@ static int user_reset_fdc(int drive, int arg, int interruptible)
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
@@ -3593,7 +3592,7 @@ static int user_reset_fdc(int drive, int arg, int interruptible)
 		WAIT(reset_fdc);
 	}
 	process_fd_request();
-	return ret;
+	return 0;
 }
 
 /*
@@ -3879,7 +3878,9 @@ static inline int set_geometry(unsigned int cmd, struct floppy_struct *g,
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
@@ -3962,7 +3963,8 @@ static int get_floppy_geometry(int drive, int type, struct floppy_struct **g)
 	if (type)
 		*g = &floppy_type[type];
 	else {
-		LOCK_FDC(drive, 0);
+		if (lock_fdc(drive, 0))
+			return -EINTR;
 		CALL(poll_drive(0, 0));
 		process_fd_request();
 		*g = current_type[drive];
@@ -4037,7 +4039,8 @@ static int fd_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd,
 		if (UDRS->fd_ref != 1)
 			/* somebody else has this drive open */
 			return -EBUSY;
-		LOCK_FDC(drive, 1);
+		if (lock_fdc(drive, 1))
+			return -EINTR;
 
 		/* do the actual eject. Fails on
 		 * non-Sparc architectures */
@@ -4049,7 +4052,8 @@ static int fd_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd,
 		return ret;
 
 	case FDCLRPRM:
-		LOCK_FDC(drive, 1);
+		if (lock_fdc(drive, 1))
+			return -EINTR;
 		current_type[drive] = NULL;
 		floppy_sizes[drive] = MAX_DISK_SIZE << 1;
 		UDRS->keep_data = 0;
@@ -4074,7 +4078,8 @@ static int fd_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd,
 		return 0;
 
 	case FDFMTBEG:
-		LOCK_FDC(drive, 1);
+		if (lock_fdc(drive, 1))
+			return -EINTR;
 		CALL(poll_drive(1, FD_RAW_NEED_DISK));
 		ret = UDRS->flags;
 		process_fd_request();
@@ -4091,7 +4096,8 @@ static int fd_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd,
 
 	case FDFMTEND:
 	case FDFLUSH:
-		LOCK_FDC(drive, 1);
+		if (lock_fdc(drive, 1))
+			return -EINTR;
 		return invalidate_drive(bdev);
 
 	case FDSETEMSGTRESH:
@@ -4120,7 +4126,8 @@ static int fd_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd,
 		break;
 
 	case FDPOLLDRVSTAT:
-		LOCK_FDC(drive, 1);
+		if (lock_fdc(drive, 1))
+			return -EINTR;
 		CALL(poll_drive(1, FD_RAW_NEED_DISK));
 		process_fd_request();
 		/* fall through */
@@ -4147,14 +4154,16 @@ static int fd_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd,
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

