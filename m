Return-Path: <linux-kernel-owner+w=401wt.eu-S1755301AbZFRTec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301AbZFRTec (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 15:34:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752162AbZFRTeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 15:34:25 -0400
Received: from claw.goop.org ([74.207.240.146]:41571 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751654AbZFRTeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 15:34:24 -0400
Message-ID: <4A3A96BC.1000302@goop.org>
Date: Thu, 18 Jun 2009 12:34:20 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>
Subject: Re: [PATCH RFC] x86/acpi: don't ignore I/O APICs just because there's
 no local APIC
References: <4A329CF8.4050502@goop.org> <m1d499yyug.fsf@fess.ebiederm.org>	<4A35ACB3.9040501@goop.org> <m1k53dbwo2.fsf@fess.ebiederm.org>	<4A36B3EC.7010004@goop.org> <m1fxe117n5.fsf@fess.ebiederm.org>	<4A37F4AE.5050902@goop.org> <m1vdmvxe3u.fsf@fess.ebiederm.org>	<4A392896.9090408@goop.org> <m1zlc6memu.fsf@fess.ebiederm.org>
In-Reply-To: <m1zlc6memu.fsf@fess.ebiederm.org>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/09 19:58, Eric W. Biederman wrote:
>> One of the options we discussed was changing the API to get rid of the exposed
>> vector, and just replace it with an operation to directly bind a gsi to a pirq
>> (internal Xen physical interrupt handle, if you will), so that Xen ends up doing
>> all the I/O APIC programming internally, as well as the local APIC.
>>     
>
> As an abstraction layer I think that will work out a lot better long term.
>
> Given what iommus with irqs and DMA I expect you want something like
> that, that can be used from domU.  Then you just make allowing the
> operation conditional on if you happen to have the associated hardware
> mapped into your domain.
>   

A domU with a PCI passthrough device can bind a pirq to one of its event
channels.  All the gsi->pirq binding happens in dom0, but binding a pirq
to event channel can happen anywhere (that's why it doesn't bind gsi
directly to event channel, as they're strictly per-domain).

MSI interrupts also get bound to pirqs, so once the binding is created,
MSI and GSI interrupts can be treated identically (I think, I haven't
looked into the details yet).

>> On the Linux side, I think it means we can just point pcibios_enable/disable_irq
>> to our own xen_pci_irq_enable/disable functions to create the binding between a
>> PCI device and an irq.
>>     
>
> If you want xen to assign the linux irq number that is absolutely the properly place
> to hook.
>   

Yes.  We'd want to keep the irq==gsi mapping for non-MSI interrupts, but
that's easy enough to arrange.

> When I was messing with the irq code I did not recall finding many
> cases where migrating irqs from process context worked without hitting
> hardware bugs.  ioapic state machine lockups and the like.
>   

Keir mentioned that Xen avoids masking/unmasking interrupts in the I/O
APIC too much, because that has been problematic in the past.  Is that
related to the problems you're talking about?  Is there anywhere which
documents them?

> How does Xen handle domU with hardware directly mapped?
>   

We call that "pci passthrough".  Dom0 will bind the gsi to a pirq as
usual, and then pass the pirq through to the domU.  The domU will bind
the pirq to an event channel, which gets mapped to a Linux irq and
handled as usual.

> Temporally ignoring what we have to do to work with Xen 3.4.  I'm curious
> if we could make the Xen dom0 irq case the same as the Xen domU case.
>   

It is already; once the pirq is prepared, the process is the same in
both cases.

    J
