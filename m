Return-Path: <linux-kernel-owner+w=401wt.eu-S1031220AbXEANCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031220AbXEANCv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 09:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031689AbXEANCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 09:02:51 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:2295 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031220AbXEANCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 09:02:49 -0400
Message-ID: <46373A71.4030200@shadowen.org>
Date: Tue, 01 May 2007 14:02:41 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Mel Gorman <mel@skynet.ie>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, clameter@sgi.com, y-goto@jp.fujitsu.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: 2.6.22 -mm merge plans -- lumpy reclaim
References: <20070430162007.ad46e153.akpm@linux-foundation.org> <20070501101651.GA29957@skynet.ie>
In-Reply-To: <20070501101651.GA29957@skynet.ie>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman wrote:

<snip>

>>  lumpy-reclaim-v4.patch
> 
> And I guess this patch also moves here
> 
> lumpy-move-to-using-pfn_valid_within.patch
> 
>> This is in a similar situation to the moveable-zone work.  Sounds great on
>> paper, but it needs considerable third-party testing and review.  It is a
>> major change to core MM and, we hope, a significant advance.  On paper.
> 
> Andy will probably comment more here. Like the fragmentation stuff, we have
> beaten this heavily in tests.

With this stack the basic functionality for Lumpy reclaim is complete.
Better integration with kswapd is desirable, but IMO that should be a
separate change.

In testing it has produced significant improvements the likelyhood of
reclaiming a page (reclaim effectiveness) at very high orders (where the
likelyhood of success is least), and effectiveness at lower orders
should be better again.  In general -mm testing lumpy is triggered for
any stalled allocation above order-0; it is common to see stack
allocations triggering lumpy under higher load.  kswapd also now
utilises lumpy when required.

As Mel has indicated a lot of automated testing has been done on these
patches.  As reclaim is only entered when low on memory, our testing
focuses on triggering pushing the system to a heavily fragmented state
where reclaim is used heavily.  This testing has not shown any
regressions and shows improved effectiveness particularly under load.

Effectiveness for regular reclaim is based on random distributions, as
such it is only likely to successfully reclaim pages at lower orders.
Lumpy reclaim improves on this by actively targeting reclaim on areas at
the orders required and so succeeds at significantly higher order.  Very
high order allocations require better layout, from the mobility patches.

I have some primitive stats patches which we have used performance
testing.  Perhaps those could be brought up to date to provide better
visibility into lumpy's operation.  Again this would be a separate patch.

> I'm not sure of it's review situation.

As lumpy reclaim and grouping-by-mobility are complementary patch sets
(in that they both assist at the highest order) we work pretty closely
and I generally pass all my patches past Mel before general release.
Early versions were based on patches from Peter Zijlstra who also
reviewed earlier versions if memory serves.  The changes since then have
been reviewed by Mel and Andrew Morton only to my knowledge.

Perhaps Peter would have some time to take a look over the latest stack
as it appears in -mm when that releases; ping me for a patch kit if you
want it before then :).

<snip>

-apw
