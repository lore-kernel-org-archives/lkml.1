Return-Path: <linux-kernel-owner+w=401wt.eu-S1756934AbXLDVRE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756934AbXLDVRE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 16:17:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755509AbXLDVKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 16:10:16 -0500
Received: from il.qumranet.com ([82.166.9.18]:34779 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755489AbXLDVKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 16:10:12 -0500
Message-ID: <4755C179.8050101@argo.co.il>
Date: Tue, 04 Dec 2007 23:07:05 +0200
From: Avi Kivity <avi@argo.co.il>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Andi Kleen <andi@firstfloor.org>, Kyle Moffett <mrmacman_g4@mac.com>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Ben Crowhurst <Ben.Crowhurst@stellatravel.co.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: Kernel Development & Objective-C
References: <474EAD18.6040408@stellatravel.co.uk> <20071130143445.GA2310@csclub.uwaterloo.ca> <53ADBDBF-9B65-441E-B867-D68DE48ABD64@mac.com> <4751BE0D.3050609@argo.co.il> <p733aukyl8n.fsf@bingen.suse.de> <47539030.10600@argo.co.il> <20071203095022.GA28560@one.firstfloor.org> <4753ECA5.2010604@argo.co.il> <20071203211353.GA4009@1wt.eu>
In-Reply-To: <20071203211353.GA4009@1wt.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau wrote:
>>>>    
>>>>         
>>> With 10Gbit/s ethernet working you start to care about every cycle.
>>>  
>>>       
>> If you have 10M packets/sec no amount of cycle-saving will help you.  
>> You need high level optimizations like TSO.  I'm not saying we should 
>> sacrifice cycles like there's no tomorrow, but the big wins are elsewhere.
>>     
>
> Huh? At 4 GHz, you have 400 cycles to process each packet. If you need to
> route those packets, those cycles may just be what you need to lookup a
> forwarding table and perform a few MMIO on an accelerated chip which will
> take care of the transfer. But you need those cycles. If you start to waste
> them 30 by 30, the performance can drop by a critical factor.
>
>   

I really doubt Linux spends 400 cycles routing a packet.  Look what an 
skbuff looks like.

A flood ping to localhost on a 2GHz system takes 8 microseconds, that's 
16,000 cycles.  Sure it involves userspace, but you're about two orders 
of magnitude off.  And the localhost interface is nicely cached in L1 
without mmio at all, unlike real devices.

>>> Another simple noticeable case is Unix
>>> sockets and your X server communication.
>>>       
>> Your reflexes are *much* better than mine if you can measure half a 
>> nanosecond on X.
>>     
>
> It just depends how many times a second it happens. For instance, consider
> this trivial loop (fct is a two-function array which just return 1 or 2) :
>
>         i = 0;
>         for (j = 0; j < (1 << 28); j++) {
>                 k = (j >> 8) & 1;
>                 i += fct[k]();
>         }
>
> It takes 1.6 seconds to execute on my athlon-xp 1.5 GHz. If, instead of
> changing the function once every 256 calls, you change it to every call :
>
>         i = 0;
>         for (j = 0; j < (1 << 28); j++) {
>                 k = (j >> 0) & 1;
>                 i += fct[k]();
>         }
>
> Then it only takes 4.3 seconds, which is about 3 times slower. The number
> of calls per function remains the same (128M calls each), it's just the
> branch prediction which is wrong every time. The very few nanoseconds added
> at each call are enough to slow down a program from 1.6 to 4.3 seconds while
> it executes the exact same code (it may even save one shift). If you have
> such stupid code, say, to compute the color or alpha of each pixel in an
> image, you will certainly notice the difference.
>
>   

This happens very often in HPC, and when it does, it is often worthwhile 
to invest in manual optimizations or even assembly coding.  
Unfortunately it is very rare in the kernel (memcmp, raid xor, what 
else?).  Loops with high iteration counts are very rare, so any 
attention you give to the loop body is not amortized over a large number 
of executions.

> And such poorly efficient code may happen very often when you blindly rely
> on function pointers instead of explicit calls.
>   

Using an indirect call where a direct call is sufficient will also 
reduce the compiler's optimization opportunities.  However, I don't see 
anyone recommending it in the context of systems programming.

It is not true that the number of indirect calls necessarily increases 
if you use a language other than C.

(Actually, with templates you can reduce the number of indirect calls)

>> Here, it's scheduling that matters, avoiding large transfers, and 
>> avoiding ping-pongs, not some cycles on the unix domain socket.  You 
>> already paid 150 cycles or so by issuing the syscall and thousands for 
>> copying the data, 50 more won't be noticeable except in nanobenchmarks.
>>     
>
> You are forgetting something very important : once you start stacking
> functions to perform the dirty work for you, you end up with so much
> abstraction that even new stupid code cannot be written at all without
> relying on them, and it's where the problem takes its roots, because
> when you need to write a fast function and you notice that you cannot
> touch a variable without passing through a slow pinhole, your fast
> function will remain slow whatever you do, and the worst of all is that
> you will think that it is normally fast and that it cannot be written
> faster.
>
>   

I don't understand.  Can you give an example?

There are two cases where abstraction hurts performance: the first is 
where the mechanisms used to achieve the abstraction (functions instead 
of direct access to variables, function pointers instead of duplicating 
the caller) introduce performance overhead.  I don't think C has any 
advantage here -- actually a disadvantage as it lacks templates and is 
forced to use function pointers for nontrivial cases.  Usually the 
abstraction penalty is nil with modern compilers.

The second case is where too much abstraction clouds the programmer's 
mind.  But this is independent of the programming language.


>>> And there are some special cases where block IO is also pretty critical.
>>> A popular one is TPC-* benchmarking, but there are also others and it 
>>> looks likely in the future that this will become more critical
>>> as block devices become faster (e.g. highend SSDs) 
>>>  
>>>       
>> And again the key is batching, improving cpu affinity, and caching, not 
>> looking for a faster instruction sequence.
>>     
>
> Every cycle burned is definitely lost. The time cannot go backwards. So
> for each cycle that you lose to laziness, you have to become more and more
> clever to find out how to write an alternative. Lazy people simply put
> caches everywhere and after that they find normal that "hello world" requires
> 2 Gigs of RAM to be displayed. 

A 100 byte program will print "hello world" on a UART and stop.  A 
modern program will load a vector description of a font, scale it to the 
desired size, render it using anti aliasing and sub-pixel positioning, 
lay it out according to the language rules of whereever you live, and 
place it on a multi-megabyte frame buffer.  Yes it needs hundreds of 
megabytes and lots of nasty algorithms to do that.

> The only true solution is to create better
> algorithms, but you will find even less people capable of creating efficient
> algorithms than you will find capable of coding correctly.
>
>   

That is true, that is why we see a lot more microoptimizations than 
algorithmic progress.

But if you want a fast streaming filesystem you choose XFS over ext3, 
even though the latter is much smaller and easier to optimize.  If you 
write a network server you choose epoll() instead of trying to optimize 
select() somehow.  True algorithmic improvements are rare but they are 
the ones that are actually measurable.


>>> For example there are some CPUs who are relatively slow at indirect
>>> function calls and there are actually cases where this can be measured.
>>>       
>> That is true.  But any self-respecting systems language will let you 
>> choose between direct and indirect calls.
>>
>> If adding an indirect call allows you to avoid even 1% of I/O, you save 
>> much more than you lose, so again the high level optimizations win.
>>     
>
> It depends which type of I/O. If the I/O is non-blocking, you end up doing
> something else instead of actively burning cycles.
>
>   

Unless you are I/O bound, which is usually the case when you have 2GHz 
cpus driving 200Hz disks.

>> Nanooptimizations are fun (I do them myself, I admit) but that's not 
>> where performance as measured by the end user lies.
>>     
>
> I do not agree. It's not uncommon to find 2- or 3-fold performance factors
> between equivalent components when one is carefully optimized and the other
> one is not. Granted it takes an awful lot of time doing all those nano-opts
> at the beginning, but the more you learn about how the hardware reacts to
> your code, the more efficiently you write future code, with the fewest bloat.
> End users notice bloat a lot (especially when CPU and RAM are excessively
> wasted).
>   

Can you give an example of a 2- or 3- fold factor on an end-user 
workload achieved by microopts?

I agree about bloat.

