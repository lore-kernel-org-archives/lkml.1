Return-Path: <linux-kernel-owner+w=401wt.eu-S1754170AbYKTGTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbYKTGTZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 01:19:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753206AbYKTGTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 01:19:16 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:36973 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753100AbYKTGTQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 01:19:16 -0500
Date: Thu, 20 Nov 2008 11:48:54 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: [PATCH] sched: Don't allow priority switch to realtime when the
	task doesn't belong to init_task_group and when
	CONFIG_RT_GROUP_SCHED isn't set
Message-ID: <20081120061854.GA4349@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applies on 2.6.28-rc5.

With CONFIG_RT_GROUP_SCHED not set, don't allow a task's priority switch
to realtime if the task isn't part of init_task_group.

A task belonging to a fair group could use sched_setscheduler/sched_setparam
to become a realtime task. If such a task belongs to one of the
child groups of init_task_group and if CONFIG_RT_GROUP_SCHED is not set,
then it ends up getting queued in init_task_group's runqueue.
So we have a situation where, a task belongs to one group (child)
but ends in the runqueue of another group (init_task_group).
This does not look correct.

Fix this by failing such priority change requests in sched_setscheduler()
and sched_setparam().

Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
---
 kernel/sched.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5206,6 +5206,13 @@ recheck:
 		if (rt_bandwidth_enabled() && rt_policy(policy) &&
 				task_group(p)->rt_bandwidth.rt_runtime == 0)
 			return -EPERM;
+#elif defined(CONFIG_FAIR_GROUP_SCHED)
+		/*
+		 * If the task doesn't belong to init_task_group, don't
+		 * allow priority switch to realtime. (!CONFIG_RT_GROUP_SCHED)
+		 */
+		if (rt_policy(policy) && (task_group(p) != &init_task_group))
+			return -EPERM;
 #endif
 
 		retval = security_task_setscheduler(p, policy, param);
Regards,
Bharata.
