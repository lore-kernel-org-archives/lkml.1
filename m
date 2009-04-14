Return-Path: <linux-kernel-owner+w=401wt.eu-S1754362AbZDNKra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362AbZDNKra (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 06:47:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752271AbZDNKrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 06:47:20 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:29203
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750856AbZDNKrT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 06:47:19 -0400
X-BigFish: VPS-25(zz1432R98dR1805M936fKzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KI37AJ-04-9U0-01
Date: Tue, 14 Apr 2009 12:48:50 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH 2/2] gart: reimplement IOMMU_LEAK feature by using
	DMA_API_DEBUG
Message-ID: <20090414104850.GF1141@amd.com>
References: <1239669799-23579-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1239669799-23579-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <1239669799-23579-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 14 Apr 2009 10:47:07.0393 (UTC) FILETIME=[5B217F10:01C9BCEE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 09:43:19AM +0900, FUJITA Tomonori wrote:
> IOMMU_LEAK, GART's own feature, dumps the used IOMMU entries when
> IOMMU entries is full, which might be useful to find a bad driver that
> eats IOMMU entries.
> 
> DMA_API_DEBUG provides the similar feature, debug_dma_dump_mappings,
> and it's better than GART's IOMMU_LEAK feature. GART's IOMMU_LEAK
> feature doesn't say who uses IOMMU entries so it's hard to find a bad
> driver.
> 
> This patch reimplements the GART's IOMMU_LEAK feature by using
> DMA_API_DEBUG.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Yeah, I also had that on my list :-) This feature is indeed unnecessary now.

Acked-by: Joerg Roedel <joerg.roedel@amd.com>

> ---
>  arch/x86/Kconfig.debug        |    3 +-
>  arch/x86/kernel/pci-gart_64.c |   45 +++++++---------------------------------
>  2 files changed, 9 insertions(+), 39 deletions(-)
> 
> diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
> index d8359e7..5865712 100644
> --- a/arch/x86/Kconfig.debug
> +++ b/arch/x86/Kconfig.debug
> @@ -161,8 +161,7 @@ config IOMMU_DEBUG
>  
>  config IOMMU_LEAK
>  	bool "IOMMU leak tracing"
> -	depends on DEBUG_KERNEL
> -	depends on IOMMU_DEBUG
> +	depends on IOMMU_DEBUG && DMA_API_DEBUG
>  	---help---
>  	  Add a simple leak tracer to the IOMMU code. This is useful when you
>  	  are debugging a buggy device driver that leaks IOMMU mappings.
> diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
> index b284b58..1e8920d 100644
> --- a/arch/x86/kernel/pci-gart_64.c
> +++ b/arch/x86/kernel/pci-gart_64.c
> @@ -144,48 +144,21 @@ static void flush_gart(void)
>  }
>  
>  #ifdef CONFIG_IOMMU_LEAK
> -
> -#define SET_LEAK(x)							\
> -	do {								\
> -		if (iommu_leak_tab)					\
> -			iommu_leak_tab[x] = __builtin_return_address(0);\
> -	} while (0)
> -
> -#define CLEAR_LEAK(x)							\
> -	do {								\
> -		if (iommu_leak_tab)					\
> -			iommu_leak_tab[x] = NULL;			\
> -	} while (0)
> -
>  /* Debugging aid for drivers that don't free their IOMMU tables */
> -static void **iommu_leak_tab;
>  static int leak_trace;
>  static int iommu_leak_pages = 20;
>  
>  static void dump_leak(void)
>  {
> -	int i;
>  	static int dump;
>  
> -	if (dump || !iommu_leak_tab)
> +	if (dump)
>  		return;
>  	dump = 1;
> -	show_stack(NULL, NULL);
>  
> -	/* Very crude. dump some from the end of the table too */
> -	printk(KERN_DEBUG "Dumping %d pages from end of IOMMU:\n",
> -	       iommu_leak_pages);
> -	for (i = 0; i < iommu_leak_pages; i += 2) {
> -		printk(KERN_DEBUG "%lu: ", iommu_pages-i);
> -		printk_address((unsigned long) iommu_leak_tab[iommu_pages-i],
> -				0);
> -		printk(KERN_CONT "%c", (i+1)%2 == 0 ? '\n' : ' ');
> -	}
> -	printk(KERN_DEBUG "\n");
> +	show_stack(NULL, NULL);
> +	debug_dma_dump_mappings(NULL);
>  }
> -#else
> -# define SET_LEAK(x)
> -# define CLEAR_LEAK(x)
>  #endif
>  
>  static void iommu_full(struct device *dev, size_t size, int dir)
> @@ -248,7 +221,6 @@ static dma_addr_t dma_map_area(struct device *dev, dma_addr_t phys_mem,
>  
>  	for (i = 0; i < npages; i++) {
>  		iommu_gatt_base[iommu_page + i] = GPTE_ENCODE(phys_mem);
> -		SET_LEAK(iommu_page + i);
>  		phys_mem += PAGE_SIZE;
>  	}
>  	return iommu_bus_base + iommu_page*PAGE_SIZE + (phys_mem & ~PAGE_MASK);
> @@ -294,7 +266,6 @@ static void gart_unmap_page(struct device *dev, dma_addr_t dma_addr,
>  	npages = iommu_num_pages(dma_addr, size, PAGE_SIZE);
>  	for (i = 0; i < npages; i++) {
>  		iommu_gatt_base[iommu_page + i] = gart_unmapped_entry;
> -		CLEAR_LEAK(iommu_page + i);
>  	}
>  	free_iommu(iommu_page, npages);
>  }
> @@ -377,7 +348,6 @@ static int __dma_map_cont(struct device *dev, struct scatterlist *start,
>  		pages = iommu_num_pages(s->offset, s->length, PAGE_SIZE);
>  		while (pages--) {
>  			iommu_gatt_base[iommu_page] = GPTE_ENCODE(addr);
> -			SET_LEAK(iommu_page);
>  			addr += PAGE_SIZE;
>  			iommu_page++;
>  		}
> @@ -801,11 +771,12 @@ void __init gart_iommu_init(void)
>  
>  #ifdef CONFIG_IOMMU_LEAK
>  	if (leak_trace) {
> -		iommu_leak_tab = (void *)__get_free_pages(GFP_KERNEL|__GFP_ZERO,
> -				  get_order(iommu_pages*sizeof(void *)));
> -		if (!iommu_leak_tab)
> +		int ret;
> +
> +		ret = dma_debug_resize_entries(iommu_pages);
> +		if (ret)
>  			printk(KERN_DEBUG
> -			       "PCI-DMA: Cannot allocate leak trace area\n");
> +			       "PCI-DMA: Cannot trace all the entries\n");
>  	}
>  #endif
>  
> -- 
> 1.6.0.6
> 
> 

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Jochen Polster, Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

