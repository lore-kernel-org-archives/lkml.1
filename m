Return-Path: <linux-kernel-owner+w=401wt.eu-S1753906AbZI3BYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbZI3BYR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 21:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753816AbZI3BYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 21:24:16 -0400
Received: from mga03.intel.com ([143.182.124.21]:59961 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752562AbZI3BYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 21:24:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,476,1249282800"; 
   d="scan'208";a="193236475"
Date: Wed, 30 Sep 2009 09:24:06 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Chris Mason <chris.mason@oracle.com>,
       Artem Bityutskiy <dedekind1@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "david@fromorbit.com" <david@fromorbit.com>,
       "hch@infradead.org" <hch@infradead.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH 8/8] vm: Add an tuning knob for vm.max_writeback_mb
Message-ID: <20090930012406.GB6311@localhost>
References: <1252428983.7746.140.camel@twins> <20090908172842.GC2975@think> <1252431974.7746.151.camel@twins> <1252432501.7746.156.camel@twins> <1252434746.7035.7.camel@laptop> <20090909142315.GA7949@duck.suse.cz> <1252597750.7205.82.camel@laptop> <20090914111721.GA24075@duck.suse.cz> <20090924083342.GA15918@localhost> <20090929173506.GE11573@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090929173506.GE11573@duck.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 30, 2009 at 01:35:06AM +0800, Jan Kara wrote:
> On Thu 24-09-09 16:33:42, Wu Fengguang wrote:
> > On Mon, Sep 14, 2009 at 07:17:21PM +0800, Jan Kara wrote:
> > > On Thu 10-09-09 17:49:10, Peter Zijlstra wrote:
> > > > On Wed, 2009-09-09 at 16:23 +0200, Jan Kara wrote:
> > > > >   Well, what I imagined we could do is:
> > > > > Have a per-bdi variable 'pages_written' - that would reflect the amount of
> > > > > pages written to the bdi since boot (OK, we'd have to handle overflows but
> > > > > that's doable).
> > > > > 
> > > > > There will be a per-bdi variable 'pages_waited'. When a thread should sleep
> > > > > in balance_dirty_pages() because we are over limits, it kicks writeback thread
> > > > > and does:
> > > > >   to_wait =  max(pages_waited, pages_written) + sync_dirty_pages() (or
> > > > > whatever number we decide)
> > > > >   pages_waited = to_wait
> > > > >   sleep until pages_written reaches to_wait or we drop below dirty limits.
> > > > > 
> > > > > That will make sure each thread will sleep until writeback threads have done
> > > > > their duty for the writing thread.
> > > > > 
> > > > > If we make sure sleeping threads are properly ordered on the wait queue,
> > > > > we could always wakeup just the first one and thus avoid the herding
> > > > > effect. When we drop below dirty limits, we would just wakeup the whole
> > > > > waitqueue.
> > > > > 
> > > > > Does this sound reasonable?
> > > > 
> > > > That seems to go wrong when there's multiple tasks waiting on the same
> > > > bdi, you'd count each page for 1/n its weight.
> > > > 
> > > > Suppose pages_written = 1024, and 4 tasks block and compute their to
> > > > wait as pages_written + 256 = 1280, then we'd release all 4 of them
> > > > after 256 pages are written, instead of 4*256, which would be
> > > > pages_written = 2048.
> > >   Well, there's some locking needed of course. The intent is to stack
> > > demands as they come. So in case pages_written = 1024, pages_waited = 1024
> > > we would do:
> > > THREAD 1:
> > > 
> > > spin_lock
> > > to_wait = 1024 + 256
> > > pages_waited = 1280
> > > spin_unlock
> > > 
> > > THREAD 2:
> > > 
> > > spin_lock
> > > to_wait = 1280 + 256
> > > pages_waited = 1536
> > > spin_unlock
> > > 
> > >   So weight of each page will be kept. The fact that second thread
> > > effectively waits until the first thread has its demand satisfied looks
> > > strange at the first sight but we don't do better currently and I think
> > > it's fine - if they were two writer threads, then soon the thread released
> > > first will queue behind the thread still waiting so long term the behavior
> > > should be fair.
> > 
> > Yeah, FIFO queuing should be good enough.
> > 
> > I'd like to propose one more data structure for evaluation :)
> > 
> > - bdi->throttle_lock
> > - bdi->throttle_list    pages to sync for each waiting task, taken from sync_writeback_pages()
> > - bdi->throttle_pages   (counted down) pages to sync for the head task, shall be atomic_t
> > 
> > In balance_dirty_pages(), it would do
> > 
> >         nr_to_sync = sync_writeback_pages()
> >         if (list_empty(bdi->throttle_list))  # I'm the only task
> >                 bdi->throttle_pages = nr_to_sync
> >         append nr_to_sync to bdi->throttle_list
> >         kick off background writeback
> >         wait
> >         remove itself from bdi->throttle_list and wait list
> >         set bdi->throttle_pages for new head task (or LONG_MAX)
> > 
> > In __bdi_writeout_inc(), it would do
> > 
> >         if (--bdi->throttle_pages <= 0)
> >                 check and wake up head task
>   Yeah, this would work as well. I don't see a big difference between my
> approach and this so if you get to implementing this, I'm happy :).

Thanks. Here is a prototype implementation for preview :)

> > In wb_writeback(), it would do
> > 
> >         if (args->for_background && exiting)
> >                 wake up all throttled tasks
> > To prevent wake up too many tasks at the same time, it can relax the
> > background threshold a bit, so that __bdi_writeout_inc() become the
> > only wake up point in normal cases.
> > 
> >         if (args->for_background && !list_empty(bdi->throttle_list) &&
> >                 over background_thresh - background_thresh / 32)
> >                 keep write pages;
>   We want to wakeup tasks when we get below dirty_limit (either global
> or per-bdi). Not when we get below background threshold...

I did a trick to add one bdi work from each waiting task, and remove
them when the task is waked up :)

Thanks,
Fengguang

---
writeback: let balance_dirty_pages() wait on background writeback

CC: Chris Mason <chris.mason@oracle.com> 
CC: Dave Chinner <david@fromorbit.com> 
CC: Jan Kara <jack@suse.cz> 
CC: Peter Zijlstra <a.p.zijlstra@chello.nl> 
CC: Jens Axboe <jens.axboe@oracle.com> 
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c           |   89 ++++++++++++++++++++++++++++++++--
 include/linux/backing-dev.h |   15 +++++
 mm/backing-dev.c            |    4 +
 mm/page-writeback.c         |   43 ++--------------
 4 files changed, 109 insertions(+), 42 deletions(-)

--- linux.orig/mm/page-writeback.c	2009-09-28 19:01:40.000000000 +0800
+++ linux/mm/page-writeback.c	2009-09-28 19:02:48.000000000 +0800
@@ -218,6 +218,10 @@ static inline void __bdi_writeout_inc(st
 {
 	__prop_inc_percpu_max(&vm_completions, &bdi->completions,
 			      bdi->max_prop_frac);
+
+	if (atomic_read(&bdi->throttle_pages) < DIRTY_THROTTLE_PAGES_STOP &&
+	    atomic_dec_and_test(&bdi->throttle_pages))
+		bdi_writeback_wakeup(bdi);
 }
 
 void bdi_writeout_inc(struct backing_dev_info *bdi)
@@ -458,20 +462,10 @@ static void balance_dirty_pages(struct a
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
@@ -518,31 +512,7 @@ static void balance_dirty_pages(struct a
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
 	}
 
 	if (!dirty_exceeded && bdi->dirty_exceeded)
@@ -559,8 +529,7 @@ static void balance_dirty_pages(struct a
 	 * In normal mode, we start background writeout at the lower
 	 * background_thresh, to keep the amount of dirty memory low.
 	 */
-	if ((laptop_mode && pages_written) ||
-	    (!laptop_mode && (nr_reclaimable > background_thresh)))
+	if (!laptop_mode && (nr_reclaimable > background_thresh))
 		bdi_start_writeback(bdi, NULL, 0);
 }
 
--- linux.orig/include/linux/backing-dev.h	2009-09-28 18:52:51.000000000 +0800
+++ linux/include/linux/backing-dev.h	2009-09-28 19:02:45.000000000 +0800
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
@@ -94,6 +101,12 @@ struct backing_dev_info {
 #endif
 };
 
+/*
+ * when no task is throttled, set throttle_pages to larger than this,
+ * to avoid unnecessary atomic decreases.
+ */
+#define DIRTY_THROTTLE_PAGES_STOP	(1 << 22)
+
 int bdi_init(struct backing_dev_info *bdi);
 void bdi_destroy(struct backing_dev_info *bdi);
 
@@ -105,6 +118,8 @@ void bdi_start_writeback(struct backing_
 				long nr_pages);
 int bdi_writeback_task(struct bdi_writeback *wb);
 int bdi_has_dirty_io(struct backing_dev_info *bdi);
+int bdi_writeback_wakeup(struct backing_dev_info *bdi);
+void bdi_writeback_wait(struct backing_dev_info *bdi, long nr_pages);
 
 extern spinlock_t bdi_lock;
 extern struct list_head bdi_list;
--- linux.orig/fs/fs-writeback.c	2009-09-28 18:57:51.000000000 +0800
+++ linux/fs/fs-writeback.c	2009-09-28 19:02:45.000000000 +0800
@@ -25,6 +25,7 @@
 #include <linux/blkdev.h>
 #include <linux/backing-dev.h>
 #include <linux/buffer_head.h>
+#include <linux/completion.h>
 #include "internal.h"
 
 #define inode_to_bdi(inode)	((inode)->i_mapping->backing_dev_info)
@@ -136,14 +137,14 @@ static void wb_work_complete(struct bdi_
 		call_rcu(&work->rcu_head, bdi_work_free);
 }
 
-static void wb_clear_pending(struct bdi_writeback *wb, struct bdi_work *work)
+static void wb_clear_pending(struct backing_dev_info *bdi,
+			     struct bdi_work *work)
 {
 	/*
 	 * The caller has retrieved the work arguments from this work,
 	 * drop our reference. If this is the last ref, delete and free it
 	 */
 	if (atomic_dec_and_test(&work->pending)) {
-		struct backing_dev_info *bdi = wb->bdi;
 
 		spin_lock(&bdi->wb_lock);
 		list_del_rcu(&work->list);
@@ -275,6 +276,81 @@ void bdi_start_writeback(struct backing_
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
+	struct wb_writeback_args args = {
+		.sync_mode	= WB_SYNC_NONE,
+		.nr_pages	= LONG_MAX,
+		.range_cyclic	= 1,
+		.for_background	= 1,
+	};
+	struct bdi_work work;
+
+	bdi_work_init(&work, &args);
+	work.state |= WS_ONSTACK;
+
+	/*
+	 * make sure we will be waken up by someone
+	 */
+	bdi_queue_work(bdi, &work);
+
+	/*
+	 * register throttle pages
+	 */
+	spin_lock(&bdi->throttle_lock);
+	if (list_empty(&bdi->throttle_list))
+		atomic_set(&bdi->throttle_pages, nr_pages);
+	list_add(&tt.list, &bdi->throttle_list);
+	spin_unlock(&bdi->throttle_lock);
+
+	wait_for_completion(&tt.complete);
+
+	wb_clear_pending(bdi, &work); /* XXX */
+}
+
+/*
+ * return 1 if there are more waiting tasks.
+ */
+int bdi_writeback_wakeup(struct backing_dev_info *bdi)
+{
+	struct dirty_throttle_task *tt;
+
+	spin_lock(&bdi->throttle_lock);
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
+	spin_unlock(&bdi->throttle_lock);
+
+	return tt != NULL;
+}
+
 /*
  * Redirty an inode: set its when-it-was dirtied timestamp and move it to the
  * furthest end of its superblock's dirty-inode list.
@@ -788,8 +864,11 @@ static long wb_writeback(struct bdi_writ
 		 * For background writeout, stop when we are below the
 		 * background dirty threshold
 		 */
-		if (args->for_background && !over_bground_thresh())
+		if (args->for_background && !over_bground_thresh()) {
+			while (bdi_writeback_wakeup(wb->bdi))
+				;  /* unthrottle all tasks */
 			break;
+		}
 
 		wbc.more_io = 0;
 		wbc.encountered_congestion = 0;
@@ -911,7 +990,7 @@ long wb_do_writeback(struct bdi_writebac
 		 * that we have seen this work and we are now starting it.
 		 */
 		if (args.sync_mode == WB_SYNC_NONE)
-			wb_clear_pending(wb, work);
+			wb_clear_pending(bdi, work);
 
 		wrote += wb_writeback(wb, &args);
 
@@ -920,7 +999,7 @@ long wb_do_writeback(struct bdi_writebac
 		 * notification when we have completed the work.
 		 */
 		if (args.sync_mode == WB_SYNC_ALL)
-			wb_clear_pending(wb, work);
+			wb_clear_pending(bdi, work);
 	}
 
 	/*
--- linux.orig/mm/backing-dev.c	2009-09-28 18:52:18.000000000 +0800
+++ linux/mm/backing-dev.c	2009-09-28 19:02:45.000000000 +0800
@@ -645,6 +645,10 @@ int bdi_init(struct backing_dev_info *bd
 	bdi->wb_mask = 1;
 	bdi->wb_cnt = 1;
 
+	spin_lock_init(&bdi->throttle_lock);
+	INIT_LIST_HEAD(&bdi->throttle_list);
+	atomic_set(&bdi->throttle_pages, DIRTY_THROTTLE_PAGES_STOP * 2);
+
 	for (i = 0; i < NR_BDI_STAT_ITEMS; i++) {
 		err = percpu_counter_init(&bdi->bdi_stat[i], 0);
 		if (err)
