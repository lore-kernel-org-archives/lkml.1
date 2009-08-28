Return-Path: <linux-kernel-owner+w=401wt.eu-S1752806AbZH1TT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806AbZH1TT2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 15:19:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752316AbZH1TT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 15:19:28 -0400
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:42799 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbZH1TT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 15:19:27 -0400
Date: Sat, 29 Aug 2009 00:49:23 +0530
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
Subject: [Patch 2/3] HW-BKPT: Allow kernel breakpoints to be modified
	through a new API
Message-ID: <20090828191923.GC11063@in.ibm.com>
References: <20090828190842.015422920@abc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=modify_kernel_hbp_02
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce modify_kernel_hw_breakpoint() API that can quickly change the
characteristics (such as address, length, type) of a kernel-space
breakpoint without having to unregister first and then re-register it.

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
---
 include/asm-generic/hw_breakpoint.h |    2 +
 kernel/hw_breakpoint.c              |   49 ++++++++++++++++++++++++++++++++++++
 2 files changed, 51 insertions(+)

Index: linux-2.6-tip.hbkpt/include/asm-generic/hw_breakpoint.h
===================================================================
--- linux-2.6-tip.hbkpt.orig/include/asm-generic/hw_breakpoint.h
+++ linux-2.6-tip.hbkpt/include/asm-generic/hw_breakpoint.h
@@ -133,6 +133,8 @@ extern void unregister_user_hw_breakpoin
  * Kernel breakpoints are not associated with any particular thread.
  */
 extern int register_kernel_hw_breakpoint(struct hw_breakpoint *bp);
+extern int modify_kernel_hw_breakpoint(struct hw_breakpoint *old_bp,
+					struct hw_breakpoint *new_bp);
 extern void unregister_kernel_hw_breakpoint(struct hw_breakpoint *bp);
 
 extern unsigned int hbp_kernel_pos;
Index: linux-2.6-tip.hbkpt/kernel/hw_breakpoint.c
===================================================================
--- linux-2.6-tip.hbkpt.orig/kernel/hw_breakpoint.c
+++ linux-2.6-tip.hbkpt/kernel/hw_breakpoint.c
@@ -362,6 +362,55 @@ err_ret:
 }
 EXPORT_SYMBOL_GPL(register_kernel_hw_breakpoint);
 
+/**
+ * modify_kernel_hw_breakpoint - modify characteristics of a previously registered breakpoint request
+ * @old_bp: pointer to the registered breakpoint structure
+ * @new_bp: pointer to the breakpoint structure that replaces @old_bp
+ *
+ */
+int modify_kernel_hw_breakpoint(struct hw_breakpoint *old_bp,
+				   struct hw_breakpoint *new_bp)
+{
+	int i, rc;
+	unsigned int cpu;
+	const cpumask_t *new_cpumask = new_bp->cpumask;
+
+	/* Default to ALL CPUs if cpumask is not specified */
+	if (!new_cpumask)
+		new_cpumask = new_bp->cpumask = cpu_possible_mask;
+	/*
+	 * The user cannot modify the cpumask of the registered breakpoint
+	 * It requires non-trivial amount of code and new data-structures to
+	 * allow a change in cpumask value. The user must instead 'unregister'
+	 * and re-register a new breakpoint if 'cpumask' should be changed
+	 */
+	if (!cpumask_equal(old_bp->cpumask, new_cpumask))
+		return -EINVAL;
+
+	rc = arch_validate_hwbkpt_settings(new_bp, NULL);
+	if (rc)
+		return rc;
+
+	spin_lock_bh(&hw_breakpoint_lock);
+	for_each_cpu(cpu, new_cpumask) {
+		for (i = HBP_NUM-1; i >= hbp_kernel_pos; i--) {
+			if (per_cpu(this_hbp_kernel[i], cpu) == old_bp) {
+				per_cpu(this_hbp_kernel[i], cpu) = new_bp;
+				break;
+			}
+		}
+	}
+
+	if (cpumask_test_cpu(smp_processor_id(), new_cpumask))
+		arch_update_kernel_hw_breakpoint(NULL);
+	smp_call_function_many(new_cpumask,
+				arch_update_kernel_hw_breakpoint, NULL, 1);
+
+	spin_unlock_bh(&hw_breakpoint_lock);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(modify_kernel_hw_breakpoint);
+
 /* Removes breakpoint structure from the per-cpu breakpoint data-structure */
 static void remove_each_cpu_kernel_hbp(void *bp_param)
 {

