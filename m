Return-Path: <linux-kernel-owner+w=401wt.eu-S1760199AbZE0F1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760199AbZE0F1Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 01:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759819AbZE0F1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 01:27:12 -0400
Received: from mga10.intel.com ([192.55.52.92]:65305 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757348AbZE0F1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 01:27:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,257,1241420400"; 
   d="scan'208";a="693860448"
Subject: Re: [PATCH 0/12] Per-bdi writeback flusher threads v7
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, richard@rsk.demon.co.uk
In-Reply-To: <1243330430-9964-1-git-send-email-jens.axboe@oracle.com>
References: <1243330430-9964-1-git-send-email-jens.axboe@oracle.com>
Content-Type: multipart/mixed; boundary="=-bsbuMAnxEHh8HvfgOLjE"
Date: Wed, 27 May 2009 13:27:15 +0800
Message-Id: <1243402035.2560.127.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-bsbuMAnxEHh8HvfgOLjE
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Tue, 2009-05-26 at 11:33 +0200, Jens Axboe wrote:
> Hi,
> 
> Here's the 7th version of the writeback patches. Changes since
> v5/v6:
> 
> - Move the sync_supers() to the global bdi_forker_task() thread, so we
>   don't writeback the supers from all the bdi kupdated() tasks.
> - Make bdi_start_writeback() and bdi_writeback_all() be sync when called
>   with WB_SYNC_ALL only.
> - Shuffle some more things around to make a cleaner series. The sync vs
>   async nature of bdi_writeback_all() and bdi_start_writeback() isn't
>   consistent through the series, but otherwise things should be sane.
> 
> I'd appreciate if Richard and Yanmin could re-run testing with this,
> just to make sure that things are sane. For ease of patching, I've
> put the full diff here:
> 
>   http://kernel.dk/writeback-v7.patch
I ported it to 2.6.30-rc6 with some change in file mm/page-write.c, so I 
could compare with old data.

See the attachment.

The new testing hits the hang issue again. It seems there is still a race.

INFO: task sync:30013 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
sync          D ffffc20000011300  4736 30013  28019
 ffffffff8093e350 0000000000000086 0000000000000000 0000000000000000
 0000000000021220 0000000000004000 0000000000011300 000000000000c868
 ffff880000016c48 ffffe20002934b30 ffff8800720b3780 ffff8800720b3b08
Call Trace:
 [<ffffffff802c31d0>] ? bdi_sched_wait+0x0/0xd
 [<ffffffff8071e56f>] ? schedule+0x9/0x1e
 [<ffffffff802c31d9>] ? bdi_sched_wait+0x9/0xd
 [<ffffffff8071eb36>] ? __wait_on_bit+0x41/0x71
 [<ffffffff802c31d0>] ? bdi_sched_wait+0x0/0xd
 [<ffffffff8071ebd1>] ? out_of_line_wait_on_bit+0x6b/0x77
 [<ffffffff8024cc0c>] ? wake_bit_function+0x0/0x23
 [<ffffffff8022cfa1>] ? __wake_up+0x30/0x44
 [<ffffffff802c2e22>] ? bdi_writeback_all+0x20b/0x24c
 [<ffffffff802800ce>] ? pagevec_lookup_tag+0x1a/0x21
 [<ffffffff80279248>] ? wait_on_page_writeback_range+0xce/0x11b
 [<ffffffff802c2ff3>] ? generic_sync_sb_inodes+0x36/0xe1
 [<ffffffff802c3121>] ? sync_inodes_sb+0x83/0x88
 [<ffffffff802c316c>] ? __sync_inodes+0x46/0x8f
 [<ffffffff802c5d10>] ? do_sync+0x36/0x5a
 [<ffffffff802c5d56>] ? sys_sync+0xe/0x14
 [<ffffffff8020ba2b>] ? system_call_fastpath+0x16/0x1b



--=-bsbuMAnxEHh8HvfgOLjE
Content-Disposition: attachment; filename=jens_bdi_fluser_v7_2.6.30-rc6.patch
Content-Type: text/x-patch; name=jens_bdi_fluser_v7_2.6.30-rc6.patch; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

diff -Nraup linux-2.6.30-rc6/block/blk-core.c linux-2.6.30-rc6_bdiflusherv7/block/blk-core.c
--- linux-2.6.30-rc6/block/blk-core.c	2009-05-19 11:00:45.000000000 +0800
+++ linux-2.6.30-rc6_bdiflusherv7/block/blk-core.c	2009-05-27 08:59:27.000000000 +0800
@@ -517,6 +517,7 @@ struct request_queue *blk_alloc_queue_no
 
 	q->backing_dev_info.unplug_io_fn = blk_backing_dev_unplug;
 	q->backing_dev_info.unplug_io_data = q;
+	q->backing_dev_info.name = "block";
 	err = bdi_init(&q->backing_dev_info);
 	if (err) {
 		kmem_cache_free(blk_requestq_cachep, q);
diff -Nraup linux-2.6.30-rc6/drivers/block/aoe/aoeblk.c linux-2.6.30-rc6_bdiflusherv7/drivers/block/aoe/aoeblk.c
--- linux-2.6.30-rc6/drivers/block/aoe/aoeblk.c	2009-05-19 11:00:27.000000000 +0800
+++ linux-2.6.30-rc6_bdiflusherv7/drivers/block/aoe/aoeblk.c	2009-05-27 08:59:27.000000000 +0800
@@ -265,6 +265,7 @@ aoeblk_gdalloc(void *vp)
 	}
 
 	blk_queue_make_request(&d->blkq, aoeblk_make_request);
+	d->blkq.backing_dev_info.name = "aoe";
 	if (bdi_init(&d->blkq.backing_dev_info))
 		goto err_mempool;
 	spin_lock_irqsave(&d->lock, flags);
diff -Nraup linux-2.6.30-rc6/drivers/char/mem.c linux-2.6.30-rc6_bdiflusherv7/drivers/char/mem.c
--- linux-2.6.30-rc6/drivers/char/mem.c	2009-05-19 11:00:46.000000000 +0800
+++ linux-2.6.30-rc6_bdiflusherv7/drivers/char/mem.c	2009-05-27 08:59:27.000000000 +0800
@@ -820,6 +820,7 @@ static const struct file_operations zero
  * - permits private mappings, "copies" are taken of the source of zeros
  */
 static struct backing_dev_info zero_bdi = {
+	.name		= "char/mem",
 	.capabilities	= BDI_CAP_MAP_COPY,
 };
 
diff -Nraup linux-2.6.30-rc6/fs/btrfs/disk-io.c linux-2.6.30-rc6_bdiflusherv7/fs/btrfs/disk-io.c
--- linux-2.6.30-rc6/fs/btrfs/disk-io.c	2009-05-19 11:00:56.000000000 +0800
+++ linux-2.6.30-rc6_bdiflusherv7/fs/btrfs/disk-io.c	2009-05-27 08:59:27.000000000 +0800
@@ -1345,12 +1345,25 @@ static void btrfs_unplug_io_fn(struct ba
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
+	bdi->name = "btrfs";
+	bdi->capabilities = BDI_CAP_MAP_COPY;
+	err = bdi_init(bdi);
+	if (err)
+		return err;
+
+	err = bdi_register(bdi, NULL, "btrfs");
+	if (err)
+		return err;
+
 	bdi->ra_pages	= default_backing_dev_info.ra_pages;
-	bdi->state		= 0;
-	bdi->capabilities	= default_backing_dev_info.capabilities;
 	bdi->unplug_io_fn	= btrfs_unplug_io_fn;
 	bdi->unplug_io_data	= info;
 	bdi->congested_fn	= btrfs_congested_fn;
@@ -1574,7 +1587,8 @@ struct btrfs_root *open_ctree(struct sup
 	fs_info->sb = sb;
 	fs_info->max_extent = (u64)-1;
 	fs_info->max_inline = 8192 * 1024;
-	setup_bdi(fs_info, &fs_info->bdi);
+	if (setup_bdi(fs_info, &fs_info->bdi))
+		goto fail_bdi;
 	fs_info->btree_inode = new_inode(sb);
 	fs_info->btree_inode->i_ino = 1;
 	fs_info->btree_inode->i_nlink = 1;
@@ -1931,8 +1945,8 @@ fail_iput:
 
 	btrfs_close_devices(fs_info->fs_devices);
 	btrfs_mapping_tree_free(&fs_info->mapping_tree);
+fail_bdi:
 	bdi_destroy(&fs_info->bdi);
-
 fail:
 	kfree(extent_root);
 	kfree(tree_root);
diff -Nraup linux-2.6.30-rc6/fs/buffer.c linux-2.6.30-rc6_bdiflusherv7/fs/buffer.c
--- linux-2.6.30-rc6/fs/buffer.c	2009-05-19 11:00:56.000000000 +0800
+++ linux-2.6.30-rc6_bdiflusherv7/fs/buffer.c	2009-05-27 08:59:27.000000000 +0800
@@ -281,7 +281,7 @@ static void free_more_memory(void)
 	struct zone *zone;
 	int nid;
 
-	wakeup_pdflush(1024);
+	wakeup_flusher_threads(1024);
 	yield();
 
 	for_each_online_node(nid) {
diff -Nraup linux-2.6.30-rc6/fs/char_dev.c linux-2.6.30-rc6_bdiflusherv7/fs/char_dev.c
--- linux-2.6.30-rc6/fs/char_dev.c	2009-05-19 11:00:27.000000000 +0800
+++ linux-2.6.30-rc6_bdiflusherv7/fs/char_dev.c	2009-05-27 08:59:27.000000000 +0800
@@ -32,6 +32,7 @@
  * - no readahead or I/O queue unplugging required
  */
 struct backing_dev_info directly_mappable_cdev_bdi = {
+	.name = "char",
 	.capabilities	= (
 #ifdef CONFIG_MMU
 		/* permit private copies of the data to be taken */
diff -Nraup linux-2.6.30-rc6/fs/configfs/inode.c linux-2.6.30-rc6_bdiflusherv7/fs/configfs/inode.c
--- linux-2.6.30-rc6/fs/configfs/inode.c	2009-05-19 11:00:27.000000000 +0800
+++ linux-2.6.30-rc6_bdiflusherv7/fs/configfs/inode.c	2009-05-27 08:59:27.000000000 +0800
@@ -46,6 +46,7 @@ static const struct address_space_operat
 };
 
 static struct backing_dev_info configfs_backing_dev_info = {
+	.name		= "configfs",
 	.ra_pages	= 0,	/* No readahead */
 	.capabilities	= BDI_CAP_NO_ACCT_AND_WRITEBACK,
 };
diff -Nraup linux-2.6.30-rc6/fs/fs-writeback.c linux-2.6.30-rc6_bdiflusherv7/fs/fs-writeback.c
--- linux-2.6.30-rc6/fs/fs-writeback.c	2009-05-19 11:00:57.000000000 +0800
+++ linux-2.6.30-rc6_bdiflusherv7/fs/fs-writeback.c	2009-05-27 08:59:27.000000000 +0800
@@ -19,49 +19,563 @@
 #include <linux/sched.h>
 #include <linux/fs.h>
 #include <linux/mm.h>
+#include <linux/kthread.h>
+#include <linux/freezer.h>
 #include <linux/writeback.h>
 #include <linux/blkdev.h>
 #include <linux/backing-dev.h>
 #include <linux/buffer_head.h>
 #include "internal.h"
 
+#define inode_to_bdi(inode)	((inode)->i_mapping->backing_dev_info)
 
-/**
- * writeback_acquire - attempt to get exclusive writeback access to a device
- * @bdi: the device's backing_dev_info structure
- *
- * It is a waste of resources to have more than one pdflush thread blocked on
- * a single request queue.  Exclusion at the request_queue level is obtained
- * via a flag in the request_queue's backing_dev_info.state.
- *
- * Non-request_queue-backed address_spaces will share default_backing_dev_info,
- * unless they implement their own.  Which is somewhat inefficient, as this
- * may prevent concurrent writeback against multiple devices.
+/*
+ * We don't actually have pdflush, but this one is exported though /proc...
+ */
+int nr_pdflush_threads;
+
+static void generic_sync_wb_inodes(struct bdi_writeback *wb,
+				   struct super_block *sb,
+				   struct writeback_control *wbc);
+
+/*
+ * Work items for the bdi_writeback threads
  */
-static int writeback_acquire(struct backing_dev_info *bdi)
+struct bdi_work {
+	struct list_head list;
+	struct list_head wait_list;
+	struct rcu_head rcu_head;
+
+	unsigned long seen;
+	atomic_t pending;
+
+	unsigned long sb_data;
+	unsigned long nr_pages;
+	enum writeback_sync_modes sync_mode;
+
+	unsigned long state;
+};
+
+static struct super_block *bdi_work_sb(struct bdi_work *work)
+{
+	return (struct super_block *) (work->sb_data & ~1UL);
+}
+
+static inline bool bdi_work_on_stack(struct bdi_work *work)
+{
+	return work->sb_data & 1UL;
+}
+
+static inline void bdi_work_init(struct bdi_work *work, struct super_block *sb,
+				 unsigned long nr_pages,
+				 enum writeback_sync_modes sync_mode)
+{
+	INIT_RCU_HEAD(&work->rcu_head);
+	work->sb_data = (unsigned long) sb;
+	work->nr_pages = nr_pages;
+	work->sync_mode = sync_mode;
+	work->state = 1;
+
+	/*
+	 * state must not be reordered around the insert
+	 */
+	smp_mb();
+}
+
+static inline void bdi_work_init_on_stack(struct bdi_work *work,
+					  struct super_block *sb,
+					  unsigned long nr_pages,
+					  enum writeback_sync_modes sync_mode)
 {
-	return !test_and_set_bit(BDI_pdflush, &bdi->state);
+	bdi_work_init(work, sb, nr_pages, sync_mode);
+	work->sb_data |= 1UL;
 }
 
 /**
  * writeback_in_progress - determine whether there is writeback in progress
  * @bdi: the device's backing_dev_info structure.
  *
- * Determine whether there is writeback in progress against a backing device.
+ * Determine whether there is writeback waiting to be handled against a
+ * backing device.
  */
 int writeback_in_progress(struct backing_dev_info *bdi)
 {
-	return test_bit(BDI_pdflush, &bdi->state);
+	return !list_empty(&bdi->work_list);
 }
 
-/**
- * writeback_release - relinquish exclusive writeback access against a device.
- * @bdi: the device's backing_dev_info structure
+static void bdi_work_clear(struct bdi_work *work)
+{
+	clear_bit(0, &work->state);
+	smp_mb__after_clear_bit();
+	wake_up_bit(&work->state, 0);
+}
+
+static void bdi_work_free(struct rcu_head *head)
+{
+	struct bdi_work *work = container_of(head, struct bdi_work, rcu_head);
+
+	if (!bdi_work_on_stack(work))
+		kfree(work);
+	else
+		bdi_work_clear(work);
+}
+
+static void wb_work_complete(struct bdi_work *work)
+{
+	if (!bdi_work_on_stack(work)) {
+		bdi_work_clear(work);
+
+		if (work->sync_mode == WB_SYNC_NONE)
+			call_rcu(&work->rcu_head, bdi_work_free);
+	} else
+		call_rcu(&work->rcu_head, bdi_work_free);
+}
+
+static void wb_clear_pending(struct bdi_writeback *wb, struct bdi_work *work)
+{
+	/*
+	 * The caller has retrieved the work arguments from this work,
+	 * drop our reference. If this is the last ref, delete and free it
+	 */
+	if (atomic_dec_and_test(&work->pending)) {
+		struct backing_dev_info *bdi = wb->bdi;
+
+		spin_lock(&bdi->wb_lock);
+		list_del_rcu(&work->list);
+		spin_unlock(&bdi->wb_lock);
+
+		wb_work_complete(work);
+	}
+}
+
+static void wb_start_writeback(struct bdi_writeback *wb, struct bdi_work *work)
+{
+	/*
+	 * If we failed allocating the bdi work item, wake up the wb thread
+	 * always. As a safety precaution, it'll flush out everything
+	 */
+	if (!wb_has_dirty_io(wb) && work)
+		wb_clear_pending(wb, work);
+	else
+		wake_up(&wb->wait);
+}
+
+static void bdi_queue_work(struct backing_dev_info *bdi, struct bdi_work *work)
+{
+	if (work) {
+		work->seen = bdi->wb_mask;
+		atomic_set(&work->pending, bdi->wb_cnt);
+
+		/*
+		 * Make sure stores are seen before it appears on the list
+		 */
+		smp_mb();
+
+		spin_lock(&bdi->wb_lock);
+		list_add_tail_rcu(&work->list, &bdi->work_list);
+		spin_unlock(&bdi->wb_lock);
+	}
+}
+
+static void bdi_sched_work(struct backing_dev_info *bdi, struct bdi_work *work)
+{
+	if (!bdi_wblist_needs_lock(bdi))
+		wb_start_writeback(&bdi->wb, work);
+	else {
+		struct bdi_writeback *wb;
+		int idx;
+
+		idx = srcu_read_lock(&bdi->srcu);
+
+		list_for_each_entry_rcu(wb, &bdi->wb_list, list)
+			wb_start_writeback(wb, work);
+
+		srcu_read_unlock(&bdi->srcu, idx);
+	}
+}
+
+static void __bdi_start_work(struct backing_dev_info *bdi,
+			     struct bdi_work *work)
+{
+	/*
+	 * If the default thread isn't there, make sure we add it. When
+	 * it gets created and wakes up, we'll run this work.
+	 */
+	if (unlikely(list_empty_careful(&bdi->wb_list)))
+		bdi_add_default_flusher_task(bdi);
+	else
+		bdi_sched_work(bdi, work);
+}
+
+static void bdi_start_work(struct backing_dev_info *bdi, struct bdi_work *work)
+{
+	/*
+	 * If the default thread isn't there, make sure we add it. When
+	 * it gets created and wakes up, we'll run this work.
+	 */
+	if (unlikely(list_empty_careful(&bdi->wb_list))) {
+		mutex_lock(&bdi_lock);
+		bdi_add_default_flusher_task(bdi);
+		mutex_unlock(&bdi_lock);
+	} else
+		bdi_sched_work(bdi, work);
+}
+
+/*
+ * Used for on-stack allocated work items. The caller needs to wait until
+ * the wb threads have acked the work before it's safe to continue.
+ */
+static void bdi_wait_on_work_clear(struct bdi_work *work)
+{
+	wait_on_bit(&work->state, 0, bdi_sched_wait, TASK_UNINTERRUPTIBLE);
+}
+
+static struct bdi_work *bdi_alloc_work(struct super_block *sb, long nr_pages,
+				       enum writeback_sync_modes sync_mode)
+{
+	struct bdi_work *work;
+
+	work = kmalloc(sizeof(*work), GFP_ATOMIC);
+	if (work)
+		bdi_work_init(work, sb, nr_pages, sync_mode);
+
+	return work;
+}
+
+void bdi_start_writeback(struct backing_dev_info *bdi, struct super_block *sb,
+			 long nr_pages, enum writeback_sync_modes sync_mode)
+{
+	const bool must_wait = sync_mode == WB_SYNC_ALL;
+	struct bdi_work work_stack, *work = NULL;
+
+	if (!must_wait)
+		work = bdi_alloc_work(sb, nr_pages, sync_mode);
+
+	if (!work) {
+		work = &work_stack;
+		bdi_work_init_on_stack(work, sb, nr_pages, sync_mode);
+	}
+
+	bdi_queue_work(bdi, work);
+	bdi_start_work(bdi, work);
+
+	/*
+	 * If the sync mode is WB_SYNC_ALL, block waiting for the work to
+	 * complete. If not, we only need to wait for the work to be started,
+	 * if we allocated it on-stack. We use the same mechanism, if the
+	 * wait bit is set in the bdi_work struct, then threads will not
+	 * clear pending until after they are done.
+	 *
+	 * Note that work == &work_stack if must_wait is true, but that
+	 * is implementation detail and we make it explicit here for
+	 * ease of reading.
+	 */
+	if (work == &work_stack || must_wait) {
+		bdi_wait_on_work_clear(work);
+		if (must_wait)
+			call_rcu(&work->rcu_head, bdi_work_free);
+	}
+}
+
+/*
+ * The maximum number of pages to writeout in a single bdi flush/kupdate
+ * operation.  We do this so we don't hold I_SYNC against an inode for
+ * enormous amounts of time, which would block a userspace task which has
+ * been forced to throttle against that inode.  Also, the code reevaluates
+ * the dirty each time it has written this many pages.
+ */
+#define MAX_WRITEBACK_PAGES     1024
+
+/*
+ * Periodic writeback of "old" data.
+ *
+ * Define "old": the first time one of an inode's pages is dirtied, we mark the
+ * dirtying-time in the inode's address_space.  So this periodic writeback code
+ * just walks the superblock inode list, writing back any inodes which are
+ * older than a specific point in time.
+ *
+ * Try to run once per dirty_writeback_interval.  But if a writeback event
+ * takes longer than a dirty_writeback_interval interval, then leave a
+ * one-second gap.
+ *
+ * older_than_this takes precedence over nr_to_write.  So we'll only write back
+ * all dirty pages if they are all attached to "old" mappings.
+ */
+static long wb_kupdated(struct bdi_writeback *wb)
+{
+	unsigned long oldest_jif;
+	long nr_to_write, wrote = 0;
+	struct writeback_control wbc = {
+		.bdi			= wb->bdi,
+		.sync_mode		= WB_SYNC_NONE,
+		.older_than_this	= &oldest_jif,
+		.nr_to_write		= 0,
+		.for_kupdate		= 1,
+		.range_cyclic		= 1,
+	};
+
+	oldest_jif = jiffies - msecs_to_jiffies(dirty_expire_interval * 10);
+
+	nr_to_write = global_page_state(NR_FILE_DIRTY) +
+			global_page_state(NR_UNSTABLE_NFS) +
+			(inodes_stat.nr_inodes - inodes_stat.nr_unused);
+
+	while (nr_to_write > 0) {
+		wbc.more_io = 0;
+		wbc.encountered_congestion = 0;
+		wbc.nr_to_write = MAX_WRITEBACK_PAGES;
+		generic_sync_wb_inodes(wb, NULL, &wbc);
+		wrote += MAX_WRITEBACK_PAGES - wbc.nr_to_write;
+		if (wbc.nr_to_write > 0)
+			break;	/* All the old data is written */
+		nr_to_write -= MAX_WRITEBACK_PAGES;
+	}
+
+	return wrote;
+}
+
+static inline bool over_bground_thresh(void)
+{
+	unsigned long background_thresh, dirty_thresh;
+
+	get_dirty_limits(&background_thresh, &dirty_thresh, NULL, NULL);
+
+	return (global_page_state(NR_FILE_DIRTY) +
+		global_page_state(NR_UNSTABLE_NFS) >= background_thresh);
+}
+
+static long __wb_writeback(struct bdi_writeback *wb, long nr_pages,
+			   struct super_block *sb,
+			   enum writeback_sync_modes sync_mode)
+{
+	struct writeback_control wbc = {
+		.bdi			= wb->bdi,
+		.sync_mode		= sync_mode,
+		.older_than_this	= NULL,
+		.range_cyclic		= 1,
+	};
+	long wrote = 0;
+
+	for (;;) {
+		if (sync_mode == WB_SYNC_NONE && nr_pages <= 0 &&
+		    !over_bground_thresh())
+			break;
+
+		wbc.more_io = 0;
+		wbc.encountered_congestion = 0;
+		wbc.nr_to_write = MAX_WRITEBACK_PAGES;
+		wbc.pages_skipped = 0;
+		generic_sync_wb_inodes(wb, sb, &wbc);
+		nr_pages -= MAX_WRITEBACK_PAGES - wbc.nr_to_write;
+		wrote += MAX_WRITEBACK_PAGES - wbc.nr_to_write;
+		/*
+		 * If we ran out of stuff to write, bail unless more_io got set
+		 */
+		if (wbc.nr_to_write > 0 || wbc.pages_skipped > 0) {
+			if (wbc.more_io)
+				continue;
+			break;
+		}
+	}
+
+	return wrote;
+}
+
+/*
+ * Return the next bdi_work struct that hasn't been processed by this
+ * wb thread yet
+ */
+static struct bdi_work *get_next_work_item(struct backing_dev_info *bdi,
+					   struct bdi_writeback *wb)
+{
+	struct bdi_work *work, *ret = NULL;
+
+	rcu_read_lock();
+
+	list_for_each_entry_rcu(work, &bdi->work_list, list) {
+		if (!test_and_clear_bit(wb->nr, &work->seen))
+			continue;
+
+		ret = work;
+		break;
+	}
+
+	rcu_read_unlock();
+	return ret;
+}
+
+/*
+ * Retrieve work items and do the writeback they describe
+ */
+static long wb_writeback(struct bdi_writeback *wb)
+{
+	struct backing_dev_info *bdi = wb->bdi;
+	struct bdi_work *work;
+	long wrote = 0;
+
+	while ((work = get_next_work_item(bdi, wb)) != NULL) {
+		struct super_block *sb = bdi_work_sb(work);
+		long nr_pages = work->nr_pages;
+		enum writeback_sync_modes sync_mode = work->sync_mode;
+
+		/*
+		 * If this isn't a data integrity operation, just notify
+		 * that we have seen this work and we are now starting it.
+		 */
+		if (sync_mode == WB_SYNC_NONE)
+			wb_clear_pending(wb, work);
+
+		wrote += __wb_writeback(wb, nr_pages, sb, sync_mode);
+
+		/*
+		 * This is a data integrity writeback, so only do the
+		 * notification when we have completed the work.
+		 */
+		if (sync_mode == WB_SYNC_ALL)
+			wb_clear_pending(wb, work);
+	}
+
+	return wrote;
+}
+
+/*
+ * This will be inlined in bdi_writeback_task() once we get rid of any
+ * dirty inodes on the default_backing_dev_info
+ */
+long wb_do_writeback(struct bdi_writeback *wb)
+{
+	long wrote;
+
+	/*
+	 * We get here in two cases:
+	 *
+	 *  schedule_timeout() returned because the dirty writeback
+	 *  interval has elapsed. If that happens, the work item list
+	 *  will be empty and we will proceed to do kupdated style writeout.
+	 *
+	 *  Someone called bdi_start_writeback(), which put one/more work
+	 *  items on the work_list. Process those.
+	 */
+	if (list_empty(&wb->bdi->work_list))
+		wrote = wb_kupdated(wb);
+	else
+		wrote = wb_writeback(wb);
+
+	return wrote;
+}
+
+/*
+ * Handle writeback of dirty data for the device backed by this bdi. Also
+ * wakes up periodically and does kupdated style flushing.
  */
-static void writeback_release(struct backing_dev_info *bdi)
+int bdi_writeback_task(struct bdi_writeback *wb)
 {
-	BUG_ON(!writeback_in_progress(bdi));
-	clear_bit(BDI_pdflush, &bdi->state);
+	unsigned long last_active = jiffies;
+	unsigned long wait_jiffies = -1UL;
+	long pages_written;
+	DEFINE_WAIT(wait);
+
+	while (!kthread_should_stop()) {
+
+		pages_written = wb_do_writeback(wb);
+
+		if (pages_written)
+			last_active = jiffies;
+		else if (wait_jiffies != -1UL) {
+			unsigned long max_idle;
+
+			/*
+			 * Longest period of inactivity that we tolerate. If we
+			 * see dirty data again later, the task will get
+			 * recreated automatically.
+			 */
+			max_idle = max(5UL * 60 * HZ, wait_jiffies);
+			if (time_after(jiffies, max_idle + last_active) &&
+			    wb_is_default_task(wb))
+				break;
+		}
+
+		prepare_to_wait(&wb->wait, &wait, TASK_INTERRUPTIBLE);
+		wait_jiffies = msecs_to_jiffies(dirty_writeback_interval * 10);
+		schedule_timeout(wait_jiffies);
+		try_to_freeze();
+	}
+
+	finish_wait(&wb->wait, &wait);
+	return 0;
+}
+
+/*
+ * Schedule writeback for all backing devices. Expensive! If this is a data
+ * integrity operation, writeback will be complete when this returns. If
+ * we are simply called for WB_SYNC_NONE, then writeback will merely be
+ * scheduled to run.
+ */
+void bdi_writeback_all(struct super_block *sb, long nr_pages,
+		       enum writeback_sync_modes sync_mode)
+{
+	const bool must_wait = sync_mode == WB_SYNC_ALL;
+	struct backing_dev_info *bdi, *tmp;
+	struct bdi_work *work;
+	LIST_HEAD(list);
+
+	mutex_lock(&bdi_lock);
+
+	list_for_each_entry_safe(bdi, tmp, &bdi_list, bdi_list) {
+		struct bdi_work *work, work_stack;
+
+		if (!bdi_has_dirty_io(bdi))
+			continue;
+
+		work = bdi_alloc_work(sb, nr_pages, sync_mode);
+		if (!work) {
+			work = &work_stack;
+			bdi_work_init_on_stack(work, sb, nr_pages, sync_mode);
+		} else if (must_wait)
+			list_add_tail(&work->wait_list, &list);
+
+		bdi_queue_work(bdi, work);
+		__bdi_start_work(bdi, work);
+
+		/*
+		 * Do the wait inline if this came from the stack. This
+		 * only happens if we ran out of memory, so should very
+		 * rarely trigger.
+		 */
+		if (work == &work_stack) {
+			bdi_wait_on_work_clear(work);
+			if (must_wait)
+				call_rcu(&work->rcu_head, bdi_work_free);
+		}
+	}
+
+	mutex_unlock(&bdi_lock);
+
+	/*
+	 * If this is for WB_SYNC_ALL, wait for pending work to complete
+	 * before returning.
+	 */
+	while (!list_empty(&list)) {
+		work = list_entry(list.next, struct bdi_work, wait_list);
+		list_del(&work->wait_list);
+		bdi_wait_on_work_clear(work);
+		call_rcu(&work->rcu_head, bdi_work_free);
+	}
+}
+
+/*
+ * If the filesystem didn't provide a way to map an inode to a dedicated
+ * flusher thread, it doesn't support more than 1 thread. So we know it's
+ * the default thread, return that.
+ */
+static inline struct bdi_writeback *inode_get_wb(struct inode *inode)
+{
+	const struct super_operations *sop = inode->i_sb->s_op;
+
+	if (!sop->inode_get_wb)
+		return &inode_to_bdi(inode)->wb;
+
+	return sop->inode_get_wb(inode);
 }
 
 /**
@@ -158,12 +672,21 @@ void __mark_inode_dirty(struct inode *in
 			goto out;
 
 		/*
-		 * If the inode was already on s_dirty/s_io/s_more_io, don't
-		 * reposition it (that would break s_dirty time-ordering).
+		 * If the inode was already on b_dirty/b_io/b_more_io, don't
+		 * reposition it (that would break b_dirty time-ordering).
 		 */
 		if (!was_dirty) {
+			struct bdi_writeback *wb = inode_get_wb(inode);
+			struct backing_dev_info *bdi = wb->bdi;
+
+			if (bdi_cap_writeback_dirty(bdi) &&
+			    !test_bit(BDI_registered, &bdi->state)) {
+				WARN_ON(1);
+				printk("bdi-%s not registered\n", bdi->name);
+			}
+
 			inode->dirtied_when = jiffies;
-			list_move(&inode->i_list, &sb->s_dirty);
+			list_move(&inode->i_list, &wb->b_dirty);
 		}
 	}
 out:
@@ -184,31 +707,32 @@ static int write_inode(struct inode *ino
  * furthest end of its superblock's dirty-inode list.
  *
  * Before stamping the inode's ->dirtied_when, we check to see whether it is
- * already the most-recently-dirtied inode on the s_dirty list.  If that is
+ * already the most-recently-dirtied inode on the b_dirty list.  If that is
  * the case then the inode must have been redirtied while it was being written
  * out and we don't reset its dirtied_when.
  */
 static void redirty_tail(struct inode *inode)
 {
-	struct super_block *sb = inode->i_sb;
+	struct bdi_writeback *wb = inode_get_wb(inode);
 
-	if (!list_empty(&sb->s_dirty)) {
-		struct inode *tail_inode;
+	if (!list_empty(&wb->b_dirty)) {
+		struct inode *tail;
 
-		tail_inode = list_entry(sb->s_dirty.next, struct inode, i_list);
-		if (time_before(inode->dirtied_when,
-				tail_inode->dirtied_when))
+		tail = list_entry(wb->b_dirty.next, struct inode, i_list);
+		if (time_before(inode->dirtied_when, tail->dirtied_when))
 			inode->dirtied_when = jiffies;
 	}
-	list_move(&inode->i_list, &sb->s_dirty);
+	list_move(&inode->i_list, &wb->b_dirty);
 }
 
 /*
- * requeue inode for re-scanning after sb->s_io list is exhausted.
+ * requeue inode for re-scanning after bdi->b_io list is exhausted.
  */
 static void requeue_io(struct inode *inode)
 {
-	list_move(&inode->i_list, &inode->i_sb->s_more_io);
+	struct bdi_writeback *wb = inode_get_wb(inode);
+
+	list_move(&inode->i_list, &wb->b_more_io);
 }
 
 static void inode_sync_complete(struct inode *inode)
@@ -255,20 +779,11 @@ static void move_expired_inodes(struct l
 /*
  * Queue all expired dirty inodes for io, eldest first.
  */
-static void queue_io(struct super_block *sb,
-				unsigned long *older_than_this)
-{
-	list_splice_init(&sb->s_more_io, sb->s_io.prev);
-	move_expired_inodes(&sb->s_dirty, &sb->s_io, older_than_this);
-}
-
-int sb_has_dirty_inodes(struct super_block *sb)
+static void queue_io(struct bdi_writeback *wb, unsigned long *older_than_this)
 {
-	return !list_empty(&sb->s_dirty) ||
-	       !list_empty(&sb->s_io) ||
-	       !list_empty(&sb->s_more_io);
+	list_splice_init(&wb->b_more_io, wb->b_io.prev);
+	move_expired_inodes(&wb->b_dirty, &wb->b_io, older_than_this);
 }
-EXPORT_SYMBOL(sb_has_dirty_inodes);
 
 /*
  * Write a single inode's dirty pages and inode data out to disk.
@@ -322,11 +837,11 @@ __sync_single_inode(struct inode *inode,
 			/*
 			 * We didn't write back all the pages.  nfs_writepages()
 			 * sometimes bales out without doing anything. Redirty
-			 * the inode; Move it from s_io onto s_more_io/s_dirty.
+			 * the inode; Move it from b_io onto b_more_io/b_dirty.
 			 */
 			/*
 			 * akpm: if the caller was the kupdate function we put
-			 * this inode at the head of s_dirty so it gets first
+			 * this inode at the head of b_dirty so it gets first
 			 * consideration.  Otherwise, move it to the tail, for
 			 * the reasons described there.  I'm not really sure
 			 * how much sense this makes.  Presumably I had a good
@@ -336,7 +851,7 @@ __sync_single_inode(struct inode *inode,
 			if (wbc->for_kupdate) {
 				/*
 				 * For the kupdate function we move the inode
-				 * to s_more_io so it will get more writeout as
+				 * to b_more_io so it will get more writeout as
 				 * soon as the queue becomes uncongested.
 				 */
 				inode->i_state |= I_DIRTY_PAGES;
@@ -402,10 +917,10 @@ __writeback_single_inode(struct inode *i
 	if ((wbc->sync_mode != WB_SYNC_ALL) && (inode->i_state & I_SYNC)) {
 		/*
 		 * We're skipping this inode because it's locked, and we're not
-		 * doing writeback-for-data-integrity.  Move it to s_more_io so
-		 * that writeback can proceed with the other inodes on s_io.
+		 * doing writeback-for-data-integrity.  Move it to b_more_io so
+		 * that writeback can proceed with the other inodes on b_io.
 		 * We'll have another go at writing back this inode when we
-		 * completed a full scan of s_io.
+		 * completed a full scan of b_io.
 		 */
 		requeue_io(inode);
 		return 0;
@@ -428,51 +943,34 @@ __writeback_single_inode(struct inode *i
 	return __sync_single_inode(inode, wbc);
 }
 
-/*
- * Write out a superblock's list of dirty inodes.  A wait will be performed
- * upon no inodes, all inodes or the final one, depending upon sync_mode.
- *
- * If older_than_this is non-NULL, then only write out inodes which
- * had their first dirtying at a time earlier than *older_than_this.
- *
- * If we're a pdflush thread, then implement pdflush collision avoidance
- * against the entire list.
- *
- * If `bdi' is non-zero then we're being asked to writeback a specific queue.
- * This function assumes that the blockdev superblock's inodes are backed by
- * a variety of queues, so all inodes are searched.  For other superblocks,
- * assume that all inodes are backed by the same queue.
- *
- * FIXME: this linear search could get expensive with many fileystems.  But
- * how to fix?  We need to go from an address_space to all inodes which share
- * a queue with that address_space.  (Easy: have a global "dirty superblocks"
- * list).
- *
- * The inodes to be written are parked on sb->s_io.  They are moved back onto
- * sb->s_dirty as they are selected for writing.  This way, none can be missed
- * on the writer throttling path, and we get decent balancing between many
- * throttled threads: we don't want them all piling up on inode_sync_wait.
- */
-void generic_sync_sb_inodes(struct super_block *sb,
-				struct writeback_control *wbc)
+static void generic_sync_wb_inodes(struct bdi_writeback *wb,
+				   struct super_block *sb,
+				   struct writeback_control *wbc)
 {
+	const int is_blkdev_sb = sb_is_blkdev_sb(sb);
 	const unsigned long start = jiffies;	/* livelock avoidance */
-	int sync = wbc->sync_mode == WB_SYNC_ALL;
 
 	spin_lock(&inode_lock);
-	if (!wbc->for_kupdate || list_empty(&sb->s_io))
-		queue_io(sb, wbc->older_than_this);
 
-	while (!list_empty(&sb->s_io)) {
-		struct inode *inode = list_entry(sb->s_io.prev,
+	if (!wbc->for_kupdate || list_empty(&wb->b_io))
+		queue_io(wb, wbc->older_than_this);
+
+	while (!list_empty(&wb->b_io)) {
+		struct inode *inode = list_entry(wb->b_io.prev,
 						struct inode, i_list);
-		struct address_space *mapping = inode->i_mapping;
-		struct backing_dev_info *bdi = mapping->backing_dev_info;
 		long pages_skipped;
 
-		if (!bdi_cap_writeback_dirty(bdi)) {
+		/*
+		 * super block given and doesn't match, skip this inode
+		 */
+		if (sb && sb != inode->i_sb) {
+			redirty_tail(inode);
+			continue;
+		}
+
+		if (!bdi_cap_writeback_dirty(wb->bdi)) {
 			redirty_tail(inode);
-			if (sb_is_blkdev_sb(sb)) {
+			if (is_blkdev_sb) {
 				/*
 				 * Dirty memory-backed blockdev: the ramdisk
 				 * driver does this.  Skip just this inode
@@ -492,21 +990,14 @@ void generic_sync_sb_inodes(struct super
 			continue;
 		}
 
-		if (wbc->nonblocking && bdi_write_congested(bdi)) {
+		if (wbc->nonblocking && bdi_write_congested(wb->bdi)) {
 			wbc->encountered_congestion = 1;
-			if (!sb_is_blkdev_sb(sb))
+			if (!is_blkdev_sb)
 				break;		/* Skip a congested fs */
 			requeue_io(inode);
 			continue;		/* Skip a congested blockdev */
 		}
 
-		if (wbc->bdi && bdi != wbc->bdi) {
-			if (!sb_is_blkdev_sb(sb))
-				break;		/* fs has the wrong queue */
-			requeue_io(inode);
-			continue;		/* blockdev has wrong queue */
-		}
-
 		/*
 		 * Was this inode dirtied after sync_sb_inodes was called?
 		 * This keeps sync from extra jobs and livelock.
@@ -514,16 +1005,10 @@ void generic_sync_sb_inodes(struct super
 		if (inode_dirtied_after(inode, start))
 			break;
 
-		/* Is another pdflush already flushing this queue? */
-		if (current_is_pdflush() && !writeback_acquire(bdi))
-			break;
-
 		BUG_ON(inode->i_state & I_FREEING);
 		__iget(inode);
 		pages_skipped = wbc->pages_skipped;
 		__writeback_single_inode(inode, wbc);
-		if (current_is_pdflush())
-			writeback_release(bdi);
 		if (wbc->pages_skipped != pages_skipped) {
 			/*
 			 * writeback is not making progress due to locked
@@ -539,13 +1024,71 @@ void generic_sync_sb_inodes(struct super
 			wbc->more_io = 1;
 			break;
 		}
-		if (!list_empty(&sb->s_more_io))
+		if (!list_empty(&wb->b_more_io))
 			wbc->more_io = 1;
 	}
 
-	if (sync) {
+	spin_unlock(&inode_lock);
+	/* Leave any unwritten inodes on b_io */
+}
+
+void generic_sync_bdi_inodes(struct super_block *sb,
+			     struct writeback_control *wbc)
+{
+	struct backing_dev_info *bdi = wbc->bdi;
+	struct bdi_writeback *wb;
+
+	/*
+	 * Common case is just a single wb thread and that is embedded in
+	 * the bdi, so it doesn't need locking
+	 */
+	if (!bdi_wblist_needs_lock(bdi))
+		generic_sync_wb_inodes(&bdi->wb, sb, wbc);
+	else {
+		int idx;
+
+		idx = srcu_read_lock(&bdi->srcu);
+
+		list_for_each_entry_rcu(wb, &bdi->wb_list, list)
+			generic_sync_wb_inodes(wb, sb, wbc);
+
+		srcu_read_unlock(&bdi->srcu, idx);
+	}
+}
+
+/*
+ * Write out a superblock's list of dirty inodes.  A wait will be performed
+ * upon no inodes, all inodes or the final one, depending upon sync_mode.
+ *
+ * If older_than_this is non-NULL, then only write out inodes which
+ * had their first dirtying at a time earlier than *older_than_this.
+ *
+ * If we're a pdlfush thread, then implement pdflush collision avoidance
+ * against the entire list.
+ *
+ * If `bdi' is non-zero then we're being asked to writeback a specific queue.
+ * This function assumes that the blockdev superblock's inodes are backed by
+ * a variety of queues, so all inodes are searched.  For other superblocks,
+ * assume that all inodes are backed by the same queue.
+ *
+ * The inodes to be written are parked on bdi->b_io.  They are moved back onto
+ * bdi->b_dirty as they are selected for writing.  This way, none can be missed
+ * on the writer throttling path, and we get decent balancing between many
+ * throttled threads: we don't want them all piling up on inode_sync_wait.
+ */
+void generic_sync_sb_inodes(struct super_block *sb,
+				struct writeback_control *wbc)
+{
+	if (wbc->bdi)
+		bdi_start_writeback(wbc->bdi, sb, wbc->nr_to_write, wbc->sync_mode);
+	else
+		bdi_writeback_all(sb, wbc->nr_to_write, wbc->sync_mode);
+
+	if (wbc->sync_mode == WB_SYNC_ALL) {
 		struct inode *inode, *old_inode = NULL;
 
+		spin_lock(&inode_lock);
+
 		/*
 		 * Data integrity sync. Must wait for all pages under writeback,
 		 * because there may have been pages dirtied before our sync
@@ -583,10 +1126,8 @@ void generic_sync_sb_inodes(struct super
 		}
 		spin_unlock(&inode_lock);
 		iput(old_inode);
-	} else
-		spin_unlock(&inode_lock);
+	}
 
-	return;		/* Leave any unwritten inodes on s_io */
 }
 EXPORT_SYMBOL_GPL(generic_sync_sb_inodes);
 
@@ -597,58 +1138,6 @@ static void sync_sb_inodes(struct super_
 }
 
 /*
- * Start writeback of dirty pagecache data against all unlocked inodes.
- *
- * Note:
- * We don't need to grab a reference to superblock here. If it has non-empty
- * ->s_dirty it's hadn't been killed yet and kill_super() won't proceed
- * past sync_inodes_sb() until the ->s_dirty/s_io/s_more_io lists are all
- * empty. Since __sync_single_inode() regains inode_lock before it finally moves
- * inode from superblock lists we are OK.
- *
- * If `older_than_this' is non-zero then only flush inodes which have a
- * flushtime older than *older_than_this.
- *
- * If `bdi' is non-zero then we will scan the first inode against each
- * superblock until we find the matching ones.  One group will be the dirty
- * inodes against a filesystem.  Then when we hit the dummy blockdev superblock,
- * sync_sb_inodes will seekout the blockdev which matches `bdi'.  Maybe not
- * super-efficient but we're about to do a ton of I/O...
- */
-void
-writeback_inodes(struct writeback_control *wbc)
-{
-	struct super_block *sb;
-
-	might_sleep();
-	spin_lock(&sb_lock);
-restart:
-	list_for_each_entry_reverse(sb, &super_blocks, s_list) {
-		if (sb_has_dirty_inodes(sb)) {
-			/* we're making our own get_super here */
-			sb->s_count++;
-			spin_unlock(&sb_lock);
-			/*
-			 * If we can't get the readlock, there's no sense in
-			 * waiting around, most of the time the FS is going to
-			 * be unmounted by the time it is released.
-			 */
-			if (down_read_trylock(&sb->s_umount)) {
-				if (sb->s_root)
-					sync_sb_inodes(sb, wbc);
-				up_read(&sb->s_umount);
-			}
-			spin_lock(&sb_lock);
-			if (__put_super_and_need_restart(sb))
-				goto restart;
-		}
-		if (wbc->nr_to_write <= 0)
-			break;
-	}
-	spin_unlock(&sb_lock);
-}
-
-/*
  * writeback and wait upon the filesystem's dirty inodes.  The caller will
  * do this in two passes - one to write, and one to wait.
  *
diff -Nraup linux-2.6.30-rc6/fs/fuse/inode.c linux-2.6.30-rc6_bdiflusherv7/fs/fuse/inode.c
--- linux-2.6.30-rc6/fs/fuse/inode.c	2009-05-19 11:00:57.000000000 +0800
+++ linux-2.6.30-rc6_bdiflusherv7/fs/fuse/inode.c	2009-05-27 08:59:27.000000000 +0800
@@ -484,6 +484,7 @@ int fuse_conn_init(struct fuse_conn *fc,
 	INIT_LIST_HEAD(&fc->bg_queue);
 	INIT_LIST_HEAD(&fc->entry);
 	atomic_set(&fc->num_waiting, 0);
+	fc->bdi.name = "fuse";
 	fc->bdi.ra_pages = (VM_MAX_READAHEAD * 1024) / PAGE_CACHE_SIZE;
 	fc->bdi.unplug_io_fn = default_unplug_io_fn;
 	/* fuse does it's own writeback accounting */
diff -Nraup linux-2.6.30-rc6/fs/hugetlbfs/inode.c linux-2.6.30-rc6_bdiflusherv7/fs/hugetlbfs/inode.c
--- linux-2.6.30-rc6/fs/hugetlbfs/inode.c	2009-05-19 11:00:57.000000000 +0800
+++ linux-2.6.30-rc6_bdiflusherv7/fs/hugetlbfs/inode.c	2009-05-27 08:59:27.000000000 +0800
@@ -43,6 +43,7 @@ static const struct inode_operations hug
 static const struct inode_operations hugetlbfs_inode_operations;
 
 static struct backing_dev_info hugetlbfs_backing_dev_info = {
+	.name		= "hugetlbfs",
 	.ra_pages	= 0,	/* No readahead */
 	.capabilities	= BDI_CAP_NO_ACCT_AND_WRITEBACK,
 };
diff -Nraup linux-2.6.30-rc6/fs/nfs/client.c linux-2.6.30-rc6_bdiflusherv7/fs/nfs/client.c
--- linux-2.6.30-rc6/fs/nfs/client.c	2009-05-19 11:00:57.000000000 +0800
+++ linux-2.6.30-rc6_bdiflusherv7/fs/nfs/client.c	2009-05-27 08:59:27.000000000 +0800
@@ -836,6 +836,7 @@ static void nfs_server_set_fsinfo(struct
 		server->rsize = NFS_MAX_FILE_IO_SIZE;
 	server->rpages = (server->rsize + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
 
+	server->backing_dev_info.name = "nfs";
 	server->backing_dev_info.ra_pages = server->rpages * NFS_MAX_READAHEAD;
 
 	if (server->wsize > max_rpc_payload)
diff -Nraup linux-2.6.30-rc6/fs/ntfs/super.c linux-2.6.30-rc6_bdiflusherv7/fs/ntfs/super.c
--- linux-2.6.30-rc6/fs/ntfs/super.c	2009-05-19 11:00:57.000000000 +0800
+++ linux-2.6.30-rc6_bdiflusherv7/fs/ntfs/super.c	2009-05-27 08:59:27.000000000 +0800
@@ -2373,39 +2373,12 @@ static void ntfs_put_super(struct super_
 		vol->mftmirr_ino = NULL;
 	}
 	/*
-	 * If any dirty inodes are left, throw away all mft data page cache
-	 * pages to allow a clean umount.  This should never happen any more
-	 * due to mft.c::ntfs_mft_writepage() cleaning all the dirty pages as
-	 * the underlying mft records are written out and cleaned.  If it does,
-	 * happen anyway, we want to know...
+	 * We should have no dirty inodes left, due to
+	 * mft.c::ntfs_mft_writepage() cleaning all the dirty pages as
+	 * the underlying mft records are written out and cleaned.
 	 */
 	ntfs_commit_inode(vol->mft_ino);
 	write_inode_now(vol->mft_ino, 1);
-	if (sb_has_dirty_inodes(sb)) {
-		const char *s1, *s2;
-
-		mutex_lock(&vol->mft_ino->i_mutex);
-		truncate_inode_pages(vol->mft_ino->i_mapping, 0);
-		mutex_unlock(&vol->mft_ino->i_mutex);
-		write_inode_now(vol->mft_ino, 1);
-		if (sb_has_dirty_inodes(sb)) {
-			static const char *_s1 = "inodes";
-			static const char *_s2 = "";
-			s1 = _s1;
-			s2 = _s2;
-		} else {
-			static const char *_s1 = "mft pages";
-			static const char *_s2 = "They have been thrown "
-					"away.  ";
-			s1 = _s1;
-			s2 = _s2;
-		}
-		ntfs_error(sb, "Dirty %s found at umount time.  %sYou should "
-				"run chkdsk.  Please email "
-				"linux-ntfs-dev@lists.sourceforge.net and say "
-				"that you saw this message.  Thank you.", s1,
-				s2);
-	}
 #endif /* NTFS_RW */
 
 	iput(vol->mft_ino);
diff -Nraup linux-2.6.30-rc6/fs/ocfs2/dlm/dlmfs.c linux-2.6.30-rc6_bdiflusherv7/fs/ocfs2/dlm/dlmfs.c
--- linux-2.6.30-rc6/fs/ocfs2/dlm/dlmfs.c	2009-05-19 11:00:27.000000000 +0800
+++ linux-2.6.30-rc6_bdiflusherv7/fs/ocfs2/dlm/dlmfs.c	2009-05-27 08:59:27.000000000 +0800
@@ -325,6 +325,7 @@ clear_fields:
 }
 
 static struct backing_dev_info dlmfs_backing_dev_info = {
+	.name		= "ocfs2-dlmfs",
 	.ra_pages	= 0,	/* No readahead */
 	.capabilities	= BDI_CAP_NO_ACCT_AND_WRITEBACK,
 };
diff -Nraup linux-2.6.30-rc6/fs/ramfs/inode.c linux-2.6.30-rc6_bdiflusherv7/fs/ramfs/inode.c
--- linux-2.6.30-rc6/fs/ramfs/inode.c	2009-05-19 11:00:57.000000000 +0800
+++ linux-2.6.30-rc6_bdiflusherv7/fs/ramfs/inode.c	2009-05-27 08:59:27.000000000 +0800
@@ -46,6 +46,7 @@ static const struct super_operations ram
 static const struct inode_operations ramfs_dir_inode_operations;
 
 static struct backing_dev_info ramfs_backing_dev_info = {
+	.name		= "ramfs",
 	.ra_pages	= 0,	/* No readahead */
 	.capabilities	= BDI_CAP_NO_ACCT_AND_WRITEBACK |
 			  BDI_CAP_MAP_DIRECT | BDI_CAP_MAP_COPY |
diff -Nraup linux-2.6.30-rc6/fs/super.c linux-2.6.30-rc6_bdiflusherv7/fs/super.c
--- linux-2.6.30-rc6/fs/super.c	2009-05-19 11:00:57.000000000 +0800
+++ linux-2.6.30-rc6_bdiflusherv7/fs/super.c	2009-05-27 08:59:27.000000000 +0800
@@ -64,9 +64,6 @@ static struct super_block *alloc_super(s
 			s = NULL;
 			goto out;
 		}
-		INIT_LIST_HEAD(&s->s_dirty);
-		INIT_LIST_HEAD(&s->s_io);
-		INIT_LIST_HEAD(&s->s_more_io);
 		INIT_LIST_HEAD(&s->s_files);
 		INIT_LIST_HEAD(&s->s_instances);
 		INIT_HLIST_HEAD(&s->s_anon);
diff -Nraup linux-2.6.30-rc6/fs/sync.c linux-2.6.30-rc6_bdiflusherv7/fs/sync.c
--- linux-2.6.30-rc6/fs/sync.c	2009-05-19 11:00:57.000000000 +0800
+++ linux-2.6.30-rc6_bdiflusherv7/fs/sync.c	2009-05-27 08:59:27.000000000 +0800
@@ -23,7 +23,7 @@
  */
 static void do_sync(unsigned long wait)
 {
-	wakeup_pdflush(0);
+	wakeup_flusher_threads(0);
 	sync_inodes(0);		/* All mappings, inodes and their blockdevs */
 	vfs_dq_sync(NULL);
 	sync_supers();		/* Write the superblocks */
diff -Nraup linux-2.6.30-rc6/fs/sysfs/inode.c linux-2.6.30-rc6_bdiflusherv7/fs/sysfs/inode.c
--- linux-2.6.30-rc6/fs/sysfs/inode.c	2009-05-19 11:00:57.000000000 +0800
+++ linux-2.6.30-rc6_bdiflusherv7/fs/sysfs/inode.c	2009-05-27 08:59:27.000000000 +0800
@@ -29,6 +29,7 @@ static const struct address_space_operat
 };
 
 static struct backing_dev_info sysfs_backing_dev_info = {
+	.name		= "sysfs",
 	.ra_pages	= 0,	/* No readahead */
 	.capabilities	= BDI_CAP_NO_ACCT_AND_WRITEBACK,
 };
diff -Nraup linux-2.6.30-rc6/fs/ubifs/super.c linux-2.6.30-rc6_bdiflusherv7/fs/ubifs/super.c
--- linux-2.6.30-rc6/fs/ubifs/super.c	2009-05-19 11:00:57.000000000 +0800
+++ linux-2.6.30-rc6_bdiflusherv7/fs/ubifs/super.c	2009-05-27 08:59:27.000000000 +0800
@@ -1923,6 +1923,7 @@ static int ubifs_fill_super(struct super
 	 *
 	 * Read-ahead will be disabled because @c->bdi.ra_pages is 0.
 	 */
+	c->bdi.name = "ubifs",
 	c->bdi.capabilities = BDI_CAP_MAP_COPY;
 	c->bdi.unplug_io_fn = default_unplug_io_fn;
 	err  = bdi_init(&c->bdi);
diff -Nraup linux-2.6.30-rc6/include/linux/backing-dev.h linux-2.6.30-rc6_bdiflusherv7/include/linux/backing-dev.h
--- linux-2.6.30-rc6/include/linux/backing-dev.h	2009-05-19 11:00:57.000000000 +0800
+++ linux-2.6.30-rc6_bdiflusherv7/include/linux/backing-dev.h	2009-05-27 08:59:27.000000000 +0800
@@ -13,6 +13,9 @@
 #include <linux/proportions.h>
 #include <linux/kernel.h>
 #include <linux/fs.h>
+#include <linux/sched.h>
+#include <linux/srcu.h>
+#include <linux/writeback.h>
 #include <asm/atomic.h>
 
 struct page;
@@ -23,9 +26,12 @@ struct dentry;
  * Bits in backing_dev_info.state
  */
 enum bdi_state {
-	BDI_pdflush,		/* A pdflush thread is working this device */
+	BDI_pending,		/* On its way to being activated */
+	BDI_wb_alloc,		/* Default embedded wb allocated */
+	BDI_wblist_lock,	/* bdi->wb_list now needs locking */
 	BDI_async_congested,	/* The async (write) queue is getting full */
 	BDI_sync_congested,	/* The sync queue is getting full */
+	BDI_registered,		/* bdi_register() was done */
 	BDI_unused,		/* Available bits start here */
 };
 
@@ -39,7 +45,24 @@ enum bdi_stat_item {
 
 #define BDI_STAT_BATCH (8*(1+ilog2(nr_cpu_ids)))
 
+struct bdi_writeback {
+	struct list_head list;			/* hangs off the bdi */
+
+	struct backing_dev_info *bdi;		/* our parent bdi */
+	unsigned int nr;
+
+	struct task_struct	*task;		/* writeback task */
+	wait_queue_head_t	wait;
+	struct list_head	b_dirty;	/* dirty inodes */
+	struct list_head	b_io;		/* parked for writeback */
+	struct list_head	b_more_io;	/* parked for more writeback */
+};
+
+#define BDI_MAX_FLUSHERS	32
+
 struct backing_dev_info {
+	struct srcu_struct srcu; /* for wb_list read side protection */
+	struct list_head bdi_list;
 	unsigned long ra_pages;	/* max readahead in PAGE_CACHE_SIZE units */
 	unsigned long state;	/* Always use atomic bitops on this */
 	unsigned int capabilities; /* Device capabilities */
@@ -48,6 +71,8 @@ struct backing_dev_info {
 	void (*unplug_io_fn)(struct backing_dev_info *, struct page *);
 	void *unplug_io_data;
 
+	char *name;
+
 	struct percpu_counter bdi_stat[NR_BDI_STAT_ITEMS];
 
 	struct prop_local_percpu completions;
@@ -56,6 +81,14 @@ struct backing_dev_info {
 	unsigned int min_ratio;
 	unsigned int max_ratio, max_prop_frac;
 
+	struct bdi_writeback wb;  /* default writeback info for this bdi */
+	spinlock_t wb_lock;	  /* protects update side of wb_list */
+	struct list_head wb_list; /* the flusher threads hanging off this bdi */
+	unsigned long wb_mask;	  /* bitmask of registered tasks */
+	unsigned int wb_cnt;	  /* number of registered tasks */
+
+	struct list_head work_list;
+
 	struct device *dev;
 
 #ifdef CONFIG_DEBUG_FS
@@ -71,6 +104,34 @@ int bdi_register(struct backing_dev_info
 		const char *fmt, ...);
 int bdi_register_dev(struct backing_dev_info *bdi, dev_t dev);
 void bdi_unregister(struct backing_dev_info *bdi);
+void bdi_start_writeback(struct backing_dev_info *bdi, struct super_block *sb,
+			 long nr_pages, enum writeback_sync_modes sync_mode);
+int bdi_writeback_task(struct bdi_writeback *wb);
+void bdi_writeback_all(struct super_block *sb, long nr_pages,
+			enum writeback_sync_modes sync_mode);
+void bdi_add_default_flusher_task(struct backing_dev_info *bdi);
+void bdi_add_flusher_task(struct backing_dev_info *bdi);
+int bdi_has_dirty_io(struct backing_dev_info *bdi);
+
+extern struct mutex bdi_lock;
+extern struct list_head bdi_list;
+
+static inline int wb_is_default_task(struct bdi_writeback *wb)
+{
+	return wb == &wb->bdi->wb;
+}
+
+static inline int bdi_wblist_needs_lock(struct backing_dev_info *bdi)
+{
+	return test_bit(BDI_wblist_lock, &bdi->state);
+}
+
+static inline int wb_has_dirty_io(struct bdi_writeback *wb)
+{
+	return !list_empty(&wb->b_dirty) ||
+	       !list_empty(&wb->b_io) ||
+	       !list_empty(&wb->b_more_io);
+}
 
 static inline void __add_bdi_stat(struct backing_dev_info *bdi,
 		enum bdi_stat_item item, s64 amount)
@@ -187,6 +248,7 @@ int bdi_set_max_ratio(struct backing_dev
 #define BDI_CAP_EXEC_MAP	0x00000040
 #define BDI_CAP_NO_ACCT_WB	0x00000080
 #define BDI_CAP_SWAP_BACKED	0x00000100
+#define BDI_CAP_FLUSH_FORKER	0x00000200
 
 #define BDI_CAP_VMFLAGS \
 	(BDI_CAP_READ_MAP | BDI_CAP_WRITE_MAP | BDI_CAP_EXEC_MAP)
@@ -256,6 +318,11 @@ static inline bool bdi_cap_swap_backed(s
 	return bdi->capabilities & BDI_CAP_SWAP_BACKED;
 }
 
+static inline bool bdi_cap_flush_forker(struct backing_dev_info *bdi)
+{
+	return bdi->capabilities & BDI_CAP_FLUSH_FORKER;
+}
+
 static inline bool mapping_cap_writeback_dirty(struct address_space *mapping)
 {
 	return bdi_cap_writeback_dirty(mapping->backing_dev_info);
@@ -271,4 +338,10 @@ static inline bool mapping_cap_swap_back
 	return bdi_cap_swap_backed(mapping->backing_dev_info);
 }
 
+static inline int bdi_sched_wait(void *word)
+{
+	schedule();
+	return 0;
+}
+
 #endif		/* _LINUX_BACKING_DEV_H */
diff -Nraup linux-2.6.30-rc6/include/linux/fs.h linux-2.6.30-rc6_bdiflusherv7/include/linux/fs.h
--- linux-2.6.30-rc6/include/linux/fs.h	2009-05-19 11:00:57.000000000 +0800
+++ linux-2.6.30-rc6_bdiflusherv7/include/linux/fs.h	2009-05-27 08:59:27.000000000 +0800
@@ -712,7 +712,7 @@ static inline int mapping_writably_mappe
 
 struct inode {
 	struct hlist_node	i_hash;
-	struct list_head	i_list;
+	struct list_head	i_list;		/* backing dev IO list */
 	struct list_head	i_sb_list;
 	struct list_head	i_dentry;
 	unsigned long		i_ino;
@@ -1329,9 +1329,6 @@ struct super_block {
 	struct xattr_handler	**s_xattr;
 
 	struct list_head	s_inodes;	/* all inodes */
-	struct list_head	s_dirty;	/* dirty inodes */
-	struct list_head	s_io;		/* parked for writeback */
-	struct list_head	s_more_io;	/* parked for more writeback */
 	struct hlist_head	s_anon;		/* anonymous dentries for (nfs) exporting */
 	struct list_head	s_files;
 	/* s_dentry_lru and s_nr_dentry_unused are protected by dcache_lock */
@@ -1553,11 +1550,14 @@ extern ssize_t vfs_readv(struct file *, 
 extern ssize_t vfs_writev(struct file *, const struct iovec __user *,
 		unsigned long, loff_t *);
 
+struct bdi_writeback;
+
 struct super_operations {
    	struct inode *(*alloc_inode)(struct super_block *sb);
 	void (*destroy_inode)(struct inode *);
 
    	void (*dirty_inode) (struct inode *);
+	struct bdi_writeback *(*inode_get_wb) (struct inode *);
 	int (*write_inode) (struct inode *, int);
 	void (*drop_inode) (struct inode *);
 	void (*delete_inode) (struct inode *);
@@ -2066,6 +2066,8 @@ extern int invalidate_inode_pages2_range
 					 pgoff_t start, pgoff_t end);
 extern void generic_sync_sb_inodes(struct super_block *sb,
 				struct writeback_control *wbc);
+extern void generic_sync_bdi_inodes(struct super_block *sb,
+				struct writeback_control *);
 extern int write_inode_now(struct inode *, int);
 extern int filemap_fdatawrite(struct address_space *);
 extern int filemap_flush(struct address_space *);
@@ -2183,7 +2185,6 @@ extern int bdev_read_only(struct block_d
 extern int set_blocksize(struct block_device *, int);
 extern int sb_set_blocksize(struct super_block *, int);
 extern int sb_min_blocksize(struct super_block *, int);
-extern int sb_has_dirty_inodes(struct super_block *);
 
 extern int generic_file_mmap(struct file *, struct vm_area_struct *);
 extern int generic_file_readonly_mmap(struct file *, struct vm_area_struct *);
diff -Nraup linux-2.6.30-rc6/include/linux/writeback.h linux-2.6.30-rc6_bdiflusherv7/include/linux/writeback.h
--- linux-2.6.30-rc6/include/linux/writeback.h	2009-05-19 11:00:58.000000000 +0800
+++ linux-2.6.30-rc6_bdiflusherv7/include/linux/writeback.h	2009-05-27 08:59:27.000000000 +0800
@@ -14,17 +14,6 @@ extern struct list_head inode_in_use;
 extern struct list_head inode_unused;
 
 /*
- * Yes, writeback.h requires sched.h
- * No, sched.h is not included from here.
- */
-static inline int task_is_pdflush(struct task_struct *task)
-{
-	return task->flags & PF_FLUSHER;
-}
-
-#define current_is_pdflush()	task_is_pdflush(current)
-
-/*
  * fs/fs-writeback.c
  */
 enum writeback_sync_modes {
@@ -80,6 +69,7 @@ void writeback_inodes(struct writeback_c
 int inode_wait(void *);
 void sync_inodes_sb(struct super_block *, int wait);
 void sync_inodes(int wait);
+long wb_do_writeback(struct bdi_writeback *wb);
 
 /* writeback.h requires fs.h; it, too, is not included from here. */
 static inline void wait_on_inode(struct inode *inode)
@@ -99,7 +89,7 @@ static inline void inode_sync_wait(struc
 /*
  * mm/page-writeback.c
  */
-int wakeup_pdflush(long nr_pages);
+void wakeup_flusher_threads(long nr_pages);
 void laptop_io_completion(void);
 void laptop_sync_completion(void);
 void throttle_vm_writeout(gfp_t gfp_mask);
@@ -151,7 +141,6 @@ balance_dirty_pages_ratelimited(struct a
 typedef int (*writepage_t)(struct page *page, struct writeback_control *wbc,
 				void *data);
 
-int pdflush_operation(void (*fn)(unsigned long), unsigned long arg0);
 int generic_writepages(struct address_space *mapping,
 		       struct writeback_control *wbc);
 int write_cache_pages(struct address_space *mapping,
diff -Nraup linux-2.6.30-rc6/kernel/cgroup.c linux-2.6.30-rc6_bdiflusherv7/kernel/cgroup.c
--- linux-2.6.30-rc6/kernel/cgroup.c	2009-05-19 11:00:58.000000000 +0800
+++ linux-2.6.30-rc6_bdiflusherv7/kernel/cgroup.c	2009-05-27 08:59:27.000000000 +0800
@@ -598,6 +598,7 @@ static struct inode_operations cgroup_di
 static struct file_operations proc_cgroupstats_operations;
 
 static struct backing_dev_info cgroup_backing_dev_info = {
+	.name		= "cgroup",
 	.capabilities	= BDI_CAP_NO_ACCT_AND_WRITEBACK,
 };
 
diff -Nraup linux-2.6.30-rc6/mm/backing-dev.c linux-2.6.30-rc6_bdiflusherv7/mm/backing-dev.c
--- linux-2.6.30-rc6/mm/backing-dev.c	2009-05-19 11:00:58.000000000 +0800
+++ linux-2.6.30-rc6_bdiflusherv7/mm/backing-dev.c	2009-05-27 08:59:27.000000000 +0800
@@ -1,8 +1,11 @@
 
 #include <linux/wait.h>
 #include <linux/backing-dev.h>
+#include <linux/kthread.h>
+#include <linux/freezer.h>
 #include <linux/fs.h>
 #include <linux/pagemap.h>
+#include <linux/mm.h>
 #include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/writeback.h>
@@ -14,14 +17,18 @@ void default_unplug_io_fn(struct backing
 EXPORT_SYMBOL(default_unplug_io_fn);
 
 struct backing_dev_info default_backing_dev_info = {
+	.name		= "default",
 	.ra_pages	= VM_MAX_READAHEAD * 1024 / PAGE_CACHE_SIZE,
 	.state		= 0,
-	.capabilities	= BDI_CAP_MAP_COPY,
+	.capabilities	= BDI_CAP_MAP_COPY | BDI_CAP_FLUSH_FORKER,
 	.unplug_io_fn	= default_unplug_io_fn,
 };
 EXPORT_SYMBOL_GPL(default_backing_dev_info);
 
 static struct class *bdi_class;
+DEFINE_MUTEX(bdi_lock);
+LIST_HEAD(bdi_list);
+LIST_HEAD(bdi_pending_list);
 
 #ifdef CONFIG_DEBUG_FS
 #include <linux/debugfs.h>
@@ -37,9 +44,29 @@ static void bdi_debug_init(void)
 static int bdi_debug_stats_show(struct seq_file *m, void *v)
 {
 	struct backing_dev_info *bdi = m->private;
+	struct bdi_writeback *wb;
 	unsigned long background_thresh;
 	unsigned long dirty_thresh;
 	unsigned long bdi_thresh;
+	unsigned long nr_dirty, nr_io, nr_more_io, nr_wb;
+	struct inode *inode;
+
+	/*
+	 * inode lock is enough here, the bdi->wb_list is protected by
+	 * RCU on the reader side
+	 */
+	nr_wb = nr_dirty = nr_io = nr_more_io = 0;
+	spin_lock(&inode_lock);
+	list_for_each_entry(wb, &bdi->wb_list, list) {
+		nr_wb++;
+		list_for_each_entry(inode, &wb->b_dirty, i_list)
+			nr_dirty++;
+		list_for_each_entry(inode, &wb->b_io, i_list)
+			nr_io++;
+		list_for_each_entry(inode, &wb->b_more_io, i_list)
+			nr_more_io++;
+	}
+	spin_unlock(&inode_lock);
 
 	get_dirty_limits(&background_thresh, &dirty_thresh, &bdi_thresh, bdi);
 
@@ -49,12 +76,22 @@ static int bdi_debug_stats_show(struct s
 		   "BdiReclaimable:   %8lu kB\n"
 		   "BdiDirtyThresh:   %8lu kB\n"
 		   "DirtyThresh:      %8lu kB\n"
-		   "BackgroundThresh: %8lu kB\n",
+		   "BackgroundThresh: %8lu kB\n"
+		   "WriteBack threads:%8lu\n"
+		   "b_dirty:          %8lu\n"
+		   "b_io:             %8lu\n"
+		   "b_more_io:        %8lu\n"
+		   "bdi_list:         %8u\n"
+		   "state:            %8lx\n"
+		   "wb_mask:          %8lx\n"
+		   "wb_list:          %8u\n"
+		   "wb_cnt:           %8u\n",
 		   (unsigned long) K(bdi_stat(bdi, BDI_WRITEBACK)),
 		   (unsigned long) K(bdi_stat(bdi, BDI_RECLAIMABLE)),
-		   K(bdi_thresh),
-		   K(dirty_thresh),
-		   K(background_thresh));
+		   K(bdi_thresh), K(dirty_thresh),
+		   K(background_thresh), nr_wb, nr_dirty, nr_io, nr_more_io,
+		   !list_empty(&bdi->bdi_list), bdi->state, bdi->wb_mask,
+		   !list_empty(&bdi->wb_list), bdi->wb_cnt);
 #undef K
 
 	return 0;
@@ -193,6 +230,343 @@ static int __init default_bdi_init(void)
 }
 subsys_initcall(default_bdi_init);
 
+static int wb_assign_nr(struct backing_dev_info *bdi, struct bdi_writeback *wb)
+{
+	unsigned long mask = BDI_MAX_FLUSHERS - 1;
+	unsigned int nr;
+
+	do {
+		if ((bdi->wb_mask & mask) == mask)
+			return 1;
+
+		nr = find_first_zero_bit(&bdi->wb_mask, BDI_MAX_FLUSHERS);
+	} while (test_and_set_bit(nr, &bdi->wb_mask));
+
+	wb->nr = nr;
+
+	spin_lock(&bdi->wb_lock);
+	bdi->wb_cnt++;
+	spin_unlock(&bdi->wb_lock);
+
+	return 0;
+}
+
+static void bdi_put_wb(struct backing_dev_info *bdi, struct bdi_writeback *wb)
+{
+	clear_bit(wb->nr, &bdi->wb_mask);
+
+	if (wb == &bdi->wb)
+		clear_bit(BDI_wb_alloc, &bdi->state);
+	else
+		kfree(wb);
+
+	spin_lock(&bdi->wb_lock);
+	bdi->wb_cnt--;
+	spin_unlock(&bdi->wb_lock);
+}
+
+static int bdi_wb_init(struct bdi_writeback *wb, struct backing_dev_info *bdi)
+{
+	memset(wb, 0, sizeof(*wb));
+
+	wb->bdi = bdi;
+	init_waitqueue_head(&wb->wait);
+	INIT_LIST_HEAD(&wb->b_dirty);
+	INIT_LIST_HEAD(&wb->b_io);
+	INIT_LIST_HEAD(&wb->b_more_io);
+
+	return wb_assign_nr(bdi, wb);
+}
+
+static struct bdi_writeback *bdi_new_wb(struct backing_dev_info *bdi)
+{
+	struct bdi_writeback *wb;
+
+	/*
+	 * Default bdi->wb is already assigned, so just return it
+	 */
+	if (!test_and_set_bit(BDI_wb_alloc, &bdi->state))
+		wb = &bdi->wb;
+	else {
+		wb = kmalloc(sizeof(struct bdi_writeback), GFP_KERNEL);
+		if (wb) {
+			if (bdi_wb_init(wb, bdi)) {
+				kfree(wb);
+				wb = NULL;
+			}
+		}
+	}
+
+	return wb;
+}
+
+static void bdi_task_init(struct backing_dev_info *bdi,
+			  struct bdi_writeback *wb)
+{
+	struct task_struct *tsk = current;
+	int was_empty;
+
+	/*
+	 * Add us to the active bdi_list. If we are adding threads beyond
+	 * the default embedded bdi_writeback, then we need to start using
+	 * proper locking. Check the list for empty first, then set the
+	 * BDI_wblist_lock flag if there's > 1 entry on the list now
+	 */
+	spin_lock(&bdi->wb_lock);
+
+	was_empty = list_empty(&bdi->wb_list);
+	list_add_tail_rcu(&wb->list, &bdi->wb_list);
+	if (!was_empty)
+		set_bit(BDI_wblist_lock, &bdi->state);
+
+	spin_unlock(&bdi->wb_lock);
+
+	tsk->flags |= PF_FLUSHER | PF_SWAPWRITE;
+	set_freezable();
+
+	/*
+	 * Our parent may run at a different priority, just set us to normal
+	 */
+	set_user_nice(tsk, 0);
+}
+
+static int bdi_start_fn(void *ptr)
+{
+	struct bdi_writeback *wb = ptr;
+	struct backing_dev_info *bdi = wb->bdi;
+	int ret;
+
+	/*
+	 * Add us to the active bdi_list
+	 */
+	mutex_lock(&bdi_lock);
+	list_add(&bdi->bdi_list, &bdi_list);
+	mutex_unlock(&bdi_lock);
+
+	bdi_task_init(bdi, wb);
+
+	/*
+	 * Clear pending bit and wakeup anybody waiting to tear us down
+	 */
+	clear_bit(BDI_pending, &bdi->state);
+	smp_mb__after_clear_bit();
+	wake_up_bit(&bdi->state, BDI_pending);
+
+	ret = bdi_writeback_task(wb);
+
+	/*
+	 * Remove us from the list
+	 */
+	spin_lock(&bdi->wb_lock);
+	list_del_rcu(&wb->list);
+	spin_unlock(&bdi->wb_lock);
+
+	/*
+	 * wait for rcu grace period to end, so we can free wb
+	 */
+	synchronize_srcu(&bdi->srcu);
+
+	bdi_put_wb(bdi, wb);
+	return ret;
+}
+
+int bdi_has_dirty_io(struct backing_dev_info *bdi)
+{
+	struct bdi_writeback *wb;
+	int ret = 0;
+
+	if (!bdi_wblist_needs_lock(bdi))
+		ret = wb_has_dirty_io(&bdi->wb);
+	else {
+		int idx;
+
+		idx = srcu_read_lock(&bdi->srcu);
+
+		list_for_each_entry_rcu(wb, &bdi->wb_list, list) {
+			ret = wb_has_dirty_io(wb);
+			if (ret)
+				break;
+		}
+
+		srcu_read_unlock(&bdi->srcu, idx);
+	}
+
+	return ret;
+}
+
+static void bdi_flush_io(struct backing_dev_info *bdi)
+{
+	struct writeback_control wbc = {
+		.bdi			= bdi,
+		.sync_mode		= WB_SYNC_NONE,
+		.older_than_this	= NULL,
+		.range_cyclic		= 1,
+		.nr_to_write		= 1024,
+	};
+
+	generic_sync_bdi_inodes(NULL, &wbc);
+}
+
+static int bdi_forker_task(void *ptr)
+{
+	struct bdi_writeback *me = ptr;
+	DEFINE_WAIT(wait);
+
+	bdi_task_init(me->bdi, me);
+
+	for (;;) {
+		struct backing_dev_info *bdi, *tmp;
+		struct bdi_writeback *wb;
+
+		/*
+		 * Do this periodically, like kupdated() did before.
+		 */
+		sync_supers();
+
+		/*
+		 * Temporary measure, we want to make sure we don't see
+		 * dirty data on the default backing_dev_info
+		 */
+		if (wb_has_dirty_io(me) || !list_empty(&me->bdi->work_list))
+			wb_do_writeback(me);
+
+		prepare_to_wait(&me->wait, &wait, TASK_INTERRUPTIBLE);
+
+		mutex_lock(&bdi_lock);
+
+		/*
+		 * Check if any existing bdi's have dirty data without
+		 * a thread registered. If so, set that up.
+		 */
+		list_for_each_entry_safe(bdi, tmp, &bdi_list, bdi_list) {
+			if (bdi->wb.task || !bdi_has_dirty_io(bdi))
+				continue;
+
+			bdi_add_default_flusher_task(bdi);
+		}
+
+		if (list_empty(&bdi_pending_list)) {
+			unsigned long wait;
+
+			mutex_unlock(&bdi_lock);
+			wait = msecs_to_jiffies(dirty_writeback_interval * 10);
+			schedule_timeout(wait);
+			try_to_freeze();
+			continue;
+		}
+
+		/*
+		 * This is our real job - check for pending entries in
+		 * bdi_pending_list, and create the tasks that got added
+		 */
+		bdi = list_entry(bdi_pending_list.next, struct backing_dev_info,
+				 bdi_list);
+		list_del_init(&bdi->bdi_list);
+		mutex_unlock(&bdi_lock);
+
+		wb = bdi_new_wb(bdi);
+		if (!wb)
+			goto readd_flush;
+
+		wb->task = kthread_run(bdi_start_fn, wb, "bdi-%s",
+					dev_name(bdi->dev));
+
+		/*
+		 * If task creation fails, then readd the bdi to
+		 * the pending list and force writeout of the bdi
+		 * from this forker thread. That will free some memory
+		 * and we can try again.
+		 */
+		if (!wb->task) {
+			bdi_put_wb(bdi, wb);
+readd_flush:
+			/*
+			 * Add this 'bdi' to the back, so we get
+			 * a chance to flush other bdi's to free
+			 * memory.
+			 */
+			mutex_lock(&bdi_lock);
+			list_add_tail(&bdi->bdi_list, &bdi_pending_list);
+			mutex_unlock(&bdi_lock);
+
+			bdi_flush_io(bdi);
+		}
+	}
+
+	finish_wait(&me->wait, &wait);
+	return 0;
+}
+
+/*
+ * bdi_lock held on entry
+ */
+static void bdi_add_one_flusher_task(struct backing_dev_info *bdi,
+				     int(*func)(struct backing_dev_info *))
+{
+	if (!bdi_cap_writeback_dirty(bdi))
+		return;
+
+	if (WARN_ON(!test_bit(BDI_registered, &bdi->state))) {
+		printk("bdi %p/%s is not registered!\n", bdi, bdi->name);
+		return;
+	}
+
+	/*
+	 * Check with the helper whether to proceed adding a task. Will only
+	 * abort if we two or more simultanous calls to
+	 * bdi_add_default_flusher_task() occured, further additions will block
+	 * waiting for previous additions to finish.
+	 */
+	if (!func(bdi)) {
+		list_move_tail(&bdi->bdi_list, &bdi_pending_list);
+
+		/*
+		 * We are now on the pending list, wake up bdi_forker_task()
+		 * to finish the job and add us back to the active bdi_list
+		 */
+		wake_up(&default_backing_dev_info.wb.wait);
+	}
+}
+
+static int flusher_add_helper_block(struct backing_dev_info *bdi)
+{
+	mutex_unlock(&bdi_lock);
+	wait_on_bit_lock(&bdi->state, BDI_pending, bdi_sched_wait,
+				TASK_UNINTERRUPTIBLE);
+	mutex_lock(&bdi_lock);
+	return 0;
+}
+
+static int flusher_add_helper_test(struct backing_dev_info *bdi)
+{
+	return test_and_set_bit(BDI_pending, &bdi->state);
+}
+
+/*
+ * Add the default flusher task that gets created for any bdi
+ * that has dirty data pending writeout
+ */
+void bdi_add_default_flusher_task(struct backing_dev_info *bdi)
+{
+	bdi_add_one_flusher_task(bdi, flusher_add_helper_test);
+}
+
+/**
+ * bdi_add_flusher_task - add one more flusher task to this @bdi
+ *  @bdi:	the bdi
+ *
+ * Add an additional flusher task to this @bdi. Will block waiting on
+ * previous additions, if any.
+ *
+ */
+void bdi_add_flusher_task(struct backing_dev_info *bdi)
+{
+	mutex_lock(&bdi_lock);
+	bdi_add_one_flusher_task(bdi, flusher_add_helper_block);
+	mutex_unlock(&bdi_lock);
+}
+EXPORT_SYMBOL(bdi_add_flusher_task);
+
 int bdi_register(struct backing_dev_info *bdi, struct device *parent,
 		const char *fmt, ...)
 {
@@ -211,9 +585,41 @@ int bdi_register(struct backing_dev_info
 		goto exit;
 	}
 
+	mutex_lock(&bdi_lock);
+	list_add_tail(&bdi->bdi_list, &bdi_list);
+	mutex_unlock(&bdi_lock);
+
 	bdi->dev = dev;
-	bdi_debug_register(bdi, dev_name(dev));
 
+	/*
+	 * Just start the forker thread for our default backing_dev_info,
+	 * and add other bdi's to the list. They will get a thread created
+	 * on-demand when they need it.
+	 */
+	if (bdi_cap_flush_forker(bdi)) {
+		struct bdi_writeback *wb;
+
+		wb = bdi_new_wb(bdi);
+		if (!wb) {
+			ret = -ENOMEM;
+			goto remove_err;
+		}
+
+		wb->task = kthread_run(bdi_forker_task, wb, "bdi-%s",
+						dev_name(dev));
+		if (!wb->task) {
+			bdi_put_wb(bdi, wb);
+			ret = -ENOMEM;
+remove_err:
+			mutex_lock(&bdi_lock);
+			list_del(&bdi->bdi_list);
+			mutex_unlock(&bdi_lock);
+			goto exit;
+		}
+	}
+
+	bdi_debug_register(bdi, dev_name(dev));
+	set_bit(BDI_registered, &bdi->state);
 exit:
 	return ret;
 }
@@ -225,9 +631,42 @@ int bdi_register_dev(struct backing_dev_
 }
 EXPORT_SYMBOL(bdi_register_dev);
 
+/*
+ * Remove bdi from global list and shutdown any threads we have running
+ */
+static void bdi_wb_shutdown(struct backing_dev_info *bdi)
+{
+	struct bdi_writeback *wb;
+
+	if (!bdi_cap_writeback_dirty(bdi))
+		return;
+
+	/*
+	 * If setup is pending, wait for that to complete first
+	 */
+	wait_on_bit(&bdi->state, BDI_pending, bdi_sched_wait,
+			TASK_UNINTERRUPTIBLE);
+
+	/*
+	 * Make sure nobody finds us on the bdi_list anymore
+	 */
+	mutex_lock(&bdi_lock);
+	list_del(&bdi->bdi_list);
+	mutex_unlock(&bdi_lock);
+
+	/*
+	 * Finally, kill the kernel threads. We don't need to be RCU
+	 * safe anymore, since the bdi is gone from visibility.
+	 */
+	list_for_each_entry(wb, &bdi->wb_list, list)
+		kthread_stop(wb->task);
+}
+
 void bdi_unregister(struct backing_dev_info *bdi)
 {
 	if (bdi->dev) {
+		if (!bdi_cap_flush_forker(bdi))
+			bdi_wb_shutdown(bdi);
 		bdi_debug_unregister(bdi);
 		device_unregister(bdi->dev);
 		bdi->dev = NULL;
@@ -237,14 +676,21 @@ EXPORT_SYMBOL(bdi_unregister);
 
 int bdi_init(struct backing_dev_info *bdi)
 {
-	int i;
-	int err;
+	int i, err;
 
 	bdi->dev = NULL;
 
 	bdi->min_ratio = 0;
 	bdi->max_ratio = 100;
 	bdi->max_prop_frac = PROP_FRAC_BASE;
+	spin_lock_init(&bdi->wb_lock);
+	bdi->wb_mask = 0;
+	bdi->wb_cnt = 0;
+	INIT_LIST_HEAD(&bdi->bdi_list);
+	INIT_LIST_HEAD(&bdi->wb_list);
+	INIT_LIST_HEAD(&bdi->work_list);
+
+	bdi_wb_init(&bdi->wb, bdi);
 
 	for (i = 0; i < NR_BDI_STAT_ITEMS; i++) {
 		err = percpu_counter_init(&bdi->bdi_stat[i], 0);
@@ -252,10 +698,15 @@ int bdi_init(struct backing_dev_info *bd
 			goto err;
 	}
 
+	err = init_srcu_struct(&bdi->srcu);
+	if (err)
+		goto err;
+
 	bdi->dirty_exceeded = 0;
 	err = prop_local_init_percpu(&bdi->completions);
 
 	if (err) {
+		cleanup_srcu_struct(&bdi->srcu);
 err:
 		while (i--)
 			percpu_counter_destroy(&bdi->bdi_stat[i]);
@@ -269,8 +720,12 @@ void bdi_destroy(struct backing_dev_info
 {
 	int i;
 
+	WARN_ON(bdi_has_dirty_io(bdi));
+
 	bdi_unregister(bdi);
 
+	cleanup_srcu_struct(&bdi->srcu);
+
 	for (i = 0; i < NR_BDI_STAT_ITEMS; i++)
 		percpu_counter_destroy(&bdi->bdi_stat[i]);
 
diff -Nraup linux-2.6.30-rc6/mm/Makefile linux-2.6.30-rc6_bdiflusherv7/mm/Makefile
--- linux-2.6.30-rc6/mm/Makefile	2009-05-19 11:00:58.000000000 +0800
+++ linux-2.6.30-rc6_bdiflusherv7/mm/Makefile	2009-05-27 08:59:27.000000000 +0800
@@ -8,7 +8,7 @@ mmu-$(CONFIG_MMU)	:= fremap.o highmem.o 
 			   vmalloc.o
 
 obj-y			:= bootmem.o filemap.o mempool.o oom_kill.o fadvise.o \
-			   maccess.o page_alloc.o page-writeback.o pdflush.o \
+			   maccess.o page_alloc.o page-writeback.o \
 			   readahead.o swap.o truncate.o vmscan.o shmem.o \
 			   prio_tree.o util.o mmzone.o vmstat.o backing-dev.o \
 			   page_isolation.o mm_init.o $(mmu-y)
diff -Nraup linux-2.6.30-rc6/mm/page-writeback.c linux-2.6.30-rc6_bdiflusherv7/mm/page-writeback.c
--- linux-2.6.30-rc6/mm/page-writeback.c	2009-05-19 11:00:58.000000000 +0800
+++ linux-2.6.30-rc6_bdiflusherv7/mm/page-writeback.c	2009-05-27 09:05:08.000000000 +0800
@@ -36,15 +36,6 @@
 #include <linux/pagevec.h>
 
 /*
- * The maximum number of pages to writeout in a single bdflush/kupdate
- * operation.  We do this so we don't hold I_SYNC against an inode for
- * enormous amounts of time, which would block a userspace task which has
- * been forced to throttle against that inode.  Also, the code reevaluates
- * the dirty each time it has written this many pages.
- */
-#define MAX_WRITEBACK_PAGES	1024
-
-/*
  * After a CPU has dirtied this many pages, balance_dirty_pages_ratelimited
  * will look to see if it needs to force writeback or throttling.
  */
@@ -117,8 +108,6 @@ EXPORT_SYMBOL(laptop_mode);
 /* End of sysctl-exported parameters */
 
 
-static void background_writeout(unsigned long _min_pages);
-
 /*
  * Scale the writeback cache size proportional to the relative writeout speeds.
  *
@@ -319,15 +308,13 @@ static void task_dirty_limit(struct task
 /*
  *
  */
-static DEFINE_SPINLOCK(bdi_lock);
 static unsigned int bdi_min_ratio;
 
 int bdi_set_min_ratio(struct backing_dev_info *bdi, unsigned int min_ratio)
 {
 	int ret = 0;
-	unsigned long flags;
 
-	spin_lock_irqsave(&bdi_lock, flags);
+	mutex_lock(&bdi_lock);
 	if (min_ratio > bdi->max_ratio) {
 		ret = -EINVAL;
 	} else {
@@ -339,27 +326,26 @@ int bdi_set_min_ratio(struct backing_dev
 			ret = -EINVAL;
 		}
 	}
-	spin_unlock_irqrestore(&bdi_lock, flags);
+	mutex_unlock(&bdi_lock);
 
 	return ret;
 }
 
 int bdi_set_max_ratio(struct backing_dev_info *bdi, unsigned max_ratio)
 {
-	unsigned long flags;
 	int ret = 0;
 
 	if (max_ratio > 100)
 		return -EINVAL;
 
-	spin_lock_irqsave(&bdi_lock, flags);
+	mutex_lock(&bdi_lock);
 	if (bdi->min_ratio > max_ratio) {
 		ret = -EINVAL;
 	} else {
 		bdi->max_ratio = max_ratio;
 		bdi->max_prop_frac = (PROP_FRAC_BASE * max_ratio) / 100;
 	}
-	spin_unlock_irqrestore(&bdi_lock, flags);
+	mutex_unlock(&bdi_lock);
 
 	return ret;
 }
@@ -542,7 +528,7 @@ static void balance_dirty_pages(struct a
 		 * been flushed to permanent storage.
 		 */
 		if (bdi_nr_reclaimable) {
-			writeback_inodes(&wbc);
+			generic_sync_bdi_inodes(NULL, &wbc);
 			pages_written += write_chunk - wbc.nr_to_write;
 			get_dirty_limits(&background_thresh, &dirty_thresh,
 				       &bdi_thresh, bdi);
@@ -593,7 +579,7 @@ static void balance_dirty_pages(struct a
 			(!laptop_mode && (global_page_state(NR_FILE_DIRTY)
 					  + global_page_state(NR_UNSTABLE_NFS)
 					  > background_thresh)))
-		pdflush_operation(background_writeout, 0);
+		bdi_start_writeback(bdi, NULL, 0, WB_SYNC_NONE);
 }
 
 void set_page_dirty_balance(struct page *page, int page_mkwrite)
@@ -678,152 +664,34 @@ void throttle_vm_writeout(gfp_t gfp_mask
 }
 
 /*
- * writeback at least _min_pages, and keep writing until the amount of dirty
- * memory is less than the background threshold, or until we're all clean.
- */
-static void background_writeout(unsigned long _min_pages)
-{
-	long min_pages = _min_pages;
-	struct writeback_control wbc = {
-		.bdi		= NULL,
-		.sync_mode	= WB_SYNC_NONE,
-		.older_than_this = NULL,
-		.nr_to_write	= 0,
-		.nonblocking	= 1,
-		.range_cyclic	= 1,
-	};
-
-	for ( ; ; ) {
-		unsigned long background_thresh;
-		unsigned long dirty_thresh;
-
-		get_dirty_limits(&background_thresh, &dirty_thresh, NULL, NULL);
-		if (global_page_state(NR_FILE_DIRTY) +
-			global_page_state(NR_UNSTABLE_NFS) < background_thresh
-				&& min_pages <= 0)
-			break;
-		wbc.more_io = 0;
-		wbc.encountered_congestion = 0;
-		wbc.nr_to_write = MAX_WRITEBACK_PAGES;
-		wbc.pages_skipped = 0;
-		writeback_inodes(&wbc);
-		min_pages -= MAX_WRITEBACK_PAGES - wbc.nr_to_write;
-		if (wbc.nr_to_write > 0 || wbc.pages_skipped > 0) {
-			/* Wrote less than expected */
-			if (wbc.encountered_congestion || wbc.more_io)
-				congestion_wait(WRITE, HZ/10);
-			else
-				break;
-		}
-	}
-}
-
-/*
  * Start writeback of `nr_pages' pages.  If `nr_pages' is zero, write back
- * the whole world.  Returns 0 if a pdflush thread was dispatched.  Returns
- * -1 if all pdflush threads were busy.
+ * the whole world.
  */
-int wakeup_pdflush(long nr_pages)
+void wakeup_flusher_threads(long nr_pages)
 {
 	if (nr_pages == 0)
 		nr_pages = global_page_state(NR_FILE_DIRTY) +
 				global_page_state(NR_UNSTABLE_NFS);
-	return pdflush_operation(background_writeout, nr_pages);
+	bdi_writeback_all(NULL, nr_pages, WB_SYNC_NONE);
 }
 
-static void wb_timer_fn(unsigned long unused);
 static void laptop_timer_fn(unsigned long unused);
 
-static DEFINE_TIMER(wb_timer, wb_timer_fn, 0, 0);
 static DEFINE_TIMER(laptop_mode_wb_timer, laptop_timer_fn, 0, 0);
 
 /*
- * Periodic writeback of "old" data.
- *
- * Define "old": the first time one of an inode's pages is dirtied, we mark the
- * dirtying-time in the inode's address_space.  So this periodic writeback code
- * just walks the superblock inode list, writing back any inodes which are
- * older than a specific point in time.
- *
- * Try to run once per dirty_writeback_interval.  But if a writeback event
- * takes longer than a dirty_writeback_interval interval, then leave a
- * one-second gap.
- *
- * older_than_this takes precedence over nr_to_write.  So we'll only write back
- * all dirty pages if they are all attached to "old" mappings.
- */
-static void wb_kupdate(unsigned long arg)
-{
-	unsigned long oldest_jif;
-	unsigned long start_jif;
-	unsigned long next_jif;
-	long nr_to_write;
-	struct writeback_control wbc = {
-		.bdi		= NULL,
-		.sync_mode	= WB_SYNC_NONE,
-		.older_than_this = &oldest_jif,
-		.nr_to_write	= 0,
-		.nonblocking	= 1,
-		.for_kupdate	= 1,
-		.range_cyclic	= 1,
-	};
-
-	sync_supers();
-
-	oldest_jif = jiffies - msecs_to_jiffies(dirty_expire_interval);
-	start_jif = jiffies;
-	next_jif = start_jif + msecs_to_jiffies(dirty_writeback_interval * 10);
-	nr_to_write = global_page_state(NR_FILE_DIRTY) +
-			global_page_state(NR_UNSTABLE_NFS) +
-			(inodes_stat.nr_inodes - inodes_stat.nr_unused);
-	while (nr_to_write > 0) {
-		wbc.more_io = 0;
-		wbc.encountered_congestion = 0;
-		wbc.nr_to_write = MAX_WRITEBACK_PAGES;
-		writeback_inodes(&wbc);
-		if (wbc.nr_to_write > 0) {
-			if (wbc.encountered_congestion || wbc.more_io)
-				congestion_wait(WRITE, HZ/10);
-			else
-				break;	/* All the old data is written */
-		}
-		nr_to_write -= MAX_WRITEBACK_PAGES - wbc.nr_to_write;
-	}
-	if (time_before(next_jif, jiffies + HZ))
-		next_jif = jiffies + HZ;
-	if (dirty_writeback_interval)
-		mod_timer(&wb_timer, next_jif);
-}
-
-/*
  * sysctl handler for /proc/sys/vm/dirty_writeback_centisecs
  */
 int dirty_writeback_centisecs_handler(ctl_table *table, int write,
 	struct file *file, void __user *buffer, size_t *length, loff_t *ppos)
 {
 	proc_dointvec(table, write, file, buffer, length, ppos);
-	if (dirty_writeback_interval)
-		mod_timer(&wb_timer, jiffies +
-			msecs_to_jiffies(dirty_writeback_interval * 10));
-	else
-		del_timer(&wb_timer);
 	return 0;
 }
 
-static void wb_timer_fn(unsigned long unused)
-{
-	if (pdflush_operation(wb_kupdate, 0) < 0)
-		mod_timer(&wb_timer, jiffies + HZ); /* delay 1 second */
-}
-
-static void laptop_flush(unsigned long unused)
-{
-	sys_sync();
-}
-
 static void laptop_timer_fn(unsigned long unused)
 {
-	pdflush_operation(laptop_flush, 0);
+	wakeup_flusher_threads(0);
 }
 
 /*
@@ -906,8 +774,6 @@ void __init page_writeback_init(void)
 {
 	int shift;
 
-	mod_timer(&wb_timer,
-		  jiffies + msecs_to_jiffies(dirty_writeback_interval * 10));
 	writeback_set_ratelimit();
 	register_cpu_notifier(&ratelimit_nb);
 
diff -Nraup linux-2.6.30-rc6/mm/pdflush.c linux-2.6.30-rc6_bdiflusherv7/mm/pdflush.c
--- linux-2.6.30-rc6/mm/pdflush.c	2009-05-19 11:00:58.000000000 +0800
+++ linux-2.6.30-rc6_bdiflusherv7/mm/pdflush.c	1970-01-01 08:00:00.000000000 +0800
@@ -1,269 +0,0 @@
-/*
- * mm/pdflush.c - worker threads for writing back filesystem data
- *
- * Copyright (C) 2002, Linus Torvalds.
- *
- * 09Apr2002	Andrew Morton
- *		Initial version
- * 29Feb2004	kaos@sgi.com
- *		Move worker thread creation to kthread to avoid chewing
- *		up stack space with nested calls to kernel_thread.
- */
-
-#include <linux/sched.h>
-#include <linux/list.h>
-#include <linux/signal.h>
-#include <linux/spinlock.h>
-#include <linux/gfp.h>
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/fs.h>		/* Needed by writeback.h	  */
-#include <linux/writeback.h>	/* Prototypes pdflush_operation() */
-#include <linux/kthread.h>
-#include <linux/cpuset.h>
-#include <linux/freezer.h>
-
-
-/*
- * Minimum and maximum number of pdflush instances
- */
-#define MIN_PDFLUSH_THREADS	2
-#define MAX_PDFLUSH_THREADS	8
-
-static void start_one_pdflush_thread(void);
-
-
-/*
- * The pdflush threads are worker threads for writing back dirty data.
- * Ideally, we'd like one thread per active disk spindle.  But the disk
- * topology is very hard to divine at this level.   Instead, we take
- * care in various places to prevent more than one pdflush thread from
- * performing writeback against a single filesystem.  pdflush threads
- * have the PF_FLUSHER flag set in current->flags to aid in this.
- */
-
-/*
- * All the pdflush threads.  Protected by pdflush_lock
- */
-static LIST_HEAD(pdflush_list);
-static DEFINE_SPINLOCK(pdflush_lock);
-
-/*
- * The count of currently-running pdflush threads.  Protected
- * by pdflush_lock.
- *
- * Readable by sysctl, but not writable.  Published to userspace at
- * /proc/sys/vm/nr_pdflush_threads.
- */
-int nr_pdflush_threads = 0;
-
-/*
- * The time at which the pdflush thread pool last went empty
- */
-static unsigned long last_empty_jifs;
-
-/*
- * The pdflush thread.
- *
- * Thread pool management algorithm:
- * 
- * - The minimum and maximum number of pdflush instances are bound
- *   by MIN_PDFLUSH_THREADS and MAX_PDFLUSH_THREADS.
- * 
- * - If there have been no idle pdflush instances for 1 second, create
- *   a new one.
- * 
- * - If the least-recently-went-to-sleep pdflush thread has been asleep
- *   for more than one second, terminate a thread.
- */
-
-/*
- * A structure for passing work to a pdflush thread.  Also for passing
- * state information between pdflush threads.  Protected by pdflush_lock.
- */
-struct pdflush_work {
-	struct task_struct *who;	/* The thread */
-	void (*fn)(unsigned long);	/* A callback function */
-	unsigned long arg0;		/* An argument to the callback */
-	struct list_head list;		/* On pdflush_list, when idle */
-	unsigned long when_i_went_to_sleep;
-};
-
-static int __pdflush(struct pdflush_work *my_work)
-{
-	current->flags |= PF_FLUSHER | PF_SWAPWRITE;
-	set_freezable();
-	my_work->fn = NULL;
-	my_work->who = current;
-	INIT_LIST_HEAD(&my_work->list);
-
-	spin_lock_irq(&pdflush_lock);
-	for ( ; ; ) {
-		struct pdflush_work *pdf;
-
-		set_current_state(TASK_INTERRUPTIBLE);
-		list_move(&my_work->list, &pdflush_list);
-		my_work->when_i_went_to_sleep = jiffies;
-		spin_unlock_irq(&pdflush_lock);
-		schedule();
-		try_to_freeze();
-		spin_lock_irq(&pdflush_lock);
-		if (!list_empty(&my_work->list)) {
-			/*
-			 * Someone woke us up, but without removing our control
-			 * structure from the global list.  swsusp will do this
-			 * in try_to_freeze()->refrigerator().  Handle it.
-			 */
-			my_work->fn = NULL;
-			continue;
-		}
-		if (my_work->fn == NULL) {
-			printk("pdflush: bogus wakeup\n");
-			continue;
-		}
-		spin_unlock_irq(&pdflush_lock);
-
-		(*my_work->fn)(my_work->arg0);
-
-		spin_lock_irq(&pdflush_lock);
-
-		/*
-		 * Thread creation: For how long have there been zero
-		 * available threads?
-		 *
-		 * To throttle creation, we reset last_empty_jifs.
-		 */
-		if (time_after(jiffies, last_empty_jifs + 1 * HZ)) {
-			if (list_empty(&pdflush_list)) {
-				if (nr_pdflush_threads < MAX_PDFLUSH_THREADS) {
-					last_empty_jifs = jiffies;
-					nr_pdflush_threads++;
-					spin_unlock_irq(&pdflush_lock);
-					start_one_pdflush_thread();
-					spin_lock_irq(&pdflush_lock);
-				}
-			}
-		}
-
-		my_work->fn = NULL;
-
-		/*
-		 * Thread destruction: For how long has the sleepiest
-		 * thread slept?
-		 */
-		if (list_empty(&pdflush_list))
-			continue;
-		if (nr_pdflush_threads <= MIN_PDFLUSH_THREADS)
-			continue;
-		pdf = list_entry(pdflush_list.prev, struct pdflush_work, list);
-		if (time_after(jiffies, pdf->when_i_went_to_sleep + 1 * HZ)) {
-			/* Limit exit rate */
-			pdf->when_i_went_to_sleep = jiffies;
-			break;					/* exeunt */
-		}
-	}
-	nr_pdflush_threads--;
-	spin_unlock_irq(&pdflush_lock);
-	return 0;
-}
-
-/*
- * Of course, my_work wants to be just a local in __pdflush().  It is
- * separated out in this manner to hopefully prevent the compiler from
- * performing unfortunate optimisations against the auto variables.  Because
- * these are visible to other tasks and CPUs.  (No problem has actually
- * been observed.  This is just paranoia).
- */
-static int pdflush(void *dummy)
-{
-	struct pdflush_work my_work;
-	cpumask_var_t cpus_allowed;
-
-	/*
-	 * Since the caller doesn't even check kthread_run() worked, let's not
-	 * freak out too much if this fails.
-	 */
-	if (!alloc_cpumask_var(&cpus_allowed, GFP_KERNEL)) {
-		printk(KERN_WARNING "pdflush failed to allocate cpumask\n");
-		return 0;
-	}
-
-	/*
-	 * pdflush can spend a lot of time doing encryption via dm-crypt.  We
-	 * don't want to do that at keventd's priority.
-	 */
-	set_user_nice(current, 0);
-
-	/*
-	 * Some configs put our parent kthread in a limited cpuset,
-	 * which kthread() overrides, forcing cpus_allowed == cpu_all_mask.
-	 * Our needs are more modest - cut back to our cpusets cpus_allowed.
-	 * This is needed as pdflush's are dynamically created and destroyed.
-	 * The boottime pdflush's are easily placed w/o these 2 lines.
-	 */
-	cpuset_cpus_allowed(current, cpus_allowed);
-	set_cpus_allowed_ptr(current, cpus_allowed);
-	free_cpumask_var(cpus_allowed);
-
-	return __pdflush(&my_work);
-}
-
-/*
- * Attempt to wake up a pdflush thread, and get it to do some work for you.
- * Returns zero if it indeed managed to find a worker thread, and passed your
- * payload to it.
- */
-int pdflush_operation(void (*fn)(unsigned long), unsigned long arg0)
-{
-	unsigned long flags;
-	int ret = 0;
-
-	BUG_ON(fn == NULL);	/* Hard to diagnose if it's deferred */
-
-	spin_lock_irqsave(&pdflush_lock, flags);
-	if (list_empty(&pdflush_list)) {
-		ret = -1;
-	} else {
-		struct pdflush_work *pdf;
-
-		pdf = list_entry(pdflush_list.next, struct pdflush_work, list);
-		list_del_init(&pdf->list);
-		if (list_empty(&pdflush_list))
-			last_empty_jifs = jiffies;
-		pdf->fn = fn;
-		pdf->arg0 = arg0;
-		wake_up_process(pdf->who);
-	}
-	spin_unlock_irqrestore(&pdflush_lock, flags);
-
-	return ret;
-}
-
-static void start_one_pdflush_thread(void)
-{
-	struct task_struct *k;
-
-	k = kthread_run(pdflush, NULL, "pdflush");
-	if (unlikely(IS_ERR(k))) {
-		spin_lock_irq(&pdflush_lock);
-		nr_pdflush_threads--;
-		spin_unlock_irq(&pdflush_lock);
-	}
-}
-
-static int __init pdflush_init(void)
-{
-	int i;
-
-	/*
-	 * Pre-set nr_pdflush_threads...  If we fail to create,
-	 * the count will be decremented.
-	 */
-	nr_pdflush_threads = MIN_PDFLUSH_THREADS;
-
-	for (i = 0; i < MIN_PDFLUSH_THREADS; i++)
-		start_one_pdflush_thread();
-	return 0;
-}
-
-module_init(pdflush_init);
diff -Nraup linux-2.6.30-rc6/mm/swap_state.c linux-2.6.30-rc6_bdiflusherv7/mm/swap_state.c
--- linux-2.6.30-rc6/mm/swap_state.c	2009-05-19 11:00:28.000000000 +0800
+++ linux-2.6.30-rc6_bdiflusherv7/mm/swap_state.c	2009-05-27 08:59:27.000000000 +0800
@@ -34,6 +34,7 @@ static const struct address_space_operat
 };
 
 static struct backing_dev_info swap_backing_dev_info = {
+	.name		= "swap",
 	.capabilities	= BDI_CAP_NO_ACCT_AND_WRITEBACK | BDI_CAP_SWAP_BACKED,
 	.unplug_io_fn	= swap_unplug_io_fn,
 };
diff -Nraup linux-2.6.30-rc6/mm/vmscan.c linux-2.6.30-rc6_bdiflusherv7/mm/vmscan.c
--- linux-2.6.30-rc6/mm/vmscan.c	2009-05-19 11:00:58.000000000 +0800
+++ linux-2.6.30-rc6_bdiflusherv7/mm/vmscan.c	2009-05-27 08:59:27.000000000 +0800
@@ -1654,7 +1654,7 @@ static unsigned long do_try_to_free_page
 		 */
 		if (total_scanned > sc->swap_cluster_max +
 					sc->swap_cluster_max / 2) {
-			wakeup_pdflush(laptop_mode ? 0 : total_scanned);
+			wakeup_flusher_threads(laptop_mode ? 0 : total_scanned);
 			sc->may_writepage = 1;
 		}
 

--=-bsbuMAnxEHh8HvfgOLjE--

