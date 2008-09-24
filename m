Return-Path: <linux-kernel-owner+w=401wt.eu-S1753286AbYIXM57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286AbYIXM57 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 08:57:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbYIXM5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 08:57:51 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:54466 "EHLO
	WA4EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456AbYIXM5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 08:57:50 -0400
X-BigFish: VPS-37(zz1418M1432R98dR1805M179dR936fO873fnzzzz2f39iz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0K7PAO2-03-LI0-01
Date: Wed, 24 Sep 2008 14:57:40 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org, andi@firstfloor.org
Subject: Re: [PATCH 3/3] x86: restore old GART alloc_coherent behavior
Message-ID: <20080924125740.GT24392@amd.com>
References: <1222256917-14321-3-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1222256917-14321-4-git-send-email-fujita.tomonori@lab.ntt.co.jp> <20080924121127.GS24392@amd.com> <20080924214353U.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080924214353U.fujita.tomonori@lab.ntt.co.jp>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 24 Sep 2008 12:57:40.0800 (UTC) FILETIME=[20C30C00:01C91E45]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2008 at 09:43:59PM +0900, FUJITA Tomonori wrote:
> On Wed, 24 Sep 2008 14:11:27 +0200
> Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > On Wed, Sep 24, 2008 at 08:48:37PM +0900, FUJITA Tomonori wrote:
> > > Currently, GART alloc_coherent tries to allocate pages with GFP_DMA32
> > > for a device having dma_masks > 24bit < 32bits. If GART gets an
> > > address that a device can't access to, GART try to map the address to
> > > a virtual I/O address that the device can access to.
> > > 
> > > But Andi pointed out, "The GART is somewhere in the 4GB range so you
> > > cannot use it to map anything < 4GB. Also GART is pretty small."
> > > 
> > > http://lkml.org/lkml/2008/9/12/43
> > > 
> > > That is, it's possible that GART doesn't have virtual I/O address
> > > space that a device can access to. The above behavior doesn't work for
> > > a device having dma_masks > 24bit < 32bits.
> > > 
> > > This patch restores old GART alloc_coherent behavior (before the
> > > alloc_coherent rewrite).
> > 
> > Patchset looks good in principle. But I have a small question, see
> > below.
> > 
> > > 
> > > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > > ---
> > >  arch/x86/kernel/pci-gart_64.c |   43 +++++++++++++++++++---------------------
> > >  1 files changed, 20 insertions(+), 23 deletions(-)
> > > 
> > > diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
> > > index 7e08e46..25c94fb 100644
> > > --- a/arch/x86/kernel/pci-gart_64.c
> > > +++ b/arch/x86/kernel/pci-gart_64.c
> > > @@ -487,31 +487,28 @@ static void *
> > >  gart_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_addr,
> > >  		    gfp_t flag)
> > >  {
> > > -	void *vaddr;
> > >  	dma_addr_t paddr;
> > >  	unsigned long align_mask;
> > > -	u64 dma_mask = dma_alloc_coherent_mask(dev, flag);
> > > -
> > > -	vaddr = (void *)__get_free_pages(flag | __GFP_ZERO, get_order(size));
> > > -	if (!vaddr)
> > > -		return NULL;
> > > -
> > > -	paddr = virt_to_phys(vaddr);
> > > -	if (is_buffer_dma_capable(dma_mask, paddr, size)) {
> > > -		*dma_addr = paddr;
> > > -		return vaddr;
> > > -	}
> > > -
> > > -	align_mask = (1UL << get_order(size)) - 1;
> > > -
> > > -	*dma_addr = dma_map_area(dev, paddr, size, DMA_BIDIRECTIONAL,
> > > -				 align_mask);
> > > -	flush_gart();
> > > -
> > > -	if (*dma_addr != bad_dma_address)
> > > -		return vaddr;
> > > -
> > > -	free_pages((unsigned long)vaddr, get_order(size));
> > > +	struct page *page;
> > > +
> > > +	if (force_iommu && !(flag & GFP_DMA)) {
> > > +		flag &= ~(__GFP_DMA | __GFP_HIGHMEM | __GFP_DMA32);
> > > +		page = alloc_pages(flag | __GFP_ZERO, get_order(size));
> > > +		if (!page)
> > > +			return NULL;
> > > +
> > > +		align_mask = (1UL << get_order(size)) - 1;
> > > +		paddr = dma_map_area(dev, page_to_phys(page), size,
> > > +				     DMA_BIDIRECTIONAL, align_mask);
> > 
> > Can't we check if a mapping is required before calling dma_map_area?
> > Your recently introduced IOMMU helper functions should make that easy
> > and GART address space is a rare resource. AFAIR this is also the
> > behaviour of the old generic dma_alloc_coherent function.
> 
> I think that the behavior of the old generic dma_alloc_coherent
> function and GART is different.
> 
> The old GART code does virtual mappings only with force_iommu option
> enabled. The old GART code always do virtual mappings with force_iommu
> option enabled (unless GFP_DMA is set).

Hmm true, the old code called map_simple and not map_single so it mapped
always.

> 
> 
> > > +
> > > +		flush_gart();
> > 
> > This should depend on need_flush.
> 
> Theoretically, yes, I think. But this patch restores the old GART code
> behavior.

Ok. The map_simple function of GART did it unconditionally too so this
is the old behavior. But its safe here to flush conditionally. I'll send
a follow-up patch.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

