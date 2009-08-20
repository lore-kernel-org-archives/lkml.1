Return-Path: <linux-kernel-owner+w=401wt.eu-S1754570AbZHTNnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570AbZHTNnd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 09:43:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754441AbZHTNnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 09:43:33 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:59372 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754440AbZHTNnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 09:43:32 -0400
X-SpamScore: -3
X-BigFish: VPS-3(zz14c3Lzz1202hzzz32i6bh203h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KOOGRB-01-1AC-02
X-M-MSG: 
Date: Thu, 20 Aug 2009 15:42:45 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 12/15] sched: Allow NODE domain to be parent of MC instead
	of CPU domain
Message-ID: <20090820134245.GA29327@alberich.amd.com>
References: <20090820131243.GO29327@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090820131243.GO29327@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 20 Aug 2009 13:42:46.0613 (UTC) FILETIME=[19DED850:01CA219C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The level of NODE domain's child domain is provided in s_data.numa_child_level.
Then several adaptions are required when creating the domain hierarchy.
In case NODE domain is parent of MC domain we have to:
- limit NODE domains' span in sched_domain_node_span() to not exceed
  corresponding topology_core_cpumask.
- fix CPU domain span to cover entire cpu_map
- fix CPU domain sched groups to cover entire physical groups instead of
  covering a node (a node sched_group might be a proper subset of a CPU
  sched_group).
- use correct child domain in init_numa_sched_groups_power() when
  calculating sched_group.__cpu_power in NODE domain
- calculate group_power of NODE domain after its child domain

Note: As I have no idea when the ALLNODES domain is required
      I assumed that an ALLNODES domain exists only if NODE domain
      is parent of CPU domain.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 kernel/sched.c |  106 ++++++++++++++++++++++++++++++++++++++-----------------
 1 files changed, 73 insertions(+), 33 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 464b6ba..b03701d 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8161,7 +8161,8 @@ static int find_next_best_node(int node, nodemask_t *used_nodes)
  * should be one that prevents unnecessary balancing, but also spreads tasks
  * out optimally.
  */
-static void sched_domain_node_span(int node, struct cpumask *span)
+static void sched_domain_node_span(int node, struct cpumask *span,
+				   enum sched_domain_level child_level)
 {
 	nodemask_t used_nodes;
 	int i;
@@ -8177,6 +8178,10 @@ static void sched_domain_node_span(int node, struct cpumask *span)
 
 		cpumask_or(span, span, cpumask_of_node(next_node));
 	}
+
+	if (child_level == SD_LV_MC)
+		cpumask_and(span, span, topology_core_cpumask(
+			      cpumask_first(cpumask_of_node(node))));
 }
 #endif /* CONFIG_NUMA */
 
@@ -8201,6 +8206,7 @@ struct static_sched_domain {
 };
 
 struct s_data {
+	enum sched_domain_level numa_child_level;
 #ifdef CONFIG_NUMA
 	int			sd_allnodes;
 	cpumask_var_t		domainspan;
@@ -8354,7 +8360,8 @@ static int cpu_to_allnodes_group(int cpu, const struct cpumask *cpu_map,
 	return group;
 }
 
-static void init_numa_sched_groups_power(struct sched_group *group_head)
+static void init_numa_sched_groups_power(struct sched_group *group_head,
+					 enum sched_domain_level child_level)
 {
 	struct sched_group *sg = group_head;
 	int j;
@@ -8365,7 +8372,11 @@ static void init_numa_sched_groups_power(struct sched_group *group_head)
 		for_each_cpu(j, sched_group_cpus(sg)) {
 			struct sched_domain *sd;
 
-			sd = &per_cpu(phys_domains, j).sd;
+			if (child_level == SD_LV_CPU)
+				sd = &per_cpu(phys_domains, j).sd;
+			else /* SD_LV_MC */
+				sd = &per_cpu(core_domains, j).sd;
+
 			if (j != group_first_cpu(sd->groups)) {
 				/*
 				 * Only add "power" once for each
@@ -8394,7 +8405,7 @@ static int build_numa_sched_groups(struct s_data *d,
 		goto out;
 	}
 
-	sched_domain_node_span(num, d->domainspan);
+	sched_domain_node_span(num, d->domainspan, d->numa_child_level);
 	cpumask_and(d->domainspan, d->domainspan, cpu_map);
 
 	sg = kmalloc_node(sizeof(struct sched_group) + cpumask_size(),
@@ -8699,15 +8710,15 @@ static enum s_alloc __visit_domain_allocation_hell(struct s_data *d,
 }
 
 static struct sched_domain *__build_numa_sched_domains(struct s_data *d,
-	const struct cpumask *cpu_map, struct sched_domain_attr *attr, int i)
+	const struct cpumask *cpu_map, struct sched_domain_attr *attr,
+	struct sched_domain *parent, int i)
 {
-	struct sched_domain *sd = NULL;
+	struct sched_domain *sd = parent;
 #ifdef CONFIG_NUMA
-	struct sched_domain *parent;
-
 	d->sd_allnodes = 0;
-	if (cpumask_weight(cpu_map) >
-	    SD_NODES_PER_DOMAIN * cpumask_weight(d->nodemask)) {
+	if ((cpumask_weight(cpu_map) >
+	     SD_NODES_PER_DOMAIN * cpumask_weight(d->nodemask)) &&
+	    (d->numa_child_level == SD_LV_CPU)) {
 		sd = &per_cpu(allnodes_domains, i).sd;
 		SD_INIT(sd, ALLNODES);
 		set_domain_attribute(sd, attr);
@@ -8720,7 +8731,8 @@ static struct sched_domain *__build_numa_sched_domains(struct s_data *d,
 	sd = &per_cpu(node_domains, i).sd;
 	SD_INIT(sd, NODE);
 	set_domain_attribute(sd, attr);
-	sched_domain_node_span(cpu_to_node(i), sched_domain_span(sd));
+	sched_domain_node_span(cpu_to_node(i), sched_domain_span(sd),
+			       d->numa_child_level);
 	sd->parent = parent;
 	if (parent)
 		parent->child = sd;
@@ -8737,10 +8749,12 @@ static struct sched_domain *__build_cpu_sched_domain(struct s_data *d,
 	sd = &per_cpu(phys_domains, i).sd;
 	SD_INIT(sd, CPU);
 	set_domain_attribute(sd, attr);
-	cpumask_copy(sched_domain_span(sd), d->nodemask);
 	sd->parent = parent;
-	if (parent)
+	if (parent) {
+		cpumask_copy(sched_domain_span(sd), d->nodemask);
 		parent->child = sd;
+	} else
+		cpumask_copy(sched_domain_span(sd), cpu_map);
 	cpu_to_phys_group(i, cpu_map, &sd->groups, d->tmpmask);
 	return sd;
 }
@@ -8831,11 +8845,18 @@ static void build_sched_groups(struct s_data *d, enum sched_domain_level l,
 		break;
 #endif
 	case SD_LV_CPU: /* set up physical groups */
-		cpumask_and(d->nodemask, cpumask_of_node(cpu), cpu_map);
-		if (!cpumask_empty(d->nodemask))
-			init_sched_build_groups(d->nodemask, cpu_map,
-						&cpu_to_phys_group,
-						d->send_covered, d->tmpmask);
+		if (d->numa_child_level == SD_LV_MC) {
+			init_sched_build_groups(cpu_map, cpu_map,
+                                                &cpu_to_phys_group,
+                                                d->send_covered, d->tmpmask);
+		} else {
+			cpumask_and(d->nodemask, cpumask_of_node(cpu), cpu_map);
+			if (!cpumask_empty(d->nodemask))
+				init_sched_build_groups(d->nodemask, cpu_map,
+							&cpu_to_phys_group,
+							d->send_covered,
+							d->tmpmask);
+		}
 		break;
 #ifdef CONFIG_NUMA
 	case SD_LV_ALLNODES:
@@ -8859,9 +8880,8 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 	struct s_data d;
 	struct sched_domain *sd;
 	int i;
-#ifdef CONFIG_NUMA
-	d.sd_allnodes = 0;
-#endif
+
+	d.numa_child_level = SD_LV_NONE;
 
 	alloc_state = __visit_domain_allocation_hell(&d, cpu_map);
 	if (alloc_state != sa_rootdomain)
@@ -8875,9 +8895,18 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 		cpumask_and(d.nodemask, cpumask_of_node(cpu_to_node(i)),
 			    cpu_map);
 
-		sd = __build_numa_sched_domains(&d, cpu_map, attr, i);
-		sd = __build_cpu_sched_domain(&d, cpu_map, attr, sd, i);
-		sd = __build_mn_sched_domain(&d, cpu_map, attr, sd, i);
+		if (d.numa_child_level == SD_LV_CPU) {
+			sd = __build_numa_sched_domains(&d, cpu_map, attr,
+							NULL, i);
+			sd = __build_cpu_sched_domain(&d, cpu_map, attr, sd, i);
+			sd = __build_mn_sched_domain(&d, cpu_map, attr, sd, i);
+		} else {
+			sd = __build_cpu_sched_domain(&d, cpu_map, attr,
+						      NULL, i);
+			sd = __build_mn_sched_domain(&d, cpu_map, attr, sd, i);
+			sd = __build_numa_sched_domains(&d, cpu_map, attr,
+							sd, i);
+		}
 		sd = __build_mc_sched_domain(&d, cpu_map, attr, sd, i);
 		sd = __build_smt_sched_domain(&d, cpu_map, attr, sd, i);
 	}
@@ -8915,6 +8944,15 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 		init_sched_groups_power(i, sd);
 	}
 #endif
+
+#ifdef CONFIG_NUMA
+	if (d.numa_child_level == SD_LV_MC)
+		for (i = 0; i < nr_node_ids; i++)
+			init_numa_sched_groups_power(d.sched_group_nodes[i],
+						     d.numa_child_level);
+#endif
+
+
 #ifdef CONFIG_SCHED_MN
 	for_each_cpu(i, cpu_map) {
 		sd = &per_cpu(cpu_node_domains, i).sd;
@@ -8928,15 +8966,17 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 	}
 
 #ifdef CONFIG_NUMA
-	for (i = 0; i < nr_node_ids; i++)
-		init_numa_sched_groups_power(d.sched_group_nodes[i]);
-
-	if (d.sd_allnodes) {
-		struct sched_group *sg;
-
-		cpu_to_allnodes_group(cpumask_first(cpu_map), cpu_map, &sg,
-								d.tmpmask);
-		init_numa_sched_groups_power(sg);
+	if (d.numa_child_level == SD_LV_CPU) {
+		for (i = 0; i < nr_node_ids; i++)
+			init_numa_sched_groups_power(d.sched_group_nodes[i],
+						     d.numa_child_level);
+
+		if (d.sd_allnodes) {
+			struct sched_group *sg;
+			cpu_to_allnodes_group(cpumask_first(cpu_map),
+					      cpu_map, &sg, d.tmpmask);
+			init_numa_sched_groups_power(sg, d.numa_child_level);
+		}
 	}
 #endif
 
-- 
1.6.0.4



