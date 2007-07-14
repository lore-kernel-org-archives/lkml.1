Return-Path: <linux-kernel-owner+w=401wt.eu-S1758579AbXGNQDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758579AbXGNQDW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 12:03:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752715AbXGNQDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 12:03:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45860 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753898AbXGNQDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 12:03:03 -0400
Message-Id: <20070714175839.377905000@chello.nl>
References: <20070714175733.194012000@chello.nl>
User-Agent: quilt/0.45-1
Date: Sat, 14 Jul 2007 19:57:34 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Oleg Nesterov <oleg@tv-sign.ru>, Steven Rostedt <rostedt@goodmis.org>,
       Christoph Lameter <clameter@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH -rt 1/5] workqueue: queue_work_cpu
Content-Disposition: inline; filename=queue_work_cpu.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/workqueue.h |    1 +
 kernel/workqueue.c        |   13 +++++++++++++
 2 files changed, 14 insertions(+)

Index: linux-2.6/include/linux/workqueue.h
===================================================================
--- linux-2.6.orig/include/linux/workqueue.h
+++ linux-2.6/include/linux/workqueue.h
@@ -131,6 +131,7 @@ extern void set_workqueue_prio(struct wo
 extern void destroy_workqueue(struct workqueue_struct *wq);
 
 extern int FASTCALL(queue_work(struct workqueue_struct *wq, struct work_struct *work));
+extern int FASTCALL(queue_work_cpu(struct workqueue_struct *wq, struct work_struct *work, int cpu));
 extern int FASTCALL(queue_delayed_work(struct workqueue_struct *wq,
 			struct delayed_work *work, unsigned long delay));
 extern int queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
Index: linux-2.6/kernel/workqueue.c
===================================================================
--- linux-2.6.orig/kernel/workqueue.c
+++ linux-2.6/kernel/workqueue.c
@@ -176,6 +176,19 @@ int fastcall queue_work(struct workqueue
 }
 EXPORT_SYMBOL_GPL(queue_work);
 
+int fastcall queue_work_cpu(struct workqueue_struct *wq, struct work_struct *work, int cpu)
+{
+	int ret = 0;
+
+	if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work))) {
+		BUG_ON(!list_empty(&work->entry));
+		__queue_work(wq_per_cpu(wq, cpu), work);
+		ret = 1;
+	}
+	return ret;
+}
+EXPORT_SYMBOL_GPL(queue_work_cpu);
+
 void delayed_work_timer_fn(unsigned long __data)
 {
 	struct delayed_work *dwork = (struct delayed_work *)__data;

--

