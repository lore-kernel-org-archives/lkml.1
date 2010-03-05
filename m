Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587Ab0CEErG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 23:47:06 -0500
Received: from gate.crashing.org ([63.228.1.57]:49031 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755330Ab0CEErC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 23:47:02 -0500
Subject: Re: USB mass storage and ARM cache coherency
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Pavel Machek <pavel@ucw.cz>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux@arm.linux.org.uk,
       mdharm-kernel@one-eyed-alien.net, linux-usb@vger.kernel.org,
       x0082077@ti.com, sshtylyov@ru.mvista.com, tom.leiming@gmail.com,
       bigeasy@linutronix.de, oliver@neukum.org, linux-kernel@vger.kernel.org,
       santosh.shilimkar@ti.com, greg@kroah.com,
       linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org
In-Reply-To: <20100305011745.GC26618@linux-sh.org>
References: <20100302211049V.fujita.tomonori@lab.ntt.co.jp>
	 <1267549527.15401.78.camel@e102109-lin.cambridge.arm.com>
	 <20100303215437.GF2579@ucw.cz>
	 <1267709756.6526.380.camel@e102109-lin.cambridge.arm.com>
	 <20100304135128.GA12191@atrey.karlin.mff.cuni.cz>
	 <1267712512.31654.176.camel@mulgrave.site>
	 <1267716578.6526.483.camel@e102109-lin.cambridge.arm.com>
	 <20100304154103.GA9384@linux-sh.org>
	 <1267726049.6526.543.camel@e102109-lin.cambridge.arm.com>
	 <1267738660.22204.77.camel@pasglop>  <20100305011745.GC26618@linux-sh.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Mar 2010 15:44:55 +1100
Message-ID: <1267764295.22204.102.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Basically we have two different MMUs on VIPT parts, the older one on all
> SH-4 parts were all read-implies-exec with no ability to differentiate
> between read or exec access. 

Ok, this is the same as the older ppc32 processors.

> For these parts the PG_dcache_dirty approach
> saves us from a lot of flushing, and the corner cases were isolated
> enough that we could tolerate fixups at the driver level, even on a
> write-allocate D-cache.

But how wide a range of devices do you have to support with those ? Is
this a few SoCs or people putting any random PCI device in there for
example ?

If I were to do it that way on ppc32, I worried that it would be more
than a few drivers that I would have to fix :-) All the 32-bit PowerMac
and PowerBooks for example, all of freescale 74xx based parts, etc...
those guys have PCI, and all sort of random HW plugged into them.

I would -love- to avoid that horrible amount of flushing we do on these,
it's quite high on any profile run, but I haven't found a good way to do
so. There's also a nasty issue of icache content leaking between
processes which I doubt is exploitable but I had people having a go at
me about it when I tried to avoid icache cleaning anonymous pages by
default.

> For second generation SH-4A (SH-X2) and up parts, read and exec are split
> out and we could reasonably adopt the PG_dcache_clean approach there
> while adopting the same sort of flushing semantics as PPC to avoid
> flushing constantly. The current generation of parts far outnumber their
> legacy counterparts, so it's certainly something I plan to experiment
> with.

I'd be curious to see whether you get a perf imporovement with that.

Note that we still have this additional thing that is floating around in
this thread which I thing is definitely worthwhile to do, which is to
mark clean pages that have been written to with DMA in dma_unmap and
friends.... if we can fix the icache problem. So far, I haven't found
James replies on this satisfactory :-) But maybe I just missed
something.

> We have an additional level of complexity on some of the SMP parts with a
> non-coherent I-cache,

I've that on some embedded ppc's too, where the icache flush instrutions
aren't broadcast, like ARM11MP in fact. Pretty horrible. Fortunately
today nobody sane (appart from Bluegene) did an SMP part with those and
so we have well localized internal hacks for them. But I've heared that
some vendors might be pumping out SoCs with that stuff too soon which
worries me.

>  some of the early CPUs have broken broadcasting of
> the cacheops in hardware and so need to rely on IPIs, while the later
> parts broadcast properly. We also need to deal with D-cache IPIs when
> using mixed coherency protocols on different CPUs.

Right, that sucks. Do those have no-exec permission support ? If they
do, then you can do what I did for BG, which is to ping pong user pages
so they are either writable or executable (since userspace code itself
will break as it will assume the cache ops -are- broadcast, since that's
what the architecture says).

> For older PIPT parts we've never used the deferred flush, since the only
> time we ever had to bother with cache maintenance was in the DMA ops, as
> anything closer to the CPU than the PCI DMAC had no opportunity to be
> snooped.

Do you also, like ARM11MP, have a case of non-cache coherent DMA and
non-broadcast cache ops in SMP ? That's somewhat of a killer, I still
don't see how it can be dealt properly other than using load/store
tricks to bring the data into the local cache and flushing it from
there. DMA ops are called way to deep into spinlock hell to rely on IPIs
(unless your HW also provides some kind of NMI IPIs).

> > > I'm not familiar with SH but for PIO devices the flushing shouldn't be
> > > more aggressive. For the DMA devices, Russell suggested that we mark
> > > the page as clean (set PG_dcache_clean) in the DMA API to avoid the
> > > default flushing.
> > 
> > I really like that idea, as I said earlier, but I'm worried about the I$
> > side of things. IE. What I'm trying to say is that I can't see how to do
> > that optimisation without ending up with missing I$ invalidations or
> > doing way too many of them, unless we have a separate bit to track I$
> > state.
> > 
> Using PG_dcache_clean from the DMA API sounds like a pretty good idea,
> and certainly worth experimenting with. I don't know how we would do the
> I-cache optimization without a PG_arch_2, though.

Right. That's the one thing I've been trying to figure out without
success. But then, is it a big deal to add PG_arch_2 ? doesn't sound
like it to me...

> In any event, if there's going to be a mass exodus to PG_dcache_clean,
> Documentation/cachetlb.txt could use a considerable amount of expanding.
> The read/exec and I-cache optimizations are something that would be
> valuable to document, as opposed to simply being pointed at the sparc64
> approach with the regular PG_dcache_dirty caveats.

Cheers,
Ben.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


