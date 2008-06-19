Return-Path: <linux-kernel-owner+w=401wt.eu-S1758598AbYFSMfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758598AbYFSMfi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 08:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756183AbYFSMf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 08:35:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:33532 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755504AbYFSMf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 08:35:27 -0400
Message-Id: <20080619123313.980647602@chello.nl>
References: <20080619122218.971447669@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 19 Jun 2008 14:22:22 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, "Daniel K." <dk@uw.no>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 04/10] sched: rt-group: fix RR buglet
Content-Disposition: inline; filename=sched-rt-rr-throttle-fix.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In tick_task_rt() we first call update_curr_rt() which can dequeue a runqueue
due to it running out of runtime, and then we try to requeue it, of it also 
having exhausted its RR quota. Obviously requeueing something that is no longer
on the runqueue will not have the expected result.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Tested-by: Daniel K. <dk@uw.no>
---
 kernel/sched_rt.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6/kernel/sched_rt.c
===================================================================
--- linux-2.6.orig/kernel/sched_rt.c
+++ linux-2.6/kernel/sched_rt.c
@@ -549,8 +549,10 @@ static
 void requeue_rt_entity(struct rt_rq *rt_rq, struct sched_rt_entity *rt_se)
 {
 	struct rt_prio_array *array = &rt_rq->active;
+	struct list_head *queue = array->queue + rt_se_prio(rt_se);
 
-	list_move_tail(&rt_se->run_list, array->queue + rt_se_prio(rt_se));
+	if (on_rt_rq(rt_se))
+		list_move_tail(&rt_se->run_list, queue);
 }
 
 static void requeue_task_rt(struct rq *rq, struct task_struct *p)

-- 

