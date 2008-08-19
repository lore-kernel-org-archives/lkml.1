Return-Path: <linux-kernel-owner+w=401wt.eu-S1754178AbYHSKqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178AbYHSKqQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 06:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753219AbYHSKo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 06:44:27 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54445 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201AbYHSKo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 06:44:26 -0400
Message-Id: <20080819103844.141902612@chello.nl>
References: <20080819103301.787700742@chello.nl>
User-Agent: quilt/0.46-1
Date: Tue, 19 Aug 2008 12:33:03 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Stefani Seibold <stefani@seibold.net>, Dario Faggioli <raistlin@linux.it>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/6] sched: rt-bandwidth accounting fix
Content-Disposition: inline; filename=sched-rt-bw-fix-accounting.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It fixes an accounting bug where we would continue accumulating runtime
even though the bandwidth control is disabled. This would lead to very long
throttle periods once bandwidth control gets turned on again.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched_rt.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

Index: linux-2.6/kernel/sched_rt.c
===================================================================
--- linux-2.6.orig/kernel/sched_rt.c
+++ linux-2.6/kernel/sched_rt.c
@@ -438,9 +438,6 @@ static int sched_rt_runtime_exceeded(str
 {
 	u64 runtime = sched_rt_runtime(rt_rq);
 
-	if (runtime == RUNTIME_INF)
-		return 0;
-
 	if (rt_rq->rt_throttled)
 		return rt_rq_throttled(rt_rq);
 
@@ -491,9 +488,11 @@ static void update_curr_rt(struct rq *rq
 		rt_rq = rt_rq_of_se(rt_se);
 
 		spin_lock(&rt_rq->rt_runtime_lock);
-		rt_rq->rt_time += delta_exec;
-		if (sched_rt_runtime_exceeded(rt_rq))
-			resched_task(curr);
+		if (sched_rt_runtime(rt_rq) != RUNTIME_INF) {
+			rt_rq->rt_time += delta_exec;
+			if (sched_rt_runtime_exceeded(rt_rq))
+				resched_task(curr);
+		}
 		spin_unlock(&rt_rq->rt_runtime_lock);
 	}
 }

-- 

