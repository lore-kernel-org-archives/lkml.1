Return-Path: <linux-kernel-owner+w=401wt.eu-S1759480AbYARAwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759480AbYARAwX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 19:52:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757220AbYARAwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 19:52:15 -0500
Received: from ozlabs.org ([203.10.76.45]:43228 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756319AbYARAwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 19:52:14 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] Make kthread_create and kthread_run typesafe
Date: Fri, 18 Jan 2008 11:51:39 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801181151.40141.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With a little macro ugliness, we can make kthread_create() and
kthread_run() typesafe: avoid the casts to and from void *.  To do
this we use a temporary function pointer which takes the type of the
data as a callback: if the function doesn't match, we get:

	warning: initialization from incompatible pointer type

It's actually slightly over-strict, since a void * would be compatible
with any function type, but there's only one such case in the kernel
anyway.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/kthread.h |   30 +++++++++++++++++++++++++++---
 kernel/kthread.c        |   29 +++++------------------------
 2 files changed, 32 insertions(+), 27 deletions(-)

diff -r 110aa94129d0 include/linux/kthread.h
--- a/include/linux/kthread.h	Fri Jan 18 10:32:31 2008 +1100
+++ b/include/linux/kthread.h	Fri Jan 18 11:31:49 2008 +1100
@@ -4,9 +4,33 @@
 #include <linux/err.h>
 #include <linux/sched.h>
 
-struct task_struct *kthread_create(int (*threadfn)(void *data),
-				   void *data,
-				   const char namefmt[], ...);
+/**
+ * kthread_create - create a kthread.
+ * @threadfn: the function to run until signal_pending(current).
+ * @data: data ptr for @threadfn.
+ * @namefmt: printf-style name for the thread.
+ *
+ * Description: This helper function creates and names a kernel
+ * thread.  The thread will be stopped: use wake_up_process() to start
+ * it.  See also kthread_run(), kthread_create_on_cpu().
+ *
+ * When woken, the thread will run @threadfn() with @data as its
+ * argument. @threadfn() can either call do_exit() directly if it is a
+ * standalone thread for which noone will call kthread_stop(), or
+ * return when 'kthread_should_stop()' is true (which means
+ * kthread_stop() has been called).  The return value should be zero
+ * or a negative error number; it will be passed to kthread_stop().
+ *
+ * Returns a task_struct or ERR_PTR(-ENOMEM).
+ */
+#define kthread_create(threadfn, data, namefmt...) ({		\
+	int (*_threadfn)(typeof(data)) = (threadfn);		\
+	__kthread_create((void *)_threadfn, (data), namefmt);	\
+})
+
+struct task_struct *__kthread_create(int (*threadfn)(void *data),
+				     void *data,
+				     const char namefmt[], ...);
 
 /**
  * kthread_run - create and wake a thread.
diff -r 110aa94129d0 kernel/kthread.c
--- a/kernel/kthread.c	Fri Jan 18 10:32:31 2008 +1100
+++ b/kernel/kthread.c	Fri Jan 18 11:31:49 2008 +1100
@@ -102,29 +102,10 @@ static void create_kthread(struct kthrea
 	complete(&create->done);
 }
 
-/**
- * kthread_create - create a kthread.
- * @threadfn: the function to run until signal_pending(current).
- * @data: data ptr for @threadfn.
- * @namefmt: printf-style name for the thread.
- *
- * Description: This helper function creates and names a kernel
- * thread.  The thread will be stopped: use wake_up_process() to start
- * it.  See also kthread_run(), kthread_create_on_cpu().
- *
- * When woken, the thread will run @threadfn() with @data as its
- * argument. @threadfn() can either call do_exit() directly if it is a
- * standalone thread for which noone will call kthread_stop(), or
- * return when 'kthread_should_stop()' is true (which means
- * kthread_stop() has been called).  The return value should be zero
- * or a negative error number; it will be passed to kthread_stop().
- *
- * Returns a task_struct or ERR_PTR(-ENOMEM).
- */
-struct task_struct *kthread_create(int (*threadfn)(void *data),
-				   void *data,
-				   const char namefmt[],
-				   ...)
+struct task_struct *__kthread_create(int (*threadfn)(void *data),
+				     void *data,
+				     const char namefmt[],
+				     ...)
 {
 	struct kthread_create_info create;
 
@@ -149,7 +130,7 @@ struct task_struct *kthread_create(int (
 	}
 	return create.result;
 }
-EXPORT_SYMBOL(kthread_create);
+EXPORT_SYMBOL(__kthread_create);
 
 /**
  * kthread_bind - bind a just-created kthread to a cpu.

