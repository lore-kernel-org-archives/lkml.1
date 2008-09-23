Return-Path: <linux-kernel-owner+w=401wt.eu-S1753281AbYIWNhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281AbYIWNhn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 09:37:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751424AbYIWNgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 09:36:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:34027 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbYIWNgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 09:36:31 -0400
Message-Id: <20080923133500.294161009@programming.kicks-ass.net>
References: <20080923133340.929758093@programming.kicks-ass.net>
User-Agent: quilt/0.46-1
Date: Tue, 23 Sep 2008 15:33:44 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 4/6] sched: more sanity checks on the bandwidth settings
Content-Disposition: inline; filename=sched-rt-bw-schedulable-fix.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While playing around with it, I noticed we missed some sanity checks.
Also add some comments while we're there.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |   33 ++++++++++++++++++++++++++++-----
 1 file changed, 28 insertions(+), 5 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -8892,11 +8892,29 @@ static int tg_schedulable(struct task_gr
 		runtime = d->rt_runtime;
 	}
 
+	/*
+	 * Cannot have more runtime than the period.
+	 */
+	if (runtime > period && runtime != RUNTIME_INF)
+		return -EINVAL;
+
+	/*
+	 * Ensure we don't starve existing RT tasks.
+	 */
 	if (rt_bandwidth_enabled() && !runtime && tg_has_rt_tasks(tg))
 		return -EBUSY;
 
 	total = to_ratio(period, runtime);
 
+	/*
+	 * Nobody can have more than the global setting allows.
+	 */
+	if (total > to_ratio(global_rt_period(), global_rt_runtime()))
+		return -EINVAL;
+
+	/*
+	 * The sum of our children's runtime should not exceed our own.
+	 */
 	list_for_each_entry_rcu(child, &tg->children, siblings) {
 		period = ktime_to_ns(child->rt_bandwidth.rt_period);
 		runtime = child->rt_bandwidth.rt_runtime;
@@ -9004,19 +9022,24 @@ long sched_group_rt_period(struct task_g
 
 static int sched_rt_global_constraints(void)
 {
-	struct task_group *tg = &root_task_group;
-	u64 rt_runtime, rt_period;
+	u64 runtime, period;
 	int ret = 0;
 
 	if (sysctl_sched_rt_period <= 0)
 		return -EINVAL;
 
-	rt_period = ktime_to_ns(tg->rt_bandwidth.rt_period);
-	rt_runtime = tg->rt_bandwidth.rt_runtime;
+	runtime = global_rt_runtime();
+	period = global_rt_period();
+
+	/*
+	 * Sanity check on the sysctl variables.
+	 */
+	if (runtime > period && runtime != RUNTIME_INF)
+		return -EINVAL;
 
 	mutex_lock(&rt_constraints_mutex);
 	read_lock(&tasklist_lock);
-	ret = __rt_schedulable(tg, rt_period, rt_runtime);
+	ret = __rt_schedulable(NULL, 0, 0);
 	read_unlock(&tasklist_lock);
 	mutex_unlock(&rt_constraints_mutex);
 

-- 

