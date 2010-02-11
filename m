Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352Ab0BKJl6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 04:41:58 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:42814 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753068Ab0BKJls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 04:41:48 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: Christoph Hellwig <hch@lst.de>
Cc: roland@redhat.com, oleg@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 1/2] Blackfin: initial tracehook support
Date: Thu, 11 Feb 2010 04:43:08 -0500
Message-Id: <1265881389-26925-2-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <20100202185907.GE3630@lst.de>
References: <20100202185907.GE3630@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/Kconfig               |    1 +
 arch/blackfin/include/asm/ptrace.h  |   23 ++++++++
 arch/blackfin/include/asm/syscall.h |   96 +++++++++++++++++++++++++++++++++++
 arch/blackfin/kernel/ptrace.c       |   71 +++++++-------------------
 arch/blackfin/kernel/signal.c       |    4 +-
 arch/blackfin/mach-common/entry.S   |    6 ++-
 6 files changed, 145 insertions(+), 56 deletions(-)
 create mode 100644 arch/blackfin/include/asm/syscall.h

diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index cdd87a0..13d8fe9 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -24,6 +24,7 @@ config RWSEM_XCHGADD_ALGORITHM
 config BLACKFIN
 	def_bool y
 	select HAVE_ARCH_KGDB
+	select HAVE_ARCH_TRACEHOOK
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select HAVE_FUNCTION_TRACER
 	select HAVE_IDE
diff --git a/arch/blackfin/include/asm/ptrace.h b/arch/blackfin/include/asm/ptrace.h
index b33a448..f3e75fa 100644
--- a/arch/blackfin/include/asm/ptrace.h
+++ b/arch/blackfin/include/asm/ptrace.h
@@ -24,6 +24,8 @@
 
 #ifndef __ASSEMBLY__
 
+struct task_struct;
+
 /* this struct defines the way the registers are stored on the
    stack during a system call. */
 
@@ -101,9 +103,30 @@ struct pt_regs {
    master interrupt enable.  */
 #define user_mode(regs) (!(((regs)->ipend & ~0x10) & (((regs)->ipend & ~0x10) - 1)))
 #define instruction_pointer(regs) ((regs)->pc)
+#define user_stack_pointer(regs)  ((regs)->usp)
 #define profile_pc(regs) instruction_pointer(regs)
 extern void show_regs(struct pt_regs *);
 
+#define arch_has_single_step()	(1)
+extern void user_enable_single_step(struct task_struct *);
+extern void user_disable_single_step(struct task_struct *child);
+/* common code demands this function */
+#define ptrace_disable(child) user_disable_single_step(child)
+
+/*
+ * Get the address of the live pt_regs for the specified task.
+ * These are saved onto the top kernel stack when the process
+ * is not running.
+ *
+ * Note: if a user thread is execve'd from kernel space, the
+ * kernel stack will not be empty on entry to the kernel, so
+ * ptracing these tasks will fail.
+ */
+#define task_pt_regs(task) \
+	(struct pt_regs *) \
+	    ((unsigned long)task_stack_page(task) + \
+	     (THREAD_SIZE - sizeof(struct pt_regs)))
+
 #endif  /*  __KERNEL__  */
 
 #endif				/* __ASSEMBLY__ */
diff --git a/arch/blackfin/include/asm/syscall.h b/arch/blackfin/include/asm/syscall.h
new file mode 100644
index 0000000..74e0458
--- /dev/null
+++ b/arch/blackfin/include/asm/syscall.h
@@ -0,0 +1,96 @@
+/*
+ * Magic syscall break down functions
+ *
+ * Copyright 2010 Analog Devices Inc.
+ *
+ * Licensed under the GPL-2 or later.
+ */
+
+#ifndef __ASM_BLACKFIN_SYSCALL_H__
+#define __ASM_BLACKFIN_SYSCALL_H__
+
+/*
+ * Blackfin syscalls are simple:
+ *	enter:
+ *		p0: syscall number
+ *		r{0,1,2,3,4,5}: syscall args 0,1,2,3,4,5
+ *	exit:
+ *		r0: return/error value
+ */
+
+#include <linux/err.h>
+#include <linux/sched.h>
+#include <asm/ptrace.h>
+
+static inline long
+syscall_get_nr(struct task_struct *task, struct pt_regs *regs)
+{
+	return regs->p0;
+}
+
+static inline void
+syscall_rollback(struct task_struct *task, struct pt_regs *regs)
+{
+	/* was zu tun !? */
+}
+
+static inline long
+syscall_get_error(struct task_struct *task, struct pt_regs *regs)
+{
+	return IS_ERR_VALUE(regs->r0) ? regs->r0 : 0;
+}
+
+static inline long
+syscall_get_return_value(struct task_struct *task, struct pt_regs *regs)
+{
+	return regs->r0;
+}
+
+static inline void
+syscall_set_return_value(struct task_struct *task, struct pt_regs *regs,
+                         int error, long val)
+{
+	regs->r0 = error ? -error : val;
+}
+
+static inline void
+syscall_get_arguments(struct task_struct *task, struct pt_regs *regs,
+                      unsigned int i, unsigned int n, unsigned long *args)
+{
+	/* wtf is "i" ? */
+	BUG_ON(i);
+
+	switch (n) {
+	case 6: args[5] = regs->r5;
+	case 5: args[4] = regs->r4;
+	case 4: args[3] = regs->r3;
+	case 3: args[2] = regs->r2;
+	case 2: args[1] = regs->r1;
+	case 1: args[0] = regs->r0;
+		break;
+	default:
+		BUG();
+	}
+}
+
+static inline void
+syscall_set_arguments(struct task_struct *task, struct pt_regs *regs,
+                      unsigned int i, unsigned int n, const unsigned long *args)
+{
+	/* wtf is "i" ? */
+	BUG_ON(i);
+
+	switch (n) {
+	case 6: regs->r5 = args[5];
+	case 5: regs->r4 = args[4];
+	case 4: regs->r3 = args[3];
+	case 3: regs->r2 = args[2];
+	case 2: regs->r1 = args[1];
+	case 1: regs->r0 = args[0];
+		break;
+	default:
+		BUG();
+	}
+}
+
+#endif
diff --git a/arch/blackfin/kernel/ptrace.c b/arch/blackfin/kernel/ptrace.c
index 65567dc..f6e94ad 100644
--- a/arch/blackfin/kernel/ptrace.c
+++ b/arch/blackfin/kernel/ptrace.c
@@ -13,6 +13,7 @@
 #include <linux/ptrace.h>
 #include <linux/user.h>
 #include <linux/signal.h>
+#include <linux/tracehook.h>
 #include <linux/uaccess.h>
 
 #include <asm/page.h>
@@ -37,32 +38,13 @@
 /* sets the trace bits. */
 #define TRACE_BITS 0x0001
 
-/* Find the stack offset for a register, relative to thread.esp0. */
-#define PT_REG(reg)	((long)&((struct pt_regs *)0)->reg)
-
-/*
- * Get the address of the live pt_regs for the specified task.
- * These are saved onto the top kernel stack when the process
- * is not running.
- *
- * Note: if a user thread is execve'd from kernel space, the
- * kernel stack will not be empty on entry to the kernel, so
- * ptracing these tasks will fail.
- */
-static inline struct pt_regs *get_user_regs(struct task_struct *task)
-{
-	return (struct pt_regs *)
-	    ((unsigned long)task_stack_page(task) +
-	     (THREAD_SIZE - sizeof(struct pt_regs)));
-}
-
 /*
  * Get all user integer registers.
  */
 static inline int ptrace_getregs(struct task_struct *tsk, void __user *uregs)
 {
 	struct pt_regs regs;
-	memcpy(&regs, get_user_regs(tsk), sizeof(regs));
+	memcpy(&regs, task_pt_regs(tsk), sizeof(regs));
 	regs.usp = tsk->thread.usp;
 	return copy_to_user(uregs, &regs, sizeof(struct pt_regs)) ? -EFAULT : 0;
 }
@@ -78,10 +60,8 @@ static inline int ptrace_getregs(struct task_struct *tsk, void __user *uregs)
 static inline long get_reg(struct task_struct *task, int regno)
 {
 	unsigned char *reg_ptr;
+	struct pt_regs *regs = task_pt_regs(task);
 
-	struct pt_regs *regs =
-	    (struct pt_regs *)((unsigned long)task_stack_page(task) +
-			       (THREAD_SIZE - sizeof(struct pt_regs)));
 	reg_ptr = (char *)regs;
 
 	switch (regno) {
@@ -104,10 +84,8 @@ static inline int
 put_reg(struct task_struct *task, int regno, unsigned long data)
 {
 	char *reg_ptr;
+	struct pt_regs *regs = task_pt_regs(task);
 
-	struct pt_regs *regs =
-	    (struct pt_regs *)((unsigned long)task_stack_page(task) +
-			       (THREAD_SIZE - sizeof(struct pt_regs)));
 	reg_ptr = (char *)regs;
 
 	switch (regno) {
@@ -160,7 +138,7 @@ static inline int is_user_addr_valid(struct task_struct *child,
 	return -EIO;
 }
 
-void ptrace_enable(struct task_struct *child)
+void user_enable_single_step(struct task_struct *child)
 {
 	unsigned long tmp;
 	tmp = get_reg(child, PT_SYSCFG) | (TRACE_BITS);
@@ -169,10 +147,8 @@ void ptrace_enable(struct task_struct *child)
 
 /*
  * Called by kernel/ptrace.c when detaching..
- *
- * Make sure the single step bit is not set.
  */
-void ptrace_disable(struct task_struct *child)
+void user_disable_single_step(struct task_struct *child)
 {
 	unsigned long tmp;
 	/* make sure the single step bit is not set. */
@@ -366,7 +342,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		else
 			clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
 		child->exit_code = data;
-		ptrace_disable(child);
+		user_disable_single_step(child);
 		pr_debug("ptrace: before wake_up_process\n");
 		wake_up_process(child);
 		ret = 0;
@@ -382,7 +358,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		if (child->exit_state == EXIT_ZOMBIE)	/* already dead */
 			break;
 		child->exit_code = SIGKILL;
-		ptrace_disable(child);
+		user_disable_single_step(child);
 		wake_up_process(child);
 		break;
 
@@ -392,7 +368,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		if (!valid_signal(data))
 			break;
 		clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-		ptrace_enable(child);
+		user_enable_single_step(child);
 		child->exit_code = data;
 		wake_up_process(child);
 		ret = 0;
@@ -417,27 +393,18 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 	return ret;
 }
 
-asmlinkage void syscall_trace(void)
+asmlinkage int syscall_trace_enter(struct pt_regs *regs)
 {
-	if (!test_thread_flag(TIF_SYSCALL_TRACE))
-		return;
+	int ret = 0;
 
-	if (!(current->ptrace & PT_PTRACED))
-		return;
+	if (test_thread_flag(TIF_SYSCALL_TRACE))
+		ret = tracehook_report_syscall_entry(regs);
 
-	/* the 0x80 provides a way for the tracing parent to distinguish
-	 * between a syscall stop and SIGTRAP delivery
-	 */
-	ptrace_notify(SIGTRAP | ((current->ptrace & PT_TRACESYSGOOD)
-				 ? 0x80 : 0));
+	return ret;
+}
 
-	/*
-	 * this isn't the same as continuing with a signal, but it will do
-	 * for normal use.  strace only continues with a signal if the
-	 * stopping signal is not SIGTRAP.  -brl
-	 */
-	if (current->exit_code) {
-		send_sig(current->exit_code, current, 1);
-		current->exit_code = 0;
-	}
+asmlinkage void syscall_trace_leave(struct pt_regs *regs)
+{
+	if (test_thread_flag(TIF_SYSCALL_TRACE))
+		tracehook_report_syscall_exit(regs, 0);
 }
diff --git a/arch/blackfin/kernel/signal.c b/arch/blackfin/kernel/signal.c
index e0fd63e..1f28852 100644
--- a/arch/blackfin/kernel/signal.c
+++ b/arch/blackfin/kernel/signal.c
@@ -1,5 +1,5 @@
 /*
- * Copyright 2004-2009 Analog Devices Inc.
+ * Copyright 2004-2010 Analog Devices Inc.
  *
  * Licensed under the GPL-2 or later
  */
@@ -213,7 +213,7 @@ setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t * info,
 	 */
 	if (regs->syscfg & TRACE_BITS) {
 		regs->syscfg &= ~TRACE_BITS;
-		ptrace_notify(SIGTRAP);
+		tracehook_signal_handler(sig, info, ka, regs, 1);
 	}
 
 	return 0;
diff --git a/arch/blackfin/mach-common/entry.S b/arch/blackfin/mach-common/entry.S
index 16abeb8..365d506 100644
--- a/arch/blackfin/mach-common/entry.S
+++ b/arch/blackfin/mach-common/entry.S
@@ -736,7 +736,8 @@ ENDPROC(_system_call)
  * this symbol need not be global anyways, so ...
  */
 _sys_trace:
-	pseudo_long_call _syscall_trace, p5;
+	r0 = sp;
+	pseudo_long_call _syscall_trace_enter, p5;
 
 	/* Execute the appropriate system call */
 
@@ -760,7 +761,8 @@ _sys_trace:
 	SP += 24;
 	[sp + PT_R0] = r0;
 
-	pseudo_long_call _syscall_trace, p5;
+	r0 = sp;
+	pseudo_long_call _syscall_trace_leave, p5;
 	jump .Lresume_userspace;
 ENDPROC(_sys_trace)
 
-- 
1.6.6.1

