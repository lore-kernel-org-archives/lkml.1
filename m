Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784Ab0CDOWH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 09:22:07 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:48781 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751225Ab0CDOWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 09:22:05 -0500
Subject: Re: USB mass storage and ARM cache coherency
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       benh@kernel.crashing.org, linux@arm.linux.org.uk,
       mdharm-kernel@one-eyed-alien.net, linux-usb@vger.kernel.org,
       x0082077@ti.com, sshtylyov@ru.mvista.com, tom.leiming@gmail.com,
       bigeasy@linutronix.de, oliver@neukum.org, linux-kernel@vger.kernel.org,
       santosh.shilimkar@ti.com, greg@kroah.com,
       linux-arm-kernel@lists.infradead.org
In-Reply-To: <20100304135128.GA12191@atrey.karlin.mff.cuni.cz>
References: <20100226210030.GC23933@n2100.arm.linux.org.uk>
	 <1267316072.23523.1842.camel@pasglop>
	 <1267333263.2762.11.camel@mulgrave.site>
	 <20100302211049V.fujita.tomonori@lab.ntt.co.jp>
	 <1267549527.15401.78.camel@e102109-lin.cambridge.arm.com>
	 <20100303215437.GF2579@ucw.cz>
	 <1267709756.6526.380.camel@e102109-lin.cambridge.arm.com>
	 <20100304135128.GA12191@atrey.karlin.mff.cuni.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Mar 2010 19:51:52 +0530
Message-ID: <1267712512.31654.176.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-04 at 14:51 +0100, Pavel Machek wrote:
> > On Wed, 2010-03-03 at 21:54 +0000, Pavel Machek wrote:
> > > > With some drivers (those doing PIO) or subsystems (SCSI mass storage
> > > > over USB HCD), there is no call to flush_dcache_page() for page cache
> > > > pages, hence the ARM implementation of update_mmu_cache() doesn't flush
> > > > the D-cache (and only invalidating the I-cache doesn't help).
> > > >
> > > > The viable solutions so far:
> > > >
> > > >      1. Implement a PIO mapping API similar to the DMA API which takes
> > > >         care of the D-cache flushing. This means that PIO drivers would
> > > >         need to be modified to use an API like pio_kmap()/pio_kunmap()
> > > >         before writing to a page cache page.
> > > >      2. Invert the meaning of PG_arch_1 to denote a clean page. This
> > > >         means that by default newly allocated page cache pages are
> > > >         considered dirty and even if there isn't a call to
> > > >         flush_dcache_page(), update_mmu_cache() would flush the D-cache.
> > > >         This is the PowerPC approach.
> > > 
> > > What about option
> > > 
> > > 3. Forget about PG_arch_1 and always do the flush?
> > > 
> > > How big is the performance impact? Note that current code does not
> > > even *work* so working, 10% slower code will be an improvement.
> > 
> > The driver fix is as simple as calling a flush_dcache_page() and I've
> > been carrying such patches in my tree for some time now. The question is
> > whether we need to do it in the driver or not (would need to update
> > Documentation/cachetlb.txt as well).
> > 
> > The reason I'm not in favour always doing the flush is that we penalise
> > DMA drivers where there is no need for extra D-cache flushing (already
> > handled by the DMA API; option 1 above is similar, just that it is meant
> > for PIO usage). An ARM patch I proposed for inverting the meaning of
> > PG_arch_1 also marks a page as clean in the dma_map_* functions.
> 
> But you are not fixing driver bug, are you?

Technically, he is.  In the old days, most VI architectures were high
end enough not to require PIO transfers.  The only exception was an IDE
driver used by sparc, which lead to the arch specific ide in/out string
instructions, in which sparc actually did all the necessary flushing.

So no other drivers than old IDE grew up with cache flushing in the PIO
case (and almost no high end VI hardware had an IDE interface, so they
rarely got implemented in the arch layer).  However, recently, with the
transition from old IDE to libata and the prevalence of ARM with more
commodity hardware, the deficiency is becoming exposed.  Even the PA8000
workstations now come with an IDE CD, which means we're starting to have
problems with them as well.

> Seems like ARM has requirement other architectures do not, that is
> a) not documented anywhere
> b) causes problems
> 
> You could argue that performance improvement (how big is it, anyway?)
> is worth it, but this should be agreed to by wider community...

Performance is always worth it provided we don't sacrifice correctness.
The thing which was discovered in this thread is basically that ARM is
handling deferred flushing (for D/I coherency) in a slightly different
way from everyone else ... once that's fixed, ARM will likely not have
the D/I problem, but we'll still have the libata (and other PIO systems)
D flushing issue.

James


