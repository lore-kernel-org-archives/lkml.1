Return-Path: <linux-kernel-owner+w=401wt.eu-S1759519AbZHRQyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759519AbZHRQyd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 12:54:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759510AbZHRQyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 12:54:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:42365 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759479AbZHRQy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 12:54:28 -0400
Date: Tue, 18 Aug 2009 16:53:54 GMT
From: tip-bot for Andreas Herrmann <andreas.herrmann3@amd.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       andreas.herrmann3@amd.com, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andreas.herrmann3@amd.com, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20090818110111.GL29515@alberich.amd.com>
References: <20090818110111.GL29515@alberich.amd.com>
Subject: [tip:sched/domains] sched: Separate out build of NUMA sched groups from __build_sched_domains
Message-ID: <tip-0601a88d8fa4508eaa49a6d96c6685e1dece38e3@git.kernel.org>
Git-Commit-ID: 0601a88d8fa4508eaa49a6d96c6685e1dece38e3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 18 Aug 2009 16:53:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0601a88d8fa4508eaa49a6d96c6685e1dece38e3
Gitweb:     http://git.kernel.org/tip/0601a88d8fa4508eaa49a6d96c6685e1dece38e3
Author:     Andreas Herrmann <andreas.herrmann3@amd.com>
AuthorDate: Tue, 18 Aug 2009 13:01:11 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 18 Aug 2009 18:35:44 +0200

sched: Separate out build of NUMA sched groups from __build_sched_domains

... to further strip down __build_sched_domains().

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20090818110111.GL29515@alberich.amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c |  130 +++++++++++++++++++++++++++++---------------------------
 1 files changed, 67 insertions(+), 63 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 52c1953..c1ce884 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8246,6 +8246,71 @@ static void init_numa_sched_groups_power(struct sched_group *group_head)
 		sg = sg->next;
 	} while (sg != group_head);
 }
+
+static int build_numa_sched_groups(struct s_data *d,
+				   const struct cpumask *cpu_map, int num)
+{
+	struct sched_domain *sd;
+	struct sched_group *sg, *prev;
+	int n, j;
+
+	cpumask_clear(d->covered);
+	cpumask_and(d->nodemask, cpumask_of_node(num), cpu_map);
+	if (cpumask_empty(d->nodemask)) {
+		d->sched_group_nodes[num] = NULL;
+		goto out;
+	}
+
+	sched_domain_node_span(num, d->domainspan);
+	cpumask_and(d->domainspan, d->domainspan, cpu_map);
+
+	sg = kmalloc_node(sizeof(struct sched_group) + cpumask_size(),
+			  GFP_KERNEL, num);
+	if (!sg) {
+		printk(KERN_WARNING "Can not alloc domain group for node %d\n",
+		       num);
+		return -ENOMEM;
+	}
+	d->sched_group_nodes[num] = sg;
+
+	for_each_cpu(j, d->nodemask) {
+		sd = &per_cpu(node_domains, j).sd;
+		sd->groups = sg;
+	}
+
+	sg->__cpu_power = 0;
+	cpumask_copy(sched_group_cpus(sg), d->nodemask);
+	sg->next = sg;
+	cpumask_or(d->covered, d->covered, d->nodemask);
+
+	prev = sg;
+	for (j = 0; j < nr_node_ids; j++) {
+		n = (num + j) % nr_node_ids;
+		cpumask_complement(d->notcovered, d->covered);
+		cpumask_and(d->tmpmask, d->notcovered, cpu_map);
+		cpumask_and(d->tmpmask, d->tmpmask, d->domainspan);
+		if (cpumask_empty(d->tmpmask))
+			break;
+		cpumask_and(d->tmpmask, d->tmpmask, cpumask_of_node(n));
+		if (cpumask_empty(d->tmpmask))
+			continue;
+		sg = kmalloc_node(sizeof(struct sched_group) + cpumask_size(),
+				  GFP_KERNEL, num);
+		if (!sg) {
+			printk(KERN_WARNING
+			       "Can not alloc domain group for node %d\n", j);
+			return -ENOMEM;
+		}
+		sg->__cpu_power = 0;
+		cpumask_copy(sched_group_cpus(sg), d->tmpmask);
+		sg->next = prev->next;
+		cpumask_or(d->covered, d->covered, d->tmpmask);
+		prev->next = sg;
+		prev = sg;
+	}
+out:
+	return 0;
+}
 #endif /* CONFIG_NUMA */
 
 #ifdef CONFIG_NUMA
@@ -8652,70 +8717,9 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 	if (d.sd_allnodes)
 		build_sched_groups(&d, SD_LV_ALLNODES, cpu_map, 0);
 
-	for (i = 0; i < nr_node_ids; i++) {
-		/* Set up node groups */
-		struct sched_group *sg, *prev;
-		int j;
-
-		cpumask_clear(d.covered);
-		cpumask_and(d.nodemask, cpumask_of_node(i), cpu_map);
-		if (cpumask_empty(d.nodemask)) {
-			d.sched_group_nodes[i] = NULL;
-			continue;
-		}
-
-		sched_domain_node_span(i, d.domainspan);
-		cpumask_and(d.domainspan, d.domainspan, cpu_map);
-
-		sg = kmalloc_node(sizeof(struct sched_group) + cpumask_size(),
-				  GFP_KERNEL, i);
-		if (!sg) {
-			printk(KERN_WARNING "Can not alloc domain group for "
-				"node %d\n", i);
+	for (i = 0; i < nr_node_ids; i++)
+		if (build_numa_sched_groups(&d, cpu_map, i))
 			goto error;
-		}
-		d.sched_group_nodes[i] = sg;
-		for_each_cpu(j, d.nodemask) {
-			struct sched_domain *sd;
-
-			sd = &per_cpu(node_domains, j).sd;
-			sd->groups = sg;
-		}
-		sg->__cpu_power = 0;
-		cpumask_copy(sched_group_cpus(sg), d.nodemask);
-		sg->next = sg;
-		cpumask_or(d.covered, d.covered, d.nodemask);
-		prev = sg;
-
-		for (j = 0; j < nr_node_ids; j++) {
-			int n = (i + j) % nr_node_ids;
-
-			cpumask_complement(d.notcovered, d.covered);
-			cpumask_and(d.tmpmask, d.notcovered, cpu_map);
-			cpumask_and(d.tmpmask, d.tmpmask, d.domainspan);
-			if (cpumask_empty(d.tmpmask))
-				break;
-
-			cpumask_and(d.tmpmask, d.tmpmask, cpumask_of_node(n));
-			if (cpumask_empty(d.tmpmask))
-				continue;
-
-			sg = kmalloc_node(sizeof(struct sched_group) +
-					  cpumask_size(),
-					  GFP_KERNEL, i);
-			if (!sg) {
-				printk(KERN_WARNING
-				"Can not alloc domain group for node %d\n", j);
-				goto error;
-			}
-			sg->__cpu_power = 0;
-			cpumask_copy(sched_group_cpus(sg), d.tmpmask);
-			sg->next = prev->next;
-			cpumask_or(d.covered, d.covered, d.tmpmask);
-			prev->next = sg;
-			prev = sg;
-		}
-	}
 #endif
 
 	/* Calculate CPU power for physical packages and nodes */
