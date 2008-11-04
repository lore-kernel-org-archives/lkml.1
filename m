Return-Path: <linux-kernel-owner+w=401wt.eu-S1754045AbYKDEQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045AbYKDEQa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 23:16:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751160AbYKDEQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 23:16:20 -0500
Received: from hera.kernel.org ([140.211.167.34]:47682 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112AbYKDEQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 23:16:19 -0500
Message-ID: <490FCC87.1070205@kernel.org>
Date: Tue, 04 Nov 2008 13:16:07 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: petkovbb@gmail.com
CC: axboe@kernel.dk, bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Subject: [PATCH] block: fix __blkdev_get() for removable devices
References: <20081029071319.GA9205@gollum.tnic>	 <20081101201419.GA29462@gollum.tnic> <490F1AC6.8000109@kernel.org> <9ea470500811030956k209b2f2ci10bcde1ea4ac7334@mail.gmail.com>
In-Reply-To: <9ea470500811030956k209b2f2ci10bcde1ea4ac7334@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 04 Nov 2008 04:16:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 0762b8bde9729f10f8e6249809660ff2ec3ad735 moved disk_get_part()
in front of recursive get on the whole disk, which caused removable
devices to try disk_get_part() before rescanning after a new media is
inserted, which might fail legit open attempts or give the old
partition.

This patch fixes the problem by moving disk_get_part() after
__blkdev_get() on the whole disk.

This problem was spotted by Borislav Petkov.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: <Borislav Petkov> petkovbb@googlemail.com
---
Borislav, can you please verify this patch?  Thanks.

 fs/block_dev.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 88a776f..db831ef 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -986,7 +986,6 @@ static int __blkdev_put(struct block_device *bdev, fmode_t mode, int for_part);
 static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 {
 	struct gendisk *disk;
-	struct hd_struct *part = NULL;
 	int ret;
 	int partno;
 	int perm = 0;
@@ -1004,24 +1003,25 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 		return ret;
 	}
 
-	ret = -ENXIO;
-
 	lock_kernel();
 
+	ret = -ENXIO;
 	disk = get_gendisk(bdev->bd_dev, &partno);
 	if (!disk)
 		goto out_unlock_kernel;
-	part = disk_get_part(disk, partno);
-	if (!part)
-		goto out_unlock_kernel;
 
 	mutex_lock_nested(&bdev->bd_mutex, for_part);
 	if (!bdev->bd_openers) {
 		bdev->bd_disk = disk;
-		bdev->bd_part = part;
 		bdev->bd_contains = bdev;
 		if (!partno) {
 			struct backing_dev_info *bdi;
+
+			ret = -ENXIO;
+			bdev->bd_part = disk_get_part(disk, partno);
+			if (!bdev->bd_part)
+				goto out_clear;
+
 			if (disk->fops->open) {
 				ret = disk->fops->open(bdev, mode);
 				if (ret)
@@ -1049,18 +1049,17 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 			bdev->bd_contains = whole;
 			bdev->bd_inode->i_data.backing_dev_info =
 			   whole->bd_inode->i_data.backing_dev_info;
+			bdev->bd_part = disk_get_part(disk, partno);
 			if (!(disk->flags & GENHD_FL_UP) ||
-			    !part || !part->nr_sects) {
+			    !bdev->bd_part || !bdev->bd_part->nr_sects) {
 				ret = -ENXIO;
 				goto out_clear;
 			}
-			bd_set_size(bdev, (loff_t)part->nr_sects << 9);
+			bd_set_size(bdev, (loff_t)bdev->bd_part->nr_sects << 9);
 		}
 	} else {
-		disk_put_part(part);
 		put_disk(disk);
 		module_put(disk->fops->owner);
-		part = NULL;
 		disk = NULL;
 		if (bdev->bd_contains == bdev) {
 			if (bdev->bd_disk->fops->open) {
@@ -1080,6 +1079,7 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 	return 0;
 
  out_clear:
+	disk_put_part(bdev->bd_part);
 	bdev->bd_disk = NULL;
 	bdev->bd_part = NULL;
 	bdev->bd_inode->i_data.backing_dev_info = &default_backing_dev_info;
@@ -1091,7 +1091,6 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
  out_unlock_kernel:
 	unlock_kernel();
 
-	disk_put_part(part);
 	if (disk)
 		module_put(disk->fops->owner);
 	put_disk(disk);
