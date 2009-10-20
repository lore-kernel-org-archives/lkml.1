Return-Path: <linux-kernel-owner+w=401wt.eu-S1752439AbZJTO2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439AbZJTO2t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 10:28:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752148AbZJTO2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 10:28:48 -0400
Received: from mail.gmx.net ([213.165.64.20]:48396 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752058AbZJTO2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 10:28:48 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18iWz1g6VQiq+jl6zoDf7Q4Dx4wvtXGB/5F2KipSK
	VgStGitORrEqJX
Subject: Re: RFC [patch] sched: strengthen LAST_BUDDY and minimize buddy
 induced latencies V3
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@linux.intel.com>
In-Reply-To: <1256012656.17774.14.camel@laptop>
References: <1255775063.32691.5.camel@marge.simson.net>
	 <1256012656.17774.14.camel@laptop>
Content-Type: text/plain
Date: Tue, 20 Oct 2009 16:28:48 +0200
Message-Id: <1256048928.8699.34.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-20 at 06:24 +0200, Peter Zijlstra wrote:
> On Sat, 2009-10-17 at 12:24 +0200, Mike Galbraith wrote:
> > sched: strengthen LAST_BUDDY and minimize buddy induced latencies.
> > 
> > This patch restores the effectiveness of LAST_BUDDY in preventing pgsql+oltp
> > from collapsing due to wakeup preemption.  It also minimizes buddy induced
> > latencies.  x264 testcase spawns new worker threads at a high rate, and was
> > being affected badly by NEXT_BUDDY.  It turned out that CACHE_HOT_BUDDY was
> > thwarting idle balancing.  This patch ensures that the load can disperse,
> > and that buddies can't make any task excessively late.
> 
> > Index: linux-2.6/kernel/sched.c
> > ===================================================================
> > --- linux-2.6.orig/kernel/sched.c
> > +++ linux-2.6/kernel/sched.c
> > @@ -2007,8 +2007,12 @@ task_hot(struct task_struct *p, u64 now,
> >  
> >  	/*
> >  	 * Buddy candidates are cache hot:
> > +	 *
> > +	 * Do not honor buddies if there may be nothing else to
> > +	 * prevent us from becoming idle.
> >  	 */
> >  	if (sched_feat(CACHE_HOT_BUDDY) &&
> > +			task_rq(p)->nr_running >= sched_nr_latency &&
> >  			(&p->se == cfs_rq_of(&p->se)->next ||
> >  			 &p->se == cfs_rq_of(&p->se)->last))
> >  		return 1;
> 
> I'm not sure about this. The sched_nr_latency seems arbitrary, 1 seems
> like a more natural boundary.

How about the below?  I started thinking about a vmark et al, and
figured I'd try taking LAST_BUDDY a bit further, ie try even harder to
give the CPU back to a preempted task so it can go on it's merry way
rightward.  Vmark likes the idea, as does mysql+oltp and of course pgsql
+oltp is happier (preempt userland spinlock holder -> welcome to pain)

That weird little dip right after mysql+oltp peak is still present, and
I don't understand why.  I've squabbled with that bugger before.

Full retest (pulled tip v2.6.32-rc5-1497-ga525b32)

vmark
tip           108466 messages per second 
tip++         121151 messages per second
               1.116
              
mysql+oltp
clients             1          2          4          8         16         32         64        128        256
tip           9821.62   18573.65   34757.38   34313.31   32144.12   30654.29   28310.89   25027.35   19558.34
              9862.92   18561.28   34822.03   34576.43   32971.17   30845.74   28290.78   25051.09   19473.82
             10165.14   18935.68   34824.31   34490.38   32933.35   30797.89   28314.15   25100.49   19612.10
tip avg       9949.89   18690.20   34801.24   34460.04   32682.88   30765.97   28305.27   25059.64   19548.08
             
tip+         10206.95   18661.99   34808.03   33735.84   32939.46   31613.18   29994.18   27293.44   22846.26
              9884.26   18652.53   35136.57   34090.69   32953.83   31699.69   30073.19   27242.16   22772.26
              9885.20   18774.23   35166.59   34034.52   33015.85   31726.04   30144.69   27239.97   22750.68
tip+ avg      9992.13   18696.25   35037.06   33953.68   32969.71   31679.63   30070.68   27258.52   22789.73
                1.004      1.000      1.006       .985      1.008      1.029      1.062      1.087      1.165

pgsql+oltp
clients             1          2          4          8         16         32         64        128        256
tip          13686.37   26609.25   51934.28   51347.81   49479.51   45312.65   36691.91   26851.57   24145.35
tip++        13675.11   26591.73   51882.93   51618.99   50681.77   49592.17   48893.15   47374.94   45417.42
                 .999       .999       .999      1.005      1.024      1.094      1.332      1.764      1.881

sched: strengthen LAST_BUDDY and minimize buddy induced latencies.

This patch restores the effectiveness of LAST_BUDDY in preventing pgsql+oltp
from collapsing due to wakeup preemption.  It also switches LAST_BUDDY to
do what it does best, namely mitigate the effects of aggressive preemption,
which improves vmark throughput markedly.

Last hunk is to prevent buddies from stymieing BALANCE_NEWIDLE.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>

---
 kernel/sched.c      |    2 +-
 kernel/sched_fair.c |   49 ++++++++++++++++++++++++-------------------------
 2 files changed, 25 insertions(+), 26 deletions(-)

Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -861,21 +861,17 @@ wakeup_preempt_entity(struct sched_entit
 static struct sched_entity *pick_next_entity(struct cfs_rq *cfs_rq)
 {
 	struct sched_entity *se = __pick_next_entity(cfs_rq);
-	struct sched_entity *buddy;
 
-	if (cfs_rq->next) {
-		buddy = cfs_rq->next;
-		cfs_rq->next = NULL;
-		if (wakeup_preempt_entity(buddy, se) < 1)
-			return buddy;
-	}
+	if (cfs_rq->next && wakeup_preempt_entity(cfs_rq->next, se) < 1)
+		se = cfs_rq->next;
 
-	if (cfs_rq->last) {
-		buddy = cfs_rq->last;
-		cfs_rq->last = NULL;
-		if (wakeup_preempt_entity(buddy, se) < 1)
-			return buddy;
-	}
+	/*
+	 * Prefer last buddy, try to return the CPU to a preempted task.
+	 */
+	if (cfs_rq->last && wakeup_preempt_entity(cfs_rq->last, se) < 1)
+		se = cfs_rq->last;
+
+	clear_buddies(cfs_rq, se);
 
 	return se;
 }
@@ -1591,17 +1587,6 @@ static void check_preempt_wakeup(struct
 	if (unlikely(se == pse))
 		return;
 
-	/*
-	 * Only set the backward buddy when the current task is still on the
-	 * rq. This can happen when a wakeup gets interleaved with schedule on
-	 * the ->pre_schedule() or idle_balance() point, either of which can
-	 * drop the rq lock.
-	 *
-	 * Also, during early boot the idle thread is in the fair class, for
-	 * obvious reasons its a bad idea to schedule back to the idle thread.
-	 */
-	if (sched_feat(LAST_BUDDY) && likely(se->on_rq && curr != rq->idle))
-		set_last_buddy(se);
 	if (sched_feat(NEXT_BUDDY) && !(wake_flags & WF_FORK))
 		set_next_buddy(pse);
 
@@ -1648,8 +1633,22 @@ static void check_preempt_wakeup(struct
 
 	BUG_ON(!pse);
 
-	if (wakeup_preempt_entity(se, pse) == 1)
+	if (wakeup_preempt_entity(se, pse) == 1) {
 		resched_task(curr);
+		/*
+		 * Only set the backward buddy when the current task is still
+		 * on the rq. This can happen when a wakeup gets interleaved
+		 * with schedule on the ->pre_schedule() or idle_balance()
+		 * point, either of which can * drop the rq lock.
+		 *
+		 * Also, during early boot the idle thread is in the fair class,
+		 * for obvious reasons its a bad idea to schedule back to it.
+		 */
+		if (unlikely(!se->on_rq || curr == rq->idle))
+			return;
+		if (sched_feat(LAST_BUDDY))
+			set_last_buddy(se);
+	}
 }
 
 static struct task_struct *pick_next_task_fair(struct rq *rq)
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -2008,7 +2008,7 @@ task_hot(struct task_struct *p, u64 now,
 	/*
 	 * Buddy candidates are cache hot:
 	 */
-	if (sched_feat(CACHE_HOT_BUDDY) &&
+	if (sched_feat(CACHE_HOT_BUDDY) && this_rq()->nr_running &&
 			(&p->se == cfs_rq_of(&p->se)->next ||
 			 &p->se == cfs_rq_of(&p->se)->last))
 		return 1;


