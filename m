Return-Path: <linux-kernel-owner+w=401wt.eu-S1758672AbZJPLHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758672AbZJPLHY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 07:07:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755256AbZJPLHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 07:07:23 -0400
Received: from mail.gmx.net ([213.165.64.20]:55134 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753425AbZJPLHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 07:07:22 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19FoaI3YfJFUfSt+VvK0nW3Hvet7grwAQMKKEvoua
	KsuP3K6o4q30sj
Subject: Re: hackbench regression with kernel 2.6.32-rc1
From: Mike Galbraith <efault@gmx.de>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1255403522.3684.57.camel@ymzhang>
References: <1255079943.25078.23.camel@ymzhang>
	 <1255084986.8802.46.camel@laptop>  <1255331120.3684.43.camel@ymzhang>
	 <1255357264.10420.15.camel@twins>  <1255403522.3684.57.camel@ymzhang>
Content-Type: text/plain
Date: Fri, 16 Oct 2009 13:06:32 +0200
Message-Id: <1255691192.7029.13.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-13 at 11:12 +0800, Zhang, Yanmin wrote:

> NEXT_BUDDY has no help on volanoMark and tbench.

Can you try the patch below please?  It does tries to preserve buddy
affinity where possible, and mitigates over-preemption by strengthening
buddies a bit.  It improves vmark here by ~7%.

diff --git a/kernel/sched.c b/kernel/sched.c
index 00f9e71..fb025d4 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2007,8 +2007,12 @@ task_hot(struct task_struct *p, u64 now, struct sched_domain *sd)
 
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
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index c32c3e6..428bf55 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -863,18 +863,20 @@ static struct sched_entity *pick_next_entity(struct cfs_rq *cfs_rq)
 	struct sched_entity *se = __pick_next_entity(cfs_rq);
 	struct sched_entity *buddy;
 
-	if (cfs_rq->next) {
+	if (cfs_rq->next && sched_feat(NEXT_BUDDY)) {
 		buddy = cfs_rq->next;
-		cfs_rq->next = NULL;
-		if (wakeup_preempt_entity(buddy, se) < 1)
+		if (wakeup_preempt_entity(buddy, se) < 1) {
+			cfs_rq->next = NULL;
 			return buddy;
+		}
 	}
 
-	if (cfs_rq->last) {
+	if (cfs_rq->last && sched_feat(LAST_BUDDY)) {
 		buddy = cfs_rq->last;
-		cfs_rq->last = NULL;
-		if (wakeup_preempt_entity(buddy, se) < 1)
+		if (wakeup_preempt_entity(buddy, se) < 1) {
+			cfs_rq->last = NULL;
 			return buddy;
+		}
 	}
 
 	return se;
@@ -1600,9 +1602,9 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
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


