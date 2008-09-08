Return-Path: <linux-kernel-owner+w=401wt.eu-S1755290AbYIHUH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290AbYIHUH0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 16:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753672AbYIHUHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 16:07:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35214 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753543AbYIHUHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 16:07:12 -0400
Date: Mon, 8 Sep 2008 22:06:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [git pull] scheduler fixes
Message-ID: <20080908200652.GA4785@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

These are cpusets related cpu hotplug race fixes that have been tested 
to fix crashes and behavioral regressions that were reported.

Thanks,

	Ingo

------------------>
Max Krasnyansky (2):
      sched, cpuset: rework sched domains and CPU hotplug handling (v4)
      sched: arch_reinit_sched_domains() must destroy domains to force rebuild


 include/linux/cpuset.h |    2 +-
 kernel/cpuset.c        |  312 ++++++++++++++++++++++++++++--------------------
 kernel/sched.c         |   19 ++-
 3 files changed, 196 insertions(+), 137 deletions(-)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index e8f450c..2691926 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -160,7 +160,7 @@ static inline int current_cpuset_is_being_rebound(void)
 
 static inline void rebuild_sched_domains(void)
 {
-	partition_sched_domains(0, NULL, NULL);
+	partition_sched_domains(1, NULL, NULL);
 }
 
 #endif /* !CONFIG_CPUSETS */
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index d5ab79c..f227bc1 100644
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
@@ -236,9 +238,11 @@ static struct cpuset top_cpuset = {
 
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
@@ -473,10 +477,9 @@ static int validate_change(const struct cpuset *cur, const struct cpuset *trial)
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
@@ -518,26 +521,15 @@ update_domain_attr_tree(struct sched_domain_attr *dattr, struct cpuset *c)
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
@@ -547,13 +539,7 @@ update_domain_attr_tree(struct sched_domain_attr *dattr, struct cpuset *c)
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
@@ -588,10 +574,10 @@ update_domain_attr_tree(struct sched_domain_attr *dattr, struct cpuset *c)
  *	element of the partition (one sched domain) to be passed to
  *	partition_sched_domains().
  */
-
-void rebuild_sched_domains(void)
+static int generate_sched_domains(cpumask_t **domains,
+			struct sched_domain_attr **attributes)
 {
-	LIST_HEAD(q);		/* queue of cpusets to be scanned*/
+	LIST_HEAD(q);		/* queue of cpusets to be scanned */
 	struct cpuset *cp;	/* scans q */
 	struct cpuset **csa;	/* array of all cpuset ptrs */
 	int csn;		/* how many cpuset ptrs in csa so far */
@@ -601,23 +587,26 @@ void rebuild_sched_domains(void)
 	int ndoms;		/* number of sched domains in result */
 	int nslot;		/* next empty doms[] cpumask_t slot */
 
-	csa = NULL;
+	ndoms = 0;
 	doms = NULL;
 	dattr = NULL;
+	csa = NULL;
 
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
@@ -680,61 +669,141 @@ restart:
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
+	/*
+	 * The rest of the code, including the scheduler, can deal with
+	 * dattr==NULL case. No need to abort if alloc fails.
+	 */
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
+ * Rebuild scheduler domains.
+ *
+ * Call with neither cgroup_mutex held nor within get_online_cpus().
+ * Takes both cgroup_mutex and get_online_cpus().
+ *
+ * Cannot be directly called from cpuset code handling changes
+ * to the cpuset pseudo-filesystem, because it cannot be called
+ * from code that already holds cgroup_mutex.
+ */
+static void do_rebuild_sched_domains(struct work_struct *unused)
+{
+	struct sched_domain_attr *attr;
+	cpumask_t *doms;
+	int ndoms;
+
 	get_online_cpus();
-	partition_sched_domains(ndoms, doms, dattr);
+
+	/* Generate domain masks and attrs */
+	cgroup_lock();
+	ndoms = generate_sched_domains(&doms, &attr);
+	cgroup_unlock();
+
+	/* Have scheduler rebuild the domains */
+	partition_sched_domains(ndoms, doms, attr);
+
 	put_online_cpus();
+}
 
-done:
-	kfree(csa);
-	/* Don't kfree(doms) -- partition_sched_domains() does that. */
-	/* Don't kfree(dattr) -- partition_sched_domains() does that. */
+static DECLARE_WORK(rebuild_sched_domains_work, do_rebuild_sched_domains);
+
+/*
+ * Rebuild scheduler domains, asynchronously via workqueue.
+ *
+ * If the flag 'sched_load_balance' of any cpuset with non-empty
+ * 'cpus' changes, or if the 'cpus' allowed changes in any cpuset
+ * which has that flag enabled, or if any cpuset with a non-empty
+ * 'cpus' is removed, then call this routine to rebuild the
+ * scheduler's dynamic sched domains.
+ *
+ * The rebuild_sched_domains() and partition_sched_domains()
+ * routines must nest cgroup_lock() inside get_online_cpus(),
+ * but such cpuset changes as these must nest that locking the
+ * other way, holding cgroup_lock() for much of the code.
+ *
+ * So in order to avoid an ABBA deadlock, the cpuset code handling
+ * these user changes delegates the actual sched domain rebuilding
+ * to a separate workqueue thread, which ends up processing the
+ * above do_rebuild_sched_domains() function.
+ */
+static void async_rebuild_sched_domains(void)
+{
+	schedule_work(&rebuild_sched_domains_work);
+}
+
+/*
+ * Accomplishes the same scheduler domain rebuild as the above
+ * async_rebuild_sched_domains(), however it directly calls the
+ * rebuild routine synchronously rather than calling it via an
+ * asynchronous work thread.
+ *
+ * This can only be called from code that is not holding
+ * cgroup_mutex (not nested in a cgroup_lock() call.)
+ */
+void rebuild_sched_domains(void)
+{
+	do_rebuild_sched_domains(NULL);
 }
 
 /**
@@ -863,7 +932,7 @@ static int update_cpumask(struct cpuset *cs, const char *buf)
 		return retval;
 
 	if (is_load_balanced)
-		rebuild_sched_domains();
+		async_rebuild_sched_domains();
 	return 0;
 }
 
@@ -1090,7 +1159,7 @@ static int update_relax_domain_level(struct cpuset *cs, s64 val)
 	if (val != cs->relax_domain_level) {
 		cs->relax_domain_level = val;
 		if (!cpus_empty(cs->cpus_allowed) && is_sched_load_balance(cs))
-			rebuild_sched_domains();
+			async_rebuild_sched_domains();
 	}
 
 	return 0;
@@ -1131,7 +1200,7 @@ static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
 	mutex_unlock(&callback_mutex);
 
 	if (cpus_nonempty && balance_flag_changed)
-		rebuild_sched_domains();
+		async_rebuild_sched_domains();
 
 	return 0;
 }
@@ -1492,6 +1561,9 @@ static u64 cpuset_read_u64(struct cgroup *cont, struct cftype *cft)
 	default:
 		BUG();
 	}
+
+	/* Unreachable but makes gcc happy */
+	return 0;
 }
 
 static s64 cpuset_read_s64(struct cgroup *cont, struct cftype *cft)
@@ -1504,6 +1576,9 @@ static s64 cpuset_read_s64(struct cgroup *cont, struct cftype *cft)
 	default:
 		BUG();
 	}
+
+	/* Unrechable but makes gcc happy */
+	return 0;
 }
 
 
@@ -1692,15 +1767,9 @@ static struct cgroup_subsys_state *cpuset_create(
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
+ * will call async_rebuild_sched_domains().
  */
 
 static void cpuset_destroy(struct cgroup_subsys *ss, struct cgroup *cont)
@@ -1719,7 +1788,7 @@ static void cpuset_destroy(struct cgroup_subsys *ss, struct cgroup *cont)
 struct cgroup_subsys cpuset_subsys = {
 	.name = "cpuset",
 	.create = cpuset_create,
-	.destroy  = cpuset_destroy,
+	.destroy = cpuset_destroy,
 	.can_attach = cpuset_can_attach,
 	.attach = cpuset_attach,
 	.populate = cpuset_populate,
@@ -1811,7 +1880,7 @@ static void move_member_tasks_to_cpuset(struct cpuset *from, struct cpuset *to)
 }
 
 /*
- * If common_cpu_mem_hotplug_unplug(), below, unplugs any CPUs
+ * If CPU and/or memory hotplug handlers, below, unplug any CPUs
  * or memory nodes, we need to walk over the cpuset hierarchy,
  * removing that CPU or node from all cpusets.  If this removes the
  * last CPU or node from a cpuset, then move the tasks in the empty
@@ -1903,35 +1972,6 @@ static void scan_for_empty_cpusets(const struct cpuset *root)
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
@@ -1939,40 +1979,52 @@ static void common_cpu_mem_hotplug_unplug(int rebuild_sd)
  *
  * This routine ensures that top_cpuset.cpus_allowed tracks
  * cpu_online_map on each CPU hotplug (cpuhp) event.
+ *
+ * Called within get_online_cpus().  Needs to call cgroup_lock()
+ * before calling generate_sched_domains().
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
 
@@ -1987,7 +2039,7 @@ void __init cpuset_init_smp(void)
 	top_cpuset.cpus_allowed = cpu_online_map;
 	top_cpuset.mems_allowed = node_states[N_HIGH_MEMORY];
 
-	hotcpu_notifier(cpuset_handle_cpuhp, 0);
+	hotcpu_notifier(cpuset_track_online_cpus, 0);
 }
 
 /**
diff --git a/kernel/sched.c b/kernel/sched.c
index 1a5f73c..cc1f81b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7696,24 +7696,27 @@ static int dattrs_equal(struct sched_domain_attr *cur, int idx_cur,
  * and partition_sched_domains() will fallback to the single partition
  * 'fallback_doms', it also forces the domains to be rebuilt.
  *
+ * If doms_new==NULL it will be replaced with cpu_online_map.
+ * ndoms_new==0 is a special case for destroying existing domains.
+ * It will not create the default domain.
+ *
  * Call with hotplug lock held
  */
 void partition_sched_domains(int ndoms_new, cpumask_t *doms_new,
 			     struct sched_domain_attr *dattr_new)
 {
-	int i, j;
+	int i, j, n;
 
 	mutex_lock(&sched_domains_mutex);
 
 	/* always unregister in case we don't destroy any domains */
 	unregister_sched_domain_sysctl();
 
-	if (doms_new == NULL)
-		ndoms_new = 0;
+	n = doms_new ? ndoms_new : 0;
 
 	/* Destroy deleted domains */
 	for (i = 0; i < ndoms_cur; i++) {
-		for (j = 0; j < ndoms_new; j++) {
+		for (j = 0; j < n; j++) {
 			if (cpus_equal(doms_cur[i], doms_new[j])
 			    && dattrs_equal(dattr_cur, i, dattr_new, j))
 				goto match1;
@@ -7726,7 +7729,6 @@ match1:
 
 	if (doms_new == NULL) {
 		ndoms_cur = 0;
-		ndoms_new = 1;
 		doms_new = &fallback_doms;
 		cpus_andnot(doms_new[0], cpu_online_map, cpu_isolated_map);
 		dattr_new = NULL;
@@ -7763,8 +7765,13 @@ match2:
 int arch_reinit_sched_domains(void)
 {
 	get_online_cpus();
+
+	/* Destroy domains first to force the rebuild */
+	partition_sched_domains(0, NULL, NULL);
+
 	rebuild_sched_domains();
 	put_online_cpus();
+
 	return 0;
 }
 
@@ -7848,7 +7855,7 @@ static int update_sched_domains(struct notifier_block *nfb,
 	case CPU_ONLINE_FROZEN:
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
-		partition_sched_domains(0, NULL, NULL);
+		partition_sched_domains(1, NULL, NULL);
 		return NOTIFY_OK;
 
 	default:
