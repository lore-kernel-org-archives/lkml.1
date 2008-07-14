Return-Path: <linux-kernel-owner+w=401wt.eu-S1756641AbYGNGHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641AbYGNGHR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 02:07:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752990AbYGNGHD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 02:07:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:60198 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752734AbYGNGHC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 02:07:02 -0400
Message-ID: <487AECF5.8060805@kernel.org>
Date: Mon, 14 Jul 2008 15:06:45 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] block: allow deleting zero length partition
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 14 Jul 2008 06:06:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

delete_partition() was noop for zero length partition.  As the
addition code allows creating zero lenght partition and deletion is
assumed to always succeed, this causes memory leak for zero length
partitions.  Allow zero length partitions to end their meaningless
lives.

While at it, allow deleting zero lenght partition via
BLKPG_DEL_PARTITION ioctl too.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/ioctl.c         |    2 --
 fs/partitions/check.c |    2 --
 2 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/block/ioctl.c b/block/ioctl.c
index 52d6385..f0178c4 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -67,8 +67,6 @@ static int blkpg_ioctl(struct block_device *bdev, struct blkpg_ioctl_arg __user
 		case BLKPG_DEL_PARTITION:
 			if (!disk->part[part-1])
 				return -ENXIO;
-			if (disk->part[part - 1]->nr_sects == 0)
-				return -ENXIO;
 			bdevp = bdget_disk(disk, part);
 			if (!bdevp)
 				return -ENOMEM;
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 6149e4b..3e0bf3f 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -325,8 +325,6 @@ void delete_partition(struct gendisk *disk, int part)
 
 	if (!p)
 		return;
-	if (!p->nr_sects)
-		return;
 	disk->part[part-1] = NULL;
 	p->start_sect = 0;
 	p->nr_sects = 0;
-- 
1.5.4.5


