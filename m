Return-Path: <linux-kernel-owner+w=401wt.eu-S1756861AbZA2Xgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861AbZA2Xgc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 18:36:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752478AbZA2XgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 18:36:23 -0500
Received: from sh.osrg.net ([192.16.179.4]:60517 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644AbZA2XgW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 18:36:22 -0500
Date: Fri, 30 Jan 2009 08:36:12 +0900
To: y-goto@jp.fujitsu.com
Cc: fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu, tony.luck@intel.com,
       linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org
Subject: Re: [PATCH -tip 1/3] IA64: fix swiotlb alloc_coherent for non
 DMA_64BIT_MASK devices
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090130073511.F48F.E1E9C6FF@jp.fujitsu.com>
References: <20090129200303.E2C2.E1E9C6FF@jp.fujitsu.com>
	<20090129205446N.fujita.tomonori@lab.ntt.co.jp>
	<20090130073511.F48F.E1E9C6FF@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090130083654U.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 30 Jan 2009 08:36:13 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Jan 2009 07:54:07 +0900
Yasunori Goto <y-goto@jp.fujitsu.com> wrote:

> > On Thu, 29 Jan 2009 20:41:07 +0900
> > Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
> > 
> > > > Before the dma ops unification, IA64 always uses GFP_DMA for
> > > > dma_alloc_coherent like:
> > > > 
> > > > #define dma_alloc_coherent(dev, size, handle, gfp)	\
> > > > 	platform_dma_alloc_coherent(dev, size, handle, (gfp) | GFP_DMA)
> > > > 
> > > > This GFP_DMA enforcement doesn't make sense for IOMMUs since they can
> > > > do address translation to give addresses that devices can access
> > > > to. The IOMMU drivers ignore the zone flag. However, this is still
> > > > necessary for swiotlb since it can't do address translation.
> > > > 
> > > > We don't always need to use GFP_DMA for swiotlb. We need GFP_DMA for
> > > > devices incapable of 64bit DMA.
> > > > 
> > > > This patch is sorta updated version of:
> > > > 
> > > > http://marc.info/?l=linux-kernel&m=122638215612705&w=2
> > > > 
> > > > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > > > Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
> > > > ---
> > > >  arch/ia64/kernel/pci-swiotlb.c |   10 +++++++++-
> > > >  1 files changed, 9 insertions(+), 1 deletions(-)
> > > > 
> > > > diff --git a/arch/ia64/kernel/pci-swiotlb.c b/arch/ia64/kernel/pci-swiotlb.c
> > > > index 717ad4f..573f02c 100644
> > > > --- a/arch/ia64/kernel/pci-swiotlb.c
> > > > +++ b/arch/ia64/kernel/pci-swiotlb.c
> > > > @@ -13,8 +13,16 @@
> > > >  int swiotlb __read_mostly;
> > > >  EXPORT_SYMBOL(swiotlb);
> > > >  
> > > > +static void *ia64_swiotlb_alloc_coherent(struct device *dev, size_t size,
> > > > +					 dma_addr_t *dma_handle, gfp_t gfp)
> > > > +{
> > > > +	if (dev->coherent_dma_mask != DMA_64BIT_MASK)
> > > > +		gfp |= GFP_DMA;
> > > > +	return swiotlb_alloc_coherent(dev, size, dma_handle, gfp);
> > > > +}
> > > > +
> > > >  struct dma_map_ops swiotlb_dma_ops = {
> > > > -	.alloc_coherent = swiotlb_alloc_coherent,
> > > > +	.alloc_coherent = ia64_swiotlb_alloc_coherent,
> > > >  	.free_coherent = swiotlb_free_coherent,
> > > >  	.map_page = swiotlb_map_page,
> > > >  	.unmap_page = swiotlb_unmap_page,
> > > > -- 
> > > > 1.6.0.6
> > > 
> > > 
> > > Though I may be misunderstanding something, this initialization seems to be
> > > called only when CONFIG_IA64_DIG_VTD is on.
> > 
> > Hmm, what's 'this initialization'?
> > 
> > This patch always sets swiotlb_dma_ops.alloc_coherent to
> > ia64_swiotlb_alloc_coherent.
> 
> I tested your patch, but, ia64_swiotlb_alloc_coherent() was not called with
> CONFIG_GENERIC.

You use the generic kernel on a DIG box, right? If so, yeah, there is
something wrong.


> swiotlb_dma_ops is set by pci_swiotlb_init().
> However, it seems to be not called when CONFIG_IA64_DIG/Generic configuration.

You are talking about setting dma_ops to swiotlb_dma_ops?

I think that swiotlb_dma_init() also sets dma_ops to swiotlb_dma_ops.
