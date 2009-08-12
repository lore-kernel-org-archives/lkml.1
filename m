Return-Path: <linux-kernel-owner+w=401wt.eu-S1752861AbZHLSRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861AbZHLSRW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 14:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbZHLSRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 14:17:22 -0400
Received: from mga14.intel.com ([143.182.124.37]:27048 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752566AbZHLSRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 14:17:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,369,1246863600"; 
   d="scan'208";a="175093807"
Date: Wed, 12 Aug 2009 11:17:22 -0700
From: Fenghua Yu <fenghua.yu@intel.com>
To: Luming Yu <luming.yu@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
       "Yu, Fenghua" <fenghua.yu@intel.com>,
       "Luck, Tony" <tony.luck@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC patch] init default dma_ops to prepare intel_iommu_init failure
Message-ID: <20090812181722.GA32653@linux-os.sc.intel.com>
References: <3877989d0908120220q5104d2e7rd272ececbc45e377@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3877989d0908120220q5104d2e7rd272ececbc45e377@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi there,
> 
> On ia64 platform with dmar table and new upstream
> kernel(config_dmar_default_on enabled),
> if intel_iommu_init ends up without dma_ops initialized or other iommu
> failures.
> We got nothing to fall back. The following patch fixes it.
> 
x86/x86-64 also needs this fix. Please check the pci_swiotlb_init for x86/64.

> Please review. If make sense, please apply.
> 
> **The patch is enclosed in text attachment*
> **Using web client to send the patch* *
> **below is for review, please apply attached  patch*/
> 
> Thanks,
> Luming
> 
> Signed-off-by: Yu Luming <luming.yu@intel.com>
> 
> arch/ia64/kernel/pci-swiotlb.c |   14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/ia64/kernel/pci-swiotlb.c b/arch/ia64/kernel/pci-swiotlb.c
> index 223abb1..d5dcaf5 100644
> --- a/arch/ia64/kernel/pci-swiotlb.c
> +++ b/arch/ia64/kernel/pci-swiotlb.c
> @@ -46,15 +46,13 @@ void __init swiotlb_dma_init(void)
> 
>  void __init pci_swiotlb_init(void)
>  {
> -	if (!iommu_detected || iommu_pass_through) {

This check can not be removed. Otherwise, swiotlb_dma_ops will always override
previous dma_ops value.

I think you can change this check to something like:
	if (!dma_ops || iommu_pass_through) {
With this change, checking iommu_detected is unnecesary because checking dma_ops
covers it.

>  #ifdef CONFIG_IA64_GENERIC
> -		swiotlb = 1;
> -		printk(KERN_INFO "PCI-DMA: Re-initialize machine vector.\n");
> -		machvec_init("dig");
> -		swiotlb_init();
> -		dma_ops = &swiotlb_dma_ops;
> +	swiotlb = 1;
> +	printk(KERN_INFO "PCI-DMA: Re-initialize machine vector.\n");
> +	machvec_init("dig");
> +	swiotlb_init();
> +	dma_ops = &swiotlb_dma_ops;
>  #else
> -		panic("Unable to find Intel IOMMU");
> +	panic("Unable to find Intel IOMMU");
>  #endif
> -	}
>  }



