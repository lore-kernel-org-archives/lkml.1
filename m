Return-Path: <linux-kernel-owner+w=401wt.eu-S1758671AbZHRKwG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758671AbZHRKwG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 06:52:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755527AbZHRKwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 06:52:05 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:20544 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994AbZHRKwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 06:52:04 -0400
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMzz1202hzzz32i6bh203h62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KOKJIG-02-680-02
X-M-MSG: 
Date: Tue, 18 Aug 2009 12:51:52 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 01/12] sched: Use structure to store local data in
	__build_sched_domains
Message-ID: <20090818105152.GB29515@alberich.amd.com>
References: <20090818104944.GA29515@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090818104944.GA29515@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 18 Aug 2009 10:51:52.0966 (UTC) FILETIME=[E564FA60:01CA1FF1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 kernel/sched.c |  165 ++++++++++++++++++++++++++++++--------------------------
 1 files changed, 89 insertions(+), 76 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 5184580..30fc914 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8197,6 +8197,22 @@ struct static_sched_domain {
 	DECLARE_BITMAP(span, CONFIG_NR_CPUS);
 };
 
+struct s_data {
+#ifdef CONFIG_NUMA
+	int			sd_allnodes;
+	cpumask_var_t		domainspan;
+	cpumask_var_t		covered;
+	cpumask_var_t		notcovered;
+#endif
+	cpumask_var_t		nodemask;
+	cpumask_var_t		this_sibling_map;
+	cpumask_var_t		this_core_map;
+	cpumask_var_t		send_covered;
+	cpumask_var_t		tmpmask;
+	struct sched_group	**sched_group_nodes;
+	struct root_domain	*rd;
+};
+
 /*
  * SMT sched-domains:
  */
@@ -8491,54 +8507,49 @@ static void set_domain_attribute(struct sched_domain *sd,
 static int __build_sched_domains(const struct cpumask *cpu_map,
 				 struct sched_domain_attr *attr)
 {
+	struct s_data d;
 	int i, err = -ENOMEM;
-	struct root_domain *rd;
-	cpumask_var_t nodemask, this_sibling_map, this_core_map, send_covered,
-		tmpmask;
 #ifdef CONFIG_NUMA
-	cpumask_var_t domainspan, covered, notcovered;
-	struct sched_group **sched_group_nodes = NULL;
-	int sd_allnodes = 0;
-
-	if (!alloc_cpumask_var(&domainspan, GFP_KERNEL))
+	d.sd_allnodes = 0;
+	if (!alloc_cpumask_var(&d.domainspan, GFP_KERNEL))
 		goto out;
-	if (!alloc_cpumask_var(&covered, GFP_KERNEL))
+	if (!alloc_cpumask_var(&d.covered, GFP_KERNEL))
 		goto free_domainspan;
-	if (!alloc_cpumask_var(&notcovered, GFP_KERNEL))
+	if (!alloc_cpumask_var(&d.notcovered, GFP_KERNEL))
 		goto free_covered;
 #endif
 
-	if (!alloc_cpumask_var(&nodemask, GFP_KERNEL))
+	if (!alloc_cpumask_var(&d.nodemask, GFP_KERNEL))
 		goto free_notcovered;
-	if (!alloc_cpumask_var(&this_sibling_map, GFP_KERNEL))
+	if (!alloc_cpumask_var(&d.this_sibling_map, GFP_KERNEL))
 		goto free_nodemask;
-	if (!alloc_cpumask_var(&this_core_map, GFP_KERNEL))
+	if (!alloc_cpumask_var(&d.this_core_map, GFP_KERNEL))
 		goto free_this_sibling_map;
-	if (!alloc_cpumask_var(&send_covered, GFP_KERNEL))
+	if (!alloc_cpumask_var(&d.send_covered, GFP_KERNEL))
 		goto free_this_core_map;
-	if (!alloc_cpumask_var(&tmpmask, GFP_KERNEL))
+	if (!alloc_cpumask_var(&d.tmpmask, GFP_KERNEL))
 		goto free_send_covered;
 
 #ifdef CONFIG_NUMA
 	/*
 	 * Allocate the per-node list of sched groups
 	 */
-	sched_group_nodes = kcalloc(nr_node_ids, sizeof(struct sched_group *),
-				    GFP_KERNEL);
-	if (!sched_group_nodes) {
+	d.sched_group_nodes = kcalloc(nr_node_ids, sizeof(struct sched_group *),
+				      GFP_KERNEL);
+	if (!d.sched_group_nodes) {
 		printk(KERN_WARNING "Can not alloc sched group node list\n");
 		goto free_tmpmask;
 	}
 #endif
 
-	rd = alloc_rootdomain();
-	if (!rd) {
+	d.rd = alloc_rootdomain();
+	if (!d.rd) {
 		printk(KERN_WARNING "Cannot alloc root domain\n");
 		goto free_sched_groups;
 	}
 
 #ifdef CONFIG_NUMA
-	sched_group_nodes_bycpu[cpumask_first(cpu_map)] = sched_group_nodes;
+	sched_group_nodes_bycpu[cpumask_first(cpu_map)] = d.sched_group_nodes;
 #endif
 
 	/*
@@ -8547,18 +8558,20 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 	for_each_cpu(i, cpu_map) {
 		struct sched_domain *sd = NULL, *p;
 
-		cpumask_and(nodemask, cpumask_of_node(cpu_to_node(i)), cpu_map);
+		cpumask_and(d.nodemask, cpumask_of_node(cpu_to_node(i)),
+			    cpu_map);
 
 #ifdef CONFIG_NUMA
 		if (cpumask_weight(cpu_map) >
-				SD_NODES_PER_DOMAIN*cpumask_weight(nodemask)) {
+				SD_NODES_PER_DOMAIN*cpumask_weight(d.nodemask)) {
 			sd = &per_cpu(allnodes_domains, i).sd;
 			SD_INIT(sd, ALLNODES);
 			set_domain_attribute(sd, attr);
 			cpumask_copy(sched_domain_span(sd), cpu_map);
-			cpu_to_allnodes_group(i, cpu_map, &sd->groups, tmpmask);
+			cpu_to_allnodes_group(i, cpu_map, &sd->groups,
+					      d.tmpmask);
 			p = sd;
-			sd_allnodes = 1;
+			d.sd_allnodes = 1;
 		} else
 			p = NULL;
 
@@ -8577,11 +8590,11 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 		sd = &per_cpu(phys_domains, i).sd;
 		SD_INIT(sd, CPU);
 		set_domain_attribute(sd, attr);
-		cpumask_copy(sched_domain_span(sd), nodemask);
+		cpumask_copy(sched_domain_span(sd), d.nodemask);
 		sd->parent = p;
 		if (p)
 			p->child = sd;
-		cpu_to_phys_group(i, cpu_map, &sd->groups, tmpmask);
+		cpu_to_phys_group(i, cpu_map, &sd->groups, d.tmpmask);
 
 #ifdef CONFIG_SCHED_MC
 		p = sd;
@@ -8592,7 +8605,7 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 						   cpu_coregroup_mask(i));
 		sd->parent = p;
 		p->child = sd;
-		cpu_to_core_group(i, cpu_map, &sd->groups, tmpmask);
+		cpu_to_core_group(i, cpu_map, &sd->groups, d.tmpmask);
 #endif
 
 #ifdef CONFIG_SCHED_SMT
@@ -8604,54 +8617,54 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 			    topology_thread_cpumask(i), cpu_map);
 		sd->parent = p;
 		p->child = sd;
-		cpu_to_cpu_group(i, cpu_map, &sd->groups, tmpmask);
+		cpu_to_cpu_group(i, cpu_map, &sd->groups, d.tmpmask);
 #endif
 	}
 
 #ifdef CONFIG_SCHED_SMT
 	/* Set up CPU (sibling) groups */
 	for_each_cpu(i, cpu_map) {
-		cpumask_and(this_sibling_map,
+		cpumask_and(d.this_sibling_map,
 			    topology_thread_cpumask(i), cpu_map);
-		if (i != cpumask_first(this_sibling_map))
+		if (i != cpumask_first(d.this_sibling_map))
 			continue;
 
-		init_sched_build_groups(this_sibling_map, cpu_map,
+		init_sched_build_groups(d.this_sibling_map, cpu_map,
 					&cpu_to_cpu_group,
-					send_covered, tmpmask);
+					d.send_covered, d.tmpmask);
 	}
 #endif
 
 #ifdef CONFIG_SCHED_MC
 	/* Set up multi-core groups */
 	for_each_cpu(i, cpu_map) {
-		cpumask_and(this_core_map, cpu_coregroup_mask(i), cpu_map);
-		if (i != cpumask_first(this_core_map))
+		cpumask_and(d.this_core_map, cpu_coregroup_mask(i), cpu_map);
+		if (i != cpumask_first(d.this_core_map))
 			continue;
 
-		init_sched_build_groups(this_core_map, cpu_map,
+		init_sched_build_groups(d.this_core_map, cpu_map,
 					&cpu_to_core_group,
-					send_covered, tmpmask);
+					d.send_covered, d.tmpmask);
 	}
 #endif
 
 	/* Set up physical groups */
 	for (i = 0; i < nr_node_ids; i++) {
-		cpumask_and(nodemask, cpumask_of_node(i), cpu_map);
-		if (cpumask_empty(nodemask))
+		cpumask_and(d.nodemask, cpumask_of_node(i), cpu_map);
+		if (cpumask_empty(d.nodemask))
 			continue;
 
-		init_sched_build_groups(nodemask, cpu_map,
+		init_sched_build_groups(d.nodemask, cpu_map,
 					&cpu_to_phys_group,
-					send_covered, tmpmask);
+					d.send_covered, d.tmpmask);
 	}
 
 #ifdef CONFIG_NUMA
 	/* Set up node groups */
-	if (sd_allnodes) {
+	if (d.sd_allnodes) {
 		init_sched_build_groups(cpu_map, cpu_map,
 					&cpu_to_allnodes_group,
-					send_covered, tmpmask);
+					d.send_covered, d.tmpmask);
 	}
 
 	for (i = 0; i < nr_node_ids; i++) {
@@ -8659,15 +8672,15 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 		struct sched_group *sg, *prev;
 		int j;
 
-		cpumask_clear(covered);
-		cpumask_and(nodemask, cpumask_of_node(i), cpu_map);
-		if (cpumask_empty(nodemask)) {
-			sched_group_nodes[i] = NULL;
+		cpumask_clear(d.covered);
+		cpumask_and(d.nodemask, cpumask_of_node(i), cpu_map);
+		if (cpumask_empty(d.nodemask)) {
+			d.sched_group_nodes[i] = NULL;
 			continue;
 		}
 
-		sched_domain_node_span(i, domainspan);
-		cpumask_and(domainspan, domainspan, cpu_map);
+		sched_domain_node_span(i, d.domainspan);
+		cpumask_and(d.domainspan, d.domainspan, cpu_map);
 
 		sg = kmalloc_node(sizeof(struct sched_group) + cpumask_size(),
 				  GFP_KERNEL, i);
@@ -8676,30 +8689,30 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 				"node %d\n", i);
 			goto error;
 		}
-		sched_group_nodes[i] = sg;
-		for_each_cpu(j, nodemask) {
+		d.sched_group_nodes[i] = sg;
+		for_each_cpu(j, d.nodemask) {
 			struct sched_domain *sd;
 
 			sd = &per_cpu(node_domains, j).sd;
 			sd->groups = sg;
 		}
 		sg->__cpu_power = 0;
-		cpumask_copy(sched_group_cpus(sg), nodemask);
+		cpumask_copy(sched_group_cpus(sg), d.nodemask);
 		sg->next = sg;
-		cpumask_or(covered, covered, nodemask);
+		cpumask_or(d.covered, d.covered, d.nodemask);
 		prev = sg;
 
 		for (j = 0; j < nr_node_ids; j++) {
 			int n = (i + j) % nr_node_ids;
 
-			cpumask_complement(notcovered, covered);
-			cpumask_and(tmpmask, notcovered, cpu_map);
-			cpumask_and(tmpmask, tmpmask, domainspan);
-			if (cpumask_empty(tmpmask))
+			cpumask_complement(d.notcovered, d.covered);
+			cpumask_and(d.tmpmask, d.notcovered, cpu_map);
+			cpumask_and(d.tmpmask, d.tmpmask, d.domainspan);
+			if (cpumask_empty(d.tmpmask))
 				break;
 
-			cpumask_and(tmpmask, tmpmask, cpumask_of_node(n));
-			if (cpumask_empty(tmpmask))
+			cpumask_and(d.tmpmask, d.tmpmask, cpumask_of_node(n));
+			if (cpumask_empty(d.tmpmask))
 				continue;
 
 			sg = kmalloc_node(sizeof(struct sched_group) +
@@ -8711,9 +8724,9 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 				goto error;
 			}
 			sg->__cpu_power = 0;
-			cpumask_copy(sched_group_cpus(sg), tmpmask);
+			cpumask_copy(sched_group_cpus(sg), d.tmpmask);
 			sg->next = prev->next;
-			cpumask_or(covered, covered, tmpmask);
+			cpumask_or(d.covered, d.covered, d.tmpmask);
 			prev->next = sg;
 			prev = sg;
 		}
@@ -8744,13 +8757,13 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 
 #ifdef CONFIG_NUMA
 	for (i = 0; i < nr_node_ids; i++)
-		init_numa_sched_groups_power(sched_group_nodes[i]);
+		init_numa_sched_groups_power(d.sched_group_nodes[i]);
 
-	if (sd_allnodes) {
+	if (d.sd_allnodes) {
 		struct sched_group *sg;
 
 		cpu_to_allnodes_group(cpumask_first(cpu_map), cpu_map, &sg,
-								tmpmask);
+								d.tmpmask);
 		init_numa_sched_groups_power(sg);
 	}
 #endif
@@ -8765,42 +8778,42 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 #else
 		sd = &per_cpu(phys_domains, i).sd;
 #endif
-		cpu_attach_domain(sd, rd, i);
+		cpu_attach_domain(sd, d.rd, i);
 	}
 
 	err = 0;
 
 free_tmpmask:
-	free_cpumask_var(tmpmask);
+	free_cpumask_var(d.tmpmask);
 free_send_covered:
-	free_cpumask_var(send_covered);
+	free_cpumask_var(d.send_covered);
 free_this_core_map:
-	free_cpumask_var(this_core_map);
+	free_cpumask_var(d.this_core_map);
 free_this_sibling_map:
-	free_cpumask_var(this_sibling_map);
+	free_cpumask_var(d.this_sibling_map);
 free_nodemask:
-	free_cpumask_var(nodemask);
+	free_cpumask_var(d.nodemask);
 free_notcovered:
 #ifdef CONFIG_NUMA
-	free_cpumask_var(notcovered);
+	free_cpumask_var(d.notcovered);
 free_covered:
-	free_cpumask_var(covered);
+	free_cpumask_var(d.covered);
 free_domainspan:
-	free_cpumask_var(domainspan);
+	free_cpumask_var(d.domainspan);
 out:
 #endif
 	return err;
 
 free_sched_groups:
 #ifdef CONFIG_NUMA
-	kfree(sched_group_nodes);
+	kfree(d.sched_group_nodes);
 #endif
 	goto free_tmpmask;
 
 #ifdef CONFIG_NUMA
 error:
-	free_sched_groups(cpu_map, tmpmask);
-	free_rootdomain(rd);
+	free_sched_groups(cpu_map, d.tmpmask);
+	free_rootdomain(d.rd);
 	goto free_tmpmask;
 #endif
 }
-- 
1.6.4



