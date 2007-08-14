Return-Path: <linux-kernel-owner+w=401wt.eu-S1755322AbXHNIKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322AbXHNIKz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 04:10:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752535AbXHNIKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 04:10:40 -0400
Received: from www.osadl.org ([213.239.205.134]:39085 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751605AbXHNIKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 04:10:36 -0400
Subject: Re: [patch 3/3] genirq: mark io_apic level interrupts to avoid
	resend
From: Thomas Gleixner <tglx@linutronix.de>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Stable Team <stable@kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jean-Baptiste Vignaud <vignaud@xandmail.fr>,
       "marcin.slusarz" <marcin.slusarz@gmail.com>
In-Reply-To: <20070814071203.GA1702@ff.dom.local>
References: <20070812152213.551812576@inhelltoy.tec.linutronix.de>
	 <20070812152303.177006193@inhelltoy.tec.linutronix.de>
	 <20070813112821.GA2863@ff.dom.local> <1187006835.12828.112.camel@chaos>
	 <20070813135311.GB4026@ff.dom.local> <1187022620.12828.127.camel@chaos>
	 <20070814071203.GA1702@ff.dom.local>
Content-Type: text/plain
Date: Tue, 14 Aug 2007 10:10:32 +0200
Message-Id: <1187079032.12828.161.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-14 at 09:12 +0200, Jarek Poplawski wrote:
> > No, the point is that the resend is suppressed for all interrupts which
> > are marked with IRQ_LEVEL:
> > 
> >         /*
> >          * We do not resend level type interrupts. Level type
> >          * interrupts are resent by hardware when they are still
> >          * active.
> >          */
> >         if ((status & (IRQ_LEVEL | IRQ_PENDING | IRQ_REPLAY)) == IRQ_PENDING) {
> > 	....
> > 
> > This is not witchcraft, this is how the hardware works.
> 
> Sorry! It's probably something with my English: I like this flag very
> much! But I simply can't find where this flag is set for any irq using
> handle_level_irq, or, otherwise, can't understand why it's not set
> (because in this case I don't think not setting IRQ_PENDING by the
> handler should be enough).

handle_level_irq() does not set the PENDING bit on delayed disable.

> > 
> It's different because e.g. for x86_64 fasteoi level type irqs were
> masked during disable_irq, so there was very small probability any
> irq were skipped, plus the state of io_apic was different from this
> point (regarding this irq). Now it's for sure many interrupts could
> be 'missing'.

No. Let me explain:

Before delayed disable:

	irq_disable(); /* Mask in hardware */
	....
	-> Interrupt line is asserted. No interrupt due to hardware mask
	....
	irq_enable();  /* Unmask */
	
	-> When interrupt line is still active, then the interrupt is
	   invoked. Otherwise nothing happens

Delayed disable (with level fix):

	irq_disable(); /* Do not mask in hardware */
	....
	-> Interrupt line is asserted.
	---> interrupt handler is invoked: interrupt is masked in
	     hardware
	....
	irq_enable();  /* Unmask */
	
	-> When interrupt line is still active, then the interrupt is
	   invoked. Otherwise nothing happens

Can we agree, that this is the same ?

> BTW, of course, my knowledge of this is very limited, but I wonder
> about these level type irqs used e.g. by apics. 'Normal' chips hold
> some data until it's read by a driver, so there is something more
> needed than an ack by io_apic. But isn't there any possibility
> some level type irqs possible for IPIs or local interrupts (82489DX?)
> could be missing here? Are we sure there is no hardware using level
> type irqs in a similar way (drop after acking)?

Level type interrupts _are_ active as long as the hardware pin of the
interrupt line is driven by a device to the active level. 

When the hardware pin is kept at the active level by a device, the ACK
of the interrupt controller does not change the interrupt line of the
device. The interrupt comes back again immediately.

Edge type interrupts are different:

The interrupt is only triggered on the transition of the hardware pin
from inactive to active level. So the above scheme looks like:

Before delayed disable:

	irq_disable(); /* Mask in hardware */
	....
	-> Interrupt line is asserted. No interrupt due to hardware mask
	....
	irq_enable();  /* Unmask */
	
	-> The now unmasked interrupt becomes active and the interrupt
	   handler is invoked.

Delayed disable:

	irq_disable(); /* Do not mask in hardware */
	....
	-> Interrupt line is asserted.
	---> interrupt handler is invoked: interrupt is masked in
	     hardware, acknowledged and marked PENDING
	....
	irq_enable();  /* Unmask */
	
	-> On unmask the hardware does not invoke the interrupt, because
	   we acknowledged it above. Here we need to use the
	   hard-/soft-ware resend mechanism, otherwise the interrupt
	   would be lost

> > > there is no reason to endanger even a small number of users/admins
> > > for stresses like this, done to Marcin or Jean-Baptiste, when it's
> > > possible to do this safer without much changes.
> > 
> > Safer in what way ? 
> 
> Because, if there were a visible config option or kernel parameter
> e.g.  with a comment like "legacy level irq handling - obsolete",
> some people would be happy when they find it's useful for them, and
> you would know about the problem much sooner, as well.

Well, there is nothing legacy. level type interrupts do not need the
resend mechanism at all. This misfeature was introduced with the delayed
disable and went unnoticed until now.

	tglx


