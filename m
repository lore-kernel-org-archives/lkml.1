Return-Path: <linux-kernel-owner+w=401wt.eu-S1757026AbYIGWVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757026AbYIGWVx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 18:21:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754255AbYIGWSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 18:18:13 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:64118 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441AbYIGWSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 18:18:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=L4y88ju2C0Oq2lEcv0Vcu4SiKIwYIbXekBSwnei0VHlrEBdmK+Sypc7HZh5kafBQeL
         HY7f2gOSNAjq2/di10TE/5qZNgOZiJI5d9k3LONR9tz7IxlNqd51lMYIgIHgEsOWl+ch
         W5nyOinDf374q3pSUSXnorJkBQc0+JbZWLLi0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 08 Sep 2008 00:16:01 +0200
Message-Id: <20080907221601.24285.91233.sendpatchset@localhost.localdomain>
In-Reply-To: <20080907221424.24285.81137.sendpatchset@localhost.localdomain>
References: <20080907221424.24285.81137.sendpatchset@localhost.localdomain>
Subject: [PATCH 14/18] ide-disk: use IDE_DFLAG_MEDIA_CHANGED
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set IDE_DFLAG_MEDIA_CHANGED in ide_gd_open() to signalize
ide_gd_media_changed() that that media has changed (instead
of relying on IDE_DFLAG_REMOVABLE).

There should be no functional changes caused by this patch.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-gd.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

Index: b/drivers/ide/ide-gd.c
===================================================================
--- a/drivers/ide/ide-gd.c
+++ b/drivers/ide/ide-gd.c
@@ -154,6 +154,7 @@ static int ide_gd_open(struct inode *ino
 		 * and the door_lock is irrelevant at this point.
 		 */
 		ide_disk_set_doorlock(drive, 1);
+		drive->dev_flags |= IDE_DFLAG_MEDIA_CHANGED;
 		check_disk_change(inode->i_bdev);
 	}
 	return 0;
@@ -193,6 +194,7 @@ static int ide_gd_media_changed(struct g
 {
 	struct ide_disk_obj *idkp = ide_drv_g(disk, ide_disk_obj);
 	ide_drive_t *drive = idkp->drive;
+	int ret;
 
 	/* do not scan partitions twice if this is a removable device */
 	if (drive->dev_flags & IDE_DFLAG_ATTACH) {
@@ -200,8 +202,10 @@ static int ide_gd_media_changed(struct g
 		return 0;
 	}
 
-	/* if removable, always assume it was changed */
-	return !!(drive->dev_flags & IDE_DFLAG_REMOVABLE);
+	ret = !!(drive->dev_flags & IDE_DFLAG_MEDIA_CHANGED);
+	drive->dev_flags &= ~IDE_DFLAG_MEDIA_CHANGED;
+
+	return ret;
 }
 
 static int ide_gd_revalidate_disk(struct gendisk *disk)
