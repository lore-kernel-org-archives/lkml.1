Return-Path: <linux-kernel-owner+w=401wt.eu-S1754065Ab0AICnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab0AICnq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 21:43:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753189Ab0AICnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 21:43:45 -0500
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:63666 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752914Ab0AICnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 21:43:45 -0500
Date: Fri, 8 Jan 2010 21:38:42 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       josh@joshtriplett.org, tglx@linutronix.de, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, laijs@cn.fujitsu.com, dipankar@in.ibm.com
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
	barrier
Message-ID: <20100109023842.GA1696@Krystal>
References: <20100107183946.GL6764@linux.vnet.ibm.com> <1262890782.28171.3738.camel@gandalf.stny.rr.com> <20100107191657.GN6764@linux.vnet.ibm.com> <1262893243.28171.3753.camel@gandalf.stny.rr.com> <20100107205830.GR6764@linux.vnet.ibm.com> <1262900140.28171.3773.camel@gandalf.stny.rr.com> <20100108235338.GA18050@Krystal> <20100109002043.GD6816@linux.vnet.ibm.com> <20100109010231.GA25368@Krystal> <20100109012128.GF6816@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20100109012128.GF6816@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 21:15:12 up 23 days, 10:33,  7 users,  load average: 0.16, 0.10,
	0.08
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> On Fri, Jan 08, 2010 at 08:02:31PM -0500, Mathieu Desnoyers wrote:
> > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > On Fri, Jan 08, 2010 at 06:53:38PM -0500, Mathieu Desnoyers wrote:
> > > > * Steven Rostedt (rostedt@goodmis.org) wrote:
> > > > > Well, if we just grab the task_rq(task)->lock here, then we should be
> > > > > OK? We would guarantee that curr is either the task we want or not.
> > > > 
> > > > Hrm, I just tested it, and there seems to be a significant performance
> > > > penality involved with taking these locks for each CPU, even with just 8
> > > > cores. So if we can do without the locks, that would be preferred.
> > > 
> > > How significant?  Factor of two?  Two orders of magnitude?
> > > 
> > 
> > On a 8-core Intel Xeon (T is the number of threads receiving the IPIs):
> > 
> > Without runqueue locks:
> > 
> > T=1: 0m13.911s
> > T=2: 0m20.730s
> > T=3: 0m21.474s
> > T=4: 0m27.952s
> > T=5: 0m26.286s
> > T=6: 0m27.855s
> > T=7: 0m29.695s
> > 
> > With runqueue locks:
> > 
> > T=1: 0m15.802s
> > T=2: 0m22.484s
> > T=3: 0m24.751s
> > T=4: 0m29.134s
> > T=5: 0m30.094s
> > T=6: 0m33.090s
> > T=7: 0m33.897s
> > 
> > So on 8 cores, taking spinlocks for each of the 8 runqueues adds about
> > 15% overhead when doing an IPI to 1 thread. Therefore, that won't be
> > pretty on 128+-core machines.
> 
> But isn't the bulk of the overhead the IPIs rather than the runqueue
> locks?
> 
>      W/out RQ       W/RQ   % degradation
fix:
       W/out RQ       W/RQ   ratio
> T=1:    13.91      15.8    1.14
> T=2:    20.73      22.48   1.08
> T=3:    21.47      24.75   1.15
> T=4:    27.95      29.13   1.04
> T=5:    26.29      30.09   1.14
> T=6:    27.86      33.09   1.19
> T=7:    29.7       33.9    1.14

These numbers tell you that the degradation is roughly constant as we
add more threads (let's consider 1 thread per core, 1 IPI per thread,
with active threads). It is all run on a 8-core system will all cpus
active. As we increase the number of IPIs (e.g. T=2 -> T=7) we add 9s,
for 1.8s/IPI (always for 10,000,000 sys_membarrier() calls), for an
added 180 ns/core per call. (note: T=1 is a special-case, as I do not
allocate any cpumask.)

Using the spinlocks adds about 3s for 10,000,000 sys_membarrier() calls
or a 8-core system, for an added 300 ns/core per call.

So the overhead of taking the task lock is about twice higher, per core,
than the overhead of the IPIs. This is understandable if the
architecture does an IPI broadcast: the scalability problem then boils
down to exchange cache-lines to inform the ipi sender that the other
cpus have completed. An atomic operation exchanging a cache-line would
be expected to be within the irqoff+spinlock+spinunlock+irqon overhead.

> 
> So if we had lots of CPUs, we might want to fan the IPIs out through
> intermediate CPUs in a tree fashion, but the runqueue locks are not
> causing excessive pain.

A tree hierarchy may not be useful for sending the IPIs (as, hopefully,
they can be broadcasted pretty efficiciently), but however could be
useful when waiting for the IPIs to complete efficiently.

> 
> How does this compare to use of POSIX signals?  Never mind, POSIX
> signals are arbitrarily bad if you have way more threads than are
> actually running at the time...

POSIX signals to all threads are terrible in that they require to wake
up all those threads. I have not even thought it useful to compare
these two approaches with benchmarks yet (I'll do that when the
sys_membarrier() support is implemented in liburcu).

Thanks,

Mathieu

> 
> 							Thanx, Paul

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
