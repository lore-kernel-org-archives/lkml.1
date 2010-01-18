Return-Path: <linux-kernel-owner+w=401wt.eu-S1755389Ab0ARA5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab0ARA5n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 19:57:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755324Ab0ARA5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 19:57:00 -0500
Received: from hera.kernel.org ([140.211.167.34]:54437 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755389Ab0ARAxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 19:53:44 -0500
From: Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 30/40] workqueue: implement work_busy()
Date: Mon, 18 Jan 2010 09:57:42 +0900
Message-Id: <1263776272-382-31-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1263776272-382-1-git-send-email-tj@kernel.org>
References: <1263776272-382-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 18 Jan 2010 00:52:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement work_busy() which tests whether a work is either pending or
running.  The test isn't synchronized against workqueue operation and
the result is only good as advisory hints or for debugging.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/workqueue.h |    2 +-
 kernel/workqueue.c        |   31 +++++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+), 1 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 265207d..4f8705f 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -293,8 +293,8 @@ extern int keventd_up(void);
 extern void init_workqueues(void);
 int execute_in_process_context(work_func_t fn, struct execute_work *);
 
+extern bool work_busy(struct work_struct *work);
 extern int flush_work(struct work_struct *work);
-
 extern int cancel_work_sync(struct work_struct *work);
 
 /*
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 233278c..882d4d8 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1960,6 +1960,37 @@ out_unlock:
 EXPORT_SYMBOL_GPL(flush_workqueue);
 
 /**
+ * work_busy - test whether a work is currently pending or running
+ * @work: the work to be tested
+ *
+ * Test whether @work is currently pending or running.  There is no
+ * synchronization around this function and the test result is
+ * unreliable and only useful as advisory hints or for debugging.  The
+ * caller is responsible for ensuring the workqueue @work was last
+ * queued on stays valid until this function returns.
+ *
+ * RETURNS:
+ * %true if @work is currently running, %false otherwise.
+ */
+bool work_busy(struct work_struct *work)
+{
+	struct cpu_workqueue_struct *cwq = get_wq_data(work);
+	struct global_cwq *gcwq;
+	unsigned long flags;
+	bool ret;
+
+	if (!cwq)
+		return false;
+	gcwq = cwq->gcwq;
+
+	spin_lock_irqsave(&gcwq->lock, flags);
+	ret = work_pending(work) || find_worker_executing_work(gcwq, work);
+	spin_unlock_irqrestore(&gcwq->lock, flags);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(work_busy);
+
+/**
  * flush_work - block until a work_struct's callback has terminated
  * @work: the work which is to be flushed
  *
-- 
1.6.4.2

