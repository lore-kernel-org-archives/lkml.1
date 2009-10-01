Return-Path: <linux-kernel-owner+w=401wt.eu-S1754149AbZJAOzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149AbZJAOzB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 10:55:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752736AbZJAOy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 10:54:57 -0400
Received: from mga03.intel.com ([143.182.124.21]:14439 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752369AbZJAOyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 10:54:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,488,1249282800"; 
   d="scan'208";a="193984095"
Date: Thu, 1 Oct 2009 22:54:43 +0800
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
Message-ID: <20091001145443.GA9469@localhost>
References: <1252434746.7035.7.camel@laptop> <20090909142315.GA7949@duck.suse.cz> <1252597750.7205.82.camel@laptop> <20090914111721.GA24075@duck.suse.cz> <20090924083342.GA15918@localhost> <20090929173506.GE11573@duck.suse.cz> <20090930012406.GB6311@localhost> <20090930115539.GA16074@duck.suse.cz> <20091001133610.GA7228@localhost> <20091001142243.GD24027@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091001142243.GD24027@duck.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 01, 2009 at 10:22:43PM +0800, Jan Kara wrote:
> On Thu 01-10-09 21:36:10, Wu Fengguang wrote:
> > > > --- linux.orig/fs/fs-writeback.c	2009-09-28 18:57:51.000000000 +0800
> > > > +++ linux/fs/fs-writeback.c	2009-09-28 19:02:45.000000000 +0800
> > > > @@ -25,6 +25,7 @@
> > > >  #include <linux/blkdev.h>
> > > >  #include <linux/backing-dev.h>
> > > >  #include <linux/buffer_head.h>
> > > > +#include <linux/completion.h>
> > > >  #include "internal.h"
> > > >  
> > > >  #define inode_to_bdi(inode)	((inode)->i_mapping->backing_dev_info)
> > > > @@ -136,14 +137,14 @@ static void wb_work_complete(struct bdi_
> > > >  		call_rcu(&work->rcu_head, bdi_work_free);
> > > >  }
> > > >  
> > > > -static void wb_clear_pending(struct bdi_writeback *wb, struct bdi_work *work)
> > > > +static void wb_clear_pending(struct backing_dev_info *bdi,
> > > > +			     struct bdi_work *work)
> > > >  {
> > > >  	/*
> > > >  	 * The caller has retrieved the work arguments from this work,
> > > >  	 * drop our reference. If this is the last ref, delete and free it
> > > >  	 */
> > > >  	if (atomic_dec_and_test(&work->pending)) {
> > > > -		struct backing_dev_info *bdi = wb->bdi;
> > > >  
> > > >  		spin_lock(&bdi->wb_lock);
> > > >  		list_del_rcu(&work->list);
> > > > @@ -275,6 +276,81 @@ void bdi_start_writeback(struct backing_
> > > >  	bdi_alloc_queue_work(bdi, &args);
> > > >  }
> > > >  
> > > > +struct dirty_throttle_task {
> > > > +	long			nr_pages;
> > > > +	struct list_head	list;
> > > > +	struct completion	complete;
> > > > +};
> > > > +
> > > > +void bdi_writeback_wait(struct backing_dev_info *bdi, long nr_pages)
> > > > +{
> > > > +	struct dirty_throttle_task tt = {
> > > > +		.nr_pages = nr_pages,
> > > > +		.complete = COMPLETION_INITIALIZER_ONSTACK(tt.complete),
> > > > +	};
> > > > +	struct wb_writeback_args args = {
> > > > +		.sync_mode	= WB_SYNC_NONE,
> > > > +		.nr_pages	= LONG_MAX,
> > > > +		.range_cyclic	= 1,
> > > > +		.for_background	= 1,
> > > > +	};
> > > > +	struct bdi_work work;
> > > > +
> > > > +	bdi_work_init(&work, &args);
> > > > +	work.state |= WS_ONSTACK;
> > > > +
> > > > +	/*
> > > > +	 * make sure we will be waken up by someone
> > > > +	 */
> > > > +	bdi_queue_work(bdi, &work);
> > >   This is wrong, you shouldn't submit the work like this because you'll
> > > have to wait for completion (wb_clear_pending below is just bogus). You
> > > should rather do bdi_start_writeback(bdi, NULL, 0).
> > 
> > No I don't intent to wait for completion of this work (that would
> > wait too long). This bdi work is to ensure writeback IO submissions
> > are now in progress. Thus __bdi_writeout_inc() will be called to
> > decrease bdi->throttle_pages, and when it counts down to 0, wake up
> > this process.
> > 
> > The alternative way is to do
> > 
> >         if (no background work queued)
> >                 bdi_start_writeback(bdi, NULL, 0)
> > 
> > It looks a saner solution, thanks for the suggestion :)
>   Yes, but you'll have hard time finding whether there's background work
> queued or not. So I suggest you just queue the background writeout
> unconditionally.

I added an atomic flag bit WB_FLAG_BACKGROUND_WORK for it :)

It is necessary because balance_dirty_pages() is called frequently and
one background work typically takes long time to finish, so huge
number of memory may be pinned for all the queued works.

> > > > +
> > > > +	/*
> > > > +	 * register throttle pages
> > > > +	 */
> > > > +	spin_lock(&bdi->throttle_lock);
> > > > +	if (list_empty(&bdi->throttle_list))
> > > > +		atomic_set(&bdi->throttle_pages, nr_pages);
> > > > +	list_add(&tt.list, &bdi->throttle_list);
> > > > +	spin_unlock(&bdi->throttle_lock);
> > > > +
> > > > +	wait_for_completion(&tt.complete);
> > 
> > > > +	wb_clear_pending(bdi, &work); /* XXX */
> > 
> > For the above reason, I remove the work here and don't care whether it
> > has been executed or is running or not seen at all. We have been waken up.
> > 
> > Sorry I definitely "misused" wb_clear_pending() for a slightly
> > different purpose..
> > 
> > This didn't really cancel the work if it has already been running.
> > So bdi_writeback_wait() achieves another goal of starting background
> > writeback if bdi-flush is previously idle.
> > 
> > > > +}
> > > > +
> > > > +/*
> > > > + * return 1 if there are more waiting tasks.
> > > > + */
> > > > +int bdi_writeback_wakeup(struct backing_dev_info *bdi)
> > > > +{
> > > > +	struct dirty_throttle_task *tt;
> > > > +
> > > > +	spin_lock(&bdi->throttle_lock);
> > > > +	/*
> > > > +	 * remove and wakeup head task
> > > > +	 */
> > > > +	if (!list_empty(&bdi->throttle_list)) {
> > > > +		tt = list_entry(bdi->throttle_list.prev,
> > > > +				struct dirty_throttle_task, list);
> > > > +		list_del(&tt->list);
> > > > +		complete(&tt->complete);
> > > > +	}
> > > > +	/*
> > > > +	 * update throttle pages
> > > > +	 */
> > > > +	if (!list_empty(&bdi->throttle_list)) {
> > > > +		tt = list_entry(bdi->throttle_list.prev,
> > > > +				struct dirty_throttle_task, list);
> > > > +		atomic_set(&bdi->throttle_pages, tt->nr_pages);
> > > > +	} else {
> > > > +		tt = NULL;
> > > > +		atomic_set(&bdi->throttle_pages, DIRTY_THROTTLE_PAGES_STOP * 2);
> > >   Why is here * 2?
> >  
> > Because we do a racy test in another place:
> > 
> >     +	if (atomic_read(&bdi->throttle_pages) < DIRTY_THROTTLE_PAGES_STOP &&
> >     +	    atomic_dec_and_test(&bdi->throttle_pages))
> >     +		bdi_writeback_wakeup(bdi);
> > 
> > The *2 is for reducing the race possibility. It might still be racy, but
> > that's OK, because it's mainly an optimization. It's perfectly correct
> > if we simply do 
>   Ah, I see. OK, then it deserves at least a comment...

Good suggestion. Here is one:

        /*
         * The DIRTY_THROTTLE_PAGES_STOP test is an optional optimization, so
         * it's OK to be racy. We set DIRTY_THROTTLE_PAGES_STOP*2 in other
         * places to reduce the race possibility.
         */     

> >     +	if (atomic_dec_and_test(&bdi->throttle_pages))
> >     +		bdi_writeback_wakeup(bdi);
> > 
> > > > +	}
> > > > +	spin_unlock(&bdi->throttle_lock);
> > > > +
> > > > +	return tt != NULL;
> > > > +}
> > > > +
> > > >  /*
> > > >   * Redirty an inode: set its when-it-was dirtied timestamp and move it to the
> > > >   * furthest end of its superblock's dirty-inode list.
> > > > @@ -788,8 +864,11 @@ static long wb_writeback(struct bdi_writ
> > > >  		 * For background writeout, stop when we are below the
> > > >  		 * background dirty threshold
> > > >  		 */
> > > > -		if (args->for_background && !over_bground_thresh())
> > > > +		if (args->for_background && !over_bground_thresh()) {
> > > > +			while (bdi_writeback_wakeup(wb->bdi))
> > > > +				;  /* unthrottle all tasks */
> > > >  			break;
> > > > +		}
> > >   You probably didn't understand my comment in the previous email. This is
> > > too late to wakeup all the tasks. There are two limits - background_limit
> > > (set to 5%) and dirty_limit (set to 10%). When amount of dirty data is
> > > above background_limit, we start the writeback but we don't throttle tasks
> > > yet. We start throttling tasks only when amount of dirty data on the bdi
> > > exceeds the part of the dirty limit belonging to the bdi. In case of a
> > > single bdi, this means we start throttling threads only when 10% of memory
> > > is dirty. To keep this behavior, we have to wakeup waiting threads as soon
> > > as their BDI gets below the dirty limit or when global number of dirty
> > > pages gets below (background_limit + dirty_limit) / 2.
> > 
> > Sure, but the design goal is to wakeup the throttled tasks in the
> > __bdi_writeout_inc() path instead of here. As long as some (background)
> > writeback is running, __bdi_writeout_inc() will be called to wakeup
> > the tasks.  This "unthrottle all on exit of background writeback" is
> > merely a safeguard, since once background writeback (which could be
> > queued by the throttled task itself, in bdi_writeback_wait) exits, the
> > calls to __bdi_writeout_inc() is likely to stop.
>   The thing is: In the old code, tasks returned from balance_dirty_pages()
> as soon as we got below dirty_limit, regardless of how much they managed to
> write. So we want to wake them up from waiting as soon as we get below the
> dirty limit (maybe a bit later so that they don't immediately block again
> but I hope you get the point).

Ah good catch!  However overhitting the threshold by 1MB (maybe more with
concurrent dirtiers) should not be a problem. As you said, that avoids the
task being immediately blocked again.

The old code does the dirty_limit check in an opportunistic manner. There were
no guarantee. 2.6.32 further weakens it with the removal of congestion back off.

Here is the updated patch :)

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
 fs/fs-writeback.c           |   92 +++++++++++++++++++++++++++-------
 include/linux/backing-dev.h |   41 ++++++++++++++-
 mm/backing-dev.c            |    4 +
 mm/page-writeback.c         |   53 ++++---------------
 4 files changed, 132 insertions(+), 58 deletions(-)

--- linux.orig/mm/page-writeback.c	2009-10-01 13:34:29.000000000 +0800
+++ linux/mm/page-writeback.c	2009-10-01 22:30:32.000000000 +0800
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
 
--- linux.orig/include/linux/backing-dev.h	2009-10-01 12:37:21.000000000 +0800
+++ linux/include/linux/backing-dev.h	2009-10-01 22:21:52.000000000 +0800
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
@@ -94,6 +101,17 @@ struct backing_dev_info {
 #endif
 };
 
+/*
+ * when no task is throttled, set throttle_pages to larger than this,
+ * to avoid unnecessary atomic decreases.
+ */
+#define DIRTY_THROTTLE_PAGES_STOP	(1 << 22)
+
+/*
+ * background work queued, set to avoid queuing redundant many background works
+ */
+#define WB_FLAG_BACKGROUND_WORK		30
+
 int bdi_init(struct backing_dev_info *bdi);
 void bdi_destroy(struct backing_dev_info *bdi);
 
@@ -105,6 +123,8 @@ void bdi_start_writeback(struct backing_
 				long nr_pages);
 int bdi_writeback_task(struct bdi_writeback *wb);
 int bdi_has_dirty_io(struct backing_dev_info *bdi);
+int bdi_writeback_wakeup(struct backing_dev_info *bdi);
+void bdi_writeback_wait(struct backing_dev_info *bdi, long nr_pages);
 
 extern spinlock_t bdi_lock;
 extern struct list_head bdi_list;
@@ -248,7 +268,26 @@ int bdi_set_max_ratio(struct backing_dev
 extern struct backing_dev_info default_backing_dev_info;
 void default_unplug_io_fn(struct backing_dev_info *bdi, struct page *page);
 
-int writeback_in_progress(struct backing_dev_info *bdi);
+/**
+ * writeback_in_progress - determine whether there is writeback in progress
+ * @bdi: the device's backing_dev_info structure.
+ *
+ * Determine whether there is writeback waiting to be handled against a
+ * backing device.
+ */
+int writeback_in_progress(struct backing_dev_info *bdi)
+{
+	return !list_empty(&bdi->work_list);
+}
+
+/*
+ * This prevents > 2 for_background writeback works in circulation.
+ * (one running and another queued)
+ */
+int can_submit_background_writeback(struct backing_dev_info *bdi)
+{
+	return test_and_set_bit(WB_FLAG_BACKGROUND_WORK, &bdi->wb_mask);
+}
 
 static inline int bdi_congested(struct backing_dev_info *bdi, int bdi_bits)
 {
--- linux.orig/fs/fs-writeback.c	2009-10-01 13:34:29.000000000 +0800
+++ linux/fs/fs-writeback.c	2009-10-01 22:31:54.000000000 +0800
@@ -25,6 +25,7 @@
 #include <linux/blkdev.h>
 #include <linux/backing-dev.h>
 #include <linux/buffer_head.h>
+#include <linux/completion.h>
 #include "internal.h"
 
 #define inode_to_bdi(inode)	((inode)->i_mapping->backing_dev_info)
@@ -85,18 +86,6 @@ static inline void bdi_work_init(struct 
 int sysctl_dirty_debug __read_mostly;
 
 
-/**
- * writeback_in_progress - determine whether there is writeback in progress
- * @bdi: the device's backing_dev_info structure.
- *
- * Determine whether there is writeback waiting to be handled against a
- * backing device.
- */
-int writeback_in_progress(struct backing_dev_info *bdi)
-{
-	return !list_empty(&bdi->work_list);
-}
-
 static void bdi_work_clear(struct bdi_work *work)
 {
 	clear_bit(WS_USED_B, &work->state);
@@ -136,17 +125,19 @@ static void wb_work_complete(struct bdi_
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
+		if (work->args.for_background)
+			clear_bit(WB_FLAG_BACKGROUND_WORK, &bdi->wb_mask);
 		spin_unlock(&bdi->wb_lock);
 
 		wb_work_complete(work);
@@ -275,6 +266,70 @@ void bdi_start_writeback(struct backing_
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
+
+	/*
+	 * make sure we will be woke up by someone
+	 */
+	if (can_submit_background_writeback(bdi))
+		bdi_start_writeback(bdi, NULL, 0);
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
@@ -756,8 +811,11 @@ static long wb_writeback(struct bdi_writ
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
@@ -879,7 +937,7 @@ long wb_do_writeback(struct bdi_writebac
 		 * that we have seen this work and we are now starting it.
 		 */
 		if (args.sync_mode == WB_SYNC_NONE)
-			wb_clear_pending(wb, work);
+			wb_clear_pending(bdi, work);
 
 		wrote += wb_writeback(wb, &args);
 
@@ -888,7 +946,7 @@ long wb_do_writeback(struct bdi_writebac
 		 * notification when we have completed the work.
 		 */
 		if (args.sync_mode == WB_SYNC_ALL)
-			wb_clear_pending(wb, work);
+			wb_clear_pending(bdi, work);
 	}
 
 	/*
--- linux.orig/mm/backing-dev.c	2009-10-01 13:34:29.000000000 +0800
+++ linux/mm/backing-dev.c	2009-10-01 22:17:05.000000000 +0800
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
