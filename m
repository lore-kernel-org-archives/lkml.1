Return-Path: <linux-kernel-owner+w=401wt.eu-S1758758AbZHRLJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758758AbZHRLJw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 07:09:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758624AbZHRLJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 07:09:51 -0400
Received: from sg2ehsobe005.messaging.microsoft.com ([207.46.51.79]:35187 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750934AbZHRLJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 07:09:51 -0400
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMzz1202hzzz32i6bh203h64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0KOKJM6-02-69H-02
X-M-MSG: 
Date: Tue, 18 Aug 2009 12:54:06 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 03/12] sched: Seperate out build of NUMA sched domain from
	__build_sched_domains
Message-ID: <20090818105406.GD29515@alberich.amd.com>
References: <20090818104944.GA29515@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090818104944.GA29515@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 18 Aug 2009 10:54:06.0469 (UTC) FILETIME=[34F7EB50:01CA1FF2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


... to further strip down __build_sched_domains().

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 kernel/sched.c |   57 +++++++++++++++++++++++++++++++------------------------
 1 files changed, 32 insertions(+), 25 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 5aa7dad..e696cd9 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8588,6 +8588,37 @@ static enum s_alloc __visit_domain_allocation_hell(struct s_data *d,
 	return sa_rootdomain;
 }
 
+static struct sched_domain *__build_numa_sched_domains(struct s_data *d,
+	const struct cpumask *cpu_map, struct sched_domain_attr *attr, int i)
+{
+	struct sched_domain *sd = NULL;
+#ifdef CONFIG_NUMA
+	struct sched_domain *parent;
+
+	d->sd_allnodes = 0;
+	if (cpumask_weight(cpu_map) >
+	    SD_NODES_PER_DOMAIN * cpumask_weight(d->nodemask)) {
+		sd = &per_cpu(allnodes_domains, i).sd;
+		SD_INIT(sd, ALLNODES);
+		set_domain_attribute(sd, attr);
+		cpumask_copy(sched_domain_span(sd), cpu_map);
+		cpu_to_allnodes_group(i, cpu_map, &sd->groups, d->tmpmask);
+		d->sd_allnodes = 1;
+	}
+	parent = sd;
+
+	sd = &per_cpu(node_domains, i).sd;
+	SD_INIT(sd, NODE);
+	set_domain_attribute(sd, attr);
+	sched_domain_node_span(cpu_to_node(i), sched_domain_span(sd));
+	sd->parent = parent;
+	if (parent)
+		parent->child = sd;
+	cpumask_and(sched_domain_span(sd), sched_domain_span(sd), cpu_map);
+#endif
+	return sd;
+}
+
 /*
  * Build sched domains for a given set of cpus and attach the sched domains
  * to the individual cpus
@@ -8616,31 +8647,7 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 		cpumask_and(d.nodemask, cpumask_of_node(cpu_to_node(i)),
 			    cpu_map);
 
-#ifdef CONFIG_NUMA
-		if (cpumask_weight(cpu_map) >
-				SD_NODES_PER_DOMAIN*cpumask_weight(d.nodemask)) {
-			sd = &per_cpu(allnodes_domains, i).sd;
-			SD_INIT(sd, ALLNODES);
-			set_domain_attribute(sd, attr);
-			cpumask_copy(sched_domain_span(sd), cpu_map);
-			cpu_to_allnodes_group(i, cpu_map, &sd->groups,
-					      d.tmpmask);
-			p = sd;
-			d.sd_allnodes = 1;
-		} else
-			p = NULL;
-
-		sd = &per_cpu(node_domains, i).sd;
-		SD_INIT(sd, NODE);
-		set_domain_attribute(sd, attr);
-		sched_domain_node_span(cpu_to_node(i), sched_domain_span(sd));
-		sd->parent = p;
-		if (p)
-			p->child = sd;
-		cpumask_and(sched_domain_span(sd),
-			    sched_domain_span(sd), cpu_map);
-#endif
-
+		sd = __build_numa_sched_domains(&d, cpu_map, attr, i);
 		p = sd;
 		sd = &per_cpu(phys_domains, i).sd;
 		SD_INIT(sd, CPU);
-- 
1.6.4



