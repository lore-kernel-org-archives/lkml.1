Return-Path: <linux-kernel-owner+w=401wt.eu-S1760485AbZCPLQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760485AbZCPLQR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 07:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753609AbZCPLQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 07:16:00 -0400
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:48108 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbZCPLP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 07:15:59 -0400
Date: Mon, 16 Mar 2009 16:45:48 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: a.p.zijlstra@chello.nl, ego@in.ibm.com, tglx@linutronix.de, mingo@elte.hu,
       andi@firstfloor.org, venkatesh.pallipadi@intel.com,
       vatsa@linux.vnet.ibm.com, arjan@infradead.org,
       svaidy@linux.vnet.ibm.com, Arun Bharadwaj <arun@linux.vnet.ibm.com>
Subject: [v3 PATCH 4/4] timers: logic to move non pinned timers
Message-ID: <20090316111548.GE4686@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
References: <20090316111045.GA4686@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090316111045.GA4686@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arun R Bharadwaj <arun@linux.vnet.ibm.com> [2009-03-16 16:40:45]:

This patch migrates all non pinned timers and hrtimers to the current
idle load balancer, from all the idle CPUs. Timers firing on busy CPUs
are not migrated.

Signed-off-by: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
---
 include/linux/sched.h |    9 +++++++++
 kernel/hrtimer.c      |   12 +++++++++++-
 kernel/sched.c        |    5 +++++
 kernel/timer.c        |   13 ++++++++++++-
 4 files changed, 37 insertions(+), 2 deletions(-)

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
 
@@ -627,6 +628,16 @@ __mod_timer(struct timer_list *timer, un
 
 	new_base = __get_cpu_var(tvec_bases);
 
+	current_cpu = smp_processor_id();
+	preferred_cpu = get_nohz_load_balancer();
+	if (get_sysctl_timer_migration() && idle_cpu(current_cpu) &&
+			!pinned && preferred_cpu != -1) {
+		new_base = per_cpu(tvec_bases, preferred_cpu);
+		timer_set_base(timer, new_base);
+		timer->expires = expires;
+		internal_add_timer(new_base, timer);
+		goto out_unlock;
+	}
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
 
@@ -198,8 +200,16 @@ switch_hrtimer_base(struct hrtimer *time
 {
 	struct hrtimer_clock_base *new_base;
 	struct hrtimer_cpu_base *new_cpu_base;
+	int current_cpu, preferred_cpu;
+
+	current_cpu = smp_processor_id();
+	preferred_cpu = get_nohz_load_balancer();
+	if (get_sysctl_timer_migration() && !pinned && preferred_cpu != -1
+			&& idle_cpu(current_cpu))
+		new_cpu_base = &per_cpu(hrtimer_bases, preferred_cpu);
+	else
+		new_cpu_base = &__get_cpu_var(hrtimer_bases);
 
-	new_cpu_base = &__get_cpu_var(hrtimer_bases);
 	new_base = &new_cpu_base->clock_base[base->index];
 
 	if (base != new_base) {
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
@@ -1769,6 +1770,14 @@ int sched_nr_latency_handler(struct ctl_
 		struct file *file, void __user *buffer, size_t *length,
 		loff_t *ppos);
 #endif
+static inline int get_sysctl_timer_migration(void)
+{
+#ifdef CONFIG_SCHED_DEBUG
+	return sysctl_timer_migration;
+#else
+	return 1;
+#endif
+}
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
+        return atomic_read(&nohz.load_balancer);
+}
+
 /*
  * This routine will try to nominate the ilb (idle load balancing)
  * owner among the cpus whose ticks are stopped. ilb owner will do the idle
