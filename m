Return-Path: <linux-kernel-owner+w=401wt.eu-S1755553AbZFBWoN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbZFBWoN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 18:44:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754481AbZFBWno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 18:43:44 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:20851 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753349AbZFBWnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 18:43:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=thWlep1etwDfpRRAIuUdupPtwA/Z/4J8Q6PixOtpit9fAcRAPKDfj2UpyX2D05JwsB
         zXt/PZ59gdpAZAl6E8yrTqibDf6AOeB5zCbSuOnC6QiApI81nsRUi7wXak0JCRDRcoc7
         q+e2OfIwHvEkW9WRKvs1MZ6f6W3/5huq4gLO4=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 01/12] hw-breakpoints: prepare the code for Hardware Breakpoint interfaces
Date: Wed,  3 Jun 2009 00:43:25 +0200
Message-Id: <1243982616-18212-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1243982616-18212-1-git-send-email-fweisbec@gmail.com>
References: <1243982616-18212-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: K.Prasad <prasad@linux.vnet.ibm.com>

The generic hardware breakpoint interface provides an abstraction of
hardware breakpoints in front of specific arch implementations for both kernel
and user side breakpoints.
This includes execution breakpoints and read/write breakpoints, also known as
"watchpoints".

This patch introduces header files containing constants, structure definitions
and declaration of functions used by the hardware breakpoint core and x86
specific code.
It also introduces an array based storage for the debug-register values in
'struct thread_struct', while modifying all users of debugreg<n> member in the
structure.

[ Impact: add headers for new hardware breakpoint interface ]

Original-patch-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/include/asm/a.out-core.h    |    8 +-
 arch/x86/include/asm/debugreg.h      |   29 +++++++
 arch/x86/include/asm/hw_breakpoint.h |   55 +++++++++++++
 arch/x86/include/asm/processor.h     |    8 +-
 arch/x86/kernel/process.c            |   16 ++--
 arch/x86/kernel/ptrace.c             |   16 ++--
 arch/x86/power/cpu_32.c              |    8 +-
 arch/x86/power/cpu_64.c              |    8 +-
 include/asm-generic/hw_breakpoint.h  |  139 ++++++++++++++++++++++++++++++++++
 9 files changed, 255 insertions(+), 32 deletions(-)
 create mode 100644 arch/x86/include/asm/hw_breakpoint.h
 create mode 100644 include/asm-generic/hw_breakpoint.h

diff --git a/arch/x86/include/asm/a.out-core.h b/arch/x86/include/asm/a.out-core.h
index bb70e39..fc4685d 100644
--- a/arch/x86/include/asm/a.out-core.h
+++ b/arch/x86/include/asm/a.out-core.h
@@ -32,10 +32,10 @@ static inline void aout_dump_thread(struct pt_regs *regs, struct user *dump)
 			>> PAGE_SHIFT;
 	dump->u_dsize -= dump->u_tsize;
 	dump->u_ssize = 0;
-	dump->u_debugreg[0] = current->thread.debugreg0;
-	dump->u_debugreg[1] = current->thread.debugreg1;
-	dump->u_debugreg[2] = current->thread.debugreg2;
-	dump->u_debugreg[3] = current->thread.debugreg3;
+	dump->u_debugreg[0] = current->thread.debugreg[0];
+	dump->u_debugreg[1] = current->thread.debugreg[1];
+	dump->u_debugreg[2] = current->thread.debugreg[2];
+	dump->u_debugreg[3] = current->thread.debugreg[3];
 	dump->u_debugreg[4] = 0;
 	dump->u_debugreg[5] = 0;
 	dump->u_debugreg[6] = current->thread.debugreg6;
diff --git a/arch/x86/include/asm/debugreg.h b/arch/x86/include/asm/debugreg.h
index 3ea6f37..23439fb 100644
--- a/arch/x86/include/asm/debugreg.h
+++ b/arch/x86/include/asm/debugreg.h
@@ -18,6 +18,7 @@
 #define DR_TRAP1	(0x2)		/* db1 */
 #define DR_TRAP2	(0x4)		/* db2 */
 #define DR_TRAP3	(0x8)		/* db3 */
+#define DR_TRAP_BITS	(DR_TRAP0|DR_TRAP1|DR_TRAP2|DR_TRAP3)
 
 #define DR_STEP		(0x4000)	/* single-step */
 #define DR_SWITCH	(0x8000)	/* task switch */
@@ -49,6 +50,8 @@
 
 #define DR_LOCAL_ENABLE_SHIFT 0    /* Extra shift to the local enable bit */
 #define DR_GLOBAL_ENABLE_SHIFT 1   /* Extra shift to the global enable bit */
+#define DR_LOCAL_ENABLE (0x1)      /* Local enable for reg 0 */
+#define DR_GLOBAL_ENABLE (0x2)     /* Global enable for reg 0 */
 #define DR_ENABLE_SIZE 2           /* 2 enable bits per register */
 
 #define DR_LOCAL_ENABLE_MASK (0x55)  /* Set  local bits for all 4 regs */
@@ -67,4 +70,30 @@
 #define DR_LOCAL_SLOWDOWN (0x100)   /* Local slow the pipeline */
 #define DR_GLOBAL_SLOWDOWN (0x200)  /* Global slow the pipeline */
 
+/*
+ * HW breakpoint additions
+ */
+#ifdef __KERNEL__
+
+/* For process management */
+extern void flush_thread_hw_breakpoint(struct task_struct *tsk);
+extern int copy_thread_hw_breakpoint(struct task_struct *tsk,
+		struct task_struct *child, unsigned long clone_flags);
+
+/* For CPU management */
+extern void load_debug_registers(void);
+static inline void hw_breakpoint_disable(void)
+{
+	/* Zero the control register for HW Breakpoint */
+	set_debugreg(0UL, 7);
+
+	/* Zero-out the individual HW breakpoint address registers */
+	set_debugreg(0UL, 0);
+	set_debugreg(0UL, 1);
+	set_debugreg(0UL, 2);
+	set_debugreg(0UL, 3);
+}
+
+#endif	/* __KERNEL__ */
+
 #endif /* _ASM_X86_DEBUGREG_H */
diff --git a/arch/x86/include/asm/hw_breakpoint.h b/arch/x86/include/asm/hw_breakpoint.h
new file mode 100644
index 0000000..1acb4d4
--- /dev/null
+++ b/arch/x86/include/asm/hw_breakpoint.h
@@ -0,0 +1,55 @@
+#ifndef	_I386_HW_BREAKPOINT_H
+#define	_I386_HW_BREAKPOINT_H
+
+#ifdef	__KERNEL__
+#define	__ARCH_HW_BREAKPOINT_H
+
+struct arch_hw_breakpoint {
+	char		*name; /* Contains name of the symbol to set bkpt */
+	unsigned long	address;
+	u8		len;
+	u8		type;
+};
+
+#include <linux/kdebug.h>
+#include <asm-generic/hw_breakpoint.h>
+
+/* Available HW breakpoint length encodings */
+#define HW_BREAKPOINT_LEN_1		0x40
+#define HW_BREAKPOINT_LEN_2		0x44
+#define HW_BREAKPOINT_LEN_4		0x4c
+#define HW_BREAKPOINT_LEN_EXECUTE	0x40
+
+#ifdef CONFIG_X86_64
+#define HW_BREAKPOINT_LEN_8		0x48
+#endif
+
+/* Available HW breakpoint type encodings */
+
+/* trigger on instruction execute */
+#define HW_BREAKPOINT_EXECUTE	0x80
+/* trigger on memory write */
+#define HW_BREAKPOINT_WRITE	0x81
+/* trigger on memory read or write */
+#define HW_BREAKPOINT_RW	0x83
+
+/* Total number of available HW breakpoint registers */
+#define HBP_NUM 4
+
+extern struct hw_breakpoint *hbp_kernel[HBP_NUM];
+DECLARE_PER_CPU(struct hw_breakpoint*, this_hbp_kernel[HBP_NUM]);
+extern unsigned int hbp_user_refcount[HBP_NUM];
+
+extern void arch_install_thread_hw_breakpoint(struct task_struct *tsk);
+extern void arch_uninstall_thread_hw_breakpoint(void);
+extern int arch_check_va_in_userspace(unsigned long va, u8 hbp_len);
+extern int arch_validate_hwbkpt_settings(struct hw_breakpoint *bp,
+						struct task_struct *tsk);
+extern void arch_update_user_hw_breakpoint(int pos, struct task_struct *tsk);
+extern void arch_flush_thread_hw_breakpoint(struct task_struct *tsk);
+extern void arch_update_kernel_hw_breakpoint(void *);
+extern int hw_breakpoint_exceptions_notify(struct notifier_block *unused,
+				     unsigned long val, void *data);
+#endif	/* __KERNEL__ */
+#endif	/* _I386_HW_BREAKPOINT_H */
+
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 0b2fab0..448b34a 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -29,6 +29,7 @@ struct mm_struct;
 #include <linux/threads.h>
 #include <linux/init.h>
 
+#define HBP_NUM 4
 /*
  * Default implementation of macro that returns current
  * instruction pointer ("program counter").
@@ -431,12 +432,11 @@ struct thread_struct {
 	unsigned long		fs;
 	unsigned long		gs;
 	/* Hardware debugging registers: */
-	unsigned long		debugreg0;
-	unsigned long		debugreg1;
-	unsigned long		debugreg2;
-	unsigned long		debugreg3;
+	unsigned long		debugreg[HBP_NUM];
 	unsigned long		debugreg6;
 	unsigned long		debugreg7;
+	/* Hardware breakpoint info */
+	struct hw_breakpoint	*hbp[HBP_NUM];
 	/* Fault info: */
 	unsigned long		cr2;
 	unsigned long		trap_no;
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index fb5dfb8..291527c 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -106,10 +106,10 @@ void flush_thread(void)
 
 	clear_tsk_thread_flag(tsk, TIF_DEBUG);
 
-	tsk->thread.debugreg0 = 0;
-	tsk->thread.debugreg1 = 0;
-	tsk->thread.debugreg2 = 0;
-	tsk->thread.debugreg3 = 0;
+	tsk->thread.debugreg[0] = 0;
+	tsk->thread.debugreg[1] = 0;
+	tsk->thread.debugreg[2] = 0;
+	tsk->thread.debugreg[3] = 0;
 	tsk->thread.debugreg6 = 0;
 	tsk->thread.debugreg7 = 0;
 	memset(tsk->thread.tls_array, 0, sizeof(tsk->thread.tls_array));
@@ -194,10 +194,10 @@ void __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p,
 		update_debugctlmsr(next->debugctlmsr);
 
 	if (test_tsk_thread_flag(next_p, TIF_DEBUG)) {
-		set_debugreg(next->debugreg0, 0);
-		set_debugreg(next->debugreg1, 1);
-		set_debugreg(next->debugreg2, 2);
-		set_debugreg(next->debugreg3, 3);
+		set_debugreg(next->debugreg[0], 0);
+		set_debugreg(next->debugreg[1], 1);
+		set_debugreg(next->debugreg[2], 2);
+		set_debugreg(next->debugreg[3], 3);
 		/* no 4 and 5 */
 		set_debugreg(next->debugreg6, 6);
 		set_debugreg(next->debugreg7, 7);
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 09ecbde..313be40 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -471,10 +471,10 @@ static int genregs_set(struct task_struct *target,
 static unsigned long ptrace_get_debugreg(struct task_struct *child, int n)
 {
 	switch (n) {
-	case 0:		return child->thread.debugreg0;
-	case 1:		return child->thread.debugreg1;
-	case 2:		return child->thread.debugreg2;
-	case 3:		return child->thread.debugreg3;
+	case 0:		return child->thread.debugreg[0];
+	case 1:		return child->thread.debugreg[1];
+	case 2:		return child->thread.debugreg[2];
+	case 3:		return child->thread.debugreg[3];
 	case 6:		return child->thread.debugreg6;
 	case 7:		return child->thread.debugreg7;
 	}
@@ -493,10 +493,10 @@ static int ptrace_set_debugreg(struct task_struct *child,
 		return -EIO;
 
 	switch (n) {
-	case 0:		child->thread.debugreg0 = data; break;
-	case 1:		child->thread.debugreg1 = data; break;
-	case 2:		child->thread.debugreg2 = data; break;
-	case 3:		child->thread.debugreg3 = data; break;
+	case 0:		child->thread.debugreg[0] = data; break;
+	case 1:		child->thread.debugreg[1] = data; break;
+	case 2:		child->thread.debugreg[2] = data; break;
+	case 3:		child->thread.debugreg[3] = data; break;
 
 	case 6:
 		if ((data & ~0xffffffffUL) != 0)
diff --git a/arch/x86/power/cpu_32.c b/arch/x86/power/cpu_32.c
index ce702c5..5199139 100644
--- a/arch/x86/power/cpu_32.c
+++ b/arch/x86/power/cpu_32.c
@@ -84,10 +84,10 @@ static void fix_processor_context(void)
 	 * Now maybe reload the debug registers
 	 */
 	if (current->thread.debugreg7) {
-		set_debugreg(current->thread.debugreg0, 0);
-		set_debugreg(current->thread.debugreg1, 1);
-		set_debugreg(current->thread.debugreg2, 2);
-		set_debugreg(current->thread.debugreg3, 3);
+		set_debugreg(current->thread.debugreg[0], 0);
+		set_debugreg(current->thread.debugreg[1], 1);
+		set_debugreg(current->thread.debugreg[2], 2);
+		set_debugreg(current->thread.debugreg[3], 3);
 		/* no 4 and 5 */
 		set_debugreg(current->thread.debugreg6, 6);
 		set_debugreg(current->thread.debugreg7, 7);
diff --git a/arch/x86/power/cpu_64.c b/arch/x86/power/cpu_64.c
index 5343540..1e3bdcc 100644
--- a/arch/x86/power/cpu_64.c
+++ b/arch/x86/power/cpu_64.c
@@ -163,10 +163,10 @@ static void fix_processor_context(void)
 	 * Now maybe reload the debug registers
 	 */
 	if (current->thread.debugreg7){
-                loaddebug(&current->thread, 0);
-                loaddebug(&current->thread, 1);
-                loaddebug(&current->thread, 2);
-                loaddebug(&current->thread, 3);
+		set_debugreg(current->thread.debugreg[0], 0);
+		set_debugreg(current->thread.debugreg[1], 1);
+		set_debugreg(current->thread.debugreg[2], 2);
+		set_debugreg(current->thread.debugreg[3], 3);
                 /* no 4 and 5 */
                 loaddebug(&current->thread, 6);
                 loaddebug(&current->thread, 7);
diff --git a/include/asm-generic/hw_breakpoint.h b/include/asm-generic/hw_breakpoint.h
new file mode 100644
index 0000000..9bf2d12
--- /dev/null
+++ b/include/asm-generic/hw_breakpoint.h
@@ -0,0 +1,139 @@
+#ifndef	_ASM_GENERIC_HW_BREAKPOINT_H
+#define	_ASM_GENERIC_HW_BREAKPOINT_H
+
+#ifndef __ARCH_HW_BREAKPOINT_H
+#error "Please don't include this file directly"
+#endif
+
+#ifdef	__KERNEL__
+#include <linux/list.h>
+#include <linux/types.h>
+#include <linux/kallsyms.h>
+
+/**
+ * struct hw_breakpoint - unified kernel/user-space hardware breakpoint
+ * @triggered: callback invoked after target address access
+ * @info: arch-specific breakpoint info (address, length, and type)
+ *
+ * %hw_breakpoint structures are the kernel's way of representing
+ * hardware breakpoints.  These are data breakpoints
+ * (also known as "watchpoints", triggered on data access), and the breakpoint's
+ * target address can be located in either kernel space or user space.
+ *
+ * The breakpoint's address, length, and type are highly
+ * architecture-specific.  The values are encoded in the @info field; you
+ * specify them when registering the breakpoint.  To examine the encoded
+ * values use hw_breakpoint_get_{kaddress,uaddress,len,type}(), declared
+ * below.
+ *
+ * The address is specified as a regular kernel pointer (for kernel-space
+ * breakponts) or as an %__user pointer (for user-space breakpoints).
+ * With register_user_hw_breakpoint(), the address must refer to a
+ * location in user space.  The breakpoint will be active only while the
+ * requested task is running.  Conversely with
+ * register_kernel_hw_breakpoint(), the address must refer to a location
+ * in kernel space, and the breakpoint will be active on all CPUs
+ * regardless of the current task.
+ *
+ * The length is the breakpoint's extent in bytes, which is subject to
+ * certain limitations.  include/asm/hw_breakpoint.h contains macros
+ * defining the available lengths for a specific architecture.  Note that
+ * the address's alignment must match the length.  The breakpoint will
+ * catch accesses to any byte in the range from address to address +
+ * (length - 1).
+ *
+ * The breakpoint's type indicates the sort of access that will cause it
+ * to trigger.  Possible values may include:
+ *
+ * 	%HW_BREAKPOINT_RW (triggered on read or write access),
+ * 	%HW_BREAKPOINT_WRITE (triggered on write access), and
+ * 	%HW_BREAKPOINT_READ (triggered on read access).
+ *
+ * Appropriate macros are defined in include/asm/hw_breakpoint.h; not all
+ * possibilities are available on all architectures.  Execute breakpoints
+ * must have length equal to the special value %HW_BREAKPOINT_LEN_EXECUTE.
+ *
+ * When a breakpoint gets hit, the @triggered callback is
+ * invoked in_interrupt with a pointer to the %hw_breakpoint structure and the
+ * processor registers.
+ * Data breakpoints occur after the memory access has taken place.
+ * Breakpoints are disabled during execution @triggered, to avoid
+ * recursive traps and allow unhindered access to breakpointed memory.
+ *
+ * This sample code sets a breakpoint on pid_max and registers a callback
+ * function for writes to that variable.  Note that it is not portable
+ * as written, because not all architectures support HW_BREAKPOINT_LEN_4.
+ *
+ * ----------------------------------------------------------------------
+ *
+ * #include <asm/hw_breakpoint.h>
+ *
+ * struct hw_breakpoint my_bp;
+ *
+ * static void my_triggered(struct hw_breakpoint *bp, struct pt_regs *regs)
+ * {
+ * 	printk(KERN_DEBUG "Inside triggered routine of breakpoint exception\n");
+ * 	dump_stack();
+ *  	.......<more debugging output>........
+ * }
+ *
+ * static struct hw_breakpoint my_bp;
+ *
+ * static int init_module(void)
+ * {
+ *	..........<do anything>............
+ *	my_bp.info.type = HW_BREAKPOINT_WRITE;
+ *	my_bp.info.len = HW_BREAKPOINT_LEN_4;
+ *
+ *	my_bp.installed = (void *)my_bp_installed;
+ *
+ *	rc = register_kernel_hw_breakpoint(&my_bp);
+ *	..........<do anything>............
+ * }
+ *
+ * static void cleanup_module(void)
+ * {
+ *	..........<do anything>............
+ *	unregister_kernel_hw_breakpoint(&my_bp);
+ *	..........<do anything>............
+ * }
+ *
+ * ----------------------------------------------------------------------
+ */
+struct hw_breakpoint {
+	void (*triggered)(struct hw_breakpoint *, struct pt_regs *);
+	struct arch_hw_breakpoint info;
+};
+
+/*
+ * len and type values are defined in include/asm/hw_breakpoint.h.
+ * Available values vary according to the architecture.  On i386 the
+ * possibilities are:
+ *
+ *	HW_BREAKPOINT_LEN_1
+ *	HW_BREAKPOINT_LEN_2
+ *	HW_BREAKPOINT_LEN_4
+ *	HW_BREAKPOINT_RW
+ *	HW_BREAKPOINT_READ
+ *
+ * On other architectures HW_BREAKPOINT_LEN_8 may be available, and the
+ * 1-, 2-, and 4-byte lengths may be unavailable.  There also may be
+ * HW_BREAKPOINT_WRITE.  You can use #ifdef to check at compile time.
+ */
+
+extern int register_user_hw_breakpoint(struct task_struct *tsk,
+					struct hw_breakpoint *bp);
+extern int modify_user_hw_breakpoint(struct task_struct *tsk,
+					struct hw_breakpoint *bp);
+extern void unregister_user_hw_breakpoint(struct task_struct *tsk,
+						struct hw_breakpoint *bp);
+/*
+ * Kernel breakpoints are not associated with any particular thread.
+ */
+extern int register_kernel_hw_breakpoint(struct hw_breakpoint *bp);
+extern void unregister_kernel_hw_breakpoint(struct hw_breakpoint *bp);
+
+extern unsigned int hbp_kernel_pos;
+
+#endif	/* __KERNEL__ */
+#endif	/* _ASM_GENERIC_HW_BREAKPOINT_H */
-- 
1.6.2.3

