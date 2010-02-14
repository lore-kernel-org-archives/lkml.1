Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554Ab0BNXgu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 18:36:50 -0500
Received: from gate.crashing.org ([63.228.1.57]:34423 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753457Ab0BNXgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 18:36:49 -0500
Subject: Re: [PATCH -mm 5/7] powerpc: use generic pci_set_dma_mask and
 pci_set_consistent_dma_mask
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <1265967212-9126-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1265967212-9126-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	 <1265967212-9126-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Feb 2010 10:36:40 +1100
Message-ID: <1266190600.16346.74.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-02-12 at 18:33 +0900, FUJITA Tomonori wrote:
> This converts powerpc to use the generic pci_set_dma_mask and
> pci_set_consistent_dma_mask (drivers/pci/pci.c).
> 
> The generic pci_set_dma_mask does what powerpc's pci_set_dma_mask
> does.
> 
> Unlike powerpc's pci_set_consistent_dma_mask, the gneric
> pci_set_consistent_dma_mask sets only coherent_dma_mask. It doesn't
> work for powerpc? pci_set_consistent_dma_mask API should set only
> coherent_dma_mask?

I don't know why we do it that way, your patch looks correct to me, if
we have a driver bug assuming it does both masks at once, then we'll
fix it.

Do you need me to merge that via powerpc.git or are you happy to carry
it with the rest of your PCI DMA changes ?

> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> ---
>  arch/powerpc/include/asm/dma-mapping.h |    3 ---
>  arch/powerpc/kernel/pci-common.c       |   15 ---------------
>  2 files changed, 0 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/dma-mapping.h b/arch/powerpc/include/asm/dma-mapping.h
> index 80a973b..c85ef23 100644
> --- a/arch/powerpc/include/asm/dma-mapping.h
> +++ b/arch/powerpc/include/asm/dma-mapping.h
> @@ -127,9 +127,6 @@ static inline int dma_supported(struct device *dev, u64 mask)
>  	return dma_ops->dma_supported(dev, mask);
>  }
>  
> -/* We have our own implementation of pci_set_dma_mask() */
> -#define HAVE_ARCH_PCI_SET_DMA_MASK
> -
>  static inline int dma_set_mask(struct device *dev, u64 dma_mask)
>  {
>  	struct dma_map_ops *dma_ops = get_dma_ops(dev);
> diff --git a/arch/powerpc/kernel/pci-common.c b/arch/powerpc/kernel/pci-common.c
> index cadbed6..a8bc6f2 100644
> --- a/arch/powerpc/kernel/pci-common.c
> +++ b/arch/powerpc/kernel/pci-common.c
> @@ -63,21 +63,6 @@ struct dma_map_ops *get_pci_dma_ops(void)
>  }
>  EXPORT_SYMBOL(get_pci_dma_ops);
>  
> -int pci_set_dma_mask(struct pci_dev *dev, u64 mask)
> -{
> -	return dma_set_mask(&dev->dev, mask);
> -}
> -
> -int pci_set_consistent_dma_mask(struct pci_dev *dev, u64 mask)
> -{
> -	int rc;
> -
> -	rc = dma_set_mask(&dev->dev, mask);
> -	dev->dev.coherent_dma_mask = dev->dma_mask;
> -
> -	return rc;
> -}
> -
>  struct pci_controller *pcibios_alloc_controller(struct device_node *dev)
>  {
>  	struct pci_controller *phb;


