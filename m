Return-Path: <linux-kernel-owner+w=401wt.eu-S1758082AbYFGBGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758082AbYFGBGU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 21:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754017AbYFGBFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 21:05:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37832 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754279AbYFGBFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 21:05:08 -0400
Date: Fri, 6 Jun 2008 18:04:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, lee.schermerhorn@hp.com,
       kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com,
       Lee.Schermerhorn@hp.com, Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH -mm 04/25] free swap space on swap-in/activation
Message-Id: <20080606180430.38bf1d82.akpm@linux-foundation.org>
In-Reply-To: <20080606202858.570020389@redhat.com>
References: <20080606202838.390050172@redhat.com>
	<20080606202858.570020389@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Jun 2008 16:28:42 -0400
Rik van Riel <riel@redhat.com> wrote:

> From: Rik van Riel <riel@redhat.com>
> 
> Free swap cache entries when swapping in pages if vm_swap_full()
> [swap space > 1/2 used].  Uses new pagevec to reduce pressure
> on locks.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>
> Signed-off-by: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
> Signed-off-by: MinChan Kim <minchan.kim@gmail.com>
> 
> ---
>  include/linux/pagevec.h |    1 +
>  include/linux/swap.h    |    6 ++++++
>  mm/swap.c               |   18 ++++++++++++++++++
>  mm/swapfile.c           |   25 ++++++++++++++++++++++---
>  mm/vmscan.c             |    7 +++++++
>  5 files changed, 54 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6.26-rc2-mm1/mm/vmscan.c
> ===================================================================
> --- linux-2.6.26-rc2-mm1.orig/mm/vmscan.c	2008-05-23 14:21:33.000000000 -0400
> +++ linux-2.6.26-rc2-mm1/mm/vmscan.c	2008-05-23 14:21:33.000000000 -0400
> @@ -619,6 +619,9 @@ free_it:
>  		continue;
>  
>  activate_locked:
> +		/* Not a candidate for swapping, so reclaim swap space. */
> +		if (PageSwapCache(page) && vm_swap_full())

The patch puts rather a lot of pressure onto vm_swap_full().  We might
want to look into optimising that.

- Is the 50% thing optimum?  Could go higher and perhaps should be
  based on amount-of-memory.

- Can precalculate the fraction rather than doing it inline all the time.

- Can make total_swap_pages __read_mostly and have a think about
  nr_swap_pages too.

- Can completely optimise the thing away if !CONFIG_SWAP.


Has all this code been tested with CONFIG_SWAP=n?

> Index: linux-2.6.26-rc2-mm1/mm/swap.c
> ===================================================================
> --- linux-2.6.26-rc2-mm1.orig/mm/swap.c	2008-05-23 14:21:33.000000000 -0400
> +++ linux-2.6.26-rc2-mm1/mm/swap.c	2008-05-23 14:21:33.000000000 -0400
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
> +				remove_exclusive_swap_page_ref(page);
> +			unlock_page(page);
> +		}
> +	}
> +}

What's going on here.

Normally we'll bump a page's refcount to account for its presence in a
pagevec.  This code doesn't do that.

Is it safe?  If so, how come?

Suitable code comments should be added which explain this unusual and
dangerous optimisation.  Or fix the bug :)


