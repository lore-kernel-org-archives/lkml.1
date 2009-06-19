Return-Path: <linux-kernel-owner+w=401wt.eu-S1759464AbZFSCmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759464AbZFSCmT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 22:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752713AbZFSCmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 22:42:05 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:46311 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbZFSCmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 22:42:04 -0400
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH RFC] x86/acpi: don't ignore I/O APICs just because there's no local APIC
References: <4A329CF8.4050502@goop.org>
	<alpine.LFD.2.00.0906181206190.4213@localhost.localdomain>
	<4A3A9220.4070807@goop.org> <m1zlc5jqac.fsf@fess.ebiederm.org>
	<4A3A99FB.7070807@goop.org> <m1vdmtgtt2.fsf@fess.ebiederm.org>
	<4A3AC0C4.6060508@goop.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 18 Jun 2009 19:42:00 -0700
In-Reply-To: <4A3AC0C4.6060508@goop.org> (Jeremy Fitzhardinge's message of "Thu\, 18 Jun 2009 15\:33\:40 -0700")
Message-ID: <m17hz9djwn.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: jeremy@goop.org, xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com, lenb@kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Exit with error (see exim mainlog)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> On 06/18/09 13:39, Eric W. Biederman wrote:
>>> Well, if acpi_pci_irq_lookup() and friends return the right things
>>> without having parsed the MADT and set up the secondary state, then we
>>> should be fine either way.
>>>
>>> acpi_irq_model gets tested in all sorts of random places, so I wonder if
>>> we'll need to set it to ACPI_IRQ_MODEL_IOAPIC (or something else?) to
>>> make things work properly.
>>>     
>>
>> And this is where things get interesting.  Xen strictly speaking has
>> already made that decision.  Unless you support non APIC mode it
>> should always be ACPI_IRQ_MODEL_IOAPIC.
>>   
>
> We could decide by fiat to not support non-APIC machines (which is more
> or less the case), but they do happen to work at the moment; Gerd even
> has one and provided fixes to make it work.  (Ditto non-ACPI, though
> they're commonly related.)

Interesting.  Then we need to know what Xen has chosen to do.
This whole logic of having linux and Xen happen to choose the
same interrupt handling mode by coincidence that is in use
right now seems fragile.

Xen runs a timer so I can't see Xen actually leaving the decision
up to linux.  It certainly doesn't leave the physical versus logical
mode decision up to linux.

>> But Xen runs the hardware so Xen knows, and Xen should be running
>> all of the acpi and what not to make it happen.
>>   
>
> There are two separate issues:
>
>    1. If we intercept interrupt routing at the pcibios_pci_irq_enable
>       level, will anything in the kernel care about the state of its
>       acpi_irq_model variable?  At first glance it *shouldn't* care,
>       because its just handing the whole problem off to Xen.

>    2. Xen has no AML interpreter, so its use of ACPI is limited to
>       parsing tables.  It looks like we'll need to set acpi_irq_model
>       appropriately and then get acpi_bus_init_irq() to run.

Assuming Xen not having the AML interpreter is the right decision.
I recall from some of the hibernation discussions that ACPI is not an easy
thing to start/stop on a machine unless it is handled just so.

Which if dom0 is to be redundant/restartable seems to make the
argument for AML living in Xen.

Xen has everything except the AML interpreter.

> (Related to this is making sure any chipset configuration that happens
> in the depths of the DSDT does in fact happen.)
>
>>> Hm, and principle we just get the SCI gsi from the FADT, but there's all
>>> that other mucking about with it in the MADT processing... Wonder what
>>> needs to happen there...
>>>     
>>
>> Good question.  What does the domU case do?
>>   
>
> DomU doesn't know or care about ACPI at all.  There's no reason for it
> to get any kind of ACPI event.

Yet at least occasionally Xen fakes up ACPI tables for a guest.

DomU has to do something to get the mapping, which is what I thought you
were referring to.

I can believe a Xen dom0 that is the same as domU except with lots
more hardware.  I have trouble understanding and Xen dom0 that has to
all kinds of special one off hardware manipulation because Xen is too
lazy too.  Xen is already 300,000 lines of code so it's not like it is
fully comprehensible/maintainable by a single person anyway.

Eric
