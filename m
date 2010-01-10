Return-Path: <linux-kernel-owner+w=401wt.eu-S1753578Ab0AJBGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578Ab0AJBGK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 20:06:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752661Ab0AJBGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 20:06:09 -0500
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:47042 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752269Ab0AJBGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 20:06:08 -0500
Date: Sat, 9 Jan 2010 20:01:04 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, josh@joshtriplett.org, tglx@linutronix.de,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
	barrier
Message-ID: <20100110010104.GB25790@Krystal>
References: <20100107205830.GR6764@linux.vnet.ibm.com> <1262900140.28171.3773.camel@gandalf.stny.rr.com> <20100108235338.GA18050@Krystal> <20100109002043.GD6816@linux.vnet.ibm.com> <20100109010231.GA25368@Krystal> <20100109012128.GF6816@linux.vnet.ibm.com> <20100109023842.GA1696@Krystal> <20100109054215.GB9044@linux.vnet.ibm.com> <20100109192006.GA23672@Krystal> <1263078327.28171.3792.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1263078327.28171.3792.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 19:54:06 up 24 days,  9:12,  5 users,  load average: 0.05, 0.07,
	0.08
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Sat, 2010-01-09 at 14:20 -0500, Mathieu Desnoyers wrote:
> 
> > > > Using the spinlocks adds about 3s for 10,000,000 sys_membarrier() calls
> > > > or a 8-core system, for an added 300 ns/core per call.
> > > > 
> > > > So the overhead of taking the task lock is about twice higher, per core,
> > > > than the overhead of the IPIs. This is understandable if the
> > > > architecture does an IPI broadcast: the scalability problem then boils
> > > > down to exchange cache-lines to inform the ipi sender that the other
> > > > cpus have completed. An atomic operation exchanging a cache-line would
> > > > be expected to be within the irqoff+spinlock+spinunlock+irqon overhead.
> > > 
> > > Let me rephrase the question...  Isn't the vast bulk of the overhead
> > > something other than the runqueue spinlocks?
> > 
> > I don't think so. What we have here is:
> > 
> > O(1)
> > - a system call
> > - cpumask allocation
> > - IPI broadcast
> 
> > O(nr cpus)
> 
> Isn't this really O(tasks) ?

Yes, you are right. The iteration is done with:

for_each_cpu(cpu, mm_cpumask(current->mm))

which is bounded by the number of threads in the process.

> 
> Don't you do the spinlock(task_rq(task)->rq->lock)?

Within this loop, I check with cpu_curr(cpu)->mm

So, really, it's O(min(nr threads, nr cpus)), which could be translated
into O(nr active threads).

> 
> So the scale is not with large boxes, but the number of tasks that must
> be checked. Still, if you have 1000 threads, a rcu writer is bound to
> take a bit of overhead. But the advantage is the readers are still fast.

Yep.

> 
> RCU is known to be slow for writing. A user must be aware of this.

True. Although the goal of this modification is to ensure that
synchronize_rcu() is not painfully slow and does not involve waking up
all threads, which would have many side-effects on the system (killing
sleep states and so on).

> 
> Then we should have O(tasks) for spinlocks taken, and 
> O(min(tasks, CPUS)) for IPIs.

We actually have O(nr active threads) for both spinlocks taken and IPI
wait, which is not that bad.

You're starting to convince me to start with something rock-solid, and
wait until there is a need for something faster before we do tighter
coupling with the scheduler memory barriers.

Thanks,

Mathieu

> 
> cpumask = 0;
> foreach task {
> 	spin_lock(task_rq(task)->rq->lock);
> 	if (task_rq(task)->curr == task)
> 		cpu_set(task_cpu(task), cpumask);
> 	spin_unlock(task_rq(task)->rq->lock);
> }
> send_ipi(cpumask);
> 
> -- Steve
> 
> 
> > - wait for IPI handlers to complete
> > - runqueue spinlocks
> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
