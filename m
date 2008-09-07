Return-Path: <linux-kernel-owner+w=401wt.eu-S1756418AbYIGWSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756418AbYIGWSq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 18:18:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753893AbYIGWRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 18:17:09 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:25685 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688AbYIGWRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 18:17:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Yj8H1ML/QH9LeFIzFeKi28lg86Oqj+awbAU5WYoWG8PVAXB5FVD73knl6WusGXH4yC
         wyLGN4fLRtx+cWuM38FKj/5MqymuP1h9vBxhwKyHluYd0eoRKKrCuM910dQx1zueH6O/
         4INtQZG+GP1Ijgcip1z65n0F4N3B8Ca4GfYWQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 08 Sep 2008 00:14:58 +0200
Message-Id: <20080907221458.24285.31795.sendpatchset@localhost.localdomain>
In-Reply-To: <20080907221424.24285.81137.sendpatchset@localhost.localdomain>
References: <20080907221424.24285.81137.sendpatchset@localhost.localdomain>
Subject: [PATCH 05/18] ide-disk: move IDE_DFLAG_DOORLOCKING flag handling to idedisk_set_doorlock()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functional changes caused by this patch.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-disk.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

Index: b/drivers/ide/ide-disk.c
===================================================================
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -811,12 +811,21 @@ static ide_driver_t idedisk_driver = {
 static int idedisk_set_doorlock(ide_drive_t *drive, int on)
 {
 	ide_task_t task;
+	int ret;
+
+	if ((drive->dev_flags & IDE_DFLAG_DOORLOCKING) == 0)
+		return 0;
 
 	memset(&task, 0, sizeof(task));
 	task.tf.command = on ? ATA_CMD_MEDIA_LOCK : ATA_CMD_MEDIA_UNLOCK;
 	task.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
 
-	return ide_no_data_taskfile(drive, &task);
+	ret = ide_no_data_taskfile(drive, &task);
+
+	if (ret)
+		drive->dev_flags &= ~IDE_DFLAG_DOORLOCKING;
+
+	return ret;
 }
 
 static int idedisk_open(struct inode *inode, struct file *filp)
@@ -839,9 +848,7 @@ static int idedisk_open(struct inode *in
 		 * since the open() has already succeeded,
 		 * and the door_lock is irrelevant at this point.
 		 */
-		if ((drive->dev_flags & IDE_DFLAG_DOORLOCKING) &&
-		    idedisk_set_doorlock(drive, 1))
-			drive->dev_flags &= ~IDE_DFLAG_DOORLOCKING;
+		idedisk_set_doorlock(drive, 1);
 		check_disk_change(inode->i_bdev);
 	}
 	return 0;
@@ -856,11 +863,8 @@ static int idedisk_release(struct inode 
 	if (idkp->openers == 1)
 		ide_cacheflush_p(drive);
 
-	if ((drive->dev_flags & IDE_DFLAG_REMOVABLE) && idkp->openers == 1) {
-		if ((drive->dev_flags & IDE_DFLAG_DOORLOCKING) &&
-		    idedisk_set_doorlock(drive, 0))
-			drive->dev_flags &= ~IDE_DFLAG_DOORLOCKING;
-	}
+	if ((drive->dev_flags & IDE_DFLAG_REMOVABLE) && idkp->openers == 1)
+		idedisk_set_doorlock(drive, 0);
 
 	idkp->openers--;
 
