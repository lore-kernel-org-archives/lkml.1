Return-Path: <linux-kernel-owner+w=401wt.eu-S1761233AbYCGQq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761233AbYCGQq4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 11:46:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756189AbYCGQqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 11:46:48 -0500
Received: from mo10.iij4u.or.jp ([210.138.174.78]:55361 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751759AbYCGQqr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 11:46:47 -0500
Date: Sat, 8 Mar 2008 01:45:42 +0900
To: ink@jurassic.park.msu.ru
Cc: tomof@acm.org, rct@frus.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       linux-alpha@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
       akpm@linux-foundation.org
Subject: Re: [regression]2.6.25-rc4: boot panic on alpha
From: FUJITA Tomonori <tomof@acm.org>
In-Reply-To: <20080307162116.GA18563@jurassic.park.msu.ru>
References: <20080307141439.GB23178@elte.hu>
	<20080307235616T.tomof@acm.org>
	<20080307162116.GA18563@jurassic.park.msu.ru>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080308014543E.tomof@acm.org>
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Mar 2008 19:21:16 +0300
Ivan Kokshaysky <ink@jurassic.park.msu.ru> wrote:

> On Fri, Mar 07, 2008 at 11:56:40PM +0900, FUJITA Tomonori wrote:
> > Very sorry, I probably broke the IOMMU. I don't have the hardware so
> > I've not tested the patches.
> 
> Unfortunately, I was not able to test these patches either, as my
> alpha with iommmu and scsi is disassembled at the moment, thanks to
> dead CPU fan...
> 
> > -	BUG_ON(arena->dma_base & ~PAGE_MASK);
> > +	if (arena->dma_base & ~PAGE_MASK)
> > +		printk("%s %d: %lx\n", __FUNCTION__, __LINE__, arena->dma_base);
> 
> arena->dma_base is always properly aligned - it's pretty fundamental thing.

Thanks, I see.


> >  	base = arena->dma_base >> PAGE_SHIFT;
> >  	if (dev)
> >  		boundary_size = ALIGN(dma_get_max_seg_size(dev) + 1, PAGE_SIZE)
> 				      ^^^^^^^^^^^^^^^^^^^^^^^^^
> Must be dma_get_seg_boundary(dev). Hopefully it's the only typo ;-)

Ah, a stupid typo...


> > @@ -152,7 +155,8 @@ iommu_arena_find_pages(struct device *dev, struct pci_iommu_arena *arena,
> >  	else
> >  		boundary_size = ALIGN(1UL << 32, PAGE_SIZE) >> PAGE_SHIFT;
> 
> A bit of abuse of ALIGN() macro, to my taste ;-)
> 
> > -	BUG_ON(!is_power_of_2(boundary_size));
> > +	if (!is_power_of_2(boundary_size))
> > +		printk("%s %d: %lx\n", __FUNCTION__, __LINE__, boundary_size);
> 
> Perhaps it was that, if the scsi driver set max_seg_size to something
> other than default 65536 (and not a power of two)...

Yeah, probably (and hopefully) it was.


> Bob, can you give it a try?
> 
> Ivan.
> 
> diff --git a/arch/alpha/kernel/pci_iommu.c b/arch/alpha/kernel/pci_iommu.c
> index be6fa10..e07a23f 100644
> --- a/arch/alpha/kernel/pci_iommu.c
> +++ b/arch/alpha/kernel/pci_iommu.c
> @@ -144,15 +144,14 @@ iommu_arena_find_pages(struct device *dev, struct pci_iommu_arena *arena,
>  	unsigned long base;
>  	unsigned long boundary_size;
>  
> -	BUG_ON(arena->dma_base & ~PAGE_MASK);
>  	base = arena->dma_base >> PAGE_SHIFT;
> -	if (dev)
> -		boundary_size = ALIGN(dma_get_max_seg_size(dev) + 1, PAGE_SIZE)
> -			>> PAGE_SHIFT;
> -	else
> -		boundary_size = ALIGN(1UL << 32, PAGE_SIZE) >> PAGE_SHIFT;
> -
> -	BUG_ON(!is_power_of_2(boundary_size));
> +	if (dev) {
> +		boundary_size = dma_get_seg_boundary(dev) + 1;
> +		BUG_ON(!is_power_of_2(boundary_size));
> +		boundary_size >>= PAGE_SHIFT;
> +	} else {
> +		boundary_size = 1UL << (32 - PAGE_SHIFT);
> +	}
>  
>  	/* Search forward for the first mask-aligned sequence of N free ptes */
>  	ptes = arena->ptes;

Thanks!
