Return-Path: <linux-kernel-owner+w=401wt.eu-S1754645AbYJGLmK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbYJGLmK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 07:42:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753179AbYJGLl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 07:41:56 -0400
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:58872 "EHLO
	e28esmtp01.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753109AbYJGLly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 07:41:54 -0400
Date: Tue, 7 Oct 2008 17:11:47 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>, Roland McGrath <roland@redhat.com>,
       akpm@linux-foundation.org, mingo@elte.hu, jason.wessel@windriver.com,
       avi@qumranet.com, richardj_moore@uk.ibm.com
Subject: [RFC Patch 2/9] x86 architecture implementation of Hardware
	Breakpoint interfaces
Message-ID: <20081007114147.GB25627@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20081007113815.GA23523@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081007113815.GA23523@in.ibm.com>
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
 arch/x86/kernel/Makefile        |    2 
 arch/x86/kernel/hw_breakpoint.c |  684 ++++++++++++++++++++++++++++++++++++++++
 include/asm-x86/hw_breakpoint.h |  121 +++++++
 3 files changed, 806 insertions(+), 1 deletion(-)

Index: linux-bkpt-lkml-27-rc9/arch/x86/kernel/hw_breakpoint.c
===================================================================
--- /dev/null
+++ linux-bkpt-lkml-27-rc9/arch/x86/kernel/hw_breakpoint.c
@@ -0,0 +1,684 @@
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
+ * Copyright (C) 2008 IBM Corporation
+ */
+
+/*
+ * HW_breakpoint: a unified kernel/user-space hardware breakpoint facility,
+ * using the CPU's debug registers.
+ */
+
+#include <linux/init.h>
+#include <linux/irqflags.h>
+#include <linux/kdebug.h>
+#include <linux/kernel.h>
+#include <linux/kprobes.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/notifier.h>
+#include <linux/rculist.h>
+#include <linux/sched.h>
+#include <linux/smp.h>
+#include <linux/percpu.h>
+
+#include <asm/debugreg.h>
+#include <asm/hw_breakpoint.h>
+#include <asm/processor.h>
+
+DEFINE_PER_CPU(unsigned int, sstep_reason) = 0;
+
+/* Arch-specific hook routines */
+
+/*
+ * Install the kernel breakpoints in their debug registers.
+ */
+static void arch_install_chbi(struct cpu_hw_breakpoint *chbi)
+{
+	struct hw_breakpoint **bps;
+
+	/* Don't allow debug exceptions while we update the registers */
+	set_debugreg(0UL, 7);
+	chbi->cur_kbpdata = rcu_dereference(cur_kbpdata);
+
+	/* Kernel breakpoints are stored starting in DR0 and going up */
+	bps = chbi->cur_kbpdata->bps;
+	switch (chbi->cur_kbpdata->num_kbps) {
+	case 4:
+		set_debugreg(bps[3]->info.address, 3);
+	case 3:
+		set_debugreg(bps[2]->info.address, 2);
+	case 2:
+		set_debugreg(bps[1]->info.address, 1);
+	case 1:
+		set_debugreg(bps[0]->info.address, 0);
+	}
+	/* No need to set DR6 */
+	set_debugreg(chbi->cur_kbpdata->mkdr7, 7);
+}
+
+/*
+ * Update an out-of-date thread hw_breakpoint info structure.
+ */
+static void arch_update_thbi(struct thread_hw_breakpoint *thbi,
+		struct kernel_bp_data *thr_kbpdata)
+{
+	int num = thr_kbpdata->num_kbps;
+
+	thbi->tkdr7 = thr_kbpdata->mkdr7 | (thbi->tdr7 & ~kdr7_masks[num]);
+}
+
+/*
+ * Install the thread breakpoints in their debug registers.
+ */
+static void arch_install_thbi(struct thread_hw_breakpoint *thbi)
+{
+	/* Install the user breakpoints.  Kernel breakpoints are stored
+	 * starting in DR0 and going up; there are num_kbps of them.
+	 * User breakpoints are stored starting in DR3 and going down,
+	 * as many as we have room for.
+	 */
+	switch (thbi->num_installed) {
+	case 4:
+		set_debugreg(thbi->tdr[0], 0);
+	case 3:
+		set_debugreg(thbi->tdr[1], 1);
+	case 2:
+		set_debugreg(thbi->tdr[2], 2);
+	case 1:
+		set_debugreg(thbi->tdr[3], 3);
+	}
+	/* No need to set DR6 */
+	set_debugreg(thbi->tkdr7, 7);
+}
+
+/*
+ * Install the debug register values for just the kernel, no thread.
+ */
+static void arch_install_none(struct cpu_hw_breakpoint *chbi)
+{
+	set_debugreg(chbi->cur_kbpdata->mkdr7, 7);
+}
+
+/*
+ * Create a new kbpdata entry.
+ */
+static void arch_new_kbpdata(struct kernel_bp_data *new_kbpdata)
+{
+	int num = new_kbpdata->num_kbps;
+
+	new_kbpdata->mkdr7 = kdr7 & (kdr7_masks[num] | DR_GLOBAL_SLOWDOWN);
+}
+
+/*
+ * Store a thread breakpoint array entry's address
+ */
+static void arch_store_thread_bp_array(struct thread_hw_breakpoint *thbi,
+		struct hw_breakpoint *bp, int i)
+{
+	thbi->tdr[i] = bp->info.address;
+}
+
+int pre_handler_allowed(unsigned type)
+{
+	if (type == HW_BREAKPOINT_EXECUTE)
+		return 1;
+	else
+		return -EINVAL;
+}
+
+int post_handler_allowed(unsigned type)
+{
+	/* We can have a post handler for all types of breakpoints */
+	return 1;
+}
+
+/*
+ * Store a breakpoint's encoded address, length, and type.
+ */
+static void arch_store_info(struct hw_breakpoint *bp,
+		unsigned long address, unsigned len, unsigned type)
+{
+	bp->info.address = address;
+	bp->info.len = len;
+	bp->info.type = type;
+}
+
+/*
+ * Validate the arch-specific HW Breakpoint register settings
+ */
+static int arch_validate_hwbkpt_settings(struct hw_breakpoint *bp,
+			unsigned long address, unsigned len, unsigned int type,
+			unsigned int *align)
+{
+	int ret = -EINVAL;
+
+	switch (type) {
+	case HW_BREAKPOINT_EXECUTE:
+		if (len != HW_BREAKPOINT_LEN_EXECUTE)
+			return ret;
+		break;
+	case HW_BREAKPOINT_WRITE:
+				break;
+	case HW_BREAKPOINT_IO:
+				break;
+	case HW_BREAKPOINT_RW:
+				break;
+	default:
+		return ret;
+	}
+
+	switch (len) {
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
+	if ((pre_handler_allowed(type) && (bp->pre_handler)) ||
+		(post_handler_allowed(type) && (bp->post_handler))) {
+		ret = 0;
+		arch_store_info(bp, address, len, type);
+	}
+	return ret;
+}
+
+/*
+ * Check for virtual address in user space.
+ */
+static int arch_check_va_in_userspace(unsigned long va,
+		struct task_struct *tsk)
+{
+#ifndef	CONFIG_X86_64
+#define	TASK_SIZE_OF(t)	TASK_SIZE
+#endif
+	return (va < TASK_SIZE_OF(tsk));
+}
+
+/*
+ * Check for virtual address in kernel space.
+ */
+static int arch_check_va_in_kernelspace(unsigned long va)
+{
+#ifndef	CONFIG_X86_64
+#define	TASK_SIZE64	TASK_SIZE
+#endif
+	return (va >= TASK_SIZE64);
+}
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
+ * Calculate the DR7 value for a list of kernel or user breakpoints.
+ */
+static unsigned long calculate_dr7(struct thread_hw_breakpoint *thbi)
+{
+	int is_user;
+	struct list_head *bp_list;
+	struct hw_breakpoint *bp;
+	int i;
+	int drnum;
+	unsigned long dr7;
+
+	if (thbi) {
+		is_user = 1;
+		bp_list = &thbi->thread_bps;
+		drnum = HB_NUM - 1;
+	} else {
+		is_user = 0;
+		bp_list = &kernel_bps;
+		drnum = 0;
+	}
+
+	/* Kernel bps are assigned from DR0 on up, and user bps are assigned
+	 * from DR3 on down.  Accumulate all 4 bps; the kernel DR7 mask will
+	 * select the appropriate bits later.
+	 */
+	dr7 = 0;
+	i = 0;
+	list_for_each_entry(bp, bp_list, node) {
+
+		/* Get the debug register number and accumulate the bits */
+		dr7 |= encode_dr7(drnum, bp->info.len, bp->info.type);
+		if (++i >= HB_NUM)
+			break;
+		if (is_user)
+			--drnum;
+		else
+			++drnum;
+	}
+	return dr7;
+}
+
+/*
+ * Register a new user breakpoint structure.
+ */
+static void arch_register_user_hw_breakpoint(struct hw_breakpoint *bp,
+		struct thread_hw_breakpoint *thbi)
+{
+	thbi->tdr7 = calculate_dr7(thbi);
+
+	/* If this is an execution breakpoint for the current PC address,
+	 * we should clear the task's RF so that the bp will be certain
+	 * to trigger.
+	 *
+	 * FIXME: It's not so easy to get hold of the task's PC as a linear
+	 * address!  ptrace.c does this already...
+	 */
+}
+
+/*
+ * Unregister a user breakpoint structure.
+ */
+static void arch_unregister_user_hw_breakpoint(struct hw_breakpoint *bp,
+		struct thread_hw_breakpoint *thbi)
+{
+	thbi->tdr7 = calculate_dr7(thbi);
+}
+
+/*
+ * Register a kernel breakpoint structure.
+ */
+static void arch_register_kernel_hw_breakpoint(
+		struct hw_breakpoint *bp)
+{
+	kdr7 = calculate_dr7(NULL);
+}
+
+/*
+ * Unregister a kernel breakpoint structure.
+ */
+static void arch_unregister_kernel_hw_breakpoint(
+		struct hw_breakpoint *bp)
+{
+	kdr7 = calculate_dr7(NULL);
+}
+
+
+/* End of arch-specific hook routines */
+
+
+/*
+ * Copy out the debug register information for a core dump.
+ *
+ * tsk must be equal to current.
+ */
+void dump_thread_hw_breakpoint(struct task_struct *tsk, int u_debugreg[8])
+{
+	struct thread_hw_breakpoint *thbi = tsk->thread.hw_breakpoint_info;
+	int i;
+
+	memset(u_debugreg, 0, sizeof u_debugreg);
+	if (thbi) {
+		for (i = 0; i < HB_NUM; ++i)
+			u_debugreg[i] = thbi->vdr_bps[i].info.address;
+		u_debugreg[7] = thbi->vdr7;
+	}
+	u_debugreg[6] = tsk->thread.vdr6;
+}
+
+/*
+ * Ptrace support: breakpoint trigger routine.
+ */
+
+static struct thread_hw_breakpoint *alloc_thread_hw_breakpoint(
+		struct task_struct *tsk);
+static int __register_user_hw_breakpoint(struct task_struct *tsk,
+		struct hw_breakpoint *bp,
+		unsigned long address, unsigned len, unsigned type);
+static void __unregister_user_hw_breakpoint(struct task_struct *tsk,
+		struct hw_breakpoint *bp);
+
+static void ptrace_triggered(struct hw_breakpoint *bp, struct pt_regs *regs)
+{
+	struct task_struct *tsk = current;
+	struct thread_hw_breakpoint *thbi = tsk->thread.hw_breakpoint_info;
+	int i;
+
+	/* Store in the virtual DR6 register the fact that the breakpoint
+	 * was hit so the thread's debugger will see it.
+	 */
+	if (thbi) {
+		i = bp - thbi->vdr_bps;
+		tsk->thread.vdr6 |= (DR_TRAP0 << i);
+	}
+}
+
+/*
+ * Handle PTRACE_PEEKUSR calls for the debug register area.
+ */
+unsigned long thread_get_debugreg(struct task_struct *tsk, int n)
+{
+	struct thread_hw_breakpoint *thbi;
+	unsigned long val = 0;
+
+	mutex_lock(&hw_breakpoint_mutex);
+	thbi = tsk->thread.hw_breakpoint_info;
+	if (n < HB_NUM) {
+		if (thbi)
+			val = thbi->vdr_bps[n].info.address;
+	} else if (n == 6) {
+		val = tsk->thread.vdr6;
+	} else if (n == 7) {
+		if (thbi)
+			val = thbi->vdr7;
+	}
+	mutex_unlock(&hw_breakpoint_mutex);
+	return val;
+}
+
+/*
+ * Decode the length and type bits for a particular breakpoint as
+ * stored in debug register 7.  Return the "enabled" status.
+ */
+static int decode_dr7(unsigned long dr7, int bpnum, unsigned *len,
+		unsigned *type)
+{
+	int temp = dr7 >> (DR_CONTROL_SHIFT + bpnum * DR_CONTROL_SIZE);
+
+	*len = (temp & 0xc) | 0x40;
+	*type = (temp & 0x3) | 0x80;
+	return (dr7 >> (bpnum * DR_ENABLE_SIZE)) & 0x3;
+}
+
+/*
+ * Handle ptrace writes to debug register 7.
+ */
+static int ptrace_write_dr7(struct task_struct *tsk,
+		struct thread_hw_breakpoint *thbi, unsigned long data)
+{
+	struct hw_breakpoint *bp;
+	int i;
+	int rc = 0;
+	unsigned long old_dr7 = thbi->vdr7;
+
+	data &= ~DR_CONTROL_RESERVED;
+
+	/* Loop through all the hardware breakpoints, making the
+	 * appropriate changes to each.
+	 */
+ restore_settings:
+	thbi->vdr7 = data;
+	bp = &thbi->vdr_bps[0];
+	for (i = 0; i < HB_NUM; (++i, ++bp)) {
+		int enabled;
+		unsigned len, type;
+
+		enabled = decode_dr7(data, i, &len, &type);
+
+		/* Unregister the breakpoint before trying to change it */
+		if (bp->status)
+			__unregister_user_hw_breakpoint(tsk, bp);
+
+		/* Now register the breakpoint if it should be enabled.
+		 * New invalid entries will raise an error here.
+		 */
+		if (enabled) {
+			/* TODO: Change this portion of the code to use pre_
+			 * and post_ handler_allowed() routine
+			 */
+			if (type == HW_BREAKPOINT_EXECUTE)
+				bp->pre_handler = ptrace_triggered;
+			else
+				bp->post_handler = ptrace_triggered;
+
+			bp->priority = HW_BREAKPOINT_PRIO_PTRACE;
+			if (rc == 0 && __register_user_hw_breakpoint(tsk, bp,
+					bp->info.address, len, type) < 0)
+				break;
+		}
+	}
+
+	/* If anything above failed, restore the original settings */
+	if (i < HB_NUM) {
+		rc = -EIO;
+		data = old_dr7;
+		goto restore_settings;
+	}
+	return rc;
+}
+
+/*
+ * Handle PTRACE_POKEUSR calls for the debug register area.
+ */
+int thread_set_debugreg(struct task_struct *tsk, int n, unsigned long val)
+{
+	struct thread_hw_breakpoint *thbi;
+	int rc = -EIO;
+
+	/* We have to hold this lock the entire time, to prevent thbi
+	 * from being deallocated out from under us.
+	 */
+	mutex_lock(&hw_breakpoint_mutex);
+
+	/* There are no DR4 or DR5 registers */
+	if (n == 4 || n == 5)
+		;
+
+	/* Writes to DR6 modify the virtualized value */
+	else if (n == 6) {
+		tsk->thread.vdr6 = val;
+		rc = 0;
+	}
+
+	else if (!tsk->thread.hw_breakpoint_info && val == 0)
+		rc = 0;		/* Minor optimization */
+
+	else if ((thbi = alloc_thread_hw_breakpoint(tsk)) == NULL)
+		rc = -ENOMEM;
+
+	/* Writes to DR0 - DR3 change a breakpoint address */
+	else if (n < HB_NUM) {
+		struct hw_breakpoint *bp = &thbi->vdr_bps[n];
+
+		/* If the breakpoint is registered then unregister it,
+		 * change it, and re-register it.  Revert to the original
+		 * address if an error occurs.
+		 */
+		if (bp->status) {
+			unsigned long old_addr = bp->info.address;
+
+			__unregister_user_hw_breakpoint(tsk, bp);
+			rc = __register_user_hw_breakpoint(tsk, bp,
+					val, bp->info.len, bp->info.type);
+			if (rc < 0) {
+				__register_user_hw_breakpoint(tsk, bp,
+						old_addr,
+						bp->info.len, bp->info.type);
+			}
+		} else {
+			bp->info.address = val;
+			rc = 0;
+		}
+	}
+
+	/* All that's left is DR7 */
+	else
+		rc = ptrace_write_dr7(tsk, thbi, val);
+
+	mutex_unlock(&hw_breakpoint_mutex);
+	return rc;
+}
+
+
+/*
+ * Handle debug exception notifications.
+ */
+
+static void switch_to_none_hw_breakpoint(void);
+struct hw_breakpoint *last_hit_bp;
+struct thread_hw_breakpoint *last_hit_thbi;
+
+static int __kprobes hw_breakpoint_handler(struct die_args *args)
+{
+	struct cpu_hw_breakpoint *chbi;
+	int i;
+	struct hw_breakpoint *bp;
+	struct thread_hw_breakpoint *thbi = NULL;
+	unsigned int *ssr = &(__get_cpu_var(sstep_reason));
+
+	/* The DR6 value is stored in args->err */
+#define DR6	(args->err)
+
+	chbi = &per_cpu(cpu_info, get_cpu());
+
+	/* Disable all breakpoints so that the callbacks can run without
+	 * triggering recursive debug exceptions.
+	 */
+	set_debugreg(0UL, 7);
+
+	if ((DR6 & DR_STEP) && !((*ssr) & SSTEP_HWBKPT))
+		return NOTIFY_DONE;
+
+	/* If none of the breakpoint detection flags are enabled, it means we
+	 * have arrived here due to single-stepping of a target instruction
+	 */
+	if ((!(DR6 & (DR_TRAP0|DR_TRAP1|DR_TRAP2|DR_TRAP3))) &&
+						(DR6 & DR_STEP)) {
+		args->regs->flags &= ~X86_EFLAGS_TF;
+		(*ssr) &= ~SSTEP_HWBKPT;
+		(last_hit_bp->post_handler)(last_hit_bp, args->regs);
+		/* Re-enable the breakpoints */
+		set_debugreg(last_hit_thbi ? last_hit_thbi->tkdr7 :
+						chbi->cur_kbpdata->mkdr7, 7);
+		put_cpu_no_resched();
+		current->thread.vdr6 &= ~(DR_TRAP0|DR_TRAP1|DR_TRAP2|DR_TRAP3);
+
+		return NOTIFY_STOP;
+	}
+
+	/* Assert that local interrupts are disabled */
+	/* Reset the DRn bits in the virtualized register value.
+	 * The ptrace trigger routine will add in whatever is needed.
+	 */
+	current->thread.vdr6 &= ~(DR_TRAP0|DR_TRAP1|DR_TRAP2|DR_TRAP3);
+
+	/* Are we a victim of lazy debug-register switching? */
+	if (!chbi->bp_task)
+		;
+	else if (chbi->bp_task != current) {
+
+		/* No user breakpoints are valid.  Perform the belated
+		 * debug-register switch.
+		 */
+		switch_to_none_hw_breakpoint();
+	} else {
+		thbi = chbi->bp_task->thread.hw_breakpoint_info;
+	}
+
+	/* Handle all the breakpoints that were triggered */
+	for (i = 0; i < HB_NUM; ++i) {
+		if (likely(!(DR6 & (DR_TRAP0 << i))))
+			continue;
+
+		/* Find the corresponding hw_breakpoint structure and
+		 * invoke its triggered callback.
+		 */
+		if (i < chbi->cur_kbpdata->num_kbps)
+			bp = chbi->cur_kbpdata->bps[i];
+		else if (thbi)
+			bp = thbi->bps[i];
+		else		/* False alarm due to lazy DR switching */
+			continue;
+		if (bp) {
+			(*ssr) = 0;
+			/* Enable single-stepping over the watched insn */
+			switch (bp->info.type) {
+			case HW_BREAKPOINT_EXECUTE:
+				if (bp->pre_handler)
+					(bp->pre_handler)(bp, args->regs);
+
+				if (bp->post_handler) {
+					(*ssr) |= SSTEP_HWBKPT;
+					args->regs->flags |=
+						(X86_EFLAGS_TF | X86_EFLAGS_RF);
+					last_hit_bp = bp;
+					last_hit_thbi = thbi;
+					return NOTIFY_DONE;
+				}
+				break;
+			case HW_BREAKPOINT_WRITE:
+			case HW_BREAKPOINT_RW:
+				if (bp->post_handler)
+					(bp->post_handler)(bp, args->regs);
+				/* Re-enable the breakpoints */
+				set_debugreg(thbi ? thbi->tkdr7 :
+						chbi->cur_kbpdata->mkdr7, 7);
+				put_cpu_no_resched();
+
+				return NOTIFY_DONE;
+			}
+		}
+	}
+	/* Stop processing further if the exception is a stray one */
+	if (!(DR6 & ~(DR_TRAP0|DR_TRAP1|DR_TRAP2|DR_TRAP3)))
+		return NOTIFY_STOP;
+
+	return NOTIFY_DONE;
+#undef DR6
+}
+
+/*
+ * Handle debug exception notifications.
+ */
+static int __kprobes hw_breakpoint_exceptions_notify(
+		struct notifier_block *unused, unsigned long val, void *data)
+{
+int ret;
+
+	if (val != DIE_DEBUG)
+		return NOTIFY_DONE;
+	ret = hw_breakpoint_handler(data);
+	return ret;
+}
+
+static struct notifier_block hw_breakpoint_exceptions_nb = {
+	.notifier_call = hw_breakpoint_exceptions_notify,
+	.priority = 0x00
+};
+
+static int __init init_hw_breakpoint(void)
+{
+	load_debug_registers();
+	return register_die_notifier(&hw_breakpoint_exceptions_nb);
+}
+
+core_initcall(init_hw_breakpoint);
+
+
+/* Grab the arch-independent code */
+#include "../../../kernel/hw_breakpoint.c"
+
Index: linux-bkpt-lkml-27-rc9/include/asm-x86/hw_breakpoint.h
===================================================================
--- /dev/null
+++ linux-bkpt-lkml-27-rc9/include/asm-x86/hw_breakpoint.h
@@ -0,0 +1,121 @@
+#ifndef	_I386_HW_BREAKPOINT_H
+#define	_I386_HW_BREAKPOINT_H
+
+#ifdef	__KERNEL__
+#define	__ARCH_HW_BREAKPOINT_H
+
+struct arch_hw_breakpoint {
+	unsigned long	address;
+	u8		len;
+	u8		type;
+} __attribute__((packed));
+
+#include <asm-generic/hw_breakpoint.h>
+
+/* HW breakpoint accessor routines */
+static inline const void *hw_breakpoint_get_kaddress(struct hw_breakpoint *bp)
+{
+	return (const void *) bp->info.address;
+}
+
+static inline const void __user *hw_breakpoint_get_uaddress
+						(struct hw_breakpoint *bp)
+{
+	return (const void __user *) bp->info.address;
+}
+
+static inline unsigned hw_breakpoint_get_len(struct hw_breakpoint *bp)
+{
+	return bp->info.len;
+}
+
+static inline unsigned hw_breakpoint_get_type(struct hw_breakpoint *bp)
+{
+	return bp->info.type;
+}
+
+/* Available HW breakpoint length encodings */
+#define HW_BREAKPOINT_LEN_1		0x40
+#define HW_BREAKPOINT_LEN_2		0x44
+#define HW_BREAKPOINT_LEN_4		0x4c
+#define HW_BREAKPOINT_LEN_EXECUTE	0x40
+
+/* Available HW breakpoint type encodings */
+#define HW_BREAKPOINT_EXECUTE	0x80	/* trigger on instruction execute */
+#define HW_BREAKPOINT_WRITE	0x81	/* trigger on memory write */
+#define HW_BREAKPOINT_IO	0x82	/* trigger on I/O reads or writes */
+#define HW_BREAKPOINT_RW	0x83	/* trigger on memory read or write */
+
+#define HB_NUM 4
+
+/* Per-thread HW breakpoint and debug register info */
+struct thread_hw_breakpoint {
+
+	/* utrace support */
+	struct list_head	node;		/* Entry in thread list */
+	struct list_head	thread_bps;	/* Thread's breakpoints */
+	struct hw_breakpoint	*bps[HB_NUM];	/* Highest-priority bps */
+	unsigned long		tdr[HB_NUM];	/*  and their addresses */
+	int			num_installed;	/* Number of installed bps */
+	unsigned		gennum;		/* update-generation number */
+
+	/* Only the portions below are arch-specific */
+
+	/* ptrace support -- Note that vdr6 is stored directly in the
+	 * thread_struct so that it is always available.
+	 */
+	unsigned long		vdr7;			/* Virtualized DR7 */
+	struct hw_breakpoint	vdr_bps[HB_NUM];	/* Breakpoints
+			representing virtualized debug registers 0 - 3 */
+	unsigned long		tdr7;		/* Thread's DR7 value */
+	unsigned long		tkdr7;		/* Thread + kernel DR7 value */
+};
+
+/* Kernel-space breakpoint data */
+struct kernel_bp_data {
+	unsigned		gennum;		/* Generation number */
+	int			num_kbps;	/* Number of kernel bps */
+	struct hw_breakpoint	*bps[HB_NUM];	/* Loaded breakpoints */
+
+	/* Only the portions below are arch-specific */
+	unsigned long		mkdr7;		/* Masked kernel DR7 value */
+};
+
+/* Per-CPU debug register info */
+struct cpu_hw_breakpoint {
+	struct kernel_bp_data	*cur_kbpdata;	/* Current kbpdata[] entry */
+	struct task_struct	*bp_task;	/* The thread whose bps
+			are currently loaded in the debug registers */
+};
+
+/* Global info */
+static struct kernel_bp_data	kbpdata[2];	/* Old and new settings */
+static int			cur_kbpindex;	/* Alternates 0, 1, ... */
+static struct kernel_bp_data	*cur_kbpdata = &kbpdata[0];
+			/* Always equal to &kbpdata[cur_kbpindex] */
+
+static u8			tprio[HB_NUM];	/* Thread bp max priorities */
+static LIST_HEAD(kernel_bps);			/* Kernel breakpoint list */
+static LIST_HEAD(thread_list);			/* thread_hw_breakpoint list */
+static DEFINE_MUTEX(hw_breakpoint_mutex);	/* Protects everything */
+
+/* Only the portions below are arch-specific */
+
+static unsigned long		kdr7;		/* Unmasked kernel DR7 value */
+
+/* Masks for the bits in DR7 related to kernel breakpoints, for various
+ * values of num_kbps.  Entry n is the mask for when there are n kernel
+ * breakpoints, in debug registers 0 - (n-1).  The DR_GLOBAL_SLOWDOWN bit
+ * (GE) is handled specially.
+ */
+static const unsigned long	kdr7_masks[HB_NUM + 1] = {
+	0x00000000,
+	0x000f0003,	/* LEN0, R/W0, G0, L0 */
+	0x00ff000f,	/* Same for 0,1 */
+	0x0fff003f,	/* Same for 0,1,2 */
+	0xffff00ff	/* Same for 0,1,2,3 */
+};
+
+#endif	/* __KERNEL__ */
+#endif	/* _I386_HW_BREAKPOINT_H */
+
Index: linux-bkpt-lkml-27-rc9/arch/x86/kernel/Makefile
===================================================================
--- linux-bkpt-lkml-27-rc9.orig/arch/x86/kernel/Makefile
+++ linux-bkpt-lkml-27-rc9/arch/x86/kernel/Makefile
@@ -33,7 +33,7 @@ obj-$(CONFIG_X86_64)	+= sys_x86_64.o x86
 obj-$(CONFIG_X86_64)	+= syscall_64.o vsyscall_64.o
 obj-y			+= bootflag.o e820.o
 obj-y			+= pci-dma.o quirks.o i8237.o topology.o kdebugfs.o
-obj-y			+= alternative.o i8253.o pci-nommu.o
+obj-y			+= alternative.o i8253.o pci-nommu.o hw_breakpoint.o
 obj-y			+= tsc.o io_delay.o rtc.o
 
 obj-$(CONFIG_X86_TRAMPOLINE)	+= trampoline.o
