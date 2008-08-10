Return-Path: <linux-kernel-owner+w=401wt.eu-S1755760AbYHJPj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760AbYHJPj3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 11:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754240AbYHJPiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 11:38:09 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:13064 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196AbYHJPiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 11:38:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=PJOL4tzwblwDzmfPsXl+5nhwSjbj3KQ4pcwqwQPJx2k9Z8IyUnMhf9k3gzfTClP3Su
         MRIEciEStPZjWWJvuO+QIazPCnHwthUpkH4QUSbGWO1AJkOxTlNHiLcPCPXVJxtvjPHs
         +sWqL4if+vP3ul1BPVSSiqjB5S4n72phGIhpk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 10 Aug 2008 17:35:55 +0200
Message-Id: <20080810153555.16255.42725.sendpatchset@localhost.localdomain>
In-Reply-To: <20080810153527.16255.2504.sendpatchset@localhost.localdomain>
References: <20080810153527.16255.2504.sendpatchset@localhost.localdomain>
Subject: [PATCH 04/22] ide-floppy: add ide_floppy_set_media_lock() helper
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ide_floppy_set_media_lock() helper and convert idefloppy_open(),
idefloppy_release() and ide_floppy_lockdoor() to use it.

There should be no functional changes caused by this patch.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-floppy.c |   39 ++++++++++++++++-----------------------
 1 file changed, 16 insertions(+), 23 deletions(-)

Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -1037,6 +1037,17 @@ static ide_driver_t idefloppy_driver = {
 #endif
 };
 
+static void ide_floppy_set_media_lock(ide_drive_t *drive, int on)
+{
+	struct ide_atapi_pc pc;
+
+	/* IOMEGA Clik! drives do not support lock/unlock commands */
+	if ((drive->atapi_flags & IDE_AFLAG_CLIK_DRIVE) == 0) {
+		idefloppy_create_prevent_cmd(&pc, on);
+		(void)idefloppy_queue_pc_tail(drive, &pc);
+	}
+}
+
 static int idefloppy_open(struct inode *inode, struct file *filp)
 {
 	struct gendisk *disk = inode->i_bdev->bd_disk;
@@ -1083,12 +1094,9 @@ static int idefloppy_open(struct inode *
 			ret = -EROFS;
 			goto out_put_floppy;
 		}
+
 		drive->atapi_flags |= IDE_AFLAG_MEDIA_CHANGED;
-		/* IOMEGA Clik! drives do not support lock/unlock commands */
-		if (!(drive->atapi_flags & IDE_AFLAG_CLIK_DRIVE)) {
-			idefloppy_create_prevent_cmd(&pc, 1);
-			(void) idefloppy_queue_pc_tail(drive, &pc);
-		}
+		ide_floppy_set_media_lock(drive, 1);
 		check_disk_change(inode->i_bdev);
 	} else if (drive->atapi_flags & IDE_AFLAG_FORMAT_IN_PROGRESS) {
 		ret = -EBUSY;
@@ -1107,17 +1115,11 @@ static int idefloppy_release(struct inod
 	struct gendisk *disk = inode->i_bdev->bd_disk;
 	struct ide_floppy_obj *floppy = ide_floppy_g(disk);
 	ide_drive_t *drive = floppy->drive;
-	struct ide_atapi_pc pc;
 
 	debug_log("Reached %s\n", __func__);
 
 	if (floppy->openers == 1) {
-		/* IOMEGA Clik! drives do not support lock/unlock commands */
-		if (!(drive->atapi_flags & IDE_AFLAG_CLIK_DRIVE)) {
-			idefloppy_create_prevent_cmd(&pc, 0);
-			(void) idefloppy_queue_pc_tail(drive, &pc);
-		}
-
+		ide_floppy_set_media_lock(drive, 0);
 		drive->atapi_flags &= ~IDE_AFLAG_FORMAT_IN_PROGRESS;
 	}
 
@@ -1143,21 +1145,12 @@ static int ide_floppy_lockdoor(ide_drive
 			       unsigned long arg, unsigned int cmd)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
+	int prevent = (arg && cmd != CDROMEJECT) ? 1 : 0;
 
 	if (floppy->openers > 1)
 		return -EBUSY;
 
-	/* The IOMEGA Clik! Drive doesn't support this command -
-	 * no room for an eject mechanism */
-	if (!(drive->atapi_flags & IDE_AFLAG_CLIK_DRIVE)) {
-		int prevent = arg ? 1 : 0;
-
-		if (cmd == CDROMEJECT)
-			prevent = 0;
-
-		idefloppy_create_prevent_cmd(pc, prevent);
-		(void) idefloppy_queue_pc_tail(floppy->drive, pc);
-	}
+	ide_floppy_set_media_lock(drive, prevent);
 
 	if (cmd == CDROMEJECT) {
 		idefloppy_create_start_stop_cmd(pc, 2);
