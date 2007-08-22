Return-Path: <linux-kernel-owner+w=401wt.eu-S933456AbXHVUs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933456AbXHVUs4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 16:48:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933371AbXHVUsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 16:48:42 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:33927 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933357AbXHVUsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 16:48:40 -0400
Message-ID: <46CC9FF2.3040406@vmware.com>
Date: Wed, 22 Aug 2007 13:43:30 -0700
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Chris Wright <chrisw@sous-sol.org>, Avi Kivity <avi@qumranet.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] Add I/O hypercalls for i386 paravirt
References: <46CBC842.4070100@vmware.com> <20070822102217.GE2642@bingen.suse.de> <46CC68D9.5060200@vmware.com> <20070822175918.GB8058@bingen.suse.de> <46CC6D63.2010204@vmware.com> <20070822194632.GD8058@bingen.suse.de>
In-Reply-To: <20070822194632.GD8058@bingen.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>
> How is that measured? In a loop? In the same pipeline state?
>
> It seems a little dubious to me.
>   

I did the experiments in a controlled environment, with interrupts 
disabled and care to get the pipeline in the same state.  It was a 
perfectly repeatable experiment.  I don't have exact cycle time anymore, 
but they were the tightest measurements I've even seen on cycle counts 
because of the unique nature of serializing the processor for the fault 
/ privilege transition.  I tested a variety of different conditions, 
including different types of #GP (yes, the cost does vary), #NP, #PF, 
sysenter, int $0xxx.  Sysenter was the fastest, by far.  Int was about 
5x the cost.  #GP and friends were all about similar costs.  #PF was the 
most expensive.


>   
>>>> to verify protection in the page tables mapping the page allows 
>>>> execution (P, !NX, and U/S check).  This is a lot more expensive than a 
>>>>    
>>>>         
>>> When the page is not executable or not present you get #PF not #GP. 
>>> So the hardware already checks that.
>>>
>>> The only case where you would need to check yourself is if you emulate
>>> NX on non NX capable hardware, but I can't see you doing that.
>>>  
>>>       
>> No, it doesn't.  Between the #GP and decode, you have an SMP race where 
>> another processor can rewrite the instruction.
>>     
>
> That can be ignored imho. If the page goes away you'll notice
> when you handle the page fault on read. If it becomes NX then the execution
> just happened to be logically a little earlier.
>
>   

No, you can't ignore it.  The page protections won't change between the 
GP and the decoder execution, but the instruction can, causing you to 
decode into the next page where the processor would not have.  !P 
becomes obvious, but failure to respect NX or U/S is an exploitable 
bug.  Put a 1 byte instruction at the end of a page crossing into a NX 
(or supervisor page).  Remotely, change keep switching between the 
instruction and a segment override.

Result: user executes instruction on supervisor code page, learning data 
as a result of this; code on NX page gets executed.

> Or easier to just write a backend for the lguest virtio drivers,
> that will be likely faster in the end anyways than this gross
> hack.
>   

We already have drivers for all of our hardware in Linux.  Most of the 
hardware we emulate is physical hardware, and there are no virtual 
drivers for it.  Should we take the BusLogic driver and "paravirtualize" 
it by adding VMI hypercalls?  We might benefit from it, but would the 
BusLogic driver?  It sets a nasty precedent for maintenance as different 
hypervisors and emulators hack up different drivers for their own 
performance.

Our SCSI and IDE emulation and thus the drivers used by Linux are pretty 
much fixed in stone; we are not going to go about changing a tricky 
hardware interface to a virtual one, it is simply too risky for 
something as critical as storage.  We might be able to move our network 
driver over to virtio, but that is not a short-term prospect either.

There is great advantage in talking to our existing device layer faster, 
and this is something that is valuable today.

> Really LinuxHAL^wparavirt ops is already so complicated that
> any new hooks need an extremly good justification and that is
> just not here for this.
>
> We can add it if you find an equivalent number of hooks
> to eliminate.
>   

Interesting trade.  What if I sanitized the whole I/O messy macros into 
something fun and friendly:

native_port_in(int port, iosize_t opsize, int delay)
native_port_out(int port, iosize_t opsize, u32 output, int delay)
native_port_string_in(int port, void *ptr, iosize_t opsize, unsigned 
count, int delay)
native_port_string_out(int port, void *ptr, iosize_t opsize, unsigned 
count, int delay)

Then we can be rid of all the macro goo in io.h, which frightens my 
mother.  We might even be able to get rid of the umpteen different 
places where drivers wrap iospace access with their own byte / word / 
long functions so they can switch between port I/O and memory mapped I/O 
by moving it all into common infrastructure.

We could make similar (unwelcome?) advances on the pte functions if it 
were not for the regrettable disconnect between pte_high / pte_low and 
the rest.  Perhaps if it was hidden in macros?

Zach
