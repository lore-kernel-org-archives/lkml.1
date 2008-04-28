Return-Path: <linux-kernel-owner+w=401wt.eu-S934478AbYD1OKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934478AbYD1OKr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 10:10:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933360AbYD1OKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 10:10:39 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40766 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933228AbYD1OKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 10:10:38 -0400
Date: Mon, 28 Apr 2008 07:10:06 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "David S. Miller" <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] x86, voyager: fix ioremap_nocache()
Message-ID: <20080428071006.5ce27533@laptopd505.fenrus.org>
In-Reply-To: <4815009C.2010809@garzik.org>
References: <1209329485.3801.46.camel@localhost.localdomain>
	<20080427214837.GA11631@elte.hu>
	<1209335660.3801.79.camel@localhost.localdomain>
	<4815009C.2010809@garzik.org>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Apr 2008 18:39:24 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> James Bottomley wrote:
> > Here's another piece of the x86 API that's designed to be cached.
> > The dma_declare_coherent_memory() usually represents behind bridge
> > memory that's fully participatory in the coherence model.
> > 
> > Making it uncached damages the utility of this memory because doing
> > cacheline sized burst cycles when needed to it is far faster than
> > individual byte/word/quad writes.
> > 
> > Signed-off-by: James Bottomley
> > <James.Bottomley@HansenPartnership.com>
> > 
> > ---
> > 
> > diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
> > index 388b113..df83ffd 100644
> > --- a/arch/x86/kernel/pci-dma.c
> > +++ b/arch/x86/kernel/pci-dma.c
> > @@ -214,7 +214,7 @@ int dma_declare_coherent_memory(struct device
> > *dev, dma_addr_t bus_addr, 
> >  	/* FIXME: this routine just ignores
> > DMA_MEMORY_INCLUDES_CHILDREN */ 
> > -	mem_base = ioremap(bus_addr, size);
> > +	mem_base = ioremap_cache(bus_addr, size);
> >  	if (!mem_base)
> >  		goto out;

this patch patch is likely broken on x86; or rather, anyone who uses it is...
thinking you can find cache coherent memory on a PCI or similar bus that is actually
cachable... keep dreaming. (for now; there's talk about extending PCI)


> I would rather change drivers to use ioremap_nocache(), and leave the 
> API as-is.
> 
> Isn't there Yet More Breakage in lib/iomap.c, given these new
> semantics?
> 
>          if (flags & IORESOURCE_MEM) {
>                  if (flags & IORESOURCE_CACHEABLE)
>                          return ioremap(start, len);
>                  return ioremap_nocache(start, len);
>          }
> 
> Any driver using pci_iomap() (libata, and others) is affected.

only if you map ROM's. Anything but ROMs you cannot set IORESOURCE_CACHEABLE
on... since PCI MMIO memory isn't cache coherent per se. (it's cache coherent on
x86 by virtue of being uncachable ;-)
Thankfully Linux doesn't do that.

> I disagree with this semantics change.  A number of code places _and 
> drivers_ GET IT RIGHT, and these are all broken now?

Can you list one that gets it actually right ?
(cachable pretty much means: "the cpu is the only one changing it AND there is no side effect of 
reading or writing")

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
