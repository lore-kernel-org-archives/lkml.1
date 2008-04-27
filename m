Return-Path: <linux-kernel-owner+w=401wt.eu-S1762306AbYD0Wjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762306AbYD0Wjp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 18:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751999AbYD0Wjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 18:39:37 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:52847 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751936AbYD0Wjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 18:39:37 -0400
Message-ID: <4815009C.2010809@garzik.org>
Date: Sun, 27 Apr 2008 18:39:24 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "David S. Miller" <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] x86, voyager: fix ioremap_nocache()
References: <1209329485.3801.46.camel@localhost.localdomain>	 <20080427214837.GA11631@elte.hu> <1209335660.3801.79.camel@localhost.localdomain>
In-Reply-To: <1209335660.3801.79.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> Here's another piece of the x86 API that's designed to be cached.  The
> dma_declare_coherent_memory() usually represents behind bridge memory
> that's fully participatory in the coherence model.
> 
> Making it uncached damages the utility of this memory because doing
> cacheline sized burst cycles when needed to it is far faster than
> individual byte/word/quad writes.
> 
> Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> 
> ---
> 
> diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
> index 388b113..df83ffd 100644
> --- a/arch/x86/kernel/pci-dma.c
> +++ b/arch/x86/kernel/pci-dma.c
> @@ -214,7 +214,7 @@ int dma_declare_coherent_memory(struct device *dev, dma_addr_t bus_addr,
>  
>  	/* FIXME: this routine just ignores DMA_MEMORY_INCLUDES_CHILDREN */
>  
> -	mem_base = ioremap(bus_addr, size);
> +	mem_base = ioremap_cache(bus_addr, size);
>  	if (!mem_base)
>  		goto out;

Surely the change in semantics will find other places to creep out like 
this?

I would rather change drivers to use ioremap_nocache(), and leave the 
API as-is.

Isn't there Yet More Breakage in lib/iomap.c, given these new semantics?

         if (flags & IORESOURCE_MEM) {
                 if (flags & IORESOURCE_CACHEABLE)
                         return ioremap(start, len);
                 return ioremap_nocache(start, len);
         }

Any driver using pci_iomap() (libata, and others) is affected.

I disagree with this semantics change.  A number of code places _and 
drivers_ GET IT RIGHT, and these are all broken now?

	Jeff



