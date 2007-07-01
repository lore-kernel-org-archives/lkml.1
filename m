Return-Path: <linux-kernel-owner+w=401wt.eu-S1756804AbXGAPhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804AbXGAPhU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 11:37:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752597AbXGAPhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 11:37:07 -0400
Received: from mail.screens.ru ([213.234.233.54]:35689 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350AbXGAPhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 11:37:05 -0400
Date: Sun, 1 Jul 2007 19:37:10 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Jarek Poplawski <jarkao2@o2.pl>, Steven Rostedt <rostedt@goodmis.org>,
       Tejun Heo <htejun@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] make cancel_xxx_work_sync() return a boolean
Message-ID: <20070701153710.GA108@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Change cancel_work_sync() and cancel_delayed_work_sync() to return a boolean
indicating whether the work was actually cancelled. A zero return value means
that the work was not pending/queued.

Without that kind of change it is not possible to avoid flush_workqueue()
sometimes, see the next patch as an example.

Also, this patch unifies both functions and kills the (unlikely) busy-wait loop.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- OLD/include/linux/workqueue.h~2_retval	2007-06-02 14:26:54.000000000 +0400
+++ OLD/include/linux/workqueue.h	2007-07-01 16:02:32.000000000 +0400
@@ -148,7 +148,7 @@ extern int keventd_up(void);
 extern void init_workqueues(void);
 int execute_in_process_context(work_func_t fn, struct execute_work *);
 
-extern void cancel_work_sync(struct work_struct *work);
+extern int cancel_work_sync(struct work_struct *work);
 
 /*
  * Kill off a pending schedule_delayed_work().  Note that the work callback
@@ -166,7 +166,7 @@ static inline int cancel_delayed_work(st
 	return ret;
 }
 
-extern void cancel_delayed_work_sync(struct delayed_work *work);
+extern int cancel_delayed_work_sync(struct delayed_work *work);
 
 /* Obsolete. use cancel_delayed_work_sync() */
 static inline
--- OLD/kernel/workqueue.c~2_retval	2007-07-01 15:02:12.000000000 +0400
+++ OLD/kernel/workqueue.c	2007-07-01 16:56:22.000000000 +0400
@@ -382,16 +382,16 @@ void fastcall flush_workqueue(struct wor
 EXPORT_SYMBOL_GPL(flush_workqueue);
 
 /*
- * Upon a successful return, the caller "owns" WORK_STRUCT_PENDING bit,
+ * Upon a successful return (>= 0), the caller "owns" WORK_STRUCT_PENDING bit,
  * so this work can't be re-armed in any way.
  */
 static int try_to_grab_pending(struct work_struct *work)
 {
 	struct cpu_workqueue_struct *cwq;
-	int ret = 0;
+	int ret = -1;
 
 	if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work)))
-		return 1;
+		return 0;
 
 	/*
 	 * The queueing is in progress, or it is already queued. Try to
@@ -457,10 +457,28 @@ static void wait_on_work(struct work_str
 		wait_on_cpu_work(per_cpu_ptr(wq->cpu_wq, cpu), work);
 }
 
+static int __cancel_work_timer(struct work_struct *work,
+				struct timer_list* timer)
+{
+	int ret;
+
+	do {
+		ret = (timer && likely(del_timer(timer)));
+		if (!ret)
+			ret = try_to_grab_pending(work);
+		wait_on_work(work);
+	} while (unlikely(ret < 0));
+
+	work_clear_pending(work);
+	return ret;
+}
+
 /**
  * cancel_work_sync - block until a work_struct's callback has terminated
  * @work: the work which is to be flushed
  *
+ * Returns true if @work was pending.
+ *
  * cancel_work_sync() will cancel the work if it is queued. If the work's
  * callback appears to be running, cancel_work_sync() will block until it
  * has completed.
@@ -476,12 +494,9 @@ static void wait_on_work(struct work_str
  * The caller must ensure that workqueue_struct on which this work was last
  * queued can't be destroyed before this function returns.
  */
-void cancel_work_sync(struct work_struct *work)
+int cancel_work_sync(struct work_struct *work)
 {
-	while (!try_to_grab_pending(work))
-		cpu_relax();
-	wait_on_work(work);
-	work_clear_pending(work);
+	return __cancel_work_timer(work, NULL);
 }
 EXPORT_SYMBOL_GPL(cancel_work_sync);
 
@@ -489,16 +504,14 @@ EXPORT_SYMBOL_GPL(cancel_work_sync);
  * cancel_delayed_work_sync - reliably kill off a delayed work.
  * @dwork: the delayed work struct
  *
+ * Returns true if @dwork was pending.
+ *
  * It is possible to use this function if @dwork rearms itself via queue_work()
  * or queue_delayed_work(). See also the comment for cancel_work_sync().
  */
-void cancel_delayed_work_sync(struct delayed_work *dwork)
+int cancel_delayed_work_sync(struct delayed_work *dwork)
 {
-	while (!del_timer(&dwork->timer) &&
-	       !try_to_grab_pending(&dwork->work))
-		cpu_relax();
-	wait_on_work(&dwork->work);
-	work_clear_pending(&dwork->work);
+	return __cancel_work_timer(&dwork->work, &dwork->timer);
 }
 EXPORT_SYMBOL(cancel_delayed_work_sync);
 

