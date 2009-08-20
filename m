Return-Path: <linux-kernel-owner+w=401wt.eu-S1754542AbZHTNim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542AbZHTNim (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 09:38:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754497AbZHTNil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 09:38:41 -0400
Received: from sg2ehsobe002.messaging.microsoft.com ([207.46.51.76]:48997 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751513AbZHTNik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 09:38:40 -0400
X-SpamScore: -3
X-BigFish: VPS-3(zz14c3Lzz1202hzzz32i6bh203h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KOOGK3-02-8C8-02
X-M-MSG: 
Date: Thu, 20 Aug 2009 15:38:28 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 7/15] sched: Activate build of MN domains
Message-ID: <20090820133828.GV29327@alberich.amd.com>
References: <20090820131243.GO29327@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090820131243.GO29327@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 20 Aug 2009 13:38:28.0544 (UTC) FILETIME=[800CA400:01CA219B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I.e. call __build_mn_sched_domain, build corresponding groups
and calculate power.

Note: still missing are changes in various places
to actually detect domain hierarchy and fixup some stuff.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 kernel/sched.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index cc16629..6cfc840 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8862,6 +8862,7 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 
 		sd = __build_numa_sched_domains(&d, cpu_map, attr, i);
 		sd = __build_cpu_sched_domain(&d, cpu_map, attr, sd, i);
+		sd = __build_mn_sched_domain(&d, cpu_map, attr, sd, i);
 		sd = __build_mc_sched_domain(&d, cpu_map, attr, sd, i);
 		sd = __build_smt_sched_domain(&d, cpu_map, attr, sd, i);
 	}
@@ -8869,6 +8870,7 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 	for_each_cpu(i, cpu_map) {
 		build_sched_groups(&d, SD_LV_SIBLING, cpu_map, i);
 		build_sched_groups(&d, SD_LV_MC, cpu_map, i);
+		build_sched_groups(&d, SD_LV_MN, cpu_map, i);
 	}
 
 	/* Set up physical groups */
@@ -8898,6 +8900,12 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 		init_sched_groups_power(i, sd);
 	}
 #endif
+#ifdef CONFIG_SCHED_MN
+	for_each_cpu(i, cpu_map) {
+		sd = &per_cpu(cpu_node_domains, i).sd;
+		init_sched_groups_power(i, sd);
+	}
+#endif
 
 	for_each_cpu(i, cpu_map) {
 		sd = &per_cpu(phys_domains, i).sd;
-- 
1.6.0.4



