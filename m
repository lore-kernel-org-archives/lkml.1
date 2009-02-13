Return-Path: <linux-kernel-owner+w=401wt.eu-S1760815AbZBMQ3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760815AbZBMQ3S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 11:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758353AbZBMQ2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 11:28:21 -0500
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:60254 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758098AbZBMQ2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 11:28:19 -0500
Date: Fri, 13 Feb 2009 20:26:23 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Roland McGrath <roland@redhat.com>, richardj_moore@uk.ibm.com,
       jason.wessel@windriver.com
Subject: [Patch 4/10] Introduce virtual debug register in thread_struct and
	wrapper-routines around process related functions
Message-ID: <20090213145623.GD32064@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20090213145301.GA31546@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090213145301.GA31546@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Introduce virtual debug register in thread_struct and wrapper-routines around
process related functions

From: Alan Stern <stern@rowland.harvard.edu>

This patch introduces virtual debug registers to used by the per-thread
structure ad wrapper routines to manage debug registers by process-related
functions.

[K.Prasad: Split-out from the bigger patch and minor changes following
           re-basing]

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
---
 arch/x86/include/asm/debugreg.h  |   27 +++++++++++++++++++++++++++
 arch/x86/include/asm/processor.h |   10 +++-------
 2 files changed, 30 insertions(+), 7 deletions(-)

Index: linux-2.6-tip.hbkpt/arch/x86/include/asm/debugreg.h
===================================================================
--- linux-2.6-tip.hbkpt.orig/arch/x86/include/asm/debugreg.h
+++ linux-2.6-tip.hbkpt/arch/x86/include/asm/debugreg.h
@@ -49,6 +49,8 @@
 
 #define DR_LOCAL_ENABLE_SHIFT 0    /* Extra shift to the local enable bit */
 #define DR_GLOBAL_ENABLE_SHIFT 1   /* Extra shift to the global enable bit */
+#define DR_LOCAL_ENABLE (0x1)      /* Local enable for reg 0 */
+#define DR_GLOBAL_ENABLE (0x2)     /* Global enable for reg 0 */
 #define DR_ENABLE_SIZE 2           /* 2 enable bits per register */
 
 #define DR_LOCAL_ENABLE_MASK (0x55)  /* Set  local bits for all 4 regs */
@@ -67,4 +69,29 @@
 #define DR_LOCAL_SLOWDOWN (0x100)   /* Local slow the pipeline */
 #define DR_GLOBAL_SLOWDOWN (0x200)  /* Global slow the pipeline */
 
+/*
+ * HW breakpoint additions
+ */
+#ifdef __KERNEL__
+
+/* For process management */
+void flush_thread_hw_breakpoint(struct task_struct *tsk);
+int copy_thread_hw_breakpoint(struct task_struct *tsk,
+		struct task_struct *child, unsigned long clone_flags);
+void dump_thread_hw_breakpoint(struct task_struct *tsk, int u_debugreg[8]);
+void switch_to_thread_hw_breakpoint(struct task_struct *tsk);
+
+/* For CPU management */
+void load_debug_registers(void);
+static inline void disable_debug_registers(void)
+{
+	set_debugreg(0UL, 7);
+}
+
+/* For use by ptrace */
+unsigned long thread_get_debugreg(struct task_struct *tsk, int n);
+int thread_set_debugreg(struct task_struct *tsk, int n, unsigned long val);
+
+#endif	/* __KERNEL__ */
+
 #endif /* _ASM_X86_DEBUGREG_H */
Index: linux-2.6-tip.hbkpt/arch/x86/include/asm/processor.h
===================================================================
--- linux-2.6-tip.hbkpt.orig/arch/x86/include/asm/processor.h
+++ linux-2.6-tip.hbkpt/arch/x86/include/asm/processor.h
@@ -427,13 +427,9 @@ struct thread_struct {
 	unsigned long		ip;
 	unsigned long		fs;
 	unsigned long		gs;
-	/* Hardware debugging registers: */
-	unsigned long		debugreg0;
-	unsigned long		debugreg1;
-	unsigned long		debugreg2;
-	unsigned long		debugreg3;
-	unsigned long		debugreg6;
-	unsigned long		debugreg7;
+	/* Hardware breakpoint info */
+	unsigned long	vdr6;
+	struct thread_hw_breakpoint	*hw_breakpoint_info;
 	/* Fault info: */
 	unsigned long		cr2;
 	unsigned long		trap_no;
