Return-Path: <linux-kernel-owner+w=401wt.eu-S1760835AbZFOOID@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760835AbZFOOID (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 10:08:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760541AbZFOOHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 10:07:36 -0400
Received: from www.tglx.de ([62.245.132.106]:50217 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759733AbZFOOHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 10:07:32 -0400
Date: Mon, 15 Jun 2009 16:06:54 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] timers: migration for power saving
Message-ID: <alpine.LFD.2.00.0906151456000.2800@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-for-linus-migration git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-for-linus-migration

The migration support for power saving touches a few timer unrelated
files to mark timers which are not allowed to be migrated. Acked by
the relevant maintainers.

Thanks,

	tglx

------------------>
Arun R Bharadwaj (4):
      timers: Framework for identifying pinned timers
      timers: Identifying the existing pinned timers
      timers: /proc/sys sysctl hook to enable timer migration
      timers: Logic to move non pinned timers

Jon Hunter (1):
      timers: allow deferrable timers for intervals tv2-tv5 to be deferred


 arch/x86/kernel/apic/x2apic_uv_x.c |    2 +-
 include/linux/clockchips.h         |    9 +++++
 include/linux/hrtimer.h            |    7 +++-
 include/linux/sched.h              |   13 ++++++++
 include/linux/timer.h              |    3 ++
 kernel/hrtimer.c                   |   58 ++++++++++++++++++++++++++++++++---
 kernel/sched.c                     |   11 +++++-
 kernel/sysctl.c                    |    8 +++++
 kernel/time/clockevents.c          |   12 +++++++
 kernel/time/tick-sched.c           |    7 ++--
 kernel/timer.c                     |   51 +++++++++++++++++++++++++++----
 kernel/trace/trace_sysprof.c       |    3 +-
 12 files changed, 163 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 2bda693..a9cad1b 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -463,7 +463,7 @@ static void uv_heartbeat(unsigned long ignored)
 	uv_set_scir_bits(bits);
 
 	/* enable next timer period */
-	mod_timer(timer, jiffies + SCIR_CPU_HB_INTERVAL);
+	mod_timer_pinned(timer, jiffies + SCIR_CPU_HB_INTERVAL);
 }
 
 static void __cpuinit uv_heartbeat_enable(int cpu)
diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
index 3a1dbba..20a100f 100644
--- a/include/linux/clockchips.h
+++ b/include/linux/clockchips.h
@@ -143,3 +143,12 @@ extern void clockevents_notify(unsigned long reason, void *arg);
 #endif
 
 #endif
+
+#ifdef CONFIG_GENERIC_CLOCKEVENTS
+extern ktime_t clockevents_get_next_event(int cpu);
+#else
+static inline ktime_t clockevents_get_next_event(int cpu)
+{
+	return (ktime_t) { .tv64 = KTIME_MAX };
+}
+#endif
diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 0d2f7c8..7400900 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -30,8 +30,11 @@ struct hrtimer_cpu_base;
  * Mode arguments of xxx_hrtimer functions:
  */
 enum hrtimer_mode {
-	HRTIMER_MODE_ABS,	/* Time value is absolute */
-	HRTIMER_MODE_REL,	/* Time value is relative to now */
+	HRTIMER_MODE_ABS = 0x0,		/* Time value is absolute */
+	HRTIMER_MODE_REL = 0x1,		/* Time value is relative to now */
+	HRTIMER_MODE_PINNED = 0x02,	/* Timer is bound to CPU */
+	HRTIMER_MODE_ABS_PINNED = 0x02,
+	HRTIMER_MODE_REL_PINNED = 0x03,
 };
 
 /*
diff --git a/include/linux/sched.h b/include/linux/sched.h
index b4c38bc..311dec1 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -257,6 +257,7 @@ extern void task_rq_unlock_wait(struct task_struct *p);
 extern cpumask_var_t nohz_cpu_mask;
 #if defined(CONFIG_SMP) && defined(CONFIG_NO_HZ)
 extern int select_nohz_load_balancer(int cpu);
+extern int get_nohz_load_balancer(void);
 #else
 static inline int select_nohz_load_balancer(int cpu)
 {
@@ -1766,11 +1767,23 @@ extern unsigned int sysctl_sched_child_runs_first;
 extern unsigned int sysctl_sched_features;
 extern unsigned int sysctl_sched_migration_cost;
 extern unsigned int sysctl_sched_nr_migrate;
+extern unsigned int sysctl_timer_migration;
 
 int sched_nr_latency_handler(struct ctl_table *table, int write,
 		struct file *file, void __user *buffer, size_t *length,
 		loff_t *ppos);
 #endif
+#ifdef CONFIG_SCHED_DEBUG
+static inline unsigned int get_sysctl_timer_migration(void)
+{
+	return sysctl_timer_migration;
+}
+#else
+static inline unsigned int get_sysctl_timer_migration(void)
+{
+	return 1;
+}
+#endif
 extern unsigned int sysctl_sched_rt_period;
 extern int sysctl_sched_rt_runtime;
 
diff --git a/include/linux/timer.h b/include/linux/timer.h
index 6cdb6f3..ccf882e 100644
--- a/include/linux/timer.h
+++ b/include/linux/timer.h
@@ -163,7 +163,10 @@ extern void add_timer_on(struct timer_list *timer, int cpu);
 extern int del_timer(struct timer_list * timer);
 extern int mod_timer(struct timer_list *timer, unsigned long expires);
 extern int mod_timer_pending(struct timer_list *timer, unsigned long expires);
+extern int mod_timer_pinned(struct timer_list *timer, unsigned long expires);
 
+#define TIMER_NOT_PINNED	0
+#define TIMER_PINNED		1
 /*
  * The jiffies value which is added to now, when there is no timer
  * in the timer wheel:
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index cb8a15c..b675a67 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -43,6 +43,8 @@
 #include <linux/seq_file.h>
 #include <linux/err.h>
 #include <linux/debugobjects.h>
+#include <linux/sched.h>
+#include <linux/timer.h>
 
 #include <asm/uaccess.h>
 
@@ -193,12 +195,24 @@ struct hrtimer_clock_base *lock_hrtimer_base(const struct hrtimer *timer,
  * Switch the timer base to the current CPU when possible.
  */
 static inline struct hrtimer_clock_base *
-switch_hrtimer_base(struct hrtimer *timer, struct hrtimer_clock_base *base)
+switch_hrtimer_base(struct hrtimer *timer, struct hrtimer_clock_base *base,
+		    int pinned)
 {
 	struct hrtimer_clock_base *new_base;
 	struct hrtimer_cpu_base *new_cpu_base;
+	int cpu, preferred_cpu = -1;
+
+	cpu = smp_processor_id();
+#if defined(CONFIG_NO_HZ) && defined(CONFIG_SMP)
+	if (!pinned && get_sysctl_timer_migration() && idle_cpu(cpu)) {
+		preferred_cpu = get_nohz_load_balancer();
+		if (preferred_cpu >= 0)
+			cpu = preferred_cpu;
+	}
+#endif
 
-	new_cpu_base = &__get_cpu_var(hrtimer_bases);
+again:
+	new_cpu_base = &per_cpu(hrtimer_bases, cpu);
 	new_base = &new_cpu_base->clock_base[base->index];
 
 	if (base != new_base) {
@@ -218,6 +232,40 @@ switch_hrtimer_base(struct hrtimer *timer, struct hrtimer_clock_base *base)
 		timer->base = NULL;
 		spin_unlock(&base->cpu_base->lock);
 		spin_lock(&new_base->cpu_base->lock);
+
+		/* Optimized away for NOHZ=n SMP=n */
+		if (cpu == preferred_cpu) {
+			/* Calculate clock monotonic expiry time */
+#ifdef CONFIG_HIGH_RES_TIMERS
+			ktime_t expires = ktime_sub(hrtimer_get_expires(timer),
+							new_base->offset);
+#else
+			ktime_t expires = hrtimer_get_expires(timer);
+#endif
+
+			/*
+			 * Get the next event on target cpu from the
+			 * clock events layer.
+			 * This covers the highres=off nohz=on case as well.
+			 */
+			ktime_t next = clockevents_get_next_event(cpu);
+
+			ktime_t delta = ktime_sub(expires, next);
+
+			/*
+			 * We do not migrate the timer when it is expiring
+			 * before the next event on the target cpu because
+			 * we cannot reprogram the target cpu hardware and
+			 * we would cause it to fire late.
+			 */
+			if (delta.tv64 < 0) {
+				cpu = smp_processor_id();
+				spin_unlock(&new_base->cpu_base->lock);
+				spin_lock(&base->cpu_base->lock);
+				timer->base = base;
+				goto again;
+			}
+		}
 		timer->base = new_base;
 	}
 	return new_base;
@@ -235,7 +283,7 @@ lock_hrtimer_base(const struct hrtimer *timer, unsigned long *flags)
 	return base;
 }
 
-# define switch_hrtimer_base(t, b)	(b)
+# define switch_hrtimer_base(t, b, p)	(b)
 
 #endif	/* !CONFIG_SMP */
 
@@ -907,9 +955,9 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 	ret = remove_hrtimer(timer, base);
 
 	/* Switch the timer base, if necessary: */
-	new_base = switch_hrtimer_base(timer, base);
+	new_base = switch_hrtimer_base(timer, base, mode & HRTIMER_MODE_PINNED);
 
-	if (mode == HRTIMER_MODE_REL) {
+	if (mode & HRTIMER_MODE_REL) {
 		tim = ktime_add_safe(tim, new_base->get_time());
 		/*
 		 * CONFIG_TIME_LOW_RES is a temporary way for architectures
diff --git a/kernel/sched.c b/kernel/sched.c
index b902e58..9fe3774 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -244,7 +244,7 @@ static void start_rt_bandwidth(struct rt_bandwidth *rt_b)
 		hard = hrtimer_get_expires(&rt_b->rt_period_timer);
 		delta = ktime_to_ns(ktime_sub(hard, soft));
 		__hrtimer_start_range_ns(&rt_b->rt_period_timer, soft, delta,
-				HRTIMER_MODE_ABS, 0);
+				HRTIMER_MODE_ABS_PINNED, 0);
 	}
 	spin_unlock(&rt_b->rt_runtime_lock);
 }
@@ -1154,7 +1154,7 @@ static __init void init_hrtick(void)
 static void hrtick_start(struct rq *rq, u64 delay)
 {
 	__hrtimer_start_range_ns(&rq->hrtick_timer, ns_to_ktime(delay), 0,
-			HRTIMER_MODE_REL, 0);
+			HRTIMER_MODE_REL_PINNED, 0);
 }
 
 static inline void init_hrtick(void)
@@ -4244,6 +4244,11 @@ static struct {
 	.load_balancer = ATOMIC_INIT(-1),
 };
 
+int get_nohz_load_balancer(void)
+{
+	return atomic_read(&nohz.load_balancer);
+}
+
 /*
  * This routine will try to nominate the ilb (idle load balancing)
  * owner among the cpus whose ticks are stopped. ilb owner will do the idle
@@ -8731,6 +8736,8 @@ void __init sched_init_smp(void)
 }
 #endif /* CONFIG_SMP */
 
+const_debug unsigned int sysctl_timer_migration = 1;
+
 int in_sched_functions(unsigned long addr)
 {
 	return in_lock_functions(addr) ||
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index e3d2c7d..b3ce581 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -324,6 +324,14 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
 	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "timer_migration",
+		.data		= &sysctl_timer_migration,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
 #endif
 	{
 		.ctl_name	= CTL_UNNUMBERED,
diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index d13be21..ab20ded 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -18,6 +18,7 @@
 #include <linux/notifier.h>
 #include <linux/smp.h>
 #include <linux/sysdev.h>
+#include <linux/tick.h>
 
 /* The registered clock event devices */
 static LIST_HEAD(clockevent_devices);
@@ -251,4 +252,15 @@ void clockevents_notify(unsigned long reason, void *arg)
 	spin_unlock(&clockevents_lock);
 }
 EXPORT_SYMBOL_GPL(clockevents_notify);
+
+ktime_t clockevents_get_next_event(int cpu)
+{
+	struct tick_device *td;
+	struct clock_event_device *dev;
+
+	td = &per_cpu(tick_cpu_device, cpu);
+	dev = td->evtdev;
+
+	return dev->next_event;
+}
 #endif
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index d3f1ef4..2aff39c 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -349,7 +349,7 @@ void tick_nohz_stop_sched_tick(int inidle)
 
 		if (ts->nohz_mode == NOHZ_MODE_HIGHRES) {
 			hrtimer_start(&ts->sched_timer, expires,
-				      HRTIMER_MODE_ABS);
+				      HRTIMER_MODE_ABS_PINNED);
 			/* Check, if the timer was already in the past */
 			if (hrtimer_active(&ts->sched_timer))
 				goto out;
@@ -395,7 +395,7 @@ static void tick_nohz_restart(struct tick_sched *ts, ktime_t now)
 
 		if (ts->nohz_mode == NOHZ_MODE_HIGHRES) {
 			hrtimer_start_expires(&ts->sched_timer,
-				      HRTIMER_MODE_ABS);
+					      HRTIMER_MODE_ABS_PINNED);
 			/* Check, if the timer was already in the past */
 			if (hrtimer_active(&ts->sched_timer))
 				break;
@@ -698,7 +698,8 @@ void tick_setup_sched_timer(void)
 
 	for (;;) {
 		hrtimer_forward(&ts->sched_timer, now, tick_period);
-		hrtimer_start_expires(&ts->sched_timer, HRTIMER_MODE_ABS);
+		hrtimer_start_expires(&ts->sched_timer,
+				      HRTIMER_MODE_ABS_PINNED);
 		/* Check, if the timer was already in the past */
 		if (hrtimer_active(&ts->sched_timer))
 			break;
diff --git a/kernel/timer.c b/kernel/timer.c
index cffffad..3f841db 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -37,6 +37,7 @@
 #include <linux/delay.h>
 #include <linux/tick.h>
 #include <linux/kallsyms.h>
+#include <linux/sched.h>
 
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
@@ -604,13 +605,12 @@ static struct tvec_base *lock_timer_base(struct timer_list *timer,
 }
 
 static inline int
-__mod_timer(struct timer_list *timer, unsigned long expires, bool pending_only)
+__mod_timer(struct timer_list *timer, unsigned long expires,
+						bool pending_only, int pinned)
 {
 	struct tvec_base *base, *new_base;
 	unsigned long flags;
-	int ret;
-
-	ret = 0;
+	int ret = 0 , cpu;
 
 	timer_stats_timer_set_start_info(timer);
 	BUG_ON(!timer->function);
@@ -629,6 +629,18 @@ __mod_timer(struct timer_list *timer, unsigned long expires, bool pending_only)
 
 	new_base = __get_cpu_var(tvec_bases);
 
+	cpu = smp_processor_id();
+
+#if defined(CONFIG_NO_HZ) && defined(CONFIG_SMP)
+	if (!pinned && get_sysctl_timer_migration() && idle_cpu(cpu)) {
+		int preferred_cpu = get_nohz_load_balancer();
+
+		if (preferred_cpu >= 0)
+			cpu = preferred_cpu;
+	}
+#endif
+	new_base = per_cpu(tvec_bases, cpu);
+
 	if (base != new_base) {
 		/*
 		 * We are trying to schedule the timer on the local CPU.
@@ -668,7 +680,7 @@ out_unlock:
  */
 int mod_timer_pending(struct timer_list *timer, unsigned long expires)
 {
-	return __mod_timer(timer, expires, true);
+	return __mod_timer(timer, expires, true, TIMER_NOT_PINNED);
 }
 EXPORT_SYMBOL(mod_timer_pending);
 
@@ -702,11 +714,33 @@ int mod_timer(struct timer_list *timer, unsigned long expires)
 	if (timer->expires == expires && timer_pending(timer))
 		return 1;
 
-	return __mod_timer(timer, expires, false);
+	return __mod_timer(timer, expires, false, TIMER_NOT_PINNED);
 }
 EXPORT_SYMBOL(mod_timer);
 
 /**
+ * mod_timer_pinned - modify a timer's timeout
+ * @timer: the timer to be modified
+ * @expires: new timeout in jiffies
+ *
+ * mod_timer_pinned() is a way to update the expire field of an
+ * active timer (if the timer is inactive it will be activated)
+ * and not allow the timer to be migrated to a different CPU.
+ *
+ * mod_timer_pinned(timer, expires) is equivalent to:
+ *
+ *     del_timer(timer); timer->expires = expires; add_timer(timer);
+ */
+int mod_timer_pinned(struct timer_list *timer, unsigned long expires)
+{
+	if (timer->expires == expires && timer_pending(timer))
+		return 1;
+
+	return __mod_timer(timer, expires, false, TIMER_PINNED);
+}
+EXPORT_SYMBOL(mod_timer_pinned);
+
+/**
  * add_timer - start a timer
  * @timer: the timer to be added
  *
@@ -1015,6 +1049,9 @@ cascade:
 		index = slot = timer_jiffies & TVN_MASK;
 		do {
 			list_for_each_entry(nte, varp->vec + slot, entry) {
+				if (tbase_get_deferrable(nte->base))
+					continue;
+
 				found = 1;
 				if (time_before(nte->expires, expires))
 					expires = nte->expires;
@@ -1353,7 +1390,7 @@ signed long __sched schedule_timeout(signed long timeout)
 	expire = timeout + jiffies;
 
 	setup_timer_on_stack(&timer, process_timeout, (unsigned long)current);
-	__mod_timer(&timer, expire, false);
+	__mod_timer(&timer, expire, false, TIMER_NOT_PINNED);
 	schedule();
 	del_singleshot_timer_sync(&timer);
 
diff --git a/kernel/trace/trace_sysprof.c b/kernel/trace/trace_sysprof.c
index 91fd19c..d180554 100644
--- a/kernel/trace/trace_sysprof.c
+++ b/kernel/trace/trace_sysprof.c
@@ -203,7 +203,8 @@ static void start_stack_timer(void *unused)
 	hrtimer_init(hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	hrtimer->function = stack_trace_timer_fn;
 
-	hrtimer_start(hrtimer, ns_to_ktime(sample_period), HRTIMER_MODE_REL);
+	hrtimer_start(hrtimer, ns_to_ktime(sample_period),
+		      HRTIMER_MODE_REL_PINNED);
 }
 
 static void start_stack_timers(void)
