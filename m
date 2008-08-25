Return-Path: <linux-kernel-owner+w=401wt.eu-S1757148AbYHYJSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757148AbYHYJSp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 05:18:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755654AbYHYJRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 05:17:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:53158 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754622AbYHYJRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 05:17:08 -0400
From: Tejun Heo <tj@kernel.org>
To: Greg Kroah-Hartman <gregkh@suse.de>,
       Abdel Benamrouche <draconux@gmail.com>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Abdel Benamrouche <draconux@gmail.com>
Subject: [PATCH] block: update add_partition() error handling
Date: Mon, 25 Aug 2008 18:15:40 +0900
Message-Id: <1219655740-11672-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1219655740-11672-1-git-send-email-tj@kernel.org>
References: <1219655740-11672-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 25 Aug 2008 09:17:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

d805dda4 tried to fix error case handling in add_partition() but had a
few problems.

* disk->part[] entry is set early and left dangling if operation
  fails.

* Once device initialized, the last put_device() is responsible for
  freeing all the resources.  The failure path freed part_stats and p
  regardless of put_device() causing double free.

* holders subdir holds reference to the disk device, so failure path
  should remove it to release resources properly which was missing.

This patch fixes the above problems and while at it move partition
slot busy check into add_partition() for completeness and inlines
holders subdirectory creation.  Using separate function for it just
obfuscates the code.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Abdel Benamrouche <draconux@gmail.com>
---
 block/ioctl.c         |    7 ++-----
 fs/partitions/check.c |   40 +++++++++++++++++++++-------------------
 2 files changed, 23 insertions(+), 24 deletions(-)

diff --git a/block/ioctl.c b/block/ioctl.c
index c722de0..eb046ae 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -43,12 +43,9 @@ static int blkpg_ioctl(struct block_device *bdev, struct blkpg_ioctl_arg __user
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
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 1b1808e..43dbfab 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -300,15 +300,6 @@ struct device_type part_type = {
 	.release	= part_release,
 };
 
-static inline void partition_sysfs_add_subdir(struct hd_struct *p)
-{
-	struct kobject *k;
-
-	k = kobject_get(&p->dev.kobj);
-	p->holder_dir = kobject_create_and_add("holders", k);
-	kobject_put(k);
-}
-
 static inline void disk_sysfs_add_subdirs(struct gendisk *disk)
 {
 	struct kobject *k;
@@ -347,13 +338,16 @@ int add_partition(struct gendisk *disk, int part, sector_t start, sector_t len,
 	struct hd_struct *p;
 	int err;
 
+	if (disk->part[part - 1])
+		return -EBUSY;
+
 	p = kzalloc(sizeof(*p), GFP_KERNEL);
 	if (!p)
 		return -ENOMEM;
 
 	if (!init_part_stats(p)) {
 		err = -ENOMEM;
-		goto out0;
+		goto out_free;
 	}
 	p->start_sect = start;
 	p->nr_sects = len;
@@ -372,34 +366,42 @@ int add_partition(struct gendisk *disk, int part, sector_t start, sector_t len,
 	p->dev.class = &block_class;
 	p->dev.type = &part_type;
 	p->dev.parent = &disk->dev;
-	disk->part[part-1] = p;
 
 	/* delay uevent until 'holders' subdir is created */
 	p->dev.uevent_suppress = 1;
 	err = device_add(&p->dev);
 	if (err)
-		goto out1;
-	partition_sysfs_add_subdir(p);
+		goto out_put;
+
+	err = -ENOMEM;
+	p->holder_dir = kobject_create_and_add("holders", &p->dev.kobj);
+	if (!p->holder_dir)
+		goto out_del;
+
 	p->dev.uevent_suppress = 0;
 	if (flags & ADDPART_FLAG_WHOLEDISK) {
 		err = device_create_file(&p->dev, &dev_attr_whole_disk);
 		if (err)
-			goto out2;
+			goto out_del;
 	}
 
+	/* everything is up and running, commence */
+	disk->part[part - 1] = p;
+
 	/* suppress uevent if the disk supresses it */
 	if (!disk->dev.uevent_suppress)
 		kobject_uevent(&p->dev.kobj, KOBJ_ADD);
 
 	return 0;
 
-out2:
+out_free:
+	kfree(p);
+	return err;
+out_del:
+	kobject_put(p->holder_dir);
 	device_del(&p->dev);
-out1:
+out_put:
 	put_device(&p->dev);
-	free_part_stats(p);
-out0:
-	kfree(p);
 	return err;
 }
 
-- 
1.5.4.5

