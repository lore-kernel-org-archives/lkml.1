Return-Path: <linux-kernel-owner+w=401wt.eu-S1751719AbZHQMrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719AbZHQMrq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 08:47:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751197AbZHQMrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 08:47:46 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:48272 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbZHQMrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 08:47:45 -0400
Date: Mon, 17 Aug 2009 18:17:30 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Alan Stern <stern@rowland.harvard.edu>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>
Subject: [Patch 1/1] HW-BKPT: Allow per-cpu kernel-space Hardware
	Breakpoint requests
Message-ID: <20090817124730.GB13354@in.ibm.com>
References: <20090817122427.222765334@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=per_cpu_breakpoint_01
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow kernel-space hw-breakpoints to be restricted only for a subset of
CPUs using a cpumask field in 'struct hw_breakpoint'.

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
---
 arch/x86/include/asm/hw_breakpoint.h |    2 
 arch/x86/kernel/hw_breakpoint.c      |    8 +-
 include/asm-generic/hw_breakpoint.h  |    2 
 kernel/hw_breakpoint.c               |  121 ++++++++++++++++++++++++-----------
 4 files changed, 95 insertions(+), 38 deletions(-)

Index: linux-2.6-tip.hbkpt/arch/x86/kernel/hw_breakpoint.c
===================================================================
--- linux-2.6-tip.hbkpt.orig/arch/x86/kernel/hw_breakpoint.c
+++ linux-2.6-tip.hbkpt/arch/x86/kernel/hw_breakpoint.c
@@ -68,7 +68,7 @@ static unsigned long encode_dr7(int drnu
 	return bp_info;
 }
 
-void arch_update_kernel_hw_breakpoint(void *unused)
+void arch_update_kernel_hw_breakpoint(void)
 {
 	struct hw_breakpoint *bp;
 	int i, cpu = get_cpu();
@@ -78,7 +78,7 @@ void arch_update_kernel_hw_breakpoint(vo
 	set_debugreg(0UL, 7);
 
 	for (i = hbp_kernel_pos; i < HBP_NUM; i++) {
-		per_cpu(this_hbp_kernel[i], cpu) = bp = hbp_kernel[i];
+		bp = per_cpu(this_hbp_kernel[i], cpu);
 		if (bp) {
 			temp_kdr7 |= encode_dr7(i, bp->info.len, bp->info.type);
 			set_debugreg(bp->info.address, i);
@@ -207,6 +207,10 @@ int arch_validate_hwbkpt_settings(struct
 	unsigned int align;
 	int ret = -EINVAL;
 
+	/* User-space breakpoints cannot be restricted to a subset of CPUs */
+	if (tsk && bp->cpumask)
+		return ret;
+
 	switch (bp->info.type) {
 	/*
 	 * Ptrace-refactoring code
Index: linux-2.6-tip.hbkpt/include/asm-generic/hw_breakpoint.h
===================================================================
--- linux-2.6-tip.hbkpt.orig/include/asm-generic/hw_breakpoint.h
+++ linux-2.6-tip.hbkpt/include/asm-generic/hw_breakpoint.h
@@ -8,6 +8,7 @@
 #ifdef	__KERNEL__
 #include <linux/list.h>
 #include <linux/types.h>
+#include <linux/cpumask.h>
 #include <linux/kallsyms.h>
 
 /**
@@ -102,6 +103,7 @@
  */
 struct hw_breakpoint {
 	void (*triggered)(struct hw_breakpoint *, struct pt_regs *);
+	const cpumask_t *cpumask;
 	struct arch_hw_breakpoint info;
 };
 
Index: linux-2.6-tip.hbkpt/kernel/hw_breakpoint.c
===================================================================
--- linux-2.6-tip.hbkpt.orig/kernel/hw_breakpoint.c
+++ linux-2.6-tip.hbkpt/kernel/hw_breakpoint.c
@@ -47,14 +47,7 @@
  */
 static DEFINE_SPINLOCK(hw_breakpoint_lock);
 
-/* Array of kernel-space breakpoint structures */
-struct hw_breakpoint *hbp_kernel[HBP_NUM];
-
-/*
- * Per-processor copy of hbp_kernel[]. Used only when hbp_kernel is being
- * modified but we need the older copy to handle any hbp exceptions. It will
- * sync with hbp_kernel[] value after updation is done through IPIs.
- */
+/* Per-cpu copy of HW-breakpoint structure */
 DEFINE_PER_CPU(struct hw_breakpoint*, this_hbp_kernel[HBP_NUM]);
 
 /*
@@ -72,6 +65,9 @@ unsigned int hbp_kernel_pos = HBP_NUM;
  */
 unsigned int hbp_user_refcount[HBP_NUM];
 
+/* An array denoting the number of consumed HW Breakpoints on each CPU */
+static DEFINE_PER_CPU(int, hbp_consumed);
+
 /*
  * Load the debug registers during startup of a CPU.
  */
@@ -84,7 +80,7 @@ void load_debug_registers(void)
 
 	/* Prevent IPIs for new kernel breakpoint updates */
 	local_irq_save(flags);
-	arch_update_kernel_hw_breakpoint(NULL);
+	arch_update_kernel_hw_breakpoint();
 	local_irq_restore(flags);
 
 	if (test_tsk_thread_flag(tsk, TIF_DEBUG))
@@ -294,6 +290,23 @@ void unregister_user_hw_breakpoint(struc
 }
 EXPORT_SYMBOL_GPL(unregister_user_hw_breakpoint);
 
+/* Update per-cpu instances of HW Breakpoint structure */
+static void update_each_cpu_kernel_hbp(void *bp_param)
+{
+	int i, cpu = get_cpu();
+	struct hw_breakpoint *bp = (struct hw_breakpoint *)bp_param;
+
+	for (i = HBP_NUM-1; i >= hbp_kernel_pos; i--) {
+		if (per_cpu(this_hbp_kernel[i], cpu))
+			continue;
+		per_cpu(this_hbp_kernel[i], cpu) = bp;
+		per_cpu(hbp_consumed, cpu)++;
+		break;
+	}
+	arch_update_kernel_hw_breakpoint();
+	put_cpu();
+}
+
 /**
  * register_kernel_hw_breakpoint - register a hardware breakpoint for kernel space
  * @bp: the breakpoint structure to register
@@ -305,27 +318,74 @@ EXPORT_SYMBOL_GPL(unregister_user_hw_bre
 int register_kernel_hw_breakpoint(struct hw_breakpoint *bp)
 {
 	int rc;
+	unsigned int cpu;
 
 	rc = arch_validate_hwbkpt_settings(bp, NULL);
 	if (rc)
 		return rc;
 
+	/* Default to ALL CPUs if cpumask is not specified */
+	if (!bp->cpumask)
+		bp->cpumask = cpu_possible_mask;
+
 	spin_lock_bh(&hw_breakpoint_lock);
 
-	rc = -ENOSPC;
-	/* Check if we are over-committing */
-	if ((hbp_kernel_pos > 0) && (!hbp_user_refcount[hbp_kernel_pos-1])) {
-		hbp_kernel_pos--;
-		hbp_kernel[hbp_kernel_pos] = bp;
-		on_each_cpu(arch_update_kernel_hw_breakpoint, NULL, 1);
-		rc = 0;
+	rc = -EINVAL;
+	for_each_cpu(cpu, bp->cpumask) {
+		/*
+		 * Check if we need a new slot of debug register in every CPU
+		 * i.e. if 'hbp_kernel_pos' needs to be decremented or if the
+		 * request can be serviced by consuming the vacant debug
+		 * registers
+		 */
+		if (per_cpu(hbp_consumed, cpu) == (HBP_NUM - hbp_kernel_pos)) {
+			/* Check if a new slot is available */
+			if ((hbp_kernel_pos == 0) ||
+			    (hbp_user_refcount[hbp_kernel_pos - 1] != 0)) {
+				rc = -ENOSPC;
+				goto err_ret;
+			} else {
+				hbp_kernel_pos--;
+				break;
+			}
+		}
 	}
 
+	if (cpumask_test_cpu(smp_processor_id(), bp->cpumask))
+		update_each_cpu_kernel_hbp(bp);
+	smp_call_function_many(bp->cpumask, update_each_cpu_kernel_hbp, bp, 1);
+	rc = 0;
+
+err_ret:
 	spin_unlock_bh(&hw_breakpoint_lock);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(register_kernel_hw_breakpoint);
 
+/* Removes breakpoint structure from the per-cpu breakpoint data-structure */
+static void remove_each_cpu_kernel_hbp(void *bp_param)
+{
+	int i, j, cpu = get_cpu();
+	struct hw_breakpoint *bp  = (struct hw_breakpoint *)bp_param;
+
+	for (i = HBP_NUM-1; i >= hbp_kernel_pos; i--) {
+		if (per_cpu(this_hbp_kernel[i], cpu) == bp) {
+			/*
+			 * Shift the breakpoint structures by one-position
+			 * above to compact them
+			 */
+			for (j = i; j > hbp_kernel_pos; j--)
+				per_cpu(this_hbp_kernel[j], cpu) =
+					per_cpu(this_hbp_kernel[j-1], cpu);
+			per_cpu(this_hbp_kernel[hbp_kernel_pos], cpu) = NULL;
+			break;
+		}
+	}
+	per_cpu(hbp_consumed, cpu)--;
+	arch_update_kernel_hw_breakpoint();
+	put_cpu();
+}
+
 /**
  * unregister_kernel_hw_breakpoint - unregister a HW breakpoint for kernel space
  * @bp: the breakpoint structure to unregister
@@ -334,32 +394,23 @@ EXPORT_SYMBOL_GPL(register_kernel_hw_bre
  */
 void unregister_kernel_hw_breakpoint(struct hw_breakpoint *bp)
 {
-	int i, j;
+	int cpu;
 
 	spin_lock_bh(&hw_breakpoint_lock);
 
-	/* Find the 'bp' in our list of breakpoints for kernel */
-	for (i = hbp_kernel_pos; i < HBP_NUM; i++)
-		if (bp == hbp_kernel[i])
-			break;
-
-	/* Check if we did not find a match for 'bp'. If so return early */
-	if (i == HBP_NUM) {
-		spin_unlock_bh(&hw_breakpoint_lock);
-		return;
-	}
+	if (cpumask_test_cpu(smp_processor_id(), bp->cpumask))
+		remove_each_cpu_kernel_hbp(bp);
+	smp_call_function_many(bp->cpumask, remove_each_cpu_kernel_hbp, bp, 1);
+	for_each_possible_cpu(cpu)
+		if (per_cpu(hbp_consumed, cpu) == (HBP_NUM - hbp_kernel_pos))
+			goto ret_path;
 
-	/*
-	 * We'll shift the breakpoints one-level above to compact if
-	 * unregistration creates a hole
-	 */
-	for (j = i; j > hbp_kernel_pos; j--)
-		hbp_kernel[j] = hbp_kernel[j-1];
+	if (bp->cpumask == cpu_possible_mask)
+		bp->cpumask = NULL;
 
-	hbp_kernel[hbp_kernel_pos] = NULL;
-	on_each_cpu(arch_update_kernel_hw_breakpoint, NULL, 1);
 	hbp_kernel_pos++;
 
+ret_path:
 	spin_unlock_bh(&hw_breakpoint_lock);
 }
 EXPORT_SYMBOL_GPL(unregister_kernel_hw_breakpoint);
Index: linux-2.6-tip.hbkpt/arch/x86/include/asm/hw_breakpoint.h
===================================================================
--- linux-2.6-tip.hbkpt.orig/arch/x86/include/asm/hw_breakpoint.h
+++ linux-2.6-tip.hbkpt/arch/x86/include/asm/hw_breakpoint.h
@@ -47,7 +47,7 @@ extern int arch_validate_hwbkpt_settings
 						struct task_struct *tsk);
 extern void arch_update_user_hw_breakpoint(int pos, struct task_struct *tsk);
 extern void arch_flush_thread_hw_breakpoint(struct task_struct *tsk);
-extern void arch_update_kernel_hw_breakpoint(void *);
+extern void arch_update_kernel_hw_breakpoint(void);
 extern int hw_breakpoint_exceptions_notify(struct notifier_block *unused,
 				     unsigned long val, void *data);
 #endif	/* __KERNEL__ */

