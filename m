Return-Path: <linux-kernel-owner+w=401wt.eu-S1758473AbZKTEve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758473AbZKTEve (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 23:51:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754744AbZKTEro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 23:47:44 -0500
Received: from hera.kernel.org ([140.211.167.34]:45013 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753664AbZKTErn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 23:47:43 -0500
From: Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, peterz@infradead.org, johannes@sipsolutions.net
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 05/19] sched: implement sched_notifier_wake_up_process()
Date: Fri, 20 Nov 2009 13:46:33 +0900
Message-Id: <1258692407-8985-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1258692407-8985-1-git-send-email-tj@kernel.org>
References: <1258692407-8985-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement sched_notifier_wake_up_process() which can be called from
wakeup, sleep and in scheduler notifiers to wake up a task which is
bound to the same cpu.  This will be used to implement concurrency
managed workqueue.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/sched.h |    1 +
 kernel/sched.c        |   37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 657372f..6889a6c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1246,6 +1246,7 @@ struct sched_notifier {
 
 void sched_notifier_register(struct sched_notifier *notifier);
 void sched_notifier_unregister(struct sched_notifier *notifier);
+bool sched_notifier_wake_up_process(struct task_struct *p);
 
 static inline void sched_notifier_init(struct sched_notifier *notifier,
 				       struct sched_notifier_ops *ops)
diff --git a/kernel/sched.c b/kernel/sched.c
index 88c0fda..b53db19 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2665,6 +2665,43 @@ void sched_notifier_unregister(struct sched_notifier *notifier)
 EXPORT_SYMBOL_GPL(sched_notifier_unregister);
 
 /**
+ * sched_notifier_wake_up_process - wake up a process from sched notifier
+ * @p: task to wake up
+ *
+ * Wake up @p.  This function can only be called from wakeup, sleep
+ * and in scheduler notifiers and can only wake up tasks which are
+ * already bound to the cpu in question.
+ *
+ * CONTEXT:
+ * Scheduler notifiers.
+ *
+ * RETURNS:
+ * true if @p was waken up, false if @p was already awake.
+ */
+bool sched_notifier_wake_up_process(struct task_struct *p)
+{
+	struct rq *rq = task_rq(p);
+	bool success = false;
+
+	assert_spin_locked(&rq->lock);
+
+	if (!p->se.on_rq) {
+		schedstat_inc(p, se.nr_wakeups);
+		schedstat_inc(p, se.nr_wakeups_local);
+		activate_task(rq, p, 1);
+		success = true;
+	}
+
+	trace_sched_wakeup(rq, p, success);
+	p->state = TASK_RUNNING;
+#ifdef CONFIG_SMP
+	if (p->sched_class->task_wake_up)
+		p->sched_class->task_wake_up(rq, p);
+#endif
+	return success;
+}
+
+/**
  * prepare_task_switch - prepare to switch tasks
  * @rq: the runqueue preparing to switch
  * @prev: the current task that is being switched out
-- 
1.6.4.2

