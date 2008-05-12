Return-Path: <linux-kernel-owner+w=401wt.eu-S1758572AbYELLXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758572AbYELLXU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 07:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753974AbYELLXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 07:23:11 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:64008 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250AbYELLXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 07:23:10 -0400
Message-Id: <4828283C.4000803@mxp.nes.nec.co.jp>
Date: Mon, 12 May 2008 20:21:32 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: lee.schermerhorn@hp.com, akpm@linux-foundation.org,
       kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 05/15] free swap space on swap-in/activation
References: <20080428181835.502876582@redhat.com> <20080428181852.620969450@redhat.com>
In-Reply-To: <20080428181852.620969450@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

I have a question about the intention of this patch.

I think all the remove_exclusive_swap_page() you have added
are called while the _count of the page is incremented by
__isolate_lru_page().

So, IMHO, swap caches that will be freed by this patch should have
page counts from __isolate_lru_page() and the swap cache itself.

They are different from, for example, those are freed by do_swap_page()
-> remove_exclusive_swap_page(), that is, swap caches
that have been just mapped and have page counts from
the process(only user of the page) and the swap cache itself.

So, the intention of this patch is
not to free a swap space of swap cache that has already swapped in
and only used one process as do_swap_page() does,
but to free a swap space that is only used as a swap cache
(not used by any processes), right?


Regards,
Daisuke Nishimura.

Rik van Riel wrote:
> Free swap cache entries when swapping in pages if vm_swap_full()
> [swap space > 1/2 used].  Uses new pagevec to reduce pressure
> on locks.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>
> Signed-off-by: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
> 
> Index: linux-2.6.25-mm1/mm/vmscan.c
> ===================================================================
> --- linux-2.6.25-mm1.orig/mm/vmscan.c	2008-04-24 10:46:43.000000000 -0400
> +++ linux-2.6.25-mm1/mm/vmscan.c	2008-04-24 11:59:56.000000000 -0400
> @@ -619,6 +619,9 @@ free_it:
>  		continue;
>  
>  activate_locked:
> +		/* Not a candidate for swapping, so reclaim swap space. */
> +		if (PageSwapCache(page) && vm_swap_full())
> +			remove_exclusive_swap_page(page);
>  		SetPageActive(page);
>  		pgactivate++;
>  keep_locked:
> @@ -1203,6 +1206,8 @@ static void shrink_active_list(unsigned 
>  			__mod_zone_page_state(zone, NR_ACTIVE, pgmoved);
>  			pgmoved = 0;
>  			spin_unlock_irq(&zone->lru_lock);
> +			if (vm_swap_full())
> +				pagevec_swap_free(&pvec);
>  			__pagevec_release(&pvec);
>  			spin_lock_irq(&zone->lru_lock);
>  		}
> @@ -1212,6 +1217,8 @@ static void shrink_active_list(unsigned 
>  	__count_zone_vm_events(PGREFILL, zone, pgscanned);
>  	__count_vm_events(PGDEACTIVATE, pgdeactivate);
>  	spin_unlock_irq(&zone->lru_lock);
> +	if (vm_swap_full())
> +		pagevec_swap_free(&pvec);
>  
>  	pagevec_release(&pvec);
>  }
> Index: linux-2.6.25-mm1/mm/swap.c
> ===================================================================
> --- linux-2.6.25-mm1.orig/mm/swap.c	2008-04-24 11:59:51.000000000 -0400
> +++ linux-2.6.25-mm1/mm/swap.c	2008-04-24 11:59:56.000000000 -0400
> @@ -443,6 +443,24 @@ void pagevec_strip(struct pagevec *pvec)
>  	}
>  }
>  
> +/*
> + * Try to free swap space from the pages in a pagevec
> + */
> +void pagevec_swap_free(struct pagevec *pvec)
> +{
> +	int i;
> +
> +	for (i = 0; i < pagevec_count(pvec); i++) {
> +		struct page *page = pvec->pages[i];
> +
> +		if (PageSwapCache(page) && !TestSetPageLocked(page)) {
> +			if (PageSwapCache(page))
> +				remove_exclusive_swap_page(page);
> +			unlock_page(page);
> +		}
> +	}
> +}
> +
>  /**
>   * pagevec_lookup - gang pagecache lookup
>   * @pvec:	Where the resulting pages are placed
> Index: linux-2.6.25-mm1/include/linux/pagevec.h
> ===================================================================
> --- linux-2.6.25-mm1.orig/include/linux/pagevec.h	2008-04-24 11:59:51.000000000 -0400
> +++ linux-2.6.25-mm1/include/linux/pagevec.h	2008-04-24 11:59:56.000000000 -0400
> @@ -25,6 +25,7 @@ void __pagevec_release_nonlru(struct pag
>  void __pagevec_free(struct pagevec *pvec);
>  void ____pagevec_lru_add(struct pagevec *pvec, enum lru_list lru);
>  void pagevec_strip(struct pagevec *pvec);
> +void pagevec_swap_free(struct pagevec *pvec);
>  unsigned pagevec_lookup(struct pagevec *pvec, struct address_space *mapping,
>  		pgoff_t start, unsigned nr_pages);
>  unsigned pagevec_lookup_tag(struct pagevec *pvec,
> 

