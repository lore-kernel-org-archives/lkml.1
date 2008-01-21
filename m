Return-Path: <linux-kernel-owner+w=401wt.eu-S1760214AbYAULeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760214AbYAULeA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 06:34:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759027AbYAULdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 06:33:52 -0500
Received: from ozlabs.org ([203.10.76.45]:43298 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758987AbYAULdv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 06:33:51 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH 0/6] RFC: Typesafe callbacks
Date: Mon, 21 Jan 2008 22:33:04 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>
References: <200801202046.14746.rusty@rustcorp.com.au> <47934604.6080505@gmail.com> <200801210917.30977.rusty@rustcorp.com.au>
In-Reply-To: <200801210917.30977.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801212233.04989.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 January 2008 09:17:30 Rusty Russell wrote:
> On Monday 21 January 2008 00:00:52 Tejun Heo wrote:
> > What should be do are
> >
> > * Check that the threadfn's argument fits into void *.
>
> For everything but timer, you'll get a warning if the data isn't assignable
> to a void *, so you get a warning if you use a non-pointer already.
>
> But it would be cool to allow functions which take an unsigned long.
...
> I'll test this out and see what I can make...

I think this comes under "too ugly", but here's an attempt.

Two patches, the infrastructure then the stop_machine change, and some
test cases (#if 0'd out).
===
Attempt to create callbacks which take unsigned long as well as
correct pointer types.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/compiler-gcc.h   |   72 +++++++++++++++++++++++++++++++++++++++++
 include/linux/compiler-intel.h |    3 +
 2 files changed, 75 insertions(+)

diff -r f41638047650 include/linux/compiler-gcc.h
--- a/include/linux/compiler-gcc.h	Mon Jan 21 11:46:30 2008 +1100
+++ b/include/linux/compiler-gcc.h	Mon Jan 21 15:05:45 2008 +1100
@@ -53,3 +53,75 @@
 #define  noinline			__attribute__((noinline))
 #define __attribute_const__		__attribute__((__const__))
 #define __maybe_unused			__attribute__((unused))
+
+/* This is not complete: I can't figure out a way to handle enums. */
+#define ulong_compatible(arg)						\
+	(__builtin_types_compatible_p(typeof(arg), char)		\
+	 || __builtin_types_compatible_p(typeof(arg), unsigned char)	\
+	 || __builtin_types_compatible_p(typeof(arg), signed char)	\
+	 || __builtin_types_compatible_p(typeof(arg), unsigned short)	\
+	 || __builtin_types_compatible_p(typeof(arg), short)		\
+	 || __builtin_types_compatible_p(typeof(arg), unsigned int)	\
+	 || __builtin_types_compatible_p(typeof(arg), int)		\
+	 || __builtin_types_compatible_p(typeof(arg), unsigned long)	\
+	 || __builtin_types_compatible_p(typeof(arg), long))
+
+/**
+ * typesafe_function - cast function type if it's compatible
+ * @fn: the function or function pointer
+ * @ulongtype: the function pointer type if arg is an integer
+ * @safetype: the function pointer type which matches typeof(arg)
+ * @fntype: the generic function pointer type to cast to
+ * @arg: the function argument.
+ *
+ * Callback functions are usually declared to take a "void *arg"
+ * argument, which stops the compiler from doing type checking.  We
+ * can freely cast to function pointer which takes "void *" in two
+ * cases: a function which takes a different pointer type or an
+ * unsigned long.
+ *
+ * Typechecking is done in two stages: this macro handles the cases where
+ * @fn takes an unsigned long and @arg is compatible with that, and also
+ * the case where @fn and @arg match types.  For other cases, @fn is not
+ * cast, so using the results of this macro should cause a warning unless
+ * @fn is already of if type @fntype.
+ *
+ * Logic looks like this:
+ * if (typeof(@arg) compatible with unsigned long) {
+ *     if (typeof(@fn) == @ulongtype)
+ *         (@fntype)(@fn); // OK!
+ *     else
+ *         @fn; // will give type warning unless it's of @fntype already.
+ * } else if (typeof(@fn) == @safetype)
+ *     (@fntype)(@fn); // OK!
+ * else
+ *     (@fn);  // will give type warning unless it's of @fntype already.
+ */
+#define typesafe_function(fn, ulongtype, safetype, fntype, arg)		\
+__builtin_choose_expr((ulong_compatible(arg)				\
+		       && __builtin_types_compatible_p(typeof(1?(fn):NULL), \
+						       ulongtype))	\
+		      || (!ulong_compatible(arg)			\
+			  && __builtin_types_compatible_p(typeof(1?(fn):NULL), \
+							  safetype)),	\
+		      ((fntype)(fn)),					\
+		      (fn))
+
+/**
+ * typesafe_arg - cast to void * if function expects an unsigned long
+ * @fn: the function or function pointer
+ * @ulongtype: the function pointer type if arg is an integer
+ * @arg: the function argument
+ *
+ * If @fn expects an unsigned long, cast @arg, otherwise leave it
+ * alone (if it's not void * compatible, this will cause a warning
+ * when used).
+ *
+ * Note that we've already checked @arg/@fn compatibility in
+ * typesafe_function(): this makes sure that @arg is a pointer or an integer
+ * if @fn expects an unsigned long.
+ */
+#define typesafe_arg(fn, ulongtype, arg)				\
+__builtin_choose_expr(__builtin_types_compatible_p(typeof(1?(fn):NULL), \
+						   ulongtype),		\
+		      ((void *)(long)(arg)), (arg))
diff -r f41638047650 include/linux/compiler-intel.h
--- a/include/linux/compiler-intel.h	Mon Jan 21 11:46:30 2008 +1100
+++ b/include/linux/compiler-intel.h	Mon Jan 21 15:05:45 2008 +1100
@@ -29,3 +29,6 @@
 #endif
 
 #define uninitialized_var(x) x
+
+#define typesafe_function(fn, ulongtype, safetype, fntype, arg) ((fntype)(fn))
+#define typesafe_arg(fn, ulongtype, arg) ((void *)arg)

===
typesafe: Convert stop_machine and callers

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/char/hw_random/intel-rng.c |    3 -
 include/linux/stop_machine.h       |   16 ++++--
 kernel/module.c                    |   10 +---
 kernel/stop_machine.c              |   89 ++++++++++++++++++++++++++++++++++++-
 4 files changed, 103 insertions(+), 15 deletions(-)

diff -r e279190b7b43 drivers/char/hw_random/intel-rng.c
--- a/drivers/char/hw_random/intel-rng.c	Mon Jan 21 14:42:54 2008 +1100
+++ b/drivers/char/hw_random/intel-rng.c	Mon Jan 21 15:04:00 2008 +1100
@@ -227,9 +227,8 @@ struct intel_rng_hw {
 	u8 fwh_dec_en1_val;
 };
 
-static int __init intel_rng_hw_init(void *_intel_rng_hw)
+static int __init intel_rng_hw_init(struct intel_rng_hw *intel_rng_hw)
 {
-	struct intel_rng_hw *intel_rng_hw = _intel_rng_hw;
 	u8 mfc, dvc;
 
 	/* interrupts disabled in stop_machine_run call */
diff -r e279190b7b43 include/linux/stop_machine.h
--- a/include/linux/stop_machine.h	Mon Jan 21 14:42:54 2008 +1100
+++ b/include/linux/stop_machine.h	Mon Jan 21 15:04:00 2008 +1100
@@ -5,9 +5,9 @@
    (and more).  So the "read" side to such a lock is anything which
    diables preeempt. */
 #include <linux/cpu.h>
+#include <linux/compiler.h>
 #include <asm/system.h>
 
-#if defined(CONFIG_STOP_MACHINE) && defined(CONFIG_SMP)
 /**
  * stop_machine_run: freeze the machine on all CPUs and run this function
  * @fn: the function to run
@@ -21,7 +21,15 @@
  *
  * This can be thought of as a very heavy write lock, equivalent to
  * grabbing every spinlock in the kernel. */
-int stop_machine_run(int (*fn)(void *), void *data, unsigned int cpu);
+#define stop_machine_run(fn, data, cpu)					\
+stop_machine_run_notype(typesafe_function((fn), int(*)(unsigned long),	\
+					  int(*)(typeof(data)),		\
+					  int(*)(void *), (data)),	\
+			typesafe_arg((fn), int(*)(unsigned long), (data)), \
+			(cpu))
+
+#if defined(CONFIG_STOP_MACHINE) && defined(CONFIG_SMP)
+int stop_machine_run_notype(int (*fn)(void *), void *data, unsigned int cpu);
 
 /**
  * __stop_machine_run: freeze the machine on all CPUs and run this function
@@ -38,8 +46,8 @@ struct task_struct *__stop_machine_run(i
 
 #else
 
-static inline int stop_machine_run(int (*fn)(void *), void *data,
-				   unsigned int cpu)
+static inline int stop_machine_run_notype(int (*fn)(void *), void *data,
+					  unsigned int cpu)
 {
 	int ret;
 	local_irq_disable();
diff -r e279190b7b43 kernel/module.c
--- a/kernel/module.c	Mon Jan 21 14:42:54 2008 +1100
+++ b/kernel/module.c	Mon Jan 21 15:04:00 2008 +1100
@@ -623,10 +623,8 @@ struct stopref
 };
 
 /* Whole machine is stopped with interrupts off when this runs. */
-static int __try_stop_module(void *_sref)
+static int __try_stop_module(struct stopref *sref)
 {
-	struct stopref *sref = _sref;
-
 	/* If it's not unused, quit unless we are told to block. */
 	if ((sref->flags & O_NONBLOCK) && module_refcount(sref->mod) != 0) {
 		if (!(*sref->forced = try_force_unload(sref->flags)))
@@ -1305,9 +1303,8 @@ static void mod_kobject_remove(struct mo
  * link the module with the whole machine is stopped with interrupts off
  * - this defends against kallsyms not taking locks
  */
-static int __link_module(void *_mod)
+static int __link_module(struct module *mod)
 {
-	struct module *mod = _mod;
 	list_add(&mod->list, &modules);
 	return 0;
 }
@@ -1316,9 +1313,8 @@ static int __link_module(void *_mod)
  * unlink the module with the whole machine is stopped with interrupts off
  * - this defends against kallsyms not taking locks
  */
-static int __unlink_module(void *_mod)
+static int __unlink_module(struct module *mod)
 {
-	struct module *mod = _mod;
 	list_del(&mod->list);
 	return 0;
 }
diff -r e279190b7b43 kernel/stop_machine.c
--- a/kernel/stop_machine.c	Mon Jan 21 14:42:54 2008 +1100
+++ b/kernel/stop_machine.c	Mon Jan 21 15:04:00 2008 +1100
@@ -197,7 +197,7 @@ struct task_struct *__stop_machine_run(i
 	return p;
 }
 
-int stop_machine_run(int (*fn)(void *), void *data, unsigned int cpu)
+int stop_machine_run_notype(int (*fn)(void *), void *data, unsigned int cpu)
 {
 	struct task_struct *p;
 	int ret;
@@ -213,4 +213,89 @@ int stop_machine_run(int (*fn)(void *), 
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(stop_machine_run);
+EXPORT_SYMBOL_GPL(stop_machine_run_notype);
+
+#if 0 /* Compile test */
+int testfn_voidp(void *);
+int testfn_charp(char *);
+int testfn_char(char);
+int testfn_ulong(unsigned long);
+
+void test(void)
+{
+	char c;
+	unsigned long ul;
+	void *p;
+	struct { void *p; } s;
+
+	/*
+	 * Should work
+	 */
+	/* void * compatible with any pointer. */
+	stop_machine_run(testfn_voidp, NULL, 0);
+	stop_machine_run(testfn_voidp, p, 0);
+	stop_machine_run(testfn_voidp, &c, 0);
+	stop_machine_run(testfn_voidp, &ul, 0);
+
+	/* NULL callbacks compatible with any pointer. */
+	stop_machine_run(NULL, NULL, 0);
+	stop_machine_run(NULL, p, 0);
+	stop_machine_run(NULL, &c, 0);
+	stop_machine_run(NULL, &ul, 0);
+
+	/* Char * match. */
+	stop_machine_run(testfn_charp, &c, 0);
+
+	/* ulong can take any int or long. */
+	stop_machine_run(testfn_ulong, c, 0);
+	stop_machine_run(testfn_ulong, ul, 0);
+
+	/*
+	 * It would be nice if these worked, but they don't (void * arg).
+	 */
+	stop_machine_run(testfn_charp, NULL, 0);
+	stop_machine_run(testfn_charp, p, 0);
+	stop_machine_run(testfn_ulong, NULL, 0);
+	stop_machine_run(testfn_ulong, p, 0);
+
+	/*
+	 * Should complain.
+	 */
+
+	/* void * incompatible with non-pointers. */
+	stop_machine_run(testfn_voidp, c, 0);
+	stop_machine_run(testfn_voidp, ul, 0);
+	stop_machine_run(testfn_voidp, s, 0);
+
+	/* NULL callbacks incompatible with non-pointers. */
+	stop_machine_run(NULL, c, 0);
+	stop_machine_run(NULL, ul, 0);
+	stop_machine_run(NULL, s, 0);
+
+	/* char * function and unsigned long */
+	stop_machine_run(testfn_charp, &ul, 0);
+
+	/* char * incompatible with non-pointers */
+	stop_machine_run(testfn_charp, c, 0);
+	stop_machine_run(testfn_charp, ul, 0);
+	stop_machine_run(testfn_charp, s, 0);
+
+	/* A char function simply can't work as a callback. */
+	stop_machine_run(testfn_char, NULL, 0);
+	stop_machine_run(testfn_char, p, 0);
+	stop_machine_run(testfn_char, &c, 0);
+	stop_machine_run(testfn_char, &ul, 0);
+	stop_machine_run(testfn_char, c, 0);
+	stop_machine_run(testfn_char, ul, 0);
+	stop_machine_run(testfn_char, s, 0);
+
+	/* unsigned long function and char * */
+	stop_machine_run(testfn_ulong, &c, 0);
+
+	/* unsigned long function and unsigned long * */
+	stop_machine_run(testfn_ulong, &ul, 0);
+
+	/* unsigned long function and struct. */
+	stop_machine_run(testfn_ulong, s, 0);
+}
+#endif
