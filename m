Return-Path: <linux-kernel-owner+w=401wt.eu-S1752386Ab0AGRpM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386Ab0AGRpM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 12:45:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752251Ab0AGRpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 12:45:10 -0500
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:43509 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752202Ab0AGRpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 12:45:08 -0500
Date: Thu, 7 Jan 2010 12:45:05 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
	barrier
Message-ID: <20100107174505.GA9612@Krystal>
References: <20100107044007.GA22863@Krystal> <20100107052851.GA12419@feather> <20100107060439.GB25786@Krystal> <20100107063207.GA12939@feather>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20100107063207.GA12939@feather>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 09:09:46 up 21 days, 22:28,  5 users,  load average: 0.34, 0.20,
	0.18
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Josh Triplett (josh@joshtriplett.org) wrote:
> On Thu, Jan 07, 2010 at 01:04:39AM -0500, Mathieu Desnoyers wrote:
[...]
> > Just tried it with a 10,000,000 iterations loop.
> > 
> > The thread doing the system call loop takes 2.0% of user time, 98% of
> > system time. All other cpus are nearly 100.0% idle. Just to give a bit
> > more info about my test setup, I also have a thread sitting on a CPU
> > busy-waiting for the loop to complete. This thread takes 97.7% user
> > time (but it really is just there to make sure we are indeed doing the
> > IPIs, not skipping it through the thread_group_empty(current) test). If
> > I remove this thread, the execution time of the test program shrinks
> > from 32 seconds down to 1.9 seconds. So yes, the IPI is actually
> > executed in the first place, because removing the extra thread
> > accelerates the loop tremendously. I used a 8-core Xeon to test.
> 
> Do you know if the kernel properly measures the overhead of IPIs?  The
> CPUs might have only looked idle.  What about running some kind of
> CPU-bound benchmark on the other CPUs and testing the completion time
> with and without the process running the membarrier loop?

Good point. Just tried with a cache-hot kernel compilation using 6/8 CPUs.

Normally:                                              real 2m41.852s
With the sys_membarrier+1 busy-looping thread running: real 5m41.830s

So... the unrelated processes become 2x slower. That hurts.

So let's try allocating a cpu mask for PeterZ scheme. I prefer to have a
small allocation overhead and benefit from cpumask broadcast if
possible so we scale better. But that all depends on how big the
allocation overhead is.

Impact of allocating a cpumask (time for 10,000,000 sys_membarrier
calls, one thread is doing the sys_membarrier, the others are busy
looping)):

IPI to all:                                            real 0m44.708s
alloc cpumask+local mb()+IPI-many to 1 thread:         real 1m2.034s

So, roughly, the cpumask allocation overhead is 17s here, not exactly
cheap. So let's see when it becomes better than single IPIs:

local mb()+single IPI to 1 thread:                     real 0m29.502s
local mb()+single IPI to 7 threads:                    real 2m30.971s

So, roughly, the single IPI overhead is 120s here for 6 more threads,
for 20s per thread.

Here is what we can do: Given that it costs almost half as much to
perform the cpumask allocation than to send a single IPI, as we iterate
on the CPUs, for the, say, first N CPUs (ourself and 1 cpu that needs to
have an IPI sent), we send a "single IPI". This will be N-1 IPI and a
local function call. If we need more than that, then we switch to the
cpumask allocation and send a broadcast IPI to the cpumask we construct
for the rest of the CPUs. Let's call it the "adaptative IPI scheme".

For my Intel Xeon E5405:

Just doing local mb()+single IPI to T other threads:

T=1: 0m29.219s
T=2: 0m46.310s
T=3: 1m10.172s
T=4: 1m24.822s
T=5: 1m43.205s
T=6: 2m15.405s
T=7: 2m31.207s

Just doing cpumask alloc+IPI-many to T other threads:

T=1: 0m39.605s
T=2: 0m48.566s
T=3: 0m50.167s
T=4: 0m57.896s
T=5: 0m56.411s
T=6: 1m0.536s
T=7: 1m12.532s

So I think the right threshold should be around 2 threads (assuming
other architecture will behave like mine). So starting 3 threads, we
allocate the cpumask and send IPIs.

How does that sound ?

[...]

> 
> > > - Part of me thinks this ought to become slightly more general, and just
> > >   deliver a signal that the receiving thread could handle as it likes.
> > >   However, that would certainly prove more expensive than this, and I
> > >   don't know that the generality would buy anything.
> > 
> > A general scheme would have to call every threads, even those which are
> > not running. In the case of this system call, this is a particular case
> > where we can forget about non-running threads, because the memory
> > barrier is implied by the scheduler activity that brought them offline.
> > So I really don't see how we can use this IPI scheme for other things
> > that this kind of synchronization.
> 
> No, I don't mean non-running threads.  If you wanted that, you could do
> what urcu currently does, and send a signal to all threads.  I meant
> something like "signal all *running* threads from my process".

Well, if you find me a real-life use-case, then we can surely look into
that ;)

> 
> > > - Could you somehow register reader threads with the kernel, in a way
> > >   that makes them easy to detect remotely?
> > 
> > There are two ways I figure out we could do this. One would imply adding
> > extra shared data between kernel and userspace (which I'd like to avoid,
> > to keep coupling low). The other alternative would be to add per
> > task_struct information about this, and new system calls. The added per
> > task_struct information would use up cache lines (which are very
> > important, especially in the task_struct) and the added system call at
> > rcu_read_lock/unlock() would simply kill performance.
> 
> No, I didn't mean that you would do a syscall in rcu_read_{lock,unlock}.
> I meant that you would do a system call when the reader threads start,
> saying "hey, reader thread here".

Hrm, we need to inform the userspace RCU library that this thread is
present too. So I don't see how going through the kernel helps us there.

Thanks,

Mathieu

> 
> - Josh Triplett

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
