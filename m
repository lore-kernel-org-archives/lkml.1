Return-Path: <linux-kernel-owner+w=401wt.eu-S1755355AbYFGBFO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbYFGBFO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 21:05:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751709AbYFGBE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 21:04:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60687 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751403AbYFGBE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 21:04:58 -0400
Date: Fri, 6 Jun 2008 18:04:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, lee.schermerhorn@hp.com,
       kosaki.motohiro@jp.fujitsu.com, clameter@sgi.com
Subject: Re: [PATCH -mm 02/25] Use an indexed array for LRU variables
Message-Id: <20080606180426.89989a07.akpm@linux-foundation.org>
In-Reply-To: <20080606202858.449902618@redhat.com>
References: <20080606202838.390050172@redhat.com>
	<20080606202858.449902618@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Jun 2008 16:28:40 -0400
Rik van Riel <riel@redhat.com> wrote:

> From: Christoph Lameter <clameter@sgi.com>
> 
> Currently we are defining explicit variables for the inactive
> and active list. An indexed array can be more generic and avoid
> repeating similar code in several places in the reclaim code.
> 
> We are saving a few bytes in terms of code size:
> 
> Before:
> 
>    text    data     bss     dec     hex filename
> 4097753  573120 4092484 8763357  85b7dd vmlinux
> 
> After:
> 
>    text    data     bss     dec     hex filename
> 4097729  573120 4092484 8763333  85b7c5 vmlinux
> 
> Having an easy way to add new lru lists may ease future work on
> the reclaim code.

I would have spat the dummy at pointless churn and code uglification
but I see that we end up with five LRU lsits so ho hum.

>
> ...
>
>  
>  	/* Fields commonly accessed by the page reclaim scanner */
>  	spinlock_t		lru_lock;	
> -	struct list_head	active_list;
> -	struct list_head	inactive_list;
> -	unsigned long		nr_scan_active;
> -	unsigned long		nr_scan_inactive;
> +	struct list_head	list[NR_LRU_LISTS];
> +	unsigned long		nr_scan[NR_LRU_LISTS];

It'd be a little cache-friendlier to lay this out as

	struct {
		struct list_head list;
		unsigned long nr_scan;
	} lru_stuff[NR_LRU_LISTS];


>  	unsigned long		pages_scanned;	   /* since last reclaim */
>  	unsigned long		flags;		   /* zone flags, see below */
>  
> Index: linux-2.6.26-rc2-mm1/include/linux/mm_inline.h
> ===================================================================
> --- linux-2.6.26-rc2-mm1.orig/include/linux/mm_inline.h	2008-05-23 14:21:21.000000000 -0400
> +++ linux-2.6.26-rc2-mm1/include/linux/mm_inline.h	2008-05-23 14:21:33.000000000 -0400
> @@ -1,40 +1,51 @@
>  static inline void
> +add_page_to_lru_list(struct zone *zone, struct page *page, enum lru_list l)
> +{
> +	list_add(&page->lru, &zone->list[l]);
> +	__inc_zone_state(zone, NR_INACTIVE + l);

                               ^ that's a bug, isn't it?

oh, no it isn't.

Can we rename NR_INACTIVE?  Maybe VMSCAN_BASE or something?

> +}
> +
>
> ...
>
> @@ -945,10 +945,7 @@ static unsigned long shrink_inactive_lis
>  			VM_BUG_ON(PageLRU(page));
>  			SetPageLRU(page);
>  			list_del(&page->lru);
> -			if (PageActive(page))
> -				add_page_to_active_list(zone, page);
> -			else
> -				add_page_to_inactive_list(zone, page);
> +			add_page_to_lru_list(zone, page, PageActive(page));

urgh.  the third arg to add_page_to_lru_list() is an `enum lru_list'
and here we are secretly coercing PageActive()'s boolean return into a
just-happens-to-be-right `enum lru_list'.

That's pretty nasty?

>  			if (!pagevec_add(&pvec, page)) {
>  				spin_unlock_irq(&zone->lru_lock);
>  				__pagevec_release(&pvec);
>
> ...
>
> +static unsigned long shrink_list(enum lru_list l, unsigned long nr_to_scan,
> +	struct zone *zone, struct scan_control *sc, int priority)
> +{
> +	if (l == LRU_ACTIVE) {
> +		shrink_active_list(nr_to_scan, zone, sc, priority);
> +		return 0;
> +	}
> +	return shrink_inactive_list(nr_to_scan, zone, sc);
> +}

I guess a lot of this code gets changed a lot later on.

>
> ...
>

