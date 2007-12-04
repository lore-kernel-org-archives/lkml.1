Return-Path: <linux-kernel-owner+w=401wt.eu-S1755610AbXLDVJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610AbXLDVJg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 16:09:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755102AbXLDVG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 16:06:57 -0500
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:53437
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755057AbXLDVGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 16:06:55 -0500
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 06/23] Subject: SCHED - wake up balance RT
To: mingo@elte.hu
Cc: rostedt@goodmis.org, ghaskins@novell.com, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Tue, 04 Dec 2007 15:44:56 -0500
Message-ID: <20071204204456.3567.63926.stgit@novell1.haskins.net>
In-Reply-To: <20071204204236.3567.65491.stgit@novell1.haskins.net>
References: <20071204204236.3567.65491.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

This patch adds pushing of overloaded RT tasks from a runqueue that is
having tasks (most likely RT tasks) added to the run queue.

TODO: We don't cover the case of waking of new RT tasks (yet).

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/sched.c    |    3 +++
 kernel/sched_rt.c |   10 ++++++++++
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index a30147e..ebd114b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -22,6 +22,8 @@
  *              by Peter Williams
  *  2007-05-06  Interactivity improvements to CFS by Mike Galbraith
  *  2007-07-01  Group scheduling enhancements by Srivatsa Vaddagiri
+ *  2007-10-22  RT overload balancing by Steven Rostedt
+ *                 (with thanks to Gregory Haskins)
  */
 
 #include <linux/mm.h>
@@ -1641,6 +1643,7 @@ out_activate:
 
 out_running:
 	p->state = TASK_RUNNING;
+	wakeup_balance_rt(rq, p);
 out:
 	task_rq_unlock(rq, &flags);
 
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index a2f1057..a0b05ff 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -556,6 +556,15 @@ static void schedule_tail_balance_rt(struct rq *rq)
 	}
 }
 
+
+static void wakeup_balance_rt(struct rq *rq, struct task_struct *p)
+{
+	if (unlikely(rt_task(p)) &&
+	    !task_running(rq, p) &&
+	    (p->prio >= rq->curr->prio))
+		push_rt_tasks(rq);
+}
+
 /*
  * Load-balancing iterator. Note: while the runqueue stays locked
  * during the whole iteration, the current task might be
@@ -663,6 +672,7 @@ move_one_task_rt(struct rq *this_rq, int this_cpu, struct rq *busiest,
 #else /* CONFIG_SMP */
 # define schedule_tail_balance_rt(rq)	do { } while (0)
 # define schedule_balance_rt(rq, prev)	do { } while (0)
+# define wakeup_balance_rt(rq, p)	do { } while (0)
 #endif /* CONFIG_SMP */
 
 static void task_tick_rt(struct rq *rq, struct task_struct *p)

