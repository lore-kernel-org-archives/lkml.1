Return-Path: <linux-kernel-owner+w=401wt.eu-S1765882AbXGKSix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765882AbXGKSix (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 14:38:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753329AbXGKSiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 14:38:46 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:3050 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755632AbXGKSip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 14:38:45 -0400
Message-ID: <469523AF.6050207@shadowen.org>
Date: Wed, 11 Jul 2007 19:38:39 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
       Christoph Lameter <clameter@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: -mm merge plans -- lumpy reclaim
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>	<46937DA2.4040302@shadowen.org>	<4694A427.7070708@shadowen.org> <20070711094600.b2a525d5.akpm@linux-foundation.org>
In-Reply-To: <20070711094600.b2a525d5.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:

>>>> lumpy-reclaim-v4.patch
>>>> have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
>>>> only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
>>>>
>>>>  Lumpy reclaim.  In a similar situation to Mel's patches.  Stuck due to
>>>>  general lack or interest and effort.
>>> The lumpy reclaim patches originally came out of work to support Mel's
>>> anti-fragmentation work.  As such I think they have become somewhat
>>> attached to those patches.  Whilst lumpy is most effective where
>>> placement controls are in place as offered by Mel's work, we see benefit
>>> from reduction in the "blunderbuss" effect when we reclaim at higher
>>> orders.  While placement control is pretty much required for the very
>>> highest orders such as huge page size, lower order allocations are
>>> benefited in terms of lower collateral damage.
>>>
>>> There are now a few areas other than huge page allocations which can
>>> benefit.  Stacks are still order 1.  Jumbo frames want higher order
>>> contiguous pages for there incoming hardware buffers.  SLUB is showing
>>> performance benefits from moving to a higher allocation order.  All of
>>> these should benefit from more aggressive targeted reclaim, indeed I
>>> have been surprised just how often my test workloads trigger lumpy at
>>> order 1 to get new stacks.
>>>
>>> Truly representative work loads are hard to generate for some of these.
>>>  Though we have heard some encouraging noises from those who can
>>> reproduce these problems.
> 
> I'd expect that the main application for lumpy-reclaim is in keeping a pool
> of order-2 (say) pages in reserve for GFP_ATOMIC allocators.  ie: jumbo
> frames.
> 
> At present this relies upon the wakeup_kswapd(..., order) mechanism.
> 
> How effective is this at solving the jumbo frame problem?

The tie in between allocator and kswapd is essentially unchanged,
so if allocators are dropping below the watermarks at the specified
order, reclaim will be triggered at that order.  Reclaim continues
until we return above the high watermarks, at the order at which
we are reclaiming.

What lumpy brings is a greater targetting of effort to get the pages.
kswapd now uses the desired allocator order when applying reclaim.
This leads to pressure being applied to contigious areas at the
required order, and so a higher chance of that order becoming
available.  Traditional reclaim could end up applying pressure to
a number of pages, but not all pages in any area at the required
order, leading to a very low chance of success.  By targetting
areas at the required order we significantly increase the chances
of success for any given amount of reclaim.  As we will reclaim
until we have the desired number of free pages, we will have to
reclaim less to achieve this compared to random reclaim.

This certainly is appealing intuitivly, and our testing at higher
orders shows that the cost of each reclaimed page is lower and more
importantly the time to reclaim each page is reduced.  So for a
'continuing' consumer like an incoming packet stream, we should
have to do much less work and thus disrupt the system as a whole
much less to get its pages.

Where demand for atomic higher order pages is not heavy we would
expect kswapd to maintain free levels pages more readily and so
under higher demand.  Though it should be stressed without placement
control success rates drop off significantly at higher orders as
the probabality of reclaim succeeding on all pages in the area
tends to zero.

> (And do we still have a jumbo frame problem?  Reports seems to have
subsided)

It is not in the least bit clear if the problem is resolved or if the
reporters have simply gone quiet.

Overall the approach taken in lumpy reclaim seems to be a logical
extension of the regular reclaim algorithm, leading to more
efficient reclaim.

-apw
