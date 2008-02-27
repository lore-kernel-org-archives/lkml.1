Return-Path: <linux-kernel-owner+w=401wt.eu-S1760966AbYB0W0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760966AbYB0W0e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 17:26:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750934AbYB0W0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 17:26:24 -0500
Received: from viefep31-int.chello.at ([62.179.121.49]:56636 "EHLO
	viefep31-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696AbYB0W0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 17:26:23 -0500
Message-Id: <20080227222542.311184000@chello.nl>
References: <20080227222103.673194000@chello.nl>
User-Agent: quilt/0.45-1
Date: Wed, 27 Feb 2008 23:21:05 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Oleg Nesterov <oleg@tv-sign.ru>, Steven Rostedt <rostedt@goodmis.org>,
       Paul Jackson <pj@sgi.com>, Max Krasnyanskiy <maxk@qualcomm.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC/PATCH 2/4] cpuset: system sets
Content-Disposition: inline; filename=cpuset-system.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce the notion of a System set. A system set will be one that caters the
general purpose OS. This patch provides the infrastructure, but doesn't
actually provide any new functionality.

Typical functionality would be setting the IRQ affinity of unbound IRQs to
within the system set. And setting the affinity of unbounded kernel threads to
within the system set.

Future patches will provide this.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/cpumask.h |    5 ++
 include/linux/cpuset.h  |    2 
 kernel/cpuset.c         |  115 +++++++++++++++++++++++++++++++++++++++++++++++-
 kernel/sched.c          |    3 +
 4 files changed, 124 insertions(+), 1 deletion(-)

Index: linux-2.6/kernel/cpuset.c
===================================================================
--- linux-2.6.orig/kernel/cpuset.c
+++ linux-2.6/kernel/cpuset.c
@@ -64,6 +64,7 @@
  * short circuit some hooks.
  */
 int number_of_cpusets __read_mostly;
+int number_of_system_sets __read_mostly;
 
 /* Forward declare cgroup structures */
 struct cgroup_subsys cpuset_subsys;
@@ -128,6 +129,7 @@ typedef enum {
 	CS_SCHED_LOAD_BALANCE,
 	CS_SPREAD_PAGE,
 	CS_SPREAD_SLAB,
+	CS_SYSTEM,
 } cpuset_flagbits_t;
 
 /* convenient tests for these bits */
@@ -161,6 +163,11 @@ static inline int is_spread_slab(const s
 	return test_bit(CS_SPREAD_SLAB, &cs->flags);
 }
 
+static inline int is_system(const struct cpuset *cs)
+{
+	return test_bit(CS_SYSTEM, &cs->flags);
+}
+
 /*
  * Increment this integer everytime any cpuset changes its
  * mems_allowed value.  Users of cpusets can track this generation
@@ -183,7 +190,9 @@ static inline int is_spread_slab(const s
 static int cpuset_mems_generation;
 
 static struct cpuset top_cpuset = {
-	.flags = ((1 << CS_CPU_EXCLUSIVE) | (1 << CS_MEM_EXCLUSIVE)),
+	.flags = ((1 << CS_CPU_EXCLUSIVE) |
+		  (1 << CS_MEM_EXCLUSIVE) |
+		  (1 << CS_SYSTEM)),
 	.cpus_allowed = CPU_MASK_ALL,
 	.mems_allowed = NODE_MASK_ALL,
 };
@@ -465,6 +474,9 @@ static int validate_change(const struct 
 		}
 	}
 
+	if (number_of_system_sets == 1 && is_system(cur) && !is_system(trial))
+		return -EINVAL;
+
 	return 0;
 }
 
@@ -1011,6 +1023,74 @@ static int update_memory_pressure_enable
 	return 0;
 }
 
+BLOCKING_NOTIFIER_HEAD(system_map_notifier);
+EXPORT_SYMBOL_GPL(system_map_notifier);
+
+int cpus_match_system(cpumask_t mask)
+{
+	cpumask_t online_system, online_mask;
+
+	cpus_and(online_system, cpu_system_map, cpu_online_map);
+	cpus_and(online_mask, mask, cpu_online_map);
+
+	return cpus_equal(online_system, online_mask);
+}
+
+static void rebuild_system_map(void)
+{
+	cpumask_t *new_system_map;
+	struct kfifo *q = NULL;
+	struct cpuset *cp;
+
+	new_system_map = kmalloc(sizeof(cpumask_t), GFP_KERNEL);
+	if (!new_system_map)
+		return;
+
+	if (is_system(&top_cpuset)) {
+		cpus_setall(*new_system_map);
+		goto notify;
+	}
+
+	cpus_clear(*new_system_map);
+
+	q = kfifo_alloc(number_of_cpusets * sizeof(cp), GFP_KERNEL, NULL);
+	if (IS_ERR(q))
+		goto done;
+
+	cp = &top_cpuset;
+	__kfifo_put(q, (void *)&cp, sizeof(cp));
+	while (__kfifo_get(q, (void *)&cp, sizeof(cp))) {
+		struct cgroup *cont;
+		struct cpuset *child;
+
+		if (is_system(cp)) {
+			cpus_or(*new_system_map,
+					*new_system_map, cp->cpus_allowed);
+			continue;
+		}
+
+		list_for_each_entry(cont, &cp->css.cgroup->children, sibling) {
+			child = cgroup_cs(cont);
+			__kfifo_put(q, (void *)&child, sizeof(cp));
+		}
+	}
+
+	if (cpus_empty(*new_system_map))
+		BUG();
+
+notify:
+	if (!cpus_match_system(*new_system_map)) {
+		blocking_notifier_call_chain(&system_map_notifier, 0,
+				new_system_map);
+	}
+	cpu_system_map = *new_system_map;
+
+done:
+	kfree(new_system_map);
+	if (q && !IS_ERR(q))
+		kfifo_free(q);
+}
+
 /*
  * update_flag - read a 0 or a 1 in a file and update associated flag
  * bit:	the bit to update (CS_CPU_EXCLUSIVE, CS_MEM_EXCLUSIVE,
@@ -1029,6 +1109,7 @@ static int update_flag(cpuset_flagbits_t
 	struct cpuset trialcs;
 	int err;
 	int cpus_nonempty, balance_flag_changed;
+	int system_flag_changed;
 
 	turning_on = (simple_strtoul(buf, NULL, 10) != 0);
 
@@ -1045,6 +1126,7 @@ static int update_flag(cpuset_flagbits_t
 	cpus_nonempty = !cpus_empty(trialcs.cpus_allowed);
 	balance_flag_changed = (is_sched_load_balance(cs) !=
 		 			is_sched_load_balance(&trialcs));
+	system_flag_changed = (is_system(cs) != is_system(&trialcs));
 
 	mutex_lock(&callback_mutex);
 	cs->flags = trialcs.flags;
@@ -1053,6 +1135,15 @@ static int update_flag(cpuset_flagbits_t
 	if (cpus_nonempty && balance_flag_changed)
 		rebuild_sched_domains();
 
+	if (system_flag_changed) {
+		rebuild_system_map();
+
+		if (is_system(cs))
+			number_of_system_sets++;
+		else
+			number_of_system_sets--;
+	}
+
 	return 0;
 }
 
@@ -1206,6 +1297,7 @@ typedef enum {
 	FILE_MEMORY_PRESSURE,
 	FILE_SPREAD_PAGE,
 	FILE_SPREAD_SLAB,
+	FILE_SYSTEM,
 } cpuset_filetype_t;
 
 static ssize_t cpuset_common_file_write(struct cgroup *cont,
@@ -1273,6 +1365,9 @@ static ssize_t cpuset_common_file_write(
 		retval = update_flag(CS_SPREAD_SLAB, cs, buffer);
 		cs->mems_generation = cpuset_mems_generation++;
 		break;
+	case FILE_SYSTEM:
+		retval = update_flag(CS_SYSTEM, cs, buffer);
+		break;
 	default:
 		retval = -EINVAL;
 		goto out2;
@@ -1369,6 +1464,9 @@ static ssize_t cpuset_common_file_read(s
 	case FILE_SPREAD_SLAB:
 		*s++ = is_spread_slab(cs) ? '1' : '0';
 		break;
+	case FILE_SYSTEM:
+		*s++ = is_system(cs) ? '1' : '0';
+		break;
 	default:
 		retval = -EINVAL;
 		goto out;
@@ -1459,6 +1557,13 @@ static struct cftype cft_spread_slab = {
 	.private = FILE_SPREAD_SLAB,
 };
 
+static struct cftype cft_system = {
+	.name = "system",
+	.read = cpuset_common_file_read,
+	.write = cpuset_common_file_write,
+	.private = FILE_SYSTEM,
+};
+
 static int cpuset_populate(struct cgroup_subsys *ss, struct cgroup *cont)
 {
 	int err;
@@ -1481,6 +1586,8 @@ static int cpuset_populate(struct cgroup
 		return err;
 	if ((err = cgroup_add_file(cont, ss, &cft_spread_slab)) < 0)
 		return err;
+	if ((err = cgroup_add_file(cont, ss, &cft_system)) < 0)
+		return err;
 	/* memory_pressure_enabled is in root cpuset only */
 	if (err == 0 && !cont->parent)
 		err = cgroup_add_file(cont, ss,
@@ -1555,6 +1662,7 @@ static struct cgroup_subsys_state *cpuse
 	if (is_spread_slab(parent))
 		set_bit(CS_SPREAD_SLAB, &cs->flags);
 	set_bit(CS_SCHED_LOAD_BALANCE, &cs->flags);
+	set_bit(CS_SYSTEM, &cs->flags);
 	cs->cpus_allowed = CPU_MASK_NONE;
 	cs->mems_allowed = NODE_MASK_NONE;
 	cs->mems_generation = cpuset_mems_generation++;
@@ -1562,6 +1670,7 @@ static struct cgroup_subsys_state *cpuse
 
 	cs->parent = parent;
 	number_of_cpusets++;
+	number_of_system_sets++;
 	return &cs->css ;
 }
 
@@ -1585,8 +1694,11 @@ static void cpuset_destroy(struct cgroup
 
 	if (is_sched_load_balance(cs))
 		update_flag(CS_SCHED_LOAD_BALANCE, cs, "0");
+	if (!is_system(cs))
+		update_flag(CS_SYSTEM, cs, "1");
 
 	number_of_cpusets--;
+	number_of_system_sets--;
 	kfree(cs);
 }
 
@@ -1637,6 +1749,7 @@ int __init cpuset_init(void)
 		return err;
 
 	number_of_cpusets = 1;
+	number_of_system_sets = 1;
 	return 0;
 }
 
Index: linux-2.6/include/linux/cpumask.h
===================================================================
--- linux-2.6.orig/include/linux/cpumask.h
+++ linux-2.6/include/linux/cpumask.h
@@ -380,6 +380,7 @@ static inline void __cpus_remap(cpumask_
 extern cpumask_t cpu_possible_map;
 extern cpumask_t cpu_online_map;
 extern cpumask_t cpu_present_map;
+extern cpumask_t cpu_system_map;
 
 #if NR_CPUS > 1
 #define num_online_cpus()	cpus_weight(cpu_online_map)
@@ -388,6 +389,7 @@ extern cpumask_t cpu_present_map;
 #define cpu_online(cpu)		cpu_isset((cpu), cpu_online_map)
 #define cpu_possible(cpu)	cpu_isset((cpu), cpu_possible_map)
 #define cpu_present(cpu)	cpu_isset((cpu), cpu_present_map)
+#define cpu_system(cpu)		cpu_isset((cpu), cpu_system_map)
 #else
 #define num_online_cpus()	1
 #define num_possible_cpus()	1
@@ -395,8 +397,11 @@ extern cpumask_t cpu_present_map;
 #define cpu_online(cpu)		((cpu) == 0)
 #define cpu_possible(cpu)	((cpu) == 0)
 #define cpu_present(cpu)	((cpu) == 0)
+#define cpu_system(cpu)		((cpu) == 0)
 #endif
 
+extern int cpus_match_system(cpumask_t mask);
+
 #define cpu_is_offline(cpu)	unlikely(!cpu_online(cpu))
 
 #ifdef CONFIG_SMP
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -4854,6 +4854,9 @@ asmlinkage long sys_sched_setaffinity(pi
 cpumask_t cpu_present_map __read_mostly;
 EXPORT_SYMBOL(cpu_present_map);
 
+cpumask_t cpu_system_map __read_mostly = CPU_MASK_ALL;
+EXPORT_SYMBOL(cpu_system_map);
+
 #ifndef CONFIG_SMP
 cpumask_t cpu_online_map __read_mostly = CPU_MASK_ALL;
 EXPORT_SYMBOL(cpu_online_map);
Index: linux-2.6/include/linux/cpuset.h
===================================================================
--- linux-2.6.orig/include/linux/cpuset.h
+++ linux-2.6/include/linux/cpuset.h
@@ -78,6 +78,8 @@ extern void cpuset_track_online_nodes(vo
 
 extern int current_cpuset_is_being_rebound(void);
 
+extern struct blocking_notifier_head system_map_notifier;
+
 #else /* !CONFIG_CPUSETS */
 
 static inline int cpuset_init_early(void) { return 0; }

--

