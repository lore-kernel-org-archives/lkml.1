Return-Path: <linux-kernel-owner+w=401wt.eu-S1754181AbYH1LoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181AbYH1LoS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 07:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752146AbYH1LoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 07:44:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47554 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997AbYH1LoG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 07:44:06 -0400
Date: Thu, 28 Aug 2008 13:43:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] scheduler fixes
Message-ID: <20080828114353.GA1651@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

Thanks,

	Ingo

------------------>
John Blackwood (1):
      sched: fix sched_rt_rq_enqueue() resched idle

Peter Zijlstra (1):
      sched: rt-bandwidth accounting fix


 kernel/sched_rt.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 998ba54..5523107 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -199,6 +199,8 @@ static inline struct rt_rq *group_rt_rq(struct sched_rt_entity *rt_se)
 
 static inline void sched_rt_rq_enqueue(struct rt_rq *rt_rq)
 {
+	if (rt_rq->rt_nr_running)
+		resched_task(rq_of_rt_rq(rt_rq)->curr);
 }
 
 static inline void sched_rt_rq_dequeue(struct rt_rq *rt_rq)
@@ -438,9 +440,6 @@ static int sched_rt_runtime_exceeded(struct rt_rq *rt_rq)
 {
 	u64 runtime = sched_rt_runtime(rt_rq);
 
-	if (runtime == RUNTIME_INF)
-		return 0;
-
 	if (rt_rq->rt_throttled)
 		return rt_rq_throttled(rt_rq);
 
@@ -491,9 +490,11 @@ static void update_curr_rt(struct rq *rq)
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
