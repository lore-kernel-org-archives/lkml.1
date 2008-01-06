Return-Path: <linux-kernel-owner+w=401wt.eu-S1759697AbYAFQ0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759697AbYAFQ0d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 11:26:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759630AbYAFQY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 11:24:26 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:47233 "EHLO
	viefep12-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759618AbYAFQYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 11:24:25 -0500
Message-Id: <20080106162123.836922000@chello.nl>
References: <20080106161128.152634000@chello.nl>
User-Agent: quilt/0.45-1
Date: Sun, 06 Jan 2008 17:11:34 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       dmitry.adamushko@gmail.com,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 06/11] sched: rt-group: reduce rescheduling
Content-Disposition: inline; filename=sched-rt-group-fix-enqueue.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only reschedule if the new group has a higher prio task.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched_rt.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6/kernel/sched_rt.c
===================================================================
--- linux-2.6.orig/kernel/sched_rt.c
+++ linux-2.6/kernel/sched_rt.c
@@ -94,8 +94,11 @@ static void sched_rt_ratio_enqueue(struc
 	struct sched_rt_entity *rt_se = rt_rq->rt_se;
 
 	if (rt_se && !on_rt_rq(rt_se) && rt_rq->rt_nr_running) {
+		struct task_struct *curr = rq_of_rt_rq(rt_rq)->curr;
+
 		enqueue_rt_entity(rt_se);
-		resched_task(rq_of_rt_rq(rt_rq)->curr);
+		if (rt_rq->highest_prio < curr->prio)
+			resched_task(curr);
 	}
 }
 

--

