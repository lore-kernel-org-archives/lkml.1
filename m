Return-Path: <linux-kernel-owner+w=401wt.eu-S1755496AbZDPGrE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496AbZDPGrE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 02:47:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752471AbZDPGqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 02:46:52 -0400
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:49798 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbZDPGqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 02:46:51 -0400
Date: Thu, 16 Apr 2009 12:16:41 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: a.p.zijlstra@chello.nl, ego@in.ibm.com, tglx@linutronix.de, mingo@elte.hu,
       andi@firstfloor.org, venkatesh.pallipadi@intel.com,
       vatsa@linux.vnet.ibm.com, arjan@infradead.org,
       svaidy@linux.vnet.ibm.com, Richard Henderson <rth@twiddle.net>,
       Chris Zankel <chris@zankel.net>, Mikael Starvik <starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>,
       Tony Luck <tony.luck@intel.com>, Kyle McMartin <kyle@mcmartin.ca>,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>
Subject: [v6 PATCH 4/4] timers: Logic to move non pinned timers
Message-ID: <20090416064641.GE7510@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
References: <20090416064136.GA7510@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090416064136.GA7510@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arun R Bharadwaj <arun@linux.vnet.ibm.com> [2009-04-16 12:11:36]:

This patch migrates all non pinned timers and hrtimers to the current
idle load balancer, from all the idle CPUs. Timers firing on busy CPUs
are not migrated.

While migrating hrtimers, care should be taken to check if migrating
a hrtimer would result in a latency or not. So we compare the expiry of the
hrtimer with the next timer interrupt on the target cpu and migrate the
hrtimer only if it expires *after* the next interrupt on the target cpu.
So, added a clockevents_get_next_event() helper function to return the
next_event on the target cpu's clock_event_device.

Signed-off-by: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
---
 include/linux/clockchips.h |   11 +++++++++
 include/linux/sched.h      |   12 ++++++++++
 kernel/hrtimer.c           |   50 +++++++++++++++++++++++++++++++++++++++++++--
 kernel/sched.c             |    5 ++++
 kernel/time/clockevents.c  |   14 ++++++++++++
 kernel/timer.c             |   14 +++++++++++-
 6 files changed, 103 insertions(+), 3 deletions(-)

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
+	int ret, preferred_cpu = -1, cpu;
 
 	ret = 0;
 
@@ -627,6 +628,17 @@ __mod_timer(struct timer_list *timer, un
 
 	new_base = __get_cpu_var(tvec_bases);
 
+	cpu = smp_processor_id();
+	if (get_sysctl_timer_migration() && idle_cpu(cpu) && !pinned) {
+#if defined(CONFIG_NO_HZ) && (CONFIG_SMP)
+		preferred_cpu = get_nohz_load_balancer();
+#endif
+		if (preferred_cpu >= 0)
+			cpu = preferred_cpu;
+	}
+
+	new_base = per_cpu(tvec_bases, cpu);
+
 	if (base != new_base) {
 		/*
 		 * We are trying to schedule the timer on the local CPU.
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
 
@@ -198,8 +200,19 @@ switch_hrtimer_base(struct hrtimer *time
 {
 	struct hrtimer_clock_base *new_base;
 	struct hrtimer_cpu_base *new_cpu_base;
+	int cpu, preferred_cpu = -1;
 
-	new_cpu_base = &__get_cpu_var(hrtimer_bases);
+	cpu = smp_processor_id();
+	if (get_sysctl_timer_migration() && !pinned && idle_cpu(cpu)) {
+#if defined(CONFIG_NO_HZ) && (CONFIG_SMP)
+		preferred_cpu = get_nohz_load_balancer();
+#endif
+		if (preferred_cpu >= 0)
+			cpu = preferred_cpu;
+	}
+
+again:
+	new_cpu_base = &per_cpu(hrtimer_bases, cpu);
 	new_base = &new_cpu_base->clock_base[base->index];
 
 	if (base != new_base) {
@@ -219,6 +232,39 @@ switch_hrtimer_base(struct hrtimer *time
 		timer->base = NULL;
 		spin_unlock(&base->cpu_base->lock);
 		spin_lock(&new_base->cpu_base->lock);
+
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
@@ -236,7 +282,7 @@ lock_hrtimer_base(const struct hrtimer *
 	return base;
 }
 
-# define switch_hrtimer_base(t, b)	(b)
+# define switch_hrtimer_base(t, b, p)	(b)
 
 #endif	/* !CONFIG_SMP */
 
Index: linux.trees.git/include/linux/sched.h
===================================================================
--- linux.trees.git.orig/include/linux/sched.h
+++ linux.trees.git/include/linux/sched.h
@@ -258,6 +258,7 @@ extern void task_rq_unlock_wait(struct t
 extern cpumask_var_t nohz_cpu_mask;
 #if defined(CONFIG_SMP) && defined(CONFIG_NO_HZ)
 extern int select_nohz_load_balancer(int cpu);
+extern int get_nohz_load_balancer(void);
 #else
 static inline int select_nohz_load_balancer(int cpu)
 {
@@ -1769,6 +1770,17 @@ int sched_nr_latency_handler(struct ctl_
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
Index: linux.trees.git/kernel/time/clockevents.c
===================================================================
--- linux.trees.git.orig/kernel/time/clockevents.c
+++ linux.trees.git/kernel/time/clockevents.c
@@ -18,6 +18,7 @@
 #include <linux/notifier.h>
 #include <linux/smp.h>
 #include <linux/sysdev.h>
+#include <linux/tick.h>
 
 /* The registered clock event devices */
 static LIST_HEAD(clockevent_devices);
@@ -252,3 +253,16 @@ void clockevents_notify(unsigned long re
 }
 EXPORT_SYMBOL_GPL(clockevents_notify);
 #endif
+
+#ifdef CONFIG_GENERIC_CLOCKEVENTS
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
+#endif
Index: linux.trees.git/include/linux/clockchips.h
===================================================================
--- linux.trees.git.orig/include/linux/clockchips.h
+++ linux.trees.git/include/linux/clockchips.h
@@ -143,3 +143,14 @@ extern void clockevents_notify(unsigned 
 #endif
 
 #endif
+
+#ifdef CONFIG_GENERIC_CLOCKEVENTS
+extern ktime_t clockevents_get_next_event(int cpu);
+#else
+static inline ktime_t clockevents_get_next_event(int cpu)
+{
+	ktime_t ret;
+	ret.tv64 = KTIME_MAX;
+	return ret;
+}
+#endif
