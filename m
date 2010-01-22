Return-Path: <linux-kernel-owner+w=401wt.eu-S1753117Ab0AVEzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117Ab0AVEzK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 23:55:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753124Ab0AVExC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 23:53:02 -0500
Received: from mail.perches.com ([173.55.12.10]:1353 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752905Ab0AVEw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 23:52:59 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 11/24] drivers/block/floppy.c: Remove IN/OUT macros, indent switch/case
Date: Thu, 21 Jan 2010 20:52:41 -0800
Message-Id: <12d2a54858c2591bb51e711521e27a9d1e4c15cb.1264133863.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1264133863.git.joe@perches.com>
References: <cover.1264133863.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove ugly IN/OUT macros, use direct case and code
Add missing semicolon after ECALL

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/floppy.c |  218 +++++++++++++++++++++++------------------------
 1 files changed, 107 insertions(+), 111 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 0813c10..d93fc9d 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -3466,8 +3466,6 @@ static int fd_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd,
 		    unsigned long param)
 {
 #define FD_IOCTL_ALLOWED (mode & (FMODE_WRITE|FMODE_WRITE_IOCTL))
-#define OUT(c,x) case c: outparam = (const char *) (x); break
-#define IN(c,x,tag) case c: *(x) = inparam. tag ; return 0
 
 	int drive = (long)bdev->bd_disk->private_data;
 	int type = ITYPE(UDRS->fd_device);
@@ -3509,122 +3507,120 @@ static int fd_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd,
 	/* copyin */
 	memset(&inparam, 0, sizeof(inparam));
 	if (_IOC_DIR(cmd) & _IOC_WRITE)
-	    ECALL(fd_copyin((void __user *)param, &inparam, size))
+		ECALL(fd_copyin((void __user *)param, &inparam, size));
 
-		switch (cmd) {
-		case FDEJECT:
-			if (UDRS->fd_ref != 1)
-				/* somebody else has this drive open */
-				return -EBUSY;
-			LOCK_FDC(drive, 1);
-
-			/* do the actual eject. Fails on
-			 * non-Sparc architectures */
-			ret = fd_eject(UNIT(drive));
-
-			USETF(FD_DISK_CHANGED);
-			USETF(FD_VERIFY);
-			process_fd_request();
-			return ret;
-		case FDCLRPRM:
-			LOCK_FDC(drive, 1);
-			current_type[drive] = NULL;
-			floppy_sizes[drive] = MAX_DISK_SIZE << 1;
-			UDRS->keep_data = 0;
-			return invalidate_drive(bdev);
-		case FDSETPRM:
-		case FDDEFPRM:
-			return set_geometry(cmd, &inparam.g,
-					    drive, type, bdev);
-		case FDGETPRM:
-			ECALL(get_floppy_geometry(drive, type,
-						  (struct floppy_struct **)
-						  &outparam));
-			break;
-
-		case FDMSGON:
-			UDP->flags |= FTD_MSG;
-			return 0;
-		case FDMSGOFF:
-			UDP->flags &= ~FTD_MSG;
-			return 0;
-
-		case FDFMTBEG:
-			LOCK_FDC(drive, 1);
-			CALL(poll_drive(1, FD_RAW_NEED_DISK));
-			ret = UDRS->flags;
-			process_fd_request();
-			if (ret & FD_VERIFY)
-				return -ENODEV;
-			if (!(ret & FD_DISK_WRITABLE))
-				return -EROFS;
-			return 0;
-		case FDFMTTRK:
-			if (UDRS->fd_ref != 1)
-				return -EBUSY;
-			return do_format(drive, &inparam.f);
-		case FDFMTEND:
-		case FDFLUSH:
-			LOCK_FDC(drive, 1);
-			return invalidate_drive(bdev);
-
-		case FDSETEMSGTRESH:
-			UDP->max_errors.reporting =
-			    (unsigned short)(param & 0x0f);
-			return 0;
-			OUT(FDGETMAXERRS, &UDP->max_errors);
-			IN(FDSETMAXERRS, &UDP->max_errors, max_errors);
-
-		case FDGETDRVTYP:
-			outparam = drive_name(type, drive);
-			SUPBOUND(size, strlen(outparam) + 1);
-			break;
-
-			IN(FDSETDRVPRM, UDP, dp);
-			OUT(FDGETDRVPRM, UDP);
-
-		case FDPOLLDRVSTAT:
-			LOCK_FDC(drive, 1);
-			CALL(poll_drive(1, FD_RAW_NEED_DISK));
-			process_fd_request();
-			/* fall through */
-			OUT(FDGETDRVSTAT, UDRS);
-
-		case FDRESET:
-			return user_reset_fdc(drive, (int)param, 1);
-
-			OUT(FDGETFDCSTAT, UFDCS);
-
-		case FDWERRORCLR:
-			memset(UDRWE, 0, sizeof(*UDRWE));
-			return 0;
-			OUT(FDWERRORGET, UDRWE);
-
-		case FDRAWCMD:
-			if (type)
-				return -EINVAL;
-			LOCK_FDC(drive, 1);
-			set_floppy(drive);
-			CALL(i = raw_cmd_ioctl(cmd, (void __user *)param));
-			process_fd_request();
-			return i;
+	switch (cmd) {
+	case FDEJECT:
+		if (UDRS->fd_ref != 1)
+			/* somebody else has this drive open */
+			return -EBUSY;
+		LOCK_FDC(drive, 1);
 
-		case FDTWADDLE:
-			LOCK_FDC(drive, 1);
-			twaddle();
-			process_fd_request();
-			return 0;
+		/* do the actual eject. Fails on
+		 * non-Sparc architectures */
+		ret = fd_eject(UNIT(drive));
 
-		default:
+		USETF(FD_DISK_CHANGED);
+		USETF(FD_VERIFY);
+		process_fd_request();
+		return ret;
+	case FDCLRPRM:
+		LOCK_FDC(drive, 1);
+		current_type[drive] = NULL;
+		floppy_sizes[drive] = MAX_DISK_SIZE << 1;
+		UDRS->keep_data = 0;
+		return invalidate_drive(bdev);
+	case FDSETPRM:
+	case FDDEFPRM:
+		return set_geometry(cmd, &inparam.g, drive, type, bdev);
+	case FDGETPRM:
+		ECALL(get_floppy_geometry(drive, type,
+					  (struct floppy_struct **)
+					  &outparam));
+		break;
+	case FDMSGON:
+		UDP->flags |= FTD_MSG;
+		return 0;
+	case FDMSGOFF:
+		UDP->flags &= ~FTD_MSG;
+		return 0;
+	case FDFMTBEG:
+		LOCK_FDC(drive, 1);
+		CALL(poll_drive(1, FD_RAW_NEED_DISK));
+		ret = UDRS->flags;
+		process_fd_request();
+		if (ret & FD_VERIFY)
+			return -ENODEV;
+		if (!(ret & FD_DISK_WRITABLE))
+			return -EROFS;
+		return 0;
+	case FDFMTTRK:
+		if (UDRS->fd_ref != 1)
+			return -EBUSY;
+		return do_format(drive, &inparam.f);
+	case FDFMTEND:
+	case FDFLUSH:
+		LOCK_FDC(drive, 1);
+		return invalidate_drive(bdev);
+	case FDSETEMSGTRESH:
+		UDP->max_errors.reporting = (unsigned short)(param & 0x0f);
+		return 0;
+	case FDGETMAXERRS:
+		outparam = (const char *)&UDP->max_errors;
+		break;
+	case FDSETMAXERRS:
+		UDP->max_errors = inparam.max_errors;
+		break;
+	case FDGETDRVTYP:
+		outparam = drive_name(type, drive);
+		SUPBOUND(size, strlen(outparam) + 1);
+		break;
+	case FDSETDRVPRM:
+		*UDP = inparam.dp;
+		break;
+	case FDGETDRVPRM:
+		outparam = (const char *)UDP;
+		break;
+	case FDPOLLDRVSTAT:
+		LOCK_FDC(drive, 1);
+		CALL(poll_drive(1, FD_RAW_NEED_DISK));
+		process_fd_request();
+		/* fall through */
+	case FDGETDRVSTAT:
+		outparam = (const char *)UDRS;
+		break;
+	case FDRESET:
+		return user_reset_fdc(drive, (int)param, 1);
+	case FDGETFDCSTAT:
+		outparam = (const char *)UFDCS;
+		break;
+	case FDWERRORCLR:
+		memset(UDRWE, 0, sizeof(*UDRWE));
+		return 0;
+	case FDWERRORGET:
+		outparam = (const char *)UDRWE;
+		break;
+	case FDRAWCMD:
+		if (type)
 			return -EINVAL;
-		}
+		LOCK_FDC(drive, 1);
+		set_floppy(drive);
+		CALL(i = raw_cmd_ioctl(cmd, (void __user *)param));
+		process_fd_request();
+		return i;
+	case FDTWADDLE:
+		LOCK_FDC(drive, 1);
+		twaddle();
+		process_fd_request();
+		return 0;
+	default:
+		return -EINVAL;
+	}
 
 	if (_IOC_DIR(cmd) & _IOC_READ)
 		return fd_copyout((void __user *)param, outparam, size);
-	else
-		return 0;
-#undef OUT
-#undef IN
+
+	return 0;
 }
 
 static void __init config_types(void)
-- 
1.6.6.rc0.57.gad7a

