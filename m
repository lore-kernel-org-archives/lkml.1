Return-Path: <linux-kernel-owner+w=401wt.eu-S933467AbZGPWPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933467AbZGPWPT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 18:15:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933454AbZGPWPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 18:15:18 -0400
Received: from smtpout.cs.fsu.edu ([128.186.122.75]:1872 "EHLO mail.cs.fsu.edu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933453AbZGPWPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 18:15:16 -0400
Date: Thu, 16 Jul 2009 18:15:14 -0400
From: Ted Baker <baker@cs.fsu.edu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Chris Friesen <cfriesen@nortel.com>, Noah Watkins <jayhawk@soe.ucsc.edu>,
       Raistlin <raistlin@linux.it>, Douglas Niehaus <niehaus@ittc.ku.edu>,
       Henrik Austad <henrik@austad.us>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Bill Huey <billh@gnuppy.monkey.org>,
       Linux RT <linux-rt-users@vger.kernel.org>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       "James H. Anderson" <anderson@cs.unc.edu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       KUSP Google Group <kusp@googlegroups.com>,
       Tommaso Cucinotta <cucinotta@sssup.it>,
       Giuseppe Lipari <lipari@retis.sssup.it>
Subject: Re: RFC for a new Scheduling policy/class in the Linux-kernel
Message-ID: <20090716221514.GC27757@cs.fsu.edu>
References: <1247336891.9978.32.camel@laptop> <4A594D2D.3080101@ittc.ku.edu> <1247412708.6704.105.camel@laptop> <1247499843.8107.548.camel@Palantir> <1247505941.7500.39.camel@twins> <5B78D181-E446-4266-B9DD-AC0A2629C638@soe.ucsc.edu> <20090713201305.GA25386@cs.fsu.edu> <4A5BAAE7.5020906@nortel.com> <20090715231109.GH14993@cs.fsu.edu> <1247731113.15471.24.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247731113.15471.24.camel@twins>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 16, 2009 at 09:58:32AM +0200, Peter Zijlstra wrote:

> > Again, I don't think that either PP or PI is appropriate for use
> > in a (SMP) kernel. For non-blocking locks, the current
> > no-preeemption spinlock mechanism works.  For higher-level
> > (blocking) locks, I'm attracted to Jim Anderson's model of
> > non-preemptable critical sections, combined with FIFO queue
> > service.
> 
> Right, so there's two points here I think:
> 
>  A) making most locks preemptible
>  B) adding PI to all preemptible locks
> 
> I think that we can all agree that if you do A, B makes heaps of sense,
> right?

Maybe.  That depends on how much it costs to provide PI for those
locks, and assumes that everyone (all application and OS tasks)
can agree on a global meaning for priority in the system.  

I have always liked the simplicify of a global notion of priority,
which is the core idea of global preemptive SMP
scheduling. However, some authors have pointed out scenarios for
*partitioned* multiprocessor scheduling where expediting the
highest priority task on one processor may result in idling other
processors unnecessarily, ultimately resulting in missed
deadlines.  For argument's sake, I'll assume that those scenarios
are pathological, and that a good designer who want to partition
can arrange the task-to-cpu assignments and priorities in a way
that prevents them.

There are two elements in this discussion that will require
resolution in such a global priority scheme: (1) how to rank EDF
deadlines vs. fixed priorities; (2) what to do about tasks that
are scheduled by dynamic priority schemes.

In the latter context, I'm thinking first of aperiodic server
scheduling schemes like SCHED_SPORADIC, but the problem occurs
with any scheme where a task's priority varies routinely.  (You
already have a bunch of implementation code complexity from
user-initiated priority changes, like pthread_sched_setpolicy(),
but those kinds of changes don't happen often.)

I think both (1) and (2) are covered by what I think has been
termed here the "PEP" scheme or "proxy" scheduling, i.e.,
implementing priority inheritance not by explicitly comparing and
adjusting priorities, but by allowing the system scheduler to use
whatever algorithms it may to choose a task A to execute on each
processor, and then if that task A is blocked by a lock held by
another task B, instead execute B on A's processor if B is not
already executing.

However, this still leaves the question of how to choose which of
several blocked tasks to grant a lock to, when the lock is
released.  If you want to do that according to priority (whichq
it seems one ought to, for consistency) it seems you now have to
maintain a priority orderd lock queue.  That means you are back
into looking at explicit representation of inherited priorities
again, unless you can find a way to use the scheduler to choose
who to grant the lock to.

Some proponents of the original POSIX mutex scheme intended to
solve this by unblocking all the tasks contending for the mutex,
and letting them re-try locking it.  This does get around the
explicit priority problem.  Whichever task the scheduler chooses
first will get the lock.  The problem is that you have the
overhead of unblocking all those tasks (itself a priority
inversion, since you are unblocking some "low priority" tasks). On
a single processor (or, on an SMP if you are lucky), the lock will
be released again soon, and all these unblocked tasks will get
into their critical sections without having to block again.
However, with back luck, on an SMP, all but one will bang up
against the spin-lock, and have be blocked again.  This will
generate extra context switches on every CPU.... not a good thing.
This scheme also does not seem to work well for partitioned
scheduling, or any scheme with per-cpu run queues, since the
scheduling is being done in an uncoordinated way on multiple
processors.

So, maybe Jim's model of FIFO service in queues is the right one?
I'ts predictable. Even if it can cause some unnecesary priority
inversion, the priority inversion should be bounded.

I still conceptually prefer the idea of granting locks to
contending tasks in priority order, of course.  It is just a
question of whether you want to have to agree (1) that all
scheduling is based on priority, and (2) pay the price for either
(2a) dynamically re-ordering all those queues every time a task
gains or loses priority (due to inheritance, or whatever), or (2b)
pay the O(n) price of scanning the queue for the currently
highest-priority task when you grant the lock.  If you go this
way, I would favor the latter.  In any system that does not
already have poor performance due to excessive lock contention,
the queues should rarely have more than one member.  Assuming
integrity of the queue is maintained by the corresponding lock
itself, it is much easier to do this scanning at the point the
lock is released than to support (asynchronous) queue reordering
for every potential priority change.

> I just asked Thomas if he could remember any numbers on this, and he
> said that keeping all the locks non-preemptible had at least an order
> difference in max latencies [ so a 60us (A+B) would turn into 600us (!
> A) ], this means a proportional decrease for the max freq of periodic
> tasks.

Those numbers are convincing for the value of preemptable locks.

> This led to the conviction that the PI overheads are worth it, since
> people actually want high freq tasks.

As argued above, I don't see that they necessarily argue for
PI on those preempable locks.

> Of course, when the decreased period is still sufficient for the
> application at hand, the non-preemptible case allows for better
> analysis.

Ted
