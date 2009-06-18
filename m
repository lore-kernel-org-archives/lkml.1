Return-Path: <linux-kernel-owner+w=401wt.eu-S1759427AbZFRC7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759427AbZFRC7V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 22:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758865AbZFRC7C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 22:59:02 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:47073 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759081AbZFRC7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 22:59:00 -0400
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
	<4A392896.9090408@goop.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 17 Jun 2009 19:58:49 -0700
In-Reply-To: <4A392896.9090408@goop.org> (Jeremy Fitzhardinge's message of "Wed\, 17 Jun 2009 10\:32\:06 -0700")
Message-ID: <m1zlc6memu.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: jeremy@goop.org, keir.fraser@eu.citrix.com, xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jeremy Fitzhardinge <jeremy@goop.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
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

> On 06/17/09 05:02, Eric W. Biederman wrote:
>> Trying to understand what is going on I just read through Xen 3.4 and the
>> accompanying 2.6.18 kernel source.
>>    
>
> Thanks very much for spending time on this.  I really appreciate it.
>
>> Xen has a horrible api with respect to io_apics.  They aren't even real
>> io_apics when Xen is done ``abstracting'' them.
>>
>> Xen gives us the vector to write.  But we get to assign that
>> vector arbitrarily to an ioapic and vector.
>>
>> We are required to use a hypercall when performing the write.
>> Xen overrides the delivery_mode and destination, and occasionally
>> the mask bit.
>>    
>
> Yes, it's a bit mad.  All those writes are really conveying is the vector, and
> Xen gave that to us in the first place.

Pretty much.  After seeing the pirq to event channel binding I had to hunt
like mad to figure out why you needed anything else.

>> We still have to handle polarity and the trigger mode.  Despite
>> the fact that Xen has acpi and mp tables parsers of it's own.
>>
>> I expect it would have been easier and simpler all around if there
>> was just a map_gsi event channel hypercall.  But Xen has an abi
>> and an existing set of calls so could aren't worth worrying about
>> much.
>>    
>
> Actually I was discussing this with Keir yesterday.  We're definitely open to
> changing the dom0 API to make things simpler on the Linux side.  (The dom0 ABI
> is more fluid than the domU one, and these changes would be backwards-compatible
> anyway.)
>
> One of the options we discussed was changing the API to get rid of the exposed
> vector, and just replace it with an operation to directly bind a gsi to a pirq
> (internal Xen physical interrupt handle, if you will), so that Xen ends up doing
> all the I/O APIC programming internally, as well as the local APIC.

As an abstraction layer I think that will work out a lot better long term.

Given what iommus with irqs and DMA I expect you want something like
that, that can be used from domU.  Then you just make allowing the
operation conditional on if you happen to have the associated hardware
mapped into your domain.

> On the Linux side, I think it means we can just point pcibios_enable/disable_irq
> to our own xen_pci_irq_enable/disable functions to create the binding between a
> PCI device and an irq.

If you want xen to assign the linux irq number that is absolutely the properly place
to hook.

> I haven't prototyped this yet, or even looked into it very closely, but it seems
> like a promising approach to avoid almost all interaction with the apic layer of
> the kernel.  xen_pci_irq_enable() would have to make its own calls
> acpi_pci_irq_lookup() to map pci_dev+pin -> gsi, so we would still need to make
> sure ACPI is up to that job.
>
>> Xen's ioapic affinity management logic looks like it only works
>> on sunny days if you don't stress it too hard.
> Could you be a bit more specific?  Are you referring to problems that you've
> fixed in the kernel which are still present in Xen?

Problems I have avoided.

When I was messing with the irq code I did not recall finding many
cases where migrating irqs from process context worked without hitting
hardware bugs.  ioapic state machine lockups and the like.

I currently make that problem harder on myself by not allocating vectors
globally, but it gives an irq architecture that should work for however
much I/O we have in the future.  

The one case that it is most likely to work is lowest priority interrupt
delivery where the hardware decides which cpu it should go to and it only
takes a single register write to change the cpu mask, and the common case
in Xen.

When you start directing irqs at specific cpus things get a lot easier
to break.

>> It looks like the only thing Xen gains by pushing out the work of
>> setting the polarity and setting edge/level triggering is our database
>> of motherboards which get those things wrong.
>>    
>
> Avoiding duplication of effort is a non-trivial benefit.
>
>> So I expect the thing to do is factor out acpi_parse_ioapic,
>> mp_register_ioapic so we can share information on borked BIOS's
>> between the Xen dom0 port and otherwise push Xen pseudo apic handling
>> off into it's strange little corner.
>
> Yes, that's what I'll look into.

How does Xen handle domU with hardware directly mapped?

Temporally ignoring what we have to do to work with Xen 3.4.  I'm curious
if we could make the Xen dom0 irq case the same as the Xen domU case.

Eric
