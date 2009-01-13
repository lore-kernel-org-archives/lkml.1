Return-Path: <linux-kernel-owner+w=401wt.eu-S1756013AbZAMP5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013AbZAMP5h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 10:57:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752299AbZAMP5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 10:57:23 -0500
Received: from ns.suse.de ([195.135.220.2]:58945 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752043AbZAMP5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 10:57:21 -0500
Date: Tue, 13 Jan 2009 16:57:17 +0100
From: Olaf Dabrunz <od@suse.de>
To: Stefan Assmann <sassmann@suse.de>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, Len Brown <lenb@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Olaf Dabrunz <od@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Sven Dietrich <sdietrich@novell.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Jon Masters <jcm@redhat.com>
Subject: Re: PCI, ACPI, IRQ, IOAPIC: reroute PCI interrupt to legacy boot
	interrupt equivalent
Message-ID: <20090113155717.GM25512@suse.de>
Mail-Followup-To: Stefan Assmann <sassmann@suse.de>,
	Bjorn Helgaas <bjorn.helgaas@hp.com>, Len Brown <lenb@kernel.org>,
	Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-acpi@vger.kernel.org, Sven Dietrich <sdietrich@novell.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	"Maciej W. Rozycki" <macro@linux-mips.org>,
	Jon Masters <jcm@redhat.com>
References: <alpine.LFD.2.00.0901091743310.20020@localhost.localdomain> <496B24E5.1070804@suse.de> <200901121151.53195.bjorn.helgaas@hp.com> <496C788C.9050305@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <496C788C.9050305@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-Jan-09, Stefan Assmann wrote:
> Bjorn Helgaas wrote:
> > (I added Eric, Maciej, and Jon because they participated in
> > previous discussion here: http://lkml.org/lkml/2008/6/2/269)
> > 
> > On Monday 12 January 2009 04:09:25 am Stefan Assmann wrote:
> >> Len Brown wrote:
> >>> Stefan,
> >>> I had to exclude your changes to drivers/acpi/pci_irq.c from
> >>> e1d3a90846b40ad3160bf4b648d36c6badad39ac
> >>> in order to get some other changes to that file upstream in the
> >>> 2.6.29 merge window. ...
> >> Let me try to give you a short overview of what's happening there.
> >>
> >> If an IRQ arrives at line X of a non-primary IO-APIC and that line is
> >> masked a new IRQ will be generated on the primary IO-APIC/PIC. This is
> >> called a "Boot Interrupt" by Intel. It's purpose is, as the name
> >> suggests, to ensure that the IRQ is handled at boot time (when the
> >> non-primary) IO-APIC is still disabled.
> >>
> >> Condition to be met for "Boot Interrupts":
> >> - line X on non-primary IO-APIC interrupt line is masked
> >> - line X is asserted
> > 
> > Thanks.  Let me replay this to see whether I understand.  Please
> > correct any of my misapprehensions :-)
> > 
> > Since your patch doesn't look at the IOxAPIC RDL register to see
> > whether the pin is masked, you must be assuming that Linux is
> > *always* using boot interrupts, and never unmasking the non-primary
> > IOxAPIC entry.
> 
> Yes, for this special case that is correct.

Right. The current reroute code assumes that all interrupts use masking.

If you think about migrating the reroute code to new per-line (or
per-device) masking/threading: this means we need to hook into
request_irq() or some such, to find out if an interrupt handler requests
a masked/threaded IRQ.

The state of the mask bit in the IO-APIC RDL is not sufficient. It is
switched on in the initial IRQ handler and switched off when the IRQ has
been handled by the IRQ thread. A cleared mask bit does not mean that
the IRQ-line will not be masked.

> > It looks like for each PCI bus, the 6700PXH contains a 24-input IOxAPIC
> > with 16 of the inputs available for PCI interrupts.  The boot interrupt
> > feature generates only INTA-INTD messages (total of four choices).
> > I think that means your patch forces sharing, e.g. pins 0, 4, 8, and
> > 12 all generate INTA on PCI Express, so they will share the same IRQ.
> > If the non-primary IOxAPIC entries were unmasked, the boot interrupt
> > would not be generated, so those pins could all have separate IRQs.
> 
> Indeed, this method introduces a kind of artificial interrupt sharing.
> The trade-off here is, having a reliably working system with the
> possibility of slightly increased interrupt sharing rather than a system
> that shows all kinds of nasty behaviors as Ingo pointed out.
> 
> How much of a performance hit gives interrupt sharing anyway? Does
> anybody have some numbers?

IRQ sharing mainly has an effect on latency. I do not expect the latency
changes to be large, so this is not an issue for non-RT computing. But
for RT computing increased latency is an issue. So why would we increase
the latency for RT computing with our reroute code? Because it is the
only approach that reliably targets and fixes the problems caused by
broken hardware for RT. The only alternative to that is to use different
hardware.

Making the widely available broken hardware work at the cost of a bit of
added latency seems to be a good tradeoff (and the best tradeoff
available, as far as we know).

We have not seen any newer bridges that are broken, so we expect that
eventually the need for rerouting will go away. But this is probably
years in the future, when the broken hardware is not being used anymore.

We were preparing a paper which describes the problem and all the
approaches we considered and/or tried. We also have a presentation about
this. Unfortunately, due to the huge number of other interesting
presentations, we could not give our presentation at the LPC and the
paper was not finished. But we have a simplified version of the paper
and are working on making it and the presentation slides available
online.

> > The 6700PXH boot interrupt behavior doesn't seem to be configurable,
> > so it should work the same even with "acpi=off", so I think we would
> > have a similar issue in the pirq_enable_irq() path.
> > 
> > I was about to ask why you have devices generating interrupts while
> > their APIC entry is masked, but the discussion starting with Eric's
> > response in this thread:
> >   http://lkml.org/lkml/2008/6/2/269
> > suggests that the RT kernel masks APIC entries in the course of
> > normal operation, while the device can still be generating interrupts.

Threaded IRQ handling masks the IRQ while the original IRQ is still
pending. This is done so that IRQs in general can be activated quickly
again (by leaving the initial IRQ handler) in order to minimize the
times where other, high-priority threads cannot run.

The masking then prevents the pending IRQ from re-activating the IRQ
handler. Later the IRQ thread will handle the IRQ and unmask the line.

> > And these boot interrupts would certainly be a surprising side-effect
> > of masking an APIC entry, even in a non-RT kernel.

Yes. To prevent this, the patent by Intel describes a bit that disables
boot interrupts. But this bit has not been implemented in several Intel
chips.

> > Basically, the interrupt routing changes depending on whether the
> > APIC entry is masked.  That seems pretty ugly, and I can't think of
> > any nice way to describe that behavior via ACPI.  It seems sub-optimal

Yes, I agree: if I was a BIOS manufacturer and had to write the ACPI
tables for boot interrupts, I would not see a way to describe this
behaviour in the ACPI tables either.

> > to add a constraint that we can't ever mask or unmask that APIC entry.

Yes, preventing boot interrupts by completely disallowing masking in
software is not a solution either: masking is needed for threaded
interrupt handling and for disabling (!) interrupt lines (although this
also does not work as expected on broken chips, as the IRQ will then be
delivered via the boot interrupt mechanism -- in the case of screaming
IRQs this leads to a situation where both lines are disabled).

> Well, it shouldn't be that bad. Mind you this only applies to
> non-primary IO-APICs. These IO-APICs are usually used to handle a
> separate bus, which usually only has a few devices hanging around.
> 
> > What if we installed an extra ISR for the boot interrupt that just
> > invoked the ISR for each device on each of the APIC pins that can
> > generate that boot interrupt?
> 
> You might end up invoking the same ISR twice. Once by the original IRQ
> followed by a Boot Interrupt that is generated during masked interrupt
> handling.

And this will happen every time. And as you (Stefan) reminded me, the
second of the two invocations of the ISR may not see the IRQ asserted on
the device anymore (e.g. if the boot interrupt line was masked, and if
it is unmasked after the threaded IRQ handler de-asserted the IRQ on the
device). So we may end up having screaming IRQs on one IRQ line, leading
to the nasty effects again that we needed to avoid. This failure mode is
also very difficult to reproduce and analyze.

> >  I.e., for the 6700PXH case, install an
> > ISR for INTA, and have that ISR call the ISRs for all the devices on
> > pins 0, 4, 8, and 12.  Then the normal case would be that the APIC entry
> > is unmasked, we don't share the IRQ, and the ISR is called directly.
> > But when the APIC entry is masked, we take the boot interrupt and pay
> > the penalty of calling some extra ISRs.
> 
> Don't you think that would clutter /proc/interrupts? The other question
> I have, is that really worth the effort? Another thing that comes to
> mind is, what if there is no other device on the interrupt line where
> INTA, INTB, etc. end up. Would you want to permanently unmask all these
> interrupt lines in case a Boot Interrupt shows up even if there are no
> devices on the interrupt lines? The whole case is pretty tricky.
> 
> > 
> > Bjorn
> > 
> >> This behavior is not necessary during normal operation as the IRQ is
> >> handled by the non-primary IO-APIC itself. Now imagine what happens if
> >> these Boot Interrupts would occur during normal operation. You'd see
> >> spurious IRQs on your primary IO-APIC which, in the worst case, will
> >> bring down the interrupt line they occur on! Every device that shares this
> >> interrupt line will fail when this happens.
> >>
> >> Why can these IRQ lines be brought down by Boot Interrupts? Because
> >> there's no handler installed on the primary IO-APIC IRQ line that can
> >> take care of them and after too many unhandled IRQs the line will be shut
> >> down by the kernel.
> >>
> >> What this quirk does:
> >> It installs the interrupt handler on the primary IO-APICs interrupt line
> >> instead of the (original) non-primary IO-APICs interrupt line, keeping
> >> the original interrupt line masked. This guarantees that for every IRQ
> >> arriving at the non-primary IO-APIC a Boot Interrupt is generated _and_
> >> handled properly.
> >>
> >> Note: You need this quirk if you mask your interrupts during handling.
> >>
> >>> The quirk is specific to Intel chipsets, so with all the
> >>> Linux guys now working at Intel, I'm hopeful that we can
> >>> reach a clear understanding of the issue and a consensus
> >>> on the proper fix.
> >>>
> >>> BTW. I'm not excited about how the original patch
> >>> drops a chipset specific workaround inside the ACPI code
> >>> to go behind the mirrors and lie about what ACPI returns.
> >>> I'm hopeful that a better place for the workaround
> >>> can be found if this is the approach we need to take..
> >> Yes, I agree with you and I'm totally open for discussing a better place
> >> for this quirk if you find any. You see the problem here is to "move" the
> >> interrupt handler from one line to another and so far we haven't found a
> >> better way to do this. If I'm not mistaken this technically is pretty
> >> similar to what this new "derive an IRQ for this device from a parent
> >> bridge" does.

Yes, we should better integrate this information and keep the
information in the ACPI tables available.

My suggestion is to add a "used_irq" field to acpi_prt_entry. If that
field is valid (i.e. not -1), we use that IRQ number instead of the one
reported in the ACPI table.

> >>> Can you help us understand what the failure is?
> >> I hope this explains a little bit what this is all about. In case your
> >> looking for more in-depth information about the interrupt routing I'd
> >> suggest to have a look for example at the Intel® 6700PXH 64-bit PCI Hub
> >> Datasheet, especially chapter 2.15 I/OxAPIC Interrupt Controller. Feel
> >> free to ask any further questions that might arise.
> >>
> >> Taking a look at the new pci_irq.c code now, could you tell me where
> >> exactly you're seeing trouble with the quirk. It shouldn't be too
> >> troublesome to put it in again, but let me have a look and thanks for
> >> your efforts.
> >>
> >>> thanks,
> >>> -Len
> >>   Stefan
> > 
> 
>   Stefan

Thanks,

-- 
Olaf Dabrunz (od/odabrunz), SUSE Linux Products GmbH, Nürnberg

