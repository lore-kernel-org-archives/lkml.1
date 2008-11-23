Return-Path: <linux-kernel-owner+w=401wt.eu-S1758034AbYKWKTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758034AbYKWKTa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 05:19:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754092AbYKWKTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 05:19:21 -0500
Received: from mga14.intel.com ([143.182.124.37]:58376 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751579AbYKWKTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 05:19:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,653,1220252400"; 
   d="scan'208";a="81060992"
Date: Sun, 23 Nov 2008 18:19:07 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] don't take lock on changing ra_pages
Message-ID: <20081123101907.GA12218@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need to take queue_lock or kernel_lock when modifying
bdi->ra_pages. So remove them. Also remove out of date comment for
queue_max_sectors_store().

Signed-off-by: Wu Fengguang <wfg@linux.intel.com>
---
 block/blk-sysfs.c    |    7 +------
 block/compat_ioctl.c |    2 --
 block/ioctl.c        |    2 --
 3 files changed, 1 insertion(+), 10 deletions(-)

--- linux-2.6.orig/block/blk-sysfs.c
+++ linux-2.6/block/blk-sysfs.c
@@ -88,9 +88,7 @@ queue_ra_store(struct request_queue *q, 
 	unsigned long ra_kb;
 	ssize_t ret = queue_var_store(&ra_kb, page, count);
 
-	spin_lock_irq(q->queue_lock);
 	q->backing_dev_info.ra_pages = ra_kb >> (PAGE_CACHE_SHIFT - 10);
-	spin_unlock_irq(q->queue_lock);
 
 	return ret;
 }
@@ -117,10 +115,7 @@ queue_max_sectors_store(struct request_q
 
 	if (max_sectors_kb > max_hw_sectors_kb || max_sectors_kb < page_kb)
 		return -EINVAL;
-	/*
-	 * Take the queue lock to update the readahead and max_sectors
-	 * values synchronously:
-	 */
+
 	spin_lock_irq(q->queue_lock);
 	q->max_sectors = max_sectors_kb << 1;
 	spin_unlock_irq(q->queue_lock);
--- linux-2.6.orig/block/compat_ioctl.c
+++ linux-2.6/block/compat_ioctl.c
@@ -745,9 +745,7 @@ long compat_blkdev_ioctl(struct file *fi
 		bdi = blk_get_backing_dev_info(bdev);
 		if (bdi == NULL)
 			return -ENOTTY;
-		lock_kernel();
 		bdi->ra_pages = (arg * 512) / PAGE_CACHE_SIZE;
-		unlock_kernel();
 		return 0;
 	case BLKGETSIZE:
 		size = bdev->bd_inode->i_size;
--- linux-2.6.orig/block/ioctl.c
+++ linux-2.6/block/ioctl.c
@@ -323,9 +323,7 @@ int blkdev_ioctl(struct block_device *bd
 		bdi = blk_get_backing_dev_info(bdev);
 		if (bdi == NULL)
 			return -ENOTTY;
-		lock_kernel();
 		bdi->ra_pages = (arg * 512) / PAGE_CACHE_SIZE;
-		unlock_kernel();
 		return 0;
 	case BLKBSZSET:
 		/* set the logical block size */
