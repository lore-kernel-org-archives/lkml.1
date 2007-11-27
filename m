Return-Path: <linux-kernel-owner+w=401wt.eu-S1757882AbXK0PDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757882AbXK0PDh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 10:03:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755332AbXK0PDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 10:03:30 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:34962 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbXK0PDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 10:03:30 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andi Kleen <ak@suse.de>
Cc: Neil Horman <nhorman@redhat.com>, Neil Horman <nhorman@tuxdriver.com>,
       hbabu@us.ibm.com, vgoyal@in.ibm.com, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kexec: force x86_64 arches to boot kdump kernels on boot cpu
References: <20071127014740.GA28622@hmsreliant.think-freely.org>
	<20071127131355.GA14887@hmsendeavour.rdu.redhat.com>
	<m1y7cjkec2.fsf@ebiederm.dsl.xmission.com>
	<200711271445.56792.ak@suse.de>
Date: Tue, 27 Nov 2007 07:56:44 -0700
In-Reply-To: <200711271445.56792.ak@suse.de> (Andi Kleen's message of "Tue, 27
	Nov 2007 14:45:56 +0100")
Message-ID: <m1lk8jka8j.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <ak@suse.de> writes:

> his is any less reliable that what we have currently.
>> 
>> It doesn't make things more reliable, and it adds code to a code path
>> that already has to much code to be solid reliable (thus your
>> problem). 
>> 
>> Putting the system back in PIC legacy mode on the kexec on panic path
>> was supposed to be a short term hack until we could remove the need
>> by always deliver interrupts in apic mode.
>> 
>> If you can't root cause your problem and figure out how the apics
>> are misconfigured for legacy mode
>
> Probably legacy mode always routes to CPU #0. Makes sense and is
> not really a misconfiguration of legacy mode.

Possible. So far I have not seen a hardware setup that would force
interrupts to cpu #0 in legacy mode.  But I would not be truly
surprised if it happened that there was hardware that only worked that
way.

> But if CPU #0 has interrupts disabled no interrupts get delivered.
>
> So choices are:
> - Move to CPU #0
> - Do not use legacy mode during shutdown.
    (Do not use legacy mode in the kdump kernel. removing it from shutdown
     is just minor optimization)
> - Or do not rely on interrupts after enabling legacy mode
> - Or do not disable interrupts on the other CPUs when they're
> halted.
>
> First and last option are probably unreliable for the kdump case.
> Second or third sound best. 
>
> I suspect the real fix would be to enable IOAPIC mode really
> early and never use the timers in legacy mode. Then the kdump
> kernel wouldn't care about the legacy mode pointing to the wrong CPU.

Exactly.  If we can work out the details that should be a much more reliable
mode of operation.

> IIrc Eric even had  a patch for that a long time ago, but it broke some 
> things so it wasn't included. But perhaps it should be revisited.

My real problem was the failure case was obscure (a bad interaction
with ACPI on Linus's laptop) and I didn't have the time to track it
down when it showed up.

My patch had two parts.  Some cleanups to enable the code to be enabled
early, and the actually early enable.  I figure if we can get the
cleanups in one major kernel version and then in the next enable
the apic mode before we start getting interrupts we should be in good
shape.

I expect with x86 becoming an embedded platform with multiple cpus we
may start seeing systems that don't actually support legacy PIC mode
for interrupt delivery.

Eric
