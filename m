Return-Path: <linux-kernel-owner+w=401wt.eu-S1753114AbYCLL5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114AbYCLL5W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 07:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751141AbYCLL5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 07:57:11 -0400
Received: from brick.kernel.dk ([87.55.233.238]:25742 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351AbYCLL5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 07:57:10 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: npiggin@suse.de, dgc@sgi.com, Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 5/7] Add interface for queuing work on a specific CPU
Date: Wed, 12 Mar 2008 12:55:38 +0100
Message-Id: <1205322940-20127-6-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <1205322940-20127-1-git-send-email-jens.axboe@oracle.com>
References: <1205322940-20127-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 include/linux/workqueue.h |    2 ++
 kernel/workqueue.c        |   33 ++++++++++++++++++++++++++-------
 2 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 542526c..fcc400b 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -181,6 +181,8 @@ extern void destroy_workqueue(struct workqueue_struct *wq);
 extern int queue_work(struct workqueue_struct *wq, struct work_struct *work);
 extern int queue_delayed_work(struct workqueue_struct *wq,
 			struct delayed_work *work, unsigned long delay);
+extern int queue_work_on_cpu(struct workqueue_struct *wq,
+			struct work_struct *work, int cpu);
 extern int queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
 			struct delayed_work *work, unsigned long delay);
 
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index ff06611..6bbd7b0 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -152,25 +152,44 @@ static void __queue_work(struct cpu_workqueue_struct *cwq,
 }
 
 /**
- * queue_work - queue work on a workqueue
+ * queue_work_on_cpu - queue work on a workqueue on a specific CPU
  * @wq: workqueue to use
  * @work: work to queue
+ * @cpu: cpu to queue the work on
  *
  * Returns 0 if @work was already on a queue, non-zero otherwise.
- *
- * We queue the work to the CPU it was submitted, but there is no
- * guarantee that it will be processed by that CPU.
  */
-int queue_work(struct workqueue_struct *wq, struct work_struct *work)
+int queue_work_on_cpu(struct workqueue_struct *wq, struct work_struct *work,
+		      int cpu)
 {
 	int ret = 0;
 
 	if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work))) {
 		BUG_ON(!list_empty(&work->entry));
-		__queue_work(wq_per_cpu(wq, get_cpu()), work);
-		put_cpu();
+		__queue_work(wq_per_cpu(wq, cpu), work);
 		ret = 1;
 	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(queue_work_on_cpu);
+
+/**
+ * queue_work - queue work on a workqueue
+ * @wq: workqueue to use
+ * @work: work to queue
+ *
+ * Returns 0 if @work was already on a queue, non-zero otherwise.
+ *
+ * We queue the work to the CPU it was submitted, but there is no
+ * guarantee that it will be processed by that CPU.
+ */
+int queue_work(struct workqueue_struct *wq, struct work_struct *work)
+{
+	int ret;
+
+	ret = queue_work_on_cpu(wq, work, get_cpu());
+	put_cpu();
 	return ret;
 }
 EXPORT_SYMBOL_GPL(queue_work);
-- 
1.5.4.GIT

