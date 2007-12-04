Return-Path: <linux-kernel-owner+w=401wt.eu-S1755009AbXLDVID@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009AbXLDVID (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 16:08:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752839AbXLDVGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 16:06:36 -0500
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:53417
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751081AbXLDVGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 16:06:35 -0500
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 02/23] Subject: SCHED - track highest prio queued on runqueue
To: mingo@elte.hu
Cc: rostedt@goodmis.org, ghaskins@novell.com, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Tue, 04 Dec 2007 15:44:36 -0500
Message-ID: <20071204204436.3567.59146.stgit@novell1.haskins.net>
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

This patch adds accounting to each runqueue to keep track of the
highest prio task queued on the run queue. We only care about
RT tasks, so if the run queue does not contain any active RT tasks
its priority will be considered MAX_RT_PRIO.

This information will be used for later patches.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/sched.c    |    3 +++
 kernel/sched_rt.c |   18 ++++++++++++++++++
 2 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 4751c2f..90c04fd 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -267,6 +267,8 @@ struct rt_rq {
 	int rt_load_balance_idx;
 	struct list_head *rt_load_balance_head, *rt_load_balance_curr;
 	unsigned long rt_nr_running;
+	/* highest queued rt task prio */
+	int highest_prio;
 };
 
 /*
@@ -6783,6 +6785,7 @@ void __init sched_init(void)
 		rq->cpu = i;
 		rq->migration_thread = NULL;
 		INIT_LIST_HEAD(&rq->migration_queue);
+		rq->rt.highest_prio = MAX_RT_PRIO;
 #endif
 		atomic_set(&rq->nr_iowait, 0);
 
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index a6271f4..4d5b9b2 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -30,6 +30,10 @@ static inline void inc_rt_tasks(struct task_struct *p, struct rq *rq)
 {
 	WARN_ON(!rt_task(p));
 	rq->rt.rt_nr_running++;
+#ifdef CONFIG_SMP
+	if (p->prio < rq->rt.highest_prio)
+		rq->rt.highest_prio = p->prio;
+#endif /* CONFIG_SMP */
 }
 
 static inline void dec_rt_tasks(struct task_struct *p, struct rq *rq)
@@ -37,6 +41,20 @@ static inline void dec_rt_tasks(struct task_struct *p, struct rq *rq)
 	WARN_ON(!rt_task(p));
 	WARN_ON(!rq->rt.rt_nr_running);
 	rq->rt.rt_nr_running--;
+#ifdef CONFIG_SMP
+	if (rq->rt.rt_nr_running) {
+		struct rt_prio_array *array;
+
+		WARN_ON(p->prio < rq->rt.highest_prio);
+		if (p->prio == rq->rt.highest_prio) {
+			/* recalculate */
+			array = &rq->rt.active;
+			rq->rt.highest_prio =
+				sched_find_first_bit(array->bitmap);
+		} /* otherwise leave rq->highest prio alone */
+	} else
+		rq->rt.highest_prio = MAX_RT_PRIO;
+#endif /* CONFIG_SMP */
 }
 
 static void enqueue_task_rt(struct rq *rq, struct task_struct *p, int wakeup)

