Return-Path: <linux-kernel-owner+w=401wt.eu-S1762436AbXENLLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762436AbXENLLR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 07:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756875AbXENLLD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 07:11:03 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44470 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756806AbXENLLB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 07:11:01 -0400
Date: Mon, 14 May 2007 13:10:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: efault@gmx.de, tingy@cs.umass.edu, wli@holomorphy.com,
       linux-kernel@vger.kernel.org
Subject: Re: fair clock use in CFS
Message-ID: <20070514111051.GB23766@elte.hu>
References: <20070514083358.GA29775@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070514083358.GA29775@in.ibm.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Srivatsa Vaddagiri <vatsa@in.ibm.com> wrote:

> 	I have been brooding over how fair clock is computed/used in 
> CFS and thought I would ask the experts to avoid wrong guesses!

hey, thanks for the interest :-)

> As I understand, fair_clock is a monotonously increasing clock which 
> advances at a pace inversely proportional to the load on the runqueue. 
> If load = 1 (task), it will advance at same pace as wall clock, as 
> load increases it advances slower than wall clock.

correct.

> In addition, following calculations depend on fair clock: task's wait 
> time on runqueue and sleep time outside the runqueue (both reflected 
> in p->wait_run_time).

(note that in -v12 only the on-runqueue wait time is used.)

> Few questions that come up are:
> 
> 1. Why can't fair clock be same as wall clock at all times? i.e fair
>    clock progresses at same pace as wall clock independent of the load 
>    on the runqueue.
> 
>    It would still give the ability to measure time spent waiting on 
>    runqueue or sleeping and use that calculated time to give 
>    latency/bandwidth credit?

155 milliseconds spent waiting for CPU time while there are another 10 
tasks contending for the CPU is a different scenario from when there is 
just one task running on the CPU. In the 10-task case a single task 
would only have a 'fair expectation' to run for 15.5 milliseconds, in 
the 1-task case a single task has a 'fair expectation' to run the full 
155 milliseconds. The 'fair clock' measures this capacity of 'effective 
CPU power' in essence.

but let me give you some more CFS design background:

80% of CFS's design can be summed up in a single sentence: CFS basically 
models an "ideal, precise multi-tasking CPU" on real hardware.

"Ideal multi-tasking CPU" is a (non-existent :-) CPU that has 100% 
physical power and which can run each task at precise equal speed, in 
parallel, each at 1/nr_running speed. For example: if there are 2 tasks 
running then it runs each at 50% physical power - totally in parallel.

On real hardware, we can run only a single task at once, so while that 
one task runs the other tasks that are waiting for the CPU are at a 
disadvantage - the current task gets an unfair amount of CPU time. In 
CFS this fairness imbalance is expressed and tracked via the per-task 
p->wait_runtime (nanosec-unit) value. "wait_runtime" is the amount of 
time the task should now run on the CPU for it become completely fair 
and balanced.

( small detail: on 'ideal' hardware, the p->wait_runtime value would
  always be zero - no task would ever get 'out of balance' from the
  'ideal' share of CPU time. )

CFS's task picking logic is based on this p->wait_runtime value and it 
is thus very simple: it always tries to run the task with the largest 
p->wait_runtime value. In other words, CFS tries to run the task with 
the 'gravest need' for more CPU time. So CFS always tries to split up 
CPU time between runnable tasks as close to 'ideal multitasking 
hardware' as possible.

Most of the rest of CFS's design just falls out of this really simple 
concept, with a few add-on embellishments like nice levels, 
multiprocessing and various algorithm variants to recognize sleepers.

In practice it works like this: the system runs a task a bit, and when 
the task schedules (or a scheduler tick happens) the task's CPU usage is 
'accounted for': the (small) time it just spent using the physical CPU 
is deducted from p->wait_runtime. [minus the 'fair share' it would have 
gotten anyway]. Once p->wait_runtime gets low enough so that another 
task becomes the 'leftmost task' (plus a small amount of 'granularity' 
distance relative to the leftmost task so that we do not over-schedule 
tasks and trash the cache) then the new leftmost task is picked and the 
current task is preempted.

The rq->fair_clock value tracks the 'CPU time a runnable task would have 
fairly gotten, had it been runnable during that time'. So by using 
rq->fair_clock values we can accurately timestamp and measure the 
'expected CPU time' a task should have gotten. All runnable tasks are 
sorted in the rbtree by the "rq->fair_clock - p->wait_runtime" key, and 
CFS picks the 'leftmost' task and sticks to it. As the system progresses 
forwards, newly woken tasks are put into the tree more and more to the 
right - slowly but surely giving a chance for every task to become the 
'leftmost task' and thus get on the CPU within a deterministic amount of 
time.

> 2. Preemption granularity - sysctl_sched_granularity
> 
> 	This seems to be measured in the fair clock scale rather than 
> 	wall clock scale. As a consequence of this, the time taken for a 
> 	task to relinquish to competetion is dependent on number N of 
> 	tasks? For ex: if there a million cpu hungry tasks, then the 
> 	time taken to switch between two tasks is more compared to the 
> 	case where just two cpu hungry tasks are running. Is there any 
> 	advantage of using fair clock scale to detect preemtion points?

yes, there is an advantage. The granularity is really mostly a property 
of the physical CPU and not part of the "precise scheduling" model. 
Granularity expresses the fact that a task has caching affinity to the 
CPU and there is a cost to scheduling in a too finegrained way. This 
granularity value does not depend on the number of tasks running. For 
example the granularity value could be made really small if CPUs had no 
task-switching costs.

( small detail: the granularity value is currently dependent on the nice
  level, making it easier for higher-prio tasks to preempt lower-prio
  tasks. )

( i'd agree in theory with the proposition that the granularity could be
  made a function of load too, but only to model cache/affinity effects,
  _not_ due to the basic model of precise scheduling. )

	Ingo
