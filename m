Return-Path: <linux-kernel-owner+w=401wt.eu-S1759895AbYLDTNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759895AbYLDTNy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 14:13:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759462AbYLDTNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 14:13:09 -0500
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:55204 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758950AbYLDTNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 14:13:07 -0500
Date: Fri, 5 Dec 2008 00:43:00 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Roland McGrath <roland@redhat.com>,
       akpm@linux-foundation.org, mingo@elte.hu, richardj_moore@uk.ibm.com
Subject: [RFC Patch 4/9] Modify kprobe exception handler to recognise
	single-stepping by HW Breakpoint handler
Message-ID: <20081204191300.GD20563@in.ibm.com>
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

This patch modifies the kprobe handler to help it recognise single-stepping by
the HW Breakpoint exception code. A per-cpu variable called 'sstep_reason' to
distinguish the source of single-step exceptions.

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
---
 arch/x86/include/asm/debugreg.h  |   29 +++++++++++++++++++++++++++++
 arch/x86/include/asm/processor.h |   10 +++-------
 arch/x86/kernel/kprobes.c        |    6 ++++++
 3 files changed, 38 insertions(+), 7 deletions(-)

Index: linux-HBKPT-2.6.28-rc7/arch/x86/kernel/kprobes.c
===================================================================
--- linux-HBKPT-2.6.28-rc7.orig/arch/x86/kernel/kprobes.c
+++ linux-HBKPT-2.6.28-rc7/arch/x86/kernel/kprobes.c
@@ -54,6 +54,7 @@
 #include <asm/pgtable.h>
 #include <asm/uaccess.h>
 #include <asm/alternative.h>
+#include <asm/debugreg.h>
 
 void jprobe_return_end(void);
 
@@ -517,6 +518,7 @@ static int __kprobes kprobe_handler(stru
 	kprobe_opcode_t *addr;
 	struct kprobe *p;
 	struct kprobe_ctlblk *kcb;
+	unsigned int *ssr;
 
 	addr = (kprobe_opcode_t *)(regs->ip - sizeof(kprobe_opcode_t));
 	if (*addr != BREAKPOINT_INSTRUCTION) {
@@ -962,6 +964,10 @@ int __kprobes kprobe_exceptions_notify(s
 			ret = NOTIFY_STOP;
 		break;
 	case DIE_DEBUG:
+		/* We could be here due to single-stepping after a pre-handler
+		 * execution of HW Breakpoint or kprobes. We determine the cause
+		 * using the bitmask flag 'sstep_reason'.
+		 */
 		if (post_kprobe_handler(args->regs))
 			ret = NOTIFY_STOP;
 		break;
Index: linux-HBKPT-2.6.28-rc7/arch/x86/include/asm/debugreg.h
===================================================================
--- linux-HBKPT-2.6.28-rc7.orig/arch/x86/include/asm/debugreg.h
+++ linux-HBKPT-2.6.28-rc7/arch/x86/include/asm/debugreg.h
@@ -49,6 +49,8 @@
 
 #define DR_LOCAL_ENABLE_SHIFT 0    /* Extra shift to the local enable bit */
 #define DR_GLOBAL_ENABLE_SHIFT 1   /* Extra shift to the global enable bit */
+#define DR_LOCAL_ENABLE (0x1)      /* Local enable for reg 0 */
+#define DR_GLOBAL_ENABLE (0x2)     /* Global enable for reg 0 */
 #define DR_ENABLE_SIZE 2           /* 2 enable bits per register */
 
 #define DR_LOCAL_ENABLE_MASK (0x55)  /* Set  local bits for all 4 regs */
@@ -67,4 +69,31 @@
 #define DR_LOCAL_SLOWDOWN (0x100)   /* Local slow the pipeline */
 #define DR_GLOBAL_SLOWDOWN (0x200)  /* Global slow the pipeline */
 
+/*
+ * HW breakpoint additions
+ */
+#ifdef __KERNEL__
+
+#define HB_NUM		4	/* Number of hardware breakpoints */
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
Index: linux-HBKPT-2.6.28-rc7/arch/x86/include/asm/processor.h
===================================================================
--- linux-HBKPT-2.6.28-rc7.orig/arch/x86/include/asm/processor.h
+++ linux-HBKPT-2.6.28-rc7/arch/x86/include/asm/processor.h
@@ -401,13 +401,9 @@ struct thread_struct {
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
+/* Hardware breakpoint info */
+	unsigned long	vdr6;
+	struct thread_hw_breakpoint	*hw_breakpoint_info;
 	/* Fault info: */
 	unsigned long		cr2;
 	unsigned long		trap_no;
