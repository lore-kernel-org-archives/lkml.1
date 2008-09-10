Return-Path: <linux-kernel-owner+w=401wt.eu-S1753547AbYIJMim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547AbYIJMim (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 08:38:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbYIJMie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 08:38:34 -0400
Received: from sh.osrg.net ([192.16.179.4]:33172 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767AbYIJMid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 08:38:33 -0400
Date: Wed, 10 Sep 2008 21:38:11 +0900
To: joerg.roedel@amd.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH] x86: avoid unnecessary low zone allocation in AMD
 IOMMU's alloc_coherent
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080910120310.GD6329@amd.com>
References: <20080910201851R.fujita.tomonori@lab.ntt.co.jp>
	<20080910120310.GD6329@amd.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080910213155M.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Sep 2008 14:03:10 +0200
Joerg Roedel <joerg.roedel@amd.com> wrote:

> On Wed, Sep 10, 2008 at 08:19:40PM +0900, FUJITA Tomonori wrote:
> > This is for tip/iommu.
> > 
> > btw, Joery, what happens if map_sg (or map_single) gets
> > not-DMA-capable buffer in the case of !iommu || !domain?
> 
> It blows up :-)
> I know it but currently it is no problem because this will never happen
> in any real AMD IOMMU system (because the hardware just remaps every
> device in the system).

I see, thanks.

> It needs a fix anyway and the
> right solution here is to fall back to one of the software iommu
> implementations. The stackable dma_ops patches I have currently in work
> will do exactly that.

I'm not sure you need the stackable dma_ops support. Calgary IOMMU had
the same problem and already solved it with dma_ops-per-device option.


> > ==
> > From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > Subject: [PATCH] x86: avoid unnecessary low zone allocation in AMD IOMMU's alloc_coherent
> > 
> > x86's common alloc_coherent (dma_alloc_coherent in dma-mapping.h) sets
> > up the gfp flag according to the device dma_mask but AMD IOMMU doesn't
> > need it for devices that the IOMMU can do virtual mappings for. This
> > patch avoids unnecessary low zone allocation.
> > 
> > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > ---
> >  arch/x86/kernel/amd_iommu.c |    7 +++++--
> >  1 files changed, 5 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
> > index 01c68c3..8efd249 100644
> > --- a/arch/x86/kernel/amd_iommu.c
> > +++ b/arch/x86/kernel/amd_iommu.c
> > @@ -999,6 +999,11 @@ static void *alloc_coherent(struct device *dev, size_t size,
> >  	u16 devid;
> >  	phys_addr_t paddr;
> >  
> > +	get_device_resources(dev, &iommu, &domain, &devid);
> > +
> > +	if (iommu && domain)
> > +		flag &= ~(__GFP_DMA | __GFP_HIGHMEM | __GFP_DMA32);
> > +
> 
> These flags are already removed in the dma_alloc_coherent function which
> calls this one. Further I think in the case of a remapping IOMMU like

Not true about x86/tip/iommu. dma_alloc_coherent in dma-mapping.h does
that so that swiotlb and pci-nommu don't need the gfp hack. Clearing
the gfp flags is much simpler than setting up the flags correctly
mainly because of the fallback device, setting up the flags is really
difficult.


> this one we should avoid implementing any gfp hacks and just trust the
> caller.
> 
> >  	virt_addr = (void *)__get_free_pages(flag, get_order(size));
> >  	if (!virt_addr)
> >  		return 0;
> > @@ -1006,8 +1011,6 @@ static void *alloc_coherent(struct device *dev, size_t size,
> >  	memset(virt_addr, 0, size);
> >  	paddr = virt_to_phys(virt_addr);
> >  
> > -	get_device_resources(dev, &iommu, &domain, &devid);
> > -
> >  	if (!iommu || !domain) {
> >  		*dma_addr = (dma_addr_t)paddr;
> >  		return virt_addr;
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
