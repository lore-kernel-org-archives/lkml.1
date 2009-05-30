Return-Path: <linux-kernel-owner+w=401wt.eu-S1760786AbZE3KtI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760786AbZE3KtI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 06:49:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759987AbZE3Ks4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 06:48:56 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:41921 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757581AbZE3Ksy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 06:48:54 -0400
Date: Sat, 30 May 2009 16:18:47 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Alan Stern <stern@rowland.harvard.edu>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>
Subject: [Patch 01/12] Prepare the code for Hardware Breakpoint interfaces
Message-ID: <20090530104847.GB9512@in.ibm.com>
References: <20090530103857.715014561@prasadkr_t60p.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=definitions_to_prepare_for_hwbkpt_01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces header files containing constants, structure definitions
and declaration of functions used by the hardware breakpoint interface code.

Original-patch-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
---
 arch/x86/include/asm/debugreg.h      |   29 +++++++
 arch/x86/include/asm/hw_breakpoint.h |   55 +++++++++++++
 arch/x86/include/asm/processor.h     |    4 +
 include/asm-generic/hw_breakpoint.h  |  139 +++++++++++++++++++++++++++++++++++
 4 files changed, 227 insertions(+)

Index: linux-2.6-tip.hbkpt/arch/x86/include/asm/debugreg.h
===================================================================
--- linux-2.6-tip.hbkpt.orig/arch/x86/include/asm/debugreg.h
+++ linux-2.6-tip.hbkpt/arch/x86/include/asm/debugreg.h
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
Index: linux-2.6-tip.hbkpt/arch/x86/include/asm/hw_breakpoint.h
===================================================================
--- /dev/null
+++ linux-2.6-tip.hbkpt/arch/x86/include/asm/hw_breakpoint.h
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
Index: linux-2.6-tip.hbkpt/arch/x86/include/asm/processor.h
===================================================================
--- linux-2.6-tip.hbkpt.orig/arch/x86/include/asm/processor.h
+++ linux-2.6-tip.hbkpt/arch/x86/include/asm/processor.h
@@ -29,6 +29,7 @@ struct mm_struct;
 #include <linux/threads.h>
 #include <linux/init.h>
 
+#define HBP_NUM 4
 /*
  * Default implementation of macro that returns current
  * instruction pointer ("program counter").
@@ -437,8 +438,11 @@ struct thread_struct {
 	unsigned long		debugreg1;
 	unsigned long		debugreg2;
 	unsigned long		debugreg3;
+	unsigned long		debugreg[HBP_NUM];
 	unsigned long		debugreg6;
 	unsigned long		debugreg7;
+	/* Hardware breakpoint info */
+	struct hw_breakpoint	*hbp[HBP_NUM];
 	/* Fault info: */
 	unsigned long		cr2;
 	unsigned long		trap_no;
Index: linux-2.6-tip.hbkpt/include/asm-generic/hw_breakpoint.h
===================================================================
--- /dev/null
+++ linux-2.6-tip.hbkpt/include/asm-generic/hw_breakpoint.h
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

