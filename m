Return-Path: <linux-kernel-owner+w=401wt.eu-S1756085AbYGYCRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085AbYGYCRv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 22:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752795AbYGYCRn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 22:17:43 -0400
Received: from ozlabs.org ([203.10.76.45]:41746 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624AbYGYCRn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 22:17:43 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3/4] typesafe: kthread_create and kthread_run
Date: Fri, 25 Jul 2008 12:17:41 +1000
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
       Harvey Harrison <harvey.harrison@gmail.com>
References: <200807251213.17773.rusty@rustcorp.com.au> <200807251214.51807.rusty@rustcorp.com.au> <200807251216.12139.rusty@rustcorp.com.au>
In-Reply-To: <200807251216.12139.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807251217.41875.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Assumes patch to add printf attr to kthread_create is applied, but fixup trivial)

Straight-forward conversion to allow typesafe callbacks.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/kthread.h |   28 +++++++++++++++++++++++++---
 kernel/kthread.c        |   29 +++++------------------------
 2 files changed, 30 insertions(+), 27 deletions(-)

diff -r f5a7f7f9683c include/linux/kthread.h
--- a/include/linux/kthread.h	Mon Apr 07 18:36:20 2008 +1000
+++ b/include/linux/kthread.h	Mon Apr 07 19:12:04 2008 +1000
@@ -4,9 +4,31 @@
 #include <linux/err.h>
 #include <linux/sched.h>
 
-struct task_struct *kthread_create(int (*threadfn)(void *data),
-				   void *data,
-				   const char namefmt[], ...)
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
+	__kthread_create(typesafe_cb(int,(threadfn),(data)), (data), namefmt)
+
+struct task_struct *__kthread_create(int (*threadfn)(void *data),
+				     void *data,
+				     const char namefmt[], ...)
 	__attribute__((format(printf, 3, 4)));
 
 /**
diff -r f5a7f7f9683c kernel/kthread.c
--- a/kernel/kthread.c	Mon Apr 07 18:36:20 2008 +1000
+++ b/kernel/kthread.c	Mon Apr 07 19:12:04 2008 +1000
@@ -112,29 +112,10 @@ static void create_kthread(struct kthrea
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
 
@@ -159,7 +140,7 @@ struct task_struct *kthread_create(int (
 	}
 	return create.result;
 }
-EXPORT_SYMBOL(kthread_create);
+EXPORT_SYMBOL(__kthread_create);
 
 /**
  * kthread_bind - bind a just-created kthread to a cpu.
