Return-Path: <linux-kernel-owner+w=401wt.eu-S1030857AbXCHW6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030857AbXCHW6o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 17:58:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030856AbXCHW6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 17:58:43 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:43657 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030857AbXCHW6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 17:58:42 -0500
Message-ID: <45F09521.1060308@vmware.com>
Date: Thu, 08 Mar 2007 14:58:41 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: tglx@linutronix.de, Ingo Molnar <mingo@elte.hu>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       john stultz <johnstul@us.ibm.com>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Pratap Subrahmanyam <pratap@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Daniel Hecht <dhecht@vmware.com>,
       Daniel Arai <arai@vmware.com>, Chris Wright <chrisw@sous-sol.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>
Subject: Re: hardwired VMI crap
References: <45EE1EA3.90803@vmware.com> <1173352154.24738.1023.camel@localhost.localdomain> <45F0761C.6060107@vmware.com> <200703082239.44585.ak@suse.de>
In-Reply-To: <200703082239.44585.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:

> At least in Linux we don't really work with deadlines; if there 
> are issues they need to be fixed even if it takes longer. I don't 
> expect the version in .21 to be really usable anyways; it is clearly
> still in development.
>   

It was working, and I expect to have it working again.  It is not in 
development, but we urgently need to find a way to fix the problems 
created when Ingo hobbled it by removing NO_IDLE_HZ code from 2.6.21..

>   
>> we re-used the APIC and IO-APIC, this is  
>> uber rocket science.  We've been doing things this way, with public 
>> patches for over a year, and you've even been CC'd on some of the 
>> discussions.  So it is a little late to tell us - "redesign your 
>> hypervisor, or else.."
>>     
>
> It shouldn't touch the hypervisor, just the paravirt VMI backend shouldn't it?
> I assume you could do a very minimal APIC layer that is just enough to 
> talk to your softapic and a genapic backend for IPIs.
>
> At least I would welcome anything that shrinks the number of 
> paravirt hooks.
>
> I'm just not sure it would be less hooks: you would probably need
> functions to start other CPUs at least.
>   
 
Anything that attempts to create this uber multi-virtual interrupt / 
timer / IPI / clock management beast is going to add a huge number of 
paravirt hooks, because the vendor backends will be different for all of 
these.

>  
> I must admit I also didn't quite get what was the big problem with
> hooking apic_read/apic_write.
>   

You mean why we need them?  They make APIC writes faster, since 
otherwise they would trap and emulate, which is slow, and APIC is on 
critical paths.  Or why people object to them?  I don't get the latter 
either.

> For the timer you just need to use a own exclusive 
> clocksource that never touches PIT.
>   

We have that working fine.  It is getting the clock event to work 
independently from the lapic timer that is difficult because of the i386 
backend.

>   
>> We faithfully emulate lapic, io_apic, the pit, pic, and a normal 
>> interrupt subsystem. We can't magically stop using these things because  
>> we have to support traditional full virtualization.  Which means any 
>> version of Linux, virtual interrupt controller or not, is going to boot 
>> up, find these things, and try to use them.  So for a paravirt kernel, 
>> either we have to disable each of these things in the Linux code or just 
>> re-use them.
>>     
>
> If you don't enable them they should be already disabled as default 
> state, shouldn't they? 
>
> With an own custom clocksource and possible own APIC layer nobody
> would ever enable the APICs.
>   

But we enable and use them, in both full-virt, and paravirt mode.  So we 
really would need to duplicate the code, almost exactly for our "virtual 
interrupt controller", which would really just be a wrapper on top of a 
nearly identical APIC or IO-APIC implementation.

>> 1) Rewrite the interrupt subsystem of our hypervisor, making it 
>> incompatible with full virtualization, so that we can support an 
>> abstract interrupt controller with a "clean" interface
>>     
>
> What do you mean with rewrite? It's quite easy to add a new
> backend to the generic IRQ code. They aren't a lot of code.
>   

Yes, but we would then need to duplicate the APIC or IO-APIC 
implementation, because that is the hardware we emulate and use.  We 
just want a different way to fire local timers, that is all.

> You could probably do a much simpler version, couldn't you? A lot of 
> the stuff in apic.c/io_apic.c shouldn't be needed for a clean virtual
> interface. But yes it would probably be still a lot of code.
>   

Yes, we could do a cleaner simpler version.  But then we need to write 
this new interrupt controller code for both the hypervisor and for 
Linux.  And the fact that it is cleaner doesn't make it any nicer or 
perform any better - it is just another dependency between the kernel 
and hypervisor that then becomes hard to change.  So we would rather 
stay as close to the hardware design as possible.

> Still (2) is probably best for now, but the other alternatives
> are not as ridiculous as you paint them.
>   

We have (2) working.  But Thomas apparently hated it.  The idea I have 
about a single-IRQ source interrupt controller for timers seems pretty 
nice, and does almost exactly encapsulate the one difference we have 
from standard APIC / IO-APIC hardware - a different way to drive local 
timers.

Thanks for your feedback,

Zach
