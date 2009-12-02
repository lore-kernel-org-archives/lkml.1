Return-Path: <linux-kernel-owner+w=401wt.eu-S1753428AbZLBGHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428AbZLBGHz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 01:07:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752870AbZLBGHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 01:07:53 -0500
Received: from mail.perches.com ([173.55.12.10]:1225 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752828AbZLBGHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 01:07:49 -0500
From: Joe Perches <joe@perches.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH 07/13] drivers/block/floppy.c: convert int 1/0 to bool true/false
Date: Tue,  1 Dec 2009 22:07:47 -0800
Message-Id: <5179a65ec29ada142d4a75e5574099728276cfe0.1259733457.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1259733456.git.joe@perches.com>
References: <cover.1259733456.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Various functions use int where bool is appropriate
lock_fdc, wait_til_done, poll_drive, user_reset_fdc

Convert to bool

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/floppy.c |   60 ++++++++++++++++++++++++------------------------
 1 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 9665ab2..90352f6 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -1387,7 +1387,7 @@ static void set_fdc(int drive)
 }
 
 /* locks the driver */
-static int _lock_fdc(int drive, int interruptible, int line)
+static int _lock_fdc(int drive, bool interruptible, int line)
 {
 	if (!usage_count) {
 		pr_err("Trying to lock fdc while usage count=0 at line %d\n",
@@ -2548,7 +2548,7 @@ static struct cont_t intr_cont = {
 	.done		= (done_f)empty
 };
 
-static int wait_til_done(void (*handler)(void), int interruptible)
+static int wait_til_done(void (*handler)(void), bool interruptible)
 {
 	int ret;
 
@@ -2774,7 +2774,7 @@ static int do_format(int drive, struct format_descr *tmp_format_req)
 {
 	int ret;
 
-	if (lock_fdc(drive, 1))
+	if (lock_fdc(drive, true))
 		return -EINTR;
 
 	set_floppy(drive);
@@ -2791,7 +2791,7 @@ static int do_format(int drive, struct format_descr *tmp_format_req)
 	format_errors = 0;
 	cont = &format_cont;
 	errors = &format_errors;
-	ret = wait_til_done(redo_format, 1);
+	ret = wait_til_done(redo_format, true);
 	if (ret == -EINTR)
 		return -EINTR;
 	process_fd_request();
@@ -3507,7 +3507,7 @@ static void do_fd_request(struct request_queue *q)
 		is_alive("do fd request, old request running");
 		return;
 	}
-	lock_fdc(MAXTIMEOUT, 0);
+	lock_fdc(MAXTIMEOUT, false);
 	process_fd_request();
 	is_alive("do fd request");
 }
@@ -3519,7 +3519,7 @@ static struct cont_t poll_cont = {
 	.done		= generic_done
 };
 
-static int poll_drive(int interruptible, int flag)
+static int poll_drive(bool interruptible, int flag)
 {
 	/* no auto-sense, just clear dcl */
 	raw_cmd = &default_raw_cmd;
@@ -3550,7 +3550,7 @@ static struct cont_t reset_cont = {
 	.done		= generic_done
 };
 
-static int user_reset_fdc(int drive, int arg, int interruptible)
+static int user_reset_fdc(int drive, int arg, bool interruptible)
 {
 	int ret;
 
@@ -3791,7 +3791,7 @@ static int raw_cmd_ioctl(int cmd, void __user *param)
 
 	raw_cmd = my_raw_cmd;
 	cont = &raw_cmd_cont;
-	ret = wait_til_done(floppy_start, 1);
+	ret = wait_til_done(floppy_start, true);
 	debug_dcl(DP->flags, "calling disk change from raw_cmd ioctl\n");
 
 	if (ret != -EINTR && FDCS->reset)
@@ -3831,7 +3831,7 @@ static inline int set_geometry(unsigned int cmd, struct floppy_struct *g,
 		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;
 		mutex_lock(&open_lock);
-		if (lock_fdc(drive, 1)) {
+		if (lock_fdc(drive, true)) {
 			mutex_unlock(&open_lock);
 			return -EINTR;
 		}
@@ -3851,12 +3851,12 @@ static inline int set_geometry(unsigned int cmd, struct floppy_struct *g,
 	} else {
 		int oldStretch;
 
-		if (lock_fdc(drive, 1))
+		if (lock_fdc(drive, true))
 			return -EINTR;
 		if (cmd != FDDEFPRM) {
 			/* notice a disk change immediately, else
 			 * we lose our settings immediately*/
-			if (poll_drive(1, FD_RAW_NEED_DISK) == -EINTR)
+			if (poll_drive(true, FD_RAW_NEED_DISK) == -EINTR)
 				return -EINTR;
 		}
 		oldStretch = g->stretch;
@@ -3937,9 +3937,9 @@ static int get_floppy_geometry(int drive, int type, struct floppy_struct **g)
 	if (type)
 		*g = &floppy_type[type];
 	else {
-		if (lock_fdc(drive, 0))
+		if (lock_fdc(drive, false))
 			return -EINTR;
-		if (poll_drive(0, 0) == -EINTR)
+		if (poll_drive(false, 0) == -EINTR)
 			return -EINTR;
 		process_fd_request();
 		*g = current_type[drive];
@@ -4019,7 +4019,7 @@ static int fd_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd,
 		if (UDRS->fd_ref != 1)
 			/* somebody else has this drive open */
 			return -EBUSY;
-		if (lock_fdc(drive, 1))
+		if (lock_fdc(drive, true))
 			return -EINTR;
 
 		/* do the actual eject. Fails on
@@ -4032,7 +4032,7 @@ static int fd_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd,
 		return ret;
 
 	case FDCLRPRM:
-		if (lock_fdc(drive, 1))
+		if (lock_fdc(drive, true))
 			return -EINTR;
 		current_type[drive] = NULL;
 		floppy_sizes[drive] = MAX_DISK_SIZE << 1;
@@ -4060,9 +4060,9 @@ static int fd_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd,
 		return 0;
 
 	case FDFMTBEG:
-		if (lock_fdc(drive, 1))
+		if (lock_fdc(drive, true))
 			return -EINTR;
-		if (poll_drive(1, FD_RAW_NEED_DISK) == -EINTR)
+		if (poll_drive(true, FD_RAW_NEED_DISK) == -EINTR)
 			return -EINTR;
 		ret = UDRS->flags;
 		process_fd_request();
@@ -4079,7 +4079,7 @@ static int fd_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd,
 
 	case FDFMTEND:
 	case FDFLUSH:
-		if (lock_fdc(drive, 1))
+		if (lock_fdc(drive, true))
 			return -EINTR;
 		return invalidate_drive(bdev);
 
@@ -4109,9 +4109,9 @@ static int fd_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd,
 		break;
 
 	case FDPOLLDRVSTAT:
-		if (lock_fdc(drive, 1))
+		if (lock_fdc(drive, true))
 			return -EINTR;
-		if (poll_drive(1, FD_RAW_NEED_DISK) == -EINTR)
+		if (poll_drive(true, FD_RAW_NEED_DISK) == -EINTR)
 			return -EINTR;
 		process_fd_request();
 		/* fall through */
@@ -4121,7 +4121,7 @@ static int fd_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd,
 		break;
 
 	case FDRESET:
-		return user_reset_fdc(drive, (int)param, 1);
+		return user_reset_fdc(drive, (int)param, true);
 
 	case FDGETFDCSTAT:
 		outparam = (const char *)UFDCS;
@@ -4138,7 +4138,7 @@ static int fd_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd,
 	case FDRAWCMD:
 		if (type)
 			return -EINVAL;
-		if (lock_fdc(drive, 1))
+		if (lock_fdc(drive, true))
 			return -EINTR;
 		set_floppy(drive);
 		i = raw_cmd_ioctl(cmd, (void __user *)param);
@@ -4148,7 +4148,7 @@ static int fd_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd,
 		return i;
 
 	case FDTWADDLE:
-		if (lock_fdc(drive, 1))
+		if (lock_fdc(drive, true))
 			return -EINTR;
 		twaddle();
 		process_fd_request();
@@ -4344,8 +4344,8 @@ static int check_floppy_change(struct gendisk *disk)
 		return 1;
 
 	if (time_after(jiffies, UDRS->last_checked + UDP->checkfreq)) {
-		lock_fdc(drive, 0);
-		poll_drive(0, 0);
+		lock_fdc(drive, false);
+		poll_drive(false, 0);
 		process_fd_request();
 	}
 
@@ -4428,7 +4428,7 @@ static int floppy_revalidate(struct gendisk *disk)
 			pr_info("VFS: revalidate called on non-open device.\n");
 			return -EFAULT;
 		}
-		lock_fdc(drive, 0);
+		lock_fdc(drive, false);
 		cf = (test_bit(FD_DISK_CHANGED_BIT, &UDRS->flags) ||
 		      test_bit(FD_VERIFY_BIT, &UDRS->flags));
 		if (!(cf || test_bit(drive, &fake_change) || NO_GEOM)) {
@@ -4449,7 +4449,7 @@ static int floppy_revalidate(struct gendisk *disk)
 			res = __floppy_read_block_0(opened_bdev[drive]);
 		} else {
 			if (cf)
-				poll_drive(0, FD_RAW_NEED_DISK);
+				poll_drive(false, FD_RAW_NEED_DISK);
 			process_fd_request();
 		}
 	}
@@ -4851,7 +4851,7 @@ static int floppy_resume(struct device *dev)
 
 	for (fdc = 0; fdc < N_FDC; fdc++)
 		if (FDCS->address != -1)
-			user_reset_fdc(-1, FD_RESET_ALWAYS, 0);
+			user_reset_fdc(-1, FD_RESET_ALWAYS, false);
 
 	return 0;
 }
@@ -4998,7 +4998,7 @@ static int __init floppy_init(void)
 		if (FDCS->address == -1)
 			continue;
 		FDCS->rawcmd = 2;
-		if (user_reset_fdc(-1, FD_RESET_ALWAYS, 0)) {
+		if (user_reset_fdc(-1, FD_RESET_ALWAYS, false)) {
 			/* free ioports reserved by floppy_grab_irq_and_dma() */
 			floppy_release_regions(fdc);
 			FDCS->address = -1;
@@ -5021,7 +5021,7 @@ static int __init floppy_init(void)
 		 * properly, so force a reset for the standard FDC clones,
 		 * to avoid interrupt garbage.
 		 */
-		user_reset_fdc(-1, FD_RESET_ALWAYS, 0);
+		user_reset_fdc(-1, FD_RESET_ALWAYS, false);
 	}
 	fdc = 0;
 	del_timer(&fd_timeout);
-- 
1.6.6.rc0.57.gad7a

