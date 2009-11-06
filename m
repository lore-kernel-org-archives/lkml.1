Return-Path: <linux-kernel-owner+w=401wt.eu-S1755995AbZKFDTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995AbZKFDTw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 22:19:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbZKFDTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 22:19:51 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:23861 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbZKFDTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 22:19:51 -0500
Subject: Re: [PATCH] intel-iommu: Obey coherent_dma_mask for alloc_coherent
 on	passthrough
From: Alex Williamson <alex.williamson@hp.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: dwmw2@infradead.org, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <20091106114130J.fujita.tomonori@lab.ntt.co.jp>
References: <20091104225359.2720.91502.stgit@nehalem.aw>
	 <20091106114130J.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 Nov 2009 20:19:52 -0700
Message-ID: <1257477592.2837.94.camel@2710p.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-11-06 at 11:41 +0900, FUJITA Tomonori wrote:
> On Wed, 04 Nov 2009 15:59:34 -0700
> Alex Williamson <alex.williamson@hp.com> wrote:
> > @@ -2582,7 +2582,7 @@ static dma_addr_t __intel_map_single(struct device *hwdev, phys_addr_t paddr,
> >  	BUG_ON(dir == DMA_NONE);
> >  
> >  	if (iommu_no_mapping(hwdev))
> > -		return paddr;
> > +		return paddr + size > dma_mask ? 0 : paddr;
> 
> You can use dma_capable(hwdev, paddr, size) here.

Good thought, however __intel_map_single() gets called with either the
dma_mask or the coherent_dma_mask.  dma_capable() only checks dma_mask,
so would only work for one of the callers.

> >  	domain = get_valid_domain_for_dev(pdev);
> >  	if (!domain)
> > @@ -2767,7 +2767,15 @@ static void *intel_alloc_coherent(struct device *hwdev, size_t size,
> >  
> >  	size = PAGE_ALIGN(size);
> >  	order = get_order(size);
> > -	flags &= ~(GFP_DMA | GFP_DMA32);
> > +
> > +	if (!iommu_no_mapping(hwdev))
> > +		flags &= ~(GFP_DMA | GFP_DMA32);
> > +	else if (hwdev->coherent_dma_mask != DMA_BIT_MASK(64)) {
> > +		if (hwdev->coherent_dma_mask < DMA_BIT_MASK(32))
> > +			flags |= GFP_DMA;
> > +		else
> > +			flags |= GFP_DMA32;
> > +	}
> 
> This is fine for 2.6.32 but we'll cleanly fix this by using
> swiotlb_dma_ops later, right?

I'm open to suggestions.  I don't really understand why we dropped
swiotlb for passthrough mode in 2.6.32 to start with.  It seems like we
now have a couple corner cases where we have to either hope for the best
or effectively ignore the request to use passthrough.  Thanks,

Alex



