Return-Path: <linux-kernel-owner+w=401wt.eu-S1422947AbXDTGDB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422947AbXDTGDB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 02:03:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422952AbXDTGDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 02:03:00 -0400
Received: from omta01sl.mx.bigpond.com ([144.140.92.153]:41777 "EHLO
	omta01sl.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422947AbXDTGC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 02:02:59 -0400
Message-ID: <46285781.7090205@bigpond.net.au>
Date: Fri, 20 Apr 2007 16:02:41 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [patch] CFS scheduler, v3
References: <20070418175017.GA5250@elte.hu> <46280505.4020605@bigpond.net.au> <20070420044850.GA31438@1wt.eu>
In-Reply-To: <20070420044850.GA31438@1wt.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta06sl.mx.bigpond.com from [58.164.138.40] using ID pwil3058@bigpond.net.au at Fri, 20 Apr 2007 06:02:46 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau wrote:
> On Fri, Apr 20, 2007 at 10:10:45AM +1000, Peter Williams wrote:
>> Ingo Molnar wrote:
>>> - bugfix: use constant offset factor for nice levels instead of 
>>>   sched_granularity_ns. Thus nice levels work even if someone sets 
>>>   sched_granularity_ns to 0. NOTE: nice support is still naive, i'll 
>>>   address the many nice level related suggestions in -v4.
>> I have a suggestion I'd like to make that addresses both nice and 
>> fairness at the same time.  As I understand the basic principle behind 
>> this scheduler it to work out a time by which a task should make it onto 
>> the CPU and then place it into an ordered list (based on this value) of 
>> tasks waiting for the CPU.  I think that this is a great idea and my 
>> suggestion is with regard to a method for working out this time that 
>> takes into account both fairness and nice.
>>
>> First suppose we have the following metrics available in addition to 
>> what's already provided.
>>
>> rq->avg_weight_load /* a running average of the weighted load on the CPU */
>> p->avg_cpu_per_cycle /* the average time in nsecs that p spends on the 
>> CPU each scheduling cycle */
>>
>> where a scheduling cycle for a task starts when it is placed on the 
>> queue after waking or being preempted and ends when it is taken off the 
>> CPU either voluntarily or after being preempted.  So 
>> p->avg_cpu_per_cycle is just the average amount of time p spends on the 
>> CPU each time it gets on to the CPU.  Sorry for the long explanation 
>> here but I just wanted to make sure there was no chance that "scheduling 
>> cycle" would be construed as some mechanism being imposed on the scheduler.)
>>
>> We can then define:
>>
>> effective_weighted_load = max(rq->raw_weighted_load, rq->avg_weighted_load)
>>
>> If p is just waking (i.e. it's not on the queue and its load_weight is 
>> not included in rq->raw_weighted_load) and we need to queue it, we say 
>> that the maximum time (in all fairness) that p should have to wait to 
>> get onto the CPU is:
>>
>> expected_wait = p->avg_cpu_per_cycle * effective_weighted_load / 
>> p->load_weight
>>
>> Calculating p->avg_cpu_per_cycle costs one add, one multiply and one 
>> shift right per scheduling cycle of the task.  An additional cost is 
>> that you need a shift right to get the nanosecond value from value 
>> stored in the task struct. (i.e. the above code is simplified to give 
>> the general idea).  The average would be number of cycles based rather 
>> than time based and (happily) this simplifies the calculations.
>>
>> If the expected time to get onto the CPU (i.e. expected_wait plus the 
>> current time) for p is earlier than the equivalent time for the 
>> currently running task then preemption of that task would be justified.
> 
> I 100% agree on this method because I came to nearly the same conclusion on
> paper about 1 year ago. What I'd like to add is that the expected wake up time
> is not the most precise criterion for fairness.

It's not the expected wake up time being computed.  It's the expected 
time that the task is selected to run after being put on the queue 
(either as a result of waking or being pre-empted).

I think that your comments below are mainly invalid because of this 
understanding.

> The expected completion
> time is better. When you have one task t1 which is expected to run for T1
> nanosecs and another task t2 which is expected to run for T2, what is
> important for the user for fairness is when the task completes its work. If
> t1 should wake up at time W1 and t2 at W2, then the list should be ordered
> by comparing W1+T1 and W2+T2.

This is a point where misunderstanding results in a wrong conclusion. 
However, the notion of expected completion time is useful.  I'd 
calculate the expected completion time for the task as it goes on to the 
CPU and if while it is running a new task is queued whose expected "on 
CPU" time is before the current task's expected end time you can think 
about preempting when the new tasks "on CPU" task arrives -- how 
hard/easy this would be to implement is moot.

> 
> What I like with this method is that it remains fair with nice tasks because
> because in order to renice a task tN, you just have to change TN, and if it
> has to run shorter, it can be executed before CPU hogs and stay there for a
> very short time.
> 
> Also, I found that if we want to respect interactivity, we must conserve a
> credit for each task.

This is one point where the misunderstanding results in an invalid 
conclusion.  There is no need for credits as the use of the average time 
on CPU each cycle makes the necessary corrections that credits would be 
used to address.

> It is a bounded amount of CPU time left to be used. When
> the task t3 has the right to use T3 nsecs, and wakes up at W3, if it does not
> spend T3 nsec on the CPU, but only N3<T3, then we have a credit C3 computed
> like this :
> 
>   C3 = MAX(MAX_CREDIT, C3 + T3 - N3)
> 
> And if a CPU hog uses more than its assigned time slice due to scheduler
> resolution, then C3 can become negative (and bounded too) :
> 
>   C3 = MAX(MIN_CREDIT, C3 + T3 - N3)
> 
> Now how is the credit used ? Simple: the credit is a part of a timeslice, so
> it's systematically added to the computed timeslice when ordering the tasks.
> So we indeed order tasks t1 and t2 by W1+T1+C1 and W2+T2+C2.

I think this is overcomplicating matters.

However, some compensating credit might be in order for tasks that get 
pre-empted e.g. base their next expected "on CPU" time on the difference 
between their average on CPU time and they amount they got to use before 
they were pre-empted.

> 
> It means that an interactive task which has not eaten all of timeslice will
> accumulate time credit have great chances of being able to run before others
> if it wakes up again, and even use slightly more CPU time than others if it
> has not used it before. Conversely, if a task eats too much CPU time, it will
> be punished and wait longer than others, and run less, to compensate for the
> advance it has taken.

I think that with this model you can almost do away with the notion of a 
time slice but I need to think about that some more as the idea I have 
for doing that may have some gotchas.

> 
> Also, what I like with this method is that it can correctly handle the
> fork/exit storms which quickly change the per-task allocated CPU time.
> Upon fork() or exit(), it should not be too hard to readjust Tx and Cx
> for each task and reorder them according to their new completion time.
> 
> I've not found a way to include a variable nr_running in the tree and
> order the tasks according to an external variable, hence the need to
> rescan the tree upon fork/exit for maximum precision. That's where I
> stopped working on those ideas. If someone knows how to order the tree
> by (Wx+(Tx+Cx)/nr_running) with nr_running which can change at any time
> but which is common for everyone in the tree, that would be great.

There is only one potential exploit for this method that I can see (but 
that doesn't mean there aren't others) and that is a task that does 
virtually no CPU use when on the CPU and has very short sleeps such as 
the expected "on CPU" time is "right now" (and it's happening at high 
frequency due to the short sleeps), even when other tasks are running, 
due to the average "on CPU" time being zero. This could be defeated by 
using min(average "on CPU" time, some system dependent minimum).

In practice, it might be prudent to use the idea of maximum expected "on 
CPU" time instead of the average (especially if you're going to use this 
for triggering pre-emption).  This would be the average plus two or 
three time the standard deviation and has the down side that you have to 
calculate the standard deviation and that means a square root (of course 
we could use some less mathematically rigorous metric to approximate the 
standard deviation).  The advantage would be that streamer type programs 
such as audio/video applications would have very small standard 
deviations and would hence get earlier expected "on CPU" times than 
other tasks with similar averages but more random distribution.

Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce
