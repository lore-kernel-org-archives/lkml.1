Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757486Ab0BLTw2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 14:52:28 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46826 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757093Ab0BLTw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 14:52:27 -0500
Date: Fri, 12 Feb 2010 11:51:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, James.Bottomley@suse.de, davem@davemloft.net,
       jbarnes@virtuousgeek.org, arnd@arndb.de
Subject: Re: [PATCH -mm] dma-mapping.h: add the dma_unmap state API
Message-Id: <20100212115157.02124608.akpm@linux-foundation.org>
In-Reply-To: <20100212145601W.fujita.tomonori@lab.ntt.co.jp>
References: <20100212145601W.fujita.tomonori@lab.ntt.co.jp>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Feb 2010 15:04:52 +0900
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> Adds the following macros:
> 
> DECLARE_DMA_UNMAP_ADDR(ADDR_NAME)
> DECLARE_DMA_UNMAP_LEN(LEN_NAME)
> dma_unmap_addr(PTR, ADDR_NAME)
> dma_unmap_addr_set(PTR, ADDR_NAME, VAL)
> dma_unmap_len(PTR, LEN_NAME)
> dma_unmap_len_set(PTR, LEN_NAME, VAL)
> 
> The API corresponds to the pci_unmap state API. We'll move to this new
> generic API from the PCI specific API in the long term. As
> include/asm-generic/pci-dma-compat.h does, the pci_unmap API simply
> calls the new generic API for some time.
> 

grumble.

>  
> +#ifdef CONFIG_NEED_DMA_MAP_STATE
> +#define DECLARE_DMA_UNMAP_ADDR(ADDR_NAME)        dma_addr_t ADDR_NAME;
> +#define DECLARE_DMA_UNMAP_LEN(LEN_NAME)          __u32 LEN_NAME;

Adding the semicolons is dopey.

(And these are "definitions", not "declarations" but I'm close to
giving up on that fight).

> +#define dma_unmap_addr(PTR, ADDR_NAME)           ((PTR)->ADDR_NAME)
> +#define dma_unmap_addr_set(PTR, ADDR_NAME, VAL)  (((PTR)->ADDR_NAME) = (VAL))
> +#define dma_unmap_len(PTR, LEN_NAME)             ((PTR)->LEN_NAME)
> +#define dma_unmap_len_set(PTR, LEN_NAME, VAL)    (((PTR)->LEN_NAME) = (VAL))
> +#else
> +#define DECLARE_DMA_MAP_ADDR(ADDR_NAME)
> +#define DECLARE_DMA_UNMAP_LEN(LEN_NAME)
> +#define dma_unmap_addr(PTR, ADDR_NAME)           (0)
> +#define dma_unmap_addr_set(PTR, ADDR_NAME, VAL)  do { } while (0)
> +#define dma_unmap_len(PTR, LEN_NAME)             (0)
> +#define dma_unmap_len_set(PTR, LEN_NAME, VAL)    do { } while (0)
> +#endif
> +
>  #endif
> diff --git a/include/linux/pci-dma.h b/include/linux/pci-dma.h
> index cfd63ab..235a61e 100644
> --- a/include/linux/pci-dma.h
> +++ b/include/linux/pci-dma.h
> @@ -1,20 +1,11 @@
>  #ifndef _LINUX_PCI_DMA_H
>  #define _LINUX_PCI_DMA_H
>  
> -#ifdef CONFIG_NEED_DMA_MAP_STATE
> -#define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)        dma_addr_t ADDR_NAME;
> -#define DECLARE_PCI_UNMAP_LEN(LEN_NAME)          __u32 LEN_NAME;

But we already screwed up the semicolon thing.  If you grep the tree you'll
see that about half of the users of this macro added their own semicolon:

./drivers/net/cxgb3/sge.c:              DECLARE_PCI_UNMAP_ADDR(addr);
./drivers/net/skge.h:   DECLARE_PCI_UNMAP_ADDR(mapaddr);
./drivers/net/qla3xxx.h:         DECLARE_PCI_UNMAP_ADDR(mapaddr);
./drivers/net/qla3xxx.h:         DECLARE_PCI_UNMAP_ADDR(mapaddr);
./drivers/net/tg3.h:    DECLARE_PCI_UNMAP_ADDR(mapping)


Perhaps someone will clean all that up sometime.
