Return-Path: <linux-kernel-owner+w=401wt.eu-S1758684AbZELH1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758684AbZELH1A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 03:27:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755800AbZELH0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 03:26:51 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:25311 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755834AbZELH0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 03:26:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=WUJNEJJFaeZoMAgIgXK5U+4g4q+b98v6PnBgoEzICOXG/XkyQ++KYIqDjf89rSIzPa
         WToW5o0wKLlT91l0VgFml/qxS7TdzqTWfVRopxIEDjphLNnTBoT/TvxntoIowIWI7nEt
         XKlxCSjKv/U1NkNiwAUeyN9PGGxxqgLQmq2BA=
Date: Tue, 12 May 2009 16:26:33 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "riel@redhat.com" <riel@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "cl@linux-foundation.org" <cl@linux-foundation.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>
Subject: Re: [PATCH -mm] vmscan: merge duplicate code in
 shrink_active_list()
Message-Id: <20090512162633.352313d6.minchan.kim@barrios-desktop>
In-Reply-To: <20090512025319.GD7518@localhost>
References: <20090430195439.e02edc26.akpm@linux-foundation.org>
	<49FB01C1.6050204@redhat.com>
	<20090501123541.7983a8ae.akpm@linux-foundation.org>
	<20090503031539.GC5702@localhost>
	<1241432635.7620.4732.camel@twins>
	<20090507121101.GB20934@localhost>
	<20090507151039.GA2413@cmpxchg.org>
	<20090507134410.0618b308.akpm@linux-foundation.org>
	<20090508081608.GA25117@localhost>
	<20090508125859.210a2a25.akpm@linux-foundation.org>
	<20090512025319.GD7518@localhost>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 May 2009 10:53:19 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

> The "move pages to active list" and "move pages to inactive list"
> code blocks are mostly identical and can be served by a function.
> 
> Thanks to Andrew Morton for pointing this out.
> 
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  mm/vmscan.c |   84 ++++++++++++++++++++------------------------------
>  1 file changed, 35 insertions(+), 49 deletions(-)
> 
> --- linux.orig/mm/vmscan.c
> +++ linux/mm/vmscan.c
> @@ -1225,6 +1225,36 @@ static inline void note_zone_scanning_pr
>   * But we had to alter page->flags anyway.
>   */
>  
> +void move_active_pages_to_lru(enum lru_list lru, struct list_head *list)
> +{
> +	unsigned long pgmoved = 0;
> +
> +	while (!list_empty(&list)) {
> +		page = lru_to_page(&list);
> +		prefetchw_prev_lru_page(page, &list, flags);
> +
> +		VM_BUG_ON(PageLRU(page));
> +		SetPageLRU(page);
> +
> +		VM_BUG_ON(!PageActive(page));
> +		if (lru < LRU_ACTIVE)
> +			ClearPageActive(page);

Arithmetic on the LRU list is not good code for redability, I think. 
How about adding comment? 

if (lru < LRU_ACTIVE) /* In case of moving from active list to inactive */

Ignore me if you think this is trivial. 
I am okay. 

> +
> +		list_move(&page->lru, &zone->lru[lru].list);
> +		mem_cgroup_add_lru_list(page, lru);
> +		pgmoved++;
> +		if (!pagevec_add(&pvec, page)) {
> +			spin_unlock_irq(&zone->lru_lock);
> +			if (buffer_heads_over_limit)
> +				pagevec_strip(&pvec);
> +			__pagevec_release(&pvec);
> +			spin_lock_irq(&zone->lru_lock);
> +		}
> +	}
> +	__mod_zone_page_state(zone, NR_LRU_BASE + lru, pgmoved);
> +	if (lru < LRU_ACTIVE)
> +		__count_vm_events(PGDEACTIVATE, pgmoved);
> +}
>  
>  static void shrink_active_list(unsigned long nr_pages, struct zone *zone,
>  			struct scan_control *sc, int priority, int file)
> @@ -1254,6 +1284,7 @@ static void shrink_active_list(unsigned 
>  	}
>  	reclaim_stat->recent_scanned[!!file] += pgmoved;
>  
> +	__count_zone_vm_events(PGREFILL, zone, pgscanned);
>  	if (file)
>  		__mod_zone_page_state(zone, NR_ACTIVE_FILE, -pgmoved);
>  	else
> @@ -1293,65 +1324,20 @@ static void shrink_active_list(unsigned 
>  	}
>  
>  	/*
> -	 * Move the pages to the [file or anon] inactive list.
> +	 * Move pages back to the lru list.
>  	 */
>  	pagevec_init(&pvec, 1);
>  
>  	spin_lock_irq(&zone->lru_lock);
>  	/*
> -	 * Count referenced pages from currently used mappings as
> -	 * rotated, even though they are moved to the inactive list.
> +	 * Count referenced pages from currently used mappings as rotated.
>  	 * This helps balance scan pressure between file and anonymous
>  	 * pages in get_scan_ratio.
>  	 */
>  	reclaim_stat->recent_rotated[!!file] += pgmoved;
>  
> -	pgmoved = 0;  /* count pages moved to inactive list */
> -	lru = LRU_BASE + file * LRU_FILE;
> -	while (!list_empty(&l_inactive)) {
> -		page = lru_to_page(&l_inactive);
> -		prefetchw_prev_lru_page(page, &l_inactive, flags);
> -		VM_BUG_ON(PageLRU(page));
> -		SetPageLRU(page);
> -		VM_BUG_ON(!PageActive(page));
> -		ClearPageActive(page);
> -
> -		list_move(&page->lru, &zone->lru[lru].list);
> -		mem_cgroup_add_lru_list(page, lru);
> -		pgmoved++;
> -		if (!pagevec_add(&pvec, page)) {
> -			spin_unlock_irq(&zone->lru_lock);
> -			if (buffer_heads_over_limit)
> -				pagevec_strip(&pvec);
> -			__pagevec_release(&pvec);
> -			spin_lock_irq(&zone->lru_lock);
> -		}
> -	}
> -	__mod_zone_page_state(zone, NR_LRU_BASE + lru, pgmoved);
> -	__count_zone_vm_events(PGREFILL, zone, pgscanned);
> -	__count_vm_events(PGDEACTIVATE, pgmoved);
> -
> -	pgmoved = 0;  /* count pages moved back to active list */
> -	lru = LRU_ACTIVE + file * LRU_FILE;
> -	while (!list_empty(&l_active)) {
> -		page = lru_to_page(&l_active);
> -		prefetchw_prev_lru_page(page, &l_active, flags);
> -		VM_BUG_ON(PageLRU(page));
> -		SetPageLRU(page);
> -		VM_BUG_ON(!PageActive(page));
> -
> -		list_move(&page->lru, &zone->lru[lru].list);
> -		mem_cgroup_add_lru_list(page, lru);
> -		pgmoved++;
> -		if (!pagevec_add(&pvec, page)) {
> -			spin_unlock_irq(&zone->lru_lock);
> -			if (buffer_heads_over_limit)
> -				pagevec_strip(&pvec);
> -			__pagevec_release(&pvec);
> -			spin_lock_irq(&zone->lru_lock);
> -		}
> -	}
> -	__mod_zone_page_state(zone, NR_LRU_BASE + lru, pgmoved);
> +	move_active_pages_to_lru(LRU_ACTIVE + file * LRU_FILE, &l_active);
> +	move_active_pages_to_lru(LRU_BASE   + file * LRU_FILE, &l_inactive);
>  
>  	spin_unlock_irq(&zone->lru_lock);
>  	if (buffer_heads_over_limit)


-- 
Kinds Regards
Minchan Kim
