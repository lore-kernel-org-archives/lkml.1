Return-Path: <linux-kernel-owner+w=401wt.eu-S1752668AbZHMEtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbZHMEtr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 00:49:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbZHMEtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 00:49:47 -0400
Received: from sh.osrg.net ([192.16.179.4]:33800 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568AbZHMEtq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 00:49:46 -0400
Date: Thu, 13 Aug 2009 13:49:27 +0900
To: fenghua.yu@intel.com
Cc: luming.yu@gmail.com, dwmw2@infradead.org, tony.luck@intel.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [RFC patch] init default dma_ops to prepare intel_iommu_init
 failure
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090812181722.GA32653@linux-os.sc.intel.com>
References: <3877989d0908120220q5104d2e7rd272ececbc45e377@mail.gmail.com>
	<20090812181722.GA32653@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090813132845R.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 13 Aug 2009 13:49:28 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Aug 2009 11:17:22 -0700
Fenghua Yu <fenghua.yu@intel.com> wrote:

> > Hi there,
> > 
> > On ia64 platform with dmar table and new upstream
> > kernel(config_dmar_default_on enabled),
> > if intel_iommu_init ends up without dma_ops initialized or other iommu
> > failures.
> > We got nothing to fall back. The following patch fixes it.
> > 
> x86/x86-64 also needs this fix. Please check the pci_swiotlb_init for x86/64.

x86 falls back into nommu_dam_ops (though it would be better to use
swiotlb on x86_64).


> > Please review. If make sense, please apply.
> > 
> > **The patch is enclosed in text attachment*
> > **Using web client to send the patch* *
> > **below is for review, please apply attached  patch*/
> > 
> > Thanks,
> > Luming
> > 
> > Signed-off-by: Yu Luming <luming.yu@intel.com>
> > 
> > arch/ia64/kernel/pci-swiotlb.c |   14 ++++++--------
> >  1 file changed, 6 insertions(+), 8 deletions(-)
> > 
> > diff --git a/arch/ia64/kernel/pci-swiotlb.c b/arch/ia64/kernel/pci-swiotlb.c
> > index 223abb1..d5dcaf5 100644
> > --- a/arch/ia64/kernel/pci-swiotlb.c
> > +++ b/arch/ia64/kernel/pci-swiotlb.c
> > @@ -46,15 +46,13 @@ void __init swiotlb_dma_init(void)
> > 
> >  void __init pci_swiotlb_init(void)
> >  {
> > -	if (!iommu_detected || iommu_pass_through) {
> 
> This check can not be removed. Otherwise, swiotlb_dma_ops will always override
> previous dma_ops value.

Yeah.


> I think you can change this check to something like:
> 	if (!dma_ops || iommu_pass_through) {

I don't think this work since pci_iommu_alloc() always sets up dma_ops
and calls pci_swiotlb_init().

All we need to do here is calling swiotlb_init() then we can use
swiotlb_dma_ops after intel_iommu_init() fails:

http://marc.info/?l=linux-kernel&m=125013354518721&w=2


> With this change, checking iommu_detected is unnecesary because checking dma_ops
> covers it.
> 
> >  #ifdef CONFIG_IA64_GENERIC
> > -		swiotlb = 1;
> > -		printk(KERN_INFO "PCI-DMA: Re-initialize machine vector.\n");
> > -		machvec_init("dig");
> > -		swiotlb_init();
> > -		dma_ops = &swiotlb_dma_ops;
> > +	swiotlb = 1;
> > +	printk(KERN_INFO "PCI-DMA: Re-initialize machine vector.\n");
> > +	machvec_init("dig");
> > +	swiotlb_init();
> > +	dma_ops = &swiotlb_dma_ops;
> >  #else
> > -		panic("Unable to find Intel IOMMU");
> > +	panic("Unable to find Intel IOMMU");
> >  #endif
> > -	}
> >  }
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
