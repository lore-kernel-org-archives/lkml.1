Return-Path: <linux-kernel-owner+w=401wt.eu-S1761901AbXGPKhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761901AbXGPKhU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 06:37:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753051AbXGPKhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 06:37:08 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:40056 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754745AbXGPKhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 06:37:07 -0400
Date: Mon, 16 Jul 2007 11:37:04 +0100
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@shadowen.org>, linux-kernel@vger.kernel.org,
       Christoph Lameter <clameter@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: -mm merge plans -- lumpy reclaim
Message-ID: <20070716103704.GA1082@skynet.ie>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org> <46937DA2.4040302@shadowen.org> <4694A427.7070708@shadowen.org> <20070711094600.b2a525d5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20070711094600.b2a525d5.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (11/07/07 09:46), Andrew Morton didst pronounce:
> On Wed, 11 Jul 2007 10:34:31 +0100 Andy Whitcroft <apw@shadowen.org> wrote:
> 
> > [Seems a PEBKAC occured on the subject line, resending lest it become a
> > victim of "oh thats spam".]
> > 
> > Andy Whitcroft wrote:
> > > Andrew Morton wrote:
> > > 
> > > [...]
> > >> lumpy-reclaim-v4.patch
> > >> have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
> > >> only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
> > >>
> > >>  Lumpy reclaim.  In a similar situation to Mel's patches.  Stuck due to
> > >>  general lack or interest and effort.
> > > 
> > > The lumpy reclaim patches originally came out of work to support Mel's
> > > anti-fragmentation work.  As such I think they have become somewhat
> > > attached to those patches.  Whilst lumpy is most effective where
> > > placement controls are in place as offered by Mel's work, we see benefit
> > > from reduction in the "blunderbuss" effect when we reclaim at higher
> > > orders.  While placement control is pretty much required for the very
> > > highest orders such as huge page size, lower order allocations are
> > > benefited in terms of lower collateral damage.
> > > 
> > > There are now a few areas other than huge page allocations which can
> > > benefit.  Stacks are still order 1.  Jumbo frames want higher order
> > > contiguous pages for there incoming hardware buffers.  SLUB is showing
> > > performance benefits from moving to a higher allocation order.  All of
> > > these should benefit from more aggressive targeted reclaim, indeed I
> > > have been surprised just how often my test workloads trigger lumpy at
> > > order 1 to get new stacks.
> > > 
> > > Truly representative work loads are hard to generate for some of these.
> > >  Though we have heard some encouraging noises from those who can
> > > reproduce these problems.
> 
> I'd expect that the main application for lumpy-reclaim is in keeping a pool
> of order-2 (say) pages in reserve for GFP_ATOMIC allocators.  ie: jumbo
> frames.
> 
> At present this relies upon the wakeup_kswapd(..., order) mechanism.
> 
> How effective is this at solving the jumbo frame problem?
> 
> (And do we still have a jumbo frame problem?  Reports seems to have subsided)

The patches have an application with hugepage pool resizing.

When lumpy-reclaim is used used with ZONE_MOVABLE, the hugepages pool can
be resized with greater reliability. Testing on a desktop machine with 2GB
of RAM showed that growing the hugepage pool with ZONE_MOVABLE on it's own
was very slow as the success rate was quite low. Without lumpy-reclaim, each
attempt to grow the pool by 100 pages would yield 1 or 2 hugepages. With
lumpy-reclaim, getting 40 to 70 hugepages on each attempt was typical.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
