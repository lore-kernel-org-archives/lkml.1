Return-Path: <linux-kernel-owner+w=401wt.eu-S1754324Ab0AHW2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324Ab0AHW2Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 17:28:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754314Ab0AHW2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 17:28:23 -0500
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:50136 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754307Ab0AHW2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 17:28:22 -0500
Date: Fri, 8 Jan 2010 17:28:20 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: paulmck@linux.vnet.ibm.com, Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       josh@joshtriplett.org, tglx@linutronix.de, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, laijs@cn.fujitsu.com, dipankar@in.ibm.com
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
	barrier
Message-ID: <20100108222820.GA9537@Krystal>
References: <20100107044007.GA22863@Krystal> <1262852862.4049.78.camel@laptop> <20100107183010.GA14980@redhat.com> <20100107183946.GL6764@linux.vnet.ibm.com> <1262890782.28171.3738.camel@gandalf.stny.rr.com> <20100107191657.GN6764@linux.vnet.ibm.com> <1262893243.28171.3753.camel@gandalf.stny.rr.com> <20100107205830.GR6764@linux.vnet.ibm.com> <1262900140.28171.3773.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1262900140.28171.3773.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 17:25:23 up 23 days,  6:43,  5 users,  load average: 0.04, 0.08,
	0.08
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Thu, 2010-01-07 at 12:58 -0800, Paul E. McKenney wrote:
> 
> > I believe that I am worried about a different scenario.  I do not believe
> > that the scenario you lay out above can actually happen.  The pair of
> > schedules on CPU 2 have to act as a full memory barrier, otherwise,
> > it would not be safe to resume a task on some other CPU.
> 
> I'm not so sure about that. The update of ->curr happens inside a
> spinlock, which is a rmb() ... wmb() pair. Must be, because a spin_lock
> must be an rmb otherwise the loads could move outside the lock, and the
> spin_unlock must be a wmb() otherwise what was written could move
> outside the lock.

Hrm, a rmb + wmb pair is different than a full mb(), because rmb and wmb
can be reordered ont wrt the other. The equivalence is more:

mb() = rmb() + sync_core() + wmb()

> 
> 
> >   If the pair
> > of schedules act as a full memory barrier, then the code in
> > synchronize_rcu() that looks at the RCU read-side state would see that
> > CPU 2 is in an RCU read-side critical section.
> > 
> > The scenario that I am (perhaps wrongly) concerned about is enabled by
> > the fact that URCU's rcu_read_lock() has a load, some checks, and a store.
> > It has compiler constraints, but no hardware memory barriers.  This
> > means that CPUs (even x86) can execute an rcu_dereference() before the
> > rcu_read_lock()'s store has executed.
> > 
> > Hacking your example above, keeping mind that x86 can reorder subsequent
> > loads to precede prior stores:
> > 
> > 
> > 	CPU 1				CPU 2
> >      -----------                    -------------
> > 
> > 	<user space>			<kernel space, switching to task>
> > 
> > 					->curr updated
> > 
> > 					<long code path, maybe mb?>
> > 
> > 					<user space>
> > 
> > 					rcu_read_lock(); [load only]
> > 
> > 					obj = list->next
> > 
> > 	list_del(obj)
> > 
> > 	sys_membarrier();
> > 	< kernel space >
> 
> Well, if we just grab the task_rq(task)->lock here, then we should be
> OK? We would guarantee that curr is either the task we want or not.
> 
[...]

Yes, I'll do some testing to figure out how much overhead this has.
Probably not much, but it's an iteration on all CPUs, so it will be a
bit larger on big iron. Clearly taking the run queue lock would be the
safest way to proceed.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
