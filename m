Return-Path: <linux-kernel-owner+w=401wt.eu-S1753653AbYIEL5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653AbYIEL5T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 07:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752208AbYIEL5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 07:57:10 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:64670 "EHLO
	VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860AbYIEL5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 07:57:08 -0400
X-BigFish: VPS-30(zz1432R98dR1805M936fQzz10d3izzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0K6Q16V-04-PZI-01
Date: Fri, 5 Sep 2008 13:56:55 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Andi Kleen <andi@firstfloor.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: iommu@lists.linux-foundation.org, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix nommu_alloc_coherent allocation with NULL device argument
Message-ID: <20080905115655.GC3189@amd.com>
References: <1220605129-18359-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1220605129-18359-2-git-send-email-fujita.tomonori@lab.ntt.co.jp> <20080905104049.GY3189@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080905104049.GY3189@amd.com>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 05 Sep 2008 11:56:56.0092 (UTC) FILETIME=[7E7F7DC0:01C90F4E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi,

I guess you made the dma_mask of the fallback_dev 32 bit a long time
ago. Is there any reason it cannot be 24 bit?

Joerg

On Fri, Sep 05, 2008 at 12:40:49PM +0200, Joerg Roedel wrote:
> I agree with this patch in principle. It fixes the problem. But I think
> we should evaluate if we can change the dma_mask of the fallback_dev to
> 24 bit.
> 
> On Fri, Sep 05, 2008 at 05:58:47PM +0900, FUJITA Tomonori wrote:
> > We need to use __GFP_DMA for NULL device argument (fallback_dev) with
> > pci-nommu. It's a hack for ISA (and some old code) so we need to use
> > GFP_DMA.
> > 
> > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > ---
> >  arch/x86/kernel/pci-nommu.c   |    5 +----
> >  include/asm-x86/dma-mapping.h |    2 ++
> >  2 files changed, 3 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/pci-nommu.c b/arch/x86/kernel/pci-nommu.c
> > index 73853d3..526b2db 100644
> > --- a/arch/x86/kernel/pci-nommu.c
> > +++ b/arch/x86/kernel/pci-nommu.c
> > @@ -83,7 +83,6 @@ nommu_alloc_coherent(struct device *hwdev, size_t size,
> >  	if (hwdev->dma_mask == NULL)
> >  		return NULL;
> >  
> > -	gfp &= ~(__GFP_DMA | __GFP_HIGHMEM | __GFP_DMA32);
> >  	gfp |= __GFP_ZERO;
> >  
> >  	dma_mask = hwdev->coherent_dma_mask;
> > @@ -96,14 +95,12 @@ nommu_alloc_coherent(struct device *hwdev, size_t size,
> >  	node = dev_to_node(hwdev);
> >  
> >  #ifdef CONFIG_X86_64
> > -	if (dma_mask <= DMA_32BIT_MASK)
> > +	if (dma_mask <= DMA_32BIT_MASK && !(gfp & GFP_DMA))
> >  		gfp |= GFP_DMA32;
> >  #endif
> > -
> >  	/* No alloc-free penalty for ISA devices */
> >  	if (dma_mask == DMA_24BIT_MASK)
> >  		gfp |= GFP_DMA;
> > -
> 
> Please leave these spare lines where they are. They increase the
> readability of the code imho.
> 
> >  again:
> >  	page = alloc_pages_node(node, gfp, get_order(size));
> >  	if (!page)
> > diff --git a/include/asm-x86/dma-mapping.h b/include/asm-x86/dma-mapping.h
> > index 3a9a6f5..de4495e 100644
> > --- a/include/asm-x86/dma-mapping.h
> > +++ b/include/asm-x86/dma-mapping.h
> > @@ -246,6 +246,8 @@ dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
> >  	struct dma_mapping_ops *ops = get_dma_ops(dev);
> >  	void *memory;
> >  
> > +	gfp &= ~(__GFP_DMA | __GFP_HIGHMEM | __GFP_DMA32);
> > +
> >  	if (dma_alloc_from_coherent(dev, size, dma_handle, &memory))
> >  		return memory;
> >  
> > -- 
> > 1.5.4.2
> > 
> > 
> 
> -- 
>            |           AMD Saxony Limited Liability Company & Co. KG
>  Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
>  System    |                  Register Court Dresden: HRA 4896
>  Research  |              General Partner authorized to represent:
>  Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
>            | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy
> 
> _______________________________________________
> iommu mailing list
> iommu@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/iommu
> 

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

