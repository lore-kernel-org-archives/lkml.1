Return-Path: <linux-kernel-owner+w=401wt.eu-S1755642AbYJGLod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642AbYJGLod (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 07:44:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753610AbYJGLoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 07:44:15 -0400
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:56624 "EHLO
	e28esmtp04.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755484AbYJGLoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 07:44:13 -0400
Date: Tue, 7 Oct 2008 17:14:05 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>, Roland McGrath <roland@redhat.com>,
       akpm@linux-foundation.org, mingo@elte.hu, jason.wessel@windriver.com,
       avi@qumranet.com, richardj_moore@uk.ibm.com
Subject: [RFC Patch 5/9] Use wrapper routines around debug registers in
	processor related functions
Message-ID: <20081007114405.GE25627@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20081007113815.GA23523@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081007113815.GA23523@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables the use of wrapper routines to access the debug/breakpoint
registers.

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
---
 arch/x86/kernel/smpboot.c   |    3 +++
 arch/x86/power/cpu_32.c     |   16 +++-------------
 arch/x86/power/cpu_64.c     |   15 +++------------
 include/asm-x86/debugreg.h  |   29 +++++++++++++++++++++++++++++
 include/asm-x86/processor.h |   10 +++-------
 5 files changed, 41 insertions(+), 32 deletions(-)

Index: linux-bkpt-lkml-27-rc9/arch/x86/power/cpu_32.c
===================================================================
--- linux-bkpt-lkml-27-rc9.orig/arch/x86/power/cpu_32.c
+++ linux-bkpt-lkml-27-rc9/arch/x86/power/cpu_32.c
@@ -11,6 +11,7 @@
 #include <linux/suspend.h>
 #include <asm/mtrr.h>
 #include <asm/mce.h>
+#include <asm/debugreg.h>
 
 static struct saved_context saved_context;
 
@@ -46,6 +47,7 @@ static void __save_processor_state(struc
 	ctxt->cr2 = read_cr2();
 	ctxt->cr3 = read_cr3();
 	ctxt->cr4 = read_cr4_safe();
+	disable_debug_registers();
 }
 
 /* Needed by apm.c */
@@ -78,19 +80,7 @@ static void fix_processor_context(void)
 	load_TR_desc();				/* This does ltr */
 	load_LDT(&current->active_mm->context);	/* This does lldt */
 
-	/*
-	 * Now maybe reload the debug registers
-	 */
-	if (current->thread.debugreg7) {
-		set_debugreg(current->thread.debugreg0, 0);
-		set_debugreg(current->thread.debugreg1, 1);
-		set_debugreg(current->thread.debugreg2, 2);
-		set_debugreg(current->thread.debugreg3, 3);
-		/* no 4 and 5 */
-		set_debugreg(current->thread.debugreg6, 6);
-		set_debugreg(current->thread.debugreg7, 7);
-	}
-
+	load_debug_registers();
 }
 
 static void __restore_processor_state(struct saved_context *ctxt)
Index: linux-bkpt-lkml-27-rc9/arch/x86/power/cpu_64.c
===================================================================
--- linux-bkpt-lkml-27-rc9.orig/arch/x86/power/cpu_64.c
+++ linux-bkpt-lkml-27-rc9/arch/x86/power/cpu_64.c
@@ -14,6 +14,7 @@
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/mtrr.h>
+#include <asm/debugreg.h>
 
 static void fix_processor_context(void);
 
@@ -69,6 +70,7 @@ static void __save_processor_state(struc
 	ctxt->cr3 = read_cr3();
 	ctxt->cr4 = read_cr4();
 	ctxt->cr8 = read_cr8();
+	disable_debug_registers();
 }
 
 void save_processor_state(void)
@@ -151,16 +153,5 @@ static void fix_processor_context(void)
 	load_TR_desc();				/* This does ltr */
 	load_LDT(&current->active_mm->context);	/* This does lldt */
 
-	/*
-	 * Now maybe reload the debug registers
-	 */
-	if (current->thread.debugreg7){
-                loaddebug(&current->thread, 0);
-                loaddebug(&current->thread, 1);
-                loaddebug(&current->thread, 2);
-                loaddebug(&current->thread, 3);
-                /* no 4 and 5 */
-                loaddebug(&current->thread, 6);
-                loaddebug(&current->thread, 7);
-	}
+	load_debug_registers();
 }
Index: linux-bkpt-lkml-27-rc9/arch/x86/kernel/smpboot.c
===================================================================
--- linux-bkpt-lkml-27-rc9.orig/arch/x86/kernel/smpboot.c
+++ linux-bkpt-lkml-27-rc9/arch/x86/kernel/smpboot.c
@@ -61,6 +61,7 @@
 #include <asm/mtrr.h>
 #include <asm/vmi.h>
 #include <asm/genapic.h>
+#include <asm/debugreg.h>
 #include <linux/mc146818rtc.h>
 
 #include <mach_apic.h>
@@ -342,6 +343,7 @@ static void __cpuinit start_secondary(vo
 	setup_secondary_clock();
 
 	wmb();
+	load_debug_registers();
 	cpu_idle();
 }
 
@@ -1382,6 +1384,7 @@ int __cpu_disable(void)
 	remove_cpu_from_maps(cpu);
 	unlock_vector_lock();
 	fixup_irqs(cpu_online_map);
+	disable_debug_registers();
 	return 0;
 }
 
Index: linux-bkpt-lkml-27-rc9/include/asm-x86/debugreg.h
===================================================================
--- linux-bkpt-lkml-27-rc9.orig/include/asm-x86/debugreg.h
+++ linux-bkpt-lkml-27-rc9/include/asm-x86/debugreg.h
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
 #endif
Index: linux-bkpt-lkml-27-rc9/include/asm-x86/processor.h
===================================================================
--- linux-bkpt-lkml-27-rc9.orig/include/asm-x86/processor.h
+++ linux-bkpt-lkml-27-rc9/include/asm-x86/processor.h
@@ -381,13 +381,9 @@ struct thread_struct {
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
