Return-Path: <linux-kernel-owner+w=401wt.eu-S1758034AbYGDNfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758034AbYGDNfy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 09:35:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753679AbYGDNfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 09:35:46 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:43125 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662AbYGDNfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 09:35:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:content-type
         :content-transfer-encoding:from;
        b=LHiWsNYa+6uPrsM/3Gz/GZCwSaNsSGYQgnbrbyAbeW6G0Z+3i2EkEcDcir7VV+dZr2
         zaGdhVl7aSF+39pwdU+gfYff162RFjqk6mr6ck9nNqFKuc5j6fMxufjgQwOUtFHIwrXY
         DJ9+YUI2I/xO2sLznh13het3Tcpfa3977xZIo=
Message-ID: <486E271E.705@sidebranch.com>
Date: Fri, 04 Jul 2008 15:35:26 +0200
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       RT <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>
CC: leon@sidebranch.com
Subject: [PATCH -rt] [resend as inlined patch] {queue,schedule}_work_prio()
 allowing work priorities other than caller's priority
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
From: Leon Woestenberg <leon.woestenberg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Against 2.6.24.7-rt14. Tested on IXP4xx platform.

Adds schedule_work_prio() and queue_work_prio() so that work can be
scheduled with a different priority than the caller.

Under PREEMPT RT, schedule_work() and therefore queue_work() makes
the work inherit the caller's priority.

However, if a real-time kernel interrupt handler thread defers work it 
may want
the deferred work have lower priority so it does not contend for the cpu 
with
succeeding interrupt handling.

The faulty case was a non-FIFO serial driver that deferred LED blinking to
a workqueue using schedule_work(). However, that work used GPIO 
bitbanged I2C,
which uses 50 usecs udelay()s. With the work inheriting the serial IRQ 
priority,
it easily missed the ~60 usec deadline of 115200 bps communications.

This patch solves the issue with the IRQ using schedule_work_prio().

Signed-off-by: Leon Woestenberg <leon@sidebranch.com>

Index: linux-2.6.24/kernel/workqueue.c
===================================================================
--- linux-2.6.24.orig/kernel/workqueue.c    2008-06-30 
17:12:05.000000000 +0200
+++ linux-2.6.24/kernel/workqueue.c    2008-06-30 17:25:03.000000000 +0200
@@ -163,9 +163,10 @@
 }
 
 /**
- * queue_work - queue work on a workqueue
+ * queue_work_prio - queue work on a workqueue and set work priority
  * @wq: workqueue to use
  * @work: work to queue
+ * @prio: priority of work
  *
  * Returns 0 if @work was already on a queue, non-zero otherwise.
  *
@@ -174,17 +175,36 @@
  *
  * Especially no such guarantee on PREEMPT_RT.
  */
-int fastcall queue_work(struct workqueue_struct *wq, struct work_struct 
*work)
+int fastcall queue_work_prio(struct workqueue_struct *wq,
+  struct work_struct *work, int prio)
 {
     int ret = 0, cpu = raw_smp_processor_id();
 
     if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work))) {
         BUG_ON(!plist_node_empty(&work->entry));
-        __queue_work(wq_per_cpu(wq, cpu), work, current->normal_prio);
+        __queue_work(wq_per_cpu(wq, cpu), work, prio);
         ret = 1;
     }
     return ret;
 }
+EXPORT_SYMBOL_GPL(queue_work_prio);
+
+/**
+ * queue_work - queue work on a workqueue. work inherits caller's prio.
+ * @wq: workqueue to use
+ * @work: work to queue
+ *
+ * Returns 0 if @work was already on a queue, non-zero otherwise.
+ *
+ * We queue the work to the CPU it was submitted, but there is no
+ * guarantee that it will be processed by that CPU.
+ *
+ * Especially no such guarantee on PREEMPT_RT.
+ */
+int fastcall queue_work(struct workqueue_struct *wq, struct work_struct 
*work)
+{
+  return queue_work_prio(wq, work, current->normal_prio);
+}
 EXPORT_SYMBOL_GPL(queue_work);
 
 void delayed_work_timer_fn(unsigned long __data)
@@ -627,7 +647,8 @@
  * schedule_work - put work task in global workqueue
  * @work: job to be done
  *
- * This puts a job in the kernel-global workqueue.
+ * This puts a job in the kernel-global workqueue. The job inherits the
+ * caller's priority.
  */
 int fastcall schedule_work(struct work_struct *work)
 {
@@ -636,6 +657,19 @@
 EXPORT_SYMBOL(schedule_work);
 
 /**
+ * schedule_work_prio - put work task in global workqueue, set work prio
+ * @work: job to be done
+ *
+ * This puts a job in the kernel-global workqueue. The job gets the 
specified
+ * priority.
+ */
+int fastcall schedule_work_prio(struct work_struct *work, int prio)
+{
+    return queue_work_prio(keventd_wq, work, prio);
+}
+EXPORT_SYMBOL(schedule_work_prio);
+
+/**
  * schedule_delayed_work - put work task in global workqueue after delay
  * @dwork: job to be done
  * @delay: number of jiffies to wait or 0 for immediate execution
Index: linux-2.6.24/include/linux/workqueue.h
===================================================================
--- linux-2.6.24.orig/include/linux/workqueue.h    2008-06-30 
17:12:57.000000000 +0200
+++ linux-2.6.24/include/linux/workqueue.h    2008-06-30 
17:30:34.000000000 +0200
@@ -185,6 +185,7 @@
 extern void destroy_workqueue(struct workqueue_struct *wq);
 
 extern int FASTCALL(queue_work(struct workqueue_struct *wq, struct 
work_struct *work));
+extern int FASTCALL(queue_work_prio(struct workqueue_struct *wq, struct 
work_struct *work, int prio));
 extern int FASTCALL(queue_delayed_work(struct workqueue_struct *wq,
             struct delayed_work *work, unsigned long delay));
 extern int queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
@@ -194,6 +195,7 @@
 extern void flush_scheduled_work(void);
 
 extern int FASTCALL(schedule_work(struct work_struct *work));
+extern int FASTCALL(schedule_work_prio(struct work_struct *work, int 
prio));
 extern int FASTCALL(schedule_delayed_work(struct delayed_work *work,
                     unsigned long delay));
 extern int schedule_delayed_work_on(int cpu, struct delayed_work *work,

