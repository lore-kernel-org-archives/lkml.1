Return-Path: <linux-kernel-owner+w=401wt.eu-S1751964AbZGNL75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964AbZGNL75 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 07:59:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751207AbZGNL75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 07:59:57 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52916 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751074AbZGNL74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 07:59:56 -0400
From: Xiaotian Feng <dfeng@redhat.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, Xiaotian Feng <dfeng@redhat.com>
Subject: [RFC PATCH] block: slightly optimize blkdev_ioctl BLKRA{SET,GET}
Date: Tue, 14 Jul 2009 19:59:54 +0800
Message-Id: <1247572794-24107-1-git-send-email-dfeng@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Slightly optimize blkdev_ioctl by using shift instead of multiply
and divide.

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
---
 block/ioctl.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/ioctl.c b/block/ioctl.c
index 500e4c7..f8c7362 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -305,7 +305,7 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 		bdi = blk_get_backing_dev_info(bdev);
 		if (bdi == NULL)
 			return -ENOTTY;
-		return put_long(arg, (bdi->ra_pages * PAGE_CACHE_SIZE) / 512);
+		return put_long(arg, bdi->ra_pages << (PAGE_CACHE_SHIFT - 9));
 	case BLKROGET:
 		return put_int(arg, bdev_read_only(bdev) != 0);
 	case BLKBSZGET: /* get the logical block size (cf. BLKSSZGET) */
@@ -321,7 +321,7 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 		bdi = blk_get_backing_dev_info(bdev);
 		if (bdi == NULL)
 			return -ENOTTY;
-		bdi->ra_pages = (arg * 512) / PAGE_CACHE_SIZE;
+		bdi->ra_pages = arg >> (PAGE_CACHE_SHIFT - 9);
 		return 0;
 	case BLKBSZSET:
 		/* set the logical block size */
-- 
1.6.2.5

