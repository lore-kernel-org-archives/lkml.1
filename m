Return-Path: <linux-kernel-owner+w=401wt.eu-S1754255AbZEKOLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255AbZEKOLU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 10:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752605AbZEKOLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 10:11:05 -0400
Received: from 8bytes.org ([88.198.83.132]:51292 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751914AbZEKOLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 10:11:04 -0400
Date: Mon, 11 May 2009 16:11:01 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Ian Campbell <ian.campbell@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 3/9] xen: add hooks for mapping phys<->bus addresses in
	swiotlb
Message-ID: <20090511141059.GB8671@8bytes.org>
References: <1241741842-7966-1-git-send-email-jeremy@goop.org> <1241741842-7966-4-git-send-email-jeremy@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241741842-7966-4-git-send-email-jeremy@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 07, 2009 at 05:17:16PM -0700, Jeremy Fitzhardinge wrote:
> From: Ian Campbell <ian.campbell@citrix.com>
> 
> Impact: Xen support for DMA
> 
> Add hooks to allow Xen to do translation between pfn and mfns for the swiotlb
> layer, so that dma actually ends up going to the proper machine pages.
> 
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Reviewed-by: "H. Peter Anvin" <hpa@zytor.com>
> Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Acked-by: Joerg Roedel <joerg.roedel@amd.com>

> ---
>  arch/x86/kernel/pci-swiotlb.c |   10 ----------
>  arch/x86/xen/pci-swiotlb.c    |   18 ++++++++++++++++++
>  drivers/pci/xen-iommu.c       |   11 +++++++++++
>  include/xen/swiotlb.h         |    2 ++
>  4 files changed, 31 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kernel/pci-swiotlb.c b/arch/x86/kernel/pci-swiotlb.c
> index bc09da7..3216674 100644
> --- a/arch/x86/kernel/pci-swiotlb.c
> +++ b/arch/x86/kernel/pci-swiotlb.c
> @@ -13,16 +13,6 @@
>  
>  int swiotlb __read_mostly;
>  
> -dma_addr_t swiotlb_phys_to_bus(struct device *hwdev, phys_addr_t paddr)
> -{
> -	return paddr;
> -}
> -
> -phys_addr_t swiotlb_bus_to_phys(dma_addr_t baddr)
> -{
> -	return baddr;
> -}
> -
>  int __weak swiotlb_arch_range_needs_mapping(phys_addr_t paddr, size_t size)
>  {
>  	return 0;
> diff --git a/arch/x86/xen/pci-swiotlb.c b/arch/x86/xen/pci-swiotlb.c
> index 25f0365..1d43fde 100644
> --- a/arch/x86/xen/pci-swiotlb.c
> +++ b/arch/x86/xen/pci-swiotlb.c
> @@ -1,5 +1,7 @@
>  #include <linux/bootmem.h>
>  #include <linux/gfp.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/swiotlb.h>
>  
>  #include <xen/swiotlb.h>
>  #include <asm/xen/hypervisor.h>
> @@ -25,3 +27,19 @@ void *swiotlb_alloc(unsigned order, unsigned long nslabs)
>  	WARN_ON(1);
>  	return NULL;
>  }
> +
> +dma_addr_t swiotlb_phys_to_bus(struct device *hwdev, phys_addr_t paddr)
> +{
> +	if (xen_pv_domain())
> +		return xen_phys_to_bus(paddr);
> +
> +	return paddr;
> +}
> +
> +phys_addr_t swiotlb_bus_to_phys(dma_addr_t baddr)
> +{
> +	if (xen_pv_domain())
> +		return xen_bus_to_phys(baddr);
> +
> +	return baddr;
> +}
> diff --git a/drivers/pci/xen-iommu.c b/drivers/pci/xen-iommu.c
> index b9b4620..e3d6ddb 100644
> --- a/drivers/pci/xen-iommu.c
> +++ b/drivers/pci/xen-iommu.c
> @@ -59,6 +59,17 @@ void xen_swiotlb_fixup(void *buf, size_t size, unsigned long nslabs)
>  			panic(KERN_ERR "xen_create_contiguous_region failed\n");
>  	}
>  }
> +
> +dma_addr_t xen_phys_to_bus(phys_addr_t paddr)
> +{
> +	return phys_to_machine(XPADDR(paddr)).maddr;
> +}
> +
> +phys_addr_t xen_bus_to_phys(dma_addr_t daddr)
> +{
> +	return machine_to_phys(XMADDR(daddr)).paddr;
> +}
> +
>  static inline int address_needs_mapping(struct device *hwdev,
>  						dma_addr_t addr)
>  {
> diff --git a/include/xen/swiotlb.h b/include/xen/swiotlb.h
> index 67b7b42..4229f27 100644
> --- a/include/xen/swiotlb.h
> +++ b/include/xen/swiotlb.h
> @@ -2,5 +2,7 @@
>  #define _XEN_SWIOTLB_H
>  
>  extern void xen_swiotlb_fixup(void *buf, size_t size, unsigned long nslabs);
> +extern phys_addr_t xen_bus_to_phys(dma_addr_t daddr);
> +extern dma_addr_t xen_phys_to_bus(phys_addr_t paddr);
>  
>  #endif /* _XEN_SWIOTLB_H */
> -- 
> 1.6.0.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
