Return-Path: <linux-kernel-owner+w=401wt.eu-S933558AbZGPXN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933558AbZGPXN2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 19:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933546AbZGPXN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 19:13:28 -0400
Received: from smtpout.cs.fsu.edu ([128.186.122.75]:1952 "EHLO mail.cs.fsu.edu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933534AbZGPXN1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 19:13:27 -0400
Date: Thu, 16 Jul 2009 19:13:23 -0400
From: Ted Baker <baker@cs.fsu.edu>
To: Henrik Austad <henrik@austad.us>
Cc: Chris Friesen <cfriesen@nortel.com>, Raistlin <raistlin@linux.it>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Douglas Niehaus <niehaus@ittc.ku.edu>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Bill Huey <billh@gnuppy.monkey.org>,
       Linux RT <linux-rt-users@vger.kernel.org>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       "James H. Anderson" <anderson@cs.unc.edu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Noah Watkins <jayhawk@soe.ucsc.edu>,
       KUSP Google Group <kusp@googlegroups.com>,
       Tommaso Cucinotta <cucinotta@sssup.it>,
       Giuseppe Lipari <lipari@retis.sssup.it>
Subject: Re: RFC for a new Scheduling policy/class in the Linux-kernel
Message-ID: <20090716231323.GE27757@cs.fsu.edu>
References: <200907102350.47124.henrik@austad.us> <4A5CCD5A.80108@nortel.com> <20090715221410.GE14993@cs.fsu.edu> <200907160917.10098.henrik@austad.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907160917.10098.henrik@austad.us>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 16, 2009 at 09:17:09AM +0200, Henrik Austad wrote:

> My understanding of PEP is that when B executes through the
> A-proxy, B will consume parts of A's resources until the lock is
> freed. This makes sense when A and B runs on different CPUs and
> B is moved (temporarily) to CPU#A. If B were to use it's own
> budget when running here, once A resumes execution and exhaustes
> its entire budget, you can have over-utilization on that CPU
> (and under-util on CPU#B).

To be sure we are using A and B the same way here:
  B is holding a lock.  
  A wants that lock.
  A grants its priority B until B releases the lock.

How to look at the charges for usage seems not to have a perfect
solution.  That is, you can't get around the fact that either:

(1) B is using some its time at the wrong priority (priority inversion)

or

(2) B is using some of A's time to do B's work (the right
priority, but the wrong task)

The right way to resolve this conflict seems to depend a lot on
where B runs, as well as whether you are managing budget per-CPU
(partitioned model) or managing it globally (free migration
model).

1) In a global scheduling model, it does not matter where B runs.
We want to charge B's critical section to B, since our
schedulability analysis is based on the processor usage of each
task.  It would be broken if A could be charged random bits of
time for the execution of other tasks.  So, we must charge B.

2) In a partitioned scheuling model, we worry about the
CPU utilization of each processor.  We have several cases, depending
where B runs when it runs with A's priority:

2.1) If B gets to run on A's processor, we have a problem
with processor overload unless we charge the usage to A.  This
is still a bad thing, though, since we then need to over-provision
A to allow for this.

2.2) If B runs on its own processor, we want to use B's budget.

2.3) A third variatin is that all the critical sections for A and
B run on a separate synchronization procesor.  In that case, the
synchronization processor needs its own budget, and in effect we
the critical sections of tasks A and B become aperiodic tasks in
their own right. 

> AFAIK, there are no such things as preemption-overhead charging
> to a task's budget in the kernel today. This time simply
> vanishes and must be compensated for when running a task through
> the acceptance-stage (say, only 95% util pr CPU or some such).

I don't see that anything can or does "vanish".  Consider this
sequence of events on one processor:

1. task A is running, and calls scheduler (synchronously or maybe
via IRQ, say from timer)

2. scheduler computes how much time A has used recently, and charges
it to A's budget

The overhead of the IRQ handler and scheduler are therefore
charged to A.

3. scheduler switches to B

4. B calls scheduler

6. scheduler computes how much time B has used recently,
and charges it to B's budget

The rest of the overhead of the context switch from A to B, including cache
misses and page faults immediately following 3 are now
effectively charged to B.

> > Back to the original question, of who should be charged for
> > the actual critical section.

> That depends on where you want to run the tasks. If you want to
> migrate B to CPU#A, A should be charged. If you run B on CPU#B,
> then B should be charged (for the exact same reasoning A should
> be charged in the first case).

As I mentioned above, it also depends on whether you are using
a partitioned or global scheduling policy for your analysis.

> The beauty of PEP, is that enabling B to run is very easy. In
> the case where B runs on CPU#B, B must be updated statically so
> that the scheduler will trigger on the new priority. In PEP,
> this is done automatically when A is picked. One solution to
> this, would be to migrate A to CPU#B and insert A into the
> runqueue there. However, then you add more overhead by moving
> the task around instead of just 'borrowing' the task_struct.

> > From the schedulability analysis point of view, B is getting
> > higher priority time than it normally would be allowed to execute,
> > potentially causing priority inversion (a.k.a. "interference" or
> > "blocking") to a higher priority task D (which does not even share
> > a need for the lock that B is holding) that would otherwise run on
> > the same processor as B.  Without priority inheritance this kind
> > of interferfence would not happen.  So, we are benefiting A at the
> > expense of D. In the analysis, we can either allow for all such
> > interference in a "blocking term" in the analysis for D, or we
> > might call it "preemption" in the analysis of D and charge it to A
> > (if A has higher priority than D).  Is the latter any better?  

> If D has higher priority than A, then neither A nor B (with the
> locks held) should be allowed to run before D.

Yes, but I only meant D has higher priority than B.  A may have
higher priority than D, but with multiple processors we can't just
focus on the one highest priority task.  We need to look at the
(number of CPUs) highest priority tasks, or we will may end
up with our system behaving as if we have only one processor.

This is a key difference with multiprocessor scheduling,
and also with processor "share" scheduilng.

Expediting the highest priority task is *not* always the
best strategy.  Assuming that each task has some amount of slack,
there is no great benefit for completing a high-priority task
early, if that means causing other tasks to miss their deadlines.

That is, if by delaying the highest-priority task a little bit
on one processor you can keep more processors busy,
you may be able to successfully schedule a set of tasks that
could not be scheduled to meet deadlines otherwise.

(I can give you an example of how this happens if you want, but it
would tedious if you can get my point without the example.)

> Yes, no task should be allowed to run more than the budget, but
> that requires B to execute *only* on CPU#B.

As mentioned above, that depends on whether you are
applying a global or partitioned model.  With a global
scheduling model the budget is not per-CPU.

> On the other hand, one could say that if you run PEP and B is
> executed on CPU#A, and A then exhausts its budget, you could
> blame A as well, as lock-contention is a common problem and it's
> not only the kernel's fault. Do we need perfect or best-effort
> lock-resolving?

Yes. For application locks, with application-managed partitioned
scheduling, you can blame the application designer for building
in cross-CPU contention.

For kernel (hidden from the application) locks, it is a harder
problem.

I don't think there is a perfect solution for the partitioned
scheduling model.  As mentioned above, you get to choose between B
causing short-term priority inversion for other tasks on B's
processor (but not using more than its budget on the average), or
B causing budget over-run for A on A's processor.

Ted
