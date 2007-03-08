Return-Path: <linux-kernel-owner+w=401wt.eu-S1030826AbXCHWjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030826AbXCHWjR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 17:39:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030830AbXCHWjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 17:39:17 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:55696 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030826AbXCHWjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 17:39:15 -0500
Message-ID: <45F09093.6070302@vmware.com>
Date: Thu, 08 Mar 2007 14:39:15 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: tglx@linutronix.de, Jeremy Fitzhardinge <jeremy@goop.org>,
       john stultz <johnstul@us.ibm.com>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Pratap Subrahmanyam <pratap@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Daniel Hecht <dhecht@vmware.com>, Daniel Arai <arai@vmware.com>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: hardwired VMI crap
References: <1173302503.24738.795.camel@localhost.localdomain> <45EF372E.7030600@goop.org> <1173308717.24738.898.camel@localhost.localdomain> <45EF49E9.7040509@vmware.com> <20070308091019.GA19460@elte.hu> <45EFE010.7080108@vmware.com> <1173352154.24738.1023.camel@localhost.localdomain> <45F0761C.6060107@vmware.com> <20070308211306.GA20934@elte.hu> <45F08B71.50606@vmware.com> <20070308223317.GC30113@elte.hu>
In-Reply-To: <20070308223317.GC30113@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Zachary Amsden <zach@vmware.com> wrote:
>
>   
>> Ingo, either you or Thomas have vetoed every attempt we have made to 
>> make our code operate with clockevents. [...]
>>     
>
> this is news to me - do you have any proof of such a veto?
>   

Yes, your refusal to discuss any technical details when asked point 
blank which solution you prefer, and your continued whining and 
threatening to unmerge our code.

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

Zach

