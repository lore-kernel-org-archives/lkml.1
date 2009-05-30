Return-Path: <linux-kernel-owner+w=401wt.eu-S1761443AbZE3Kvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761443AbZE3Kvp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 06:51:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760521AbZE3Kvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 06:51:35 -0400
Received: from e28smtp09.in.ibm.com ([59.145.155.9]:45080 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761558AbZE3Kve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 06:51:34 -0400
Date: Sat, 30 May 2009 16:21:29 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Alan Stern <stern@rowland.harvard.edu>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>
Subject: [Patch 05/12] Use wrapper routines around debug registers in
	processor related functions
Message-ID: <20090530105129.GF9512@in.ibm.com>
References: <20090530103857.715014561@prasadkr_t60p.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=modify_processor_related_05
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables the use of wrapper routines to access the debug/breakpoint
registers.

Original-patch-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
---
 arch/x86/kernel/smpboot.c |    3 +++
 arch/x86/power/cpu_32.c   |   16 +++-------------
 arch/x86/power/cpu_64.c   |   15 +++------------
 3 files changed, 9 insertions(+), 25 deletions(-)

Index: linux-2.6-tip.hbkpt/arch/x86/kernel/smpboot.c
===================================================================
--- linux-2.6-tip.hbkpt.orig/arch/x86/kernel/smpboot.c
+++ linux-2.6-tip.hbkpt/arch/x86/kernel/smpboot.c
@@ -63,6 +63,7 @@
 #include <asm/apic.h>
 #include <asm/setup.h>
 #include <asm/uv/uv.h>
+#include <asm/debugreg.h>
 #include <linux/mc146818rtc.h>
 
 #include <asm/smpboot_hooks.h>
@@ -326,6 +327,7 @@ notrace static void __cpuinit start_seco
 	setup_secondary_clock();
 
 	wmb();
+	load_debug_registers();
 	cpu_idle();
 }
 
@@ -1252,6 +1254,7 @@ void cpu_disable_common(void)
 	remove_cpu_from_maps(cpu);
 	unlock_vector_lock();
 	fixup_irqs();
+	hw_breakpoint_disable();
 }
 
 int native_cpu_disable(void)
Index: linux-2.6-tip.hbkpt/arch/x86/power/cpu_32.c
===================================================================
--- linux-2.6-tip.hbkpt.orig/arch/x86/power/cpu_32.c
+++ linux-2.6-tip.hbkpt/arch/x86/power/cpu_32.c
@@ -13,6 +13,7 @@
 #include <asm/mce.h>
 #include <asm/xcr.h>
 #include <asm/suspend.h>
+#include <asm/debugreg.h>
 
 static struct saved_context saved_context;
 
@@ -48,6 +49,7 @@ static void __save_processor_state(struc
 	ctxt->cr2 = read_cr2();
 	ctxt->cr3 = read_cr3();
 	ctxt->cr4 = read_cr4_safe();
+	hw_breakpoint_disable();
 }
 
 /* Needed by apm.c */
@@ -80,19 +82,7 @@ static void fix_processor_context(void)
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
Index: linux-2.6-tip.hbkpt/arch/x86/power/cpu_64.c
===================================================================
--- linux-2.6-tip.hbkpt.orig/arch/x86/power/cpu_64.c
+++ linux-2.6-tip.hbkpt/arch/x86/power/cpu_64.c
@@ -16,6 +16,7 @@
 #include <asm/mtrr.h>
 #include <asm/xcr.h>
 #include <asm/suspend.h>
+#include <asm/debugreg.h>
 
 static void fix_processor_context(void);
 
@@ -71,6 +72,7 @@ static void __save_processor_state(struc
 	ctxt->cr3 = read_cr3();
 	ctxt->cr4 = read_cr4();
 	ctxt->cr8 = read_cr8();
+	hw_breakpoint_disable();
 }
 
 void save_processor_state(void)
@@ -159,16 +161,5 @@ static void fix_processor_context(void)
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

