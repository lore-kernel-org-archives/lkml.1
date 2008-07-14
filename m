Return-Path: <linux-kernel-owner+w=401wt.eu-S1756752AbYGNGHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752AbYGNGHj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 02:07:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753648AbYGNGHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 02:07:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:60207 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753561AbYGNGH3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 02:07:29 -0400
Message-ID: <487AED0F.5050507@kernel.org>
Date: Mon, 14 Jul 2008 15:07:11 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] block: update add_partition() error handling
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 14 Jul 2008 06:07:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add_partition() had some number of holes in the error handling path.
Update it.

* make add_partition() return error code on failure and report failure
  from caller

* make add_partition() check whether the specified slot is already
  occupied instead of doing that in caller

* make add_partition() check error return from device_add()

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/ioctl.c         |   17 +++++++++--------
 fs/partitions/check.c |   44 ++++++++++++++++++++++++++++++++++----------
 include/linux/genhd.h |    2 +-
 3 files changed, 44 insertions(+), 19 deletions(-)

diff --git a/block/ioctl.c b/block/ioctl.c
index f0178c4..ecbdd74 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -16,7 +16,7 @@ static int blkpg_ioctl(struct block_device *bdev, struct blkpg_ioctl_arg __user
 	struct blkpg_partition p;
 	long long start, length;
 	int part;
-	int i;
+	int i, rc;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
@@ -42,12 +42,9 @@ static int blkpg_ioctl(struct block_device *bdev, struct blkpg_ioctl_arg __user
 				    || pstart < 0 || plength < 0)
 					return -EINVAL;
 			}
-			/* partition number in use? */
+
 			mutex_lock(&bdev->bd_mutex);
-			if (disk->part[part - 1]) {
-				mutex_unlock(&bdev->bd_mutex);
-				return -EBUSY;
-			}
+
 			/* overlap? */
 			for (i = 0; i < disk->minors - 1; i++) {
 				struct hd_struct *s = disk->part[i];
@@ -60,10 +57,14 @@ static int blkpg_ioctl(struct block_device *bdev, struct blkpg_ioctl_arg __user
 					return -EBUSY;
 				}
 			}
+
 			/* all seems OK */
-			add_partition(disk, part, start, length, ADDPART_FLAG_NONE);
+			rc = add_partition(disk, part, start, length,
+					   ADDPART_FLAG_NONE);
+
 			mutex_unlock(&bdev->bd_mutex);
-			return 0;
+			return rc;
+
 		case BLKPG_DEL_PARTITION:
 			if (!disk->part[part-1])
 				return -ENXIO;
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 3e0bf3f..b75ca08 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -342,19 +342,24 @@ static ssize_t whole_disk_show(struct device *dev,
 static DEVICE_ATTR(whole_disk, S_IRUSR | S_IRGRP | S_IROTH,
 		   whole_disk_show, NULL);
 
-void add_partition(struct gendisk *disk, int part, sector_t start, sector_t len, int flags)
+int add_partition(struct gendisk *disk, int part,
+		  sector_t start, sector_t len, int flags)
 {
-	struct hd_struct *p;
+	struct hd_struct *p = NULL;
 	int err;
 
+	if (disk->part[part - 1]) {
+		err = -EBUSY;
+		goto fail;
+	}
+
+	err = -ENOMEM;
 	p = kzalloc(sizeof(*p), GFP_KERNEL);
 	if (!p)
-		return;
+		goto fail;
+	if (!init_part_stats(p))
+		goto fail;
 
-	if (!init_part_stats(p)) {
-		kfree(p);
-		return;
-	}
 	p->start_sect = start;
 	p->nr_sects = len;
 	p->partno = part;
@@ -376,15 +381,29 @@ void add_partition(struct gendisk *disk, int part, sector_t start, sector_t len,
 
 	/* delay uevent until 'holders' subdir is created */
 	p->dev.uevent_suppress = 1;
-	device_add(&p->dev);
+	err = device_add(&p->dev);
+	if (err)
+		goto fail;
+
 	partition_sysfs_add_subdir(p);
 	p->dev.uevent_suppress = 0;
-	if (flags & ADDPART_FLAG_WHOLEDISK)
+	if (flags & ADDPART_FLAG_WHOLEDISK) {
 		err = device_create_file(&p->dev, &dev_attr_whole_disk);
+		printk(" %s: failed to create sysfs attrs (%d)\n",
+		       dev_name(&p->dev), err);
+	}
 
 	/* suppress uevent if the disk supresses it */
 	if (!disk->dev.uevent_suppress)
 		kobject_uevent(&p->dev.kobj, KOBJ_ADD);
+
+	return 0;
+
+ fail:
+	if (p)
+		free_part_stats(p);
+	kfree(p);
+	return err;
 }
 
 /* Not exported, helper to add_disk(). */
@@ -484,7 +503,12 @@ int rescan_partitions(struct gendisk *disk, struct block_device *bdev)
 			printk(" %s: p%d exceeds device capacity\n",
 				disk->disk_name, p);
 		}
-		add_partition(disk, p, from, size, state->parts[p].flags);
+		res = add_partition(disk, p, from, size, state->parts[p].flags);
+		if (res) {
+			printk(" %s: failed to add p%d (%d)\n",
+			       disk->disk_name, p, res);
+			continue;
+		}
 #ifdef CONFIG_BLK_DEV_MD
 		if (state->parts[p].flags & ADDPART_FLAG_RAID)
 			md_autodetect_dev(bdev->bd_dev+p);
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index ae7aec3..e485cf0 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -529,7 +529,7 @@ extern dev_t blk_lookup_devt(const char *name, int part);
 extern char *disk_name (struct gendisk *hd, int part, char *buf);
 
 extern int rescan_partitions(struct gendisk *disk, struct block_device *bdev);
-extern void add_partition(struct gendisk *, int, sector_t, sector_t, int);
+extern int add_partition(struct gendisk *, int, sector_t, sector_t, int);
 extern void delete_partition(struct gendisk *, int);
 extern void printk_all_partitions(void);
 
-- 
1.5.4.5

