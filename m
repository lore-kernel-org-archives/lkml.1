Return-Path: <linux-kernel-owner+w=401wt.eu-S1759615AbXI0Vrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759615AbXI0Vrx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 17:47:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754743AbXI0Vrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 17:47:45 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36717 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753927AbXI0Vro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 17:47:44 -0400
Date: Thu, 27 Sep 2007 14:47:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] kswapd should only wait on IO if there is IO
Message-Id: <20070927144702.a9124c7a.akpm@linux-foundation.org>
In-Reply-To: <20070927170816.055548fd@bree.surriel.com>
References: <20070927170816.055548fd@bree.surriel.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Sep 2007 17:08:16 -0400
Rik van Riel <riel@redhat.com> wrote:

> The current kswapd (and try_to_free_pages) code has an oddity where the
> code will wait on IO, even if there is no IO in flight.  This problem is
> notable especially when the system scans through many unfreeable pages,
> causing unnecessary stalls in the VM.
> 

What effect did this change have?

> 
> diff -up linux-2.6.22.x86_64/mm/vmscan.c.wait linux-2.6.22.x86_64/mm/vmscan.c
> --- linux-2.6.22.x86_64/mm/vmscan.c.wait	2007-09-25 11:33:30.000000000 -0400
> +++ linux-2.6.22.x86_64/mm/vmscan.c	2007-09-25 21:27:08.000000000 -0400
> @@ -68,6 +68,8 @@ struct scan_control {
>  	int all_unreclaimable;
>  
>  	int order;
> +
> +	int nr_io_pages;
>  };
>  
>  #define lru_to_page(_head) (list_entry((_head)->prev, struct page, lru))
> @@ -489,8 +491,10 @@ static unsigned long shrink_page_list(st
>  			 */
>  			if (sync_writeback == PAGEOUT_IO_SYNC && may_enter_fs)
>  				wait_on_page_writeback(page);
> -			else
> +			else {
> +				sc->nr_io_pages++;
>  				goto keep_locked;
> +			}
>  		}
>  
>  		referenced = page_referenced(page, 1);
> @@ -541,8 +545,10 @@ static unsigned long shrink_page_list(st
>  			case PAGE_ACTIVATE:
>  				goto activate_locked;
>  			case PAGE_SUCCESS:
> -				if (PageWriteback(page) || PageDirty(page))
> +				if (PageWriteback(page) || PageDirty(page)) {
> +					sc->nr_io_pages++;
>  					goto keep;
> +				}
>  				/*
>  				 * A synchronous write - probably a ramdisk.  Go
>  				 * ahead and try to reclaim the page.
> @@ -1201,6 +1207,7 @@ unsigned long try_to_free_pages(struct z
>  
>  	for (priority = DEF_PRIORITY; priority >= 0; priority--) {
>  		sc.nr_scanned = 0;
> +		sc.nr_io_pages = 0;
>  		if (!priority)
>  			disable_swap_token();
>  		nr_reclaimed += shrink_zones(priority, zones, &sc);
> @@ -1229,7 +1236,8 @@ unsigned long try_to_free_pages(struct z
>  		}
>  
>  		/* Take a nap, wait for some writeback to complete */
> -		if (sc.nr_scanned && priority < DEF_PRIORITY - 2)
> +		if (sc.nr_scanned && priority < DEF_PRIORITY - 2 &&
> +				sc.nr_io_pages > sc.swap_cluster_max)

The comparison with swap_cluster_max is unobvious, and merits a
comment.  What is the thinking here?  


Also, we now have this:

		if (total_scanned > sc.swap_cluster_max +
					sc.swap_cluster_max / 2) {
			wakeup_pdflush(laptop_mode ? 0 : total_scanned);
			sc.may_writepage = 1;
		}

		/* Take a nap, wait for some writeback to complete */
		if (sc.nr_scanned && priority < DEF_PRIORITY - 2 &&
				sc.nr_io_pages > sc.swap_cluster_max)
			congestion_wait(WRITE, HZ/10);


So in the case where total_scanned has not yet reached
swap_cluster_max, this process isn't initiating writeout and it isn't
sleeping, either.  Nor is it incrementing nr_io_pages.

In the range (swap_cluster_max < nr_io_pages < 1.5*swap_cluster_max) this
process still isn't incrementing nr_io_pages, but it _is_ running
congestion_wait().

Once nr_io_pages exceeds 1.5*swap_cluster_max, this process is both
initiating IO and is throttling on writeback completion events.

This all seems a bit weird and arbitrary - what is the reason for
throttling-but-not-writing in that 1.0->1.5 window?

If there _is_ a reason and it's all been carefully thought out and
designed, then can we please capture a description of that design in the
changelog or in the code?



Also, I wonder about what this change will do to the dynamic behaviour of
GFP_NOFS direct-reclaimers.  Previously they would throttle if they
encounter dirty pages which they can't write out.  Hopefully someone else
(kswapd or a __GFP_FS direct-reclaimer) will write some of those pages
and this caller will be woken when that writeout completes and will go off
and scoop them off the tail of the LRU.

But after this change, such a GFP_NOFS caller will, afacit, burn its way
through potentially the entire inactive list and will then declare oom. 
Non-preemtible uniprocessor kernels would be most at risk from this.


>  			congestion_wait(WRITE, HZ/10);
>  	}
>  	/* top priority shrink_caches still had more to do? don't OOM, then */
> @@ -1315,6 +1323,7 @@ loop_again:
>  		if (!priority)
>  			disable_swap_token();
>  
> +		sc.nr_io_pages = 0;
>  		all_zones_ok = 1;
>  
>  		/*
> @@ -1398,7 +1407,8 @@ loop_again:
>  		 * OK, kswapd is getting into trouble.  Take a nap, then take
>  		 * another pass across the zones.
>  		 */
> -		if (total_scanned && priority < DEF_PRIORITY - 2)
> +		if (total_scanned && priority < DEF_PRIORITY - 2 &&
> +					sc.nr_io_pages > sc.swap_cluster_max)
>  			congestion_wait(WRITE, HZ/10);
>  
>  		/*
