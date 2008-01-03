Return-Path: <linux-kernel-owner+w=401wt.eu-S1754424AbYACNXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424AbYACNXq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 08:23:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752370AbYACNXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 08:23:05 -0500
Received: from smtp106.plus.mail.re1.yahoo.com ([69.147.102.69]:24883 "HELO
	smtp106.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751988AbYACNXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 08:23:00 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References;
  b=dg5r4dz0C8IvEr/VpXs0AVPVLPp0Che8BknqezyTUvI1sDqSTIhjS5wlHPnXe1eJ5Q/D78wtav6AhyxczzPsioUN00D0v5aJS+vbxcFLg2rLPkHaehKCq5QY8IznAXjbsmWVSAatVnKKYLjutAezJ64PdVMbee+d+DMotelkzkg=  ;
X-YMail-OSG: ycqT8yEVM1lRTWoZaw5HjUkLlFqMeSsE20hu68j4eyamlVo98qCK2ma0AD.QLSffb0.8wf2NLA--
From: Borislav Petkov <bbpetkov@yahoo.de>
To: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: bzolnier@gmail.com, Borislav Petkov <bbpetkov@yahoo.de>
Subject: [RESEND PATCH 05/10] ide-floppy: factor out ioctl handlers from idefloppy_ioctl()
Date: Thu,  3 Jan 2008 14:20:04 +0100
Message-Id: <1199366409-26016-6-git-send-email-bbpetkov@yahoo.de>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1199366409-26016-5-git-send-email-bbpetkov@yahoo.de>
References: <1199366409-26016-1-git-send-email-bbpetkov@yahoo.de>
 <1199366409-26016-2-git-send-email-bbpetkov@yahoo.de>
 <1199366409-26016-3-git-send-email-bbpetkov@yahoo.de>
 <1199366409-26016-4-git-send-email-bbpetkov@yahoo.de>
 <1199366409-26016-5-git-send-email-bbpetkov@yahoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functional change resulting from this patch.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
---
 drivers/ide/ide-floppy.c |   90 +++++++++++++++++++++++++++++-----------------
 1 files changed, 57 insertions(+), 33 deletions(-)

diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 196a697..7823447 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -1600,6 +1600,58 @@ static int idefloppy_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 	return 0;
 }
 
+static int idefloppy_lockdoor(struct inode *inode, idefloppy_pc_t *pc,
+		int event, unsigned int cmd)
+{
+	struct block_device *bdev = inode->i_bdev;
+	struct ide_floppy_obj *floppy = ide_floppy_g(bdev->bd_disk);
+	ide_drive_t *drive = floppy->drive;
+
+	if (floppy->openers > 1)
+		return -EBUSY;
+
+	/* The IOMEGA Clik! Drive doesn't support this command -
+	 * no room for an eject mechanism */
+	if (!test_bit(IDEFLOPPY_CLIK_DRIVE, &floppy->flags)) {
+		idefloppy_create_prevent_cmd(pc, event);
+		(void) idefloppy_queue_pc_tail(drive, pc);
+	}
+
+	if (cmd == CDROMEJECT) {
+		idefloppy_create_start_stop_cmd(pc, 2);
+		(void) idefloppy_queue_pc_tail(drive, pc);
+	}
+
+	return 0;
+}
+
+static
+int idefloppy_format_start(struct file *file, struct inode *inode,
+		void __user *argp)
+{
+	struct block_device *bdev = inode->i_bdev;
+	struct ide_floppy_obj *floppy = ide_floppy_g(bdev->bd_disk);
+	ide_drive_t *drive = floppy->drive;
+	int err;
+
+	if (!(file->f_mode & 2))
+		return -EPERM;
+
+	if (floppy->openers > 1) {
+		/* Don't format if someone is using the disk */
+		clear_bit(IDEFLOPPY_FORMAT_IN_PROGRESS, &floppy->flags);
+		return -EBUSY;
+	}
+
+	set_bit(IDEFLOPPY_FORMAT_IN_PROGRESS, &floppy->flags);
+
+	err = idefloppy_begin_format(drive, argp);
+	if (err)
+		clear_bit(IDEFLOPPY_FORMAT_IN_PROGRESS, &floppy->flags);
+
+	return err;
+}
+
 static int idefloppy_ioctl(struct inode *inode, struct file *file,
 			unsigned int cmd, unsigned long arg)
 {
@@ -1612,47 +1664,19 @@ static int idefloppy_ioctl(struct inode *inode, struct file *file,
 	idefloppy_pc_t pc;
 
 	switch (cmd) {
+
 	case CDROMEJECT:
 		prevent = 0;
 		/* fall through */
-	case CDROM_LOCKDOOR:
-		if (floppy->openers > 1)
-			return -EBUSY;
 
-		/* The IOMEGA Clik! Drive doesn't support this command -
-		 * no room for an eject mechanism */
-                if (!test_bit(IDEFLOPPY_CLIK_DRIVE, &floppy->flags)) {
-			idefloppy_create_prevent_cmd(&pc, prevent);
-			(void) idefloppy_queue_pc_tail(drive, &pc);
-		}
-		if (cmd == CDROMEJECT) {
-			idefloppy_create_start_stop_cmd(&pc, 2);
-			(void) idefloppy_queue_pc_tail(drive, &pc);
-		}
-		return 0;
+	case CDROM_LOCKDOOR:
+		return idefloppy_lockdoor(inode, &pc, prevent, cmd);
 	case IDEFLOPPY_IOCTL_FORMAT_SUPPORTED:
 		return 0;
 	case IDEFLOPPY_IOCTL_FORMAT_GET_CAPACITY:
 		return idefloppy_get_format_capacities(drive, argp);
 	case IDEFLOPPY_IOCTL_FORMAT_START:
-
-		if (!(file->f_mode & 2))
-			return -EPERM;
-
-		if (floppy->openers > 1) {
-
-			/* Don't format if someone is using the disk */
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
+		return idefloppy_format_start(file, inode, argp);
 		/*
 		 * Note, the bit will be cleared when the device is
 		 * closed.  This is the cleanest way to handle the
@@ -1669,7 +1693,7 @@ static int idefloppy_ioctl(struct inode *inode, struct file *file,
 	 */
 	if (cmd != CDROM_SEND_PACKET && cmd != SCSI_IOCTL_SEND_COMMAND)
 		err = scsi_cmd_ioctl(file, bdev->bd_disk->queue,
-					bdev->bd_disk, cmd, argp);
+				bdev->bd_disk, cmd, argp);
 	else
 		err = -ENOTTY;
 
-- 
1.5.3.7

