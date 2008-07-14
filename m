Return-Path: <linux-kernel-owner+w=401wt.eu-S1755981AbYGNO4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981AbYGNO4v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 10:56:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753975AbYGNO4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 10:56:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56085 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753952AbYGNO4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 10:56:41 -0400
Date: Mon, 14 Jul 2008 16:56:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] stackprotector updates for v2.6.27
Message-ID: <20080714145625.GA23501@elte.hu>
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

Please pull the latest stackprotector-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git stackprotector-for-linus

[ NOTE: please pull this tree only after having pulled x86/for-linus, it 
  is merged ontop of that tree. The shortlog is relative to x86/for-linus. ]

Thanks,

	Ingo

------------------>
Arjan van de Ven (5):
      x86: setup stack canary for the idle threads
      x86: add CONFIG_CC_STACKPROTECTOR self-test
      stackprotector: turn not having the right gcc into a #warning
      stackprotector: better self-test
      x86: simplify stackprotector self-check

Daniel Walker (1):
      panic.c: fix whitespace additions

Eric Sandeen (1):
      stackprotector: use canary at end of stack to indicate overruns at oops time

Ingo Molnar (12):
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
      stackprotector: remove self-test


 arch/x86/Kconfig                 |   23 ++++++++++-------------
 arch/x86/Kconfig.debug           |    1 +
 arch/x86/Makefile                |    2 +-
 arch/x86/kernel/Makefile         |    1 +
 arch/x86/kernel/process_64.c     |   13 ++++++++++++-
 arch/x86/mm/fault.c              |    7 +++++++
 include/asm-x86/pda.h            |    3 +--
 include/asm-x86/stackprotector.h |   38 ++++++++++++++++++++++++++++++++++++++
 include/asm-x86/system.h         |    6 +++++-
 include/linux/magic.h            |    1 +
 include/linux/sched.h            |   16 ++++++++++++++--
 include/linux/stackprotector.h   |   16 ++++++++++++++++
 init/main.c                      |    7 +++++++
 kernel/exit.c                    |    5 +----
 kernel/fork.c                    |    5 +++++
 kernel/panic.c                   |   12 +++++++++++-
 kernel/sched.c                   |    7 +------
 17 files changed, 132 insertions(+), 31 deletions(-)
 create mode 100644 include/asm-x86/stackprotector.h
 create mode 100644 include/linux/stackprotector.h

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 2cfccc9..0f79d73 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1221,13 +1221,17 @@ config SECCOMP
 
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
@@ -1235,15 +1239,8 @@ config CC_STACKPROTECTOR
 
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
index acc0271..b98e995 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -114,6 +114,7 @@ config DIRECT_GBPAGES
 config DEBUG_RODATA_TEST
 	bool "Testcase for the DEBUG_RODATA feature"
 	depends on DEBUG_RODATA
+	default y
 	help
 	  This option enables a testcase for the DEBUG_RODATA
 	  feature as well as for the change_page_attr() infrastructure.
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 919ce21..fc4c43d 100644
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
index 55ff016..940e670 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -14,6 +14,7 @@ nostackp := $(call cc-option, -fno-stack-protector)
 CFLAGS_vsyscall_64.o	:= $(PROFILING) -g0 $(nostackp)
 CFLAGS_hpet.o		:= $(nostackp)
 CFLAGS_tsc.o		:= $(nostackp)
+CFLAGS_paravirt.o	:= $(nostackp)
 
 obj-y			:= process_$(BITS).o signal_$(BITS).o entry_$(BITS).o
 obj-y			+= traps_$(BITS).o irq_$(BITS).o
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index db5eb96..fed70e7 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -16,6 +16,7 @@
 
 #include <stdarg.h>
 
+#include <linux/stackprotector.h>
 #include <linux/cpu.h>
 #include <linux/errno.h>
 #include <linux/sched.h>
@@ -118,6 +119,17 @@ static inline void play_dead(void)
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
@@ -626,7 +638,6 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	write_pda(kernelstack,
 	(unsigned long)task_stack_page(next_p) + THREAD_SIZE - PDA_STACKOFFSET);
 #ifdef CONFIG_CC_STACKPROTECTOR
-	write_pda(stack_canary, next_p->stack_canary);
 	/*
 	 * Build time only check to make sure the stack_canary is at
 	 * offset 40 in the pda; this is a gcc ABI requirement
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index d0f5fce..7ab608d 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -25,6 +25,7 @@
 #include <linux/kprobes.h>
 #include <linux/uaccess.h>
 #include <linux/kdebug.h>
+#include <linux/magic.h>
 
 #include <asm/system.h>
 #include <asm/desc.h>
@@ -578,6 +579,8 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
 	unsigned long address;
 	int write, si_code;
 	int fault;
+	unsigned long *stackend;
+
 #ifdef CONFIG_X86_64
 	unsigned long flags;
 #endif
@@ -843,6 +846,10 @@ no_context:
 
 	show_fault_oops(regs, error_code, address);
 
+ 	stackend = end_of_stack(tsk);
+	if (*stackend != STACK_END_MAGIC)
+		printk(KERN_ALERT "Thread overran stack, or stack corrupted\n");
+
 	tsk->thread.cr2 = address;
 	tsk->thread.trap_no = 14;
 	tsk->thread.error_code = error_code;
diff --git a/include/asm-x86/pda.h b/include/asm-x86/pda.h
index b34e9a7..072e6d0 100644
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
 	short nodenumber;		/* number of current node (32k max) */
 	short in_bootmem;		/* pda lives in bootmem */
@@ -134,4 +132,5 @@ do {									\
 
 #define PDA_STACKOFFSET (5*8)
 
+#define refresh_stack_canary() write_pda(stack_canary, current->stack_canary)
 #endif
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
index 983ce37..929345a 100644
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
 
diff --git a/include/linux/magic.h b/include/linux/magic.h
index 1fa0c2c..74e68e2 100644
--- a/include/linux/magic.h
+++ b/include/linux/magic.h
@@ -42,4 +42,5 @@
 #define FUTEXFS_SUPER_MAGIC	0xBAD1DEA
 #define INOTIFYFS_SUPER_MAGIC	0x2BAD1DEA
 
+#define STACK_END_MAGIC		0x57AC6E9D
 #endif /* __LINUX_MAGIC_H__ */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index c5d3f84..f0132f9 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1095,10 +1095,9 @@ struct task_struct {
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
@@ -1971,6 +1970,19 @@ static inline unsigned long *end_of_stack(struct task_struct *p)
 
 extern void thread_info_cache_init(void);
 
+#ifdef CONFIG_DEBUG_STACK_USAGE
+static inline unsigned long stack_not_used(struct task_struct *p)
+{
+	unsigned long *n = end_of_stack(p);
+
+	do { 	/* Skip over canary */
+		n++;
+	} while (!*n);
+
+	return (unsigned long)n - (unsigned long)end_of_stack(p);
+}
+#endif
+
 /* set thread flags in other task's structures
  * - see asm/thread_info.h for TIF_xxxx flags available
  */
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
index f7fb200..b44e4eb 100644
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
@@ -545,6 +546,12 @@ asmlinkage void __init start_kernel(void)
 	unwind_init();
 	lockdep_init();
 	debug_objects_early_init();
+
+	/*
+	 * Set up the the initial canary ASAP:
+	 */
+	boot_init_stack_canary();
+
 	cgroup_init_early();
 
 	local_irq_disable();
diff --git a/kernel/exit.c b/kernel/exit.c
index 8f6185e..fb8de6c 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -899,12 +899,9 @@ static void check_stack_usage(void)
 {
 	static DEFINE_SPINLOCK(low_water_lock);
 	static int lowest_to_date = THREAD_SIZE;
-	unsigned long *n = end_of_stack(current);
 	unsigned long free;
 
-	while (*n == 0)
-		n++;
-	free = (unsigned long)n - (unsigned long)end_of_stack(current);
+	free = stack_not_used(current);
 
 	if (free >= lowest_to_date)
 		return;
diff --git a/kernel/fork.c b/kernel/fork.c
index 19908b2..d428336 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -54,6 +54,7 @@
 #include <linux/tty.h>
 #include <linux/proc_fs.h>
 #include <linux/blkdev.h>
+#include <linux/magic.h>
 
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
@@ -186,6 +187,8 @@ static struct task_struct *dup_task_struct(struct task_struct *orig)
 {
 	struct task_struct *tsk;
 	struct thread_info *ti;
+	unsigned long *stackend;
+
 	int err;
 
 	prepare_to_copy(orig);
@@ -211,6 +214,8 @@ static struct task_struct *dup_task_struct(struct task_struct *orig)
 		goto out;
 
 	setup_thread_stack(tsk, orig);
+	stackend = end_of_stack(tsk);
+	*stackend = STACK_END_MAGIC;	/* for overflow detection */
 
 #ifdef CONFIG_CC_STACKPROTECTOR
 	tsk->stack_canary = get_random_int();
diff --git a/kernel/panic.c b/kernel/panic.c
index 425567f..c35c9ec 100644
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
@@ -321,13 +324,20 @@ EXPORT_SYMBOL(warn_on_slowpath);
 #endif
 
 #ifdef CONFIG_CC_STACKPROTECTOR
+
+#ifndef GCC_HAS_SP
+#warning You have selected the CONFIG_CC_STACKPROTECTOR option, but the gcc used does not support this.
+#endif
+
 /*
  * Called when gcc's -fstack-protector feature is used, and
  * gcc detects corruption of the on-stack canary value
  */
 void __stack_chk_fail(void)
 {
-	panic("stack-protector: Kernel stack is corrupted");
+	panic("stack-protector: Kernel stack is corrupted in: %p\n",
+		__builtin_return_address(0));
 }
 EXPORT_SYMBOL(__stack_chk_fail);
+
 #endif
diff --git a/kernel/sched.c b/kernel/sched.c
index 8402944..be561b0 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5406,12 +5406,7 @@ void sched_show_task(struct task_struct *p)
 		printk(KERN_CONT " %016lx ", thread_saved_pc(p));
 #endif
 #ifdef CONFIG_DEBUG_STACK_USAGE
-	{
-		unsigned long *n = end_of_stack(p);
-		while (!*n)
-			n++;
-		free = (unsigned long)n - (unsigned long)end_of_stack(p);
-	}
+	free = stack_not_used(p);
 #endif
 	printk(KERN_CONT "%5lu %5d %6d\n", free,
 		task_pid_nr(p), task_pid_nr(p->real_parent));
