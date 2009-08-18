Return-Path: <linux-kernel-owner+w=401wt.eu-S1758699AbZHRK6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758699AbZHRK6v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 06:58:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758053AbZHRK6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 06:58:50 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:38748 "EHLO
	IE1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754333AbZHRK6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 06:58:50 -0400
X-SpamScore: -2
X-BigFish: VPS-2(zz936eMzz1202hzzz32i6bh203h43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KOKJTR-01-8X8-02
X-M-MSG: 
Date: Tue, 18 Aug 2009 12:58:38 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 08/12] sched: Seperate out build of MC sched groups from
	__build_sched_domains
Message-ID: <20090818105838.GI29515@alberich.amd.com>
References: <20090818104944.GA29515@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090818104944.GA29515@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 18 Aug 2009 10:58:39.0289 (UTC) FILETIME=[D794F290:01CA1FF2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


... to further strip down __build_sched_domains().

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 kernel/sched.c |   23 ++++++++++-------------
 1 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index cd00d9e..d045e5c 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8683,6 +8683,15 @@ static void build_sched_groups(struct s_data *d, enum sched_domain_level l,
 						d->send_covered, d->tmpmask);
 		break;
 #endif
+#ifdef CONFIG_SCHED_MC
+	case SD_LV_MC: /* set up multi-core groups */
+		cpumask_and(d->this_core_map, cpu_map, cpu_coregroup_mask(cpu));
+		if (cpu == cpumask_first(d->this_core_map))
+			init_sched_build_groups(d->this_core_map, cpu_map,
+						&cpu_to_core_group,
+						d->send_covered, d->tmpmask);
+		break;
+#endif
 	default:
 		break;
 	}
@@ -8724,21 +8733,9 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 
 	for_each_cpu(i, cpu_map) {
 		build_sched_groups(&d, SD_LV_SIBLING, cpu_map, i);
+		build_sched_groups(&d, SD_LV_MC, cpu_map, i);
 	}
 
-#ifdef CONFIG_SCHED_MC
-	/* Set up multi-core groups */
-	for_each_cpu(i, cpu_map) {
-		cpumask_and(d.this_core_map, cpu_coregroup_mask(i), cpu_map);
-		if (i != cpumask_first(d.this_core_map))
-			continue;
-
-		init_sched_build_groups(d.this_core_map, cpu_map,
-					&cpu_to_core_group,
-					d.send_covered, d.tmpmask);
-	}
-#endif
-
 	/* Set up physical groups */
 	for (i = 0; i < nr_node_ids; i++) {
 		cpumask_and(d.nodemask, cpumask_of_node(i), cpu_map);
-- 
1.6.4



