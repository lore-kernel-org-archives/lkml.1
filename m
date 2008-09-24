Return-Path: <linux-kernel-owner+w=401wt.eu-S1753179AbYIXMqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179AbYIXMqd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 08:46:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751325AbYIXMq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 08:46:26 -0400
Received: from sh.osrg.net ([192.16.179.4]:51979 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750938AbYIXMqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 08:46:25 -0400
Date: Wed, 24 Sep 2008 21:43:59 +0900
To: joerg.roedel@amd.com
Cc: fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu, linux-kernel@vger.kernel.org,
       andi@firstfloor.org
Subject: Re: [PATCH 3/3] x86: restore old GART alloc_coherent behavior
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080924121127.GS24392@amd.com>
References: <1222256917-14321-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1222256917-14321-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<20080924121127.GS24392@amd.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080924214353U.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Sep 2008 14:11:27 +0200
Joerg Roedel <joerg.roedel@amd.com> wrote:

> On Wed, Sep 24, 2008 at 08:48:37PM +0900, FUJITA Tomonori wrote:
> > Currently, GART alloc_coherent tries to allocate pages with GFP_DMA32
> > for a device having dma_masks > 24bit < 32bits. If GART gets an
> > address that a device can't access to, GART try to map the address to
> > a virtual I/O address that the device can access to.
> > 
> > But Andi pointed out, "The GART is somewhere in the 4GB range so you
> > cannot use it to map anything < 4GB. Also GART is pretty small."
> > 
> > http://lkml.org/lkml/2008/9/12/43
> > 
> > That is, it's possible that GART doesn't have virtual I/O address
> > space that a device can access to. The above behavior doesn't work for
> > a device having dma_masks > 24bit < 32bits.
> > 
> > This patch restores old GART alloc_coherent behavior (before the
> > alloc_coherent rewrite).
> 
> Patchset looks good in principle. But I have a small question, see
> below.
> 
> > 
> > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > ---
> >  arch/x86/kernel/pci-gart_64.c |   43 +++++++++++++++++++---------------------
> >  1 files changed, 20 insertions(+), 23 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
> > index 7e08e46..25c94fb 100644
> > --- a/arch/x86/kernel/pci-gart_64.c
> > +++ b/arch/x86/kernel/pci-gart_64.c
> > @@ -487,31 +487,28 @@ static void *
> >  gart_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_addr,
> >  		    gfp_t flag)
> >  {
> > -	void *vaddr;
> >  	dma_addr_t paddr;
> >  	unsigned long align_mask;
> > -	u64 dma_mask = dma_alloc_coherent_mask(dev, flag);
> > -
> > -	vaddr = (void *)__get_free_pages(flag | __GFP_ZERO, get_order(size));
> > -	if (!vaddr)
> > -		return NULL;
> > -
> > -	paddr = virt_to_phys(vaddr);
> > -	if (is_buffer_dma_capable(dma_mask, paddr, size)) {
> > -		*dma_addr = paddr;
> > -		return vaddr;
> > -	}
> > -
> > -	align_mask = (1UL << get_order(size)) - 1;
> > -
> > -	*dma_addr = dma_map_area(dev, paddr, size, DMA_BIDIRECTIONAL,
> > -				 align_mask);
> > -	flush_gart();
> > -
> > -	if (*dma_addr != bad_dma_address)
> > -		return vaddr;
> > -
> > -	free_pages((unsigned long)vaddr, get_order(size));
> > +	struct page *page;
> > +
> > +	if (force_iommu && !(flag & GFP_DMA)) {
> > +		flag &= ~(__GFP_DMA | __GFP_HIGHMEM | __GFP_DMA32);
> > +		page = alloc_pages(flag | __GFP_ZERO, get_order(size));
> > +		if (!page)
> > +			return NULL;
> > +
> > +		align_mask = (1UL << get_order(size)) - 1;
> > +		paddr = dma_map_area(dev, page_to_phys(page), size,
> > +				     DMA_BIDIRECTIONAL, align_mask);
> 
> Can't we check if a mapping is required before calling dma_map_area?
> Your recently introduced IOMMU helper functions should make that easy
> and GART address space is a rare resource. AFAIR this is also the
> behaviour of the old generic dma_alloc_coherent function.

I think that the behavior of the old generic dma_alloc_coherent
function and GART is different.

The old GART code does virtual mappings only with force_iommu option
enabled. The old GART code always do virtual mappings with force_iommu
option enabled (unless GFP_DMA is set).


> > +
> > +		flush_gart();
> 
> This should depend on need_flush.

Theoretically, yes, I think. But this patch restores the old GART code
behavior.
