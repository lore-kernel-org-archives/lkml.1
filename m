Return-Path: <linux-kernel-owner+w=401wt.eu-S1753796AbYIJNK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796AbYIJNK4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 09:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752096AbYIJNKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 09:10:48 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:31624 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbYIJNKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 09:10:47 -0400
X-BigFish: VPS-40(zz1432R98dR1805M179dR936fQzz10d3izzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K6ZDXJ-03-7TV-01
Date: Wed, 10 Sep 2008 15:10:32 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH] x86: avoid unnecessary low zone allocation in AMD IOMMU's alloc_coherent
Message-ID: <20080910131032.GH6329@amd.com>
References: <20080910120310.GD6329@amd.com> <20080910213155M.fujita.tomonori@lab.ntt.co.jp> <20080910124822.GG6329@amd.com> <20080910220323D.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080910220323D.fujita.tomonori@lab.ntt.co.jp>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 10 Sep 2008 13:10:32.0358 (UTC) FILETIME=[9ADCF460:01C91346]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2008 at 10:03:32PM +0900, FUJITA Tomonori wrote:

Ok, I see.

> Hmm, I'm not sure what code you look at. Here's dma_alloc_coherent()
> in tip/x86/iommu:
> 
> dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
> 		gfp_t gfp)
> {
> 	struct dma_mapping_ops *ops = get_dma_ops(dev);
> 	void *memory;
> 
> 	gfp &= ~(__GFP_DMA | __GFP_HIGHMEM | __GFP_DMA32);
> 
> Surely we here clear the flag but...
> 
> 	if (dma_alloc_from_coherent(dev, size, dma_handle, &memory))
> 		return memory;
> 
> 	if (!dev) {
> 		dev = &x86_dma_fallback_dev;
> 		gfp |= GFP_DMA;
> 	}
> 
> we play with it here though (not happens with pci devices),
> 
> 	if (!dev->dma_mask)
> 		return NULL;
> 
> 	if (!ops->alloc_coherent)
> 		return NULL;
> 
> Then dma_alloc_coherent_gfp_flags() sets it again according to
> device->coherent_dma_mask and gfp before ops->alloc_coherent hook:
> 
> 	return ops->alloc_coherent(dev, size, dma_handle,
> 				   dma_alloc_coherent_gfp_flags(dev, gfp));
> 
> 
> This code can set up the exact same gfp flag for swiotbl and nommu as
> before.

So its possible that alloc_coherent is called with region specifiers in
the gfp flags. Can't we simply make the gfp hacks depend on
dma_ops->is_phys and avoid further gfp hacks in the hardware iommu
implementations?

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

