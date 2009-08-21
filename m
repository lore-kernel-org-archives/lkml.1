Return-Path: <linux-kernel-owner+w=401wt.eu-S1755576AbZHUOFL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576AbZHUOFL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 10:05:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754669AbZHUOFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 10:05:11 -0400
Received: from viefep17-int.chello.at ([62.179.121.37]:44727 "EHLO
	viefep17-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754637AbZHUOFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 10:05:09 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [RFC PATCH] mm: balance_dirty_pages. reduce calls to
 global_page_state to reduce cache references
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "chris.mason" <chris.mason@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       miklos <miklos@szeredi.hu>
In-Reply-To: <1250855961.2226.94.camel@castor>
References: <1250855961.2226.94.camel@castor>
Content-Type: text/plain
Date: Fri, 21 Aug 2009 16:04:54 +0200
Message-Id: <1250863494.7538.49.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(removed linux-mm because it seems to be ill atm)

On Fri, 2009-08-21 at 12:59 +0100, Richard Kennedy wrote:
> Reducing the number of times balance_dirty_pages calls global_page_state
> reduces the cache references and so improves write performance on a
> variety of workloads.
> 
> 'perf stats' of simple fio write tests shows the reduction in cache
> access.
> Where the test is fio 'write,mmap,600Mb,pre_read' on AMD AthlonX2 with
> 3Gb memory (dirty_threshold approx 600 Mb)
> running each test 10 times, taking the average & standard deviation
> 
> 		average (s.d.) in millions (10^6)
> 2.6.31-rc6	661 (9.88)
> +patch		604 (4.19)

Nice.

> Achieving this reduction is by dropping clip_bdi_dirty_limit as it  
> rereads the counters to apply the dirty_threshold and moving this check
> up into balance_dirty_pages where it has already read the counters.

OK, so what you did is first check the total dirty limit, and only if
that is ok, check the per-BDI limit, now why didn't I think of that ;-)

> Also by rearrange the for loop to only contain one copy of the limit
> tests allows the pdflush test after the loop to use the local copies of
> the counters rather than rereading then.
> 
> In the common case with no throttling it now calls global_page_state 5
> fewer times and bdi_stat 2 fewer.
> 
> I have tried to retain the existing behavior as much as possible, but
> have added NR_WRITEBACK_TEMP to nr_writeback. This counter was used in
> clip_bdi_dirty_limit but not in balance_dirty_pages, grep suggests this
> is only used by FUSE but I haven't done any testing on that. It does
> seem logical to count all the WRITEBACK pages when making the throttling
> decisions so this change should be more correct ;)

Right, the NR_WRITEBACK_TEMP thing is a FUSE feature, its used in
writable mmap() support for FUSE things.

I must admit to forgetting the exact semantics of the things, maybe
Miklos can remind us.

> Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>

Looks good here

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

> ----
>  page-writeback.c |  116 ++++++++++++++++++++-----------------------------------
>  1 file changed, 43 insertions(+), 73 deletions(-)

> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 81627eb..6f18e40 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c

> @@ -512,45 +485,12 @@ static void balance_dirty_pages(struct address_space *mapping)
>  		};
>  
>  		get_dirty_limits(&background_thresh, &dirty_thresh,
> +				 &bdi_thresh, bdi);
>  
>  		nr_reclaimable = global_page_state(NR_FILE_DIRTY) +
> +			global_page_state(NR_UNSTABLE_NFS);
> +		nr_writeback = global_page_state(NR_WRITEBACK) +
> +			global_page_state(NR_WRITEBACK_TEMP);
>  
>  		/*
>  		 * In order to avoid the stacked BDI deadlock we need
> @@ -570,16 +510,48 @@ static void balance_dirty_pages(struct address_space *mapping)
>  			bdi_nr_writeback = bdi_stat(bdi, BDI_WRITEBACK);
>  		}
>  
> +		/* always throttle if over threshold */
> +		if (nr_reclaimable + nr_writeback < dirty_thresh) {
> +
> +			if (bdi_nr_reclaimable + bdi_nr_writeback <= bdi_thresh)
> +				break;
> +
> +			/*
> +			 * Throttle it only when the background writeback cannot
> +			 * catch-up. This avoids (excessively) small writeouts
> +			 * when the bdi limits are ramping up.
> +			 */
> +			if (nr_reclaimable + nr_writeback <
> +			    (background_thresh + dirty_thresh) / 2)
> +				break;
> +
> +			/* done enough? */
> +			if (pages_written >= write_chunk)
> +				break;
> +		}
> +		if (!bdi->dirty_exceeded)
> +			bdi->dirty_exceeded = 1;
>  
> +		/* Note: nr_reclaimable denotes nr_dirty + nr_unstable.
> +		 * Unstable writes are a feature of certain networked
> +		 * filesystems (i.e. NFS) in which data may have been
> +		 * written to the server's write cache, but has not yet
> +		 * been flushed to permanent storage.
> +		 * Only move pages to writeback if this bdi is over its
> +		 * threshold otherwise wait until the disk writes catch
> +		 * up.
> +		 */
> +		if (bdi_nr_reclaimable > bdi_thresh) {
> +			writeback_inodes(&wbc);
> +			pages_written += write_chunk - wbc.nr_to_write;
> +			if (wbc.nr_to_write == 0)
> +				continue;
> +		}
>  		congestion_wait(BLK_RW_ASYNC, HZ/10);
>  	}
>  
>  	if (bdi_nr_reclaimable + bdi_nr_writeback < bdi_thresh &&
> +	    bdi->dirty_exceeded)
>  		bdi->dirty_exceeded = 0;
>  
>  	if (writeback_in_progress(bdi))
> @@ -593,10 +565,8 @@ static void balance_dirty_pages(struct address_space *mapping)
>  	 * In normal mode, we start background writeout at the lower
>  	 * background_thresh, to keep the amount of dirty memory low.
>  	 */
> +	if ((laptop_mode && pages_written) || (!laptop_mode &&
> +	     (nr_reclaimable > background_thresh)))
>  		pdflush_operation(background_writeout, 0);
>  }
>  
> 
> 

