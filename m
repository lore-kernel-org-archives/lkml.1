Return-Path: <linux-kernel-owner+w=401wt.eu-S933924AbZKXSvD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933924AbZKXSvD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 13:51:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933852AbZKXSvB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 13:51:01 -0500
Received: from hera.kernel.org ([140.211.167.34]:43400 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933846AbZKXSvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 13:51:01 -0500
Message-ID: <4B0C2A80.5090609@kernel.org>
Date: Tue, 24 Nov 2009 10:48:32 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix gart iommu using for amd 64 bit system
References: <4B0BAC06.1000905@kernel.org>	<20091124193031P.fujita.tomonori@lab.ntt.co.jp>	<4B0BB892.9080401@kernel.org> <20091124225000H.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20091124225000H.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> On Tue, 24 Nov 2009 02:42:26 -0800
> Yinghai Lu <yinghai@kernel.org> wrote:
> 
>> at GART iommu workaround : it is not rare. a lot of systems have this problem.
>> and that workaround works well for several years.
> 
> swiotlb has worked too.
> 
> 
>> don't think user will like to use SWIOTLB instead of swiotlb.
> 
> I doubt that users care about a way to fix their problems.
> 
> 
>> that gart iommu hardware is not broken, just those BIOS guys just forget to program it.
>>
>> here intel vt-d is different, it seems can not make it work just program some hardware register...
> 
> Because BIOS is broken, IIRC. Both cases are pretty similar.
> 
>> please check my v2 patch, to see if it breaks your setup.
> 
> As I said, adding another trick only for GART is not good. And using
> force_iommu in pci-dma.c is confusing since force_iommu should be used
> only in X86_64.
> 
> The following patch works for you?
> 
> 
> diff --git a/arch/x86/include/asm/swiotlb.h b/arch/x86/include/asm/swiotlb.h
> index 87ffcb1..8085277 100644
> --- a/arch/x86/include/asm/swiotlb.h
> +++ b/arch/x86/include/asm/swiotlb.h
> @@ -5,13 +5,17 @@
>  
>  #ifdef CONFIG_SWIOTLB
>  extern int swiotlb;
> -extern int pci_swiotlb_init(void);
> +extern int __init pci_swiotlb_detect(void);
> +extern void __init pci_swiotlb_init(void);
>  #else
>  #define swiotlb 0
> -static inline int pci_swiotlb_init(void)
> +static inline int pci_swiotlb_detect(void)
>  {
>  	return 0;
>  }
> +static inline void pci_swiotlb_init(void)
> +{
> +}
>  #endif
>  
>  static inline void dma_mark_clean(void *addr, size_t size) {}
> diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
> index e0dfb68..750dd8d 100644
> --- a/arch/x86/kernel/aperture_64.c
> +++ b/arch/x86/kernel/aperture_64.c
> @@ -401,6 +401,7 @@ void __init gart_iommu_hole_init(void)
>  
>  			iommu_detected = 1;
>  			gart_iommu_aperture = 1;
> +			swiotlb = 0;
>  			x86_init.iommu.iommu_init = gart_iommu_init;
>  
>  			aper_order = (read_pci_config(bus, slot, 3, AMD64_GARTAPERTURECTL) >> 1) & 7;
> @@ -458,7 +459,7 @@ out:
>  
>  	if (aper_alloc) {
>  		/* Got the aperture from the AGP bridge */
> -	} else if (!valid_agp) {
> +	} else if (swiotlb && !valid_agp) {
>  		/* Do nothing */

still have some problem here.
because you set swiotlb to 0 before. it will break
iommu=soft

when amd 64bit system, ram > 4g, and no AGP bridge, and BIOS doesn't set gart.
if the user set iommu=soft.
old way, kernel will use swiotlb.

so instead set swiotlb before, it seems you should restore
 			iommu_detected
 			gart_iommu_aperture
			swiotlb = 0;
 			x86_init.iommu.iommu_init
to make swiotlb happy later.

>  	} else if ((!no_iommu && max_pfn > MAX_DMA32_PFN) ||
>  		   force_iommu ||
> diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
> index afcc58b..75e14e2 100644
> --- a/arch/x86/kernel/pci-dma.c
> +++ b/arch/x86/kernel/pci-dma.c
> @@ -124,8 +124,8 @@ void __init pci_iommu_alloc(void)
>  	/* free the range so iommu could get some range less than 4G */
>  	dma32_free_bootmem();
>  #endif
> -	if (pci_swiotlb_init())
> -		return;
> +	if (pci_swiotlb_detect())
> +		goto out;
>  
>  	gart_iommu_hole_init();
>  
> @@ -135,6 +135,8 @@ void __init pci_iommu_alloc(void)
>  
>  	/* needs to be called after gart_iommu_hole_init */
>  	amd_iommu_detect();
> +out:
> +	pci_swiotlb_init();
>  }
>  
>  void *dma_generic_alloc_coherent(struct device *dev, size_t size,
> diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
> index e6a0d40..2358409 100644
> --- a/arch/x86/kernel/pci-gart_64.c
> +++ b/arch/x86/kernel/pci-gart_64.c
> @@ -847,7 +847,6 @@ int __init gart_iommu_init(void)
>  	flush_gart();
>  	dma_ops = &gart_dma_ops;
>  	x86_platform.iommu_shutdown = gart_iommu_shutdown;
> -	swiotlb = 0;
>  
>  	return 0;
>  }
> diff --git a/arch/x86/kernel/pci-swiotlb.c b/arch/x86/kernel/pci-swiotlb.c
> index e36e71d..6971ba5 100644
> --- a/arch/x86/kernel/pci-swiotlb.c
> +++ b/arch/x86/kernel/pci-swiotlb.c
> @@ -43,12 +43,12 @@ static struct dma_map_ops swiotlb_dma_ops = {
>  };
>  
>  /*
> - * pci_swiotlb_init - initialize swiotlb if necessary
> + * pci_swiotlb_init - set swiotlb to 1 if necessary

pci_swiotlb_detect ?

YH
