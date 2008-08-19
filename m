Return-Path: <linux-kernel-owner+w=401wt.eu-S1756744AbYHSSmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744AbYHSSmz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 14:42:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755003AbYHSSmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 14:42:10 -0400
Received: from gv-out-0910.google.com ([216.239.58.187]:25109 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754755AbYHSSmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 14:42:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=g+G8MXCzWvU0WMYbVEHSDKHETrETG6Ik2ytG1kkT2/oeIBy25j1crtc7/WR+hTKbnl
         lSOOn1TQ/aHSe8eNsYuJZ72rOSrZwlH8jANmYJzDKY3cGwnV/P5sjbAd2CB1mnX/w33o
         LJv160IVZdN2loMqLYgpHMPoVikpANPWYZnfI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 19 Aug 2008 20:39:48 +0200
Message-Id: <20080819183948.16469.60793.sendpatchset@localhost.localdomain>
In-Reply-To: <20080819183934.16469.69799.sendpatchset@localhost.localdomain>
References: <20080819183934.16469.69799.sendpatchset@localhost.localdomain>
Subject: [PATCH 3/6] ide-floppy: move all ioctl handling to ide-floppy_ioctl.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While at it:
- idefloppy_ioctl() -> ide_floppy_ioctl()

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-floppy.c       |   52 ---------------------------------------
 drivers/ide/ide-floppy.h       |    3 --
 drivers/ide/ide-floppy_ioctl.c |   54 +++++++++++++++++++++++++++++++++++++++--
 3 files changed, 54 insertions(+), 55 deletions(-)

Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -767,56 +767,6 @@ static int idefloppy_getgeo(struct block
 	return 0;
 }
 
-static int ide_floppy_lockdoor(ide_drive_t *drive, struct ide_atapi_pc *pc,
-			       unsigned long arg, unsigned int cmd)
-{
-	idefloppy_floppy_t *floppy = drive->driver_data;
-	struct gendisk *disk = floppy->disk;
-	int prevent = (arg && cmd != CDROMEJECT) ? 1 : 0;
-
-	if (floppy->openers > 1)
-		return -EBUSY;
-
-	ide_set_media_lock(drive, disk, prevent);
-
-	if (cmd == CDROMEJECT)
-		ide_do_start_stop(drive, disk, 2);
-
-	return 0;
-}
-
-static int idefloppy_ioctl(struct inode *inode, struct file *file,
-			unsigned int cmd, unsigned long arg)
-{
-	struct block_device *bdev = inode->i_bdev;
-	struct ide_floppy_obj *floppy = ide_drv_g(bdev->bd_disk,
-						     ide_floppy_obj);
-	ide_drive_t *drive = floppy->drive;
-	struct ide_atapi_pc pc;
-	void __user *argp = (void __user *)arg;
-	int err;
-
-	if (cmd == CDROMEJECT || cmd == CDROM_LOCKDOOR)
-		return ide_floppy_lockdoor(drive, &pc, arg, cmd);
-
-	err = ide_floppy_format_ioctl(drive, file, cmd, argp);
-	if (err != -ENOTTY)
-		return err;
-
-	/*
-	 * skip SCSI_IOCTL_SEND_COMMAND (deprecated)
-	 * and CDROM_SEND_PACKET (legacy) ioctls
-	 */
-	if (cmd != CDROM_SEND_PACKET && cmd != SCSI_IOCTL_SEND_COMMAND)
-		err = scsi_cmd_ioctl(file, bdev->bd_disk->queue,
-					bdev->bd_disk, cmd, argp);
-
-	if (err == -ENOTTY)
-		err = generic_ide_ioctl(drive, file, bdev, cmd, arg);
-
-	return err;
-}
-
 static int idefloppy_media_changed(struct gendisk *disk)
 {
 	struct ide_floppy_obj *floppy = ide_drv_g(disk, ide_floppy_obj);
@@ -844,7 +794,7 @@ static struct block_device_operations id
 	.owner			= THIS_MODULE,
 	.open			= idefloppy_open,
 	.release		= idefloppy_release,
-	.ioctl			= idefloppy_ioctl,
+	.ioctl			= ide_floppy_ioctl,
 	.getgeo			= idefloppy_getgeo,
 	.media_changed		= idefloppy_media_changed,
 	.revalidate_disk	= idefloppy_revalidate_disk
Index: b/drivers/ide/ide-floppy.h
===================================================================
--- a/drivers/ide/ide-floppy.h
+++ b/drivers/ide/ide-floppy.h
@@ -50,7 +50,6 @@ void ide_floppy_create_mode_sense_cmd(st
 void ide_floppy_create_read_capacity_cmd(struct ide_atapi_pc *);
 
 /* ide-floppy_ioctl.c */
-int ide_floppy_format_ioctl(ide_drive_t *, struct file *, unsigned int,
-			    void __user *);
+int ide_floppy_ioctl(struct inode *, struct file *, unsigned, unsigned long);
 
 #endif /*__IDE_FLOPPY_H */
Index: b/drivers/ide/ide-floppy_ioctl.c
===================================================================
--- a/drivers/ide/ide-floppy_ioctl.c
+++ b/drivers/ide/ide-floppy_ioctl.c
@@ -223,8 +223,26 @@ static int ide_floppy_get_format_progres
 	return 0;
 }
 
-int ide_floppy_format_ioctl(ide_drive_t *drive, struct file *file,
-			    unsigned int cmd, void __user *argp)
+static int ide_floppy_lockdoor(ide_drive_t *drive, struct ide_atapi_pc *pc,
+			       unsigned long arg, unsigned int cmd)
+{
+	idefloppy_floppy_t *floppy = drive->driver_data;
+	struct gendisk *disk = floppy->disk;
+	int prevent = (arg && cmd != CDROMEJECT) ? 1 : 0;
+
+	if (floppy->openers > 1)
+		return -EBUSY;
+
+	ide_set_media_lock(drive, disk, prevent);
+
+	if (cmd == CDROMEJECT)
+		ide_do_start_stop(drive, disk, 2);
+
+	return 0;
+}
+
+static int ide_floppy_format_ioctl(ide_drive_t *drive, struct file *file,
+				   unsigned int cmd, void __user *argp)
 {
 	switch (cmd) {
 	case IDEFLOPPY_IOCTL_FORMAT_SUPPORTED:
@@ -241,3 +259,35 @@ int ide_floppy_format_ioctl(ide_drive_t 
 		return -ENOTTY;
 	}
 }
+
+int idefloppy_ioctl(struct inode *inode, struct file *file,
+		    unsigned int cmd, unsigned long arg)
+{
+	struct block_device *bdev = inode->i_bdev;
+	struct ide_floppy_obj *floppy = ide_drv_g(bdev->bd_disk,
+						     ide_floppy_obj);
+	ide_drive_t *drive = floppy->drive;
+	struct ide_atapi_pc pc;
+	void __user *argp = (void __user *)arg;
+	int err;
+
+	if (cmd == CDROMEJECT || cmd == CDROM_LOCKDOOR)
+		return ide_floppy_lockdoor(drive, &pc, arg, cmd);
+
+	err = ide_floppy_format_ioctl(drive, file, cmd, argp);
+	if (err != -ENOTTY)
+		return err;
+
+	/*
+	 * skip SCSI_IOCTL_SEND_COMMAND (deprecated)
+	 * and CDROM_SEND_PACKET (legacy) ioctls
+	 */
+	if (cmd != CDROM_SEND_PACKET && cmd != SCSI_IOCTL_SEND_COMMAND)
+		err = scsi_cmd_ioctl(file, bdev->bd_disk->queue,
+					bdev->bd_disk, cmd, argp);
+
+	if (err == -ENOTTY)
+		err = generic_ide_ioctl(drive, file, bdev, cmd, arg);
+
+	return err;
+}
