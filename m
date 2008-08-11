Return-Path: <linux-kernel-owner+w=401wt.eu-S1751821AbYHKH4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821AbYHKH4q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 03:56:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751001AbYHKH4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 03:56:39 -0400
Received: from ozlabs.org ([203.10.76.45]:41446 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750739AbYHKH4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 03:56:38 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [RFC] typesafe callbacks?
Date: Mon, 11 Aug 2008 17:56:21 +1000
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org,
       Peter Moulder <Peter.Moulder@infotech.monash.edu.au>,
       Andi Kleen <ak@suse.de>, Al Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808111756.21850.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

  Well, noone else voiced great enthusiasm about typesafe callbacks.  I esp.
like them because we can use them to wean off unsigned long in timer
callbacks without a flag day.

Should I just drop these patches, or leave them in -next for a third round?
Rusty.

Megapatch for refreshing memory:

diff -r 281ec5e7d696 include/linux/kernel.h
--- a/include/linux/kernel.h	Mon Aug 11 17:54:26 2008 +1000
+++ b/include/linux/kernel.h	Mon Aug 11 17:54:45 2008 +1000
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
diff -r 281ec5e7d696 include/linux/kthread.h
--- a/include/linux/kthread.h	Mon Aug 11 17:54:26 2008 +1000
+++ b/include/linux/kthread.h	Mon Aug 11 17:54:45 2008 +1000
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
diff -r 281ec5e7d696 include/linux/stop_machine.h
--- a/include/linux/stop_machine.h	Mon Aug 11 17:54:26 2008 +1000
+++ b/include/linux/stop_machine.h	Mon Aug 11 17:54:45 2008 +1000
@@ -6,9 +6,8 @@
    diables preeempt. */
 #include <linux/cpu.h>
 #include <linux/cpumask.h>
+#include <linux/compiler.h>
 #include <asm/system.h>
-
-#if defined(CONFIG_STOP_MACHINE) && defined(CONFIG_SMP)
 
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
@@ -38,10 +39,12 @@ int stop_machine(int (*fn)(void *), void
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
diff -r 281ec5e7d696 include/linux/timer.h
--- a/include/linux/timer.h	Mon Aug 11 17:54:26 2008 +1000
+++ b/include/linux/timer.h	Mon Aug 11 17:54:45 2008 +1000
@@ -25,12 +25,22 @@ struct timer_list {
 
 extern struct tvec_base boot_tvec_bases;
 
-#define TIMER_INITIALIZER(_function, _expires, _data) {		\
-		.entry = { .prev = TIMER_ENTRY_STATIC },	\
-		.function = (_function),			\
-		.expires = (_expires),				\
-		.data = (_data),				\
-		.base = &boot_tvec_bases,			\
+/*
+ * For historic reasons the timer function takes an unsigned long, so
+ * we use this variant of typesafe_cb.  data is converted to an unsigned long
+ * if it is another integer type, by adding 0UL.
+ */
+#define typesafe_timerfn(fn, data)				\
+	__typesafe_cb(void (*)(unsigned long), (fn),		\
+		      void (*)(const typeof((data)+0UL)),	\
+		      void (*)(typeof((data)+0UL)))
+
+#define TIMER_INITIALIZER(_function, _expires, _data) {			\
+		.entry = { .prev = TIMER_ENTRY_STATIC },		\
+		.function = typesafe_timerfn((_function), (_data)),	\
+		.expires = (_expires),					\
+		.data = (unsigned long)(_data),				\
+		.base = &boot_tvec_bases,				\
 	}
 
 #define DEFINE_TIMER(_name, _function, _expires, _data)		\
@@ -51,9 +61,13 @@ static inline void init_timer_on_stack(s
 }
 #endif
 
-static inline void setup_timer(struct timer_list * timer,
-				void (*function)(unsigned long),
-				unsigned long data)
+#define setup_timer(timer, function, data)				\
+	__setup_timer((timer), typesafe_timerfn((function), (data)),	\
+		      (unsigned long)(data))
+
+static inline void __setup_timer(struct timer_list *timer,
+				 void (*function)(unsigned long),
+				 unsigned long data)
 {
 	timer->function = function;
 	timer->data = data;
diff -r 281ec5e7d696 kernel/kthread.c
--- a/kernel/kthread.c	Mon Aug 11 17:54:26 2008 +1000
+++ b/kernel/kthread.c	Mon Aug 11 17:54:45 2008 +1000
@@ -111,29 +111,10 @@ static void create_kthread(struct kthrea
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
 
@@ -158,7 +139,7 @@ struct task_struct *kthread_create(int (
 	}
 	return create.result;
 }
-EXPORT_SYMBOL(kthread_create);
+EXPORT_SYMBOL(__kthread_create);
 
 /**
  * kthread_bind - bind a just-created kthread to a cpu.
diff -r 281ec5e7d696 kernel/stop_machine.c
--- a/kernel/stop_machine.c	Mon Aug 11 17:54:26 2008 +1000
+++ b/kernel/stop_machine.c	Mon Aug 11 17:54:45 2008 +1000
@@ -175,7 +175,7 @@ kill_threads:
 	return err;
 }
 
-int stop_machine(int (*fn)(void *), void *data, const cpumask_t *cpus)
+int stop_machine_notype(int (*fn)(void *), void *data, const cpumask_t *cpus)
 {
 	int ret;
 
@@ -186,4 +186,4 @@ int stop_machine(int (*fn)(void *), void
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(stop_machine);
+EXPORT_SYMBOL_GPL(stop_machine_notype);
