Return-Path: <linux-kernel-owner+w=401wt.eu-S1758732AbZDGGhF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758732AbZDGGhF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 02:37:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758119AbZDGGg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 02:36:28 -0400
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:55943 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758346AbZDGGg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 02:36:26 -0400
Date: Tue, 7 Apr 2009 12:05:55 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, maneesh@linux.vnet.ibm.com,
       Roland McGrath <roland@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [Patch 03/11] x86 architecture implementation of Hardware
	Breakpoint interfaces
Message-ID: <20090407063555.GD17461@in.ibm.com>
References: <20090407063058.301701787@prasadkr_t60p.in.ibm.com>
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
 arch/x86/kernel/hw_breakpoint.c |  379 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 381 insertions(+), 1 deletion(-)

Index: arch/x86/Kconfig
===================================================================
--- arch/x86/Kconfig.orig
+++ arch/x86/Kconfig
@@ -47,6 +47,7 @@ config X86
 	select HAVE_KERNEL_LZMA
 	select HAVE_ARCH_KMEMCHECK
 	select HAVE_DMA_API_DEBUG
+	select HAVE_HW_BREAKPOINT
 
 config ARCH_DEFCONFIG
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
@@ -0,0 +1,379 @@
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
+static const unsigned long	kdr7_masks[HB_NUM] = {
+	0xffff00ff,	/* Same for 3, 2, 1, 0 */
+	0xfff000fc,	/* Same for 3, 2, 1 */
+	0xff0000f0,	/* Same for 3, 2 */
+	0xf00f00c0	/* LEN3, R/W3, G3, L3 */
+};
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
+	unsigned long dr7;
+	int i;
+
+	/* Check if there is nothing to update */
+	if (hbp_kernel_pos == HB_NUM)
+		return;
+
+	get_debugreg(dr7, 7);
+
+	/* Don't allow debug exceptions while we update the registers */
+	set_debugreg(0UL, 7);
+
+	/* Clear all kernel-space bits in kdr7 and dr7 before we set them */
+	kdr7 &= ~kdr7_masks[hbp_kernel_pos];
+	dr7 &= ~kdr7_masks[hbp_kernel_pos];
+
+	for (i = hbp_kernel_pos; i < HB_NUM; i++) {
+		bp = hbp_kernel[i];
+		if (bp) {
+			kdr7 |= encode_dr7(i, bp->info.len, bp->info.type);
+			set_debugreg(hbp_kernel[i]->info.address, i);
+		}
+	}
+
+	dr7 |= kdr7;
+
+	/* No need to set DR6 */
+	set_debugreg(dr7, 7);
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
+						struct task_struct *tsk)
+{
+	unsigned int align;
+	int ret = -EINVAL;
+
+	switch (bp->info.type) {
+
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
+	/*
+	 * Check that the low-order bits of the address are appropriate
+	 * for the alignment implied by len.
+	 */
+	if (bp->info.address & align)
+		return ret;
+
+	if (bp->triggered) {
+		ret = 0;
+		arch_store_info(bp);
+	}
+	return ret;
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
+
+	for (i = 0; i < HB_NUM; ++i)
+		u_debugreg[i] = thread->debugreg[i];
+
+	u_debugreg[6] = thread->debugreg6;
+	u_debugreg[7] = thread->debugreg7;
+}
+
+/*
+ * Handle debug exception notifications.
+ */
+int __kprobes hw_breakpoint_handler(struct die_args *args)
+{
+	int i, rc = NOTIFY_STOP;
+	struct hw_breakpoint *bp;
+	/* The DR6 value is stored in args->err */
+	unsigned long dr7, dr6 = args->err;
+
+	/*
+	 * We are here because BT, BS or BD bit is set and no trap bits are set
+	 * in dr6 register. Do an early return
+	 */
+	if ((dr6 & (DR_TRAP0|DR_TRAP1|DR_TRAP2|DR_TRAP3)) == 0)
+		return NOTIFY_DONE;
+
+	get_debugreg(dr7, 7);
+
+	/* Disable breakpoints during exception handling */
+	set_debugreg(0UL, 7);
+	/*
+	 * Assert that local interrupts are disabled
+	 * Reset the DRn bits in the virtualized register value.
+	 * The ptrace trigger routine will add in whatever is needed.
+	 */
+	current->thread.debugreg6 &= ~(DR_TRAP0|DR_TRAP1|DR_TRAP2|DR_TRAP3);
+
+	/* Lazy debug register switching */
+	if (per_cpu(last_debugged_task, get_cpu()) != current) {
+		switch_to_none_hw_breakpoint();
+		put_cpu_no_resched();
+	}
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
+			bp = hbp_kernel[i];
+		else {
+			bp = current->thread.hbp[i];
+			if (!bp) {
+				/* False alarm due to lazy DR switching */
+				continue;
+			}
+		}
+		(bp->triggered)(bp, args->regs);
+		/*
+		 * We have more work to do (send signals) if the breakpoint is
+		 * triggered due to user-space address, or if exceptions other
+		 * than breakpoint (such as single-stepping) are triggered.
+		 */
+		if (arch_check_va_in_userspace(bp->info.address, bp->info.len))
+			rc = NOTIFY_DONE;
+	}
+	if (dr6 & ~(DR_TRAP0|DR_TRAP1|DR_TRAP2|DR_TRAP3))
+		rc = NOTIFY_DONE;
+	set_debugreg(dr7, 7);
+	return rc;
+}

