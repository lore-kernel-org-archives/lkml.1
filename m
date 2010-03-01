Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751132Ab0CAKjU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 05:39:20 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:38876 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750944Ab0CAKjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 05:39:18 -0500
Subject: Re: USB mass storage and ARM cache coherency
From: Catalin Marinas <catalin.marinas@arm.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       linux-usb@vger.kernel.org, "Mankad,Maulik Ojas" <x0082077@ti.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Ming Lei <tom.leiming@gmail.com>,
       Sebastian Siewior <bigeasy@linutronix.de>,
       Oliver Neukum <oliver@neukum.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Shilimkar,Santosh" <santosh.shilimkar@ti.com>,
       Pavel Machek <pavel@ucw.cz>, Greg KH <greg@kroah.com>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
In-Reply-To: <1267333263.2762.11.camel@mulgrave.site>
References: <1266979632.23523.1668.camel@pasglop>
	 <1267201521.14703.50.camel@e102109-lin.cambridge.arm.com>
	 <20100226210030.GC23933@n2100.arm.linux.org.uk>
	 <1267316072.23523.1842.camel@pasglop>
	 <1267333263.2762.11.camel@mulgrave.site>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Mon, 01 Mar 2010 10:39:14 +0000
Message-ID: <1267439954.23333.41.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Mar 2010 10:39:15.0286 (UTC) FILETIME=[70556F60:01CAB92B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-02-28 at 05:01 +0000, James Bottomley wrote:
> On Sun, 2010-02-28 at 11:14 +1100, Benjamin Herrenschmidt wrote:
> > On Fri, 2010-02-26 at 21:00 +0000, Russell King - ARM Linux wrote:
> > > On Fri, Feb 26, 2010 at 04:25:21PM +0000, Catalin Marinas wrote:
> > > > For mmap'ed pages (and present in the page cache), is it guaranteed that
> > > > the HCD driver won't write to it once it has been mapped into user
> > > > space? If that's the case, it may solve the problem by just reversing
> > > > the meaning of PG_arch_1 on ARM and assume that a newly allocated page
> > > > has dirty D-cache by default.
> > >
> > > I guess we could also set PG_arch_1 in the DMA API as well, to avoid the
> > > unnecessary D cache flushing when clean pages get mapped into userspace.
> >
> > That's an interesting thought for us too. When doing I$/D$ coherency, we
> > have to fist flush the D$ and then invalidate the I$. If we could keep
> > track of D$ and I$ separately, we could avoid the first step in many
> > cases, including the DMA API trick you mentioned.
> >
> > I wonder if it's time to get a PG_arch_2 :-)
> 
> Sorry to be a bit late to the party (on holiday), but I/D coherency is
> supposed to be taken care of using flush_cache_page in the memory
> mapping routines.  On parisc, at least, we don't use any PG_arch flags
> to help.  The way it's supposed to work is that I is invalidated on
> mapping or remapping, so the I/O code only needs to worry about flushing
> D.  The guarantee we pass to userland is that any page we do I/O to has
> a clean D cache before it goes back to userspace.  Thus if userspace
> executes the page, the I cache gets its first movein there.  There is an
> underlying assumption to all of this:  The CPU won't speculatively move
> in I cache until the page is executed, so we can rely on the
> flush_cache_page in the mapping to keep the I cache invalidated until
> we're ready to execute.  

We cannot guarantee this assumption on ARM. As soon as the page is
accessible and executable, the CPU can fetch into the I-cache
speculatively. Even if the page hasn't been mapped into user-space yet,
we still have the kernel linear mapping via which we can get the same
I-cache lines fetched (PIPT cache).

The only place we can safely invalidate the I-cache is after the D-cache
was flushed (after flush_dcache_page).

On ARM PIPT, flush_cache_page is a no-op.

> The other fundamental assumption is that if
> userspace needs to modify an executable region (say for dynamic linking)
> it has to take care of reinvalidating the I cache itself ... although it
> can do this by remapping the region to alter the flags (i.e W no X then
> X no W).

The ARM dynamic linker remaps the page with no-exec, writes the data and
then remaps it back with exec. The COW code flushes the D-cache. Anyway,
recent dynamic linker no longer touches a code page.
> 
> But the point of all of this is that I cache invalidation doesn't appear
> anywhere in the I/O path ... so  if we're getting I/D incoherency,
> there's some problem in the mm code (or there's a missing arch
> assumption ... like I cache gets moved in more aggressively than we
> expect).  Parisc is very sensitive to I/D incoherency, so we'd notice if
> there were a serious generic problem here.

On ARM PIPT, it's probably because flush_cache_page isn't implemented.
But as I said above, given the speculative fetches I don't think it
would help much (well, it would work a bit better but not a complete
fix).

Thanks.

-- 
Catalin

