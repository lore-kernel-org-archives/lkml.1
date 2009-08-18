Return-Path: <linux-kernel-owner+w=401wt.eu-S1758654AbZHRKxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758654AbZHRKxl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 06:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754266AbZHRKxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 06:53:41 -0400
Received: from sg2ehsobe004.messaging.microsoft.com ([207.46.51.78]:1184 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752110AbZHRKxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 06:53:40 -0400
X-SpamScore: -2
X-BigFish: VPS-2(zz936eMzz1202hzzz32i6bh203h43j64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0KOKJKE-01-8TZ-02
X-M-MSG: 
Date: Tue, 18 Aug 2009 12:53:00 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 02/12] sched: Separate out allocation/free/goto-hell from
	__build_sched_domains
Message-ID: <20090818105300.GC29515@alberich.amd.com>
References: <20090818104944.GA29515@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090818104944.GA29515@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 18 Aug 2009 10:53:01.0358 (UTC) FILETIME=[0E28C4E0:01CA1FF2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 kernel/sched.c |  171 ++++++++++++++++++++++++++++++++-----------------------
 1 files changed, 99 insertions(+), 72 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 30fc914..5aa7dad 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8213,6 +8213,23 @@ struct s_data {
 	struct root_domain	*rd;
 };
 
+enum s_alloc {
+	sa_sched_groups = 0,
+	sa_rootdomain,
+	sa_tmpmask,
+	sa_send_covered,
+	sa_this_core_map,
+	sa_this_sibling_map,
+	sa_nodemask,
+	sa_sched_group_nodes,
+#ifdef CONFIG_NUMA
+	sa_notcovered,
+	sa_covered,
+	sa_domainspan,
+#endif
+	sa_none,
+};
+
 /*
  * SMT sched-domains:
  */
@@ -8500,6 +8517,77 @@ static void set_domain_attribute(struct sched_domain *sd,
 	}
 }
 
+static void __free_domain_allocs(struct s_data *d, enum s_alloc what,
+				 const struct cpumask *cpu_map)
+{
+	switch (what) {
+	case sa_sched_groups:
+		free_sched_groups(cpu_map, d->tmpmask); /* fall through */
+		d->sched_group_nodes = NULL;
+	case sa_rootdomain:
+		free_rootdomain(d->rd); /* fall through */
+	case sa_tmpmask:
+		free_cpumask_var(d->tmpmask); /* fall through */
+	case sa_send_covered:
+		free_cpumask_var(d->send_covered); /* fall through */
+	case sa_this_core_map:
+		free_cpumask_var(d->this_core_map); /* fall through */
+	case sa_this_sibling_map:
+		free_cpumask_var(d->this_sibling_map); /* fall through */
+	case sa_nodemask:
+		free_cpumask_var(d->nodemask); /* fall through */
+	case sa_sched_group_nodes:
+#ifdef CONFIG_NUMA
+		kfree(d->sched_group_nodes); /* fall through */
+	case sa_notcovered:
+		free_cpumask_var(d->notcovered); /* fall through */
+	case sa_covered:
+		free_cpumask_var(d->covered); /* fall through */
+	case sa_domainspan:
+		free_cpumask_var(d->domainspan); /* fall through */
+#endif
+	case sa_none:
+		break;
+	}
+}
+
+static enum s_alloc __visit_domain_allocation_hell(struct s_data *d,
+						   const struct cpumask *cpu_map)
+{
+#ifdef CONFIG_NUMA
+	if (!alloc_cpumask_var(&d->domainspan, GFP_KERNEL))
+		return sa_none;
+	if (!alloc_cpumask_var(&d->covered, GFP_KERNEL))
+		return sa_domainspan;
+	if (!alloc_cpumask_var(&d->notcovered, GFP_KERNEL))
+		return sa_covered;
+	/* Allocate the per-node list of sched groups */
+	d->sched_group_nodes = kcalloc(nr_node_ids,
+				      sizeof(struct sched_group *), GFP_KERNEL);
+	if (!d->sched_group_nodes) {
+		printk(KERN_WARNING "Can not alloc sched group node list\n");
+		return sa_notcovered;
+	}
+	sched_group_nodes_bycpu[cpumask_first(cpu_map)] = d->sched_group_nodes;
+#endif
+	if (!alloc_cpumask_var(&d->nodemask, GFP_KERNEL))
+		return sa_sched_group_nodes;
+	if (!alloc_cpumask_var(&d->this_sibling_map, GFP_KERNEL))
+		return sa_nodemask;
+	if (!alloc_cpumask_var(&d->this_core_map, GFP_KERNEL))
+		return sa_this_sibling_map;
+	if (!alloc_cpumask_var(&d->send_covered, GFP_KERNEL))
+		return sa_this_core_map;
+	if (!alloc_cpumask_var(&d->tmpmask, GFP_KERNEL))
+		return sa_send_covered;
+	d->rd = alloc_rootdomain();
+	if (!d->rd) {
+		printk(KERN_WARNING "Cannot alloc root domain\n");
+		return sa_tmpmask;
+	}
+	return sa_rootdomain;
+}
+
 /*
  * Build sched domains for a given set of cpus and attach the sched domains
  * to the individual cpus
@@ -8507,50 +8595,17 @@ static void set_domain_attribute(struct sched_domain *sd,
 static int __build_sched_domains(const struct cpumask *cpu_map,
 				 struct sched_domain_attr *attr)
 {
+	enum s_alloc alloc_state = sa_none;
 	struct s_data d;
-	int i, err = -ENOMEM;
+	int i;
 #ifdef CONFIG_NUMA
 	d.sd_allnodes = 0;
-	if (!alloc_cpumask_var(&d.domainspan, GFP_KERNEL))
-		goto out;
-	if (!alloc_cpumask_var(&d.covered, GFP_KERNEL))
-		goto free_domainspan;
-	if (!alloc_cpumask_var(&d.notcovered, GFP_KERNEL))
-		goto free_covered;
-#endif
-
-	if (!alloc_cpumask_var(&d.nodemask, GFP_KERNEL))
-		goto free_notcovered;
-	if (!alloc_cpumask_var(&d.this_sibling_map, GFP_KERNEL))
-		goto free_nodemask;
-	if (!alloc_cpumask_var(&d.this_core_map, GFP_KERNEL))
-		goto free_this_sibling_map;
-	if (!alloc_cpumask_var(&d.send_covered, GFP_KERNEL))
-		goto free_this_core_map;
-	if (!alloc_cpumask_var(&d.tmpmask, GFP_KERNEL))
-		goto free_send_covered;
-
-#ifdef CONFIG_NUMA
-	/*
-	 * Allocate the per-node list of sched groups
-	 */
-	d.sched_group_nodes = kcalloc(nr_node_ids, sizeof(struct sched_group *),
-				      GFP_KERNEL);
-	if (!d.sched_group_nodes) {
-		printk(KERN_WARNING "Can not alloc sched group node list\n");
-		goto free_tmpmask;
-	}
 #endif
 
-	d.rd = alloc_rootdomain();
-	if (!d.rd) {
-		printk(KERN_WARNING "Cannot alloc root domain\n");
-		goto free_sched_groups;
-	}
-
-#ifdef CONFIG_NUMA
-	sched_group_nodes_bycpu[cpumask_first(cpu_map)] = d.sched_group_nodes;
-#endif
+	alloc_state = __visit_domain_allocation_hell(&d, cpu_map);
+	if (alloc_state != sa_rootdomain)
+		goto error;
+	alloc_state = sa_sched_groups;
 
 	/*
 	 * Set up domains for cpus specified by the cpu_map.
@@ -8781,41 +8836,13 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 		cpu_attach_domain(sd, d.rd, i);
 	}
 
-	err = 0;
-
-free_tmpmask:
-	free_cpumask_var(d.tmpmask);
-free_send_covered:
-	free_cpumask_var(d.send_covered);
-free_this_core_map:
-	free_cpumask_var(d.this_core_map);
-free_this_sibling_map:
-	free_cpumask_var(d.this_sibling_map);
-free_nodemask:
-	free_cpumask_var(d.nodemask);
-free_notcovered:
-#ifdef CONFIG_NUMA
-	free_cpumask_var(d.notcovered);
-free_covered:
-	free_cpumask_var(d.covered);
-free_domainspan:
-	free_cpumask_var(d.domainspan);
-out:
-#endif
-	return err;
-
-free_sched_groups:
-#ifdef CONFIG_NUMA
-	kfree(d.sched_group_nodes);
-#endif
-	goto free_tmpmask;
+	d.sched_group_nodes = NULL; /* don't free this we still need it */
+	__free_domain_allocs(&d, sa_tmpmask, cpu_map);
+	return 0;
 
-#ifdef CONFIG_NUMA
 error:
-	free_sched_groups(cpu_map, d.tmpmask);
-	free_rootdomain(d.rd);
-	goto free_tmpmask;
-#endif
+	__free_domain_allocs(&d, alloc_state, cpu_map);
+	return -ENOMEM;
 }
 
 static int build_sched_domains(const struct cpumask *cpu_map)
-- 
1.6.4



