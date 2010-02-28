Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936543Ab0B1TRT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 14:17:19 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:57819 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S936491Ab0B1TRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 14:17:14 -0500
Date: Sun, 28 Feb 2010 20:17:06 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       linux-usb@vger.kernel.org, "Mankad,Maulik Ojas" <x0082077@ti.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Ming Lei <tom.leiming@gmail.com>,
       Sebastian Siewior <bigeasy@linutronix.de>,
       Oliver Neukum <oliver@neukum.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Shilimkar,Santosh" <santosh.shilimkar@ti.com>,
       Greg KH <greg@kroah.com>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: USB mass storage and ARM cache coherency
Message-ID: <20100228191706.GB4853@elf.ucw.cz>
References: <1266979632.23523.1668.camel@pasglop>
 <1267201521.14703.50.camel@e102109-lin.cambridge.arm.com>
 <1267220429.23523.1811.camel@pasglop>
 <20100226214908.GD23933@n2100.arm.linux.org.uk>
 <1267316647.23523.1852.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267316647.23523.1852.camel@pasglop>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> There's two potential problems with the approach, and maybe more that I
> have missed though. One is the case of a networked filesystem where the
> executable pages are modified remotely. However, I would expect such a
> program to invalidate the PTE mappings before making the change visible,
> so we -do- get a chance to re-flush provided something clears PG_arch_1.
> 
> Then, there's In the case of a multithread app, where one thread does
> the cache flush and another thread then executes, the earlier ARMs
> without broadcast ops have a potential problem there. In fact, some
> variant of PowerPC 440 have the same problem and some people are
> (ab)using those for SMP setups I'm being told.
> 
> For that case, I see two options. One is a big hammer but would make
> existing code work to "most" extent: Don't allow a page to be both
> writable and executable. Ping-pong the page permission lazily and flush
> when transitioning from write to exec.
> 
> That means using a spare bit for Linux _PAGE_RW separate from your real
> RW bit I suppose, since you have HW loaded PTEs (on 440 it's easier
> since we SW load, we can do the fixup there, though it has a perf impact
> obviously).
> 
> Another option would be to make some syscall mandatory to "sync" caches
> which could then do IPIs or whatever else is needed. But that would
> require changing existing userspace code.

Or you could do first option by default, and add mmap flag that says
that application is responsible for cross-cpu cache flushes...?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
