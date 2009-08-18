Return-Path: <linux-kernel-owner+w=401wt.eu-S932698AbZHRQwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932698AbZHRQwb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 12:52:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932575AbZHRQw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 12:52:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:42225 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932530AbZHRQw2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 12:52:28 -0400
Date: Tue, 18 Aug 2009 16:51:48 GMT
From: tip-bot for Andreas Herrmann <andreas.herrmann3@amd.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       andreas.herrmann3@amd.com, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andreas.herrmann3@amd.com, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20090818105152.GB29515@alberich.amd.com>
References: <20090818105152.GB29515@alberich.amd.com>
Subject: [tip:sched/domains] sched: Use structure to store local data in __build_sched_domains
Message-ID: <tip-49a02c514d967921a908ac64e9c0ec0f0fc17fd8@git.kernel.org>
Git-Commit-ID: 49a02c514d967921a908ac64e9c0ec0f0fc17fd8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 18 Aug 2009 16:51:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  49a02c514d967921a908ac64e9c0ec0f0fc17fd8
Gitweb:     http://git.kernel.org/tip/49a02c514d967921a908ac64e9c0ec0f0fc17fd8
Author:     Andreas Herrmann <andreas.herrmann3@amd.com>
AuthorDate: Tue, 18 Aug 2009 12:51:52 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 18 Aug 2009 18:35:39 +0200

sched: Use structure to store local data in __build_sched_domains

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20090818105152.GB29515@alberich.amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c |  165 ++++++++++++++++++++++++++++++--------------------------
 1 files changed, 89 insertions(+), 76 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 1b59e26..565ff77 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8091,6 +8091,22 @@ struct static_sched_domain {
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
@@ -8385,54 +8401,49 @@ static void set_domain_attribute(struct sched_domain *sd,
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
@@ -8441,18 +8452,20 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
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
 
@@ -8471,11 +8484,11 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
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
@@ -8486,7 +8499,7 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 						   cpu_coregroup_mask(i));
 		sd->parent = p;
 		p->child = sd;
-		cpu_to_core_group(i, cpu_map, &sd->groups, tmpmask);
+		cpu_to_core_group(i, cpu_map, &sd->groups, d.tmpmask);
 #endif
 
 #ifdef CONFIG_SCHED_SMT
@@ -8498,54 +8511,54 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
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
@@ -8553,15 +8566,15 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
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
@@ -8570,30 +8583,30 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
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
@@ -8605,9 +8618,9 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
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
@@ -8638,13 +8651,13 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 
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
@@ -8659,42 +8672,42 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
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
