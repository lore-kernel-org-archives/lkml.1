Return-Path: <linux-kernel-owner+w=401wt.eu-S1758704AbZHRK7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758704AbZHRK7k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 06:59:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758050AbZHRK7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 06:59:39 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:41089 "EHLO
	IE1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755527AbZHRK7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 06:59:38 -0400
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMzz1202hzzz32i6bh203h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KOKJV5-01-8Y1-02
X-M-MSG: 
Date: Tue, 18 Aug 2009 12:59:28 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 09/12] sched: Seperate out build of CPU sched groups from
	__build_sched_domains
Message-ID: <20090818105928.GJ29515@alberich.amd.com>
References: <20090818104944.GA29515@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090818104944.GA29515@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 18 Aug 2009 10:59:28.0899 (UTC) FILETIME=[F526D530:01CA1FF2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


... to further strip down __build_sched_domains().

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 kernel/sched.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index d045e5c..666017b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8692,6 +8692,13 @@ static void build_sched_groups(struct s_data *d, enum sched_domain_level l,
 						d->send_covered, d->tmpmask);
 		break;
 #endif
+	case SD_LV_CPU: /* set up physical groups */
+		cpumask_and(d->nodemask, cpumask_of_node(cpu), cpu_map);
+		if (!cpumask_empty(d->nodemask))
+			init_sched_build_groups(d->nodemask, cpu_map,
+						&cpu_to_phys_group,
+						d->send_covered, d->tmpmask);
+		break;
 	default:
 		break;
 	}
@@ -8737,15 +8744,8 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 	}
 
 	/* Set up physical groups */
-	for (i = 0; i < nr_node_ids; i++) {
-		cpumask_and(d.nodemask, cpumask_of_node(i), cpu_map);
-		if (cpumask_empty(d.nodemask))
-			continue;
-
-		init_sched_build_groups(d.nodemask, cpu_map,
-					&cpu_to_phys_group,
-					d.send_covered, d.tmpmask);
-	}
+	for (i = 0; i < nr_node_ids; i++)
+		build_sched_groups(&d, SD_LV_CPU, cpu_map, i);
 
 #ifdef CONFIG_NUMA
 	/* Set up node groups */
-- 
1.6.4



