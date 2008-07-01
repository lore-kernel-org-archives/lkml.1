Return-Path: <linux-kernel-owner+w=401wt.eu-S1761268AbYGAVwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761268AbYGAVwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 17:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756412AbYGAVwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 17:52:10 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:56438 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751988AbYGAVwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 17:52:08 -0400
Subject: Re: [PATCH -mm] fix per-device dma_mapping_ops support
From: Alexis Bruemmer <alexisb@us.ibm.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, muli@il.ibm.com,
       mingo@elte.hu
In-Reply-To: <20080612172554X.fujita.tomonori@lab.ntt.co.jp>
References: <20080612172554X.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain
Date: Tue, 01 Jul 2008 14:52:04 -0700
Message-Id: <1214949124.6553.9.camel@alexis>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Where are we with with this patch-- as well as the needed calgary
update:

http://marc.info/?l=linux-kernel&m=121329005131176&w=2

Are they at a state where they can be picked-up?  If not what is needed
to progress?

Thanks!

Alexis


On Thu, 2008-06-12 at 17:21 +0900, FUJITA Tomonori wrote:
> Andrew, can you put this patch to -mm?
> 
> This patch fixes a bug in per-device dma_mapping_ops support. The
> patch to fix Calgary IOMMU with per-device dma_mapping_ops support is
> ready so we need this fix in -mm.
> 
> http://lkml.org/lkml/2008/6/11/447
> 
> This is a resend of:
> 
> http://lkml.org/lkml/2008/6/3/430
> 
> =
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Date: Thu, 12 Jun 2008 17:14:02 +0900
> Subject: [PATCH] fix per-device dma_mapping_ops support
> 
> On x86, pci_dma_supported, pci_alloc_consistent, and
> pci_free_consistent don't call DMA APIs directly (the majority of
> platforms do). per-device dma_mapping_ops support patch needs to
> modify pci-dma.c.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  arch/x86/kernel/pci-dma.c |   25 +++++++++++++++----------
>  1 files changed, 15 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
> index fa500c4..a2b98a5 100644
> --- a/arch/x86/kernel/pci-dma.c
> +++ b/arch/x86/kernel/pci-dma.c
> @@ -318,6 +318,8 @@ static int dma_release_coherent(struct device *dev, int order, void *vaddr)
> 
>  int dma_supported(struct device *dev, u64 mask)
>  {
> +	struct dma_mapping_ops *ops = get_dma_ops(dev);
> +
>  #ifdef CONFIG_PCI
>  	if (mask > 0xffffffff && forbid_dac > 0) {
>  		dev_info(dev, "PCI: Disallowing DAC for device\n");
> @@ -325,8 +327,8 @@ int dma_supported(struct device *dev, u64 mask)
>  	}
>  #endif
> 
> -	if (dma_ops->dma_supported)
> -		return dma_ops->dma_supported(dev, mask);
> +	if (ops->dma_supported)
> +		return ops->dma_supported(dev, mask);
> 
>  	/* Copied from i386. Doesn't make much sense, because it will
>  	   only work for pci_alloc_coherent.
> @@ -373,6 +375,7 @@ void *
>  dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
>  		   gfp_t gfp)
>  {
> +	struct dma_mapping_ops *ops = get_dma_ops(dev);
>  	void *memory = NULL;
>  	struct page *page;
>  	unsigned long dma_mask = 0;
> @@ -435,8 +438,8 @@ dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
>  			/* Let low level make its own zone decisions */
>  			gfp &= ~(GFP_DMA32|GFP_DMA);
> 
> -			if (dma_ops->alloc_coherent)
> -				return dma_ops->alloc_coherent(dev, size,
> +			if (ops->alloc_coherent)
> +				return ops->alloc_coherent(dev, size,
>  							   dma_handle, gfp);
>  			return NULL;
>  		}
> @@ -448,14 +451,14 @@ dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
>  		}
>  	}
> 
> -	if (dma_ops->alloc_coherent) {
> +	if (ops->alloc_coherent) {
>  		free_pages((unsigned long)memory, get_order(size));
>  		gfp &= ~(GFP_DMA|GFP_DMA32);
> -		return dma_ops->alloc_coherent(dev, size, dma_handle, gfp);
> +		return ops->alloc_coherent(dev, size, dma_handle, gfp);
>  	}
> 
> -	if (dma_ops->map_simple) {
> -		*dma_handle = dma_ops->map_simple(dev, virt_to_phys(memory),
> +	if (ops->map_simple) {
> +		*dma_handle = ops->map_simple(dev, virt_to_phys(memory),
>  					      size,
>  					      PCI_DMA_BIDIRECTIONAL);
>  		if (*dma_handle != bad_dma_address)
> @@ -477,12 +480,14 @@ EXPORT_SYMBOL(dma_alloc_coherent);
>  void dma_free_coherent(struct device *dev, size_t size,
>  			 void *vaddr, dma_addr_t bus)
>  {
> +	struct dma_mapping_ops *ops = get_dma_ops(dev);
> +
>  	int order = get_order(size);
>  	WARN_ON(irqs_disabled());	/* for portability */
>  	if (dma_release_coherent(dev, order, vaddr))
>  		return;
> -	if (dma_ops->unmap_single)
> -		dma_ops->unmap_single(dev, bus, size, 0);
> +	if (ops->unmap_single)
> +		ops->unmap_single(dev, bus, size, 0);
>  	free_pages((unsigned long)vaddr, order);
>  }
>  EXPORT_SYMBOL(dma_free_coherent);

