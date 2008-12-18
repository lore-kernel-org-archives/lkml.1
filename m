Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752252AbYLRQc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252AbYLRQc6 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 11:32:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751380AbYLRQcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 11:32:46 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40523 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212AbYLRQcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 11:32:45 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: Re: irqs_disabled() vs ACPI interpreter vs suspend
Date: Thu, 18 Dec 2008 17:32:17 +0100
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, pavel@suse.cz,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-acpi@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>
References: <20081125110508.GA1943@elf.ucw.cz> <200812170040.07977.rjw@sisk.pl> <alpine.LFD.2.00.0812180107150.17738@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0812180107150.17738@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812181732.18023.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 18 of December 2008, Len Brown wrote:
> Rafael,
> 
> to answer your question "what happens at boot"...
> 
> interrupts are enabled in start_kernel()
> well before the ACPI interpreter is started
> up in a subsys_initcall().
> 
> The first use of the interpreter indeed allocates memory
> (as every invocation of acpi_evaluate_object() does)
> to evaluate _PIC
> ie. when we print out "ACPI: Using IOAPIC for interrupt routing".
> 
> So one would first think we could WARN_ON(irqs_disabled())
> right at acpi_evaluate_object(), or at any external
> entry to the AML interpreter.
> 
> But _GTS and _BFS are counter-examples --
> they are ONLY evaluated with interrupts OFF,
> since they are between the invocation of arch_suspend_disable_irqs()
> and arch_suspend_enable_irqs().  I believe that they are the
> ONLY counter-examples, and for those we'd conceivably
> WARN_ON(!irqs_disabled).
> 
> But at resume...
> irqrouter_resume() is called to restore ACPI PCI Interrupt Link Devices
> while we still have interrupts disabled.  If we called it after interrupts
> were enabled, then an incorrectly resumed link could cause a
> screaming interrupt.
> 
> This is different from boot-time.  At boot time
> we disable all the links b/c we know that the drivers
> that use them will all request_irq() and we'll set
> up the links one by one at that time.
> 
> Originally we had planned for suspend to be like boot --
> every driver would free_irq() at .suspend
> and request_irq() at .resume -- indirectly for pci devices
> via pci_enable_device()...
> This would leave the Links disabled at suspend time, like we
> disable them at boot time -- and then the request_irq()'s would
> come in from the resumed drivers and the links would be re-programmed.
> I don't think we succeeded here, and IIR Linus didn't like our
> suggestion that every driver must do something, rather than do nothing....
> So the irqrouter_resume safety-net remains.
> 
> But restoring a PCI Interrupt Link Device evaluates _CRS, _PRS, _SRS --
> general methods which are also invoked at other times with
> interrupts enabled.  So for those we'd not be able to WARN_ON()
> for either irqs enabled or disabled:-(
> 
> I have to think about irqrouter_resume a bit.
> I don't like it, but I don't see an alternative -- unless we
> do something like ENFORCE all users of the links have to
> stop using them at suspend, so we can _DIS them,
> and they must request their IRQs at resume
> like they do at boot...

Well, that was my question to Linus in a recent discussion.

I see some technical reasons to require drivers to free IRQs during
suspend.  First, the issue above.  Second, some removable devices may not
even be present during resume while we may still think they use an IRQ
(or is that impossible for some reason?).

Now, _if_ we decide we want devices to free IRQs during suspend, we can make
the core do that, so that the drivers won't have to worry about it.

Does the ACPI spec say anything about handling interrupts during
suspend-resume?

> IIR we'd have to add some reference counting to handle shard links
> so we could _DIS when the last user freed the irq.
> 
> So it looks like we will indeed need something like the
> patch to transform ACPI's use of GFP_KERNEL
> to GFP_ATOMIC across late suspend
> and early resume; to avoid warnings from
> _GTS, _BFS, and irqrouter_resume use of kmalloc.

OK, so there are two possibilities, IMO.

Either we switch that in the suspend callbacks like in my patch #1, or we
can add a bool variable that will be 'true' is the system is during
suspend-resume with interrupts off.  Any of them is fine by me, so please let
me know.

Thanks,
Rafael
