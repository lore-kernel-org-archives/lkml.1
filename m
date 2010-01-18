Return-Path: <linux-kernel-owner+w=401wt.eu-S1755588Ab0ARA6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588Ab0ARA6t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 19:58:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755356Ab0ARA6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 19:58:42 -0500
Received: from hera.kernel.org ([140.211.167.34]:54385 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755349Ab0ARAxd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 19:53:33 -0500
From: Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
Cc: Tejun Heo <tj@kernel.org>, Mike Galbraith <efault@gmx.de>
Subject: [PATCH 06/40] sched: add wakeup/sleep sched_notifiers and allow NULL notifier ops
Date: Mon, 18 Jan 2010 09:57:18 +0900
Message-Id: <1263776272-382-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1263776272-382-1-git-send-email-tj@kernel.org>
References: <1263776272-382-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 18 Jan 2010 00:52:09 +0000 (UTC)
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
index 9fc537a..a6b4e9c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1222,6 +1222,10 @@ struct sched_notifier;
 
 /**
  * sched_notifier_ops - notifiers called for scheduling events
+ * @wakeup: we're waking up
+ *    notifier: struct sched_notifier for the task being woken up
+ * @sleep: we're going to bed
+ *    notifier: struct sched_notifier for the task sleeping
  * @in: we're about to be rescheduled:
  *    notifier: struct sched_notifier for the task being scheduled
  *    cpu:  cpu we're scheduled on
@@ -1235,6 +1239,8 @@ struct sched_notifier;
  * and depended upon by its users.
  */
 struct sched_notifier_ops {
+	void (*wakeup)(struct sched_notifier *notifier);
+	void (*sleep)(struct sched_notifier *notifier);
 	void (*in)(struct sched_notifier *notifier, int cpu);
 	void (*out)(struct sched_notifier *notifier, struct task_struct *next);
 };
diff --git a/kernel/sched.c b/kernel/sched.c
index 30b7ea8..eae624f 100644
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
@@ -2439,6 +2440,8 @@ static inline void ttwu_post_activation(struct task_struct *p, struct rq *rq,
 		rq->idle_stamp = 0;
 	}
 #endif
+	if (success)
+		fire_sched_notifiers(p, wakeup);
 }
 
 /**
@@ -5481,10 +5484,12 @@ need_resched_nonpreemptible:
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

