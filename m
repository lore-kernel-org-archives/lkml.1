Return-Path: <linux-kernel-owner+w=401wt.eu-S1764699AbYEOSgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764699AbYEOSgk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 14:36:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764047AbYEOSft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 14:35:49 -0400
Received: from nds154-200.nds.lab.novell.com ([151.155.154.200]:54180 "EHLO
	lsg.lab.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763957AbYEOSfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 14:35:47 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [RFC PATCH 3/3] sched: add a per-core balancer group
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: Suresh Sidda <suresh.b.siddha@intel.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Gregory Haskins <ghaskins@novell.com>
Date: Thu, 15 May 2008 12:35:46 -0600
Message-ID: <20080515183546.5323.26657.stgit@lsg>
In-Reply-To: <20080515182832.5323.70102.stgit@lsg>
References: <20080515182832.5323.70102.stgit@lsg>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current scheduler balances SCHED_OTHER tasks based on a hierarchy of
sched_domains and sched_groups as dictated by the physical cache/node
topology of the hardware.  This policy leads to the overall optimal
balancing solution, but leaves a hole under certain circumstances (see
Documentation/scheduler/core_balancer.txt for more details).

This patch adds the concept of a new per-core grouping at each domain-level
to address the shortcomings in the group_balancer.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 Documentation/scheduler/core_balancer.txt |   69 +++++++++++++
 include/linux/sched.h                     |    2 
 kernel/sched.c                            |  149 +++++++++++++++++++++--------
 3 files changed, 180 insertions(+), 40 deletions(-)

diff --git a/Documentation/scheduler/core_balancer.txt b/Documentation/scheduler/core_balancer.txt
new file mode 100644
index 0000000..3b8d346
--- /dev/null
+++ b/Documentation/scheduler/core_balancer.txt
@@ -0,0 +1,69 @@
+Core Balancing
+----------------------
+
+The standard group_balancer manages SCHED_OTHER tasks based on a hierarchy
+of sched_domains and sched_groups as dictated by the physical cache/node
+topology of the hardware.  Each group may contain one or more cores which
+have a specific relationship to other members of the group.  Balancing
+is always performed on an inter-group basis.
+
+For example, consider a quad-core, dual socket Intel Xeon system.  It has
+a total of 8 cores across one logical NUMA node, with a cache shared
+between cores [0,2], [1,3], [4,6], [5,7].  From a sched_domain/group
+perspective on core 0, this looks like the following:
+
+domain-0: (MC)
+  span: 0x5
+  groups = 2 -> [0], [2]
+  domain-1: (SMP)
+    span: 0xff
+    groups = 4 -> [0,2], [1,3], [4,6], [5,7]
+    domain-2: (NUMA)
+      span: 0xff
+      groups = 1 -> [0-7]
+
+Recall that balancing is always inter-group, and will get more aggressive
+in the lower domains than the higher ones.  The balancing logic will
+attempt to balance between [0],[2] first, [0,2], [1,3], [4,6], [5,7]
+second, and [0-7] last.  Note that since domain-2 only consists of 1
+group, it will never result in a balance decision since there must be
+at least two groups to consider.
+
+This layout is quite logical.  The idea is that [0], and [2] can
+balance between each other aggresively in a very efficient manner
+since they share a cache.  Once the load is equalized between two
+cache-peers, domain-1 can spread the load out between the other
+peer-groups.  This represents a pretty good way to structure the
+balancing operations.
+
+However, there is one slight problem with the group_balancer: Since we
+always balance inter-group, intra-group imbalances may result in
+suboptimal behavior if we hit the condition where lower-level domains
+(domain-0 in this example) are ineffective.  This condition can arise
+whenever a domain-level imbalance cannot be resolved such that the group
+has a high aggregate load rating, yet some cores are relatively idle.
+
+For example, if a core has a large but affined load, or otherwise
+untouchable tasks (e.g. RT tasks), SCHED_OTHER will not be able to
+equalize the load.  The net result is that one or more members of the
+group may remain relatively unloaded, while the load rating for the
+entire group is high.  The higher layer domains will only consider the
+group as a whole, and the lower level domains are left powerless to
+equalize the vacuum.
+
+To address this concern, core_balancer adds the concept of a new grouping
+of cores at each domain-level: a per-core grouping (each core in its own
+unique group).  This "core_balancer" group is configured to run much less
+aggressively than its topologically relevant brother: "group_balancer".
+Core_balancer will sweep through the cores every so often, correcting
+intra-group vacuums left over from lower level domains.  In most cases,
+the group_balancer should have already established equilibrium, therefore
+benefiting from the hardwares natural affinity hierarchy.  In the cases
+where it cannot achieve equilibrium, the core_balancer tries to take it
+one step closer.
+
+By default, group_balancer runs at sd->min_interval, whereas
+core_balancer starts at sd->max_interval (both of which will respond
+to dynamic programming).  Both will employ a multiplicative backoff
+algorithm when faced with repeated migration failure.
+
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 95e46e3..98c9e90 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -715,6 +715,7 @@ enum cpu_idle_type {
 #define SD_SHARE_PKG_RESOURCES	512	/* Domain members share cpu pkg resources */
 #define SD_SERIALIZE		1024	/* Only a single load balancing instance */
 #define SD_WAKE_IDLE_FAR	2048	/* Gain latency sacrificing cache hit */
+#define SD_CORE_BALANCE	        4096	/* Balance on a per-core basis */
 
 #define BALANCE_FOR_MC_POWER	\
 	(sched_smt_power_savings ? SD_POWERSAVINGS_BALANCE : 0)
@@ -791,6 +792,7 @@ struct sched_domain {
 
 	/* Balancer data */
 	struct sched_balancer group_balancer;
+	struct sched_balancer core_balancer;
 
 #ifdef CONFIG_SCHEDSTATS
 	/* load_balance() stats */
diff --git a/kernel/sched.c b/kernel/sched.c
index 0bdbfe6..4ad3143 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4041,6 +4041,59 @@ int select_nohz_load_balancer(int stop_tick)
 
 static DEFINE_SPINLOCK(balancing);
 
+static unsigned int rebalance_domain(struct rq *rq,
+				     struct sched_domain *sd,
+				     struct sched_balancer *balancer,
+				     unsigned long *next_balance,
+				     enum cpu_idle_type *idle,
+				     int *balance)
+{
+	unsigned long interval;
+	int need_serialize;
+	cpumask_t tmp;
+
+	interval = balancer->interval;
+	if (*idle != CPU_IDLE)
+		interval *= sd->busy_factor;
+
+	/* scale ms to jiffies */
+	interval = msecs_to_jiffies(interval);
+	if (unlikely(!interval))
+		interval = 1;
+	if (interval > HZ*NR_CPUS/10)
+		interval = HZ*NR_CPUS/10;
+
+	need_serialize = sd->flags & SD_SERIALIZE;
+
+	if (need_serialize) {
+		if (!spin_trylock(&balancing))
+			goto out;
+	}
+
+	if (time_after_eq(jiffies, balancer->last_exec + interval)) {
+		if (load_balance(rq->cpu, rq, sd, balancer,
+				 *idle, balance, &tmp)) {
+			/*
+			 * We've pulled tasks over so either we're no
+			 * longer idle, or one of our SMT siblings is
+			 * not idle.
+			 */
+			*idle = CPU_NOT_IDLE;
+		}
+		balancer->last_exec = jiffies;
+	}
+
+	if (need_serialize)
+		spin_unlock(&balancing);
+out:
+	if (time_after(*next_balance, balancer->last_exec + interval)) {
+		*next_balance = balancer->last_exec + interval;
+		return 1;
+	}
+
+	return 0;
+}
+
 /*
  * It checks each scheduling domain to see if it is due to be balanced,
  * and initiates a balancing operation if so.
@@ -4051,57 +4104,23 @@ static void rebalance_domains(int cpu, enum cpu_idle_type idle)
 {
 	int balance = 1;
 	struct rq *rq = cpu_rq(cpu);
-	unsigned long interval;
 	struct sched_domain *sd;
 	/* Earliest time when we have to do rebalance again */
 	unsigned long next_balance = jiffies + 60*HZ;
 	int update_next_balance = 0;
-	int need_serialize;
-	cpumask_t tmp;
 
 	for_each_domain(cpu, sd) {
-		struct sched_balancer *balancer = &sd->group_balancer;
-
 		if (!(sd->flags & SD_LOAD_BALANCE))
 			continue;
 
-		interval = balancer->interval;
-		if (idle != CPU_IDLE)
-			interval *= sd->busy_factor;
-
-		/* scale ms to jiffies */
-		interval = msecs_to_jiffies(interval);
-		if (unlikely(!interval))
-			interval = 1;
-		if (interval > HZ*NR_CPUS/10)
-			interval = HZ*NR_CPUS/10;
-
-		need_serialize = sd->flags & SD_SERIALIZE;
-
-		if (need_serialize) {
-			if (!spin_trylock(&balancing))
-				goto out;
-		}
+		if (rebalance_domain(rq, sd, &sd->group_balancer,
+				     &next_balance, &idle, &balance))
+			update_next_balance = 1;
 
-		if (time_after_eq(jiffies, balancer->last_exec + interval)) {
-			if (load_balance(cpu, rq, sd, balancer,
-					 idle, &balance, &tmp)) {
-				/*
-				 * We've pulled tasks over so either we're no
-				 * longer idle, or one of our SMT siblings is
-				 * not idle.
-				 */
-				idle = CPU_NOT_IDLE;
-			}
-			balancer->last_exec = jiffies;
-		}
-		if (need_serialize)
-			spin_unlock(&balancing);
-out:
-		if (time_after(next_balance, balancer->last_exec + interval)) {
-			next_balance = balancer->last_exec + interval;
+		if ((sd->flags & SD_CORE_BALANCE)
+		    && rebalance_domain(rq, sd, &sd->core_balancer,
+					&next_balance, &idle, &balance))
 			update_next_balance = 1;
-		}
 
 		/*
 		 * Stop the load balance at this level. There is another
@@ -7348,6 +7367,42 @@ static void init_sched_balancer(struct sched_balancer *balancer,
 	balancer->nr_failed = 0;
 }
 
+static __read_mostly struct sched_group smp_core_group[NR_CPUS];
+#ifdef CONFIG_NUMA
+static __read_mostly struct sched_group allnode_core_group[NR_CPUS];
+static __read_mostly struct sched_group node_core_group[NR_CPUS];
+#endif
+
+static void init_sched_core_balancer(int cpu, struct sched_domain *sd,
+				     struct sched_group *pool)
+{
+	struct sched_balancer *balancer = &sd->core_balancer;
+	struct sched_group *last = NULL;
+	int i = 0;
+
+	balancer->groups = &pool[sd->first_cpu];
+
+	if (cpu != sd->first_cpu)
+		return;
+
+	for_each_cpu_mask(i, sd->span) {
+		struct sched_group *sg = &pool[i];
+
+		cpus_clear(sg->cpumask);
+		cpu_set(i, sg->cpumask);
+		sg->__cpu_power = 0;
+
+		/* FIXME: We probably need more accuracy here */
+		sg_inc_cpu_power(sg, SCHED_LOAD_SCALE);
+
+		if (last)
+			last->next = sg;
+
+		last = sg;
+	}
+	last->next = balancer->groups;
+}
+
 /*
  * Build sched domains for a given set of cpus and attach the sched domains
  * to the individual cpus
@@ -7425,6 +7480,10 @@ static int __build_sched_domains(const cpumask_t *cpu_map,
 					      tmpmask);
 			p = sd;
 			sd_allnodes = 1;
+
+			/* Enable core balancing for NUMA-allnode domain */
+			sd->flags |= SD_CORE_BALANCE;
+			init_sched_core_balancer(i, sd, allnode_core_group);
 		} else
 			p = NULL;
 
@@ -7437,6 +7496,10 @@ static int __build_sched_domains(const cpumask_t *cpu_map,
 		if (p)
 			p->child = sd;
 		cpus_and(sd->span, sd->span, *cpu_map);
+
+		/* Enable core balancing for NUMA domain */
+		sd->flags |= SD_CORE_BALANCE;
+		init_sched_core_balancer(i, sd, node_core_group);
 #endif
 
 		p = sd;
@@ -7451,6 +7514,10 @@ static int __build_sched_domains(const cpumask_t *cpu_map,
 		cpu_to_phys_group(i, cpu_map, &sd->group_balancer.groups,
 				  tmpmask);
 
+		/* Enable core balancing for smp domain */
+		sd->flags |= SD_CORE_BALANCE;
+		init_sched_core_balancer(i, sd, smp_core_group);
+
 #ifdef CONFIG_SCHED_MC
 		p = sd;
 		sd = &per_cpu(core_domains, i);
@@ -7661,6 +7728,8 @@ static int __build_sched_domains(const cpumask_t *cpu_map,
 		for_each_domain(i, sd) {
 			init_sched_balancer(&sd->group_balancer,
 					    &sd->min_interval);
+			init_sched_balancer(&sd->core_balancer,
+					    &sd->max_interval);
 		}
 	}
 

