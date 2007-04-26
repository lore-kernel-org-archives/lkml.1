Return-Path: <linux-kernel-owner+w=401wt.eu-S1754792AbXDZNug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792AbXDZNug (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 09:50:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754796AbXDZNua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 09:50:30 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:45327 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754794AbXDZNuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 09:50:17 -0400
Subject: Re: [PATCH] dma_declare_coherent_memory wrong allocation
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, jayalk@intworks.biz,
       akpm@linux-foundation.org
In-Reply-To: <Pine.LNX.4.60.0704232239250.12939@poirot.grange>
References: <Pine.LNX.4.60.0704132000030.5919@poirot.grange>
	 <1177260725.4268.9.camel@mulgrave.il.steeleye.com>
	 <Pine.LNX.4.60.0704222202050.4127@poirot.grange>
	 <1177343905.6284.22.camel@mulgrave>
	 <Pine.LNX.4.60.0704232239250.12939@poirot.grange>
Content-Type: text/plain
Date: Thu, 26 Apr 2007 09:47:47 -0400
Message-Id: <1177595268.6284.116.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-23 at 22:45 +0200, Guennadi Liakhovetski wrote:
> On Mon, 23 Apr 2007, James Bottomley wrote:
> 
> > On Mon, 2007-04-23 at 00:45 +0200, Guennadi Liakhovetski wrote:
> > > Right, thinko. How about using his:
> > > 
> > > +	int pages = DIV_ROUND_UP(size, PAGE_SIZE);
> > 
> > Actually, no ... this has to be size >> PAGE_SHIFT.  The reason being
> > that the  allocator is designed to allocate pages out of a device memory
> > buffer.  If the size isn't a multiple of page size, we have to round
> > down (we can't allocate the last page if the memory we have is only part
> > of a page).
> > 
> > I suppose if you want to catch the unlikely nutcase where size <
> > PAGE_SIZE you could
> > 
> > if (unlikely(pages == 0))
> > 	goto out;
> > 
> > > +	int bitmap_size = BITS_TO_LONGS(pages) * BYTES_PER_LONG;
> > 
> > This is fine, except the BYTES_PER_LONG.  Traditionally, we do this with
> > sizeof(long).  The only reason to have a #define for it is if it has to
> > be used in a macro (the compiler does sizeof() not the preprocessor).
> > 
> > How about just a simple
> > 
> > int bitmap_size = BITS_TO_LONGS(pages) * sizeof(long);
> 
> Ok, version 3, small, and hopefully, beautiful:
> 
> dma_declare_coherent_memory() allocates a bitmap 1 bit per page, it 
> calculates the bitmap size based on size of long, but allocates bytes...
> Thanks to James Bottomley for clarifications and corrections.
> 
> Signed-off-by: G. Liakhovetski <g.liakhovetski@gmx.de>

Looks perfect to me.

Acked-by: James Bottomley <James.Bottomley@SteelEye.com>

> diff --git a/arch/cris/arch-v32/drivers/pci/dma.c b/arch/cris/arch-v32/drivers/pci/dma.c
> index 70d3bf0..832fc63 100644
> --- a/arch/cris/arch-v32/drivers/pci/dma.c
> +++ b/arch/cris/arch-v32/drivers/pci/dma.c
> @@ -76,7 +76,7 @@ int dma_declare_coherent_memory(struct device *dev, dma_addr_t bus_addr,
>  {
>  	void __iomem *mem_base;
>  	int pages = size >> PAGE_SHIFT;
> -	int bitmap_size = (pages + 31)/32;
> +	int bitmap_size = BITS_TO_LONGS(pages) * sizeof(long);
>  
>  	if ((flags & (DMA_MEMORY_MAP | DMA_MEMORY_IO)) == 0)
>  		goto out;
> diff --git a/arch/i386/kernel/pci-dma.c b/arch/i386/kernel/pci-dma.c
> index 3ebcea0..30b754f 100644
> --- a/arch/i386/kernel/pci-dma.c
> +++ b/arch/i386/kernel/pci-dma.c
> @@ -77,7 +77,7 @@ int dma_declare_coherent_memory(struct device *dev, dma_addr_t bus_addr,
>  {
>  	void __iomem *mem_base = NULL;
>  	int pages = size >> PAGE_SHIFT;
> -	int bitmap_size = (pages + 31)/32;
> +	int bitmap_size = BITS_TO_LONGS(pages) * sizeof(long);
>  
>  	if ((flags & (DMA_MEMORY_MAP | DMA_MEMORY_IO)) == 0)
>  		goto out;

