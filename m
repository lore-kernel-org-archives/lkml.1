Return-Path: <linux-kernel-owner+w=401wt.eu-S965154AbXBSXUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965154AbXBSXUf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 18:20:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965533AbXBSXUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 18:20:35 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3869 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965154AbXBSXUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 18:20:34 -0500
Date: Mon, 19 Feb 2007 23:20:20 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: "Michael K. Edwards" <medwards.linux@gmail.com>
Cc: Jose Goncalves <jose.goncalves@inov.pt>,
       Frederik Deweerdt <deweerdt@free.fr>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: Serial related oops
Message-ID: <20070219232020.GL27370@flint.arm.linux.org.uk>
Mail-Followup-To: "Michael K. Edwards" <medwards.linux@gmail.com>,
	Jose Goncalves <jose.goncalves@inov.pt>,
	Frederik Deweerdt <deweerdt@free.fr>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org
References: <20070220144814.GJ566@slug> <20070219150508.GD27370@flint.arm.linux.org.uk> <45D9D073.7020701@inov.pt> <20070219164200.GF27370@flint.arm.linux.org.uk> <45D9E46C.4030408@inov.pt> <f2b55d220702191237o2e6c4211u58a77deae1febe70@mail.gmail.com> <20070219205153.GH27370@flint.arm.linux.org.uk> <f2b55d220702191324s17c9cc87xc581a9beba2644f8@mail.gmail.com> <20070219213151.GJ27370@flint.arm.linux.org.uk> <f2b55d220702191416k479aa8c0gad4f42e306f26ecb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2b55d220702191416k479aa8c0gad4f42e306f26ecb@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 19, 2007 at 02:16:41PM -0800, Michael K. Edwards wrote:
> Right.  But as soon as you turn the source back on, in the postamble
> of the interrupt dispatch handler, it fires again.  At least on ARM,
> that gives you recursive hits to __irq_svc and a couple of nested
> calls within it.

I think something else is going on here.  I think you're getting
an interrupt for the UART, and another interrupt is also pending.

When the UART interrupt is handled, it is masked at the interrupt
controller, and the CPU mask is dropped.

The second interrupt comes in, and when you go to disable that
source, you inadvertently re-enable the UART interrupt, despite it
still being serviced.

This leads to the UART interrupt again triggering an IRQ.

Please show your interrupt controller (mask, unmask, mask_ack)
handling functions corresponding with the interrupt which your
UART is connected to.

> >> But its context is not.  Shared IRQ lines are a _problem_.  You cannot
> >> safely enable an IRQ until all devices that share it have had their
> >> ISRs installed, unless you can absolutely guarantee at a hardware
> >> level that the unitialized ones cannot assert the IRQ line.
> >
> >Linux assumes that all interrupt sources on a shared IRQ line are
> >disabled at the point in time when the kernel boots.  When a device
> >is to be used, an interrupt handler is installed and then the kernel
> >will enable the interrupt on the device, not before.
> 
> Linux assumes incorrectly in this instance.
> It would improve the
> kernel if all drivers' __init code were refactored into an
> IRQ-discovery-ISR-installation pass, followed by a
> chip-reset-data-structure-initialization pass, followed by a
> chip-configuration-driver-activation pass.  This is unlikely to happen
> overnight.

This shows that you don't actually have an understanding of the Linux
kernel boot, especially in respect of serial devices.  At boot, devices
are detected and initialised to a safe state, where they will not
spuriously generate interrupts.

When a userspace program opens a serial port, which can only happen
once the kernel boot has completed (ergo, devices have been initialised
and placed in a safe state) the interrupts are claimed, and enabled
at the source.

> In the meantime, weird UART states on entry into platform_device_init
> are a reality.

Yes, uart states are indeterminent at this point.  However, as soon as
the 8250 driver loads it takes control of the 8250 ports, and DISABLES
the interrupt on ALL ports found, LONG BEFORE any service handlers are
installed.

So, by the time the system is up and running _all_ 8250 ports have
had their IERs written with zero.  Interrupts disabled at source.

By the time you get to open any serial port, the initialisation has
completed.

> >We follow that rule in the 8250 driver - in fact, when we initialise
> >we ensure that interrupts are disabled on any devices we find.
> 
> No, you rely on the caller of serial8250_init to have punctured the
> abstraction

Can you add any other useless complex words into that sentence?

> and forced any and all UARTs to a state where they cannot
> possibly generate an IRQ.

That is being done already at initialisation time.

Now, please show your interrupt mask/unmask/mask_ack code, which is
where I believe your problem to lie.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
