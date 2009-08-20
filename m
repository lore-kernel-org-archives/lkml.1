Return-Path: <linux-kernel-owner+w=401wt.eu-S1754617AbZHTNoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbZHTNoa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 09:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754476AbZHTNo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 09:44:29 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:51789
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754608AbZHTNo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 09:44:28 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i6bh203h43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KOOGT0-01-1BN-02
X-M-MSG: 
Date: Thu, 20 Aug 2009 15:43:47 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 13/15] sched: Detect child domain of NUMA (aka NODE) domain
Message-ID: <20090820134347.GB29327@alberich.amd.com>
References: <20090820131243.GO29327@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090820131243.GO29327@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 20 Aug 2009 13:43:47.0505 (UTC) FILETIME=[3E2A3A10:01CA219C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On multi-node processors a NUMA node might not span a socket.
Instead a socket might span several NUMA nodes.

This patch introduces a check whether NODE domain is parent
of MC domain and sets s_data.numa_child_level accordingly.
(See previous patch for further details.)

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 kernel/sched.c |   43 +++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index b03701d..0c950dc 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8869,6 +8869,45 @@ static void build_sched_groups(struct s_data *d, enum sched_domain_level l,
 	}
 }
 
+static enum sched_domain_level get_numa_child_domain_level(struct s_data *d,
+	const struct cpumask *cpu_map)
+{
+	enum sched_domain_level dl = SD_LV_NONE;
+#ifdef CONFIG_NUMA
+	int i;
+	int proper_superset = 0;
+	int proper_subset = 0;
+
+	for_each_cpu(i, cpu_map) {
+		cpumask_and(d->tmpmask, cpu_map, topology_cpu_node_cpumask(i));
+		cpumask_and(d->nodemask, cpu_map,
+			    cpumask_of_node(cpu_to_node(i)));
+
+		/* NUMA node's CPU set is proper subset of socket's CPU set */
+		if (cpumask_subset(d->nodemask, d->tmpmask) &&
+		    !cpumask_subset(d->tmpmask, d->nodemask))
+			proper_subset = 1;
+
+		/* socket's CPU set is proper subset of NUMA node's CPU set */
+		if (!cpumask_subset(d->nodemask, d->tmpmask) &&
+		    cpumask_subset(d->tmpmask, d->nodemask))
+			proper_superset = 1;
+	}
+
+	if (proper_subset && proper_superset)
+		printk(KERN_ERR "sched: inconsistent NUMA hierarchy\n");
+	else if (proper_subset) {
+		printk(KERN_DEBUG "sched: NUMA child domain: MC\n");
+		dl = SD_LV_MC;
+	} else {
+		printk(KERN_DEBUG "sched: NUMA child domain: CPU\n");
+		dl = SD_LV_CPU;
+	}
+
+#endif
+	return dl;
+}
+
 /*
  * Build sched domains for a given set of cpus and attach the sched domains
  * to the individual cpus
@@ -8881,13 +8920,13 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 	struct sched_domain *sd;
 	int i;
 
-	d.numa_child_level = SD_LV_NONE;
-
 	alloc_state = __visit_domain_allocation_hell(&d, cpu_map);
 	if (alloc_state != sa_rootdomain)
 		goto error;
 	alloc_state = sa_sched_groups;
 
+	d.numa_child_level = get_numa_child_domain_level(&d, cpu_map);
+
 	/*
 	 * Set up domains for cpus specified by the cpu_map.
 	 */
-- 
1.6.0.4



