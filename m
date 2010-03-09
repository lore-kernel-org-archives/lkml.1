Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039Ab0CIXCP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 18:02:15 -0500
Received: from xenotime.net ([72.52.64.118]:33603 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754679Ab0CIXCK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 18:02:10 -0500
Message-ID: <4B96D36B.9080802@xenotime.net>
Date: Tue, 09 Mar 2010 15:02:03 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: akpm@linux-foundation.org, James.Bottomley@suse.de,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       davem@davemloft.net
Subject: Re: [PATCH -mm 1/3] Documentation: convert PCI-DMA-mapping.txt to
 use the generic DMA API
References: <1268110389-12444-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1268110389-12444-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1268110389-12444-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/10 20:53, FUJITA Tomonori wrote:
> - replace the PCI DMA API (i.e. pci_dma_*) with the generic DMA API.
> 
> - make the document more generic (use the PCI specific explanation as
>   an example).
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  Documentation/PCI/PCI-DMA-mapping.txt |  352 ++++++++++++++++-----------------
>  1 files changed, 172 insertions(+), 180 deletions(-)
> 
> diff --git a/Documentation/PCI/PCI-DMA-mapping.txt b/Documentation/PCI/PCI-DMA-mapping.txt
> index ecad88d..55a3ac5 100644
> --- a/Documentation/PCI/PCI-DMA-mapping.txt
> +++ b/Documentation/PCI/PCI-DMA-mapping.txt


> @@ -133,31 +135,30 @@ of your driver reports that performance is bad or that the device is not
>  even detected, you can ask them for the kernel messages to find out
>  exactly why.
>  
> -The standard 32-bit addressing PCI device would do something like
> -this:
> +The standard 32-bit addressing device would do something like this:
>  
> -	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32))) {
> +	if (dma_set_mask(dev, DMA_BIT_MASK(32))) {
>  		printk(KERN_WARNING
>  		       "mydev: No suitable DMA available.\n");
>  		goto ignore_this_device;
>  	}
>  
> -Another common scenario is a 64-bit capable device.  The approach
> -here is to try for 64-bit DAC addressing, but back down to a
> -32-bit mask should that fail.  The PCI platform code may fail the
> -64-bit mask not because the platform is not capable of 64-bit
> -addressing.  Rather, it may fail in this case simply because
> -32-bit SAC addressing is done more efficiently than DAC addressing.
> -Sparc64 is one platform which behaves in this way.
> +Another common scenario is a 64-bit capable device.  The approach here
> +is to try for 64-bit addressing, but back down to a 32-bit mask that
> +should not fail.  The kernel may fail the 64-bit mask not because the
> +platform is not capable of 64-bit addressing.  Rather, it may fail in
> +this case simply because 32-bit addressing is done more efficiently
> +than addressing.  For example, Sparc64 PCI SAC addressing is more

   than 64-bit addressing.  (?)

> +efficient than DAC addressing.
>  
>  Here is how you would handle a 64-bit capable device which can drive
>  all 64-bits when accessing streaming DMA:
>  
>  	int using_dac;
>  
> -	if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
> +	if (!dma_set_mask(dev, DMA_BIT_MASK(64))) {
>  		using_dac = 1;
> -	} else if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(32))) {
> +	} else if (!dma_set_mask(dev, DMA_BIT_MASK(32))) {
>  		using_dac = 0;
>  	} else {
>  		printk(KERN_WARNING

> @@ -315,33 +316,27 @@ you should do:
>  
>  	dma_addr_t dma_handle;
>  
> -	cpu_addr = pci_alloc_consistent(pdev, size, &dma_handle);
> -
> -where pdev is a struct pci_dev *. This may be called in interrupt context.
> -You should use dma_alloc_coherent (see DMA-API.txt) for buses
> -where devices don't have struct pci_dev (like ISA, EISA).
> +	cpu_addr = dma_alloc_coherent(dev, size, &dma_handle, gfp);
>  
> -This argument is needed because the DMA translations may be bus
> -specific (and often is private to the bus which the device is attached
> -to).
> +where device is a struct device *. This may be called in interrupt
> +context with the GFP_ATOMIC flag.
>  
>  Size is the length of the region you want to allocate, in bytes.
>  
>  This routine will allocate RAM for that region, so it acts similarly to
>  __get_free_pages (but takes size instead of a page order).  If your
>  driver needs regions sized smaller than a page, you may prefer using
> -the pci_pool interface, described below.
> -
> -The consistent DMA mapping interfaces, for non-NULL pdev, will by
> -default return a DMA address which is SAC (Single Address Cycle)
> -addressable.  Even if the device indicates (via PCI dma mask) that it
> -may address the upper 32-bits and thus perform DAC cycles, consistent
> -allocation will only return > 32-bit PCI addresses for DMA if the
> -consistent dma mask has been explicitly changed via
> -pci_set_consistent_dma_mask().  This is true of the pci_pool interface
> -as well.
> -
> -pci_alloc_consistent returns two values: the virtual address which you
> +the dma_pool interface, described below.
> +
> +The consistent DMA mapping interfaces, for non-NULL dev, will by
> +default return a DMA address which is 32-bit addressable.  Even if the
> +device indicates (via dma mask) that it may address the upper 32-bits,

                         DMA

> +consistent allocation will only return > 32-bit addresses for DMA if
> +the consistent dma mask has been explicitly changed via

                  DMA

> +dma_set_coherent_mask().  This is true of the dma_pool interface as
> +well.
> +
> +dma_alloc_coherent returns two values: the virtual address which you
>  can use to access it from the CPU and dma_handle which you pass to the
>  card.
>  


This looks like a really nice update/change.  Thanks.

Reviewed-by: Randy Dunlap <rdunlap@xenotime.net>


-- 
~Randy
