Return-Path: <linux-kernel-owner+w=401wt.eu-S1754625AbZJBC0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625AbZJBC0O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 22:26:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753961AbZJBC0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 22:26:13 -0400
Received: from mga14.intel.com ([143.182.124.37]:42428 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752904AbZJBC0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 22:26:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,490,1249282800"; 
   d="scan'208";a="194246614"
Date: Fri, 2 Oct 2009 10:25:12 +0800
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
Message-ID: <20091002022511.GA7061@localhost>
References: <1252597750.7205.82.camel@laptop> <20090914111721.GA24075@duck.suse.cz> <20090924083342.GA15918@localhost> <20090929173506.GE11573@duck.suse.cz> <20090930012406.GB6311@localhost> <20090930115539.GA16074@duck.suse.cz> <20091001133610.GA7228@localhost> <20091001142243.GD24027@duck.suse.cz> <20091001145443.GA9469@localhost> <20091001213523.GA21982@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091001213523.GA21982@duck.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 02, 2009 at 05:35:23AM +0800, Jan Kara wrote:
> On Thu 01-10-09 22:54:43, Wu Fengguang wrote:
> > > > >   You probably didn't understand my comment in the previous email. This is
> > > > > too late to wakeup all the tasks. There are two limits - background_limit
> > > > > (set to 5%) and dirty_limit (set to 10%). When amount of dirty data is
> > > > > above background_limit, we start the writeback but we don't throttle tasks
> > > > > yet. We start throttling tasks only when amount of dirty data on the bdi
> > > > > exceeds the part of the dirty limit belonging to the bdi. In case of a
> > > > > single bdi, this means we start throttling threads only when 10% of memory
> > > > > is dirty. To keep this behavior, we have to wakeup waiting threads as soon
> > > > > as their BDI gets below the dirty limit or when global number of dirty
> > > > > pages gets below (background_limit + dirty_limit) / 2.
> > > > 
> > > > Sure, but the design goal is to wakeup the throttled tasks in the
> > > > __bdi_writeout_inc() path instead of here. As long as some (background)
> > > > writeback is running, __bdi_writeout_inc() will be called to wakeup
> > > > the tasks.  This "unthrottle all on exit of background writeback" is
> > > > merely a safeguard, since once background writeback (which could be
> > > > queued by the throttled task itself, in bdi_writeback_wait) exits, the
> > > > calls to __bdi_writeout_inc() is likely to stop.
> > >   The thing is: In the old code, tasks returned from balance_dirty_pages()
> > > as soon as we got below dirty_limit, regardless of how much they managed to
> > > write. So we want to wake them up from waiting as soon as we get below the
> > > dirty limit (maybe a bit later so that they don't immediately block again
> > > but I hope you get the point).
> > 
> > Ah good catch!  However overhitting the threshold by 1MB (maybe more with
> > concurrent dirtiers) should not be a problem. As you said, that avoids the
> > task being immediately blocked again.
> > 
> > The old code does the dirty_limit check in an opportunistic manner. There were
> > no guarantee. 2.6.32 further weakens it with the removal of congestion back off.
>   Sure, there are no guarantees but if we let threads sleep in
> balance_dirty_pages longer than necessary it will have a performance impact
> (application will sleep instead of doing useful work). So we should better
> make sure applications sleep as few as necessary in balance_dirty_pages.

To avoid long sleep, we limit write_chunk size for balance_dirty_pages.
That's all we need.  The "abort earlier if below dirty_limit" logic is
not necessary (or even undesirable) in three ways.
- just found that pre-31 kernels will normally succeed in writing the
  whole write_chunk because nonblocking=0, thus it won't backoff on
  congestion. So it's not over_bground_thresh() but over_dirty_limit()
  that will change behavior.
- whether it be abort on over_bground_thresh() or over_dirty_limit(),
  there is some constant threshold around which applications are
  throttled. The exact threshold level won't change the throttled
  dirty throughput. It is determined by the write IO throughput the
  block device can handle.
- The over_bground_thresh() check is merely a safeguard which is not
  relevant in 99.9% time. But when increased to over_dirty_limit(), it
  may become a hot wakeup path comparable to the __bdi_writeout_inc()
  path.  The problem of this wakeup path is, it is "wakeup all". It's
  preferable to wake up processes one by one in __bdi_writeout_inc().

I assume dirty_limit to be (background_thresh + dirty_thresh) / 2.

> > @@ -756,8 +811,11 @@ static long wb_writeback(struct bdi_writ
> >  		 * For background writeout, stop when we are below the
> >  		 * background dirty threshold
> >  		 */
> > -		if (args->for_background && !over_bground_thresh())
> > +		if (args->for_background && !over_bground_thresh()) {
> > +			while (bdi_writeback_wakeup(wb->bdi))
> > +				;  /* unthrottle all tasks */
> >  			break;
> > +		}
>   Thus the check here should rather be
> if (args->for_background && !over_dirty_limit())

Sorry, for above reasons, I don't think we need to add dirty_limit
check here.

Thanks,
Fengguang
