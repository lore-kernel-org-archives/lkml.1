Return-Path: <linux-kernel-owner+w=401wt.eu-S1754727AbYAMUXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727AbYAMUXb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 15:23:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753827AbYAMUWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 15:22:16 -0500
Received: from smtp112.plus.mail.re1.yahoo.com ([69.147.102.75]:47787 "HELO
	smtp112.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753436AbYAMUWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 15:22:06 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References;
  b=RHXijtT7NSGR5uHcARverCdGEp2XSHOIR7B+bJ0CKnsxcaGTktintpg3sOqBjz9J3vNLpzJ3kx7Rawpx5HcAMecnbv7spLGH5JRv18J3G1A1Vrwh45+WuY/Cub6Kk2xwpCYoHdqSUXTTcyfanfHanrjm+VyeLjfwiyXRSU7XlZY=  ;
X-YMail-OSG: 1MjOjx0VM1kICJE0U0ZD8XxwXJjy0pskpr8AT64isPOTLtJVkJS709zeKiqw3S4iFTEvMc3TyQ--
X-Yahoo-Newman-Property: ymail-3
From: Borislav Petkov <bbpetkov@yahoo.de>
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>
Subject: [PATCH 4/12] ide-floppy: factor out ioctl handlers from idefloppy_ioctl()
Date: Sun, 13 Jan 2008 21:18:17 +0100
Message-Id: <1200255505-31418-5-git-send-email-bbpetkov@yahoo.de>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1200255505-31418-4-git-send-email-bbpetkov@yahoo.de>
References: <1200255505-31418-1-git-send-email-bbpetkov@yahoo.de>
 <1200255505-31418-2-git-send-email-bbpetkov@yahoo.de>
 <1200255505-31418-3-git-send-email-bbpetkov@yahoo.de>
 <1200255505-31418-4-git-send-email-bbpetkov@yahoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By passing idefloppy_floppy_t *floppy to the factored out functions, we get
rid of (almost) all local vars so stack usage should be at minimum here. Also,
we merge idefloppy_begin_format() into idefloppy_format_start() since it is its
only user. Also, rename idefloppy_format_start() to idefloppy_format_unit().
Finally, rename the reworked functions to ide_floppy..().

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
---
 drivers/ide/ide-floppy.c |  153 +++++++++++++++++++++++----------------------
 1 files changed, 78 insertions(+), 75 deletions(-)

diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 276731a..00ea8d6 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -1290,44 +1290,6 @@ static int ide_floppy_get_format_capacities(ide_drive_t *drive, int __user *arg)
 }
 
 /*
-** Send ATAPI_FORMAT_UNIT to the drive.
-**
-** Userland gives us the following structure:
-**
-** struct idefloppy_format_command {
-**        int nblocks;
-**        int blocksize;
-**        int flags;
-**        } ;
-**
-** flags is a bitmask, currently, the only defined flag is:
-**
-**        0x01 - verify media after format.
-*/
-
-static int idefloppy_begin_format(ide_drive_t *drive, int __user *arg)
-{
-	int blocks;
-	int length;
-	int flags;
-	idefloppy_pc_t pc;
-
-	if (get_user(blocks, arg) ||
-	    get_user(length, arg+1) ||
-	    get_user(flags, arg+2)) {
-		return (-EFAULT);
-	}
-
-	(void) idefloppy_get_sfrp_bit(drive);
-	idefloppy_create_format_unit_cmd(&pc, blocks, length, flags);
-	if (idefloppy_queue_pc_tail(drive, &pc)) {
-                return (-EIO);
-	}
-
-	return (0);
-}
-
-/*
 ** Get ATAPI_FORMAT_UNIT progress indication.
 **
 ** Userland gives a pointer to an int.  The int is set to a progress
@@ -1678,64 +1640,105 @@ static int idefloppy_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 	return 0;
 }
 
+static int ide_floppy_lockdoor(idefloppy_floppy_t *floppy, idefloppy_pc_t *pc,
+		unsigned long arg, unsigned int cmd)
+{
+	if (floppy->openers > 1)
+		return -EBUSY;
+
+	/* The IOMEGA Clik! Drive doesn't support this command -
+	 * no room for an eject mechanism */
+	if (!test_bit(IDEFLOPPY_CLIK_DRIVE, &floppy->flags)) {
+		int prevent = arg ? 1 : 0;
+
+		if (cmd == CDROMEJECT)
+			prevent = 0;
+
+		idefloppy_create_prevent_cmd(pc, prevent);
+		(void) idefloppy_queue_pc_tail(floppy->drive, pc);
+	}
+
+	if (cmd == CDROMEJECT) {
+		idefloppy_create_start_stop_cmd(pc, 2);
+		(void) idefloppy_queue_pc_tail(floppy->drive, pc);
+	}
+
+	return 0;
+}
+
+static int ide_floppy_format_unit(idefloppy_floppy_t *floppy,
+		int __user *arg)
+{
+	int blocks, length, flags, err = 0;
+	idefloppy_pc_t pc;
+
+	if (floppy->openers > 1) {
+		/* Don't format if someone is using the disk */
+		clear_bit(IDEFLOPPY_FORMAT_IN_PROGRESS, &floppy->flags);
+		return -EBUSY;
+	}
+
+	set_bit(IDEFLOPPY_FORMAT_IN_PROGRESS, &floppy->flags);
+
+	/*
+	 * Send ATAPI_FORMAT_UNIT to the drive.
+	 *
+	 * Userland gives us the following structure:
+	 *
+	 * struct idefloppy_format_command {
+	 *        int nblocks;
+	 *        int blocksize;
+	 *        int flags;
+	 *        } ;
+	 *
+	 * flags is a bitmask, currently, the only defined flag is:
+	 *
+	 *        0x01 - verify media after format.
+	 */
+	if (get_user(blocks, arg) ||
+			get_user(length, arg+1) ||
+			get_user(flags, arg+2)) {
+		err = -EFAULT;
+		goto out;
+	}
+
+	(void) idefloppy_get_sfrp_bit(floppy->drive);
+	idefloppy_create_format_unit_cmd(&pc, blocks, length, flags);
+
+	if (idefloppy_queue_pc_tail(floppy->drive, &pc))
+		err = -EIO;
+
+out:
+	if (err)
+		clear_bit(IDEFLOPPY_FORMAT_IN_PROGRESS, &floppy->flags);
+	return err;
+}
+
+
 static int idefloppy_ioctl(struct inode *inode, struct file *file,
 			unsigned int cmd, unsigned long arg)
 {
 	struct block_device *bdev = inode->i_bdev;
 	struct ide_floppy_obj *floppy = ide_floppy_g(bdev->bd_disk);
 	ide_drive_t *drive = floppy->drive;
+	idefloppy_pc_t pc;
 	void __user *argp = (void __user *)arg;
 	int err;
-	int prevent = (arg) ? 1 : 0;
-	idefloppy_pc_t pc;
 
 	switch (cmd) {
 	case CDROMEJECT:
-		prevent = 0;
 		/* fall through */
 	case CDROM_LOCKDOOR:
-		if (floppy->openers > 1)
-			return -EBUSY;
-
-		/* The IOMEGA Clik! Drive doesn't support this command - no room for an eject mechanism */
-                if (!test_bit(IDEFLOPPY_CLIK_DRIVE, &floppy->flags)) {
-			idefloppy_create_prevent_cmd(&pc, prevent);
-			(void) idefloppy_queue_pc_tail(drive, &pc);
-		}
-		if (cmd == CDROMEJECT) {
-			idefloppy_create_start_stop_cmd(&pc, 2);
-			(void) idefloppy_queue_pc_tail(drive, &pc);
-		}
-		return 0;
+		return ide_floppy_lockdoor(floppy, &pc, arg, cmd);
 	case IDEFLOPPY_IOCTL_FORMAT_SUPPORTED:
 		return 0;
 	case IDEFLOPPY_IOCTL_FORMAT_GET_CAPACITY:
 		return ide_floppy_get_format_capacities(drive, argp);
 	case IDEFLOPPY_IOCTL_FORMAT_START:
-
 		if (!(file->f_mode & 2))
 			return -EPERM;
 
-		if (floppy->openers > 1) {
-			/* Don't format if someone is using the disk */
-
-			clear_bit(IDEFLOPPY_FORMAT_IN_PROGRESS,
-				  &floppy->flags);
-			return -EBUSY;
-		}
-
-		set_bit(IDEFLOPPY_FORMAT_IN_PROGRESS, &floppy->flags);
-
-		err = idefloppy_begin_format(drive, argp);
-		if (err)
-			clear_bit(IDEFLOPPY_FORMAT_IN_PROGRESS, &floppy->flags);
-		return err;
-		/*
-		** Note, the bit will be cleared when the device is
-		** closed.  This is the cleanest way to handle the
-		** situation where the drive does not support
-		** format progress reporting.
-		*/
+		return ide_floppy_format_unit(floppy, (int __user *)arg);
 	case IDEFLOPPY_IOCTL_FORMAT_GET_PROGRESS:
 		return idefloppy_get_format_progress(drive, argp);
 	}
-- 
1.5.3.7

