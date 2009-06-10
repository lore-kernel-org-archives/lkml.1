Return-Path: <linux-kernel-owner+w=401wt.eu-S1756445AbZFJGby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756445AbZFJGby (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 02:31:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752800AbZFJGbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 02:31:47 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46300 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbZFJGbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 02:31:46 -0400
Date: Wed, 10 Jun 2009 15:30:10 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       apw@canonical.com, riel@redhat.com, minchan.kim@gmail.com,
       mel@csn.ul.ie
Subject: Re: [PATCH 1/2] lumpy reclaim: clean up and write lumpy reclaim
Message-Id: <20090610153010.8d219dfc.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090610151027.DDBA.A69D9226@jp.fujitsu.com>
References: <20090610142443.9370aff8.kamezawa.hiroyu@jp.fujitsu.com>
	<20090610151027.DDBA.A69D9226@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Jun 2009 15:11:21 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > I think lumpy reclaim should be updated to meet to current split-lru.
> > This patch includes bugfix and cleanup. How do you think ?
> > 
> > ==
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > 
> > In lumpty reclaim, "cursor_page" is found just by pfn. Then, we don't know
> > where "cursor" page came from. Then, putback it to "src" list is BUG.
> > And as pointed out, current lumpy reclaim doens't seem to
> > work as originally designed and a bit complicated. This patch adds a
> > function try_lumpy_reclaim() and rewrite the logic.
> > 
> > The major changes from current lumpy reclaim is
> >   - check migratetype before aggressive retry at failure.
> >   - check PG_unevictable at failure.
> >   - scan is done in buddy system order. This is a help for creating
> >     a lump around targeted page. We'll create a continuous pages for buddy
> >     allocator as far as we can _around_ reclaim target page.
> > 
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > ---
> >  mm/vmscan.c |  120 +++++++++++++++++++++++++++++++++++-------------------------
> >  1 file changed, 71 insertions(+), 49 deletions(-)
> > 
> > Index: mmotm-2.6.30-Jun10/mm/vmscan.c
> > ===================================================================
> > --- mmotm-2.6.30-Jun10.orig/mm/vmscan.c
> > +++ mmotm-2.6.30-Jun10/mm/vmscan.c
> > @@ -850,6 +850,69 @@ int __isolate_lru_page(struct page *page
> >  	return ret;
> >  }
> >  
> > +static int
> > +try_lumpy_reclaim(struct page *page, struct list_head *dst, int request_order)
> > +{
> > +	unsigned long buddy_base, buddy_idx, buddy_start_pfn, buddy_end_pfn;
> > +	unsigned long pfn, page_pfn, page_idx;
> > +	int zone_id, order, type;
> > +	int do_aggressive = 0;
> > +	int nr = 0;
> > +	/*
> > +	 * Lumpy reqraim. Try to take near pages in requested order to
> > +	 * create free continous pages. This algorithm tries to start
> > +	 * from order 0 and scan buddy pages up to request_order.
> > +	 * If you are unsure about buddy position calclation, please see
> > +	 * mm/page_alloc.c
> > +	 */
> > +	zone_id = page_zone_id(page);
> > +	page_pfn = page_to_pfn(page);
> > +	buddy_base = page_pfn & ~((1 << MAX_ORDER) - 1);
> > +
> > +	/* Can we expect succesful reclaim ? */
> > +	type = get_pageblock_migratetype(page);
> > +	if ((type == MIGRATE_MOVABLE) || (type == MIGRATE_RECLAIMABLE))
> > +		do_aggressive = 1;
> > +
> > +	for (order = 0; order < request_order; ++order) {
> > +		/* offset in this buddy region */
> > +		page_idx = page_pfn & ~buddy_base;
> > +		/* offset of buddy can be calculated by xor */
> > +		buddy_idx = page_idx ^ (1 << order);
> > +		buddy_start_pfn = buddy_base + buddy_idx;
> > +		buddy_end_pfn = buddy_start_pfn + (1 << order);
> > +
> > +		/* scan range [buddy_start_pfn...buddy_end_pfn) */
> > +		for (pfn = buddy_start_pfn; pfn < buddy_end_pfn; ++pfn) {
> > +			/* Avoid holes within the zone. */
> > +			if (unlikely(!pfn_valid_within(pfn)))
> > +				break;
> > +			page = pfn_to_page(pfn);
> > +			/*
> > +			 * Check that we have not crossed a zone boundary.
> > +			 * Some arch have zones not aligned to MAX_ORDER.
> > +			 */
> > +			if (unlikely(page_zone_id(page) != zone_id))
> > +				break;
> > +
> > +			/* we are always under ISOLATE_BOTH */
> > +			if (__isolate_lru_page(page, ISOLATE_BOTH, 0) == 0) {
> > +				list_move(&page->lru, dst);
> > +				nr++;
> > +			} else if (do_aggressive && !PageUnevictable(page))
> 
> Could you explain this branch intention more?
> 
__isolate_lru_page() can fail in following case
  - the page is not on LRU.
        This implies
		(a) the page is not for anon/file-cache
		(b) the page is taken off from LRU by shirnk_list or pagevec.
		(c) the page is free.
   - the page is temorarlly busy.

So, aborting this loop here directly is not very good. But if the page is for
kernel' usage or unevictable,  contuning this loop just wastes time.

Then, I used migrate_type attribute for the target page.
migrate_type is determined per pageblock_order (This itself detemined by
sizeo of hugepage at el. see  include/linux/pageblock-flags.h)

If the page is under MIGRATE_MOVABLE
	- at least 50% of nearby pages are used for GFP_MOVABLE(GFP_HIGHUSER_MOVABLE)
   the page is udner MIGRATE_REMOVABLE
	- at least 50% of nearby pages are used for  GFP_TEMPORARY

Then, we can expect meaningful lumpy reclaim if do_aggressive == 1.
If do_aggressive==0, nearby pages are used for some kernel usage and not suitable
for _this_ lumpy reclaim.

How about a comment like this ?
/*
 * __isolate_lru_page() returns busy status in many reason. If we are under
 * migrate type of MIGRATE_MOVABLE/MIGRATE_REMOVABLE, we can expect nearby
 * pages are just temporally busy and should be reclaimed later. (If the page
 * is _now_ free or being freed, __isolate_lru_page() returns -EBUSY.)
 * Then, continue this loop.
 */

Thanks,
-Kame




