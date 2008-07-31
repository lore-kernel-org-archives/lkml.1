Return-Path: <linux-kernel-owner+w=401wt.eu-S1753659AbYGaExm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659AbYGaExm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 00:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbYGaExd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 00:53:33 -0400
Received: from ozlabs.org ([203.10.76.45]:59262 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293AbYGaExc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 00:53:32 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [PULL] typesafe callbacks for kthread and stop_machine
Date: Thu, 31 Jul 2008 14:52:35 +1000
User-Agent: KMail/1.9.9
Cc: "Bert Wesarg" <bert.wesarg@googlemail.com>, Tejun Heo <htejun@gmail.com>,
       Andi Kleen <andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807311452.36025.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just the two places I look after.  And this time the conglomerate patch is
included below for more random commentry.

The following changes since commit 94ad374a0751f40d25e22e036c37f7263569d24c:
  Linus Torvalds (1):
        Fix off-by-one error in iov_iter_advance()

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus.git master

Rusty Russell (4):
      cast_if_type: allow macros functions which take more than one type.
      typesafe_cb: wrappers for typesafe callbacks.
      typesafe: kthread_create and kthread_run
      typesafe: stop_machine

 include/linux/compiler-gcc.h   |   18 ++++++++++++++++++
 include/linux/compiler-intel.h |    2 ++
 include/linux/kernel.h         |   35 +++++++++++++++++++++++++++++++++++
 include/linux/kthread.h        |   28 +++++++++++++++++++++++++---
 include/linux/stop_machine.h   |   13 ++++++++-----
 kernel/kthread.c               |   29 +++++------------------------
 kernel/stop_machine.c          |    4 ++--
 7 files changed, 95 insertions(+), 34 deletions(-)


diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index 5c8351b..3cdd22e 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -61,3 +61,21 @@
 #define  noinline			__attribute__((noinline))
 #define __attribute_const__		__attribute__((__const__))
 #define __maybe_unused			__attribute__((unused))
+
+/**
+ * cast_if_type - allow an alternate type
+ * @expr: the expression to optionally cast
+ * @oktype: the type to allow.
+ * @desttype: the type to cast to.
+ *
+ * This is used to accept a particular alternate type for an expression:
+ * because any other types will not be cast, they will cause a warning as
+ * normal.
+ *
+ * Note that the unnecessary trinary forces functions to devolve into
+ * function pointers as users expect, but means @expr must be a pointer or
+ * integer.
+ */
+#define cast_if_type(expr, oktype, desttype)	__builtin_choose_expr(	\
+	__builtin_types_compatible_p(typeof(1?(expr):(expr)), oktype),	\
+	(desttype)(expr), (expr))
diff --git a/include/linux/compiler-intel.h b/include/linux/compiler-intel.h
index d8e636e..7e704e6 100644
--- a/include/linux/compiler-intel.h
+++ b/include/linux/compiler-intel.h
@@ -29,3 +29,5 @@
 #endif
 
 #define uninitialized_var(x) x
+
+#define cast_if_type(expr, oktype, desttype) ((desttype)(expr))
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index aaa998f..8ea3c49 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -486,4 +486,39 @@ struct sysinfo {
 #define NUMA_BUILD 0
 #endif
 
+/* If fn is of type ok1 or ok2, cast to desttype */
+#define __typesafe_cb(desttype, fn, ok1, ok2) \
+	cast_if_type(cast_if_type((fn), ok1, desttype), ok2, desttype)
+
+/**
+ * typesafe_cb - cast a callback function if it matches the arg
+ * @rettype: the return type of the callback function
+ * @fn: the callback function to cast
+ * @arg: the (pointer) argument to hand to the callback function.
+ *
+ * If a callback function takes a single argument, this macro does
+ * appropriate casts to a function which takes a single void * argument if the
+ * callback provided matches the @arg (or a const version).
+ *
+ * It is assumed that @arg is of pointer type: usually @arg is passed
+ * or assigned to a void * elsewhere anyway.
+ */
+#define typesafe_cb(rettype, fn, arg)					\
+	__typesafe_cb(rettype (*)(void *), (fn),			\
+		      rettype (*)(const typeof(arg)),			\
+		      rettype (*)(typeof(arg)))
+
+/**
+ * typesafe_cb_preargs - cast a callback function if it matches the arg
+ * @rettype: the return type of the callback function
+ * @fn: the callback function to cast
+ * @arg: the (pointer) argument to hand to the callback function.
+ *
+ * This is a version of typesafe_cb() for callbacks that take other arguments
+ * before the @arg.
+ */
+#define typesafe_cb_preargs(rettype, fn, arg, ...)			\
+	__typesafe_cb(rettype (*)(__VA_ARGS__, void *), (fn),		\
+		      rettype (*)(__VA_ARGS__, const typeof(arg)),	\
+		      rettype (*)(__VA_ARGS__, typeof(arg)))
 #endif
diff --git a/include/linux/kthread.h b/include/linux/kthread.h
index aabc8a1..3152c1e 100644
--- a/include/linux/kthread.h
+++ b/include/linux/kthread.h
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
diff --git a/include/linux/stop_machine.h b/include/linux/stop_machine.h
index f1cb0ba..7c62754 100644
--- a/include/linux/stop_machine.h
+++ b/include/linux/stop_machine.h
@@ -6,10 +6,9 @@
    diables preeempt. */
 #include <linux/cpu.h>
 #include <linux/cpumask.h>
+#include <linux/compiler.h>
 #include <asm/system.h>
 
-#if defined(CONFIG_STOP_MACHINE) && defined(CONFIG_SMP)
-
 /* Deprecated, but useful for transition. */
 #define ALL_CPUS ~0U
 
@@ -26,8 +25,10 @@
  *
  * This can be thought of as a very heavy write lock, equivalent to
  * grabbing every spinlock in the kernel. */
-int stop_machine(int (*fn)(void *), void *data, const cpumask_t *cpus);
+#define stop_machine(fn, data, cpus)					\
+	stop_machine_notype(typesafe_cb(int, (fn), (data)), (data), (cpus))
 
+#if defined(CONFIG_STOP_MACHINE) && defined(CONFIG_SMP)
 /**
  * __stop_machine: freeze the machine on all CPUs and run this function
  * @fn: the function to run
@@ -38,10 +39,12 @@ int stop_machine(int (*fn)(void *), void *data, const cpumask_t *cpus);
  * won't come or go while it's being called.  Used by hotplug cpu.
  */
 int __stop_machine(int (*fn)(void *), void *data, const cpumask_t *cpus);
+
+int stop_machine_notype(int (*fn)(void *), void *data, const cpumask_t *cpus);
 #else
 
-static inline int stop_machine(int (*fn)(void *), void *data,
-			       const cpumask_t *cpus)
+static inline int stop_machine_notype(int (*fn)(void *), void *data,
+				      const cpumask_t *cpus)
 {
 	int ret;
 	local_irq_disable();
diff --git a/kernel/kthread.c b/kernel/kthread.c
index 96cff2f..822d64d 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -111,29 +111,10 @@ static void create_kthread(struct kthread_create_info *create)
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
 
@@ -158,7 +139,7 @@ struct task_struct *kthread_create(int (*threadfn)(void *data),
 	}
 	return create.result;
 }
-EXPORT_SYMBOL(kthread_create);
+EXPORT_SYMBOL(__kthread_create);
 
 /**
  * kthread_bind - bind a just-created kthread to a cpu.
diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index e446c7c..82d72ae 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -176,7 +176,7 @@ kill_threads:
 	return err;
 }
 
-int stop_machine(int (*fn)(void *), void *data, const cpumask_t *cpus)
+int stop_machine_notype(int (*fn)(void *), void *data, const cpumask_t *cpus)
 {
 	int ret;
 
@@ -187,4 +187,4 @@ int stop_machine(int (*fn)(void *), void *data, const cpumask_t *cpus)
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(stop_machine);
+EXPORT_SYMBOL_GPL(stop_machine_notype);
