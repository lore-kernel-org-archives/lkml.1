Return-Path: <linux-kernel-owner+w=401wt.eu-S1753178AbZJQKYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178AbZJQKYY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 06:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751613AbZJQKYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 06:24:24 -0400
Received: from mail.gmx.net ([213.165.64.20]:52266 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750859AbZJQKYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 06:24:22 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19piys9zFlpu7VXVTmigmBgj1tNBV0MWJ8Mj+8l/o
	Bfhz2vqXzQWkt1
Subject: RFC [patch] sched: strengthen LAST_BUDDY and minimize buddy
 induced latencies V3
From: Mike Galbraith <efault@gmx.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain
Date: Sat, 17 Oct 2009 12:24:23 +0200
Message-Id: <1255775063.32691.5.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sched: strengthen LAST_BUDDY and minimize buddy induced latencies.

This patch restores the effectiveness of LAST_BUDDY in preventing pgsql+oltp
from collapsing due to wakeup preemption.  It also minimizes buddy induced
latencies.  x264 testcase spawns new worker threads at a high rate, and was
being affected badly by NEXT_BUDDY.  It turned out that CACHE_HOT_BUDDY was
thwarting idle balancing.  This patch ensures that the load can disperse,
and that buddies can't make any task excessively late.

Some numbers for v2.6.32-rc4-1600-g0786aa4:

vmark
tip           108841 messages per second 
tip+          116617 messages per second

tbench 8
tip           938.421 MB/sec 8 procs
tip+          948.408 MB/sec 8 procs

mysql+oltp
clients             1          2          4          8         16         32         64        128        256
tip           9999.36   18493.54   34652.91   34253.13   32057.64   30297.43   28300.96   25450.14   20675.99
tip+         10054.16   18275.67   34799.62   33561.74   32633.54   31584.56   29861.57   26929.84   22450.29

pgsql+oltp
clients             1          2          4          8         16         32         64        128        256
tip          13577.63   26510.67   51871.05   51374.62   50190.69   45494.64   37173.83   27767.09   22795.23
tip+         13671.69   26586.23   51766.85   51464.36   50459.22   49637.46   48678.73   47127.42   44994.69

x264.sh 8
tip          366.80 fps  +NEXT_BUDDY: 274.15  -NEXT_BUDDY -START_DEBIT: 396.77  +NEXT_BUDDY -START_DEBIT: 263.45
tip+         373.23 fps  +NEXT_BUDDY: 369.73  -NEXT_BUDDY -START_DEBIT: 404.57  +NEXT_BUDDY -START_DEBIT: 401.57


Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>

---
 kernel/sched.c      |    4 ++++
 kernel/sched_fair.c |   35 +++++++++++++++++++++--------------
 2 files changed, 25 insertions(+), 14 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -2007,8 +2007,12 @@ task_hot(struct task_struct *p, u64 now,
 
 	/*
 	 * Buddy candidates are cache hot:
+	 *
+	 * Do not honor buddies if there may be nothing else to
+	 * prevent us from becoming idle.
 	 */
 	if (sched_feat(CACHE_HOT_BUDDY) &&
+			task_rq(p)->nr_running >= sched_nr_latency &&
 			(&p->se == cfs_rq_of(&p->se)->next ||
 			 &p->se == cfs_rq_of(&p->se)->last))
 		return 1;
Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -861,21 +861,28 @@ wakeup_preempt_entity(struct sched_entit
 static struct sched_entity *pick_next_entity(struct cfs_rq *cfs_rq)
 {
 	struct sched_entity *se = __pick_next_entity(cfs_rq);
-	struct sched_entity *buddy;
+	u64 vruntime = se->vruntime + (2*sysctl_sched_min_granularity);
 
-	if (cfs_rq->next) {
-		buddy = cfs_rq->next;
-		cfs_rq->next = NULL;
-		if (wakeup_preempt_entity(buddy, se) < 1)
-			return buddy;
+	/*
+	 * Maybe it's a buddy, maybe not.  Who cares, it's late.. go now!
+	 */
+	if (unlikely(min_vruntime(vruntime, cfs_rq->min_vruntime) == vruntime)) {
+		clear_buddies(cfs_rq, se);
+		return se;
 	}
 
-	if (cfs_rq->last) {
-		buddy = cfs_rq->last;
-		cfs_rq->last = NULL;
-		if (wakeup_preempt_entity(buddy, se) < 1)
-			return buddy;
-	}
+	if (cfs_rq->next && se != cfs_rq->next && sched_feat(NEXT_BUDDY) &&
+			wakeup_preempt_entity(cfs_rq->next, se) < 1)
+		se = cfs_rq->next;
+
+	/*
+	 * Prefer last buddy, try to return the CPU to a preempted task.
+	 */
+	if (cfs_rq->last && se != cfs_rq->last && sched_feat(LAST_BUDDY) &&
+			wakeup_preempt_entity(cfs_rq->last, se) < 1)
+		se = cfs_rq->last;
+
+	clear_buddies(cfs_rq, se);
 
 	return se;
 }
@@ -1600,9 +1607,9 @@ static void check_preempt_wakeup(struct
 	 * Also, during early boot the idle thread is in the fair class, for
 	 * obvious reasons its a bad idea to schedule back to the idle thread.
 	 */
-	if (sched_feat(LAST_BUDDY) && likely(se->on_rq && curr != rq->idle))
+	if (!(wake_flags & WF_FORK) && likely(se->on_rq && curr != rq->idle))
 		set_last_buddy(se);
-	if (sched_feat(NEXT_BUDDY) && !(wake_flags & WF_FORK))
+	if (!(wake_flags & WF_FORK))
 		set_next_buddy(pse);
 
 	/*


