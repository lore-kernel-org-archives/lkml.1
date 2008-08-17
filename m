Return-Path: <linux-kernel-owner+w=401wt.eu-S1754504AbYHQPhV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504AbYHQPhV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 11:37:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752035AbYHQPhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 11:37:09 -0400
Received: from sh.osrg.net ([192.16.179.4]:32910 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751671AbYHQPhH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 11:37:07 -0400
Date: Mon, 18 Aug 2008 00:36:18 +0900
To: mingo@elte.hu
Cc: fujita.tomonori@lab.ntt.co.jp, prarit@redhat.com, jbarnes@virtuousgeek.org,
       joro@8bytes.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH]: PCI: GART iommu alignment fixes [v2]
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080817125614.GA31875@elte.hu>
References: <20080815180048.GA26844@elte.hu>
	<20080816101601K.fujita.tomonori@lab.ntt.co.jp>
	<20080817125614.GA31875@elte.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080818003648M.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Aug 2008 14:56:14 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> 
> > > Config is:
> > > 
> > >   http://redhat.com/~mingo/misc/config-Fri_Aug_15_18_30_56_CEST_2008.bad
> > > 
> > > Any idea why that is so? Apparently the alignment change wasnt as benign 
> > > as assumed.
> > 
> > Ah, sorry,
> > 
> > @@ -262,7 +264,11 @@ static dma_addr_t dma_map_area(struct device *dev, dma_addr_t phys_mem,
> >  static dma_addr_t
> >  gart_map_simple(struct device *dev, phys_addr_t paddr, size_t size, int dir)
> >  {
> > -	dma_addr_t map = dma_map_area(dev, paddr, size, dir);
> > +	dma_addr_t map;
> > +	unsigned long align_mask;
> > +
> > +	align_mask = (roundup_pow_of_two(size) >> PAGE_SHIFT) - 1;
> > +	map = dma_map_area(dev, paddr, size, dir, align_mask);
> > 
> > This code doesn't work with the case size < PAGE_SIZE.
> > 
> > I think that dmam_alloc_consistent in libata-core fails due to this
> > bug.
> > 
> > Can you try this?
> 
> ok - merged the commit below in tip/x86/iommu.
> 
> > BTW, I think that this is not urgent stuff at all.
> 
> ok - i've queued it up for v2.6.28.
> 
> 	Ingo
> 
> -------------->
> From 4ae29849888f85a0cee12553995d47ec527ad049 Mon Sep 17 00:00:00 2001
> From: Prarit Bhargava <prarit@redhat.com>
> Date: Sat, 16 Aug 2008 10:15:32 +0900
> Subject: [PATCH] x86 gart: allocate size-aligned address for alloc_coherent, v2
> 
> pci_alloc_consistent/dma_alloc_coherent does not return size aligned
> addresses.
> 
> >From Documentation/DMA-mapping.txt:
> 
> "pci_alloc_consistent returns two values: the virtual address which you
> can use to access it from the CPU and dma_handle which you pass to the
> card.
> 
> The cpu return address and the DMA bus master address are both
> guaranteed to be aligned to the smallest PAGE_SIZE order which
> is greater than or equal to the requested size.  This invariant
> exists (for example) to guarantee that if you allocate a chunk
> which is smaller than or equal to 64 kilobytes, the extent of the
> buffer you receive will not cross a 64K boundary."
> 
> 1.  Modify alloc_iommu to allow for an alignment mask
> 2.  Modify pci_gart_simple to return size-aligned values.
> 3.  Fixup the alignment calculation in the iommu-helper code.
> 4.  Fix possible overflow in alloc_iommu's boundary_size calculation.
>     (It is possible that alloc_iommu()'s boundary_size overflows as
>      dma_get_seg_boundary can return 0xffffffff.  In that case, further usage of
>      boundary_size triggers a BUG_ON() in the iommu code.)
> 
> End result: When allocating from IOMMU, pci_alloc_consistent/dma_alloc_coherent
> will now return a size aligned value.

The above commit log of Prarit's patch is completely wrong (so I wrote
this patch). To avoid misunderstanding, can you apply this patch with
a proper description like this:

=
This patch changes GART IOMMU to return a size aligned address wrt
dma_alloc_coherent, as DMA-mapping.txt defines:

The cpu return address and the DMA bus master address are both
guaranteed to be aligned to the smallest PAGE_SIZE order which
is greater than or equal to the requested size.  This invariant
exists (for example) to guarantee that if you allocate a chunk
which is smaller than or equal to 64 kilobytes, the extent of the
buffer you receive will not cross a 64K boundary.


But it is very unlikely that this matters. As DMA-mapping.txt
explains, This invariant is to avoid the boundary problem (such as
64K). Now the majority of IOMMUs including GART (except for Intel
IOMMU) don't allocate a buffer that crosses a 64K boundary wrt all the
DMA mapping interfaces (dma_alloc_coherent, dma_map_sg, and
dma_map_single) because of segment_boundary_mask in struct
device_dma_parameters.
