Return-Path: <linux-kernel-owner+w=401wt.eu-S1754364AbZLIJzN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364AbZLIJzN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 04:55:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754200AbZLIJzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 04:55:11 -0500
Received: from hera.kernel.org ([140.211.167.34]:45161 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754311AbZLIJzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 04:55:05 -0500
Date: Wed, 9 Dec 2009 09:54:36 GMT
From: tip-bot for Jupyung Lee <jupyung@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jupyung@gmail.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jupyung@gmail.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1258451500-6714-1-git-send-email-jupyung@gmail.com>
References: <1258451500-6714-1-git-send-email-jupyung@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Move update_curr() in check_preempt_wakeup() to avoid redundant call
Message-ID: <tip-a65ac745e47e91f9d98dbf07f22ed0492e34d998@git.kernel.org>
Git-Commit-ID: a65ac745e47e91f9d98dbf07f22ed0492e34d998
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a65ac745e47e91f9d98dbf07f22ed0492e34d998
Gitweb:     http://git.kernel.org/tip/a65ac745e47e91f9d98dbf07f22ed0492e34d998
Author:     Jupyung Lee <jupyung@gmail.com>
AuthorDate: Tue, 17 Nov 2009 18:51:40 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 9 Dec 2009 10:03:06 +0100

sched: Move update_curr() in check_preempt_wakeup() to avoid redundant call

If a RT task is woken up while a non-RT task is running,
check_preempt_wakeup() is called to check whether the new task can
preempt the old task. The function returns quickly without going deeper
because it is apparent that a RT task can always preempt a non-RT task.

In this situation, check_preempt_wakeup() always calls update_curr() to
update vruntime value of the currently running task. However, the
function call is unnecessary and redundant at that moment because (1) a
non-RT task can always be preempted by a RT task regardless of its
vruntime value, and (2) update_curr() will be called shortly when the
context switch between two occurs.

By moving update_curr() in check_preempt_wakeup(), we can avoid
redundant call to update_curr(), slightly reducing the time taken to
wake up RT tasks.

Signed-off-by: Jupyung Lee <jupyung@gmail.com>
[ Place update_curr() right before the wake_preempt_entity() call, which
  is the only thing that relies on the updated vruntime ]
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1258451500-6714-1-git-send-email-jupyung@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 44ec80c..4dec185 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1651,8 +1651,6 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
 	int sync = wake_flags & WF_SYNC;
 	int scale = cfs_rq->nr_running >= sched_nr_latency;
 
-	update_curr(cfs_rq);
-
 	if (unlikely(rt_prio(p->prio))) {
 		resched_task(curr);
 		return;
@@ -1710,6 +1708,8 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
 
 	BUG_ON(!pse);
 
+	update_curr(cfs_rq);
+
 	if (wakeup_preempt_entity(se, pse) == 1) {
 		resched_task(curr);
 		/*
