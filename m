Return-Path: <linux-kernel-owner+w=401wt.eu-S1757507AbZJBJzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507AbZJBJzA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 05:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757496AbZJBJy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 05:54:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47690 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757495AbZJBJy5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 05:54:57 -0400
Date: Fri, 2 Oct 2009 11:54:59 +0200
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
Message-ID: <20091002095459.GA24990@duck.suse.cz>
References: <20090914111721.GA24075@duck.suse.cz> <20090924083342.GA15918@localhost> <20090929173506.GE11573@duck.suse.cz> <20090930012406.GB6311@localhost> <20090930115539.GA16074@duck.suse.cz> <20091001133610.GA7228@localhost> <20091001142243.GD24027@duck.suse.cz> <20091001145443.GA9469@localhost> <20091001213523.GA21982@duck.suse.cz> <20091002022511.GA7061@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091002022511.GA7061@localhost>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 02-10-09 10:25:12, Wu Fengguang wrote:
> On Fri, Oct 02, 2009 at 05:35:23AM +0800, Jan Kara wrote:
> > On Thu 01-10-09 22:54:43, Wu Fengguang wrote:
> > > > > >   You probably didn't understand my comment in the previous email. This is
> > > > > > too late to wakeup all the tasks. There are two limits - background_limit
> > > > > > (set to 5%) and dirty_limit (set to 10%). When amount of dirty data is
> > > > > > above background_limit, we start the writeback but we don't throttle tasks
> > > > > > yet. We start throttling tasks only when amount of dirty data on the bdi
> > > > > > exceeds the part of the dirty limit belonging to the bdi. In case of a
> > > > > > single bdi, this means we start throttling threads only when 10% of memory
> > > > > > is dirty. To keep this behavior, we have to wakeup waiting threads as soon
> > > > > > as their BDI gets below the dirty limit or when global number of dirty
> > > > > > pages gets below (background_limit + dirty_limit) / 2.
> > > > > 
> > > > > Sure, but the design goal is to wakeup the throttled tasks in the
> > > > > __bdi_writeout_inc() path instead of here. As long as some (background)
> > > > > writeback is running, __bdi_writeout_inc() will be called to wakeup
> > > > > the tasks.  This "unthrottle all on exit of background writeback" is
> > > > > merely a safeguard, since once background writeback (which could be
> > > > > queued by the throttled task itself, in bdi_writeback_wait) exits, the
> > > > > calls to __bdi_writeout_inc() is likely to stop.
> > > >   The thing is: In the old code, tasks returned from balance_dirty_pages()
> > > > as soon as we got below dirty_limit, regardless of how much they managed to
> > > > write. So we want to wake them up from waiting as soon as we get below the
> > > > dirty limit (maybe a bit later so that they don't immediately block again
> > > > but I hope you get the point).
> > > 
> > > Ah good catch!  However overhitting the threshold by 1MB (maybe more with
> > > concurrent dirtiers) should not be a problem. As you said, that avoids the
> > > task being immediately blocked again.
> > > 
> > > The old code does the dirty_limit check in an opportunistic manner. There were
> > > no guarantee. 2.6.32 further weakens it with the removal of congestion back off.
> >   Sure, there are no guarantees but if we let threads sleep in
> > balance_dirty_pages longer than necessary it will have a performance impact
> > (application will sleep instead of doing useful work). So we should better
> > make sure applications sleep as few as necessary in balance_dirty_pages.
> 
> To avoid long sleep, we limit write_chunk size for balance_dirty_pages.
> That's all we need.  The "abort earlier if below dirty_limit" logic is
> not necessary (or even undesirable) in three ways.
> - just found that pre-31 kernels will normally succeed in writing the
>   whole write_chunk because nonblocking=0, thus it won't backoff on
>   congestion. So it's not over_bground_thresh() but over_dirty_limit()
>   that will change behavior.
  OK, good point.

> - whether it be abort on over_bground_thresh() or over_dirty_limit(),
>   there is some constant threshold around which applications are
>   throttled. The exact threshold level won't change the throttled
>   dirty throughput. It is determined by the write IO throughput the
>   block device can handle.
  But the aim is to throttle applications at higher limit than a limit at
which we start pdflush-style writeback. So that if writeback thread is fast
enough to flush the data, applications don't get throttled at all. That's
the reason for a difference between dirty_thresh and background_thresh.

> - The over_bground_thresh() check is merely a safeguard which is not
>   relevant in 99.9% time. But when increased to over_dirty_limit(), it
>   may become a hot wakeup path comparable to the __bdi_writeout_inc()
>   path.  The problem of this wakeup path is, it is "wakeup all". It's
>   preferable to wake up processes one by one in __bdi_writeout_inc().
  Well, it depends on the number of applications writing data (if there are
100 threads writing data, the last would get unblocked after 400 MB are
written assuming ratelimit_pages = 1024). So in this case there are high
chances that quite some threads will get woken up because we reach even
background_thresh.
  What I'm in fact a bit worried about is the latency - in the example
above it can take quite a long time for an application to be woken in
balance_dirty_pages (that's not a new problem I agree). When the threads
are writing continuously losts of data, there's no way around this. But
when it was just a short spike of IO, we'd win if we woke those threads
earlier. But OK, probaly we can sort that out later.

								Honza
