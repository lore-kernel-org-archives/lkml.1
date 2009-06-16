Return-Path: <linux-kernel-owner+w=401wt.eu-S1756938AbZFPHSa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756938AbZFPHSa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 03:18:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbZFPHSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 03:18:22 -0400
Received: from brick.kernel.dk ([93.163.65.50]:36488 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506AbZFPHSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 03:18:22 -0400
Date: Tue, 16 Jun 2009 09:18:23 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] block updates for 2.6.31-rc1
Message-ID: <20090616071823.GL11363@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Pushing this out before -rc1, since the queue limits block helper will
be required by a DM push soon.

Nothing really major in here, just small fixes or cleanups. The 3
patches from me are preparatory patches from the per-bdi writeback
series.

Please pull.

  git://git.kernel.dk/linux-2.6-block.git for-linus

Gui Jianfeng (1):
      cfq: cleanup for last_end_request in cfq_data

Jeff Moyer (1):
      cfq: remove extraneous '\n' in blktrace output

Jens Axboe (3):
      block: don't overwrite bdi->state after bdi_init() has been run
      btrfs: properly register fs backing device
      ubifs: register backing_dev_info

Martin K. Petersen (1):
      block: Introduce helper to reset queue limits to default values

unsik Kim (1):
      mg_disk: seperate mg_disk.h again

 block/blk-core.c        |    5 +++++
 block/blk-settings.c    |   37 +++++++++++++++++++++++++++----------
 block/cfq-iosched.c     |    7 +------
 drivers/block/mg_disk.c |   28 +---------------------------
 fs/btrfs/disk-io.c      |   26 +++++++++++++++++++++-----
 fs/ubifs/super.c        |    3 +++
 include/linux/blkdev.h  |    1 +
 include/linux/mg_disk.h |   45 +++++++++++++++++++++++++++++++++++++++++++++
 8 files changed, 104 insertions(+), 48 deletions(-)
 create mode 100644 include/linux/mg_disk.h

diff --git a/block/blk-core.c b/block/blk-core.c
index f6452f6..94d88fa 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -498,6 +498,11 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 
 	q->backing_dev_info.unplug_io_fn = blk_backing_dev_unplug;
 	q->backing_dev_info.unplug_io_data = q;
+	q->backing_dev_info.ra_pages =
+			(VM_MAX_READAHEAD * 1024) / PAGE_CACHE_SIZE;
+	q->backing_dev_info.state = 0;
+	q->backing_dev_info.capabilities = BDI_CAP_MAP_COPY;
+
 	err = bdi_init(&q->backing_dev_info);
 	if (err) {
 		kmem_cache_free(blk_requestq_cachep, q);
diff --git a/block/blk-settings.c b/block/blk-settings.c
index d71cedc..7541ea4 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -96,6 +96,31 @@ void blk_queue_lld_busy(struct request_queue *q, lld_busy_fn *fn)
 EXPORT_SYMBOL_GPL(blk_queue_lld_busy);
 
 /**
+ * blk_set_default_limits - reset limits to default values
+ * @limits:  the queue_limits structure to reset
+ *
+ * Description:
+ *   Returns a queue_limit struct to its default state.  Can be used by
+ *   stacking drivers like DM that stage table swaps and reuse an
+ *   existing device queue.
+ */
+void blk_set_default_limits(struct queue_limits *lim)
+{
+	lim->max_phys_segments = MAX_PHYS_SEGMENTS;
+	lim->max_hw_segments = MAX_HW_SEGMENTS;
+	lim->seg_boundary_mask = BLK_SEG_BOUNDARY_MASK;
+	lim->max_segment_size = MAX_SEGMENT_SIZE;
+	lim->max_sectors = lim->max_hw_sectors = SAFE_MAX_SECTORS;
+	lim->logical_block_size = lim->physical_block_size = lim->io_min = 512;
+	lim->bounce_pfn = BLK_BOUNCE_ANY;
+	lim->alignment_offset = 0;
+	lim->io_opt = 0;
+	lim->misaligned = 0;
+	lim->no_cluster = 0;
+}
+EXPORT_SYMBOL(blk_set_default_limits);
+
+/**
  * blk_queue_make_request - define an alternate make_request function for a device
  * @q:  the request queue for the device to be affected
  * @mfn: the alternate make_request function
@@ -123,18 +148,8 @@ void blk_queue_make_request(struct request_queue *q, make_request_fn *mfn)
 	 * set defaults
 	 */
 	q->nr_requests = BLKDEV_MAX_RQ;
-	blk_queue_max_phys_segments(q, MAX_PHYS_SEGMENTS);
-	blk_queue_max_hw_segments(q, MAX_HW_SEGMENTS);
-	blk_queue_segment_boundary(q, BLK_SEG_BOUNDARY_MASK);
-	blk_queue_max_segment_size(q, MAX_SEGMENT_SIZE);
 
 	q->make_request_fn = mfn;
-	q->backing_dev_info.ra_pages =
-			(VM_MAX_READAHEAD * 1024) / PAGE_CACHE_SIZE;
-	q->backing_dev_info.state = 0;
-	q->backing_dev_info.capabilities = BDI_CAP_MAP_COPY;
-	blk_queue_max_sectors(q, SAFE_MAX_SECTORS);
-	blk_queue_logical_block_size(q, 512);
 	blk_queue_dma_alignment(q, 511);
 	blk_queue_congestion_threshold(q);
 	q->nr_batching = BLK_BATCH_REQ;
@@ -147,6 +162,8 @@ void blk_queue_make_request(struct request_queue *q, make_request_fn *mfn)
 	q->unplug_timer.function = blk_unplug_timeout;
 	q->unplug_timer.data = (unsigned long)q;
 
+	blk_set_default_limits(&q->limits);
+
 	/*
 	 * by default assume old behaviour and bounce for any highmem page
 	 */
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index ef2f72d..833ec18 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -122,7 +122,6 @@ struct cfq_data {
 	struct cfq_queue *async_idle_cfqq;
 
 	sector_t last_position;
-	unsigned long last_end_request;
 
 	/*
 	 * tunables, see top of file
@@ -1253,7 +1252,7 @@ static int cfq_forced_dispatch(struct cfq_data *cfqd)
 
 	BUG_ON(cfqd->busy_queues);
 
-	cfq_log(cfqd, "forced_dispatch=%d\n", dispatched);
+	cfq_log(cfqd, "forced_dispatch=%d", dispatched);
 	return dispatched;
 }
 
@@ -2164,9 +2163,6 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
 	if (cfq_cfqq_sync(cfqq))
 		cfqd->sync_flight--;
 
-	if (!cfq_class_idle(cfqq))
-		cfqd->last_end_request = now;
-
 	if (sync)
 		RQ_CIC(rq)->last_end_request = now;
 
@@ -2479,7 +2475,6 @@ static void *cfq_init_queue(struct request_queue *q)
 
 	INIT_WORK(&cfqd->unplug_work, cfq_kick_queue);
 
-	cfqd->last_end_request = jiffies;
 	cfqd->cfq_quantum = cfq_quantum;
 	cfqd->cfq_fifo_expire[0] = cfq_fifo_expire[0];
 	cfqd->cfq_fifo_expire[1] = cfq_fifo_expire[1];
diff --git a/drivers/block/mg_disk.c b/drivers/block/mg_disk.c
index 60de5a0..f703f54 100644
--- a/drivers/block/mg_disk.c
+++ b/drivers/block/mg_disk.c
@@ -22,13 +22,12 @@
 #include <linux/delay.h>
 #include <linux/platform_device.h>
 #include <linux/gpio.h>
+#include <linux/mg_disk.h>
 
 #define MG_RES_SEC (CONFIG_MG_DISK_RES << 1)
 
 /* name for block device */
 #define MG_DISK_NAME "mgd"
-/* name for platform device */
-#define MG_DEV_NAME "mg_disk"
 
 #define MG_DISK_MAJ 0
 #define MG_DISK_MAX_PART 16
@@ -103,33 +102,8 @@
 #define MG_TMAX_SWRST_TO_RDY	500
 #define MG_TMAX_RSTOUT		3000
 
-/* device attribution */
-/* use mflash as boot device */
-#define MG_BOOT_DEV		(1 << 0)
-/* use mflash as storage device */
-#define MG_STORAGE_DEV		(1 << 1)
-/* same as MG_STORAGE_DEV, but bootloader already done reset sequence */
-#define MG_STORAGE_DEV_SKIP_RST	(1 << 2)
-
 #define MG_DEV_MASK (MG_BOOT_DEV | MG_STORAGE_DEV | MG_STORAGE_DEV_SKIP_RST)
 
-/* names of GPIO resource */
-#define MG_RST_PIN	"mg_rst"
-/* except MG_BOOT_DEV, reset-out pin should be assigned */
-#define MG_RSTOUT_PIN	"mg_rstout"
-
-/* private driver data */
-struct mg_drv_data {
-	/* disk resource */
-	u32 use_polling;
-
-	/* device attribution */
-	u32 dev_attr;
-
-	/* internally used */
-	struct mg_host *host;
-};
-
 /* main structure for mflash driver */
 struct mg_host {
 	struct device *dev;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 0d50d49..d28d29c 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -42,6 +42,8 @@
 static struct extent_io_ops btree_extent_io_ops;
 static void end_workqueue_fn(struct btrfs_work *work);
 
+static atomic_t btrfs_bdi_num = ATOMIC_INIT(0);
+
 /*
  * end_io_wq structs are used to do processing in task context when an IO is
  * complete.  This is used during reads to verify checksums, and it is used
@@ -1342,12 +1344,25 @@ static void btrfs_unplug_io_fn(struct backing_dev_info *bdi, struct page *page)
 	free_extent_map(em);
 }
 
+/*
+ * If this fails, caller must call bdi_destroy() to get rid of the
+ * bdi again.
+ */
 static int setup_bdi(struct btrfs_fs_info *info, struct backing_dev_info *bdi)
 {
-	bdi_init(bdi);
+	int err;
+
+	bdi->capabilities = BDI_CAP_MAP_COPY;
+	err = bdi_init(bdi);
+	if (err)
+		return err;
+
+	err = bdi_register(bdi, NULL, "btrfs-%d",
+				atomic_inc_return(&btrfs_bdi_num));
+	if (err)
+		return err;
+
 	bdi->ra_pages	= default_backing_dev_info.ra_pages;
-	bdi->state		= 0;
-	bdi->capabilities	= default_backing_dev_info.capabilities;
 	bdi->unplug_io_fn	= btrfs_unplug_io_fn;
 	bdi->unplug_io_data	= info;
 	bdi->congested_fn	= btrfs_congested_fn;
@@ -1569,7 +1584,8 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	fs_info->sb = sb;
 	fs_info->max_extent = (u64)-1;
 	fs_info->max_inline = 8192 * 1024;
-	setup_bdi(fs_info, &fs_info->bdi);
+	if (setup_bdi(fs_info, &fs_info->bdi))
+		goto fail_bdi;
 	fs_info->btree_inode = new_inode(sb);
 	fs_info->btree_inode->i_ino = 1;
 	fs_info->btree_inode->i_nlink = 1;
@@ -1946,8 +1962,8 @@ fail_iput:
 
 	btrfs_close_devices(fs_info->fs_devices);
 	btrfs_mapping_tree_free(&fs_info->mapping_tree);
+fail_bdi:
 	bdi_destroy(&fs_info->bdi);
-
 fail:
 	kfree(extent_root);
 	kfree(tree_root);
diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index 3589eab..3260b73 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -1937,6 +1937,9 @@ static int ubifs_fill_super(struct super_block *sb, void *data, int silent)
 	err  = bdi_init(&c->bdi);
 	if (err)
 		goto out_close;
+	err = bdi_register(&c->bdi, NULL, "ubifs");
+	if (err)
+		goto out_bdi;
 
 	err = ubifs_parse_options(c, data, 0);
 	if (err)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 0b1a6ca..8963d91 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -926,6 +926,7 @@ extern void blk_queue_alignment_offset(struct request_queue *q,
 				       unsigned int alignment);
 extern void blk_queue_io_min(struct request_queue *q, unsigned int min);
 extern void blk_queue_io_opt(struct request_queue *q, unsigned int opt);
+extern void blk_set_default_limits(struct queue_limits *lim);
 extern int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 			    sector_t offset);
 extern void disk_stack_limits(struct gendisk *disk, struct block_device *bdev,
diff --git a/include/linux/mg_disk.h b/include/linux/mg_disk.h
new file mode 100644
index 0000000..e11f4d9
--- /dev/null
+++ b/include/linux/mg_disk.h
@@ -0,0 +1,45 @@
+/*
+ *  include/linux/mg_disk.c
+ *
+ *  Private data for mflash platform driver
+ *
+ * (c) 2008 mGine Co.,LTD
+ * (c) 2008 unsik Kim <donari75@gmail.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+
+#ifndef __MG_DISK_H__
+#define __MG_DISK_H__
+
+/* name for platform device */
+#define MG_DEV_NAME "mg_disk"
+
+/* names of GPIO resource */
+#define MG_RST_PIN	"mg_rst"
+/* except MG_BOOT_DEV, reset-out pin should be assigned */
+#define MG_RSTOUT_PIN	"mg_rstout"
+
+/* device attribution */
+/* use mflash as boot device */
+#define MG_BOOT_DEV		(1 << 0)
+/* use mflash as storage device */
+#define MG_STORAGE_DEV		(1 << 1)
+/* same as MG_STORAGE_DEV, but bootloader already done reset sequence */
+#define MG_STORAGE_DEV_SKIP_RST	(1 << 2)
+
+/* private driver data */
+struct mg_drv_data {
+	/* disk resource */
+	u32 use_polling;
+
+	/* device attribution */
+	u32 dev_attr;
+
+	/* internally used */
+	void *host;
+};
+
+#endif

-- 
Jens Axboe

