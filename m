Return-Path: <linux-kernel-owner+w=401wt.eu-S1753478AbYHAW7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478AbYHAW7Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 18:59:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751022AbYHAW7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 18:59:16 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:27527 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbYHAW7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 18:59:13 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5352"; a="5086537"
From: Max Krasnyansky <maxk@qualcomm.com>
To: pj@sgi.com, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, Max Krasnyansky <maxk@qualcomm.com>,
       menage@google.com, a.p.zijlstra@chello.nl, vegard.nossum@gmail.com
Subject: [PATCH] cpuset: Rework sched domains and CPU hotplug handling (2.6.27-rc1)
Date: Fri,  1 Aug 2008 15:59:12 -0700
Message-Id: <1217631552-22129-1-git-send-email-maxk@qualcomm.com>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an updated version of my previous cpuset patch:
  "Make rebuild_sched_domains() usable from any context (take 2)"
It's been merged with the latest cpuset changes in mainline.

rebuild_sched_domains() is the only way to rebuild sched domains
correctly based on the current cpuset settings. What this means
is that we need to be able to call it from different contexts,
like cpu hotplug for example.
Also latest scheduler code in -tip now calls rebuild_sched_domains()
directly from functions like arch_reinit_sched_domains().

In order to support that properly we need to rework cpuset locking
rules to avoid circular depencies, which is what this patch does.
New lock nesting rules are explained in the comments.
We can now safely call rebuild_sched_domains() from virtually any
context. The only requirement is that it needs to be called under
get_online_cpus(). This allows cpu hotplug handlers and the scheduler
to call rebuild_sched_domains() directly.

The rest of the cpuset code now offloads sched domains rebuilds to
the single threaded workqueue. As suggested by both Paul J. and Paul M.

This version of the patch addresses comments from the previous review.
I fixed all miss-formated comments and trailing spaces.
__rebuild_sched_domains() has been renamed to async_rebuild_sched_domains().

I also factored out the code that builds domain masks and split up CPU and
memory hotplug handling. This was needed to simplify locking, to avoid unsafe
access to the cpu_online_map from mem hotplug handler, and in general to make
things cleaner.

The patch passes moderate testing (building kernel with -j 16, creating &
removing domains and bring cpus off/online at the same time) on the
quad-core2 based machine.
It passes lockdep checks, even with preemptable RCU enabled.
This time I also tested in with suspend/resume path and everything is working
as expected.

Signed-off-by: Max Krasnyansky <maxk@qualcomm.com>
Cc: mingo@elte.hu
Cc: pj@sgi.com
Cc: menage@google.com
Cc: a.p.zijlstra@chello.nl
Cc: vegard.nossum@gmail.com
---
 kernel/cpuset.c |  297 +++++++++++++++++++++++++++++++------------------------
 1 files changed, 168 insertions(+), 129 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index d5ab79c..e655cea 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -14,6 +14,8 @@
  *  2003-10-22 Updates by Stephen Hemminger.
  *  2004 May-July Rework by Paul Jackson.
  *  2006 Rework by Paul Menage to use generic cgroups
+ *  2008 Rework of the scheduler domains and CPU hotplug handling
+ *       by Max Krasnyansky
  *
  *  This file is subject to the terms and conditions of the GNU General Public
  *  License.  See the file COPYING in the main directory of the Linux
@@ -58,6 +60,11 @@
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
@@ -236,9 +243,11 @@ static struct cpuset top_cpuset = {
 
 static DEFINE_MUTEX(callback_mutex);
 
-/* This is ugly, but preserves the userspace API for existing cpuset
+/*
+ * This is ugly, but preserves the userspace API for existing cpuset
  * users. If someone tries to mount the "cpuset" filesystem, we
- * silently switch it to mount "cgroup" instead */
+ * silently switch it to mount "cgroup" instead
+ */
 static int cpuset_get_sb(struct file_system_type *fs_type,
 			 int flags, const char *unused_dev_name,
 			 void *data, struct vfsmount *mnt)
@@ -473,10 +482,9 @@ static int validate_change(const struct cpuset *cur, const struct cpuset *trial)
 }
 
 /*
- * Helper routine for rebuild_sched_domains().
+ * Helper routine for generate_sched_domains().
  * Do cpusets a, b have overlapping cpus_allowed masks?
  */
-
 static int cpusets_overlap(struct cpuset *a, struct cpuset *b)
 {
 	return cpus_intersects(a->cpus_allowed, b->cpus_allowed);
@@ -518,26 +526,15 @@ update_domain_attr_tree(struct sched_domain_attr *dattr, struct cpuset *c)
 }
 
 /*
- * rebuild_sched_domains()
- *
- * This routine will be called to rebuild the scheduler's dynamic
- * sched domains:
- * - if the flag 'sched_load_balance' of any cpuset with non-empty
- *   'cpus' changes,
- * - or if the 'cpus' allowed changes in any cpuset which has that
- *   flag enabled,
- * - or if the 'sched_relax_domain_level' of any cpuset which has
- *   that flag enabled and with non-empty 'cpus' changes,
- * - or if any cpuset with non-empty 'cpus' is removed,
- * - or if a cpu gets offlined.
- *
- * This routine builds a partial partition of the systems CPUs
- * (the set of non-overlappping cpumask_t's in the array 'part'
- * below), and passes that partial partition to the kernel/sched.c
- * partition_sched_domains() routine, which will rebuild the
- * schedulers load balancing domains (sched domains) as specified
- * by that partial partition.  A 'partial partition' is a set of
- * non-overlapping subsets whose union is a subset of that set.
+ * generate_sched_domains()
+ *
+ * This function builds a partial partition of the systems CPUs
+ * A 'partial partition' is a set of non-overlapping subsets whose
+ * union is a subset of that set.
+ * The output of this function needs to be passed to kernel/sched.c
+ * partition_sched_domains() routine, which will rebuild the scheduler's
+ * load balancing domains (sched domains) as specified by that partial
+ * partition.
  *
  * See "What is sched_load_balance" in Documentation/cpusets.txt
  * for a background explanation of this.
@@ -547,13 +544,7 @@ update_domain_attr_tree(struct sched_domain_attr *dattr, struct cpuset *c)
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
+ * Must be called with cgroup_lock held.
  *
  * The three key local variables below are:
  *    q  - a linked-list queue of cpuset pointers, used to implement a
@@ -588,8 +579,8 @@ update_domain_attr_tree(struct sched_domain_attr *dattr, struct cpuset *c)
  *	element of the partition (one sched domain) to be passed to
  *	partition_sched_domains().
  */
-
-void rebuild_sched_domains(void)
+static int generate_sched_domains(cpumask_t **domains,
+			struct sched_domain_attr **attributes)
 {
 	LIST_HEAD(q);		/* queue of cpusets to be scanned*/
 	struct cpuset *cp;	/* scans q */
@@ -601,23 +592,26 @@ void rebuild_sched_domains(void)
 	int ndoms;		/* number of sched domains in result */
 	int nslot;		/* next empty doms[] cpumask_t slot */
 
-	csa = NULL;
-	doms = NULL;
+	ndoms = 0;
+	doms  = NULL;
 	dattr = NULL;
+	csa   = NULL;
 
 	/* Special case for the 99% of systems with one, full, sched domain */
 	if (is_sched_load_balance(&top_cpuset)) {
-		ndoms = 1;
 		doms = kmalloc(sizeof(cpumask_t), GFP_KERNEL);
 		if (!doms)
-			goto rebuild;
+			goto done;
+
 		dattr = kmalloc(sizeof(struct sched_domain_attr), GFP_KERNEL);
 		if (dattr) {
 			*dattr = SD_ATTR_INIT;
 			update_domain_attr_tree(dattr, &top_cpuset);
 		}
 		*doms = top_cpuset.cpus_allowed;
-		goto rebuild;
+
+		ndoms = 1;
+		goto done;
 	}
 
 	csa = kmalloc(number_of_cpusets * sizeof(cp), GFP_KERNEL);
@@ -680,61 +674,123 @@ restart:
 		}
 	}
 
-	/* Convert <csn, csa> to <ndoms, doms> */
+	/*
+	 * Now we know how many domains to create.
+	 * Convert <csn, csa> to <ndoms, doms> and populate cpu masks.
+	 */
 	doms = kmalloc(ndoms * sizeof(cpumask_t), GFP_KERNEL);
-	if (!doms)
-		goto rebuild;
+	if (!doms) {
+		ndoms = 0;
+		goto done;
+	}
+
 	dattr = kmalloc(ndoms * sizeof(struct sched_domain_attr), GFP_KERNEL);
 
 	for (nslot = 0, i = 0; i < csn; i++) {
 		struct cpuset *a = csa[i];
+		cpumask_t *dp;
 		int apn = a->pn;
 
-		if (apn >= 0) {
-			cpumask_t *dp = doms + nslot;
-
-			if (nslot == ndoms) {
-				static int warnings = 10;
-				if (warnings) {
-					printk(KERN_WARNING
-					 "rebuild_sched_domains confused:"
-					  " nslot %d, ndoms %d, csn %d, i %d,"
-					  " apn %d\n",
-					  nslot, ndoms, csn, i, apn);
-					warnings--;
-				}
-				continue;
+		if (apn < 0) {
+			/* Skip completed partitions */
+			continue;
+		}
+
+		dp = doms + nslot;
+
+		if (nslot == ndoms) {
+			static int warnings = 10;
+			if (warnings) {
+				printk(KERN_WARNING
+				 "rebuild_sched_domains confused:"
+				  " nslot %d, ndoms %d, csn %d, i %d,"
+				  " apn %d\n",
+				  nslot, ndoms, csn, i, apn);
+				warnings--;
 			}
+			continue;
+		}
 
-			cpus_clear(*dp);
-			if (dattr)
-				*(dattr + nslot) = SD_ATTR_INIT;
-			for (j = i; j < csn; j++) {
-				struct cpuset *b = csa[j];
-
-				if (apn == b->pn) {
-					cpus_or(*dp, *dp, b->cpus_allowed);
-					b->pn = -1;
-					if (dattr)
-						update_domain_attr_tree(dattr
-								   + nslot, b);
-				}
+		cpus_clear(*dp);
+		if (dattr)
+			*(dattr + nslot) = SD_ATTR_INIT;
+		for (j = i; j < csn; j++) {
+			struct cpuset *b = csa[j];
+
+			if (apn == b->pn) {
+				cpus_or(*dp, *dp, b->cpus_allowed);
+				if (dattr)
+					update_domain_attr_tree(dattr + nslot, b);
+
+				/* Done with this partition */
+				b->pn = -1;
 			}
-			nslot++;
 		}
+		nslot++;
 	}
 	BUG_ON(nslot != ndoms);
 
-rebuild:
-	/* Have scheduler rebuild sched domains */
+done:
+	kfree(csa);
+
+	*domains    = doms;
+	*attributes = dattr;
+	return ndoms;
+}
+
+/*
+ * Rebuilds scheduler domains. See generate_sched_domains() description
+ * for details.
+ *
+ * Must be called under get_online_cpus(). This is an external interface
+ * and must not be used inside the cpuset code to avoid circular locking
+ * dependency. cpuset code should use async_rebuild_sched_domains() instead.
+ */
+void rebuild_sched_domains(void)
+{
+	struct sched_domain_attr *attr;
+	cpumask_t *doms;
+	int ndoms;
+
+	/*
+	 * We have to iterate cgroup hierarch which requires cgroup lock.
+	 */
+	cgroup_lock();
+	ndoms = generate_sched_domains(&doms, &attr);
+	cgroup_unlock();
+
+	/* Have scheduler rebuild the domains */
+	partition_sched_domains(ndoms, doms, attr);
+}
+
+/*
+ * Simply calls rebuild_sched_domains() with correct locking rules.
+ */
+static void rebuild_domains_callback(struct work_struct *work)
+{
 	get_online_cpus();
-	partition_sched_domains(ndoms, doms, dattr);
+	rebuild_sched_domains();
 	put_online_cpus();
+}
+static DECLARE_WORK(rebuild_domains_work, rebuild_domains_callback);
 
-done:
-	kfree(csa);
-	/* Don't kfree(doms) -- partition_sched_domains() does that. */
-	/* Don't kfree(dattr) -- partition_sched_domains() does that. */
+/*
+ * Internal helper for rebuilding sched domains when something changes.
+ *
+ * If the flag 'sched_load_balance' of any cpuset with non-empty
+ * 'cpus' changes, or if the 'cpus' allowed changes in any cpuset
+ * which has that flag enabled, or if any cpuset with a non-empty
+ * 'cpus' is removed, then call this routine to rebuild the
+ * scheduler's dynamic sched domains.
+ *
+ * rebuild_sched_domains() must be called under get_online_cpus() and
+ * it needs to take cgroup_lock(). But most of the cpuset code is already
+ * holding cgroup_lock(). In order to avoid incorrect lock nesting we
+ * delegate the actual domain rebuilding to the workqueue.
+ */
+static void async_rebuild_sched_domains(void)
+{
+	queue_work(cpuset_wq, &rebuild_domains_work);
 }
 
 /**
@@ -863,7 +919,7 @@ static int update_cpumask(struct cpuset *cs, const char *buf)
 		return retval;
 
 	if (is_load_balanced)
-		rebuild_sched_domains();
+		async_rebuild_sched_domains();
 	return 0;
 }
 
@@ -1090,7 +1146,7 @@ static int update_relax_domain_level(struct cpuset *cs, s64 val)
 	if (val != cs->relax_domain_level) {
 		cs->relax_domain_level = val;
 		if (!cpus_empty(cs->cpus_allowed) && is_sched_load_balance(cs))
-			rebuild_sched_domains();
+			async_rebuild_sched_domains();
 	}
 
 	return 0;
@@ -1131,7 +1187,7 @@ static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
 	mutex_unlock(&callback_mutex);
 
 	if (cpus_nonempty && balance_flag_changed)
-		rebuild_sched_domains();
+		async_rebuild_sched_domains();
 
 	return 0;
 }
@@ -1492,6 +1548,9 @@ static u64 cpuset_read_u64(struct cgroup *cont, struct cftype *cft)
 	default:
 		BUG();
 	}
+
+	/* Unreachable but makes gcc happy */
+	return 0;
 }
 
 static s64 cpuset_read_s64(struct cgroup *cont, struct cftype *cft)
@@ -1504,6 +1563,9 @@ static s64 cpuset_read_s64(struct cgroup *cont, struct cftype *cft)
 	default:
 		BUG();
 	}
+
+	/* Unrechable but makes gcc happy */
+	return 0;
 }
 
 
@@ -1692,15 +1754,9 @@ static struct cgroup_subsys_state *cpuset_create(
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
@@ -1811,7 +1867,7 @@ static void move_member_tasks_to_cpuset(struct cpuset *from, struct cpuset *to)
 }
 
 /*
- * If common_cpu_mem_hotplug_unplug(), below, unplugs any CPUs
+ * If CPU and/or memory hotplug handlers, below, unplug any CPUs
  * or memory nodes, we need to walk over the cpuset hierarchy,
  * removing that CPU or node from all cpusets.  If this removes the
  * last CPU or node from a cpuset, then move the tasks in the empty
@@ -1903,35 +1959,6 @@ static void scan_for_empty_cpusets(const struct cpuset *root)
 }
 
 /*
- * The cpus_allowed and mems_allowed nodemasks in the top_cpuset track
- * cpu_online_map and node_states[N_HIGH_MEMORY].  Force the top cpuset to
- * track what's online after any CPU or memory node hotplug or unplug event.
- *
- * Since there are two callers of this routine, one for CPU hotplug
- * events and one for memory node hotplug events, we could have coded
- * two separate routines here.  We code it as a single common routine
- * in order to minimize text size.
- */
-
-static void common_cpu_mem_hotplug_unplug(int rebuild_sd)
-{
-	cgroup_lock();
-
-	top_cpuset.cpus_allowed = cpu_online_map;
-	top_cpuset.mems_allowed = node_states[N_HIGH_MEMORY];
-	scan_for_empty_cpusets(&top_cpuset);
-
-	/*
-	 * Scheduler destroys domains on hotplug events.
-	 * Rebuild them based on the current settings.
-	 */
-	if (rebuild_sd)
-		rebuild_sched_domains();
-
-	cgroup_unlock();
-}
-
-/*
  * The top_cpuset tracks what CPUs and Memory Nodes are online,
  * period.  This is necessary in order to make cpusets transparent
  * (of no affect) on systems that are actively using CPU hotplug
@@ -1940,39 +1967,48 @@ static void common_cpu_mem_hotplug_unplug(int rebuild_sd)
  * This routine ensures that top_cpuset.cpus_allowed tracks
  * cpu_online_map on each CPU hotplug (cpuhp) event.
  */
-
-static int cpuset_handle_cpuhp(struct notifier_block *unused_nb,
+static int cpuset_track_online_cpus(struct notifier_block *unused_nb,
 				unsigned long phase, void *unused_cpu)
 {
+	struct sched_domain_attr *attr;
+	cpumask_t *doms;
+	int ndoms;
+
 	switch (phase) {
-	case CPU_UP_CANCELED:
-	case CPU_UP_CANCELED_FROZEN:
-	case CPU_DOWN_FAILED:
-	case CPU_DOWN_FAILED_FROZEN:
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
-		common_cpu_mem_hotplug_unplug(1);
 		break;
+
 	default:
 		return NOTIFY_DONE;
 	}
 
+	cgroup_lock();
+	top_cpuset.cpus_allowed = cpu_online_map;
+	scan_for_empty_cpusets(&top_cpuset);
+	ndoms = generate_sched_domains(&doms, &attr);
+	cgroup_unlock();
+
+	/* Have scheduler rebuild the domains */
+	partition_sched_domains(ndoms, doms, attr);
+
 	return NOTIFY_OK;
 }
 
 #ifdef CONFIG_MEMORY_HOTPLUG
 /*
  * Keep top_cpuset.mems_allowed tracking node_states[N_HIGH_MEMORY].
- * Call this routine anytime after you change
- * node_states[N_HIGH_MEMORY].
- * See also the previous routine cpuset_handle_cpuhp().
+ * Call this routine anytime after node_states[N_HIGH_MEMORY] changes.
+ * See also the previous routine cpuset_track_online_cpus().
  */
-
 void cpuset_track_online_nodes(void)
 {
-	common_cpu_mem_hotplug_unplug(0);
+	cgroup_lock();
+	top_cpuset.mems_allowed = node_states[N_HIGH_MEMORY];
+	scan_for_empty_cpusets(&top_cpuset);
+	cgroup_unlock();
 }
 #endif
 
@@ -1987,7 +2023,10 @@ void __init cpuset_init_smp(void)
 	top_cpuset.cpus_allowed = cpu_online_map;
 	top_cpuset.mems_allowed = node_states[N_HIGH_MEMORY];
 
-	hotcpu_notifier(cpuset_handle_cpuhp, 0);
+	hotcpu_notifier(cpuset_track_online_cpus, 0);
+
+	cpuset_wq = create_singlethread_workqueue("cpuset");
+	BUG_ON(!cpuset_wq);
 }
 
 /**
-- 
1.5.5.1

