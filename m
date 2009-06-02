Return-Path: <linux-kernel-owner+w=401wt.eu-S1755094AbZFBEJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094AbZFBEJc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 00:09:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751921AbZFBEJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 00:09:25 -0400
Received: from sh.osrg.net ([192.16.179.4]:41161 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751947AbZFBEJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 00:09:23 -0400
Date: Tue, 2 Jun 2009 13:08:09 +0900
To: ian.campbell@citrix.com
Cc: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
       jeremy@goop.org, okir@suse.de, gregkh@suse.de, x86@kernel.org
Subject: Re: [PATCH 02/11] x86: introduce arch-specific dma-mapping
 interface
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1243870383-12954-3-git-send-email-ian.campbell@citrix.com>
References: <1243870383-12954-1-git-send-email-ian.campbell@citrix.com>
	<1243870383-12954-3-git-send-email-ian.campbell@citrix.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090602130424I.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 02 Jun 2009 13:08:10 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Jun 2009 16:32:54 +0100
Ian Campbell <ian.campbell@citrix.com> wrote:

> dma_map_range is intended to replace usage of both
> swiotlb_arch_range_needs_mapping and
> swiotlb_arch_address_needs_mapping as __weak functions as well as
> replacing is_buffer_dma_capable.
> 
> phys_to_dma and dma_to_phys are intended to replace
> swiotlb_phys_to_bus and swiotlb_bus_to_phys.  I choose to use dma
> rather than bus since a) it matches the parameters and b) avoids
> confusion on x86 with the existing (but deprecated) virt_to_bus
> function which relates to ISA device DMA.
> 
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> Cc: Olaf Kirch <okir@suse.de>
> Cc: Greg KH <gregkh@suse.de>
> Cc: x86@kernel.org
> ---
>  arch/x86/include/asm/dma-mapping.h |    7 +++++++
>  arch/x86/kernel/pci-dma.c          |   26 ++++++++++++++++++++++++++
>  2 files changed, 33 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/include/asm/dma-mapping.h b/arch/x86/include/asm/dma-mapping.h
> index 916cbb6..be8cb22 100644
> --- a/arch/x86/include/asm/dma-mapping.h
> +++ b/arch/x86/include/asm/dma-mapping.h
> @@ -47,6 +47,9 @@ static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
>  #define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
>  #define dma_is_consistent(d, h)	(1)
>  
> +extern dma_addr_t phys_to_dma(struct device *hwdev, phys_addr_t paddr);
> +extern phys_addr_t dma_to_phys(struct device *hwdev, dma_addr_t daddr);
> +
>  extern int dma_supported(struct device *hwdev, u64 mask);
>  extern int dma_set_mask(struct device *dev, u64 mask);
>  
> @@ -309,4 +312,8 @@ static inline void dma_free_coherent(struct device *dev, size_t size,
>  		ops->free_coherent(dev, size, vaddr, bus);
>  }
>  
> +extern bool dma_map_range(struct device *dev, u64 mask,
> +			  phys_addr_t addr, size_t size,
> +			  dma_addr_t *dma_addr_p);
> +
>  #endif
> diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
> index 745579b..f4c1b03 100644
> --- a/arch/x86/kernel/pci-dma.c
> +++ b/arch/x86/kernel/pci-dma.c
> @@ -59,6 +59,32 @@ int dma_set_mask(struct device *dev, u64 mask)
>  }
>  EXPORT_SYMBOL(dma_set_mask);
>  
> +dma_addr_t phys_to_dma(struct device *hwdev, phys_addr_t paddr)
> +{
> +	return paddr;
> +}
> +EXPORT_SYMBOL_GPL(phys_to_dma);
> +
> +phys_addr_t dma_to_phys(struct device *hwdev, dma_addr_t daddr)
> +{
> +	return daddr;
> +}
> +EXPORT_SYMBOL_GPL(dma_to_phys);
> +
> +bool dma_map_range(struct device *dev, u64 mask,
> +		   phys_addr_t addr, size_t size,
> +		   dma_addr_t *dma_addr_p)
> +{
> +	dma_addr_t dma_addr = phys_to_dma(dev, addr);
> +
> +	if (dma_addr + size > mask)
> +		return false;
> +
> +	*dma_addr_p = dma_addr;
> +	return true;
> +}
> +EXPORT_SYMBOL_GPL(dma_map_range);
> +

Why can't the above functions live in arch/include/asm/dma-mapping.h,
where they should live?
