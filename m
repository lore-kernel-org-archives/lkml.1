Return-Path: <linux-kernel-owner+w=401wt.eu-S934091AbZJGID2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934091AbZJGID2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:03:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932598AbZJGIDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:03:16 -0400
Received: from mga03.intel.com ([143.182.124.21]:28327 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934085AbZJGIDK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:03:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,518,1249282800"; 
   d="scan'208";a="195972048"
Message-Id: <20091007074906.108562976@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 07 Oct 2009 15:38:56 +0800
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
       <linux-fsdevel@vger.kernel.org>, David Chinner <dgc@sgi.com>,
       Michael Rubin <mrubin@google.com>,
       Peter Zijlstra <peterz@infradead.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 38/45] writeback: introduce queue b_more_io_wait
References: <20091007073818.318088777@intel.com>
Content-Disposition: inline; filename=writeback-more_io_wait.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce the b_more_io_wait queue to park inodes that for some reason
cannot be synced immediately. They will be revisited either in the next
b_io scan time, or after 0.1s sleep for sync, or retried after 5s in the
next periodic writeback.

The new data flow after this patchset:

b_dirty --> b_io --> b_more_io/b_more_io_wait --+
             ^                                  |
	     |                                  |
	     +----------------------------------+

The rational is to address two issues:
- the 30s delay of redirty_tail() may be too long
- redirty_tail() may update i_dirtied_when, however we now rely on it
  remain unchanged for all candidate inodes of sync(). (to avoid extra
  work and livelock, we now exclude any inodes from being synced if its
  dirty time is after the sync time)

Cc: Jan Kara <jack@suse.cz> 
Cc: David Chinner <dgc@sgi.com>
Cc: Michael Rubin <mrubin@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 fs/fs-writeback.c           |   27 ++++++++++++++++-----------
 include/linux/backing-dev.h |    8 +++++---
 mm/backing-dev.c            |   14 +++++++++++---
 3 files changed, 32 insertions(+), 17 deletions(-)

--- linux.orig/fs/fs-writeback.c	2009-10-07 14:31:47.000000000 +0800
+++ linux/fs/fs-writeback.c	2009-10-07 14:32:50.000000000 +0800
@@ -384,6 +384,16 @@ static void requeue_io(struct inode *ino
 	list_move(&inode->i_list, &wb->b_more_io);
 }
 
+/*
+ * The inode should be retried in an opportunistic way.
+ */
+static void requeue_io_wait(struct inode *inode)
+{
+	struct bdi_writeback *wb = &inode_to_bdi(inode)->wb;
+
+	list_move(&inode->i_list, &wb->b_more_io_wait);
+}
+
 static void inode_sync_complete(struct inode *inode)
 {
 	/*
@@ -453,12 +463,14 @@ static void move_expired_inodes(struct l
 /*
  * Queue all expired dirty inodes for io, eldest first:
  * (newly dirtied) => b_dirty inodes
+ *                 => b_more_io_wait inodes
  *                 => b_more_io inodes
  *                 => remaining inodes in b_io => (dequeue for sync)
  */
 static void queue_io(struct bdi_writeback *wb, unsigned long *older_than_this)
 {
 	list_splice_init(&wb->b_more_io, &wb->b_io);
+	list_splice_init(&wb->b_more_io_wait, &wb->b_io);
 	move_expired_inodes(&wb->b_dirty, &wb->b_io, older_than_this);
 }
 
@@ -860,18 +872,11 @@ static long wb_writeback(struct bdi_writ
 		 */
 		if (nr)
 			continue;
-		/*
-		 * Nothing written. Wait for some inode to
-		 * become available for writeback. Otherwise
-		 * we'll just busyloop.
-		 */
-		spin_lock(&inode_lock);
-		if (!list_empty(&wb->b_more_io))  {
-			inode = list_entry(wb->b_more_io.prev,
-						struct inode, i_list);
-			inode_wait_for_writeback(inode);
+		if (wbc.for_sync && !list_empty(&wb->b_more_io_wait)) {
+			schedule_timeout_interruptible(HZ/10);
+			continue;
 		}
-		spin_unlock(&inode_lock);
+		break;
 	}
 
 	if (args->for_sync)
--- linux.orig/include/linux/backing-dev.h	2009-10-07 14:32:46.000000000 +0800
+++ linux/include/linux/backing-dev.h	2009-10-07 14:32:50.000000000 +0800
@@ -56,6 +56,7 @@ struct bdi_writeback {
 	struct list_head	b_dirty;	/* dirty inodes */
 	struct list_head	b_io;		/* parked for writeback */
 	struct list_head	b_more_io;	/* parked for more writeback */
+	struct list_head	b_more_io_wait;	/* opportunistic retry io */
 };
 
 struct backing_dev_info {
@@ -140,9 +141,10 @@ extern struct list_head bdi_list;
 
 static inline int wb_has_dirty_io(struct bdi_writeback *wb)
 {
-	return !list_empty(&wb->b_dirty) ||
-	       !list_empty(&wb->b_io) ||
-	       !list_empty(&wb->b_more_io);
+	return !list_empty(&wb->b_dirty)	||
+	       !list_empty(&wb->b_io)		||
+	       !list_empty(&wb->b_more_io)	||
+	       !list_empty(&wb->b_more_io_wait);
 }
 
 static inline void __add_bdi_stat(struct backing_dev_info *bdi,
--- linux.orig/mm/backing-dev.c	2009-10-07 14:32:46.000000000 +0800
+++ linux/mm/backing-dev.c	2009-10-07 14:32:50.000000000 +0800
@@ -63,14 +63,17 @@ static int bdi_debug_stats_show(struct s
 	unsigned long background_thresh;
 	unsigned long dirty_thresh;
 	unsigned long bdi_thresh;
-	unsigned long nr_dirty, nr_io, nr_more_io, nr_wb;
+	unsigned long nr_dirty		= 0;
+	unsigned long nr_io		= 0;
+	unsigned long nr_more_io	= 0;
+	unsigned long nr_more_io_wait	= 0;
+	unsigned long nr_wb		= 0;
 	struct inode *inode;
 
 	/*
 	 * inode lock is enough here, the bdi->wb_list is protected by
 	 * RCU on the reader side
 	 */
-	nr_wb = nr_dirty = nr_io = nr_more_io = 0;
 	spin_lock(&inode_lock);
 	list_for_each_entry(wb, &bdi->wb_list, list) {
 		nr_wb++;
@@ -80,6 +83,8 @@ static int bdi_debug_stats_show(struct s
 			nr_io++;
 		list_for_each_entry(inode, &wb->b_more_io, i_list)
 			nr_more_io++;
+		list_for_each_entry(inode, &wb->b_more_io_wait, i_list)
+			nr_more_io_wait++;
 	}
 	spin_unlock(&inode_lock);
 
@@ -98,6 +103,7 @@ static int bdi_debug_stats_show(struct s
 		   "b_dirty:          %8lu\n"
 		   "b_io:             %8lu\n"
 		   "b_more_io:        %8lu\n"
+		   "b_more_io_wait:   %8lu\n"
 		   "bdi_list:         %8u\n"
 		   "state:            %8lx\n"
 		   "wb_mask:          %8lx\n"
@@ -107,7 +113,7 @@ static int bdi_debug_stats_show(struct s
 		   (unsigned long) K(bdi_stat(bdi, BDI_RECLAIMABLE)),
 		   K(bdi_thresh), K(dirty_thresh), K(background_thresh),
 		   (unsigned long) K(bdi->write_bandwidth),
-		   nr_wb, nr_dirty, nr_io, nr_more_io,
+		   nr_wb, nr_dirty, nr_io, nr_more_io, nr_more_io_wait,
 		   !list_empty(&bdi->bdi_list), bdi->state, bdi->wb_mask,
 		   !list_empty(&bdi->wb_list), bdi->wb_cnt);
 #undef K
@@ -264,6 +270,7 @@ static void bdi_wb_init(struct bdi_write
 	INIT_LIST_HEAD(&wb->b_dirty);
 	INIT_LIST_HEAD(&wb->b_io);
 	INIT_LIST_HEAD(&wb->b_more_io);
+	INIT_LIST_HEAD(&wb->b_more_io_wait);
 }
 
 static void bdi_task_init(struct backing_dev_info *bdi,
@@ -688,6 +695,7 @@ void bdi_destroy(struct backing_dev_info
 		list_splice(&bdi->wb.b_dirty, &dst->b_dirty);
 		list_splice(&bdi->wb.b_io, &dst->b_io);
 		list_splice(&bdi->wb.b_more_io, &dst->b_more_io);
+		list_splice(&bdi->wb.b_more_io_wait, &dst->b_more_io_wait);
 		spin_unlock(&inode_lock);
 	}
 


