Return-Path: <linux-kernel-owner+w=401wt.eu-S1755031AbZHRK5O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031AbZHRK5O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 06:57:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755527AbZHRK5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 06:57:13 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:46379
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754266AbZHRK5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 06:57:13 -0400
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMzz1202hzzz32i6bh203h64h)
X-Spam-TCS-SCL: 3:0
X-FB-SS: 5,
X-WSS-ID: 0KOKJR4-01-8WB-02
X-M-MSG: 
Date: Tue, 18 Aug 2009 12:57:03 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 06/12] sched: Seperate out build of SMT sched domain from
	__build_sched_domains
Message-ID: <20090818105703.GG29515@alberich.amd.com>
References: <20090818104944.GA29515@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090818104944.GA29515@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 18 Aug 2009 10:57:03.0692 (UTC) FILETIME=[9E9A00C0:01CA1FF2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


... to further strip down __build_sched_domains().

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 kernel/sched.c |   32 +++++++++++++++++++-------------
 1 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index e24cb49..a253ca6 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8652,6 +8652,23 @@ static struct sched_domain *__build_mc_sched_domain(struct s_data *d,
 	return sd;
 }
 
+static struct sched_domain *__build_smt_sched_domain(struct s_data *d,
+	const struct cpumask *cpu_map, struct sched_domain_attr *attr,
+	struct sched_domain *parent, int i)
+{
+	struct sched_domain *sd = parent;
+#ifdef CONFIG_SCHED_SMT
+	sd = &per_cpu(cpu_domains, i).sd;
+	SD_INIT(sd, SIBLING);
+	set_domain_attribute(sd, attr);
+	cpumask_and(sched_domain_span(sd), cpu_map, topology_thread_cpumask(i));
+	sd->parent = parent;
+	parent->child = sd;
+	cpu_to_cpu_group(i, cpu_map, &sd->groups, d->tmpmask);
+#endif
+	return sd;
+}
+
 /*
  * Build sched domains for a given set of cpus and attach the sched domains
  * to the individual cpus
@@ -8675,7 +8692,7 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 	 * Set up domains for cpus specified by the cpu_map.
 	 */
 	for_each_cpu(i, cpu_map) {
-		struct sched_domain *sd = NULL, *p;
+		struct sched_domain *sd;
 
 		cpumask_and(d.nodemask, cpumask_of_node(cpu_to_node(i)),
 			    cpu_map);
@@ -8683,18 +8700,7 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 		sd = __build_numa_sched_domains(&d, cpu_map, attr, i);
 		sd = __build_cpu_sched_domain(&d, cpu_map, attr, sd, i);
 		sd = __build_mc_sched_domain(&d, cpu_map, attr, sd, i);
-
-#ifdef CONFIG_SCHED_SMT
-		p = sd;
-		sd = &per_cpu(cpu_domains, i).sd;
-		SD_INIT(sd, SIBLING);
-		set_domain_attribute(sd, attr);
-		cpumask_and(sched_domain_span(sd),
-			    topology_thread_cpumask(i), cpu_map);
-		sd->parent = p;
-		p->child = sd;
-		cpu_to_cpu_group(i, cpu_map, &sd->groups, d.tmpmask);
-#endif
+		sd = __build_smt_sched_domain(&d, cpu_map, attr, sd, i);
 	}
 
 #ifdef CONFIG_SCHED_SMT
-- 
1.6.4



