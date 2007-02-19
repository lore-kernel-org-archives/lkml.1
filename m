Return-Path: <linux-kernel-owner+w=401wt.eu-S932643AbXBSVcF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932643AbXBSVcF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 16:32:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932706AbXBSVcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 16:32:04 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3958 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932643AbXBSVcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 16:32:02 -0500
Date: Mon, 19 Feb 2007 21:31:52 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: "Michael K. Edwards" <medwards.linux@gmail.com>
Cc: Jose Goncalves <jose.goncalves@inov.pt>,
       Frederik Deweerdt <deweerdt@free.fr>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: Serial related oops
Message-ID: <20070219213151.GJ27370@flint.arm.linux.org.uk>
Mail-Followup-To: "Michael K. Edwards" <medwards.linux@gmail.com>,
	Jose Goncalves <jose.goncalves@inov.pt>,
	Frederik Deweerdt <deweerdt@free.fr>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org
References: <20070220142442.GF566@slug> <20070219143520.GB27370@flint.arm.linux.org.uk> <20070220144814.GJ566@slug> <20070219150508.GD27370@flint.arm.linux.org.uk> <45D9D073.7020701@inov.pt> <20070219164200.GF27370@flint.arm.linux.org.uk> <45D9E46C.4030408@inov.pt> <f2b55d220702191237o2e6c4211u58a77deae1febe70@mail.gmail.com> <20070219205153.GH27370@flint.arm.linux.org.uk> <f2b55d220702191324s17c9cc87xc581a9beba2644f8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2b55d220702191324s17c9cc87xc581a9beba2644f8@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 19, 2007 at 01:24:17PM -0800, Michael K. Edwards wrote:
> On 2/19/07, Russell King <rmk+lkml@arm.linux.org.uk> wrote:
> >On Mon, Feb 19, 2007 at 12:37:00PM -0800, Michael K. Edwards wrote:
> >> What we've seen on our embedded ARM is that enabling an interrupt that
> >> is shared between multiple UARTs, at a stage when you have not set up
> >> all the data structures touched by the ISR and softirq, can have
> >> horrible consequences, including soft lockups and fandangos on core.
> >
> >Incorrect.  We have:
> >
> >1. registered an interrupt handler at this point.
> >2. disabled interrupts (we're under the spin lock)
> 
> setup_irq() is where things go wrong, at least for us, at least on
> 2.6.16.x.  Interrupts are not disabled at the point in request_irq()
> when the interrupt controller is poked to enable the IRQ source.  If
> you're lucky, and you're on an architecture where the UART interrupt
> is properly level-triggered, and the worst thing that happens when you
> attempt to service an interrupt that isn't yours is that it stays on,
> then you get a soft lockup with two or three recursive __irq_svc hits
> in the backtrace.  If you're not lucky you do a fandango on core.

That should not happen if your interrupt handling is correct - okay, you
might get an interrupt at that point, but while servicing that interrupt
the source will be disabled on the interrupt controller.

You should _never_ _ever_ get recusive interrupts for the same interrupt
source.  Ever.  If you do, your platforms interrupt handling is seriously
buggy.

> But its context is not.  Shared IRQ lines are a _problem_.  You cannot
> safely enable an IRQ until all devices that share it have had their
> ISRs installed, unless you can absolutely guarantee at a hardware
> level that the unitialized ones cannot assert the IRQ line.

Linux assumes that all interrupt sources on a shared IRQ line are
disabled at the point in time when the kernel boots.  When a device
is to be used, an interrupt handler is installed and then the kernel
will enable the interrupt on the device, not before.

We follow that rule in the 8250 driver - in fact, when we initialise
we ensure that interrupts are disabled on any devices we find.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
