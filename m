Return-Path: <linux-kernel-owner+w=401wt.eu-S1753742AbZIAIwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742AbZIAIwf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 04:52:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753566AbZIAIvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 04:51:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48615 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521AbZIAIvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 04:51:39 -0400
Message-Id: <20090901083826.073345955@chello.nl>
References: <20090901083431.748830771@chello.nl>
User-Agent: quilt/0.46-1
Date: Tue, 01 Sep 2009 10:34:35 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Gautham R Shenoy <ego@in.ibm.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Balbir Singh <balbir@in.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 4/8] sched: add smt_gain
Content-Disposition: inline; filename=sched-lb-1b.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The idea is that multi-threading a core yields more work capacity than
a single thread, provide a way to express a static gain for threads.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/sched.h    |    1 +
 include/linux/topology.h |    1 +
 kernel/sched.c           |    8 +++++++-
 3 files changed, 9 insertions(+), 1 deletion(-)

Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -930,6 +930,7 @@ struct sched_domain {
 	unsigned int newidle_idx;
 	unsigned int wake_idx;
 	unsigned int forkexec_idx;
+	unsigned int smt_gain;
 	int flags;			/* See SD_* */
 	enum sched_domain_level level;
 
Index: linux-2.6/include/linux/topology.h
===================================================================
--- linux-2.6.orig/include/linux/topology.h
+++ linux-2.6/include/linux/topology.h
@@ -99,6 +99,7 @@ int arch_update_cpu_topology(void);
 				| SD_SHARE_CPUPOWER,	\
 	.last_balance		= jiffies,		\
 	.balance_interval	= 1,			\
+	.smt_gain		= 1178,	/* 15% */	\
 }
 #endif
 #endif /* CONFIG_SCHED_SMT */
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -8490,9 +8490,15 @@ static void init_sched_groups_power(int 
 		weight = cpumask_weight(sched_domain_span(sd));
 		/*
 		 * SMT siblings share the power of a single core.
+		 * Usually multiple threads get a better yield out of
+		 * that one core than a single thread would have,
+		 * reflect that in sd->smt_gain.
 		 */
-		if ((sd->flags & SD_SHARE_CPUPOWER) && weight > 1)
+		if ((sd->flags & SD_SHARE_CPUPOWER) && weight > 1) {
+			power *= sd->smt_gain;
 			power /= weight;
+			power >>= SCHED_LOAD_SHIFT;
+		}
 		sg_inc_cpu_power(sd->groups, power);
 		return;
 	}

-- 

