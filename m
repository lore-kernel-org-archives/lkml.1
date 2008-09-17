Return-Path: <linux-kernel-owner+w=401wt.eu-S1754691AbYIQJ7G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691AbYIQJ7G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 05:59:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752217AbYIQJ6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 05:58:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54918 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292AbYIQJ6x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 05:58:53 -0400
Date: Wed, 17 Sep 2008 11:58:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [git pull] scheduler fixes
Message-ID: <20080917095836.GA9479@elte.hu>
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
Hiroshi Shimamoto (1):
      sched: fix deadlock in setting scheduler parameter to zero

Zhang, Yanmin (1):
      sched: fix 2.6.27-rc5 couldn't boot on tulsa machine randomly


 kernel/sched.c    |    6 ++++++
 kernel/sched_rt.c |    1 +
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index cc1f81b..9889080 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8909,6 +8909,9 @@ static int sched_rt_global_constraints(void)
 	u64 rt_runtime, rt_period;
 	int ret = 0;
 
+	if (sysctl_sched_rt_period <= 0)
+		return -EINVAL;
+
 	rt_period = ktime_to_ns(tg->rt_bandwidth.rt_period);
 	rt_runtime = tg->rt_bandwidth.rt_runtime;
 
@@ -8925,6 +8928,9 @@ static int sched_rt_global_constraints(void)
 	unsigned long flags;
 	int i;
 
+	if (sysctl_sched_rt_period <= 0)
+		return -EINVAL;
+
 	spin_lock_irqsave(&def_rt_bandwidth.rt_runtime_lock, flags);
 	for_each_possible_cpu(i) {
 		struct rt_rq *rt_rq = &cpu_rq(i)->rt;
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 5523107..1113157 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -350,6 +350,7 @@ static void __enable_runtime(struct rq *rq)
 		spin_lock(&rt_rq->rt_runtime_lock);
 		rt_rq->rt_runtime = rt_b->rt_runtime;
 		rt_rq->rt_time = 0;
+		rt_rq->rt_throttled = 0;
 		spin_unlock(&rt_rq->rt_runtime_lock);
 		spin_unlock(&rt_b->rt_runtime_lock);
 	}
