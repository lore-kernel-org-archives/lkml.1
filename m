Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187Ab0CJDxl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 22:53:41 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:32932 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756151Ab0CJDxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 22:53:39 -0500
Date: Wed, 10 Mar 2010 12:52:50 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Pavel Machek <pavel@ucw.cz>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux@arm.linux.org.uk,
       mdharm-kernel@one-eyed-alien.net, linux-usb@vger.kernel.org,
       x0082077@ti.com, sshtylyov@ru.mvista.com, tom.leiming@gmail.com,
       bigeasy@linutronix.de, oliver@neukum.org, linux-kernel@vger.kernel.org,
       santosh.shilimkar@ti.com, greg@kroah.com,
       linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org
Subject: Re: USB mass storage and ARM cache coherency
Message-ID: <20100310035249.GB17693@linux-sh.org>
References: <20100303215437.GF2579@ucw.cz> <1267709756.6526.380.camel@e102109-lin.cambridge.arm.com> <20100304135128.GA12191@atrey.karlin.mff.cuni.cz> <1267712512.31654.176.camel@mulgrave.site> <1267716578.6526.483.camel@e102109-lin.cambridge.arm.com> <20100304154103.GA9384@linux-sh.org> <1267726049.6526.543.camel@e102109-lin.cambridge.arm.com> <1267738660.22204.77.camel@pasglop> <20100305011745.GC26618@linux-sh.org> <1267764295.22204.102.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267764295.22204.102.camel@pasglop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 05, 2010 at 03:44:55PM +1100, Benjamin Herrenschmidt wrote:
> > For these parts the PG_dcache_dirty approach
> > saves us from a lot of flushing, and the corner cases were isolated
> > enough that we could tolerate fixups at the driver level, even on a
> > write-allocate D-cache.
> 
> But how wide a range of devices do you have to support with those ? Is
> this a few SoCs or people putting any random PCI device in there for
> example ?
> 
> If I were to do it that way on ppc32, I worried that it would be more
> than a few drivers that I would have to fix :-) All the 32-bit PowerMac
> and PowerBooks for example, all of freescale 74xx based parts, etc...
> those guys have PCI, and all sort of random HW plugged into them.
> 
Many of those parts do support PCI, but are rarely used with arbitrary
devices. The PCI controller on those parts also permits one to establish
coherency for any transactions between PCI and memory through a rudimentary
snoop controller that requires the CPU to avoid entering any sleep
states. This works ok in practice since that series of host controllers
doesn't really support power management anyways (nor do any of the cores
of that generation implement any of the more complex sleep states).

> > For second generation SH-4A (SH-X2) and up parts, read and exec are split
> > out and we could reasonably adopt the PG_dcache_clean approach there
> > while adopting the same sort of flushing semantics as PPC to avoid
> > flushing constantly. The current generation of parts far outnumber their
> > legacy counterparts, so it's certainly something I plan to experiment
> > with.
> 
> I'd be curious to see whether you get a perf imporovement with that.
> 
> Note that we still have this additional thing that is floating around in
> this thread which I thing is definitely worthwhile to do, which is to
> mark clean pages that have been written to with DMA in dma_unmap and
> friends.... if we can fix the icache problem. So far, I haven't found
> James replies on this satisfactory :-) But maybe I just missed
> something.
> 
I'll start in on profiling some of this once I start on 2.6.35 stuff. I
think I still have my old numbers from when we did the PG_mapped to
PG_dcache_dirty transition, so it will be interesting to see how
PG_dcache_clean stacks up against both of those.

> > We have an additional level of complexity on some of the SMP parts with a
> > non-coherent I-cache,
> 
> I've that on some embedded ppc's too, where the icache flush instrutions
> aren't broadcast, like ARM11MP in fact. Pretty horrible. Fortunately
> today nobody sane (appart from Bluegene) did an SMP part with those and
> so we have well localized internal hacks for them. But I've heared that
> some vendors might be pumping out SoCs with that stuff too soon which
> worries me.
> 
I-cache invalidations are broadcast on all mass produced SH-4A SMP parts,
but we do have some early proto chips that screwed that up. For the case
of mainline, we ought to be able to assume hardware broadcast though.

> >  some of the early CPUs have broken broadcasting of
> > the cacheops in hardware and so need to rely on IPIs, while the later
> > parts broadcast properly. We also need to deal with D-cache IPIs when
> > using mixed coherency protocols on different CPUs.
> 
> Right, that sucks. Do those have no-exec permission support ? If they
> do, then you can do what I did for BG, which is to ping pong user pages
> so they are either writable or executable (since userspace code itself
> will break as it will assume the cache ops -are- broadcast, since that's
> what the architecture says).
> 
Yes, these all support no-exec. I'll give the ping ponging thing a try,
thanks for the tip.

> Do you also, like ARM11MP, have a case of non-cache coherent DMA and
> non-broadcast cache ops in SMP ? That's somewhat of a killer, I still
> don't see how it can be dealt properly other than using load/store
> tricks to bring the data into the local cache and flushing it from
> there. DMA ops are called way to deep into spinlock hell to rely on IPIs

The only thing we really lack is I-cache coherency, which isn't such a
big deal with invalidations being broadcast. All DMA accesses are
snooped, and the D-cache is fully coherent.

> (unless your HW also provides some kind of NMI IPIs).
> 
While we don't have anything like FIQs to work with, we do have IRQ
priority levels to play with. I'd toyed with this idea in the past of
simply having a reserved level that never gets masked, particularly for
things like broadcast backtraces.

> > Using PG_dcache_clean from the DMA API sounds like a pretty good idea,
> > and certainly worth experimenting with. I don't know how we would do the
> > I-cache optimization without a PG_arch_2, though.
> 
> Right. That's the one thing I've been trying to figure out without
> success. But then, is it a big deal to add PG_arch_2 ? doesn't sound
> like it to me...
> 
Well, it does start to get a bit painful with sparsemem section or NUMA
node IDs also digging in to the page flags on 32-bit.. the benefits would
have to be pretty compelling to offset the pain.
