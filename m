Return-Path: <linux-kernel-owner+w=401wt.eu-S1761019AbZB0V0I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761019AbZB0V0I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 16:26:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759500AbZB0VZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 16:25:45 -0500
Received: from gw.goop.org ([64.81.55.164]:40002 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758835AbZB0VZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 16:25:43 -0500
Message-ID: <49A85A48.50901@goop.org>
Date: Fri, 27 Feb 2009 13:25:28 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] x86: unify chunks of kernel/process*.c
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With x86-32 and -64 using the same mechanism for managing the
tss io permissions bitmap, large chunks of process*.c are
trivially unifyable, including:
 - exit_thread
 - flush_thread
 - __switch_to_xtra (along with tsc enable/disable)

and as bonus pickups:
 - sys_fork
 - sys_vfork

(Note: asmlinkage expands to empty on x86-64)

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

diff --git a/arch/x86/include/asm/system.h b/arch/x86/include/asm/system.h
index c00bfdb..1a7bf39 100644
--- a/arch/x86/include/asm/system.h
+++ b/arch/x86/include/asm/system.h
@@ -20,6 +20,8 @@
 struct task_struct; /* one of the stranger aspects of C forward declarations */
 struct task_struct *__switch_to(struct task_struct *prev,
 				struct task_struct *next);
+void __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p,
+		      struct tss_struct *tss);
 
 #ifdef CONFIG_X86_32
 
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index bf91350..bcef69e 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -1,14 +1,17 @@
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
-#include <asm/idle.h>
 #include <linux/smp.h>
+#include <linux/prctl.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/pm.h>
 #include <linux/clockchips.h>
 #include <trace/power.h>
+#include <asm/idle.h>
+#include <asm/uaccess.h>
+#include <asm/i387.h>
 #include <asm/system.h>
 #include <asm/apic.h>
 
@@ -59,6 +62,192 @@ void arch_task_cache_init(void)
 }
 
 /*
+ * Free current thread data structures etc..
+ */
+void exit_thread(void)
+{
+	struct task_struct *me = current;
+	struct thread_struct *t = &me->thread;
+
+	if (me->thread.io_bitmap_ptr) {
+		struct tss_struct *tss = &per_cpu(init_tss, get_cpu());
+
+		kfree(t->io_bitmap_ptr);
+		t->io_bitmap_ptr = NULL;
+		clear_thread_flag(TIF_IO_BITMAP);
+		/*
+		 * Careful, clear this in the TSS too:
+		 */
+		memset(tss->io_bitmap, 0xff, t->io_bitmap_max);
+		t->io_bitmap_max = 0;
+		put_cpu();
+	}
+
+	ds_exit_thread(current);
+}
+
+void flush_thread(void)
+{
+	struct task_struct *tsk = current;
+
+#ifdef CONFIG_X86_64
+	if (test_tsk_thread_flag(tsk, TIF_ABI_PENDING)) {
+		clear_tsk_thread_flag(tsk, TIF_ABI_PENDING);
+		if (test_tsk_thread_flag(tsk, TIF_IA32)) {
+			clear_tsk_thread_flag(tsk, TIF_IA32);
+		} else {
+			set_tsk_thread_flag(tsk, TIF_IA32);
+			current_thread_info()->status |= TS_COMPAT;
+		}
+	}
+#endif
+
+	clear_tsk_thread_flag(tsk, TIF_DEBUG);
+
+	tsk->thread.debugreg0 = 0;
+	tsk->thread.debugreg1 = 0;
+	tsk->thread.debugreg2 = 0;
+	tsk->thread.debugreg3 = 0;
+	tsk->thread.debugreg6 = 0;
+	tsk->thread.debugreg7 = 0;
+	memset(tsk->thread.tls_array, 0, sizeof(tsk->thread.tls_array));
+	/*
+	 * Forget coprocessor state..
+	 */
+	tsk->fpu_counter = 0;
+	clear_fpu(tsk);
+	clear_used_math();
+}
+
+static void hard_disable_TSC(void)
+{
+	write_cr4(read_cr4() | X86_CR4_TSD);
+}
+
+void disable_TSC(void)
+{
+	preempt_disable();
+	if (!test_and_set_thread_flag(TIF_NOTSC))
+		/*
+		 * Must flip the CPU state synchronously with
+		 * TIF_NOTSC in the current running context.
+		 */
+		hard_disable_TSC();
+	preempt_enable();
+}
+
+static void hard_enable_TSC(void)
+{
+	write_cr4(read_cr4() & ~X86_CR4_TSD);
+}
+
+static void enable_TSC(void)
+{
+	preempt_disable();
+	if (test_and_clear_thread_flag(TIF_NOTSC))
+		/*
+		 * Must flip the CPU state synchronously with
+		 * TIF_NOTSC in the current running context.
+		 */
+		hard_enable_TSC();
+	preempt_enable();
+}
+
+int get_tsc_mode(unsigned long adr)
+{
+	unsigned int val;
+
+	if (test_thread_flag(TIF_NOTSC))
+		val = PR_TSC_SIGSEGV;
+	else
+		val = PR_TSC_ENABLE;
+
+	return put_user(val, (unsigned int __user *)adr);
+}
+
+int set_tsc_mode(unsigned int val)
+{
+	if (val == PR_TSC_SIGSEGV)
+		disable_TSC();
+	else if (val == PR_TSC_ENABLE)
+		enable_TSC();
+	else
+		return -EINVAL;
+
+	return 0;
+}
+
+void __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p,
+		      struct tss_struct *tss)
+{
+	struct thread_struct *prev, *next;
+
+	prev = &prev_p->thread;
+	next = &next_p->thread;
+
+	if (test_tsk_thread_flag(next_p, TIF_DS_AREA_MSR) ||
+	    test_tsk_thread_flag(prev_p, TIF_DS_AREA_MSR))
+		ds_switch_to(prev_p, next_p);
+	else if (next->debugctlmsr != prev->debugctlmsr)
+		update_debugctlmsr(next->debugctlmsr);
+
+	if (test_tsk_thread_flag(next_p, TIF_DEBUG)) {
+		set_debugreg(next->debugreg0, 0);
+		set_debugreg(next->debugreg1, 1);
+		set_debugreg(next->debugreg2, 2);
+		set_debugreg(next->debugreg3, 3);
+		/* no 4 and 5 */
+		set_debugreg(next->debugreg6, 6);
+		set_debugreg(next->debugreg7, 7);
+	}
+
+	if (test_tsk_thread_flag(prev_p, TIF_NOTSC) ^
+	    test_tsk_thread_flag(next_p, TIF_NOTSC)) {
+		/* prev and next are different */
+		if (test_tsk_thread_flag(next_p, TIF_NOTSC))
+			hard_disable_TSC();
+		else
+			hard_enable_TSC();
+	}
+
+	if (test_tsk_thread_flag(next_p, TIF_IO_BITMAP)) {
+		/*
+		 * Copy the relevant range of the IO bitmap.
+		 * Normally this is 128 bytes or less:
+		 */
+		memcpy(tss->io_bitmap, next->io_bitmap_ptr,
+		       max(prev->io_bitmap_max, next->io_bitmap_max));
+	} else if (test_tsk_thread_flag(prev_p, TIF_IO_BITMAP)) {
+		/*
+		 * Clear any possible leftover bits:
+		 */
+		memset(tss->io_bitmap, 0xff, prev->io_bitmap_max);
+	}
+}
+
+int sys_fork(struct pt_regs *regs)
+{
+	return do_fork(SIGCHLD, regs->sp, regs, 0, NULL, NULL);
+}
+
+/*
+ * This is trivial, and on the face of it looks like it
+ * could equally well be done in user mode.
+ *
+ * Not so, for quite unobvious reasons - register pressure.
+ * In user mode vfork() cannot have a stack frame, and if
+ * done by calling the "clone()" system call directly, you
+ * do not have enough call-clobbered registers to hold all
+ * the information you need.
+ */
+int sys_vfork(struct pt_regs *regs)
+{
+	return do_fork(CLONE_VFORK | CLONE_VM | SIGCHLD, regs->sp, regs, 0,
+		       NULL, NULL);
+}
+
+
+/*
  * Idle related variables and functions
  */
 unsigned long boot_option_idle_override = 0;
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 01ff913..07c39b0 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -228,52 +228,6 @@ int kernel_thread(int (*fn)(void *), void *arg, unsigned long flags)
 }
 EXPORT_SYMBOL(kernel_thread);
 
-/*
- * Free current thread data structures etc..
- */
-void exit_thread(void)
-{
-	/* The process may have allocated an io port bitmap... nuke it. */
-	if (unlikely(test_thread_flag(TIF_IO_BITMAP))) {
-		struct task_struct *tsk = current;
-		struct thread_struct *t = &tsk->thread;
-		int cpu = get_cpu();
-		struct tss_struct *tss = &per_cpu(init_tss, cpu);
-
-		kfree(t->io_bitmap_ptr);
-		t->io_bitmap_ptr = NULL;
-		clear_thread_flag(TIF_IO_BITMAP);
-		/*
-		 * Careful, clear this in the TSS too:
-		 */
-		memset(tss->io_bitmap, 0xff, t->io_bitmap_max);
-		t->io_bitmap_max = 0;
-		put_cpu();
-	}
-
-	ds_exit_thread(current);
-}
-
-void flush_thread(void)
-{
-	struct task_struct *tsk = current;
-
-	tsk->thread.debugreg0 = 0;
-	tsk->thread.debugreg1 = 0;
-	tsk->thread.debugreg2 = 0;
-	tsk->thread.debugreg3 = 0;
-	tsk->thread.debugreg6 = 0;
-	tsk->thread.debugreg7 = 0;
-	memset(tsk->thread.tls_array, 0, sizeof(tsk->thread.tls_array));
-	clear_tsk_thread_flag(tsk, TIF_DEBUG);
-	/*
-	 * Forget coprocessor state..
-	 */
-	tsk->fpu_counter = 0;
-	clear_fpu(tsk);
-	clear_used_math();
-}
-
 void release_thread(struct task_struct *dead_task)
 {
 	BUG_ON(dead_task->mm);
@@ -361,112 +315,6 @@ start_thread(struct pt_regs *regs, unsigned long new_ip, unsigned long new_sp)
 }
 EXPORT_SYMBOL_GPL(start_thread);
 
-static void hard_disable_TSC(void)
-{
-	write_cr4(read_cr4() | X86_CR4_TSD);
-}
-
-void disable_TSC(void)
-{
-	preempt_disable();
-	if (!test_and_set_thread_flag(TIF_NOTSC))
-		/*
-		 * Must flip the CPU state synchronously with
-		 * TIF_NOTSC in the current running context.
-		 */
-		hard_disable_TSC();
-	preempt_enable();
-}
-
-static void hard_enable_TSC(void)
-{
-	write_cr4(read_cr4() & ~X86_CR4_TSD);
-}
-
-static void enable_TSC(void)
-{
-	preempt_disable();
-	if (test_and_clear_thread_flag(TIF_NOTSC))
-		/*
-		 * Must flip the CPU state synchronously with
-		 * TIF_NOTSC in the current running context.
-		 */
-		hard_enable_TSC();
-	preempt_enable();
-}
-
-int get_tsc_mode(unsigned long adr)
-{
-	unsigned int val;
-
-	if (test_thread_flag(TIF_NOTSC))
-		val = PR_TSC_SIGSEGV;
-	else
-		val = PR_TSC_ENABLE;
-
-	return put_user(val, (unsigned int __user *)adr);
-}
-
-int set_tsc_mode(unsigned int val)
-{
-	if (val == PR_TSC_SIGSEGV)
-		disable_TSC();
-	else if (val == PR_TSC_ENABLE)
-		enable_TSC();
-	else
-		return -EINVAL;
-
-	return 0;
-}
-
-static noinline void
-__switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p,
-		 struct tss_struct *tss)
-{
-	struct thread_struct *prev, *next;
-
-	prev = &prev_p->thread;
-	next = &next_p->thread;
-
-	if (test_tsk_thread_flag(next_p, TIF_DS_AREA_MSR) ||
-	    test_tsk_thread_flag(prev_p, TIF_DS_AREA_MSR))
-		ds_switch_to(prev_p, next_p);
-	else if (next->debugctlmsr != prev->debugctlmsr)
-		update_debugctlmsr(next->debugctlmsr);
-
-	if (test_tsk_thread_flag(next_p, TIF_DEBUG)) {
-		set_debugreg(next->debugreg0, 0);
-		set_debugreg(next->debugreg1, 1);
-		set_debugreg(next->debugreg2, 2);
-		set_debugreg(next->debugreg3, 3);
-		/* no 4 and 5 */
-		set_debugreg(next->debugreg6, 6);
-		set_debugreg(next->debugreg7, 7);
-	}
-
-	if (test_tsk_thread_flag(prev_p, TIF_NOTSC) ^
-	    test_tsk_thread_flag(next_p, TIF_NOTSC)) {
-		/* prev and next are different */
-		if (test_tsk_thread_flag(next_p, TIF_NOTSC))
-			hard_disable_TSC();
-		else
-			hard_enable_TSC();
-	}
-
-	if (test_tsk_thread_flag(next_p, TIF_IO_BITMAP)) {
-		/*
-		 * Copy the relevant range of the IO bitmap.
-		 * Normally this is 128 bytes or less:
-		 */
-		memcpy(tss->io_bitmap, next->io_bitmap_ptr,
-		       max(prev->io_bitmap_max, next->io_bitmap_max));
-	} else if (test_tsk_thread_flag(prev_p, TIF_IO_BITMAP)) {
-		/*
-		 * Clear any possible leftover bits:
-		 */
-		memset(tss->io_bitmap, 0xff, prev->io_bitmap_max);
-	}
-}
 
 /*
  *	switch_to(x,yn) should switch tasks from x to y.
@@ -580,11 +428,6 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	return prev_p;
 }
 
-int sys_fork(struct pt_regs *regs)
-{
-	return do_fork(SIGCHLD, regs->sp, regs, 0, NULL, NULL);
-}
-
 int sys_clone(struct pt_regs *regs)
 {
 	unsigned long clone_flags;
@@ -601,21 +444,6 @@ int sys_clone(struct pt_regs *regs)
 }
 
 /*
- * This is trivial, and on the face of it looks like it
- * could equally well be done in user mode.
- *
- * Not so, for quite unobvious reasons - register pressure.
- * In user mode vfork() cannot have a stack frame, and if
- * done by calling the "clone()" system call directly, you
- * do not have enough call-clobbered registers to hold all
- * the information you need.
- */
-int sys_vfork(struct pt_regs *regs)
-{
-	return do_fork(CLONE_VFORK | CLONE_VM | SIGCHLD, regs->sp, regs, 0, NULL, NULL);
-}
-
-/*
  * sys_execve() executes a new program.
  */
 int sys_execve(struct pt_regs *regs)
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 836ef65..abb7e6a 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -237,61 +237,6 @@ void show_regs(struct pt_regs *regs)
 	show_trace(NULL, regs, (void *)(regs + 1), regs->bp);
 }
 
-/*
- * Free current thread data structures etc..
- */
-void exit_thread(void)
-{
-	struct task_struct *me = current;
-	struct thread_struct *t = &me->thread;
-
-	if (me->thread.io_bitmap_ptr) {
-		struct tss_struct *tss = &per_cpu(init_tss, get_cpu());
-
-		kfree(t->io_bitmap_ptr);
-		t->io_bitmap_ptr = NULL;
-		clear_thread_flag(TIF_IO_BITMAP);
-		/*
-		 * Careful, clear this in the TSS too:
-		 */
-		memset(tss->io_bitmap, 0xff, t->io_bitmap_max);
-		t->io_bitmap_max = 0;
-		put_cpu();
-	}
-
-	ds_exit_thread(current);
-}
-
-void flush_thread(void)
-{
-	struct task_struct *tsk = current;
-
-	if (test_tsk_thread_flag(tsk, TIF_ABI_PENDING)) {
-		clear_tsk_thread_flag(tsk, TIF_ABI_PENDING);
-		if (test_tsk_thread_flag(tsk, TIF_IA32)) {
-			clear_tsk_thread_flag(tsk, TIF_IA32);
-		} else {
-			set_tsk_thread_flag(tsk, TIF_IA32);
-			current_thread_info()->status |= TS_COMPAT;
-		}
-	}
-	clear_tsk_thread_flag(tsk, TIF_DEBUG);
-
-	tsk->thread.debugreg0 = 0;
-	tsk->thread.debugreg1 = 0;
-	tsk->thread.debugreg2 = 0;
-	tsk->thread.debugreg3 = 0;
-	tsk->thread.debugreg6 = 0;
-	tsk->thread.debugreg7 = 0;
-	memset(tsk->thread.tls_array, 0, sizeof(tsk->thread.tls_array));
-	/*
-	 * Forget coprocessor state..
-	 */
-	tsk->fpu_counter = 0;
-	clear_fpu(tsk);
-	clear_used_math();
-}
-
 void release_thread(struct task_struct *dead_task)
 {
 	if (dead_task->mm) {
@@ -425,118 +370,6 @@ start_thread(struct pt_regs *regs, unsigned long new_ip, unsigned long new_sp)
 }
 EXPORT_SYMBOL_GPL(start_thread);
 
-static void hard_disable_TSC(void)
-{
-	write_cr4(read_cr4() | X86_CR4_TSD);
-}
-
-void disable_TSC(void)
-{
-	preempt_disable();
-	if (!test_and_set_thread_flag(TIF_NOTSC))
-		/*
-		 * Must flip the CPU state synchronously with
-		 * TIF_NOTSC in the current running context.
-		 */
-		hard_disable_TSC();
-	preempt_enable();
-}
-
-static void hard_enable_TSC(void)
-{
-	write_cr4(read_cr4() & ~X86_CR4_TSD);
-}
-
-static void enable_TSC(void)
-{
-	preempt_disable();
-	if (test_and_clear_thread_flag(TIF_NOTSC))
-		/*
-		 * Must flip the CPU state synchronously with
-		 * TIF_NOTSC in the current running context.
-		 */
-		hard_enable_TSC();
-	preempt_enable();
-}
-
-int get_tsc_mode(unsigned long adr)
-{
-	unsigned int val;
-
-	if (test_thread_flag(TIF_NOTSC))
-		val = PR_TSC_SIGSEGV;
-	else
-		val = PR_TSC_ENABLE;
-
-	return put_user(val, (unsigned int __user *)adr);
-}
-
-int set_tsc_mode(unsigned int val)
-{
-	if (val == PR_TSC_SIGSEGV)
-		disable_TSC();
-	else if (val == PR_TSC_ENABLE)
-		enable_TSC();
-	else
-		return -EINVAL;
-
-	return 0;
-}
-
-/*
- * This special macro can be used to load a debugging register
- */
-#define loaddebug(thread, r) set_debugreg(thread->debugreg ## r, r)
-
-static inline void __switch_to_xtra(struct task_struct *prev_p,
-				    struct task_struct *next_p,
-				    struct tss_struct *tss)
-{
-	struct thread_struct *prev, *next;
-
-	prev = &prev_p->thread,
-	next = &next_p->thread;
-
-	if (test_tsk_thread_flag(next_p, TIF_DS_AREA_MSR) ||
-	    test_tsk_thread_flag(prev_p, TIF_DS_AREA_MSR))
-		ds_switch_to(prev_p, next_p);
-	else if (next->debugctlmsr != prev->debugctlmsr)
-		update_debugctlmsr(next->debugctlmsr);
-
-	if (test_tsk_thread_flag(next_p, TIF_DEBUG)) {
-		loaddebug(next, 0);
-		loaddebug(next, 1);
-		loaddebug(next, 2);
-		loaddebug(next, 3);
-		/* no 4 and 5 */
-		loaddebug(next, 6);
-		loaddebug(next, 7);
-	}
-
-	if (test_tsk_thread_flag(prev_p, TIF_NOTSC) ^
-	    test_tsk_thread_flag(next_p, TIF_NOTSC)) {
-		/* prev and next are different */
-		if (test_tsk_thread_flag(next_p, TIF_NOTSC))
-			hard_disable_TSC();
-		else
-			hard_enable_TSC();
-	}
-
-	if (test_tsk_thread_flag(next_p, TIF_IO_BITMAP)) {
-		/*
-		 * Copy the relevant range of the IO bitmap.
-		 * Normally this is 128 bytes or less:
-		 */
-		memcpy(tss->io_bitmap, next->io_bitmap_ptr,
-		       max(prev->io_bitmap_max, next->io_bitmap_max));
-	} else if (test_tsk_thread_flag(prev_p, TIF_IO_BITMAP)) {
-		/*
-		 * Clear any possible leftover bits:
-		 */
-		memset(tss->io_bitmap, 0xff, prev->io_bitmap_max);
-	}
-}
-
 /*
  *	switch_to(x,y) should switch tasks from x to y.
  *
@@ -694,11 +527,6 @@ void set_personality_64bit(void)
 	current->personality &= ~READ_IMPLIES_EXEC;
 }
 
-asmlinkage long sys_fork(struct pt_regs *regs)
-{
-	return do_fork(SIGCHLD, regs->sp, regs, 0, NULL, NULL);
-}
-
 asmlinkage long
 sys_clone(unsigned long clone_flags, unsigned long newsp,
 	  void __user *parent_tid, void __user *child_tid, struct pt_regs *regs)
@@ -708,22 +536,6 @@ sys_clone(unsigned long clone_flags, unsigned long newsp,
 	return do_fork(clone_flags, newsp, regs, 0, parent_tid, child_tid);
 }
 
-/*
- * This is trivial, and on the face of it looks like it
- * could equally well be done in user mode.
- *
- * Not so, for quite unobvious reasons - register pressure.
- * In user mode vfork() cannot have a stack frame, and if
- * done by calling the "clone()" system call directly, you
- * do not have enough call-clobbered registers to hold all
- * the information you need.
- */
-asmlinkage long sys_vfork(struct pt_regs *regs)
-{
-	return do_fork(CLONE_VFORK | CLONE_VM | SIGCHLD, regs->sp, regs, 0,
-		    NULL, NULL);
-}
-
 unsigned long get_wchan(struct task_struct *p)
 {
 	unsigned long stack;


