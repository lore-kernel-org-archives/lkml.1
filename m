Return-Path: <linux-kernel-owner+w=401wt.eu-S1757567AbYJQRag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567AbYJQRag (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 13:30:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755921AbYJQR3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 13:29:47 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37821 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755839AbYJQR3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 13:29:46 -0400
Message-Id: <20081017172829.768067427@chello.nl>
References: <20081017172701.047939625@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 17 Oct 2008 19:27:05 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>, Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 4/4] sched: fix wakeup preemption
Content-Disposition: inline; filename=sched-fix-wakeup-preempt.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In my recent wakeup preempt rework I messed up the asym wakeup.
The idea is that it should be easier to preempt lighter tasks
but not harder to preempt heavier tasks.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched_fair.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -1243,8 +1243,8 @@ static unsigned long wakeup_gran(struct 
 	 * More easily preempt - nice tasks, while not making it harder for
 	 * + nice tasks.
 	 */
-	if (sched_feat(ASYM_GRAN))
-		gran = calc_delta_mine(gran, NICE_0_LOAD, &se->load);
+	if (sched_feat(ASYM_GRAN) && se->load.weight < NICE_0_LOAD)
+		gran = (gran * se->load.weight) >> NICE_0_SHIFT;
 
 	return gran;
 }
@@ -1296,7 +1296,7 @@ static void check_preempt_wakeup(struct 
 	}
 
 	delta_exec = se->sum_exec_runtime - se->prev_sum_exec_runtime;
-	if (delta_exec > wakeup_gran(pse))
+	if (delta_exec > wakeup_gran(se))
 		resched_task(curr);
 }
 

-- 

