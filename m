Return-Path: <linux-kernel-owner+w=401wt.eu-S1756293AbYKKNjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293AbYKKNjz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 08:39:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755855AbYKKNjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 08:39:47 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36827 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754906AbYKKNjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 08:39:46 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [RFC][PATCH] mm: the page of MIGRATE_RESERVE don't insert into pcp
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-mm <linux-mm@kvack.org>
In-Reply-To: <20081107104726.GD13786@csn.ul.ie>
References: <20081107093127.F84A.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081107104726.GD13786@csn.ul.ie>
Message-Id: <20081111221059.8B44.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue, 11 Nov 2008 22:39:40 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > What your patch may help is the situation where the system is under intense
> > > memory pressure, is dipping routinely into the lowmem reserves and mixing
> > > with high-order atomic allocations. This seems a bit extreme.
> > 
> > not so extreame.
> > 
> > The linux page reclaim can't process in interrupt context.
> > Sl network subsystem and driver often use MIGRATE_RESERVE memory although
> > system have many reclaimable memory.
> > 
> 
> Why are they often using MIGRATE_RESERVE, have you confirmed that? For that
> to be happening, it implies that either memory is under intense pressure and
> free pages are often below watermarks due to interrupt contexts or they are
> frequently allocating high-order pages in interrupt context. Normal order-0
> allocations should be getting satisified from elsewhere as if the free page
> counts are low, they would be direct reclaiming and that will likely be
> outside of the MIGRATE_RESERVE areas.

if inserting printk() in MIGRATE_RESERVE, I can observe MIGRATE_RESERVE
page alloc easily although heavy workload don't run.
but, there aren't my point.

ok, I guess my patch description was too poor (and a bit pointless).
So, I retry it.

(1) in general principal, the system should effort to avoid oom rather than
    performance if memory shortage happend.
    MIGRATE_RESERVE directly indicate memory shortage happend.
    and pcp caching can prevent another cpu allocation.
(2) MIGRATE_RESERVE is never searched by buffered_rmqueue() because 
    allocflags_to_migratetype() never return MIGRATE_RESERVE.
    it doesn't work as cache.
    IOW, it don't help to increase performance.
(3) if the system pass MIGRATE_RESERVE to free_hot_cold_page() continously,
    pcp queueing can reduce the number of grabing zone->lock.
    However, it is rate. because MIGRATE_RESERVE is emergency memory,
    and it is often used interupt context processing.
    continuous emergency memory allocation in interrupt context isn't so sane.

Then, unqueueing MIGRATE_RESERVE page doesn't cause performance degression
and, it can (a bit) increase realibility and I think merit is much over demerit.




> > static struct page *buffered_rmqueue(struct zone *preferred_zone,
> >                         struct zone *zone, int order, gfp_t gfp_flags)
> > {
> > (snip)
> >                 /* Find a page of the appropriate migrate type */
> >                 if (cold) {
> >                         list_for_each_entry_reverse(page, &pcp->list, lru)
> >                                 if (page_private(page) == migratetype)
> >                                         break;
> >                 } else {
> >                         list_for_each_entry(page, &pcp->list, lru)
> >                                 if (page_private(page) == migratetype)
> >                                         break;
> >                 }
> > 
> > Therefore, I'd like to make per migratetype pcp list.
> 
> That was actually how it was originally implemented and later moved to a list
> search. It got shot down on the grounds a per-cpu structure increased in size.

Yup, I believe at that time your decision is right.
However, I think the condision was changed (or to be able to change).

 (1) legacy pcp implementation deeply relate to struct zone size.
     and, to blow up struct zone size cause performance degression
     because cache miss increasing.
     However, it solved cristoph's cpu-alloc patch

 (2) legacy pcp doesn't have total number of pages restriction.
     So, increasing lists directly cause number of pages in pcp.
     it can cause oom problem on large numa environment.
     However, I think we can implement total number of pages restriction.



