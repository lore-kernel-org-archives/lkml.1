Return-Path: <linux-kernel-owner+w=401wt.eu-S1764735AbXGYOnB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764735AbXGYOnB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 10:43:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755154AbXGYOmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 10:42:51 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:51995 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754347AbXGYOms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 10:42:48 -0400
Date: Wed, 25 Jul 2007 15:46:56 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Marcin ??lusarz <marcin.slusarz@gmail.com>,
       Jean-Baptiste Vignaud <vignaud@xandmail.fr>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       shemminger <shemminger@linux-foundation.org>,
       linux-net <linux-net@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.20->2.6.21 - networking dies after random time
Message-ID: <20070725154656.54fd6f13@the-village.bc.nu>
In-Reply-To: <20070725135718.GB1843@ff.dom.local>
References: <JKE37W$0126317E099DF36884CC046B6F8A7AA9@xandmail.com>
	<20070629150759.GC2771@ff.dom.local>
	<4bacf17f0707222244p664e7a6ap850b3357a57d73c@mail.gmail.com>
	<20070724080534.GC18740@elte.hu>
	<20070724094202.GA11610@elte.hu>
	<alpine.LFD.0.999.0707241228291.3607@woody.linux-foundation.org>
	<20070724200431.GA22190@elte.hu>
	<1185322771.4175.102.camel@chaos>
	<20070725135718.GB1843@ff.dom.local>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > The code in question lib8390.c does
> > 
> > 	disable_irq();
> > 	fiddle_with_the_network_card_hardware()
> > 	enable_irq();
> ...
> > 
> > No idea how this affects the network card, as the code there must be
> > able to handle interrupts, which are not originated from the card due to
> > interrupt sharing.
> 
> I think, in this last yesterday's patch Ingo could be right, yet!
> The comment at the beginnig points this is done like that because
> of chip's slowness. And problems with timing are mysterious.
> 
> On the other hand author of this code didn't use spin_lock_irqsave
> for some reason, probably after testing this option too. So, I hope
> this is the right path, but alas, I'm not sure this patch has to
> prove this 100%.

The author (me) didn't use spin_lock_irqsave because the slowness of the
card means that approach caused horrible problems like losing serial data
at 38400 baud on some chips. Rememeber many 8390 nics on PCI were ISA
chips with FPGA front ends.

> Anyway, in my opinion this situation where interrupts could/have_to
> be used for such strange things should confirm the need of more
> options for handling irqs individually.

Ok the logic behind the 8390 is very simple:

Things to know
	- IRQ delivery is asynchronous to the PCI bus
	- Blocking the local CPU IRQ via spin locks was too slow
	- The chip has register windows needing locking work

So the path was once (I say once as people appear to have changed it
in the mean time and it now looks rather bogus if the changes to use
disable_irq_nosync_irqsave are disabling the local IRQ)


	Take the page lock
	Mask the IRQ on chip
	Disable the IRQ (but not mask locally- someone seems to have
		broken this with the lock validator stuff)
		[This must be _nosync as the page lock may otherwise
			deadlock us]
	Drop the page lock and turn IRQs back on
	
	At this point an existing IRQ may still be running but we can't
	get a new one

	Take the lock (so we know the IRQ has terminated) but don't mask
the IRQs on the processor
	Set irqlock [for debug]

	Transmit (slow as ****)

	re-enable the IRQ


We have to use disable_irq because otherwise you will get delayed
interrupts on the APIC bus deadlocking the transmit path.

Quite hairy but the chip simply wasn't designed for SMP and you can't
even ACK an interrupt without risking corrupting other parallel
activities on the chip.

Alan
