Return-Path: <linux-kernel-owner+w=401wt.eu-S1754526AbZHTNg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526AbZHTNg6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 09:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754409AbZHTNg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 09:36:57 -0400
Received: from sg2ehsobe004.messaging.microsoft.com ([207.46.51.78]:58227 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754169AbZHTNg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 09:36:57 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i6bh203h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KOOGH7-01-12S-02
X-M-MSG: 
Date: Thu, 20 Aug 2009 15:36:43 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 5/15] sched: Add function to build MN sched domain
Message-ID: <20090820133643.GT29327@alberich.amd.com>
References: <20090820131243.GO29327@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090820131243.GO29327@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 20 Aug 2009 13:36:43.0494 (UTC) FILETIME=[416F4860:01CA219B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 kernel/sched.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index d85985d..7b8b2ab 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8569,6 +8569,9 @@ SD_INIT_FUNC(CPU)
 #ifdef CONFIG_SCHED_MC
  SD_INIT_FUNC(MC)
 #endif
+#ifdef CONFIG_SCHED_MN
+ SD_INIT_FUNC(MN)
+#endif
 
 static int default_relax_domain_level = -1;
 
@@ -8727,6 +8730,24 @@ static struct sched_domain *__build_cpu_sched_domain(struct s_data *d,
 	return sd;
 }
 
+static struct sched_domain *__build_mn_sched_domain(struct s_data *d,
+	const struct cpumask *cpu_map, struct sched_domain_attr *attr,
+	struct sched_domain *parent, int i)
+{
+	struct sched_domain *sd = parent;
+#ifdef CONFIG_SCHED_MN
+	sd = &per_cpu(cpu_node_domains, i).sd;
+	SD_INIT(sd, MN);
+	set_domain_attribute(sd, attr);
+	cpumask_and(sched_domain_span(sd), cpu_map,
+		    topology_cpu_node_cpumask(i));
+	sd->parent = parent;
+	parent->child = sd;
+	cpu_to_cpu_node_group(i, cpu_map, &sd->groups, d->tmpmask);
+#endif
+	return sd;
+}
+
 static struct sched_domain *__build_mc_sched_domain(struct s_data *d,
 	const struct cpumask *cpu_map, struct sched_domain_attr *attr,
 	struct sched_domain *parent, int i)
-- 
1.6.0.4



