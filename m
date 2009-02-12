Return-Path: <linux-kernel-owner+w=401wt.eu-S1758534AbZBLL0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758534AbZBLL0o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 06:26:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756743AbZBLL0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 06:26:36 -0500
Received: from cmpxchg.org ([85.214.51.133]:56346 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756788AbZBLL0f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 06:26:35 -0500
Date: Thu, 12 Feb 2009 12:25:58 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: MinChan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH v2]  shrink_all_memory() use sc.nr_reclaimed
Message-ID: <20090212112557.GA6677@cmpxchg.org>
References: <20090212163310.b204e80a.minchan.kim@barrios-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090212163310.b204e80a.minchan.kim@barrios-desktop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 12, 2009 at 04:33:10PM +0900, MinChan Kim wrote:
> 
> Impact: cleanup
> 
> Commit a79311c14eae4bb946a97af25f3e1b17d625985d "vmscan: bail out of
> direct reclaim after swap_cluster_max pages" moved the nr_reclaimed
> counter into the scan control to accumulate the number of all
> reclaimed pages in a reclaim invocation.
> 
> The shrink_all_memory() can use the same mechanism. it increases code
> consistency and readability.
> 
> It's based on mmtom 2009-02-11-17-15.
> 
> Signed-off-by: MinChan Kim <minchan.kim@gmail.com>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> Cc: Rik van Riel <riel@redhat.com>
> 
> 
> ---
>  mm/vmscan.c |   51 ++++++++++++++++++++++++++++++---------------------
>  1 files changed, 30 insertions(+), 21 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index ae4202b..caa2de5 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2055,16 +2055,15 @@ unsigned long global_lru_pages(void)
>  #ifdef CONFIG_PM
>  /*
>   * Helper function for shrink_all_memory().  Tries to reclaim 'nr_pages' pages
> - * from LRU lists system-wide, for given pass and priority, and returns the
> - * number of reclaimed pages
> + * from LRU lists system-wide, for given pass and priority.
>   *
>   * For pass > 3 we also try to shrink the LRU lists that contain a few pages
>   */
> -static unsigned long shrink_all_zones(unsigned long nr_pages, int prio,
> +static void shrink_all_zones(unsigned long nr_pages, int prio,
>  				      int pass, struct scan_control *sc)
>  {
>  	struct zone *zone;
> -	unsigned long ret = 0;
> +	unsigned long nr_reclaimed = 0;

Why this extra variable?  You could use sc->nr_reclaimed throughout,
like you do in shrink_all_memory().

>  	for_each_populated_zone(zone) {
>  		enum lru_list l;
> @@ -2087,14 +2086,16 @@ static unsigned long shrink_all_zones(unsigned long nr_pages, int prio,
>  
>  				zone->lru[l].nr_scan = 0;
>  				nr_to_scan = min(nr_pages, lru_pages);
> -				ret += shrink_list(l, nr_to_scan, zone,
> +				nr_reclaimed += shrink_list(l, nr_to_scan, zone,
>  								sc, prio);
> -				if (ret >= nr_pages)
> -					return ret;
> +				if (nr_reclaimed >= nr_pages) {
> +					sc->nr_reclaimed = nr_reclaimed;
> +					return;
> +				}
>  			}
>  		}
>  	}
> -	return ret;
> +	sc->nr_reclaimed = nr_reclaimed;
>  }
>  
>  /*
> @@ -2126,13 +2127,15 @@ unsigned long shrink_all_memory(unsigned long nr_pages)
>  	/* If slab caches are huge, it's better to hit them first */
>  	while (nr_slab >= lru_pages) {
>  		reclaim_state.reclaimed_slab = 0;
> -		shrink_slab(nr_pages, sc.gfp_mask, lru_pages);
> +		shrink_slab(sc.swap_cluster_max, sc.gfp_mask, lru_pages);
>  		if (!reclaim_state.reclaimed_slab)
>  			break;
>  
> -		ret += reclaim_state.reclaimed_slab;
> -		if (ret >= nr_pages)
> +		sc.nr_reclaimed += reclaim_state.reclaimed_slab;
> +		if (sc.nr_reclaimed >= sc.swap_cluster_max) {
> +			ret = sc.nr_reclaimed;

Why do you still maintain `ret'?  Just return sc.nr_reclaimed at the
end and get rid of ret alltogether.

Using sc.swap_cluster_max here seems to be a good idea at first sight
but really it is not.

Usually, swap_cluster_max is smaller than the reclaim goal and reclaim
code uses it combined with other conditions to bail out BEFORE the
original reclaim goal is met.  But sc.swap_cluster_max IS our original
reclaim goal, so it means something different.

It's btw buggy, we never decrease swap_cluster_max which leads to
funky overreclaim in shrink_inactive_list().  I will send the original
patch from Kosaki-san for using sc->nr_reclaimed and a patch for the
overreclaim problem.

	Hannes
