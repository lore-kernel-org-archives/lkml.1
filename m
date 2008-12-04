Return-Path: <linux-kernel-owner+w=401wt.eu-S1759431AbYLDTMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759431AbYLDTMX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 14:12:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756287AbYLDTMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 14:12:09 -0500
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:39454 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756279AbYLDTMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 14:12:06 -0500
Date: Fri, 5 Dec 2008 00:41:56 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Roland McGrath <roland@redhat.com>,
       akpm@linux-foundation.org, mingo@elte.hu, richardj_moore@uk.ibm.com
Subject: [RFC Patch 2/9] x86 architecture implementation of Hardware
	Breakpoint interfaces
Message-ID: <20081204191156.GB20563@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20081204190804.GA15134@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081204190804.GA15134@in.ibm.com>
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
 arch/x86/kernel/hw_breakpoint.c |  441 ++++++++++++++++++++++++++++++++++++++++
 include/asm-x86/hw_breakpoint.h |  128 +++++++++++
 3 files changed, 570 insertions(+), 1 deletion(-)

Index: linux-HBKPT-2.6.28-rc7/arch/x86/kernel/hw_breakpoint.c
===================================================================
--- /dev/null
+++ linux-HBKPT-2.6.28-rc7/arch/x86/kernel/hw_breakpoint.c
@@ -0,0 +1,441 @@
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
+	case HW_BREAKPOINT_WRITE:
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
+	if (bp->triggered) {
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
+ * Handle debug exception notifications.
+ */
+
+static void switch_to_none_hw_breakpoint(void);
+static struct hw_breakpoint *last_hit_bp;
+static struct thread_hw_breakpoint *last_hit_thbi;
+
+static int __kprobes hw_breakpoint_handler(struct die_args *args)
+{
+	struct cpu_hw_breakpoint *chbi;
+	int i;
+	struct hw_breakpoint *bp;
+	struct thread_hw_breakpoint *thbi = NULL;
+
+	/* The DR6 value is stored in args->err */
+#define DR6	(args->err)
+
+	if (DR6 & DR_STEP)
+		return NOTIFY_DONE;
+
+	chbi = &per_cpu(cpu_info, get_cpu());
+
+	/* Disable all breakpoints so that the callbacks can run without
+	 * triggering recursive debug exceptions.
+	 */
+	set_debugreg(0UL, 7);
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
+			switch (bp->info.type) {
+			case HW_BREAKPOINT_WRITE:
+			case HW_BREAKPOINT_RW:
+				if (bp->triggered)
+					(bp->triggered)(bp, args->regs);
+				/* Re-enable the breakpoints */
+				set_debugreg(thbi ? thbi->tkdr7 :
+						chbi->cur_kbpdata->mkdr7, 7);
+				put_cpu_no_resched();
+
+				return NOTIFY_STOP;
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
+	if (val != DIE_DEBUG)
+		return NOTIFY_DONE;
+	return hw_breakpoint_handler(data);
+}
+
+static struct notifier_block hw_breakpoint_exceptions_nb = {
+	.notifier_call = hw_breakpoint_exceptions_notify,
+	.priority = 0x7fffffff /* we need to be notified first */
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
Index: linux-HBKPT-2.6.28-rc7/include/asm-x86/hw_breakpoint.h
===================================================================
--- /dev/null
+++ linux-HBKPT-2.6.28-rc7/include/asm-x86/hw_breakpoint.h
@@ -0,0 +1,128 @@
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
+#define HW_BREAKPOINT_WRITE	0x81	/* trigger on memory write */
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
+/*
+ * Ptrace support: breakpoint trigger routine.
+ */
+
+int __register_user_hw_breakpoint(struct task_struct *tsk,
+			struct hw_breakpoint *bp,
+			unsigned long address, unsigned len, unsigned type);
+void __unregister_user_hw_breakpoint(struct task_struct *tsk,
+			struct hw_breakpoint *bp);
+
+#endif	/* __KERNEL__ */
+#endif	/* _I386_HW_BREAKPOINT_H */
+
Index: linux-HBKPT-2.6.28-rc7/arch/x86/kernel/Makefile
===================================================================
--- linux-HBKPT-2.6.28-rc7.orig/arch/x86/kernel/Makefile
+++ linux-HBKPT-2.6.28-rc7/arch/x86/kernel/Makefile
@@ -34,7 +34,7 @@ obj-$(CONFIG_X86_64)	+= sys_x86_64.o x86
 obj-$(CONFIG_X86_64)	+= syscall_64.o vsyscall_64.o
 obj-y			+= bootflag.o e820.o
 obj-y			+= pci-dma.o quirks.o i8237.o topology.o kdebugfs.o
-obj-y			+= alternative.o i8253.o pci-nommu.o
+obj-y			+= alternative.o i8253.o pci-nommu.o hw_breakpoint.o
 obj-y			+= tsc.o io_delay.o rtc.o
 
 obj-$(CONFIG_X86_TRAMPOLINE)	+= trampoline.o
