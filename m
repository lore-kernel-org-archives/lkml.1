Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752641AbYLRHJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbYLRHJV (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 02:09:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751445AbYLRHJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 02:09:03 -0500
Received: from vms173009pub.verizon.net ([206.46.173.9]:26165 "EHLO
	vms173009.mailsrvcs.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750760AbYLRHJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 02:09:02 -0500
X-Greylist: delayed 3609 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Dec 2008 02:09:02 EST
Date: Thu, 18 Dec 2008 01:08:45 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, pavel@suse.cz,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-acpi@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>
Subject: irqs_disabled() vs ACPI interpreter vs suspend
In-reply-to: <200812170040.07977.rjw@sisk.pl>
Message-id: <alpine.LFD.2.00.0812180107150.17738@localhost.localdomain>
References: <20081125110508.GA1943@elf.ucw.cz>
 <20081215214140.9031d4c8.akpm@linux-foundation.org>
 <200812161634.25838.rjw@sisk.pl> <200812170040.07977.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael,

to answer your question "what happens at boot"...

interrupts are enabled in start_kernel()
well before the ACPI interpreter is started
up in a subsys_initcall().

The first use of the interpreter indeed allocates memory
(as every invocation of acpi_evaluate_object() does)
to evaluate _PIC
ie. when we print out "ACPI: Using IOAPIC for interrupt routing".

So one would first think we could WARN_ON(irqs_disabled())
right at acpi_evaluate_object(), or at any external
entry to the AML interpreter.

But _GTS and _BFS are counter-examples --
they are ONLY evaluated with interrupts OFF,
since they are between the invocation of arch_suspend_disable_irqs()
and arch_suspend_enable_irqs().  I believe that they are the
ONLY counter-examples, and for those we'd conceivably
WARN_ON(!irqs_disabled).

But at resume...
irqrouter_resume() is called to restore ACPI PCI Interrupt Link Devices
while we still have interrupts disabled.  If we called it after interrupts
were enabled, then an incorrectly resumed link could cause a
screaming interrupt.

This is different from boot-time.  At boot time
we disable all the links b/c we know that the drivers
that use them will all request_irq() and we'll set
up the links one by one at that time.

Originally we had planned for suspend to be like boot --
every driver would free_irq() at .suspend
and request_irq() at .resume -- indirectly for pci devices
via pci_enable_device()...
This would leave the Links disabled at suspend time, like we
disable them at boot time -- and then the request_irq()'s would
come in from the resumed drivers and the links would be re-programmed.
I don't think we succeeded here, and IIR Linus didn't like our
suggestion that every driver must do something, rather than do nothing....
So the irqrouter_resume safety-net remains.

But restoring a PCI Interrupt Link Device evaluates _CRS, _PRS, _SRS --
general methods which are also invoked at other times with
interrupts enabled.  So for those we'd not be able to WARN_ON()
for either irqs enabled or disabled:-(

I have to think about irqrouter_resume a bit.
I don't like it, but I don't see an alternative -- unless we
do something like ENFORCE all users of the links have to
stop using them at suspend, so we can _DIS them,
and they must request their IRQs at resume
like they do at boot...  IIR we'd have to add
some reference counting to handle shard links
so we could _DIS when the last user freed the irq.

So it looks like we will indeed need something like the
patch to transform ACPI's use of GFP_KERNEL
to GFP_ATOMIC across late suspend
and early resume; to avoid warnings from
_GTS, _BFS, and irqrouter_resume use of kmalloc.

thanks,
-- Len Brown, Intel Open Source Technology Center

