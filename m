Return-Path: <linux-kernel-owner+w=401wt.eu-S932110AbZJMDYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110AbZJMDYs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 23:24:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015AbZJMDYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 23:24:47 -0400
Received: from mga14.intel.com ([143.182.124.37]:43921 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751665AbZJMDYq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 23:24:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,549,1249282800"; 
   d="scan'208";a="198187816"
Date: Tue, 13 Oct 2009 11:24:05 +0800
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
Message-ID: <20091013032405.GA20405@localhost>
References: <20091007073818.318088777@intel.com> <20091007074901.251116016@intel.com> <20091009151230.GF7654@duck.suse.cz> <20091010213339.GA8644@localhost> <20091012211838.GA3965@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091012211838.GA3965@duck.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 13, 2009 at 05:18:38AM +0800, Jan Kara wrote:
> On Sun 11-10-09 05:33:39, Wu Fengguang wrote:
> > On Fri, Oct 09, 2009 at 11:12:31PM +0800, Jan Kara wrote:
> > > > +			/* don't wait if we've done enough */
> > > > +			if (pages_written >= write_chunk)
> > > > +				break;
> > > >  		}
> > > > -
> > > > -		if (bdi_nr_reclaimable + bdi_nr_writeback <= bdi_thresh)
> > > > -			break;
> > > > -		if (pages_written >= write_chunk)
> > > > -			break;		/* We've done our duty */
> > > > -
> > >   Here, we had an opportunity to break from the loop even if we didn't
> > > manage to write everything (for example because per-bdi thread managed to
> > > write enough or because enough IO has completed while we were trying to
> > > write). After the patch, we will sleep. IMHO that's not good...
> > 
> > Note that the pages_written check is moved several lines up in the patch :)
> > 
> > >   I'd think that if we did all that work in writeback_inodes_wbc we could
> > > spend the effort on regetting and rechecking the stats...
> > 
> > Yes maybe. I didn't care it because the later throttle queue patch totally
> > removed the loop and hence to need to reget the stats :)
>   Yes, since the loop gets removed in the end, this does not matter. You
> are right.

You are right too :) I followed you and Peter's advice to do the loop
and the recheck of stats as follows:

static void balance_dirty_pages(struct address_space *mapping,
				unsigned long write_chunk)
{
	long nr_reclaimable, bdi_nr_reclaimable;
	long nr_writeback, bdi_nr_writeback;
	unsigned long background_thresh;
	unsigned long dirty_thresh;
	unsigned long bdi_thresh;
	int dirty_exceeded;
	struct backing_dev_info *bdi = mapping->backing_dev_info;

	/*
	 * If sync() is in progress, curb the to-be-synced inodes regardless
	 * of dirty limits, so that a fast dirtier won't livelock the sync.
	 */
	if (unlikely(bdi->sync_time &&
		     S_ISREG(mapping->host->i_mode) &&
		     time_after_eq(bdi->sync_time,
				   mapping->host->dirtied_when))) {
		write_chunk *= 2;
		bdi_writeback_wait(bdi, write_chunk);
	}

	for (;;) {
		nr_reclaimable = global_page_state(NR_FILE_DIRTY) +
				 global_page_state(NR_UNSTABLE_NFS);
		nr_writeback = global_page_state(NR_WRITEBACK) +
			       global_page_state(NR_WRITEBACK_TEMP);

		global_dirty_thresh(&background_thresh, &dirty_thresh);

		/*
		 * Throttle it only when the background writeback cannot
		 * catch-up. This avoids (excessively) small writeouts
		 * when the bdi limits are ramping up.
		 */
		if (nr_reclaimable + nr_writeback <
		    (background_thresh + dirty_thresh) / 2)
			break;

		bdi_thresh = bdi_dirty_thresh(bdi, dirty_thresh);

		/*
		 * In order to avoid the stacked BDI deadlock we need
		 * to ensure we accurately count the 'dirty' pages when
		 * the threshold is low.
		 *
		 * Otherwise it would be possible to get thresh+n pages
		 * reported dirty, even though there are thresh-m pages
		 * actually dirty; with m+n sitting in the percpu
		 * deltas.
		 */
		if (bdi_thresh < 2*bdi_stat_error(bdi)) {
			bdi_nr_reclaimable = bdi_stat_sum(bdi, BDI_RECLAIMABLE);
			bdi_nr_writeback = bdi_stat_sum(bdi, BDI_WRITEBACK);
		} else {
			bdi_nr_reclaimable = bdi_stat(bdi, BDI_RECLAIMABLE);
			bdi_nr_writeback = bdi_stat(bdi, BDI_WRITEBACK);
		}

		/*
		 * The bdi thresh is somehow "soft" limit derived from the
		 * global "hard" limit. The former helps to prevent heavy IO
		 * bdi or process from holding back light ones; The latter is
		 * the last resort safeguard.
		 */
		dirty_exceeded =
			(bdi_nr_reclaimable + bdi_nr_writeback >= bdi_thresh)
			|| (nr_reclaimable + nr_writeback >= dirty_thresh);

		if (!dirty_exceeded)
			break;

		bdi->dirty_exceed_time = jiffies;

		bdi_writeback_wait(bdi, write_chunk);
	}

	/*
	 * In laptop mode, we wait until hitting the higher threshold before
	 * starting background writeout, and then write out all the way down
	 * to the lower threshold.  So slow writers cause minimal disk activity.
	 *
	 * In normal mode, we start background writeout at the lower
	 * background_thresh, to keep the amount of dirty memory low.
	 */
	if (!laptop_mode && (nr_reclaimable > background_thresh) &&
	    can_submit_background_writeback(bdi))
		bdi_start_writeback(bdi, NULL, WB_FOR_BACKGROUND);
}

> > > >  		schedule_timeout_interruptible(pause);
> > > >
> > > >  		/*
> > > > @@ -577,8 +547,7 @@ static void balance_dirty_pages(struct a
> > > >  			pause = HZ / 10;
> > > >  	}
> > > >
> > > > -	if (bdi_nr_reclaimable + bdi_nr_writeback < bdi_thresh &&
> > > > -			bdi->dirty_exceeded)
> > > > +	if (!dirty_exceeded && bdi->dirty_exceeded)
> > > >  		bdi->dirty_exceeded = 0;
> > >   Here we fail to clear dirty_exceeded if we are over global dirty limit
> > > but not over per-bdi dirty limit...
> > 
> > You must be mistaken: dirty_exceeded = (over bdi limit || over global limit),
> > so !dirty_exceeded = (!over bdi limit && !over global limit).
>   Exactly. Previously, the check was:
> if (!over bdi limit)
>   bdi->dirty_exceeded = 0;
> 
>   Now it is
> if (!over bdi limit && !over global limit)
>   bdi->dirty_exceeded = 0;
> 
>   That's clearly not equivalent which is what I was trying to point out.
> But looking at where dirty_exceeded is used, your new way is probably more
> useful. It's just a bit counterintuitive that bdi->dirty_exceeded is set
> even if the per-bdi limit is not exceeded...

Yeah good point. Since the per-bdi limits are more about "soft" limits
which are derived from the global "hard" limit, the code makes sense
with some comments and updated changelog :)

        This patch slightly changes behavior by replacing clip_bdi_dirty_limit()
        with the explicit check (nr_reclaimable + nr_writeback >= dirty_thresh)
        to avoid exceeding the dirty limit. Since the bdi dirty limit is mostly
        accurate we don't need to do routinely clip. A simple dirty limit check
        would be enough.

        The check is necessary because, in principle we should throttle
        everything calling balance_dirty_pages() when we're over the total
        limit, as said by Peter.

        We now set and clear dirty_exceeded not only based on bdi dirty limits,
        but also on the global dirty limits. This is a bit counterintuitive, but
        the global limits are the ultimate goal and shall be always imposed.

        We may now start background writeback work based on outdated conditions.
        That's safe because the bdi flush thread will (and have to) double check
        the states. It reduces overall overheads because the test based on old
        states still have good chance to be right.

Thanks,
Fengguang
