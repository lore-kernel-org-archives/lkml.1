Return-Path: <linux-kernel-owner+w=401wt.eu-S1754812Ab0AJAnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812Ab0AJAnc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 19:43:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752644Ab0AJAnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 19:43:31 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:46751 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200Ab0AJAnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 19:43:31 -0500
X-Authority-Analysis: v=1.0 c=1 a=r_nf4N-T2GkA:10 a=kiMWPxQlYM7JJ5ILkhUA:9 a=lVRQm7Q2HJ4CVP4Y8PoA:7 a=c3fM5yTakJhw_CT7ZLWUUkRJH9gA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
 barrier
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, josh@joshtriplett.org, tglx@linutronix.de,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com
In-Reply-To: <20100110000318.GD9044@linux.vnet.ibm.com>
References: <1262900140.28171.3773.camel@gandalf.stny.rr.com>
	 <20100108235338.GA18050@Krystal> <20100109002043.GD6816@linux.vnet.ibm.com>
	 <20100109010231.GA25368@Krystal> <20100109012128.GF6816@linux.vnet.ibm.com>
	 <20100109023842.GA1696@Krystal> <20100109054215.GB9044@linux.vnet.ibm.com>
	 <20100109192006.GA23672@Krystal>
	 <1263078327.28171.3792.camel@gandalf.stny.rr.com>
	 <1263079000.28171.3795.camel@gandalf.stny.rr.com>
	 <20100110000318.GD9044@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Sat, 09 Jan 2010 19:41:39 -0500
Message-Id: <1263084099.2231.5.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-01-09 at 16:03 -0800, Paul E. McKenney wrote:
> On Sat, Jan 09, 2010 at 06:16:40PM -0500, Steven Rostedt wrote:
> > On Sat, 2010-01-09 at 18:05 -0500, Steven Rostedt wrote:
> > 
> > > Then we should have O(tasks) for spinlocks taken, and 
> > > O(min(tasks, CPUS)) for IPIs.
> > 
> > And for nr tasks >> CPUS, this may help too:
> > 
> > > cpumask = 0;
> > > foreach task {
> > 
> > 	if (cpumask == online_cpus)
> > 		break;
> > 
> > > 	spin_lock(task_rq(task)->rq->lock);
> > > 	if (task_rq(task)->curr == task)
> > > 		cpu_set(task_cpu(task), cpumask);
> > > 	spin_unlock(task_rq(task)->rq->lock);
> > > }
> > > send_ipi(cpumask);
> 
> Good point, erring on the side of sending too many IPIs is safe.  One
> might even be able to just send the full set if enough of the CPUs were
> running the current process and none of the remainder were running
> real-time threads.  And yes, it would then be necessary to throttle
> calls to sys_membarrier().
> 

If you need to throttle calls to sys_membarrier(), than why bother
optimizing it? Again, this is like calling synchronize_sched() in the
kernel, which is a very heavy operation, and should only be called by
those that are not performance critical.

Why are we struggling so much with optimizing the slow path?

Here's how I take it. This method is much better that sending signals to
all threads. The advantage the sys_membarrier gives us, is also a way to
keep user rcu_read_locks barrier free, which means that rcu_read_locks
are quick and scale well.

So what if we have a linear decrease in performance with the number of
threads on the write side?

-- Steve


