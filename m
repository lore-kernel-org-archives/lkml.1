Return-Path: <linux-kernel-owner+w=401wt.eu-S1756440AbYBDVTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440AbYBDVTV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 16:19:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755940AbYBDVRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 16:17:19 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:41976 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755477AbYBDVRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 16:17:12 -0500
Message-Id: <20080204211837.636773000@chello.nl>
References: <20080204210258.118479000@chello.nl>
User-Agent: quilt/0.45-1
Date: Mon, 04 Feb 2008 22:03:04 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: tong.n.li@intel.com, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 6/8] sched: rt-group: refure unrunnable tasks
Content-Disposition: inline; filename=sched-rt-group-accept.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refuse to accept or create RT tasks in groups that can't run them.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -4588,6 +4588,15 @@ recheck:
 			return -EPERM;
 	}
 
+#ifdef CONFIG_RT_GROUP_SCHED
+	/*
+	 * Do not allow realtime tasks into groups that have no runtime
+	 * assigned.
+	 */
+	if (rt_policy(policy) && task_group(p)->rt_runtime == 0)
+		return -EPERM;
+#endif
+
 	retval = security_task_setscheduler(p, policy, param);
 	if (retval)
 		return retval;
@@ -8005,9 +8014,15 @@ static int
 cpu_cgroup_can_attach(struct cgroup_subsys *ss, struct cgroup *cgrp,
 		      struct task_struct *tsk)
 {
+#ifdef CONFIG_RT_GROUP_SCHED
+	/* Don't accept realtime tasks when there is no way for them to run */
+	if (rt_task(tsk) && cgroup_tg(cgrp)->rt_runtime == 0)
+		return -EINVAL;
+#else
 	/* We don't support RT-tasks being in separate groups */
 	if (tsk->sched_class != &fair_sched_class)
 		return -EINVAL;
+#endif
 
 	return 0;
 }

--

