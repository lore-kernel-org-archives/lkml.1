Return-Path: <linux-kernel-owner+w=401wt.eu-S1751200AbYKGEhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751200AbYKGEhc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 23:37:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751112AbYKGEhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 23:37:20 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36186 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbYKGEhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 23:37:19 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [RFC][PATCH] mm: the page of MIGRATE_RESERVE don't insert into pcp
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-mm <linux-mm@kvack.org>
In-Reply-To: <20081106164644.GA14012@csn.ul.ie>
References: <20081106091431.0D2A.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081106164644.GA14012@csn.ul.ie>
Message-Id: <20081107093127.F84A.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Fri,  7 Nov 2008 13:37:14 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mel, Cristoph,

Thank you for interesting comment!


> > MIGRATE_RESERVE mean that the page is for emergency.
> > So it shouldn't be cached in pcp.
> 
> It doesn't necessarily mean it's for emergencys. MIGRATE_RESERVE is one
> or more pageblocks at the beginning of the zone. While it's possible
> that the minimum page reserve for GFP_ATOMIC is located here, it's not
> mandatory.
> 
> What MIGRATE_RESERVE can help is high-order atomic allocations used by
> some network drivers (a wireless one is what led to MIGRATE_RESERVE). As
> they are high-order allocations, they would be returned to the buddy
> allocator anyway.

yup.
my patch is meaningless for high order allocation because high order allocation
don't use pcp.


> What your patch may help is the situation where the system is under intense
> memory pressure, is dipping routinely into the lowmem reserves and mixing
> with high-order atomic allocations. This seems a bit extreme.

not so extreame.

The linux page reclaim can't process in interrupt context.
Sl network subsystem and driver often use MIGRATE_RESERVE memory although
system have many reclaimable memory.

At that time, any task in process context can use high order allocation.


> > otherwise, the system have unnecessary memory starvation risk
> > because other cpu can't use this emergency pages.
> > 
> > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > CC: Mel Gorman <mel@csn.ul.ie>
> > CC: Christoph Lameter <cl@linux-foundation.org>
> > 
> 
> This patch seems functionally sound but as Christoph points out, this
> adds another branch to the fast path. Now, I ran some tests and those that
> completed didn't show any problems but adding branches in the fast path can
> eventually lead to hard-to-detect performance problems.
> 
> Do you have a situation in mind that this patch fixes up?

Ah, sorry for my description is too poor.
This isn't real workload issue, it is jsut 

Actually, I plan to rework to pcp because following pcp list searching 
in fast path is NOT fast.

In general, list searching often cause L1 cache miss, therefore it shouldn't be
used in fast path.


static struct page *buffered_rmqueue(struct zone *preferred_zone,
                        struct zone *zone, int order, gfp_t gfp_flags)
{
(snip)
                /* Find a page of the appropriate migrate type */
                if (cold) {
                        list_for_each_entry_reverse(page, &pcp->list, lru)
                                if (page_private(page) == migratetype)
                                        break;
                } else {
                        list_for_each_entry(page, &pcp->list, lru)
                                if (page_private(page) == migratetype)
                                        break;
                }


Therefore, I'd like to make per migratetype pcp list.
However, MIGRATETYPE_RESEVE list isn't useful because caller never need reserve type.
it is only internal attribute.

So I thought "dropping reserve type page in pcp" patch is useful although it is sololy used.
Then, I posted it sololy for hear other developer opinion.

Actually, current pcp is NOT fast, therefore the discussion of the 
number of branches isn't meaningful.
the discussion of the number of branches is only meaningful when the fast path can
process at N*branches level time, but current pcp is more slow.




