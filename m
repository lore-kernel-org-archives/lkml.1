Return-Path: <linux-kernel-owner+w=401wt.eu-S1755216AbXGAPgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216AbXGAPgu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 11:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752330AbXGAPgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 11:36:43 -0400
Received: from mail.screens.ru ([213.234.233.54]:35676 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350AbXGAPgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 11:36:42 -0400
Date: Sun, 1 Jul 2007 19:36:29 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Jarek Poplawski <jarkao2@o2.pl>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] rename cancel_rearming_delayed_work() to cancel_delayed_work_sync()
Message-ID: <20070701153629.GA105@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Imho, the current naming of cancel_xxx workqueue functions is very confusing.

	cancel_delayed_work()
	cancel_rearming_delayed_work()
	cancel_rearming_delayed_workqueue()	// obsolete

	cancel_work_sync()

This looks as if the first 2 functions differ in "type" of their argument which
is not true any longer, nowadays the difference is the behaviour.

The semantics of cancel_rearming_delayed_work(dwork) was changed significantly,
it doesn't require that dwork rearms itself, and cancels dwork synchronously.

Rename it to cancel_delayed_work_sync(). This matches cancel_delayed_work() and
cancel_work_sync(). Re-create cancel_rearming_delayed_work() as a simple inline
obsolete wrapper, like cancel_rearming_delayed_workqueue().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- OLD/include/linux/workqueue.h~1_rename	2007-05-17 23:05:13.000000000 +0400
+++ OLD/include/linux/workqueue.h	2007-06-02 14:26:54.000000000 +0400
@@ -166,14 +166,21 @@ static inline int cancel_delayed_work(st
 	return ret;
 }
 
-extern void cancel_rearming_delayed_work(struct delayed_work *work);
+extern void cancel_delayed_work_sync(struct delayed_work *work);
 
-/* Obsolete. use cancel_rearming_delayed_work() */
+/* Obsolete. use cancel_delayed_work_sync() */
 static inline
 void cancel_rearming_delayed_workqueue(struct workqueue_struct *wq,
 					struct delayed_work *work)
 {
-	cancel_rearming_delayed_work(work);
+	cancel_delayed_work_sync(work);
+}
+
+/* Obsolete. use cancel_delayed_work_sync() */
+static inline
+void cancel_rearming_delayed_work(struct delayed_work *work)
+{
+	cancel_delayed_work_sync(work);
 }
 
 #endif
--- OLD/kernel/workqueue.c~1_rename	2007-05-19 01:55:03.000000000 +0400
+++ OLD/kernel/workqueue.c	2007-07-01 15:02:12.000000000 +0400
@@ -486,13 +486,13 @@ void cancel_work_sync(struct work_struct
 EXPORT_SYMBOL_GPL(cancel_work_sync);
 
 /**
- * cancel_rearming_delayed_work - reliably kill off a delayed work.
+ * cancel_delayed_work_sync - reliably kill off a delayed work.
  * @dwork: the delayed work struct
  *
  * It is possible to use this function if @dwork rearms itself via queue_work()
  * or queue_delayed_work(). See also the comment for cancel_work_sync().
  */
-void cancel_rearming_delayed_work(struct delayed_work *dwork)
+void cancel_delayed_work_sync(struct delayed_work *dwork)
 {
 	while (!del_timer(&dwork->timer) &&
 	       !try_to_grab_pending(&dwork->work))
@@ -500,7 +500,7 @@ void cancel_rearming_delayed_work(struct
 	wait_on_work(&dwork->work);
 	work_clear_pending(&dwork->work);
 }
-EXPORT_SYMBOL(cancel_rearming_delayed_work);
+EXPORT_SYMBOL(cancel_delayed_work_sync);
 
 static struct workqueue_struct *keventd_wq __read_mostly;
 

