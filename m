Return-Path: <linux-kernel-owner+w=401wt.eu-S1752078AbYKGKrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078AbYKGKrl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 05:47:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752265AbYKGKra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 05:47:30 -0500
Received: from gir.skynet.ie ([193.1.99.77]:47657 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751819AbYKGKr3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 05:47:29 -0500
Date: Fri, 7 Nov 2008 10:47:26 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC][PATCH] mm: the page of MIGRATE_RESERVE don't insert into pcp
Message-ID: <20081107104726.GD13786@csn.ul.ie>
References: <20081106091431.0D2A.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081106164644.GA14012@csn.ul.ie> <20081107093127.F84A.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20081107093127.F84A.KOSAKI.MOTOHIRO@jp.fujitsu.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2008 at 01:37:14PM +0900, KOSAKI Motohiro wrote:
> Hi Mel, Cristoph,
> 
> Thank you for interesting comment!
> 
> 
> > > MIGRATE_RESERVE mean that the page is for emergency.
> > > So it shouldn't be cached in pcp.
> > 
> > It doesn't necessarily mean it's for emergencys. MIGRATE_RESERVE is one
> > or more pageblocks at the beginning of the zone. While it's possible
> > that the minimum page reserve for GFP_ATOMIC is located here, it's not
> > mandatory.
> > 
> > What MIGRATE_RESERVE can help is high-order atomic allocations used by
> > some network drivers (a wireless one is what led to MIGRATE_RESERVE). As
> > they are high-order allocations, they would be returned to the buddy
> > allocator anyway.
> 
> yup.
> my patch is meaningless for high order allocation because high order allocation
> don't use pcp.
> 
> > What your patch may help is the situation where the system is under intense
> > memory pressure, is dipping routinely into the lowmem reserves and mixing
> > with high-order atomic allocations. This seems a bit extreme.
> 
> not so extreame.
> 
> The linux page reclaim can't process in interrupt context.
> Sl network subsystem and driver often use MIGRATE_RESERVE memory although
> system have many reclaimable memory.
> 

Why are they often using MIGRATE_RESERVE, have you confirmed that? For that
to be happening, it implies that either memory is under intense pressure and
free pages are often below watermarks due to interrupt contexts or they are
frequently allocating high-order pages in interrupt context. Normal order-0
allocations should be getting satisified from elsewhere as if the free page
counts are low, they would be direct reclaiming and that will likely be
outside of the MIGRATE_RESERVE areas.

> At that time, any task in process context can use high order allocation.
> 
> > > otherwise, the system have unnecessary memory starvation risk
> > > because other cpu can't use this emergency pages.
> > > 
> > > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > > CC: Mel Gorman <mel@csn.ul.ie>
> > > CC: Christoph Lameter <cl@linux-foundation.org>
> > > 
> > 
> > This patch seems functionally sound but as Christoph points out, this
> > adds another branch to the fast path. Now, I ran some tests and those that
> > completed didn't show any problems but adding branches in the fast path can
> > eventually lead to hard-to-detect performance problems.
> > 
> > Do you have a situation in mind that this patch fixes up?
> 
> Ah, sorry for my description is too poor.
> This isn't real workload issue, it is jsut 
> 
> Actually, I plan to rework to pcp because following pcp list searching 
> in fast path is NOT fast.
> 
> In general, list searching often cause L1 cache miss, therefore it shouldn't be
> used in fast path.
> 
> 
> static struct page *buffered_rmqueue(struct zone *preferred_zone,
>                         struct zone *zone, int order, gfp_t gfp_flags)
> {
> (snip)
>                 /* Find a page of the appropriate migrate type */
>                 if (cold) {
>                         list_for_each_entry_reverse(page, &pcp->list, lru)
>                                 if (page_private(page) == migratetype)
>                                         break;
>                 } else {
>                         list_for_each_entry(page, &pcp->list, lru)
>                                 if (page_private(page) == migratetype)
>                                         break;
>                 }
> 
> Therefore, I'd like to make per migratetype pcp list.

That was actually how it was originally implemented and later moved to a list
search. It got shot down on the grounds a per-cpu structure increased in size.

> However, MIGRATETYPE_RESEVE list isn't useful because caller never need reserve type.
> it is only internal attribute.
> 
> So I thought "dropping reserve type page in pcp" patch is useful although it is sololy used.
> Then, I posted it sololy for hear other developer opinion.
> 
> Actually, current pcp is NOT fast, therefore the discussion of the 
> number of branches isn't meaningful.
> the discussion of the number of branches is only meaningful when the fast path can
> process at N*branches level time, but current pcp is more slow.
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
