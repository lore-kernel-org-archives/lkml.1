Return-Path: <linux-kernel-owner+w=401wt.eu-S1759544AbYFSMhQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759544AbYFSMhQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 08:37:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758423AbYFSMff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 08:35:35 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44118 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758289AbYFSMfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 08:35:33 -0400
Message-Id: <20080619123314.332414229@chello.nl>
References: <20080619122218.971447669@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 19 Jun 2008 14:22:27 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, "Daniel K." <dk@uw.no>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 09/10] sched: rt: fix the bandwidth contraint computations
Content-Disposition: inline; filename=sched-rt-fixup-constraints.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 - allow a subgroup to use all of its parent's bandwidth
 - contrain the global bandwidth to not be lower than the root group's

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c    |   11 ++++++++---
 kernel/sched_rt.c |    3 +++
 2 files changed, 11 insertions(+), 3 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -8354,7 +8354,7 @@ static unsigned long to_ratio(u64 period
 #ifdef CONFIG_CGROUP_SCHED
 static int __rt_schedulable(struct task_group *tg, u64 period, u64 runtime)
 {
-	struct task_group *tgi, *parent = tg ? tg->parent : NULL;
+	struct task_group *tgi, *parent = tg->parent;
 	unsigned long total = 0;
 
 	if (!parent) {
@@ -8378,7 +8378,7 @@ static int __rt_schedulable(struct task_
 	}
 	rcu_read_unlock();
 
-	return total + to_ratio(period, runtime) <
+	return total + to_ratio(period, runtime) <=
 		to_ratio(ktime_to_ns(parent->rt_bandwidth.rt_period),
 				parent->rt_bandwidth.rt_runtime);
 }
@@ -8495,10 +8495,15 @@ long sched_group_rt_period(struct task_g
 
 static int sched_rt_global_constraints(void)
 {
+	struct task_group *tg = &root_task_group;
+	u64 rt_runtime, rt_period;
 	int ret = 0;
 
+	rt_period = ktime_to_ns(tg->rt_bandwidth.rt_period);
+	rt_runtime = tg->rt_bandwidth.rt_runtime;
+
 	mutex_lock(&rt_constraints_mutex);
-	if (!__rt_schedulable(NULL, 1, 0))
+	if (!__rt_schedulable(tg, rt_period, rt_runtime))
 		ret = -EINVAL;
 	mutex_unlock(&rt_constraints_mutex);
 

-- 

