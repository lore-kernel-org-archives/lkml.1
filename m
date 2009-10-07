Return-Path: <linux-kernel-owner+w=401wt.eu-S933023AbZJGIAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933023AbZJGIAp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:00:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932902AbZJGIAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:00:45 -0400
Received: from mga14.intel.com ([143.182.124.37]:35820 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932868AbZJGIAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:00:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,518,1249282800"; 
   d="scan'208";a="195971241"
Message-Id: <20091007074903.422089703@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 07 Oct 2009 15:38:36 +0800
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
Subject: [PATCH 18/45] writeback: introduce wait queue for balance_dirty_pages()
References: <20091007073818.318088777@intel.com>
Content-Disposition: inline; filename=writeback-balance-wait-queue.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As proposed by Chris, Dave and Jan, let balance_dirty_pages() wait for
the per-bdi flusher to writeback enough pages for it, instead of
starting foreground writeback by itself. By doing so we harvest two
benefits:
- avoid concurrent writeback of multiple inodes (Dave Chinner)
  If every thread doing writes and being throttled start foreground
  writeback, it leads to N IO submitters from at least N different
  inodes at the same time, end up with N different sets of IO being
  issued with potentially zero locality to each other, resulting in
  much lower elevator sort/merge efficiency and hence we seek the disk
  all over the place to service the different sets of IO.
  OTOH, if there is only one submission thread, it doesn't jump between
  inodes in the same way when congestion clears - it keeps writing to
  the same inode, resulting in large related chunks of sequential IOs
  being issued to the disk. This is more efficient than the above
  foreground writeback because the elevator works better and the disk
  seeks less.
- avoid one constraint torwards huge per-file nr_to_write
  The write_chunk used by balance_dirty_pages() should be small enough to
  prevent user noticeable one-shot latency. Ie. each sleep/wait inside
  balance_dirty_pages() shall be small enough. When it starts its own
  writeback, it must specify a small nr_to_write. The throttle wait queue
  removes this dependancy by the way.

CC: Chris Mason <chris.mason@oracle.com> 
CC: Dave Chinner <david@fromorbit.com> 
CC: Jan Kara <jack@suse.cz> 
CC: Peter Zijlstra <a.p.zijlstra@chello.nl> 
CC: Jens Axboe <jens.axboe@oracle.com> 
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c           |   71 ++++++++++++++++++++++++++++++++++
 include/linux/backing-dev.h |   15 +++++++
 mm/backing-dev.c            |    4 +
 mm/page-writeback.c         |   53 ++++++-------------------
 4 files changed, 103 insertions(+), 40 deletions(-)

--- linux.orig/mm/page-writeback.c	2009-10-06 23:38:30.000000000 +0800
+++ linux/mm/page-writeback.c	2009-10-06 23:38:43.000000000 +0800
@@ -218,6 +218,15 @@ static inline void __bdi_writeout_inc(st
 {
 	__prop_inc_percpu_max(&vm_completions, &bdi->completions,
 			      bdi->max_prop_frac);
+
+	/*
+	 * The DIRTY_THROTTLE_PAGES_STOP test is an optional optimization, so
+	 * it's OK to be racy. We set DIRTY_THROTTLE_PAGES_STOP*2 in other
+	 * places to reduce the race possibility.
+	 */
+	if (atomic_read(&bdi->throttle_pages) < DIRTY_THROTTLE_PAGES_STOP &&
+	    atomic_dec_and_test(&bdi->throttle_pages))
+		bdi_writeback_wakeup(bdi);
 }
 
 void bdi_writeout_inc(struct backing_dev_info *bdi)
@@ -458,20 +467,10 @@ static void balance_dirty_pages(struct a
 	unsigned long background_thresh;
 	unsigned long dirty_thresh;
 	unsigned long bdi_thresh;
-	unsigned long pages_written = 0;
-	unsigned long pause = 1;
 	int dirty_exceeded;
 	struct backing_dev_info *bdi = mapping->backing_dev_info;
 
 	for (;;) {
-		struct writeback_control wbc = {
-			.bdi		= bdi,
-			.sync_mode	= WB_SYNC_NONE,
-			.older_than_this = NULL,
-			.nr_to_write	= write_chunk,
-			.range_cyclic	= 1,
-		};
-
 		nr_reclaimable = global_page_state(NR_FILE_DIRTY) +
 				 global_page_state(NR_UNSTABLE_NFS);
 		nr_writeback = global_page_state(NR_WRITEBACK) +
@@ -518,39 +517,13 @@ static void balance_dirty_pages(struct a
 		if (!bdi->dirty_exceeded)
 			bdi->dirty_exceeded = 1;
 
-		/* Note: nr_reclaimable denotes nr_dirty + nr_unstable.
-		 * Unstable writes are a feature of certain networked
-		 * filesystems (i.e. NFS) in which data may have been
-		 * written to the server's write cache, but has not yet
-		 * been flushed to permanent storage.
-		 * Only move pages to writeback if this bdi is over its
-		 * threshold otherwise wait until the disk writes catch
-		 * up.
-		 */
-		if (bdi_nr_reclaimable > bdi_thresh) {
-			writeback_inodes_wbc(&wbc);
-			pages_written += write_chunk - wbc.nr_to_write;
-			/* don't wait if we've done enough */
-			if (pages_written >= write_chunk)
-				break;
-		}
-		schedule_timeout_interruptible(pause);
-
-		/*
-		 * Increase the delay for each loop, up to our previous
-		 * default of taking a 100ms nap.
-		 */
-		pause <<= 1;
-		if (pause > HZ / 10)
-			pause = HZ / 10;
+		bdi_writeback_wait(bdi, write_chunk);
+		break;
 	}
 
 	if (!dirty_exceeded && bdi->dirty_exceeded)
 		bdi->dirty_exceeded = 0;
 
-	if (writeback_in_progress(bdi))
-		return;
-
 	/*
 	 * In laptop mode, we wait until hitting the higher threshold before
 	 * starting background writeout, and then write out all the way down
@@ -559,8 +532,8 @@ static void balance_dirty_pages(struct a
 	 * In normal mode, we start background writeout at the lower
 	 * background_thresh, to keep the amount of dirty memory low.
 	 */
-	if ((laptop_mode && pages_written) ||
-	    (!laptop_mode && (nr_reclaimable > background_thresh)))
+	if (!laptop_mode && (nr_reclaimable > background_thresh) &&
+	    can_submit_background_writeback(bdi))
 		bdi_start_writeback(bdi, NULL, 0);
 }
 
--- linux.orig/include/linux/backing-dev.h	2009-10-06 23:38:43.000000000 +0800
+++ linux/include/linux/backing-dev.h	2009-10-06 23:38:43.000000000 +0800
@@ -86,6 +86,13 @@ struct backing_dev_info {
 
 	struct list_head work_list;
 
+	/*
+	 * dirtier process throttling
+	 */
+	spinlock_t		throttle_lock;
+	struct list_head	throttle_list;	/* nr to sync for each task */
+	atomic_t		throttle_pages; /* nr to sync for head task */
+
 	struct device *dev;
 
 #ifdef CONFIG_DEBUG_FS
@@ -99,6 +106,12 @@ struct backing_dev_info {
  */
 #define WB_FLAG_BACKGROUND_WORK		30
 
+/*
+ * when no task is throttled, set throttle_pages to larger than this,
+ * to avoid unnecessary atomic decreases.
+ */
+#define DIRTY_THROTTLE_PAGES_STOP	(1 << 22)
+
 int bdi_init(struct backing_dev_info *bdi);
 void bdi_destroy(struct backing_dev_info *bdi);
 
@@ -110,6 +123,8 @@ void bdi_start_writeback(struct backing_
 				long nr_pages);
 int bdi_writeback_task(struct bdi_writeback *wb);
 int bdi_has_dirty_io(struct backing_dev_info *bdi);
+int bdi_writeback_wakeup(struct backing_dev_info *bdi);
+void bdi_writeback_wait(struct backing_dev_info *bdi, long nr_pages);
 
 extern spinlock_t bdi_lock;
 extern struct list_head bdi_list;
--- linux.orig/fs/fs-writeback.c	2009-10-06 23:38:43.000000000 +0800
+++ linux/fs/fs-writeback.c	2009-10-06 23:38:43.000000000 +0800
@@ -25,6 +25,7 @@
 #include <linux/blkdev.h>
 #include <linux/backing-dev.h>
 #include <linux/buffer_head.h>
+#include <linux/completion.h>
 #include "internal.h"
 
 #define inode_to_bdi(inode)	((inode)->i_mapping->backing_dev_info)
@@ -265,6 +266,72 @@ void bdi_start_writeback(struct backing_
 	bdi_alloc_queue_work(bdi, &args);
 }
 
+struct dirty_throttle_task {
+	long			nr_pages;
+	struct list_head	list;
+	struct completion	complete;
+};
+
+void bdi_writeback_wait(struct backing_dev_info *bdi, long nr_pages)
+{
+	struct dirty_throttle_task tt = {
+		.nr_pages = nr_pages,
+		.complete = COMPLETION_INITIALIZER_ONSTACK(tt.complete),
+	};
+	unsigned long flags;
+
+	/*
+	 * register throttle pages
+	 */
+	spin_lock_irqsave(&bdi->throttle_lock, flags);
+	if (list_empty(&bdi->throttle_list))
+		atomic_set(&bdi->throttle_pages, nr_pages);
+	list_add(&tt.list, &bdi->throttle_list);
+	spin_unlock_irqrestore(&bdi->throttle_lock, flags);
+
+	/*
+	 * make sure we will be woke up by someone
+	 */
+	if (can_submit_background_writeback(bdi))
+		bdi_start_writeback(bdi, NULL, 0);
+
+	wait_for_completion(&tt.complete);
+}
+
+/*
+ * return 1 if there are more waiting tasks.
+ */
+int bdi_writeback_wakeup(struct backing_dev_info *bdi)
+{
+	struct dirty_throttle_task *tt;
+	unsigned long flags;
+
+	spin_lock_irqsave(&bdi->throttle_lock, flags);
+	/*
+	 * remove and wakeup head task
+	 */
+	if (!list_empty(&bdi->throttle_list)) {
+		tt = list_entry(bdi->throttle_list.prev,
+				struct dirty_throttle_task, list);
+		list_del(&tt->list);
+		complete(&tt->complete);
+	}
+	/*
+	 * update throttle pages
+	 */
+	if (!list_empty(&bdi->throttle_list)) {
+		tt = list_entry(bdi->throttle_list.prev,
+				struct dirty_throttle_task, list);
+		atomic_set(&bdi->throttle_pages, tt->nr_pages);
+	} else {
+		tt = NULL;
+		atomic_set(&bdi->throttle_pages, DIRTY_THROTTLE_PAGES_STOP * 2);
+	}
+	spin_unlock_irqrestore(&bdi->throttle_lock, flags);
+
+	return tt != NULL;
+}
+
 /*
  * Redirty an inode: set its when-it-was dirtied timestamp and move it to the
  * furthest end of its superblock's dirty-inode list.
@@ -760,6 +827,10 @@ static long wb_writeback(struct bdi_writ
 		spin_unlock(&inode_lock);
 	}
 
+	if (args->for_background)
+		while (bdi_writeback_wakeup(wb->bdi))
+			;  /* unthrottle all tasks */
+
 	return wrote;
 }
 
--- linux.orig/mm/backing-dev.c	2009-10-06 23:37:47.000000000 +0800
+++ linux/mm/backing-dev.c	2009-10-06 23:38:43.000000000 +0800
@@ -646,6 +646,10 @@ int bdi_init(struct backing_dev_info *bd
 	bdi->wb_mask = 1;
 	bdi->wb_cnt = 1;
 
+	spin_lock_init(&bdi->throttle_lock);
+	INIT_LIST_HEAD(&bdi->throttle_list);
+	atomic_set(&bdi->throttle_pages, DIRTY_THROTTLE_PAGES_STOP * 2);
+
 	for (i = 0; i < NR_BDI_STAT_ITEMS; i++) {
 		err = percpu_counter_init(&bdi->bdi_stat[i], 0);
 		if (err)


