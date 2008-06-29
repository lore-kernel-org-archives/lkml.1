Return-Path: <linux-kernel-owner+w=401wt.eu-S1760680AbYF2LEE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760680AbYF2LEE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 07:04:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759976AbYF2K7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 06:59:44 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:55680 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755994AbYF2K7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 06:59:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=CT4e/OBuOhxNZscNApmJfEgxO8ZjqhrcA4dZ2ACo0p1/UEwxQTIkyBhpatXp2PywO/
         +Xkhr8eVrZzJlRadSD/8loeZsZjDXO2W50JYutDzvIP7eaS9uAcsn17j6bGQxQ92EKeN
         LVNU7UORUNdDOuEbRGQXFmXBCItmxyPQJ2gzI=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 12/16] ide-floppy: convert to using the new dev_flags
Date: Sun, 29 Jun 2008 12:59:15 +0200
Message-Id: <1214737159-1078-13-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1214737159-1078-1-git-send-email-petkovbb@gmail.com>
References: <1214737159-1078-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

while at it, remove PC_FLAG_ZIP_DRIVE from the packed command flags altogether
and query the drive type through drive->dev_flags.

There should be no functionality change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-atapi.c  |    5 ++-
 drivers/ide/ide-floppy.c |   73 +++++++++++++++++-----------------------------
 include/linux/ide.h      |    3 +-
 3 files changed, 31 insertions(+), 50 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index fa49344..951768a 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -247,7 +247,7 @@ ide_startstop_t ide_transfer_pc(ide_drive_t *drive, struct ide_atapi_pc *pc,
 	}
 
 	/* Send the actual packet */
-	if ((pc->flags & PC_FLAG_ZIP_DRIVE) == 0)
+	if ((drive->dev_flags & IDE_FLAG_ZIP_DRIVE) == 0)
 		hwif->output_data(drive, NULL, rq->cmd, 12);
 
 	return ide_started;
@@ -292,7 +292,8 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive, struct ide_atapi_pc *pc,
 			   bcount, dma);
 
 	/* Issue the packet command */
-	if (pc->flags & PC_FLAG_DRQ_INTERRUPT) {
+	if ((pc->flags & PC_FLAG_DRQ_INTERRUPT) ||
+	    (drive->dev_flags & IDE_FLAG_DRQ_INTERRUPT)) {
 		ide_execute_command(drive, WIN_PACKETCMD, handler,
 				    timeout, NULL);
 		return ide_started;
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 37146d3..a81014f 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -125,26 +125,10 @@ typedef struct ide_floppy_obj {
 	int wp;
 	/* Supports format progress report */
 	int srfp;
-	/* Status/Action flags */
-	unsigned long flags;
 } idefloppy_floppy_t;
 
 #define IDEFLOPPY_TICKS_DELAY	HZ/20	/* default delay for ZIP 100 (50ms) */
 
-/* Floppy flag bits values. */
-enum {
-	/* DRQ interrupt device */
-	IDEFLOPPY_FLAG_DRQ_INTERRUPT		= (1 <<	0),
-	/* Media may have changed */
-	IDEFLOPPY_FLAG_MEDIA_CHANGED		= (1 << 1),
-	/* Format in progress */
-	IDEFLOPPY_FLAG_FORMAT_IN_PROGRESS	= (1 << 2),
-	/* Avoid commands not supported in Clik drive */
-	IDEFLOPPY_FLAG_CLIK_DRIVE		= (1 << 3),
-	/* Requires BH algorithm for packets */
-	IDEFLOPPY_FLAG_ZIP_DRIVE		= (1 << 4),
-};
-
 /* Defines for the MODE SENSE command */
 #define MODE_SENSE_CURRENT		0x00
 #define MODE_SENSE_CHANGEABLE		0x01
@@ -429,7 +413,7 @@ static ide_startstop_t idefloppy_start_pc_transfer(ide_drive_t *drive)
 	 * 40 and 50msec work well. idefloppy_pc_intr will not be actually
 	 * used until after the packet is moved in about 50 msec.
 	 */
-	if (pc->flags & PC_FLAG_ZIP_DRIVE) {
+	if (drive->dev_flags & IDE_FLAG_ZIP_DRIVE) {
 		timeout = floppy->ticks;
 		expiry = &idefloppy_transfer_pc;
 	} else {
@@ -649,12 +633,6 @@ static ide_startstop_t idefloppy_do_request(ide_drive_t *drive,
 		return ide_stopped;
 	}
 
-	if (floppy->flags & IDEFLOPPY_FLAG_DRQ_INTERRUPT)
-		pc->flags |= PC_FLAG_DRQ_INTERRUPT;
-
-	if (floppy->flags & IDEFLOPPY_FLAG_ZIP_DRIVE)
-		pc->flags |= PC_FLAG_ZIP_DRIVE;
-
 	pc->rq = rq;
 
 	return idefloppy_issue_pc(drive, pc);
@@ -798,7 +776,7 @@ static int ide_floppy_get_capacity(ide_drive_t *drive)
 		switch (pc.buf[desc_start + 4] & 0x03) {
 		/* Clik! drive returns this instead of CAPACITY_CURRENT */
 		case CAPACITY_UNFORMATTED:
-			if (!(floppy->flags & IDEFLOPPY_FLAG_CLIK_DRIVE))
+			if (!(drive->dev_flags & IDE_FLAG_CLIK_DRIVE))
 				/*
 				 * If it is not a clik drive, break out
 				 * (maintains previous driver behaviour)
@@ -844,7 +822,7 @@ static int ide_floppy_get_capacity(ide_drive_t *drive)
 	}
 
 	/* Clik! disk does not support get_flexible_disk_page */
-	if (!(floppy->flags & IDEFLOPPY_FLAG_CLIK_DRIVE))
+	if (!(drive->dev_flags & IDE_FLAG_CLIK_DRIVE))
 		(void) ide_floppy_get_flexible_disk_page(drive);
 
 	set_capacity(floppy->disk, floppy->blocks * floppy->bs_factor);
@@ -1045,7 +1023,7 @@ static void idefloppy_setup(ide_drive_t *drive, idefloppy_floppy_t *floppy)
 	drive->pc_callback = ide_floppy_callback;
 
 	if (((gcw[0] & 0x60) >> 5) == 1)
-		floppy->flags |= IDEFLOPPY_FLAG_DRQ_INTERRUPT;
+		drive->dev_flags |= IDE_FLAG_DRQ_INTERRUPT;
 	/*
 	 * We used to check revisions here. At this point however I'm giving up.
 	 * Just assume they are all broken, its easier.
@@ -1056,7 +1034,7 @@ static void idefloppy_setup(ide_drive_t *drive, idefloppy_floppy_t *floppy)
 	 * we'll leave the limitation below for the 2.2.x tree.
 	 */
 	if (!strncmp(drive->id->model, "IOMEGA ZIP 100 ATAPI", 20)) {
-		floppy->flags |= IDEFLOPPY_FLAG_ZIP_DRIVE;
+		drive->dev_flags |= IDE_FLAG_ZIP_DRIVE;
 		/* This value will be visible in the /proc/ide/hdx/settings */
 		floppy->ticks = IDEFLOPPY_TICKS_DELAY;
 		blk_queue_max_sectors(drive->queue, 64);
@@ -1068,7 +1046,7 @@ static void idefloppy_setup(ide_drive_t *drive, idefloppy_floppy_t *floppy)
 	 */
 	if (strncmp(drive->id->model, "IOMEGA Clik!", 11) == 0) {
 		blk_queue_max_sectors(drive->queue, 64);
-		floppy->flags |= IDEFLOPPY_FLAG_CLIK_DRIVE;
+		drive->dev_flags |= IDE_FLAG_CLIK_DRIVE;
 	}
 
 	(void) ide_floppy_get_capacity(drive);
@@ -1158,7 +1136,7 @@ static int idefloppy_open(struct inode *inode, struct file *filp)
 	floppy->openers++;
 
 	if (floppy->openers == 1) {
-		floppy->flags &= ~IDEFLOPPY_FLAG_FORMAT_IN_PROGRESS;
+		drive->dev_flags &= ~IDE_FLAG_FORMAT_IN_PROGRESS;
 		/* Just in case */
 
 		idefloppy_init_pc(&pc);
@@ -1185,14 +1163,14 @@ static int idefloppy_open(struct inode *inode, struct file *filp)
 			ret = -EROFS;
 			goto out_put_floppy;
 		}
-		floppy->flags |= IDEFLOPPY_FLAG_MEDIA_CHANGED;
+		drive->dev_flags |= IDE_FLAG_MEDIA_CHANGED;
 		/* IOMEGA Clik! drives do not support lock/unlock commands */
-		if (!(floppy->flags & IDEFLOPPY_FLAG_CLIK_DRIVE)) {
+		if (!(drive->dev_flags & IDE_FLAG_CLIK_DRIVE)) {
 			idefloppy_create_prevent_cmd(&pc, 1);
 			(void) idefloppy_queue_pc_tail(drive, &pc);
 		}
 		check_disk_change(inode->i_bdev);
-	} else if (floppy->flags & IDEFLOPPY_FLAG_FORMAT_IN_PROGRESS) {
+	} else if (drive->dev_flags & IDE_FLAG_FORMAT_IN_PROGRESS) {
 		ret = -EBUSY;
 		goto out_put_floppy;
 	}
@@ -1215,12 +1193,12 @@ static int idefloppy_release(struct inode *inode, struct file *filp)
 
 	if (floppy->openers == 1) {
 		/* IOMEGA Clik! drives do not support lock/unlock commands */
-		if (!(floppy->flags & IDEFLOPPY_FLAG_CLIK_DRIVE)) {
+		if (!(drive->dev_flags & IDE_FLAG_CLIK_DRIVE)) {
 			idefloppy_create_prevent_cmd(&pc, 0);
 			(void) idefloppy_queue_pc_tail(drive, &pc);
 		}
 
-		floppy->flags &= ~IDEFLOPPY_FLAG_FORMAT_IN_PROGRESS;
+		drive->dev_flags &= ~IDE_FLAG_FORMAT_IN_PROGRESS;
 	}
 
 	floppy->openers--;
@@ -1241,15 +1219,17 @@ static int idefloppy_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 	return 0;
 }
 
-static int ide_floppy_lockdoor(idefloppy_floppy_t *floppy,
-		struct ide_atapi_pc *pc, unsigned long arg, unsigned int cmd)
+static int ide_floppy_lockdoor(ide_drive_t *drive, struct ide_atapi_pc *pc,
+			       unsigned long arg, unsigned int cmd)
 {
+	idefloppy_floppy_t *floppy = drive->driver_data;
+
 	if (floppy->openers > 1)
 		return -EBUSY;
 
 	/* The IOMEGA Clik! Drive doesn't support this command -
 	 * no room for an eject mechanism */
-	if (!(floppy->flags & IDEFLOPPY_FLAG_CLIK_DRIVE)) {
+	if (!(drive->dev_flags & IDE_FLAG_CLIK_DRIVE)) {
 		int prevent = arg ? 1 : 0;
 
 		if (cmd == CDROMEJECT)
@@ -1270,16 +1250,17 @@ static int ide_floppy_lockdoor(idefloppy_floppy_t *floppy,
 static int ide_floppy_format_unit(idefloppy_floppy_t *floppy,
 				  int __user *arg)
 {
-	int blocks, length, flags, err = 0;
 	struct ide_atapi_pc pc;
+	ide_drive_t *drive = floppy->drive;
+	int blocks, length, flags, err = 0;
 
 	if (floppy->openers > 1) {
 		/* Don't format if someone is using the disk */
-		floppy->flags &= ~IDEFLOPPY_FLAG_FORMAT_IN_PROGRESS;
+		drive->dev_flags &= ~IDE_FLAG_FORMAT_IN_PROGRESS;
 		return -EBUSY;
 	}
 
-	floppy->flags |= IDEFLOPPY_FLAG_FORMAT_IN_PROGRESS;
+	drive->dev_flags |= IDE_FLAG_FORMAT_IN_PROGRESS;
 
 	/*
 	 * Send ATAPI_FORMAT_UNIT to the drive.
@@ -1303,15 +1284,15 @@ static int ide_floppy_format_unit(idefloppy_floppy_t *floppy,
 		goto out;
 	}
 
-	(void) idefloppy_get_sfrp_bit(floppy->drive);
+	(void) idefloppy_get_sfrp_bit(drive);
 	idefloppy_create_format_unit_cmd(&pc, blocks, length, flags);
 
-	if (idefloppy_queue_pc_tail(floppy->drive, &pc))
+	if (idefloppy_queue_pc_tail(drive, &pc))
 		err = -EIO;
 
 out:
 	if (err)
-		floppy->flags &= ~IDEFLOPPY_FLAG_FORMAT_IN_PROGRESS;
+		drive->dev_flags &= ~IDE_FLAG_FORMAT_IN_PROGRESS;
 	return err;
 }
 
@@ -1330,7 +1311,7 @@ static int idefloppy_ioctl(struct inode *inode, struct file *file,
 	case CDROMEJECT:
 		/* fall through */
 	case CDROM_LOCKDOOR:
-		return ide_floppy_lockdoor(floppy, &pc, arg, cmd);
+		return ide_floppy_lockdoor(drive, &pc, arg, cmd);
 	case IDEFLOPPY_IOCTL_FORMAT_SUPPORTED:
 		return 0;
 	case IDEFLOPPY_IOCTL_FORMAT_GET_CAPACITY:
@@ -1371,8 +1352,8 @@ static int idefloppy_media_changed(struct gendisk *disk)
 		drive->attach = 0;
 		return 0;
 	}
-	ret = !!(floppy->flags & IDEFLOPPY_FLAG_MEDIA_CHANGED);
-	floppy->flags &= ~IDEFLOPPY_FLAG_MEDIA_CHANGED;
+	ret = !!(drive->dev_flags & IDE_FLAG_MEDIA_CHANGED);
+	drive->dev_flags &= ~IDE_FLAG_MEDIA_CHANGED;
 	return ret;
 }
 
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 0e52c3c..9ab55c5 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -657,8 +657,7 @@ enum {
 	PC_FLAG_WRITING			= (1 << 6),
 	/* command timed out */
 	PC_FLAG_TIMEDOUT		= (1 << 7),
-	PC_FLAG_ZIP_DRIVE		= (1 << 8),
-	PC_FLAG_DRQ_INTERRUPT		= (1 << 9),
+	PC_FLAG_DRQ_INTERRUPT		= (1 << 8),
 };
 
 struct ide_atapi_pc {
-- 
1.5.5.4

