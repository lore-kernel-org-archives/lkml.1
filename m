Return-Path: <linux-kernel-owner+w=401wt.eu-S1753627Ab0AVEyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627Ab0AVEyY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 23:54:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753332Ab0AVExI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 23:53:08 -0500
Received: from mail.perches.com ([173.55.12.10]:1362 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752999Ab0AVExA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 23:53:00 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 16/24] drivers/block/floppy.c: Remove most uses of CALL and ECALL macros
Date: Thu, 21 Jan 2010 20:52:46 -0800
Message-Id: <73fcb1ec1d221fc17d386629a490b17efd3e16b2.1264133863.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1264133863.git.joe@perches.com>
References: <cover.1264133863.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/floppy.c |   51 ++++++++++++++++++++++++++++++++---------------
 1 files changed, 35 insertions(+), 16 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index b1c2bc6..822e4ee 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -3151,8 +3151,10 @@ static inline int raw_cmd_copyout(int cmd, char __user *param,
 			if (ptr->length >= 0 &&
 			    ptr->length <= ptr->buffer_length) {
 				long length = ptr->buffer_length - ptr->length;
-				ECALL(fd_copyout(ptr->data, ptr->kernel_data,
-						 length));
+				ret = fd_copyout(ptr->data, ptr->kernel_data,
+						 length);
+				if (ret)
+					return ret;
 			}
 		}
 		ptr = ptr->next;
@@ -3223,9 +3225,12 @@ static inline int raw_cmd_copyin(int cmd, char __user *param,
 				return -ENOMEM;
 			ptr->buffer_length = ptr->length;
 		}
-		if (ptr->flags & FD_RAW_WRITE)
-			ECALL(fd_copyin(ptr->data, ptr->kernel_data,
-					ptr->length));
+		if (ptr->flags & FD_RAW_WRITE) {
+			ret = fd_copyin(ptr->data, ptr->kernel_data,
+					ptr->length);
+			if (ret)
+				return ret;
+		}
 		rcmd = &(ptr->next);
 		if (!(ptr->flags & FD_RAW_MORE))
 			return 0;
@@ -3329,10 +3334,12 @@ static inline int set_geometry(unsigned int cmd, struct floppy_struct *g,
 
 		if (lock_fdc(drive, 1))
 			return -EINTR;
-		if (cmd != FDDEFPRM)
+		if (cmd != FDDEFPRM) {
 			/* notice a disk change immediately, else
 			 * we lose our settings immediately*/
-			CALL(poll_drive(1, FD_RAW_NEED_DISK));
+			if (poll_drive(1, FD_RAW_NEED_DISK) == -EINTR)
+				return -EINTR;
+		}
 		oldStretch = g->stretch;
 		user_params[drive] = *g;
 		if (buffer_drive == drive)
@@ -3413,7 +3420,8 @@ static int get_floppy_geometry(int drive, int type, struct floppy_struct **g)
 	else {
 		if (lock_fdc(drive, 0))
 			return -EINTR;
-		CALL(poll_drive(0, 0));
+		if (poll_drive(0, 0) == -EINTR)
+			return -EINTR;
 		process_fd_request();
 		*g = current_type[drive];
 	}
@@ -3471,7 +3479,9 @@ static int fd_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd,
 		return -EINVAL;
 
 	/* convert the old style command into a new style command */
-	ECALL(normalize_ioctl(&cmd, &size));
+	ret = normalize_ioctl(&cmd, &size);
+	if (ret)
+		return ret;
 
 	/* permission checks */
 	if (((cmd & 0x40) && !FD_IOCTL_ALLOWED) ||
@@ -3483,8 +3493,11 @@ static int fd_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd,
 
 	/* copyin */
 	memset(&inparam, 0, sizeof(inparam));
-	if (_IOC_DIR(cmd) & _IOC_WRITE)
-		ECALL(fd_copyin((void __user *)param, &inparam, size));
+	if (_IOC_DIR(cmd) & _IOC_WRITE) {
+		ret = fd_copyin((void __user *)param, &inparam, size);
+		if (ret)
+			return ret;
+	}
 
 	switch (cmd) {
 	case FDEJECT:
@@ -3513,9 +3526,11 @@ static int fd_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd,
 	case FDDEFPRM:
 		return set_geometry(cmd, &inparam.g, drive, type, bdev);
 	case FDGETPRM:
-		ECALL(get_floppy_geometry(drive, type,
+		ret = get_floppy_geometry(drive, type,
 					  (struct floppy_struct **)
-					  &outparam));
+					  &outparam);
+		if (ret)
+			return ret;
 		break;
 	case FDMSGON:
 		UDP->flags |= FTD_MSG;
@@ -3526,7 +3541,8 @@ static int fd_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd,
 	case FDFMTBEG:
 		if (lock_fdc(drive, 1))
 			return -EINTR;
-		CALL(poll_drive(1, FD_RAW_NEED_DISK));
+		if (poll_drive(1, FD_RAW_NEED_DISK) == -EINTR)
+			return -EINTR;
 		ret = UDRS->flags;
 		process_fd_request();
 		if (ret & FD_VERIFY)
@@ -3565,7 +3581,8 @@ static int fd_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd,
 	case FDPOLLDRVSTAT:
 		if (lock_fdc(drive, 1))
 			return -EINTR;
-		CALL(poll_drive(1, FD_RAW_NEED_DISK));
+		if (poll_drive(1, FD_RAW_NEED_DISK) == -EINTR)
+			return -EINTR;
 		process_fd_request();
 		/* fall through */
 	case FDGETDRVSTAT:
@@ -3588,7 +3605,9 @@ static int fd_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd,
 		if (lock_fdc(drive, 1))
 			return -EINTR;
 		set_floppy(drive);
-		CALL(i = raw_cmd_ioctl(cmd, (void __user *)param));
+		i = raw_cmd_ioctl(cmd, (void __user *)param);
+		if (i == -EINTR)
+			return -EINTR;
 		process_fd_request();
 		return i;
 	case FDTWADDLE:
-- 
1.6.6.rc0.57.gad7a

