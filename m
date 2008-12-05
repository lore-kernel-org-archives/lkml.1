Return-Path: <linux-kernel-owner+w=401wt.eu-S1756096AbYLEMIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096AbYLEMIR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 07:08:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751667AbYLEMH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 07:07:58 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44372 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773AbYLEMH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 07:07:57 -0500
Date: Fri, 5 Dec 2008 13:07:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Veen <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [patch 0/3] [Announcement] Performance Counters for Linux
Message-ID: <20081205120734.GA26244@elte.hu>
References: <20081204225345.654705757@linutronix.de> <18744.29747.728320.652642@cargo.ozlabs.ibm.com> <20081205063131.GB12785@elte.hu> <18744.56857.259756.129894@cargo.ozlabs.ibm.com> <20081205080813.GA2030@elte.hu> <18744.61429.548462.667020@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18744.61429.548462.667020@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Mackerras <paulus@samba.org> wrote:

> Ingo Molnar writes:
> 
> > * Paul Mackerras <paulus@samba.org> wrote:
> [...]
> > > Isn't it two separate read() calls to read the two counters?  If so, 
> > > the only way the two values are actually going to correspond to the 
> > > same point in time is if the task being monitored is stopped.  In which 
> > > case the monitoring task needs to use ptrace or something similar in 
> > > order to make sure that the monitored task is actually stopped.
> > 
> > It doesnt matter in practice.
> 
> Can I ask - and this is a real question, I'm not being sarcastic - is 
> that statement made with substantial serious experience in performance 
> analysis behind it, or is it just an intuition?
> 
> I will happily admit that I am not a great expert on performance 
> analysis with years of experience.  But I have taken a bit of a look at 
> what people with that sort of experience do, and I don't think they 
> would agree with your "doesn't matter" statement.

A stream of read()s possibly slightly being off is an order of magnitude 
smaller of an effect to precision. Look at the numbers: on the testbox i 
have a read() syscall takes 0.2 microseconds, while a context-switch 
takes 2 microseconds on the local CPU and about 5-10 microseconds 
cross-CPU (or more, if the cache pattern is unlucky/unaffine). That's 
10-25-50 times more expensive. You can do 9-24-49 reads and still be 
cheaper. Compound syscalls are almost never worth the complexity.

So as a scheduler person i cannot really take the perfmon "ptrace 
approach" seriously, and i explained that in great detail already. It 
clearly came from HPC workload quarters where tasks are persistent 
entities running alone on a single CPU that just use up CPU time there 
and dont interact with each other too much. That's a good and important 
profiling target for sure - but by no means the only workload target to 
design a core kernel facility for. It's an absolutely horrible approach 
for a number of more common workloads for sure.

> > Such kind of 'group system call facility' has been suggested several 
> > times in the past - but ... never got anywhere because system calls 
> > are cheap enough, it really does not count in practice.
> > 
> > It could be implemented, and note that because our code uses a proper 
> > Linux file descriptor abstraction, such a sys_read_fds() facility 
> > would help _other_ applications as well, not just performance 
> > counters.
> > 
> > But it brings complications: demultiplexing of error conditions on 
> > individual counters is a real pain with any compound abstraction. We 
> > very consciously went with the 'one fd, one object, one counter' 
> > design.
> 
> And I think that is the fundamental flaw.  On the machines I am 
> familiar with, the performance counters as not separate things that can 
> individually and independently be assigned to count one thing or 
> another.

Today we've implemented virtual counter scheduling in our to-be-v2 code:

   3 files changed, 36 insertions(+), 1 deletion(-)

hello.c gives:

 counter[0 cycles              ]:  10121258163 , delta:    844256826 events
 counter[1 instructions        ]:   4160893621 , delta:    347054666 events
 counter[2 cache-refs          ]:         2297 , delta:          179 events
 counter[3 cache-misses        ]:            3 , delta:            0 events
 counter[4 branch-instructions ]:    799422166 , delta:     66551572 events
 counter[5 branch-misses       ]:         7286 , delta:          775 events

All we need to get that array of information from 6 sw counters is a 
_single_ hardware counter. I'm not sure where you read "you must map sw 
counters to hw counters directly" or "hw counters must be independent of 
each other" into our design - it's not part of it, emphatically.

And i dont see your (fully correct!) statement above about counter 
constraints to be in any sort of conflict with what we are doing.

Intel hardware is just as constrained as powerpc hardware: there are 
counter inter-dependencies and many CPUs have just two performance 
counters. We very much took this into account while designing this code.

[ Obviously, you _can_ do higher quality profiling if you have more 
  hardware resources that help it. Nothing will change that fact. ]

> Rather, what the hardware provides is ONE performance monitor unit, 
> which the OS can context-switch between tasks.  The performance monitor 
> unit has several counters that can be assigned (within limits) to count 
> various aspects of the performance of the code being executed.  That is 
> why, for instance, if you ask for the counters to be frozen when one of 
> them overflows, they all get frozen at that point.

i dont see this as an issue at all - it's a feature of powerpc over x86 
that the core perfcounter code can support just fine. The overflow IRQ 
handler is arch specific. The overflow IRQ handler, if it triggers, 
updates the sw counters, creates any event records if needed, wakes up 
the monitor task if needed, and continues the task and performance 
measurement without having scheduled out. Demultiplexing of hw counters 
is arch-specific.

	Ingo
