Return-Path: <linux-kernel-owner+w=401wt.eu-S1755976AbZALSwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976AbZALSwX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 13:52:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753073AbZALSwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 13:52:05 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:35761 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959AbZALSwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 13:52:01 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Stefan Assmann <sassmann@suse.de>
Subject: Re: PCI, ACPI, IRQ, IOAPIC: reroute PCI interrupt to legacy boot interrupt equivalent
Date: Mon, 12 Jan 2009 11:51:51 -0700
User-Agent: KMail/1.9.10
Cc: Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Olaf Dabrunz <od@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Sven Dietrich <sdietrich@novell.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Jon Masters <jcm@redhat.com>
References: <alpine.LFD.2.00.0901091743310.20020@localhost.localdomain> <496B24E5.1070804@suse.de>
In-Reply-To: <496B24E5.1070804@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200901121151.53195.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(I added Eric, Maciej, and Jon because they participated in
previous discussion here: http://lkml.org/lkml/2008/6/2/269)

On Monday 12 January 2009 04:09:25 am Stefan Assmann wrote:
> Len Brown wrote:
> > Stefan,
> > I had to exclude your changes to drivers/acpi/pci_irq.c from
> > e1d3a90846b40ad3160bf4b648d36c6badad39ac
> > in order to get some other changes to that file upstream in the
> > 2.6.29 merge window. ...
> 
> Let me try to give you a short overview of what's happening there.
> 
> If an IRQ arrives at line X of a non-primary IO-APIC and that line is
> masked a new IRQ will be generated on the primary IO-APIC/PIC. This is
> called a "Boot Interrupt" by Intel. It's purpose is, as the name
> suggests, to ensure that the IRQ is handled at boot time (when the
> non-primary) IO-APIC is still disabled.
> 
> Condition to be met for "Boot Interrupts":
> - line X on non-primary IO-APIC interrupt line is masked
> - line X is asserted

Thanks.  Let me replay this to see whether I understand.  Please
correct any of my misapprehensions :-)

Since your patch doesn't look at the IOxAPIC RDL register to see
whether the pin is masked, you must be assuming that Linux is
*always* using boot interrupts, and never unmasking the non-primary
IOxAPIC entry.

It looks like for each PCI bus, the 6700PXH contains a 24-input IOxAPIC
with 16 of the inputs available for PCI interrupts.  The boot interrupt
feature generates only INTA-INTD messages (total of four choices).
I think that means your patch forces sharing, e.g. pins 0, 4, 8, and
12 all generate INTA on PCI Express, so they will share the same IRQ.
If the non-primary IOxAPIC entries were unmasked, the boot interrupt
would not be generated, so those pins could all have separate IRQs.

The 6700PXH boot interrupt behavior doesn't seem to be configurable,
so it should work the same even with "acpi=off", so I think we would
have a similar issue in the pirq_enable_irq() path.

I was about to ask why you have devices generating interrupts while
their APIC entry is masked, but the discussion starting with Eric's
response in this thread:
  http://lkml.org/lkml/2008/6/2/269
suggests that the RT kernel masks APIC entries in the course of
normal operation, while the device can still be generating interrupts.
And these boot interrupts would certainly be a surprising side-effect
of masking an APIC entry, even in a non-RT kernel.

Basically, the interrupt routing changes depending on whether the
APIC entry is masked.  That seems pretty ugly, and I can't think of
any nice way to describe that behavior via ACPI.  It seems sub-optimal
to add a constraint that we can't ever mask or unmask that APIC entry.

What if we installed an extra ISR for the boot interrupt that just
invoked the ISR for each device on each of the APIC pins that can
generate that boot interrupt?  I.e., for the 6700PXH case, install an
ISR for INTA, and have that ISR call the ISRs for all the devices on
pins 0, 4, 8, and 12.  Then the normal case would be that the APIC entry
is unmasked, we don't share the IRQ, and the ISR is called directly.
But when the APIC entry is masked, we take the boot interrupt and pay
the penalty of calling some extra ISRs.

Bjorn

> This behavior is not necessary during normal operation as the IRQ is
> handled by the non-primary IO-APIC itself. Now imagine what happens if
> these Boot Interrupts would occur during normal operation. You'd see
> spurious IRQs on your primary IO-APIC which, in the worst case, will
> bring down the interrupt line they occur on! Every device that shares this
> interrupt line will fail when this happens.
> 
> Why can these IRQ lines be brought down by Boot Interrupts? Because
> there's no handler installed on the primary IO-APIC IRQ line that can
> take care of them and after too many unhandled IRQs the line will be shut
> down by the kernel.
> 
> What this quirk does:
> It installs the interrupt handler on the primary IO-APICs interrupt line
> instead of the (original) non-primary IO-APICs interrupt line, keeping
> the original interrupt line masked. This guarantees that for every IRQ
> arriving at the non-primary IO-APIC a Boot Interrupt is generated _and_
> handled properly.
> 
> Note: You need this quirk if you mask your interrupts during handling.
> 
> > The quirk is specific to Intel chipsets, so with all the
> > Linux guys now working at Intel, I'm hopeful that we can
> > reach a clear understanding of the issue and a consensus
> > on the proper fix.
> > 
> > BTW. I'm not excited about how the original patch
> > drops a chipset specific workaround inside the ACPI code
> > to go behind the mirrors and lie about what ACPI returns.
> > I'm hopeful that a better place for the workaround
> > can be found if this is the approach we need to take..
> 
> Yes, I agree with you and I'm totally open for discussing a better place
> for this quirk if you find any. You see the problem here is to "move" the
> interrupt handler from one line to another and so far we haven't found a
> better way to do this. If I'm not mistaken this technically is pretty
> similar to what this new "derive an IRQ for this device from a parent
> bridge" does.
> 
> > Can you help us understand what the failure is?
> 
> I hope this explains a little bit what this is all about. In case your
> looking for more in-depth information about the interrupt routing I'd
> suggest to have a look for example at the Intel® 6700PXH 64-bit PCI Hub
> Datasheet, especially chapter 2.15 I/OxAPIC Interrupt Controller. Feel
> free to ask any further questions that might arise.
> 
> Taking a look at the new pci_irq.c code now, could you tell me where
> exactly you're seeing trouble with the quirk. It shouldn't be too
> troublesome to put it in again, but let me have a look and thanks for
> your efforts.
> 
> > thanks,
> > -Len
> 
>   Stefan

