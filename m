Return-Path: <linux-kernel-owner+w=401wt.eu-S1756349AbYHFNiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349AbYHFNiV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 09:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753680AbYHFNgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 09:36:13 -0400
Received: from mo11.iij4u.or.jp ([210.138.174.79]:51006 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753180AbYHFNgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 09:36:12 -0400
Date: Wed, 6 Aug 2008 22:35:50 +0900
To: prarit@redhat.com
Cc: fujita.tomonori@lab.ntt.co.jp, jbarnes@virtuousgeek.org, joro@8bytes.org,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH]: PCI: GART iommu alignment fixes [v2]
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4899993D.3060109@redhat.com>
References: <200807281523.35469.jbarnes@virtuousgeek.org>
	<20080730094303W.fujita.tomonori@lab.ntt.co.jp>
	<4899993D.3060109@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080806223550K.tomof@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Aug 2008 08:29:49 -0400
Prarit Bhargava <prarit@redhat.com> wrote:

> 
> 
> FUJITA Tomonori wrote:
> > On Mon, 28 Jul 2008 15:23:35 -0700
> > Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> >
> >   
> >> On Wednesday, July 23, 2008 4:14 pm FUJITA Tomonori wrote:
> >>     
> >>> On Thu, 24 Jul 2008 00:10:33 +0200
> >>>
> >>> Joerg Roedel <joro@8bytes.org> wrote:
> >>>       
> >>>> On Wed, Jul 23, 2008 at 07:19:43AM -0400, Prarit Bhargava wrote:
> >>>>         
> >>>>> pci_alloc_consistent/dma_alloc_coherent does not return size aligned
> >>>>> addresses.
> >>>>>
> >>>>> >From Documentation/DMA-mapping.txt:
> >>>>>
> >>>>> "pci_alloc_consistent returns two values: the virtual address which you
> >>>>> can use to access it from the CPU and dma_handle which you pass to the
> >>>>> card.
> >>>>>
> >>>>> The cpu return address and the DMA bus master address are both
> >>>>> guaranteed to be aligned to the smallest PAGE_SIZE order which
> >>>>> is greater than or equal to the requested size.  This invariant
> >>>>> exists (for example) to guarantee that if you allocate a chunk
> >>>>> which is smaller than or equal to 64 kilobytes, the extent of the
> >>>>> buffer you receive will not cross a 64K boundary."
> >>>>>           
> >>>> Interesting. Have you experienced any problems because of that
> >>>> misbehavior in the GART code? AMD IOMMU currently also violates this
> >>>> requirement. I will send a patch to fix that there too.
> >>>>         
> >>> IIRC, only PARISC and POWER IOMMUs follow the above rule. So I also
> >>> wondered what problem he hit.
> >>>       
> >> Prarit, what's the latest here?  The v3 patch I have from you doesn't apply to 
> >> my tree but it looks like a good fix.  Care to send me a new patch against my 
> >> for-linus branch?
> >>     
> >
> > I'm not sure how the following cast to 'unsigned long long' fixes
> > something on X86_64.
> >
> >   
> 
> You can write a very simple module that kmalloc's a pci_dev, sets up 
> some trivial values for the dev, and then calls pci_alloc_consistent.  
> You will panic 100% of the time because  'dma_get_seg_boundary(dev) + 1' 
> overflows an unsigned long.

You can't kmalloc pci_dev or setup some trivial values. You need to
use a proper value. The pci code does for us.

Calgary IOMMU has the same code. New AMD IOMMU has the same code too.


> >> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
> >>
> >> diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
> >> index 744126e..d3eb527 100644
> >> --- a/arch/x86/kernel/pci-gart_64.c
> >> +++ b/arch/x86/kernel/pci-gart_64.c
> >> @@ -85,7 +85,8 @@ AGPEXTERN __u32 *agp_gatt_table;
> >>  static unsigned long next_bit;  /* protected by iommu_bitmap_lock */
> >>  static int need_flush;		/* global flush state. set for each gart wrap */
> >>  
> >> -static unsigned long alloc_iommu(struct device *dev, int size)
> >> +static unsigned long alloc_iommu(struct device *dev, int size,
> >> +				 unsigned long mask)
> >>  {
> >>  	unsigned long offset, flags;
> >>  	unsigned long boundary_size;
> >> @@ -93,16 +94,17 @@ static unsigned long alloc_iommu(struct device *dev, int size)
> >>  
> >>  	base_index = ALIGN(iommu_bus_base & dma_get_seg_boundary(dev),
> >>  			   PAGE_SIZE) >> PAGE_SHIFT;
> >> -	boundary_size = ALIGN(dma_get_seg_boundary(dev) + 1,
> >> +	boundary_size = ALIGN((unsigned long long)dma_get_seg_boundary(dev) + 1,
> >>  			      PAGE_SIZE) >> PAGE_SHIFT;
> >>     
> >
> > I don't think that the following code works since the size is not
> > always a power of 2.
> >   
> 
> 
> 
> >
> >   
> >> @@ -265,7 +268,7 @@ static dma_addr_t dma_map_area(struct device *dev, dma_addr_t phys_mem,
> >>  static dma_addr_t
> >>  gart_map_simple(struct device *dev, phys_addr_t paddr, size_t size, int dir)
> >>  {
> >> -	dma_addr_t map = dma_map_area(dev, paddr, size, dir);
> >> +	dma_addr_t map = dma_map_area(dev, paddr, size, dir, size - 1);
> >>     
> 
> Maybe I'm missing something -- what implies  size has to be a power of two?

Yes, see iommu_area_alloc().
