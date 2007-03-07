Return-Path: <linux-kernel-owner+w=401wt.eu-S2992731AbXCGXZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992731AbXCGXZb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 18:25:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992734AbXCGXZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 18:25:31 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:58531 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2992731AbXCGXZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 18:25:30 -0500
Message-ID: <45EF49E9.7040509@vmware.com>
Date: Wed, 07 Mar 2007 15:25:29 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: tglx@linutronix.de
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       john stultz <johnstul@us.ibm.com>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: + stupid-hack-to-make-mainline-build.patch added to -mm tree
References: <200703060654.l266sVxr014860@shell0.pdx.osdl.net>	<45ED16D2.3000202@vmware.com> <20070306084258.GA15745@elte.hu>	<20070306084647.GA16280@elte.hu> <45ED2C82.3080008@vmware.com>	<1173178774.24738.311.camel@localhost.localdomain>	<45EDD82F.90204@vmware.com>	<1173225182.24738.507.camel@localhost.localdomain>	<45EE0628.1080108@goop.org> <45EE08E8.2020008@vmware.com>	<1173228544.24738.514.camel@localhost.localdomain>	<45EE0D10.7070807@vmware.com>	<1173230305.24738.529.camel@localhost.localdomain>	<45EE1EA3.90803@vmware.com>	<1173256666.24738.576.camel@localhost.localdomain>	<45EEF966.6060902@goop.org>	<Line.LNX.4.64.0703071304080.1851@d.namei>	<45EF0CF5.5090305@goop.org>  <45EF175D.6030609@vmware.com>	<1173302503.24738.795.camel@localhost.localdomain>	<45EF372E.7030600@goop.org> <1173308717.24738.898.camel@localhost.localdomain>
In-Reply-To: <1173308717.24738.898.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On the other hand we yet see things like:
>
>         /* We use normal irq0 handler on cpu0. */
>         time_init_hook();
>
> Which is just reaching into the kernel code directly and does not handle
> the clock event interrupt self contained. clockevents is not bound to
> IRQ0 and this kind of hackery is exactly what we need to avoid in order
> to get this maintainable.
>
> Once this is used by paravirt implementations a change to the
> mach-default implementation will break stuff left and right.
>   

We've fixed that already.  Thanks for pointing it out.  We were just 
trying to re-use code.

> Also the whole LAPIC business is so horrible, that it hurts. The generic
> interrupt layer is there since almost a year and we still see the crude
> emulation of hardware and assumptions of irq0 setup all over the place.
>
> We carefully need to define, which existing kernel interfaces are used /
> hooked in which way.
>
> If the paravirt implementations actually use the already available
> abstractions in the way in which those abstractions are designed, then
> we get into a maintainable design. If there are shortcomings on those
> abstractions we need to fix them in a sane way or provide a _common_
> workaround (e.g. 128 bit math back and forth library) without impacting
> the main kernel code.
>
> Looking at vmitimer.c and the number of hardcoded assumptions are
> telling me, that we are heading in exactly the opposite direction.
>   

No, VMI timer is unique because for SMP, it is based on the APIC.  On 
i386, SMP is hardwired to depend on the APIC, and so we simply re-use 
the pieces of it which are there, with the same assumptions about irqs, 
and hardware behavior, good or bad.  We just have a different way of 
telling the LAPIC when to deliver interrupts.

The alternative is to pretty much completely copy apic.c into vmi.c or 
vmitimer.c, which seems a rather bad idea, since now two copies of 
nearly identical code need to be maintained.

> Yes, if they are used in a sane and self contained way without reaching
> all over the place and expecting that those functions, which are not
> part of the paravirt interfaces will work for ever.
>   

But we definitely need pieces of the core APIC dependent code.  Xen 
needs pieces of it too, but very select pieces for SMP boot.  The 
ugliness you point out is there, but the reason it is there is not 
because the paravirt code is cluttered, it is because the i386 code is 
so hardwired to use the APIC model that there is pain separating from it.

The correct solution here is to properly separate the APIC, SMP, and 
timer code so the logic of it which we want to reuse is separated from 
the hardware dependence.  Clock events and clocksources take care of 
most of the timer issues, but there is still ugliness from SMP timer 
events depending on having part of the APIC infrastructure for wiring 
the interrupt gates.

> No it's not an absolute blocker, as long as we can take care, that the
> number of incarnations is 
>
> - designed to be shareable between hypervisors which have the same time
> model
> - common code like the 128 bit math is in a shared library
> - self contained and not reaching out into core kernel code for no good
> reason
>   
> Same goes for clock events, interrupts and other core facilities.

I think that is what everyone wants.  This is an iterative process.  We 
certainly don't want to reach out into core kernel code unless there is 
a good reason to do so, and with every development of clock events, 
sources, and interrupts, we have less of a reason to do so, and the code 
gets cleaner and more maintainable.

Zach
