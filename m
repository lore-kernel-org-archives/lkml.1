Return-Path: <linux-kernel-owner+w=401wt.eu-S1752429AbZDMR3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429AbZDMR3A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 13:29:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751579AbZDMR2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 13:28:51 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40422 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496AbZDMR2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 13:28:50 -0400
Date: Mon, 13 Apr 2009 19:28:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [GIT PULL] core fixes
Message-ID: <20090413172835.GA28573@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus

The two lockdep fixes are not regression fixes but fixes for two 
recently discovered problems that artificially narrowed lockdep 
coverage for a class of drivers and a class of bootups 
(-with-warnings).

 Thanks,

	Ingo

------------------>
Frederic Weisbecker (2):
      lockdep: warn about lockdep disabling after kernel taint
      lockdep: continue lock debugging despite some taints

Heiko Carstens (1):
      mutex: have non-spinning mutexes on s390 by default

Tejun Heo (1):
      percpu: unbreak alpha percpu


 arch/Kconfig                 |    3 ++
 arch/s390/Kconfig            |    1 +
 include/asm-generic/percpu.h |   52 ------------------------------------------
 include/linux/debug_locks.h  |    7 +++++
 include/linux/percpu.h       |   52 ++++++++++++++++++++++++++++++++++++++++++
 kernel/mutex.c               |    3 +-
 kernel/panic.c               |   12 ++++++++-
 lib/debug_locks.c            |    2 +-
 8 files changed, 76 insertions(+), 56 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index dc81b34..78a35e9 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -109,3 +109,6 @@ config HAVE_CLK
 
 config HAVE_DMA_API_DEBUG
 	bool
+
+config HAVE_DEFAULT_NO_SPIN_MUTEXES
+	bool
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index dcb667c..2eca5fe 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -82,6 +82,7 @@ config S390
 	select USE_GENERIC_SMP_HELPERS if SMP
 	select HAVE_SYSCALL_WRAPPERS
 	select HAVE_FUNCTION_TRACER
+	select HAVE_DEFAULT_NO_SPIN_MUTEXES
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
diff --git a/include/asm-generic/percpu.h b/include/asm-generic/percpu.h
index 00f45ff..b0e63c6 100644
--- a/include/asm-generic/percpu.h
+++ b/include/asm-generic/percpu.h
@@ -80,56 +80,4 @@ extern void setup_per_cpu_areas(void);
 #define DECLARE_PER_CPU(type, name) extern PER_CPU_ATTRIBUTES \
 					__typeof__(type) per_cpu_var(name)
 
-/*
- * Optional methods for optimized non-lvalue per-cpu variable access.
- *
- * @var can be a percpu variable or a field of it and its size should
- * equal char, int or long.  percpu_read() evaluates to a lvalue and
- * all others to void.
- *
- * These operations are guaranteed to be atomic w.r.t. preemption.
- * The generic versions use plain get/put_cpu_var().  Archs are
- * encouraged to implement single-instruction alternatives which don't
- * require preemption protection.
- */
-#ifndef percpu_read
-# define percpu_read(var)						\
-  ({									\
-	typeof(per_cpu_var(var)) __tmp_var__;				\
-	__tmp_var__ = get_cpu_var(var);					\
-	put_cpu_var(var);						\
-	__tmp_var__;							\
-  })
-#endif
-
-#define __percpu_generic_to_op(var, val, op)				\
-do {									\
-	get_cpu_var(var) op val;					\
-	put_cpu_var(var);						\
-} while (0)
-
-#ifndef percpu_write
-# define percpu_write(var, val)		__percpu_generic_to_op(var, (val), =)
-#endif
-
-#ifndef percpu_add
-# define percpu_add(var, val)		__percpu_generic_to_op(var, (val), +=)
-#endif
-
-#ifndef percpu_sub
-# define percpu_sub(var, val)		__percpu_generic_to_op(var, (val), -=)
-#endif
-
-#ifndef percpu_and
-# define percpu_and(var, val)		__percpu_generic_to_op(var, (val), &=)
-#endif
-
-#ifndef percpu_or
-# define percpu_or(var, val)		__percpu_generic_to_op(var, (val), |=)
-#endif
-
-#ifndef percpu_xor
-# define percpu_xor(var, val)		__percpu_generic_to_op(var, (val), ^=)
-#endif
-
 #endif /* _ASM_GENERIC_PERCPU_H_ */
diff --git a/include/linux/debug_locks.h b/include/linux/debug_locks.h
index 096476f..493dedb 100644
--- a/include/linux/debug_locks.h
+++ b/include/linux/debug_locks.h
@@ -2,12 +2,19 @@
 #define __LINUX_DEBUG_LOCKING_H
 
 #include <linux/kernel.h>
+#include <asm/atomic.h>
 
 struct task_struct;
 
 extern int debug_locks;
 extern int debug_locks_silent;
 
+
+static inline int __debug_locks_off(void)
+{
+	return xchg(&debug_locks, 0);
+}
+
 /*
  * Generic 'turn off all lock debugging' function:
  */
diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index ee5615d..cfda2d5 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -168,4 +168,56 @@ static inline void free_percpu(void *p)
 #define alloc_percpu(type)	(type *)__alloc_percpu(sizeof(type), \
 						       __alignof__(type))
 
+/*
+ * Optional methods for optimized non-lvalue per-cpu variable access.
+ *
+ * @var can be a percpu variable or a field of it and its size should
+ * equal char, int or long.  percpu_read() evaluates to a lvalue and
+ * all others to void.
+ *
+ * These operations are guaranteed to be atomic w.r.t. preemption.
+ * The generic versions use plain get/put_cpu_var().  Archs are
+ * encouraged to implement single-instruction alternatives which don't
+ * require preemption protection.
+ */
+#ifndef percpu_read
+# define percpu_read(var)						\
+  ({									\
+	typeof(per_cpu_var(var)) __tmp_var__;				\
+	__tmp_var__ = get_cpu_var(var);					\
+	put_cpu_var(var);						\
+	__tmp_var__;							\
+  })
+#endif
+
+#define __percpu_generic_to_op(var, val, op)				\
+do {									\
+	get_cpu_var(var) op val;					\
+	put_cpu_var(var);						\
+} while (0)
+
+#ifndef percpu_write
+# define percpu_write(var, val)		__percpu_generic_to_op(var, (val), =)
+#endif
+
+#ifndef percpu_add
+# define percpu_add(var, val)		__percpu_generic_to_op(var, (val), +=)
+#endif
+
+#ifndef percpu_sub
+# define percpu_sub(var, val)		__percpu_generic_to_op(var, (val), -=)
+#endif
+
+#ifndef percpu_and
+# define percpu_and(var, val)		__percpu_generic_to_op(var, (val), &=)
+#endif
+
+#ifndef percpu_or
+# define percpu_or(var, val)		__percpu_generic_to_op(var, (val), |=)
+#endif
+
+#ifndef percpu_xor
+# define percpu_xor(var, val)		__percpu_generic_to_op(var, (val), ^=)
+#endif
+
 #endif /* __LINUX_PERCPU_H */
diff --git a/kernel/mutex.c b/kernel/mutex.c
index 5d79781..507cf2b 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -148,7 +148,8 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 
 	preempt_disable();
 	mutex_acquire(&lock->dep_map, subclass, 0, ip);
-#if defined(CONFIG_SMP) && !defined(CONFIG_DEBUG_MUTEXES)
+#if defined(CONFIG_SMP) && !defined(CONFIG_DEBUG_MUTEXES) && \
+    !defined(CONFIG_HAVE_DEFAULT_NO_SPIN_MUTEXES)
 	/*
 	 * Optimistic spinning.
 	 *
diff --git a/kernel/panic.c b/kernel/panic.c
index 3fd8c5b..934fb37 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -213,8 +213,16 @@ unsigned long get_taint(void)
 
 void add_taint(unsigned flag)
 {
-	/* can't trust the integrity of the kernel anymore: */
-	debug_locks = 0;
+	/*
+	 * Can't trust the integrity of the kernel anymore.
+	 * We don't call directly debug_locks_off() because the issue
+	 * is not necessarily serious enough to set oops_in_progress to 1
+	 * Also we want to keep up lockdep for staging development and
+	 * post-warning case.
+	 */
+	if (flag != TAINT_CRAP && flag != TAINT_WARN && __debug_locks_off())
+		printk(KERN_WARNING "Disabling lockdep due to kernel taint\n");
+
 	set_bit(flag, &tainted_mask);
 }
 EXPORT_SYMBOL(add_taint);
diff --git a/lib/debug_locks.c b/lib/debug_locks.c
index 0218b46..bc3b117 100644
--- a/lib/debug_locks.c
+++ b/lib/debug_locks.c
@@ -36,7 +36,7 @@ int debug_locks_silent;
  */
 int debug_locks_off(void)
 {
-	if (xchg(&debug_locks, 0)) {
+	if (__debug_locks_off()) {
 		if (!debug_locks_silent) {
 			oops_in_progress = 1;
 			console_verbose();
