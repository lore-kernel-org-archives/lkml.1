Return-Path: <linux-kernel-owner+w=401wt.eu-S932803AbXGLLeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932803AbXGLLeS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 07:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762241AbXGLLeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 07:34:10 -0400
Received: from brick.kernel.dk ([80.160.20.94]:18483 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757674AbXGLLeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 07:34:06 -0400
Date: Thu, 12 Jul 2007 13:34:02 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, neilb@suse.de
Subject: Re: [PATCH] BLOCK:  Remove references to dead CONFIG_MM_MAP_MEMORY
	variable.
Message-ID: <20070712113402.GS4587@kernel.dk>
References: <Pine.LNX.4.64.0707120401140.24359@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707120401140.24359@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12 2007, Robert P. J. Day wrote:
> 
> Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

Looks fine to me, I remember this being brought up a long time ago, but
apparently it never got merged. Neil?

> 
> ---
> 
> diff --git a/drivers/block/umem.c b/drivers/block/umem.c
> index 6f5d620..62c9d08 100644
> --- a/drivers/block/umem.c
> +++ b/drivers/block/umem.c
> @@ -105,12 +105,6 @@ struct cardinfo {
>  	unsigned long	csr_base;
>  	unsigned char	__iomem *csr_remap;
>  	unsigned long	csr_len;
> -#ifdef CONFIG_MM_MAP_MEMORY
> -	unsigned long	mem_base;
> -	unsigned char	__iomem *mem_remap;
> -	unsigned long	mem_len;
> -#endif
> -
>  	unsigned int	win_size; /* PCI window size */
>  	unsigned int	mm_size;  /* size in kbytes */
> 
> @@ -872,10 +866,6 @@ static int __devinit mm_pci_probe(struct pci_dev *dev, const struct pci_device_i
> 
>  	card->csr_base = pci_resource_start(dev, 0);
>  	card->csr_len  = pci_resource_len(dev, 0);
> -#ifdef CONFIG_MM_MAP_MEMORY
> -	card->mem_base = pci_resource_start(dev, 1);
> -	card->mem_len  = pci_resource_len(dev, 1);
> -#endif
> 
>  	printk(KERN_INFO "Micro Memory(tm) controller #%d found at %02x:%02x (PCI Mem Module (Battery Backup))\n",
>  	       card->card_number, dev->bus->number, dev->devfn);
> @@ -903,27 +893,6 @@ static int __devinit mm_pci_probe(struct pci_dev *dev, const struct pci_device_i
>  	printk(KERN_INFO "MM%d: CSR 0x%08lx -> 0x%p (0x%lx)\n", card->card_number,
>  	       card->csr_base, card->csr_remap, card->csr_len);
> 
> -#ifdef CONFIG_MM_MAP_MEMORY
> -	if (!request_mem_region(card->mem_base, card->mem_len, "Micro Memory")) {
> -		printk(KERN_ERR "MM%d: Unable to request memory region\n", card->card_number);
> -		ret = -ENOMEM;
> -
> -		goto failed_req_mem;
> -	}
> -
> -	if (!(card->mem_remap = ioremap(card->mem_base, cards->mem_len))) {
> -		printk(KERN_ERR "MM%d: Unable to remap memory region\n", card->card_number);
> -		ret = -ENOMEM;
> -
> -		goto failed_remap_mem;
> -	}
> -
> -	printk(KERN_INFO "MM%d: MEM 0x%8lx -> 0x%8lx (0x%lx)\n", card->card_number,
> -	       card->mem_base, card->mem_remap, card->mem_len);
> -#else
> -	printk(KERN_INFO "MM%d: MEM area not remapped (CONFIG_MM_MAP_MEMORY not set)\n",
> -	       card->card_number);
> -#endif
>  	switch(card->dev->device) {
>  	case 0x5415:
>  		card->flags |= UM_FLAG_NO_BYTE_STATUS | UM_FLAG_NO_BATTREG;
> @@ -1091,12 +1060,6 @@ static int __devinit mm_pci_probe(struct pci_dev *dev, const struct pci_device_i
>  				    card->mm_pages[1].desc,
>  				    card->mm_pages[1].page_dma);
>   failed_magic:
> -#ifdef CONFIG_MM_MAP_MEMORY
> -	iounmap(card->mem_remap);
> - failed_remap_mem:
> -	release_mem_region(card->mem_base, card->mem_len);
> - failed_req_mem:
> -#endif
>  	iounmap(card->csr_remap);
>   failed_remap_csr:
>  	release_mem_region(card->csr_base, card->csr_len);
> @@ -1116,10 +1079,6 @@ static void mm_pci_remove(struct pci_dev *dev)
>  	tasklet_kill(&card->tasklet);
>  	iounmap(card->csr_remap);
>  	release_mem_region(card->csr_base, card->csr_len);
> -#ifdef CONFIG_MM_MAP_MEMORY
> -	iounmap(card->mem_remap);
> -	release_mem_region(card->mem_base, card->mem_len);
> -#endif
>  	free_irq(card->irq, card);
> 
>  	if (card->mm_pages[0].desc)
> -- 
> ========================================================================
> Robert P. J. Day
> Linux Consulting, Training and Annoying Kernel Pedantry
> Waterloo, Ontario, CANADA
> 
> http://fsdev.net/wiki/index.php?title=Main_Page
> ========================================================================

-- 
Jens Axboe

