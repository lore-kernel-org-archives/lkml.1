Return-Path: <linux-kernel-owner+w=401wt.eu-S1758615AbZFRWdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758615AbZFRWdw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 18:33:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753971AbZFRWdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 18:33:44 -0400
Received: from claw.goop.org ([74.207.240.146]:38021 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754877AbZFRWdo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 18:33:44 -0400
Message-ID: <4A3AC0C4.6060508@goop.org>
Date: Thu, 18 Jun 2009 15:33:40 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH RFC] x86/acpi: don't ignore I/O APICs just because there's
 no local APIC
References: <4A329CF8.4050502@goop.org>	<alpine.LFD.2.00.0906181206190.4213@localhost.localdomain>	<4A3A9220.4070807@goop.org> <m1zlc5jqac.fsf@fess.ebiederm.org>	<4A3A99FB.7070807@goop.org> <m1vdmtgtt2.fsf@fess.ebiederm.org>
In-Reply-To: <m1vdmtgtt2.fsf@fess.ebiederm.org>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/09 13:39, Eric W. Biederman wrote:
>> Well, if acpi_pci_irq_lookup() and friends return the right things
>> without having parsed the MADT and set up the secondary state, then we
>> should be fine either way.
>>
>> acpi_irq_model gets tested in all sorts of random places, so I wonder if
>> we'll need to set it to ACPI_IRQ_MODEL_IOAPIC (or something else?) to
>> make things work properly.
>>     
>
> And this is where things get interesting.  Xen strictly speaking has
> already made that decision.  Unless you support non APIC mode it
> should always be ACPI_IRQ_MODEL_IOAPIC.
>   

We could decide by fiat to not support non-APIC machines (which is more
or less the case), but they do happen to work at the moment; Gerd even
has one and provided fixes to make it work.  (Ditto non-ACPI, though
they're commonly related.)

> But Xen runs the hardware so Xen knows, and Xen should be running
> all of the acpi and what not to make it happen.
>   

There are two separate issues:

   1. If we intercept interrupt routing at the pcibios_pci_irq_enable
      level, will anything in the kernel care about the state of its
      acpi_irq_model variable?  At first glance it *shouldn't* care,
      because its just handing the whole problem off to Xen.
   2. Xen has no AML interpreter, so its use of ACPI is limited to
      parsing tables.  It looks like we'll need to set acpi_irq_model
      appropriately and then get acpi_bus_init_irq() to run.

(Related to this is making sure any chipset configuration that happens
in the depths of the DSDT does in fact happen.)

>> Hm, and principle we just get the SCI gsi from the FADT, but there's all
>> that other mucking about with it in the MADT processing... Wonder what
>> needs to happen there...
>>     
>
> Good question.  What does the domU case do?
>   

DomU doesn't know or care about ACPI at all.  There's no reason for it
to get any kind of ACPI event.

    J
