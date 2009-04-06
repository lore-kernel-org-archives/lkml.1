Return-Path: <linux-kernel-owner+w=401wt.eu-S1755542AbZDFKnF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542AbZDFKnF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 06:43:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754713AbZDFKmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 06:42:54 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:35154 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754863AbZDFKmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 06:42:53 -0400
Date: Mon, 6 Apr 2009 16:12:28 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       a.p.zijlstra@chello.nl, ego@in.ibm.com, mingo@elte.hu,
       andi@firstfloor.org, venkatesh.pallipadi@intel.com,
       vatsa@linux.vnet.ibm.com, arjan@infradead.org,
       svaidy@linux.vnet.ibm.com, Arun Bharadwaj <arun@linux.vnet.ibm.com>
Subject: Re: [v4 RFC PATCH 4/4] timers: logic to move non pinned timers
Message-ID: <20090406104228.GB17412@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
References: <20090401113128.GA22478@linux.vnet.ibm.com> <20090401113738.GE22478@linux.vnet.ibm.com> <alpine.LFD.2.00.0904032142460.12916@localhost.localdomain> <20090406051656.GA17412@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090406051656.GA17412@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arun R Bharadwaj <arun@linux.vnet.ibm.com> [2009-04-06 10:46:56]:

This is a re-post of the patch after implementing the changes
suggested by Thomas.

---

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
 include/linux/sched.h |   12 ++++++++++++
 kernel/hrtimer.c      |   50 +++++++++++++++++++++++++++++++++++++++++++++++++-
 kernel/sched.c        |    5 +++++
 kernel/timer.c        |   12 +++++++++++-
 4 files changed, 77 insertions(+), 2 deletions(-)

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
 
@@ -189,6 +191,17 @@ struct hrtimer_clock_base *lock_hrtimer_
 	}
 }
 
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
+
 /*
  * Switch the timer base to the current CPU when possible.
  */
@@ -198,8 +211,17 @@ switch_hrtimer_base(struct hrtimer *time
 {
 	struct hrtimer_clock_base *new_base;
 	struct hrtimer_cpu_base *new_cpu_base;
+	int cpu, preferred_cpu = -1;
+
+	cpu = smp_processor_id();
+	if (get_sysctl_timer_migration() && !pinned && idle_cpu(cpu)) {
+		preferred_cpu = get_nohz_load_balancer();
+		if (preferred_cpu >= 0)
+			cpu = preferred_cpu;
+	}
 
-	new_cpu_base = &__get_cpu_var(hrtimer_bases);
+again:
+	new_cpu_base = &per_cpu(hrtimer_bases, cpu);
 	new_base = &new_cpu_base->clock_base[base->index];
 
 	if (base != new_base) {
@@ -220,6 +242,32 @@ switch_hrtimer_base(struct hrtimer *time
 		spin_unlock(&base->cpu_base->lock);
 		spin_lock(&new_base->cpu_base->lock);
 		timer->base = new_base;
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
+				goto again;
+			}
+		}
 	}
 	return new_base;
 }
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
