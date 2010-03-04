Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab0CDVgk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 16:36:40 -0500
Received: from gate.crashing.org ([63.228.1.57]:42901 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754118Ab0CDVgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 16:36:38 -0500
Subject: Re: USB mass storage and ARM cache coherency
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       mdharm-kernel@one-eyed-alien.net, oliver@neukum.org,
       linux@arm.linux.org.uk, greg@kroah.com, x0082077@ti.com,
       sshtylyov@ru.mvista.com, bigeasy@linutronix.de,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       santosh.shilimkar@ti.com, Pavel Machek <pavel@ucw.cz>,
       tom.leiming@gmail.com, linux-arm-kernel@lists.infradead.org
In-Reply-To: <20100304154103.GA9384@linux-sh.org>
References: <20100226210030.GC23933@n2100.arm.linux.org.uk>
	 <1267316072.23523.1842.camel@pasglop>
	 <1267333263.2762.11.camel@mulgrave.site>
	 <20100302211049V.fujita.tomonori@lab.ntt.co.jp>
	 <1267549527.15401.78.camel@e102109-lin.cambridge.arm.com>
	 <20100303215437.GF2579@ucw.cz>
	 <1267709756.6526.380.camel@e102109-lin.cambridge.arm.com>
	 <20100304135128.GA12191@atrey.karlin.mff.cuni.cz>
	 <1267712512.31654.176.camel@mulgrave.site>
	 <1267716578.6526.483.camel@e102109-lin.cambridge.arm.com>
	 <20100304154103.GA9384@linux-sh.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Mar 2010 08:34:40 +1100
Message-ID: <1267738480.22204.74.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-05 at 00:41 +0900, Paul Mundt wrote:
> On Thu, Mar 04, 2010 at 03:29:38PM +0000, Catalin Marinas wrote:
> > On Thu, 2010-03-04 at 14:21 +0000, James Bottomley wrote:
> > > The thing which was discovered in this thread is basically that ARM is
> > > handling deferred flushing (for D/I coherency) in a slightly different
> > > way from everyone else ... 
> > 
> > Doing a grep for PG_dcache_dirty defined in terms of PG_arch_1 reveals
> > that MIPS, Parisc, Score, SH and SPARC do similar things to ARM. PowerPC
> > and IA-64 use PG_arch_1 as a clean rather than dirty bit.
> > 
> SH used to use it as a PG_mapped which was roughly similar to the
> PG_dcache_clean approach, at which point things like flushing for the PIO
> case in the HCD wasn't necessary. It did result in rather aggressive over
> flushing though, which is one of the reasons we elected to switch to
> PG_dcache_dirty.
> 
> Note that the PG_dcache_dirty semantics are also outlined in
> Documentation/cachetlb.txt for PG_arch_1 usage, so it's hardly esoteric.

Doing this way though is a lot more fragile... since page cache pages
are no longer dirty by default, you need to ensure that any driver
writing to one without DMA sets PG_arch_1, and as we've seen, this is
generally not the case (it's almost never the case actually).

Also, in the DMA case, you may not need to flush D$, but you -still-
need to invalidate I$, and unless you then get another bit for tracking
it, you end up doing a lot of over-invalidating of I$ no ?

Or am I missing a critical piece of the puzzle ?

Cheers,
Ben.


