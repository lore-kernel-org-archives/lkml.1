Return-Path: <linux-kernel-owner+w=401wt.eu-S1757599AbYGPGVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757599AbYGPGVV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 02:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751787AbYGPGVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 02:21:12 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:39750 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbYGPGVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 02:21:11 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5339"; a="4584061"
From: Max Krasnyansky <maxk@qualcomm.com>
To: mingo@elte.hu, pj@sgi.com
Cc: linux-kernel@vger.kernel.org, Max Krasnyanskiy <maxk@qualcomm.com>,
       a.p.zijlstra@chello.nl, menage@google.com, vegard.nossum@gmail.com
Subject: [PATCH] cpuset: Make rebuild_sched_domains() usable from any context (take 2)
Date: Tue, 15 Jul 2008 23:21:08 -0700
Message-Id: <1216189268-30122-1-git-send-email-maxk@qualcomm.com>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Max Krasnyanskiy <maxk@qualcomm.com>

Basically as Paul J. pointed out rebuild_sched_domains() is the
only way to rebuild sched domains correctly based on the current
cpuset settings. What this means is that we need to be able to
call it from different contexts, like cpuhotplug for example.
Also if you look at the cpu_active_map patches, the scheduler now
calls rebuild_sched_domains() directly from places like
arch_init_sched_domains().

In order to support that properly we need to change cpuset locking
a bit, to avoid circular locking dependencies.
This patch makes rebuild_sched_domains() callable from any context.
The only requirement now is the the caller has to hold cpu_hotplug.lock
(ie get_online_cpus()). This allows cpu hotplug handlers and the
scheduler code to call rebuild_sched_domains() directly.

The rest of the cpuset code now offloads sched domains rebuilds to
the single threaded workqueue. As suggested by both Paul J. and Paul M.

This passes light testing (building kernel with -j 16, creating/removing
domains and bring cpus off/online at the same time) on the dual-Core2
based machine.
It passes (for the first) time lockdep checks, even with preemptable RCU
enabled.

So it looks like we're good to go :). Obviously needs more testing but
otherwise things are looking good.

Signed-off-by: Max Krasnyanskiy <maxk@qualcomm.com>
Cc: a.p.zijlstra@chello.nl
Cc: pj@sgi.com
Cc: mingo@elte.hu
Cc: menage@google.com
Cc: vegard.nossum@gmail.com
---
 kernel/cpuset.c |   92 ++++++++++++++++++++++++++++++++++++------------------
 1 files changed, 61 insertions(+), 31 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 3c3ef02..4581e4f 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -59,6 +59,11 @@
 #include <linux/cgroup.h>
 
 /*
+ * Workqueue for cpuset related tasks.
+ */
+static struct workqueue_struct *cpuset_wq;
+
+/*
  * Tracks how many cpusets are currently defined in system.
  * When there is only one cpuset (the root cpuset) we can
  * short circuit some hooks.
@@ -522,13 +527,12 @@ update_domain_attr(struct sched_domain_attr *dattr, struct cpuset *c)
  * domains when operating in the severe memory shortage situations
  * that could cause allocation failures below.
  *
- * Call with cgroup_mutex held.  May take callback_mutex during
- * call due to the kfifo_alloc() and kmalloc() calls.  May nest
- * a call to the get_online_cpus()/put_online_cpus() pair.
- * Must not be called holding callback_mutex, because we must not
- * call get_online_cpus() while holding callback_mutex.  Elsewhere
- * the kernel nests callback_mutex inside get_online_cpus() calls.
- * So the reverse nesting would risk an ABBA deadlock.
+ * Call under get_online_cpus().
+ * Must not be called with cgroup_lock or callback_mutex held.
+ * This means that internally cpuset code must not use this function
+ * and call __rebuild_sched_domains() instead. The only exception is
+ * cpu hotplug code where get_online_cpus() lock is taken at the top 
+ * level and nesting is not an issue.
  *
  * The three key local variables below are:
  *    q  - a kfifo queue of cpuset pointers, used to implement a
@@ -581,6 +585,10 @@ void rebuild_sched_domains(void)
 	doms = NULL;
 	dattr = NULL;
 
+	/* We have to iterate cgroup hierarchy, make sure nobody is messing 
+	 * with it. */
+	cgroup_lock();
+
 	/* Special case for the 99% of systems with one, full, sched domain */
 	if (is_sched_load_balance(&top_cpuset)) {
 		ndoms = 1;
@@ -598,10 +606,10 @@ void rebuild_sched_domains(void)
 
 	q = kfifo_alloc(number_of_cpusets * sizeof(cp), GFP_KERNEL, NULL);
 	if (IS_ERR(q))
-		goto done;
+		goto unlock;
 	csa = kmalloc(number_of_cpusets * sizeof(cp), GFP_KERNEL);
 	if (!csa)
-		goto done;
+		goto unlock;
 	csn = 0;
 
 	cp = &top_cpuset;
@@ -688,10 +696,16 @@ restart:
 	BUG_ON(nslot != ndoms);
 
 rebuild:
+	/* Drop cgroup lock before calling the scheduler.
+	 * This is not strictly necesseary but simplifies lock nesting. */
+	cgroup_unlock();
+
 	/* Have scheduler rebuild sched domains */
-	get_online_cpus();
 	partition_sched_domains(ndoms, doms, dattr);
-	put_online_cpus();
+	goto done;
+
+unlock:
+	cgroup_unlock();
 
 done:
 	if (q && !IS_ERR(q))
@@ -701,6 +715,30 @@ done:
 	/* Don't kfree(dattr) -- partition_sched_domains() does that. */
 }
 
+/*
+ * Simply calls rebuild_sched_domains() with correct locking rules.
+ */
+static void rebuild_domains_callback(struct work_struct *work)
+{
+	get_online_cpus();
+	rebuild_sched_domains();
+	put_online_cpus();
+}
+static DECLARE_WORK(rebuild_domains_work, rebuild_domains_callback);
+
+/*
+ * Internal helper for rebuilding sched domains when something changes.
+ * rebuild_sched_domains() must be called under get_online_cpus() and 
+ * it needs to take cgroup_lock(). But most of the cpuset code is already 
+ * holding cgroup_lock() while calling __rebuild_sched_domains(). 
+ * In order to avoid incorrect lock nesting we delegate the actual domain 
+ * rebuilding to the workqueue.
+ */ 
+static void __rebuild_sched_domains(void)
+{
+	queue_work(cpuset_wq, &rebuild_domains_work);
+}
+
 static inline int started_after_time(struct task_struct *t1,
 				     struct timespec *time,
 				     struct task_struct *t2)
@@ -831,7 +869,7 @@ static int update_cpumask(struct cpuset *cs, char *buf)
 	heap_free(&heap);
 
 	if (is_load_balanced)
-		rebuild_sched_domains();
+		__rebuild_sched_domains();
 	return 0;
 }
 
@@ -1042,7 +1080,7 @@ static int update_relax_domain_level(struct cpuset *cs, s64 val)
 
 	if (val != cs->relax_domain_level) {
 		cs->relax_domain_level = val;
-		rebuild_sched_domains();
+		__rebuild_sched_domains();
 	}
 
 	return 0;
@@ -1083,7 +1121,7 @@ static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
 	mutex_unlock(&callback_mutex);
 
 	if (cpus_nonempty && balance_flag_changed)
-		rebuild_sched_domains();
+		__rebuild_sched_domains();
 
 	return 0;
 }
@@ -1677,15 +1715,9 @@ static struct cgroup_subsys_state *cpuset_create(
 }
 
 /*
- * Locking note on the strange update_flag() call below:
- *
  * If the cpuset being removed has its flag 'sched_load_balance'
  * enabled, then simulate turning sched_load_balance off, which
- * will call rebuild_sched_domains().  The get_online_cpus()
- * call in rebuild_sched_domains() must not be made while holding
- * callback_mutex.  Elsewhere the kernel nests callback_mutex inside
- * get_online_cpus() calls.  So the reverse nesting would risk an
- * ABBA deadlock.
+ * will call rebuild_sched_domains().
  */
 
 static void cpuset_destroy(struct cgroup_subsys *ss, struct cgroup *cont)
@@ -1894,7 +1926,7 @@ static void scan_for_empty_cpusets(const struct cpuset *root)
  * in order to minimize text size.
  */
 
-static void common_cpu_mem_hotplug_unplug(int rebuild_sd)
+static void common_cpu_mem_hotplug_unplug(void)
 {
 	cgroup_lock();
 
@@ -1902,13 +1934,6 @@ static void common_cpu_mem_hotplug_unplug(int rebuild_sd)
 	top_cpuset.mems_allowed = node_states[N_HIGH_MEMORY];
 	scan_for_empty_cpusets(&top_cpuset);
 
-	/*
-	 * Scheduler destroys domains on hotplug events.
-	 * Rebuild them based on the current settings.
-	 */
-	if (rebuild_sd)
-		rebuild_sched_domains();
-
 	cgroup_unlock();
 }
 
@@ -1934,12 +1959,14 @@ static int cpuset_handle_cpuhp(struct notifier_block *unused_nb,
 	case CPU_ONLINE_FROZEN:
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
-		common_cpu_mem_hotplug_unplug(1);
 		break;
+
 	default:
 		return NOTIFY_DONE;
 	}
 
+	common_cpu_mem_hotplug_unplug();
+	rebuild_sched_domains();
 	return NOTIFY_OK;
 }
 
@@ -1953,7 +1980,7 @@ static int cpuset_handle_cpuhp(struct notifier_block *unused_nb,
 
 void cpuset_track_online_nodes(void)
 {
-	common_cpu_mem_hotplug_unplug(0);
+	common_cpu_mem_hotplug_unplug();
 }
 #endif
 
@@ -1969,6 +1996,9 @@ void __init cpuset_init_smp(void)
 	top_cpuset.mems_allowed = node_states[N_HIGH_MEMORY];
 
 	hotcpu_notifier(cpuset_handle_cpuhp, 0);
+
+	cpuset_wq = create_singlethread_workqueue("cpuset");
+	BUG_ON(!cpuset_wq);
 }
 
 /**
-- 
1.5.5.1

