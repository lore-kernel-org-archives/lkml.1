Return-Path: <linux-kernel-owner+w=401wt.eu-S1764790AbYB1UG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764790AbYB1UG1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 15:06:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752132AbYB1UFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 15:05:48 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:16666 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbYB1UFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 15:05:47 -0500
Subject: Re: [patch 04/21] free swap space on swap-in/activation
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org
In-Reply-To: <20080228192928.251195952@redhat.com>
References: <20080228192908.126720629@redhat.com>
	 <20080228192928.251195952@redhat.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Thu, 28 Feb 2008 15:05:53 -0500
Message-Id: <1204229154.5301.22.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-02-28 at 14:29 -0500, Rik van Riel wrote:
> plain text document attachment (rvr-00-linux-2.6-swapfree.patch)
> + lts' convert anon_vma list lock to reader/write lock patch
> + Nick Piggin's move and rework isolate_lru_page() patch

Hi, Rik:

We no long depend on the anon_vma rwlock patch, right?   And, since
they're now all part of the same series, we can probably loose the note
about depending on Nick's move/rework patch.  These are hold overs from
my overly paranoid dependency annotations.  We can fix the description
on next posting.  [Or am I being too pessimistic?]

Lee

> 
> Free swap cache entries when swapping in pages if vm_swap_full()
> [swap space > 1/2 used?].  Uses new pagevec to reduce pressure
> on locks.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>
> Signed-off-by: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
> 
> Index: linux-2.6.25-rc2-mm1/mm/vmscan.c
> ===================================================================
> --- linux-2.6.25-rc2-mm1.orig/mm/vmscan.c	2008-02-27 14:19:47.000000000 -0500
> +++ linux-2.6.25-rc2-mm1/mm/vmscan.c	2008-02-27 14:35:47.000000000 -0500
> @@ -632,6 +632,9 @@ free_it:
>  		continue;
>  
>  activate_locked:
> +		/* Not a candidate for swapping, so reclaim swap space. */
> +		if (PageSwapCache(page) && vm_swap_full())
> +			remove_exclusive_swap_page(page);
>  		SetPageActive(page);
>  		pgactivate++;
>  keep_locked:
> @@ -1214,6 +1217,8 @@ static void shrink_active_list(unsigned 
>  			__mod_zone_page_state(zone, NR_ACTIVE, pgmoved);
>  			pgmoved = 0;
>  			spin_unlock_irq(&zone->lru_lock);
> +			if (vm_swap_full())
> +				pagevec_swap_free(&pvec);
>  			__pagevec_release(&pvec);
>  			spin_lock_irq(&zone->lru_lock);
>  		}
> @@ -1223,6 +1228,8 @@ static void shrink_active_list(unsigned 
>  	__count_zone_vm_events(PGREFILL, zone, pgscanned);
>  	__count_vm_events(PGDEACTIVATE, pgdeactivate);
>  	spin_unlock_irq(&zone->lru_lock);
> +	if (vm_swap_full())
> +		pagevec_swap_free(&pvec);
>  
>  	pagevec_release(&pvec);
>  }
> Index: linux-2.6.25-rc2-mm1/mm/swap.c
> ===================================================================
> --- linux-2.6.25-rc2-mm1.orig/mm/swap.c	2008-02-27 14:31:35.000000000 -0500
> +++ linux-2.6.25-rc2-mm1/mm/swap.c	2008-02-27 14:35:47.000000000 -0500
> @@ -448,6 +448,24 @@ void pagevec_strip(struct pagevec *pvec)
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
> Index: linux-2.6.25-rc2-mm1/include/linux/pagevec.h
> ===================================================================
> --- linux-2.6.25-rc2-mm1.orig/include/linux/pagevec.h	2008-02-27 13:41:27.000000000 -0500
> +++ linux-2.6.25-rc2-mm1/include/linux/pagevec.h	2008-02-27 14:35:47.000000000 -0500
> @@ -25,6 +25,7 @@ void __pagevec_release_nonlru(struct pag
>  void __pagevec_free(struct pagevec *pvec);
>  void ____pagevec_lru_add(struct pagevec *pvec, enum lru_list lru);
>  void pagevec_strip(struct pagevec *pvec);
> +void pagevec_swap_free(struct pagevec *pvec);
>  unsigned pagevec_lookup(struct pagevec *pvec, struct address_space *mapping,
>  		pgoff_t start, unsigned nr_pages);
>  unsigned pagevec_lookup_tag(struct pagevec *pvec,
> 

