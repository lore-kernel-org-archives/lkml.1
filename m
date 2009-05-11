Return-Path: <linux-kernel-owner+w=401wt.eu-S1758265AbZEKLx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758265AbZEKLx0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 07:53:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758070AbZEKLxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 07:53:13 -0400
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:39903 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758238AbZEKLxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 07:53:12 -0400
Date: Mon, 11 May 2009 17:23:03 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>, maneesh@linux.vnet.ibm.com,
       Roland McGrath <roland@redhat.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: [Patch 03/12] x86 architecture implementation of Hardware
	Breakpoint interfaces
Message-ID: <20090511115303.GD25673@in.ibm.com>
References: <20090511114422.133566343@prasadkr_t60p.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=arch_x86_hwbkpt_03
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces the arch-specific implementation of hw_breakpoint.c
inside x86 specific directories. They contain functions which help validate and
serve requests for using Hardware Breakpoint registers on x86 processors.

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
---
 arch/x86/Kconfig                |    1 
 arch/x86/kernel/Makefile        |    2 
 arch/x86/kernel/hw_breakpoint.c |  358 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 360 insertions(+), 1 deletion(-)

Index: arch/x86/Kconfig
===================================================================
--- arch/x86/Kconfig.orig
+++ arch/x86/Kconfig
@@ -47,6 +47,7 @@ config X86
 	select HAVE_KERNEL_BZIP2
 	select HAVE_KERNEL_LZMA
 	select HAVE_ARCH_KMEMCHECK
+	select HAVE_HW_BREAKPOINT
 
 config OUTPUT_FORMAT
 	string
Index: arch/x86/kernel/Makefile
===================================================================
--- arch/x86/kernel/Makefile.orig
+++ arch/x86/kernel/Makefile
@@ -36,7 +36,7 @@ obj-$(CONFIG_X86_64)	+= sys_x86_64.o x86
 obj-$(CONFIG_X86_64)	+= syscall_64.o vsyscall_64.o
 obj-y			+= bootflag.o e820.o
 obj-y			+= pci-dma.o quirks.o i8237.o topology.o kdebugfs.o
-obj-y			+= alternative.o i8253.o pci-nommu.o
+obj-y			+= alternative.o i8253.o pci-nommu.o hw_breakpoint.o
 obj-y			+= tsc.o io_delay.o rtc.o
 
 obj-$(CONFIG_X86_TRAMPOLINE)	+= trampoline.o
Index: arch/x86/kernel/hw_breakpoint.c
===================================================================
--- /dev/null
+++ arch/x86/kernel/hw_breakpoint.c
@@ -0,0 +1,358 @@
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
+void arch_update_kernel_hw_breakpoints(void *unused)
+{
+	struct hw_breakpoint *bp;
+	int i, cpu = get_cpu();
+
+	/* Don't allow debug exceptions while we update the registers */
+	set_debugreg(0UL, 7);
+
+	/* Clear all kernel-space breakpoints in kdr7 */
+	kdr7 = 0;
+	for (i = hbp_kernel_pos; i < HB_NUM; i++) {
+		per_cpu(this_hbp_kernel[i], cpu) = bp = hbp_kernel[i];
+		if (bp) {
+			kdr7 |= encode_dr7(i, bp->info.len, bp->info.type);
+			set_debugreg(hbp_kernel[i]->info.address, i);
+		}
+	}
+
+	/* No need to set DR6. Update the debug registers with kernel-space
+	 * breakpoint values from kdr7 and user-space requests from the
+	 * current process
+	 */
+	set_debugreg(kdr7 | current->thread.debugreg7, 7);
+	put_cpu_no_resched();
+}
+
+/*
+ * Install the thread breakpoints in their debug registers.
+ */
+void arch_install_thread_hw_breakpoint(struct task_struct *tsk)
+{
+	struct thread_struct *thread = &(tsk->thread);
+
+	switch (hbp_kernel_pos) {
+	case 4:
+		set_debugreg(thread->debugreg[3], 3);
+	case 3:
+		set_debugreg(thread->debugreg[2], 2);
+	case 2:
+		set_debugreg(thread->debugreg[1], 1);
+	case 1:
+		set_debugreg(thread->debugreg[0], 0);
+	default:
+		break;
+	}
+
+	/* No need to set DR6 */
+	set_debugreg((kdr7 | thread->debugreg7), 7);
+}
+
+/*
+ * Install the debug register values for just the kernel, no thread.
+ */
+void arch_uninstall_thread_hw_breakpoint()
+{
+	/* Clear the user-space portion of debugreg7 by setting only kdr7 */
+	set_debugreg(kdr7, 7);
+
+}
+
+static int get_hbp_len(u8 hbp_len)
+{
+	unsigned int len_in_bytes = 0;
+
+	switch (hbp_len) {
+	case HW_BREAKPOINT_LEN_1:
+		len_in_bytes = 1;
+		break;
+	case HW_BREAKPOINT_LEN_2:
+		len_in_bytes = 2;
+		break;
+	case HW_BREAKPOINT_LEN_4:
+		len_in_bytes = 4;
+		break;
+#ifdef CONFIG_X86_64
+	case HW_BREAKPOINT_LEN_8:
+		len_in_bytes = 8;
+		break;
+#endif
+	}
+	return len_in_bytes;
+}
+
+/*
+ * Check for virtual address in user space.
+ */
+int arch_check_va_in_userspace(unsigned long va, u8 hbp_len)
+{
+	unsigned int len;
+
+	len = get_hbp_len(hbp_len);
+
+	return (va <= TASK_SIZE - len);
+}
+
+/*
+ * Check for virtual address in kernel space.
+ */
+int arch_check_va_in_kernelspace(unsigned long va, u8 hbp_len)
+{
+	unsigned int len;
+
+	len = get_hbp_len(hbp_len);
+
+	return (va >= TASK_SIZE) && ((va + len - 1) >= TASK_SIZE);
+}
+
+/*
+ * Store a breakpoint's encoded address, length, and type.
+ */
+static int arch_store_info(struct hw_breakpoint *bp)
+{
+	/*
+	 * User-space requests will always have the address field populated
+	 * For kernel-addresses, either the address or symbol name can be
+	 * specified.
+	 */
+	if (bp->info.name)
+		bp->info.address = (unsigned long)
+					kallsyms_lookup_name(bp->info.name);
+	if (bp->info.address)
+		return 0;
+	return -EINVAL;
+}
+
+/*
+ * Validate the arch-specific HW Breakpoint register settings
+ */
+int arch_validate_hwbkpt_settings(struct hw_breakpoint *bp,
+						struct task_struct *tsk)
+{
+	unsigned int align;
+	int ret = -EINVAL;
+
+	switch (bp->info.type) {
+	/*
+	 * Ptrace-refactoring code
+	 * For now, we'll allow instruction breakpoint only for user-space
+	 * addresses
+	 */
+	case HW_BREAKPOINT_EXECUTE:
+		if ((!arch_check_va_in_userspace(bp->info.address,
+							bp->info.len)) &&
+			bp->info.len != HW_BREAKPOINT_LEN_EXECUTE)
+			return ret;
+		break;
+	case HW_BREAKPOINT_WRITE:
+		break;
+	case HW_BREAKPOINT_RW:
+		break;
+	default:
+		return ret;
+	}
+
+	switch (bp->info.len) {
+	case HW_BREAKPOINT_LEN_1:
+		align = 0;
+		break;
+	case HW_BREAKPOINT_LEN_2:
+		align = 1;
+		break;
+	case HW_BREAKPOINT_LEN_4:
+		align = 3;
+		break;
+#ifdef CONFIG_X86_64
+	case HW_BREAKPOINT_LEN_8:
+		align = 7;
+		break;
+#endif
+	default:
+		return ret;
+	}
+
+	if (bp->triggered)
+		ret = arch_store_info(bp);
+
+	if (ret < 0)
+		return ret;
+	/*
+	 * Check that the low-order bits of the address are appropriate
+	 * for the alignment implied by len.
+	 */
+	if (bp->info.address & align)
+		return -EINVAL;
+
+	/* Check that the virtual address is in the proper range */
+	if (tsk) {
+		if (!arch_check_va_in_userspace(bp->info.address, bp->info.len))
+			return -EFAULT;
+	} else {
+		if (!arch_check_va_in_kernelspace(bp->info.address,
+								bp->info.len))
+			return -EFAULT;
+	}
+	return 0;
+}
+
+void arch_update_user_hw_breakpoint(int pos, struct task_struct *tsk)
+{
+	struct thread_struct *thread = &(tsk->thread);
+	struct hw_breakpoint *bp = thread->hbp[pos];
+
+	thread->debugreg7 &= ~dr7_masks[pos];
+	if (bp) {
+		thread->debugreg[pos] = bp->info.address;
+		thread->debugreg7 |= encode_dr7(pos, bp->info.len,
+							bp->info.type);
+	} else
+		thread->debugreg[pos] = 0;
+}
+
+void arch_flush_thread_hw_breakpoint(struct task_struct *tsk)
+{
+	int i;
+	struct thread_struct *thread = &(tsk->thread);
+
+	thread->debugreg7 = 0;
+	for (i = 0; i < HB_NUM; i++)
+		thread->debugreg[i] = 0;
+}
+
+/*
+ * Handle debug exception notifications.
+ */
+int __kprobes hw_breakpoint_handler(struct die_args *args)
+{
+	int i, cpu, rc = NOTIFY_STOP;
+	struct hw_breakpoint *bp;
+	/* The DR6 value is stored in args->err */
+	unsigned long dr7, dr6 = args->err;
+
+	/* Do an early return if no trap bits are set in DR6 */
+	if ((dr6 & DR_TRAP_BITS) == 0)
+		return NOTIFY_DONE;
+
+	/* Lazy debug register switching */
+	if (!test_tsk_thread_flag(current, TIF_DEBUG))
+		switch_to_none_hw_breakpoint();
+
+	get_debugreg(dr7, 7);
+	/* Disable breakpoints during exception handling */
+	set_debugreg(0UL, 7);
+	/*
+	 * Assert that local interrupts are disabled
+	 * Reset the DRn bits in the virtualized register value.
+	 * The ptrace trigger routine will add in whatever is needed.
+	 */
+	current->thread.debugreg6 &= ~DR_TRAP_BITS;
+	cpu = get_cpu();
+
+	/* Handle all the breakpoints that were triggered */
+	for (i = 0; i < HB_NUM; ++i) {
+		if (likely(!(dr6 & (DR_TRAP0 << i))))
+			continue;
+		/*
+		 * Find the corresponding hw_breakpoint structure and
+		 * invoke its triggered callback.
+		 */
+		if (i >= hbp_kernel_pos)
+			bp = per_cpu(this_hbp_kernel[i], cpu);
+		else {
+			bp = current->thread.hbp[i];
+			/* False alarm due to lazy DR switching */
+			if (!bp)
+				continue;
+			rc = NOTIFY_DONE;
+		}
+		(bp->triggered)(bp, args->regs);
+	}
+	if (dr6 & (~DR_TRAP_BITS))
+		rc = NOTIFY_DONE;
+
+	set_debugreg(dr7, 7);
+	put_cpu_no_resched();
+	return rc;
+}
+
+/*
+ * Handle debug exception notifications.
+ */
+int __kprobes hw_breakpoint_exceptions_notify(
+		struct notifier_block *unused, unsigned long val, void *data)
+{
+	if (val != DIE_DEBUG)
+		return NOTIFY_DONE;
+
+	return hw_breakpoint_handler(data);
+}

