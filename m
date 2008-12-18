Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752568AbYLRQvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568AbYLRQvW (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 11:51:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750892AbYLRQvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 11:51:09 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33457 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbYLRQvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 11:51:08 -0500
Date: Thu, 18 Dec 2008 17:52:55 +0100
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-acpi@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>
Subject: Re: irqs_disabled() vs ACPI interpreter vs suspend
Message-ID: <20081218165255.GD16115@elf.ucw.cz>
References: <20081125110508.GA1943@elf.ucw.cz> <200812170040.07977.rjw@sisk.pl> <alpine.LFD.2.00.0812180107150.17738@localhost.localdomain> <200812181732.18023.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812181732.18023.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > to answer your question "what happens at boot"...
> > 
> > interrupts are enabled in start_kernel()
> > well before the ACPI interpreter is started
> > up in a subsys_initcall().
> > 
> > The first use of the interpreter indeed allocates memory
> > (as every invocation of acpi_evaluate_object() does)
> > to evaluate _PIC
> > ie. when we print out "ACPI: Using IOAPIC for interrupt routing".
> > 
> > So one would first think we could WARN_ON(irqs_disabled())
> > right at acpi_evaluate_object(), or at any external
> > entry to the AML interpreter.
> > 
> > But _GTS and _BFS are counter-examples --
> > they are ONLY evaluated with interrupts OFF,
> > since they are between the invocation of arch_suspend_disable_irqs()
> > and arch_suspend_enable_irqs().  I believe that they are the
> > ONLY counter-examples, and for those we'd conceivably
> > WARN_ON(!irqs_disabled).
> > 
> > But at resume...
> > irqrouter_resume() is called to restore ACPI PCI Interrupt Link Devices
> > while we still have interrupts disabled.  If we called it after interrupts
> > were enabled, then an incorrectly resumed link could cause a
> > screaming interrupt.
> > 
> > This is different from boot-time.  At boot time
> > we disable all the links b/c we know that the drivers
> > that use them will all request_irq() and we'll set
> > up the links one by one at that time.
> > 
> > Originally we had planned for suspend to be like boot --
> > every driver would free_irq() at .suspend
> > and request_irq() at .resume -- indirectly for pci devices
> > via pci_enable_device()...
> > This would leave the Links disabled at suspend time, like we
> > disable them at boot time -- and then the request_irq()'s would
> > come in from the resumed drivers and the links would be re-programmed.
> > I don't think we succeeded here, and IIR Linus didn't like our
> > suggestion that every driver must do something, rather than do nothing....
> > So the irqrouter_resume safety-net remains.
> > 
> > But restoring a PCI Interrupt Link Device evaluates _CRS, _PRS, _SRS --
> > general methods which are also invoked at other times with
> > interrupts enabled.  So for those we'd not be able to WARN_ON()
> > for either irqs enabled or disabled:-(
> > 
> > I have to think about irqrouter_resume a bit.
> > I don't like it, but I don't see an alternative -- unless we
> > do something like ENFORCE all users of the links have to
> > stop using them at suspend, so we can _DIS them,
> > and they must request their IRQs at resume
> > like they do at boot...
> 
> Well, that was my question to Linus in a recent discussion.
> 
> I see some technical reasons to require drivers to free IRQs during
> suspend.  First, the issue above.  Second, some removable devices may not
> even be present during resume while we may still think they use an IRQ
> (or is that impossible for some reason?).
> 
> Now, _if_ we decide we want devices to free IRQs during suspend, we can make
> the core do that, so that the drivers won't have to worry about it.

How can we make core do that?

I think that would be everyones prefered suggestion:

Linus: happy, because drivers don't have to do anything

me, Len: happy, because interrupts are freed over suspend

...but I don't see how to do that easily&nicely. AFAICT currently
drivers do something like

private_struct->my_interrupt = register_irq()...

If we put my_interrupt in struct device (or somewhere) we could handle
99% devices that have just one interrupt nicely... maybe that's good
enough? (And the rest can free/register them by hand without telling core).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
