Return-Path: <linux-kernel-owner+w=401wt.eu-S935489AbXK3RJN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935489AbXK3RJN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 12:09:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934642AbXK3RIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 12:08:17 -0500
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:43070
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S935437AbXK3RIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 12:08:14 -0500
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 2/4] Subject: SCHED - Add sched-domain roots
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML 
	<"linux-kernel@vger.kernel.org>, linux-rt-users"@vger.kernel.org>,
       mingo@elte.hu
Date: Fri, 30 Nov 2007 11:46:54 -0500
Message-ID: <20071130164654.30588.29181.stgit@novell1.haskins.net>
In-Reply-To: <20071130163638.30588.47845.stgit@novell1.haskins.net>
References: <20071130163638.30588.47845.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We add the notion of a root-domain which will be used later to rescope
global variables to per-domain variables.  Each exclusive cpuset
essentially defines an island domain by fully partitioning the member cpus
from any other cpuset.  However, we currently still maintain some
policy/state as global variables which transcend all cpusets.  Consider,
for instance, rt-overload state.

Whenever a new exclusive cpuset is created, we also create a new
root-domain object and move each cpu member to the root-domain's span.
By default the system creates a single root-domain with all cpus as
members (mimicking the global state we have today).

We add some plumbing for storing class specific data in our root-domain.
Whenever a RQ is switching root-domains (because of repartitioning) we
give each sched_class the opportunity to remove any state from its old
domain and add state to the new one.  This logic doesn't have any clients
yet but it will later in the series.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
CC: Christoph Lameter <clameter@sgi.com>
CC: Paul Jackson <pj@sgi.com>
CC: Simon Derr <simon.derr@bull.net>
---

 include/linux/sched.h |    3 +
 kernel/sched.c        |  121 ++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 121 insertions(+), 3 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 809658c..b891d81 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -849,6 +849,9 @@ struct sched_class {
 	void (*task_tick) (struct rq *rq, struct task_struct *p);
 	void (*task_new) (struct rq *rq, struct task_struct *p);
 	void (*set_cpus_allowed)(struct task_struct *p, cpumask_t *newmask);
+
+	void (*join_domain)(struct rq *rq);
+	void (*leave_domain)(struct rq *rq);
 };
 
 struct load_weight {
diff --git a/kernel/sched.c b/kernel/sched.c
index 19973a0..9fcf36a 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -276,6 +276,28 @@ struct rt_rq {
 	int overloaded;
 };
 
+#ifdef CONFIG_SMP
+
+/*
+ * We add the notion of a root-domain which will be used to define per-domain
+ * variables.  Each exclusive cpuset essentially defines an island domain by
+ * fully partitioning the member cpus from any other cpuset.  Whenever a new
+ * exclusive cpuset is created, we also create and attach a new root-domain
+ * object.
+ *
+ * By default the system creates a single root-domain with all cpus as
+ * members (mimicking the global state we have today).
+ */
+struct root_domain {
+	atomic_t refcount;
+	cpumask_t span;
+	cpumask_t online;
+};
+
+static struct root_domain def_root_domain;
+
+#endif
+
 /*
  * This is the main, per-CPU runqueue data structure.
  *
@@ -333,6 +355,7 @@ struct rq {
 	atomic_t nr_iowait;
 
 #ifdef CONFIG_SMP
+	struct root_domain  *rd;
 	struct sched_domain *sd;
 
 	/* For active balancing */
@@ -5479,6 +5502,15 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 	case CPU_ONLINE_FROZEN:
 		/* Strictly unnecessary, as first user will wake it. */
 		wake_up_process(cpu_rq(cpu)->migration_thread);
+
+		/* Update our root-domain */
+		rq = cpu_rq(cpu);
+		spin_lock_irqsave(&rq->lock, flags);
+		if (rq->rd) {
+			BUG_ON(!cpu_isset(cpu, rq->rd->span));
+			cpu_set(cpu, rq->rd->online);
+		}
+		spin_unlock_irqrestore(&rq->lock, flags);
 		break;
 
 #ifdef CONFIG_HOTPLUG_CPU
@@ -5527,6 +5559,17 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		}
 		spin_unlock_irq(&rq->lock);
 		break;
+
+	case CPU_DOWN_PREPARE:
+		/* Update our root-domain */
+		rq = cpu_rq(cpu);
+		spin_lock_irqsave(&rq->lock, flags);
+		if (rq->rd) {
+			BUG_ON(!cpu_isset(cpu, rq->rd->span));
+			cpu_clear(cpu, rq->rd->online);
+		}
+		spin_unlock_irqrestore(&rq->lock, flags);
+		break;
 #endif
 	case CPU_LOCK_RELEASE:
 		mutex_unlock(&sched_hotcpu_mutex);
@@ -5718,11 +5761,69 @@ sd_parent_degenerate(struct sched_domain *sd, struct sched_domain *parent)
 	return 1;
 }
 
+static void rq_attach_root(struct rq *rq, struct root_domain *rd)
+{
+	unsigned long flags;
+	const struct sched_class *class;
+
+	spin_lock_irqsave(&rq->lock, flags);
+
+	if (rq->rd) {
+		struct root_domain *old_rd = rq->rd;
+
+		for (class = sched_class_highest; class; class = class->next)
+			if (class->leave_domain)
+				class->leave_domain(rq);
+
+		if (atomic_dec_and_test(&old_rd->refcount))
+			kfree(old_rd);
+	}
+
+	atomic_inc(&rd->refcount);
+	rq->rd = rd;
+
+	for (class = sched_class_highest; class; class = class->next)
+		if (class->join_domain)
+			class->join_domain(rq);
+
+	spin_unlock_irqrestore(&rq->lock, flags);
+}
+
+static void init_rootdomain(struct root_domain *rd, const cpumask_t *map)
+{
+	memset(rd, 0, sizeof(*rd));
+
+	rd->span = *map;
+	cpus_and(rd->online, rd->span, cpu_online_map);
+}
+
+static void init_defrootdomain(void)
+{
+	cpumask_t cpus = CPU_MASK_ALL;
+
+	init_rootdomain(&def_root_domain, &cpus);
+	atomic_set(&def_root_domain.refcount, 1);
+}
+
+static struct root_domain *alloc_rootdomain(const cpumask_t *map)
+{
+	struct root_domain *rd;
+
+	rd = kmalloc(sizeof(*rd), GFP_KERNEL);
+	if (!rd)
+		return NULL;
+
+	init_rootdomain(rd, map);
+
+	return rd;
+}
+
 /*
  * Attach the domain 'sd' to 'cpu' as its base domain.  Callers must
  * hold the hotplug lock.
  */
-static void cpu_attach_domain(struct sched_domain *sd, int cpu)
+static void cpu_attach_domain(struct sched_domain *sd,
+			      struct root_domain *rd, int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
 	struct sched_domain *tmp;
@@ -5747,6 +5848,7 @@ static void cpu_attach_domain(struct sched_domain *sd, int cpu)
 
 	sched_domain_debug(sd, cpu);
 
+	rq_attach_root(rq, rd);
 	rcu_assign_pointer(rq->sd, sd);
 }
 
@@ -6115,6 +6217,7 @@ static void init_sched_groups_power(int cpu, struct sched_domain *sd)
 static int build_sched_domains(const cpumask_t *cpu_map)
 {
 	int i;
+	struct root_domain *rd;
 #ifdef CONFIG_NUMA
 	struct sched_group **sched_group_nodes = NULL;
 	int sd_allnodes = 0;
@@ -6131,6 +6234,12 @@ static int build_sched_domains(const cpumask_t *cpu_map)
 	sched_group_nodes_bycpu[first_cpu(*cpu_map)] = sched_group_nodes;
 #endif
 
+	rd = alloc_rootdomain(cpu_map);
+	if (!rd) {
+		printk(KERN_WARNING "Cannot alloc root domain\n");
+		return -ENOMEM;
+	}
+
 	/*
 	 * Set up domains for cpus specified by the cpu_map.
 	 */
@@ -6347,7 +6456,7 @@ static int build_sched_domains(const cpumask_t *cpu_map)
 #else
 		sd = &per_cpu(phys_domains, i);
 #endif
-		cpu_attach_domain(sd, i);
+		cpu_attach_domain(sd, rd, i);
 	}
 
 	return 0;
@@ -6405,7 +6514,7 @@ static void detach_destroy_domains(const cpumask_t *cpu_map)
 	unregister_sched_domain_sysctl();
 
 	for_each_cpu_mask(i, *cpu_map)
-		cpu_attach_domain(NULL, i);
+		cpu_attach_domain(NULL, &def_root_domain, i);
 	synchronize_sched();
 	arch_destroy_sched_domains(cpu_map);
 }
@@ -6638,6 +6747,10 @@ void __init sched_init(void)
 	int highest_cpu = 0;
 	int i, j;
 
+#ifdef CONFIG_SMP
+	init_defrootdomain();
+#endif
+
 	for_each_possible_cpu(i) {
 		struct rt_prio_array *array;
 		struct rq *rq;
@@ -6677,6 +6790,8 @@ void __init sched_init(void)
 			rq->cpu_load[j] = 0;
 #ifdef CONFIG_SMP
 		rq->sd = NULL;
+		rq->rd = NULL;
+		rq_attach_root(rq, &def_root_domain);
 		rq->active_balance = 0;
 		rq->next_balance = jiffies;
 		rq->push_cpu = 0;

