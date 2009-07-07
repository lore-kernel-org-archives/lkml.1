Return-Path: <linux-kernel-owner+w=401wt.eu-S1755059AbZGGJQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059AbZGGJQl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 05:16:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753493AbZGGJQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 05:16:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:34021 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043AbZGGJQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 05:16:33 -0400
Subject: Re: IOMMU and graphics cards
From: David Woodhouse <dwmw2@infradead.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Dave Airlie <airlied@linux.ie>, Joerg Roedel <joro@8bytes.org>,
       Zhenyu Wang <zhenyu.z.wang@intel.com>, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, iommu@lists.linux-foundation.org,
       mingo@redhat.com, David Miller <davem@davemloft.net>, eric@anholt.net
In-Reply-To: <20090707085904.GP5380@amd.com>
References: <20090507164742V.fujita.tomonori@lab.ntt.co.jp>
	 <20090507100114.GF4059@amd.com>
	 <1241691721.3531.73.camel@macbook.infradead.org>
	 <20090507.113632.210373283.davem@davemloft.net>
	 <20090508093526.GB13708@8bytes.org>
	 <1246883177.2615.33.camel@macbook.infradead.org>
	 <20090706131156.GL5380@amd.com>
	 <1246889932.2615.81.camel@macbook.infradead.org>
	 <alpine.DEB.2.00.0907062232350.5769@skynet.skynet.ie>
	 <20090707085904.GP5380@amd.com>
Content-Type: text/plain
Date: Tue, 07 Jul 2009 10:16:31 +0100
Message-Id: <1246958191.2615.234.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-07 at 10:59 +0200, Joerg Roedel wrote:
> On Mon, Jul 06, 2009 at 10:35:59PM +0100, Dave Airlie wrote:
> > My memory of this is graphics becomes totally useless and can be 10x-50x 
> > slower. I think ripping this out without the person doing the ripping 
> > taking responsiblity for doing speed regression testing is totally insane.
> 
> Are you sure that using the dma-api has such an performance impact? I've
> heard from other people that switching to dma-api with amd iommu had no
> significant performance impact.

The DMA API on its own shouldn't hurt at all. and I'm not sure about the
AMD IOMMU.

It's the other IOMMU that hurts -- something about cache-incoherent page
tables and having to flush the cache for every change... especially on
an architecture which doesn't have any sane cache management (because it
was always designed for everything to be cache coherent, dammit!) so you
end up _invalidating_ the cache at the same time as you write it back!

Of course, it's a lot saner now that we don't individually flush the
cache after _every_ PTE we change, but do it in batches instead.
Multi-page mapping/unmapping is now a _lot_ faster than it used to be.

I'm also looking at mapping the page tables uncached, so we don't have
to do the cache flushes at all.

> > I personally have no IOMMU hw from Intel or AMD and nobody has seen it fit 
> > to supply me with any at any point in time, I'm not on the correct gravy 
> > train. So I suspect the people with the hw will have to do the work and 
> > the regression testing.
> 
> You just need to switch to dma-api. You don't need an iommu to test.
> Most bugs in such code can also be found and eliminated using the
> dma-api debugging interface.

Indeed. Just turn on CONFIG_DMA_API_DEBUG (that might have some
performance impact, but it's not huge).

-- 
dwmw2

