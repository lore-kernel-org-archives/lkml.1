Return-Path: <linux-kernel-owner+w=401wt.eu-S1754193AbXJICqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193AbXJICqq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 22:46:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752741AbXJICqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 22:46:35 -0400
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:33909 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683AbXJICqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 22:46:34 -0400
Date: Mon, 8 Oct 2007 22:46:21 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Mike Kravetz <kravetz@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH RT] fix rt-task scheduling issue
Message-ID: <20071009024621.GA12915@goodmis.org>
References: <20071006021548.GE4587@monkey.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071006021548.GE4587@monkey.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mike,

Can you attach your Signed-off-by to this patch, please.


On Fri, Oct 05, 2007 at 07:15:48PM -0700, Mike Kravetz wrote:
> Hi Ingo,
> 
> After applying the fix to try_to_wake_up() I was still seeing some large
> latencies for realtime tasks.  Some debug code pointed out two additional
> causes of these latencies.  I have put fixes into my 'old' kernel and the
> scheduler related latencies have gone away.  I'm pretty confident that
> one of these bugs still exist in the latest RT patch set.  Not so sure
> about the other.  But, I wanted to describe in detail so that you could
> address in the latest version of the code if applicable.
> 
> finish_task_switch() contains the following code:
> 
> #if defined(CONFIG_PREEMPT_RT) && defined(CONFIG_SMP)
> 	/*
> 	 * If we pushed an RT task off the runqueue,
> 	 * then kick other CPUs, they might run it:
> 	 */
> 	if (unlikely(rt_task(current) && prev->se.on_rq && rt_task(prev))) {
> 		schedstat_inc(rq, rto_schedule);
> 		smp_send_reschedule_allbutself_cpumask(current->cpus_allowed);
> 	}
> #endif
> 
> My debug code found instances where more than one realtime task got
> put on the runqueue before the __schedule() was invoked.  So, current
> would be a realtime task, but prev was not realtime.  And, there was
> another (lesser priority, or last in) realtime task on the queue.  I
> believe that in this case we would still want to send the IPIs.  In my
> kernel I changed the test to be:
> 
> 	if (unlikely(rt_task(current) && rq->rt_nr_running > 1)) {
> 
> After this change, I definitely saw some long latencies go away.

I definitely agree with your analysis.

> 
> The other place of concern is in the routine pull_task().  I was a
> little surprised to see realtime tasks moved around via normal load
> balancing.  But, my debug code did point this out.  In the code for
> my old kernel, the routines end with:
> 
>         /*
>          * Note that idle threads have a prio of MAX_PRIO, for this test
>          * to be always true for them.
>          */
>         if (TASK_PREEMPTS_CURR(p, this_rq))
>                 resched_task(this_rq->curr);
> 
> This reminded me very much of the situation/code in try_to_wake_up().
> If pull_tasks() pulled in a realtime task, then I think it should also
> deal with the case where (TASK_PREEMPTS_CURR(p, this_rq) is false.  So
> I changed the code in my kernel to be:
> 
> 	/*
> 	 * Note that idle threads have a prio of MAX_PRIO, for this test
> 	 * to be always true for them.
> 	 */
> 	if (TASK_PREEMPTS_CURR(p, this_rq)) {
> 		resched_task(this_rq->curr);
> 
> 	} else if (unlikely(rt_task(p))) {
> 		/* no appropriate rt_overload counter goes here */
> 		smp_send_reschedule_allbutself();
> 	}

I'm thinking that the first change would actually make this one
obsolete. The checking at the time of scheduling should cover most cases
where multiple rt tasks are being queued on the same CPU.  When we see
that the rt tasks are bunching up on a queue we should handle it then.
Which I would think is at the time of schedule, and the time a task is
queued (try_to_wake_up). Hopefully this is enough.

> 
> To be perfectly honest, I don't know if this change helped eliminate
> any of the large latencies I was seeing.  I made this changes first,
> and was still seeing some large latencies.  I then made the modification
> to finish_task_switch() and all my scheduler related latencies went
> away.  Entirely possible this change had no impact.  Also, the above

I'm thinking it may have had little to no effect. The first change seems
to be the culprit.

> code is replaced in the latest kernels with:
> 
> 	check_preempt_curr(this_rq, p);
> 
> What check_preempt_curr() does is not immediately obvious to me. So,
> this may not apply at all.  Just something to think about.

I also don't want to put too many IPI reschedules when we see that we
have more than one rt task on queue. I can imaging an IPI scheduling
storm if we have one more rt tasks than CPUs. So sending the IPI when a
task switch actually occurs seems approriate.

-- Steve

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>


Index: linux-2.6.23-rc9-rt2/kernel/sched.c
===================================================================
--- linux-2.6.23-rc9-rt2.orig/kernel/sched.c
+++ linux-2.6.23-rc9-rt2/kernel/sched.c
@@ -2207,7 +2207,7 @@ static inline void finish_task_switch(st
 	 * If we pushed an RT task off the runqueue,
 	 * then kick other CPUs, they might run it:
 	 */
-	if (unlikely(rt_task(current) && prev->se.on_rq && rt_task(prev))) {
+	if (unlikely(rt_task(current) && rq->rt_nr_running > 1)) {
 		schedstat_inc(rq, rto_schedule);
 		smp_send_reschedule_allbutself_cpumask(current->cpus_allowed);
 	}
