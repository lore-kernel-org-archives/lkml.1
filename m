Return-Path: <linux-kernel-owner+w=401wt.eu-S1756958AbZLIEnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756958AbZLIEnY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 23:43:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756844AbZLIEnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 23:43:18 -0500
Received: from mail.southpole.se ([193.12.106.18]:51580 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755917AbZLIEnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 23:43:16 -0500
Subject: Re: gpio gpio_to_irq
From: Kenneth Johansson <kenneth@southpole.se>
To: David Brownell <david-b@pacbell.net>
Cc: linux-kernel@vger.kernel.org, alek.du@intel.com, tglx@linutronix.de
In-Reply-To: <200912081422.24656.david-b@pacbell.net>
References: <1260187867.16040.35.camel@kenjo-laptop>
	 <200912081422.24656.david-b@pacbell.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Dec 2009 05:43:21 +0100
Message-ID: <1260333801.26900.37.camel@kenjo-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-Assp-ID: assp.southpole.se (33802-00479)
X-Assp-Version: 1.6.1.3(1.0.00)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-08 at 14:22 -0800, David Brownell wrote:
> On Monday 07 December 2009, Kenneth Johansson wrote:
> > But doing so on a shared pci 
> > interrupt do not look like a good idea. 
> > 
> > Under what circumstance is set_irq_chained_handler allowed ? 
> 
> That's an IRQ question not a GPIO question.  I think the answer
> to that question has likely been evolving over time... and that
> you may be right about doing this over PCI.

yes the irq thing is the only part of the gpio abstraction I have issue
with so this is basically all about that part. It all originates from
the gpio_to_irq function and what that one is supposed to return. 

> > The next thing is that the drivers then registers a "fake" interrupt
> > chip to make it possible for the gpio client to call request_irq with
> > the irq number returned from gpio_to_irq().
> 
> Not that I've ever seen.  It's a real irq_chip.

I had it in quotes as I have a mental block on thinking of it as an
interrupt controller but you are right it can be view as a simple
controller. 

> > While using this interface is neat it do require that the gpio driver
> > somehow can just take over a few irq numbers from the system. 
> > 
> > How is this supposed to be done??
> 
> Last I looked, IRQ numbering was a global system-wide policy.
> 
> So plug'n'play of IRQ controllers was ... awkward, along with
> dynamic assignment of IRQ numbers.  True for all PCI-based IRQ
> controllers.  Southbridge IRQs are often wrapped up in ACPI,
> so those issues don't surface in most PCs.
> 
> Again, not a GPIO question, but an IRQ question.  (Or maybe an
> x86 arch question.)

Yes I has hoped that the "overlord of low level hacking on
x86" (Gleixner) would bite but no such luck.

> 
> > the langwell driver reads a number 
> > located at BAR1 and simply use that as the first irq number, hu?
> > 
> > others start to allocate from the top and so on. what is the correct way
> > to do this on a x86 with a gpio device on the pci bus ?? 
> 
> Embedded platforms have typically done things like pre-allocate
> a bunch of extra IRQ numbers, and then arrange to have each new
> IRQ controller land in a board-assigned slot.  It can waste RAM,
> but is mostly painless.
> 
> That's fine so long as you have a sane level of control over
> system bootup, where board-specific logic can for example know
> which external chips (and thus irq_chip controllers) exist.
> (And maybe even arrange via Kconfig to alloc extra IRQ numbers
> only as needed.)
> 
> When you don't have such a notion of "board" -- maybe punting
> everything to ACPI or some other "hide the hardware from the
> OS" abstraction -- I'm not clear on a good solution.

I wish the genirq had an allocation strategy for the irq numbers Then
that could basically be used by any gpio driver on any arch. basically
irq_get_free() would solve it. 

Well I have to investigate more how msi interrupts is done as they also
need to allocate a new irq number whenever a pci device turns it on.

I just hoped I had missed something that would make this problem go
away. 




