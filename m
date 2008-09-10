Return-Path: <linux-kernel-owner+w=401wt.eu-S1754072AbYIJNEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072AbYIJNEP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 09:04:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752230AbYIJNEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 09:04:00 -0400
Received: from sh.osrg.net ([192.16.179.4]:47922 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752161AbYIJND7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 09:03:59 -0400
Date: Wed, 10 Sep 2008 22:03:32 +0900
To: joerg.roedel@amd.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH] x86: avoid unnecessary low zone allocation in AMD
 IOMMU's alloc_coherent
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080910124822.GG6329@amd.com>
References: <20080910120310.GD6329@amd.com>
	<20080910213155M.fujita.tomonori@lab.ntt.co.jp>
	<20080910124822.GG6329@amd.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080910220323D.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Sep 2008 14:48:22 +0200
Joerg Roedel <joerg.roedel@amd.com> wrote:

> On Wed, Sep 10, 2008 at 09:38:11PM +0900, FUJITA Tomonori wrote:
> > On Wed, 10 Sep 2008 14:03:10 +0200
> > Joerg Roedel <joerg.roedel@amd.com> wrote:
> > > It needs a fix anyway and the
> > > right solution here is to fall back to one of the software iommu
> > > implementations. The stackable dma_ops patches I have currently in work
> > > will do exactly that.
> > 
> > I'm not sure you need the stackable dma_ops support. Calgary IOMMU had
> > the same problem and already solved it with dma_ops-per-device option.
> 
> We need stackable dma_ops anyway for paravirt IOMMU support in KVM.

I know. We discussed it when adding dma_ops-per-device support.


> And they will fix this issue too.

Ok, I'll wait until I see how the patches solve the problem cleanly.


> > > These flags are already removed in the dma_alloc_coherent function which
> > > calls this one. Further I think in the case of a remapping IOMMU like
> > 
> > Not true about x86/tip/iommu. dma_alloc_coherent in dma-mapping.h does
> > that so that swiotlb and pci-nommu don't need the gfp hack. Clearing
> > the gfp flags is much simpler than setting up the flags correctly
> > mainly because of the fallback device, setting up the flags is really
> > difficult.
> 
> Yes, dma_alloc_coherent in dma-mapping.h clears the flags. And this
> function also calls ops->alloc_coherent which points to the AMD IOMMUs
> alloc_coherent function if the driver is in place.

Hmm, I'm not sure what code you look at. Here's dma_alloc_coherent()
in tip/x86/iommu:

dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
		gfp_t gfp)
{
	struct dma_mapping_ops *ops = get_dma_ops(dev);
	void *memory;

	gfp &= ~(__GFP_DMA | __GFP_HIGHMEM | __GFP_DMA32);

Surely we here clear the flag but...

	if (dma_alloc_from_coherent(dev, size, dma_handle, &memory))
		return memory;

	if (!dev) {
		dev = &x86_dma_fallback_dev;
		gfp |= GFP_DMA;
	}

we play with it here though (not happens with pci devices),

	if (!dev->dma_mask)
		return NULL;

	if (!ops->alloc_coherent)
		return NULL;

Then dma_alloc_coherent_gfp_flags() sets it again according to
device->coherent_dma_mask and gfp before ops->alloc_coherent hook:

	return ops->alloc_coherent(dev, size, dma_handle,
				   dma_alloc_coherent_gfp_flags(dev, gfp));


This code can set up the exact same gfp flag for swiotbl and nommu as
before.
