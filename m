Return-Path: <linux-kernel-owner+w=401wt.eu-S1755482AbYB0LIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482AbYB0LIv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 06:08:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752140AbYB0LIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 06:08:43 -0500
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:41547 "EHLO
	e28esmtp04.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751671AbYB0LIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 06:08:42 -0500
Date: Wed, 27 Feb 2008 16:38:29 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Sudhir Kumar <skumar@linux.vnet.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Aneesh Kumar KV <aneesh.kumar@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] sched: don't allow rt_runtime_us to be zero for groups
	having rt tasks
Message-ID: <20080227110829.GA15731@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch checks if we can set the rt_runtime_us to 0. If there is a
realtime task in the group, we don't want to set the rt_runtime_us to 0
otherwise bad things will happen.

Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
---
 kernel/sched.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+)

Index: linux-2.6.25-rc3/kernel/sched.c
===================================================================
--- linux-2.6.25-rc3.orig/kernel/sched.c
+++ linux-2.6.25-rc3/kernel/sched.c
@@ -7960,6 +7960,17 @@ static int __rt_schedulable(struct task_
 	return total + to_ratio(period, runtime) < global_ratio;
 }
 
+/* Must be called with tasklist_lock held */
+static inline int tg_has_rt_tasks(struct task_group *tg)
+{
+	struct task_struct *p;
+	for_each_process(p) {
+		if (rt_task(p) && rt_rq_of_se(&p->rt)->tg == tg)
+			return 1;
+	}
+	return 0;
+}
+
 int sched_group_set_rt_runtime(struct task_group *tg, long rt_runtime_us)
 {
 	u64 rt_runtime, rt_period;
@@ -7971,6 +7982,13 @@ int sched_group_set_rt_runtime(struct ta
 		rt_runtime = rt_period;
 
 	mutex_lock(&rt_constraints_mutex);
+	read_lock(&tasklist_lock);
+	if (rt_runtime_us == 0) {
+		if (tg_has_rt_tasks(tg)) {
+			err = -EINVAL;
+			goto unlock;
+		}
+	}
 	if (!__rt_schedulable(tg, rt_period, rt_runtime)) {
 		err = -EINVAL;
 		goto unlock;
@@ -7979,6 +7997,7 @@ int sched_group_set_rt_runtime(struct ta
 		rt_runtime = RUNTIME_INF;
 	tg->rt_runtime = rt_runtime;
  unlock:
+	read_unlock(&tasklist_lock);
 	mutex_unlock(&rt_constraints_mutex);
 
 	return err;
-- 
regards,
Dhaval
