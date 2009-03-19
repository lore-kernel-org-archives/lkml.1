Return-Path: <linux-kernel-owner+w=401wt.eu-S1762183AbZCSXtl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762183AbZCSXtl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 19:49:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762125AbZCSXtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 19:49:15 -0400
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:50560 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759378AbZCSXtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 19:49:13 -0400
Date: Fri, 20 Mar 2009 05:19:04 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Roland McGrath <roland@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>
Subject: [Patch 04/11] Introduce user-space debug registers
Message-ID: <20090319234904.GE10517@in.ibm.com>
References: <20090319234044.410725944@K.Prasad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=4
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces virtual debug registers to used by the per-thread
structure and wrapper routines to manage debug registers by process-related
functions.

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
---
 arch/x86/include/asm/debugreg.h  |   23 +++++++++++++++++++++++
 arch/x86/include/asm/processor.h |   16 +++++++++-------
 2 files changed, 32 insertions(+), 7 deletions(-)

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
@@ -67,4 +69,25 @@
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
+static inline void hw_breakpoint_disable(void)
+{
+	set_debugreg(0UL, 7);
+}
+
+#endif	/* __KERNEL__ */
+
 #endif /* _ASM_X86_DEBUGREG_H */
Index: linux-2.6-tip.hbkpt/arch/x86/include/asm/processor.h
===================================================================
--- linux-2.6-tip.hbkpt.orig/arch/x86/include/asm/processor.h
+++ linux-2.6-tip.hbkpt/arch/x86/include/asm/processor.h
@@ -29,6 +29,7 @@ struct mm_struct;
 #include <linux/threads.h>
 #include <linux/init.h>
 
+#define HB_NUM 4
 /*
  * Default implementation of macro that returns current
  * instruction pointer ("program counter").
@@ -424,13 +425,14 @@ struct thread_struct {
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
+	struct hw_breakpoint	*hbkpt[HB_NUM];
+	unsigned int		hbkpt_num_installed;
+	/* Thread's view of debug reg 6 */
+	unsigned long		dr6;
+	/* Thread's view of debug reg 7 */
+	unsigned long		dr7;
+
 	/* Fault info: */
 	unsigned long		cr2;
 	unsigned long		trap_no;

