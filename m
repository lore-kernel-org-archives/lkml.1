Return-Path: <linux-kernel-owner+w=401wt.eu-S1754742AbYBDMRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742AbYBDMRw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 07:17:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752535AbYBDMRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 07:17:44 -0500
Received: from ozlabs.org ([203.10.76.45]:53279 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125AbYBDMRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 07:17:44 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3/5] typesafe: kthread_create and kthread_run
Date: Mon, 4 Feb 2008 23:17:29 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org
References: <200802042311.18762.rusty@rustcorp.com.au> <200802042314.18738.rusty@rustcorp.com.au> <200802042316.02963.rusty@rustcorp.com.au>
In-Reply-To: <200802042316.02963.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802042317.29130.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using cast_if_type() we can have a callback funciton either of the
exactly correct type to take "data", or to take a void *.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/kthread.h |   30 +++++++++++++++++++++++++++---
 kernel/kthread.c        |   29 +++++------------------------
 2 files changed, 32 insertions(+), 27 deletions(-)

diff -r 5748be68d6ee include/linux/kthread.h
--- a/include/linux/kthread.h	Wed Jan 23 12:08:28 2008 +1100
+++ b/include/linux/kthread.h	Wed Jan 23 12:14:00 2008 +1100
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
+#define kthread_create(threadfn, data, namefmt...)			\
+	__kthread_create(cast_if_type((threadfn), int(*)(typeof(data)), \
+				      int(*)(void *)),			\
+			 (data), namefmt)
+
+struct task_struct *__kthread_create(int (*threadfn)(void *data),
+				     void *data,
+				     const char namefmt[], ...);
 
 /**
  * kthread_run - create and wake a thread.
diff -r 5748be68d6ee kernel/kthread.c
--- a/kernel/kthread.c	Wed Jan 23 12:08:28 2008 +1100
+++ b/kernel/kthread.c	Wed Jan 23 12:14:00 2008 +1100
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
