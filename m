Return-Path: <linux-kernel-owner+w=401wt.eu-S1764560AbXKQG3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764560AbXKQG3g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 01:29:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762006AbXKQGYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 01:24:46 -0500
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:45571 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759126AbXKQGYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 01:24:40 -0500
Message-Id: <20071117062405.149639013@goodmis.org>
References: <20071117062104.177779113@goodmis.org>
User-Agent: quilt/0.46-1
Date: Sat, 17 Nov 2007 01:21:17 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Gregory Haskins <ghaskins@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@sgi.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH v3 13/17] RT: Pre-route RT tasks on wakeup
Content-Disposition: inline; filename=0005-pre-route-rt-tasks-on-wakeup.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gregory Haskins <ghaskins@novell.com>

In the original patch series that Steven Rostedt and I worked on together,
we both took different approaches to low-priority wakeup path.  I utilized
"pre-routing" (push the task away to a less important RQ before activating)
approach, while Steve utilized a "post-routing" approach.  The advantage of
my approach is that you avoid the overhead of a wasted activate/deactivate
cycle and peripherally related burdens.  The advantage of Steve's method is
that it neatly solves an issue preventing a "pull" optimization from being
deployed.

In the end, we ended up deploying Steve's idea.  But it later dawned on me
that we could get the best of both worlds by deploying both ideas together,
albeit slightly modified.

The idea is simple:  Use a "light-weight" lookup for pre-routing, since we
only need to approximate a good home for the task.  And we also retain the
post-routing push logic to clean up any inaccuracies caused by a condition
of "priority mistargeting" caused by the lightweight lookup.  Most of the
time, the pre-routing should work and yield lower overhead.  In the cases
where it doesnt, the post-router will bat cleanup.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---

 kernel/sched_rt.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

Index: linux-compile.git/kernel/sched_rt.c
===================================================================
--- linux-compile.git.orig/kernel/sched_rt.c	2007-11-16 22:23:45.000000000 -0500
+++ linux-compile.git/kernel/sched_rt.c	2007-11-16 22:23:48.000000000 -0500
@@ -42,8 +42,27 @@ static void update_rt_migration(struct r
 		rt_clear_overload(rq);
 }
 
+static int find_lowest_rq(struct task_struct *task);
+
 static int select_task_rq_rt(struct task_struct *p, int sync)
 {
+	struct rq *rq = task_rq(p);
+
+	/*
+	 * If the task will not preempt the RQ, try to find a better RQ
+	 * before we even activate the task
+	 */
+	if ((p->prio >= rq->rt.highest_prio)
+	    && (p->nr_cpus_allowed > 1)) {
+		int cpu = find_lowest_rq(p);
+
+		return (cpu == -1) ? task_cpu(p) : cpu;
+	}
+
+	/*
+	 * Otherwise, just let it ride on the affined RQ and the
+	 * post-schedule router will push the preempted task away
+	 */
 	return task_cpu(p);
 }
 #endif /* CONFIG_SMP */

-- 
