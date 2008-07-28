Return-Path: <linux-kernel-owner+w=401wt.eu-S1756497AbYG1Uo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497AbYG1Uo6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 16:44:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760148AbYG1Und
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 16:43:33 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:16727 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760060AbYG1Una (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 16:43:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=BOsKcDym5zIuw4c5DKpiOhEyla0TdCabADKXhXQaOP/zLV9t0ZPd/Jb28TxSvkXwl1
         hkh7cqXF9H/cJskVAjPK4IUibuiJ8p3PuacgrO/RodUw6Gbxm9lpLGoE/V5YKewGDC1j
         3iZGr+AnzlNXZXySxz0lcGIearfWemD1VgvuM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 28 Jul 2008 22:41:31 +0200
Message-Id: <20080728204131.4283.96095.sendpatchset@localhost.localdomain>
In-Reply-To: <20080728204102.4283.74632.sendpatchset@localhost.localdomain>
References: <20080728204102.4283.74632.sendpatchset@localhost.localdomain>
Subject: [PATCH 5/5] ide: factor out HDIO_*_NICE ioctl handling to ide_*_nice_ioctl()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor out HDIO_{GET,SET}_NICE ioctl handling from
generic_ide_ioctl() to ide_{get,set}_nice_ioctl().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide.c |   40 ++++++++++++++++++++++++++--------------
 1 file changed, 26 insertions(+), 14 deletions(-)

Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -558,6 +558,28 @@ out:
 	return rc;
 }
 
+static int ide_get_nice_ioctl(ide_drive_t *drive, unsigned long arg)
+{
+	return put_user((drive->dsc_overlap << IDE_NICE_DSC_OVERLAP) |
+			(drive->nice1 << IDE_NICE_1), (long __user *)arg);
+}
+
+static int ide_set_nice_ioctl(ide_drive_t *drive, unsigned long arg)
+{
+	if (arg != (arg & ((1 << IDE_NICE_DSC_OVERLAP) | (1 << IDE_NICE_1))))
+		return -EPERM;
+
+	if (((arg >> IDE_NICE_DSC_OVERLAP) & 1) &&
+	    (drive->media == ide_disk || drive->media == ide_floppy ||
+	     drive->scsi))
+		return -EPERM;
+
+	drive->dsc_overlap = (arg >> IDE_NICE_DSC_OVERLAP) & 1;
+	drive->nice1 = (arg >> IDE_NICE_1) & 1;
+
+	return 0;
+}
+
 int generic_ide_ioctl(ide_drive_t *drive, struct file *file, struct block_device *bdev,
 			unsigned int cmd, unsigned long arg)
 {
@@ -583,9 +605,7 @@ int generic_ide_ioctl(ide_drive_t *drive
 				return -EINVAL;
 			return ide_get_identity_ioctl(drive, cmd, arg);
 		case HDIO_GET_NICE:
-			return put_user(drive->dsc_overlap	<<	IDE_NICE_DSC_OVERLAP	|
-					drive->nice1 << IDE_NICE_1,
-					(long __user *) arg);
+			return ide_get_nice_ioctl(drive, arg);
 #ifdef CONFIG_IDE_TASK_IOCTL
 		case HDIO_DRIVE_TASKFILE:
 		        if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
@@ -608,17 +628,9 @@ int generic_ide_ioctl(ide_drive_t *drive
 				return -EACCES;
 			return ide_task_ioctl(drive, cmd, arg);
 		case HDIO_SET_NICE:
-			if (!capable(CAP_SYS_ADMIN)) return -EACCES;
-			if (arg != (arg & ((1 << IDE_NICE_DSC_OVERLAP) | (1 << IDE_NICE_1))))
-				return -EPERM;
-			if (((arg >> IDE_NICE_DSC_OVERLAP) & 1) &&
-			    (drive->media == ide_disk ||
-			     drive->media == ide_floppy ||
-			     drive->scsi))
-				return -EPERM;
-			drive->dsc_overlap = (arg >> IDE_NICE_DSC_OVERLAP) & 1;
-			drive->nice1 = (arg >> IDE_NICE_1) & 1;
-			return 0;
+			if (!capable(CAP_SYS_ADMIN))
+				return -EACCES;
+			return ide_set_nice_ioctl(drive, arg);
 		case HDIO_DRIVE_RESET:
 			if (!capable(CAP_SYS_ADMIN))
 				return -EACCES;
