Return-Path: <linux-kernel-owner+w=401wt.eu-S933297AbXCHUqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933297AbXCHUqY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 15:46:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933306AbXCHUqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 15:46:24 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:45962 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933297AbXCHUqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 15:46:22 -0500
Message-ID: <45F0761C.6060107@vmware.com>
Date: Thu, 08 Mar 2007 12:46:20 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: tglx@linutronix.de
CC: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       john stultz <johnstul@us.ibm.com>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Pratap Subrahmanyam <pratap@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Daniel Hecht <dhecht@vmware.com>, Daniel Arai <arai@vmware.com>,
       Chris Wright <chrisw@sous-sol.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>
Subject: Re: hardwired VMI crap
References: <45EE1EA3.90803@vmware.com>	 <1173256666.24738.576.camel@localhost.localdomain>	 <45EEF966.6060902@goop.org> <Line.LNX.4.64.0703071304080.1851@d.namei>	 <45EF0CF5.5090305@goop.org> <45EF175D.6030609@vmware.com>	 <1173302503.24738.795.camel@localhost.localdomain>	 <45EF372E.7030600@goop.org>	 <1173308717.24738.898.camel@localhost.localdomain>	 <45EF49E9.7040509@vmware.com> <20070308091019.GA19460@elte.hu>	 <45EFE010.7080108@vmware.com> <1173352154.24738.1023.camel@localhost.localdomain>
In-Reply-To: <1173352154.24738.1023.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Thu, 2007-03-08 at 02:06 -0800, Zachary Amsden wrote:
>   
>>>> The correct solution here is to properly separate the APIC, SMP, and 
>>>> timer code so the logic of it which we want to reuse is separated from 
>>>> the hardware dependence.  Clock events and clocksources take care of 
>>>> most of the timer issues, but there is still ugliness from SMP timer 
>>>> events depending on having part of the APIC infrastructure for wiring 
>>>> the interrupt gates.
>>>>     
>>>>         
>>> what are you talking about? A clockevents driver does not need to know 
>>> about lapic details, at all. In terms of interrupt gates for the 
>>> hypervisor to notify about clock events - use a virtual interrupt 
>>> controller via genirq.
>>>   
>>>       
>> See my last e-mail.  It is not possible on i386, since local per-cpu 
>> interrupts are only supported via the APIC.
>>     
>
> It is not possible from your POV. It is possible, as we have already a
> complete irq abstraction layer, which supports _ALL_ of the
> requirements.
>
> To make use of it in a maintainable way, it just needs the work of doing
> a proper client for the genirq layer, which get's its interrupt injected
> by the hypervisor.
>
> genirq() does not care by which mechanism handle_percpu_irq() is called.
>
> We provided the abstractions and you just tell us straight in the face,
> that your hypervisor works that way and therefor we have to accept that
> you do it that way.
>
> It's not rocket science to implement an abstract interrupt controller,
> which lets you inject per cpu or global interrupts into the generic
> layer. It needs some preparatory work to distangle the boot code
> assumptions from the implicit hardware, but this is a better spent time,
> than another set of hackery, which you already advertised for smpboot.c
>   

When we're about two weeks away from a product release and you are 
threatening to unmerge or block our code because we didn't create an 
abstract interrupt controller, we re-used the APIC and IO-APIC, this is 
uber rocket science.  We've been doing things this way, with public 
patches for over a year, and you've even been CC'd on some of the 
discussions.  So it is a little late to tell us - "redesign your 
hypervisor, or else.."

> All we want you and the other hypervisor folks to do is to 
>
> - use existing abstractions in the way they are designed
> - create new ones where applicable
>   

Great.
> - break the hardwired hardware assumptions, so a sane emulation model
> can be used.
>   

Why?  This is your own invention, as you think it would make life 
easier.  It doesn't - you still have real hardware to deal with, and 
your code will always be designed to operate on silicon with these 
hardwired assumptions.  Breaking away from that can actually make the 
code more complex, both in the hypervisor and in Linux.

>   
>> So far, all you have done is not complain about our code until it was 
>> merged, the pursue every tactic possible to break it.  It is not us that 
>> are stonewalling.
>>     
>
> You have been told before. Andi asked you more than once to move to
> clockevents.
>   

Which we have done.  And now you refuse to give any feedback on 
technical points, but maintain an objection to the way we have done it.

> If you can not change your hypervisor model to use a sane abstraction of
> interrupts, then please emulate lapic, io_apic and everything else
> _OUTSIDE_ of the kernel.
>   

We faithfully emulate lapic, io_apic, the pit, pic, and a normal 
interrupt subsystem.  We can't magically stop using these things because 
we have to support traditional full virtualization.  Which means any 
version of Linux, virtual interrupt controller or not, is going to boot 
up, find these things, and try to use them.  So for a paravirt kernel, 
either we have to disable each of these things in the Linux code or just 
re-use them.

So we re-use them.  We don't even change their semantics.  Where we get 
into trouble is the fact that only the lapic can deliver per-cpu timer 
IRQs, and we need to provide a better time abstraction than TSC.  So we 
need a time device, but there is no way to implement it in the 
traditional hardware model.

And I ask again for your feedback on which approach you think is correct:

1) Rewrite the interrupt subsystem of our hypervisor, making it 
incompatible with full virtualization, so that we can support an 
abstract interrupt controller with a "clean" interface
2) Reuse the same method that HPET, PIT and other time clients in i386 
use - the global_clock_event pointer which allows you to wrest control 
back from the APIC and reuse the lapic_events local clockevents.
3) Create a new low level interrupt handler for the per-cpu VMI timer 
IRQs instead of re-using the APIC handler
4) Use the irq APIs to allocate IRQ-0 as a percpu IRQ, then change the 
IO-APIC code so it can know not to convert this PIC IRQ into a IO-APIC 
edge IRQ.
5) Disable the io-apic code entirely in paravirt mode.  Rather than 
change it, merge a parallel copy of it into the VMI code
 so that we can use the 99% of the code we need, with the one bugfix for 
#4 above
6) Disable the apic code entirely in paravirt mode.  Rather than change 
it, merge a parallel copy of into the VMI code so that we can use the 
90% of the code we need, with changes to the LVT0 timer handling.
7) For SMP only, allocate a non-shared IO-APIC IRQ, then after the 
IO-APIC is initialized, magically switch this to a percpu handler and 
start delivering local timer interrupts via this IRQ.
8) Create a pie-in-the-sky single interrupt source, reserve an IDT 
vector for it (or steal the lapic timer slot), and use the irq apis to 
set it up to be handled as a per-cpu interrupt.  This actually sounds 
pretty good, to me.  The only problem is we will need to switch the 
timer IRQ from IRQ 0 to this vector when the APIC is initialized, but I 
think we already have all the machinery we need to handle that.
9) ???

This is a serious question, I would appreciate a serious response 
instead of snide comments about the crappiness of our interface and our 
code.  Which do help a little, because by process of elimination,  we 
can rule out the approaches you don't like.  But it would be more 
productive if we could carry on a traditional dialogue and I could just 
ask a question and you could answer and vice versa.

Zach
