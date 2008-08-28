Return-Path: <linux-kernel-owner+w=401wt.eu-S1752794AbYH1JP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794AbYH1JP0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 05:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750821AbYH1JPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 05:15:11 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:47382 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbYH1JPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 05:15:09 -0400
Date: Thu, 28 Aug 2008 14:42:49 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [patch] sched: call resched_task() conditionally from new task
	wake up path.
Message-ID: <20080828091249.GA3303@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

sched: call resched_task() conditionally from new task wake up path.

- During wake up of a new task, task_new_fair() can do a resched_task()
  on the current task. Later in the code path, check_preempt_curr() also ends
  up doing the same, which can be avoided. Check if TIF_NEED_RESCHED is
  already set for the current task.

- task_new_fair() does a resched_task() on the current task unconditionally.
  This can be done only in case when child runs before the parent.

Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
CC: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1348,6 +1348,13 @@ static void check_preempt_wakeup(struct 
 	if (unlikely(se == pse))
 		return;
 
+	/*
+	 * We can come here with TIF_NEED_RESCHED already set from new task
+	 * wake up path.
+	 */
+	if (test_tsk_need_resched(curr))
+		return;
+
 	cfs_rq_of(pse)->next = pse;
 
 	/*
@@ -1615,10 +1622,10 @@ static void task_new_fair(struct rq *rq,
 		 * 'current' within the tree based on its new key value.
 		 */
 		swap(curr->vruntime, se->vruntime);
+		resched_task(rq->curr);
 	}
 
 	enqueue_task_fair(rq, p, 0);
-	resched_task(rq->curr);
 }
 
 /*

Regards,
Bharata.
