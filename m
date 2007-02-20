Return-Path: <linux-kernel-owner+w=401wt.eu-S932808AbXBTCRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932808AbXBTCRu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 21:17:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932810AbXBTCRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 21:17:50 -0500
Received: from an-out-0708.google.com ([209.85.132.248]:7654 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932808AbXBTCRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 21:17:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SgbT99xkQdFnD3R21pqQXjPGKpsZWrw3Or0ZlcYhDfhuuUVyoE2oTyim6/25IeCSCuI+265dJQ6qBNQ/RPOhPzMdNwoUupkVOdoXY+bcDUSDSe1gdIN5piWekgsOeQPqkq4vHScTPRtOkrLg0DPl77HPzJh/MfvKMnxTFrqFshw=
Message-ID: <f2b55d220702191817g3e0929a0xabefbf3e108566a8@mail.gmail.com>
Date: Mon, 19 Feb 2007 18:17:47 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Michael K. Edwards" <medwards.linux@gmail.com>,
       "Jose Goncalves" <jose.goncalves@inov.pt>,
       "Frederik Deweerdt" <deweerdt@free.fr>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: Serial related oops
In-Reply-To: <20070220002150.GA4653@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45D9D073.7020701@inov.pt> <45D9E46C.4030408@inov.pt>
	 <f2b55d220702191237o2e6c4211u58a77deae1febe70@mail.gmail.com>
	 <20070219205153.GH27370@flint.arm.linux.org.uk>
	 <f2b55d220702191324s17c9cc87xc581a9beba2644f8@mail.gmail.com>
	 <20070219213151.GJ27370@flint.arm.linux.org.uk>
	 <f2b55d220702191416k479aa8c0gad4f42e306f26ecb@mail.gmail.com>
	 <20070219232020.GL27370@flint.arm.linux.org.uk>
	 <f2b55d220702191604y51dc4594ie0d7692c40764455@mail.gmail.com>
	 <20070220002150.GA4653@flint.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/19/07, Russell King <rmk+lkml@arm.linux.org.uk> wrote:
> This can't happen because when __do_irq unmasks the interrupt source,
> the CPU mask is set, thereby preventing any further interrupt exceptions
> being taken.  This is done precisely to prevent this situation happening.
>
> If you are seeing recursion for the same interrupt (two or more stack
> frames containing asm_do_IRQ for that very same IRQ) then your interrupt
> handling is buggy, plain and simple.

Imaginable.  I'll look at the mask/unmask code.  Thanks.

> I don't doubt that it is on the same IRQ line - I have such setups here
> and it works perfectly - multiple 8250 UARTs connected to a single
> level-triggered interrupt input which also happens to be shared with
> a SCSI host chip as well.  Absolutely no problems.

Can you do me a favor?  In the sys_open("/dev/console") path, turn on
the right bits in that second uart's IER, then insert a sleep in
request_irq or something (wherever seems best based on that
backtrace), and feed enough characters into the second UART during
that sleep to generate an IRQ.  Do you not get the same soft lockup?

> I still say that your understanding is completely flawed.  Moreover,
> you haven't read what I've said about the ordering of initialisation,
> the stress on when we disable interrupts for the ports, etc.

Well, all I can say is that that's a real backtrace and it shouldn't
be hard to reproduce if it's anything other than a broken interrupt
controller or broken code called by the __do_irq postamble.  I don't
see any platform-provided unmask routines in that backtrace, but maybe
it got inlined; I'll go back and check.

> You're actually *not* helping.  You're causing utter confusion through
> misunderstanding, but it seems you're not open to the possibility that
> your understanding is flawed.

Still open, though it's a pity you're more interested in my flawed
understanding that in the possibility that the kernel could be
systematically made more robust against hardware bugs and coding
errors by the simple expedient of putting all the ISRs in before
turning on any IRQ that might be shared.  Or are you telling me that's
already been done?  (Yes, I am aware that this interacts
entertainingly with hot-plug PCI.  Yes, I am aware that there is a
limit to how much software can fix stupid hardware.  But surely there
is room for an emergency IRQ suppressor to let chip initialization
code kick in and force the hardware to a known state.)

> I'm offering to look through your code and point you at the source of
> your issue for free.  Please don't throw that offer away without first
> considering that maybe I have a clue about what's going on here.

I appreciate that offer, and I hope to take advantage of it as soon as
I have the source code at my fingertips (not just the chat log where I
recorded the backtrace).

> ... which showed the port being opened well after system initialisation
> of devices, including all serial ports - including disabling of their
> interrupt source at the IER, has been completed.

Now that you mention it, the backtrace I sent is the
serial8250_startup one, not the serial8250_init one.  Sorry, this
one's probably an artifact of brain damage specific to this UART.  I
need to dig through a different account to find the init-path example;
but in either case, we're getting a new interrupt during the __do_irq
postamble.  If you're telling me that that shouldn't happen, what
should the backtrace for a soft lockup due to a stuck level-triggered
IRQ look like on ARM?

> Yes, and it's the same for any serial console with functioning break
> support.  You'll find it in Documentation/sysrq.txt, though it does
> misleadingly say "PC style standard serial ports only" whereas the
> reality is "where possible".

Thank you very much; this will help me get to the bottom of some other
chip-support nastiness on this device.

Cheers,
- Michael
