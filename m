Return-Path: <linux-kernel-owner+w=401wt.eu-S1752152AbZHMCLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152AbZHMCLq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 22:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751312AbZHMCLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 22:11:46 -0400
Received: from sh.osrg.net ([192.16.179.4]:60457 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751060AbZHMCLp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 22:11:45 -0400
Date: Thu, 13 Aug 2009 11:11:14 +0900
To: luming.yu@gmail.com
Cc: dwmw2@infradead.org, fenghua.yu@intel.com, tony.luck@intel.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [RFC patch] init default dma_ops to prepare intel_iommu_init
 failure
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <3877989d0908120220q5104d2e7rd272ececbc45e377@mail.gmail.com>
References: <3877989d0908120220q5104d2e7rd272ececbc45e377@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090813110948V.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 13 Aug 2009 11:11:14 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Aug 2009 17:20:11 +0800
Luming Yu <luming.yu@gmail.com> wrote:

> Hi there,
> 
> On ia64 platform with dmar table and new upstream
> kernel(config_dmar_default_on enabled),
> if intel_iommu_init ends up without dma_ops initialized or other iommu
> failures.
> We got nothing to fall back. The following patch fixes it.

Hmm, I think that the current code should work.

If intel_iommu_init ends up without dma_ops initialized or other iommu
failures, then 'iommu_detected' should be zero.


Note that IA64_DIG_VTD doesn't enable SWIOTLB so there is fall
back. That's kinda the IA64 policy about non IA64_GENERIC kernel.


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
