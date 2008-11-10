Return-Path: <linux-kernel-owner+w=401wt.eu-S1754468AbYKJGak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468AbYKJGak (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 01:30:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751226AbYKJGac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 01:30:32 -0500
Received: from hera.kernel.org ([140.211.167.34]:51722 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912AbYKJGab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 01:30:31 -0500
Message-ID: <4917D4E6.5060008@kernel.org>
Date: Mon, 10 Nov 2008 15:29:58 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
CC: Neil Brown <neilb@suse.de>
Subject: [PATCH] block: make add_partition() return pointer to hd_struct
References: <4917D4AB.4080401@kernel.org>
In-Reply-To: <4917D4AB.4080401@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 10 Nov 2008 06:30:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make add_partition() return pointer to the new hd_struct on success
and ERR_PTR() value on failure.  This change will be used to fix md
autodetection bug.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Neil Brown <neilb@suse.de>
---
 block/ioctl.c         |    7 +++----
 fs/partitions/check.c |   25 +++++++++++++------------
 include/linux/genhd.h |    4 +++-
 3 files changed, 19 insertions(+), 17 deletions(-)

Index: work/fs/partitions/check.c
===================================================================
--- work.orig/fs/partitions/check.c
+++ work/fs/partitions/check.c
@@ -348,8 +348,8 @@ static ssize_t whole_disk_show(struct de
 static DEVICE_ATTR(whole_disk, S_IRUSR | S_IRGRP | S_IROTH,
 		   whole_disk_show, NULL);
 
-int add_partition(struct gendisk *disk, int partno,
-		  sector_t start, sector_t len, int flags)
+struct hd_struct *add_partition(struct gendisk *disk, int partno,
+				sector_t start, sector_t len, int flags)
 {
 	struct hd_struct *p;
 	dev_t devt = MKDEV(0, 0);
@@ -361,15 +361,15 @@ int add_partition(struct gendisk *disk,
 
 	err = disk_expand_part_tbl(disk, partno);
 	if (err)
-		return err;
+		return ERR_PTR(err);
 	ptbl = disk->part_tbl;
 
 	if (ptbl->part[partno])
-		return -EBUSY;
+		return ERR_PTR(-EBUSY);
 
 	p = kzalloc(sizeof(*p), GFP_KERNEL);
 	if (!p)
-		return -ENOMEM;
+		return ERR_PTR(-EBUSY);
 
 	if (!init_part_stats(p)) {
 		err = -ENOMEM;
@@ -424,20 +424,20 @@ int add_partition(struct gendisk *disk,
 	if (!ddev->uevent_suppress)
 		kobject_uevent(&pdev->kobj, KOBJ_ADD);
 
-	return 0;
+	return p;
 
 out_free_stats:
 	free_part_stats(p);
 out_free:
 	kfree(p);
-	return err;
+	return ERR_PTR(err);
 out_del:
 	kobject_put(p->holder_dir);
 	device_del(pdev);
 out_put:
 	put_device(pdev);
 	blk_free_devt(devt);
-	return err;
+	return ERR_PTR(err);
 }
 
 /* Not exported, helper to add_disk(). */
@@ -568,10 +568,11 @@ int rescan_partitions(struct gendisk *di
 			       disk->disk_name, p, (unsigned long long) size);
 			size = get_capacity(disk) - from;
 		}
-		res = add_partition(disk, p, from, size, state->parts[p].flags);
-		if (res) {
-			printk(KERN_ERR " %s: p%d could not be added: %d\n",
-				disk->disk_name, p, -res);
+		part = add_partition(disk, p, from, size,
+				     state->parts[p].flags);
+		if (IS_ERR(part)) {
+			printk(KERN_ERR " %s: p%d could not be added: %ld\n",
+			       disk->disk_name, p, -PTR_ERR(part));
 			continue;
 		}
 #ifdef CONFIG_BLK_DEV_MD
Index: work/include/linux/genhd.h
===================================================================
--- work.orig/include/linux/genhd.h
+++ work/include/linux/genhd.h
@@ -522,7 +522,9 @@ extern char *disk_name (struct gendisk *
 
 extern int disk_expand_part_tbl(struct gendisk *disk, int target);
 extern int rescan_partitions(struct gendisk *disk, struct block_device *bdev);
-extern int __must_check add_partition(struct gendisk *, int, sector_t, sector_t, int);
+extern struct hd_struct * __must_check add_partition(struct gendisk *disk,
+						     int partno, sector_t start,
+						     sector_t len, int flags);
 extern void delete_partition(struct gendisk *, int);
 extern void printk_all_partitions(void);
 
Index: work/block/ioctl.c
===================================================================
--- work.orig/block/ioctl.c
+++ work/block/ioctl.c
@@ -18,7 +18,6 @@ static int blkpg_ioctl(struct block_devi
 	struct disk_part_iter piter;
 	long long start, length;
 	int partno;
-	int err;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
@@ -61,10 +60,10 @@ static int blkpg_ioctl(struct block_devi
 			disk_part_iter_exit(&piter);
 
 			/* all seems OK */
-			err = add_partition(disk, partno, start, length,
-					    ADDPART_FLAG_NONE);
+			part = add_partition(disk, partno, start, length,
+					     ADDPART_FLAG_NONE);
 			mutex_unlock(&bdev->bd_mutex);
-			return err;
+			return IS_ERR(part) ? PTR_ERR(part) : 0;
 		case BLKPG_DEL_PARTITION:
 			part = disk_get_part(disk, partno);
 			if (!part)
