Return-Path: <linux-kernel-owner+w=401wt.eu-S1753347AbZHZUPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347AbZHZUPS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 16:15:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753267AbZHZUPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 16:15:17 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:57824 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236AbZHZUPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 16:15:13 -0400
Date: Thu, 27 Aug 2009 01:45:06 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Alan Stern <stern@rowland.harvard.edu>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>
Subject: [Patch 3/3] HW-BKPT: Enable/disable the breakpoints when still
	registered
Message-ID: <20090826201506.GD12766@in.ibm.com>
References: <20090826200840.118253312@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=enable_disable_patch_03
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow breakpoints to be enabled/disabled without yielding the
breakpoint request through a new API - enable_hw_breakpoint().

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
---
 arch/x86/kernel/hw_breakpoint.c     |   12 ++++++----
 include/asm-generic/hw_breakpoint.h |    9 +++++++
 kernel/hw_breakpoint.c              |   41 ++++++++++++++++++++++++++++++++++++
 3 files changed, 57 insertions(+), 5 deletions(-)

Index: linux-2.6-tip.hbkpt/arch/x86/kernel/hw_breakpoint.c
===================================================================
--- linux-2.6-tip.hbkpt.orig/arch/x86/kernel/hw_breakpoint.c
+++ linux-2.6-tip.hbkpt/arch/x86/kernel/hw_breakpoint.c
@@ -79,10 +79,11 @@ void arch_update_kernel_hw_breakpoint(vo
 
 	for (i = hbp_kernel_pos; i < HBP_NUM; i++) {
 		bp = per_cpu(this_hbp_kernel[i], cpu);
-		if (bp) {
+		if (!bp)
+			continue;
+		set_debugreg(bp->info.address, i);
+		if (bp->enabled)
 			temp_kdr7 |= encode_dr7(i, bp->info.len, bp->info.type);
-			set_debugreg(bp->info.address, i);
-		}
 	}
 
 	/* No need to set DR6. Update the debug registers with kernel-space
@@ -282,8 +283,9 @@ void arch_update_user_hw_breakpoint(int 
 	thread->debugreg7 &= ~dr7_masks[pos];
 	if (bp) {
 		thread->debugreg[pos] = bp->info.address;
-		thread->debugreg7 |= encode_dr7(pos, bp->info.len,
-							bp->info.type);
+		if (bp->enabled)
+			thread->debugreg7 |= encode_dr7(pos, bp->info.len,
+								bp->info.type);
 	} else
 		thread->debugreg[pos] = 0;
 }
Index: linux-2.6-tip.hbkpt/include/asm-generic/hw_breakpoint.h
===================================================================
--- linux-2.6-tip.hbkpt.orig/include/asm-generic/hw_breakpoint.h
+++ linux-2.6-tip.hbkpt/include/asm-generic/hw_breakpoint.h
@@ -102,6 +102,12 @@
  * ----------------------------------------------------------------------
  */
 struct hw_breakpoint {
+	/*
+	 * Denotes if a breakpoint is currently enabled in physical debug
+	 * registers. Not to be set directly by the end-user. Must be
+	 * operated through enable_hw_breakpoint() API only.
+	 */
+	unsigned int enabled;
 	void (*triggered)(struct hw_breakpoint *, struct pt_regs *);
 	const cpumask_t *cpumask;
 	struct arch_hw_breakpoint info;
@@ -137,6 +143,9 @@ extern int modify_kernel_hw_breakpoint(s
 					struct hw_breakpoint *new_bp);
 extern void unregister_kernel_hw_breakpoint(struct hw_breakpoint *bp);
 
+extern void enable_hw_breakpoint(struct hw_breakpoint *bp,
+				struct task_struct *tsk, unsigned int enabled);
+
 extern unsigned int hbp_kernel_pos;
 
 #endif	/* __KERNEL__ */
Index: linux-2.6-tip.hbkpt/kernel/hw_breakpoint.c
===================================================================
--- linux-2.6-tip.hbkpt.orig/kernel/hw_breakpoint.c
+++ linux-2.6-tip.hbkpt/kernel/hw_breakpoint.c
@@ -351,6 +351,7 @@ int register_kernel_hw_breakpoint(struct
 		}
 	}
 
+	bp->enabled = 1;
 	if (cpumask_test_cpu(smp_processor_id(), bp->cpumask))
 		update_each_cpu_kernel_hbp(bp);
 	smp_call_function_many(bp->cpumask, update_each_cpu_kernel_hbp, bp, 1);
@@ -464,6 +465,46 @@ ret_path:
 }
 EXPORT_SYMBOL_GPL(unregister_kernel_hw_breakpoint);
 
+/**
+ * enable_hw_breakpoint - enable/disable a previous registered breakpoint
+ * @bp: the breakpoint structure to unregister
+ * @tsk: pointer to 'task_struct' of the process (for user-space breakpoints)
+ * @enabled: zero to disable, any positive integer to enable the breakpoint
+ *
+ * Enable or disable a breakpoint without actually losing the registration
+ */
+void enable_hw_breakpoint(struct hw_breakpoint *bp, struct task_struct *tsk,
+							unsigned int enabled)
+{
+	int i;
+	struct thread_struct *thread = &(tsk->thread);
+
+	spin_lock_bh(&hw_breakpoint_lock);
+
+	bp->enabled = enabled;
+	/* Enable/Disable the kernel-space breakpoint */
+	if (!tsk) {
+		if (cpumask_test_cpu(smp_processor_id(), bp->cpumask))
+			arch_update_kernel_hw_breakpoint(NULL);
+		smp_call_function_many(bp->cpumask,
+				arch_update_kernel_hw_breakpoint, NULL, 1);
+		goto out;
+	}
+
+	/* Enable/disable the user-space breakpoint */
+	for (i = 0; i < hbp_kernel_pos; i++) {
+		if (thread->hbp[i] != bp)
+			continue;
+		arch_update_user_hw_breakpoint(i, tsk);
+		if (tsk == current)
+			arch_install_thread_hw_breakpoint(tsk);
+		break;
+	}
+out:
+	spin_unlock_bh(&hw_breakpoint_lock);
+}
+EXPORT_SYMBOL_GPL(enable_hw_breakpoint);
+
 static struct notifier_block hw_breakpoint_exceptions_nb = {
 	.notifier_call = hw_breakpoint_exceptions_notify,
 	/* we need to be notified first */

