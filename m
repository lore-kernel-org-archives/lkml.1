Return-Path: <linux-kernel-owner+w=401wt.eu-S1759184AbZJKBLH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759184AbZJKBLH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 21:11:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755713AbZJKBLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 21:11:05 -0400
Received: from mga14.intel.com ([143.182.124.37]:12434 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756491AbZJKBLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 21:11:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,539,1249282800"; 
   d="scan'208";a="197519856"
Date: Sun, 11 Oct 2009 05:33:39 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       Christoph Hellwig <hch@infradead.org>,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       Myklebust Trond <Trond.Myklebust@netapp.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       Nick Piggin <npiggin@suse.de>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Richard Kennedy <richard@rsk.demon.co.uk>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/45] writeback: reduce calls to global_page_state in
	balance_dirty_pages()
Message-ID: <20091010213339.GA8644@localhost>
References: <20091007073818.318088777@intel.com> <20091007074901.251116016@intel.com> <20091009151230.GF7654@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091009151230.GF7654@duck.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 09, 2009 at 11:12:31PM +0800, Jan Kara wrote:
>   Hi,
>
> On Wed 07-10-09 15:38:19, Wu Fengguang wrote:
> > From: Richard Kennedy <richard@rsk.demon.co.uk>
> >
> > Reducing the number of times balance_dirty_pages calls global_page_state
> > reduces the cache references and so improves write performance on a
> > variety of workloads.
> >
> > 'perf stats' of simple fio write tests shows the reduction in cache
> > access.
> > Where the test is fio 'write,mmap,600Mb,pre_read' on AMD AthlonX2 with
> > 3Gb memory (dirty_threshold approx 600 Mb)
> > running each test 10 times, dropping the fasted & slowest values then
> > taking
> > the average & standard deviation
> >
> > 		average (s.d.) in millions (10^6)
> > 2.6.31-rc8	648.6 (14.6)
> > +patch		620.1 (16.5)
> >
> > Achieving this reduction is by dropping clip_bdi_dirty_limit as it
> > rereads the counters to apply the dirty_threshold and moving this check
> > up into balance_dirty_pages where it has already read the counters.
> >
> > Also by rearrange the for loop to only contain one copy of the limit
> > tests allows the pdflush test after the loop to use the local copies of
> > the counters rather than rereading them.
> >
> > In the common case with no throttling it now calls global_page_state 5
> > fewer times and bdi_stat 2 fewer.
>   Hmm, but the patch changes the behavior of balance_dirty_pages() in
> several ways:

Yes, unfortunately the changelog failed to make that clear ..

> > -/*
> > - * Clip the earned share of dirty pages to that which is actually available.
> > - * This avoids exceeding the total dirty_limit when the floating averages
> > - * fluctuate too quickly.
> > - */
> > -static void clip_bdi_dirty_limit(struct backing_dev_info *bdi,
> > -		unsigned long dirty, unsigned long *pbdi_dirty)
> > -{
> > -	unsigned long avail_dirty;
> > -
> > -	avail_dirty = global_page_state(NR_FILE_DIRTY) +
> > -		 global_page_state(NR_WRITEBACK) +
> > -		 global_page_state(NR_UNSTABLE_NFS) +
> > -		 global_page_state(NR_WRITEBACK_TEMP);
> > -
> > -	if (avail_dirty < dirty)
> > -		avail_dirty = dirty - avail_dirty;
> > -	else
> > -		avail_dirty = 0;
> > -
> > -	avail_dirty += bdi_stat(bdi, BDI_RECLAIMABLE) +
> > -		bdi_stat(bdi, BDI_WRITEBACK);
> > -
> > -	*pbdi_dirty = min(*pbdi_dirty, avail_dirty);
> > -}
> > -
> >  static inline void task_dirties_fraction(struct task_struct *tsk,
> >  		long *numerator, long *denominator)
> >  {
> > @@ -468,7 +442,6 @@ get_dirty_limits(unsigned long *pbackgro
> >  			bdi_dirty = dirty * bdi->max_ratio / 100;
> >
> >  		*pbdi_dirty = bdi_dirty;
> > -		clip_bdi_dirty_limit(bdi, dirty, pbdi_dirty);
>   I don't see, what test in balance_dirty_limits() should replace this
> clipping... OTOH clipping does not seem to have too much effect on the
> behavior of balance_dirty_pages - the limit we clip to (at least
> BDI_WRITEBACK + BDI_RECLAIMABLE) is large enough so that we break from the
> loop immediately. So just getting rid of the function is fine but
> I'd update the changelog accordingly.
>

It essentially replace clip_bdi_dirty_limit() with the explicit check
(nr_reclaimable + nr_writeback >= dirty_thresh) to avoid exceeding the
dirty limit. Since the bdi dirty limit is mostly accurate we don't need
to do routinely clip. A simple dirty limit check would be enough.

I added the above text to changelog :)

> > +		dirty_exceeded =
> > +			(bdi_nr_reclaimable + bdi_nr_writeback >= bdi_thresh)
> > +			|| (nr_reclaimable + nr_writeback >= dirty_thresh);
> >
> > -		if (bdi_nr_reclaimable + bdi_nr_writeback <= bdi_thresh)
> > +		if (!dirty_exceeded)
> >  			break;
>   Ugh, but this is not equivalent! We would block the writer on some BDI
> without any dirty data if we are over global dirty limit. That didn't
> happen before.

This restores the (right) behavior in 2.6.18. And peter have the same goal
in mind with clip_bdi_dirty_limit() ;)

> > +			/* don't wait if we've done enough */
> > +			if (pages_written >= write_chunk)
> > +				break;
> >  		}
> > -
> > -		if (bdi_nr_reclaimable + bdi_nr_writeback <= bdi_thresh)
> > -			break;
> > -		if (pages_written >= write_chunk)
> > -			break;		/* We've done our duty */
> > -
>   Here, we had an opportunity to break from the loop even if we didn't
> manage to write everything (for example because per-bdi thread managed to
> write enough or because enough IO has completed while we were trying to
> write). After the patch, we will sleep. IMHO that's not good...

Note that the pages_written check is moved several lines up in the patch :)

>   I'd think that if we did all that work in writeback_inodes_wbc we could
> spend the effort on regetting and rechecking the stats...

Yes maybe. I didn't care it because the later throttle queue patch totally
removed the loop and hence to need to reget the stats :)

> >  		schedule_timeout_interruptible(pause);
> >
> >  		/*
> > @@ -577,8 +547,7 @@ static void balance_dirty_pages(struct a
> >  			pause = HZ / 10;
> >  	}
> >
> > -	if (bdi_nr_reclaimable + bdi_nr_writeback < bdi_thresh &&
> > -			bdi->dirty_exceeded)
> > +	if (!dirty_exceeded && bdi->dirty_exceeded)
> >  		bdi->dirty_exceeded = 0;
>   Here we fail to clear dirty_exceeded if we are over global dirty limit
> but not over per-bdi dirty limit...

You must be mistaken: dirty_exceeded = (over bdi limit || over global limit),
so !dirty_exceeded = (!over bdi limit && !over global limit).

> > @@ -593,9 +562,7 @@ static void balance_dirty_pages(struct a
> >  	 * background_thresh, to keep the amount of dirty memory low.
> >  	 */
> >  	if ((laptop_mode && pages_written) ||
> > -	    (!laptop_mode && ((global_page_state(NR_FILE_DIRTY)
> > -			       + global_page_state(NR_UNSTABLE_NFS))
> > -					  > background_thresh)))
> > +	    (!laptop_mode && (nr_reclaimable > background_thresh)))
> >  		bdi_start_writeback(bdi, NULL, 0);
> >  }
>   This might be based on rather old values in case we break from the loop
> after calling writeback_inodes_wbc.

Yes that's possible. It's safe because the bdi worker will double check
background_thresh. We can call bdi_start_writeback() as long as there are
good possibility: the nr_reclaimable is not likely to drop suddenly from
during our writeout.

Thanks,
Fengguang
