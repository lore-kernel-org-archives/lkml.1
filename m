Return-Path: <linux-kernel-owner+w=401wt.eu-S1752817AbZDGINO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817AbZDGINO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 04:13:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752898AbZDGIM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 04:12:57 -0400
Received: from e28smtp09.in.ibm.com ([59.145.155.9]:34448 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486AbZDGIMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 04:12:54 -0400
Date: Tue, 7 Apr 2009 13:41:57 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       a.p.zijlstra@chello.nl, ego@in.ibm.com, andi@firstfloor.org,
       venkatesh.pallipadi@intel.com, vatsa@linux.vnet.ibm.com,
       arjan@infradead.org, svaidy@linux.vnet.ibm.com
Subject: Re: [v5 PATCH 4/4] timers: logic to move non pinned timers
Message-ID: <20090407081157.GA7628@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
References: <20090406161357.GB15269@linux.vnet.ibm.com> <20090406162205.GE15269@linux.vnet.ibm.com> <alpine.LFD.2.00.0904061846140.21577@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904061846140.21577@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Thomas Gleixner <tglx@linutronix.de> [2009-04-06 18:48:48]:

Hi,

I tested my patchset for any possible regression, with kernbench.
Posting the results below. The results show that we are not facing
any regression due to these patches.

Ingo,

Can you please include the patch series in the -tip so that it gets
more testing? I worked with Thomas to implement all the necessary
fine-tunings that were required.

I'm reposting the [PATCH 4/4] in this mail. All the other patches in
the patchset are unchanged.


Kernbech results on an 8-cpu, 2 package machine.

-----------------------------------------------------------------------
| No. of Threads  |	 Time(s) - Without   |	   Time(s) - With the |
|		  |       patches applied    |	     patches applied  |
-----------------------------------------------------------------------
|	1	  |	      298.9	     |		298.8	      |
|	2	  |	      148.2	     |		148.6	      |
|	4	  |	       76.9	     |		 76.5	      |
|	8	  |	       43.8	     |		 43.5	      |
|      16	  |	       39.5	     |		 39.3	      |
|      32	  |	       39.1	     |		 39.1	      |
-----------------------------------------------------------------------

--arun
---

Signed-off-by: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
---
 include/linux/clockchips.h |    9 +++++++++
 include/linux/sched.h      |   12 ++++++++++++
 kernel/hrtimer.c           |   42 +++++++++++++++++++++++++++++++++++++++++-
 kernel/sched.c             |    5 +++++
 kernel/time/clockevents.c  |   14 ++++++++++++++
 kernel/timer.c             |   12 +++++++++++-
 6 files changed, 92 insertions(+), 2 deletions(-)

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
+	int ret, preferred_cpu, cpu;
 
 	ret = 0;
 
@@ -627,6 +628,15 @@ __mod_timer(struct timer_list *timer, un
 
 	new_base = __get_cpu_var(tvec_bases);
 
+	cpu = smp_processor_id();
+	if (get_sysctl_timer_migration() && idle_cpu(cpu) && !pinned) {
+		preferred_cpu = get_nohz_load_balancer();
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
 
@@ -198,8 +200,17 @@ switch_hrtimer_base(struct hrtimer *time
 {
 	struct hrtimer_clock_base *new_base;
 	struct hrtimer_cpu_base *new_cpu_base;
+	int cpu, preferred_cpu = -1;
 
-	new_cpu_base = &__get_cpu_var(hrtimer_bases);
+	cpu = smp_processor_id();
+	if (get_sysctl_timer_migration() && !pinned && idle_cpu(cpu)) {
+		preferred_cpu = get_nohz_load_balancer();
+		if (preferred_cpu >= 0)
+			cpu = preferred_cpu;
+	}
+
+again:
+	new_cpu_base = &per_cpu(hrtimer_bases, cpu);
 	new_base = &new_cpu_base->clock_base[base->index];
 
 	if (base != new_base) {
@@ -219,6 +230,35 @@ switch_hrtimer_base(struct hrtimer *time
 		timer->base = NULL;
 		spin_unlock(&base->cpu_base->lock);
 		spin_lock(&new_base->cpu_base->lock);
+
+		if (cpu == preferred_cpu) {
+			/* Calculate clock monotonic expiry time */
+			ktime_t expires = ktime_sub(hrtimer_get_expires(timer),
+							new_base->offset);
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
@@ -143,3 +143,12 @@ extern void clockevents_notify(unsigned 
 #endif
 
 #endif
+
+#ifdef CONFIG_GENERIC_CLOCKEVENTS
+extern ktime_t clockevents_get_next_event(int cpu);
+#else
+static inline ktime_t clockevents_get_next_event(int cpu)
+{
+	return KTIME_MAX;
+}
+#endif
