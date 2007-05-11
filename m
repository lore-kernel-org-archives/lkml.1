Return-Path: <linux-kernel-owner+w=401wt.eu-S1761677AbXEKA5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761677AbXEKA5o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 20:57:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758402AbXEKA5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 20:57:37 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37313 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758214AbXEKA5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 20:57:37 -0400
Date: Fri, 11 May 2007 09:58:18 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: y-goto@jp.fujitsu.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@osdl.org, clameter@sgi.com
Subject: Re: [RFC] memory hotremove patch take 2 [04/10] (isolate all free
 pages)
Message-Id: <20070511095818.240c6f47.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0705101737500.6987@skynet.skynet.ie>
References: <20070509115506.B904.Y-GOTO@jp.fujitsu.com>
	<20070509120434.B90E.Y-GOTO@jp.fujitsu.com>
	<Pine.LNX.4.64.0705101737500.6987@skynet.skynet.ie>
Organization: Fujitsu
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007 17:42:54 +0100 (IST)
Mel Gorman <mel@csn.ul.ie> wrote:

> > +	if (!pfn_valid(pfn))
> > +		return -EINVAL;
> 
> This may lead to boundary cases where pages cannot be captured at the 
> start and end of non-aligned zones due to memory holes.
> 
Hm, ok. maybe we can remove this.

> > +	zone = info->zone;
> > +	if ((zone != page_zone(pfn_to_page(pfn))) ||
> > +	    (zone != page_zone(pfn_to_page(last_pfn))))
> > +		return -EINVAL;
> 
> Is this check really necessary? Surely a caller to 
> capture_isolate_freed_pages() will have already made all the necessary 
> checks when adding the struct insolation_info ?
> 
just because isolation_info is treated per zone.
Maybe MIGRATE_ISOLATING can allow us more flexible approach.


> > +	drain_all_pages();
> > +	spin_lock(&zone->lock);
> > +	while (pfn < info->end_pfn) {
> > +		if (!pfn_valid(pfn)) {
> > +			pfn++;
> > +			continue;
> > +		}
> > +		page = pfn_to_page(pfn);
> > +		/* See page_is_buddy()  */
> > +		if (page_count(page) == 0 && PageBuddy(page)) {
> 
> If PageBuddy is set it's free, you shouldn't have to check the page_count.
> 
ok.

> > +			order = page_order(page);
> > +			order_size = 1 << order;
> > +			zone->free_area[order].nr_free--;
> > +			__mod_zone_page_state(zone, NR_FREE_PAGES, -order_size);
> > +			list_del(&page->lru);
> > +			rmv_page_order(page);
> > +			isolate_page_nolock(info, page, order);
> > +			nr_pages += order_size;
> > +			pfn += order_size;
> > +		} else {
> > +			pfn++;
> > +		}
> > +	}
> > +	spin_unlock(&zone->lock);
> > +	return nr_pages;
> > +}
> > #endif /* CONFIG_PAGE_ISOLATION */
> >
> 
> This is all similar to move_freepages() other than the locking part. It 
> would be worth checking if there is code that could be shared or at least 
> have similar styles.

Thank you, I'll look into move_freepages().

-Kame


