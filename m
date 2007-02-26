Return-Path: <linux-kernel-owner+w=401wt.eu-S932403AbXBZMLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932403AbXBZMLs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 07:11:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751222AbXBZMLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 07:11:48 -0500
Received: from mail.screens.ru ([213.234.233.54]:56372 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216AbXBZMLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 07:11:48 -0500
Date: Mon, 26 Feb 2007 15:11:49 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dave Jones <davej@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] workqueue: kill NOAUTOREL works
Message-ID: <20070226121149.GA257@tv-sign.ru>
References: <20070224202737.GA162@tv-sign.ru> <3040.1172490891@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3040.1172490891@redhat.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26, David Howells wrote:
>
> Oleg Nesterov <oleg@tv-sign.ru> wrote:
> 
> > and rename work_release to work_clear_pending to avoid a confusion.
> 
> Can you add a comment to the effect that this is a function for internal use
> only?  Or maybe make it __work_clear_pending()?

Done.

> Acked-By: David Howells <dhowells@redhat.com>

Thanks, included.


[PATCH] workqueue: kill NOAUTOREL works

We don't have any users, and it is not so trivial to use NOAUTOREL works
correctly. It is better to simplify API.

Delete NOAUTOREL support and rename work_release to work_clear_pending to
avoid a confusion.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-By: David Howells <dhowells@redhat.com>

--- 6.20-rc6-mm3/include/linux/workqueue.h~kill_nar	2007-02-12 03:26:54.000000000 +0300
+++ 6.20-rc6-mm3/include/linux/workqueue.h	2007-02-26 15:08:58.000000000 +0300
@@ -24,15 +24,13 @@ typedef void (*work_func_t)(struct work_
 struct work_struct {
 	atomic_long_t data;
 #define WORK_STRUCT_PENDING 0		/* T if work item pending execution */
-#define WORK_STRUCT_NOAUTOREL 1		/* F if work item automatically released on exec */
 #define WORK_STRUCT_FLAG_MASK (3UL)
 #define WORK_STRUCT_WQ_DATA_MASK (~WORK_STRUCT_FLAG_MASK)
 	struct list_head entry;
 	work_func_t func;
 };
 
-#define WORK_DATA_INIT(autorelease) \
-	ATOMIC_LONG_INIT((autorelease) << WORK_STRUCT_NOAUTOREL)
+#define WORK_DATA_INIT()	ATOMIC_LONG_INIT(0)
 
 struct delayed_work {
 	struct work_struct work;
@@ -44,14 +42,8 @@ struct execute_work {
 };
 
 #define __WORK_INITIALIZER(n, f) {				\
-	.data = WORK_DATA_INIT(0),				\
-        .entry	= { &(n).entry, &(n).entry },			\
-	.func = (f),						\
-	}
-
-#define __WORK_INITIALIZER_NAR(n, f) {				\
-	.data = WORK_DATA_INIT(1),				\
-        .entry	= { &(n).entry, &(n).entry },			\
+	.data = WORK_DATA_INIT(),				\
+	.entry	= { &(n).entry, &(n).entry },			\
 	.func = (f),						\
 	}
 
@@ -60,23 +52,12 @@ struct execute_work {
 	.timer = TIMER_INITIALIZER(NULL, 0, 0),			\
 	}
 
-#define __DELAYED_WORK_INITIALIZER_NAR(n, f) {			\
-	.work = __WORK_INITIALIZER_NAR((n).work, (f)),		\
-	.timer = TIMER_INITIALIZER(NULL, 0, 0),			\
-	}
-
 #define DECLARE_WORK(n, f)					\
 	struct work_struct n = __WORK_INITIALIZER(n, f)
 
-#define DECLARE_WORK_NAR(n, f)					\
-	struct work_struct n = __WORK_INITIALIZER_NAR(n, f)
-
 #define DECLARE_DELAYED_WORK(n, f)				\
 	struct delayed_work n = __DELAYED_WORK_INITIALIZER(n, f)
 
-#define DECLARE_DELAYED_WORK_NAR(n, f)			\
-	struct dwork_struct n = __DELAYED_WORK_INITIALIZER_NAR(n, f)
-
 /*
  * initialize a work item's function pointer
  */
@@ -95,16 +76,9 @@ struct execute_work {
  * assignment of the work data initializer allows the compiler
  * to generate better code.
  */
-#define INIT_WORK(_work, _func)					\
-	do {							\
-		(_work)->data = (atomic_long_t) WORK_DATA_INIT(0);	\
-		INIT_LIST_HEAD(&(_work)->entry);		\
-		PREPARE_WORK((_work), (_func));			\
-	} while (0)
-
-#define INIT_WORK_NAR(_work, _func)					\
+#define INIT_WORK(_work, _func)						\
 	do {								\
-		(_work)->data = (atomic_long_t) WORK_DATA_INIT(1);	\
+		(_work)->data = (atomic_long_t) WORK_DATA_INIT();	\
 		INIT_LIST_HEAD(&(_work)->entry);			\
 		PREPARE_WORK((_work), (_func));				\
 	} while (0)
@@ -115,12 +89,6 @@ struct execute_work {
 		init_timer(&(_work)->timer);			\
 	} while (0)
 
-#define INIT_DELAYED_WORK_NAR(_work, _func)			\
-	do {							\
-		INIT_WORK_NAR(&(_work)->work, (_func));		\
-		init_timer(&(_work)->timer);			\
-	} while (0)
-
 /**
  * work_pending - Find out whether a work item is currently pending
  * @work: The work item in question
@@ -137,24 +105,10 @@ struct execute_work {
 	work_pending(&(w)->work)
 
 /**
- * work_release - Release a work item under execution
- * @work: The work item to release
- *
- * This is used to release a work item that has been initialised with automatic
- * release mode disabled (WORK_STRUCT_NOAUTOREL is set).  This gives the work
- * function the opportunity to grab auxiliary data from the container of the
- * work_struct before clearing the pending bit as the work_struct may be
- * subject to deallocation the moment the pending bit is cleared.
- *
- * In such a case, this should be called in the work function after it has
- * fetched any data it may require from the containter of the work_struct.
- * After this function has been called, the work_struct may be scheduled for
- * further execution or it may be deallocated unless other precautions are
- * taken.
- *
- * This should also be used to release a delayed work item.
+ * work_clear_pending - for internal use only, mark a work item as not pending
+ * @work: The work item in question
  */
-#define work_release(work) \
+#define work_clear_pending(work) \
 	clear_bit(WORK_STRUCT_PENDING, work_data_bits(work))
 
 
@@ -201,7 +155,7 @@ static inline int cancel_delayed_work(st
 
 	ret = del_timer_sync(&work->timer);
 	if (ret)
-		work_release(&work->work);
+		work_clear_pending(&work->work);
 	return ret;
 }
 
--- 6.20-rc6-mm3/kernel/workqueue.c~kill_nar	2007-02-17 00:31:18.000000000 +0300
+++ 6.20-rc6-mm3/kernel/workqueue.c	2007-02-20 02:21:11.000000000 +0300
@@ -246,8 +246,7 @@ static void run_workqueue(struct cpu_wor
 		spin_unlock_irq(&cwq->lock);
 
 		BUG_ON(get_wq_data(work) != cwq);
-		if (!test_bit(WORK_STRUCT_NOAUTOREL, work_data_bits(work)))
-			work_release(work);
+		work_clear_pending(work);
 		f(work);
 
 		if (unlikely(in_atomic() || lockdep_depth(current) > 0)) {
@@ -454,7 +453,7 @@ void cancel_work_sync(struct work_struct
 	 */
 	spin_lock_irq(&cwq->lock);
 	list_del_init(&work->entry);
-	work_release(work);
+	work_clear_pending(work);
 	spin_unlock_irq(&cwq->lock);
 
 	wq = cwq->wq;

