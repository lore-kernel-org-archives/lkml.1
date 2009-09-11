Return-Path: <linux-kernel-owner+w=401wt.eu-S1756097AbZIKTzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097AbZIKTzi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 15:55:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755968AbZIKTzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 15:55:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41133 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752160AbZIKTzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 15:55:36 -0400
Date: Fri, 11 Sep 2009 21:55:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>
Subject: [GIT PULL] x86/percpu for v2.6.32
Message-ID: <20090911195525.GA32523@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-percpu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-percpu-for-linus


out-of-topic modifications in x86-percpu-for-linus:
---------------------------------------------------
include/linux/percpu-defs.h        # 3e352aa: x86, percpu: Fix DECLARE/DEFINE_P

 Thanks,

	Ingo

------------------>
Linus Torvalds (1):
      x86, percpu: Add 'percpu_read_stable()' interface for cacheable accesses

Tejun Heo (2):
      x86, percpu: Fix DECLARE/DEFINE_PER_CPU_PAGE_ALIGNED()
      x86, percpu: Collect hot percpu variables into one cacheline


 arch/x86/include/asm/current.h     |    2 +-
 arch/x86/include/asm/percpu.h      |   26 +++++++++++++++++++-------
 arch/x86/include/asm/thread_info.h |    2 +-
 arch/x86/kernel/cpu/common.c       |   18 ++++++++++++++----
 arch/x86/kernel/process_32.c       |    3 ---
 arch/x86/kernel/process_64.c       |    3 ---
 include/linux/percpu-defs.h        |    8 +++++---
 7 files changed, 40 insertions(+), 22 deletions(-)

diff --git a/arch/x86/include/asm/current.h b/arch/x86/include/asm/current.h
index c68c361..4d447b7 100644
--- a/arch/x86/include/asm/current.h
+++ b/arch/x86/include/asm/current.h
@@ -11,7 +11,7 @@ DECLARE_PER_CPU(struct task_struct *, current_task);
 
 static __always_inline struct task_struct *get_current(void)
 {
-	return percpu_read(current_task);
+	return percpu_read_stable(current_task);
 }
 
 #define current get_current()
diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index 103f1dd..04eacef 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -49,7 +49,7 @@
 #define __percpu_arg(x)		"%%"__stringify(__percpu_seg)":%P" #x
 #define __my_cpu_offset		percpu_read(this_cpu_off)
 #else
-#define __percpu_arg(x)		"%" #x
+#define __percpu_arg(x)		"%P" #x
 #endif
 
 /*
@@ -104,36 +104,48 @@ do {							\
 	}						\
 } while (0)
 
-#define percpu_from_op(op, var)				\
+#define percpu_from_op(op, var, constraint)		\
 ({							\
 	typeof(var) ret__;				\
 	switch (sizeof(var)) {				\
 	case 1:						\
 		asm(op "b "__percpu_arg(1)",%0"		\
 		    : "=q" (ret__)			\
-		    : "m" (var));			\
+		    : constraint);			\
 		break;					\
 	case 2:						\
 		asm(op "w "__percpu_arg(1)",%0"		\
 		    : "=r" (ret__)			\
-		    : "m" (var));			\
+		    : constraint);			\
 		break;					\
 	case 4:						\
 		asm(op "l "__percpu_arg(1)",%0"		\
 		    : "=r" (ret__)			\
-		    : "m" (var));			\
+		    : constraint);			\
 		break;					\
 	case 8:						\
 		asm(op "q "__percpu_arg(1)",%0"		\
 		    : "=r" (ret__)			\
-		    : "m" (var));			\
+		    : constraint);			\
 		break;					\
 	default: __bad_percpu_size();			\
 	}						\
 	ret__;						\
 })
 
-#define percpu_read(var)	percpu_from_op("mov", per_cpu__##var)
+/*
+ * percpu_read() makes gcc load the percpu variable every time it is
+ * accessed while percpu_read_stable() allows the value to be cached.
+ * percpu_read_stable() is more efficient and can be used if its value
+ * is guaranteed to be valid across cpus.  The current users include
+ * get_current() and get_thread_info() both of which are actually
+ * per-thread variables implemented as per-cpu variables and thus
+ * stable for the duration of the respective task.
+ */
+#define percpu_read(var)	percpu_from_op("mov", per_cpu__##var,	\
+					       "m" (per_cpu__##var))
+#define percpu_read_stable(var)	percpu_from_op("mov", per_cpu__##var,	\
+					       "p" (&per_cpu__##var))
 #define percpu_write(var, val)	percpu_to_op("mov", per_cpu__##var, val)
 #define percpu_add(var, val)	percpu_to_op("add", per_cpu__##var, val)
 #define percpu_sub(var, val)	percpu_to_op("sub", per_cpu__##var, val)
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index fad7d40..a1bb5a1 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -213,7 +213,7 @@ DECLARE_PER_CPU(unsigned long, kernel_stack);
 static inline struct thread_info *current_thread_info(void)
 {
 	struct thread_info *ti;
-	ti = (void *)(percpu_read(kernel_stack) +
+	ti = (void *)(percpu_read_stable(kernel_stack) +
 		      KERNEL_STACK_OFFSET - THREAD_SIZE);
 	return ti;
 }
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index f1961c0..1bd88ed 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -987,13 +987,21 @@ struct desc_ptr idt_descr = { 256 * 16 - 1, (unsigned long) idt_table };
 DEFINE_PER_CPU_FIRST(union irq_stack_union,
 		     irq_stack_union) __aligned(PAGE_SIZE);
 
-DEFINE_PER_CPU(char *, irq_stack_ptr) =
-	init_per_cpu_var(irq_stack_union.irq_stack) + IRQ_STACK_SIZE - 64;
+/*
+ * The following four percpu variables are hot.  Align current_task to
+ * cacheline size such that all four fall in the same cacheline.
+ */
+DEFINE_PER_CPU(struct task_struct *, current_task) ____cacheline_aligned =
+	&init_task;
+EXPORT_PER_CPU_SYMBOL(current_task);
 
 DEFINE_PER_CPU(unsigned long, kernel_stack) =
 	(unsigned long)&init_thread_union - KERNEL_STACK_OFFSET + THREAD_SIZE;
 EXPORT_PER_CPU_SYMBOL(kernel_stack);
 
+DEFINE_PER_CPU(char *, irq_stack_ptr) =
+	init_per_cpu_var(irq_stack_union.irq_stack) + IRQ_STACK_SIZE - 64;
+
 DEFINE_PER_CPU(unsigned int, irq_count) = -1;
 
 /*
@@ -1008,8 +1016,7 @@ static const unsigned int exception_stack_sizes[N_EXCEPTION_STACKS] = {
 };
 
 static DEFINE_PER_CPU_PAGE_ALIGNED(char, exception_stacks
-	[(N_EXCEPTION_STACKS - 1) * EXCEPTION_STKSZ + DEBUG_STKSZ])
-	__aligned(PAGE_SIZE);
+	[(N_EXCEPTION_STACKS - 1) * EXCEPTION_STKSZ + DEBUG_STKSZ]);
 
 /* May not be marked __init: used by software suspend */
 void syscall_init(void)
@@ -1042,6 +1049,9 @@ DEFINE_PER_CPU(struct orig_ist, orig_ist);
 
 #else	/* CONFIG_X86_64 */
 
+DEFINE_PER_CPU(struct task_struct *, current_task) = &init_task;
+EXPORT_PER_CPU_SYMBOL(current_task);
+
 #ifdef CONFIG_CC_STACKPROTECTOR
 DEFINE_PER_CPU(unsigned long, stack_canary);
 #endif
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 59f4524..daa4107 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -61,9 +61,6 @@
 
 asmlinkage void ret_from_fork(void) __asm__("ret_from_fork");
 
-DEFINE_PER_CPU(struct task_struct *, current_task) = &init_task;
-EXPORT_PER_CPU_SYMBOL(current_task);
-
 /*
  * Return saved PC of a blocked thread.
  */
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index ebefb54..c4c675d 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -55,9 +55,6 @@
 
 asmlinkage extern void ret_from_fork(void);
 
-DEFINE_PER_CPU(struct task_struct *, current_task) = &init_task;
-EXPORT_PER_CPU_SYMBOL(current_task);
-
 DEFINE_PER_CPU(unsigned long, old_rsp);
 static DEFINE_PER_CPU(unsigned char, is_idle);
 
diff --git a/include/linux/percpu-defs.h b/include/linux/percpu-defs.h
index 68438e1..afd5f8b 100644
--- a/include/linux/percpu-defs.h
+++ b/include/linux/percpu-defs.h
@@ -69,11 +69,13 @@
 /*
  * Declaration/definition used for per-CPU variables that must be page aligned.
  */
-#define DECLARE_PER_CPU_PAGE_ALIGNED(type, name)				\
-	DECLARE_PER_CPU_SECTION(type, name, ".page_aligned")
+#define DECLARE_PER_CPU_PAGE_ALIGNED(type, name)			\
+	DECLARE_PER_CPU_SECTION(type, name, ".page_aligned")		\
+	__aligned(PAGE_SIZE)
 
 #define DEFINE_PER_CPU_PAGE_ALIGNED(type, name)				\
-	DEFINE_PER_CPU_SECTION(type, name, ".page_aligned")
+	DEFINE_PER_CPU_SECTION(type, name, ".page_aligned")		\
+	__aligned(PAGE_SIZE)
 
 /*
  * Intermodule exports for per-CPU variables.
