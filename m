Return-Path: <linux-kernel-owner+w=401wt.eu-S1759824AbYF0MC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759824AbYF0MC5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 08:02:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756873AbYF0L6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 07:58:09 -0400
Received: from viefep31-int.chello.at ([62.179.121.49]:64053 "EHLO
	viefep31-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760AbYF0L54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 07:57:56 -0400
Message-Id: <20080627115212.446496199@chello.nl>
References: <20080627114109.724249622@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jun 2008 13:41:39 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 30/30] sched: bias effective_load() error towards failing wake_affine().
Content-Disposition: inline; filename=sched-asymetric-effective-load.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Measurement shows that the difference between cgroup:/ and cgroup:/foo
wake_affine() results is that the latter succeeds significantly more.

Therefore bias the calculations towards failing the test.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched_fair.c     |   28 ++++++++++++++++++++++++++++
 kernel/sched_features.h |    1 +
 2 files changed, 29 insertions(+)

Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -1074,6 +1074,27 @@ static inline int wake_idle(int cpu, str
 static const struct sched_class fair_sched_class;
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
+/*
+ * effective_load() calculates the load change as seen from the root_task_group
+ *
+ * Adding load to a group doesn't make a group heavier, but can cause movement
+ * of group shares between cpus. Assuming the shares were perfectly aligned one
+ * can calculate the shift in shares.
+ *
+ * The problem is that perfectly aligning the shares is rather expensive, hence
+ * we try to avoid doing that too often - see update_shares(), which ratelimits
+ * this change.
+ *
+ * We compensate this by not only taking the current delta into account, but
+ * also considering the delta between when the shares were last adjusted and
+ * now.
+ *
+ * We still saw a performance dip, some tracing learned us that between
+ * cgroup:/ and cgroup:/foo balancing the number of affine wakeups increased
+ * significantly. Therefore try to bias the error in direction of failing
+ * the affine wakeup.
+ *
+ */
 static long effective_load(struct task_group *tg, int cpu,
 		long wl, long wg)
 {
@@ -1084,6 +1105,13 @@ static long effective_load(struct task_g
 		return wl;
 
 	/*
+	 * By not taking the decrease of shares on the other cpu into
+	 * account our error leans towards reducing the affine wakeups.
+	 */
+	if (!wl && sched_feat(ASYM_EFF_LOAD))
+		return wl;
+
+	/*
 	 * Instead of using this increment, also add the difference
 	 * between when the shares were last updated and now.
 	 */
Index: linux-2.6/kernel/sched_features.h
===================================================================
--- linux-2.6.orig/kernel/sched_features.h
+++ linux-2.6/kernel/sched_features.h
@@ -10,3 +10,4 @@ SCHED_FEAT(DOUBLE_TICK, 0)
 SCHED_FEAT(ASYM_GRAN, 1)
 SCHED_FEAT(LB_BIAS, 0)
 SCHED_FEAT(LB_WAKEUP_UPDATE, 1)
+SCHED_FEAT(ASYM_EFF_LOAD, 1)

-- 

