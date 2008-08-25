Return-Path: <linux-kernel-owner+w=401wt.eu-S1756738AbYHYJRq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738AbYHYJRq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 05:17:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754662AbYHYJRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 05:17:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:53152 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754060AbYHYJRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 05:17:04 -0400
From: Tejun Heo <tj@kernel.org>
To: Greg Kroah-Hartman <gregkh@suse.de>,
       Abdel Benamrouche <draconux@gmail.com>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH] block: allow deleting zero length partition
Date: Mon, 25 Aug 2008 18:15:39 +0900
Message-Id: <1219655740-11672-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1219655740-11672-1-git-send-email-tj@kernel.org>
References: <1219655740-11672-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 25 Aug 2008 09:16:59 +0000 (UTC)
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
index 375c579..c722de0 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -68,8 +68,6 @@ static int blkpg_ioctl(struct block_device *bdev, struct blkpg_ioctl_arg __user
 		case BLKPG_DEL_PARTITION:
 			if (!disk->part[part-1])
 				return -ENXIO;
-			if (disk->part[part - 1]->nr_sects == 0)
-				return -ENXIO;
 			bdevp = bdget_disk(disk, part);
 			if (!bdevp)
 				return -ENOMEM;
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 7d6b34e..1b1808e 100644
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

