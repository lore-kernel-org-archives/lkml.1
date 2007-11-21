Return-Path: <linux-kernel-owner+w=401wt.eu-S1763076AbXKUBO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763076AbXKUBO4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 20:14:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765424AbXKUBNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 20:13:50 -0500
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:45696 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763329AbXKUBNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 20:13:46 -0500
Message-Id: <20071121011251.425055221@goodmis.org>
References: <20071121010054.663842380@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 20 Nov 2007 20:01:10 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Gregory Haskins <ghaskins@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@sgi.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH v4 16/20] Avoid overload
Content-Disposition: inline; filename=rt-balance-avoid-overloading.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the searching for a run queue by a waking RT task
to try to pick another runqueue if the currently running task
is an RT task.

The reason is that RT tasks behave different than normal
tasks. Preempting a normal task to run a RT task to keep
its cache hot is fine, because the preempted non-RT task
may wait on that same runqueue to run again unless the
migration thread comes along and pulls it off.

RT tasks behave differently. If one is preempted, it makes
an active effort to continue to run. So by having a high
priority task preempt a lower priority RT task, that lower
RT task will then quickly try to run on another runqueue.
This will cause that lower RT task to replace its nice
hot cache (and TLB) with a completely cold one. This is
for the hope that the new high priority RT task will keep
 its cache hot.

Remeber that this high priority RT task was just woken up.
So it may likely have been sleeping for several milliseconds,
and will end up with a cold cache anyway. RT tasks run till
they voluntarily stop, or are preempted by a higher priority
task. This means that it is unlikely that the woken RT task
will have a hot cache to wake up to. So pushing off a lower
RT task is just killing its cache for no good reason.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---

 kernel/sched_rt.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

Index: linux-compile.git/kernel/sched_rt.c
===================================================================
--- linux-compile.git.orig/kernel/sched_rt.c	2007-11-20 19:53:10.000000000 -0500
+++ linux-compile.git/kernel/sched_rt.c	2007-11-20 19:53:11.000000000 -0500
@@ -157,11 +157,23 @@ static int select_task_rq_rt(struct task
 	struct rq *rq = task_rq(p);
 
 	/*
-	 * If the task will not preempt the RQ, try to find a better RQ
-	 * before we even activate the task
+	 * If the current task is an RT task, then
+	 * try to see if we can wake this RT task up on another
+	 * runqueue. Otherwise simply start this RT task
+	 * on its current runqueue.
+	 *
+	 * We want to avoid overloading runqueues. Even if
+	 * the RT task is of higher priority than the current RT task.
+	 * RT tasks behave differently than other tasks. If
+	 * one gets preempted, we try to push it off to another queue.
+	 * So trying to keep a preempting RT task on the same
+	 * cache hot CPU will force the running RT task to
+	 * a cold CPU. So we waste all the cache for the lower
+	 * RT task in hopes of saving some of a RT task
+	 * that is just being woken and probably will have
+	 * cold cache anyway.
 	 */
-	if ((p->prio >= rq->rt.highest_prio)
-	    && (p->nr_cpus_allowed > 1)) {
+	if (unlikely(rt_task(rq->curr))) {
 		int cpu = find_lowest_rq(p);
 
 		return (cpu == -1) ? task_cpu(p) : cpu;

-- 
