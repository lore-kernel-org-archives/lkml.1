Return-Path: <linux-kernel-owner+w=401wt.eu-S1757044AbYFGBHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757044AbYFGBHX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 21:07:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756089AbYFGBF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 21:05:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59096 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755749AbYFGBFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 21:05:17 -0400
Date: Fri, 6 Jun 2008 18:05:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, lee.schermerhorn@hp.com,
       kosaki.motohiro@jp.fujitsu.com
Subject: Re: [PATCH -mm 11/25] more aggressively use lumpy reclaim
Message-Id: <20080606180501.8d3ef5c6.akpm@linux-foundation.org>
In-Reply-To: <20080606202859.067696707@redhat.com>
References: <20080606202838.390050172@redhat.com>
	<20080606202859.067696707@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Jun 2008 16:28:49 -0400
Rik van Riel <riel@redhat.com> wrote:

> From: Rik van Riel <riel@redhat.com>
> 
> During an AIM7 run on a 16GB system, fork started failing around
> 32000 threads, despite the system having plenty of free swap and
> 15GB of pageable memory.

Can we upadte the changelog to explain why this actually happened?

>From reading the patch I _assume_ that

a) the kernel was using 8k (2-page) stacks and

b) all the memory was stuck on the active list, so reclaim wasn't
   able to find any order-1 pages and wasn't able to find any order-0
   pages which gave it allocatable order-1 pages.

?

> If normal pageout does not result in contiguous free pages for
> kernel stacks, fall back to lumpy reclaim instead of failing fork
> or doing excessive pageout IO.

hm, I guess that this para kinda says that.  Not sure what the
"excessive pageout IO" part is referring to?

> I do not know whether this change is needed due to the extreme
> stress test or because the inactive list is a smaller fraction
> of system memory on huge systems.
> 

I guess that tweaking the inactive_ratio could be used to determine
this?

> 
> ---
>  mm/vmscan.c |   20 ++++++++++++++++----
>  1 file changed, 16 insertions(+), 4 deletions(-)
> 
> Index: linux-2.6.26-rc2-mm1/mm/vmscan.c
> ===================================================================
> --- linux-2.6.26-rc2-mm1.orig/mm/vmscan.c	2008-05-28 12:14:34.000000000 -0400
> +++ linux-2.6.26-rc2-mm1/mm/vmscan.c	2008-05-28 12:14:43.000000000 -0400
> @@ -857,7 +857,8 @@ int isolate_lru_page(struct page *page)
>   * of reclaimed pages
>   */
>  static unsigned long shrink_inactive_list(unsigned long max_scan,
> -			struct zone *zone, struct scan_control *sc, int file)
> +			struct zone *zone, struct scan_control *sc,
> +			int priority, int file)
>  {
>  	LIST_HEAD(page_list);
>  	struct pagevec pvec;
> @@ -875,8 +876,19 @@ static unsigned long shrink_inactive_lis
>  		unsigned long nr_freed;
>  		unsigned long nr_active;
>  		unsigned int count[NR_LRU_LISTS] = { 0, };
> -		int mode = (sc->order > PAGE_ALLOC_COSTLY_ORDER) ?
> -					ISOLATE_BOTH : ISOLATE_INACTIVE;
> +		int mode = ISOLATE_INACTIVE;
> +
> +		/*
> +		 * If we need a large contiguous chunk of memory, or have
> +		 * trouble getting a small set of contiguous pages, we
> +		 * will reclaim both active and inactive pages.
> +		 *
> +		 * We use the same threshold as pageout congestion_wait below.
> +		 */
> +		if (sc->order > PAGE_ALLOC_COSTLY_ORDER)
> +			mode = ISOLATE_BOTH;
> +		else if (sc->order && priority < DEF_PRIORITY - 2)
> +			mode = ISOLATE_BOTH;
>  
>  		nr_taken = sc->isolate_pages(sc->swap_cluster_max,
>  			     &page_list, &nr_scan, sc->order, mode,
> @@ -1171,7 +1183,7 @@ static unsigned long shrink_list(enum lr
>  		shrink_active_list(nr_to_scan, zone, sc, priority, file);
>  		return 0;
>  	}
> -	return shrink_inactive_list(nr_to_scan, zone, sc, file);
> +	return shrink_inactive_list(nr_to_scan, zone, sc, priority, file);
>  }

