Return-Path: <linux-kernel-owner+w=401wt.eu-S1758695AbZHRK6D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758695AbZHRK6D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 06:58:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755527AbZHRK6B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 06:58:01 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:36176 "EHLO
	IE1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754333AbZHRK6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 06:58:00 -0400
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMzz1202hzzz32i6bh203h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KOKJSG-01-8WN-02
X-M-MSG: 
Date: Tue, 18 Aug 2009 12:57:51 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 07/12] sched: Seperate out build of SMT sched groups from
	__build_sched_domains
Message-ID: <20090818105751.GH29515@alberich.amd.com>
References: <20090818104944.GA29515@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090818104944.GA29515@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 18 Aug 2009 10:57:51.0522 (UTC) FILETIME=[BB1C4820:01CA1FF2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


... to further strip down __build_sched_domains().

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 kernel/sched.c |   31 ++++++++++++++++++++-----------
 1 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index a253ca6..cd00d9e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8669,6 +8669,25 @@ static struct sched_domain *__build_smt_sched_domain(struct s_data *d,
 	return sd;
 }
 
+static void build_sched_groups(struct s_data *d, enum sched_domain_level l,
+			       const struct cpumask *cpu_map, int cpu)
+{
+	switch (l) {
+#ifdef CONFIG_SCHED_SMT
+	case SD_LV_SIBLING: /* set up CPU (sibling) groups */
+		cpumask_and(d->this_sibling_map, cpu_map,
+			    topology_thread_cpumask(cpu));
+		if (cpu == cpumask_first(d->this_sibling_map))
+			init_sched_build_groups(d->this_sibling_map, cpu_map,
+						&cpu_to_cpu_group,
+						d->send_covered, d->tmpmask);
+		break;
+#endif
+	default:
+		break;
+	}
+}
+
 /*
  * Build sched domains for a given set of cpus and attach the sched domains
  * to the individual cpus
@@ -8703,19 +8722,9 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 		sd = __build_smt_sched_domain(&d, cpu_map, attr, sd, i);
 	}
 
-#ifdef CONFIG_SCHED_SMT
-	/* Set up CPU (sibling) groups */
 	for_each_cpu(i, cpu_map) {
-		cpumask_and(d.this_sibling_map,
-			    topology_thread_cpumask(i), cpu_map);
-		if (i != cpumask_first(d.this_sibling_map))
-			continue;
-
-		init_sched_build_groups(d.this_sibling_map, cpu_map,
-					&cpu_to_cpu_group,
-					d.send_covered, d.tmpmask);
+		build_sched_groups(&d, SD_LV_SIBLING, cpu_map, i);
 	}
-#endif
 
 #ifdef CONFIG_SCHED_MC
 	/* Set up multi-core groups */
-- 
1.6.4



