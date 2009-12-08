Return-Path: <linux-kernel-owner+w=401wt.eu-S966626AbZLHWWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966626AbZLHWWd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 17:22:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755619AbZLHWWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 17:22:30 -0500
Received: from smtp102.sbc.mail.gq1.yahoo.com ([67.195.15.61]:20108 "HELO
	smtp102.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755564AbZLHWW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 17:22:29 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ee4BkJ4FC/dJ5HXcknVRdyM5lRl5bSI/gA6WyVxUHiIVh0dnT82zbv/uJldROYUu1s9zT5C9UjrNj4GA6mMnvsC41tMSAEZtdBy6520+Vlq5HcAsfnHofkzxBcPA07hYI4rSooTx8rwZqR2OoAfueOavRPi8LqOL5sCsAK6xNVE=  ;
X-Yahoo-SMTP: 2V1ThQ.swBDh24fWwg9PZFuY7TTwFsTuVtXZ.8DKSgQ-
X-YMail-OSG: dP52A1cVM1nMWEaz2duM1g_xFYiOQ59ToLYj_lYgfQ2WZel7gr4h.jFACZ.ZMoGSp9LxeHNZv_392Tz9jApIWvyQZ63AJqEl4AIpXjhuiE4sZzmZ5or44B7VPPRRvZgHh2PP3rK0HHR805pyC.Ag8jHCKfQJs1XgusV5nwLuCFcNw1Ar2StDFfLIx3DxQKdCFpsypXXJr.sV60QdRlncNHJpqbB2B6LOqpxX3fCWtVq7qIFvnquSafr7ZPdVF6nX
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Kenneth Johansson <kenneth@southpole.se>
Subject: Re: gpio gpio_to_irq
Date: Tue, 8 Dec 2009 14:22:24 -0800
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, alek.du@intel.com, tglx@linutronix.de
References: <1260187867.16040.35.camel@kenjo-laptop>
In-Reply-To: <1260187867.16040.35.camel@kenjo-laptop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200912081422.24656.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 December 2009, Kenneth Johansson wrote:

> Many gpio drivers use the set_irq_chained_handler() instead of calling
> request_irq to get the main gpio interrupt.

Right ... mostly those are microcontrollers, where the top level
IRQ controller is hooked up to a few dozen on-chip peripherals,
and several of them are GPIO controllers.  Most (or all!) external
IRQs come through GPIOs, with the more powerful ones offering some
control over trigger modes (which levels/edges) on the input side.


> But doing so on a shared pci 
> interrupt do not look like a good idea. 
> 
> Under what circumstance is set_irq_chained_handler allowed ? 

That's an IRQ question not a GPIO question.  I think the answer
to that question has likely been evolving over time... and that
you may be right about doing this over PCI.


> The next thing is that the drivers then registers a "fake" interrupt
> chip to make it possible for the gpio client to call request_irq with
> the irq number returned from gpio_to_irq().

Not that I've ever seen.  It's a real irq_chip.  The only odd
case is when the IRQs are enabled/disabled/acked over a slow
bus like I2C ... that's stuff the IRQ framework hasn't much
liked, it wants to call those methods with a hard spinlock.

For the more typical case of an on-chip IRQ peripheral, just
think of it as another layer to the IRQ dispatch tree.  There
can easily be two or more layers.  If one of the IRQ controllers
has additional duties, instead of only handling IRQ dispatch,
that's routine; it fits into power management and wakeup too.


> While using this interface is neat it do require that the gpio driver
> somehow can just take over a few irq numbers from the system. 
> 
> How is this supposed to be done??

Last I looked, IRQ numbering was a global system-wide policy.

So plug'n'play of IRQ controllers was ... awkward, along with
dynamic assignment of IRQ numbers.  True for all PCI-based IRQ
controllers.  Southbridge IRQs are often wrapped up in ACPI,
so those issues don't surface in most PCs.

Again, not a GPIO question, but an IRQ question.  (Or maybe an
x86 arch question.)


> the langwell driver reads a number 
> located at BAR1 and simply use that as the first irq number, hu?
> 
> others start to allocate from the top and so on. what is the correct way
> to do this on a x86 with a gpio device on the pci bus ?? 

Embedded platforms have typically done things like pre-allocate
a bunch of extra IRQ numbers, and then arrange to have each new
IRQ controller land in a board-assigned slot.  It can waste RAM,
but is mostly painless.

That's fine so long as you have a sane level of control over
system bootup, where board-specific logic can for example know
which external chips (and thus irq_chip controllers) exist.
(And maybe even arrange via Kconfig to alloc extra IRQ numbers
only as needed.)

When you don't have such a notion of "board" -- maybe punting
everything to ACPI or some other "hide the hardware from the
OS" abstraction -- I'm not clear on a good solution.

With ACPI, the notion of whether a given GPIO is used for its
IRQ capabilities is hidden in ACPI bytecode and not exposed to
Linux.  A lot of the ACPI event reports are from  GPIO IRQs;
input buttons and so on.  And a lot of that bytecode goes and
queries the GPIOs; I'd have to go re-read things, but a "GPE"
is intimately associated with a southbridge GPIO signal.  If
you disassemble the bytecode and read some handlers, you'll
see exactly what I mean.

So the x86 world has thus far punted on a lot of the (good!)
questions you're asking, since the main use of GPIOs on a PC
is wrapped up in ACPI southbridge support, and is seen only
indirectly by Linux or any operating system.

- Dave

