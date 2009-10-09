Return-Path: <linux-kernel-owner+w=401wt.eu-S1761082AbZJIPNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761082AbZJIPNZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 11:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760891AbZJIPNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 11:13:24 -0400
Received: from cantor.suse.de ([195.135.220.2]:46254 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758440AbZJIPNX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 11:13:23 -0400
Date: Fri, 9 Oct 2009 17:12:31 +0200
From: Jan Kara <jack@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       Christoph Hellwig <hch@infradead.org>,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Li Shaohua <shaohua.li@intel.com>,
       Myklebust Trond <Trond.Myklebust@netapp.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       Jan Kara <jack@suse.cz>, Nick Piggin <npiggin@suse.de>,
       linux-fsdevel@vger.kernel.org,
       Richard Kennedy <richard@rsk.demon.co.uk>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/45] writeback: reduce calls to global_page_state in
	balance_dirty_pages()
Message-ID: <20091009151230.GF7654@duck.suse.cz>
References: <20091007073818.318088777@intel.com> <20091007074901.251116016@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091007074901.251116016@intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

On Wed 07-10-09 15:38:19, Wu Fengguang wrote:
> From: Richard Kennedy <richard@rsk.demon.co.uk>
> 
> Reducing the number of times balance_dirty_pages calls global_page_state
> reduces the cache references and so improves write performance on a
> variety of workloads.
> 
> 'perf stats' of simple fio write tests shows the reduction in cache
> access.
> Where the test is fio 'write,mmap,600Mb,pre_read' on AMD AthlonX2 with
> 3Gb memory (dirty_threshold approx 600 Mb)
> running each test 10 times, dropping the fasted & slowest values then
> taking 
> the average & standard deviation
> 
> 		average (s.d.) in millions (10^6)
> 2.6.31-rc8	648.6 (14.6)
> +patch		620.1 (16.5)
> 
> Achieving this reduction is by dropping clip_bdi_dirty_limit as it  
> rereads the counters to apply the dirty_threshold and moving this check
> up into balance_dirty_pages where it has already read the counters.
> 
> Also by rearrange the for loop to only contain one copy of the limit
> tests allows the pdflush test after the loop to use the local copies of
> the counters rather than rereading them.
> 
> In the common case with no throttling it now calls global_page_state 5
> fewer times and bdi_stat 2 fewer.
  Hmm, but the patch changes the behavior of balance_dirty_pages() in
several ways:

> -/*
> - * Clip the earned share of dirty pages to that which is actually available.
> - * This avoids exceeding the total dirty_limit when the floating averages
> - * fluctuate too quickly.
> - */
> -static void clip_bdi_dirty_limit(struct backing_dev_info *bdi,
> -		unsigned long dirty, unsigned long *pbdi_dirty)
> -{
> -	unsigned long avail_dirty;
> -
> -	avail_dirty = global_page_state(NR_FILE_DIRTY) +
> -		 global_page_state(NR_WRITEBACK) +
> -		 global_page_state(NR_UNSTABLE_NFS) +
> -		 global_page_state(NR_WRITEBACK_TEMP);
> -
> -	if (avail_dirty < dirty)
> -		avail_dirty = dirty - avail_dirty;
> -	else
> -		avail_dirty = 0;
> -
> -	avail_dirty += bdi_stat(bdi, BDI_RECLAIMABLE) +
> -		bdi_stat(bdi, BDI_WRITEBACK);
> -
> -	*pbdi_dirty = min(*pbdi_dirty, avail_dirty);
> -}
> -
>  static inline void task_dirties_fraction(struct task_struct *tsk,
>  		long *numerator, long *denominator)
>  {
> @@ -468,7 +442,6 @@ get_dirty_limits(unsigned long *pbackgro
>  			bdi_dirty = dirty * bdi->max_ratio / 100;
>  
>  		*pbdi_dirty = bdi_dirty;
> -		clip_bdi_dirty_limit(bdi, dirty, pbdi_dirty);
  I don't see, what test in balance_dirty_limits() should replace this
clipping... OTOH clipping does not seem to have too much effect on the
behavior of balance_dirty_pages - the limit we clip to (at least
BDI_WRITEBACK + BDI_RECLAIMABLE) is large enough so that we break from the
loop immediately. So just getting rid of the function is fine but
I'd update the changelog accordingly.

> @@ -503,16 +476,36 @@ static void balance_dirty_pages(struct a
>  		};
>  
>  		get_dirty_limits(&background_thresh, &dirty_thresh,
> -				&bdi_thresh, bdi);
> +				 &bdi_thresh, bdi);
>  
>  		nr_reclaimable = global_page_state(NR_FILE_DIRTY) +
> -					global_page_state(NR_UNSTABLE_NFS);
> -		nr_writeback = global_page_state(NR_WRITEBACK);
> +				 global_page_state(NR_UNSTABLE_NFS);
> +		nr_writeback = global_page_state(NR_WRITEBACK) +
> +			       global_page_state(NR_WRITEBACK_TEMP);
>  
> -		bdi_nr_reclaimable = bdi_stat(bdi, BDI_RECLAIMABLE);
> -		bdi_nr_writeback = bdi_stat(bdi, BDI_WRITEBACK);
> +		/*
> +		 * In order to avoid the stacked BDI deadlock we need
> +		 * to ensure we accurately count the 'dirty' pages when
> +		 * the threshold is low.
> +		 *
> +		 * Otherwise it would be possible to get thresh+n pages
> +		 * reported dirty, even though there are thresh-m pages
> +		 * actually dirty; with m+n sitting in the percpu
> +		 * deltas.
> +		 */
> +		if (bdi_thresh < 2*bdi_stat_error(bdi)) {
> +			bdi_nr_reclaimable = bdi_stat_sum(bdi, BDI_RECLAIMABLE);
> +			bdi_nr_writeback = bdi_stat_sum(bdi, BDI_WRITEBACK);
> +		} else {
> +			bdi_nr_reclaimable = bdi_stat(bdi, BDI_RECLAIMABLE);
> +			bdi_nr_writeback = bdi_stat(bdi, BDI_WRITEBACK);
> +		}
> +
> +		dirty_exceeded =
> +			(bdi_nr_reclaimable + bdi_nr_writeback >= bdi_thresh)
> +			|| (nr_reclaimable + nr_writeback >= dirty_thresh);
>  
> -		if (bdi_nr_reclaimable + bdi_nr_writeback <= bdi_thresh)
> +		if (!dirty_exceeded)
>  			break;
  Ugh, but this is not equivalent! We would block the writer on some BDI
without any dirty data if we are over global dirty limit. That didn't
happen before.

>  		/*
> @@ -521,7 +514,7 @@ static void balance_dirty_pages(struct a
>  		 * when the bdi limits are ramping up.
>  		 */
>  		if (nr_reclaimable + nr_writeback <
> -				(background_thresh + dirty_thresh) / 2)
> +		    (background_thresh + dirty_thresh) / 2)
>  			break;
>  
>  		if (!bdi->dirty_exceeded)
> @@ -539,33 +532,10 @@ static void balance_dirty_pages(struct a
>  		if (bdi_nr_reclaimable > bdi_thresh) {
>  			writeback_inodes_wbc(&wbc);
>  			pages_written += write_chunk - wbc.nr_to_write;
> -			get_dirty_limits(&background_thresh, &dirty_thresh,
> -				       &bdi_thresh, bdi);
> -		}
> -
> -		/*
> -		 * In order to avoid the stacked BDI deadlock we need
> -		 * to ensure we accurately count the 'dirty' pages when
> -		 * the threshold is low.
> -		 *
> -		 * Otherwise it would be possible to get thresh+n pages
> -		 * reported dirty, even though there are thresh-m pages
> -		 * actually dirty; with m+n sitting in the percpu
> -		 * deltas.
> -		 */
> -		if (bdi_thresh < 2*bdi_stat_error(bdi)) {
> -			bdi_nr_reclaimable = bdi_stat_sum(bdi, BDI_RECLAIMABLE);
> -			bdi_nr_writeback = bdi_stat_sum(bdi, BDI_WRITEBACK);
> -		} else if (bdi_nr_reclaimable) {
> -			bdi_nr_reclaimable = bdi_stat(bdi, BDI_RECLAIMABLE);
> -			bdi_nr_writeback = bdi_stat(bdi, BDI_WRITEBACK);
> +			/* don't wait if we've done enough */
> +			if (pages_written >= write_chunk)
> +				break;
>  		}
> -
> -		if (bdi_nr_reclaimable + bdi_nr_writeback <= bdi_thresh)
> -			break;
> -		if (pages_written >= write_chunk)
> -			break;		/* We've done our duty */
> -
  Here, we had an opportunity to break from the loop even if we didn't
manage to write everything (for example because per-bdi thread managed to
write enough or because enough IO has completed while we were trying to
write). After the patch, we will sleep. IMHO that's not good...
  I'd think that if we did all that work in writeback_inodes_wbc we could
spend the effort on regetting and rechecking the stats...

>  		schedule_timeout_interruptible(pause);
>  
>  		/*
> @@ -577,8 +547,7 @@ static void balance_dirty_pages(struct a
>  			pause = HZ / 10;
>  	}
>  
> -	if (bdi_nr_reclaimable + bdi_nr_writeback < bdi_thresh &&
> -			bdi->dirty_exceeded)
> +	if (!dirty_exceeded && bdi->dirty_exceeded)
>  		bdi->dirty_exceeded = 0;
  Here we fail to clear dirty_exceeded if we are over global dirty limit
but not over per-bdi dirty limit...

> @@ -593,9 +562,7 @@ static void balance_dirty_pages(struct a
>  	 * background_thresh, to keep the amount of dirty memory low.
>  	 */
>  	if ((laptop_mode && pages_written) ||
> -	    (!laptop_mode && ((global_page_state(NR_FILE_DIRTY)
> -			       + global_page_state(NR_UNSTABLE_NFS))
> -					  > background_thresh)))
> +	    (!laptop_mode && (nr_reclaimable > background_thresh)))
>  		bdi_start_writeback(bdi, NULL, 0);
>  }
  This might be based on rather old values in case we break from the loop
after calling writeback_inodes_wbc.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
