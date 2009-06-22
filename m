Return-Path: <linux-kernel-owner+w=401wt.eu-S1758313AbZFVPrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758313AbZFVPrd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 11:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756434AbZFVPrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 11:47:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:49304 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756839AbZFVPrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 11:47:21 -0400
Message-ID: <4A3FA76C.3070609@kernel.org>
Date: Mon, 22 Jun 2009 08:46:52 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Pekka J Enberg <penberg@cs.helsinki.fi>
CC: mingo@elte.hu, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: move init_gbpages() to setup_arch()
References: <Pine.LNX.4.64.0906221731210.19474@melkki.cs.Helsinki.FI>
In-Reply-To: <Pine.LNX.4.64.0906221731210.19474@melkki.cs.Helsinki.FI>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka J Enberg wrote:
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> The init_gbpages() function is conditionally called from init_memory_mapping()
> function. There are two call-sites where this 'after_bootmem' condition can be
> true: setup_arch() and mem_init() via pci_iommu_alloc().
> 
> Therefore, it's safe to move the call to init_gbpages() to setup_arch() as it's
> always called before mem_init().
> 
> Cc: Yinghai Lu <yinghai@kernel.org>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> ---
>  arch/x86/kernel/setup.c |   16 ++++++++++++++++
>  arch/x86/mm/init.c      |   17 -----------------
>  2 files changed, 16 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index be5ae80..de2cab1 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -289,6 +289,20 @@ void * __init extend_brk(size_t size, size_t align)
>  	return ret;
>  }
>  
> +#ifdef CONFIG_X86_64
> +static void __init init_gbpages(void)
> +{
> +	if (direct_gbpages && cpu_has_gbpages)
> +		printk(KERN_INFO "Using GB pages for direct mapping\n");
> +	else
> +		direct_gbpages = 0;
> +}
> +#else
> +static inline void init_gbpages(void)
> +{
> +}
> +#endif
> +
>  static void __init reserve_brk(void)
>  {
>  	if (_brk_end > _brk_start)
> @@ -871,6 +885,8 @@ void __init setup_arch(char **cmdline_p)
>  
>  	reserve_brk();
>  
> +	init_gbpages();
> +
>  	/* max_pfn_mapped is updated here */
>  	max_low_pfn_mapped = init_memory_mapping(0, max_low_pfn<<PAGE_SHIFT);
>  	max_pfn_mapped = max_low_pfn_mapped;
> diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
> index f53b57e..47ce9a2 100644
> --- a/arch/x86/mm/init.c
> +++ b/arch/x86/mm/init.c
> @@ -177,20 +177,6 @@ static int __meminit save_mr(struct map_range *mr, int nr_range,
>  	return nr_range;
>  }
>  
> -#ifdef CONFIG_X86_64
> -static void __init init_gbpages(void)
> -{
> -	if (direct_gbpages && cpu_has_gbpages)
> -		printk(KERN_INFO "Using GB pages for direct mapping\n");
> -	else
> -		direct_gbpages = 0;
> -}
> -#else
> -static inline void init_gbpages(void)
> -{
> -}
> -#endif
> -
>  /*
>   * Setup the direct mapping of the physical memory at PAGE_OFFSET.
>   * This runs before bootmem is initialized and gets pages directly from
> @@ -210,9 +196,6 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
>  
>  	printk(KERN_INFO "init_memory_mapping: %016lx-%016lx\n", start, end);
>  
> -	if (!after_bootmem)
> -		init_gbpages();
> -
>  #if defined(CONFIG_DEBUG_PAGEALLOC) || defined(CONFIG_KMEMCHECK)
>  	/*
>  	 * For CONFIG_DEBUG_PAGEALLOC, identity mapping will use small pages.


Acked-by: Yinghai Lu <yinghai@kernel.org>

YH
