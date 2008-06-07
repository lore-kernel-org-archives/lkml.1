Return-Path: <linux-kernel-owner+w=401wt.eu-S1757472AbYFGBGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472AbYFGBGi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 21:06:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756022AbYFGBF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 21:05:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42264 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754454AbYFGBFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 21:05:09 -0400
Date: Fri, 6 Jun 2008 18:04:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, lee.schermerhorn@hp.com,
       kosaki.motohiro@jp.fujitsu.com
Subject: Re: [PATCH -mm 07/25] second chance replacement for anonymous pages
Message-Id: <20080606180443.43f782e2.akpm@linux-foundation.org>
In-Reply-To: <20080606202858.744030156@redhat.com>
References: <20080606202838.390050172@redhat.com>
	<20080606202858.744030156@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Jun 2008 16:28:45 -0400
Rik van Riel <riel@redhat.com> wrote:

> From: Rik van Riel <riel@redhat.com>
> 
> We avoid evicting and scanning anonymous pages for the most part, but
> under some workloads we can end up with most of memory filled with
> anonymous pages.  At that point, we suddenly need to clear the referenced
> bits on all of memory, which can take ages on very large memory systems.
> 
> We can reduce the maximum number of pages that need to be scanned by
> not taking the referenced state into account when deactivating an
> anonymous page.  After all, every anonymous page starts out referenced,
> so why check?
> 
> If an anonymous page gets referenced again before it reaches the end
> of the inactive list, we move it back to the active list.
> 
> To keep the maximum amount of necessary work reasonable, we scale the
> active to inactive ratio with the size of memory, using the formula
> active:inactive ratio = sqrt(memory in GB * 10).

Should be scaled by PAGE_SIZE?

> Kswapd CPU use now seems to scale by the amount of pageout bandwidth,
> instead of by the amount of memory present in the system.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> 
> ---
>  include/linux/mm_inline.h |   12 ++++++++++++
>  include/linux/mmzone.h    |    5 +++++
>  mm/page_alloc.c           |   40 ++++++++++++++++++++++++++++++++++++++++
>  mm/vmscan.c               |   38 +++++++++++++++++++++++++++++++-------
>  mm/vmstat.c               |    6 ++++--
>  5 files changed, 92 insertions(+), 9 deletions(-)
> 
> Index: linux-2.6.26-rc2-mm1/include/linux/mm_inline.h
> ===================================================================
> --- linux-2.6.26-rc2-mm1.orig/include/linux/mm_inline.h	2008-05-23 14:21:34.000000000 -0400
> +++ linux-2.6.26-rc2-mm1/include/linux/mm_inline.h	2008-05-28 12:09:06.000000000 -0400
> @@ -97,4 +97,16 @@ del_page_from_lru(struct zone *zone, str
>  	__dec_zone_state(zone, NR_INACTIVE_ANON + l);
>  }
>  
> +static inline int inactive_anon_low(struct zone *zone)
> +{
> +	unsigned long active, inactive;
> +
> +	active = zone_page_state(zone, NR_ACTIVE_ANON);
> +	inactive = zone_page_state(zone, NR_INACTIVE_ANON);
> +
> +	if (inactive * zone->inactive_ratio < active)
> +		return 1;
> +
> +	return 0;
> +}

inactive_anon_low: "number of inactive anonymous pages which are in lowmem"?

Nope.

Needs a comment.  And maybe a better name, like inactive_anon_is_low. 
Although making the return type a bool kind-of does that.

>  #endif
> Index: linux-2.6.26-rc2-mm1/include/linux/mmzone.h
> ===================================================================
> --- linux-2.6.26-rc2-mm1.orig/include/linux/mmzone.h	2008-05-23 14:21:34.000000000 -0400
> +++ linux-2.6.26-rc2-mm1/include/linux/mmzone.h	2008-05-28 12:09:06.000000000 -0400
> @@ -311,6 +311,11 @@ struct zone {
>  	 */
>  	int prev_priority;
>  
> +	/*
> +	 * The ratio of active to inactive pages.
> +	 */
> +	unsigned int inactive_ratio;

That comment needs a lot of help please.  For a start, it's plain wrong
- inactive_ratio would need to be a float to be able to record that ratio.

The comment should describe the units too.

Now poor-old-reviewer has to go off and work out what this thing is.

>  
>  	ZONE_PADDING(_pad2_)
>  	/* Rarely used or read-mostly fields */
> Index: linux-2.6.26-rc2-mm1/mm/page_alloc.c
> ===================================================================
> --- linux-2.6.26-rc2-mm1.orig/mm/page_alloc.c	2008-05-23 14:21:34.000000000 -0400
> +++ linux-2.6.26-rc2-mm1/mm/page_alloc.c	2008-05-28 12:09:06.000000000 -0400
> @@ -4269,6 +4269,45 @@ void setup_per_zone_pages_min(void)
>  	calculate_totalreserve_pages();
>  }
>  
> +/**
> + * setup_per_zone_inactive_ratio - called when min_free_kbytes changes.
> + *
> + * The inactive anon list should be small enough that the VM never has to
> + * do too much work, but large enough that each inactive page has a chance
> + * to be referenced again before it is swapped out.
> + *
> + * The inactive_anon ratio is the ratio of active to inactive anonymous

target ratio?  Desired ratio?

> + * pages.  Ie. a ratio of 3 means 3:1 or 25% of the anonymous pages are
> + * on the inactive list.
> + *
> + * total     return    max
> + * memory    value     inactive anon

This function doesn't "return" a "value".

> + * -------------------------------------
> + *   10MB       1         5MB
> + *  100MB       1        50MB
> + *    1GB       3       250MB
> + *   10GB      10       0.9GB
> + *  100GB      31         3GB
> + *    1TB     101        10GB
> + *   10TB     320        32GB
> + */
> +void setup_per_zone_inactive_ratio(void)
> +{
> +	struct zone *zone;
> +
> +	for_each_zone(zone) {
> +		unsigned int gb, ratio;
> +
> +		/* Zone size in gigabytes */
> +		gb = zone->present_pages >> (30 - PAGE_SHIFT);
> +		ratio = int_sqrt(10 * gb);
> +		if (!ratio)
> +			ratio = 1;
> +
> +		zone->inactive_ratio = ratio;
> +	}
> +}

OK, so inactive_ratio is an integer 1 ..  N which determines our target
number of inactive pages according to the formula

	nr_inactive = nr_active / inactive_ratio

yes?

Can nr_inactive get larger than this?  I assume so.  I guess that
doesn't matter much.  Except the problems which you're trying to sovle
here can reoccur.   What would I need to do to trigger that?

>  /*
>   * Initialise min_free_kbytes.
>   *
> @@ -4306,6 +4345,7 @@ static int __init init_per_zone_pages_mi
>  		min_free_kbytes = 65536;
>  	setup_per_zone_pages_min();
>  	setup_per_zone_lowmem_reserve();
> +	setup_per_zone_inactive_ratio();
>  	return 0;
>  }
>  module_init(init_per_zone_pages_min)
> Index: linux-2.6.26-rc2-mm1/mm/vmscan.c
> ===================================================================
> --- linux-2.6.26-rc2-mm1.orig/mm/vmscan.c	2008-05-23 14:21:34.000000000 -0400
> +++ linux-2.6.26-rc2-mm1/mm/vmscan.c	2008-05-28 12:11:38.000000000 -0400
> @@ -114,7 +114,7 @@ struct scan_control {
>  /*
>   * From 0 .. 100.  Higher means more swappy.
>   */
> -int vm_swappiness = 60;
> +int vm_swappiness = 20;

<goes back to check the changelog>

Whoa.  Where'd this come from?

>  long vm_total_pages;	/* The total number of pages which the VM controls */
>  
>  static LIST_HEAD(shrinker_list);
> @@ -1008,7 +1008,7 @@ static inline int zone_is_near_oom(struc
>  static void shrink_active_list(unsigned long nr_pages, struct zone *zone,
>  			struct scan_control *sc, int priority, int file)
>  {
> -	unsigned long pgmoved;
> +	unsigned long pgmoved = 0;
>  	int pgdeactivate = 0;
>  	unsigned long pgscanned;
>  	LIST_HEAD(l_hold);	/* The pages which were snipped off */
> @@ -1036,17 +1036,32 @@ static void shrink_active_list(unsigned 
>  		__mod_zone_page_state(zone, NR_ACTIVE_ANON, -pgmoved);
>  	spin_unlock_irq(&zone->lru_lock);
>  
> +	pgmoved = 0;

didn't we just do that?

>  	while (!list_empty(&l_hold)) {
>  		cond_resched();
>  		page = lru_to_page(&l_hold);
>  		list_del(&page->lru);
> -		if (page_referenced(page, 0, sc->mem_cgroup))
> -			list_add(&page->lru, &l_active);
> -		else
> +		if (page_referenced(page, 0, sc->mem_cgroup)) {
> +			if (file) {
> +				/* Referenced file pages stay active. */
> +				list_add(&page->lru, &l_active);
> +			} else {
> +				/* Anonymous pages always get deactivated. */

hm.  That's going to make the machine swap like hell.  I guess I don't
understand all this yet.

> +				list_add(&page->lru, &l_inactive);
> +				pgmoved++;
> +			}
> +		} else
>  			list_add(&page->lru, &l_inactive);
>  	}
>  
>  	/*
> +	 * Count the referenced anon pages as rotated, to balance pageout
> +	 * scan pressure between file and anonymous pages in get_sacn_ratio.

tpyo


