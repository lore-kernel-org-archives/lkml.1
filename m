Return-Path: <linux-kernel-owner+w=401wt.eu-S1755040AbZJNGEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040AbZJNGEh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 02:04:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752422AbZJNGEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 02:04:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:58694 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750990AbZJNGDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 02:03:35 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, mingo@redhat.com, tglx@linutronix.de,
       akpm@linux-foundation.org, rostedt@goodmis.org, hpa@zytor.com,
       cebbert@redhat.com
Cc: Tejun Heo <tj@kernel.org>, Nick Piggin <npiggin@suse.de>
Subject: [PATCH 04/16] percpu: make percpu symbols under kernel/ and mm/ unique
Date: Wed, 14 Oct 2009 15:01:53 +0900
Message-Id: <1255500125-3210-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1255500125-3210-1-git-send-email-tj@kernel.org>
References: <1255500125-3210-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 14 Oct 2009 06:02:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates percpu related symbols under kernel/ and mm/ such
that percpu symbols are unique and don't clash with local symbols.
This serves two purposes of decreasing the possibility of global
percpu symbol collision and allowing dropping per_cpu__ prefix from
percpu symbols.

* kernel/lockdep.c: s/lock_stats/cpu_lock_stats/

* kernel/sched.c: s/init_rq_rt/init_rt_rq_var/	(any better idea?)
  		  s/sched_group_cpus/sched_groups/

* kernel/softirq.c: s/ksoftirqd/run_ksoftirqd/a

* kernel/softlockup.c: s/(*)_timestamp/softlockup_\1_ts/
  		       s/watchdog_task/softlockup_watchdog/
		       s/timestamp/ts/ for local variables

* kernel/time/timer_stats: s/lookup_lock/tstats_lookup_lock/

* mm/slab.c: s/reap_work/slab_reap_work/
  	     s/reap_node/slab_reap_node/

* mm/vmstat.c: local variable changed to avoid collision with vmstat_work

Partly based on Rusty Russell's "alloc_percpu: rename percpu vars
which cause name clashes" patch.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: (slab/vmstat) Christoph Lameter <cl@linux-foundation.org>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>
---
 kernel/lockdep.c          |   11 +++++----
 kernel/sched.c            |    8 +++---
 kernel/softirq.c          |    4 +-
 kernel/softlockup.c       |   54 ++++++++++++++++++++++----------------------
 kernel/time/timer_stats.c |   11 +++++----
 mm/slab.c                 |   18 +++++++-------
 mm/vmstat.c               |    7 ++---
 7 files changed, 57 insertions(+), 56 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 3815ac1..8631320 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -140,7 +140,8 @@ static inline struct lock_class *hlock_class(struct held_lock *hlock)
 }
 
 #ifdef CONFIG_LOCK_STAT
-static DEFINE_PER_CPU(struct lock_class_stats[MAX_LOCKDEP_KEYS], lock_stats);
+static DEFINE_PER_CPU(struct lock_class_stats[MAX_LOCKDEP_KEYS],
+		      cpu_lock_stats);
 
 static int lock_point(unsigned long points[], unsigned long ip)
 {
@@ -186,7 +187,7 @@ struct lock_class_stats lock_stats(struct lock_class *class)
 	memset(&stats, 0, sizeof(struct lock_class_stats));
 	for_each_possible_cpu(cpu) {
 		struct lock_class_stats *pcs =
-			&per_cpu(lock_stats, cpu)[class - lock_classes];
+			&per_cpu(cpu_lock_stats, cpu)[class - lock_classes];
 
 		for (i = 0; i < ARRAY_SIZE(stats.contention_point); i++)
 			stats.contention_point[i] += pcs->contention_point[i];
@@ -213,7 +214,7 @@ void clear_lock_stats(struct lock_class *class)
 
 	for_each_possible_cpu(cpu) {
 		struct lock_class_stats *cpu_stats =
-			&per_cpu(lock_stats, cpu)[class - lock_classes];
+			&per_cpu(cpu_lock_stats, cpu)[class - lock_classes];
 
 		memset(cpu_stats, 0, sizeof(struct lock_class_stats));
 	}
@@ -223,12 +224,12 @@ void clear_lock_stats(struct lock_class *class)
 
 static struct lock_class_stats *get_lock_stats(struct lock_class *class)
 {
-	return &get_cpu_var(lock_stats)[class - lock_classes];
+	return &get_cpu_var(cpu_lock_stats)[class - lock_classes];
 }
 
 static void put_lock_stats(struct lock_class_stats *stats)
 {
-	put_cpu_var(lock_stats);
+	put_cpu_var(cpu_lock_stats);
 }
 
 static void lock_release_holdtime(struct held_lock *hlock)
diff --git a/kernel/sched.c b/kernel/sched.c
index 1535f38..854ab41 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -298,7 +298,7 @@ static DEFINE_PER_CPU_SHARED_ALIGNED(struct cfs_rq, init_tg_cfs_rq);
 
 #ifdef CONFIG_RT_GROUP_SCHED
 static DEFINE_PER_CPU(struct sched_rt_entity, init_sched_rt_entity);
-static DEFINE_PER_CPU_SHARED_ALIGNED(struct rt_rq, init_rt_rq);
+static DEFINE_PER_CPU_SHARED_ALIGNED(struct rt_rq, init_rt_rq_var);
 #endif /* CONFIG_RT_GROUP_SCHED */
 #else /* !CONFIG_USER_SCHED */
 #define root_task_group init_task_group
@@ -8199,14 +8199,14 @@ enum s_alloc {
  */
 #ifdef CONFIG_SCHED_SMT
 static DEFINE_PER_CPU(struct static_sched_domain, cpu_domains);
-static DEFINE_PER_CPU(struct static_sched_group, sched_group_cpus);
+static DEFINE_PER_CPU(struct static_sched_group, sched_groups);
 
 static int
 cpu_to_cpu_group(int cpu, const struct cpumask *cpu_map,
 		 struct sched_group **sg, struct cpumask *unused)
 {
 	if (sg)
-		*sg = &per_cpu(sched_group_cpus, cpu).sg;
+		*sg = &per_cpu(sched_groups, cpu).sg;
 	return cpu;
 }
 #endif /* CONFIG_SCHED_SMT */
@@ -9470,7 +9470,7 @@ void __init sched_init(void)
 #elif defined CONFIG_USER_SCHED
 		init_tg_rt_entry(&root_task_group, &rq->rt, NULL, i, 0, NULL);
 		init_tg_rt_entry(&init_task_group,
-				&per_cpu(init_rt_rq, i),
+				&per_cpu(init_rt_rq_var, i),
 				&per_cpu(init_sched_rt_entity, i), i, 1,
 				root_task_group.rt_se[i]);
 #endif
diff --git a/kernel/softirq.c b/kernel/softirq.c
index f8749e5..0740dfd 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -697,7 +697,7 @@ void __init softirq_init(void)
 	open_softirq(HI_SOFTIRQ, tasklet_hi_action);
 }
 
-static int ksoftirqd(void * __bind_cpu)
+static int run_ksoftirqd(void * __bind_cpu)
 {
 	set_current_state(TASK_INTERRUPTIBLE);
 
@@ -810,7 +810,7 @@ static int __cpuinit cpu_callback(struct notifier_block *nfb,
 	switch (action) {
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
-		p = kthread_create(ksoftirqd, hcpu, "ksoftirqd/%d", hotcpu);
+		p = kthread_create(run_ksoftirqd, hcpu, "ksoftirqd/%d", hotcpu);
 		if (IS_ERR(p)) {
 			printk("ksoftirqd for %i failed\n", hotcpu);
 			return NOTIFY_BAD;
diff --git a/kernel/softlockup.c b/kernel/softlockup.c
index 81324d1..d225790 100644
--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@ -22,9 +22,9 @@
 
 static DEFINE_SPINLOCK(print_lock);
 
-static DEFINE_PER_CPU(unsigned long, touch_timestamp);
-static DEFINE_PER_CPU(unsigned long, print_timestamp);
-static DEFINE_PER_CPU(struct task_struct *, watchdog_task);
+static DEFINE_PER_CPU(unsigned long, softlockup_touch_ts); /* touch timestamp */
+static DEFINE_PER_CPU(unsigned long, softlockup_print_ts); /* print timestamp */
+static DEFINE_PER_CPU(struct task_struct *, softlockup_watchdog);
 
 static int __read_mostly did_panic;
 int __read_mostly softlockup_thresh = 60;
@@ -70,12 +70,12 @@ static void __touch_softlockup_watchdog(void)
 {
 	int this_cpu = raw_smp_processor_id();
 
-	__raw_get_cpu_var(touch_timestamp) = get_timestamp(this_cpu);
+	__raw_get_cpu_var(softlockup_touch_ts) = get_timestamp(this_cpu);
 }
 
 void touch_softlockup_watchdog(void)
 {
-	__raw_get_cpu_var(touch_timestamp) = 0;
+	__raw_get_cpu_var(softlockup_touch_ts) = 0;
 }
 EXPORT_SYMBOL(touch_softlockup_watchdog);
 
@@ -85,7 +85,7 @@ void touch_all_softlockup_watchdogs(void)
 
 	/* Cause each CPU to re-update its timestamp rather than complain */
 	for_each_online_cpu(cpu)
-		per_cpu(touch_timestamp, cpu) = 0;
+		per_cpu(softlockup_touch_ts, cpu) = 0;
 }
 EXPORT_SYMBOL(touch_all_softlockup_watchdogs);
 
@@ -104,28 +104,28 @@ int proc_dosoftlockup_thresh(struct ctl_table *table, int write,
 void softlockup_tick(void)
 {
 	int this_cpu = smp_processor_id();
-	unsigned long touch_timestamp = per_cpu(touch_timestamp, this_cpu);
-	unsigned long print_timestamp;
+	unsigned long touch_ts = per_cpu(softlockup_touch_ts, this_cpu);
+	unsigned long print_ts;
 	struct pt_regs *regs = get_irq_regs();
 	unsigned long now;
 
 	/* Is detection switched off? */
-	if (!per_cpu(watchdog_task, this_cpu) || softlockup_thresh <= 0) {
+	if (!per_cpu(softlockup_watchdog, this_cpu) || softlockup_thresh <= 0) {
 		/* Be sure we don't false trigger if switched back on */
-		if (touch_timestamp)
-			per_cpu(touch_timestamp, this_cpu) = 0;
+		if (touch_ts)
+			per_cpu(softlockup_touch_ts, this_cpu) = 0;
 		return;
 	}
 
-	if (touch_timestamp == 0) {
+	if (touch_ts == 0) {
 		__touch_softlockup_watchdog();
 		return;
 	}
 
-	print_timestamp = per_cpu(print_timestamp, this_cpu);
+	print_ts = per_cpu(softlockup_print_ts, this_cpu);
 
 	/* report at most once a second */
-	if (print_timestamp == touch_timestamp || did_panic)
+	if (print_ts == touch_ts || did_panic)
 		return;
 
 	/* do not print during early bootup: */
@@ -140,18 +140,18 @@ void softlockup_tick(void)
 	 * Wake up the high-prio watchdog task twice per
 	 * threshold timespan.
 	 */
-	if (now > touch_timestamp + softlockup_thresh/2)
-		wake_up_process(per_cpu(watchdog_task, this_cpu));
+	if (now > touch_ts + softlockup_thresh/2)
+		wake_up_process(per_cpu(softlockup_watchdog, this_cpu));
 
 	/* Warn about unreasonable delays: */
-	if (now <= (touch_timestamp + softlockup_thresh))
+	if (now <= (touch_ts + softlockup_thresh))
 		return;
 
-	per_cpu(print_timestamp, this_cpu) = touch_timestamp;
+	per_cpu(softlockup_print_ts, this_cpu) = touch_ts;
 
 	spin_lock(&print_lock);
 	printk(KERN_ERR "BUG: soft lockup - CPU#%d stuck for %lus! [%s:%d]\n",
-			this_cpu, now - touch_timestamp,
+			this_cpu, now - touch_ts,
 			current->comm, task_pid_nr(current));
 	print_modules();
 	print_irqtrace_events(current);
@@ -209,32 +209,32 @@ cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 	switch (action) {
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
-		BUG_ON(per_cpu(watchdog_task, hotcpu));
+		BUG_ON(per_cpu(softlockup_watchdog, hotcpu));
 		p = kthread_create(watchdog, hcpu, "watchdog/%d", hotcpu);
 		if (IS_ERR(p)) {
 			printk(KERN_ERR "watchdog for %i failed\n", hotcpu);
 			return NOTIFY_BAD;
 		}
-		per_cpu(touch_timestamp, hotcpu) = 0;
-		per_cpu(watchdog_task, hotcpu) = p;
+		per_cpu(softlockup_touch_ts, hotcpu) = 0;
+		per_cpu(softlockup_watchdog, hotcpu) = p;
 		kthread_bind(p, hotcpu);
 		break;
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
-		wake_up_process(per_cpu(watchdog_task, hotcpu));
+		wake_up_process(per_cpu(softlockup_watchdog, hotcpu));
 		break;
 #ifdef CONFIG_HOTPLUG_CPU
 	case CPU_UP_CANCELED:
 	case CPU_UP_CANCELED_FROZEN:
-		if (!per_cpu(watchdog_task, hotcpu))
+		if (!per_cpu(softlockup_watchdog, hotcpu))
 			break;
 		/* Unbind so it can run.  Fall thru. */
-		kthread_bind(per_cpu(watchdog_task, hotcpu),
+		kthread_bind(per_cpu(softlockup_watchdog, hotcpu),
 			     cpumask_any(cpu_online_mask));
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
-		p = per_cpu(watchdog_task, hotcpu);
-		per_cpu(watchdog_task, hotcpu) = NULL;
+		p = per_cpu(softlockup_watchdog, hotcpu);
+		per_cpu(softlockup_watchdog, hotcpu) = NULL;
 		kthread_stop(p);
 		break;
 #endif /* CONFIG_HOTPLUG_CPU */
diff --git a/kernel/time/timer_stats.c b/kernel/time/timer_stats.c
index ee5681f..63b117e 100644
--- a/kernel/time/timer_stats.c
+++ b/kernel/time/timer_stats.c
@@ -86,7 +86,7 @@ static DEFINE_SPINLOCK(table_lock);
 /*
  * Per-CPU lookup locks for fast hash lookup:
  */
-static DEFINE_PER_CPU(spinlock_t, lookup_lock);
+static DEFINE_PER_CPU(spinlock_t, tstats_lookup_lock);
 
 /*
  * Mutex to serialize state changes with show-stats activities:
@@ -245,7 +245,7 @@ void timer_stats_update_stats(void *timer, pid_t pid, void *startf,
 	if (likely(!timer_stats_active))
 		return;
 
-	lock = &per_cpu(lookup_lock, raw_smp_processor_id());
+	lock = &per_cpu(tstats_lookup_lock, raw_smp_processor_id());
 
 	input.timer = timer;
 	input.start_func = startf;
@@ -348,9 +348,10 @@ static void sync_access(void)
 	int cpu;
 
 	for_each_online_cpu(cpu) {
-		spin_lock_irqsave(&per_cpu(lookup_lock, cpu), flags);
+		spinlock_t *lock = &per_cpu(tstats_lookup_lock, cpu);
+		spin_lock_irqsave(lock, flags);
 		/* nothing */
-		spin_unlock_irqrestore(&per_cpu(lookup_lock, cpu), flags);
+		spin_unlock_irqrestore(lock, flags);
 	}
 }
 
@@ -408,7 +409,7 @@ void __init init_timer_stats(void)
 	int cpu;
 
 	for_each_possible_cpu(cpu)
-		spin_lock_init(&per_cpu(lookup_lock, cpu));
+		spin_lock_init(&per_cpu(tstats_lookup_lock, cpu));
 }
 
 static int __init init_tstats_procfs(void)
diff --git a/mm/slab.c b/mm/slab.c
index 7dfa481..211b174 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -685,7 +685,7 @@ int slab_is_available(void)
 	return g_cpucache_up >= EARLY;
 }
 
-static DEFINE_PER_CPU(struct delayed_work, reap_work);
+static DEFINE_PER_CPU(struct delayed_work, slab_reap_work);
 
 static inline struct array_cache *cpu_cache_get(struct kmem_cache *cachep)
 {
@@ -826,7 +826,7 @@ __setup("noaliencache", noaliencache_setup);
  * objects freed on different nodes from which they were allocated) and the
  * flushing of remote pcps by calling drain_node_pages.
  */
-static DEFINE_PER_CPU(unsigned long, reap_node);
+static DEFINE_PER_CPU(unsigned long, slab_reap_node);
 
 static void init_reap_node(int cpu)
 {
@@ -836,17 +836,17 @@ static void init_reap_node(int cpu)
 	if (node == MAX_NUMNODES)
 		node = first_node(node_online_map);
 
-	per_cpu(reap_node, cpu) = node;
+	per_cpu(slab_reap_node, cpu) = node;
 }
 
 static void next_reap_node(void)
 {
-	int node = __get_cpu_var(reap_node);
+	int node = __get_cpu_var(slab_reap_node);
 
 	node = next_node(node, node_online_map);
 	if (unlikely(node >= MAX_NUMNODES))
 		node = first_node(node_online_map);
-	__get_cpu_var(reap_node) = node;
+	__get_cpu_var(slab_reap_node) = node;
 }
 
 #else
@@ -863,7 +863,7 @@ static void next_reap_node(void)
  */
 static void __cpuinit start_cpu_timer(int cpu)
 {
-	struct delayed_work *reap_work = &per_cpu(reap_work, cpu);
+	struct delayed_work *reap_work = &per_cpu(slab_reap_work, cpu);
 
 	/*
 	 * When this gets called from do_initcalls via cpucache_init(),
@@ -1027,7 +1027,7 @@ static void __drain_alien_cache(struct kmem_cache *cachep,
  */
 static void reap_alien(struct kmem_cache *cachep, struct kmem_list3 *l3)
 {
-	int node = __get_cpu_var(reap_node);
+	int node = __get_cpu_var(slab_reap_node);
 
 	if (l3->alien) {
 		struct array_cache *ac = l3->alien[node];
@@ -1286,9 +1286,9 @@ static int __cpuinit cpuup_callback(struct notifier_block *nfb,
 		 * anything expensive but will only modify reap_work
 		 * and reschedule the timer.
 		*/
-		cancel_rearming_delayed_work(&per_cpu(reap_work, cpu));
+		cancel_rearming_delayed_work(&per_cpu(slab_reap_work, cpu));
 		/* Now the cache_reaper is guaranteed to be not running. */
-		per_cpu(reap_work, cpu).work.func = NULL;
+		per_cpu(slab_reap_work, cpu).work.func = NULL;
   		break;
   	case CPU_DOWN_FAILED:
   	case CPU_DOWN_FAILED_FROZEN:
diff --git a/mm/vmstat.c b/mm/vmstat.c
index c81321f..dad2327 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -883,11 +883,10 @@ static void vmstat_update(struct work_struct *w)
 
 static void __cpuinit start_cpu_timer(int cpu)
 {
-	struct delayed_work *vmstat_work = &per_cpu(vmstat_work, cpu);
+	struct delayed_work *work = &per_cpu(vmstat_work, cpu);
 
-	INIT_DELAYED_WORK_DEFERRABLE(vmstat_work, vmstat_update);
-	schedule_delayed_work_on(cpu, vmstat_work,
-				 __round_jiffies_relative(HZ, cpu));
+	INIT_DELAYED_WORK_DEFERRABLE(work, vmstat_update);
+	schedule_delayed_work_on(cpu, work, __round_jiffies_relative(HZ, cpu));
 }
 
 /*
-- 
1.6.4.2

