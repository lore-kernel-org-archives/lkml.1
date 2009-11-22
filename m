Return-Path: <linux-kernel-owner+w=401wt.eu-S1755412AbZKVQuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412AbZKVQuj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 11:50:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755274AbZKVQui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 11:50:38 -0500
Received: from mail.gmx.net ([213.165.64.20]:45905 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755025AbZKVQui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 11:50:38 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/DAHAu9KnDzHr9Q8eVf0spsj8Af8IIp2XboWdS/q
	vai0nllUCYCDJD
Subject: Re: [patch] sched: improve tick time missed wakeup preempt
 protection
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1258895767.28730.527.camel@laptop>
References: <1258891682.14325.31.camel@marge.simson.net>
	 <1258895767.28730.527.camel@laptop>
Content-Type: text/plain
Date: Sun, 22 Nov 2009 17:50:40 +0100
Message-Id: <1258908640.6043.11.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.47
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-11-22 at 14:16 +0100, Peter Zijlstra wrote:

> You can loose the else, the if branch does an unconditional return,
> there's no other way to get below there than 'else' ;-)

Ok.  Can't plug tail into a function, doesn't fit on a line, so..

sched: improve tick time missed wakeup preempt protection

f685ceac provides protection from tasks just missing wakeup preemption, and then
having to wait a full slice.  However, it offers this protection to tasks which
have no business receiving the benefit, namely SCHED_BATCH and SCHED_IDLE.  It
also treats all tasks equally, which obviously isn't true.  Exclude tasks of
other than SCHED_NORMAL class, and scale minimum runtime before a tick time
preemption by the difference in task weights, after which, we can just use the
standard wakeup preempt vruntime delta test, sysctl_sched_wakeup_granularity.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>

---
 kernel/sched_fair.c |   27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -811,7 +811,10 @@ dequeue_entity(struct cfs_rq *cfs_rq, st
 static void
 check_preempt_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
 {
+	struct sched_entity *next;
 	unsigned long ideal_runtime, delta_exec;
+	unsigned long min = sysctl_sched_min_granularity;
+	s64 delta;
 
 	ideal_runtime = sched_slice(cfs_rq, curr);
 	delta_exec = curr->sum_exec_runtime - curr->prev_sum_exec_runtime;
@@ -825,24 +828,28 @@ check_preempt_tick(struct cfs_rq *cfs_rq
 		return;
 	}
 
+	if (!sched_feat(WAKEUP_PREEMPT) || cfs_rq->nr_running < 2)
+		return;
+
 	/*
 	 * Ensure that a task that missed wakeup preemption by a
 	 * narrow margin doesn't have to wait for a full slice.
 	 * This also mitigates buddy induced latencies under load.
 	 */
-	if (!sched_feat(WAKEUP_PREEMPT))
-		return;
+	next = __pick_next_entity(cfs_rq);
+	delta = curr->vruntime - next->vruntime;
 
-	if (delta_exec < sysctl_sched_min_granularity)
+	if (task_of(next)->policy != SCHED_NORMAL)
+		return;
+	if (delta < 0)
+		return;
+	if (curr->load.weight != next->load.weight)
+		min = calc_delta_mine(min, curr->load.weight, &next->load);
+	if (delta_exec < min)
 		return;
 
-	if (cfs_rq->nr_running > 1) {
-		struct sched_entity *se = __pick_next_entity(cfs_rq);
-		s64 delta = curr->vruntime - se->vruntime;
-
-		if (delta > ideal_runtime)
-			resched_task(rq_of(cfs_rq)->curr);
-	}
+	if (delta > sysctl_sched_wakeup_granularity)
+		resched_task(rq_of(cfs_rq)->curr);
 }
 
 static void


