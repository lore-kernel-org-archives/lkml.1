Return-Path: <linux-kernel-owner+w=401wt.eu-S1755284AbZEKNzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284AbZEKNzz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 09:55:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755060AbZEKNzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 09:55:37 -0400
Received: from 8bytes.org ([88.198.83.132]:50354 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755149AbZEKNzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 09:55:36 -0400
Date: Mon, 11 May 2009 15:55:33 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 1/9] xen: make sure swiotlb allocation is physically
	contigious
Message-ID: <20090511135532.GA8671@8bytes.org>
References: <1241741842-7966-1-git-send-email-jeremy@goop.org> <1241741842-7966-2-git-send-email-jeremy@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241741842-7966-2-git-send-email-jeremy@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 07, 2009 at 05:17:14PM -0700, Jeremy Fitzhardinge wrote:
> Impact: make swiotlb allocation suitable for Xen
> 
> When allocating the swiotlb buffer under Xen, make sure the memory is
> physically contiguous so that its really suitable for DMA.
> 
> Do this by allocating the memory as usual, but then call a Xen
> function to rearrange the underlying pages to be physically
> contiguous.
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Reviewed-by: "H. Peter Anvin" <hpa@zytor.com>
> Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  arch/x86/kernel/pci-swiotlb.c |   10 ----------
>  arch/x86/xen/Makefile         |    1 +
>  arch/x86/xen/pci-swiotlb.c    |   27 +++++++++++++++++++++++++++
>  drivers/pci/xen-iommu.c       |   16 ++++++++++++++++
>  include/xen/swiotlb.h         |    6 ++++++
>  5 files changed, 50 insertions(+), 10 deletions(-)
>  create mode 100644 arch/x86/xen/pci-swiotlb.c
>  create mode 100644 include/xen/swiotlb.h
> 
> diff --git a/arch/x86/kernel/pci-swiotlb.c b/arch/x86/kernel/pci-swiotlb.c
> index 34f12e9..bc09da7 100644
> --- a/arch/x86/kernel/pci-swiotlb.c
> +++ b/arch/x86/kernel/pci-swiotlb.c
> @@ -13,16 +13,6 @@
>  
>  int swiotlb __read_mostly;
>  
> -void * __init swiotlb_alloc_boot(size_t size, unsigned long nslabs)
> -{
> -	return alloc_bootmem_low_pages(size);
> -}
> -
> -void *swiotlb_alloc(unsigned order, unsigned long nslabs)
> -{
> -	return (void *)__get_free_pages(GFP_DMA | __GFP_NOWARN, order);
> -}
> -
>  dma_addr_t swiotlb_phys_to_bus(struct device *hwdev, phys_addr_t paddr)
>  {
>  	return paddr;
> diff --git a/arch/x86/xen/Makefile b/arch/x86/xen/Makefile
> index c4cda96..caede49 100644
> --- a/arch/x86/xen/Makefile
> +++ b/arch/x86/xen/Makefile
> @@ -12,3 +12,4 @@ obj-y		:= enlighten.o setup.o multicalls.o mmu.o irq.o \
>  obj-$(CONFIG_SMP)		+= smp.o spinlock.o
>  obj-$(CONFIG_XEN_DEBUG_FS)	+= debugfs.o
>  obj-$(CONFIG_XEN_DOM0)		+= vga.o
> +obj-$(CONFIG_PCI_XEN)		+= pci-swiotlb.o
> \ No newline at end of file
> diff --git a/arch/x86/xen/pci-swiotlb.c b/arch/x86/xen/pci-swiotlb.c
> new file mode 100644
> index 0000000..25f0365
> --- /dev/null
> +++ b/arch/x86/xen/pci-swiotlb.c
> @@ -0,0 +1,27 @@
> +#include <linux/bootmem.h>
> +#include <linux/gfp.h>
> +
> +#include <xen/swiotlb.h>
> +#include <asm/xen/hypervisor.h>
> +
> +/* 
> + * This file defines overrides for weak functions with default
> + * implementations in lib/swiotlb.c.
> + */
> +
> +void * __init swiotlb_alloc_boot(size_t size, unsigned long nslabs)
> +{
> +	void *ret = alloc_bootmem_low_pages(size);
> +
> +	if (ret && xen_pv_domain())
> +		xen_swiotlb_fixup(ret, size, nslabs);
> +
> +	return ret;
> +}
> +
> +void *swiotlb_alloc(unsigned order, unsigned long nslabs)
> +{
> +	/* Never called on x86.  Warn, just in case. */

Can't this function be removed completly then?

> +	WARN_ON(1);
> +	return NULL;
> +}
> diff --git a/drivers/pci/xen-iommu.c b/drivers/pci/xen-iommu.c
> index 32a8b49..c593058 100644
> --- a/drivers/pci/xen-iommu.c
> +++ b/drivers/pci/xen-iommu.c
> @@ -12,6 +12,7 @@
>  #include <xen/grant_table.h>
>  #include <xen/page.h>
>  #include <xen/xen-ops.h>
> +#include <xen/swiotlb.h>
>  
>  #include <asm/iommu.h>
>  #include <asm/swiotlb.h>
> @@ -34,6 +35,21 @@ do {							\
>  	(unsigned long long)addr + size);		\
>  } while (0)
>  
> +
> +void xen_swiotlb_fixup(void *buf, size_t size, unsigned long nslabs)
> +{
> +	unsigned order = get_order(size);
> +
> +	printk(KERN_DEBUG "xen_swiotlb_fixup: buf=%p size=%zu order=%u\n",
> +		buf, size, order);
> +
> +	if (WARN_ON(size != (PAGE_SIZE << order)))
> +		return;
> +
> +	if (xen_create_contiguous_region((unsigned long)buf,
> +					 order, 0xffffffff))
                                                DMA_32BIT_MASK?

> +		printk(KERN_ERR "xen_create_contiguous_region failed\n");
> +}
>  static inline int address_needs_mapping(struct device *hwdev,
>  						dma_addr_t addr)
>  {
> diff --git a/include/xen/swiotlb.h b/include/xen/swiotlb.h
> new file mode 100644
> index 0000000..67b7b42
> --- /dev/null
> +++ b/include/xen/swiotlb.h
> @@ -0,0 +1,6 @@
> +#ifndef _XEN_SWIOTLB_H
> +#define _XEN_SWIOTLB_H
> +
> +extern void xen_swiotlb_fixup(void *buf, size_t size, unsigned long nslabs);
> +
> +#endif /* _XEN_SWIOTLB_H */
> -- 
> 1.6.0.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
