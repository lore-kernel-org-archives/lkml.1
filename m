Return-Path: <linux-kernel-owner+w=401wt.eu-S1753660AbXLDVMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660AbXLDVMN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 16:12:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755278AbXLDVHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 16:07:33 -0500
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:53471
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755268AbXLDVHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 16:07:31 -0500
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 13/23] Subject: SCHED - Pre-route RT tasks on wakeup
To: mingo@elte.hu
Cc: rostedt@goodmis.org, ghaskins@novell.com, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Tue, 04 Dec 2007 15:45:31 -0500
Message-ID: <20071204204531.3567.99493.stgit@novell1.haskins.net>
In-Reply-To: <20071204204236.3567.65491.stgit@novell1.haskins.net>
References: <20071204204236.3567.65491.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
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
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---

 kernel/sched_rt.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 7e444f4..ea40851 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -149,8 +149,27 @@ yield_task_rt(struct rq *rq)
 }
 
 #ifdef CONFIG_SMP
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

