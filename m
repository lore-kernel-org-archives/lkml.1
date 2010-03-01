Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751305Ab0CALK2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 06:10:28 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:41446 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751167Ab0CALKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 06:10:17 -0500
Subject: Re: USB mass storage and ARM cache coherency
From: Catalin Marinas <catalin.marinas@arm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       linux-usb@vger.kernel.org, "Mankad,Maulik Ojas" <x0082077@ti.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Ming Lei <tom.leiming@gmail.com>,
       Sebastian Siewior <bigeasy@linutronix.de>,
       Oliver Neukum <oliver@neukum.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Shilimkar,Santosh" <santosh.shilimkar@ti.com>,
       Pavel Machek <pavel@ucw.cz>, Greg KH <greg@kroah.com>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
In-Reply-To: <1267316647.23523.1852.camel@pasglop>
References: <1266979632.23523.1668.camel@pasglop>
	 <1267201521.14703.50.camel@e102109-lin.cambridge.arm.com>
	 <1267220429.23523.1811.camel@pasglop>
	 <20100226214908.GD23933@n2100.arm.linux.org.uk>
	 <1267316647.23523.1852.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Mon, 01 Mar 2010 11:10:14 +0000
Message-ID: <1267441814.23333.65.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Mar 2010 11:10:15.0652 (UTC) FILETIME=[C532C240:01CAB92F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-02-28 at 00:24 +0000, Benjamin Herrenschmidt wrote:
> On Fri, 2010-02-26 at 21:49 +0000, Russell King - ARM Linux wrote:
> > On Sat, Feb 27, 2010 at 08:40:29AM +1100, Benjamin Herrenschmidt wrote:
> > > Hrm, the DMA API certainly doesn't handle the I$/D$ coherency on
> > > powerpc.. I'm afraid that whole cache handling stuff is totally
> > > inconsistent since different archs have different expectations here.
> >
> > It doesn't on ARM either.
> 
> Ok, pfiew :-)
> 
> So far, my understanding with I$/D$ is that we only care in a few cases
> which is executing of an mmap'ed piece of executable that is -not- being
> written to, and swap.
> 
> I -think- that in both cases, the page cache always pops up a new page
> with PG_arch_1 clear before the driver gets to either DMA or PIO to it
> when faulted the first time around, before any PTE is inserted.

That's my understanding too.

> So the current approach on powerpc with I$/D$ should work fine, and it
> -might- make sense to use a similar one on PIPT ARM, provided we don't
> have expectations of the I$/D$ coherency being maintained on
> -subsequent- writes (PIO or DMA either) to such a page by the same
> program transparently by the kernel.

Are these subsequent writes likely to happen?

> There's two potential problems with the approach, and maybe more that I
> have missed though. One is the case of a networked filesystem where the
> executable pages are modified remotely. However, I would expect such a
> program to invalidate the PTE mappings before making the change visible,
> so we -do- get a chance to re-flush provided something clears PG_arch_1.

I think the NFS code in Linux calls flush_dcache_page(). This function
can check whether the page is already mapped and do the cache flushing
rather than deferring it to set_pte_at().

> Then, there's In the case of a multithread app, where one thread does
> the cache flush and another thread then executes, the earlier ARMs
> without broadcast ops have a potential problem there. In fact, some
> variant of PowerPC 440 have the same problem and some people are
> (ab)using those for SMP setups I'm being told.

Yes. That could be solved at set_pte_at() level using IPIs.

> For that case, I see two options. One is a big hammer but would make
> existing code work to "most" extent: Don't allow a page to be both
> writable and executable. Ping-pong the page permission lazily and flush
> when transitioning from write to exec.

Are you referring to the SMP and non-broadcasting cache maintenance
issue? The same pte could be shared between multiple CPUs, so once you
make it executable on one it becomes executable on the others.

-- 
Catalin

