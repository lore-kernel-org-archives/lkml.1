Return-Path: <linux-kernel-owner+w=401wt.eu-S932903AbXDUHIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932903AbXDUHIZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 03:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932997AbXDUHIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 03:08:25 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46704 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932903AbXDUHIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 03:08:24 -0400
Date: Sat, 21 Apr 2007 00:08:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dma_declare_coherent_memory wrong allocation
Message-Id: <20070421000817.124e917b.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.60.0704132000030.5919@poirot.grange>
References: <Pine.LNX.4.60.0704132000030.5919@poirot.grange>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Apr 2007 20:08:28 +0200 (CEST) Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:

> Hi
> 
> Either I've finally gone blind on this Friday 13th or... Looks like this 
> almost 3 year old function has a bug. Patch below compile-tested... in a 
> way.
> 
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski
> 
> dma_declare_coherent_memory() allocates a bitmap 1 bit per page, it 
> calculates the bitmap size based on size of long, but allocates bytes...
> 
> Signed-off-by: G. Liakhovetski <g.liakhovetski@gmx.de>
> 
> diff --git a/arch/i386/kernel/pci-dma.c b/arch/i386/kernel/pci-dma.c
> index 3ebcea0..3d55226 100644
> --- a/arch/i386/kernel/pci-dma.c
> +++ b/arch/i386/kernel/pci-dma.c
> @@ -77,7 +77,7 @@ int dma_declare_coherent_memory(struct device *dev, dma_addr_t bus_addr,
>  {
>  	void __iomem *mem_base = NULL;
>  	int pages = size >> PAGE_SHIFT;
> -	int bitmap_size = (pages + 31)/32;
> +	int bitmap_size = DIV_ROUND_UP(pages, 8);
>  
>  	if ((flags & (DMA_MEMORY_MAP | DMA_MEMORY_IO)) == 0)
>  		goto out;

Looks that way to me, too.

It also hopes like hell that `size' was a multiple of PAGE_SIZE.
