Return-Path: <linux-kernel-owner+w=401wt.eu-S1752832AbYIJNiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832AbYIJNiS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 09:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751425AbYIJNiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 09:38:07 -0400
Received: from sh.osrg.net ([192.16.179.4]:37884 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102AbYIJNiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 09:38:05 -0400
Date: Wed, 10 Sep 2008 22:37:45 +0900
To: joerg.roedel@amd.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH] x86: avoid unnecessary low zone allocation in AMD
 IOMMU's alloc_coherent
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080910131032.GH6329@amd.com>
References: <20080910124822.GG6329@amd.com>
	<20080910220323D.fujita.tomonori@lab.ntt.co.jp>
	<20080910131032.GH6329@amd.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080910223735O.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Sep 2008 15:10:32 +0200
Joerg Roedel <joerg.roedel@amd.com> wrote:

> On Wed, Sep 10, 2008 at 10:03:32PM +0900, FUJITA Tomonori wrote:
> 
> Ok, I see.
> 
> > Hmm, I'm not sure what code you look at. Here's dma_alloc_coherent()
> > in tip/x86/iommu:
> > 
> > dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
> > 		gfp_t gfp)
> > {
> > 	struct dma_mapping_ops *ops = get_dma_ops(dev);
> > 	void *memory;
> > 
> > 	gfp &= ~(__GFP_DMA | __GFP_HIGHMEM | __GFP_DMA32);
> > 
> > Surely we here clear the flag but...
> > 
> > 	if (dma_alloc_from_coherent(dev, size, dma_handle, &memory))
> > 		return memory;
> > 
> > 	if (!dev) {
> > 		dev = &x86_dma_fallback_dev;
> > 		gfp |= GFP_DMA;
> > 	}
> > 
> > we play with it here though (not happens with pci devices),
> > 
> > 	if (!dev->dma_mask)
> > 		return NULL;
> > 
> > 	if (!ops->alloc_coherent)
> > 		return NULL;
> > 
> > Then dma_alloc_coherent_gfp_flags() sets it again according to
> > device->coherent_dma_mask and gfp before ops->alloc_coherent hook:
> > 
> > 	return ops->alloc_coherent(dev, size, dma_handle,
> > 				   dma_alloc_coherent_gfp_flags(dev, gfp));
> > 
> > 
> > This code can set up the exact same gfp flag for swiotbl and nommu as
> > before.
> 
> So its possible that alloc_coherent is called with region specifiers in
> the gfp flags.

Yes, that's how we solved the ZONE_DMA exhaustion problem in
swiotlb. And we don't duplicate the gfp hack in both swiotlb and
pci-nommu.


> Can't we simply make the gfp hacks depend on
> dma_ops->is_phys and avoid further gfp hacks in the hardware iommu
> implementations?

I thought about it but adding a new dma_ops->we_don't_want_gfp_flag
hook doesn't make the code simpler much. Currently, we have the gfp
setting hack in just one place. It's not bad. Adding such new hook
means adding more lines than we can remove.

Yeah, I was against your patch to adding the gfp setting hack to
swiotlb but it's because gfp is kinda architecture specific stuff and
swiotlb should not. It's the bad design IMO. It's ok for me that
architecture specific IOMMUs can do the architecture specific stuff
(and it's about just clearing the gfp flag).

Intel IOMMU already clears up the flag so I'll send a patch to do that
for Calgary shortly then I think that we can finish x86 alloc_coherent
rewrite.
