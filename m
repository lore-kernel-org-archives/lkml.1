Return-Path: <linux-kernel-owner+w=401wt.eu-S1763070AbZDALiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763070AbZDALiW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 07:38:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755574AbZDALiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 07:38:12 -0400
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:42235 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757334AbZDALiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 07:38:10 -0400
Date: Wed, 1 Apr 2009 17:07:38 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: a.p.zijlstra@chello.nl, ego@in.ibm.com, tglx@linutronix.de, mingo@elte.hu,
       andi@firstfloor.org, venkatesh.pallipadi@intel.com,
       vatsa@linux.vnet.ibm.com, arjan@infradead.org,
       svaidy@linux.vnet.ibm.com, Arun Bharadwaj <arun@linux.vnet.ibm.com>
Subject: [v4 RFC PATCH 4/4] timers: logic to move non pinned timers
Message-ID: <20090401113738.GE22478@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
References: <20090401113128.GA22478@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090401113128.GA22478@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arun R Bharadwaj <arun@linux.vnet.ibm.com> [2009-04-01 17:01:28]:

This patch migrates all non pinned timers and hrtimers to the current
idle load balancer, from all the idle CPUs. Timers firing on busy CPUs
are not migrated.

While migrating hrtimers, care should be taken to check if migrating
a hrtimer would result in a latency or not. So a hrtimer_check_latency()
has been added to provide this check. This compares the expiry of the
hrtimer with the next timer interrupt on the target cpu and migrates the
hrtimer only if it expires *after* the next interrupt on the target cpu.
Currently get_next_timer_interrupt() helps to get the next timer interrupt
on the current cpu. So added a get_next_timer_interrupt_on() to get the
next timer interrupt on the cpu of choice. Also a few other helper functions
have been added to facilitate this.

Signed-off-by: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
---
 include/linux/hrtimer.h |   19 ++++++++++++++-
 include/linux/sched.h   |   12 +++++++++
 include/linux/timer.h   |    2 -
 kernel/hrtimer.c        |   42 +++++++++++++++++++++++++--------
 kernel/sched.c          |    5 ++++
 kernel/timer.c          |   60 ++++++++++++++++++++++++++++++++++++++++--------
 6 files changed, 119 insertions(+), 21 deletions(-)

Index: linux.trees.git/kernel/timer.c
===================================================================
--- linux.trees.git.orig/kernel/timer.c
+++ linux.trees.git/kernel/timer.c
@@ -37,6 +37,7 @@
 #include <linux/delay.h>
 #include <linux/tick.h>
 #include <linux/kallsyms.h>
+#include <linux/sched.h>
 
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
@@ -606,7 +607,7 @@ __mod_timer(struct timer_list *timer, un
 {
 	struct tvec_base *base, *new_base;
 	unsigned long flags;
-	int ret;
+	int ret, current_cpu, preferred_cpu;
 
 	ret = 0;
 
@@ -627,6 +628,12 @@ __mod_timer(struct timer_list *timer, un
 
 	new_base = __get_cpu_var(tvec_bases);
 
+	current_cpu = smp_processor_id();
+	preferred_cpu = get_nohz_load_balancer();
+	if (get_sysctl_timer_migration() && idle_cpu(current_cpu)
+			&& !pinned && preferred_cpu != -1)
+		new_base = per_cpu(tvec_bases, preferred_cpu);
+
 	if (base != new_base) {
 		/*
 		 * We are trying to schedule the timer on the local CPU.
@@ -635,7 +642,8 @@ __mod_timer(struct timer_list *timer, un
 		 * handler yet has not finished. This also guarantees that
 		 * the timer is serialized wrt itself.
 		 */
-		if (likely(base->running_timer != timer)) {
+		if (likely(base->running_timer != timer) ||
+				get_sysctl_timer_migration()) {
 			/* See the comment in lock_timer_base() */
 			timer_set_base(timer, NULL);
 			spin_unlock(&base->lock);
@@ -1063,10 +1071,9 @@ cascade:
  * Check, if the next hrtimer event is before the next timer wheel
  * event:
  */
-static unsigned long cmp_next_hrtimer_event(unsigned long now,
-					    unsigned long expires)
+static unsigned long __cmp_next_hrtimer_event(unsigned long now,
+			unsigned long expires, ktime_t hr_delta)
 {
-	ktime_t hr_delta = hrtimer_get_next_event();
 	struct timespec tsdelta;
 	unsigned long delta;
 
@@ -1103,24 +1110,59 @@ static unsigned long cmp_next_hrtimer_ev
 	return expires;
 }
 
+static unsigned long cmp_next_hrtimer_event(unsigned long now,
+					unsigned long expires)
+{
+	 ktime_t hr_delta = hrtimer_get_next_event();
+	 return __cmp_next_hrtimer_event(now, expires, hr_delta);
+}
+
+static unsigned long cmp_next_hrtimer_event_on(unsigned long now,
+					unsigned long expires, int cpu)
+{
+	 ktime_t hr_delta = hrtimer_get_next_event_on(cpu);
+	 return __cmp_next_hrtimer_event(now, expires, hr_delta);
+}
+
+unsigned long __get_next_timer_interrupt(unsigned long now, int cpu)
+{
+	struct tvec_base *base = per_cpu(tvec_bases, cpu);
+	unsigned long expires;
+
+	spin_lock(&base->lock);
+	expires = __next_timer_interrupt(base);
+	spin_unlock(&base->lock);
+	return expires;
+}
+
 /**
  * get_next_timer_interrupt - return the jiffy of the next pending timer
  * @now: current time (in jiffies)
  */
 unsigned long get_next_timer_interrupt(unsigned long now)
 {
-	struct tvec_base *base = __get_cpu_var(tvec_bases);
 	unsigned long expires;
+	int cpu = smp_processor_id();
 
-	spin_lock(&base->lock);
-	expires = __next_timer_interrupt(base);
-	spin_unlock(&base->lock);
+	expires = __get_next_timer_interrupt(now, cpu);
 
 	if (time_before_eq(expires, now))
 		return now;
 
 	return cmp_next_hrtimer_event(now, expires);
 }
+
+unsigned long get_next_timer_interrupt_on(unsigned long now, int cpu)
+{
+	unsigned long expires;
+
+	expires = __get_next_timer_interrupt(now, cpu);
+
+	if (time_before_eq(expires, now))
+		return now;
+
+	return cmp_next_hrtimer_event_on(now, expires, cpu);
+}
 #endif
 
 /*
Index: linux.trees.git/kernel/hrtimer.c
===================================================================
--- linux.trees.git.orig/kernel/hrtimer.c
+++ linux.trees.git/kernel/hrtimer.c
@@ -43,6 +43,8 @@
 #include <linux/seq_file.h>
 #include <linux/err.h>
 #include <linux/debugobjects.h>
+#include <linux/sched.h>
+#include <linux/timer.h>
 
 #include <asm/uaccess.h>
 
@@ -198,8 +200,16 @@ switch_hrtimer_base(struct hrtimer *time
 {
 	struct hrtimer_clock_base *new_base;
 	struct hrtimer_cpu_base *new_cpu_base;
+	int current_cpu, preferred_cpu;
+
+	current_cpu = smp_processor_id();
+	preferred_cpu = get_nohz_load_balancer();
+	if (get_sysctl_timer_migration() && !pinned && preferred_cpu != -1 &&
+			check_hrtimer_latency(timer, preferred_cpu))
+		new_cpu_base = &per_cpu(hrtimer_bases, preferred_cpu);
+	else
+		new_cpu_base = &__get_cpu_var(hrtimer_bases);
 
-	new_cpu_base = &__get_cpu_var(hrtimer_bases);
 	new_base = &new_cpu_base->clock_base[base->index];
 
 	if (base != new_base) {
@@ -1056,21 +1066,16 @@ EXPORT_SYMBOL_GPL(hrtimer_get_remaining)
 
 #ifdef CONFIG_NO_HZ
 /**
- * hrtimer_get_next_event - get the time until next expiry event
+ * __hrtimer_get_next_event - get the time until next expiry event
  *
  * Returns the delta to the next expiry event or KTIME_MAX if no timer
  * is pending.
  */
-ktime_t hrtimer_get_next_event(void)
+ktime_t __hrtimer_get_next_event(struct hrtimer_clock_base *base)
 {
-	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
-	struct hrtimer_clock_base *base = cpu_base->clock_base;
 	ktime_t delta, mindelta = { .tv64 = KTIME_MAX };
-	unsigned long flags;
 	int i;
 
-	spin_lock_irqsave(&cpu_base->lock, flags);
-
 	if (!hrtimer_hres_active()) {
 		for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++, base++) {
 			struct hrtimer *timer;
@@ -1086,12 +1091,29 @@ ktime_t hrtimer_get_next_event(void)
 		}
 	}
 
-	spin_unlock_irqrestore(&cpu_base->lock, flags);
-
 	if (mindelta.tv64 < 0)
 		mindelta.tv64 = 0;
 	return mindelta;
 }
+
+ktime_t hrtimer_get_next_event(void)
+{
+	ktime_t mindelta;
+	unsigned long flags;
+	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
+	struct hrtimer_clock_base *base = cpu_base->clock_base;
+	spin_lock_irqsave(&cpu_base->lock, flags);
+	mindelta = __hrtimer_get_next_event(base);
+	spin_unlock_irqrestore(&cpu_base->lock, flags);
+	return mindelta;
+}
+
+ktime_t hrtimer_get_next_event_on(int cpu)
+{
+	struct hrtimer_cpu_base *cpu_base = &per_cpu(hrtimer_bases, cpu);
+	struct hrtimer_clock_base *base = cpu_base->clock_base;
+	return __hrtimer_get_next_event(base);
+}
 #endif
 
 static void __hrtimer_init(struct hrtimer *timer, clockid_t clock_id,
Index: linux.trees.git/include/linux/sched.h
===================================================================
--- linux.trees.git.orig/include/linux/sched.h
+++ linux.trees.git/include/linux/sched.h
@@ -265,6 +265,7 @@ static inline int select_nohz_load_balan
 }
 #endif
 
+extern int get_nohz_load_balancer(void);
 /*
  * Only dump TASK_* tasks. (0 for all tasks)
  */
@@ -1769,6 +1770,17 @@ int sched_nr_latency_handler(struct ctl_
 		struct file *file, void __user *buffer, size_t *length,
 		loff_t *ppos);
 #endif
+#ifdef CONFIG_SCHED_DEBUG
+static inline int get_sysctl_timer_migration(void)
+{
+	return sysctl_timer_migration;
+}
+#else
+static inline int get_sysctl_timer_migration(void)
+{
+	return 1;
+}
+#endif
 extern unsigned int sysctl_sched_rt_period;
 extern int sysctl_sched_rt_runtime;
 
Index: linux.trees.git/kernel/sched.c
===================================================================
--- linux.trees.git.orig/kernel/sched.c
+++ linux.trees.git/kernel/sched.c
@@ -4009,6 +4009,11 @@ static struct {
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
Index: linux.trees.git/include/linux/hrtimer.h
===================================================================
--- linux.trees.git.orig/include/linux/hrtimer.h
+++ linux.trees.git/include/linux/hrtimer.h
@@ -22,7 +22,6 @@
 #include <linux/wait.h>
 #include <linux/percpu.h>
 
-
 struct hrtimer_clock_base;
 struct hrtimer_cpu_base;
 
@@ -376,6 +375,24 @@ extern ktime_t hrtimer_get_remaining(con
 extern int hrtimer_get_res(const clockid_t which_clock, struct timespec *tp);
 
 extern ktime_t hrtimer_get_next_event(void);
+extern ktime_t hrtimer_get_next_event_on(int cpu);
+
+#define TICK_PERIOD_IN_NS	NSEC_PER_SEC / HZ
+/*
+ * Helper function to check before migrating a hrtimer if it expires
+ * before the next timer interrupt on the target cpu.
+ */
+static inline int check_hrtimer_latency(struct hrtimer *timer, int cpu)
+{
+	unsigned long next_hrtimeout, next_jiffies;
+	next_jiffies = get_next_timer_interrupt_on(jiffies, cpu);
+	next_jiffies = next_jiffies * TICK_PERIOD_IN_NS;
+	next_hrtimeout = hrtimer_get_expires_ns(timer);
+
+	if (next_hrtimeout > next_jiffies)
+		return 1;
+	return 0;
+}
 
 /*
  * A timer is active, when it is enqueued into the rbtree or the callback
Index: linux.trees.git/include/linux/timer.h
===================================================================
--- linux.trees.git.orig/include/linux/timer.h
+++ linux.trees.git/include/linux/timer.h
@@ -184,7 +184,7 @@ extern unsigned long next_timer_interrup
  * jiffie.
  */
 extern unsigned long get_next_timer_interrupt(unsigned long now);
-
+extern unsigned long get_next_timer_interrupt_on(unsigned long now, int cpu);
 /*
  * Timer-statistics info:
  */
