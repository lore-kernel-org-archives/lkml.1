Return-Path: <linux-kernel-owner+w=401wt.eu-S1753655AbZGLDCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655AbZGLDCq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 23:02:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752085AbZGLDCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 23:02:37 -0400
Received: from stephens.ittc.ku.edu ([129.237.125.220]:56497 "EHLO
	stephens.ittc.ku.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbZGLDCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 23:02:36 -0400
X-Greylist: delayed 1306 seconds by postgrey-1.27 at vger.kernel.org; Sat, 11 Jul 2009 23:02:36 EDT
Message-ID: <4A594D2D.3080101@ittc.ku.edu>
Date: Sat, 11 Jul 2009 21:40:45 -0500
From: Douglas Niehaus <niehaus@ittc.ku.edu>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Henrik Austad <henrik@austad.us>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Bill Huey <billh@gnuppy.monkey.org>,
       Linux RT <linux-rt-users@vger.kernel.org>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       "James H. Anderson" <anderson@cs.unc.edu>,
       Thomas Gleixner <tglx@linutronix.de>, Ted Baker <baker@cs.fsu.edu>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Noah Watkins <jayhawk@soe.ucsc.edu>,
       KUSP Google Group <kusp@googlegroups.com>
Subject: Re: RFC for a new Scheduling policy/class in the Linux-kernel
References: <200907102350.47124.henrik@austad.us> <1247336891.9978.32.camel@laptop>
In-Reply-To: <1247336891.9978.32.camel@laptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0.1 (stephens.ittc.ku.edu); Sat, 11 Jul 2009 21:40:46 -0500 (CDT)
X-ITTC-MailScanner-Information: Please contact the ISP for more information
X-ITTC-MailScanner-ID: 15DE228F8F.46EF5
X-ITTC-MailScanner: Found to be clean
X-ITTC-MailScanner-From: niehaus@ittc.ku.edu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter:
    Perhaps you could expand on what you meant when you said:

	Thing is, both BWI and PEP seems to work brilliantly on Uni-Processor
	but SMP leaves things to be desired. Dhaval is currently working on a
	PEP implementation that will migrate all the blocked tasks to the
	owner's cpu, basically reducing it to the UP problem.

What is left to be desired with PEP on SMP? I am not saying it is 
perfect, as I can think of a few things I would like to improve or 
understand better, but I am curious what you have in mind.

Absent a clearer idea of what you had in mind, I can certainly discuss 
the tradeeoffs Noah and I have considered over time, and which we think 
motivates our approach.

When Noah and I have talked about this topic over the quite extended 
time, several years, we have been working on it, there have always 
seemed two choices:

1) Move the proxy (the resource owner) to the CPU with the blocked task
2) Move the "scheduling profile" of the blocked task to the CPU where 
the proxy is.

For Proxy Execution under Group Scheduling we have considered both over 
time. Consider the situation where thread A on CPU0 is blocked on a 
resource held by thread B on CPU1. When we considered (1), it has the 
advantage of ensuring that B will run on CPU0, unblocking A, if A (or B) 
is still the best choice at the time it has been successfully moved from 
CPU1 -> CPU0. That might not be true after the delay of moving the process.

We decided to emphasize (2) because it was more interesting in our view 
because it was cheaper and seemed no more complicated although its 
complications are different than (1). Its complication is, of course, 
that while we have worked out how to add the "avatar" of A to the set 
considered by the GS hierarchy on CPU1, it depends on the scheduling 
semantics as configured whether the avatar of A is chosen as "best" and 
thus how long it will be until B runs long enough to release the 
resource and unblock A on CPU1.

We have always viewed that as complicated, but appropriately so to the 
problem. It depends inherently on the semantics of threads A, B, and all 
other threads on CPU1 that are ready to run, among whom the "best" is 
chosen by the GS hierarchy. We think it is inherently the problem of the 
scheduling configuration to take this trade-off into account.

We have also thought being able to do both (1) and (2) is best, but 
which is best to use in a given situation depends on the comparative 
cost of (X) running B on CPU1 long enough to unblock A and (Y) the cost 
of moving B from CPU1->CPU0 to run long enough to unblock A, and then 
move it back from CPU0->CPU1 since its designed CPU assigned is on CPU1. 
Our decision after many hours of discussion over many months has been 
that the cost of (X) seems a lot more attractive than (Y).

Part of our preference is that we are still working with semaphores as 
resources. Since most critical sections are supposed to be "short",  
then scheduling semantics taking the proxy execution periods into 
account on the "foreign" CPUs would actually be easier/better than the 
double thread movement.

Both problems seem quite hard and I do not think I have yet "completely 
figured it out". While the "mass migration" you say Dhaval is working on 
would "reduce" the problem to the UP case, I think it would create more 
complexity for analysis than it eliminates. A form of thrashing seems a 
real danger. In this case, that threads would be moving from CPU to CPU 
so much it would be a real drain on resources and constraint on system 
performance. However, Dhaval my well understand the cost implications of 
thread migration better than I do.

The real core of the problem, it seems to me, is that the proxy 
relationship among threads depends on what resources can be held by 
them. I think that problem is "relatively easy" in the set of locks 
associated with a multi-threaded application.

When the resources causing blocking can be *any* lock in the kernel 
associated with *any* system service that might be used by *any* thread 
is is complicated enough to make my brain hurt. However, we thing the GS 
framework makes it relatively easy, perhaps that would be better said as 
"as easy as it can be", to implement any combination of thread migration 
and avatars desired by a given scheduling semantics.

In that sense Noah and I feel that GS is a "complete" framework in that 
it is possible to configure any semantics desired as easily as it can be 
done by any framework. Obviously that does not resolve the question of 
what semantics it is best to desire for a given system which remains 
quite complicated and highly dependent on the specific application 
semantics.

Noah and I thought the relatively low cost of creating the avatar was 
quite attractive, and so we decided on a GS configuration using it to 
experiment with in specifying the scheduling semantics. The first two 
approaches we want to experiment with are (*) to view the composite 
scheduling hierarchy for all CPUs as a whole, and let the avatar of A 
take its chances on CPU1, and (**) to view resolution of blocking as 
most important system wide, so we have the avatar viewed as "best" long 
enough for its proxy to release the resource.

The bottom line, in out view, is that no single semantics will be viewed 
as either "best" or even acceptable for all applications as is the case 
with schedulers, so we wanted to emphasize configurability.

We have performed basic tests showing the avatars can be chosen and 
resolve the blocking relationship. More complex tests await the 
completion of our port of GS and the other KUSP subsystems to 2.6.29.

Doug

Peter Zijlstra wrote:
> On Fri, 2009-07-10 at 23:50 +0200, Henrik Austad wrote:
>   
>> Hi all!
>>
>> This is a proposal for a global [1], deadline driven scheduler for
>> real-time tasks in the Linux kernel. I thought I should send out an RFC to
>> gather some feedback instead of wildy hack away at it.
>>
>> This proposed scheduler is a modified MLLF (modified Least Laxity First)
>> called Earliest Failure First (EFF) as it orders tasks according to when
>> they will miss their deadlines, not when the actual deadline is.
>>     
>
> <snip>
>
> Everybody agrees we want a deadline scheduler, we'll probably put a user
> interface into -rt shortly which should work for all the involved
> research groups so that we can share tests and have better comparisons.
>
> The only thing (aside from an utter lack of time to work on things
> recently) that has been holding us back is a proper solution to the
> priority inversion issue.
>
> I haven't fully read through the proposed algorithm below, and left it
> in place for the new people on CC.
>
> As already mentioned on IRC, the fact that you push the work to the last
> possible moment indicates that this algorithm will utterly fall apart on
> overload and would thus be unsuited for soft-rt loads, but I guess we
> could implement things like EDF-fm and keep this as a hard-rt class.
>
>   
>> === Notation ===
>>
>> - Take a set of tasks with corresponding attributes.  This set and their
>>   attributes are called the schedule, 'S' and contains *all* tasks for
>>   the given scheduling class (i.e. all EFF-tasks).
>>
>> - Consider a multi-core system with 'm' processors.
>>
>> - Let the i'th task in the schedule be denoted tau_i. [3]
>>
>> - Each task will run in intervals, each 'round' is called a job. A task
>>   consists of an infinite sequence of jobs. The k'th job of tau_i is
>>   called tau_{i,k}
>>
>> - Each task has a set of (relative) attributes supplied when the task is
>>   inserted into the scheduler (passed via syscall)
>>   * Period T_i
>>   * Deadline D_i
>>   * WCET C_i
>>
>> - Each job (tau_{i,k}) has absolute attributes (computed from the relative
>>   tasks-attributes coupled with physical time).
>>   * Release-time r_{i,k}
>>   * Deadline d_{i,k}
>>   * Allocated time so for a job, C_a(t, tau_{i,k})
>>     When C_a equals WCET, the jobs budget is exhausted and it should
>>     start a new cycle. This is tested (see below) by the scheduler.
>>   * Remaining time for the job, C_r(t, tau_{i,nk})
>>
>> - The acceptance function for EFF screens new tasks on their expected
>>   utilization. Depending on the mode and implementation, it can be based
>>   on the period, or on the deadline. The latter will cause firmer
>>   restraints, but may lead to wasted resources.
>>
>> 	U = C_i / T_i		For SRT (bounded deadline tardiness)
>> 	U = C_i / D_i		For HRT
>>
>> - A relative measure, time to failure, ttf, indicates how much time is
>>   left before a job must be scheduled to run in order to avoid a
>>   deadline-miss. This will decrease as time progresses and the job is
>>   not granted CPU time. For tasks currently running on a CPU, this value
>>   will be constant.
>>
>> 	Take a job with a WCET of 10ms, it has been allowed to run for 4
>> 	ms so far. The deadline is 8 ms away. Then the job must be
>> 	scheduled to run within the next 4 ms, otherwise it will not be
>> 	able to finish in time.
>>
>> - An absolute value, time of failure (tof) can also be computed in a
>>   static manner. For tasks not running on a CPU, the allocated time is
>>   static. That means you can take the absolute deadline, subtract the
>>   allocated time and you have the absolute point in time when a given
>>   job will fail to meet its deadline.
>>
>> === Outline of scheduler ===
>>
>> Store tasks in 2 queues. One of size m, containing all the tasks
>> currently running on the CPUs (queue R). The other will hold all
>> currently active tasks waiting to execute (queue W).
>>
>> queue R is sorted based on ttf (time to failure, the relative time left
>> until a task will miss it's deadline). As the tasks approaches the
>> absolute time of failure at the same rate C_a increases, ttf is
>> constant. R is only a 'map' of tasks to the CPUs. Position 0 in R
>> (i.e. smallest ttf) does not result in CPU#0, as the position->CPU will
>> be quite fluent.
>>
>> queue W is sorted based on absolute time of failure (tof). Since this is
>> a fixed point in time, and the tasks in W are not running (C_a is
>> unchanged), this value is constant.
>>
>> When a task is scheduled to run, a timer is set at the point in time
>> where it has exhausted it's budget (t_now + WCET - C_a). This is to
>> ensure that a runaway task does not grab the CPU.
>>
>> When a new task arrives, it is handled according the following rules:
>> - The system has one or more CPUs not running EFF-tasks. Pick any of the
>>   free CPUs and assign the new job there. Set a timer to
>>
>> - All CPUs are busy, the new task has greater time to failure than the
>>   head of W. The task is inserted into W at the appropriate place.
>>
>> - All CPUs are busy and the new task has smaller time to failure than
>>   the head of W. The new task is compared to the last task in Q. If time
>>   to failure is larger than the task at the tail, it is added to the
>>   head of W.
>>
>> - If all CPUs are busy, and time to failure is smaller than the tail of
>>   Q, the new task is a candidate for insertion. At this point the tasks
>>   must be compared to see if picking one or the other will cause a
>>   deadline-miss. If both will miss the deadline if the other is
>>   scheduled, keep the existing running and place the new at the head of
>>   W (as you will have a deadline-miss anyway unless the the task is
>>   picked up by another CPU soon).
>>
>> - A task running on a CPU with ttf=0 should *never* be preempted with
>>   another task. If all tasks in R have ttf=0, and a newly arrived task
>>   has ttf=0, a deadline-miss is inevitable and switching tasks will only
>>   waste resources.
>>
>> When a task in R finish (or is stopped due to the timer-limit), it is
>> removed from R, and the head of W is added to R, inserted at the
>> appropriate place.
>>
>> It has been some discussion lately (in particular on #linux-rt) about
>> the bandwidth inheritance (BWI) and proxy execution protocol (PEP). It
>> should be possible to extend EFF to handle both. As a side note, if
>> anyone has some good information about PEP, I'd like a copy :)
>>
>> Based on this, I think the utilization can be set as high as M
>> (i.e. full utilization of all CPUs), but the jitter can probably be
>> quite bad, so for jitter-sensitive tasks, a short period/deadline should
>> be used.
>>
>> There are still some issues left to solve, for instance how to best
>> handle sporadic tasks, and whether or not deadline-miss should be allow,
>> or just 'bounded deadline tardiness'. Either way, EFF should be able to
>> handle it. Then, there are problems concerning blocking of tasks. One
>> solution would be BWI or PEP, but I have not had the time to read
>> properly through those, but from what I've gathered a combination of BWI
>> and PEP looks promising (anyone with good info about BWI and PEP - feel
>> free to share! (-: ).
>>     
>
> Our SSSUP friends have a BWI paper here:
>
>   http://retis.sssup.it/~tommaso/publications/OSPERT-2008.pdf
>
> The thing we call PEP was christened so by Douglas Niehaus (on CC), I'm
> not sure if he has any papers on it.
>
> Also, when talking about it at OSPERT last week Ted Baker (also on CC)
> said it reminded him of something else of which I seem to have forgotten
> the name.
>
> Thing is, both BWI and PEP seems to work brilliantly on Uni-Processor
> but SMP leaves things to be desired. Dhaval is currently working on a
> PEP implementation that will migrate all the blocked tasks to the
> owner's cpu, basically reducing it to the UP problem.
>
>   
>> 1) Before you freeze at 'global' and get all caught up on "This won't
>>    ever scale to X", or "He will be haunted by Y" - I do not want to
>>    extend a global algorithm to 2000 cores. I would like to scale to a
>>    single *chip* and then we can worry about 2-way and 4-way systems
>>    later. For the record, I've donned my asbestos suit anyway.
>>     
>
> My preferred approach here is to find a distributed algorithm that
> converges to the global one.
>
>   
>> 2) http://austad.us/kernel/thesis_henrikau.pdf
>>
>> 3) Anyone want to include LaTeX-notation into an email-rfc?
>>     
>
> Not unheard of ;-)
>
>   
