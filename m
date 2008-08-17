Return-Path: <linux-kernel-owner+w=401wt.eu-S1756271AbYHQRYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271AbYHQRYx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 13:24:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754190AbYHQRXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 13:23:52 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:33170 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800AbYHQRXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 13:23:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=K3VAXrbWegYYhKV4pYeY39W4kOd4B26qs/2L7CNOS2XL7xlJlrTOMA8M5aPvMtRr4x
         nr1lV6NWqi0JOIzilEQeeH/fz5KtZ80WkyZEJSBv/LI7xzMGY/0B+CPDzQldKqNmcJ77
         TENG45IJUZSjdGVEtmGzVfH0w7B1YL2Rx4xgA=
To: Bartlomiej@gollum.tnic, Zolnierkiewicz@gollum.tnic, <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 1/5] ide: unify conversion macros
Date: Sun, 17 Aug 2008 19:23:42 +0200
Message-Id: <1218993826-4571-2-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1218993826-4571-1-git-send-email-petkovbb@gmail.com>
References: <1218993826-4571-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce to_ide_dev() and ide_drv_g() macros and replace the respective
definitions of similar ones in each driver.

There should be no functionality change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-cd.c     |   17 ++++++-----------
 drivers/ide/ide-floppy.c |   21 +++++++++------------
 drivers/ide/ide-tape.c   |   23 ++++++++---------------
 include/linux/ide.h      |    8 +++++++-
 4 files changed, 30 insertions(+), 39 deletions(-)

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 5c23ec9..5e675f3 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -52,11 +52,6 @@
 
 static DEFINE_MUTEX(idecd_ref_mutex);
 
-#define to_ide_cd(obj) container_of(obj, struct cdrom_info, kref)
-
-#define ide_cd_g(disk) \
-	container_of((disk)->private_data, struct cdrom_info, driver)
-
 static void ide_cd_release(struct kref *);
 
 static struct cdrom_info *ide_cd_get(struct gendisk *disk)
@@ -64,7 +59,7 @@ static struct cdrom_info *ide_cd_get(struct gendisk *disk)
 	struct cdrom_info *cd = NULL;
 
 	mutex_lock(&idecd_ref_mutex);
-	cd = ide_cd_g(disk);
+	cd = ide_drv_g(disk, cdrom_info);
 	if (cd) {
 		if (ide_device_get(cd->drive))
 			cd = NULL;
@@ -1937,7 +1932,7 @@ static void ide_cd_remove(ide_drive_t *drive)
 
 static void ide_cd_release(struct kref *kref)
 {
-	struct cdrom_info *info = to_ide_cd(kref);
+	struct cdrom_info *info = to_ide_drv(kref, cdrom_info);
 	struct cdrom_device_info *devinfo = &info->devinfo;
 	ide_drive_t *drive = info->drive;
 	struct gendisk *g = info->disk;
@@ -1995,7 +1990,7 @@ static int idecd_open(struct inode *inode, struct file *file)
 static int idecd_release(struct inode *inode, struct file *file)
 {
 	struct gendisk *disk = inode->i_bdev->bd_disk;
-	struct cdrom_info *info = ide_cd_g(disk);
+	struct cdrom_info *info = ide_drv_g(disk, cdrom_info);
 
 	cdrom_release(&info->devinfo, file);
 
@@ -2047,7 +2042,7 @@ static int idecd_ioctl(struct inode *inode, struct file *file,
 			unsigned int cmd, unsigned long arg)
 {
 	struct block_device *bdev = inode->i_bdev;
-	struct cdrom_info *info = ide_cd_g(bdev->bd_disk);
+	struct cdrom_info *info = ide_drv_g(bdev->bd_disk, cdrom_info);
 	int err;
 
 	switch (cmd) {
@@ -2068,13 +2063,13 @@ static int idecd_ioctl(struct inode *inode, struct file *file,
 
 static int idecd_media_changed(struct gendisk *disk)
 {
-	struct cdrom_info *info = ide_cd_g(disk);
+	struct cdrom_info *info = ide_drv_g(disk, cdrom_info);
 	return cdrom_media_changed(&info->devinfo);
 }
 
 static int idecd_revalidate_disk(struct gendisk *disk)
 {
-	struct cdrom_info *info = ide_cd_g(disk);
+	struct cdrom_info *info = ide_drv_g(disk, cdrom_info);
 	struct request_sense sense;
 
 	ide_cd_read_toc(info->drive, &sense);
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 2a34f1a..2a54a25 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -84,11 +84,6 @@
 
 static DEFINE_MUTEX(idefloppy_ref_mutex);
 
-#define to_ide_floppy(obj) container_of(obj, struct ide_floppy_obj, kref)
-
-#define ide_floppy_g(disk) \
-	container_of((disk)->private_data, struct ide_floppy_obj, driver)
-
 static void idefloppy_cleanup_obj(struct kref *);
 
 static struct ide_floppy_obj *ide_floppy_get(struct gendisk *disk)
@@ -96,7 +91,7 @@ static struct ide_floppy_obj *ide_floppy_get(struct gendisk *disk)
 	struct ide_floppy_obj *floppy = NULL;
 
 	mutex_lock(&idefloppy_ref_mutex);
-	floppy = ide_floppy_g(disk);
+	floppy = ide_drv_g(disk, ide_floppy_obj);
 	if (floppy) {
 		if (ide_device_get(floppy->drive))
 			floppy = NULL;
@@ -625,7 +620,7 @@ static void ide_floppy_remove(ide_drive_t *drive)
 
 static void idefloppy_cleanup_obj(struct kref *kref)
 {
-	struct ide_floppy_obj *floppy = to_ide_floppy(kref);
+	struct ide_floppy_obj *floppy = to_ide_drv(kref, ide_floppy_obj);
 	ide_drive_t *drive = floppy->drive;
 	struct gendisk *g = floppy->disk;
 
@@ -733,7 +728,7 @@ out_put_floppy:
 static int idefloppy_release(struct inode *inode, struct file *filp)
 {
 	struct gendisk *disk = inode->i_bdev->bd_disk;
-	struct ide_floppy_obj *floppy = ide_floppy_g(disk);
+	struct ide_floppy_obj *floppy = ide_drv_g(disk, ide_floppy_obj);
 	ide_drive_t *drive = floppy->drive;
 
 	debug_log("Reached %s\n", __func__);
@@ -752,7 +747,8 @@ static int idefloppy_release(struct inode *inode, struct file *filp)
 
 static int idefloppy_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 {
-	struct ide_floppy_obj *floppy = ide_floppy_g(bdev->bd_disk);
+	struct ide_floppy_obj *floppy = ide_drv_g(bdev->bd_disk,
+						     ide_floppy_obj);
 	ide_drive_t *drive = floppy->drive;
 
 	geo->heads = drive->bios_head;
@@ -783,7 +779,8 @@ static int idefloppy_ioctl(struct inode *inode, struct file *file,
 			unsigned int cmd, unsigned long arg)
 {
 	struct block_device *bdev = inode->i_bdev;
-	struct ide_floppy_obj *floppy = ide_floppy_g(bdev->bd_disk);
+	struct ide_floppy_obj *floppy = ide_drv_g(bdev->bd_disk,
+						     ide_floppy_obj);
 	ide_drive_t *drive = floppy->drive;
 	struct ide_atapi_pc pc;
 	void __user *argp = (void __user *)arg;
@@ -812,7 +809,7 @@ static int idefloppy_ioctl(struct inode *inode, struct file *file,
 
 static int idefloppy_media_changed(struct gendisk *disk)
 {
-	struct ide_floppy_obj *floppy = ide_floppy_g(disk);
+	struct ide_floppy_obj *floppy = ide_drv_g(disk, ide_floppy_obj);
 	ide_drive_t *drive = floppy->drive;
 	int ret;
 
@@ -828,7 +825,7 @@ static int idefloppy_media_changed(struct gendisk *disk)
 
 static int idefloppy_revalidate_disk(struct gendisk *disk)
 {
-	struct ide_floppy_obj *floppy = ide_floppy_g(disk);
+	struct ide_floppy_obj *floppy = ide_drv_g(disk, ide_floppy_obj);
 	set_capacity(disk, idefloppy_capacity(floppy->drive));
 	return 0;
 }
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 417e600..9ee93db 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -267,11 +267,6 @@ static DEFINE_MUTEX(idetape_ref_mutex);
 
 static struct class *idetape_sysfs_class;
 
-#define to_ide_tape(obj) container_of(obj, struct ide_tape_obj, kref)
-
-#define ide_tape_g(disk) \
-	container_of((disk)->private_data, struct ide_tape_obj, driver)
-
 static void ide_tape_release(struct kref *);
 
 static struct ide_tape_obj *ide_tape_get(struct gendisk *disk)
@@ -279,7 +274,7 @@ static struct ide_tape_obj *ide_tape_get(struct gendisk *disk)
 	struct ide_tape_obj *tape = NULL;
 
 	mutex_lock(&idetape_ref_mutex);
-	tape = ide_tape_g(disk);
+	tape = ide_drv_g(disk, ide_tape_obj);
 	if (tape) {
 		if (ide_device_get(tape->drive))
 			tape = NULL;
@@ -306,8 +301,6 @@ static void ide_tape_put(struct ide_tape_obj *tape)
  */
 static struct ide_tape_obj *idetape_devs[MAX_HWIFS * MAX_DRIVES];
 
-#define ide_tape_f(file) ((file)->private_data)
-
 static struct ide_tape_obj *ide_tape_chrdev_get(unsigned int i)
 {
 	struct ide_tape_obj *tape = NULL;
@@ -1541,7 +1534,7 @@ static int idetape_space_over_filemarks(ide_drive_t *drive, short mt_op,
 static ssize_t idetape_chrdev_read(struct file *file, char __user *buf,
 				   size_t count, loff_t *ppos)
 {
-	struct ide_tape_obj *tape = ide_tape_f(file);
+	struct ide_tape_obj *tape = file->private_data;
 	ide_drive_t *drive = tape->drive;
 	ssize_t bytes_read, temp, actually_read = 0, rc;
 	ssize_t ret = 0;
@@ -1603,7 +1596,7 @@ finish:
 static ssize_t idetape_chrdev_write(struct file *file, const char __user *buf,
 				     size_t count, loff_t *ppos)
 {
-	struct ide_tape_obj *tape = ide_tape_f(file);
+	struct ide_tape_obj *tape = file->private_data;
 	ide_drive_t *drive = tape->drive;
 	ssize_t actually_written = 0;
 	ssize_t ret = 0;
@@ -1835,7 +1828,7 @@ static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
 static int idetape_chrdev_ioctl(struct inode *inode, struct file *file,
 				unsigned int cmd, unsigned long arg)
 {
-	struct ide_tape_obj *tape = ide_tape_f(file);
+	struct ide_tape_obj *tape = file->private_data;
 	ide_drive_t *drive = tape->drive;
 	struct mtop mtop;
 	struct mtget mtget;
@@ -2012,7 +2005,7 @@ static void idetape_write_release(ide_drive_t *drive, unsigned int minor)
 
 static int idetape_chrdev_release(struct inode *inode, struct file *filp)
 {
-	struct ide_tape_obj *tape = ide_tape_f(filp);
+	struct ide_tape_obj *tape = filp->private_data;
 	ide_drive_t *drive = tape->drive;
 	unsigned int minor = iminor(inode);
 
@@ -2271,7 +2264,7 @@ static void ide_tape_remove(ide_drive_t *drive)
 
 static void ide_tape_release(struct kref *kref)
 {
-	struct ide_tape_obj *tape = to_ide_tape(kref);
+	struct ide_tape_obj *tape = to_ide_drv(kref, ide_tape_obj);
 	ide_drive_t *drive = tape->drive;
 	struct gendisk *g = tape->disk;
 
@@ -2354,7 +2347,7 @@ static int idetape_open(struct inode *inode, struct file *filp)
 static int idetape_release(struct inode *inode, struct file *filp)
 {
 	struct gendisk *disk = inode->i_bdev->bd_disk;
-	struct ide_tape_obj *tape = ide_tape_g(disk);
+	struct ide_tape_obj *tape = ide_drv_g(disk, ide_tape_obj);
 
 	ide_tape_put(tape);
 
@@ -2365,7 +2358,7 @@ static int idetape_ioctl(struct inode *inode, struct file *file,
 			unsigned int cmd, unsigned long arg)
 {
 	struct block_device *bdev = inode->i_bdev;
-	struct ide_tape_obj *tape = ide_tape_g(bdev->bd_disk);
+	struct ide_tape_obj *tape = ide_drv_g(bdev->bd_disk, ide_tape_obj);
 	ide_drive_t *drive = tape->drive;
 	int err = generic_ide_ioctl(drive, file, bdev, cmd, arg);
 	if (err == -EINVAL)
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 2c28f9a..6b5d425 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -568,7 +568,13 @@ struct ide_drive_s {
 
 typedef struct ide_drive_s ide_drive_t;
 
-#define to_ide_device(dev)container_of(dev, ide_drive_t, gendev)
+#define to_ide_device(dev)		container_of(dev, ide_drive_t, gendev)
+
+#define to_ide_drv(obj, cont_type)	\
+	container_of(obj, struct cont_type, kref)
+
+#define ide_drv_g(disk, cont_type)	\
+	container_of((disk)->private_data, struct cont_type, driver)
 
 struct ide_task_s;
 struct ide_port_info;
-- 
1.5.5.4

