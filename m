Return-Path: <linux-kernel-owner+w=401wt.eu-S1753286AbZKIHJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286AbZKIHJf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 02:09:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751514AbZKIHJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 02:09:34 -0500
Received: from mail.gmx.net ([213.165.64.20]:45600 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751420AbZKIHJd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 02:09:33 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19EUFM2Go1E8C3fOCdAgwoAwAQvw/AaI3dqb7diik
	mJWERoxabPUcqj
Subject: Re: specjbb2005 and aim7 regression with 2.6.32-rc kernels
From: Mike Galbraith <efault@gmx.de>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <1257747597.16282.120.camel@ymzhang>
References: <1257493130.16282.109.camel@ymzhang>
	 <20091106080418.GB28227@elte.hu>  <1257747597.16282.120.camel@ymzhang>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Nov 2009 08:09:33 +0100
Message-Id: <1257750573.6414.29.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-09 at 14:19 +0800, Zhang, Yanmin wrote:
> On Fri, 2009-11-06 at 09:04 +0100, Ingo Molnar wrote:
> > * Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:
> > 
> > > Comparing with 2.6.31, specjbb2005 and aim7 have some regressions with 
> > > 2.6.32-rc kernels on core2 machines.
> > > 
> > > 1) On 4*4 core tigerton: specjbb2005 has about 5% regression.
> > > 2) On 2*4 stoakley: aim7 has about 5% regression.
> > > 
> > > On Nehalem, specjbb2005 has about 2%~8% improvement instead of 
> > > regression.
> > > 
> > > aim7 has much dependency on schedule patameters, such like 
> > > sched_latency_ns, sched_min_granularity_ns, and 
> > > sched_wakeup_granularity_ns. 2.6.32-rc kernel decreases these 
> > > parameter values. I restore them and retest aim7 on stoakley. aim7 
> > > regression becomes about 2% and specjbb2005 regression also becomes 
> > > 2%. But on Nehalem, the improvement shrinks.
> > 
> > Which precise 2.6.32-rc commit have you tested?
> > 
> > Since v2.6.32-rc6 Linus's tree has this one too:
> > 
> >   f685cea: sched: Strengthen buddies and mitigate buddy induced latencies
> > 
> > Which should improve things a bit. For 2.6.33 we have queued up these 
> > two in -tip:
> > 
> >   a1f84a3: sched: Check for an idle shared cache in select_task_rq_fair()
> >   1b9508f: sched: Rate-limit newidle
> > 
> > If any of them fixes a performance regression we could still merge them 
> > into 2.6.32 as well.
> ﻿1b9508f definitely fixes netperf UDP loopback regression.

Excellent, I was pretty darn sure it would.  When I (well, more likely
Peter;) get all the necessary barriers in place, all should be well for
32 release scheduler wise now.

With the minimal test diff against virgin mainline below, my enumeration
woes are gone, and I'm within 2% of 31 on extreme context switch pinned
tasks, and within .7%, comparing locked vs unlocked runqueue selection.

(now to wander over to cpumask.[ch] before Peter wakes up and see if I
can close the holes without killing performance;)

diff --git a/kernel/sched.c b/kernel/sched.c
index 28dd4f4..837ab30 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -590,6 +590,8 @@ struct rq {
 
 	u64 rt_avg;
 	u64 age_stamp;
+	u64 idle_stamp;
+	u64 avg_idle;
 #endif
 
 	/* calc_load related fields */
@@ -1009,6 +1011,24 @@ static struct rq *this_rq_lock(void)
 	return rq;
 }
 
+/*
+ * cpu_rq_lock - lock the runqueue a given cpu and disable interrupts.
+ */
+static struct rq *cpu_rq_lock(int cpu, unsigned long *flags)
+	__acquires(rq->lock)
+{
+	struct rq *rq = cpu_rq(cpu);
+
+	spin_lock_irqsave(&rq->lock, *flags);
+	return rq;
+}
+
+static inline void cpu_rq_unlock(struct rq *rq, unsigned long *flags)
+	__releases(rq->lock)
+{
+	spin_unlock_irqrestore(&rq->lock, *flags);
+}
+
 #ifdef CONFIG_SCHED_HRTICK
 /*
  * Use HR-timers to deliver accurate preemption points.
@@ -2372,16 +2392,19 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state,
 	if (task_contributes_to_load(p))
 		rq->nr_uninterruptible--;
 	p->state = TASK_WAKING;
+	preempt_disable();
 	task_rq_unlock(rq, &flags);
 
 	cpu = p->sched_class->select_task_rq(p, SD_BALANCE_WAKE, wake_flags);
-	if (cpu != orig_cpu)
-		set_task_cpu(p, cpu);
-
 	rq = task_rq_lock(p, &flags);
 
-	if (rq != orig_rq)
+	if (cpu != orig_cpu) {
+		task_rq_unlock(rq, &flags);
+		rq = cpu_rq_lock(cpu, &flags);
 		update_rq_clock(rq);
+		set_task_cpu(p, cpu);
+	}
+	preempt_enable_no_resched();
 
 	WARN_ON(p->state != TASK_WAKING);
 	cpu = task_cpu(p);
@@ -2439,6 +2462,17 @@ out_running:
 #ifdef CONFIG_SMP
 	if (p->sched_class->task_wake_up)
 		p->sched_class->task_wake_up(rq, p);
+
+	if (unlikely(rq->idle_stamp)) {
+		u64 delta = rq->clock - rq->idle_stamp;
+		u64 max = 2*sysctl_sched_migration_cost;
+
+		if (delta > max)
+			rq->avg_idle = max;
+		else
+			update_avg(&rq->avg_idle, delta);
+		rq->idle_stamp = 0;
+	}
 #endif
 out:
 	task_rq_unlock(rq, &flags);
@@ -4125,7 +4159,9 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 	unsigned long flags;
 	struct cpumask *cpus = __get_cpu_var(load_balance_tmpmask);
 
+	smp_read_barrier_depends();
 	cpumask_setall(cpus);
+	cpumask_and(cpus, cpus, cpu_online_mask);
 
 	/*
 	 * When power savings policy is enabled for the parent domain, idle
@@ -4288,7 +4324,9 @@ load_balance_newidle(int this_cpu, struct rq *this_rq, struct sched_domain *sd)
 	int all_pinned = 0;
 	struct cpumask *cpus = __get_cpu_var(load_balance_tmpmask);
 
+	smp_read_barrier_depends();
 	cpumask_setall(cpus);
+	cpumask_and(cpus, cpus, cpu_online_mask);
 
 	/*
 	 * When power savings policy is enabled for the parent domain, idle
@@ -4428,6 +4466,11 @@ static void idle_balance(int this_cpu, struct rq *this_rq)
 	int pulled_task = 0;
 	unsigned long next_balance = jiffies + HZ;
 
+	this_rq->idle_stamp = this_rq->clock;
+
+	if (this_rq->avg_idle < sysctl_sched_migration_cost)
+		return;
+
 	for_each_domain(this_cpu, sd) {
 		unsigned long interval;
 
@@ -4442,8 +4485,10 @@ static void idle_balance(int this_cpu, struct rq *this_rq)
 		interval = msecs_to_jiffies(sd->balance_interval);
 		if (time_after(next_balance, sd->last_balance + interval))
 			next_balance = sd->last_balance + interval;
-		if (pulled_task)
+		if (pulled_task) {
+			this_rq->idle_stamp = 0;
 			break;
+		}
 	}
 	if (pulled_task || time_after(jiffies, this_rq->next_balance)) {
 		/*
@@ -7054,6 +7099,7 @@ int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
 	int ret = 0;
 
 	rq = task_rq_lock(p, &flags);
+	smp_read_barrier_depends();
 	if (!cpumask_intersects(new_mask, cpu_online_mask)) {
 		ret = -EINVAL;
 		goto out;
@@ -7065,11 +7111,13 @@ int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
 		goto out;
 	}
 
-	if (p->sched_class->set_cpus_allowed)
+	if (p->sched_class->set_cpus_allowed) {
 		p->sched_class->set_cpus_allowed(p, new_mask);
-	else {
+		smp_wmb();
+	} else {
 		cpumask_copy(&p->cpus_allowed, new_mask);
 		p->rt.nr_cpus_allowed = cpumask_weight(new_mask);
+		smp_wmb();
 	}
 
 	/* Can the task run on the task's current CPU? If so, we're done */
@@ -7166,6 +7214,7 @@ static int migration_thread(void *data)
 		struct list_head *head;
 
 		spin_lock_irq(&rq->lock);
+		smp_read_barrier_depends();
 
 		if (cpu_is_offline(cpu)) {
 			spin_unlock_irq(&rq->lock);
@@ -7571,6 +7620,7 @@ static void set_rq_online(struct rq *rq)
 		const struct sched_class *class;
 
 		cpumask_set_cpu(rq->cpu, rq->rd->online);
+		smp_wmb();
 		rq->online = 1;
 
 		for_each_class(class) {
@@ -7591,6 +7641,7 @@ static void set_rq_offline(struct rq *rq)
 		}
 
 		cpumask_clear_cpu(rq->cpu, rq->rd->online);
+		smp_wmb();
 		rq->online = 0;
 	}
 }
@@ -9521,6 +9572,8 @@ void __init sched_init(void)
 		rq->cpu = i;
 		rq->online = 0;
 		rq->migration_thread = NULL;
+		rq->idle_stamp = 0;
+		rq->avg_idle = 2*sysctl_sched_migration_cost;
 		INIT_LIST_HEAD(&rq->migration_queue);
 		rq_attach_root(rq, &def_root_domain);
 #endif
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index efb8440..dd304a9 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -285,12 +285,14 @@ static void print_cpu(struct seq_file *m, int cpu)
 
 #ifdef CONFIG_SCHEDSTATS
 #define P(n) SEQ_printf(m, "  .%-30s: %d\n", #n, rq->n);
+#define P64(n) SEQ_printf(m, "  .%-30s: %Ld\n", #n, rq->n);
 
 	P(yld_count);
 
 	P(sched_switch);
 	P(sched_count);
 	P(sched_goidle);
+	P64(avg_idle);
 
 	P(ttwu_count);
 	P(ttwu_local);
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 37087a7..f36d5d0 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1360,13 +1360,14 @@ static int select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flag
 	struct sched_domain *tmp, *affine_sd = NULL, *sd = NULL;
 	int cpu = smp_processor_id();
 	int prev_cpu = task_cpu(p);
-	int new_cpu = cpu;
+	int task_pinned = cpumask_weight(&p->cpus_allowed) == 1;
+	int new_cpu = task_pinned ? prev_cpu : cpu;
 	int want_affine = 0;
-	int want_sd = 1;
+	int want_sd = !task_pinned;
 	int sync = wake_flags & WF_SYNC;
 
 	if (sd_flag & SD_BALANCE_WAKE) {
-		if (sched_feat(AFFINE_WAKEUPS) &&
+		if (sched_feat(AFFINE_WAKEUPS) && !task_pinned &&
 		    cpumask_test_cpu(cpu, &p->cpus_allowed))
 			want_affine = 1;
 		new_cpu = prev_cpu;
@@ -1374,11 +1375,12 @@ static int select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flag
 
 	rcu_read_lock();
 	for_each_domain(cpu, tmp) {
+		smp_read_barrier_depends();
 		/*
 		 * If power savings logic is enabled for a domain, see if we
 		 * are not overloaded, if so, don't balance wider.
 		 */
-		if (tmp->flags & (SD_POWERSAVINGS_BALANCE|SD_PREFER_LOCAL)) {
+		if (want_sd && tmp->flags & (SD_POWERSAVINGS_BALANCE|SD_PREFER_LOCAL)) {
 			unsigned long power = 0;
 			unsigned long nr_running = 0;
 			unsigned long capacity;
@@ -1429,6 +1431,12 @@ static int select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flag
 			update_shares(tmp);
 	}
 
+	/*
+	 * Balance shares maybe, but don't waste time balancing.
+	 */
+	if (task_pinned)
+		goto out;
+
 	if (affine_sd && wake_affine(affine_sd, p, sync)) {
 		new_cpu = cpu;
 		goto out;
@@ -1447,6 +1455,7 @@ static int select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flag
 		if (sd_flag & SD_BALANCE_WAKE)
 			load_idx = sd->wake_idx;
 
+		smp_read_barrier_depends();
 		group = find_idlest_group(sd, p, cpu, load_idx);
 		if (!group) {
 			sd = sd->child;


