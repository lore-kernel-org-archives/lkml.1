Return-Path: <linux-kernel-owner+w=401wt.eu-S1756305AbZALUrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305AbZALUrS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 15:47:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752247AbZALUq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 15:46:59 -0500
Received: from mail.gmx.net ([213.165.64.20]:45177 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752783AbZALUq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 15:46:58 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19mBdIQajRmPXJsNn1dz34b6Rrpm3JUUIjaoOc2Yr
	ZD3NGaUwtq4lMg
Subject: [patch take 2] Re: [BUG] How to get real-time priority using idle
	priority
From: Mike Galbraith <efault@gmx.de>
To: Brian Rogers <brian@xyzw.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1231765433.5789.35.camel@marge.simson.net>
References: <4969D0D7.2060401@xyzw.org>
	 <1231736941.6003.7.camel@marge.simson.net>
	 <1231765433.5789.35.camel@marge.simson.net>
Content-Type: text/plain
Date: Mon, 12 Jan 2009 21:46:52 +0100
Message-Id: <1231793212.5940.2.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-12 at 14:03 +0100, Mike Galbraith wrote:

> Would you mind trying the below?

Or better, this more complete version.

Impact: fix latency issues when SCHED_IDLE tasks are queued.

Exclude SCHED_IDLE tasks from wakeup preemption, ensure that same will
always be wakeup preempted, and exclude them from being buddies so they
will only be selected via their vruntime.  Per a tip from Peter Zijlstra,
also scale migration vruntime adjustment to compensate for differences
in min_vruntime advance rates.

Reported-by: Brian Rogers <brian@xyzw.org>
Signed-off-by: Mike Galbraith <efault@gmx.de>

 kernel/sched.c      |   19 +++++++++++++++++--
 kernel/sched_fair.c |   22 ++++++++++++++++------
 2 files changed, 33 insertions(+), 8 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index deb5ac8..bdc0b38 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1888,8 +1888,23 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 			schedstat_inc(p, se.nr_forced2_migrations);
 	}
 #endif
-	p->se.vruntime -= old_cfsrq->min_vruntime -
-					 new_cfsrq->min_vruntime;
+	if (old_cpu != new_cpu) {
+		s64 delta = p->se.vruntime - old_cfsrq->min_vruntime;
+
+		/*
+		 * min_vruntimes may be advancing at wildly different
+		 * rates, so we must scale the delta accordingly.
+		 */
+		if (new_cfsrq->load.weight != old_cfsrq->load.weight) {
+			int negative = delta < 0;
+
+			delta = negative ? -delta : delta;
+			delta = calc_delta_mine(delta,
+				new_cfsrq->load.weight, &old_cfsrq->load);
+			delta = negative ? -delta : delta;
+		}
+		p->se.vruntime = new_cfsrq->min_vruntime + delta;
+	}
 
 	__set_task_cpu(p, new_cpu);
 }
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 8e1352c..500ed14 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1340,14 +1340,18 @@ wakeup_preempt_entity(struct sched_entity *curr, struct sched_entity *se)
 
 static void set_last_buddy(struct sched_entity *se)
 {
-	for_each_sched_entity(se)
-		cfs_rq_of(se)->last = se;
+	for_each_sched_entity(se) {
+		if (likely(task_of(se)->policy != SCHED_IDLE))
+			cfs_rq_of(se)->last = se;
+	}
 }
 
 static void set_next_buddy(struct sched_entity *se)
 {
-	for_each_sched_entity(se)
-		cfs_rq_of(se)->next = se;
+	for_each_sched_entity(se) {
+		if (likely(task_of(se)->policy != SCHED_IDLE))
+			cfs_rq_of(se)->next = se;
+	}
 }
 
 /*
@@ -1393,12 +1397,18 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int sync)
 		return;
 
 	/*
-	 * Batch tasks do not preempt (their preemption is driven by
+	 * Batch and idle tasks do not preempt (their preemption is driven by
 	 * the tick):
 	 */
-	if (unlikely(p->policy == SCHED_BATCH))
+	if (unlikely(p->policy != SCHED_NORMAL))
 		return;
 
+	/* Idle tasks are by definition preempted by everybody. */
+	if (unlikely(curr->policy == SCHED_IDLE)) {
+		resched_task(curr);
+		return;
+	}
+
 	if (!sched_feat(WAKEUP_PREEMPT))
 		return;
 


