Return-Path: <linux-kernel-owner+w=401wt.eu-S1760533AbYELI1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760533AbYELI1c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 04:27:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757932AbYELI1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 04:27:17 -0400
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:51305 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756209AbYELI1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 04:27:12 -0400
Date: Mon, 12 May 2008 13:57:00 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH]sched: Add comments for ifdefs in sched.c
Message-ID: <20080512082700.GD3878@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I was going to through sched.c after some time, and found it really
tough to read through it with the number of ifdefs. Adding some comments
marking the #else and #endif for what they are (not) defining.

Thanks,
--
sched: Add comments for ifdefs in sched.c

sched.c is quite difficult to read anyway. With the number of ifdefs
especially those of the nested variety, it was a bigger challenge. This
patch finds and comments some of those ifdefs.

Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c	2008-05-12 11:03:59.000000000 +0530
+++ linux-2.6/kernel/sched.c	2008-05-12 13:52:07.000000000 +0530
@@ -289,15 +289,15 @@ struct task_group root_task_group;
 static DEFINE_PER_CPU(struct sched_entity, init_sched_entity);
 /* Default task group's cfs_rq on each cpu */
 static DEFINE_PER_CPU(struct cfs_rq, init_cfs_rq) ____cacheline_aligned_in_smp;
-#endif
+#endif /* CONFIG_FAIR_GROUP_SCHED */
 
 #ifdef CONFIG_RT_GROUP_SCHED
 static DEFINE_PER_CPU(struct sched_rt_entity, init_sched_rt_entity);
 static DEFINE_PER_CPU(struct rt_rq, init_rt_rq) ____cacheline_aligned_in_smp;
-#endif
-#else
+#endif /* CONFIG_RT_GROUP_SCHED */
+#else /* !CONFIG_FAIR_GROUP_SCHED */
 #define root_task_group init_task_group
-#endif
+#endif /* CONFIG_FAIR_GROUP_SCHED */
 
 /* task_group_lock serializes add/remove of task groups and also changes to
  * a task group's cpu shares.
@@ -307,9 +307,9 @@ static DEFINE_SPINLOCK(task_group_lock);
 #ifdef CONFIG_FAIR_GROUP_SCHED
 #ifdef CONFIG_USER_SCHED
 # define INIT_TASK_GROUP_LOAD	(2*NICE_0_LOAD)
-#else
+#else /* !CONFIG_USER_SCHED */
 # define INIT_TASK_GROUP_LOAD	NICE_0_LOAD
-#endif
+#endif /* CONFIG_USER_SCHED */
 
 /*
  * A weight of 0, 1 or ULONG_MAX can cause arithmetics problems.
@@ -434,8 +434,8 @@ struct cfs_rq {
 		 */
 		unsigned long task_weight;
 	} aggregate;
-#endif
-#endif
+#endif /* CONFIG_SMP */
+#endif /* CONFIG_FAIR_GROUP_SCHED */
 };
 
 /* Real-Time classes' related field in a runqueue: */
@@ -1345,15 +1345,15 @@ void wake_up_idle_cpu(int cpu)
 	if (!tsk_is_polling(rq->idle))
 		smp_send_reschedule(cpu);
 }
-#endif
+#endif /* CONFIG_NO_HZ */
 
-#else
+#else /* !CONFIG_SMP */
 static void __resched_task(struct task_struct *p, int tif_bit)
 {
 	assert_spin_locked(&task_rq(p)->lock);
 	set_tsk_thread_flag(p, tif_bit);
 }
-#endif
+#endif /* CONFIG_SMP */
 
 #if BITS_PER_LONG == 32
 # define WMULT_CONST	(~0UL)
@@ -2463,7 +2463,7 @@ static int try_to_wake_up(struct task_st
 			}
 		}
 	}
-#endif
+#endif /* CONFIG_SCHEDSTATS */
 
 out_activate:
 #endif /* CONFIG_SMP */
@@ -2663,7 +2663,7 @@ fire_sched_out_preempt_notifiers(struct 
 		notifier->ops->sched_out(notifier, next);
 }
 
-#else
+#else /* !CONFIG_PREEMPT_NOTIFIERS */
 
 static void fire_sched_in_preempt_notifiers(struct task_struct *curr)
 {
@@ -2675,7 +2675,7 @@ fire_sched_out_preempt_notifiers(struct 
 {
 }
 
-#endif
+#endif /* CONFIG_PREEMPT_NOTIFIERS */
 
 /**
  * prepare_task_switch - prepare to switch tasks
@@ -6635,9 +6635,9 @@ static void sched_domain_debug(struct sc
 	}
 	kfree(groupmask);
 }
-#else
+#else /* !CONFIG_SCHED_DEBUG */
 # define sched_domain_debug(sd, cpu) do { } while (0)
-#endif
+#endif /* CONFIG_SCHED_DEBUG */
 
 static int sd_degenerate(struct sched_domain *sd)
 {
@@ -6931,7 +6931,7 @@ static void sched_domain_node_span(int n
 		cpus_or(*span, *span, *nodemask);
 	}
 }
-#endif
+#endif /* CONFIG_NUMA */
 
 int sched_smt_power_savings = 0, sched_mc_power_savings = 0;
 
@@ -6950,7 +6950,7 @@ cpu_to_cpu_group(int cpu, const cpumask_
 		*sg = &per_cpu(sched_group_cpus, cpu);
 	return cpu;
 }
-#endif
+#endif /* CONFIG_SCHED_SMT */
 
 /*
  * multi-core sched-domains:
@@ -6958,7 +6958,7 @@ cpu_to_cpu_group(int cpu, const cpumask_
 #ifdef CONFIG_SCHED_MC
 static DEFINE_PER_CPU(struct sched_domain, core_domains);
 static DEFINE_PER_CPU(struct sched_group, sched_group_core);
-#endif
+#endif /* CONFIG_SCHED_MC */
 
 #if defined(CONFIG_SCHED_MC) && defined(CONFIG_SCHED_SMT)
 static int
@@ -7060,7 +7060,7 @@ static void init_numa_sched_groups_power
 		sg = sg->next;
 	} while (sg != group_head);
 }
-#endif
+#endif /* CONFIG_NUMA */
 
 #ifdef CONFIG_NUMA
 /* Free memory allocated for various sched_group structures */
@@ -7097,11 +7097,11 @@ next_sg:
 		sched_group_nodes_bycpu[cpu] = NULL;
 	}
 }
-#else
+#else /* !CONFIG_NUMA */
 static void free_sched_groups(const cpumask_t *cpu_map, cpumask_t *nodemask)
 {
 }
-#endif
+#endif /* CONFIG_NUMA */
 
 /*
  * Initialize sched groups cpu_power.
@@ -7797,7 +7797,7 @@ int sched_create_sysfs_power_savings_ent
 #endif
 	return err;
 }
-#endif
+#endif /* CONFIG_SCHED_MC || CONFIG_SCHED_SMT */
 
 /*
  * Force a reinitialization of the sched domains hierarchy. The domains
@@ -8014,8 +8014,8 @@ void __init sched_init(void)
 
 		root_task_group.cfs_rq = (struct cfs_rq **)ptr;
 		ptr += nr_cpu_ids * sizeof(void **);
-#endif
-#endif
+#endif /* CONFIG_USER_SCHED */
+#endif /* CONFIG_FAIR_GROUP_SCHED */
 #ifdef CONFIG_RT_GROUP_SCHED
 		init_task_group.rt_se = (struct sched_rt_entity **)ptr;
 		ptr += nr_cpu_ids * sizeof(void **);
@@ -8029,8 +8029,8 @@ void __init sched_init(void)
 
 		root_task_group.rt_rq = (struct rt_rq **)ptr;
 		ptr += nr_cpu_ids * sizeof(void **);
-#endif
-#endif
+#endif /* CONFIG_USER_SCHED */
+#endif /* CONFIG_RT_GROUP_SCHED */
 	}
 
 #ifdef CONFIG_SMP
@@ -8047,8 +8047,8 @@ void __init sched_init(void)
 #ifdef CONFIG_USER_SCHED
 	init_rt_bandwidth(&root_task_group.rt_bandwidth,
 			global_rt_period(), RUNTIME_INF);
-#endif
-#endif
+#endif /* CONFIG_USER_SCHED */
+#endif /* CONFIG_RT_GROUP_SCHED */
 
 #ifdef CONFIG_GROUP_SCHED
 	list_add(&init_task_group.list, &task_groups);
@@ -8058,8 +8058,8 @@ void __init sched_init(void)
 	INIT_LIST_HEAD(&root_task_group.children);
 	init_task_group.parent = &root_task_group;
 	list_add(&init_task_group.siblings, &root_task_group.children);
-#endif
-#endif
+#endif /* CONFIG_USER_SCHED */
+#endif /* CONFIG_GROUP_SCHED */
 
 	for_each_possible_cpu(i) {
 		struct rq *rq;
@@ -8378,7 +8378,7 @@ static inline void unregister_fair_sched
 {
 	list_del_rcu(&tg->cfs_rq[cpu]->leaf_cfs_rq_list);
 }
-#else
+#else /* !CONFG_FAIR_GROUP_SCHED */
 static inline void free_fair_sched_group(struct task_group *tg)
 {
 }
@@ -8396,7 +8396,7 @@ static inline void register_fair_sched_g
 static inline void unregister_fair_sched_group(struct task_group *tg, int cpu)
 {
 }
-#endif
+#endif /* CONFIG_FAIR_GROUP_SCHED */
 
 #ifdef CONFIG_RT_GROUP_SCHED
 static void free_rt_sched_group(struct task_group *tg)
@@ -8467,7 +8467,7 @@ static inline void unregister_rt_sched_g
 {
 	list_del_rcu(&tg->rt_rq[cpu]->leaf_rt_rq_list);
 }
-#else
+#else /* !CONFIG_RT_GROUP_SCHED */
 static inline void free_rt_sched_group(struct task_group *tg)
 {
 }
@@ -8485,7 +8485,7 @@ static inline void register_rt_sched_gro
 static inline void unregister_rt_sched_group(struct task_group *tg, int cpu)
 {
 }
-#endif
+#endif /* CONFIG_RT_GROUP_SCHED */
 
 #ifdef CONFIG_GROUP_SCHED
 static void free_sched_group(struct task_group *tg)
@@ -8596,7 +8596,7 @@ void sched_move_task(struct task_struct 
 
 	task_rq_unlock(rq, &flags);
 }
-#endif
+#endif /* CONFIG_GROUP_SCHED */
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 static void __set_se_shares(struct sched_entity *se, unsigned long shares)
@@ -8857,7 +8857,7 @@ static int sched_rt_global_constraints(v
 
 	return ret;
 }
-#else
+#else /* !CONFIG_RT_GROUP_SCHED */
 static int sched_rt_global_constraints(void)
 {
 	unsigned long flags;
@@ -8875,7 +8875,7 @@ static int sched_rt_global_constraints(v
 
 	return 0;
 }
-#endif
+#endif /* CONFIG_RT_GROUP_SCHED */
 
 int sched_rt_handler(struct ctl_table *table, int write,
 		struct file *filp, void __user *buffer, size_t *lenp,
@@ -8983,7 +8983,7 @@ static u64 cpu_shares_read_u64(struct cg
 
 	return (u64) tg->shares;
 }
-#endif
+#endif /* CONFIG_FAIR_GROUP_SCHED */
 
 #ifdef CONFIG_RT_GROUP_SCHED
 static ssize_t cpu_rt_runtime_write(struct cgroup *cgrp, struct cftype *cft,
@@ -9007,7 +9007,7 @@ static u64 cpu_rt_period_read_uint(struc
 {
 	return sched_group_rt_period(cgroup_tg(cgrp));
 }
-#endif
+#endif /* CONFIG_RT_GROUP_SCHED */
 
 static struct cftype cpu_files[] = {
 #ifdef CONFIG_FAIR_GROUP_SCHED
-- 
regards,
Dhaval
