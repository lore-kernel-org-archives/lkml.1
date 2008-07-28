Return-Path: <linux-kernel-owner+w=401wt.eu-S1760720AbYG1Uom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760720AbYG1Uom (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 16:44:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760090AbYG1UnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 16:43:25 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:15694 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760074AbYG1UnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 16:43:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=NIedHlyOInHLY28cJuyT/8/Gd6p9a8WdPuqBxYlmeV9PkbNqDASyrHe/HUWI4Zpk0e
         Zg6/JVw6hr6dhzY3lkarp9Ub6YxzWML0SNixTFpopXQVBKJQrK9MLoBb8ksynD2DT1Eh
         mpgPLQ6K4K4fo2KkVVFzzmCblHo5S7xXwQuI8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 28 Jul 2008 22:41:23 +0200
Message-Id: <20080728204123.4283.98134.sendpatchset@localhost.localdomain>
In-Reply-To: <20080728204102.4283.74632.sendpatchset@localhost.localdomain>
References: <20080728204102.4283.74632.sendpatchset@localhost.localdomain>
Subject: [PATCH 4/5] ide: remove ->supports_dsc_overlap field from ide_driver_t
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Use drive->media and drive->scsi to check if ->dsc_overlap
  can be set by HDIO_SET_NICE ioctl in generic_ide_ioctl().

* Remove unused ->supports_dsc_overlap field from ide_driver_t.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c     |    1 -
 drivers/ide/ide-disk.c   |    1 -
 drivers/ide/ide-floppy.c |    1 -
 drivers/ide/ide-tape.c   |    1 -
 drivers/ide/ide.c        |   11 +++++------
 drivers/scsi/ide-scsi.c  |    1 -
 include/linux/ide.h      |    1 -
 7 files changed, 5 insertions(+), 12 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1961,7 +1961,6 @@ static ide_driver_t ide_cdrom_driver = {
 	.remove			= ide_cd_remove,
 	.version		= IDECD_VERSION,
 	.media			= ide_cdrom,
-	.supports_dsc_overlap	= 1,
 	.do_request		= ide_cd_do_request,
 	.end_request		= ide_end_request,
 	.error			= __ide_error,
Index: b/drivers/ide/ide-disk.c
===================================================================
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -987,7 +987,6 @@ static ide_driver_t idedisk_driver = {
 	.shutdown		= ide_device_shutdown,
 	.version		= IDEDISK_VERSION,
 	.media			= ide_disk,
-	.supports_dsc_overlap	= 0,
 	.do_request		= ide_do_rw_disk,
 	.end_request		= ide_end_request,
 	.error			= __ide_error,
Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -1129,7 +1129,6 @@ static ide_driver_t idefloppy_driver = {
 	.remove			= ide_floppy_remove,
 	.version		= IDEFLOPPY_VERSION,
 	.media			= ide_floppy,
-	.supports_dsc_overlap	= 0,
 	.do_request		= idefloppy_do_request,
 	.end_request		= idefloppy_end_request,
 	.error			= __ide_error,
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -2605,7 +2605,6 @@ static ide_driver_t idetape_driver = {
 	.remove			= ide_tape_remove,
 	.version		= IDETAPE_VERSION,
 	.media			= ide_tape,
-	.supports_dsc_overlap 	= 1,
 	.do_request		= idetape_do_request,
 	.end_request		= idetape_end_request,
 	.error			= __ide_error,
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -562,7 +562,6 @@ int generic_ide_ioctl(ide_drive_t *drive
 			unsigned int cmd, unsigned long arg)
 {
 	unsigned long flags;
-	ide_driver_t *drv;
 	int err = 0, (*getfunc)(ide_drive_t *), (*setfunc)(ide_drive_t *, int);
 
 	switch (cmd) {
@@ -612,12 +611,12 @@ int generic_ide_ioctl(ide_drive_t *drive
 			if (!capable(CAP_SYS_ADMIN)) return -EACCES;
 			if (arg != (arg & ((1 << IDE_NICE_DSC_OVERLAP) | (1 << IDE_NICE_1))))
 				return -EPERM;
-			drive->dsc_overlap = (arg >> IDE_NICE_DSC_OVERLAP) & 1;
-			drv = *(ide_driver_t **)bdev->bd_disk->private_data;
-			if (drive->dsc_overlap && !drv->supports_dsc_overlap) {
-				drive->dsc_overlap = 0;
+			if (((arg >> IDE_NICE_DSC_OVERLAP) & 1) &&
+			    (drive->media == ide_disk ||
+			     drive->media == ide_floppy ||
+			     drive->scsi))
 				return -EPERM;
-			}
+			drive->dsc_overlap = (arg >> IDE_NICE_DSC_OVERLAP) & 1;
 			drive->nice1 = (arg >> IDE_NICE_1) & 1;
 			return 0;
 		case HDIO_DRIVE_RESET:
Index: b/drivers/scsi/ide-scsi.c
===================================================================
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -521,7 +521,6 @@ static ide_driver_t idescsi_driver = {
 	.remove			= ide_scsi_remove,
 	.version		= IDESCSI_VERSION,
 	.media			= ide_scsi,
-	.supports_dsc_overlap	= 0,
 	.do_request		= idescsi_do_request,
 	.end_request		= idescsi_end_request,
 	.error                  = idescsi_atapi_error,
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -921,7 +921,6 @@ enum {
 struct ide_driver_s {
 	const char			*version;
 	u8				media;
-	unsigned supports_dsc_overlap	: 1;
 	ide_startstop_t	(*do_request)(ide_drive_t *, struct request *, sector_t);
 	int		(*end_request)(ide_drive_t *, int, int);
 	ide_startstop_t	(*error)(ide_drive_t *, struct request *rq, u8, u8);
