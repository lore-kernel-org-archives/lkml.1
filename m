Return-Path: <linux-kernel-owner+w=401wt.eu-S1758726AbZHRLBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758726AbZHRLBS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 07:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758434AbZHRLBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 07:01:17 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:45119
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758256AbZHRLBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 07:01:17 -0400
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMzz1202hzzz32i6bh203h61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KOKJXZ-02-6FB-02
X-M-MSG: 
Date: Tue, 18 Aug 2009 13:01:11 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 11/12] sched: Seperate out build of NUMA sched groups from
	__build_sched_domains
Message-ID: <20090818110111.GL29515@alberich.amd.com>
References: <20090818104944.GA29515@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090818104944.GA29515@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 18 Aug 2009 11:01:11.0652 (UTC) FILETIME=[3265B240:01CA1FF3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


... to further strip down __build_sched_domains().

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 kernel/sched.c |  130 +++++++++++++++++++++++++++++---------------------------
 1 files changed, 67 insertions(+), 63 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 8f53701..1933641 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8352,6 +8352,71 @@ static void init_numa_sched_groups_power(struct sched_group *group_head)
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
@@ -8758,70 +8823,9 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
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
-- 
1.6.4



