Return-Path: <linux-kernel-owner+w=401wt.eu-S1754476AbYDQUKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476AbYDQUKo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 16:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753004AbYDQUKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 16:10:34 -0400
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:55091
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752852AbYDQUKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 16:10:32 -0400
X-Greylist: delayed 1845 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Apr 2008 16:10:32 EDT
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH] sched: push rt tasks only if newly activated tasks have been
	added
To: suresh.b.siddha@intel.com
Cc: mingo@elte.hu, rostedt@goodmis.org, chinang.ma@intel.com,
       arjan@linux.intel.com, willy@linux.intel.com, ghaskins@novell.com,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Date: Thu, 17 Apr 2008 15:06:34 -0400
Message-ID: <20080417190544.6082.32545.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SCHED_RR can context-switch many times without having changed the run-queue.
Therefore trying to push on each context switch can just be wasted effort
since if it failed the first time, it will likely fail any subsequent times
as well.  Instead, set a flag when we have successfully pushed as many tasks
away as possible, and only clear it when the runqueue adds new tasks
(effectively becoming a run-queue "dirty bit").  If new tasks are added we
should try again.  If any remote run-queues downgrade their priority in the
meantime, they will try to pull from us (as they always do).

This attempts to address a regression reported by Suresh Siddha, et. al. in
the 2.6.25 series.  It applies to 2.6.25.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
CC: suresh.b.siddha@intel.com
CC: mingo@elte.hu
CC: rostedt@goodmis.org
CC: chinang.ma@intel.com
CC: arjan@linux.intel.com
CC: willy@linux.intel.com
---

 kernel/sched.c    |    2 ++
 kernel/sched_rt.c |    6 +++++-
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 8dcdec6..806881b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -331,6 +331,7 @@ struct rt_rq {
 #ifdef CONFIG_SMP
 	unsigned long rt_nr_migratory;
 	int overloaded;
+	int pushed;
 #endif
 	int rt_throttled;
 	u64 rt_time;
@@ -7142,6 +7143,7 @@ static void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq)
 #ifdef CONFIG_SMP
 	rt_rq->rt_nr_migratory = 0;
 	rt_rq->overloaded = 0;
+	rt_rq->pushed = 0;
 #endif
 
 	rt_rq->rt_time = 0;
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 0a6d2e5..3828aa7 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -393,6 +393,8 @@ static void enqueue_task_rt(struct rq *rq, struct task_struct *p, int wakeup)
 	 */
 	for_each_sched_rt_entity(rt_se)
 		enqueue_rt_entity(rt_se);
+
+	rq->rt.pushed = 0;
 }
 
 static void dequeue_task_rt(struct rq *rq, struct task_struct *p, int sleep)
@@ -789,7 +791,7 @@ static int push_rt_task(struct rq *rq)
 	int ret = 0;
 	int paranoid = RT_MAX_TRIES;
 
-	if (!rq->rt.overloaded)
+	if (!rq->rt.overloaded || rq->rt.pushed)
 		return 0;
 
 	next_task = pick_next_highest_task_rt(rq, -1);
@@ -863,6 +865,8 @@ static void push_rt_tasks(struct rq *rq)
 	/* push_rt_task will return true if it moved an RT */
 	while (push_rt_task(rq))
 		;
+
+	rq->rt.pushed = 1;
 }
 
 static int pull_rt_task(struct rq *this_rq)

