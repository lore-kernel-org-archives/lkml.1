Return-Path: <linux-kernel-owner+w=401wt.eu-S932288AbXHUPTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932288AbXHUPTa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 11:19:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760807AbXHUPTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 11:19:13 -0400
Received: from gir.skynet.ie ([193.1.99.77]:58581 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760564AbXHUPTL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 11:19:11 -0400
Date: Tue, 21 Aug 2007 16:19:08 +0100
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, dkegel@google.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       David Miller <davem@davemloft.net>, Nick Piggin <npiggin@suse.de>
Subject: Re: [RFC 5/7] Laundry handling for direct reclaim
Message-ID: <20070821151907.GM11329@skynet.ie>
References: <20070820215040.937296148@sgi.com> <20070820215316.994224842@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20070820215316.994224842@sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (20/08/07 14:50), Christoph Lameter didst pronounce:
> Direct reclaim collects a global laundry list in try_to_free_pages().
> 
> Pages are only written back after a reclaim pass is complete.
> 
> Signed-off-by: Christoph Lameter <clameter@sgi.com>
> 
> ---
>  mm/vmscan.c |   12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6/mm/vmscan.c
> ===================================================================
> --- linux-2.6.orig/mm/vmscan.c	2007-08-19 23:30:15.000000000 -0700
> +++ linux-2.6/mm/vmscan.c	2007-08-19 23:53:43.000000000 -0700
> @@ -1099,7 +1099,7 @@ static unsigned long shrink_zone(int pri
>   * scan then give up on it.
>   */
>  static unsigned long shrink_zones(int priority, struct zone **zones,
> -					struct scan_control *sc)
> +			struct scan_control *sc, struct list_head *laundry)
>  {
>  	unsigned long nr_reclaimed = 0;
>  	int i;
> @@ -1121,7 +1121,7 @@ static unsigned long shrink_zones(int pr
>  
>  		sc->all_unreclaimable = 0;
>  
> -		nr_reclaimed += shrink_zone(priority, zone, sc, NULL);
> +		nr_reclaimed += shrink_zone(priority, zone, sc, laundry);
>  	}
>  	return nr_reclaimed;
>  }
> @@ -1156,6 +1156,7 @@ unsigned long try_to_free_pages(struct z
>  		.swappiness = vm_swappiness,
>  		.order = order,
>  	};
> +	LIST_HEAD(laundry);
>  
>  	count_vm_event(ALLOCSTALL);
>  
> @@ -1170,16 +1171,19 @@ unsigned long try_to_free_pages(struct z
>  	}
>  
>  	for (priority = DEF_PRIORITY; priority >= 0; priority--) {
> +
>  		sc.nr_scanned = 0;
>  		if (!priority)
>  			disable_swap_token();
> -		nr_reclaimed += shrink_zones(priority, zones, &sc);
> +		nr_reclaimed += shrink_zones(priority, zones, &sc, &laundry);
>  		shrink_slab(sc.nr_scanned, gfp_mask, lru_pages);
>  		if (reclaim_state) {
>  			nr_reclaimed += reclaim_state->reclaimed_slab;
>  			reclaim_state->reclaimed_slab = 0;
>  		}
> +
>  		total_scanned += sc.nr_scanned;
> +

Could this not isolate a load of dirty pages on the laundry list and then
shortly later go to sleep in congestion_wait() ? It would appear that with
writeout deferred that the going to sleep is going to do nothing to help
the situation.

>  		if (nr_reclaimed >= sc.swap_cluster_max) {
>  			ret = 1;
>  			goto out;
> @@ -1223,6 +1227,8 @@ out:
>  
>  		zone->prev_priority = priority;
>  	}
> +	nr_reclaimed += shrink_page_list(&laundry, &sc, NULL);
> +	release_lru_pages(&laundry);
>  	return ret;
>  }
>  

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
