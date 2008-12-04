Return-Path: <linux-kernel-owner+w=401wt.eu-S1759187AbYLDTLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759187AbYLDTLn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 14:11:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756248AbYLDTLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 14:11:34 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:56343 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756096AbYLDTLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 14:11:32 -0500
Date: Fri, 5 Dec 2008 00:41:19 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Roland McGrath <roland@redhat.com>,
       akpm@linux-foundation.org, mingo@elte.hu, richardj_moore@uk.ibm.com
Subject: [RFC Patch 1/9] Introducing generic hardware breakpoint handler
	interfaces
Message-ID: <20081204191119.GA20563@in.ibm.com>
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

This patch introduces two new files hw_breakpoint.[ch] which defines the 
generic interfaces to use hardware breakpoint infrastructure of the system. 

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
---
 include/asm-generic/hw_breakpoint.h |  241 +++++++++++
 kernel/hw_breakpoint.c              |  731 ++++++++++++++++++++++++++++++++++++
 2 files changed, 972 insertions(+)

Index: linux-HBKPT-2.6.28-rc7/include/asm-generic/hw_breakpoint.h
===================================================================
--- /dev/null
+++ linux-HBKPT-2.6.28-rc7/include/asm-generic/hw_breakpoint.h
@@ -0,0 +1,241 @@
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
+
+/**
+ * struct hw_breakpoint - unified kernel/user-space hardware breakpoint
+ * @node: internal linked-list management
+ * @triggered: callback invoked after target address access
+ * @installed: callback invoked when the breakpoint is installed
+ * @uninstalled: callback invoked when the breakpoint is uninstalled
+ * @info: arch-specific breakpoint info (address, length, and type)
+ * @priority: requested priority level
+ * @status: current registration/installation status
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
+ * When a breakpoint gets hit, the @pre_handler or @post_handler (whichever or
+ * both depending upon architecture support and assignment by user) callback is
+ * invoked in_interrupt with a pointer to the %hw_breakpoint structure and the
+ * processor registers.
+ * Data breakpoints occur after the memory access has taken place.
+ * Breakpoints are disabled during execution @triggered, to avoid
+ * recursive traps and allow unhindered access to breakpointed memory.
+ *
+ * Hardware breakpoints are implemented using the CPU's debug registers,
+ * which are a limited hardware resource.  Requests to register a
+ * breakpoint will always succeed provided the parameters are valid,
+ * but the breakpoint may not be installed in a debug register right
+ * away.  Physical debug registers are allocated based on the priority
+ * level stored in @priority (higher values indicate higher priority).
+ * User-space breakpoints within a single thread compete with one
+ * another, and all user-space breakpoints compete with all kernel-space
+ * breakpoints; however user-space breakpoints in different threads do
+ * not compete.  %HW_BREAKPOINT_PRIO_PTRACE is the level used for ptrace
+ * requests; an unobtrusive kernel-space breakpoint will use
+ * %HW_BREAKPOINT_PRIO_NORMAL to avoid disturbing user programs.  A
+ * kernel-space breakpoint that always wants to be installed and doesn't
+ * care about disrupting user debugging sessions can specify
+ * %HW_BREAKPOINT_PRIO_HIGH.
+ *
+ * A particular breakpoint may be allocated (installed in) a debug
+ * register or deallocated (uninstalled) from its debug register at any
+ * time, as other breakpoints are registered and unregistered.  The
+ * @installed and @uninstalled callbacks are invoked in_atomic when these
+ * events occur.  It is legal for @installed or @uninstalled to be %NULL,
+ * but one of the handlers - @pre_handler or @post_handler must be populated
+ * (please check support for your architecture using pre_ and
+ * post_handler_supported() routines to check for support.  Note that it is not
+ * possible to register or unregister a user-space breakpoint from within a
+ * callback routine, since doing so requires a process context.  Note that for
+ * user breakpoints, while in @installed and @uninstalled the thread may be
+ * context switched. Hence it may not be safe to call printk().
+ *
+ * For kernel-space breakpoints, @installed is invoked after the
+ * breakpoint is actually installed and @uninstalled is invoked before
+ * the breakpoint is actually uninstalled.  As a result the @pre_ and
+ * @post_handler() routines may be invoked when not expected, but this way you
+ * will know that during the time interval from @installed to @uninstalled, all
+ * events are faithfully reported.  (It is not possible to do any better than
+ * this in general, because on SMP systems there is no way to set a debug
+ * register simultaneously on all CPUs.)  The same isn't always true with
+ * user-space breakpoints, but the differences should not be visible to a
+ * user process.
+ *
+ * If you need to know whether your kernel-space breakpoint was installed
+ * immediately upon registration, you can check the return value from
+ * register_kernel_hw_breakpoint().  If the value is not > 0, you can
+ * give up and unregister the breakpoint right away.
+ *
+ * @node and @status are intended for internal use.  However @status
+ * may be read to determine whether or not the breakpoint is currently
+ * installed.  (The value is not reliable unless local interrupts are
+ * disabled.)
+ *
+ * This sample code sets a breakpoint on pid_max and registers a callback
+ * function for writes to that variable.  Note that it is not portable
+ * as written, because not all architectures support HW_BREAKPOINT_LEN_4.
+ *
+ * ----------------------------------------------------------------------
+ *
+ * #include <asm/hw_breakpoint.h>
+ *
+ * static void my_pre_handler(struct hw_breakpoint *bp, struct pt_regs *regs)
+ * {
+ * 	printk(KERN_DEBUG "Inside pre_handler of breakpoint exception\n");
+ * 	dump_stack();
+ *  	.......<more debugging output>........
+ * }
+ *
+ * static void my_post_handler(struct hw_breakpoint *bp, struct pt_regs *regs)
+ * {
+ * 	printk(KERN_DEBUG "Inside post_handler of breakpoint exception\n");
+ * 	dump_stack();
+ *  	.......<more debugging output>........
+ * }
+ *
+ * static struct hw_breakpoint my_bp;
+ *
+ * static int init_module(void)
+ * {
+ *	..........<do anything>............
+ *	int bkpt_type = HW_BREAKPOINT_WRITE;
+ *
+ *	if (pre_handler_supported(bkpt_type)
+ *		my_bp.pre_handler = my_pre_handler;
+ *	if (post_handler_supported(bkpt_type)
+ *		my_bp.post_handler = my_post_handler;
+ *	my_bp.priority = HW_BREAKPOINT_PRIO_NORMAL;
+ *	rc = register_kernel_hw_breakpoint(&my_bp, &pid_max,
+ *			HW_BREAKPOINT_LEN_4, bkpt_type);
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
+ *
+ */
+struct hw_breakpoint {
+	struct list_head	node;
+	void		(*installed)(struct hw_breakpoint *);
+	void		(*uninstalled)(struct hw_breakpoint *);
+	void		(*triggered)(struct hw_breakpoint *,
+							struct pt_regs *);
+	struct arch_hw_breakpoint	info;
+	u8		priority;
+	u8		status;
+};
+
+/*
+ * Inline accessor routines to retrieve the arch-specific parts of
+ * a breakpoint structure:
+ */
+static const void *hw_breakpoint_get_kaddress(struct hw_breakpoint *bp);
+static const void __user *hw_breakpoint_get_uaddress(struct hw_breakpoint *bp);
+static unsigned hw_breakpoint_get_len(struct hw_breakpoint *bp);
+static unsigned hw_breakpoint_get_type(struct hw_breakpoint *bp);
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
+/* Standard HW breakpoint priority levels (higher value = higher priority) */
+#define HW_BREAKPOINT_PRIO_NORMAL	25
+#define HW_BREAKPOINT_PRIO_PTRACE	50
+#define HW_BREAKPOINT_PRIO_HIGH		75
+
+/* HW breakpoint status values (0 = not registered) */
+#define HW_BREAKPOINT_REGISTERED	1
+#define HW_BREAKPOINT_INSTALLED		2
+
+static DEFINE_MUTEX(hw_breakpoint_mutex);	/* Protects everything */
+
+/*
+ * The following two routines are meant to be called only from within
+ * the ptrace or utrace subsystems.  The tsk argument will usually be a
+ * process being debugged by the current task, although it is also legal
+ * for tsk to be the current task.  In any case it must be guaranteed
+ * that tsk will not start running in user mode while its breakpoints are
+ * being modified.
+ */
+int register_user_hw_breakpoint(struct task_struct *tsk,
+		struct hw_breakpoint *bp,
+		const void __user *address, unsigned len, unsigned type);
+void unregister_user_hw_breakpoint(struct task_struct *tsk,
+		struct hw_breakpoint *bp);
+
+/*
+ * Kernel breakpoints are not associated with any particular thread.
+ */
+int register_kernel_hw_breakpoint(struct hw_breakpoint *bp,
+		const void *address, unsigned len, unsigned type);
+void unregister_kernel_hw_breakpoint(struct hw_breakpoint *bp);
+
+struct thread_hw_breakpoint *alloc_thread_hw_breakpoint(
+						struct task_struct *tsk);
+
+#endif	/* __KERNEL__ */
+#endif	/* _ASM_GENERIC_HW_BREAKPOINT_H */
Index: linux-HBKPT-2.6.28-rc7/kernel/hw_breakpoint.c
===================================================================
--- /dev/null
+++ linux-HBKPT-2.6.28-rc7/kernel/hw_breakpoint.c
@@ -0,0 +1,731 @@
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
+
+/*
+ * Install the debug register values for a new thread.
+ */
+void switch_to_thread_hw_breakpoint(struct task_struct *tsk)
+{
+	struct thread_hw_breakpoint *thbi = tsk->thread.hw_breakpoint_info;
+	struct cpu_hw_breakpoint *chbi;
+	struct kernel_bp_data *thr_kbpdata;
+
+	/* This routine is on the hot path; it gets called for every
+	 * context switch into a task with active breakpoints.  We
+	 * must make sure that the common case executes as quickly as
+	 * possible.
+	 */
+	chbi = &per_cpu(cpu_info, get_cpu());
+	chbi->bp_task = tsk;
+
+	/* Use RCU to synchronize with external updates */
+	rcu_read_lock();
+
+	/* Other CPUs might be making updates to the list of kernel
+	 * breakpoints at this time.  If they are, they will modify
+	 * the other entry in kbpdata[] -- the one not pointed to
+	 * by chbi->cur_kbpdata.  So the update itself won't affect
+	 * us directly.
+	 *
+	 * However when the update is finished, an IPI will arrive
+	 * telling this CPU to change chbi->cur_kbpdata.  We need
+	 * to use a single consistent kbpdata[] entry, the present one.
+	 * So we'll copy the pointer to a local variable, thr_kbpdata,
+	 * and we must prevent the compiler from aliasing the two
+	 * pointers.  Only a compiler barrier is required, not a full
+	 * memory barrier, because everything takes place on a single CPU.
+	 */
+ restart:
+	thr_kbpdata = chbi->cur_kbpdata;
+	barrier();
+
+	/* Normally we can keep the same debug register settings as the
+	 * last time this task ran.  But if the kernel breakpoints have
+	 * changed or any user breakpoints have been registered or
+	 * unregistered, we need to handle the updates and possibly
+	 * send out some notifications.
+	 */
+	if (unlikely(thbi->gennum != thr_kbpdata->gennum)) {
+		struct hw_breakpoint *bp;
+		int i;
+		int num;
+
+		thbi->gennum = thr_kbpdata->gennum;
+		arch_update_thbi(thbi, thr_kbpdata);
+		num = thr_kbpdata->num_kbps;
+
+		/* This code can be invoked while a debugger is actively
+		 * updating the thread's breakpoint list. We use RCU to
+		 * protect our access to the list pointers. */
+		thbi->num_installed = 0;
+		i = HB_NUM;
+		list_for_each_entry_rcu(bp, &thbi->thread_bps, node) {
+
+			/* If this register is allocated for kernel bps,
+			 * don't install.  Otherwise do. */
+			if (--i < num) {
+				if (bp->status == HW_BREAKPOINT_INSTALLED) {
+					if (bp->uninstalled)
+						(bp->uninstalled)(bp);
+					bp->status = HW_BREAKPOINT_REGISTERED;
+				}
+			} else {
+				++thbi->num_installed;
+				if (bp->status != HW_BREAKPOINT_INSTALLED) {
+					bp->status = HW_BREAKPOINT_INSTALLED;
+					if (bp->installed)
+						(bp->installed)(bp);
+				}
+			}
+		}
+	}
+
+	/* Set the debug register */
+	arch_install_thbi(thbi);
+
+	/* Were there any kernel breakpoint changes while we were running? */
+	if (unlikely(chbi->cur_kbpdata != thr_kbpdata)) {
+
+		/* Some debug registers now be assigned to kernel bps and
+		 * we might have messed them up.  Reload all the kernel bps
+		 * and then reload the thread bps.
+		 */
+		arch_install_chbi(chbi);
+		goto restart;
+	}
+
+	rcu_read_unlock();
+	put_cpu_no_resched();
+}
+
+/*
+ * Install the debug register values for just the kernel, no thread.
+ */
+static void switch_to_none_hw_breakpoint(void)
+{
+	struct cpu_hw_breakpoint *chbi;
+
+	chbi = &per_cpu(cpu_info, get_cpu());
+	chbi->bp_task = NULL;
+
+	/* This routine gets called from only two places.  In one
+	 * the caller holds the hw_breakpoint_mutex; in the other
+	 * interrupts are disabled.  In either case, no kernel
+	 * breakpoint updates can arrive while the routine runs.
+	 * So we don't need to use RCU.
+	 */
+	arch_install_none(chbi);
+	put_cpu_no_resched();
+}
+
+/*
+ * Update the debug registers on this CPU.
+ */
+static void update_this_cpu(void *unused)
+{
+	struct cpu_hw_breakpoint *chbi;
+	struct task_struct *tsk = current;
+
+	chbi = &per_cpu(cpu_info, get_cpu());
+
+	/* Install both the kernel and the user breakpoints */
+	arch_install_chbi(chbi);
+	if (test_tsk_thread_flag(tsk, TIF_DEBUG))
+		switch_to_thread_hw_breakpoint(tsk);
+
+	put_cpu_no_resched();
+}
+
+/*
+ * Tell all CPUs to update their debug registers.
+ *
+ * The caller must hold hw_breakpoint_mutex.
+ */
+static void update_all_cpus(void)
+{
+	/* We don't need to use any sort of memory barrier.  The IPI
+	 * carried out by on_each_cpu() includes its own barriers.
+	 */
+	on_each_cpu(update_this_cpu, NULL, 0);
+	synchronize_rcu();
+}
+
+/*
+ * Load the debug registers during startup of a CPU.
+ */
+void load_debug_registers(void)
+{
+	unsigned long flags;
+
+	/* Prevent IPIs for new kernel breakpoint updates */
+	local_irq_save(flags);
+
+	rcu_read_lock();
+	update_this_cpu(NULL);
+	rcu_read_unlock();
+
+	local_irq_restore(flags);
+}
+
+/*
+ * Take the 4 highest-priority breakpoints in a thread and accumulate
+ * their priorities in tprio.  Highest-priority entry is in tprio[3].
+ */
+static void accum_thread_tprio(struct thread_hw_breakpoint *thbi)
+{
+	int i;
+
+	for (i = HB_NUM - 1; i >= 0 && thbi->bps[i]; --i)
+		tprio[i] = max(tprio[i], thbi->bps[i]->priority);
+}
+
+/*
+ * Recalculate the value of the tprio array, the maximum priority levels
+ * requested by user breakpoints in all threads.
+ *
+ * Each thread has a list of registered breakpoints, kept in order of
+ * decreasing priority.  We'll set tprio[0] to the maximum priority of
+ * the first entries in all the lists, tprio[1] to the maximum priority
+ * of the second entries in all the lists, etc.  In the end, we'll know
+ * that no thread requires breakpoints with priorities higher than the
+ * values in tprio.
+ *
+ * The caller must hold hw_breakpoint_mutex.
+ */
+static void recalc_tprio(void)
+{
+	struct thread_hw_breakpoint *thbi;
+
+	memset(tprio, 0, sizeof tprio);
+
+	/* Loop through all threads having registered breakpoints
+	 * and accumulate the maximum priority levels in tprio.
+	 */
+	list_for_each_entry(thbi, &thread_list, node)
+		accum_thread_tprio(thbi);
+}
+
+/*
+ * Decide how many debug registers will be allocated to kernel breakpoints
+ * and consequently, how many remain available for user breakpoints.
+ *
+ * The priorities of the entries in the list of registered kernel bps
+ * are compared against the priorities stored in tprio[].  The 4 highest
+ * winners overall get to be installed in a debug register; num_kpbs
+ * keeps track of how many of those winners come from the kernel list.
+ *
+ * If num_kbps changes, or if a kernel bp changes its installation status,
+ * then call update_all_cpus() so that the debug registers will be set
+ * correctly on every CPU.  If neither condition holds then the set of
+ * kernel bps hasn't changed, and nothing more needs to be done.
+ *
+ * The caller must hold hw_breakpoint_mutex.
+ */
+static void balance_kernel_vs_user(void)
+{
+	int k, u;
+	int changed = 0;
+	struct hw_breakpoint *bp;
+	struct kernel_bp_data *new_kbpdata;
+
+	/* Determine how many debug registers are available for kernel
+	 * breakpoints as opposed to user breakpoints, based on the
+	 * priorities.  Ties are resolved in favor of user bps.
+	 */
+	k = 0;			/* Next kernel bp to allocate */
+	u = HB_NUM - 1;		/* Next user bp to allocate */
+	bp = list_entry(kernel_bps.next, struct hw_breakpoint, node);
+	while (k <= u) {
+		if (&bp->node == &kernel_bps || tprio[u] >= bp->priority)
+			--u;		/* User bps win a slot */
+		else {
+			++k;		/* Kernel bp wins a slot */
+			if (bp->status != HW_BREAKPOINT_INSTALLED)
+				changed = 1;
+			bp = list_entry(bp->node.next, struct hw_breakpoint,
+					node);
+		}
+	}
+	if (k != cur_kbpdata->num_kbps)
+		changed = 1;
+
+	/* Notify the remaining kernel breakpoints that they are about
+	 * to be uninstalled.
+	 */
+	list_for_each_entry_from(bp, &kernel_bps, node) {
+		if (bp->status == HW_BREAKPOINT_INSTALLED) {
+			if (bp->uninstalled)
+				(bp->uninstalled)(bp);
+			bp->status = HW_BREAKPOINT_REGISTERED;
+			changed = 1;
+		}
+	}
+
+	if (changed) {
+		cur_kbpindex ^= 1;
+		new_kbpdata = &kbpdata[cur_kbpindex];
+		new_kbpdata->gennum = cur_kbpdata->gennum + 1;
+		new_kbpdata->num_kbps = k;
+		arch_new_kbpdata(new_kbpdata);
+		u = 0;
+		list_for_each_entry(bp, &kernel_bps, node) {
+			if (u >= k)
+				break;
+			new_kbpdata->bps[u] = bp;
+			++u;
+		}
+		rcu_assign_pointer(cur_kbpdata, new_kbpdata);
+
+		/* Tell all the CPUs to update their debug registers */
+		update_all_cpus();
+
+		/* Notify the breakpoints that just got installed */
+		for (u = 0; u < k; ++u) {
+			bp = new_kbpdata->bps[u];
+			if (bp->status != HW_BREAKPOINT_INSTALLED) {
+				bp->status = HW_BREAKPOINT_INSTALLED;
+				if (bp->installed)
+					(bp->installed)(bp);
+			}
+		}
+	}
+}
+
+/*
+ * Return the pointer to a thread's hw_breakpoint info area,
+ * and try to allocate one if it doesn't exist.
+ *
+ * The caller must hold hw_breakpoint_mutex.
+ */
+struct thread_hw_breakpoint *alloc_thread_hw_breakpoint(
+		struct task_struct *tsk)
+{
+	if (!tsk->thread.hw_breakpoint_info && !(tsk->flags & PF_EXITING)) {
+		struct thread_hw_breakpoint *thbi;
+
+		thbi = kzalloc(sizeof(struct thread_hw_breakpoint),
+				GFP_KERNEL);
+		if (thbi) {
+			INIT_LIST_HEAD(&thbi->node);
+			INIT_LIST_HEAD(&thbi->thread_bps);
+
+			/* Force an update the next time tsk runs */
+			thbi->gennum = cur_kbpdata->gennum - 2;
+			tsk->thread.hw_breakpoint_info = thbi;
+		}
+	}
+	return tsk->thread.hw_breakpoint_info;
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
+	struct thread_hw_breakpoint *thbi = tsk->thread.hw_breakpoint_info;
+	struct hw_breakpoint *bp;
+
+	if (!thbi)
+		return;
+	mutex_lock(&hw_breakpoint_mutex);
+
+	/* Let the breakpoints know they are being uninstalled */
+	list_for_each_entry(bp, &thbi->thread_bps, node) {
+		if (bp->status == HW_BREAKPOINT_INSTALLED && bp->uninstalled)
+			(bp->uninstalled)(bp);
+		bp->status = 0;
+	}
+
+	/* Remove tsk from the list of all threads with registered bps */
+	list_del(&thbi->node);
+
+	/* The thread no longer has any breakpoints associated with it */
+	clear_tsk_thread_flag(tsk, TIF_DEBUG);
+	tsk->thread.hw_breakpoint_info = NULL;
+	kfree(thbi);
+
+	/* Recalculate and rebalance the kernel-vs-user priorities */
+	recalc_tprio();
+	balance_kernel_vs_user();
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
+ * Store the highest-priority thread breakpoint entries in an array.
+ */
+static void store_thread_bp_array(struct thread_hw_breakpoint *thbi)
+{
+	struct hw_breakpoint *bp;
+	int i;
+
+	i = HB_NUM - 1;
+	list_for_each_entry(bp, &thbi->thread_bps, node) {
+		thbi->bps[i] = bp;
+		arch_store_thread_bp_array(thbi, bp, i);
+		if (--i < 0)
+			break;
+	}
+	while (i >= 0)
+		thbi->bps[i--] = NULL;
+
+	/* Force an update the next time this task runs */
+	thbi->gennum = cur_kbpdata->gennum - 2;
+}
+
+/*
+ * Insert a new breakpoint in a priority-sorted list.
+ * Return the bp's index in the list.
+ *
+ * Thread invariants:
+ *	tsk_thread_flag(tsk, TIF_DEBUG) set implies
+ *		tsk->thread.hw_breakpoint_info is not NULL.
+ *	tsk_thread_flag(tsk, TIF_DEBUG) set iff thbi->thread_bps is non-empty
+ *		iff thbi->node is on thread_list.
+ */
+static int insert_bp_in_list(struct hw_breakpoint *bp,
+		struct thread_hw_breakpoint *thbi, struct task_struct *tsk)
+{
+	struct list_head *head;
+	int pos;
+	struct hw_breakpoint *temp_bp;
+
+	/* tsk and thbi are NULL for kernel bps, non-NULL for user bps */
+	if (tsk)
+		head = &thbi->thread_bps;
+	else
+		head = &kernel_bps;
+
+	/* Equal-priority breakpoints get listed first-come-first-served */
+	pos = 0;
+	list_for_each_entry(temp_bp, head, node) {
+		if (bp->priority > temp_bp->priority)
+			break;
+		++pos;
+	}
+	bp->status = HW_BREAKPOINT_REGISTERED;
+	list_add_tail(&bp->node, &temp_bp->node);
+
+	if (tsk) {
+		store_thread_bp_array(thbi);
+
+		/* Is this the thread's first registered breakpoint? */
+		if (list_empty(&thbi->node)) {
+			set_tsk_thread_flag(tsk, TIF_DEBUG);
+			list_add(&thbi->node, &thread_list);
+		}
+	}
+	return pos;
+}
+
+/*
+ * Remove a breakpoint from its priority-sorted list.
+ *
+ * See the invariants mentioned above.
+ */
+static void remove_bp_from_list(struct hw_breakpoint *bp,
+		struct thread_hw_breakpoint *thbi, struct task_struct *tsk)
+{
+	/* Remove bp from the thread's/kernel's list.  If the list is now
+	 * empty we must clear the TIF_DEBUG flag.  But keep the
+	 * thread_hw_breakpoint structure, so that the virtualized debug
+	 * register values will remain valid.
+	 */
+	list_del(&bp->node);
+	if (tsk) {
+		store_thread_bp_array(thbi);
+
+		if (list_empty(&thbi->thread_bps)) {
+			list_del_init(&thbi->node);
+			clear_tsk_thread_flag(tsk, TIF_DEBUG);
+		}
+	}
+
+	/* Tell the breakpoint it is being uninstalled */
+	if (bp->status == HW_BREAKPOINT_INSTALLED && bp->uninstalled)
+		(bp->uninstalled)(bp);
+	bp->status = 0;
+}
+
+/*
+ * Validate the settings in a hw_breakpoint structure.
+ */
+static int validate_settings(struct hw_breakpoint *bp, struct task_struct *tsk,
+		unsigned long address, unsigned len, unsigned int type)
+{
+	int ret;
+	unsigned int align;
+
+	ret = arch_validate_hwbkpt_settings(bp, address, len, type, &align);
+	if (ret < 0)
+		goto err;
+
+	/* Check that the low-order bits of the address are appropriate
+	 * for the alignment implied by len.
+	 */
+	if (address & align)
+		return -EINVAL;
+
+	/* Check that the virtual address is in the proper range */
+	if (tsk) {
+		if (!arch_check_va_in_userspace(address, tsk))
+			return -EFAULT;
+	} else {
+		if (!arch_check_va_in_kernelspace(address))
+			return -EFAULT;
+	}
+ err:
+	return ret;
+}
+
+/*
+ * Actual implementation of register_user_hw_breakpoint.
+ */
+int __register_user_hw_breakpoint(struct task_struct *tsk,
+		struct hw_breakpoint *bp,
+		unsigned long address, unsigned len, unsigned type)
+{
+	int rc;
+	struct thread_hw_breakpoint *thbi;
+	int pos;
+
+	bp->status = 0;
+	rc = validate_settings(bp, tsk, address, len, type);
+	if (rc)
+		return rc;
+
+	thbi = alloc_thread_hw_breakpoint(tsk);
+	if (!thbi)
+		return -ENOMEM;
+
+	/* Insert bp in the thread's list */
+	pos = insert_bp_in_list(bp, thbi, tsk);
+	arch_register_user_hw_breakpoint(bp, thbi);
+
+	/* Update and rebalance the priorities.  We don't need to go through
+	 * the list of all threads; adding a breakpoint can only cause the
+	 * priorities for this thread to increase.
+	 */
+	accum_thread_tprio(thbi);
+	balance_kernel_vs_user();
+
+	/* Did bp get allocated to a debug register?  We can tell from its
+	 * position in the list.  The number of registers allocated to
+	 * kernel breakpoints is num_kbps; all the others are available for
+	 * user breakpoints.  If bp's position in the priority-ordered list
+	 * is low enough, it will get a register.
+	 */
+	if (pos < HB_NUM - cur_kbpdata->num_kbps) {
+		rc = 1;
+
+		/* Does it need to be installed right now? */
+		if (tsk == current)
+			switch_to_thread_hw_breakpoint(tsk);
+		/* Otherwise it will get installed the next time tsk runs */
+	}
+
+	return rc;
+}
+
+/**
+ * register_user_hw_breakpoint - register a hardware breakpoint for user space
+ * @tsk: the task in whose memory space the breakpoint will be set
+ * @bp: the breakpoint structure to register
+ * @address: location (virtual address) of the breakpoint
+ * @len: encoded extent of the breakpoint address (1, 2, 4, or 8 bytes)
+ * @type: breakpoint type (read-only, write-only, read-write, or execute)
+ *
+ * This routine registers a breakpoint to be associated with @tsk's
+ * memory space and active only while @tsk is running.  It does not
+ * guarantee that the breakpoint will be allocated to a debug register
+ * immediately; there may be other higher-priority breakpoints registered
+ * which require the use of all the debug registers.
+ *
+ * @tsk will normally be a process being debugged by the current process,
+ * but it may also be the current process.
+ *
+ * @address, @len, and @type are checked for validity and stored in
+ * encoded form in @bp.  @bp->triggered and @bp->priority must be set
+ * properly.
+ *
+ * Returns 1 if @bp is allocated to a debug register, 0 if @bp is
+ * registered but not allowed to be installed, otherwise a negative error
+ * code.
+ */
+int register_user_hw_breakpoint(struct task_struct *tsk,
+		struct hw_breakpoint *bp,
+		const void __user *address, unsigned len, unsigned type)
+{
+	int rc;
+
+	mutex_lock(&hw_breakpoint_mutex);
+	rc = __register_user_hw_breakpoint(tsk, bp,
+			(unsigned long) address, len, type);
+	mutex_unlock(&hw_breakpoint_mutex);
+	return rc;
+}
+
+/*
+ * Actual implementation of unregister_user_hw_breakpoint.
+ */
+void __unregister_user_hw_breakpoint(struct task_struct *tsk,
+		struct hw_breakpoint *bp)
+{
+	struct thread_hw_breakpoint *thbi = tsk->thread.hw_breakpoint_info;
+
+	if (!bp->status)
+		return;		/* Not registered */
+
+	/* Remove bp from the thread's list */
+	remove_bp_from_list(bp, thbi, tsk);
+	arch_unregister_user_hw_breakpoint(bp, thbi);
+
+	/* Recalculate and rebalance the kernel-vs-user priorities,
+	 * and actually uninstall bp if necessary.
+	 */
+	recalc_tprio();
+	balance_kernel_vs_user();
+	if (tsk == current)
+		switch_to_thread_hw_breakpoint(tsk);
+}
+
+/**
+ * unregister_user_hw_breakpoint - unregister a hardware breakpoint for user space
+ * @tsk: the task in whose memory space the breakpoint is registered
+ * @bp: the breakpoint structure to unregister
+ *
+ * Uninstalls and unregisters @bp.
+ */
+void unregister_user_hw_breakpoint(struct task_struct *tsk,
+		struct hw_breakpoint *bp)
+{
+	mutex_lock(&hw_breakpoint_mutex);
+	__unregister_user_hw_breakpoint(tsk, bp);
+	mutex_unlock(&hw_breakpoint_mutex);
+}
+
+/**
+ * register_kernel_hw_breakpoint - register a hardware breakpoint for kernel space
+ * @bp: the breakpoint structure to register
+ * @address: location (virtual address) of the breakpoint
+ * @len: encoded extent of the breakpoint address (1, 2, 4, or 8 bytes)
+ * @type: breakpoint type (read-only, write-only, read-write, or execute)
+ *
+ * This routine registers a breakpoint to be active at all times.  It
+ * does not guarantee that the breakpoint will be allocated to a debug
+ * register immediately; there may be other higher-priority breakpoints
+ * registered which require the use of all the debug registers.
+ *
+ * @address, @len, and @type are checked for validity and stored in
+ * encoded form in @bp.  @bp->triggered and @bp->priority must be set
+ * properly.
+ *
+ * Returns 1 if @bp is allocated to a debug register, 0 if @bp is
+ * registered but not allowed to be installed, otherwise a negative error
+ * code.
+ */
+int register_kernel_hw_breakpoint(struct hw_breakpoint *bp,
+		const void *address, unsigned len, unsigned type)
+{
+	int rc;
+	int pos;
+
+	bp->status = 0;
+	rc = validate_settings(bp, NULL, (unsigned long) address, len, type);
+	if (rc)
+		return rc;
+
+	mutex_lock(&hw_breakpoint_mutex);
+
+	/* Insert bp in the kernel's list */
+	pos = insert_bp_in_list(bp, NULL, NULL);
+	arch_register_kernel_hw_breakpoint(bp);
+
+	/* Rebalance the priorities.  This will install bp if it
+	 * was allocated a debug register.
+	 */
+	balance_kernel_vs_user();
+
+	/* Did bp get allocated to a debug register?  We can tell from its
+	 * position in the list.  The number of registers allocated to
+	 * kernel breakpoints is num_kbps; all the others are available for
+	 * user breakpoints.  If bp's position in the priority-ordered list
+	 * is low enough, it will get a register.
+	 */
+	if (pos < cur_kbpdata->num_kbps)
+		rc = 1;
+
+	mutex_unlock(&hw_breakpoint_mutex);
+	return rc;
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
+	if (!bp->status)
+		return;		/* Not registered */
+	mutex_lock(&hw_breakpoint_mutex);
+
+	/* Remove bp from the kernel's list */
+	remove_bp_from_list(bp, NULL, NULL);
+	arch_unregister_kernel_hw_breakpoint(bp);
+
+	/* Rebalance the priorities.  This will uninstall bp if it
+	 * was allocated a debug register.
+	 */
+	balance_kernel_vs_user();
+
+	mutex_unlock(&hw_breakpoint_mutex);
+}
+EXPORT_SYMBOL_GPL(unregister_kernel_hw_breakpoint);
