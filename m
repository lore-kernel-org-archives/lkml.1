Return-Path: <linux-kernel-owner+w=401wt.eu-S1754519AbZHTNfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519AbZHTNfv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 09:35:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754434AbZHTNfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 09:35:50 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:47402 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754408AbZHTNft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 09:35:49 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i203h6bh62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KOOGFF-02-89S-02
X-M-MSG: 
Date: Thu, 20 Aug 2009 15:35:39 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 4/15] sched: Define per CPU variables and cpu_to_group
	function for MN domain
Message-ID: <20090820133539.GS29327@alberich.amd.com>
References: <20090820131243.GO29327@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090820131243.GO29327@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 20 Aug 2009 13:35:40.0054 (UTC) FILETIME=[1B9F1B60:01CA219B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Additionally fixup cpu_to_phys_group() in case of CONFIG_SCHED_MN=y.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 kernel/sched.c |   32 +++++++++++++++++++++++++++-----
 1 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 9990c3a..d85985d 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8255,9 +8255,27 @@ cpu_to_cpu_group(int cpu, const struct cpumask *cpu_map,
 #ifdef CONFIG_SCHED_MC
 static DEFINE_PER_CPU(struct static_sched_domain, core_domains);
 static DEFINE_PER_CPU(struct static_sched_group, sched_group_core);
-#endif /* CONFIG_SCHED_MC */
 
-#if defined(CONFIG_SCHED_MC) && defined(CONFIG_SCHED_SMT)
+/*
+ * multi-node sched-domains:
+ */
+#ifdef CONFIG_SCHED_MN
+static DEFINE_PER_CPU(struct static_sched_domain, cpu_node_domains);
+static DEFINE_PER_CPU(struct static_sched_group, sched_group_cpu_node);
+
+static int cpu_to_cpu_node_group(int cpu, const struct cpumask *cpu_map,
+                                 struct sched_group **sg, struct cpumask *mask)
+{
+        int group;
+        cpumask_and(mask, cpu_coregroup_mask(cpu), cpu_map);
+        group = cpumask_first(mask);
+        if (sg)
+                *sg = &per_cpu(sched_group_cpu_node, group).sg;
+        return group;
+}
+#endif /* CONFIG_SCHED_MN */
+
+#ifdef CONFIG_SCHED_SMT
 static int
 cpu_to_core_group(int cpu, const struct cpumask *cpu_map,
 		  struct sched_group **sg, struct cpumask *mask)
@@ -8270,7 +8288,7 @@ cpu_to_core_group(int cpu, const struct cpumask *cpu_map,
 		*sg = &per_cpu(sched_group_core, group).sg;
 	return group;
 }
-#elif defined(CONFIG_SCHED_MC)
+#else
 static int
 cpu_to_core_group(int cpu, const struct cpumask *cpu_map,
 		  struct sched_group **sg, struct cpumask *unused)
@@ -8279,7 +8297,8 @@ cpu_to_core_group(int cpu, const struct cpumask *cpu_map,
 		*sg = &per_cpu(sched_group_core, cpu).sg;
 	return cpu;
 }
-#endif
+#endif /* CONFIG_SCHED_SMT */
+#endif /* CONFIG_SCHED_MC */
 
 static DEFINE_PER_CPU(struct static_sched_domain, phys_domains);
 static DEFINE_PER_CPU(struct static_sched_group, sched_group_phys);
@@ -8289,7 +8308,10 @@ cpu_to_phys_group(int cpu, const struct cpumask *cpu_map,
 		  struct sched_group **sg, struct cpumask *mask)
 {
 	int group;
-#ifdef CONFIG_SCHED_MC
+#ifdef CONFIG_SCHED_MN
+	cpumask_and(mask, topology_cpu_node_cpumask(cpu), cpu_map);
+	group = cpumask_first(mask);
+#elif CONFIG_SCHED_MC
 	cpumask_and(mask, cpu_coregroup_mask(cpu), cpu_map);
 	group = cpumask_first(mask);
 #elif defined(CONFIG_SCHED_SMT)
-- 
1.6.0.4



