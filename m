Return-Path: <linux-kernel-owner+w=401wt.eu-S1763929AbYDOViu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763929AbYDOViu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 17:38:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932853AbYDOVih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 17:38:37 -0400
Received: from tomts10.bellnexxia.net ([209.226.175.54]:50617 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932803AbYDOVif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 17:38:35 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ar8EAEy9BEhMROPA/2dsb2JhbACBX6sq
Date: Tue, 15 Apr 2008 17:38:32 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, prasad@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [RFC PATCH 1/2] Marker probes in futex.c
Message-ID: <20080415213832.GC7873@Krystal>
References: <20080415115058.GA6788@in.ibm.com> <20080415115314.GA6975@in.ibm.com> <1208260942.6395.6.camel@twins> <20080415123233.GA19797@Krystal> <1208264190.6395.21.camel@twins> <20080415131744.GA5248@elte.hu> <20080415134705.GB22351@Krystal> <20080415164814.GA15842@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080415164814.GA15842@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 17:08:20 up 46 days, 17:19,  5 users,  load average: 0.22, 0.18,
	0.27
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > Now for some performance impact :
> 
> absent from your figures is dyn-ftrace :-)
> 
> dyn-ftrace is a young but rather nifty tool that extends on old-style 
> static tracepoints rather forcefully, by adding 75,000+ tracepoints to 
> the kernel here and now, with no in-source maintainence overhead at all. 
> (It's a nice add-on to SystemTap because it adds space for a jprobe, but 
> i digress ;-)
> 
> anyway, my objections against markers would be reduced quite 
> significantly, if we were able to improve the immediate values 
> optimization to not actually patch the MOV's constant portion, but to 
> just patch both the MOV and the branch instruction, into two NOPs.
> 
> in fact, we can do even better: we should turn the immediate values 
> optimization into a simple "patch out a jump to the slowpath" 
> optimization. I.e. just a single instruction to patch in and out. (and 
> that makes the NMI impact all that easier to handle as well)
> 
> That would pretty much meet my "the typical trace point should have the 
> cost of a single NOP" threshold for fastpath tracing overhead, which 
> i've been repeating for 2 years now, and which would make the scheduler 
> markers a lot more palatable ;-)
> 
> hm?
> 

I think we could do something there. Let's have a look at a few
marker+immediate values fast paths on x86_32 :


    4631:       b0 00                   mov    $0x0,%al
    4633:       84 c0                   test   %al,%al
    4635:       0f 85 c6 00 00 00       jne    4701 <try_to_wake_up+0xea>


    7059:       b0 00                   mov    $0x0,%al
    705b:       84 c0                   test   %al,%al
    705d:       75 63                   jne    70c2 <sched_exec+0xb6>


    83ac:       b0 00                   mov    $0x0,%al
    83ae:       84 c0                   test   %al,%al
    83b0:       75 29                   jne    83db <wait_task_inactive+0x69>


If we want to support NMI context and have the ability to instrument
preemptable code without too much headache, we must insure that every
modification will leave the code in a "correct" state and that we do not
grow the size of any reachable instruction.  Also, we must insure gcc
did not put code between these instructions. Modifying non-relocatable
instructions would also be a pain, since we would have to deal with
instruction pointer relocation in the breakpoint code when the code
modification is being done.

Luckily, gcc almost never place any code between the mov, test and jne
instructions. But since we cannot we sure, we could dynamically check
for this code pattern after the mov instruction. If we find it, then we
play with it as if it was a single asm block, but if we don't find what
we expect, then we use standard immediate values for that. I expect the
heavily optimised version will be usable almost all the time.

This heavily optimized version could consist of a simple jump to the
address following the "jne" instruction. To activate the immediate
value, we could simply put back a mov $0x1,%al. I don't think we care
_that_ much about the active tracing performance, since we take a
supplementary function call already in that case.

We could probably force the mov into %al to make sure we search for only
one test pattern (%al,%al). We would have to decode the jne instruction
to see how big it is so we can put the correct offset in the jmp
instruction replacing the original mov.

The only problem that arises is if the gcc compiler uses the zero flag
set by testb by code following the jne instruction, but in our case, I
don't see how gcc could ever want to reuse the zero flag set by a test
on our own mov to a register unless we re-use the value loaded somewhere
else.

Dealing with the non-relocatable jmp instruction could be done by
checking, in the int3 immediate values notifiy callback, if the
instruction being modified is a jmp. If it is, we simply update the
return address without executing the bypass code.

What do you think of these ideas ?

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
