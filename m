Return-Path: <linux-kernel-owner+w=401wt.eu-S934682AbYD1O3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934682AbYD1O3X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 10:29:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933212AbYD1O3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 10:29:15 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:38857 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932830AbYD1O3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 10:29:14 -0400
Subject: Re: [patch] x86, voyager: fix ioremap_nocache()
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Jeff Garzik <jeff@garzik.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "David S. Miller" <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20080428071006.5ce27533@laptopd505.fenrus.org>
References: <1209329485.3801.46.camel@localhost.localdomain>
	 <20080427214837.GA11631@elte.hu>
	 <1209335660.3801.79.camel@localhost.localdomain>
	 <4815009C.2010809@garzik.org>
	 <20080428071006.5ce27533@laptopd505.fenrus.org>
Content-Type: text/plain
Date: Mon, 28 Apr 2008 10:29:08 -0400
Message-Id: <1209392948.3367.13.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-04-28 at 07:10 -0700, Arjan van de Ven wrote:
> On Sun, 27 Apr 2008 18:39:24 -0400
> Jeff Garzik <jeff@garzik.org> wrote:
> 
> > James Bottomley wrote:
> > > Here's another piece of the x86 API that's designed to be cached.
> > > The dma_declare_coherent_memory() usually represents behind bridge
> > > memory that's fully participatory in the coherence model.
> > > 
> > > Making it uncached damages the utility of this memory because doing
> > > cacheline sized burst cycles when needed to it is far faster than
> > > individual byte/word/quad writes.
> > > 
> > > Signed-off-by: James Bottomley
> > > <James.Bottomley@HansenPartnership.com>
> > > 
> > > ---
> > > 
> > > diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
> > > index 388b113..df83ffd 100644
> > > --- a/arch/x86/kernel/pci-dma.c
> > > +++ b/arch/x86/kernel/pci-dma.c
> > > @@ -214,7 +214,7 @@ int dma_declare_coherent_memory(struct device
> > > *dev, dma_addr_t bus_addr, 
> > >  	/* FIXME: this routine just ignores
> > > DMA_MEMORY_INCLUDES_CHILDREN */ 
> > > -	mem_base = ioremap(bus_addr, size);
> > > +	mem_base = ioremap_cache(bus_addr, size);
> > >  	if (!mem_base)
> > >  		goto out;
> 
> this patch patch is likely broken on x86; or rather, anyone who uses it is...
> thinking you can find cache coherent memory on a PCI or similar bus that is actually
> cachable... keep dreaming. (for now; there's talk about extending PCI)

No ... it works for me, and caching is a performance advantage for me
too.  The only current consumer of this API is the NCR_Q720 SCSI card
which keeps a bunch of cacheable memory remote across the MCA bus.

If you think about it logically, most busses are second citizens in the
caching hierarchy: they really only get to force a flush and invalidate
of the CPU cache line rather than being fully participatory in the
coherence protocol.  However, even being second class is enough of a
speed up on slow busses because it allows bursting of the cache line for
the bus transfers.

The other consumers are SoC embedded ... so yes, perhaps I should ask
about this on linux-arch.

James


