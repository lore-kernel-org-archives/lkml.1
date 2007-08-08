Return-Path: <linux-kernel-owner+w=401wt.eu-S1757296AbXHHKf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757296AbXHHKf6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 06:35:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751287AbXHHKft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 06:35:49 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:39937 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032AbXHHKfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 06:35:48 -0400
Date: Wed, 8 Aug 2007 16:06:03 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Martin Wilck <martin.wilck@fujitsu-siemens.com>
Cc: Haren Myneni <hbabu@us.ibm.com>,
       "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: PATCH/RFC: [kdump] fix APIC shutdown sequence
Message-ID: <20070808103603.GC13808@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <46B73955.2080007@fujitsu-siemens.com> <20070807142928.GA18839@in.ibm.com> <46B8AECA.7050908@fujitsu-siemens.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <46B8AECA.7050908@fujitsu-siemens.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2007 at 07:41:30PM +0200, Martin Wilck wrote:
[..]
> 
> Such a situation has never been observed in the "good" case.
> So, we do have some evidence, not just bare speculation.
> 
> >> 2. The crashing CPU itself disables its local APIC
> >>    before the IO-APIC, leaving a short time window
> >>    where the IOAPIC can receive IRQs, but not
> >>    deliver them.
> >>
> > 
> > I doubut that it would be the issue. Looking at intel IOAPIC (82093AA)
> > documentation, it says that IRR bit of IOAPIC will be set only if
> > destination CPU has accepted the interrupt. So if we have disabled
> > the LAPIC, it will not accept the interrupt and IRR bit of IOAPIC
> > should not be set.
> 
> Can you explain how, on the front side bus, the IO-APIC knows whether
> a CPU has accepted the INT message? There is no response
> to the INT message on the bus, except for the EOI which comes much later.
> I'm not saying that you're wrong, I just really don't understand this
> point.
> 

I don't know what is exactly hardware protocol. I am just going by 
intel documentation. 

Remote IRR—RO. This bit is used for level triggered interrupts. Its meaning
is undefined for edge triggered interrupts. For level triggered interrupts,
this bit is set to 1 when local APIC(s) accept the level interrupt sent by
the IOAPIC. The Remote IRR bit is set to 0 when an EOI message with a matching
interrupt vector is received from a local APIC.

According to this, IRR bit is set to one only when Local APIC accepts the
level trigger interrupt. This implies there should be a way of IOAPIC 
knowing that destination local apic has accepted the interrupt.

Anyway, I think after disabling the LAPIC, it should not accept more
interrupt from IOAPIC. It will only deliver pending interrupts to CPU
if CPU has not masked it. So in your case it looks like we have got
pending interrupts at LAPIC which never received EOI in first kernel.
Second kernel will field these interrupts and will mark as spurious
interrupt and issue EOI. But by that time IOAPIC  does not have vector
info so will not clear IRR bit.
   
> In the logical analyzer, we can't see when exactly the local APICs are
> disabled. But we see that IRQs arriving after the IO APIC pin is
> masked never do any harm, while IRQs arriving "during the shutdown
> sequence" (we can see e.g. the 2nd CPU taking the bus after the NMI
> IPI) cause the error situation.
> 
> >> 3. An IRQ is received and delivered to a local APIC, but
> >>    no CPU ever executes the IRQ handler and therefore no
> >>    EOI is sent.
> >>
> > 
> > We do issue EOI for all the pending interrupts in second
> > kernel. Look at setup_local_APIC(). Once the second is booting, it
> > checks if there are any pending interrupts (ISR bit is set). If yes,
> > it goes ahead and issues an extra EOI. This should also clear the
> > IRR register of IOAPIC.
> 
> In an earlier patch, I tried to add that same code in
> machine_crash_shutdown() and crash_nmi_callback(),  in order
> to send EOIs for pending IRQs on all CPUs. Unfortunately,
> that had no effect.
> 

So you tried issuing EOI to all the pending interrupts in first
kernel. Did you check that at the time of issuing EOI, corresponding
vector bits were set in ISR/IRR at LAPIC and IRR was set at IOAPIC?
If yes, then only some hardware guy can tell us that why issuing an EOI
did not clear the IRR bit at IOAPIC.

I have never used a trace analyzer. Can you really parse the EOI message
and see what are the contents? I mean in terms of making sure right
vector info is there so that IOAPIC can reset IRR?


> > disable_IO_APIC() code does not clear the vector information
> > in routing table. It just masks the interrupt. So even if
> > an EOI is issued later in second kernel, it should clear the
> > IRR bit at IOAPIC.
> 
> Hmm... ioapic_mask_entry() writes
> "union entry_union eu = { .entry.mask = 1 }" to the  LVT register.
> That clears all bits except the mask bit, so that the vector information
> is lost. Please correct me if I'm mistaken.
> 

Sorry, you are right. I read the code too fast. IOAPIC entries will be
cleared and precisely that seems to be the reason why issuing an EOI
in second kernel will not help this situation in its current form.

> >> c) There are indications that besides the EOI, it's also
> >> necessary that the PCI IRQ pin is deasserted at least for
> >> a short time.
> 
> > I doubt this. There are situations when there is no device
> > driver for the device and device pushes the interrupt (frequently
> > observed in the case of kdump). Kernel still keeps on receiving
> > the interrupt without driver telling device to lower the interrupt
> > line.
> 
> So far I haven't come up with a patch that just sends EOI without
> actually calling any HW IRQ handler. That would clarify this question.
> It's on my todo list.
> 

Isn't the "nobody cared for irq x" situation similar. Some device has
asserted a level triggered interrupt and there is no respective device
driver. So kernel sees a flurry of interrupts. (issues and EOI but
immediately sees next interrupt as device has not de-asserted the interrupt
line)?

[..]
> > - Can you please print local apic (print_local_APIC) and
> >   ioapic registers (print_IO_APIC) and verify above theory?
> 
> We always see the IO-APIC IRR  bit in the error situation, before and
> after the start of the kdump kernel.
> 
> *Before* the kdump kernel starts (more precisely: before the call
> to disable_IO_APIC()), the IO-APIC "delivery status" bit is also set.
> 
> I checked local APIC ISR and IRR bits in an earlier version of my patch
> (see above). They were sometimes set, and sometimes not (unlike the IO-APIC
> IRR/Delivery Status which behave always the same).
> 

This will be interesting. So you are saying that there are cases where
IRR bit is set at IOAPIC but corresponding IRR/ISR bit is not set at
LAPIC? If that is the case then even enabling the interrupts will not
help? Because IRR/ISR bit is not set, CPU will never receive an interrupt
and it will never issue an EOI for that vector? I am not sure in such cases
how will your patch solve the issue.

I think we should not be enabling the interrupt after the crash. If needed,
we should just issue the EOI and it should work. Otherwise we need to get
in touch with hardware folks to tell us what is going on.

Thanks
Vivek
