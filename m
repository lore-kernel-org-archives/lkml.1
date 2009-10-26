Return-Path: <linux-kernel-owner+w=401wt.eu-S1753472AbZJZVTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472AbZJZVTW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 17:19:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753452AbZJZVTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 17:19:21 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:55474 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837AbZJZVTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 17:19:20 -0400
Date: Tue, 27 Oct 2009 02:49:15 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>
Subject: [RFC Patch 2/4] Allow breakpoints to be enabled/disabled without
	yielding the breakpoint request through new APIs -
	<enable><disable>_hw_breakpoint()
Message-ID: <20091026211915.GC15529@in.ibm.com>
References: <20091026211225.214925175@xyz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=enable_disable_patch_03
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow breakpoints to be enabled/disabled without yielding the
breakpoint request through new APIs - <enable><disable>_hw_breakpoint()

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
---
 arch/x86/kernel/hw_breakpoint.c     |   15 ++++++++++-----
 include/asm-generic/hw_breakpoint.h |   13 +++++++++++++
 kernel/hw_breakpoint.c              |   27 +++++++++++++++++++++++++++
 3 files changed, 50 insertions(+), 5 deletions(-)

Index: linux-2.6-tip.perf_hbkpt/arch/x86/kernel/hw_breakpoint.c
===================================================================
--- linux-2.6-tip.perf_hbkpt.orig/arch/x86/kernel/hw_breakpoint.c
+++ linux-2.6-tip.perf_hbkpt/arch/x86/kernel/hw_breakpoint.c
@@ -85,10 +85,11 @@ void arch_update_kernel_hw_breakpoint(vo
 
 	for (i = hbp_kernel_pos; i < HBP_NUM; i++) {
 		bp = per_cpu(this_hbp_kernel[i], cpu);
-		if (bp) {
+		if (!bp)
+			continue;
+		set_debugreg(bp->info.address, i);
+		if (atomic_read(&bp->enabled) == BP_ENABLED)
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
+		if (atomic_read(&bp->enabled) == BP_ENABLED)
+			thread->debugreg7 |= encode_dr7(pos, bp->info.len,
+								bp->info.type);
 	} else
 		thread->debugreg[pos] = 0;
 }
@@ -377,6 +379,9 @@ static int __kprobes hw_breakpoint_handl
 		 */
 		if (!bp)
 			continue;
+		/* Ignore exceptions due to disabled breakpoints */
+		if (atomic_read(&bp->enabled) == BP_DISABLED)
+			continue;
 
 		(bp->triggered)(bp, args->regs);
 	}
Index: linux-2.6-tip.perf_hbkpt/include/asm-generic/hw_breakpoint.h
===================================================================
--- linux-2.6-tip.perf_hbkpt.orig/include/asm-generic/hw_breakpoint.h
+++ linux-2.6-tip.perf_hbkpt/include/asm-generic/hw_breakpoint.h
@@ -102,11 +102,22 @@
  * ----------------------------------------------------------------------
  */
 struct hw_breakpoint {
+	/*
+	 * Denotes if a breakpoint is currently enabled in physical debug
+	 * registers. Not to be set directly by the end-user. Must be
+	 * operated through <enable><disable>_hw_breakpoint() APIs only.
+	 */
+	atomic_t enabled;
 	void (*triggered)(struct hw_breakpoint *, struct pt_regs *);
 	const cpumask_t *cpumask;
 	struct arch_hw_breakpoint info;
 };
 
+enum bp_status {
+	BP_DISABLED	= 0,
+	BP_ENABLED	= 1
+};
+
 /*
  * len and type values are defined in include/asm/hw_breakpoint.h.
  * Available values vary according to the architecture.  On i386 the
@@ -135,6 +146,8 @@ extern void unregister_user_hw_breakpoin
 extern int register_kernel_hw_breakpoint(struct hw_breakpoint *bp);
 extern void unregister_kernel_hw_breakpoint(struct hw_breakpoint *bp);
 
+extern void enable_hw_breakpoint(struct hw_breakpoint *bp);
+extern void disable_hw_breakpoint(struct hw_breakpoint *bp);
 extern unsigned int hbp_kernel_pos;
 
 #endif	/* __KERNEL__ */
Index: linux-2.6-tip.perf_hbkpt/kernel/hw_breakpoint.c
===================================================================
--- linux-2.6-tip.perf_hbkpt.orig/kernel/hw_breakpoint.c
+++ linux-2.6-tip.perf_hbkpt/kernel/hw_breakpoint.c
@@ -351,6 +351,7 @@ int register_kernel_hw_breakpoint(struct
 		}
 	}
 
+	atomic_set(&bp->enabled, BP_ENABLED);
 	if (cpumask_test_cpu(smp_processor_id(), bp->cpumask))
 		update_each_cpu_kernel_hbp(bp);
 	smp_call_function_many(bp->cpumask, update_each_cpu_kernel_hbp, bp, 1);
@@ -420,6 +421,32 @@ ret_path:
 }
 EXPORT_SYMBOL_GPL(unregister_kernel_hw_breakpoint);
 
+/**
+ * enable_hw_breakpoint - re-enable a breakpoint previously disabled
+ * @bp: pointer to the breakpoint structure to be enabled
+ *
+ * Re-enable or disable a breakpoint, previously disabled using
+ * disable_hw_breakpoint()
+ */
+void enable_hw_breakpoint(struct hw_breakpoint *bp)
+{
+	atomic_set(&bp->enabled, BP_ENABLED);
+}
+EXPORT_SYMBOL_GPL(enable_hw_breakpoint);
+
+/**
+ * disable_hw_breakpoint - disable a breakpoint from raising breakpoint exceptions
+ * @bp: pointer to the breakpoint structure to be disabled
+ *
+ * Disable a breakpoint without actually losing the registration. Re-enable it
+ * again using enable_hw_breakpoint()
+ */
+void disable_hw_breakpoint(struct hw_breakpoint *bp)
+{
+	atomic_set(&bp->enabled, BP_DISABLED);
+}
+EXPORT_SYMBOL_GPL(disable_hw_breakpoint);
+
 static struct notifier_block hw_breakpoint_exceptions_nb = {
 	.notifier_call = hw_breakpoint_exceptions_notify,
 	/* we need to be notified first */

