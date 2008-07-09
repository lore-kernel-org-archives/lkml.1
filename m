Return-Path: <linux-kernel-owner+w=401wt.eu-S1754724AbYGIRwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724AbYGIRwg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 13:52:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753498AbYGIRw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 13:52:26 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751851AbYGIRwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 13:52:25 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Add error handling to add_partition() and callers
To: aeb@cwi.nl, axboe@kernel.dk, akpm@linux-foundation.org
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Date: Wed, 09 Jul 2008 18:51:39 +0100
Message-ID: <20080709175139.15954.79394.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add error handling to add_partition() and its callers.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 block/ioctl.c         |    7 +++--
 fs/block_dev.c        |   29 ++++++++++++++++---
 fs/partitions/check.c |   75 ++++++++++++++++++++++++++++++++++++++-----------
 include/linux/genhd.h |    6 +++-
 4 files changed, 90 insertions(+), 27 deletions(-)


diff --git a/block/ioctl.c b/block/ioctl.c
index 52d6385..15d5921 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -16,7 +16,7 @@ static int blkpg_ioctl(struct block_device *bdev, struct blkpg_ioctl_arg __user
 	struct blkpg_partition p;
 	long long start, length;
 	int part;
-	int i;
+	int i, ret;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
@@ -61,9 +61,10 @@ static int blkpg_ioctl(struct block_device *bdev, struct blkpg_ioctl_arg __user
 				}
 			}
 			/* all seems OK */
-			add_partition(disk, part, start, length, ADDPART_FLAG_NONE);
+			ret = add_partition(disk, part, start, length,
+					    ADDPART_FLAG_NONE);
 			mutex_unlock(&bdev->bd_mutex);
-			return 0;
+			return ret;
 		case BLKPG_DEL_PARTITION:
 			if (!disk->part[part-1])
 				return -ENXIO;
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 10d8a0a..cc36d10 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -960,12 +960,13 @@ static int do_open(struct block_device *bdev, struct file *file, int for_part)
 		bdev->bd_disk = disk;
 		bdev->bd_contains = bdev;
 		if (!part) {
-			struct backing_dev_info *bdi;
+			struct backing_dev_info *old_bdi, *bdi;
 			if (disk->fops->open) {
 				ret = disk->fops->open(bdev->bd_inode, file);
 				if (ret)
 					goto out_first;
 			}
+			old_bdi = bdev->bd_inode->i_data.backing_dev_info;
 			if (!bdev->bd_openers) {
 				bd_set_size(bdev,(loff_t)get_capacity(disk)<<9);
 				bdi = blk_get_backing_dev_info(bdev);
@@ -973,8 +974,16 @@ static int do_open(struct block_device *bdev, struct file *file, int for_part)
 					bdi = &default_backing_dev_info;
 				bdev->bd_inode->i_data.backing_dev_info = bdi;
 			}
-			if (bdev->bd_invalidated)
-				rescan_partitions(disk, bdev);
+			if (bdev->bd_invalidated) {
+				ret = rescan_partitions(disk, bdev);
+				if (ret < 0) {
+					if (!bdev->bd_openers)
+						bdev->bd_inode->i_data.
+							backing_dev_info =
+							old_bdi;
+					goto out_first_open;
+				}
+			}
 		} else {
 			struct hd_struct *p;
 			struct block_device *whole;
@@ -1007,8 +1016,11 @@ static int do_open(struct block_device *bdev, struct file *file, int for_part)
 				if (ret)
 					goto out;
 			}
-			if (bdev->bd_invalidated)
-				rescan_partitions(bdev->bd_disk, bdev);
+			if (bdev->bd_invalidated) {
+				ret = rescan_partitions(bdev->bd_disk, bdev);
+				if (ret < 0)
+					goto out_open;
+			}
 		}
 	}
 	bdev->bd_openers++;
@@ -1018,6 +1030,13 @@ static int do_open(struct block_device *bdev, struct file *file, int for_part)
 	unlock_kernel();
 	return 0;
 
+out_open:
+	if (disk->fops->release)
+		ret = disk->fops->release(bdev->bd_inode, file);
+	goto out;
+out_first_open:
+	if (disk->fops->release)
+		ret = disk->fops->release(bdev->bd_inode, file);
 out_first:
 	bdev->bd_disk = NULL;
 	bdev->bd_inode->i_data.backing_dev_info = &default_backing_dev_info;
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index efef715..246d4fb 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -300,13 +300,16 @@ struct device_type part_type = {
 	.release	= part_release,
 };
 
-static inline void partition_sysfs_add_subdir(struct hd_struct *p)
+static inline int partition_sysfs_add_subdir(struct hd_struct *p)
 {
-	struct kobject *k;
+	struct kobject *k, *dir;
 
 	k = kobject_get(&p->dev.kobj);
-	p->holder_dir = kobject_create_and_add("holders", k);
+	dir = kobject_create_and_add("holders", k);
 	kobject_put(k);
+	if (dir)
+		p->holder_dir = dir;
+	return dir ? 0 : -ENOMEM;
 }
 
 static inline void disk_sysfs_add_subdirs(struct gendisk *disk)
@@ -344,19 +347,19 @@ static ssize_t whole_disk_show(struct device *dev,
 static DEVICE_ATTR(whole_disk, S_IRUSR | S_IRGRP | S_IROTH,
 		   whole_disk_show, NULL);
 
-void add_partition(struct gendisk *disk, int part, sector_t start, sector_t len, int flags)
+int add_partition(struct gendisk *disk, int part, sector_t start, sector_t len,
+		  int flags)
 {
 	struct hd_struct *p;
 	int err;
 
+	err = -ENOMEM;
 	p = kzalloc(sizeof(*p), GFP_KERNEL);
 	if (!p)
-		return;
+		goto error_alloc_p;
 
-	if (!init_part_stats(p)) {
-		kfree(p);
-		return;
-	}
+	if (!init_part_stats(p))
+		goto error_alloc_stats;
 	p->start_sect = start;
 	p->nr_sects = len;
 	p->partno = part;
@@ -378,15 +381,43 @@ void add_partition(struct gendisk *disk, int part, sector_t start, sector_t len,
 
 	/* delay uevent until 'holders' subdir is created */
 	p->dev.uevent_suppress = 1;
-	device_add(&p->dev);
-	partition_sysfs_add_subdir(p);
+	err = device_add(&p->dev);
+	if (err < 0)
+		goto error_device_add;
+
+	err = partition_sysfs_add_subdir(p);
+	if (err < 0)
+		goto error_present_partition;
 	p->dev.uevent_suppress = 0;
-	if (flags & ADDPART_FLAG_WHOLEDISK)
+	if (flags & ADDPART_FLAG_WHOLEDISK) {
 		err = device_create_file(&p->dev, &dev_attr_whole_disk);
+		if (err < 0)
+			goto error_present_whole_disk;
+	}
 
-	/* suppress uevent if the disk supresses it */
-	if (!disk->dev.uevent_suppress)
-		kobject_uevent(&p->dev.kobj, KOBJ_ADD);
+	/* don't send uevent if the disk suppresses it */
+	if (!disk->dev.uevent_suppress) {
+		err = kobject_uevent(&p->dev.kobj, KOBJ_ADD);
+		if (err < 0)
+			goto error_notify;
+	}
+
+	return 0;
+
+error_notify:
+	device_remove_file(&p->dev, &dev_attr_whole_disk);
+error_present_whole_disk:
+	kobject_put(p->holder_dir);
+error_present_partition:
+	device_del(&p->dev);
+error_device_add:
+	free_part_stats(p);
+error_alloc_stats:
+	kfree(p);
+error_alloc_p:
+	printk(KERN_ERR "%s: Error %d whilst adding partition %d\n",
+	       disk->disk_name, err, part);
+	return err;
 }
 
 /* Not exported, helper to add_disk(). */
@@ -475,7 +506,9 @@ int rescan_partitions(struct gendisk *disk, struct block_device *bdev)
 		return -EIO;
 
 	/* tell userspace that the media / partition table may have changed */
-	kobject_uevent(&disk->dev.kobj, KOBJ_CHANGE);
+	res = kobject_uevent(&disk->dev.kobj, KOBJ_CHANGE);
+	if (res < 0)
+		goto error;
 
 	for (p = 1; p < state->limit; p++) {
 		sector_t size = state->parts[p].size;
@@ -486,7 +519,9 @@ int rescan_partitions(struct gendisk *disk, struct block_device *bdev)
 			printk(" %s: p%d exceeds device capacity\n",
 				disk->disk_name, p);
 		}
-		add_partition(disk, p, from, size, state->parts[p].flags);
+		res = add_partition(disk, p, from, size, state->parts[p].flags);
+		if (res < 0)
+			goto error;
 #ifdef CONFIG_BLK_DEV_MD
 		if (state->parts[p].flags & ADDPART_FLAG_RAID)
 			md_autodetect_dev(bdev->bd_dev+p);
@@ -494,6 +529,12 @@ int rescan_partitions(struct gendisk *disk, struct block_device *bdev)
 	}
 	kfree(state);
 	return 0;
+
+error:
+	printk(KERN_ERR "%s: Error %d during partition rescanning\n",
+	       disk->disk_name, res);
+	kfree(state);
+	return res;
 }
 
 unsigned char *read_dev_sector(struct block_device *bdev, sector_t n, Sector *p)
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index e878741..cbd144d 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -540,8 +540,10 @@ struct unixware_disklabel {
 extern dev_t blk_lookup_devt(const char *name, int part);
 extern char *disk_name (struct gendisk *hd, int part, char *buf);
 
-extern int rescan_partitions(struct gendisk *disk, struct block_device *bdev);
-extern void add_partition(struct gendisk *, int, sector_t, sector_t, int);
+extern int rescan_partitions(struct gendisk *disk, struct block_device *bdev)
+	__must_check;
+extern int add_partition(struct gendisk *, int, sector_t, sector_t, int)
+	__must_check;
 extern void delete_partition(struct gendisk *, int);
 extern void printk_all_partitions(void);
 

