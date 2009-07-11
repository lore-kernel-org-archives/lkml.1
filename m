Return-Path: <linux-kernel-owner+w=401wt.eu-S1753662AbZGKS3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662AbZGKS3S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 14:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752035AbZGKS3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 14:29:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:48726 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbZGKS3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 14:29:01 -0400
Subject: Re: RFC for a new Scheduling policy/class in the Linux-kernel
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Henrik Austad <henrik@austad.us>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Bill Huey <billh@gnuppy.monkey.org>,
       Linux RT <linux-rt-users@vger.kernel.org>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       "James H. Anderson" <anderson@cs.unc.edu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Douglas Niehaus <niehaus@ittc.ku.edu>, Ted Baker <baker@cs.fsu.edu>,
       Dhaval Giani <dhaval.giani@gmail.com>
In-Reply-To: <200907102350.47124.henrik@austad.us>
References: <200907102350.47124.henrik@austad.us>
Content-Type: text/plain
Date: Sat, 11 Jul 2009 20:28:11 +0200
Message-Id: <1247336891.9978.32.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-10 at 23:50 +0200, Henrik Austad wrote:
> Hi all!
> 
> This is a proposal for a global [1], deadline driven scheduler for
> real-time tasks in the Linux kernel. I thought I should send out an RFC to
> gather some feedback instead of wildy hack away at it.
> 
> This proposed scheduler is a modified MLLF (modified Least Laxity First)
> called Earliest Failure First (EFF) as it orders tasks according to when
> they will miss their deadlines, not when the actual deadline is.

<snip>

Everybody agrees we want a deadline scheduler, we'll probably put a user
interface into -rt shortly which should work for all the involved
research groups so that we can share tests and have better comparisons.

The only thing (aside from an utter lack of time to work on things
recently) that has been holding us back is a proper solution to the
priority inversion issue.

I haven't fully read through the proposed algorithm below, and left it
in place for the new people on CC.

As already mentioned on IRC, the fact that you push the work to the last
possible moment indicates that this algorithm will utterly fall apart on
overload and would thus be unsuited for soft-rt loads, but I guess we
could implement things like EDF-fm and keep this as a hard-rt class.

> === Notation ===
> 
> - Take a set of tasks with corresponding attributes.  This set and their
>   attributes are called the schedule, 'S' and contains *all* tasks for
>   the given scheduling class (i.e. all EFF-tasks).
> 
> - Consider a multi-core system with 'm' processors.
> 
> - Let the i'th task in the schedule be denoted tau_i. [3]
> 
> - Each task will run in intervals, each 'round' is called a job. A task
>   consists of an infinite sequence of jobs. The k'th job of tau_i is
>   called tau_{i,k}
> 
> - Each task has a set of (relative) attributes supplied when the task is
>   inserted into the scheduler (passed via syscall)
>   * Period T_i
>   * Deadline D_i
>   * WCET C_i
> 
> - Each job (tau_{i,k}) has absolute attributes (computed from the relative
>   tasks-attributes coupled with physical time).
>   * Release-time r_{i,k}
>   * Deadline d_{i,k}
>   * Allocated time so for a job, C_a(t, tau_{i,k})
>     When C_a equals WCET, the jobs budget is exhausted and it should
>     start a new cycle. This is tested (see below) by the scheduler.
>   * Remaining time for the job, C_r(t, tau_{i,nk})
> 
> - The acceptance function for EFF screens new tasks on their expected
>   utilization. Depending on the mode and implementation, it can be based
>   on the period, or on the deadline. The latter will cause firmer
>   restraints, but may lead to wasted resources.
> 
> 	U = C_i / T_i		For SRT (bounded deadline tardiness)
> 	U = C_i / D_i		For HRT
> 
> - A relative measure, time to failure, ttf, indicates how much time is
>   left before a job must be scheduled to run in order to avoid a
>   deadline-miss. This will decrease as time progresses and the job is
>   not granted CPU time. For tasks currently running on a CPU, this value
>   will be constant.
> 
> 	Take a job with a WCET of 10ms, it has been allowed to run for 4
> 	ms so far. The deadline is 8 ms away. Then the job must be
> 	scheduled to run within the next 4 ms, otherwise it will not be
> 	able to finish in time.
> 
> - An absolute value, time of failure (tof) can also be computed in a
>   static manner. For tasks not running on a CPU, the allocated time is
>   static. That means you can take the absolute deadline, subtract the
>   allocated time and you have the absolute point in time when a given
>   job will fail to meet its deadline.
> 
> === Outline of scheduler ===
> 
> Store tasks in 2 queues. One of size m, containing all the tasks
> currently running on the CPUs (queue R). The other will hold all
> currently active tasks waiting to execute (queue W).
> 
> queue R is sorted based on ttf (time to failure, the relative time left
> until a task will miss it's deadline). As the tasks approaches the
> absolute time of failure at the same rate C_a increases, ttf is
> constant. R is only a 'map' of tasks to the CPUs. Position 0 in R
> (i.e. smallest ttf) does not result in CPU#0, as the position->CPU will
> be quite fluent.
> 
> queue W is sorted based on absolute time of failure (tof). Since this is
> a fixed point in time, and the tasks in W are not running (C_a is
> unchanged), this value is constant.
> 
> When a task is scheduled to run, a timer is set at the point in time
> where it has exhausted it's budget (t_now + WCET - C_a). This is to
> ensure that a runaway task does not grab the CPU.
> 
> When a new task arrives, it is handled according the following rules:
> - The system has one or more CPUs not running EFF-tasks. Pick any of the
>   free CPUs and assign the new job there. Set a timer to
> 
> - All CPUs are busy, the new task has greater time to failure than the
>   head of W. The task is inserted into W at the appropriate place.
> 
> - All CPUs are busy and the new task has smaller time to failure than
>   the head of W. The new task is compared to the last task in Q. If time
>   to failure is larger than the task at the tail, it is added to the
>   head of W.
> 
> - If all CPUs are busy, and time to failure is smaller than the tail of
>   Q, the new task is a candidate for insertion. At this point the tasks
>   must be compared to see if picking one or the other will cause a
>   deadline-miss. If both will miss the deadline if the other is
>   scheduled, keep the existing running and place the new at the head of
>   W (as you will have a deadline-miss anyway unless the the task is
>   picked up by another CPU soon).
> 
> - A task running on a CPU with ttf=0 should *never* be preempted with
>   another task. If all tasks in R have ttf=0, and a newly arrived task
>   has ttf=0, a deadline-miss is inevitable and switching tasks will only
>   waste resources.
> 
> When a task in R finish (or is stopped due to the timer-limit), it is
> removed from R, and the head of W is added to R, inserted at the
> appropriate place.
> 
> It has been some discussion lately (in particular on #linux-rt) about
> the bandwidth inheritance (BWI) and proxy execution protocol (PEP). It
> should be possible to extend EFF to handle both. As a side note, if
> anyone has some good information about PEP, I'd like a copy :)
> 
> Based on this, I think the utilization can be set as high as M
> (i.e. full utilization of all CPUs), but the jitter can probably be
> quite bad, so for jitter-sensitive tasks, a short period/deadline should
> be used.
> 
> There are still some issues left to solve, for instance how to best
> handle sporadic tasks, and whether or not deadline-miss should be allow,
> or just 'bounded deadline tardiness'. Either way, EFF should be able to
> handle it. Then, there are problems concerning blocking of tasks. One
> solution would be BWI or PEP, but I have not had the time to read
> properly through those, but from what I've gathered a combination of BWI
> and PEP looks promising (anyone with good info about BWI and PEP - feel
> free to share! (-: ).

Our SSSUP friends have a BWI paper here:

  http://retis.sssup.it/~tommaso/publications/OSPERT-2008.pdf

The thing we call PEP was christened so by Douglas Niehaus (on CC), I'm
not sure if he has any papers on it.

Also, when talking about it at OSPERT last week Ted Baker (also on CC)
said it reminded him of something else of which I seem to have forgotten
the name.

Thing is, both BWI and PEP seems to work brilliantly on Uni-Processor
but SMP leaves things to be desired. Dhaval is currently working on a
PEP implementation that will migrate all the blocked tasks to the
owner's cpu, basically reducing it to the UP problem.

> 1) Before you freeze at 'global' and get all caught up on "This won't
>    ever scale to X", or "He will be haunted by Y" - I do not want to
>    extend a global algorithm to 2000 cores. I would like to scale to a
>    single *chip* and then we can worry about 2-way and 4-way systems
>    later. For the record, I've donned my asbestos suit anyway.

My preferred approach here is to find a distributed algorithm that
converges to the global one.

> 2) http://austad.us/kernel/thesis_henrikau.pdf
> 
> 3) Anyone want to include LaTeX-notation into an email-rfc?

Not unheard of ;-)

