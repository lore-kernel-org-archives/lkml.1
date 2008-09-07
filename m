Return-Path: <linux-kernel-owner+w=401wt.eu-S1755689AbYIGWUF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689AbYIGWUF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 18:20:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755969AbYIGWRh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 18:17:37 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:25685 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755953AbYIGWRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 18:17:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=SFRClEyhATMrcWKDEejGaTBRDfLfeEyRmMTAwZI9vLseWnft53irJJU14V5OYMpe67
         J3hGtsr4goPK1MmocSx4wC+uIaXnWImzFYdHoVNyxXwSXDLcwaRHs7fRS5QXJySLuTLs
         v78zR/MaCxRchT9M6uo5qOhmM02d9WGzFIx70=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 08 Sep 2008 00:15:26 +0200
Message-Id: <20080907221526.24285.12942.sendpatchset@localhost.localdomain>
In-Reply-To: <20080907221424.24285.81137.sendpatchset@localhost.localdomain>
References: <20080907221424.24285.81137.sendpatchset@localhost.localdomain>
Subject: [PATCH 09/18] ide: IDE_AFLAG_MEDIA_CHANGED -> IDE_DFLAG_MEDIA_CHANGED
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functional changes caused by this patch.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c       |    6 +++---
 drivers/ide/ide-cd_ioctl.c |    4 ++--
 drivers/ide/ide-floppy.c   |    6 +++---
 include/linux/ide.h        |    2 +-
 4 files changed, 9 insertions(+), 9 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -88,7 +88,7 @@ static void ide_cd_put(struct cdrom_info
 /* Mark that we've seen a media change and invalidate our internal buffers. */
 static void cdrom_saw_media_change(ide_drive_t *drive)
 {
-	drive->atapi_flags |= IDE_AFLAG_MEDIA_CHANGED;
+	drive->dev_flags |= IDE_DFLAG_MEDIA_CHANGED;
 	drive->atapi_flags &= ~IDE_AFLAG_TOC_VALID;
 }
 
@@ -1882,8 +1882,8 @@ static int ide_cdrom_setup(ide_drive_t *
 	if (!drive->queue->unplug_delay)
 		drive->queue->unplug_delay = 1;
 
-	drive->atapi_flags = IDE_AFLAG_MEDIA_CHANGED | IDE_AFLAG_NO_EJECT |
-		       ide_cd_flags(id);
+	drive->dev_flags |= IDE_DFLAG_MEDIA_CHANGED;
+	drive->atapi_flags = IDE_AFLAG_NO_EJECT | ide_cd_flags(id);
 
 	if ((drive->atapi_flags & IDE_AFLAG_VERTOS_300_SSD) &&
 	    fw_rev[4] == '1' && fw_rev[6] <= '2')
Index: b/drivers/ide/ide-cd_ioctl.c
===================================================================
--- a/drivers/ide/ide-cd_ioctl.c
+++ b/drivers/ide/ide-cd_ioctl.c
@@ -86,8 +86,8 @@ int ide_cdrom_check_media_change_real(st
 
 	if (slot_nr == CDSL_CURRENT) {
 		(void) cdrom_check_status(drive, NULL);
-		retval = (drive->atapi_flags & IDE_AFLAG_MEDIA_CHANGED) ? 1 : 0;
-		drive->atapi_flags &= ~IDE_AFLAG_MEDIA_CHANGED;
+		retval = (drive->dev_flags & IDE_DFLAG_MEDIA_CHANGED) ? 1 : 0;
+		drive->dev_flags &= ~IDE_DFLAG_MEDIA_CHANGED;
 		return retval;
 	} else {
 		return -EINVAL;
Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -689,8 +689,8 @@ static int idefloppy_open(struct inode *
 			goto out_put_floppy;
 		}
 
-		drive->atapi_flags |= IDE_AFLAG_MEDIA_CHANGED;
 		ide_set_media_lock(drive, disk, 1);
+		drive->dev_flags |= IDE_DFLAG_MEDIA_CHANGED;
 		check_disk_change(inode->i_bdev);
 	} else if (drive->atapi_flags & IDE_AFLAG_FORMAT_IN_PROGRESS) {
 		ret = -EBUSY;
@@ -747,8 +747,8 @@ static int idefloppy_media_changed(struc
 		drive->dev_flags &= ~IDE_DFLAG_ATTACH;
 		return 0;
 	}
-	ret = !!(drive->atapi_flags & IDE_AFLAG_MEDIA_CHANGED);
-	drive->atapi_flags &= ~IDE_AFLAG_MEDIA_CHANGED;
+	ret = !!(drive->dev_flags & IDE_DFLAG_MEDIA_CHANGED);
+	drive->dev_flags &= ~IDE_DFLAG_MEDIA_CHANGED;
 	return ret;
 }
 
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -462,7 +462,6 @@ struct ide_acpi_hwif_link;
 /* ATAPI device flags */
 enum {
 	IDE_AFLAG_DRQ_INTERRUPT		= (1 << 0),
-	IDE_AFLAG_MEDIA_CHANGED		= (1 << 1),
 	/* Drive cannot lock the door. */
 	IDE_AFLAG_NO_DOORLOCK		= (1 << 2),
 
@@ -571,6 +570,7 @@ enum {
 	/* retrying in PIO */
 	IDE_DFLAG_DMA_PIO_RETRY		= (1 << 25),
 	IDE_DFLAG_LBA			= (1 << 26),
+	IDE_DFLAG_MEDIA_CHANGED		= (1 << 27),
 };
 
 struct ide_drive_s {
