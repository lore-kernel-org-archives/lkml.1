Return-Path: <linux-kernel-owner+w=401wt.eu-S1754295AbZJUQTI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295AbZJUQTI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 12:19:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754207AbZJUQTH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 12:19:07 -0400
Received: from smtp.nokia.com ([192.100.122.230]:19421 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754005AbZJUQTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 12:19:05 -0400
Date: Wed, 21 Oct 2009 19:12:01 +0300
From: Jarkko Lavinen <jarkko.lavinen@nokia.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: [PATCH 1/2] Disk hot removal causing oopses and fixes
Message-ID: <20091021161201.GA16968@angel.research.nokia.com>
Reply-To: Jarkko Lavinen <jarkko.lavinen@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: GNU/Linux angel.research.nokia.com
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 21 Oct 2009 16:18:52.0710 (UTC) FILETIME=[2E1C5460:01CA526A]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am proposing two patches to protect the request queue and io
elevator from inadvertent releasing.

I've been testing mmc driver robustness against rapid card removal
reinsert cycles and it has been rather easy to get a kernel oopses 
(on 2.6.28) because of insufficient locking. 

When MMC driver notices a card has been removed, it removes the
card and the block device.  The call proceeds to
blk_cleanup_queue() which marks the request queue dead, calls
elevator exit to release the elevator and puts request queue.
This releases elevator always and may also release the request
queue.

If file system is still mounted and using the disk after
blk_cleanup_queue() has been called, io requests will access
already free'ed structures and oopses and BUG_ON()s jump in.

When the proposed patches are applied, I am not able reproduce 
the oopses in io scheduler or elevator anymore. There is still
another oops is sysfs truing to add duplicate file, but i think
that is not related.

Cheers
Jarkko Lavinen

>From 9559377f3166345649c3406427f410cd51472944 Mon Sep 17 00:00:00 2001
From: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Date: Wed, 21 Oct 2009 18:48:18 +0300
Subject: [PATCH 1/2] block: Avoid dead request queue too early removal

If disk is removed while file system is still mounted, the disk
removal can release the dead request queue too early while
file system is still trying to sumit requests.

Signed-off-by: Jarkko Lavinen <jarkko.lavinen@nokia.com>
---
 fs/block_dev.c |   24 ++++++++++++++++++++----
 1 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 9cf4b92..91f2fc3 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1165,6 +1165,8 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 	int ret;
 	int partno;
 	int perm = 0;
+	int q_ref = 0;
+	struct module *owner;
 
 	if (mode & FMODE_READ)
 		perm |= MAY_READ;
@@ -1187,6 +1189,11 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 	if (!disk)
 		goto out_unlock_kernel;
 
+	if (blk_get_queue(disk->queue))
+		goto out_unlock_kernel;
+	else
+		q_ref = 1;
+
 	mutex_lock_nested(&bdev->bd_mutex, for_part);
 	if (!bdev->bd_openers) {
 		bdev->bd_disk = disk;
@@ -1248,8 +1255,10 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 			bd_set_size(bdev, (loff_t)bdev->bd_part->nr_sects << 9);
 		}
 	} else {
+		owner = disk->fops->owner;
+		blk_put_queue(disk->queue);
 		put_disk(disk);
-		module_put(disk->fops->owner);
+		module_put(owner);
 		disk = NULL;
 		if (bdev->bd_contains == bdev) {
 			if (bdev->bd_disk->fops->open) {
@@ -1281,9 +1290,15 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
  out_unlock_kernel:
 	unlock_kernel();
 
-	if (disk)
-		module_put(disk->fops->owner);
-	put_disk(disk);
+	if (disk) {
+		owner = disk->fops->owner;
+		if (q_ref)
+			blk_put_queue(disk->queue);
+
+		put_disk(disk);
+		module_put(owner);
+	}
+
 	bdput(bdev);
 
 	return ret;
@@ -1360,6 +1375,7 @@ static int __blkdev_put(struct block_device *bdev, fmode_t mode, int for_part)
 	if (!bdev->bd_openers) {
 		struct module *owner = disk->fops->owner;
 
+		blk_put_queue(disk->queue);
 		put_disk(disk);
 		module_put(owner);
 		disk_put_part(bdev->bd_part);
-- 
1.6.3.3

