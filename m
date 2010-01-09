Return-Path: <linux-kernel-owner+w=401wt.eu-S1752996Ab0AITUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996Ab0AITUM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 14:20:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752098Ab0AITUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 14:20:11 -0500
Received: from tomts5.bellnexxia.net ([209.226.175.25]:44309 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692Ab0AITUJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 14:20:09 -0500
Date: Sat, 9 Jan 2010 14:20:06 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       josh@joshtriplett.org, tglx@linutronix.de, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, laijs@cn.fujitsu.com, dipankar@in.ibm.com
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
	barrier
Message-ID: <20100109192006.GA23672@Krystal>
References: <20100107191657.GN6764@linux.vnet.ibm.com> <1262893243.28171.3753.camel@gandalf.stny.rr.com> <20100107205830.GR6764@linux.vnet.ibm.com> <1262900140.28171.3773.camel@gandalf.stny.rr.com> <20100108235338.GA18050@Krystal> <20100109002043.GD6816@linux.vnet.ibm.com> <20100109010231.GA25368@Krystal> <20100109012128.GF6816@linux.vnet.ibm.com> <20100109023842.GA1696@Krystal> <20100109054215.GB9044@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20100109054215.GB9044@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 13:31:49 up 24 days,  2:50,  5 users,  load average: 0.11, 0.14,
	0.13
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> On Fri, Jan 08, 2010 at 09:38:42PM -0500, Mathieu Desnoyers wrote:
> > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > On Fri, Jan 08, 2010 at 08:02:31PM -0500, Mathieu Desnoyers wrote:
> > > > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > > > On Fri, Jan 08, 2010 at 06:53:38PM -0500, Mathieu Desnoyers wrote:
> > > > > > * Steven Rostedt (rostedt@goodmis.org) wrote:
> > > > > > > Well, if we just grab the task_rq(task)->lock here, then we should be
> > > > > > > OK? We would guarantee that curr is either the task we want or not.
> > > > > > 
> > > > > > Hrm, I just tested it, and there seems to be a significant performance
> > > > > > penality involved with taking these locks for each CPU, even with just 8
> > > > > > cores. So if we can do without the locks, that would be preferred.
> > > > > 
> > > > > How significant?  Factor of two?  Two orders of magnitude?
> > > > > 
> > > > 
> > > > On a 8-core Intel Xeon (T is the number of threads receiving the IPIs):
> > > > 
> > > > Without runqueue locks:
> > > > 
> > > > T=1: 0m13.911s
> > > > T=2: 0m20.730s
> > > > T=3: 0m21.474s
> > > > T=4: 0m27.952s
> > > > T=5: 0m26.286s
> > > > T=6: 0m27.855s
> > > > T=7: 0m29.695s
> > > > 
> > > > With runqueue locks:
> > > > 
> > > > T=1: 0m15.802s
> > > > T=2: 0m22.484s
> > > > T=3: 0m24.751s
> > > > T=4: 0m29.134s
> > > > T=5: 0m30.094s
> > > > T=6: 0m33.090s
> > > > T=7: 0m33.897s
> > > > 
> > > > So on 8 cores, taking spinlocks for each of the 8 runqueues adds about
> > > > 15% overhead when doing an IPI to 1 thread. Therefore, that won't be
> > > > pretty on 128+-core machines.
> > > 
> > > But isn't the bulk of the overhead the IPIs rather than the runqueue
> > > locks?
> > > 
> > >      W/out RQ       W/RQ   % degradation
> > fix:
> >        W/out RQ       W/RQ   ratio
> > > T=1:    13.91      15.8    1.14
> > > T=2:    20.73      22.48   1.08
> > > T=3:    21.47      24.75   1.15
> > > T=4:    27.95      29.13   1.04
> > > T=5:    26.29      30.09   1.14
> > > T=6:    27.86      33.09   1.19
> > > T=7:    29.7       33.9    1.14
> > 
> > These numbers tell you that the degradation is roughly constant as we
> > add more threads (let's consider 1 thread per core, 1 IPI per thread,
> > with active threads). It is all run on a 8-core system will all cpus
> > active. As we increase the number of IPIs (e.g. T=2 -> T=7) we add 9s,
> > for 1.8s/IPI (always for 10,000,000 sys_membarrier() calls), for an
> > added 180 ns/core per call. (note: T=1 is a special-case, as I do not
> > allocate any cpumask.)
> > 
> > Using the spinlocks adds about 3s for 10,000,000 sys_membarrier() calls
> > or a 8-core system, for an added 300 ns/core per call.
> > 
> > So the overhead of taking the task lock is about twice higher, per core,
> > than the overhead of the IPIs. This is understandable if the
> > architecture does an IPI broadcast: the scalability problem then boils
> > down to exchange cache-lines to inform the ipi sender that the other
> > cpus have completed. An atomic operation exchanging a cache-line would
> > be expected to be within the irqoff+spinlock+spinunlock+irqon overhead.
> 
> Let me rephrase the question...  Isn't the vast bulk of the overhead
> something other than the runqueue spinlocks?

I don't think so. What we have here is:

O(1)
- a system call
- cpumask allocation
- IPI broadcast

O(nr cpus)
- wait for IPI handlers to complete
- runqueue spinlocks

The O(1) operations seems to be about 5x slower than the combined
O(nr cpus) wait and spinlock operations, but this only means that as
soon as we have 8 cores, then the bulk of the overhead sits in the
runqueue spinlock (if we have to take them).

If we don't take spinlocks, then we can go up to 16 cores before the
bulk of the overhead starts to be the "wait for IPI handlers to
complete" phase. As you pointed out, we could turn this wait phase into
a tree hierarchy. However, we cannot do this with the spinlocks, as they
have to be taken for the initial cpumask iteration.

Therefore, if we don't have to take those spinlocks, we can have a very
significant gain over this system call overhead, especially on large
systems. Not taking spinlocks here allows us to use a tree hierarchy to
turn the bulk of the scalability overhead (waiting for IPI handlers to
complete) into a O(log(nb cpus)) complexity order, which is quite
interesting.

> 
> > > So if we had lots of CPUs, we might want to fan the IPIs out through
> > > intermediate CPUs in a tree fashion, but the runqueue locks are not
> > > causing excessive pain.
> > 
> > A tree hierarchy may not be useful for sending the IPIs (as, hopefully,
> > they can be broadcasted pretty efficiciently), but however could be
> > useful when waiting for the IPIs to complete efficiently.
> 
> OK, given that you precompute the CPU mask, you might be able to take
> advantage of hardware broadcast, on architectures having it.
> 
> > > How does this compare to use of POSIX signals?  Never mind, POSIX
> > > signals are arbitrarily bad if you have way more threads than are
> > > actually running at the time...
> > 
> > POSIX signals to all threads are terrible in that they require to wake
> > up all those threads. I have not even thought it useful to compare
> > these two approaches with benchmarks yet (I'll do that when the
> > sys_membarrier() support is implemented in liburcu).
> 
> It would be of some interest.  I bet that the runqueue spinlock overhead
> is -way- down in the noise by comparison to POSIX signals, even when all
> the threads are running.  ;-)
> 

For 1,000,000 iterations, sending signals to execute a remote mb and
waiting for it to complete:

T=1: 0m3.107s
T=2: 0m5.772s
T=3: 0m8.662s
T=4: 0m12.239s
T=5: 0m16.213s
T=6: 0m19.482s
T=7: 0m23.227s

So, per iteration:

T=1: 3107 ns
T=2: 5772 ns
T=3: 8662 ns
T=4: 12239 ns
T=5: 16213 ns
T=6: 19482 ns
T=7: 23227 ns

For an added 3000 ns per extra thread. So, yes, the added 300 ns/core
for spinlocks is almost lost in the noise compared to the signal-based
solution, but it's not because the old solution was behaving so poorly
that we can rely on it to say what is noise vs not in the current
implementation. Looking at what the scalability bottlenecks are, and
looking at what is noise within the current implementation seems like
a more appropriate way to design an efficient system call.

So all in all, we can expect around 6.25-fold improvement because we
diminish the per-core overhead if we use the spinlocks (480 ns/core vs
3000 ns/core), but if we don't take the runqueue spinlocks (180
ns/core), then we are contemplating a 16.7-fold improvement. And this is
without considering a tree-hierarchy for waiting for IPIs to complete,
which would additionally change the order of the scalability overhead
from O(n) to O(log(n)).

Thanks,

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
