Return-Path: <linux-kernel-owner+w=401wt.eu-S1753693AbZKPRQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693AbZKPRQi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 12:16:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753655AbZKPRQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 12:16:37 -0500
Received: from hera.kernel.org ([140.211.167.34]:33331 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753043AbZKPRQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 12:16:36 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       torvalds@linux-foundation.org, avi@redhat.com, peterz@infradead.org,
       andi@firstfloor.org, fweisbec@gmail.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 07/21] sched: implement sched_notifier_wake_up_process()
Date: Tue, 17 Nov 2009 02:15:12 +0900
Message-Id: <1258391726-30264-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1258391726-30264-1-git-send-email-tj@kernel.org>
References: <1258391726-30264-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement sched_notifier_wake_up_process() which can be called from
activate, deactivate and in scheduler notifiers to wake up a task
which is bound to the same cpu.  This will be used to implement
concurrency managed workqueue.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/sched.h |    1 +
 kernel/sched.c        |   37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 16dcd58..5d3a554 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1240,6 +1240,7 @@ struct sched_notifier {
 void sched_notifier_register(enum sched_notifier_type type,
 			     struct sched_notifier *notifier);
 void sched_notifier_unregister(struct sched_notifier *notifier);
+bool sched_notifier_wake_up_process(struct task_struct *p);
 
 struct rcu_node;
 
diff --git a/kernel/sched.c b/kernel/sched.c
index a25b993..c8868e2 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7388,6 +7388,43 @@ void sched_notifier_unregister(struct sched_notifier *notifier)
 }
 EXPORT_SYMBOL_GPL(sched_notifier_unregister);
 
+/**
+ * sched_notifier_wake_up_process - wake up a process from sched notifier
+ * @p: task to wake up
+ *
+ * Wake up @p.  This function can only be called from activate,
+ * deactivate and in scheduler notifiers and can only wake up tasks
+ * which are already bound to the cpu in question.
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
 #if defined(CONFIG_SCHED_DEBUG) && defined(CONFIG_SYSCTL)
 
 static struct ctl_table sd_ctl_dir[] = {
-- 
1.6.4.2

