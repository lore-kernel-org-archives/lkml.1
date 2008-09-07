Return-Path: <linux-kernel-owner+w=401wt.eu-S1756244AbYIGWS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244AbYIGWS0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 18:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755647AbYIGWRD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 18:17:03 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:25685 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755532AbYIGWQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 18:16:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=e5xdjoPBdnqh+CFgydfXxLOjNJEKRG3b3xckwBwMTbDRAYswoDUVJ2ZjQ65msG64k+
         egG+WCAb8TkYWug4CEaoxcCw35nuDsHhOzhtxuCKxkROSNODasdIjRafagi/PapZn2u+
         4/8HICfjATxAuKdfXQQblq3t+kwEzb+mZ85ZE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 08 Sep 2008 00:14:51 +0200
Message-Id: <20080907221451.24285.62383.sendpatchset@localhost.localdomain>
In-Reply-To: <20080907221424.24285.81137.sendpatchset@localhost.localdomain>
References: <20080907221424.24285.81137.sendpatchset@localhost.localdomain>
Subject: [PATCH 04/18] ide-disk: use to_ide_drv() and ide_drv_g()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functional changes caused by this patch.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-disk.c       |   14 ++++++--------
 drivers/ide/ide-disk.h       |    3 ---
 drivers/ide/ide-disk_ioctl.c |    2 +-
 3 files changed, 7 insertions(+), 12 deletions(-)

Index: b/drivers/ide/ide-disk.c
===================================================================
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -43,8 +43,6 @@
 
 static DEFINE_MUTEX(idedisk_ref_mutex);
 
-#define to_ide_disk(obj) container_of(obj, struct ide_disk_obj, kref)
-
 static void ide_disk_release(struct kref *);
 
 static struct ide_disk_obj *ide_disk_get(struct gendisk *disk)
@@ -52,7 +50,7 @@ static struct ide_disk_obj *ide_disk_get
 	struct ide_disk_obj *idkp = NULL;
 
 	mutex_lock(&idedisk_ref_mutex);
-	idkp = ide_disk_g(disk);
+	idkp = ide_drv_g(disk, ide_disk_obj);
 	if (idkp) {
 		if (ide_device_get(idkp->drive))
 			idkp = NULL;
@@ -740,7 +738,7 @@ static void ide_disk_remove(ide_drive_t 
 
 static void ide_disk_release(struct kref *kref)
 {
-	struct ide_disk_obj *idkp = to_ide_disk(kref);
+	struct ide_disk_obj *idkp = to_ide_drv(kref, ide_disk_obj);
 	ide_drive_t *drive = idkp->drive;
 	struct gendisk *g = idkp->disk;
 
@@ -852,7 +850,7 @@ static int idedisk_open(struct inode *in
 static int idedisk_release(struct inode *inode, struct file *filp)
 {
 	struct gendisk *disk = inode->i_bdev->bd_disk;
-	struct ide_disk_obj *idkp = ide_disk_g(disk);
+	struct ide_disk_obj *idkp = ide_drv_g(disk, ide_disk_obj);
 	ide_drive_t *drive = idkp->drive;
 
 	if (idkp->openers == 1)
@@ -873,7 +871,7 @@ static int idedisk_release(struct inode 
 
 static int idedisk_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 {
-	struct ide_disk_obj *idkp = ide_disk_g(bdev->bd_disk);
+	struct ide_disk_obj *idkp = ide_drv_g(bdev->bd_disk, ide_disk_obj);
 	ide_drive_t *drive = idkp->drive;
 
 	geo->heads = drive->bios_head;
@@ -884,7 +882,7 @@ static int idedisk_getgeo(struct block_d
 
 static int idedisk_media_changed(struct gendisk *disk)
 {
-	struct ide_disk_obj *idkp = ide_disk_g(disk);
+	struct ide_disk_obj *idkp = ide_drv_g(disk, ide_disk_obj);
 	ide_drive_t *drive = idkp->drive;
 
 	/* do not scan partitions twice if this is a removable device */
@@ -899,7 +897,7 @@ static int idedisk_media_changed(struct 
 
 static int idedisk_revalidate_disk(struct gendisk *disk)
 {
-	struct ide_disk_obj *idkp = ide_disk_g(disk);
+	struct ide_disk_obj *idkp = ide_drv_g(disk, ide_disk_obj);
 	set_capacity(disk, ide_disk_capacity(idkp->drive));
 	return 0;
 }
Index: b/drivers/ide/ide-disk.h
===================================================================
--- a/drivers/ide/ide-disk.h
+++ b/drivers/ide/ide-disk.h
@@ -9,9 +9,6 @@ struct ide_disk_obj {
 	unsigned int	openers;	/* protected by BKL for now */
 };
 
-#define ide_disk_g(disk) \
-	container_of((disk)->private_data, struct ide_disk_obj, driver)
-
 /* ide-disk.c */
 sector_t ide_disk_capacity(ide_drive_t *);
 ide_decl_devset(address);
Index: b/drivers/ide/ide-disk_ioctl.c
===================================================================
--- a/drivers/ide/ide-disk_ioctl.c
+++ b/drivers/ide/ide-disk_ioctl.c
@@ -17,7 +17,7 @@ int ide_disk_ioctl(struct inode *inode, 
 		   unsigned int cmd, unsigned long arg)
 {
 	struct block_device *bdev = inode->i_bdev;
-	struct ide_disk_obj *idkp = ide_disk_g(bdev->bd_disk);
+	struct ide_disk_obj *idkp = ide_drv_g(bdev->bd_disk, ide_disk_obj);
 	ide_drive_t *drive = idkp->drive;
 	int err;
 
