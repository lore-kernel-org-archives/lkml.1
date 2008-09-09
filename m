Return-Path: <linux-kernel-owner+w=401wt.eu-S1757255AbYIIPvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757255AbYIIPvp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 11:51:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754592AbYIIPuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 11:50:24 -0400
Received: from relay2.sgi.com ([192.48.171.30]:38201 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754148AbYIIPuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 11:50:15 -0400
Message-Id: <20080909155014.068091000@polaris-admin.engr.sgi.com>
References: <20080909155013.455071000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 09 Sep 2008 08:50:16 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jack Steiner <steiner@sgi.com>, Jes Sorensen <jes@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] sched: Optimize cpumask temp stack usage in kernel/sched.c
Content-Disposition: inline; filename=stack-hogs-kernel_sched_c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * Make the following changes to kernel/sched.c functions:

    - use node_to_cpumask_ptr in place of node_to_cpumask

  * Remove special code for SCHED_CPUMASK_ALLOC and use CPUMASK_ALLOC
    from linux/cpumask.h.

Applies to linux-2.6.tip/master.

Signed-off-by: Mike Travis <travis@sgi.com>
---
 kernel/sched.c |   81 +++++++++++++++++++++++----------------------------------
 1 file changed, 33 insertions(+), 48 deletions(-)

--- linux-2.6.tip.orig/kernel/sched.c
+++ linux-2.6.tip/kernel/sched.c
@@ -6110,8 +6110,9 @@ static void move_task_off_dead_cpu(int d
 
 	do {
 		/* On same node? */
-		mask = node_to_cpumask(cpu_to_node(dead_cpu));
-		cpus_and(mask, mask, p->cpus_allowed);
+		node_to_cpumask_ptr(pnodemask, cpu_to_node(dead_cpu));
+
+		cpus_and(mask, *pnodemask, p->cpus_allowed);
 		dest_cpu = any_online_cpu(mask);
 
 		/* On any allowed CPU? */
@@ -7117,9 +7118,9 @@ static int cpu_to_allnodes_group(int cpu
 				 struct sched_group **sg, cpumask_t *nodemask)
 {
 	int group;
+	node_to_cpumask_ptr(pnodemask, cpu_to_node(cpu));
 
-	*nodemask = node_to_cpumask(cpu_to_node(cpu));
-	cpus_and(*nodemask, *nodemask, *cpu_map);
+	cpus_and(*nodemask, *pnodemask, *cpu_map);
 	group = first_cpu(*nodemask);
 
 	if (sg)
@@ -7169,9 +7170,9 @@ static void free_sched_groups(const cpum
 
 		for (i = 0; i < nr_node_ids; i++) {
 			struct sched_group *oldsg, *sg = sched_group_nodes[i];
+			node_to_cpumask_ptr(pnodemask, i);
 
-			*nodemask = node_to_cpumask(i);
-			cpus_and(*nodemask, *nodemask, *cpu_map);
+			cpus_and(*nodemask, *pnodemask, *cpu_map);
 			if (cpus_empty(*nodemask))
 				continue;
 
@@ -7294,19 +7295,6 @@ struct allmasks {
 #endif
 };
 
-#if	NR_CPUS > 128
-#define	SCHED_CPUMASK_ALLOC		1
-#define	SCHED_CPUMASK_FREE(v)		kfree(v)
-#define	SCHED_CPUMASK_DECLARE(v)	struct allmasks *v
-#else
-#define	SCHED_CPUMASK_ALLOC		0
-#define	SCHED_CPUMASK_FREE(v)
-#define	SCHED_CPUMASK_DECLARE(v)	struct allmasks _v, *v = &_v
-#endif
-
-#define	SCHED_CPUMASK_VAR(v, a) 	cpumask_t *v = (cpumask_t *) \
-			((unsigned long)(a) + offsetof(struct allmasks, v))
-
 static int default_relax_domain_level = -1;
 
 static int __init setup_relax_domain_level(char *str)
@@ -7351,8 +7339,9 @@ static int __build_sched_domains(const c
 {
 	int i;
 	struct root_domain *rd;
-	SCHED_CPUMASK_DECLARE(allmasks);
-	cpumask_t *tmpmask;
+	CPUMASK_ALLOC(allmasks);
+	CPUMASK_PTR(tmpmask, allmasks);
+
 #ifdef CONFIG_NUMA
 	struct sched_group **sched_group_nodes = NULL;
 	int sd_allnodes = 0;
@@ -7364,6 +7353,7 @@ static int __build_sched_domains(const c
 				    GFP_KERNEL);
 	if (!sched_group_nodes) {
 		printk(KERN_WARNING "Can not alloc sched group node list\n");
+		CPUMASK_FREE(allmasks);
 		return -ENOMEM;
 	}
 #endif
@@ -7374,13 +7364,11 @@ static int __build_sched_domains(const c
 #ifdef CONFIG_NUMA
 		kfree(sched_group_nodes);
 #endif
+		CPUMASK_FREE(allmasks);
 		return -ENOMEM;
 	}
 
-#if SCHED_CPUMASK_ALLOC
-	/* get space for all scratch cpumask variables */
-	allmasks = kmalloc(sizeof(*allmasks), GFP_KERNEL);
-	if (!allmasks) {
+	if (allmasks == NULL) {
 		printk(KERN_WARNING "Cannot alloc cpumask array\n");
 		kfree(rd);
 #ifdef CONFIG_NUMA
@@ -7388,9 +7376,6 @@ static int __build_sched_domains(const c
 #endif
 		return -ENOMEM;
 	}
-#endif
-	tmpmask = (cpumask_t *)allmasks;
-
 
 #ifdef CONFIG_NUMA
 	sched_group_nodes_bycpu[first_cpu(*cpu_map)] = sched_group_nodes;
@@ -7401,10 +7386,10 @@ static int __build_sched_domains(const c
 	 */
 	for_each_cpu_mask_nr(i, *cpu_map) {
 		struct sched_domain *sd = NULL, *p;
-		SCHED_CPUMASK_VAR(nodemask, allmasks);
+		CPUMASK_PTR(nodemask, allmasks);
+		node_to_cpumask_ptr(pnodemask, cpu_to_node(i));
 
-		*nodemask = node_to_cpumask(cpu_to_node(i));
-		cpus_and(*nodemask, *nodemask, *cpu_map);
+		cpus_and(*nodemask, *pnodemask, *cpu_map);
 
 #ifdef CONFIG_NUMA
 		if (cpus_weight(*cpu_map) >
@@ -7467,8 +7452,8 @@ static int __build_sched_domains(const c
 #ifdef CONFIG_SCHED_SMT
 	/* Set up CPU (sibling) groups */
 	for_each_cpu_mask_nr(i, *cpu_map) {
-		SCHED_CPUMASK_VAR(this_sibling_map, allmasks);
-		SCHED_CPUMASK_VAR(send_covered, allmasks);
+		CPUMASK_PTR(this_sibling_map, allmasks);
+		CPUMASK_PTR(send_covered, allmasks);
 
 		*this_sibling_map = per_cpu(cpu_sibling_map, i);
 		cpus_and(*this_sibling_map, *this_sibling_map, *cpu_map);
@@ -7484,8 +7469,8 @@ static int __build_sched_domains(const c
 #ifdef CONFIG_SCHED_MC
 	/* Set up multi-core groups */
 	for_each_cpu_mask_nr(i, *cpu_map) {
-		SCHED_CPUMASK_VAR(this_core_map, allmasks);
-		SCHED_CPUMASK_VAR(send_covered, allmasks);
+		CPUMASK_PTR(this_core_map, allmasks);
+		CPUMASK_PTR(send_covered, allmasks);
 
 		*this_core_map = cpu_coregroup_map(i);
 		cpus_and(*this_core_map, *this_core_map, *cpu_map);
@@ -7500,11 +7485,11 @@ static int __build_sched_domains(const c
 
 	/* Set up physical groups */
 	for (i = 0; i < nr_node_ids; i++) {
-		SCHED_CPUMASK_VAR(nodemask, allmasks);
-		SCHED_CPUMASK_VAR(send_covered, allmasks);
+		CPUMASK_PTR(nodemask, allmasks);
+		CPUMASK_PTR(send_covered, allmasks);
+		node_to_cpumask_ptr(pnodemask, i);
 
-		*nodemask = node_to_cpumask(i);
-		cpus_and(*nodemask, *nodemask, *cpu_map);
+		cpus_and(*nodemask, *pnodemask, *cpu_map);
 		if (cpus_empty(*nodemask))
 			continue;
 
@@ -7516,7 +7501,7 @@ static int __build_sched_domains(const c
 #ifdef CONFIG_NUMA
 	/* Set up node groups */
 	if (sd_allnodes) {
-		SCHED_CPUMASK_VAR(send_covered, allmasks);
+		CPUMASK_PTR(send_covered, allmasks);
 
 		init_sched_build_groups(cpu_map, cpu_map,
 					&cpu_to_allnodes_group,
@@ -7526,15 +7511,15 @@ static int __build_sched_domains(const c
 	for (i = 0; i < nr_node_ids; i++) {
 		/* Set up node groups */
 		struct sched_group *sg, *prev;
-		SCHED_CPUMASK_VAR(nodemask, allmasks);
-		SCHED_CPUMASK_VAR(domainspan, allmasks);
-		SCHED_CPUMASK_VAR(covered, allmasks);
+		CPUMASK_PTR(nodemask, allmasks);
+		CPUMASK_PTR(domainspan, allmasks);
+		CPUMASK_PTR(covered, allmasks);
+		node_to_cpumask_ptr(pnodemask, i);
 		int j;
 
-		*nodemask = node_to_cpumask(i);
 		cpus_clear(*covered);
 
-		cpus_and(*nodemask, *nodemask, *cpu_map);
+		cpus_and(*nodemask, *pnodemask, *cpu_map);
 		if (cpus_empty(*nodemask)) {
 			sched_group_nodes[i] = NULL;
 			continue;
@@ -7563,7 +7548,7 @@ static int __build_sched_domains(const c
 		prev = sg;
 
 		for (j = 0; j < nr_node_ids; j++) {
-			SCHED_CPUMASK_VAR(notcovered, allmasks);
+			CPUMASK_PTR(notcovered, allmasks);
 			int n = (i + j) % nr_node_ids;
 			node_to_cpumask_ptr(pnodemask, n);
 
@@ -7642,13 +7627,13 @@ static int __build_sched_domains(const c
 		cpu_attach_domain(sd, rd, i);
 	}
 
-	SCHED_CPUMASK_FREE((void *)allmasks);
+	CPUMASK_FREE(allmasks);
 	return 0;
 
 #ifdef CONFIG_NUMA
 error:
 	free_sched_groups(cpu_map, tmpmask);
-	SCHED_CPUMASK_FREE((void *)allmasks);
+	CPUMASK_FREE(allmasks);
 	return -ENOMEM;
 #endif
 }

-- 
