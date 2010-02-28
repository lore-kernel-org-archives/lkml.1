Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030976Ab0B1AZu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 19:25:50 -0500
Received: from gate.crashing.org ([63.228.1.57]:36811 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030952Ab0B1AZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 19:25:48 -0500
Subject: Re: USB mass storage and ARM cache coherency
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
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
In-Reply-To: <20100226214908.GD23933@n2100.arm.linux.org.uk>
References: <1266979632.23523.1668.camel@pasglop>
	 <1267201521.14703.50.camel@e102109-lin.cambridge.arm.com>
	 <1267220429.23523.1811.camel@pasglop>
	 <20100226214908.GD23933@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 28 Feb 2010 11:24:07 +1100
Message-ID: <1267316647.23523.1852.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-02-26 at 21:49 +0000, Russell King - ARM Linux wrote:
> On Sat, Feb 27, 2010 at 08:40:29AM +1100, Benjamin Herrenschmidt wrote:
> > Hrm, the DMA API certainly doesn't handle the I$/D$ coherency on
> > powerpc.. I'm afraid that whole cache handling stuff is totally
> > inconsistent since different archs have different expectations here.
> 
> It doesn't on ARM either.

Ok, pfiew :-)

So far, my understanding with I$/D$ is that we only care in a few cases
which is executing of an mmap'ed piece of executable that is -not- being
written to, and swap.

I -think- that in both cases, the page cache always pops up a new page
with PG_arch_1 clear before the driver gets to either DMA or PIO to it
when faulted the first time around, before any PTE is inserted.

So the current approach on powerpc with I$/D$ should work fine, and it
-might- make sense to use a similar one on PIPT ARM, provided we don't
have expectations of the I$/D$ coherency being maintained on
-subsequent- writes (PIO or DMA either) to such a page by the same
program transparently by the kernel.

There's two potential problems with the approach, and maybe more that I
have missed though. One is the case of a networked filesystem where the
executable pages are modified remotely. However, I would expect such a
program to invalidate the PTE mappings before making the change visible,
so we -do- get a chance to re-flush provided something clears PG_arch_1.

Then, there's In the case of a multithread app, where one thread does
the cache flush and another thread then executes, the earlier ARMs
without broadcast ops have a potential problem there. In fact, some
variant of PowerPC 440 have the same problem and some people are
(ab)using those for SMP setups I'm being told.

For that case, I see two options. One is a big hammer but would make
existing code work to "most" extent: Don't allow a page to be both
writable and executable. Ping-pong the page permission lazily and flush
when transitioning from write to exec.

That means using a spare bit for Linux _PAGE_RW separate from your real
RW bit I suppose, since you have HW loaded PTEs (on 440 it's easier
since we SW load, we can do the fixup there, though it has a perf impact
obviously).

Another option would be to make some syscall mandatory to "sync" caches
which could then do IPIs or whatever else is needed. But that would
require changing existing userspace code.



