Return-Path: <linux-kernel-owner+w=401wt.eu-S1756651AbYGOLpJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651AbYGOLpJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 07:45:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754811AbYGOLo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 07:44:56 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:62732 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754399AbYGOLoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 07:44:55 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5338"; a="4548219"
From: Max Krasnyansky <maxk@qualcomm.com>
To: mingo@elte.hu, pj@sgi.com
Cc: linux-kernel@vger.kernel.org, Max Krasnyanskiy <maxk@qualcomm.com>,
       a.p.zijlstra@chello.nl, menage@google.com
Subject: [PATCH] cpuset: Make rebuild_sched_domains() usable from any context
Date: Tue, 15 Jul 2008 04:44:53 -0700
Message-Id: <1216122293-4888-1-git-send-email-maxk@qualcomm.com>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Max Krasnyanskiy <maxk@qualcomm.com>

I do not really like the current solution of dropping cgroup lock
but it shows what I have in mind in general.

Basically as Paul J. pointed out rebuild_sched_domains() is the
only way to rebuild sched domains correctly based on the current
cpuset settings. What this means is that we need to be able to
call it from different contexts, like cpuhotplug for example.

In order to get there we need to redo the lock nesting a bit.
This patch tries to do that. New lock nesting is explained in the
comments.
Paul M has some patches for fine grain cgroup locking. That should
simplify things in the future.

This passes light testing (building stuff and creating/removing
domains and bring cpus off/online at the same time) and keeps lockdep
mostly happy. The only thing that I haven't resolved yet is some
complains from lockdep and preemtable RCU is enabled.

Signed-off-by: Max Krasnyanskiy <maxk@qualcomm.com>
Cc: a.p.zijlstra@chello.nl
Cc: pj@sgi.com
Cc: mingo@elte.hu
Cc: menage@google.com
---
 kernel/cpuset.c |   91 ++++++++++++++++++++++++++++--------------------------
 1 files changed, 47 insertions(+), 44 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 3c3ef02..7b9fa17 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -522,13 +522,8 @@ update_domain_attr(struct sched_domain_attr *dattr, struct cpuset *c)
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
  *
  * The three key local variables below are:
  *    q  - a kfifo queue of cpuset pointers, used to implement a
@@ -581,6 +576,10 @@ void rebuild_sched_domains(void)
 	doms = NULL;
 	dattr = NULL;
 
+	/* We have to iterate cgroup hierarchy, make sure nobody is messing 
+	 * with it. */
+	cgroup_lock();
+
 	/* Special case for the 99% of systems with one, full, sched domain */
 	if (is_sched_load_balance(&top_cpuset)) {
 		ndoms = 1;
@@ -598,10 +597,10 @@ void rebuild_sched_domains(void)
 
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
@@ -688,10 +687,16 @@ restart:
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
@@ -701,6 +706,27 @@ done:
 	/* Don't kfree(dattr) -- partition_sched_domains() does that. */
 }
 
+/*
+ * Internal version of the rebuild_sched_domains() that ensures proper 
+ * lock nesting. rebuild_sched_domains() must be called under 
+ * get_online_cpus() and it needs to take cgroup_lock(). Since most of 
+ * the cpuset code is already holding cgroup_lock() while calling 
+ * rebuild_sched_domains() we must drop it here and take it under 
+ * get_online_cpus().
+ * This should go away when fine grained cgroup locking is available.
+ *
+ * Must be called with cgroup_lock() held.
+ * Must not be called under get_online_cpus().
+ */ 
+static void __rebuild_sched_domains(void)
+{
+	cgroup_unlock();
+	get_online_cpus();
+	rebuild_sched_domains();
+	put_online_cpus();
+	cgroup_lock();
+}
+
 static inline int started_after_time(struct task_struct *t1,
 				     struct timespec *time,
 				     struct task_struct *t2)
@@ -831,7 +857,7 @@ static int update_cpumask(struct cpuset *cs, char *buf)
 	heap_free(&heap);
 
 	if (is_load_balanced)
-		rebuild_sched_domains();
+		__rebuild_sched_domains();
 	return 0;
 }
 
@@ -1042,7 +1068,7 @@ static int update_relax_domain_level(struct cpuset *cs, s64 val)
 
 	if (val != cs->relax_domain_level) {
 		cs->relax_domain_level = val;
-		rebuild_sched_domains();
+		__rebuild_sched_domains();
 	}
 
 	return 0;
@@ -1083,7 +1109,7 @@ static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
 	mutex_unlock(&callback_mutex);
 
 	if (cpus_nonempty && balance_flag_changed)
-		rebuild_sched_domains();
+		__rebuild_sched_domains();
 
 	return 0;
 }
@@ -1194,15 +1220,6 @@ static int cpuset_can_attach(struct cgroup_subsys *ss,
 
 	if (cpus_empty(cs->cpus_allowed) || nodes_empty(cs->mems_allowed))
 		return -ENOSPC;
-	if (tsk->flags & PF_THREAD_BOUND) {
-		cpumask_t mask;
-
-		mutex_lock(&callback_mutex);
-		mask = cs->cpus_allowed;
-		mutex_unlock(&callback_mutex);
-		if (!cpus_equal(tsk->cpus_allowed, mask))
-			return -EINVAL;
-	}
 
 	return security_task_setscheduler(tsk, 0, NULL);
 }
@@ -1216,14 +1233,11 @@ static void cpuset_attach(struct cgroup_subsys *ss,
 	struct mm_struct *mm;
 	struct cpuset *cs = cgroup_cs(cont);
 	struct cpuset *oldcs = cgroup_cs(oldcont);
-	int err;
 
 	mutex_lock(&callback_mutex);
 	guarantee_online_cpus(cs, &cpus);
-	err = set_cpus_allowed_ptr(tsk, &cpus);
+	set_cpus_allowed_ptr(tsk, &cpus);
 	mutex_unlock(&callback_mutex);
-	if (err)
-		return;
 
 	from = oldcs->mems_allowed;
 	to = cs->mems_allowed;
@@ -1677,15 +1691,9 @@ static struct cgroup_subsys_state *cpuset_create(
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
@@ -1894,7 +1902,7 @@ static void scan_for_empty_cpusets(const struct cpuset *root)
  * in order to minimize text size.
  */
 
-static void common_cpu_mem_hotplug_unplug(int rebuild_sd)
+static void common_cpu_mem_hotplug_unplug(void)
 {
 	cgroup_lock();
 
@@ -1902,13 +1910,6 @@ static void common_cpu_mem_hotplug_unplug(int rebuild_sd)
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
 
@@ -1934,12 +1935,14 @@ static int cpuset_handle_cpuhp(struct notifier_block *unused_nb,
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
 
@@ -1953,7 +1956,7 @@ static int cpuset_handle_cpuhp(struct notifier_block *unused_nb,
 
 void cpuset_track_online_nodes(void)
 {
-	common_cpu_mem_hotplug_unplug(0);
+	common_cpu_mem_hotplug_unplug();
 }
 #endif
 
-- 
1.5.5.1

