Return-Path: <linux-kernel-owner+w=401wt.eu-S932797AbXBTB22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932797AbXBTB22 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 20:28:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932993AbXBTB22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 20:28:28 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:2382 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932797AbXBTB21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 20:28:27 -0500
Date: Tue, 20 Feb 2007 00:21:51 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: "Michael K. Edwards" <medwards.linux@gmail.com>
Cc: Jose Goncalves <jose.goncalves@inov.pt>,
       Frederik Deweerdt <deweerdt@free.fr>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: Serial related oops
Message-ID: <20070220002150.GA4653@flint.arm.linux.org.uk>
Mail-Followup-To: "Michael K. Edwards" <medwards.linux@gmail.com>,
	Jose Goncalves <jose.goncalves@inov.pt>,
	Frederik Deweerdt <deweerdt@free.fr>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org
References: <45D9D073.7020701@inov.pt> <20070219164200.GF27370@flint.arm.linux.org.uk> <45D9E46C.4030408@inov.pt> <f2b55d220702191237o2e6c4211u58a77deae1febe70@mail.gmail.com> <20070219205153.GH27370@flint.arm.linux.org.uk> <f2b55d220702191324s17c9cc87xc581a9beba2644f8@mail.gmail.com> <20070219213151.GJ27370@flint.arm.linux.org.uk> <f2b55d220702191416k479aa8c0gad4f42e306f26ecb@mail.gmail.com> <20070219232020.GL27370@flint.arm.linux.org.uk> <f2b55d220702191604y51dc4594ie0d7692c40764455@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2b55d220702191604y51dc4594ie0d7692c40764455@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 19, 2007 at 04:04:26PM -0800, Michael K. Edwards wrote:
> On 2/19/07, Russell King <rmk+lkml@arm.linux.org.uk> wrote:
> >The second interrupt comes in, and when you go to disable that
> >source, you inadvertently re-enable the UART interrupt, despite it
> >still being serviced.
> 
> Incorrect.  An attempt has been made to service the interrupt using
> the only ISR currently in the chain for that IRQ -- the ISR for the
> first UART.  That attempt was not successful, and when __do_irq
> unmasks the interrupt source preparatory to exiting interrupt context,
> __irq_svc is dispatched anew.

This can't happen because when __do_irq unmasks the interrupt source,
the CPU mask is set, thereby preventing any further interrupt exceptions
being taken.  This is done precisely to prevent this situation happening.

If you are seeing recursion for the same interrupt (two or more stack
frames containing asm_do_IRQ for that very same IRQ) then your interrupt
handling is buggy, plain and simple.

> >Please show your interrupt controller (mask, unmask, mask_ack)
> >handling functions corresponding with the interrupt which your
> >UART is connected to.
> 
> Don't have 'em handy; I'll be happy to post them when I do, perhaps
> later today.  I would hope they're pretty generic, though; it's a
> Feroceon core pretending to be an ARM926EJ-S, hooked to the usual
> half-assed Marvell imitation of an ARM licensed functional block.
> Trust me for the moment, it's the same IRQ line.

I don't doubt that it is on the same IRQ line - I have such setups here
and it works perfectly - multiple 8250 UARTs connected to a single
level-triggered interrupt input which also happens to be shared with
a SCSI host chip as well.  Absolutely no problems.

> If you don't enjoy this sort of forensics (which I
> for one do not, especially not when there is a project deadline
> looming and a Heisenbug starts firing 9 times out of 10), you might
> consider systematically installing ISRs that know how to shut
> everything up before turning on any interrupt sources at all.

I still say that your understanding is completely flawed.  Moreover,
you haven't read what I've said about the ordering of initialisation,
the stress on when we disable interrupts for the ports, etc.

> I'm not asking for anyone's help except in the
> let's-all-help-one-another spirit.

You're actually *not* helping.  You're causing utter confusion through
misunderstanding, but it seems you're not open to the possibility that
your understanding is flawed.

I'm offering to look through your code and point you at the source of
your issue for free.  Please don't throw that offer away without first
considering that maybe I have a clue about what's going on here.

> Now please take a second look at the backtrace before toasting me
> lightly again.

... which showed the port being opened well after system initialisation
of devices, including all serial ports - including disabling of their
interrupt source at the IER, has been completed.

> Mmm'kay?  Oh, and by the way -- is there an Alt-SysRq
> equivalent on an ARM serial console?

Yes, and it's the same for any serial console with functioning break
support.  You'll find it in Documentation/sysrq.txt, though it does
misleadingly say "PC style standard serial ports only" whereas the
reality is "where possible".

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
