Return-Path: <linux-kernel-owner+w=401wt.eu-S1758876AbZCXPZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758876AbZCXPZl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 11:25:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757442AbZCXPZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 11:25:14 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:34780 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754747AbZCXPZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 11:25:10 -0400
Date: Tue, 24 Mar 2009 20:54:50 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, maneesh@linux.vnet.ibm.com,
       Roland McGrath <roland@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>
Subject: [Patch 01/11] Introducing generic hardware breakpoint handler
	interfaces
Message-ID: <20090324152450.GB17918@in.ibm.com>
References: <20090324152028.754123712@K.Prasad>
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
 arch/Kconfig                        |    4 
 include/asm-generic/hw_breakpoint.h |  138 +++++++++++++
 kernel/Makefile                     |    1 
 kernel/hw_breakpoint.c              |  367 ++++++++++++++++++++++++++++++++++++
 4 files changed, 510 insertions(+)

Index: linux-2.6-tip/kernel/hw_breakpoint.c
===================================================================
--- /dev/null
+++ linux-2.6-tip/kernel/hw_breakpoint.c
@@ -0,0 +1,367 @@
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
+/*
+ * Mutex that protects all (un)register operations over kernel/user-space
+ * breakpoint requests
+ */
+DEFINE_MUTEX(hw_breakpoint_mutex);
+
+/* Array of kernel-space breakpoint structures */
+struct hw_breakpoint *hbp_kernel[HB_NUM];
+
+/*
+ * Kernel breakpoints grow downwards, starting from HB_NUM
+ * 'hbp_kernel_pos' denotes lowest numbered breakpoint register occupied for
+ * kernel-space request
+ */
+unsigned int hbp_kernel_pos;
+
+/*
+ * An array containing refcount of threads using a given bkpt register
+ * Accesses are synchronised by acquiring hw_breakpoint_mutex
+ */
+unsigned int hbp_user_refcount[HB_NUM];
+
+struct task_struct *last_debugged_task;
+
+/*
+ * Install the debug register values for a new thread.
+ */
+void switch_to_thread_hw_breakpoint(struct task_struct *tsk)
+{
+	/* Set the debug register */
+	arch_install_thread_hw_breakpoint(tsk);
+	last_debugged_task = current;
+}
+
+/*
+ * Install the debug register values for just the kernel, no thread.
+ */
+void switch_to_none_hw_breakpoint(void)
+{
+	arch_install_none();
+}
+
+/*
+ * Load the debug registers during startup of a CPU.
+ */
+void load_debug_registers(void)
+{
+	unsigned long flags;
+	struct task_struct *tsk = current;
+
+	mutex_lock(&hw_breakpoint_mutex);
+
+	/* Prevent IPIs for new kernel breakpoint updates */
+	local_irq_save(flags);
+	arch_load_debug_registers();
+	local_irq_restore(flags);
+
+	if (test_tsk_thread_flag(tsk, TIF_DEBUG))
+		switch_to_thread_hw_breakpoint(tsk);
+
+	mutex_unlock(&hw_breakpoint_mutex);
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
+	/* The thread no longer has any breakpoints associated with it */
+	clear_tsk_thread_flag(tsk, TIF_DEBUG);
+	for (i = 0; i < HB_NUM; i++) {
+		if (thread->hbp[i]) {
+			hbp_user_refcount[i]--;
+			kfree(thread->hbp[i]);
+			thread->hbp[i] = NULL;
+		}
+	}
+	thread->hbp_num_installed = 0;
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
+	/*
+	 * We will assume that breakpoint settings are not inherited
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
+	if (!bp)
+		return -EINVAL;
+
+	ret = arch_validate_hwbkpt_settings(bp, &align, tsk);
+	if (ret < 0)
+		goto err;
+
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
+	/* Do not overcommit. Fail if kernel has used the hbp registers */
+	if (pos >= hbp_kernel_pos)
+		return -ENOSPC;
+
+	rc = validate_settings(bp, tsk);
+	if (rc)
+		return rc;
+
+	thread->hbp[pos] = bp;
+	thread->hbp_num_installed++;
+	hbp_user_refcount[pos]++;
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
+ * Modify the address of a hbp register already in use by the task
+ * Do not invoke this in-lieu of a __unregister_user_hw_breakpoint()
+ */
+int __modify_user_hw_breakpoint(int pos, struct task_struct *tsk,
+					struct hw_breakpoint *bp)
+{
+	int rc;
+	struct thread_struct *thread = &(tsk->thread);
+
+	if ((pos >= hbp_kernel_pos) || (validate_settings(bp, tsk)))
+		return -EINVAL;
+
+	thread->hbp[pos] = bp;
+
+	/*
+	 * 'pos' must be that of a hbp register already used by 'tsk'
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
+	hbp_user_refcount[pos]--;
+	thread->hbp_num_installed--;
+
+	arch_unregister_user_hw_breakpoint(pos, bp, tsk);
+
+	if (tsk == current)
+		switch_to_thread_hw_breakpoint(tsk);
+	kfree(tsk->thread.hbp[pos]);
+	tsk->thread.hbp[pos] = NULL;
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
+	rc = -EINVAL;
+	/* Check if we are over-committing */
+	if ((hbp_kernel_pos > 0) && (!hbp_user_refcount[hbp_kernel_pos-1])) {
+		hbp_kernel_pos--;
+		hbp_kernel[hbp_kernel_pos] = bp;
+		arch_register_kernel_hw_breakpoint(hbp_kernel_pos);
+		rc = 0;
+	}
+
+	mutex_unlock(&hw_breakpoint_mutex);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(register_kernel_hw_breakpoint);
+
+/**
+ * unregister_kernel_hw_breakpoint - unregister a HW breakpoint for kernel space
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
+	/* Find the 'bp' in our list of breakpoints for kernel */
+	for (i = hbp_kernel_pos; i < HB_NUM; i++)
+		if (bp == hbp_kernel[i])
+			break;
+	/*
+	 * We'll shift the breakpoints one-level above to compact if
+	 * unregistration creates a hole
+	 */
+	if (i > hbp_kernel_pos)
+		for (j = i; j == hbp_kernel_pos; j--)
+			hbp_kernel[j] = hbp_kernel[j-1];
+
+	/*
+	 * Delete the last kernel breakpoint entry after compaction and update
+	 * the pointer to the lowest numbered kernel entry after updating its
+	 * corresponding value in kdr7
+	 */
+	hbp_kernel[hbp_kernel_pos] = 0;
+	arch_unregister_kernel_hw_breakpoint();
+	hbp_kernel_pos++;
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
+
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
+	hbp_kernel_pos = HB_NUM;
+	for (i = 0; i < HB_NUM; i++)
+		hbp_user_refcount[i] = 0;
+	load_debug_registers();
+
+	return register_die_notifier(&hw_breakpoint_exceptions_nb);
+}
+
+core_initcall(init_hw_breakpoint);
Index: linux-2.6-tip/kernel/Makefile
===================================================================
--- linux-2.6-tip.orig/kernel/Makefile
+++ linux-2.6-tip/kernel/Makefile
@@ -95,6 +95,7 @@ obj-$(CONFIG_FUNCTION_TRACER) += trace/
 obj-$(CONFIG_TRACING) += trace/
 obj-$(CONFIG_SMP) += sched_cpupri.o
 obj-$(CONFIG_PERF_COUNTERS) += perf_counter.o
+obj-$(CONFIG_HAVE_HW_BREAKPOINT) += hw_breakpoint.o
 
 ifneq ($(CONFIG_SCHED_OMIT_FRAME_POINTER),y)
 # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is
Index: linux-2.6-tip/include/asm-generic/hw_breakpoint.h
===================================================================
--- /dev/null
+++ linux-2.6-tip/include/asm-generic/hw_breakpoint.h
@@ -0,0 +1,138 @@
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
+/*
+ * Kernel breakpoints are not associated with any particular thread.
+ */
+int register_kernel_hw_breakpoint(struct hw_breakpoint *bp);
+void unregister_kernel_hw_breakpoint(struct hw_breakpoint *bp);
+void switch_to_none_hw_breakpoint(void);
+
+extern unsigned int hbp_kernel_pos;
+extern struct task_struct *last_debugged_task;
+extern struct mutex hw_breakpoint_mutex;
+
+#endif	/* __KERNEL__ */
+#endif	/* _ASM_GENERIC_HW_BREAKPOINT_H */
Index: linux-2.6-tip/arch/Kconfig
===================================================================
--- linux-2.6-tip.orig/arch/Kconfig
+++ linux-2.6-tip/arch/Kconfig
@@ -109,3 +109,7 @@ config HAVE_CLK
 
 config HAVE_DMA_API_DEBUG
 	bool
+
+config HAVE_HW_BREAKPOINT
+	bool
+

