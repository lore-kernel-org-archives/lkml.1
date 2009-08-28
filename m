Return-Path: <linux-kernel-owner+w=401wt.eu-S1752832AbZH1TTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832AbZH1TTn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 15:19:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752316AbZH1TTm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 15:19:42 -0400
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:35090 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776AbZH1TTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 15:19:41 -0400
Date: Sat, 29 Aug 2009 00:49:36 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Alan Stern <stern@rowland.harvard.edu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>
Subject: [Patch 3/3] HW-BKPT: Enable/disable the breakpoints when still
	registered
Message-ID: <20090828191936.GD11063@in.ibm.com>
References: <20090828190842.015422920@abc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=enable_disable_patch_03
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow breakpoints to be enabled/disabled without yielding the
breakpoint request through new APIs -
<enable><disable>_hw_breakpoint()

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
---
 arch/x86/kernel/hw_breakpoint.c     |   12 +++---
 include/asm-generic/hw_breakpoint.h |   10 +++++
 kernel/hw_breakpoint.c              |   66 ++++++++++++++++++++++++++++++++++++
 3 files changed, 83 insertions(+), 5 deletions(-)

Index: linux-2.6-tip.hbkpt/arch/x86/kernel/hw_breakpoint.c
===================================================================
--- linux-2.6-tip.hbkpt.orig/arch/x86/kernel/hw_breakpoint.c
+++ linux-2.6-tip.hbkpt/arch/x86/kernel/hw_breakpoint.c
@@ -85,10 +85,11 @@ void arch_update_kernel_hw_breakpoint(vo
 
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
@@ -288,8 +289,9 @@ void arch_update_user_hw_breakpoint(int 
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
+	 * operated through <enable><disable>_hw_breakpoint() APIs only.
+	 */
+	bool enabled;
 	void (*triggered)(struct hw_breakpoint *, struct pt_regs *);
 	const cpumask_t *cpumask;
 	struct arch_hw_breakpoint info;
@@ -137,6 +143,10 @@ extern int modify_kernel_hw_breakpoint(s
 					struct hw_breakpoint *new_bp);
 extern void unregister_kernel_hw_breakpoint(struct hw_breakpoint *bp);
 
+extern void enable_hw_breakpoint(struct hw_breakpoint *bp,
+				 struct task_struct *tsk);
+extern void disable_hw_breakpoint(struct hw_breakpoint *bp,
+				  struct task_struct *tsk);
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
@@ -469,6 +470,71 @@ ret_path:
 }
 EXPORT_SYMBOL_GPL(unregister_kernel_hw_breakpoint);
 
+/*
+ * Worker routine that updates enabled/disabled status for kernel/user-space
+ * hw-breakpoints.
+ */
+static void update_enable_status_hbp(struct hw_breakpoint *bp,
+					struct task_struct *tsk)
+{
+	int i;
+	struct thread_struct *thread = &(tsk->thread);
+
+	spin_lock_bh(&hw_breakpoint_lock);
+
+	/* Enable/Disable the kernel-space breakpoint */
+	if (!tsk) {
+		if (cpumask_test_cpu(smp_processor_id(), bp->cpumask))
+			arch_update_kernel_hw_breakpoint(NULL);
+		smp_call_function_many(bp->cpumask,
+				arch_update_kernel_hw_breakpoint, NULL, 1);
+				       goto out;
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
+
+}
+
+/**
+ * enable_hw_breakpoint - re-enable a breakpoint previously disabled
+ * @bp: pointer to the breakpoint structure to be enabled
+ * @tsk: pointer to 'task_struct' of the process (for user-space breakpoints)
+ *
+ * Re-enable or disable a breakpoint, previously disabled using
+ * disable_hw_breakpoint()
+ */
+void enable_hw_breakpoint(struct hw_breakpoint *bp, struct task_struct *tsk)
+{
+	bp->enabled = 1;
+	update_enable_status_hbp(bp, tsk);
+}
+EXPORT_SYMBOL_GPL(enable_hw_breakpoint);
+
+/**
+ * disable_hw_breakpoint - disable a breakpoint from raising breakpoint exceptions
+ * @bp: pointer to the breakpoint structure to be disabled
+ * @tsk: pointer to 'task_struct' of the process (for user-space breakpoints)
+ *
+ * Disable a breakpoint without actually losing the registration. Re-enable it
+ * again using enable_hw_breakpoint()
+ */
+void disable_hw_breakpoint(struct hw_breakpoint *bp, struct task_struct *tsk)
+{
+	bp->enabled = 0;
+	update_enable_status_hbp(bp, tsk);
+}
+EXPORT_SYMBOL_GPL(disable_hw_breakpoint);
+
 static struct notifier_block hw_breakpoint_exceptions_nb = {
 	.notifier_call = hw_breakpoint_exceptions_notify,
 	/* we need to be notified first */

