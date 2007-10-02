Return-Path: <linux-kernel-owner+w=401wt.eu-S1753232AbXJBFHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232AbXJBFHR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 01:07:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750923AbXJBFHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 01:07:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50498 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164AbXJBFHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 01:07:03 -0400
Date: Tue, 2 Oct 2007 07:06:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Kravetz <kravetz@us.ibm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Clark Williams <williams@redhat.com>
Subject: Re: -rt scheduling: wakeup bug?
Message-ID: <20071002050632.GB28345@elte.hu>
References: <20071001221519.GA20671@monkey.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071001221519.GA20671@monkey.ibm.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


hi Mike,

* Mike Kravetz <kravetz@us.ibm.com> wrote:

> I've been trying to track down some unexpected realtime latencies and
> believe one source is a bug in the wakeup code.  Specifically, this is
> within the try_to_wake_up() routine.  Within this routine there is the
> following code segment:
> 
> 	/*
> 	 * If a newly woken up RT task cannot preempt the
> 	 * current (RT) task (on a target runqueue) then try
> 	 * to find another CPU it can preempt:
> 	 */
> 	if (rt_task(p) && !TASK_PREEMPTS_CURR(p, rq)) {
> 		struct rq *this_rq = cpu_rq(this_cpu);
> 		/*
> 		 * Special-case: the task on this CPU can be
> 		 * preempted. In that case there's no need to
> 		 * trigger reschedules on other CPUs, we can
> 		 * mark the current task for reschedule.
> 		 *
> 		 * (Note that it's safe to access this_rq without
> 		 * extra locking in this particular case, because
> 		 * we are on the current CPU.)
> 		 */
> 		if (TASK_PREEMPTS_CURR(p, this_rq))
> 			set_tsk_need_resched(this_rq->curr);
> 		else
> 			/*
> 			 * Neither the intended target runqueue
> 			 * nor the current CPU can take this task.
> 			 * Trigger a reschedule on all other CPUs
> 			 * nevertheless, maybe one of them can take
> 			 * this task:
> 			 */
> 			smp_send_reschedule_allbutself_cpumask(p->cpus_allowed);
> 
> 		schedstat_inc(this_rq, rto_wakeup);
> 	}
> 
> This logic seems appropriate.  But, the task 'p' is most likely not on 
> the runqueue when sending the IPI.  It gets added to the runqueue a 
> little later in the routine.  As a result, the 'rt_overload' global 
> may not be set (based on the count of RT tasks on the runqueue) and 
> other CPUs may 'pass over' the runqueue when doing RT load balancing.
> 
> My observations/debugging/conclusions are based on an earlier version 
> of the code.  It appears the same code/issue still exists in the most 
> version.  But, I have not not done any work with the latest version.

I believe you are right - nice catch of this very nontrivial bug! The 
patch below is against .23-rc - do you think this fix (of moving the rt 
wakeup sequence to after the activate_task()) is adequate?

	Ingo

Index: linux-rt-rebase.q/kernel/sched.c
===================================================================
--- linux-rt-rebase.q.orig/kernel/sched.c
+++ linux-rt-rebase.q/kernel/sched.c
@@ -1819,6 +1819,13 @@ out_set_cpu:
 		cpu = task_cpu(p);
 	}
 
+out_activate:
+#endif /* CONFIG_SMP */
+
+	activate_task(rq, p, 1);
+
+	trace_start_sched_wakeup(p, rq);
+
 	/*
 	 * If a newly woken up RT task cannot preempt the
 	 * current (RT) task (on a target runqueue) then try
@@ -1849,28 +1856,21 @@ out_set_cpu:
 			smp_send_reschedule_allbutself_cpumask(p->cpus_allowed);
 
 		schedstat_inc(this_rq, rto_wakeup);
-	}
-
-out_activate:
-#endif /* CONFIG_SMP */
-
-	activate_task(rq, p, 1);
-
-	trace_start_sched_wakeup(p, rq);
-
-	/*
-	 * Sync wakeups (i.e. those types of wakeups where the waker
-	 * has indicated that it will leave the CPU in short order)
-	 * don't trigger a preemption, if the woken up task will run on
-	 * this cpu. (in this case the 'I will reschedule' promise of
-	 * the waker guarantees that the freshly woken up task is going
-	 * to be considered on this CPU.)
-	 */
-	if (!sync || cpu != this_cpu)
-		check_preempt_curr(rq, p);
-	else {
-		if (TASK_PREEMPTS_CURR(p, rq))
-			set_tsk_need_resched_delayed(rq->curr);
+	} else {
+		/*
+		 * Sync wakeups (i.e. those types of wakeups where the waker
+		 * has indicated that it will leave the CPU in short order)
+		 * don't trigger a preemption, if the woken up task will run on
+		 * this cpu. (in this case the 'I will reschedule' promise of
+		 * the waker guarantees that the freshly woken up task is going
+		 * to be considered on this CPU.)
+		 */
+		if (!sync || cpu != this_cpu)
+			check_preempt_curr(rq, p);
+		else {
+			if (TASK_PREEMPTS_CURR(p, rq))
+				set_tsk_need_resched_delayed(rq->curr);
+		}
 	}
 	if (rq->curr && p && rq && _need_resched())
 		trace_special_pid(p->pid, PRIO(p), PRIO(rq->curr));
