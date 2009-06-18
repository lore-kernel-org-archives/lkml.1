Return-Path: <linux-kernel-owner+w=401wt.eu-S1753684AbZFRU3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684AbZFRU3Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 16:29:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751550AbZFRU3C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 16:29:02 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:43410 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbZFRU3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 16:29:00 -0400
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>
References: <4A329CF8.4050502@goop.org> <m1d499yyug.fsf@fess.ebiederm.org>
	<4A35ACB3.9040501@goop.org> <m1k53dbwo2.fsf@fess.ebiederm.org>
	<4A36B3EC.7010004@goop.org> <m1fxe117n5.fsf@fess.ebiederm.org>
	<4A37F4AE.5050902@goop.org> <m1vdmvxe3u.fsf@fess.ebiederm.org>
	<4A392896.9090408@goop.org> <m1zlc6memu.fsf@fess.ebiederm.org>
	<4A3A96BC.1000302@goop.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 18 Jun 2009 13:28:55 -0700
In-Reply-To: <4A3A96BC.1000302@goop.org> (Jeremy Fitzhardinge's message of "Thu\, 18 Jun 2009 12\:34\:20 -0700")
Message-ID: <m1ab45i8vs.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: jeremy@goop.org, keir.fraser@eu.citrix.com, xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jeremy Fitzhardinge <jeremy@goop.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH RFC] x86/acpi: don't ignore I/O APICs just because there's no local APIC
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> On 06/17/09 19:58, Eric W. Biederman wrote:
>>> One of the options we discussed was changing the API to get rid of the exposed
>>> vector, and just replace it with an operation to directly bind a gsi to a pirq
>>> (internal Xen physical interrupt handle, if you will), so that Xen ends up doing
>>> all the I/O APIC programming internally, as well as the local APIC.
>>>     
>>
>> As an abstraction layer I think that will work out a lot better long term.
>>
>> Given what iommus with irqs and DMA I expect you want something like
>> that, that can be used from domU.  Then you just make allowing the
>> operation conditional on if you happen to have the associated hardware
>> mapped into your domain.
>>   
>
> A domU with a PCI passthrough device can bind a pirq to one of its event
> channels.  All the gsi->pirq binding happens in dom0, but binding a pirq
> to event channel can happen anywhere (that's why it doesn't bind gsi
> directly to event channel, as they're strictly per-domain).
>
> MSI interrupts also get bound to pirqs, so once the binding is created,
> MSI and GSI interrupts can be treated identically (I think, I haven't
> looked into the details yet).
>
>>> On the Linux side, I think it means we can just point pcibios_enable/disable_irq
>>> to our own xen_pci_irq_enable/disable functions to create the binding between a
>>> PCI device and an irq.
>>>     
>>
>> If you want xen to assign the linux irq number that is absolutely the properly place
>> to hook.
>>   
>
> Yes.  We'd want to keep the irq==gsi mapping for non-MSI interrupts, but
> that's easy enough to arrange.
>
>> When I was messing with the irq code I did not recall finding many
>> cases where migrating irqs from process context worked without hitting
>> hardware bugs.  ioapic state machine lockups and the like.
>>   
>
> Keir mentioned that Xen avoids masking/unmasking interrupts in the I/O
> APIC too much, because that has been problematic in the past.  Is that
> related to the problems you're talking about?  Is there anywhere which
> documents them?

Not in great detail.  I have some comments in the code and some messages
on the mailing list.

What I know is that in linux the historical practice has always been
to migrate irqs in interrupt context and in testing I found I could
lock up ioapic state machines when I migrate interrupts from process
context enough.

It really cleans up the code not to migrate interrupts in the
interrupt handler.  So I spent a week or two on it.

>> How does Xen handle domU with hardware directly mapped?
>>   
>
> We call that "pci passthrough".  Dom0 will bind the gsi to a pirq as
> usual, and then pass the pirq through to the domU.  The domU will bind
> the pirq to an event channel, which gets mapped to a Linux irq and
> handled as usual.

Interesting.  How does domU find out the pirq -> pci device mapping?

>> Temporally ignoring what we have to do to work with Xen 3.4.  I'm curious
>> if we could make the Xen dom0 irq case the same as the Xen domU case.
>>   
>
> It is already; once the pirq is prepared, the process is the same in
> both cases.

I 3/4 believe that.  map_domain_pirq  appears to setup a per domain
mapping between the hardware vector and the irq name it is known as.
So I don't see how that works for other domains.

msi is setup on a per domain basis.

Eric
