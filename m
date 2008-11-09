Return-Path: <linux-kernel-owner+w=401wt.eu-S1756074AbYKIQYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074AbYKIQYe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 11:24:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755442AbYKIQXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 11:23:22 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:35481 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755784AbYKIQXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 11:23:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=k9iGC4esU8tUcWPJcQ2R/Max1jCvHClI2iS7zNl5bisGTKCOTrDK3t4Fa4fWE0QKlZ
         wo7uodgNktCq9P69bherAiMZYvxXbiLG9LKdBFf1vMiRPPto4MjjrRZy0xSmXidw3jt8
         dICK5lsxpbdXGa1D3XnH9HRjSHzGkOzEbCqgo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] ide-cd: remove dead dsc_overlap setting
Date: Sun, 9 Nov 2008 15:48:31 +0100
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <petkovbb@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811091548.33137.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dsc_overlap setting is not useful anymore for ide-cd so remove
"dsc_overlap" /proc setting, disallow changing the setting through
HDIO_SET_NICE ioctl and cleanup ide_cd{rom_setup,_release}().

Cc: Borislav Petkov <petkovbb@googlemail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
for pata-2.6 tree

 drivers/ide/ide-cd.c     |   15 +--------------
 drivers/ide/ide-ioctls.c |    2 +-
 2 files changed, 2 insertions(+), 15 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1831,13 +1831,6 @@ static ide_proc_entry_t idecd_proc[] = {
 	{ NULL, 0, NULL, NULL }
 };
 
-ide_devset_rw_flag(dsc_overlap, IDE_DFLAG_DSC_OVERLAP);
-
-static const struct ide_proc_devset idecd_settings[] = {
-	IDE_PROC_DEVSET(dsc_overlap, 0, 1),
-	{ 0 },
-};
-
 static ide_proc_entry_t *ide_cd_proc_entries(ide_drive_t *drive)
 {
 	return idecd_proc;
@@ -1845,7 +1838,7 @@ static ide_proc_entry_t *ide_cd_proc_ent
 
 static const struct ide_proc_devset *ide_cd_proc_devsets(ide_drive_t *drive)
 {
-	return idecd_settings;
+	return NULL;
 }
 #endif
 
@@ -1945,11 +1938,6 @@ static int ide_cdrom_setup(ide_drive_t *
 	/* set correct block size */
 	blk_queue_hardsect_size(drive->queue, CD_FRAMESIZE);
 
-	if (drive->next != drive)
-		drive->dev_flags |= IDE_DFLAG_DSC_OVERLAP;
-	else
-		drive->dev_flags &= ~IDE_DFLAG_DSC_OVERLAP;
-
 	if (ide_cdrom_register(drive, nslots)) {
 		printk(KERN_ERR PFX "%s: %s failed to register device with the"
 				" cdrom driver.\n", drive->name, __func__);
@@ -1986,7 +1974,6 @@ static void ide_cd_release(struct kref *
 	kfree(info->toc);
 	if (devinfo->handle == drive)
 		unregister_cdrom(devinfo);
-	drive->dev_flags &= ~IDE_DFLAG_DSC_OVERLAP;
 	drive->driver_data = NULL;
 	blk_queue_prep_rq(drive->queue, NULL);
 	g->private_data = NULL;
Index: b/drivers/ide/ide-ioctls.c
===================================================================
--- a/drivers/ide/ide-ioctls.c
+++ b/drivers/ide/ide-ioctls.c
@@ -95,7 +95,7 @@ static int ide_set_nice_ioctl(ide_drive_
 		return -EPERM;
 
 	if (((arg >> IDE_NICE_DSC_OVERLAP) & 1) &&
-	    (drive->media == ide_disk || drive->media == ide_floppy ||
+	    (drive->media != ide_tape ||
 	     (drive->dev_flags & IDE_DFLAG_SCSI)))
 		return -EPERM;
 
