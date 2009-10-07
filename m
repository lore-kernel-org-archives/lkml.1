Return-Path: <linux-kernel-owner+w=401wt.eu-S933949AbZJGIMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933949AbZJGIMK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:12:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933861AbZJGIME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:12:04 -0400
Received: from mga03.intel.com ([143.182.124.21]:1895 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933700AbZJGIBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:01:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,518,1249282800"; 
   d="scan'208";a="195971479"
Message-Id: <20091007074903.867171763@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 07 Oct 2009 15:38:39 +0800
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
Subject: [PATCH 21/45] writeback: estimate bdi write bandwidth
References: <20091007073818.318088777@intel.com>
Content-Disposition: inline; filename=writeback-throughput-estimation.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Estimate bdi write bandwidth in bdi_writeback_wakeup(), at which time
the queue is not starved due to the dirtying process and the associated
background writeback.

The estimation should be able to reflect the max device capability,
unless there are busy reads, in which case we need lower nr_to_write
anyway.

CC: Theodore Ts'o <tytso@mit.edu>
CC: Jan Kara <jack@suse.cz> 
CC: Peter Zijlstra <a.p.zijlstra@chello.nl> 
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---

TODO: the estimated write bandwidth (~30MB/s) is mysteriously only half the real
throughput (~60MB/s). Here are some debug printk from bdi_calc_write_bandwidth():

        printk("write_bandwidth: comm=%s pages=%lu time=%lums\n",
	               current->comm, nr_pages, time * 1000 / HZ);

[ 1093.397700] write_bandwidth: comm=swapper pages=1536 time=204ms
[ 1093.594319] write_bandwidth: comm=swapper pages=1536 time=196ms
[ 1093.796642] write_bandwidth: comm=swapper pages=1536 time=200ms
[ 1093.986128] write_bandwidth: comm=swapper pages=1536 time=192ms
[ 1094.179983] write_bandwidth: comm=swapper pages=1536 time=192ms
[ 1094.374021] write_bandwidth: comm=swapper pages=1536 time=196ms
[ 1094.570611] write_bandwidth: comm=swapper pages=1536 time=196ms
[ 1094.771847] write_bandwidth: comm=swapper pages=1536 time=200ms
[ 1094.961981] write_bandwidth: comm=swapper pages=1536 time=192ms

Workload is several concurrent copies.

 fs/fs-writeback.c           |   30 +++++++++++++++++++++---------
 include/linux/backing-dev.h |    2 ++
 include/linux/writeback.h   |   10 ++++++++++
 mm/backing-dev.c            |    2 ++
 4 files changed, 35 insertions(+), 9 deletions(-)

--- linux.orig/fs/fs-writeback.c	2009-10-06 23:38:43.000000000 +0800
+++ linux/fs/fs-writeback.c	2009-10-06 23:38:44.000000000 +0800
@@ -266,7 +266,23 @@ void bdi_start_writeback(struct backing_
 	bdi_alloc_queue_work(bdi, &args);
 }
 
+static int bdi_writeback_chunk(struct backing_dev_info *bdi)
+{
+	return max(MIN_WRITEBACK_PAGES, bdi->write_bandwidth);
+}
+
+static void bdi_calc_write_bandwidth(struct backing_dev_info *bdi,
+				     unsigned long nr_pages,
+				     unsigned long time)
+{
+	unsigned long bw;
+
+	bw = HZ * nr_pages / (time | 1);
+	bdi->write_bandwidth = (bdi->write_bandwidth * 63 + bw) / 64;
+}
+
 struct dirty_throttle_task {
+	unsigned long		start_time;
 	long			nr_pages;
 	struct list_head	list;
 	struct completion	complete;
@@ -275,6 +291,7 @@ struct dirty_throttle_task {
 void bdi_writeback_wait(struct backing_dev_info *bdi, long nr_pages)
 {
 	struct dirty_throttle_task tt = {
+		.start_time = jiffies,
 		.nr_pages = nr_pages,
 		.complete = COMPLETION_INITIALIZER_ONSTACK(tt.complete),
 	};
@@ -314,6 +331,9 @@ int bdi_writeback_wakeup(struct backing_
 		tt = list_entry(bdi->throttle_list.prev,
 				struct dirty_throttle_task, list);
 		list_del(&tt->list);
+		if (atomic_read(&bdi->throttle_pages) == 0)
+			bdi_calc_write_bandwidth(bdi, tt->nr_pages,
+						 jiffies - tt->start_time);
 		complete(&tt->complete);
 	}
 	/*
@@ -323,6 +343,7 @@ int bdi_writeback_wakeup(struct backing_
 		tt = list_entry(bdi->throttle_list.prev,
 				struct dirty_throttle_task, list);
 		atomic_set(&bdi->throttle_pages, tt->nr_pages);
+		tt->start_time = jiffies;
 	} else {
 		tt = NULL;
 		atomic_set(&bdi->throttle_pages, DIRTY_THROTTLE_PAGES_STOP * 2);
@@ -717,15 +738,6 @@ void writeback_inodes_wbc(struct writeba
 	writeback_inodes_wb(&bdi->wb, wbc);
 }
 
-/*
- * The maximum number of pages to writeout in a single bdi flush/kupdate
- * operation.  We do this so we don't hold I_SYNC against an inode for
- * enormous amounts of time, which would block a userspace task which has
- * been forced to throttle against that inode.  Also, the code reevaluates
- * the dirty each time it has written this many pages.
- */
-#define MAX_WRITEBACK_PAGES     1024
-
 static inline bool over_bground_thresh(void)
 {
 	unsigned long background_thresh, dirty_thresh;
--- linux.orig/include/linux/writeback.h	2009-10-06 23:37:46.000000000 +0800
+++ linux/include/linux/writeback.h	2009-10-06 23:38:44.000000000 +0800
@@ -14,6 +14,16 @@ extern struct list_head inode_in_use;
 extern struct list_head inode_unused;
 
 /*
+ * The max number of pages to writeout for each inode.
+ *
+ * We honor each inode a nr_to_write that will take about 1 second
+ * to finish, based on dynamic estimation of the bdi's write bandwidth.
+ * MAX_ serves as initial bandwidth value; MIN_ serves as low boundary.
+ */
+#define MAX_WRITEBACK_PAGES	(128 << (20 - PAGE_CACHE_SHIFT))
+#define MIN_WRITEBACK_PAGES	( 16 << (20 - PAGE_CACHE_SHIFT))
+
+/*
  * fs/fs-writeback.c
  */
 enum writeback_sync_modes {
--- linux.orig/include/linux/backing-dev.h	2009-10-06 23:38:43.000000000 +0800
+++ linux/include/linux/backing-dev.h	2009-10-06 23:38:44.000000000 +0800
@@ -86,6 +86,8 @@ struct backing_dev_info {
 
 	struct list_head work_list;
 
+	int write_bandwidth;	/* pages per second */
+
 	/*
 	 * dirtier process throttling
 	 */
--- linux.orig/mm/backing-dev.c	2009-10-06 23:38:43.000000000 +0800
+++ linux/mm/backing-dev.c	2009-10-06 23:38:44.000000000 +0800
@@ -646,6 +646,8 @@ int bdi_init(struct backing_dev_info *bd
 	bdi->wb_mask = 1;
 	bdi->wb_cnt = 1;
 
+	bdi->write_bandwidth = MAX_WRITEBACK_PAGES;
+
 	spin_lock_init(&bdi->throttle_lock);
 	INIT_LIST_HEAD(&bdi->throttle_list);
 	atomic_set(&bdi->throttle_pages, DIRTY_THROTTLE_PAGES_STOP * 2);


