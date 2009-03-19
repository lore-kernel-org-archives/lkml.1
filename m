Return-Path: <linux-kernel-owner+w=401wt.eu-S1761960AbZCSXse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761960AbZCSXse (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 19:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756648AbZCSXsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 19:48:24 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:46283 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756124AbZCSXsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 19:48:22 -0400
Date: Fri, 20 Mar 2009 05:18:04 +0530
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
Subject: [Patch 01/11] Introducing generic hardware breakpoint handler
	interfaces
Message-ID: <20090319234804.GB10517@in.ibm.com>
References: <20090319234044.410725944@K.Prasad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=1
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces two new files hw_breakpoint.[ch] which defines the 
generic interfaces to use hardware breakpoint infrastructure of the system. 

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
---
 arch/Kconfig                        |    3 
 include/asm-generic/hw_breakpoint.h |  140 +++++++++++++
 kernel/Makefile                     |    1 
 kernel/hw_breakpoint.c              |  361 ++++++++++++++++++++++++++++++++++++
 4 files changed, 505 insertions(+)

Index: linux-2.6-tip.hbkpt/kernel/hw_breakpoint.c
===================================================================
--- /dev/null
+++ linux-2.6-tip.hbkpt/kernel/hw_breakpoint.c
@@ -0,0 +1,361 @@
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
+ * Copyright (C) IBM Corporation, 2009
+ */
+
+/*
+ * HW_breakpoint: a unified kernel/user-space hardware breakpoint facility,
+ * using the CPU's debug registers.
+ *
+ * This file contains the arch-independent routines.  It is not meant
+ * to be compiled as a standalone source file; rather it should be
+ * #include'd by the arch-specific implementation.
+ */
+
+#include <linux/irqflags.h>
+#include <linux/kallsyms.h>
+#include <linux/notifier.h>
+#include <linux/kprobes.h>
+#include <linux/kdebug.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/percpu.h>
+#include <linux/mutex.h>
+#include <linux/sched.h>
+#include <linux/init.h>
+#include <linux/smp.h>
+
+#include <asm/hw_breakpoint.h>
+#include <asm/processor.h>
+#include <asm/debugreg.h>
+
+/* Array of kernel-space breakpoint structures */
+struct hw_breakpoint *hbkpt_kernel[HB_NUM];
+/*
+ * Kernel breakpoints grow downwards, starting from HB_NUM
+ * 'hbkpt_kernel_pos' denotes lowest numbered breakpoint register occupied for
+ * kernel-space request
+ */
+unsigned int hbkpt_kernel_pos;
+
+/* An array containing refcount of threads using a given bkpt register */
+unsigned int hbkpt_user_max_refcount[HB_NUM];
+
+/* One higher than the highest counted user-space breakpoint register */
+unsigned int hbkpt_user_max;
+
+struct task_struct *last_debugged_task;
+
+/*
+ * Install the debug register values for a new thread.
+ */
+void switch_to_thread_hw_breakpoint(struct task_struct *tsk)
+{
+	/* Set the debug register */
+	arch_install_thread_hbkpt(tsk);
+	last_debugged_task = current;
+
+	put_cpu_no_resched();
+}
+
+/*
+ * Install the debug register values for just the kernel, no thread.
+ */
+void switch_to_none_hw_breakpoint(void)
+{
+	arch_install_none();
+	put_cpu_no_resched();
+}
+
+/*
+ * Load the debug registers during startup of a CPU.
+ */
+void load_debug_registers(void)
+{
+	int i;
+	unsigned long flags;
+
+	/* Prevent IPIs for new kernel breakpoint updates */
+	local_irq_save(flags);
+
+	for (i = hbkpt_kernel_pos; i < HB_NUM; i++)
+		if (hbkpt_kernel[i])
+			on_each_cpu(arch_install_kernel_hbkpt,
+				(void *)hbkpt_kernel[i], 0);
+	if (current->thread.dr7)
+		arch_install_thread_hbkpt(current);
+
+	local_irq_restore(flags);
+}
+
+/*
+ * Erase all the hardware breakpoint info associated with a thread.
+ *
+ * If tsk != current then tsk must not be usable (for example, a
+ * child being cleaned up from a failed fork).
+ */
+void flush_thread_hw_breakpoint(struct task_struct *tsk)
+{
+	int i;
+	struct thread_struct *thread = &(tsk->thread);
+
+	mutex_lock(&hw_breakpoint_mutex);
+
+	/* Let the breakpoints know they are being uninstalled */
+
+	/* The thread no longer has any breakpoints associated with it */
+	clear_tsk_thread_flag(tsk, TIF_DEBUG);
+	for (i = 0; i < HB_NUM; i++) {
+		if (thread->hbkpt[i]) {
+			hbkpt_user_max_refcount[i]--;
+			if (!hbkpt_user_max_refcount[i])
+				hbkpt_user_max--;
+			kfree(thread->hbkpt[i]);
+			thread->hbkpt[i] = NULL;
+		}
+	}
+	thread->hbkpt_num_installed = 0;
+
+	/* Actually uninstall the breakpoints if necessary */
+	if (tsk == current)
+		switch_to_none_hw_breakpoint();
+	mutex_unlock(&hw_breakpoint_mutex);
+}
+
+/*
+ * Copy the hardware breakpoint info from a thread to its cloned child.
+ */
+int copy_thread_hw_breakpoint(struct task_struct *tsk,
+		struct task_struct *child, unsigned long clone_flags)
+{
+	/* We will assume that breakpoint settings are not inherited
+	 * and the child starts out with no debug registers set.
+	 * But what about CLONE_PTRACE?
+	 */
+	clear_tsk_thread_flag(child, TIF_DEBUG);
+	return 0;
+}
+
+/*
+ * Validate the settings in a hw_breakpoint structure.
+ */
+static int validate_settings(struct hw_breakpoint *bp, struct task_struct *tsk)
+{
+	int ret;
+	unsigned int align;
+
+	ret = arch_validate_hwbkpt_settings(bp, &align, tsk);
+	if (ret < 0)
+		goto err;
+
+	/* Check that the low-order bits of the address are appropriate
+	 * for the alignment implied by len.
+	 */
+	if (bp->info.address & align)
+		return -EINVAL;
+
+	/* Check that the virtual address is in the proper range */
+	if (tsk) {
+		if (!arch_check_va_in_userspace(bp->info.address, tsk))
+			return -EFAULT;
+	} else {
+		if (!arch_check_va_in_kernelspace(bp->info.address))
+			return -EFAULT;
+	}
+ err:
+	return ret;
+}
+
+int __register_user_hw_breakpoint(int pos, struct task_struct *tsk,
+					struct hw_breakpoint *bp)
+{
+	struct thread_struct *thread = &(tsk->thread);
+	int rc;
+
+	/* Do not overcommit. Fail if kernel has used the hbkpt registers */
+	if (pos >= hbkpt_kernel_pos)
+		return -ENOSPC;
+
+	rc = validate_settings(bp, tsk);
+	if (rc)
+		return rc;
+
+	thread->hbkpt[pos] = bp;
+	thread->hbkpt_num_installed++;
+	hbkpt_user_max_refcount[pos]++;
+	/* 'tsk' is the thread that uses max number of hbkpt registers */
+	if (hbkpt_user_max < thread->hbkpt_num_installed)
+		hbkpt_user_max++;
+
+	arch_register_user_hw_breakpoint(pos, bp, tsk);
+
+	/*
+	 * Does it need to be installed right now?
+	 * Otherwise it will get installed the next time tsk runs
+	 */
+	if (tsk == current)
+		switch_to_thread_hw_breakpoint(tsk);
+	return rc;
+}
+
+/*
+ * Modify the address of a hbkpt register already in use by the task
+ * Do not invoke this in-lieu of a __unregister_user_hw_breakpoint()
+ */
+int __modify_user_hw_breakpoint(int pos, struct task_struct *tsk,
+					struct hw_breakpoint *bp)
+{
+	int rc;
+	struct thread_struct *thread = &(tsk->thread);
+
+	if ((pos >= hbkpt_kernel_pos) || (validate_settings(bp, tsk)))
+		return -EINVAL;
+
+	thread->hbkpt[pos] = bp;
+
+	/*
+	 * 'pos' must be that of a hbkpt register already used by 'tsk'
+	 * Otherwise arch_modify_user_hw_breakpoint() will fail
+	 */
+	rc = arch_modify_user_hw_breakpoint(pos, bp, tsk);
+	if (rc)
+		return rc;
+
+	if (tsk == current)
+		switch_to_thread_hw_breakpoint(tsk);
+	return 0;
+}
+
+/*
+ * Actual implementation of unregister_user_hw_breakpoint.
+ */
+void __unregister_user_hw_breakpoint(int pos, struct task_struct *tsk,
+						struct hw_breakpoint *bp)
+{
+	struct thread_struct *thread = &(tsk->thread);
+
+	if (!bp)
+		return;
+
+	hbkpt_user_max_refcount[pos]--;
+	if ((hbkpt_user_max == pos + 1) && (hbkpt_user_max_refcount[pos] == 0))
+		hbkpt_user_max--;
+	thread->hbkpt_num_installed--;
+
+	arch_unregister_user_hw_breakpoint(pos, bp, tsk);
+
+	if (tsk == current)
+		switch_to_thread_hw_breakpoint(tsk);
+	kfree(tsk->thread.hbkpt[pos]);
+	tsk->thread.hbkpt[pos] = NULL;
+}
+
+/**
+ * register_kernel_hw_breakpoint - register a hardware breakpoint for kernel space
+ * @bp: the breakpoint structure to register
+ *
+ * @bp.info->name or @bp.info->address, @bp.info->len, @bp.info->type and
+ * @bp->triggered must be set properly before invocation
+ *
+ */
+int register_kernel_hw_breakpoint(struct hw_breakpoint *bp)
+{
+	int rc;
+
+	rc = validate_settings(bp, NULL);
+	if (rc)
+		return rc;
+
+	mutex_lock(&hw_breakpoint_mutex);
+
+	/* Check if we are over-committing */
+	if (hbkpt_kernel_pos <= hbkpt_user_max) {
+		mutex_unlock(&hw_breakpoint_mutex);
+		return -EINVAL;
+	}
+
+	hbkpt_kernel_pos--;
+	hbkpt_kernel[hbkpt_kernel_pos] = bp;
+	arch_register_kernel_hw_breakpoint(bp);
+
+	mutex_unlock(&hw_breakpoint_mutex);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(register_kernel_hw_breakpoint);
+
+/**
+ * unregister_kernel_hw_breakpoint - unregister a hardware breakpoint for kernel space
+ * @bp: the breakpoint structure to unregister
+ *
+ * Uninstalls and unregisters @bp.
+ */
+void unregister_kernel_hw_breakpoint(struct hw_breakpoint *bp)
+{
+	int i, j;
+
+	mutex_lock(&hw_breakpoint_mutex);
+
+	for (i = hbkpt_kernel_pos; i < HB_NUM; i++)
+		if (bp == hbkpt_kernel[i])
+			break;
+
+	arch_unregister_kernel_hw_breakpoint(i);
+
+	/*
+	 * We'll shift the breakpoints one-level above to accomodate new thread
+	 * requests
+	 */
+	if (i > hbkpt_kernel_pos)
+		for (j = i; j == hbkpt_kernel_pos; j--)
+			hbkpt_kernel[j] = hbkpt_kernel[j-1];
+	hbkpt_kernel_pos++;
+
+	mutex_unlock(&hw_breakpoint_mutex);
+}
+EXPORT_SYMBOL_GPL(unregister_kernel_hw_breakpoint);
+
+/*
+ * Handle debug exception notifications.
+ */
+static int __kprobes hw_breakpoint_exceptions_notify(
+		struct notifier_block *unused, unsigned long val, void *data)
+{
+	if (val != DIE_DEBUG)
+		return NOTIFY_DONE;
+	return hw_breakpoint_handler(data);
+}
+
+static struct notifier_block hw_breakpoint_exceptions_nb = {
+	.notifier_call = hw_breakpoint_exceptions_notify,
+	/* we need to be notified first */
+	.priority = 0x7fffffff
+};
+
+static int __init init_hw_breakpoint(void)
+{
+	int i;
+
+	hbkpt_kernel_pos = HB_NUM;
+	for (i = 0; i < HB_NUM; i++)
+		hbkpt_user_max_refcount[i] = 0;
+	hbkpt_user_max = 0;
+	load_debug_registers();
+
+	return register_die_notifier(&hw_breakpoint_exceptions_nb);
+}
+
+core_initcall(init_hw_breakpoint);
Index: linux-2.6-tip.hbkpt/kernel/Makefile
===================================================================
--- linux-2.6-tip.hbkpt.orig/kernel/Makefile
+++ linux-2.6-tip.hbkpt/kernel/Makefile
@@ -95,6 +95,7 @@ obj-$(CONFIG_FUNCTION_TRACER) += trace/
 obj-$(CONFIG_TRACING) += trace/
 obj-$(CONFIG_SMP) += sched_cpupri.o
 obj-$(CONFIG_PERF_COUNTERS) += perf_counter.o
+obj-$(CONFIG_HAVE_HW_BREAKPOINT) += hw_breakpoint.o
 
 ifneq ($(CONFIG_SCHED_OMIT_FRAME_POINTER),y)
 # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is
Index: linux-2.6-tip.hbkpt/include/asm-generic/hw_breakpoint.h
===================================================================
--- /dev/null
+++ linux-2.6-tip.hbkpt/include/asm-generic/hw_breakpoint.h
@@ -0,0 +1,140 @@
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
+ *	HW_BREAKPOINT_LEN_EXECUTE
+ *	HW_BREAKPOINT_RW
+ *	HW_BREAKPOINT_READ
+ *	HW_BREAKPOINT_EXECUTE
+ *
+ * On other architectures HW_BREAKPOINT_LEN_8 may be available, and the
+ * 1-, 2-, and 4-byte lengths may be unavailable.  There also may be
+ * HW_BREAKPOINT_WRITE.  You can use #ifdef to check at compile time.
+ */
+
+static DEFINE_MUTEX(hw_breakpoint_mutex);	/* Protects everything */
+
+/*
+ * Kernel breakpoints are not associated with any particular thread.
+ */
+int register_kernel_hw_breakpoint(struct hw_breakpoint *bp);
+void unregister_kernel_hw_breakpoint(struct hw_breakpoint *bp);
+void switch_to_none_hw_breakpoint(void);
+
+extern unsigned int hbkpt_kernel_pos;
+extern unsigned int hbkpt_user_max;
+extern struct task_struct *last_debugged_task;
+
+#endif	/* __KERNEL__ */
+#endif	/* _ASM_GENERIC_HW_BREAKPOINT_H */
Index: linux-2.6-tip.hbkpt/arch/Kconfig
===================================================================
--- linux-2.6-tip.hbkpt.orig/arch/Kconfig
+++ linux-2.6-tip.hbkpt/arch/Kconfig
@@ -106,3 +106,6 @@ config HAVE_CLK
 	help
 	  The <linux/clk.h> calls support software clock gating and
 	  thus are a key power management tool on many systems.
+
+config HAVE_HW_BREAKPOINT
+	bool

