Return-Path: <linux-kernel-owner+w=401wt.eu-S932641AbZJAOWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932641AbZJAOWr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 10:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932501AbZJAOWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 10:22:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39206 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932451AbZJAOWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 10:22:45 -0400
Date: Thu, 1 Oct 2009 16:22:43 +0200
From: Jan Kara <jack@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>, Peter Zijlstra <peterz@infradead.org>,
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
Message-ID: <20091001142243.GD24027@duck.suse.cz>
References: <1252432501.7746.156.camel@twins> <1252434746.7035.7.camel@laptop> <20090909142315.GA7949@duck.suse.cz> <1252597750.7205.82.camel@laptop> <20090914111721.GA24075@duck.suse.cz> <20090924083342.GA15918@localhost> <20090929173506.GE11573@duck.suse.cz> <20090930012406.GB6311@localhost> <20090930115539.GA16074@duck.suse.cz> <20091001133610.GA7228@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091001133610.GA7228@localhost>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 01-10-09 21:36:10, Wu Fengguang wrote:
> > > --- linux.orig/fs/fs-writeback.c	2009-09-28 18:57:51.000000000 +0800
> > > +++ linux/fs/fs-writeback.c	2009-09-28 19:02:45.000000000 +0800
> > > @@ -25,6 +25,7 @@
> > >  #include <linux/blkdev.h>
> > >  #include <linux/backing-dev.h>
> > >  #include <linux/buffer_head.h>
> > > +#include <linux/completion.h>
> > >  #include "internal.h"
> > >  
> > >  #define inode_to_bdi(inode)	((inode)->i_mapping->backing_dev_info)
> > > @@ -136,14 +137,14 @@ static void wb_work_complete(struct bdi_
> > >  		call_rcu(&work->rcu_head, bdi_work_free);
> > >  }
> > >  
> > > -static void wb_clear_pending(struct bdi_writeback *wb, struct bdi_work *work)
> > > +static void wb_clear_pending(struct backing_dev_info *bdi,
> > > +			     struct bdi_work *work)
> > >  {
> > >  	/*
> > >  	 * The caller has retrieved the work arguments from this work,
> > >  	 * drop our reference. If this is the last ref, delete and free it
> > >  	 */
> > >  	if (atomic_dec_and_test(&work->pending)) {
> > > -		struct backing_dev_info *bdi = wb->bdi;
> > >  
> > >  		spin_lock(&bdi->wb_lock);
> > >  		list_del_rcu(&work->list);
> > > @@ -275,6 +276,81 @@ void bdi_start_writeback(struct backing_
> > >  	bdi_alloc_queue_work(bdi, &args);
> > >  }
> > >  
> > > +struct dirty_throttle_task {
> > > +	long			nr_pages;
> > > +	struct list_head	list;
> > > +	struct completion	complete;
> > > +};
> > > +
> > > +void bdi_writeback_wait(struct backing_dev_info *bdi, long nr_pages)
> > > +{
> > > +	struct dirty_throttle_task tt = {
> > > +		.nr_pages = nr_pages,
> > > +		.complete = COMPLETION_INITIALIZER_ONSTACK(tt.complete),
> > > +	};
> > > +	struct wb_writeback_args args = {
> > > +		.sync_mode	= WB_SYNC_NONE,
> > > +		.nr_pages	= LONG_MAX,
> > > +		.range_cyclic	= 1,
> > > +		.for_background	= 1,
> > > +	};
> > > +	struct bdi_work work;
> > > +
> > > +	bdi_work_init(&work, &args);
> > > +	work.state |= WS_ONSTACK;
> > > +
> > > +	/*
> > > +	 * make sure we will be waken up by someone
> > > +	 */
> > > +	bdi_queue_work(bdi, &work);
> >   This is wrong, you shouldn't submit the work like this because you'll
> > have to wait for completion (wb_clear_pending below is just bogus). You
> > should rather do bdi_start_writeback(bdi, NULL, 0).
> 
> No I don't intent to wait for completion of this work (that would
> wait too long). This bdi work is to ensure writeback IO submissions
> are now in progress. Thus __bdi_writeout_inc() will be called to
> decrease bdi->throttle_pages, and when it counts down to 0, wake up
> this process.
> 
> The alternative way is to do
> 
>         if (no background work queued)
>                 bdi_start_writeback(bdi, NULL, 0)
> 
> It looks a saner solution, thanks for the suggestion :)
  Yes, but you'll have hard time finding whether there's background work
queued or not. So I suggest you just queue the background writeout
unconditionally.

> > > +
> > > +	/*
> > > +	 * register throttle pages
> > > +	 */
> > > +	spin_lock(&bdi->throttle_lock);
> > > +	if (list_empty(&bdi->throttle_list))
> > > +		atomic_set(&bdi->throttle_pages, nr_pages);
> > > +	list_add(&tt.list, &bdi->throttle_list);
> > > +	spin_unlock(&bdi->throttle_lock);
> > > +
> > > +	wait_for_completion(&tt.complete);
> 
> > > +	wb_clear_pending(bdi, &work); /* XXX */
> 
> For the above reason, I remove the work here and don't care whether it
> has been executed or is running or not seen at all. We have been waken up.
> 
> Sorry I definitely "misused" wb_clear_pending() for a slightly
> different purpose..
> 
> This didn't really cancel the work if it has already been running.
> So bdi_writeback_wait() achieves another goal of starting background
> writeback if bdi-flush is previously idle.
> 
> > > +}
> > > +
> > > +/*
> > > + * return 1 if there are more waiting tasks.
> > > + */
> > > +int bdi_writeback_wakeup(struct backing_dev_info *bdi)
> > > +{
> > > +	struct dirty_throttle_task *tt;
> > > +
> > > +	spin_lock(&bdi->throttle_lock);
> > > +	/*
> > > +	 * remove and wakeup head task
> > > +	 */
> > > +	if (!list_empty(&bdi->throttle_list)) {
> > > +		tt = list_entry(bdi->throttle_list.prev,
> > > +				struct dirty_throttle_task, list);
> > > +		list_del(&tt->list);
> > > +		complete(&tt->complete);
> > > +	}
> > > +	/*
> > > +	 * update throttle pages
> > > +	 */
> > > +	if (!list_empty(&bdi->throttle_list)) {
> > > +		tt = list_entry(bdi->throttle_list.prev,
> > > +				struct dirty_throttle_task, list);
> > > +		atomic_set(&bdi->throttle_pages, tt->nr_pages);
> > > +	} else {
> > > +		tt = NULL;
> > > +		atomic_set(&bdi->throttle_pages, DIRTY_THROTTLE_PAGES_STOP * 2);
> >   Why is here * 2?
>  
> Because we do a racy test in another place:
> 
>     +	if (atomic_read(&bdi->throttle_pages) < DIRTY_THROTTLE_PAGES_STOP &&
>     +	    atomic_dec_and_test(&bdi->throttle_pages))
>     +		bdi_writeback_wakeup(bdi);
> 
> The *2 is for reducing the race possibility. It might still be racy, but
> that's OK, because it's mainly an optimization. It's perfectly correct
> if we simply do 
  Ah, I see. OK, then it deserves at least a comment...

>     +	if (atomic_dec_and_test(&bdi->throttle_pages))
>     +		bdi_writeback_wakeup(bdi);
> 
> > > +	}
> > > +	spin_unlock(&bdi->throttle_lock);
> > > +
> > > +	return tt != NULL;
> > > +}
> > > +
> > >  /*
> > >   * Redirty an inode: set its when-it-was dirtied timestamp and move it to the
> > >   * furthest end of its superblock's dirty-inode list.
> > > @@ -788,8 +864,11 @@ static long wb_writeback(struct bdi_writ
> > >  		 * For background writeout, stop when we are below the
> > >  		 * background dirty threshold
> > >  		 */
> > > -		if (args->for_background && !over_bground_thresh())
> > > +		if (args->for_background && !over_bground_thresh()) {
> > > +			while (bdi_writeback_wakeup(wb->bdi))
> > > +				;  /* unthrottle all tasks */
> > >  			break;
> > > +		}
> >   You probably didn't understand my comment in the previous email. This is
> > too late to wakeup all the tasks. There are two limits - background_limit
> > (set to 5%) and dirty_limit (set to 10%). When amount of dirty data is
> > above background_limit, we start the writeback but we don't throttle tasks
> > yet. We start throttling tasks only when amount of dirty data on the bdi
> > exceeds the part of the dirty limit belonging to the bdi. In case of a
> > single bdi, this means we start throttling threads only when 10% of memory
> > is dirty. To keep this behavior, we have to wakeup waiting threads as soon
> > as their BDI gets below the dirty limit or when global number of dirty
> > pages gets below (background_limit + dirty_limit) / 2.
> 
> Sure, but the design goal is to wakeup the throttled tasks in the
> __bdi_writeout_inc() path instead of here. As long as some (background)
> writeback is running, __bdi_writeout_inc() will be called to wakeup
> the tasks.  This "unthrottle all on exit of background writeback" is
> merely a safeguard, since once background writeback (which could be
> queued by the throttled task itself, in bdi_writeback_wait) exits, the
> calls to __bdi_writeout_inc() is likely to stop.
  The thing is: In the old code, tasks returned from balance_dirty_pages()
as soon as we got below dirty_limit, regardless of how much they managed to
write. So we want to wake them up from waiting as soon as we get below the
dirty limit (maybe a bit later so that they don't immediately block again
but I hope you get the point).

							Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
