Return-Path: <linux-kernel-owner+w=401wt.eu-S932703AbXBSVYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932703AbXBSVYZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 16:24:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932706AbXBSVYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 16:24:25 -0500
Received: from an-out-0708.google.com ([209.85.132.242]:14386 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932703AbXBSVYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 16:24:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gVScRl0rwE8OddMOunBQEDHXunhO+d4SfFlaVXG7Vubb+nPDGAS/0n3Q14P3pYgvKUi/ZYbacWQJteveApEYDRASR8ZDKYMk31KjBBQmyzB4vrq0iDCW6VHl4WQMqoIb2sT75CYCubSd4tv17PVWau3/5o5KF2khugAaGJdIgwk=
Message-ID: <f2b55d220702191324s17c9cc87xc581a9beba2644f8@mail.gmail.com>
Date: Mon, 19 Feb 2007 13:24:17 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Michael K. Edwards" <medwards.linux@gmail.com>,
       "Jose Goncalves" <jose.goncalves@inov.pt>,
       "Frederik Deweerdt" <deweerdt@free.fr>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: Serial related oops
In-Reply-To: <20070219205153.GH27370@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070220132909.GD566@slug> <20070220142442.GF566@slug>
	 <20070219143520.GB27370@flint.arm.linux.org.uk>
	 <20070220144814.GJ566@slug>
	 <20070219150508.GD27370@flint.arm.linux.org.uk>
	 <45D9D073.7020701@inov.pt>
	 <20070219164200.GF27370@flint.arm.linux.org.uk>
	 <45D9E46C.4030408@inov.pt>
	 <f2b55d220702191237o2e6c4211u58a77deae1febe70@mail.gmail.com>
	 <20070219205153.GH27370@flint.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/19/07, Russell King <rmk+lkml@arm.linux.org.uk> wrote:
> On Mon, Feb 19, 2007 at 12:37:00PM -0800, Michael K. Edwards wrote:
> > What we've seen on our embedded ARM is that enabling an interrupt that
> > is shared between multiple UARTs, at a stage when you have not set up
> > all the data structures touched by the ISR and softirq, can have
> > horrible consequences, including soft lockups and fandangos on core.
>
> Incorrect.  We have:
>
> 1. registered an interrupt handler at this point.
> 2. disabled interrupts (we're under the spin lock)

setup_irq() is where things go wrong, at least for us, at least on
2.6.16.x.  Interrupts are not disabled at the point in request_irq()
when the interrupt controller is poked to enable the IRQ source.  If
you're lucky, and you're on an architecture where the UART interrupt
is properly level-triggered, and the worst thing that happens when you
attempt to service an interrupt that isn't yours is that it stays on,
then you get a soft lockup with two or three recursive __irq_svc hits
in the backtrace.  If you're not lucky you do a fandango on core.

> So, no interrupt will be seen by the CPU since the interrupt is masked.

The interrupt would need to be masked for the entire duration of the
outer loop that calls serial8250_init() or the equivalent for all
platform devices that share the IRQ.

> The test is intentionally designed to be safe from the interrupt
> generation point of view.

But its context is not.  Shared IRQ lines are a _problem_.  You cannot
safely enable an IRQ until all devices that share it have had their
ISRs installed, unless you can absolutely guarantee at a hardware
level that the unitialized ones cannot assert the IRQ line.  That does
not apply to any device that might have been touched by the bootloader
or the early init code, especially a UART.

Cheers,
- Michael
