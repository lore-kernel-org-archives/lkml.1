Return-Path: <linux-kernel-owner+w=401wt.eu-S1761750AbZCSXsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761750AbZCSXsy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 19:48:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761781AbZCSXsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 19:48:43 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:59542 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761665AbZCSXsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 19:48:42 -0400
Date: Fri, 20 Mar 2009 05:18:24 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Roland McGrath <roland@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>
Subject: [Patch 02/11] x86 architecture implementation of Hardware
	Breakpoint interfaces
Message-ID: <20090319234824.GC10517@in.ibm.com>
References: <20090319234044.410725944@K.Prasad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=2
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces two new files named hw_breakpoint.[ch] inside x86 specific
directories. They contain functions which help validate and serve requests for 
using Hardware Breakpoint registers on x86 processors.

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
---
 arch/x86/Kconfig                     |    1 
 arch/x86/include/asm/hw_breakpoint.h |   69 ++++++
 arch/x86/kernel/Makefile             |    2 
 arch/x86/kernel/hw_breakpoint.c      |  384 +++++++++++++++++++++++++++++++++++
 4 files changed, 455 insertions(+), 1 deletion(-)

Index: linux-2.6-tip.hbkpt/arch/x86/kernel/hw_breakpoint.c
===================================================================
--- /dev/null
+++ linux-2.6-tip.hbkpt/arch/x86/kernel/hw_breakpoint.c
@@ -0,0 +1,384 @@
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright (C) 2007 Alan Stern
+ * Copyright (C) 2009 IBM Corporation
+ */
+
+/*
+ * HW_breakpoint: a unified kernel/user-space hardware breakpoint facility,
+ * using the CPU's debug registers.
+ */
+
+#include <linux/irqflags.h>
+#include <linux/notifier.h>
+#include <linux/kallsyms.h>
+#include <linux/kprobes.h>
+#include <linux/percpu.h>
+#include <linux/kdebug.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/sched.h>
+#include <linux/init.h>
+#include <linux/smp.h>
+
+#include <asm/hw_breakpoint.h>
+#include <asm/processor.h>
+#include <asm/debugreg.h>
+
+/* Unmasked kernel DR7 value */
+static unsigned long kdr7;
+
+/*
+ * Masks for the bits corresponding to registers DR0 - DR3 in DR7 register.
+ * Used to clear and verify the status of bits corresponding to DR0 - DR3
+ */
+static const unsigned long	dr7_masks[HB_NUM] = {
+	0x000f0003,	/* LEN0, R/W0, G0, L0 */
+	0x00f0000c,	/* LEN1, R/W1, G1, L1 */
+	0x0f000030,	/* LEN2, R/W2, G2, L2 */
+	0xf00000c0	/* LEN3, R/W3, G3, L3 */
+};
+
+
+/*
+ * Encode the length, type, Exact, and Enable bits for a particular breakpoint
+ * as stored in debug register 7.
+ */
+static unsigned long encode_dr7(int drnum, unsigned len, unsigned type)
+{
+	unsigned long temp;
+
+	temp = (len | type) & 0xf;
+	temp <<= (DR_CONTROL_SHIFT + drnum * DR_CONTROL_SIZE);
+	temp |= (DR_GLOBAL_ENABLE << (drnum * DR_ENABLE_SIZE)) |
+				DR_GLOBAL_SLOWDOWN;
+	return temp;
+}
+
+/*
+ * Install the kernel breakpoints in their debug registers.
+ */
+void arch_install_kernel_hbkpt(void *bkpt)
+{
+	struct hw_breakpoint *bp;
+	int i;
+	unsigned long dr7;
+
+	bp = (struct hw_breakpoint *)bkpt;
+
+	kdr7 &= ~(dr7_masks[hbkpt_kernel_pos]);
+	kdr7 |= encode_dr7(hbkpt_kernel_pos, bp->info.len, bp->info.type);
+
+	get_debugreg(dr7, 7);
+	/* Clear the bits corresponding to 'pos' register in dr7 */
+	dr7 &= ~(dr7_masks[hbkpt_kernel_pos]);
+	dr7 |= kdr7;
+
+	/* Don't allow debug exceptions while we update the registers */
+	set_debugreg(0UL, 7);
+
+	/* Kernel hbkpts always begin at 'hbkpt_kernel_pos' and upto HB_NUM */
+	for (i = hbkpt_kernel_pos; i < HB_NUM; i++)
+		set_debugreg(hbkpt_kernel[i]->info.address, i);
+
+	/* No need to set DR6 */
+	set_debugreg(dr7, 7);
+}
+
+/*
+ * Install the thread breakpoints in their debug registers.
+ */
+void arch_install_thread_hbkpt(struct task_struct *tsk)
+{
+	int i;
+	struct thread_struct *thread = &(tsk->thread);
+
+	for (i = 0; i < hbkpt_user_max; i++)
+		if (thread->hbkpt[i])
+			set_debugreg(thread->hbkpt[i]->info.address, i);
+
+	/* No need to set DR6 */
+
+	set_debugreg((kdr7 | thread->dr7), 7);
+}
+
+/*
+ * Install the debug register values for just the kernel, no thread.
+ */
+void arch_install_none()
+{
+	/* Clear the user-space portion of dr7 by setting only kdr7 */
+	set_debugreg(kdr7, 7);
+}
+
+/*
+ * Check for virtual address in user space.
+ */
+int arch_check_va_in_userspace(unsigned long va, struct task_struct *tsk)
+{
+#ifdef CONFIG_X86_32
+	return (va <= TASK_SIZE - 3);
+#else /* X86_64 */
+	return (va <= TASK_SIZE - 7);
+#endif
+}
+
+/*
+ * Check for virtual address in kernel space.
+ */
+int arch_check_va_in_kernelspace(unsigned long va)
+{
+	return (va >= TASK_SIZE);
+}
+
+/*
+ * Store a breakpoint's encoded address, length, and type.
+ */
+void arch_store_info(struct hw_breakpoint *bp)
+{
+	/*
+	 * User-space requests will always have the address field populated
+	 * For kernel-addresses, either the address or symbol name can be
+	 * specified.
+	 */
+	if (bp->info.address)
+		return;
+	if (bp->info.name)
+		bp->info.address = (unsigned long)
+					kallsyms_lookup_name(bp->info.name);
+}
+
+/*
+ * Validate the arch-specific HW Breakpoint register settings
+ */
+int arch_validate_hwbkpt_settings(struct hw_breakpoint *bp,
+				unsigned int *align, struct task_struct *tsk)
+{
+	int ret = -EINVAL;
+
+	switch (bp->info.type) {
+
+	/* Ptrace-refactoring code
+	 * For now, we'll allow instruction breakpoint only for user-space
+	 * addresses
+	 */
+	case HW_BREAKPOINT_EXECUTE:
+		if ((!arch_check_va_in_userspace(bp->info.address, tsk)) &&
+			bp->info.len != HW_BREAKPOINT_LEN_EXECUTE)
+			return ret;
+		break;
+	case HW_BREAKPOINT_WRITE:
+				break;
+	case HW_BREAKPOINT_RW:
+				break;
+	default:
+		return ret;
+	}
+
+	switch (bp->info.len) {
+	case HW_BREAKPOINT_LEN_1:
+		*align = 0;
+		break;
+	case HW_BREAKPOINT_LEN_2:
+		*align = 1;
+		break;
+	case HW_BREAKPOINT_LEN_4:
+		*align = 3;
+		break;
+	default:
+		return ret;
+	}
+
+	if (bp->triggered) {
+		ret = 0;
+		arch_store_info(bp);
+	}
+	return ret;
+}
+
+/*
+ * Register a new user breakpoint structure.
+ */
+void arch_register_user_hw_breakpoint(int pos, struct hw_breakpoint *bp,
+		struct task_struct *tsk)
+{
+	struct thread_struct *thread = &(tsk->thread);
+
+	thread->dr7 &= ~dr7_masks[pos];
+	thread->dr7 |= encode_dr7(pos, bp->info.len, bp->info.type);
+}
+
+/*
+ * Modify an existing user breakpoint structure.
+ */
+int arch_modify_user_hw_breakpoint(int pos, struct hw_breakpoint *bp,
+		struct task_struct *tsk)
+{
+	struct thread_struct *thread = &(tsk->thread);
+
+	/* Check if the register to be modified was enabled by the thread */
+	if (!(thread->dr7 & (1 << (pos * DR_ENABLE_SIZE))))
+		return -EINVAL;
+
+	thread->dr7 &= ~dr7_masks[pos];
+	thread->dr7 |= encode_dr7(pos, bp->info.len, bp->info.type);
+
+	return 0;
+}
+
+/*
+ * Unregister a user breakpoint structure.
+ */
+void arch_unregister_user_hw_breakpoint(int pos, struct hw_breakpoint *bp,
+					struct task_struct *tsk)
+{
+	struct thread_struct *thread = &(tsk->thread);
+
+	if (!thread->hbkpt[pos])
+		return;
+
+	thread->hbkpt[pos]->info.address = 0;
+	thread->dr7 &= ~dr7_masks[pos];
+}
+
+/*
+ * Register a kernel breakpoint structure.
+ */
+void arch_register_kernel_hw_breakpoint(struct hw_breakpoint *bp)
+{
+	on_each_cpu(arch_install_kernel_hbkpt, (void *)bp, 0);
+}
+
+/*
+ * Unregister a kernel breakpoint structure.
+ */
+void arch_unregister_kernel_hw_breakpoint(int pos)
+{
+	unsigned long dr7;
+
+	kdr7 &= ~(dr7_masks[pos]);
+
+	get_debugreg(dr7, 7);
+	dr7  &= ~(dr7_masks[pos]);
+	set_debugreg(dr7, 7);
+}
+
+/* End of arch-specific hook routines */
+
+/*
+ * Copy out the debug register information for a core dump.
+ *
+ * tsk must be equal to current.
+ */
+void dump_thread_hw_breakpoint(struct task_struct *tsk, int u_debugreg[8])
+{
+	struct thread_struct *thread = &(tsk->thread);
+	int i;
+
+	memset(u_debugreg, 0, sizeof u_debugreg);
+	for (i = 0; i < thread->hbkpt_num_installed && thread->hbkpt[i]; ++i)
+		u_debugreg[i] = thread->hbkpt[i]->info.address;
+	u_debugreg[7] = thread->dr7;
+	u_debugreg[6] = thread->dr6;
+}
+
+/*
+ * Handle debug exception notifications.
+ */
+int __kprobes hw_breakpoint_handler(struct die_args *args)
+{
+	int i;
+	struct hw_breakpoint *bp;
+	/* The DR6 value is stored in args->err */
+	unsigned long dr7, dr6 = args->err;
+
+	if (dr6 & DR_STEP)
+		return NOTIFY_DONE;
+
+	get_debugreg(dr7, 7);
+
+	/* Disable breakpoints during exception handling */
+	set_debugreg(0UL, 7);
+
+	/* Assert that local interrupts are disabled
+	 * Reset the DRn bits in the virtualized register value.
+	 * The ptrace trigger routine will add in whatever is needed.
+	 */
+	current->thread.dr6 &= ~(DR_TRAP0|DR_TRAP1|DR_TRAP2|DR_TRAP3);
+
+	/* Lazy debug register switching */
+	if (last_debugged_task != current)
+		switch_to_none_hw_breakpoint();
+
+	/* Handle all the breakpoints that were triggered */
+	for (i = 0; i < HB_NUM; ++i) {
+		if (likely(!(dr6 & (DR_TRAP0 << i))))
+			continue;
+
+		/* Find the corresponding hw_breakpoint structure and
+		 * invoke its triggered callback.
+		 */
+		if (i < hbkpt_user_max)
+			bp = current->thread.hbkpt[i];
+		else if (i >= hbkpt_kernel_pos)
+			bp = hbkpt_kernel[i];
+		else		/* False alarm due to lazy DR switching */
+			continue;
+		if (!bp)
+			goto ret_path;
+
+		switch (bp->info.type) {
+		case HW_BREAKPOINT_WRITE:
+		case HW_BREAKPOINT_RW:
+			if (bp->triggered)
+				(bp->triggered)(bp, args->regs);
+			/* Re-enable the breakpoints */
+			put_cpu_no_resched();
+			if (arch_check_va_in_userspace(bp->info.address,
+							current))
+				goto ret_notify_done;
+			else
+				goto ret_notify_stop;
+		/*
+		 * Presently we allow instruction breakpoints only in
+		 * user-space when requested through ptrace.
+		 */
+		case HW_BREAKPOINT_EXECUTE:
+			if (arch_check_va_in_userspace(bp->info.address,
+							current)) {
+				(bp->triggered)(bp, args->regs);
+			/*
+			 * do_debug will notify user through a SIGTRAP signal
+			 * So we are not requesting a NOTIFY_STOP here
+			 */
+				goto ret_notify_done;
+			}
+		}
+	}
+
+ret_path:
+	/* Stop processing further if the exception is a stray one */
+	if (!(dr6 & ~(DR_TRAP0|DR_TRAP1|DR_TRAP2|DR_TRAP3)))
+		goto ret_notify_stop;
+
+ret_notify_done:
+	set_debugreg(dr7, 7);
+	return NOTIFY_DONE;
+ret_notify_stop:
+	set_debugreg(dr7, 7);
+	return NOTIFY_STOP;
+}
Index: linux-2.6-tip.hbkpt/arch/x86/include/asm/hw_breakpoint.h
===================================================================
--- /dev/null
+++ linux-2.6-tip.hbkpt/arch/x86/include/asm/hw_breakpoint.h
@@ -0,0 +1,69 @@
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
+#define HB_NUM 4
+
+extern struct hw_breakpoint *hbkpt_kernel[HB_NUM];
+extern unsigned int hbkpt_user_max_refcount[HB_NUM];
+
+/*
+ * Ptrace support: breakpoint trigger routine.
+ */
+int __register_user_hw_breakpoint(int pos, struct task_struct *tsk,
+			struct hw_breakpoint *bp);
+int __modify_user_hw_breakpoint(int pos, struct task_struct *tsk,
+			struct hw_breakpoint *bp);
+void __unregister_user_hw_breakpoint(int pos, struct task_struct *tsk,
+			struct hw_breakpoint *bp);
+
+void arch_install_thread_hbkpt(struct task_struct *tsk);
+void arch_install_none(void);
+void arch_install_kernel_hbkpt(void *);
+int arch_check_va_in_userspace(unsigned long va,
+						struct task_struct *tsk);
+int arch_check_va_in_kernelspace(unsigned long va);
+void arch_store_info(struct hw_breakpoint *bp);
+int arch_validate_hwbkpt_settings(struct hw_breakpoint *bp,
+				unsigned int *align, struct task_struct *tsk);
+void arch_register_user_hw_breakpoint(int pos, struct hw_breakpoint *bp,
+				struct task_struct *tsk);
+int arch_modify_user_hw_breakpoint(int pos, struct hw_breakpoint *bp,
+				struct task_struct *tsk);
+void arch_unregister_user_hw_breakpoint(int pos, struct hw_breakpoint *bp,
+					struct task_struct *tsk);
+void arch_register_kernel_hw_breakpoint(struct hw_breakpoint *bp);
+void arch_unregister_kernel_hw_breakpoint(int pos);
+int hw_breakpoint_handler(struct die_args *args);
+
+#endif	/* __KERNEL__ */
+#endif	/* _I386_HW_BREAKPOINT_H */
+
Index: linux-2.6-tip.hbkpt/arch/x86/kernel/Makefile
===================================================================
--- linux-2.6-tip.hbkpt.orig/arch/x86/kernel/Makefile
+++ linux-2.6-tip.hbkpt/arch/x86/kernel/Makefile
@@ -36,7 +36,7 @@ obj-$(CONFIG_X86_64)	+= sys_x86_64.o x86
 obj-$(CONFIG_X86_64)	+= syscall_64.o vsyscall_64.o
 obj-y			+= bootflag.o e820.o
 obj-y			+= pci-dma.o quirks.o i8237.o topology.o kdebugfs.o
-obj-y			+= alternative.o i8253.o pci-nommu.o
+obj-y			+= alternative.o i8253.o pci-nommu.o hw_breakpoint.o
 obj-y			+= tsc.o io_delay.o rtc.o
 
 obj-$(CONFIG_X86_TRAMPOLINE)	+= trampoline.o
Index: linux-2.6-tip.hbkpt/arch/x86/Kconfig
===================================================================
--- linux-2.6-tip.hbkpt.orig/arch/x86/Kconfig
+++ linux-2.6-tip.hbkpt/arch/x86/Kconfig
@@ -46,6 +46,7 @@ config X86
 	select HAVE_KERNEL_BZIP2
 	select HAVE_KERNEL_LZMA
 	select HAVE_ARCH_KMEMCHECK
+	select HAVE_HW_BREAKPOINT
 
 config ARCH_DEFCONFIG
 	string

