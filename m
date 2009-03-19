Return-Path: <linux-kernel-owner+w=401wt.eu-S1762269AbZCSXuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762269AbZCSXuA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 19:50:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762122AbZCSXtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 19:49:25 -0400
Received: from e28smtp09.in.ibm.com ([59.145.155.9]:60415 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762109AbZCSXtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 19:49:24 -0400
Date: Fri, 20 Mar 2009 05:19:11 +0530
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
Subject: [Patch 05/11] Use wrapper routines around debug registers in
	processor related functions
Message-ID: <20090319234911.GF10517@in.ibm.com>
References: <20090319234044.410725944@K.Prasad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=5
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

This patch enables the use of wrapper routines to access the debug/breakpoint
registers.

[K.Prasad: Split-out from the bigger patch and minor changes following
           re-basing]

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
---
 arch/x86/kernel/smpboot.c |    3 +++
 arch/x86/power/cpu_32.c   |   16 +++-------------
 arch/x86/power/cpu_64.c   |   15 +++------------
 3 files changed, 9 insertions(+), 25 deletions(-)

Index: linux-2.6-tip.hbkpt/arch/x86/power/cpu_32.c
===================================================================
--- linux-2.6-tip.hbkpt.orig/arch/x86/power/cpu_32.c
+++ linux-2.6-tip.hbkpt/arch/x86/power/cpu_32.c
@@ -12,6 +12,7 @@
 #include <asm/mtrr.h>
 #include <asm/mce.h>
 #include <asm/xcr.h>
+#include <asm/debugreg.h>
 
 static struct saved_context saved_context;
 
@@ -47,6 +48,7 @@ static void __save_processor_state(struc
 	ctxt->cr2 = read_cr2();
 	ctxt->cr3 = read_cr3();
 	ctxt->cr4 = read_cr4_safe();
+	hw_breakpoint_disable();
 }
 
 /* Needed by apm.c */
@@ -79,19 +81,7 @@ static void fix_processor_context(void)
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
@@ -15,6 +15,7 @@
 #include <asm/pgtable.h>
 #include <asm/mtrr.h>
 #include <asm/xcr.h>
+#include <asm/debugreg.h>
 
 static void fix_processor_context(void);
 
@@ -70,6 +71,7 @@ static void __save_processor_state(struc
 	ctxt->cr3 = read_cr3();
 	ctxt->cr4 = read_cr4();
 	ctxt->cr8 = read_cr8();
+	hw_breakpoint_disable();
 }
 
 void save_processor_state(void)
@@ -158,16 +160,5 @@ static void fix_processor_context(void)
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
@@ -331,6 +332,7 @@ notrace static void __cpuinit start_seco
 	setup_secondary_clock();
 
 	wmb();
+	load_debug_registers();
 	cpu_idle();
 }
 
@@ -1234,6 +1236,7 @@ void cpu_disable_common(void)
 	remove_cpu_from_maps(cpu);
 	unlock_vector_lock();
 	fixup_irqs();
+	hw_breakpoint_disable();
 }
 
 int native_cpu_disable(void)

