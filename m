Return-Path: <linux-kernel-owner+w=401wt.eu-S1755897Ab0A0Usy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897Ab0A0Usy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 15:48:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932156Ab0A0Uss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 15:48:48 -0500
Received: from mail.perches.com ([173.55.12.10]:1548 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755449Ab0A0Uqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 15:46:36 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH 13/13] drivers/block/floppy.c: Remove unnecessary casting in fd_ioctl
Date: Wed, 27 Jan 2010 12:46:29 -0800
Message-Id: <067e97c37957415da24af8237a6846646836fa79.1264624292.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1264624291.git.joe@perches.com>
References: <cover.1264624291.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert outparam to const void *
Cast outparam to const char * for strlen

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/floppy.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 623fda5..389ae43 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -3431,7 +3431,7 @@ static int fd_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd,
 		struct floppy_max_errors max_errors;
 		struct floppy_drive_params dp;
 	} inparam;		/* parameters coming from user space */
-	const char *outparam;	/* parameters passed back to user space */
+	const void *outparam;	/* parameters passed back to user space */
 
 	/* convert compatibility eject ioctls into floppy eject ioctl.
 	 * We do this in order to provide a means to eject floppy disks before
@@ -3495,8 +3495,7 @@ static int fd_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd,
 		return set_geometry(cmd, &inparam.g, drive, type, bdev);
 	case FDGETPRM:
 		ret = get_floppy_geometry(drive, type,
-					  (struct floppy_struct **)
-					  &outparam);
+					  (struct floppy_struct **)&outparam);
 		if (ret)
 			return ret;
 		break;
@@ -3531,20 +3530,20 @@ static int fd_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd,
 		UDP->max_errors.reporting = (unsigned short)(param & 0x0f);
 		return 0;
 	case FDGETMAXERRS:
-		outparam = (const char *)&UDP->max_errors;
+		outparam = &UDP->max_errors;
 		break;
 	case FDSETMAXERRS:
 		UDP->max_errors = inparam.max_errors;
 		break;
 	case FDGETDRVTYP:
 		outparam = drive_name(type, drive);
-		SUPBOUND(size, strlen(outparam) + 1);
+		SUPBOUND(size, strlen((const char *)outparam) + 1);
 		break;
 	case FDSETDRVPRM:
 		*UDP = inparam.dp;
 		break;
 	case FDGETDRVPRM:
-		outparam = (const char *)UDP;
+		outparam = UDP;
 		break;
 	case FDPOLLDRVSTAT:
 		if (lock_fdc(drive, true))
@@ -3554,18 +3553,18 @@ static int fd_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd,
 		process_fd_request();
 		/* fall through */
 	case FDGETDRVSTAT:
-		outparam = (const char *)UDRS;
+		outparam = UDRS;
 		break;
 	case FDRESET:
 		return user_reset_fdc(drive, (int)param, true);
 	case FDGETFDCSTAT:
-		outparam = (const char *)UFDCS;
+		outparam = UFDCS;
 		break;
 	case FDWERRORCLR:
 		memset(UDRWE, 0, sizeof(*UDRWE));
 		return 0;
 	case FDWERRORGET:
-		outparam = (const char *)UDRWE;
+		outparam = UDRWE;
 		break;
 	case FDRAWCMD:
 		if (type)
-- 
1.6.6.rc0.57.gad7a

