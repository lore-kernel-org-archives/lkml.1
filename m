Return-Path: <linux-kernel-owner+w=401wt.eu-S1754974AbZALLJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974AbZALLJq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 06:09:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752628AbZALLJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 06:09:29 -0500
Received: from ns2.suse.de ([195.135.220.15]:46967 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351AbZALLJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 06:09:27 -0500
Message-ID: <496B24E5.1070804@suse.de>
Date: Mon, 12 Jan 2009 12:09:25 +0100
From: Stefan Assmann <sassmann@suse.de>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Olaf Dabrunz <od@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Sven Dietrich <sdietrich@novell.com>
Subject: Re: PCI, ACPI, IRQ, IOAPIC: reroute PCI interrupt to legacy boot
 interrupt equivalent
References: <alpine.LFD.2.00.0901091743310.20020@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0901091743310.20020@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Len,

Len Brown wrote:
> Stefan,
> I had to exclude your changes to drivers/acpi/pci_irq.c from
> e1d3a90846b40ad3160bf4b648d36c6badad39ac
> in order to get some other changes to that file upstream in the
> 2.6.29 merge window.
> 
> I left the other parts of the quirk intact - so at the moment
> on one of the quirked machines, you'll see
> 
> PCI quirk: reroute interrupts for...
> 
> but will not see
> 
> pci irq %d -> rerouted to legacy
> 
> as the quirk is effectively disabled.
> 
> I had difficulty trying to port this patch to the new pci_irq.c
> because fundamentally I don't understand what it is trying
> to do, and why.

Let me try to give you a short overview of what's happening there.

If an IRQ arrives at line X of a non-primary IO-APIC and that line is
masked a new IRQ will be generated on the primary IO-APIC/PIC. This is
called a "Boot Interrupt" by Intel. It's purpose is, as the name
suggests, to ensure that the IRQ is handled at boot time (when the
non-primary) IO-APIC is still disabled.

Condition to be met for "Boot Interrupts":
- line X on non-primary IO-APIC interrupt line is masked
- line X is asserted

This behavior is not necessary during normal operation as the IRQ is
handled by the non-primary IO-APIC itself. Now imagine what happens if
these Boot Interrupts would occur during normal operation. You'd see
spurious IRQs on your primary IO-APIC which, in the worst case, will
bring down the interrupt line they occur on! Every device that shares this
interrupt line will fail when this happens.

Why can these IRQ lines be brought down by Boot Interrupts? Because
there's no handler installed on the primary IO-APIC IRQ line that can
take care of them and after too many unhandled IRQs the line will be shut
down by the kernel.

What this quirk does:
It installs the interrupt handler on the primary IO-APICs interrupt line
instead of the (original) non-primary IO-APICs interrupt line, keeping
the original interrupt line masked. This guarantees that for every IRQ
arriving at the non-primary IO-APIC a Boot Interrupt is generated _and_
handled properly.

Note: You need this quirk if you mask your interrupts during handling.

> The quirk is specific to Intel chipsets, so with all the
> Linux guys now working at Intel, I'm hopeful that we can
> reach a clear understanding of the issue and a consensus
> on the proper fix.
> 
> BTW. I'm not excited about how the original patch
> drops a chipset specific workaround inside the ACPI code
> to go behind the mirrors and lie about what ACPI returns.
> I'm hopeful that a better place for the workaround
> can be found if this is the approach we need to take..

Yes, I agree with you and I'm totally open for discussing a better place
for this quirk if you find any. You see the problem here is to "move" the
interrupt handler from one line to another and so far we haven't found a
better way to do this. If I'm not mistaken this technically is pretty
similar to what this new "derive an IRQ for this device from a parent
bridge" does.

> 
> Can you help us understand what the failure is?

I hope this explains a little bit what this is all about. In case your
looking for more in-depth information about the interrupt routing I'd
suggest to have a look for example at the Intel® 6700PXH 64-bit PCI Hub
Datasheet, especially chapter 2.15 I/OxAPIC Interrupt Controller. Feel
free to ask any further questions that might arise.

Taking a look at the new pci_irq.c code now, could you tell me where
exactly you're seeing trouble with the quirk. It shouldn't be too
troublesome to put it in again, but let me have a look and thanks for
your efforts.

> thanks,
> -Len
> 

  Stefan

-- 
Stefan Assmann          | SUSE LINUX Products GmbH
Software Engineer       | Maxfeldstr. 5, D-90409 Nuernberg
Mail: sassmann@suse.de  | GF: Markus Rex, HRB 16746 (AG Nuernberg)
