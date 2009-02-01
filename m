Return-Path: <linux-kernel-owner+w=401wt.eu-S1756700AbZBAT3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700AbZBAT3Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 14:29:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756506AbZBAT1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 14:27:40 -0500
Received: from mu-out-0910.google.com ([209.85.134.191]:21944 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756435AbZBAT1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 14:27:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=XIzdW3sQuAlMtj1Ci8leYzpWjY0hxzqZIOMamCW+hpLm+h8cuuFkCJKvipyK9Y7tdz
         fYIpF0/RUQXNZ0F02Tl/x7soUbv8e817mXqHEuFa5msn6QmidhzrGhza+VqdT1hqbBy/
         11JziKLH3EQq3DWdjwsrKvmDKCyC4cqwFCkQw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 01 Feb 2009 20:28:21 +0100
Message-Id: <20090201192821.1592.11149.sendpatchset@localhost.localdomain>
In-Reply-To: <20090201192732.1592.76435.sendpatchset@localhost.localdomain>
References: <20090201192732.1592.76435.sendpatchset@localhost.localdomain>
Subject: [PATCH 7/8] ide: remove ->end_request method
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: remove ->end_request method

* Handle completion of private driver requests explicitly
  for ide_floppy and ide_tape media in ide_kill_rq().

* Remove no longer needed ->end_request method.

There should be no functional changes caused by this patch.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c     |    1 -
 drivers/ide/ide-disk.c   |    1 -
 drivers/ide/ide-floppy.c |   20 --------------------
 drivers/ide/ide-gd.c     |    6 ------
 drivers/ide/ide-io.c     |   14 +++++++-------
 drivers/ide/ide-tape.c   |   17 -----------------
 include/linux/ide.h      |    2 --
 7 files changed, 7 insertions(+), 54 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1824,7 +1824,6 @@ static struct ide_driver ide_cdrom_drive
 	.remove			= ide_cd_remove,
 	.version		= IDECD_VERSION,
 	.do_request		= ide_cd_do_request,
-	.end_request		= ide_end_request,
 #ifdef CONFIG_IDE_PROC_FS
 	.proc_entries		= ide_cd_proc_entries,
 	.proc_devsets		= ide_cd_proc_devsets,
Index: b/drivers/ide/ide-disk.c
===================================================================
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -734,6 +734,5 @@ const struct ide_disk_ops ide_ata_disk_o
 	.init_media	= ide_disk_init_media,
 	.set_doorlock	= ide_disk_set_doorlock,
 	.do_request	= ide_do_rw_disk,
-	.end_request	= ide_end_request,
 	.ioctl		= ide_disk_ioctl,
 };
Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -61,25 +61,6 @@
  */
 #define IDEFLOPPY_PC_DELAY	(HZ/20)	/* default delay for ZIP 100 (50ms) */
 
-/*
- * Used to finish servicing a private request.
- */
-static int ide_floppy_end_request(ide_drive_t *drive, int uptodate, int nsecs)
-{
-	struct request *rq = drive->hwif->rq;
-
-	ide_debug_log(IDE_DBG_FUNC, "enter");
-
-	if (uptodate == 0)
-		drive->failed_pc = NULL;
-
-	rq->errors = uptodate ? 0 : IDE_DRV_ERROR_GENERAL;
-
-	ide_complete_rq(drive, 0);
-
-	return 0;
-}
-
 static void idefloppy_update_buffers(ide_drive_t *drive,
 				struct ide_atapi_pc *pc)
 {
@@ -558,6 +539,5 @@ const struct ide_disk_ops ide_atapi_disk
 	.init_media	= ide_floppy_init_media,
 	.set_doorlock	= ide_set_media_lock,
 	.do_request	= ide_floppy_do_request,
-	.end_request	= ide_floppy_end_request,
 	.ioctl		= ide_floppy_ioctl,
 };
Index: b/drivers/ide/ide-gd.c
===================================================================
--- a/drivers/ide/ide-gd.c
+++ b/drivers/ide/ide-gd.c
@@ -144,11 +144,6 @@ static ide_startstop_t ide_gd_do_request
 	return drive->disk_ops->do_request(drive, rq, sector);
 }
 
-static int ide_gd_end_request(ide_drive_t *drive, int uptodate, int nrsecs)
-{
-	return drive->disk_ops->end_request(drive, uptodate, nrsecs);
-}
-
 static struct ide_driver ide_gd_driver = {
 	.gen_driver = {
 		.owner		= THIS_MODULE,
@@ -161,7 +156,6 @@ static struct ide_driver ide_gd_driver =
 	.shutdown		= ide_gd_shutdown,
 	.version		= IDE_GD_VERSION,
 	.do_request		= ide_gd_do_request,
-	.end_request		= ide_gd_end_request,
 #ifdef CONFIG_IDE_PROC_FS
 	.proc_entries		= ide_disk_proc_entries,
 	.proc_devsets		= ide_disk_proc_devsets,
Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -174,17 +174,17 @@ EXPORT_SYMBOL(ide_complete_rq);
 
 void ide_kill_rq(ide_drive_t *drive, struct request *rq)
 {
+	u8 drv_req = blk_special_request(rq) && rq->rq_disk;
+	u8 media = drive->media;
+
 	drive->failed_pc = NULL;
 
-	if (drive->media == ide_tape)
+	if ((media == ide_floppy && drv_req) || media == ide_tape)
 		rq->errors = IDE_DRV_ERROR_GENERAL;
 
-	if (blk_special_request(rq) && rq->rq_disk) {
-		struct ide_driver *drv;
-
-		drv = *(struct ide_driver **)rq->rq_disk->private_data;
-		drv->end_request(drive, 0, 0);
-	} else
+	if ((media == ide_floppy || media == ide_tape) && drv_req)
+		ide_complete_rq(drive, 0);
+	else
 		ide_end_request(drive, 0, 0);
 }
 
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -461,22 +461,6 @@ static void ide_tape_kfree_buffer(idetap
 	}
 }
 
-static int idetape_end_request(ide_drive_t *drive, int uptodate, int nr_sects)
-{
-	struct request *rq = drive->hwif->rq;
-
-	debug_log(DBG_PROCS, "Enter %s\n", __func__);
-
-	rq->errors = uptodate ? 0 : IDE_DRV_ERROR_GENERAL;
-
-	if (uptodate == 0)
-		drive->failed_pc = NULL;
-
-	ide_complete_rq(drive, 0);
-
-	return 0;
-}
-
 static void ide_tape_handle_dsc(ide_drive_t *);
 
 static void ide_tape_callback(ide_drive_t *drive, int dsc)
@@ -2304,7 +2288,6 @@ static struct ide_driver idetape_driver 
 	.remove			= ide_tape_remove,
 	.version		= IDETAPE_VERSION,
 	.do_request		= idetape_do_request,
-	.end_request		= idetape_end_request,
 #ifdef CONFIG_IDE_PROC_FS
 	.proc_entries		= ide_tape_proc_entries,
 	.proc_devsets		= ide_tape_proc_devsets,
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -427,7 +427,6 @@ struct ide_disk_ops {
 					int);
 	ide_startstop_t	(*do_request)(struct ide_drive_s *, struct request *,
 				      sector_t);
-	int		(*end_request)(struct ide_drive_s *, int, int);
 	int		(*ioctl)(struct ide_drive_s *, struct block_device *,
 				 fmode_t, unsigned int, unsigned long);
 };
@@ -1095,7 +1094,6 @@ void ide_check_pm_state(ide_drive_t *, s
 struct ide_driver {
 	const char			*version;
 	ide_startstop_t	(*do_request)(ide_drive_t *, struct request *, sector_t);
-	int		(*end_request)(ide_drive_t *, int, int);
 	struct device_driver	gen_driver;
 	int		(*probe)(ide_drive_t *);
 	void		(*remove)(ide_drive_t *);
