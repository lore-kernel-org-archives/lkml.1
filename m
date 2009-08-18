Return-Path: <linux-kernel-owner+w=401wt.eu-S932749AbZHRQwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932749AbZHRQwf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 12:52:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932575AbZHRQwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 12:52:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:42229 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932697AbZHRQwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 12:52:33 -0400
Date: Tue, 18 Aug 2009 16:52:01 GMT
From: tip-bot for Andreas Herrmann <andreas.herrmann3@amd.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       andreas.herrmann3@amd.com, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andreas.herrmann3@amd.com, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20090818105300.GC29515@alberich.amd.com>
References: <20090818105300.GC29515@alberich.amd.com>
Subject: [tip:sched/domains] sched: Separate out allocation/free/goto-hell from __build_sched_domains
Message-ID: <tip-2109b99ee192764b407dc7f52babb74740eea6f9@git.kernel.org>
Git-Commit-ID: 2109b99ee192764b407dc7f52babb74740eea6f9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 18 Aug 2009 16:52:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2109b99ee192764b407dc7f52babb74740eea6f9
Gitweb:     http://git.kernel.org/tip/2109b99ee192764b407dc7f52babb74740eea6f9
Author:     Andreas Herrmann <andreas.herrmann3@amd.com>
AuthorDate: Tue, 18 Aug 2009 12:53:00 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 18 Aug 2009 18:35:39 +0200

sched: Separate out allocation/free/goto-hell from __build_sched_domains

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20090818105300.GC29515@alberich.amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c |  171 ++++++++++++++++++++++++++++++++-----------------------
 1 files changed, 99 insertions(+), 72 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 565ff77..c5d1fee 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8107,6 +8107,23 @@ struct s_data {
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
@@ -8394,6 +8411,77 @@ static void set_domain_attribute(struct sched_domain *sd,
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
@@ -8401,50 +8489,17 @@ static void set_domain_attribute(struct sched_domain *sd,
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
@@ -8675,41 +8730,13 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
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
