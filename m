Return-Path: <linux-kernel-owner+w=401wt.eu-S1761673AbZANJ5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761673AbZANJ5j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 04:57:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758361AbZANJ51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 04:57:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39224 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758324AbZANJ5Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 04:57:25 -0500
Message-ID: <496DB702.40302@suse.de>
Date: Wed, 14 Jan 2009 10:57:22 +0100
From: Stefan Assmann <sassmann@suse.de>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
Cc: Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Olaf Dabrunz <od@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       Sven Dietrich <sdietrich@novell.com>
Subject: Re: PCI, ACPI, IRQ, IOAPIC: reroute PCI interrupt to legacy boot
 interrupt equivalent
References: <alpine.LFD.2.00.0901091743310.20020@localhost.localdomain> <496B24E5.1070804@suse.de> <20090113082513.GA18449@sli10-desk.sh.intel.com>
In-Reply-To: <20090113082513.GA18449@sli10-desk.sh.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shaohua Li wrote:
> On Mon, Jan 12, 2009 at 07:09:25PM +0800, Stefan Assmann wrote:
>> Hi Len,
>>
>> Len Brown wrote:
>>> Stefan,
>>> I had to exclude your changes to drivers/acpi/pci_irq.c from
>>> e1d3a90846b40ad3160bf4b648d36c6badad39ac
>>> in order to get some other changes to that file upstream in the
>>> 2.6.29 merge window.
>>>
>>> I left the other parts of the quirk intact - so at the moment
>>> on one of the quirked machines, you'll see
>>>
>>> PCI quirk: reroute interrupts for...
>>>
>>> but will not see
>>>
>>> pci irq %d -> rerouted to legacy
>>>
>>> as the quirk is effectively disabled.
>>>
>>> I had difficulty trying to port this patch to the new pci_irq.c
>>> because fundamentally I don't understand what it is trying
>>> to do, and why.
>> Let me try to give you a short overview of what's happening there.
>>
>> If an IRQ arrives at line X of a non-primary IO-APIC and that line is
>> masked a new IRQ will be generated on the primary IO-APIC/PIC. This is
>> called a "Boot Interrupt" by Intel. It's purpose is, as the name
>> suggests, to ensure that the IRQ is handled at boot time (when the
>> non-primary) IO-APIC is still disabled.
>>
>> Condition to be met for "Boot Interrupts":
>> - line X on non-primary IO-APIC interrupt line is masked
>> - line X is asserted
>>
>> This behavior is not necessary during normal operation as the IRQ is
>> handled by the non-primary IO-APIC itself. Now imagine what happens if
>> these Boot Interrupts would occur during normal operation. You'd see
>> spurious IRQs on your primary IO-APIC which, in the worst case, will
>> bring down the interrupt line they occur on! Every device that shares this
>> interrupt line will fail when this happens.
>>
>> Why can these IRQ lines be brought down by Boot Interrupts? Because
>> there's no handler installed on the primary IO-APIC IRQ line that can
>> take care of them and after too many unhandled IRQs the line will be shut
>> down by the kernel.
>>
>> What this quirk does:
>> It installs the interrupt handler on the primary IO-APICs interrupt line
>> instead of the (original) non-primary IO-APICs interrupt line, keeping
>> the original interrupt line masked. This guarantees that for every IRQ
>> arriving at the non-primary IO-APIC a Boot Interrupt is generated _and_
>> handled properly.
>>
>> Note: You need this quirk if you mask your interrupts during handling.
> So a device can generate interrupt from two irqs. And we can get the irq
> number for the routing table. Can we extend the irq mechanism and
> automatically register the interrupt handler for the two irqs?

This would not solve the problem of asserting 2 different interrupt
lines, in the masked interrupt handling case, for 1 interrupt request.
The result would be that the ISR is called twice and at the second call
you can't be sure that the device hasn't already been serviced.

> 
> Thanks,
> Shaohua

  Stefan

-- 
Stefan Assmann          | SUSE LINUX Products GmbH
Software Engineer       | Maxfeldstr. 5, D-90409 Nuernberg
Mail: sassmann@suse.de  | GF: Markus Rex, HRB 16746 (AG Nuernberg)
