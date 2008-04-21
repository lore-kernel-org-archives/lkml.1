Return-Path: <linux-kernel-owner+w=401wt.eu-S1758085AbYDULle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758085AbYDULle (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 07:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755786AbYDULlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 07:41:12 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:44379 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755634AbYDULlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 07:41:10 -0400
Date: Mon, 21 Apr 2008 12:56:04 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Mel Gorman <mel@csn.ul.ie>, Shi Weihua <shiwh@cn.fujitsu.com>,
       akpm@linux-foundation.org, balbir@linux.vnet.ibm.com, xemul@openvz.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH]Fix usemap for DISCONTIG/FLATMEM with not-aligned zone
 initilaization.
In-Reply-To: <20080421112048.78f0ec76.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0804211250000.16476@blonde.site>
References: <20080418161522.GB9147@csn.ul.ie> <48080706.50305@cn.fujitsu.com>
 <48080930.5090905@cn.fujitsu.com> <48080B86.7040200@cn.fujitsu.com>
 <20080418211214.299f91cd.kamezawa.hiroyu@jp.fujitsu.com>
 <21878461.1208539556838.kamezawa.hiroyu@jp.fujitsu.com>
 <20080421112048.78f0ec76.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Apr 2008, KAMEZAWA Hiroyuki wrote:
> usemap must be initialized only when pfn is within zone.
> If not, it corrupts memory.
> 
> After intialization, usemap is used for only pfn in valid range.
> (We have to init memmap even in invalid range.)
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Not something I know enough about to ACK, but this does look
easier than your earlier one (and even if Mel's had fixed it,
though it may be good for 2.6.26, it might not be for stable).

A few doubts below...

> 
> ---
>  mm/page_alloc.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6.25/mm/page_alloc.c
> ===================================================================
> --- linux-2.6.25.orig/mm/page_alloc.c
> +++ linux-2.6.25/mm/page_alloc.c
> @@ -2518,6 +2518,7 @@ void __meminit memmap_init_zone(unsigned
>  	struct page *page;
>  	unsigned long end_pfn = start_pfn + size;
>  	unsigned long pfn;
> +	struct zone *z;
>  
>  	for (pfn = start_pfn; pfn < end_pfn; pfn++) {
>  		/*
> @@ -2536,7 +2537,7 @@ void __meminit memmap_init_zone(unsigned
>  		init_page_count(page);
>  		reset_page_mapcount(page);
>  		SetPageReserved(page);
> -
> +		z = page_zone(page);

Does this have to be recalculated for every page?  The function name
"memmap_init_zone" suggests it could be done just once (but I'm on
unfamiliar territory here, ignore any nonsense from me).

>  		/*
>  		 * Mark the block movable so that blocks are reserved for
>  		 * movable at startup. This will force kernel allocations
> @@ -2546,7 +2547,9 @@ void __meminit memmap_init_zone(unsigned
>  		 * the start are marked MIGRATE_RESERVE by
>  		 * setup_zone_migrate_reserve()
>  		 */
> -		if ((pfn & (pageblock_nr_pages-1)))
> +		if ((z->zone_start_pfn < pfn)

Shouldn't that be <= ?

> +		    && (pfn < z->zone_start_pfn + z->spanned_pages)
> +		    && !(pfn & (pageblock_nr_pages-1)))

Ah, that line (with the ! in) makes more sense than what was there
before; but that's an unrelated (minor) bugfix which you ought to
mention separately in the change comment.

Hugh

>  			set_pageblock_migratetype(page, MIGRATE_MOVABLE);
>  
>  		INIT_LIST_HEAD(&page->lru);
> @@ -4460,6 +4463,8 @@ void set_pageblock_flags_group(struct pa
>  	pfn = page_to_pfn(page);
>  	bitmap = get_pageblock_bitmap(zone, pfn);
>  	bitidx = pfn_to_bitidx(zone, pfn);
> +	VM_BUG_ON(pfn < zone->zone_start_pfn);
> +	VM_BUG_ON(pfn >= zone->zone_start_pfn + zone->spanned_pages);
>  
>  	for (; start_bitidx <= end_bitidx; start_bitidx++, value <<= 1)
>  		if (flags & value)
