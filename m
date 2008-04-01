Return-Path: <linux-kernel-owner+w=401wt.eu-S1758926AbYDAL2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758926AbYDAL2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 07:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756895AbYDAL2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 07:28:06 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59620 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756902AbYDAL2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 07:28:04 -0400
Message-ID: <47F21C38.8090608@jp.fujitsu.com>
Date: Tue, 01 Apr 2008 20:27:52 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] Customize sched domain via cpuset
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The implementation is here.

 - Add 2 new cpuset files:
     sched_wake_idle_far
     sched_balance_newidle_far

 - Modify partition_sched_domains() and build_sched_domains()
   to take flags parameter passed from cpuset.

 - Fill newidle_idx for node domains which currently unused but
   might be required for sched_balance_newidle_far.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

---
 include/asm-ia64/topology.h |    2
 include/asm-sh/topology.h   |    2
 include/asm-x86/topology.h  |    2
 include/linux/sched.h       |    4 +
 kernel/cpuset.c             |   89 ++++++++++++++++++++++++++++++++++++++++++--
 kernel/sched.c              |   38 ++++++++++++++++--
 kernel/sched_fair.c         |    4 +
 7 files changed, 128 insertions(+), 13 deletions(-)

Index: GIT-torvalds/kernel/sched_fair.c
===================================================================
--- GIT-torvalds.orig/kernel/sched_fair.c
+++ GIT-torvalds/kernel/sched_fair.c
@@ -957,7 +957,9 @@ static int wake_idle(int cpu, struct tas
 		return cpu;

 	for_each_domain(cpu, sd) {
-		if (sd->flags & SD_WAKE_IDLE) {
+		if ((sd->flags & SD_WAKE_IDLE)
+		    || ((sd->flags & SD_WAKE_IDLE_FAR)
+			&& !task_hot(p, task_rq(p)->clock, sd))) {
 			cpus_and(tmp, sd->span, p->cpus_allowed);
 			for_each_cpu_mask(i, tmp) {
 				if (idle_cpu(i)) {
Index: GIT-torvalds/kernel/cpuset.c
===================================================================
--- GIT-torvalds.orig/kernel/cpuset.c
+++ GIT-torvalds/kernel/cpuset.c
@@ -126,6 +126,8 @@ typedef enum {
 	CS_MEM_EXCLUSIVE,
 	CS_MEMORY_MIGRATE,
 	CS_SCHED_LOAD_BALANCE,
+	CS_SCHED_BALANCE_NEWIDLE_FAR,
+	CS_SCHED_WAKE_IDLE_FAR,
 	CS_SPREAD_PAGE,
 	CS_SPREAD_SLAB,
 } cpuset_flagbits_t;
@@ -146,6 +148,16 @@ static inline int is_sched_load_balance(
 	return test_bit(CS_SCHED_LOAD_BALANCE, &cs->flags);
 }

+static inline int is_sched_balance_newidle_far(const struct cpuset *cs)
+{
+	return test_bit(CS_SCHED_BALANCE_NEWIDLE_FAR, &cs->flags);
+}
+
+static inline int is_sched_wake_idle_far(const struct cpuset *cs)
+{
+	return test_bit(CS_SCHED_WAKE_IDLE_FAR, &cs->flags);
+}
+
 static inline int is_memory_migrate(const struct cpuset *cs)
 {
 	return test_bit(CS_MEMORY_MIGRATE, &cs->flags);
@@ -161,6 +173,11 @@ static inline int is_spread_slab(const s
 	return test_bit(CS_SPREAD_SLAB, &cs->flags);
 }

+static inline int is_sched_custom_domain(const struct cpuset *cs)
+{
+	return is_sched_balance_newidle_far(cs) || is_sched_wake_idle_far(cs);
+}
+
 /*
  * Increment this integer everytime any cpuset changes its
  * mems_allowed value.  Users of cpusets can track this generation
@@ -553,12 +570,14 @@ static void rebuild_sched_domains(void)
 	int csn;		/* how many cpuset ptrs in csa so far */
 	int i, j, k;		/* indices for partition finding loops */
 	cpumask_t *doms;	/* resulting partition; i.e. sched domains */
+	int *flags;		/* flags for custom sched domains */
 	int ndoms;		/* number of sched domains in result */
 	int nslot;		/* next empty doms[] cpumask_t slot */

 	q = NULL;
 	csa = NULL;
 	doms = NULL;
+	flags = NULL;

 	/* Special case for the 99% of systems with one, full, sched domain */
 	if (is_sched_load_balance(&top_cpuset)) {
@@ -566,6 +585,13 @@ static void rebuild_sched_domains(void)
 		doms = kmalloc(sizeof(cpumask_t), GFP_KERNEL);
 		if (!doms)
 			goto rebuild;
+		if (is_sched_custom_domain(&top_cpuset)) {
+			flags = kzalloc(sizeof(int), GFP_KERNEL);
+			if (flags && is_sched_balance_newidle_far(&top_cpuset))
+				*flags |= SD_BALANCE_NEWIDLE;
+			if (flags && is_sched_wake_idle_far(&top_cpuset))
+				*flags |= SD_WAKE_IDLE_FAR;
+		}
 		*doms = top_cpuset.cpus_allowed;
 		goto rebuild;
 	}
@@ -622,6 +648,7 @@ restart:
 	doms = kmalloc(ndoms * sizeof(cpumask_t), GFP_KERNEL);
 	if (!doms)
 		goto rebuild;
+	flags = kzalloc(ndoms * sizeof(int), GFP_KERNEL);

 	for (nslot = 0, i = 0; i < csn; i++) {
 		struct cpuset *a = csa[i];
@@ -650,6 +677,13 @@ restart:
 				if (apn == b->pn) {
 					cpus_or(*dp, *dp, b->cpus_allowed);
 					b->pn = -1;
+					if (flags
+					    && is_sched_balance_newidle_far(b))
+						*(flags + nslot) |=
+							SD_BALANCE_NEWIDLE;
+					if (flags && is_sched_wake_idle_far(b))
+						*(flags + nslot) |=
+							SD_WAKE_IDLE_FAR;
 				}
 			}
 			nslot++;
@@ -660,7 +694,7 @@ restart:
 rebuild:
 	/* Have scheduler rebuild sched domains */
 	get_online_cpus();
-	partition_sched_domains(ndoms, doms);
+	partition_sched_domains(ndoms, doms, flags);
 	put_online_cpus();

 done:
@@ -668,6 +702,7 @@ done:
 		kfifo_free(q);
 	kfree(csa);
 	/* Don't kfree(doms) -- partition_sched_domains() does that. */
+	/* Don't kfree(flags) -- partition_sched_domains() does that. */
 }

 static inline int started_after_time(struct task_struct *t1,
@@ -1011,10 +1046,26 @@ static int update_memory_pressure_enable
 	return 0;
 }

+static int need_rebuild_domains(struct cpuset *cs, struct cpuset *tcs)
+{
+	if (is_sched_load_balance(cs) != is_sched_load_balance(tcs))
+		return 1;
+	if (!is_sched_load_balance(tcs))
+		return 0;
+	if (is_sched_balance_newidle_far(cs) !=
+					is_sched_balance_newidle_far(tcs))
+		return 1;
+	if (is_sched_wake_idle_far(cs) != is_sched_wake_idle_far(tcs))
+		return 1;
+	return 0;
+}
+
 /*
  * update_flag - read a 0 or a 1 in a file and update associated flag
  * bit:	the bit to update (CS_CPU_EXCLUSIVE, CS_MEM_EXCLUSIVE,
  *				CS_SCHED_LOAD_BALANCE,
+ *				CS_SCHED_BALANCE_NEW_IDLE_FAR,
+ *				CS_SCHED_WAKE_IDLE_FAR,
  *				CS_NOTIFY_ON_RELEASE, CS_MEMORY_MIGRATE,
  *				CS_SPREAD_PAGE, CS_SPREAD_SLAB)
  * cs:	the cpuset to update
@@ -1043,8 +1094,7 @@ static int update_flag(cpuset_flagbits_t
 		return err;

 	cpus_nonempty = !cpus_empty(trialcs.cpus_allowed);
-	balance_flag_changed = (is_sched_load_balance(cs) !=
-		 			is_sched_load_balance(&trialcs));
+	balance_flag_changed = need_rebuild_domains(cs, &trialcs);

 	mutex_lock(&callback_mutex);
 	cs->flags = trialcs.flags;
@@ -1202,6 +1252,8 @@ typedef enum {
 	FILE_CPU_EXCLUSIVE,
 	FILE_MEM_EXCLUSIVE,
 	FILE_SCHED_LOAD_BALANCE,
+	FILE_SCHED_BALANCE_NEWIDLE_FAR,
+	FILE_SCHED_WAKE_IDLE_FAR,
 	FILE_MEMORY_PRESSURE_ENABLED,
 	FILE_MEMORY_PRESSURE,
 	FILE_SPREAD_PAGE,
@@ -1256,6 +1308,12 @@ static ssize_t cpuset_common_file_write(
 	case FILE_SCHED_LOAD_BALANCE:
 		retval = update_flag(CS_SCHED_LOAD_BALANCE, cs, buffer);
 		break;
+	case FILE_SCHED_BALANCE_NEWIDLE_FAR:
+		retval = update_flag(CS_SCHED_BALANCE_NEWIDLE_FAR, cs, buffer);
+		break;
+	case FILE_SCHED_WAKE_IDLE_FAR:
+		retval = update_flag(CS_SCHED_WAKE_IDLE_FAR, cs, buffer);
+		break;
 	case FILE_MEMORY_MIGRATE:
 		retval = update_flag(CS_MEMORY_MIGRATE, cs, buffer);
 		break;
@@ -1354,6 +1412,12 @@ static ssize_t cpuset_common_file_read(s
 	case FILE_SCHED_LOAD_BALANCE:
 		*s++ = is_sched_load_balance(cs) ? '1' : '0';
 		break;
+	case FILE_SCHED_BALANCE_NEWIDLE_FAR:
+		*s++ = is_sched_balance_newidle_far(cs) ? '1' : '0';
+		break;
+	case FILE_SCHED_WAKE_IDLE_FAR:
+		*s++ = is_sched_wake_idle_far(cs) ? '1' : '0';
+		break;
 	case FILE_MEMORY_MIGRATE:
 		*s++ = is_memory_migrate(cs) ? '1' : '0';
 		break;
@@ -1424,6 +1488,20 @@ static struct cftype cft_sched_load_bala
 	.private = FILE_SCHED_LOAD_BALANCE,
 };

+static struct cftype cft_sched_balance_newidle_far = {
+	.name = "sched_balance_newidle_far",
+	.read = cpuset_common_file_read,
+	.write = cpuset_common_file_write,
+	.private = FILE_SCHED_BALANCE_NEWIDLE_FAR,
+};
+
+static struct cftype cft_sched_wake_idle_far = {
+	.name = "sched_wake_idle_far",
+	.read = cpuset_common_file_read,
+	.write = cpuset_common_file_write,
+	.private = FILE_SCHED_WAKE_IDLE_FAR,
+};
+
 static struct cftype cft_memory_migrate = {
 	.name = "memory_migrate",
 	.read = cpuset_common_file_read,
@@ -1475,6 +1553,11 @@ static int cpuset_populate(struct cgroup
 		return err;
 	if ((err = cgroup_add_file(cont, ss, &cft_sched_load_balance)) < 0)
 		return err;
+	if ((err = cgroup_add_file(cont, ss,
+					&cft_sched_balance_newidle_far)) < 0)
+		return err;
+	if ((err = cgroup_add_file(cont, ss, &cft_sched_wake_idle_far)) < 0)
+		return err;
 	if ((err = cgroup_add_file(cont, ss, &cft_memory_pressure)) < 0)
 		return err;
 	if ((err = cgroup_add_file(cont, ss, &cft_spread_page)) < 0)
Index: GIT-torvalds/include/linux/sched.h
===================================================================
--- GIT-torvalds.orig/include/linux/sched.h
+++ GIT-torvalds/include/linux/sched.h
@@ -704,6 +704,7 @@ enum cpu_idle_type {
 #define SD_POWERSAVINGS_BALANCE	256	/* Balance for power savings */
 #define SD_SHARE_PKG_RESOURCES	512	/* Domain members share cpu pkg resources */
 #define SD_SERIALIZE		1024	/* Only a single load balancing instance */
+#define SD_WAKE_IDLE_FAR	2048	/* Gain latency sacrificing cache hit */

 #define BALANCE_FOR_MC_POWER	\
 	(sched_smt_power_savings ? SD_POWERSAVINGS_BALANCE : 0)
@@ -789,7 +790,8 @@ struct sched_domain {
 #endif
 };

-extern void partition_sched_domains(int ndoms_new, cpumask_t *doms_new);
+extern void partition_sched_domains(int ndoms_new, cpumask_t *doms_new,
+				    int *flags_new);
 extern int arch_reinit_sched_domains(void);

 #endif	/* CONFIG_SMP */
Index: GIT-torvalds/kernel/sched.c
===================================================================
--- GIT-torvalds.orig/kernel/sched.c
+++ GIT-torvalds/kernel/sched.c
@@ -6586,7 +6586,7 @@ static void init_sched_groups_power(int
  * Build sched domains for a given set of cpus and attach the sched domains
  * to the individual cpus
  */
-static int build_sched_domains(const cpumask_t *cpu_map)
+static int __build_sched_domains(const cpumask_t *cpu_map, int flags)
 {
 	int i;
 	struct root_domain *rd;
@@ -6627,6 +6627,7 @@ static int build_sched_domains(const cpu
 			sd = &per_cpu(allnodes_domains, i);
 			*sd = SD_ALLNODES_INIT;
 			sd->span = *cpu_map;
+			/* prohibit "sd->flags |= flags" for allnodes_domain */
 			cpu_to_allnodes_group(i, cpu_map, &sd->groups);
 			p = sd;
 			sd_allnodes = 1;
@@ -6636,6 +6637,7 @@ static int build_sched_domains(const cpu
 		sd = &per_cpu(node_domains, i);
 		*sd = SD_NODE_INIT;
 		sd->span = sched_domain_node_span(cpu_to_node(i));
+		sd->flags |= flags;
 		sd->parent = p;
 		if (p)
 			p->child = sd;
@@ -6646,6 +6648,7 @@ static int build_sched_domains(const cpu
 		sd = &per_cpu(phys_domains, i);
 		*sd = SD_CPU_INIT;
 		sd->span = nodemask;
+		sd->flags |= flags;
 		sd->parent = p;
 		if (p)
 			p->child = sd;
@@ -6657,6 +6660,7 @@ static int build_sched_domains(const cpu
 		*sd = SD_MC_INIT;
 		sd->span = cpu_coregroup_map(i);
 		cpus_and(sd->span, sd->span, *cpu_map);
+		sd->flags |= flags;
 		sd->parent = p;
 		p->child = sd;
 		cpu_to_core_group(i, cpu_map, &sd->groups);
@@ -6668,6 +6672,7 @@ static int build_sched_domains(const cpu
 		*sd = SD_SIBLING_INIT;
 		sd->span = per_cpu(cpu_sibling_map, i);
 		cpus_and(sd->span, sd->span, *cpu_map);
+		sd->flags |= flags;
 		sd->parent = p;
 		p->child = sd;
 		cpu_to_cpu_group(i, cpu_map, &sd->groups);
@@ -6840,8 +6845,14 @@ error:
 #endif
 }

+static int build_sched_domains(const cpumask_t *cpu_map)
+{
+	return __build_sched_domains(cpu_map, 0);
+}
+
 static cpumask_t *doms_cur;	/* current sched domains */
 static int ndoms_cur;		/* number of sched domains in 'doms_cur' */
+static int *flags_cur;		/* custom flags of domains in 'doms_cur' */

 /*
  * Special case: If a kmalloc of a doms_cur partition (array of
@@ -6868,6 +6879,7 @@ static int arch_init_sched_domains(const
 	doms_cur = kmalloc(sizeof(cpumask_t), GFP_KERNEL);
 	if (!doms_cur)
 		doms_cur = &fallback_doms;
+	flags_cur = NULL;
 	cpus_andnot(*doms_cur, *cpu_map, cpu_isolated_map);
 	err = build_sched_domains(doms_cur);
 	register_sched_domain_sysctl();
@@ -6896,6 +6908,16 @@ static void detach_destroy_domains(const
 	arch_destroy_sched_domains(cpu_map);
 }

+/* handle null as 0s array */
+static inline int flags_equal(int *cur, int idx_cur, int *new, int idx_new)
+{
+	if (!new)
+		return (!cur || !cur[idx_cur]);
+	if (!cur)
+		return (!new[idx_new]);
+	return (cur[idx_cur] == new[idx_new]);
+}
+
 /*
  * Partition sched domains as specified by the 'ndoms_new'
  * cpumasks in the array doms_new[] of cpumasks. This compares
@@ -6917,7 +6939,7 @@ static void detach_destroy_domains(const
  *
  * Call with hotplug lock held
  */
-void partition_sched_domains(int ndoms_new, cpumask_t *doms_new)
+void partition_sched_domains(int ndoms_new, cpumask_t *doms_new, int *flags_new)
 {
 	int i, j;

@@ -6929,13 +6951,15 @@ void partition_sched_domains(int ndoms_n
 	if (doms_new == NULL) {
 		ndoms_new = 1;
 		doms_new = &fallback_doms;
+		flags_new = NULL;
 		cpus_andnot(doms_new[0], cpu_online_map, cpu_isolated_map);
 	}

 	/* Destroy deleted domains */
 	for (i = 0; i < ndoms_cur; i++) {
 		for (j = 0; j < ndoms_new; j++) {
-			if (cpus_equal(doms_cur[i], doms_new[j]))
+			if (cpus_equal(doms_cur[i], doms_new[j])
+			    && flags_equal(flags_cur, i, flags_new, j))
 				goto match1;
 		}
 		/* no match - a current sched domain not in new doms_new[] */
@@ -6947,11 +6971,13 @@ match1:
 	/* Build new domains */
 	for (i = 0; i < ndoms_new; i++) {
 		for (j = 0; j < ndoms_cur; j++) {
-			if (cpus_equal(doms_new[i], doms_cur[j]))
+			if (cpus_equal(doms_new[i], doms_cur[j])
+			    && flags_equal(flags_new, i, flags_cur, j))
 				goto match2;
 		}
 		/* no match - add a new doms_new */
-		build_sched_domains(doms_new + i);
+		__build_sched_domains(doms_new + i,
+					flags_new ? flags_new[i] : 0);
 match2:
 		;
 	}
@@ -6959,7 +6985,9 @@ match2:
 	/* Remember the new sched domains */
 	if (doms_cur != &fallback_doms)
 		kfree(doms_cur);
+	kfree(flags_cur);	/* kfree(NULL) is safe */
 	doms_cur = doms_new;
+	flags_cur = flags_new;
 	ndoms_cur = ndoms_new;

 	register_sched_domain_sysctl();
Index: GIT-torvalds/include/asm-ia64/topology.h
===================================================================
--- GIT-torvalds.orig/include/asm-ia64/topology.h
+++ GIT-torvalds/include/asm-ia64/topology.h
@@ -93,7 +93,7 @@ void build_cpu_to_node_map(void);
 	.cache_nice_tries	= 2,			\
 	.busy_idx		= 3,			\
 	.idle_idx		= 2,			\
-	.newidle_idx		= 0, /* unused */	\
+	.newidle_idx		= 2,			\
 	.wake_idx		= 1,			\
 	.forkexec_idx		= 1,			\
 	.flags			= SD_LOAD_BALANCE	\
Index: GIT-torvalds/include/asm-sh/topology.h
===================================================================
--- GIT-torvalds.orig/include/asm-sh/topology.h
+++ GIT-torvalds/include/asm-sh/topology.h
@@ -16,7 +16,7 @@
 	.cache_nice_tries	= 2,			\
 	.busy_idx		= 3,			\
 	.idle_idx		= 2,			\
-	.newidle_idx		= 0,			\
+	.newidle_idx		= 2,			\
 	.wake_idx		= 1,			\
 	.forkexec_idx		= 1,			\
 	.flags			= SD_LOAD_BALANCE	\
Index: GIT-torvalds/include/asm-x86/topology.h
===================================================================
--- GIT-torvalds.orig/include/asm-x86/topology.h
+++ GIT-torvalds/include/asm-x86/topology.h
@@ -129,7 +129,7 @@ extern unsigned long node_remap_size[];

 # define SD_CACHE_NICE_TRIES	2
 # define SD_IDLE_IDX		2
-# define SD_NEWIDLE_IDX		0
+# define SD_NEWIDLE_IDX		2
 # define SD_FORKEXEC_IDX	1

 #endif

