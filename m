Return-Path: <linux-kernel-owner+w=401wt.eu-S1752829AbZA1CyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829AbZA1CyS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 21:54:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbZA1CyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 21:54:05 -0500
Received: from sh.osrg.net ([192.16.179.4]:60393 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077AbZA1CyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 21:54:04 -0500
Date: Wed, 28 Jan 2009 11:53:45 +0900
To: ink@jurassic.park.msu.ru
Cc: akpm@linux-foundation.org, rth@twiddle.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] alpha: compile fixes
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090127083823.GB15452@jurassic.park.msu.ru>
References: <20090127083823.GB15452@jurassic.park.msu.ru>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090128115403R.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2009 11:38:23 +0300
Ivan Kokshaysky <ink@jurassic.park.msu.ru> wrote:

> - jensen build: fix conflicting declarations for pci_alloc_consistent()
>   and undefined virt_to_phys();
> 
> - SMP: arch/alpha/kernel/smp.c:124: warning: passing argument 2
>        of '__cpu_test_and_set' discards qualifiers from pointer target type
>   Interestingly, this only happens with gcc-4.2; gcc <= 4.1 and gcc-4.3
>   are OK. Fixed with extra assignment.
> 
> Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
> ---
>  arch/alpha/include/asm/dma-mapping.h |    2 ++
>  arch/alpha/kernel/pci-noop.c         |    3 ++-
>  arch/alpha/kernel/smp.c              |    3 ++-
>  3 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/alpha/include/asm/dma-mapping.h b/arch/alpha/include/asm/dma-mapping.h
> index a5801ae..04eb568 100644
> --- a/arch/alpha/include/asm/dma-mapping.h
> +++ b/arch/alpha/include/asm/dma-mapping.h
> @@ -29,6 +29,8 @@
>  
>  #else	/* no PCI - no IOMMU. */
>  
> +#include <asm/io.h>	/* for virt_to_phys() */
> +
>  struct scatterlist;
>  void *dma_alloc_coherent(struct device *dev, size_t size,
>  			 dma_addr_t *dma_handle, gfp_t gfp);
> diff --git a/arch/alpha/kernel/pci-noop.c b/arch/alpha/kernel/pci-noop.c
> index 8ac0831..c19a376 100644
> --- a/arch/alpha/kernel/pci-noop.c
> +++ b/arch/alpha/kernel/pci-noop.c
> @@ -109,7 +109,8 @@ sys_pciconfig_write(unsigned long bus, unsigned long dfn,
>  /* Stubs for the routines in pci_iommu.c: */
>  
>  void *
> -pci_alloc_consistent(struct pci_dev *pdev, size_t size, dma_addr_t *dma_addrp)
> +__pci_alloc_consistent(struct pci_dev *pdev, size_t size,
> +		       dma_addr_t *dma_addrp, gfp_t gfp)
>  {
>  	return NULL;
>  }

A patch to change Alpha to handle two dma mapping implementations
(pci-noop and the IOMMU) in the standard way (like X86, POWER, IA64,
etc do) is acceptable?

pci-noop has something like struct dma_map_ops nommu_dma_ops (similar
to pci-nommu.c in arch/x86/kernel/pci-nommu.c) and pci_iommu.c has
struct dma_map_ops iommu_dma_ops. Then at startup, the kernel properly
sets dma_ops pointer to nommu_dma_ops or iommu_dma_ops.

Then we can handle the dma mapping operations in the consistent way,
e.g., dma_map_sg can be just `return ops->map_sg(dev, sg, nents,
dir)`.
