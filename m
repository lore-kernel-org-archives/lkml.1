Return-Path: <linux-kernel-owner+w=401wt.eu-S1757345AbYGJAIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345AbYGJAIz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 20:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756510AbYGJAGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 20:06:50 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49037 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756010AbYGJAGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 20:06:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm 5/8] Introduce new interface schedule_work_on
Date: Thu, 10 Jul 2008 02:03:26 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@suse.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Zhang Rui <rui.zhang@intel.com>, Rus <harbour@sfinx.od.ua>
References: <200807100152.17755.rjw@sisk.pl>
In-Reply-To: <200807100152.17755.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807100203.27170.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Rui <rui.zhang@intel.com>
Subject: Introduce new interface schedule_work_on

This interface allows adding a job on a specific cpu.

Although a work struct on a cpu will be scheduled to other cpu if the cpu dies,
there is a recursion if a work task tries to offline the cpu it's running on.
we need to schedule the task to a specific cpu in this case.
http://bugzilla.kernel.org/show_bug.cgi?id=10897

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Tested-by: Rus <harbour@sfinx.od.ua>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 include/linux/workqueue.h |    3 +++
 kernel/workqueue.c        |   39 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 42 insertions(+)

Index: linux-2.6/include/linux/workqueue.h
===================================================================
--- linux-2.6.orig/include/linux/workqueue.h	2007-05-04 10:57:08.000000000 +0800
+++ linux-2.6/include/linux/workqueue.h	2008-07-04 10:03:21.000000000 +0800
@@ -179,6 +179,8 @@
 extern void destroy_workqueue(struct workqueue_struct *wq);
 
 extern int queue_work(struct workqueue_struct *wq, struct work_struct *work);
+extern int queue_work_on(int cpu, struct workqueue_struct *wq,
+			struct work_struct *work);
 extern int queue_delayed_work(struct workqueue_struct *wq,
 			struct delayed_work *work, unsigned long delay);
 extern int queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
@@ -188,6 +190,7 @@
 extern void flush_scheduled_work(void);
 
 extern int schedule_work(struct work_struct *work);
+extern int schedule_work_on(int cpu, struct work_struct *work);
 extern int schedule_delayed_work(struct delayed_work *work, unsigned long delay);
 extern int schedule_delayed_work_on(int cpu, struct delayed_work *work,
 					unsigned long delay);
Index: linux-2.6/kernel/workqueue.c
===================================================================
--- linux-2.6.orig/kernel/workqueue.c	2007-05-04 10:57:08.000000000 +0800
+++ linux-2.6/kernel/workqueue.c	2008-07-04 10:05:01.000000000 +0800
@@ -175,6 +175,32 @@
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
+int
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
+EXPORT_SYMBOL_GPL(queue_work_on);
+
 static void delayed_work_timer_fn(unsigned long __data)
 {
 	struct delayed_work *dwork = (struct delayed_work *)__data;
@@ -553,6 +579,19 @@
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


--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/



