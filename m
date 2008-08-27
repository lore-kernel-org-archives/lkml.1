Return-Path: <linux-kernel-owner+w=401wt.eu-S1754249AbYH0HmH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249AbYH0HmH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 03:42:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752214AbYH0Hlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 03:41:55 -0400
Received: from gate.crashing.org ([63.228.1.57]:50962 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018AbYH0Hlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 03:41:55 -0400
Subject: Re: RFC [PATCH] x86/pci: reserve extra page to avoid error caused
	by P2P pref DMA reads
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@suse.cz>, Jesse Barnes <jbarnes@virtuousgeek.org>
In-Reply-To: <1219822159-17245-1-git-send-email-yhlu.kernel@gmail.com>
References: <1219822159-17245-1-git-send-email-yhlu.kernel@gmail.com>
Content-Type: text/plain
Date: Wed, 27 Aug 2008 17:40:40 +1000
Message-Id: <1219822840.13162.184.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-08-27 at 00:29 -0700, Yinghai Lu wrote:
> Diag guys, found one system when loading is high, will have gart wark error.
> root cause is P2P bridge try to prefetch for several intel e1000 under
> it. and that skb is near GART iommu area.
> 
> try to reserve page in the boundary at first.
> last page near TOM2, and last page near MMIO
> also gart first and last page.
> 
> need one better way for all arch support PCI and memory with a lot of holes etc.

Sounds like a similar problem for which we don't unmap GART pages,
just map them read-only and route them to a dummy page. In that
case, the right approach is to write the last page of the GART
to the dummy page as well and mark it occupied. That shouldn't
involve actually reserving memory.

I'm not familiar with the x86 PCI DMA code but afaik, it's fairly
similar to ours (powerpc) in that area.

Ben.
 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> Cc: Pavel Machek <pavel@suse.cz>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Jesse Barnes<jbarnes@virtuousgeek.org>
> 
> ---
>  arch/x86/kernel/pci-dma.c     |   28 ++++++++++++++++++++++++++++
>  arch/x86/kernel/pci-gart_64.c |    6 ++++++
>  2 files changed, 34 insertions(+)
> 
> Index: linux-2.6/arch/x86/kernel/pci-dma.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/pci-dma.c
> +++ linux-2.6/arch/x86/kernel/pci-dma.c
> @@ -72,12 +72,40 @@ static int __init parse_dma32_size_opt(c
>  }
>  early_param("dma32_size", parse_dma32_size_opt);
>  
> +static void __init reserve_last_page(unsigned long pfn)
> +{
> +	unsigned long phys;
> +	void *ptr;
> +
> +	phys = (pfn - 1)<<PAGE_SHIFT;
> +	ptr = __alloc_bootmem_nopanic(PAGE_SIZE, PAGE_SIZE, phys);
> +
> +	if (!ptr || virt_to_phys(ptr) != phys)
> +		printk(KERN_WARNING "Can not hold last page near %lx for workaround P2P pref DMA reads!\n", phys);
> +	else
> +		printk(KERN_WARNING "Last page is reserved near %lx for workaround P2P pref DMA reads!\n", phys);
> +}
>  void __init dma32_reserve_bootmem(void)
>  {
>  	unsigned long size, align;
> +
> +	/*
> +	 * try to reserve last page to workaround P2P bridge pref DMA reads
> +	 * normally don't need to reserve the page near mmio,
> +	 * because always has acpi etc sit there.
> +	 * but some system has that acpi in the middle of ram below 4g
> +	 * so just reserve it.
> +	 */
> +	if (max_low_pfn_mapped < max_pfn_mapped)
> +		reserve_last_page(max_low_pfn_mapped);
> +
> +	/* less than 4G, don't need iommu */
>  	if (max_pfn <= MAX_DMA32_PFN)
>  		return;
>  
> +	/* try to reserve last page to workaround P2P bridge pref DMA reads */
> +	reserve_last_page(max_pfn);
> +
>  	/*
>  	 * check aperture_64.c allocate_aperture() for reason about
>  	 * using 512M as goal
> Index: linux-2.6/arch/x86/kernel/pci-gart_64.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/pci-gart_64.c
> +++ linux-2.6/arch/x86/kernel/pci-gart_64.c
> @@ -826,6 +826,9 @@ void __init gart_iommu_init(void)
>  	 */
>  	set_bit_string(iommu_gart_bitmap, 0, EMERGENCY_PAGES);
>  
> +	/* reserve one page at tail, for P2P bridge pref DMA reads */
> +	set_bit_string(iommu_gart_bitmap, iommu_pages - 1, 1);
> +
>  	agp_memory_reserved = iommu_size;
>  	printk(KERN_INFO
>  	       "PCI-DMA: Reserving %luMB of IOMMU area in the AGP aperture\n",
> @@ -870,6 +873,9 @@ void __init gart_iommu_init(void)
>  	for (i = EMERGENCY_PAGES; i < iommu_pages; i++)
>  		iommu_gatt_base[i] = gart_unmapped_entry;
>  
> +	/* we need set unmapped on head too, for P2P bridge pref DMA reads */
> +	iommu_gatt_base[0] = gart_unmapped_entry;
> +
>  	flush_gart();
>  	dma_ops = &gart_dma_ops;
>  }

