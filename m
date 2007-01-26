Return-Path: <linux-kernel-owner+w=401wt.eu-S1030773AbXAZGDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030773AbXAZGDT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 01:03:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030777AbXAZGDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 01:03:19 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:48088 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030773AbXAZGDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 01:03:17 -0500
Date: Fri, 26 Jan 2007 11:33:17 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: riel@redhat.com, Ingo Molnar <mingo@elte.hu>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] core scheduler changes
Message-ID: <20070126060317.GB2487@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070126060142.GA2487@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070126060142.GA2487@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This patch does several things:

	- Introduces the notion of control window (current set at 1
	  sec - ideally the window size should be adjusted based on
	  number of users to avoid rapid context switches). Bandwidth of each 
	  user is controlled within this window.  rq->last_update tracks where 
	  are in the current window.

	- Modifies scheduler_tick() to account cpu bandwidth consumption
	  by a task group. Basically bandwidth consumed by a task is
	  charged to itself (p->time_slice) -and- to its group as well.

	- A task is forced off the CPU once its group has expired the
	  bandwidth in the current control window. Such a task is also
	  marked as "starving".

	- schedule() avoids picking tasks whose group has expired its
	  bandwidth in current control window. Any task (with non-zero
	  p->timeslice) which is not picked to run in schedule() because of 
	  this reason is marked "starving".
	
	- If a group has bandwidth left and it has starving tasks, then 
	  schedule() prefers picking such tasks over non-starving tasks.
	  This will avoid starvation of lower-priority tasks in a group.


Signed-off-by : Srivatsa Vaddagiri <vatsa@in.ibm.com>

---


diff -puN include/linux/sched.h~cpu-controller-based-on-rtlimit_rt_cpu-patch include/linux/sched.h
--- linux-2.6.20-rc5/include/linux/sched.h~cpu-controller-based-on-rtlimit_rt_cpu-patch	2007-01-19 15:17:27.000000000 +0530
+++ linux-2.6.20-rc5-vatsa/include/linux/sched.h	2007-01-26 09:04:07.000000000 +0530
@@ -531,6 +531,10 @@ struct signal_struct {
 #define is_rt_policy(p)		((p) != SCHED_NORMAL && (p) != SCHED_BATCH)
 #define has_rt_policy(p)	unlikely(is_rt_policy((p)->policy))
 
+#ifdef CONFIG_FAIRSCHED
+struct cpu_usage;
+#endif
+
 /*
  * Some day this will be a full-fledged user tracking system..
  */
@@ -555,6 +559,10 @@ struct user_struct {
 	/* Hash table maintenance information */
 	struct list_head uidhash_list;
 	uid_t uid;
+#ifdef CONFIG_FAIRSCHED
+	int cpu_limit;
+	struct cpu_usage *cpu_usage;
+#endif
 };
 
 extern struct user_struct *find_user(uid_t);
@@ -1137,6 +1145,9 @@ static inline void put_task_struct(struc
 					/* Not implemented yet, only for 486*/
 #define PF_STARTING	0x00000002	/* being created */
 #define PF_EXITING	0x00000004	/* getting shut down */
+#ifdef CONFIG_FAIRSCHED
+#define PF_STARVING	0x00000010      /* Task starving for CPU */
+#endif
 #define PF_FORKNOEXEC	0x00000040	/* forked but didn't exec */
 #define PF_SUPERPRIV	0x00000100	/* used super-user privileges */
 #define PF_DUMPCORE	0x00000200	/* dumped core */
diff -puN kernel/sched.c~cpu-controller-based-on-rtlimit_rt_cpu-patch kernel/sched.c
--- linux-2.6.20-rc5/kernel/sched.c~cpu-controller-based-on-rtlimit_rt_cpu-patch	2007-01-19 15:17:27.000000000 +0530
+++ linux-2.6.20-rc5-vatsa/kernel/sched.c	2007-01-26 09:04:07.000000000 +0530
@@ -266,6 +266,9 @@ struct rq {
 	unsigned long ttwu_local;
 #endif
 	struct lock_class_key rq_lock_key;
+#ifdef CONFIG_FAIRSCHED
+	unsigned long last_update;
+#endif
 };
 
 static DEFINE_PER_CPU(struct rq, runqueues);
@@ -710,6 +713,126 @@ enqueue_task_head(struct task_struct *p,
 	p->array = array;
 }
 
+#ifdef CONFIG_FAIRSCHED
+
+struct cpu_usage {
+       long tokens;
+       unsigned long last_update;
+       int starve_count;
+};
+
+#define task_starving(p)	(p->flags & PF_STARVING)
+
+/* Mark a task starving - either we shortcircuited its timeslice or we didnt
+ * pick it to run (because user ran out of bandwidth limit in current epoch).
+ */
+static inline void set_tsk_starving(struct task_struct *p)
+{
+	struct user_struct *user = p->user;
+	struct cpu_usage *cu;
+
+	if (task_starving(p) || !user->cpu_limit)
+		return;
+
+	cu = per_cpu_ptr(user->cpu_usage, task_cpu(p));
+	cu->starve_count++;
+	p->flags |= PF_STARVING;
+}
+
+/* Clear a task's starving flag */
+static inline void clear_tsk_starving(struct task_struct *p)
+{
+	struct user_struct *user = p->user;
+	struct cpu_usage *cu;
+
+	if (!task_starving(p) || !user->cpu_limit)
+		return;
+
+	cu = per_cpu_ptr(user->cpu_usage, task_cpu(p));
+	cu->starve_count--;
+	p->flags &= ~PF_STARVING;
+}
+
+/* Does the task's group have starving tasks? */
+static inline int is_user_starving(struct task_struct *p)
+{
+	struct user_struct *user = p->user;
+	struct cpu_usage *cu;
+
+	if (!user->cpu_limit)
+		return 0;
+
+	cu = per_cpu_ptr(user->cpu_usage, task_cpu(p));
+	if (cu->starve_count)
+		return 1;
+
+	return 0;
+}
+
+/* Are we past the 1-sec control window? If so, all groups get to renew their
+ * expired tokens.
+ */
+static inline void adjust_control_window(void)
+{
+	struct rq *rq = this_rq();
+	unsigned long delta;
+
+	delta = jiffies - rq->last_update;
+	if (delta >= HZ)
+		rq->last_update += (delta/HZ) * HZ;
+}
+
+/* Account group's cpu usage */
+static inline void inc_cpu_usage(struct task_struct *p)
+{
+	struct user_struct *user = p->user;
+	struct cpu_usage *cu;
+
+	adjust_control_window();
+
+	if (!user->cpu_limit)
+		return;
+
+	cu = per_cpu_ptr(user->cpu_usage, task_cpu(p));
+	cu->tokens--;
+}
+
+static inline int task_over_cpu_limit(struct task_struct *p)
+{
+	struct rq *rq = task_rq(p);
+	struct user_struct *user = p->user;
+	struct cpu_usage *cu;
+
+	adjust_control_window();
+
+	if (!user->cpu_limit)
+	 	return 0;
+
+	cu = per_cpu_ptr(user->cpu_usage, task_cpu(p));
+	if (cu->last_update != rq->last_update) {
+		/* Replenish tokens */
+		cu->tokens += user->cpu_limit * HZ / 100;
+		cu->last_update = rq->last_update;
+	}
+
+	if (cu->tokens <= 0)
+		return 1;
+
+	return 0;
+}
+
+#else
+
+#define task_starving(p)	0
+
+static void inc_cpu_usage(struct task_struct *p) { }
+static int task_over_cpu_limit(struct task_struct *p) { return 0; }
+static void set_tsk_starving(struct task_struct *p) { }
+static void clear_tsk_starving(struct task_struct *p) { }
+static int is_user_starving(struct task_struct *p) { return 0;}
+
+#endif		/* CONFIG_FAIRSCHED */
+
 /*
  * __normal_prio - return the priority that is based on the static
  * priority but is modified by bonuses/penalties.
@@ -1607,6 +1730,9 @@ void fastcall sched_fork(struct task_str
 	/* Want to start with kernel preemption disabled. */
 	task_thread_info(p)->preempt_count = 1;
 #endif
+#ifdef CONFIG_FAIRSCHED
+	p->flags &= ~PF_STARVING;
+#endif
 	/*
 	 * Share the timeslice between parent and child, thus the
 	 * total amount of pending timeslices in the system doesn't change,
@@ -2074,6 +2200,7 @@ static void pull_task(struct rq *src_rq,
 {
 	dequeue_task(p, src_array);
 	dec_nr_running(p, src_rq);
+	clear_tsk_starving(p);
 	set_task_cpu(p, this_cpu);
 	inc_nr_running(p, this_rq);
 	enqueue_task(p, this_array);
@@ -3137,6 +3264,9 @@ static void task_running_tick(struct rq 
 		return;
 	}
 	spin_lock(&rq->lock);
+
+	inc_cpu_usage(p);
+
 	/*
 	 * The task was running during this tick - update the
 	 * time slice counter. Note: we do not update a thread's
@@ -3163,17 +3293,18 @@ static void task_running_tick(struct rq 
 		dequeue_task(p, rq->active);
 		set_tsk_need_resched(p);
 		p->prio = effective_prio(p);
-		p->time_slice = task_timeslice(p);
 		p->first_time_slice = 0;
 
 		if (!rq->expired_timestamp)
 			rq->expired_timestamp = jiffies;
-		if (!TASK_INTERACTIVE(p) || expired_starving(rq)) {
+		if (!TASK_INTERACTIVE(p) || expired_starving(rq)
+						|| task_over_cpu_limit(p)) {
 			enqueue_task(p, rq->expired);
 			if (p->static_prio < rq->best_expired_prio)
 				rq->best_expired_prio = p->static_prio;
 		} else
 			enqueue_task(p, rq->active);
+		goto out_unlock;
 	} else {
 		/*
 		 * Prevent a too long timeslice allowing a task to monopolize
@@ -3200,6 +3331,14 @@ static void task_running_tick(struct rq 
 			set_tsk_need_resched(p);
 		}
 	}
+
+	if (task_over_cpu_limit(p)) {
+		dequeue_task(p, rq->active);
+		set_tsk_need_resched(p);
+		enqueue_task(p, rq->expired);
+		set_tsk_starving(p);
+	}
+
 out_unlock:
 	spin_unlock(&rq->lock);
 }
@@ -3416,7 +3555,7 @@ asmlinkage void __sched schedule(void)
 	struct list_head *queue;
 	unsigned long long now;
 	unsigned long run_time;
-	int cpu, idx, new_prio;
+	int cpu, idx, new_prio, array_switch;
 	long *switch_count;
 	struct rq *rq;
 
@@ -3478,6 +3617,7 @@ need_resched_nonpreemptible:
 		else {
 			if (prev->state == TASK_UNINTERRUPTIBLE)
 				rq->nr_uninterruptible++;
+			clear_tsk_starving(prev);
 			deactivate_task(prev, rq);
 		}
 	}
@@ -3493,11 +3633,15 @@ need_resched_nonpreemptible:
 		}
 	}
 
+	array_switch = 0;
+
+pick_next_task:
 	array = rq->active;
 	if (unlikely(!array->nr_active)) {
 		/*
 		 * Switch the active and expired arrays.
 		 */
+		array_switch++;
 		schedstat_inc(rq, sched_switch);
 		rq->active = rq->expired;
 		rq->expired = array;
@@ -3510,6 +3654,25 @@ need_resched_nonpreemptible:
 	queue = array->queue + idx;
 	next = list_entry(queue->next, struct task_struct, run_list);
 
+	/* If we have done an array switch twice, it means we cant find any
+	 * task which isn't above its limit and hence we just run the
+	 * first task on the active array.
+	 */
+	if (array_switch < 2 && (task_over_cpu_limit(next) ||
+			(!task_starving(next) && is_user_starving(next)))) {
+		dequeue_task(next, rq->active);
+		enqueue_task(next, rq->expired);
+		if (next->time_slice)
+			set_tsk_starving(next);
+		goto pick_next_task;
+	}
+
+	if (task_over_cpu_limit(next))
+		rq->last_update = jiffies;
+	if (!next->time_slice)
+		next->time_slice = task_timeslice(next);
+	clear_tsk_starving(next);
+
 	if (!rt_task(next) && interactive_sleep(next->sleep_type)) {
 		unsigned long long delta = now - next->timestamp;
 		if (unlikely((long long)(now - next->timestamp) < 0))
@@ -5061,6 +5224,7 @@ static int __migrate_task(struct task_st
 	if (!cpu_isset(dest_cpu, p->cpus_allowed))
 		goto out;
 
+	clear_tsk_starving(p);
 	set_task_cpu(p, dest_cpu);
 	if (p->array) {
 		/*
_

-- 
Regards,
vatsa
