Return-Path: <linux-kernel-owner+w=401wt.eu-S1758811AbYGCMWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758811AbYGCMWk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 08:22:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754124AbYGCMWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 08:22:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:26576 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757323AbYGCMWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 08:22:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,742,1204531200"; 
   d="scan'208";a="584649654"
Subject: [PATCH 1/2] introduce new interface schedule_work_on
From: Zhang Rui <rui.zhang@intel.com>
To: linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, harbour@sfinx.od.ua
Content-Type: text/plain
Date: Thu, 03 Jul 2008 15:56:49 +0800
Message-Id: <1215071809.3214.0.camel@rzhang-dt.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This interface allows adding a job on a specific cpu.

Although a work struct on a cpu will be scheduled to other cpu if the cpu dies,
there is a recursion if a work task tries to offline the cpu it's running on.
we need to schedule the task to a specific cpu in this case.
http://bugzilla.kernel.org/show_bug.cgi?id=10897

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Tested-by: Rus <harbour@sfinx.od.ua>
---
 include/linux/workqueue.h |    1 +
 kernel/workqueue.c        |   38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+)

Index: linux-2.6/include/linux/workqueue.h
===================================================================
--- linux-2.6.orig/include/linux/workqueue.h	2008-07-03 11:13:23.000000000 +0800
+++ linux-2.6/include/linux/workqueue.h	2008-07-03 11:13:25.000000000 +0800
@@ -188,6 +188,7 @@
 extern void flush_scheduled_work(void);
 
 extern int schedule_work(struct work_struct *work);
+extern int schedule_work_on(int cpu, struct work_struct *work);
 extern int schedule_delayed_work(struct delayed_work *work, unsigned long delay);
 extern int schedule_delayed_work_on(int cpu, struct delayed_work *work,
 					unsigned long delay);
Index: linux-2.6/kernel/workqueue.c
===================================================================
--- linux-2.6.orig/kernel/workqueue.c	2008-07-03 11:13:23.000000000 +0800
+++ linux-2.6/kernel/workqueue.c	2008-07-03 11:14:56.000000000 +0800
@@ -175,6 +175,31 @@
 }
 EXPORT_SYMBOL_GPL(queue_work);
 
+/**
+ * queue_work_on - queue work on specific cpu
+ * @cpu: CPU number to execute work on
+ * @wq: workqueue to use
+ * @work: work to queue
+ *
+ * Returns 0 if @work was already on a queue, non-zero otherwise.
+ *
+ * We queue the work to a specific CPU
+ */
+static int
+queue_work_on(int cpu, struct workqueue_struct *wq, struct work_struct *work)
+{
+	int ret = 0;
+
+	if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work))) {
+		BUG_ON(!list_empty(&work->entry));
+		preempt_disable();
+		__queue_work(wq_per_cpu(wq, cpu), work);
+		preempt_enable();
+		ret = 1;
+	}
+	return ret;
+}
+
 static void delayed_work_timer_fn(unsigned long __data)
 {
 	struct delayed_work *dwork = (struct delayed_work *)__data;
@@ -553,6 +578,19 @@
 }
 EXPORT_SYMBOL(schedule_work);
 
+/*
+ * schedule_work_on - put work task on a specific cpu
+ * @cpu: cpu to put the work task on
+ * @work: job to be done
+ *
+ * This puts a job on a specific cpu
+ */
+int schedule_work_on(int cpu, struct work_struct *work)
+{
+	return queue_work_on(cpu, keventd_wq, work);
+}
+EXPORT_SYMBOL(schedule_work_on);
+
 /**
  * schedule_delayed_work - put work task in global workqueue after delay
  * @dwork: job to be done


