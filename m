Return-Path: <linux-kernel-owner+w=401wt.eu-S1761496AbXK1X3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761496AbXK1X3r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 18:29:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756551AbXK1X3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 18:29:39 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:52037 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154AbXK1X3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 18:29:37 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Neil Horman <nhorman@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Ben Woodard <woodard@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>, hbabu@us.ibm.com
Subject: Re: [PATCH] kexec: force x86_64 arches to boot kdump kernels on boot cpu
References: <m1lk8jka8j.fsf@ebiederm.dsl.xmission.com>
	<474C64CB.7080004@redhat.com>
	<20071127194220.GG14887@hmsendeavour.rdu.redhat.com>
	<20071127200011.GA3703@redhat.com>
	<20071127222408.GH24223@one.firstfloor.org>
	<474CA733.9050908@redhat.com> <20071128153649.GC3192@redhat.com>
	<20071128160206.GA21286@hmsendeavour.rdu.redhat.com>
	<20071128190525.GD3192@redhat.com>
	<m1d4tudun5.fsf@ebiederm.dsl.xmission.com>
	<20071128210944.GA28236@hmsendeavour.rdu.redhat.com>
Date: Wed, 28 Nov 2007 16:27:43 -0700
In-Reply-To: <20071128210944.GA28236@hmsendeavour.rdu.redhat.com> (Neil
	Horman's message of "Wed, 28 Nov 2007 16:09:44 -0500")
Message-ID: <m18x4idk7k.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Horman <nhorman@redhat.com> writes:

> On Wed, Nov 28, 2007 at 12:42:22PM -0700, Eric W. Biederman wrote:
>> Vivek Goyal <vgoyal@redhat.com> writes:
>> 
>> > Ok. Got it. So in this case we route the interrupts directly through LAPIC
>> > and put LVT0 in ExtInt mode and IOAPIC is bypassed.
>> >
>> > I am looking at Intel Multiprocessor specification v1.4 and as per figure
>> > 3-3 on page 3-9, 8259 is connected to LINTIN0 line, which in turn is 
>> > connected to LINTIN0 pin on all processors. If that is the case, even in
>> > this mode, all the CPU should see the timer interrupts (which is coming
>> > from 8259)?
>> 
>> However things are implemented completely differently now.  I don't think
>> the coherent hypertransport domain of AMD processors actually routes
>> ExtINT interrupts to all cpus but instead one (the default route?) is
>> picked.
>> 
>
> http://www.hypertransport.org/docs/tech/HTC20051222-0046-0008-Final-4-21-06.pdf
> Table 143 suggest to me that legacy interrupts should be routed to all cpus,
> which certainly doesn't seem to be the case in this situation.  Perhaps Nvidia
> goofed on that part of the specification?

Once it hits the coherent hypertransport fabric only AMD has control.
The packet does not have a destination field that could specify which
cpu.  So Nvidia could not have goofed.  It is a magic property of
the coherent hypertransport domain as which cpu gets it.


>> So I think for the kdump case we pretty much need to use an IOAPIC
>> in virtual wire mode for recent AMD systems.
>> 
>> For current Intel systems I believe either scenario still works.
>> 
>> > Can you print the LAPIC registers (print_local_APIC) during normal boot
>> > and during kdump boot and paste here?
>> 
>> It's worth a look.
>> 
>> I still think we need to just use apic mode at kernel startup, and
>> be done with it.
>> 
> Certainly, this seems like the best solution long term.
>
> So I'm looking at the implementation for 64 bit system, and it seems a little
> cleaner than 32 bit setup.  I'm wondering if we can just call setup_IO_APIC
> immediately after init_IRQ in start_kernel?  Could it be that straightforward?

Pretty much.

The essence of what I did last round was put at the end of
init_IRQ():


if (!disable_apic && cpu_has_apic) {
	/*
	 * Switch to APIC mode.
	 */
	setup_local_APIC();

	/*
	 * Now start the IO-APICs
	 */
	if (smp_found_config && !skip_ioapic_setup && nr_ioapics)
		setup_IO_APIC();
	else
		nr_ioapics = 0;
}

Beyond that it is just dotting i's and crossing t's.

Eric
