Return-Path: <linux-kernel-owner+w=401wt.eu-S1758199AbYBGJUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758199AbYBGJUs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 04:20:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754681AbYBGJUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 04:20:07 -0500
Received: from brick.kernel.dk ([87.55.233.238]:18484 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753373AbYBGJUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 04:20:00 -0500
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Alan.Brunelle@hp.com, arjan@linux.intel.com, dgc@sgi.com, npiggin@suse.de,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 2/8] Add interface for queuing work on a specific CPU
Date: Thu,  7 Feb 2008 10:18:59 +0100
Message-Id: <1202375945-29525-3-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.4.22.g7a20
In-Reply-To: <1202375945-29525-1-git-send-email-jens.axboe@oracle.com>
References: <1202375945-29525-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 include/linux/workqueue.h |    1 +
 kernel/workqueue.c        |   15 +++++++++++++++
 2 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 7f28c32..4c46944 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -179,6 +179,7 @@ __create_workqueue_key(const char *name, int singlethread,
 extern void destroy_workqueue(struct workqueue_struct *wq);
 
 extern int FASTCALL(queue_work(struct workqueue_struct *wq, struct work_struct *work));
+extern int FASTCALL(queue_work_on_cpu(struct workqueue_struct *wq, struct work_struct *work, int cpu));
 extern int FASTCALL(queue_delayed_work(struct workqueue_struct *wq,
 			struct delayed_work *work, unsigned long delay));
 extern int queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 52db48e..551ad7e 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -175,6 +175,21 @@ int fastcall queue_work(struct workqueue_struct *wq, struct work_struct *work)
 }
 EXPORT_SYMBOL_GPL(queue_work);
 
+int fastcall queue_work_on_cpu(struct workqueue_struct *wq,
+			       struct work_struct *work, int cpu)
+{
+	int ret = 0;
+
+	if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work))) {
+		BUG_ON(!list_empty(&work->entry));
+		__queue_work(per_cpu_ptr(wq->cpu_wq, cpu), work);
+		ret = 1;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(queue_work_on_cpu);
+
 void delayed_work_timer_fn(unsigned long __data)
 {
 	struct delayed_work *dwork = (struct delayed_work *)__data;
-- 
1.5.4.22.g7a20

