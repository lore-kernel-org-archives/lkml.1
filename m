Return-Path: <linux-kernel-owner+w=401wt.eu-S933966AbXHXGJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933966AbXHXGJ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 02:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755500AbXHXGJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 02:09:44 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:64363 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932999AbXHXGJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 02:09:43 -0400
Date: Thu, 23 Aug 2007 23:08:11 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Shannon Nelson <shannon.nelson@intel.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       davem@davemloft.net
Subject: Re: [PATCH v2 -mm 4/7] I/OAT: Split PCI startup from DMA handling
 code
Message-Id: <20070823230811.f9a0c5e8.randy.dunlap@oracle.com>
In-Reply-To: <20070824001512.16997.29302.stgit@localhost.localdomain>
References: <20070824001335.16997.79665.stgit@localhost.localdomain>
	<20070824001512.16997.29302.stgit@localhost.localdomain>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Aug 2007 17:15:12 -0700 Shannon Nelson wrote:

> Split the general PCI startup from the DMA handling code in order to
> prepare for adding support for DCA services and future versions of the
> ioatdma device.
> 
> Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
> Acked-by: David S. Miller <davem@davemloft.net>
> ---
> 
>  drivers/dma/Makefile     |    2 
>  drivers/dma/ioat.c       |  186 ++++++++++++++++++++++++++++++++++++++++++++
>  drivers/dma/ioat_dma.c   |  196 +++++++++++-----------------------------------
>  drivers/dma/ioatdma.h    |   16 +++-
>  drivers/dma/ioatdma_hw.h |    2 
>  5 files changed, 245 insertions(+), 157 deletions(-)

> diff --git a/drivers/dma/ioat_dma.c b/drivers/dma/ioat_dma.c
> index 9a4d154..9012176 100644
> --- a/drivers/dma/ioat_dma.c
> +++ b/drivers/dma/ioat_dma.c

> -	printk(KERN_INFO " "
> -		"ioatdma: Intel(R) I/OAT DMA Engine initialization failed\n");
> -
> -	return err;
> +	iounmap(iobase);
> +	printk(KERN_ERR " "
> +	       "ioatdma: Intel(R) I/OAT DMA Engine initialization failed\n");

Drop the " " after KERN_ERR...

> +	return NULL;
>  }

> diff --git a/drivers/dma/ioatdma.h b/drivers/dma/ioatdma.h
> index bf4dad7..26aff08 100644
> --- a/drivers/dma/ioatdma.h
> +++ b/drivers/dma/ioatdma.h
> @@ -31,7 +31,7 @@
>  #define IOAT_LOW_COMPLETION_MASK	0xffffffc0
>  
>  /**
> - * struct ioat_device - internal representation of a IOAT device
> + * struct ioatdma_device - internal representation of a IOAT device
>   * @pdev: PCI-Express device
>   * @reg_base: MMIO register space base address
>   * @dma_pool: for allocating DMA descriptors
> @@ -39,14 +39,14 @@
>   * @msi: Message Signaled Interrupt number
>   */
>  
> -struct ioat_device {
> +struct ioatdma_device {
>  	struct pci_dev *pdev;
>  	void __iomem *reg_base;
>  	struct pci_pool *dma_pool;
>  	struct pci_pool *completion_pool;
>  
>  	struct dma_device common;
> -	u8 msi;
> +	u8 version;

This field name change needs a corresponding change in the
struct's kernel-doc above here.

>  };
>  
>  /**

> @@ -117,4 +117,12 @@ struct ioat_desc_sw {
>  	struct dma_async_tx_descriptor async_tx;
>  };
>  
> +#if defined(CONFIG_INTEL_IOATDMA) || defined(CONFIG_INTEL_IOATDMA_MODULE)
> +struct ioatdma_device *ioat_dma_probe(struct pci_dev *, void __iomem *);

Please use parameter variable names in function prototypes (above;
most places already have them).

> +void ioat_dma_remove(struct ioatdma_device *device);
> +#else
> +#define ioat_dma_probe(pdev, io)                NULL
> +#define ioat_dma_remove(dev)            do { } while (0)
> +#endif
> +
>  #endif /* IOATDMA_H */


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
