Return-Path: <linux-kernel-owner+w=401wt.eu-S1759520AbXKQGYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759520AbXKQGYp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 01:24:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752689AbXKQGYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 01:24:25 -0500
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:63516 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552AbXKQGYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 01:24:24 -0500
Message-Id: <20071117062405.792778237@goodmis.org>
References: <20071117062104.177779113@goodmis.org>
User-Agent: quilt/0.46-1
Date: Sat, 17 Nov 2007 01:21:21 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Gregory Haskins <ghaskins@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@sgi.com>
Subject: [PATCH v3 17/17] --- kernel/sched_rt.c | 20 ++++++++++++++++---- 1 file changed, 16 insertions(+), 4 deletions(-)
Content-Disposition: inline; filename=rt-balance-avoid-overloading.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Index: linux-compile.git/kernel/sched_rt.c
===================================================================
--- linux-compile.git.orig/kernel/sched_rt.c	2007-11-17 00:18:27.000000000 -0500
+++ linux-compile.git/kernel/sched_rt.c	2007-11-17 00:20:31.000000000 -0500
@@ -52,11 +52,23 @@ static int select_task_rq_rt(struct task
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
