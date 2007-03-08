Return-Path: <linux-kernel-owner+w=401wt.eu-S1751441AbXCHIBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441AbXCHIBQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 03:01:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751455AbXCHIBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 03:01:16 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:37780 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751441AbXCHIBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 03:01:14 -0500
Message-ID: <45EFC2C9.10603@vmware.com>
Date: Thu, 08 Mar 2007 00:01:13 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: tglx@linutronix.de
CC: Daniel Arai <arai@vmware.com>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
       Daniel Hecht <dhecht@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: + stupid-hack-to-make-mainline-build.patch added to -mm tree
References: <200703060654.l266sVxr014860@shell0.pdx.osdl.net>	 <20070306084258.GA15745@elte.hu>	 <20070306084647.GA16280@elte.hu> <45ED2C82.3080008@vmware.com>	 <1173178774.24738.311.camel@localhost.localdomain>	 <45EDD82F.90204@vmware.com>	 <1173225182.24738.507.camel@localhost.localdomain>	 <45EE0628.1080108@goop.org> <45EE08E8.2020008@vmware.com>	 <1173228544.24738.514.camel@localhost.localdomain>	 <45EE0D10.7070807@vmware.com>	 <1173230305.24738.529.camel@localhost.localdomain>	 <45EE1EA3.90803@vmware.com>	 <1173256666.24738.576.camel@localhost.localdomain>	 <45EEF966.6060902@goop.org>	<Line.LNX.4.64.0703071304080.1851@d.namei>	 <45EF0CF5.5090305@goop.org>  <45EF175D.6030609@vmware.com>	 <1173302503.24738.795.camel@localhost.localdomain>	 <45EF372E.7030600@goop.org>	 <1173308717.24738.898.camel@localhost.localdomain>	 <45EF49E9.7040509@vmware.com>	 <1173313373.24738.937.camel@localhost.localdomain>	 <45EF6077.9090302@vmware.com> <1173338928.24738.979.camel@localhost.local
 domain>
In-Reply-To: <1173338928.24738.979.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Wed, 2007-03-07 at 17:01 -0800, Daniel Arai wrote:
>   
>> But more importantly, we want a kernel that can run both on native hardware and 
>> in a paravirtualized environment.  Linux doesn't really provide abstractions for 
>>   replacing the appropriate code.  We tried to hook into the source code at a 
>> level that seemed possible.
>>     
>
> Again. You just refuse to change your implementation and you want to
> keep it by arguing how hard it is because there are no abstractions.
>   

It is no longer possible to change our _hypervisor_ implementation.  The 
Linux side of our code is entirely flexible, and we are trying to change 
it, but it hasn't always been clear what you want us to do.

> Your prayer wheel argument of missing abstractions and easiness of
> emulating things is annoying. If you think it is better to emulate APIC,
> please emulate it without paravirt ops. If you want the speed
> improvement, work with us to create the interfaces and abstractions
> which are necessary to have a sane, maintainable and useful for all
> hypervisors implementation.
>   

That's what we are doing.  Our prayer wheel would be easier appeased if 
you actually told us which parts of the VMI timer you objected to.  As I 
understand it now:

1) We should not call into external functions in other time sources; any 
common code should be merged up
2) We should not be using global_clock_event; it is a horrible hack 
which you want to remove
3) We should not use the smp_apic_timer_interrupt assembly code which 
calls up to the lapic timer handlers
4) We should not add our own assembly code to call out to a local timer 
handler (from Ingo)

These last two points create a conflict which is a little tricky to 
solve.  We can't add our own custom timer handler, and we can't re-use 
the APIC timer handler.  But there is no timer handler available on i386 
that works, since the handlers will fall back to either PIC or IO-APIC 
edge handling.  Using either of those for the local timer interrupt on 
SMP does not work because they assume traditional IRQ semantics - an IRQ 
raised from the bus should be serviced by one processor.  Re-raises of 
the same IRQ on remote processors are locked out by the handler, and 
dropped.  Thus simultaneous local timers firing on multiple CPUs cause 
only one to be serviced.

This does not work for local timer interrupts in NO_HZ mode, because 
they must always be serviced so that they can reschedule the next local 
timer.  I have a proposed solution to this issue, but it fails to work 
when the IO-APIC assumes control of all IRQs based on ACPI results 
(which we control, but can't change because of compatibility issues with 
other operating systems).

My proposal is to keep IRQ-0 as the timer interrupt, on all CPUs, but 
fire it from the LAPIC after local apic timers get initialized.  We 
would do this by converting the irq handler using set_irq_handler(0, 
handle_percpu_irq).  The only problem is the IO-APIC code will want to 
take over IRQ0 and convert it to an edge triggered IO-APIC interrupt.  
But for the local irq handlers to work, we have to keep them using the 
handle_percpu_irq handler, and can't let the IO-APIC steal these 
vectors.  There is no way to do conditionally for just a specific set of 
IRQs in tree today, so we would need to add a special case to io_apic.c 
to allow early boot code to reserve specific vectors so they are not 
subsumed by the IO-APIC.  This seems reasonable, but is a special case.

If, on the other hand, we are allowed to use our own assembly code to 
call out to our local timer handler (dropping constraint #4 above), we 
can simply rewire LOCAL_TIMER_VECTOR to point to this code, but now we 
must emulate the semantics of irq_enter / leave / etc inside our code, 
which is also not the cleanest solution.  We used to do this, and it 
caught flak I believe from Ingo.

The basic problem is that a local IRQ doesn't behave like a global IRQ, 
and the i386 backend is unaware of how to set up any local IRQs except 
in the case of local APIC, but you have told us we should not re-use the 
APIC handlers by overloading global_clock_event.  The patches we sent 
out recently did just this, but seemed to meet even more violence than 
our previous way of doing things.

So the question is, which approach do you prefer?

Zach
