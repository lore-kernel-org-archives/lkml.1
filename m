Return-Path: <linux-kernel-owner+w=401wt.eu-S1756794AbYIITbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794AbYIITbz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 15:31:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753782AbYIITbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 15:31:46 -0400
Received: from gateway-1237.mvista.com ([63.81.120.155]:59486 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752677AbYIITbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 15:31:45 -0400
Message-ID: <48C6CF48.5060309@ru.mvista.com>
Date: Tue, 09 Sep 2008 23:32:24 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jeremy Higdon <jeremy@sgi.com>
Subject: Re: [PATCH 5/7] sgiioc4: use ->init_dma method
References: <200803091631.48968.bzolnier@gmail.com>
In-Reply-To: <200803091631.48968.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> * Move dma_base check from sgiioc4_ide_setup_pci_device()
>   to ide_dma_sgiioc4().

    This check should've been thrown out -- it's never true.

> * Replace ide_dma_sgiioc4() 'unsigned long dma_base' argument
>   by 'const struct ide_port_info *d'.

> * Move hwif->INB setup from ide_init_sgiioc4() to
>   sgiioc4_ide_setup_pci_device().

> * Move ide_init_sgiioc4() call from sgiioc4_ide_setup_pci_device()
>   to ide_dma_sgiioc4().

> * Convert the driver to use ->init_dma method.

> Cc: Jeremy Higdon <jeremy@sgi.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

> Index: b/drivers/ide/pci/sgiioc4.c
> ===================================================================
> --- a/drivers/ide/pci/sgiioc4.c
> +++ b/drivers/ide/pci/sgiioc4.c
> @@ -327,15 +327,21 @@ sgiioc4_INB(unsigned long port)
>  	return reg;
>  }
>  
> +static void __devinit ide_init_sgiioc4(ide_hwif_t *);
> +
>  /* Creates a dma map for the scatter-gather list entries */
>  static int __devinit
> -ide_dma_sgiioc4(ide_hwif_t * hwif, unsigned long dma_base)
> +ide_dma_sgiioc4(ide_hwif_t *hwif, const struct ide_port_info *d)
>  {
>  	struct pci_dev *dev = to_pci_dev(hwif->dev);
> +	unsigned long dma_base = pci_resource_start(dev, 0) + IOC4_DMA_OFFSET;
>  	void __iomem *virt_dma_base;
>  	int num_ports = sizeof (ioc4_dma_regs_t);
>  	void *pad;
>  
> +	if (dma_base == 0)
> +		return -1;
> +

    It should be quite obvious that 'dma_base' will never be 0 since 
IOC4_DMA_OFFSET == 0x140.

>  	printk(KERN_INFO "%s: BM-DMA at 0x%04lx-0x%04lx\n", hwif->name,
>  	       dma_base, dma_base + num_ports - 1);

    It should print "MMIO-DMA" since the registers are memory-mapped.

    Making another notch...

MBR, Sergei
