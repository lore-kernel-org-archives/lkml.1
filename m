Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030984Ab0B1Abh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 19:31:37 -0500
Received: from gate.crashing.org ([63.228.1.57]:55397 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030966Ab0B1Abg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 19:31:36 -0500
Subject: Re: USB mass storage and ARM cache coherency
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       linux-usb@vger.kernel.org, "Mankad, Maulik Ojas" <x0082077@ti.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Ming Lei <tom.leiming@gmail.com>,
       Sebastian Siewior <bigeasy@linutronix.de>,
       Oliver Neukum <oliver@neukum.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
       Pavel Machek <pavel@ucw.cz>, Greg KH <greg@kroah.com>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
In-Reply-To: <20100226220351.GE23933@n2100.arm.linux.org.uk>
References: <1266445892.16346.306.camel@pasglop>
	 <1266599755.32546.38.camel@e102109-lin.cambridge.arm.com>
	 <1266979170.23523.1660.camel@pasglop>
	 <1267202674.14703.70.camel@e102109-lin.cambridge.arm.com>
	 <1267220980.23523.1820.camel@pasglop>
	 <20100226220351.GE23933@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 28 Feb 2010 11:29:53 +1100
Message-ID: <1267316993.23523.1857.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-02-26 at 22:03 +0000, Russell King - ARM Linux wrote:
> On Sat, Feb 27, 2010 at 08:49:40AM +1100, Benjamin Herrenschmidt wrote:
> > It will deadlock if you use normal IRQs. I don't see a good way around
> > that other than using a higher-level type of IRQs. I though ARM has
> > something like that (FIQs ?). Can you use those guys for IPIs ?
> 
> If the hardware did support using FIQs for IPIs, this would not be
> desirable because then it takes it away from the SoC folk to do what
> they will with it.
> 
> In the past, it's been used as a fast CPU-driven "DMA" interface -
> some SoCs have been wired up in such a way that's the only use
> available for the FIQ.

This is an issue indeed.

> The other problem we'd encounter using FIQs for IPIs is that some IPIs
> need to take locks - and in order to make that safe, we'd either need
> another class of locks which disable IRQs and FIQs together, or we'd
> need to disable FIQs everywhere we disable IRQs - at which point FIQs
> become utterly pointless.

That's solvable easily :-) I mentioned having potentially to deal with a
similar problem with people using PowerPC 440 for SMP (doesn't broadcast
cache ops either). 440 has critical interrupts, which are akin to FIQs.

The trick here is that you don't use -only- critical interrupts for
IPIs. You use normal interrupts for all the current IPI types. You -add-
a fast one using critical interrupts specifically for cache ops, with a
very fast asm only path.

This works for us because masking interrupts doesn't mask critical
interrupts (it's a separate mask bit in our MSR). If that isn't the case
with FIQs then the whole idea is moot.

> (There only differences between FIQ and IRQ are:
>  - on simultaneous raising of both, the FIQ will be called before the IRQ.
>  - each has its own (single) vector.
>  - invocation of FIQ masks IRQ.
> 
> What I'm saying is that what gives FIQ an advantage for SoC people is
> that it's bare bones light weight and therefore extremely fast - as soon
> as you load it up with additional complexity, it becomes less useful.)

I understand.

Then Catalin idea of tricking the cache with load and stores would work
for the D$ side of thing. The I$ side of thing probably still needs IPIs
though, and you might need to use non-blocking async SMP call function
for that if you're going to do it from set_pte_at() instead of
update_mmu_cache() since the later is racy. In any case, it's a lot less
of a deadlock nest than the D$ side which needs to be dealt with in the
DMA ops, called below layers of driver and subsystem locks.

Note: Somebody at ARM needs to be severely beaten up for coming up with
that SMP scheme without broadcast cache ops and not also mandating some
kind FIQ IPI scheme that isn't masked with normal interrupts :-)

Cheers,
Ben.

