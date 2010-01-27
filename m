Return-Path: <linux-kernel-owner+w=401wt.eu-S1753399Ab0A0J17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399Ab0A0J17 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 04:27:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752547Ab0A0J16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 04:27:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8768 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788Ab0A0J1z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 04:27:55 -0500
Message-ID: <4B60067B.4060708@redhat.com>
Date: Wed, 27 Jan 2010 11:25:15 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>, Jim Keniston <jkenisto@us.ibm.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>, ananth@in.ibm.com,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       utrace-devel <utrace-devel@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH 1/7] User Space Breakpoint Assistance Layer (UBP)
References: <4B5459CA.9060603@redhat.com> <4B545ACF.40203@cs.helsinki.fi> <1263852957.2266.38.camel@localhost.localdomain> <4B556855.6040800@redhat.com> <1263923265.4998.28.camel@localhost.localdomain> <4B56D027.3010808@redhat.com> <1263981472.4283.843.camel@laptop> <4B56F588.2060109@redhat.com> <20100127082440.GA16640@elte.hu> <4B5FFADB.5090209@redhat.com> <20100127090824.GA23570@elte.hu>
In-Reply-To: <20100127090824.GA23570@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2010 11:08 AM, Ingo Molnar wrote:
>
>> I see it exactly the opposite.  Only a very small minority of cases will
>> have such severe memory corruption that tracing will fall apart because of
>> random writes to memory; especially on 64-bit where the address space is
>> sparse.  On the other hand, knowing that the cost is a few dozen cycles
>> rather than a thousand or so means that you can trace production servers
>> running full loads without worrying about whether tracing will affect
>> whatever it is you're trying to observe.
>>
>> I'm not against slow reliable tracing, but we shouldn't ignore the need for
>> speed.
>>      
> I havent seen a conscise summary of your points in this thread, so let me
> summarize it as i've understood them (hopefully not putting words into your
> mouth): AFAICS you are arguing for some crazy fragile architecture-specific
> solution that traps INT3 into ring3 just to shave off a few cycles, and then
> use user-space state to trace into.
>    


That's a good summary, except for the words "crazy fragile", "trap INT3 
into ring3" and "a few cycles".

Instead of using int 3, put a jump instruction in the program.  This 
shaves a lot more than a few cycles.

> If so then you ignore the obvious solution to _that_ problem: dont use INT3 at
> all, but rebuild (or re-JIT) your program with explicit callbacks. It's _MUCH_
> faster than _any_ breakpoint based solution - literally just the cost of a
> function call (or not even that - i've written very fast inlined tracers -
> they do rock when it comes to performance). Problem solved and none of the
> INT3 details matters at all.
>    

However did I not think of that?  Yes, and let's rip off kprobes tracing 
from the kernel, we can always rebuild it.

Well, I'm observing an issue in a production system now.  I may not want 
to take it down, or if I take it down I may not be able to observe it 
again as the problem takes a couple of days to show up, or I may not 
have the full source, or it takes 10 minutes to build and so an 
iterative edit/build/run cycle can stretch for hours.

Adding a vma to a running program is very unlikely to affect it.  If the 
program makes random accesses to memory, it will likely segfault very 
quickly before we ever get to trace it.

> INT3 only matters to _transparent_ probing, and for that, the cost of INT3 is
> almost _by definition_ less important than the fact that we can do transparent
> tracing. If performance were the overriding issue they'd use dedicated
> callbacks - and the INT3 technique wouldnt matter at all.
>    

INT3 isn't transparent.  The only thing that comes close to full 
transparency is hardware breakpoints.  So we have a tradeoff between 
transparency and speed, and except for the wierdest bugs, this level of 
transparency won't be needed.

> ( Also, just like we were able to extend the kprobes code with more and more
>    optimizations, the same can be done with any user-space probing as well, to
>    make it faster. But at the core of it has to be a sane design that is
>    transparent and controlled by the kernel, so that it has the option to apply
>    more and more otimizations - yours isnt such and its limitations are
>    designed-in.

No design is fully transparent, and I don't see why my design can't be 
controlled by the kernel?

> Which is neither smart nor useful. )
>    

This style of arguing is neither smart or useful as well.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

