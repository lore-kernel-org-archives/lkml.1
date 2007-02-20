Return-Path: <linux-kernel-owner+w=401wt.eu-S965571AbXBTAEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965571AbXBTAEa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 19:04:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965579AbXBTAEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 19:04:30 -0500
Received: from nz-out-0506.google.com ([64.233.162.226]:55980 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965571AbXBTAE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 19:04:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Ss+UTot++Rxa7CWt7E9NhJE1qc1v2U3aaTloaxM5SsU8PQ4Ev5VhXgYq5PnWJ5ZrdxTKWjeM/eY/VGo6Rq30vdvHAKP5pEu/SHpwUMEmVlz8APcgcNX0udrDPSt0XvKA3NKeazMEUjOTEuHMJCPrxAc35HKve6UUVA09CC7U9dc=
Message-ID: <f2b55d220702191604y51dc4594ie0d7692c40764455@mail.gmail.com>
Date: Mon, 19 Feb 2007 16:04:26 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Jose Goncalves" <jose.goncalves@inov.pt>,
       "Frederik Deweerdt" <deweerdt@free.fr>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: Serial related oops
In-Reply-To: <20070219232020.GL27370@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070220144814.GJ566@slug> <45D9D073.7020701@inov.pt>
	 <20070219164200.GF27370@flint.arm.linux.org.uk>
	 <45D9E46C.4030408@inov.pt>
	 <f2b55d220702191237o2e6c4211u58a77deae1febe70@mail.gmail.com>
	 <20070219205153.GH27370@flint.arm.linux.org.uk>
	 <f2b55d220702191324s17c9cc87xc581a9beba2644f8@mail.gmail.com>
	 <20070219213151.GJ27370@flint.arm.linux.org.uk>
	 <f2b55d220702191416k479aa8c0gad4f42e306f26ecb@mail.gmail.com>
	 <20070219232020.GL27370@flint.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/19/07, Russell King <rmk+lkml@arm.linux.org.uk> wrote:
> I think something else is going on here.  I think you're getting
> an interrupt for the UART, and another interrupt is also pending.

Correct.  An interrupt for the other UART on the same IRQ.

> When the UART interrupt is handled, it is masked at the interrupt
> controller, and the CPU mask is dropped.

Correct.

> The second interrupt comes in, and when you go to disable that
> source, you inadvertently re-enable the UART interrupt, despite it
> still being serviced.

Incorrect.  An attempt has been made to service the interrupt using
the only ISR currently in the chain for that IRQ -- the ISR for the
first UART.  That attempt was not successful, and when __do_irq
unmasks the interrupt source preparatory to exiting interrupt context,
__irq_svc is dispatched anew.

> This leads to the UART interrupt again triggering an IRQ.

Right.  The _second_ UART's interrupt.  There's another problem with
these UARTs having to do with the implementor's inability to read and
follow a bog-standard twenty-year-old spec without asking software to
fix up corner cases, but that's another backtrace for another day.

> Please show your interrupt controller (mask, unmask, mask_ack)
> handling functions corresponding with the interrupt which your
> UART is connected to.

Don't have 'em handy; I'll be happy to post them when I do, perhaps
later today.  I would hope they're pretty generic, though; it's a
Feroceon core pretending to be an ARM926EJ-S, hooked to the usual
half-assed Marvell imitation of an ARM licensed functional block.
Trust me for the moment, it's the same IRQ line.

> This shows that you don't actually have an understanding of the Linux
> kernel boot, especially in respect of serial devices.  At boot, devices
> are detected and initialised to a safe state, where they will not
> spuriously generate interrupts.

Sorry, 'taint so.  Not unless the chip support droid has put the right
stuff in arch/arm/mach-foo.  LKML is littered with the fall-out of the
decision to trust whoever jumped to main() to have left the hardware
in a sane state.  If you don't enjoy this sort of forensics (which I
for one do not, especially not when there is a project deadline
looming and a Heisenbug starts firing 9 times out of 10), you might
consider systematically installing ISRs that know how to shut
everything up before turning on any interrupt sources at all.

As I said, this is not going to happen overnight, and is not even
particularly in the economic interest of people who get paid by the
hour to wear bringup wizard hats.  That category currently includes
me, but I am intensely bored with this game and aspire to greater
things.

> When a userspace program opens a serial port, which can only happen
> once the kernel boot has completed (ergo, devices have been initialised
> and placed in a safe state) the interrupts are claimed, and enabled
> at the source.

As you can see from the console dump I posted (which begins with
"Freeing init memory: 92K" and ends with do_exit -> init -> sys_open,
which is obviously sys_open("/dev/console")), this happens long before
userspace comes into the picture.  Our 8250.c has some nasty hacks in
it but otherwise this call chain is from a very nearly vanilla
2.6.16.recent.

We've already worked around this on our board, and the whole kit and
kaboodle will eventually be posted to linux-arm-kernel in tidy patches
when my client lets me spend billable hours on it (immediately after
the damn thing passes its first functional test, long before it
ships).  I'm not asking for anyone's help except in the
let's-all-help-one-another spirit.  I'm trying to help with root cause
analysis of Frederik's (Jose's?) fandango on core.  If it's not
relevant, my apologies; and although it goes without saying, I salute
you for both the serial driver and the ARM port.

Now please take a second look at the backtrace before toasting me
lightly again.  Mmm'kay?  Oh, and by the way -- is there an Alt-SysRq
equivalent on an ARM serial console?

Cheers,
- Michael
