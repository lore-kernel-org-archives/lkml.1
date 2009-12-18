Return-Path: <linux-kernel-owner+w=401wt.eu-S1752100AbZLRM5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100AbZLRM5U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 07:57:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751650AbZLRM5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 07:57:13 -0500
Received: from hera.kernel.org ([140.211.167.34]:45180 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751606AbZLRM5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 07:57:09 -0500
From: Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, peterz@infradead.org, johannes@sipsolutions.net,
       andi@firstfloor.org
Cc: Tejun Heo <tj@kernel.org>, Mike Galbraith <efault@gmx.de>
Subject: [PATCH 05/27] sched: add wakeup/sleep sched_notifiers and allow NULL notifier ops
Date: Fri, 18 Dec 2009 21:57:46 +0900
Message-Id: <1261141088-2014-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1261141088-2014-1-git-send-email-tj@kernel.org>
References: <1261141088-2014-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add wakeup and sleep notifiers to sched_notifiers and allow omitting
some of the notifiers in the ops table.  These will be used by
concurrency managed workqueue.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h |    6 ++++++
 kernel/sched.c        |   11 ++++++++---
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index f327ac7..b3c1666 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1215,6 +1215,10 @@ struct sched_notifier;
 
 /**
  * sched_notifier_ops - notifiers called for scheduling events
+ * @wakeup: we're waking up
+ *    notifier: struct sched_notifier for the task being woken up
+ * @sleep: we're going to bed
+ *    notifier: struct sched_notifier for the task sleeping
  * @in: we're about to be rescheduled:
  *    notifier: struct sched_notifier for the task being scheduled
  *    cpu:  cpu we're scheduled on
@@ -1228,6 +1232,8 @@ struct sched_notifier;
  * and depended upon by its users.
  */
 struct sched_notifier_ops {
+	void (*wakeup)(struct sched_notifier *notifier);
+	void (*sleep)(struct sched_notifier *notifier);
 	void (*in)(struct sched_notifier *notifier, int cpu);
 	void (*out)(struct sched_notifier *notifier, struct task_struct *next);
 };
diff --git a/kernel/sched.c b/kernel/sched.c
index f44db0b..35af985 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1439,7 +1439,8 @@ static inline void cpuacct_update_stats(struct task_struct *tsk,
 	struct hlist_node *__pos;					\
 									\
 	hlist_for_each_entry(__sn, __pos, &(p)->sched_notifiers, link)	\
-		__sn->ops->callback(__sn , ##args);			\
+		if (__sn->ops->callback)				\
+			__sn->ops->callback(__sn , ##args);		\
 } while (0)
 
 /**
@@ -2410,6 +2411,8 @@ static inline void ttwu_post_activation(struct task_struct *p, struct rq *rq,
 		rq->idle_stamp = 0;
 	}
 #endif
+	if (success)
+		fire_sched_notifiers(p, wakeup);
 }
 
 /**
@@ -5448,10 +5451,12 @@ need_resched_nonpreemptible:
 	clear_tsk_need_resched(prev);
 
 	if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
-		if (unlikely(signal_pending_state(prev->state, prev)))
+		if (unlikely(signal_pending_state(prev->state, prev))) {
 			prev->state = TASK_RUNNING;
-		else
+		} else {
+			fire_sched_notifiers(prev, sleep);
 			deactivate_task(rq, prev, 1);
+		}
 		switch_count = &prev->nvcsw;
 	}
 
-- 
1.6.4.2

