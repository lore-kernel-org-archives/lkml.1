Return-Path: <linux-kernel-owner+w=401wt.eu-S1754109AbYIDENN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109AbYIDENN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 00:13:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751168AbYIDEM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 00:12:58 -0400
Received: from sh.osrg.net ([192.16.179.4]:53978 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750941AbYIDEM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 00:12:57 -0400
Date: Thu, 4 Sep 2008 13:11:46 +0900
To: joro@8bytes.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       tony.luck@intel.com, iommu@lists.linux-foundation.org, mingo@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 1/3] x86: remove the NULL device hack in dma-mapping.h
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080903200114.GC16706@8bytes.org>
References: <1220465065-10533-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1220465065-10533-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<20080903200114.GC16706@8bytes.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080904130800O.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Sep 2008 22:01:14 +0200
Joerg Roedel <joro@8bytes.org> wrote:

> On Thu, Sep 04, 2008 at 03:04:23AM +0900, FUJITA Tomonori wrote:
> > dma_alloc_coherent in dma-mapping.h has a hack to use
> > x86_dma_fallback_dev if a pointer to a device is NULL. Some of IOMMUs
> > don't need such hack. The hack also makes it difficult for IOMMUs to
> > make a proper decision because the hack hides the information.
> 
> I don't think its the right way to work around shortcomings of the
> generic code in the architecture specific implementations. Especially
> when the generic code can be easily fixed like in this case.

Well, the generic code should not have such work around.

As I wrote in another mail, you try to bring back the tricks used in
arch/x86/kernel/pci-dma.c to lib/swiotlb.c. I try to bring back them
to arch/x86/kernel/pci-swiotlb.c.


> > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > ---
> >  arch/x86/kernel/pci-swiotlb_64.c |   15 ++++++++++++++-
> >  include/asm-x86/dma-mapping.h    |    9 +--------
> >  2 files changed, 15 insertions(+), 9 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/pci-swiotlb_64.c b/arch/x86/kernel/pci-swiotlb_64.c
> > index c4ce033..f3d8d0e 100644
> > --- a/arch/x86/kernel/pci-swiotlb_64.c
> > +++ b/arch/x86/kernel/pci-swiotlb_64.c
> > @@ -11,6 +11,8 @@
> >  
> >  int swiotlb __read_mostly;
> >  
> > +extern struct device x86_dma_fallback_dev;
> > +
> >  static dma_addr_t
> >  swiotlb_map_single_phys(struct device *hwdev, phys_addr_t paddr, size_t size,
> >  			int direction)
> > @@ -18,9 +20,20 @@ swiotlb_map_single_phys(struct device *hwdev, phys_addr_t paddr, size_t size,
> >  	return swiotlb_map_single(hwdev, phys_to_virt(paddr), size, direction);
> >  }
> >  
> > +static void *x86_swiotlb_alloc_coherent(struct device *dev, size_t size,
> > +					dma_addr_t *dma_handle, gfp_t gfp)
> > +{
> > +	if (!dev) {
> > +		dev = &x86_dma_fallback_dev;
> > +		gfp |= GFP_DMA;
> > +	}
> 
> This really should be checked in the generic x86 dma_alloc_coherent
> function.

I don't think so. Any motherboards with the recent IOMMUs support ISA?


> > +
> > +	return swiotlb_alloc_coherent(dev, size, dma_handle, gfp);
> > +}
> > +
> >  struct dma_mapping_ops swiotlb_dma_ops = {
> >  	.mapping_error = swiotlb_dma_mapping_error,
> > -	.alloc_coherent = swiotlb_alloc_coherent,
> > +	.alloc_coherent = x86_swiotlb_alloc_coherent,
> >  	.free_coherent = swiotlb_free_coherent,
> >  	.map_single = swiotlb_map_single_phys,
> >  	.unmap_single = swiotlb_unmap_single,
> > diff --git a/include/asm-x86/dma-mapping.h b/include/asm-x86/dma-mapping.h
> > index bc6c8df..3463702 100644
> > --- a/include/asm-x86/dma-mapping.h
> > +++ b/include/asm-x86/dma-mapping.h
> > @@ -14,7 +14,6 @@
> >  
> >  extern dma_addr_t bad_dma_address;
> >  extern int iommu_merge;
> > -extern struct device x86_dma_fallback_dev;
> >  extern int panic_on_overflow;
> >  extern int force_iommu;
> >  
> > @@ -251,14 +250,8 @@ dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
> >  	if (dma_alloc_from_coherent(dev, size, dma_handle, &memory))
> >  		return memory;
> >  
> > -	if (!dev) {
> > -		dev = &x86_dma_fallback_dev;
> > -		gfp |= GFP_DMA;
> > -	}
> 
> Why do you move this check to swiotlb implemenation? This will break
> existing IOMMU implementations which don't check for a valid dev
> pointer?

As I wrote above, I don't think so (though I forgot to add this to
pci-nommu.c).
