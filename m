Return-Path: <linux-kernel-owner+w=401wt.eu-S1757144AbXKFAv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757144AbXKFAv6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 19:51:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755749AbXKFAuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 19:50:37 -0500
Received: from nds154-200.nds.lab.novell.com ([151.155.154.200]:25185 "EHLO
	lsg.lab.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755507AbXKFAud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 19:50:33 -0500
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 5/8] RT: Pre-route RT tasks on wakeup
To: rostedt@goodmis.org
Cc: mingo@elte.hu, dvhltc@us.ibm.com, zijlstra@redhat.com,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       ghaskins@novell.com
Date: Mon, 05 Nov 2007 16:48:58 -0700
Message-ID: <20071105234858.25451.43860.stgit@lsg>
In-Reply-To: <20071105234832.25451.55430.stgit@lsg>
References: <20071105234832.25451.55430.stgit@lsg>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

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
---

 kernel/sched_rt.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 7dd67db..43d4ea6 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -202,9 +202,28 @@ yield_task_rt(struct rq *rq, struct task_struct *p)
 	requeue_task_rt(rq, p);
 }
 
+static int find_lowest_rq(struct task_struct *task);
+
 #ifdef CONFIG_SMP
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

