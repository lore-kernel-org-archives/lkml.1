Return-Path: <linux-kernel-owner+w=401wt.eu-S934230AbZLFSD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934230AbZLFSD7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 13:03:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934134AbZLFSD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 13:03:56 -0500
Received: from www.tglx.de ([62.245.132.106]:33220 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934142AbZLFSDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 13:03:24 -0500
Message-Id: <20091206111957.845650656@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sun, 06 Dec 2009 18:03:01 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Linux-Arch <linux-arch@vger.kernel.org>
Subject: [patch 14/23] sched: Convert rq->lock to raw_spinlock
References: <20091206110944.492100233@linutronix.de>
Content-Disposition: inline; filename=sched-convert-rq-lock-to-core-lock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched.c          |  183 ++++++++++++++++++++++++------------------------
 kernel/sched_debug.c    |    4 -
 kernel/sched_idletask.c |    4 -
 kernel/sched_rt.c       |   14 +--
 4 files changed, 104 insertions(+), 101 deletions(-)

Index: linux-2.6-tip/kernel/sched.c
===================================================================
--- linux-2.6-tip.orig/kernel/sched.c
+++ linux-2.6-tip/kernel/sched.c
@@ -525,7 +525,7 @@ static struct root_domain def_root_domai
  */
 struct rq {
 	/* runqueue lock: */
-	spinlock_t lock;
+	raw_spinlock_t lock;
 
 	/*
 	 * nr_running and cpu_load should be in the same cacheline because
@@ -685,7 +685,7 @@ inline void update_rq_clock(struct rq *r
  */
 int runqueue_is_locked(int cpu)
 {
-	return spin_is_locked(&cpu_rq(cpu)->lock);
+	return raw_spin_is_locked(&cpu_rq(cpu)->lock);
 }
 
 /*
@@ -883,7 +883,7 @@ static inline void finish_lock_switch(st
 {
 #ifdef CONFIG_DEBUG_SPINLOCK
 	/* this is a valid case when another task releases the spinlock */
-	rq->lock.rlock.owner = current;
+	rq->lock.owner = current;
 #endif
 	/*
 	 * If we are tracking spinlock dependencies then we have to
@@ -892,7 +892,7 @@ static inline void finish_lock_switch(st
 	 */
 	spin_acquire(&rq->lock.dep_map, 0, 0, _THIS_IP_);
 
-	spin_unlock_irq(&rq->lock);
+	raw_spin_unlock_irq(&rq->lock);
 }
 
 #else /* __ARCH_WANT_UNLOCKED_CTXSW */
@@ -916,9 +916,9 @@ static inline void prepare_lock_switch(s
 	next->oncpu = 1;
 #endif
 #ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
-	spin_unlock_irq(&rq->lock);
+	raw_spin_unlock_irq(&rq->lock);
 #else
-	spin_unlock(&rq->lock);
+	raw_spin_unlock(&rq->lock);
 #endif
 }
 
@@ -948,10 +948,10 @@ static inline struct rq *__task_rq_lock(
 {
 	for (;;) {
 		struct rq *rq = task_rq(p);
-		spin_lock(&rq->lock);
+		raw_spin_lock(&rq->lock);
 		if (likely(rq == task_rq(p)))
 			return rq;
-		spin_unlock(&rq->lock);
+		raw_spin_unlock(&rq->lock);
 	}
 }
 
@@ -968,10 +968,10 @@ static struct rq *task_rq_lock(struct ta
 	for (;;) {
 		local_irq_save(*flags);
 		rq = task_rq(p);
-		spin_lock(&rq->lock);
+		raw_spin_lock(&rq->lock);
 		if (likely(rq == task_rq(p)))
 			return rq;
-		spin_unlock_irqrestore(&rq->lock, *flags);
+		raw_spin_unlock_irqrestore(&rq->lock, *flags);
 	}
 }
 
@@ -980,19 +980,19 @@ void task_rq_unlock_wait(struct task_str
 	struct rq *rq = task_rq(p);
 
 	smp_mb(); /* spin-unlock-wait is not a full memory barrier */
-	spin_unlock_wait(&rq->lock);
+	raw_spin_unlock_wait(&rq->lock);
 }
 
 static void __task_rq_unlock(struct rq *rq)
 	__releases(rq->lock)
 {
-	spin_unlock(&rq->lock);
+	raw_spin_unlock(&rq->lock);
 }
 
 static inline void task_rq_unlock(struct rq *rq, unsigned long *flags)
 	__releases(rq->lock)
 {
-	spin_unlock_irqrestore(&rq->lock, *flags);
+	raw_spin_unlock_irqrestore(&rq->lock, *flags);
 }
 
 /*
@@ -1005,7 +1005,7 @@ static struct rq *this_rq_lock(void)
 
 	local_irq_disable();
 	rq = this_rq();
-	spin_lock(&rq->lock);
+	raw_spin_lock(&rq->lock);
 
 	return rq;
 }
@@ -1052,10 +1052,10 @@ static enum hrtimer_restart hrtick(struc
 
 	WARN_ON_ONCE(cpu_of(rq) != smp_processor_id());
 
-	spin_lock(&rq->lock);
+	raw_spin_lock(&rq->lock);
 	update_rq_clock(rq);
 	rq->curr->sched_class->task_tick(rq, rq->curr, 1);
-	spin_unlock(&rq->lock);
+	raw_spin_unlock(&rq->lock);
 
 	return HRTIMER_NORESTART;
 }
@@ -1068,10 +1068,10 @@ static void __hrtick_start(void *arg)
 {
 	struct rq *rq = arg;
 
-	spin_lock(&rq->lock);
+	raw_spin_lock(&rq->lock);
 	hrtimer_restart(&rq->hrtick_timer);
 	rq->hrtick_csd_pending = 0;
-	spin_unlock(&rq->lock);
+	raw_spin_unlock(&rq->lock);
 }
 
 /*
@@ -1178,7 +1178,7 @@ static void resched_task(struct task_str
 {
 	int cpu;
 
-	assert_spin_locked(&task_rq(p)->lock);
+	assert_raw_spin_locked(&task_rq(p)->lock);
 
 	if (test_tsk_need_resched(p))
 		return;
@@ -1200,10 +1200,10 @@ static void resched_cpu(int cpu)
 	struct rq *rq = cpu_rq(cpu);
 	unsigned long flags;
 
-	if (!spin_trylock_irqsave(&rq->lock, flags))
+	if (!raw_spin_trylock_irqsave(&rq->lock, flags))
 		return;
 	resched_task(cpu_curr(cpu));
-	spin_unlock_irqrestore(&rq->lock, flags);
+	raw_spin_unlock_irqrestore(&rq->lock, flags);
 }
 
 #ifdef CONFIG_NO_HZ
@@ -1272,7 +1272,7 @@ static void sched_rt_avg_update(struct r
 #else /* !CONFIG_SMP */
 static void resched_task(struct task_struct *p)
 {
-	assert_spin_locked(&task_rq(p)->lock);
+	assert_raw_spin_locked(&task_rq(p)->lock);
 	set_tsk_need_resched(p);
 }
 
@@ -1599,11 +1599,11 @@ static void update_group_shares_cpu(stru
 		struct rq *rq = cpu_rq(cpu);
 		unsigned long flags;
 
-		spin_lock_irqsave(&rq->lock, flags);
+		raw_spin_lock_irqsave(&rq->lock, flags);
 		tg->cfs_rq[cpu]->rq_weight = boost ? 0 : rq_weight;
 		tg->cfs_rq[cpu]->shares = boost ? 0 : shares;
 		__set_se_shares(tg->se[cpu], shares);
-		spin_unlock_irqrestore(&rq->lock, flags);
+		raw_spin_unlock_irqrestore(&rq->lock, flags);
 	}
 }
 
@@ -1701,9 +1701,9 @@ static void update_shares_locked(struct 
 	if (root_task_group_empty())
 		return;
 
-	spin_unlock(&rq->lock);
+	raw_spin_unlock(&rq->lock);
 	update_shares(sd);
-	spin_lock(&rq->lock);
+	raw_spin_lock(&rq->lock);
 }
 
 static void update_h_load(long cpu)
@@ -1743,7 +1743,7 @@ static inline int _double_lock_balance(s
 	__acquires(busiest->lock)
 	__acquires(this_rq->lock)
 {
-	spin_unlock(&this_rq->lock);
+	raw_spin_unlock(&this_rq->lock);
 	double_rq_lock(this_rq, busiest);
 
 	return 1;
@@ -1764,14 +1764,16 @@ static int _double_lock_balance(struct r
 {
 	int ret = 0;
 
-	if (unlikely(!spin_trylock(&busiest->lock))) {
+	if (unlikely(!raw_spin_trylock(&busiest->lock))) {
 		if (busiest < this_rq) {
-			spin_unlock(&this_rq->lock);
-			spin_lock(&busiest->lock);
-			spin_lock_nested(&this_rq->lock, SINGLE_DEPTH_NESTING);
+			raw_spin_unlock(&this_rq->lock);
+			raw_spin_lock(&busiest->lock);
+			raw_spin_lock_nested(&this_rq->lock,
+					      SINGLE_DEPTH_NESTING);
 			ret = 1;
 		} else
-			spin_lock_nested(&busiest->lock, SINGLE_DEPTH_NESTING);
+			raw_spin_lock_nested(&busiest->lock,
+					      SINGLE_DEPTH_NESTING);
 	}
 	return ret;
 }
@@ -1785,7 +1787,7 @@ static int double_lock_balance(struct rq
 {
 	if (unlikely(!irqs_disabled())) {
 		/* printk() doesn't work good under rq->lock */
-		spin_unlock(&this_rq->lock);
+		raw_spin_unlock(&this_rq->lock);
 		BUG_ON(1);
 	}
 
@@ -1795,7 +1797,7 @@ static int double_lock_balance(struct rq
 static inline void double_unlock_balance(struct rq *this_rq, struct rq *busiest)
 	__releases(busiest->lock)
 {
-	spin_unlock(&busiest->lock);
+	raw_spin_unlock(&busiest->lock);
 	lock_set_subclass(&this_rq->lock.dep_map, 0, _RET_IP_);
 }
 #endif
@@ -2016,13 +2018,13 @@ void kthread_bind(struct task_struct *p,
 		return;
 	}
 
-	spin_lock_irqsave(&rq->lock, flags);
+	raw_spin_lock_irqsave(&rq->lock, flags);
 	update_rq_clock(rq);
 	set_task_cpu(p, cpu);
 	p->cpus_allowed = cpumask_of_cpu(cpu);
 	p->rt.nr_cpus_allowed = 1;
 	p->flags |= PF_THREAD_BOUND;
-	spin_unlock_irqrestore(&rq->lock, flags);
+	raw_spin_unlock_irqrestore(&rq->lock, flags);
 }
 EXPORT_SYMBOL(kthread_bind);
 
@@ -2798,10 +2800,10 @@ static inline void post_schedule(struct 
 	if (rq->post_schedule) {
 		unsigned long flags;
 
-		spin_lock_irqsave(&rq->lock, flags);
+		raw_spin_lock_irqsave(&rq->lock, flags);
 		if (rq->curr->sched_class->post_schedule)
 			rq->curr->sched_class->post_schedule(rq);
-		spin_unlock_irqrestore(&rq->lock, flags);
+		raw_spin_unlock_irqrestore(&rq->lock, flags);
 
 		rq->post_schedule = 0;
 	}
@@ -3083,15 +3085,15 @@ static void double_rq_lock(struct rq *rq
 {
 	BUG_ON(!irqs_disabled());
 	if (rq1 == rq2) {
-		spin_lock(&rq1->lock);
+		raw_spin_lock(&rq1->lock);
 		__acquire(rq2->lock);	/* Fake it out ;) */
 	} else {
 		if (rq1 < rq2) {
-			spin_lock(&rq1->lock);
-			spin_lock_nested(&rq2->lock, SINGLE_DEPTH_NESTING);
+			raw_spin_lock(&rq1->lock);
+			raw_spin_lock_nested(&rq2->lock, SINGLE_DEPTH_NESTING);
 		} else {
-			spin_lock(&rq2->lock);
-			spin_lock_nested(&rq1->lock, SINGLE_DEPTH_NESTING);
+			raw_spin_lock(&rq2->lock);
+			raw_spin_lock_nested(&rq1->lock, SINGLE_DEPTH_NESTING);
 		}
 	}
 	update_rq_clock(rq1);
@@ -3108,9 +3110,9 @@ static void double_rq_unlock(struct rq *
 	__releases(rq1->lock)
 	__releases(rq2->lock)
 {
-	spin_unlock(&rq1->lock);
+	raw_spin_unlock(&rq1->lock);
 	if (rq1 != rq2)
-		spin_unlock(&rq2->lock);
+		raw_spin_unlock(&rq2->lock);
 	else
 		__release(rq2->lock);
 }
@@ -4207,14 +4209,15 @@ redo:
 
 		if (unlikely(sd->nr_balance_failed > sd->cache_nice_tries+2)) {
 
-			spin_lock_irqsave(&busiest->lock, flags);
+			raw_spin_lock_irqsave(&busiest->lock, flags);
 
 			/* don't kick the migration_thread, if the curr
 			 * task on busiest cpu can't be moved to this_cpu
 			 */
 			if (!cpumask_test_cpu(this_cpu,
 					      &busiest->curr->cpus_allowed)) {
-				spin_unlock_irqrestore(&busiest->lock, flags);
+				raw_spin_unlock_irqrestore(&busiest->lock,
+							    flags);
 				all_pinned = 1;
 				goto out_one_pinned;
 			}
@@ -4224,7 +4227,7 @@ redo:
 				busiest->push_cpu = this_cpu;
 				active_balance = 1;
 			}
-			spin_unlock_irqrestore(&busiest->lock, flags);
+			raw_spin_unlock_irqrestore(&busiest->lock, flags);
 			if (active_balance)
 				wake_up_process(busiest->migration_thread);
 
@@ -4406,10 +4409,10 @@ redo:
 		/*
 		 * Should not call ttwu while holding a rq->lock
 		 */
-		spin_unlock(&this_rq->lock);
+		raw_spin_unlock(&this_rq->lock);
 		if (active_balance)
 			wake_up_process(busiest->migration_thread);
-		spin_lock(&this_rq->lock);
+		raw_spin_lock(&this_rq->lock);
 
 	} else
 		sd->nr_balance_failed = 0;
@@ -5278,11 +5281,11 @@ void scheduler_tick(void)
 
 	sched_clock_tick();
 
-	spin_lock(&rq->lock);
+	raw_spin_lock(&rq->lock);
 	update_rq_clock(rq);
 	update_cpu_load(rq);
 	curr->sched_class->task_tick(rq, curr, 0);
-	spin_unlock(&rq->lock);
+	raw_spin_unlock(&rq->lock);
 
 	perf_event_task_tick(curr, cpu);
 
@@ -5478,7 +5481,7 @@ need_resched_nonpreemptible:
 	if (sched_feat(HRTICK))
 		hrtick_clear(rq);
 
-	spin_lock_irq(&rq->lock);
+	raw_spin_lock_irq(&rq->lock);
 	update_rq_clock(rq);
 	clear_tsk_need_resched(prev);
 
@@ -5514,7 +5517,7 @@ need_resched_nonpreemptible:
 		cpu = smp_processor_id();
 		rq = cpu_rq(cpu);
 	} else
-		spin_unlock_irq(&rq->lock);
+		raw_spin_unlock_irq(&rq->lock);
 
 	post_schedule(rq);
 
@@ -6995,7 +6998,7 @@ void __cpuinit init_idle(struct task_str
 	struct rq *rq = cpu_rq(cpu);
 	unsigned long flags;
 
-	spin_lock_irqsave(&rq->lock, flags);
+	raw_spin_lock_irqsave(&rq->lock, flags);
 
 	__sched_fork(idle);
 	idle->se.exec_start = sched_clock();
@@ -7008,7 +7011,7 @@ void __cpuinit init_idle(struct task_str
 #if defined(CONFIG_SMP) && defined(__ARCH_WANT_UNLOCKED_CTXSW)
 	idle->oncpu = 1;
 #endif
-	spin_unlock_irqrestore(&rq->lock, flags);
+	raw_spin_unlock_irqrestore(&rq->lock, flags);
 
 	/* Set the preempt count _outside_ the spinlocks! */
 #if defined(CONFIG_PREEMPT)
@@ -7204,10 +7207,10 @@ static int migration_thread(void *data)
 		struct migration_req *req;
 		struct list_head *head;
 
-		spin_lock_irq(&rq->lock);
+		raw_spin_lock_irq(&rq->lock);
 
 		if (cpu_is_offline(cpu)) {
-			spin_unlock_irq(&rq->lock);
+			raw_spin_unlock_irq(&rq->lock);
 			break;
 		}
 
@@ -7219,7 +7222,7 @@ static int migration_thread(void *data)
 		head = &rq->migration_queue;
 
 		if (list_empty(head)) {
-			spin_unlock_irq(&rq->lock);
+			raw_spin_unlock_irq(&rq->lock);
 			schedule();
 			set_current_state(TASK_INTERRUPTIBLE);
 			continue;
@@ -7228,14 +7231,14 @@ static int migration_thread(void *data)
 		list_del_init(head->next);
 
 		if (req->task != NULL) {
-			spin_unlock(&rq->lock);
+			raw_spin_unlock(&rq->lock);
 			__migrate_task(req->task, cpu, req->dest_cpu);
 		} else if (likely(cpu == (badcpu = smp_processor_id()))) {
 			req->dest_cpu = RCU_MIGRATION_GOT_QS;
-			spin_unlock(&rq->lock);
+			raw_spin_unlock(&rq->lock);
 		} else {
 			req->dest_cpu = RCU_MIGRATION_MUST_SYNC;
-			spin_unlock(&rq->lock);
+			raw_spin_unlock(&rq->lock);
 			WARN_ONCE(1, "migration_thread() on CPU %d, expected %d\n", badcpu, cpu);
 		}
 		local_irq_enable();
@@ -7358,14 +7361,14 @@ void sched_idle_next(void)
 	 * Strictly not necessary since rest of the CPUs are stopped by now
 	 * and interrupts disabled on the current cpu.
 	 */
-	spin_lock_irqsave(&rq->lock, flags);
+	raw_spin_lock_irqsave(&rq->lock, flags);
 
 	__setscheduler(rq, p, SCHED_FIFO, MAX_RT_PRIO-1);
 
 	update_rq_clock(rq);
 	activate_task(rq, p, 0);
 
-	spin_unlock_irqrestore(&rq->lock, flags);
+	raw_spin_unlock_irqrestore(&rq->lock, flags);
 }
 
 /*
@@ -7401,9 +7404,9 @@ static void migrate_dead(unsigned int de
 	 * that's OK. No task can be added to this CPU, so iteration is
 	 * fine.
 	 */
-	spin_unlock_irq(&rq->lock);
+	raw_spin_unlock_irq(&rq->lock);
 	move_task_off_dead_cpu(dead_cpu, p);
-	spin_lock_irq(&rq->lock);
+	raw_spin_lock_irq(&rq->lock);
 
 	put_task_struct(p);
 }
@@ -7670,13 +7673,13 @@ migration_call(struct notifier_block *nf
 
 		/* Update our root-domain */
 		rq = cpu_rq(cpu);
-		spin_lock_irqsave(&rq->lock, flags);
+		raw_spin_lock_irqsave(&rq->lock, flags);
 		if (rq->rd) {
 			BUG_ON(!cpumask_test_cpu(cpu, rq->rd->span));
 
 			set_rq_online(rq);
 		}
-		spin_unlock_irqrestore(&rq->lock, flags);
+		raw_spin_unlock_irqrestore(&rq->lock, flags);
 		break;
 
 #ifdef CONFIG_HOTPLUG_CPU
@@ -7701,14 +7704,14 @@ migration_call(struct notifier_block *nf
 		put_task_struct(rq->migration_thread);
 		rq->migration_thread = NULL;
 		/* Idle task back to normal (off runqueue, low prio) */
-		spin_lock_irq(&rq->lock);
+		raw_spin_lock_irq(&rq->lock);
 		update_rq_clock(rq);
 		deactivate_task(rq, rq->idle, 0);
 		rq->idle->static_prio = MAX_PRIO;
 		__setscheduler(rq, rq->idle, SCHED_NORMAL, 0);
 		rq->idle->sched_class = &idle_sched_class;
 		migrate_dead_tasks(cpu);
-		spin_unlock_irq(&rq->lock);
+		raw_spin_unlock_irq(&rq->lock);
 		cpuset_unlock();
 		migrate_nr_uninterruptible(rq);
 		BUG_ON(rq->nr_running != 0);
@@ -7718,30 +7721,30 @@ migration_call(struct notifier_block *nf
 		 * they didn't take sched_hotcpu_mutex. Just wake up
 		 * the requestors.
 		 */
-		spin_lock_irq(&rq->lock);
+		raw_spin_lock_irq(&rq->lock);
 		while (!list_empty(&rq->migration_queue)) {
 			struct migration_req *req;
 
 			req = list_entry(rq->migration_queue.next,
 					 struct migration_req, list);
 			list_del_init(&req->list);
-			spin_unlock_irq(&rq->lock);
+			raw_spin_unlock_irq(&rq->lock);
 			complete(&req->done);
-			spin_lock_irq(&rq->lock);
+			raw_spin_lock_irq(&rq->lock);
 		}
-		spin_unlock_irq(&rq->lock);
+		raw_spin_unlock_irq(&rq->lock);
 		break;
 
 	case CPU_DYING:
 	case CPU_DYING_FROZEN:
 		/* Update our root-domain */
 		rq = cpu_rq(cpu);
-		spin_lock_irqsave(&rq->lock, flags);
+		raw_spin_lock_irqsave(&rq->lock, flags);
 		if (rq->rd) {
 			BUG_ON(!cpumask_test_cpu(cpu, rq->rd->span));
 			set_rq_offline(rq);
 		}
-		spin_unlock_irqrestore(&rq->lock, flags);
+		raw_spin_unlock_irqrestore(&rq->lock, flags);
 		break;
 #endif
 	}
@@ -7971,7 +7974,7 @@ static void rq_attach_root(struct rq *rq
 	struct root_domain *old_rd = NULL;
 	unsigned long flags;
 
-	spin_lock_irqsave(&rq->lock, flags);
+	raw_spin_lock_irqsave(&rq->lock, flags);
 
 	if (rq->rd) {
 		old_rd = rq->rd;
@@ -7997,7 +8000,7 @@ static void rq_attach_root(struct rq *rq
 	if (cpumask_test_cpu(rq->cpu, cpu_active_mask))
 		set_rq_online(rq);
 
-	spin_unlock_irqrestore(&rq->lock, flags);
+	raw_spin_unlock_irqrestore(&rq->lock, flags);
 
 	if (old_rd)
 		free_rootdomain(old_rd);
@@ -9352,7 +9355,7 @@ static void init_rt_rq(struct rt_rq *rt_
 #ifdef CONFIG_SMP
 	rt_rq->rt_nr_migratory = 0;
 	rt_rq->overloaded = 0;
-	plist_head_init(&rt_rq->pushable_tasks, &rq->lock);
+	plist_head_init_raw(&rt_rq->pushable_tasks, &rq->lock);
 #endif
 
 	rt_rq->rt_time = 0;
@@ -9518,7 +9521,7 @@ void __init sched_init(void)
 		struct rq *rq;
 
 		rq = cpu_rq(i);
-		spin_lock_init(&rq->lock);
+		raw_spin_lock_init(&rq->lock);
 		rq->nr_running = 0;
 		rq->calc_load_active = 0;
 		rq->calc_load_update = jiffies + LOAD_FREQ;
@@ -10106,9 +10109,9 @@ static void set_se_shares(struct sched_e
 	struct rq *rq = cfs_rq->rq;
 	unsigned long flags;
 
-	spin_lock_irqsave(&rq->lock, flags);
+	raw_spin_lock_irqsave(&rq->lock, flags);
 	__set_se_shares(se, shares);
-	spin_unlock_irqrestore(&rq->lock, flags);
+	raw_spin_unlock_irqrestore(&rq->lock, flags);
 }
 
 static DEFINE_MUTEX(shares_mutex);
@@ -10708,9 +10711,9 @@ static u64 cpuacct_cpuusage_read(struct 
 	/*
 	 * Take rq->lock to make 64-bit read safe on 32-bit platforms.
 	 */
-	spin_lock_irq(&cpu_rq(cpu)->lock);
+	raw_spin_lock_irq(&cpu_rq(cpu)->lock);
 	data = *cpuusage;
-	spin_unlock_irq(&cpu_rq(cpu)->lock);
+	raw_spin_unlock_irq(&cpu_rq(cpu)->lock);
 #else
 	data = *cpuusage;
 #endif
@@ -10726,9 +10729,9 @@ static void cpuacct_cpuusage_write(struc
 	/*
 	 * Take rq->lock to make 64-bit write safe on 32-bit platforms.
 	 */
-	spin_lock_irq(&cpu_rq(cpu)->lock);
+	raw_spin_lock_irq(&cpu_rq(cpu)->lock);
 	*cpuusage = val;
-	spin_unlock_irq(&cpu_rq(cpu)->lock);
+	raw_spin_unlock_irq(&cpu_rq(cpu)->lock);
 #else
 	*cpuusage = val;
 #endif
@@ -10962,9 +10965,9 @@ void synchronize_sched_expedited(void)
 		init_completion(&req->done);
 		req->task = NULL;
 		req->dest_cpu = RCU_MIGRATION_NEED_QS;
-		spin_lock_irqsave(&rq->lock, flags);
+		raw_spin_lock_irqsave(&rq->lock, flags);
 		list_add(&req->list, &rq->migration_queue);
-		spin_unlock_irqrestore(&rq->lock, flags);
+		raw_spin_unlock_irqrestore(&rq->lock, flags);
 		wake_up_process(rq->migration_thread);
 	}
 	for_each_online_cpu(cpu) {
@@ -10972,11 +10975,11 @@ void synchronize_sched_expedited(void)
 		req = &per_cpu(rcu_migration_req, cpu);
 		rq = cpu_rq(cpu);
 		wait_for_completion(&req->done);
-		spin_lock_irqsave(&rq->lock, flags);
+		raw_spin_lock_irqsave(&rq->lock, flags);
 		if (unlikely(req->dest_cpu == RCU_MIGRATION_MUST_SYNC))
 			need_full_sync = 1;
 		req->dest_cpu = RCU_MIGRATION_IDLE;
-		spin_unlock_irqrestore(&rq->lock, flags);
+		raw_spin_unlock_irqrestore(&rq->lock, flags);
 	}
 	rcu_expedited_state = RCU_EXPEDITED_STATE_IDLE;
 	synchronize_sched_expedited_count++;
Index: linux-2.6-tip/kernel/sched_debug.c
===================================================================
--- linux-2.6-tip.orig/kernel/sched_debug.c
+++ linux-2.6-tip/kernel/sched_debug.c
@@ -184,7 +184,7 @@ void print_cfs_rq(struct seq_file *m, in
 	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "exec_clock",
 			SPLIT_NS(cfs_rq->exec_clock));
 
-	spin_lock_irqsave(&rq->lock, flags);
+	raw_spin_lock_irqsave(&rq->lock, flags);
 	if (cfs_rq->rb_leftmost)
 		MIN_vruntime = (__pick_next_entity(cfs_rq))->vruntime;
 	last = __pick_last_entity(cfs_rq);
@@ -192,7 +192,7 @@ void print_cfs_rq(struct seq_file *m, in
 		max_vruntime = last->vruntime;
 	min_vruntime = cfs_rq->min_vruntime;
 	rq0_min_vruntime = cpu_rq(0)->cfs.min_vruntime;
-	spin_unlock_irqrestore(&rq->lock, flags);
+	raw_spin_unlock_irqrestore(&rq->lock, flags);
 	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "MIN_vruntime",
 			SPLIT_NS(MIN_vruntime));
 	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "min_vruntime",
Index: linux-2.6-tip/kernel/sched_idletask.c
===================================================================
--- linux-2.6-tip.orig/kernel/sched_idletask.c
+++ linux-2.6-tip/kernel/sched_idletask.c
@@ -34,10 +34,10 @@ static struct task_struct *pick_next_tas
 static void
 dequeue_task_idle(struct rq *rq, struct task_struct *p, int sleep)
 {
-	spin_unlock_irq(&rq->lock);
+	raw_spin_unlock_irq(&rq->lock);
 	printk(KERN_ERR "bad: scheduling from the idle thread!\n");
 	dump_stack();
-	spin_lock_irq(&rq->lock);
+	raw_spin_lock_irq(&rq->lock);
 }
 
 static void put_prev_task_idle(struct rq *rq, struct task_struct *prev)
Index: linux-2.6-tip/kernel/sched_rt.c
===================================================================
--- linux-2.6-tip.orig/kernel/sched_rt.c
+++ linux-2.6-tip/kernel/sched_rt.c
@@ -454,9 +454,9 @@ static void disable_runtime(struct rq *r
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&rq->lock, flags);
+	raw_spin_lock_irqsave(&rq->lock, flags);
 	__disable_runtime(rq);
-	spin_unlock_irqrestore(&rq->lock, flags);
+	raw_spin_unlock_irqrestore(&rq->lock, flags);
 }
 
 static void __enable_runtime(struct rq *rq)
@@ -486,9 +486,9 @@ static void enable_runtime(struct rq *rq
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&rq->lock, flags);
+	raw_spin_lock_irqsave(&rq->lock, flags);
 	__enable_runtime(rq);
-	spin_unlock_irqrestore(&rq->lock, flags);
+	raw_spin_unlock_irqrestore(&rq->lock, flags);
 }
 
 static int balance_runtime(struct rt_rq *rt_rq)
@@ -524,7 +524,7 @@ static int do_sched_rt_period_timer(stru
 		struct rt_rq *rt_rq = sched_rt_period_rt_rq(rt_b, i);
 		struct rq *rq = rq_of_rt_rq(rt_rq);
 
-		spin_lock(&rq->lock);
+		raw_spin_lock(&rq->lock);
 		if (rt_rq->rt_time) {
 			u64 runtime;
 
@@ -545,7 +545,7 @@ static int do_sched_rt_period_timer(stru
 
 		if (enqueue)
 			sched_rt_rq_enqueue(rt_rq);
-		spin_unlock(&rq->lock);
+		raw_spin_unlock(&rq->lock);
 	}
 
 	return idle;
@@ -1246,7 +1246,7 @@ static struct rq *find_lock_lowest_rq(st
 				     task_running(rq, task) ||
 				     !task->se.on_rq)) {
 
-				spin_unlock(&lowest_rq->lock);
+				raw_spin_unlock(&lowest_rq->lock);
 				lowest_rq = NULL;
 				break;
 			}


