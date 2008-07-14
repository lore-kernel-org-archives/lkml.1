Return-Path: <linux-kernel-owner+w=401wt.eu-S1757304AbYGNHuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304AbYGNHuu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 03:50:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756056AbYGNHti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 03:49:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:36873 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755932AbYGNHtc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 03:49:32 -0400
From: Tejun Heo <tj@kernel.org>
To: jens.axboe@oracle.com, James.Bottomley@HansenPartnership.com,
       bharrosh@panasas.com, greg.freemyer@gmail.com,
       linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, liml@rtr.ca,
       viro@ftp.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 03/13] block: move capacity from disk to part0
Date: Mon, 14 Jul 2008 16:48:03 +0900
Message-Id: <1216021693-483-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1216021693-483-1-git-send-email-tj@kernel.org>
References: <1216021693-483-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 14 Jul 2008 07:48:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move disk->capacity to part0->nr_sects and convert all users who
directly accessed the field to use {get|set}_capacity().  This is done
early to allow the __dev field to be moved.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/block/aoe/aoeblk.c |    2 +-
 drivers/block/aoe/aoecmd.c |    4 ++--
 drivers/block/aoe/aoedev.c |    2 +-
 fs/partitions/check.c      |    2 +-
 include/linux/genhd.h      |    5 ++---
 5 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/block/aoe/aoeblk.c b/drivers/block/aoe/aoeblk.c
index 3edb6cb..aa69556 100644
--- a/drivers/block/aoe/aoeblk.c
+++ b/drivers/block/aoe/aoeblk.c
@@ -276,7 +276,7 @@ aoeblk_gdalloc(void *vp)
 	gd->first_minor = d->sysminor * AOE_PARTITIONS;
 	gd->fops = &aoe_bdops;
 	gd->private_data = d;
-	gd->capacity = d->ssize;
+	set_capacity(gd, d->ssize);
 	snprintf(gd->disk_name, sizeof gd->disk_name, "etherd/e%ld.%d",
 		d->aoemajor, d->aoeminor);
 
diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index 6710df3..b13e0b7 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -645,7 +645,7 @@ aoecmd_sleepwork(struct work_struct *work)
 		unsigned long flags;
 		u64 ssize;
 
-		ssize = d->gd->capacity;
+		ssize = get_capacity(d->gd);
 		bd = bdget_disk(d->gd, 0);
 
 		if (bd) {
@@ -707,7 +707,7 @@ ataid_complete(struct aoedev *d, struct aoetgt *t, unsigned char *id)
 	if (d->flags & (DEVFL_GDALLOC|DEVFL_NEWSIZE))
 		return;
 	if (d->gd != NULL) {
-		d->gd->capacity = ssize;
+		set_capacity(d->gd, ssize);
 		d->flags |= DEVFL_NEWSIZE;
 	} else
 		d->flags |= DEVFL_GDALLOC;
diff --git a/drivers/block/aoe/aoedev.c b/drivers/block/aoe/aoedev.c
index a1d813a..6a8038d 100644
--- a/drivers/block/aoe/aoedev.c
+++ b/drivers/block/aoe/aoedev.c
@@ -91,7 +91,7 @@ aoedev_downdev(struct aoedev *d)
 	}
 
 	if (d->gd)
-		d->gd->capacity = 0;
+		set_capacity(d->gd, 0);
 
 	d->flags &= ~DEVFL_UP;
 }
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index d4e677d..d504c1a 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -582,7 +582,7 @@ void del_gendisk(struct gendisk *disk)
 		delete_partition(disk, part->partno);
 	}
 	invalidate_partition(disk, 0);
-	disk->capacity = 0;
+	set_capacity(disk, 0);
 	disk->flags &= ~GENHD_FL_UP;
 	unlink_gendisk(disk);
 	disk_stat_set_all(disk, 0);
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 9018b11..0c15733 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -139,7 +139,6 @@ struct gendisk {
 	struct block_device_operations *fops;
 	struct request_queue *queue;
 	void *private_data;
-	sector_t capacity;
 
 	int flags;
 	struct device *driverfs_dev;  // FIXME: remove
@@ -397,11 +396,11 @@ static inline sector_t get_start_sect(struct block_device *bdev)
 }
 static inline sector_t get_capacity(struct gendisk *disk)
 {
-	return disk->capacity;
+	return disk->part0.nr_sects;
 }
 static inline void set_capacity(struct gendisk *disk, sector_t size)
 {
-	disk->capacity = size;
+	disk->part0.nr_sects = size;
 }
 
 #ifdef CONFIG_SOLARIS_X86_PARTITION
-- 
1.5.4.5

