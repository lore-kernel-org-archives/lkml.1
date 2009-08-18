Return-Path: <linux-kernel-owner+w=401wt.eu-S1759490AbZHRQyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759490AbZHRQyS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 12:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759389AbZHRQyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 12:54:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:42289 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759431AbZHRQxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 12:53:24 -0400
Date: Tue, 18 Aug 2009 16:52:14 GMT
From: tip-bot for Andreas Herrmann <andreas.herrmann3@amd.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       andreas.herrmann3@amd.com, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andreas.herrmann3@amd.com, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20090818105406.GD29515@alberich.amd.com>
References: <20090818105406.GD29515@alberich.amd.com>
Subject: [tip:sched/domains] sched: Separate out build of NUMA sched domain from __build_sched_domains
Message-ID: <tip-7f4588f3aa395632fec9ba2e15a1920f0682fda0@git.kernel.org>
Git-Commit-ID: 7f4588f3aa395632fec9ba2e15a1920f0682fda0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 18 Aug 2009 16:52:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7f4588f3aa395632fec9ba2e15a1920f0682fda0
Gitweb:     http://git.kernel.org/tip/7f4588f3aa395632fec9ba2e15a1920f0682fda0
Author:     Andreas Herrmann <andreas.herrmann3@amd.com>
AuthorDate: Tue, 18 Aug 2009 12:54:06 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 18 Aug 2009 18:35:40 +0200

sched: Separate out build of NUMA sched domain from __build_sched_domains

... to further strip down __build_sched_domains().

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20090818105406.GD29515@alberich.amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c |   57 +++++++++++++++++++++++++++++++------------------------
 1 files changed, 32 insertions(+), 25 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index c5d1fee..dd95a47 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8482,6 +8482,37 @@ static enum s_alloc __visit_domain_allocation_hell(struct s_data *d,
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
@@ -8510,31 +8541,7 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
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
