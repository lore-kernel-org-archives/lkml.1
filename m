Return-Path: <linux-kernel-owner+w=401wt.eu-S1758724AbZJGICT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758724AbZJGICT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758703AbZJGICM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:02:12 -0400
Received: from mga03.intel.com ([143.182.124.21]:28327 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757714AbZJGICD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:02:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,518,1249282800"; 
   d="scan'208";a="195971688"
Message-Id: <20091007074904.473079627@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 07 Oct 2009 15:38:44 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Li Shaohua" <shaohua.li@intel.com>,
       "Myklebust Trond" <Trond.Myklebust@netapp.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       Jan Kara <jack@suse.cz>, Nick Piggin <npiggin@suse.de>,
       <linux-fsdevel@vger.kernel.org>, Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 26/45] block: pass the non-rotational queue flag to backing_dev_info
References: <20091007073818.318088777@intel.com>
Content-Disposition: inline; filename=block-bdi-nonrot.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For now only pass the non-rotational bit to the queue's bdi.

To support hierarchical dm/md configurations, blk_set_rotational()
shall be expanded to make several iterations of the bdi list and call
its bdi->rotational_fn to pass the bit up.  But that would imply we
don's support mixed SSD/HD arrays.

CC: Jens Axboe <jens.axboe@oracle.com> 
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 block/blk-core.c             |   14 ++++++++++++++
 block/blk-sysfs.c            |    7 +------
 drivers/block/nbd.c          |    2 +-
 drivers/block/xen-blkfront.c |    1 +
 drivers/mmc/card/queue.c     |    2 +-
 drivers/scsi/sd.c            |    2 +-
 include/linux/backing-dev.h  |    8 ++++++++
 include/linux/blkdev.h       |    1 +
 8 files changed, 28 insertions(+), 9 deletions(-)

--- linux.orig/block/blk-sysfs.c	2009-10-06 23:37:44.000000000 +0800
+++ linux/block/blk-sysfs.c	2009-10-06 23:39:26.000000000 +0800
@@ -162,12 +162,7 @@ static ssize_t queue_nonrot_store(struct
 	unsigned long nm;
 	ssize_t ret = queue_var_store(&nm, page, count);
 
-	spin_lock_irq(q->queue_lock);
-	if (nm)
-		queue_flag_clear(QUEUE_FLAG_NONROT, q);
-	else
-		queue_flag_set(QUEUE_FLAG_NONROT, q);
-	spin_unlock_irq(q->queue_lock);
+	blk_set_rotational(q, nm);
 
 	return ret;
 }
--- linux.orig/include/linux/backing-dev.h	2009-10-06 23:38:44.000000000 +0800
+++ linux/include/linux/backing-dev.h	2009-10-06 23:39:26.000000000 +0800
@@ -29,6 +29,7 @@ enum bdi_state {
 	BDI_wb_alloc,		/* Default embedded wb allocated */
 	BDI_async_congested,	/* The async (write) queue is getting full */
 	BDI_sync_congested,	/* The sync queue is getting full */
+	BDI_non_rotational,	/* Underlying device is SSD or virtual */
 	BDI_registered,		/* bdi_register() was done */
 	BDI_unused,		/* Available bits start here */
 };
@@ -254,6 +255,8 @@ int bdi_set_max_ratio(struct backing_dev
 #define BDI_CAP_NO_ACCT_WB	0x00000080
 #define BDI_CAP_SWAP_BACKED	0x00000100
 
+#define BDI_CAP_NONROT		0x00000200
+
 #define BDI_CAP_VMFLAGS \
 	(BDI_CAP_READ_MAP | BDI_CAP_WRITE_MAP | BDI_CAP_EXEC_MAP)
 
@@ -291,6 +294,11 @@ static inline int can_submit_background_
        return !test_and_set_bit(WB_FLAG_BACKGROUND_WORK, &bdi->wb_mask);
 }
 
+static inline bool bdi_nonrot(struct backing_dev_info *bdi)
+{
+	return bdi->state & (1 << BDI_non_rotational);
+}
+
 static inline int bdi_congested(struct backing_dev_info *bdi, int bdi_bits)
 {
 	if (bdi->congested_fn)
--- linux.orig/block/blk-core.c	2009-10-06 23:37:44.000000000 +0800
+++ linux/block/blk-core.c	2009-10-06 23:39:26.000000000 +0800
@@ -2486,6 +2486,20 @@ free_and_out:
 }
 EXPORT_SYMBOL_GPL(blk_rq_prep_clone);
 
+void blk_set_rotational(struct request_queue *q, int rotational)
+{
+	spin_lock_irq(q->queue_lock);
+	if (rotational) {
+		queue_flag_clear(QUEUE_FLAG_NONROT, q);
+		clear_bit(BDI_non_rotational, &q->backing_dev_info.state);
+	} else {
+		queue_flag_set(QUEUE_FLAG_NONROT, q);
+		set_bit(BDI_non_rotational, &q->backing_dev_info.state);
+	}
+	spin_unlock_irq(q->queue_lock);
+}
+EXPORT_SYMBOL(blk_set_rotational);
+
 int kblockd_schedule_work(struct request_queue *q, struct work_struct *work)
 {
 	return queue_work(kblockd_workqueue, work);
--- linux.orig/include/linux/blkdev.h	2009-10-06 23:37:44.000000000 +0800
+++ linux/include/linux/blkdev.h	2009-10-06 23:39:26.000000000 +0800
@@ -666,6 +666,7 @@ static inline void blk_clear_queue_full(
 		queue_flag_clear(QUEUE_FLAG_ASYNCFULL, q);
 }
 
+void blk_set_rotational(struct request_queue *q, int rotational);
 
 /*
  * mergeable request must not have _NOMERGE or _BARRIER bit set, nor may
--- linux.orig/drivers/block/nbd.c	2009-10-06 23:37:44.000000000 +0800
+++ linux/drivers/block/nbd.c	2009-10-06 23:39:26.000000000 +0800
@@ -772,7 +772,7 @@ static int __init nbd_init(void)
 		/*
 		 * Tell the block layer that we are not a rotational device
 		 */
-		queue_flag_set_unlocked(QUEUE_FLAG_NONROT, disk->queue);
+		blk_set_rotational(disk->queue, 0);
 	}
 
 	if (register_blkdev(NBD_MAJOR, "nbd")) {
--- linux.orig/drivers/block/xen-blkfront.c	2009-10-06 23:37:44.000000000 +0800
+++ linux/drivers/block/xen-blkfront.c	2009-10-06 23:39:26.000000000 +0800
@@ -342,6 +342,7 @@ static int xlvbd_init_blk_queue(struct g
 		return -1;
 
 	queue_flag_set_unlocked(QUEUE_FLAG_VIRT, rq);
+	blk_set_rotational(rq, 0);
 
 	/* Hard sector size and max sectors impersonate the equiv. hardware. */
 	blk_queue_logical_block_size(rq, sector_size);
--- linux.orig/drivers/mmc/card/queue.c	2009-10-06 23:37:44.000000000 +0800
+++ linux/drivers/mmc/card/queue.c	2009-10-06 23:39:26.000000000 +0800
@@ -127,7 +127,7 @@ int mmc_init_queue(struct mmc_queue *mq,
 
 	blk_queue_prep_rq(mq->queue, mmc_prep_request);
 	blk_queue_ordered(mq->queue, QUEUE_ORDERED_DRAIN, NULL);
-	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, mq->queue);
+	blk_set_rotational(mq->queue, 0);
 
 #ifdef CONFIG_MMC_BLOCK_BOUNCE
 	if (host->max_hw_segs == 1) {
--- linux.orig/drivers/scsi/sd.c	2009-10-06 23:37:44.000000000 +0800
+++ linux/drivers/scsi/sd.c	2009-10-06 23:39:26.000000000 +0800
@@ -1898,7 +1898,7 @@ static void sd_read_block_characteristic
 	rot = get_unaligned_be16(&buffer[4]);
 
 	if (rot == 1)
-		queue_flag_set_unlocked(QUEUE_FLAG_NONROT, sdkp->disk->queue);
+		blk_set_rotational(sdkp->disk->queue, 0);
 
 	kfree(buffer);
 }


