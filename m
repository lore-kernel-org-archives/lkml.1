Return-Path: <linux-kernel-owner+w=401wt.eu-S1757293AbYFSMgG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757293AbYFSMgG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 08:36:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758008AbYFSMfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 08:35:32 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44114 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757663AbYFSMfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 08:35:31 -0400
Message-Id: <20080619123314.398446193@chello.nl>
References: <20080619122218.971447669@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 19 Jun 2008 14:22:28 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, "Daniel K." <dk@uw.no>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 10/10] sched: rt: dont stop the period timer when there are tasks wanting to run
Content-Disposition: inline; filename=sched-rt-fix-timer-idle.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a runnable group failed to get any runtime within a period it would be
found idle and the period timer would be stopped.

So if the group ever gets throttled, it will never wake up again.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Reported-by: "Daniel K." <dk@uw.no>
---
 kernel/sched_rt.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6/kernel/sched_rt.c
===================================================================
--- linux-2.6.orig/kernel/sched_rt.c
+++ linux-2.6/kernel/sched_rt.c
@@ -408,7 +408,8 @@ static int do_sched_rt_period_timer(stru
 			if (rt_rq->rt_time || rt_rq->rt_nr_running)
 				idle = 0;
 			spin_unlock(&rt_rq->rt_runtime_lock);
-		}
+		} else if (rt_rq->rt_nr_running)
+			idle = 0;
 
 		if (enqueue)
 			sched_rt_rq_enqueue(rt_rq);

-- 

