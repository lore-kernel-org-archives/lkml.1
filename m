Return-Path: <linux-kernel-owner+w=401wt.eu-S1754028AbZKUMD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028AbZKUMD6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 07:03:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753505AbZKUMD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 07:03:57 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:40253 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860AbZKUMD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 07:03:57 -0500
Subject: Re: [PATCH 05/19] sched: implement sched_notifier_wake_up_process()
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net
In-Reply-To: <1258692407-8985-6-git-send-email-tj@kernel.org>
References: <1258692407-8985-1-git-send-email-tj@kernel.org>
	 <1258692407-8985-6-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 21 Nov 2009 13:02:55 +0100
Message-ID: <1258804975.4104.913.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-11-20 at 13:46 +0900, Tejun Heo wrote:
> Implement sched_notifier_wake_up_process() which can be called from
> wakeup, sleep and in scheduler notifiers to wake up a task which is
> bound to the same cpu.  This will be used to implement concurrency
> managed workqueue.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
 
>  /**
> + * sched_notifier_wake_up_process - wake up a process from sched notifier
> + * @p: task to wake up
> + *
> + * Wake up @p.  This function can only be called from wakeup, sleep
> + * and in scheduler notifiers and can only wake up tasks which are
> + * already bound to the cpu in question.
> + *
> + * CONTEXT:
> + * Scheduler notifiers.
> + *
> + * RETURNS:
> + * true if @p was waken up, false if @p was already awake.
> + */
> +bool sched_notifier_wake_up_process(struct task_struct *p)
> +{
> +	struct rq *rq = task_rq(p);
> +	bool success = false;
> +
> +	assert_spin_locked(&rq->lock);
> +
> +	if (!p->se.on_rq) {
> +		schedstat_inc(p, se.nr_wakeups);
> +		schedstat_inc(p, se.nr_wakeups_local);
> +		activate_task(rq, p, 1);
> +		success = true;
> +	}
> +
> +	trace_sched_wakeup(rq, p, success);
> +	p->state = TASK_RUNNING;
> +#ifdef CONFIG_SMP
> +	if (p->sched_class->task_wake_up)
> +		p->sched_class->task_wake_up(rq, p);
> +#endif
> +	return success;
> +}

I hate the name, better would be something like try_to_wake_up_local()
and enforce that the target is indeed bound to the same cpu and that rq
is this_rq().

Furthermore it misses half the things ttwu does to tasks.

Best would be if you can break the current ttwu up into two functions,
one that does the final wakeup, so as to share that part of the code.

Something like this, only less hacky, thought through and tested...

(the below almost certainly does not compile and will be buggy if it
does, this ttwu stuff is beyond tricky).

---
diff --git a/kernel/sched.c b/kernel/sched.c
index 0cbf2ef..6e7daae 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2323,70 +2323,20 @@ void task_oncpu_function_call(struct task_struct *p,
 	preempt_enable();
 }
 
-/***
- * try_to_wake_up - wake up a thread
- * @p: the to-be-woken-up thread
- * @state: the mask of task states that can be woken
- * @sync: do a synchronous wakeup?
- *
- * Put it on the run-queue if it's not already there. The "current"
- * thread is always on the run-queue (except when the actual
- * re-schedule is in progress), and as such you're allowed to do
- * the simpler "current->state = TASK_RUNNING" to mark yourself
- * runnable without the overhead of this.
- *
- * returns failure only if the task is already active.
- */
-static int try_to_wake_up(struct task_struct *p, unsigned int state,
-			  int wake_flags)
+static inline int 
+__try_to_wake_up_local(struct task_struct *p, struct rq *rq, int wake_flags)
 {
-	int cpu, orig_cpu, this_cpu, success = 0;
-	unsigned long flags;
-	struct rq *rq, *orig_rq;
-
-	if (!sched_feat(SYNC_WAKEUPS))
-		wake_flags &= ~WF_SYNC;
-
-	this_cpu = get_cpu();
-
-	smp_wmb();
-	rq = orig_rq = task_rq_lock(p, &flags);
-	update_rq_clock(rq);
-	if (!(p->state & state))
-		goto out;
+	int cpu, this_cpu = smp_processor_id();
+	int success = 0;
 
 	if (p->se.on_rq)
 		goto out_running;
 
-	cpu = task_cpu(p);
-	orig_cpu = cpu;
-
 #ifdef CONFIG_SMP
 	if (unlikely(task_running(rq, p)))
 		goto out_activate;
+#endif
 
-	/*
-	 * In order to handle concurrent wakeups and release the rq->lock
-	 * we put the task in TASK_WAKING state.
-	 *
-	 * First fix up the nr_uninterruptible count:
-	 */
-	if (task_contributes_to_load(p))
-		rq->nr_uninterruptible--;
-	p->state = TASK_WAKING;
-	task_rq_unlock(rq, &flags);
-
-	cpu = p->sched_class->select_task_rq(p, SD_BALANCE_WAKE, wake_flags);
-	if (cpu != orig_cpu) {
-		local_irq_save(flags);
-		rq = cpu_rq(cpu);
-		update_rq_clock(rq);
-		set_task_cpu(p, cpu);
-		local_irq_restore(flags);
-	}
-	rq = task_rq_lock(p, &flags);
-
-	WARN_ON(p->state != TASK_WAKING);
 	cpu = task_cpu(p);
 
 #ifdef CONFIG_SCHEDSTATS
@@ -2455,12 +2405,102 @@ out_running:
 	}
 #endif
 out:
+	return success;
+}
+
+/***
+ * try_to_wake_up - wake up a thread
+ * @p: the to-be-woken-up thread
+ * @state: the mask of task states that can be woken
+ * @sync: do a synchronous wakeup?
+ *
+ * Put it on the run-queue if it's not already there. The "current"
+ * thread is always on the run-queue (except when the actual
+ * re-schedule is in progress), and as such you're allowed to do
+ * the simpler "current->state = TASK_RUNNING" to mark yourself
+ * runnable without the overhead of this.
+ *
+ * returns failure only if the task is already active.
+ */
+static int try_to_wake_up(struct task_struct *p, unsigned int state,
+			  int wake_flags)
+{
+	int cpu, orig_cpu, this_cpu, success = 0;
+	unsigned long flags;
+	struct rq *rq, *orig_rq;
+
+	if (!sched_feat(SYNC_WAKEUPS))
+		wake_flags &= ~WF_SYNC;
+
+	this_cpu = get_cpu();
+
+	smp_wmb();
+	rq = orig_rq = task_rq_lock(p, &flags);
+	update_rq_clock(rq);
+	if (!(p->state & state))
+		goto out;
+
+	if (p->se.on_rq)
+		goto out_running;
+
+	cpu = task_cpu(p);
+	orig_cpu = cpu;
+
+#ifdef CONFIG_SMP
+	if (unlikely(task_running(rq, p)))
+		goto out_activate;
+
+	/*
+	 * In order to handle concurrent wakeups and release the rq->lock
+	 * we put the task in TASK_WAKING state.
+	 *
+	 * First fix up the nr_uninterruptible count:
+	 */
+	if (task_contributes_to_load(p))
+		rq->nr_uninterruptible--;
+	p->state = TASK_WAKING;
+	task_rq_unlock(rq, &flags);
+
+	cpu = p->sched_class->select_task_rq(p, SD_BALANCE_WAKE, wake_flags);
+	if (cpu != orig_cpu) {
+		local_irq_save(flags);
+		rq = cpu_rq(cpu);
+		update_rq_clock(rq);
+		set_task_cpu(p, cpu);
+		local_irq_restore(flags);
+	}
+	rq = task_rq_lock(p, &flags);
+
+out_activate:
+out_running:
+	success == __try_to_wake_up_local(p, rq, wake_flags);
+
+out:
 	task_rq_unlock(rq, &flags);
 	put_cpu();
 
 	return success;
 }
 
+int 
+try_to_wake_up_local(struct task_struct *p, unsigned int state, int wake_flags)
+{
+	struct rq *rq = task_rq(p);
+	int success = 0;
+
+	BUG_ON(rq != this_rq());
+	lockdep_assert_held(&rq->lock);
+	/* assert p->cpus_allowed == mask_of_this_cpu */
+
+	if (!(p->state & state))
+		goto out;
+
+	success = __try_to_wake_up(p, rq, wake_flags);
+
+out:
+	return success;
+}
+
 /**
  * wake_up_process - Wake up a specific process
  * @p: The process to be woken up.



