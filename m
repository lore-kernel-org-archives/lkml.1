Return-Path: <linux-kernel-owner+w=401wt.eu-S1757946AbYIDM7I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757946AbYIDM7I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 08:59:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756663AbYIDM5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 08:57:46 -0400
Received: from 75-130-108-43.dhcp.oxfr.ma.charter.com ([75.130.108.43]:33369
	"EHLO dev.haskins.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756459AbYIDM5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 08:57:45 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [TIP/SCHED/DEVEL PATCH v3 4/6] sched: add
	sched_class->needs_post_schedule() member
To: mingo@elte.hu
Cc: rostedt@goodmis.org, peterz@infradead.org, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, npiggin@suse.de,
       gregory.haskins@gmail.com
Date: Thu, 04 Sep 2008 08:55:20 -0400
Message-ID: <20080904125520.23633.64862.stgit@dev.haskins.net>
In-Reply-To: <20080904125029.23633.88210.stgit@dev.haskins.net>
References: <20080904125029.23633.88210.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We currently run class->post_schedule() outside of the rq->lock, which
means that we need to test for the need to post_schedule outside of
the lock to avoid a forced reacquistion.  This is currently not a problem
as we only look at rq->rt.overloaded.  However, we want to enhance this
going forward to look at more state to reduce the need to post_schedule to
a bare minimum set.  Therefore, we introduce a new member-func called
needs_post_schedule() which tests for the post_schedule condtion without
actually performing the work.  Therefore it is safe to call this
function before the rq->lock is released, because we are guaranteed not
to drop the lock at an intermediate point (such as what post_schedule()
may do).

We will use this later in the series

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 include/linux/sched.h |    1 +
 kernel/sched.c        |   10 +++++++++-
 kernel/sched_rt.c     |   24 ++++++++++++++----------
 3 files changed, 24 insertions(+), 11 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 08a87b5..cf8cd8c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -912,6 +912,7 @@ struct sched_class {
 			      struct rq *busiest, struct sched_domain *sd,
 			      enum cpu_idle_type idle);
 	void (*pre_schedule) (struct rq *this_rq, struct task_struct *task);
+	int (*needs_post_schedule) (struct rq *this_rq);
 	void (*post_schedule) (struct rq *this_rq);
 	void (*task_wake_up) (struct rq *this_rq, struct task_struct *task);
 #endif
diff --git a/kernel/sched.c b/kernel/sched.c
index af4c6fa..ddc3877 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2525,6 +2525,14 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 {
 	struct mm_struct *mm = rq->prev_mm;
 	long prev_state;
+#ifdef CONFIG_SMP
+	int post_schedule = 0;
+
+	if (current->sched_class->needs_post_schedule) {
+		BUG_ON(!current->sched_class->post_schedule);
+		post_schedule = current->sched_class->needs_post_schedule(rq);
+	}
+#endif
 
 	rq->prev_mm = NULL;
 
@@ -2543,7 +2551,7 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	finish_arch_switch(prev);
 	finish_lock_switch(rq, prev);
 #ifdef CONFIG_SMP
-	if (current->sched_class->post_schedule)
+	if (post_schedule)
 		current->sched_class->post_schedule(rq);
 #endif
 
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 768be35..277ccd2 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1212,20 +1212,23 @@ static void pre_schedule_rt(struct rq *rq, struct task_struct *prev)
 		pull_rt_task(rq);
 }
 
+/*
+ * assumes rq->lock is held
+ */
+static int needs_post_schedule_rt(struct rq *rq)
+{
+	return rq->rt.overloaded ? 1 : 0;
+}
+
 static void post_schedule_rt(struct rq *rq)
 {
 	/*
-	 * If we have more than one rt_task queued, then
-	 * see if we can push the other rt_tasks off to other CPUS.
-	 * Note we may release the rq lock, and since
-	 * the lock was owned by prev, we need to release it
-	 * first via finish_lock_switch and then reaquire it here.
+	 * This is only called if needs_post_schedule_rt() indicates that
+	 * we need to push tasks away
 	 */
-	if (unlikely(rq->rt.overloaded)) {
-		spin_lock_irq(&rq->lock);
-		push_rt_tasks(rq);
-		spin_unlock_irq(&rq->lock);
-	}
+	spin_lock_irq(&rq->lock);
+	push_rt_tasks(rq);
+	spin_unlock_irq(&rq->lock);
 }
 
 /*
@@ -1473,6 +1476,7 @@ static const struct sched_class rt_sched_class = {
 	.rq_online              = rq_online_rt,
 	.rq_offline             = rq_offline_rt,
 	.pre_schedule		= pre_schedule_rt,
+	.needs_post_schedule	= needs_post_schedule_rt,
 	.post_schedule		= post_schedule_rt,
 	.task_wake_up		= task_wake_up_rt,
 	.switched_from		= switched_from_rt,

