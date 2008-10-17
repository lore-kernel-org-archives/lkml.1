Return-Path: <linux-kernel-owner+w=401wt.eu-S1754203AbYJQU23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbYJQU23 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 16:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751355AbYJQU2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 16:28:18 -0400
Received: from tomts5.bellnexxia.net ([209.226.175.25]:35733 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbYJQU2R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 16:28:17 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AugEALGO+EhMQWq+/2dsb2JhbACBcrdiCIcMgmkIew
Date: Fri, 17 Oct 2008 16:23:13 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, ltt-dev@lists.casi.polymtl.ca
Subject: Re: [RFC patch 15/15] LTTng timestamp x86
Message-ID: <20081017202313.GA13597@Krystal>
References: <20081016232729.699004293@polymtl.ca> <20081016234657.837704867@polymtl.ca> <alpine.LFD.2.00.0810161701470.3288@nehalem.linux-foundation.org> <20081017012835.GA30195@Krystal> <57C9024A16AD2D4C97DC78E552063EA3532D455F@orsmsx505.amr.corp.intel.com> <20081017172515.GA9639@goodmis.org> <57C9024A16AD2D4C97DC78E552063EA3533458AC@orsmsx505.amr.corp.intel.com> <20081017184215.GB9874@Krystal> <57C9024A16AD2D4C97DC78E552063EA35334594F@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA35334594F@orsmsx505.amr.corp.intel.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 15:11:15 up 134 days, 23:51,  9 users,  load average: 0.37, 0.60,
	0.67
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Luck, Tony (tony.luck@intel.com) wrote:
> > Hrm, on such systems
> > - *large* amount of cpus
> > - no synchronized TSCs
> >
> > What would be the best approach to order events ?
> 
> There isn't a perfect solution for this.  My feeling is
> that your best hope is with per-cpu buffers logged with
> the local TSC ... together with some fancy heuristics to
> post-process the logs to come up with the best approximation
> to the actual ordering.
> 
> If you have a tight upper bound estimate for the
> errors in converting from "per-cpu" TSC values to "global
> system time" then the post processing tool will be able
> to identify events for which the order is uncertain.
>

The only problem I see with "fancy heuristics" regarding the time base
is that when we detect that something is going wrong in the kernel or in
a userspace program, the *very last* thing we want to do is to doubt
about the reliability of the time source. When a problematic situation
is detected, it makes a huge difference whether this information can be
trusted or not. I've seen much simpler algorithms in the past (I'm
referring to the original LTT heartbeat here) which were told to be
plain simple but ended up being buggy and unreliable in rare
corner-cases (it did not take into account interrupt latency). After
fixing the main problems, I decided to start all over from scratch,
because unreliable timestamps means unreliable traces and this is not
something I am willing to provide.


> > Do you think we should consider using HPET, event though it's
> > painfully slow ? Would it be faster than cache-line bouncing
> > on such large boxes ? With a frequency around 10MHz, that
> > would give a 100ns precision, which should be enough
> > to order events.
> 
> This sounds like a poor choice.  Makes all traces very
> slow.  100ns precision isn't all that good ... we can
> probably do almost as well estimating the delta between
> TSC on different cpus.
> 
> -Tony
> 

100ns is not bad at all actually, especially given we don't plan to
require a memory barrier to be issued around the timestamp counter
reads. Memory read/writes can easily be reordered so they cause timing
skew in the order of 100ns. Also, just the TSC frequency drift and
imprecision of the TSC synchronization even when they are synchronized
(which is typically one cache line transfer delay when the TSCs are not
synchronized by the BIOS/mobo) is also in the order of 100ns. So sorry, I
disagree and think 100ns is actually the kind of precision we can expect
even from TSC reads.

Having read a lot about the subtle timestamp counter bugs one can find
in Intel and AMD boxes (gross summary of my findings here : 
http://ltt.polymtl.ca/svn/trunk/lttv/doc/developer/tsc.txt), I think
there is no reliable way to give an upper bound on the timing
inaccurary, even with heroic measures trying to map the specific bugs of
each of those CPUs, when you have stuff like the southbridge temperature
throttling slowing down your CPU clock without notifying the kernel. And
as a said above, the timestamping code should be _very_ _very_ simple,
given that the first thing a kernel developer will point his finger at
when a tracer discovers a bug in his code is the tracer itself. So let's
save everyone precious time and make this code easy to review. :-)

So we are talking about performance impact of time base reads. Let's
look at some interesting numbers :

On my x86_64 box
model name  : Intel(R) Xeon(R) CPU           E5405  @ 2.00GHz
stepping  : 6
cpu MHz   : 2000.060
(dual quad-core, *not* NUMA)

Cycles to read (from 10000 loops, on a single CPU) :

get_cycles :                                                         60
cpuid + get_cycles + cpuid (with rdtsc_barrier) :                    77
ltt_get_timestamp_64() with synchronized TSC :                       79
ltt_get_timestamp_64() with non-synchronized TSC (cache-hot) :      163
ltt_get_timestamp_64() with non-synchronized TSC (after clflush) :  310
   (just doing the clflush takes 68 cycles, has been substracted from
   the previous result)
HPET :                                                              945

So if we have 512 processors doing timestamp reads like crazy, we can
suppose the execution to be serialized by cacheline transfer operations
from cpu to cpu. Therefore, assuming a worse-case scenario where all the
timestamp reads cause a cache line transfer, the 310 cycles (upper
bound) it takes to do the cmpxchg, with CPUs running at 2.0GHz, means
that we can do 6 451 612 timestamp reads per second on the overall
system. On 512 nodes, that means we can do 12 600 timestamp
reads/second/cpu.

Compared to this, HPET would offer a slower time base read (945 cycles
per read is fairly slow, which gives 2 116 402 time stamp read per
second), but if this mmio read is done in parallel across CPUs (I
don't see any reason why it should hold the bus exclusively for a simple
read.. ?), then it would scale much better so we could expect about 2.1M
timestamp read/second/cpu.

I guess the cache-line bouncing approach would get much worse with NUMA
systems, and in that case HPET could become increasingly interesting.

To give an order of magnitude, I expect some worse-case scenarios to be
around 8MB/s/cpu when tracing stuff like lockdep in circular per-cpu
memory buffers. With an average of, say, 16 bytes per event, including
the event header and payload, that would mean 524 288 events/second/cpu.
In that case, using the cache-line bouncing approach on a 512 nodes box
would simply kill the system, but if the HPET reads does not imply
serialization, time base reads would add a 25% performance loss in this
utterly extreme case, which is acceptable given this is a best-effort.
Compared to this, the TSC-based solution (given we have synchronized
TSCs) would add a 2% performance hit.

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
