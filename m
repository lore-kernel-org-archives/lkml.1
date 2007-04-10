Return-Path: <linux-kernel-owner+w=401wt.eu-S1753938AbXDJWAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938AbXDJWAK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 18:00:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753934AbXDJWAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 18:00:10 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:45106 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753938AbXDJWAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 18:00:06 -0400
Message-ID: <461C084C.9020009@vmware.com>
Date: Tue, 10 Apr 2007 14:57:32 -0700
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
CC: Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@muc.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dan Hecht <dhecht@vmware.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 9/10] Vmi timer update.patch
References: <200704100006.l3A06RUR020644@zach-dev.vmware.com> <20070410023702.GJ10574@sequoia.sous-sol.org> <461BC373.10306@vmware.com> <20070410172429.GN10574@sequoia.sous-sol.org>
In-Reply-To: <20070410172429.GN10574@sequoia.sous-sol.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Wright wrote:
> * Zachary Amsden (zach@vmware.com) wrote:
>   
>>>> +void __init vmi_time_init(void)
>>>> +{
>>>> +	/* Disable PIT: BIOSes start PIT CH0 with 18.2hz peridic. */
>>>> +	outb_p(0x3a, PIT_MODE); /* binary, mode 5, LSB/MSB, ch 0 */
>>>>         
>>> That shouldn't be necessary using clockevents.
>>>       
>> Actually, I'm not so sure.  If clockevents simply masks the PIT when 
>> disabling it, we still have overhead of keeping the latch in sync, which 
>> requires a timer at the PIT frequency.  I can instrument to see how 
>> exactly the PIT gets disabled.
>>     
>
> It should switch from pit to vmi-timer, and the switch should do the state
> transistions on pit to go to unused mode.
>   

Yes, but unfortunately that is a nop:

        /*
         * Avoid unnecessary state transitions, as it confuses
         * Geode / Cyrix based boxen.
         */
        case CLOCK_EVT_MODE_SHUTDOWN:
                if (evt->mode == CLOCK_EVT_MODE_UNUSED)
                        break;
        case CLOCK_EVT_MODE_UNUSED:
                if (evt->mode == CLOCK_EVT_MODE_SHUTDOWN)
                        break;
        case CLOCK_EVT_MODE_ONESHOT:
                /* One shot setup */
                outb_p(0x38, PIT_MODE);

So switching from PIT to VMI does not disable PIT timer interrupts.  
Thus I have to keep this part of the patch.

>>> isn't this just your ->startup?
>>>       
>> Which structure has a ->startup function we can use?  Sorry if this 
>> seems ignorant, I'm not quite sure what you mean.
>>     
>
> The irq_chip.  IOW, it looks like a liberal sprinkling of LVTT vector
> initialization.
>   

Ahh, ok.

>   
>>>> +	local_irq_enable();
>>>> +	clockevents_notify(CLOCK_EVT_NOTIFY_RESUME, NULL);
>>>>         
>>> ...and resume?  Instead of letting clockevents core handle all of that,
>>> and just registering right here?
>>>       
>> It wasn't clear that clockevents would issue a resume notify for us; if 
>> so we could handle this setup in the callback, but it has to be done on 
>> the correct CPU.  I can try it and see if that works.
>>     
>
> I would've expected to simply register the clockevents device right here,
> and that should do the proper state transitions on the old device, as well
> as the new device.  Why do you need resume notify?

I was confused.  The problem is, time init is also highly confused on 
i386; the system comes up running on the PIT, then switches to the 
APIC.  This changes when the APIC gets activated, which is why we 
suspend and resume clockevents while making the irq wiring changes for 
the switch to APIC mode.  Internally, clockevents does the proper state 
transition for us on VMI clock events - they get suspended properly, 
subject to all the proper precautions needed to avoid spurious interrupt 
that are pending in hardware, then they get resumed properly without us 
having to worry about missed interrupts or failure to restart the clock.

But to get the clockevents to do state transitions for us without this 
explicit suspend / resume, we would need to model two clockevents; a 
clockevent running through the PIT, and a higher priority clockevent 
running through the APIC.  Then the logic could conceivably switch over 
for us, but there is an unavoidable race, since we are using the same 
IRQ in each case - hardware IRQ-0.  And an IRQ can only have one irq 
chip, so we can't put the code to switch to the new irq chip in the 
->startup for that chip, since it will never get called unless we set 
the chip before shutting down the old irq chip (through the PIT), which 
means the old PIT irq never gets shut down.

We can't workaround it however without one of these options:

1) stealing a different IRQ and knowing the fixed 1-1 IRQ<->IDT vector 
mapping for it.  We could conceivably hijack any number of IRQs, in any 
order by reserving them during VMI platform initialization, but due to 
the non-linearity with which IRQs are re-mapped to IDT vectors when the 
IO-APIC is activated, I though it simpler to just continue using IRQ-0, 
as this is linearly mapped by constants (instead of offset by 8, 
skipping some vectors and wrapping around).

2) Reusing the local timer IDT vector, since APIC won't be using it.   
Reset the IDT handler to point to our own handler.  We used to do this, 
providing smp_vmi_timer_interrupt and entry.S assembler code for our own 
low-level interrupt handlers.  There were objections to our adding 
low-level interrupt handling code instead of using the proper genirq 
infrastructure.

3) Reuse the local timer IDT vector as our fixed IDT vector.  We must 
reset the IDT vector for this to point to a do_IRQ style handler which 
enters the genirq code.  So, reserve a non-zero platform IRQ and set the 
IDT vector for local timer to vector to interrupt[IRQ].  Now, set the 
irq chip for this IRQ to be a per-cpu handler and give it the VMI 
interrupt chip.

I can't really think of anything else that is feasible.  And keep in 
mind, all of these options require modeling the VMI timer as two 
separate clockevents.  Is it worth the complexity to avoid the suspend / 
resume?  These hacks seem even less palatable, to me, while suspend / 
resume of clock event scheduling seems to be a well defined operation.

Zach
