Return-Path: <linux-kernel-owner+w=401wt.eu-S1754169AbYHPN6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169AbYHPN6r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 09:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752141AbYHPN6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 09:58:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53638 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920AbYHPN6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 09:58:37 -0400
Date: Sat, 16 Aug 2008 15:58:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] scheduler fixes for v2.6.27
Message-ID: <20080816135823.GA10277@elte.hu>
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
Peter Zijlstra (2):
      sched: fix rt-bandwidth hotplug race
      sched: scale sysctl_sched_shares_ratelimit with nr_cpus

Zhang, Yanmin (1):
      sched: fix the race between walk_tg_tree and sched_create_group


 kernel/sched.c    |    8 +++++---
 kernel/sched_rt.c |    2 +-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index d601fb0..0408071 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -808,9 +808,9 @@ const_debug unsigned int sysctl_sched_nr_migrate = 32;
 
 /*
  * ratelimit for updating the group shares.
- * default: 0.5ms
+ * default: 0.25ms
  */
-const_debug unsigned int sysctl_sched_shares_ratelimit = 500000;
+unsigned int sysctl_sched_shares_ratelimit = 250000;
 
 /*
  * period over which we measure -rt task cpu usage in us.
@@ -5740,6 +5740,8 @@ static inline void sched_init_granularity(void)
 		sysctl_sched_latency = limit;
 
 	sysctl_sched_wakeup_granularity *= factor;
+
+	sysctl_sched_shares_ratelimit *= factor;
 }
 
 #ifdef CONFIG_SMP
@@ -8462,8 +8464,8 @@ struct task_group *sched_create_group(struct task_group *parent)
 	WARN_ON(!parent); /* root should already exist */
 
 	tg->parent = parent;
-	list_add_rcu(&tg->siblings, &parent->children);
 	INIT_LIST_HEAD(&tg->children);
+	list_add_rcu(&tg->siblings, &parent->children);
 	spin_unlock_irqrestore(&task_group_lock, flags);
 
 	return tg;
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 6163e4c..998ba54 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -298,7 +298,7 @@ static void __disable_runtime(struct rq *rq)
 			struct rt_rq *iter = sched_rt_period_rt_rq(rt_b, i);
 			s64 diff;
 
-			if (iter == rt_rq)
+			if (iter == rt_rq || iter->rt_runtime == RUNTIME_INF)
 				continue;
 
 			spin_lock(&iter->rt_runtime_lock);
