Return-Path: <linux-kernel-owner+w=401wt.eu-S1755595AbYDXV3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595AbYDXV3V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 17:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753277AbYDXV3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 17:29:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60299 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753350AbYDXV3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 17:29:01 -0400
Date: Thu, 24 Apr 2008 23:28:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] StackProtector enhancements and fixes
Message-ID: <20080424212845.GA28715@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
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


Linus, please pull the stackprotector git tree from:

 git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-stackprotector.git for-linus

StackProtector is an x86-only feature (for now), but the debug 
enhancements and the boot-canary-setting touch generic files as well so 
this is offered as a tree separate from x86.git.

The panic.c self-test bits are a bit ugly IMO, but that's the best we 
could think of to simulate a real stack-overflow.

Thanks,

	Ingo

------------------>
Arjan van de Ven (3):
      x86: setup stack canary for the idle threads
      x86: add CONFIG_CC_STACKPROTECTOR self-test
      stackprotector: turn not having the right gcc into a #warning

Daniel Walker (1):
      panic.c: fix whitespace additions

Ingo Molnar (11):
      x86: stackprotector & PARAVIRT fix
      x86: fix stackprotector canary updates during context switches
      x86: fix canary of the boot CPU's idle task
      panic: print more informative messages on stackprotect failure
      panic: print out stacktrace if DEBUG_BUGVERBOSE
      x86: if stackprotector is enabled, thn use stack-protector-all by default
      stackprotector: include files
      stackprotector: add boot_init_stack_canary()
      x86: fix the stackprotector canary of the boot CPU
      x86: stackprotector: mix TSC to the boot canary
      x86: unify stackprotector features

 arch/x86/Kconfig                 |   23 +++++------
 arch/x86/Kconfig.debug           |    1 +
 arch/x86/Makefile                |    2 +-
 arch/x86/kernel/Makefile         |    1 +
 arch/x86/kernel/process_64.c     |   13 ++++++-
 include/asm-x86/pda.h            |    2 -
 include/asm-x86/stackprotector.h |   38 +++++++++++++++++++
 include/asm-x86/system.h         |    6 ++-
 include/linux/sched.h            |    3 +-
 include/linux/stackprotector.h   |   16 ++++++++
 init/main.c                      |    7 +++
 kernel/panic.c                   |   77 +++++++++++++++++++++++++++++++++++++-
 12 files changed, 168 insertions(+), 21 deletions(-)
 create mode 100644 include/asm-x86/stackprotector.h
 create mode 100644 include/linux/stackprotector.h

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 87a693c..0d7ba51 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1103,13 +1103,17 @@ config SECCOMP
 
 	  If unsure, say Y. Only embedded should say N here.
 
+config CC_STACKPROTECTOR_ALL
+	bool
+
 config CC_STACKPROTECTOR
 	bool "Enable -fstack-protector buffer overflow detection (EXPERIMENTAL)"
-	depends on X86_64 && EXPERIMENTAL && BROKEN
+	depends on X86_64
+	select CC_STACKPROTECTOR_ALL
 	help
-         This option turns on the -fstack-protector GCC feature. This
-	  feature puts, at the beginning of critical functions, a canary
-	  value on the stack just before the return address, and validates
+          This option turns on the -fstack-protector GCC feature. This
+	  feature puts, at the beginning of functions, a canary value on
+	  the stack just before the return address, and validates
 	  the value just before actually returning.  Stack based buffer
 	  overflows (that need to overwrite this return address) now also
 	  overwrite the canary, which gets detected and the attack is then
@@ -1117,15 +1121,8 @@ config CC_STACKPROTECTOR
 
 	  This feature requires gcc version 4.2 or above, or a distribution
 	  gcc with the feature backported. Older versions are automatically
-	  detected and for those versions, this configuration option is ignored.
-
-config CC_STACKPROTECTOR_ALL
-	bool "Use stack-protector for all functions"
-	depends on CC_STACKPROTECTOR
-	help
-	  Normally, GCC only inserts the canary value protection for
-	  functions that use large-ish on-stack buffers. By enabling
-	  this option, GCC will be asked to do this for ALL functions.
+	  detected and for those versions, this configuration option is
+	  ignored. (and a warning is printed during bootup)
 
 source kernel/Kconfig.hz
 
diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 610aaec..12bc004 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -91,6 +91,7 @@ config DIRECT_GBPAGES
 config DEBUG_RODATA_TEST
 	bool "Testcase for the DEBUG_RODATA feature"
 	depends on DEBUG_RODATA
+	default y
 	help
 	  This option enables a testcase for the DEBUG_RODATA
 	  feature as well as for the change_page_attr() infrastructure.
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 3cff3c8..c3e0eee 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -73,7 +73,7 @@ else
 
         stackp := $(CONFIG_SHELL) $(srctree)/scripts/gcc-x86_64-has-stack-protector.sh
         stackp-$(CONFIG_CC_STACKPROTECTOR) := $(shell $(stackp) \
-                "$(CC)" -fstack-protector )
+                "$(CC)" "-fstack-protector -DGCC_HAS_SP" )
         stackp-$(CONFIG_CC_STACKPROTECTOR_ALL) += $(shell $(stackp) \
                 "$(CC)" -fstack-protector-all )
 
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 90e092d..c9df407 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -14,6 +14,7 @@ nostackp := $(call cc-option, -fno-stack-protector)
 CFLAGS_vsyscall_64.o	:= $(PROFILING) -g0 $(nostackp)
 CFLAGS_hpet.o		:= $(nostackp)
 CFLAGS_tsc_64.o		:= $(nostackp)
+CFLAGS_paravirt.o	:= $(nostackp)
 
 obj-y			:= process_$(BITS).o signal_$(BITS).o entry_$(BITS).o
 obj-y			+= traps_$(BITS).o irq_$(BITS).o
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 891af1a..730d0bd 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -16,6 +16,7 @@
 
 #include <stdarg.h>
 
+#include <linux/stackprotector.h>
 #include <linux/cpu.h>
 #include <linux/errno.h>
 #include <linux/sched.h>
@@ -159,6 +160,17 @@ static inline void play_dead(void)
 void cpu_idle(void)
 {
 	current_thread_info()->status |= TS_POLLING;
+
+	/*
+	 * If we're the non-boot CPU, nothing set the PDA stack
+	 * canary up for us - and if we are the boot CPU we have
+	 * a 0 stack canary. This is a good place for updating
+	 * it, as we wont ever return from this function (so the
+	 * invalid canaries already on the stack wont ever
+	 * trigger):
+	 */
+	boot_init_stack_canary();
+
 	/* endless idle loop with no priority at all */
 	while (1) {
 		tick_nohz_stop_sched_tick();
@@ -757,7 +769,6 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	write_pda(kernelstack,
 	(unsigned long)task_stack_page(next_p) + THREAD_SIZE - PDA_STACKOFFSET);
 #ifdef CONFIG_CC_STACKPROTECTOR
-	write_pda(stack_canary, next_p->stack_canary);
 	/*
 	 * Build time only check to make sure the stack_canary is at
 	 * offset 40 in the pda; this is a gcc ABI requirement
diff --git a/include/asm-x86/pda.h b/include/asm-x86/pda.h
index 101fb9e..62b7349 100644
--- a/include/asm-x86/pda.h
+++ b/include/asm-x86/pda.h
@@ -16,11 +16,9 @@ struct x8664_pda {
 	unsigned long oldrsp;		/* 24 user rsp for system call */
 	int irqcount;			/* 32 Irq nesting counter. Starts -1 */
 	unsigned int cpunumber;		/* 36 Logical CPU number */
-#ifdef CONFIG_CC_STACKPROTECTOR
 	unsigned long stack_canary;	/* 40 stack canary value */
 					/* gcc-ABI: this canary MUST be at
 					   offset 40!!! */
-#endif
 	char *irqstackptr;
 	unsigned int __softirq_pending;
 	unsigned int __nmi_count;	/* number of NMI on this CPUs */
diff --git a/include/asm-x86/stackprotector.h b/include/asm-x86/stackprotector.h
new file mode 100644
index 0000000..3baf7ad
--- /dev/null
+++ b/include/asm-x86/stackprotector.h
@@ -0,0 +1,38 @@
+#ifndef _ASM_STACKPROTECTOR_H
+#define _ASM_STACKPROTECTOR_H 1
+
+#include <asm/tsc.h>
+
+/*
+ * Initialize the stackprotector canary value.
+ *
+ * NOTE: this must only be called from functions that never return,
+ * and it must always be inlined.
+ */
+static __always_inline void boot_init_stack_canary(void)
+{
+	u64 canary;
+	u64 tsc;
+
+	/*
+	 * If we're the non-boot CPU, nothing set the PDA stack
+	 * canary up for us - and if we are the boot CPU we have
+	 * a 0 stack canary. This is a good place for updating
+	 * it, as we wont ever return from this function (so the
+	 * invalid canaries already on the stack wont ever
+	 * trigger).
+	 *
+	 * We both use the random pool and the current TSC as a source
+	 * of randomness. The TSC only matters for very early init,
+	 * there it already has some randomness on most systems. Later
+	 * on during the bootup the random pool has true entropy too.
+	 */
+	get_random_bytes(&canary, sizeof(canary));
+	tsc = __native_read_tsc();
+	canary += tsc + (tsc << 32UL);
+
+	current->stack_canary = canary;
+	write_pda(stack_canary, canary);
+}
+
+#endif
diff --git a/include/asm-x86/system.h b/include/asm-x86/system.h
index a2f04cd..172f541 100644
--- a/include/asm-x86/system.h
+++ b/include/asm-x86/system.h
@@ -92,6 +92,8 @@ do {									\
 	     ".globl thread_return\n"					  \
 	     "thread_return:\n\t"					  \
 	     "movq %%gs:%P[pda_pcurrent],%%rsi\n\t"			  \
+	     "movq %P[task_canary](%%rsi),%%r8\n\t"			  \
+	     "movq %%r8,%%gs:%P[pda_canary]\n\t"			  \
 	     "movq %P[thread_info](%%rsi),%%r8\n\t"			  \
 	     LOCK_PREFIX "btr  %[tif_fork],%P[ti_flags](%%r8)\n\t"	  \
 	     "movq %%rax,%%rdi\n\t" 					  \
@@ -103,7 +105,9 @@ do {									\
 	       [ti_flags] "i" (offsetof(struct thread_info, flags)),	  \
 	       [tif_fork] "i" (TIF_FORK),			  	  \
 	       [thread_info] "i" (offsetof(struct task_struct, stack)),   \
-	       [pda_pcurrent] "i" (offsetof(struct x8664_pda, pcurrent))  \
+	       [task_canary] "i" (offsetof(struct task_struct, stack_canary)),\
+	       [pda_pcurrent] "i" (offsetof(struct x8664_pda, pcurrent)), \
+	       [pda_canary] "i" (offsetof(struct x8664_pda, stack_canary))\
 	     : "memory", "cc" __EXTRA_CLOBBER)
 #endif
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 311380e..9e78e54 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1087,10 +1087,9 @@ struct task_struct {
 	pid_t pid;
 	pid_t tgid;
 
-#ifdef CONFIG_CC_STACKPROTECTOR
 	/* Canary value for the -fstack-protector gcc feature */
 	unsigned long stack_canary;
-#endif
+
 	/* 
 	 * pointers to (original) parent process, youngest child, younger sibling,
 	 * older sibling, respectively.  (p->father can be replaced with 
diff --git a/include/linux/stackprotector.h b/include/linux/stackprotector.h
new file mode 100644
index 0000000..6f3e54c
--- /dev/null
+++ b/include/linux/stackprotector.h
@@ -0,0 +1,16 @@
+#ifndef _LINUX_STACKPROTECTOR_H
+#define _LINUX_STACKPROTECTOR_H 1
+
+#include <linux/compiler.h>
+#include <linux/sched.h>
+#include <linux/random.h>
+
+#ifdef CONFIG_CC_STACKPROTECTOR
+# include <asm/stackprotector.h>
+#else
+static inline void boot_init_stack_canary(void)
+{
+}
+#endif
+
+#endif
diff --git a/init/main.c b/init/main.c
index 833a67d..24ec433 100644
--- a/init/main.c
+++ b/init/main.c
@@ -14,6 +14,7 @@
 #include <linux/proc_fs.h>
 #include <linux/kernel.h>
 #include <linux/syscalls.h>
+#include <linux/stackprotector.h>
 #include <linux/string.h>
 #include <linux/ctype.h>
 #include <linux/delay.h>
@@ -538,6 +539,12 @@ asmlinkage void __init start_kernel(void)
 	 */
 	unwind_init();
 	lockdep_init();
+
+	/*
+	 * Set up the the initial canary ASAP:
+	 */
+	boot_init_stack_canary();
+
 	cgroup_init_early();
 
 	local_irq_disable();
diff --git a/kernel/panic.c b/kernel/panic.c
index 24af9f8..2358cfa 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -80,6 +80,9 @@ NORET_TYPE void panic(const char * fmt, ...)
 	vsnprintf(buf, sizeof(buf), fmt, args);
 	va_end(args);
 	printk(KERN_EMERG "Kernel panic - not syncing: %s\n",buf);
+#ifdef CONFIG_DEBUG_BUGVERBOSE
+	dump_stack();
+#endif
 	bust_spinlocks(0);
 
 	/*
@@ -317,13 +320,85 @@ EXPORT_SYMBOL(warn_on_slowpath);
 #endif
 
 #ifdef CONFIG_CC_STACKPROTECTOR
+
+#ifndef GCC_HAS_SP
+#warning You have selected the CONFIG_CC_STACKPROTECTOR option, but the gcc used does not support this.
+#endif
+static unsigned long __stack_check_testing;
+/*
+ * Self test function for the stack-protector feature.
+ * This test requires that the local variable absolutely has
+ * a stack slot, hence the barrier()s.
+ */
+static noinline void __stack_chk_test_func(void)
+{
+	unsigned long foo;
+	barrier();
+	/*
+	 * we need to make sure we're not about to clobber the return address,
+	 * while real exploits do this, it's unhealthy on a running system.
+	 * Besides, if we would, the test is already failed anyway so
+	 * time to pull the emergency brake on it.
+	 */
+	if ((unsigned long)__builtin_return_address(0) ==
+					*(((unsigned long *)&foo)+1)) {
+		printk(KERN_ERR "No -fstack-protector-stack-frame!\n");
+		return;
+	}
+#ifdef CONFIG_FRAME_POINTER
+	/* We also don't want to clobber the frame pointer */
+	if ((unsigned long)__builtin_return_address(0) ==
+					*(((unsigned long *)&foo)+2)) {
+		printk(KERN_ERR "No -fstack-protector-stack-frame!\n");
+		return;
+	}
+#endif
+	barrier();
+	if (current->stack_canary == *(((unsigned long *)&foo)+1))
+		*(((unsigned long *)&foo)+1) = 0;
+	else
+		printk(KERN_ERR "No -fstack-protector canary found\n");
+	barrier();
+}
+
+static int __stack_chk_test(void)
+{
+	printk(KERN_INFO "Testing -fstack-protector-all feature\n");
+	__stack_check_testing = (unsigned long)&__stack_chk_test_func;
+	__stack_chk_test_func();
+	if (__stack_check_testing) {
+		printk(KERN_ERR "-fstack-protector-all test failed\n");
+		WARN_ON(1);
+	}
+	return 0;
+}
 /*
  * Called when gcc's -fstack-protector feature is used, and
  * gcc detects corruption of the on-stack canary value
  */
 void __stack_chk_fail(void)
 {
-	panic("stack-protector: Kernel stack is corrupted");
+	if (__stack_check_testing == (unsigned long)&__stack_chk_test_func) {
+		long delta;
+
+		delta = (unsigned long)__builtin_return_address(0) -
+				__stack_check_testing;
+		/*
+		 * The test needs to happen inside the test function, so
+		 * check if the return address is close to that function.
+		 * The function is only 2 dozen bytes long, but keep a wide
+		 * safety margin to avoid panic()s for normal users regardless
+		 * of the quality of the compiler.
+		 */
+		if (delta >= 0 && delta <= 400) {
+			__stack_check_testing = 0;
+			return;
+		}
+	}
+	panic("stack-protector: Kernel stack is corrupted in: %p\n",
+		__builtin_return_address(0));
 }
 EXPORT_SYMBOL(__stack_chk_fail);
+
+late_initcall(__stack_chk_test);
 #endif
