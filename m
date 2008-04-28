Return-Path: <linux-kernel-owner+w=401wt.eu-S934667AbYD1PHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934667AbYD1PHs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 11:07:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933768AbYD1PHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 11:07:40 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:38201 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933717AbYD1PHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 11:07:39 -0400
Date: Mon, 28 Apr 2008 08:07:00 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jeff Garzik <jeff@garzik.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "David S. Miller" <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] x86, voyager: fix ioremap_nocache()
Message-ID: <20080428080700.4190f5e6@laptopd505.fenrus.org>
In-Reply-To: <1209392948.3367.13.camel@localhost.localdomain>
References: <1209329485.3801.46.camel@localhost.localdomain>
	<20080427214837.GA11631@elte.hu>
	<1209335660.3801.79.camel@localhost.localdomain>
	<4815009C.2010809@garzik.org>
	<20080428071006.5ce27533@laptopd505.fenrus.org>
	<1209392948.3367.13.camel@localhost.localdomain>
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

On Mon, 28 Apr 2008 10:29:08 -0400
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Mon, 2008-04-28 at 07:10 -0700, Arjan van de Ven wrote:
> > On Sun, 27 Apr 2008 18:39:24 -0400
> > Jeff Garzik <jeff@garzik.org> wrote:
> > 
> > > James Bottomley wrote:
> > > > Here's another piece of the x86 API that's designed to be
> > > > cached. The dma_declare_coherent_memory() usually represents
> > > > behind bridge memory that's fully participatory in the
> > > > coherence model.
> > > > 
> > > > Making it uncached damages the utility of this memory because
> > > > doing cacheline sized burst cycles when needed to it is far
> > > > faster than individual byte/word/quad writes.
> > > > 
> > > > Signed-off-by: James Bottomley
> > > > <James.Bottomley@HansenPartnership.com>
> > > > 
> > > > ---
> > > > 
> > > > diff --git a/arch/x86/kernel/pci-dma.c
> > > > b/arch/x86/kernel/pci-dma.c index 388b113..df83ffd 100644
> > > > --- a/arch/x86/kernel/pci-dma.c
> > > > +++ b/arch/x86/kernel/pci-dma.c
> > > > @@ -214,7 +214,7 @@ int dma_declare_coherent_memory(struct
> > > > device *dev, dma_addr_t bus_addr, 
> > > >  	/* FIXME: this routine just ignores
> > > > DMA_MEMORY_INCLUDES_CHILDREN */ 
> > > > -	mem_base = ioremap(bus_addr, size);
> > > > +	mem_base = ioremap_cache(bus_addr, size);
> > > >  	if (!mem_base)
> > > >  		goto out;
> > 
> > this patch patch is likely broken on x86; or rather, anyone who
> > uses it is... thinking you can find cache coherent memory on a PCI
> > or similar bus that is actually cachable... keep dreaming. (for
> > now; there's talk about extending PCI)
> 
> No ... it works for me, and caching is a performance advantage for me
> too.  The only current consumer of this API is the NCR_Q720 SCSI card
> which keeps a bunch of cacheable memory remote across the MCA bus.
> 
> If you think about it logically, most busses are second citizens in
> the caching hierarchy: they really only get to force a flush and
> invalidate of the CPU cache line rather than being fully
> participatory in the coherence protocol. 


Cached means that the cpu, at any time, can do a speculative read to the memory.
It also means that the cpu can then write the speculated cacheline back at any time later,
if some speculation was going to write to the cacheline but didn't actually happen.
(before you think this is bogus, at least AMD cpus do this and I can't vouch for Intel
cpus never doing this).
If the on-the-bus hardware *ever* writes to the memory without being part of the full
cache coherence protocol it's in trouble. Big time.
Even if it sends an invalidate first (which PCI and others just don't allow, not sure about MCA though),
it's not enough because the cpu can just read it right back... one needs a "take for ownership" not
an "invalidate" for this to work, and that means being part of the full protocol.


> However, even being second
> class is enough of a speed up on slow busses because it allows
> bursting of the cache line for the bus transfers.

that's write combining not cachability I suspect... at least for writes it is.
> 
> The other consumers are SoC embedded ... so yes, perhaps I should ask
> about this on linux-arch.

x86 SoC ? (we're talking about an arch/x86 file here)
Esp in SoC people don't bother doing cache coherency if they can get away
with it.



-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
