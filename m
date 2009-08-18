Return-Path: <linux-kernel-owner+w=401wt.eu-S1758763AbZHRLLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758763AbZHRLLd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 07:11:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758729AbZHRLLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 07:11:32 -0400
Received: from sg2ehsobe005.messaging.microsoft.com ([207.46.51.79]:37134 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758720AbZHRLLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 07:11:31 -0400
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMzz1202hzzz32i6bh203h64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0KOKJPQ-02-6B4-02
X-M-MSG: 
Date: Tue, 18 Aug 2009 12:56:14 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 05/12] sched: Seperate out build of MC sched domain from
	__build_sched_domains
Message-ID: <20090818105614.GF29515@alberich.amd.com>
References: <20090818104944.GA29515@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090818104944.GA29515@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 18 Aug 2009 10:56:14.0613 (UTC) FILETIME=[81592450:01CA1FF2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


... to further strip down __build_sched_domains().

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 kernel/sched.c |   30 ++++++++++++++++++------------
 1 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index a2e09f4..e24cb49 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8635,6 +8635,23 @@ static struct sched_domain *__build_cpu_sched_domain(struct s_data *d,
 	return sd;
 }
 
+static struct sched_domain *__build_mc_sched_domain(struct s_data *d,
+	const struct cpumask *cpu_map, struct sched_domain_attr *attr,
+	struct sched_domain *parent, int i)
+{
+	struct sched_domain *sd = parent;
+#ifdef CONFIG_SCHED_MC
+	sd = &per_cpu(core_domains, i).sd;
+	SD_INIT(sd, MC);
+	set_domain_attribute(sd, attr);
+	cpumask_and(sched_domain_span(sd), cpu_map, cpu_coregroup_mask(i));
+	sd->parent = parent;
+	parent->child = sd;
+	cpu_to_core_group(i, cpu_map, &sd->groups, d->tmpmask);
+#endif
+	return sd;
+}
+
 /*
  * Build sched domains for a given set of cpus and attach the sched domains
  * to the individual cpus
@@ -8665,18 +8682,7 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 
 		sd = __build_numa_sched_domains(&d, cpu_map, attr, i);
 		sd = __build_cpu_sched_domain(&d, cpu_map, attr, sd, i);
-
-#ifdef CONFIG_SCHED_MC
-		p = sd;
-		sd = &per_cpu(core_domains, i).sd;
-		SD_INIT(sd, MC);
-		set_domain_attribute(sd, attr);
-		cpumask_and(sched_domain_span(sd), cpu_map,
-						   cpu_coregroup_mask(i));
-		sd->parent = p;
-		p->child = sd;
-		cpu_to_core_group(i, cpu_map, &sd->groups, d.tmpmask);
-#endif
+		sd = __build_mc_sched_domain(&d, cpu_map, attr, sd, i);
 
 #ifdef CONFIG_SCHED_SMT
 		p = sd;
-- 
1.6.4



