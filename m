Return-Path: <linux-kernel-owner+w=401wt.eu-S1763337AbYD1Ail@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763337AbYD1Ail (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 20:38:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751002AbYD1Aic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 20:38:32 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46581 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbYD1Aib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 20:38:31 -0400
Date: Mon, 28 Apr 2008 09:39:17 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hugh@veritas.com>, Mel Gorman <mel@csn.ul.ie>,
       Shi Weihua <shiwh@cn.fujitsu.com>, balbir@linux.vnet.ibm.com,
       xemul@openvz.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [BUGFIX][PATCH] Fix usemap initialization v3
Message-Id: <20080428093917.ea6f2647.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080427121817.03b432ca.akpm@linux-foundation.org>
References: <20080418161522.GB9147@csn.ul.ie>
	<48080706.50305@cn.fujitsu.com>
	<48080930.5090905@cn.fujitsu.com>
	<48080B86.7040200@cn.fujitsu.com>
	<20080418211214.299f91cd.kamezawa.hiroyu@jp.fujitsu.com>
	<21878461.1208539556838.kamezawa.hiroyu@jp.fujitsu.com>
	<20080421112048.78f0ec76.kamezawa.hiroyu@jp.fujitsu.com>
	<Pine.LNX.4.64.0804211250000.16476@blonde.site>
	<20080422104043.215c7dc4.kamezawa.hiroyu@jp.fujitsu.com>
	<20080423134621.6020dd83.kamezawa.hiroyu@jp.fujitsu.com>
	<20080427121817.03b432ca.akpm@linux-foundation.org>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Apr 2008 12:18:17 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > 
> > ---
> >  mm/page_alloc.c |   14 ++++++++++++--
> >  1 file changed, 12 insertions(+), 2 deletions(-)
> > 
> > Index: linux-2.6.25/mm/page_alloc.c
> > ===================================================================
> > --- linux-2.6.25.orig/mm/page_alloc.c
> > +++ linux-2.6.25/mm/page_alloc.c
> > @@ -2518,7 +2518,9 @@ void __meminit memmap_init_zone(unsigned
> >  	struct page *page;
> >  	unsigned long end_pfn = start_pfn + size;
> >  	unsigned long pfn;
> > +	struct zone *z;
> >  
> > +	z = &NODE_DATA(nid)->node_zones[zone];
> >  	for (pfn = start_pfn; pfn < end_pfn; pfn++) {
> >  		/*
> >  		 * There can be holes in boot-time mem_map[]s
> > @@ -2536,7 +2538,6 @@ void __meminit memmap_init_zone(unsigned
> >  		init_page_count(page);
> >  		reset_page_mapcount(page);
> >  		SetPageReserved(page);
> > -
> >  		/*
> >  		 * Mark the block movable so that blocks are reserved for
> >  		 * movable at startup. This will force kernel allocations
> > @@ -2545,8 +2546,15 @@ void __meminit memmap_init_zone(unsigned
> >  		 * kernel allocations are made. Later some blocks near
> >  		 * the start are marked MIGRATE_RESERVE by
> >  		 * setup_zone_migrate_reserve()
> > +		 *
> > +		 * bitmap is created for zone's valid pfn range. but memmap
> > +		 * can be created for invalid pages (for alignment)
> > +		 * check here not to call set_pageblock_migratetype() against
> > +		 * pfn out of zone.
> >  		 */
> > -		if ((pfn & (pageblock_nr_pages-1)))
> > +		if ((z->zone_start_pfn <= pfn)
> > +		    && (pfn < z->zone_start_pfn + z->spanned_pages)
> > +		    && !(pfn & (pageblock_nr_pages - 1)))
> >  			set_pageblock_migratetype(page, MIGRATE_MOVABLE);
> >  
> >  		INIT_LIST_HEAD(&page->lru);
> > @@ -4460,6 +4468,8 @@ void set_pageblock_flags_group(struct pa
> >  	pfn = page_to_pfn(page);
> >  	bitmap = get_pageblock_bitmap(zone, pfn);
> >  	bitidx = pfn_to_bitidx(zone, pfn);
> > +	VM_BUG_ON(pfn < zone->zone_start_pfn);
> > +	VM_BUG_ON(pfn >= zone->zone_start_pfn + zone->spanned_pages);
> >  
> >  	for (; start_bitidx <= end_bitidx; start_bitidx++, value <<= 1)
> >  		if (flags & value)
> 
> Do we think this is needed in 2.6.25.x?
> 
Yes, I think.

Thanks,
-Kame

