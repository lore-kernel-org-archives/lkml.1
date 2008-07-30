Return-Path: <linux-kernel-owner+w=401wt.eu-S1755239AbYG3AoI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239AbYG3AoI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 20:44:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753161AbYG3An4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 20:43:56 -0400
Received: from sh.osrg.net ([192.16.179.4]:54496 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104AbYG3Anz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 20:43:55 -0400
Date: Wed, 30 Jul 2008 09:43:34 +0900
To: jbarnes@virtuousgeek.org
Cc: fujita.tomonori@lab.ntt.co.jp, joro@8bytes.org, prarit@redhat.com,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH]: PCI: GART iommu alignment fixes [v2]
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <200807281523.35469.jbarnes@virtuousgeek.org>
References: <20080723221033.GD13662@8bytes.org>
	<20080724081528F.fujita.tomonori@lab.ntt.co.jp>
	<200807281523.35469.jbarnes@virtuousgeek.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080730094303W.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jul 2008 15:23:35 -0700
Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> On Wednesday, July 23, 2008 4:14 pm FUJITA Tomonori wrote:
> > On Thu, 24 Jul 2008 00:10:33 +0200
> >
> > Joerg Roedel <joro@8bytes.org> wrote:
> > > On Wed, Jul 23, 2008 at 07:19:43AM -0400, Prarit Bhargava wrote:
> > > > pci_alloc_consistent/dma_alloc_coherent does not return size aligned
> > > > addresses.
> > > >
> > > > >From Documentation/DMA-mapping.txt:
> > > >
> > > > "pci_alloc_consistent returns two values: the virtual address which you
> > > > can use to access it from the CPU and dma_handle which you pass to the
> > > > card.
> > > >
> > > > The cpu return address and the DMA bus master address are both
> > > > guaranteed to be aligned to the smallest PAGE_SIZE order which
> > > > is greater than or equal to the requested size.  This invariant
> > > > exists (for example) to guarantee that if you allocate a chunk
> > > > which is smaller than or equal to 64 kilobytes, the extent of the
> > > > buffer you receive will not cross a 64K boundary."
> > >
> > > Interesting. Have you experienced any problems because of that
> > > misbehavior in the GART code? AMD IOMMU currently also violates this
> > > requirement. I will send a patch to fix that there too.
> >
> > IIRC, only PARISC and POWER IOMMUs follow the above rule. So I also
> > wondered what problem he hit.
> 
> Prarit, what's the latest here?  The v3 patch I have from you doesn't apply to 
> my tree but it looks like a good fix.  Care to send me a new patch against my 
> for-linus branch?

I'm not sure how the following cast to 'unsigned long long' fixes
something on X86_64.

> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
> 
> diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
> index 744126e..d3eb527 100644
> --- a/arch/x86/kernel/pci-gart_64.c
> +++ b/arch/x86/kernel/pci-gart_64.c
> @@ -85,7 +85,8 @@ AGPEXTERN __u32 *agp_gatt_table;
>  static unsigned long next_bit;  /* protected by iommu_bitmap_lock */
>  static int need_flush;		/* global flush state. set for each gart wrap */
>  
> -static unsigned long alloc_iommu(struct device *dev, int size)
> +static unsigned long alloc_iommu(struct device *dev, int size,
> +				 unsigned long mask)
>  {
>  	unsigned long offset, flags;
>  	unsigned long boundary_size;
> @@ -93,16 +94,17 @@ static unsigned long alloc_iommu(struct device *dev, int size)
>  
>  	base_index = ALIGN(iommu_bus_base & dma_get_seg_boundary(dev),
>  			   PAGE_SIZE) >> PAGE_SHIFT;
> -	boundary_size = ALIGN(dma_get_seg_boundary(dev) + 1,
> +	boundary_size = ALIGN((unsigned long long)dma_get_seg_boundary(dev) + 1,
>  			      PAGE_SIZE) >> PAGE_SHIFT;

I don't think that the following code works since the size is not
always a power of 2.


> @@ -265,7 +268,7 @@ static dma_addr_t dma_map_area(struct device *dev, dma_addr_t phys_mem,
>  static dma_addr_t
>  gart_map_simple(struct device *dev, phys_addr_t paddr, size_t size, int dir)
>  {
> -	dma_addr_t map = dma_map_area(dev, paddr, size, dir);
> +	dma_addr_t map = dma_map_area(dev, paddr, size, dir, size - 1);
