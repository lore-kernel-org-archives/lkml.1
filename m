Return-Path: <linux-kernel-owner+w=401wt.eu-S1753459AbZA2I3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459AbZA2I3Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 03:29:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751921AbZA2I3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 03:29:15 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:37206 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135AbZA2I3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 03:29:14 -0500
Date: Thu, 29 Jan 2009 13:59:01 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: akpm@linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Roland McGrath <roland@redhat.com>,
       mingo@elte.hu, richardj_moore@uk.ibm.com, jason.wessel@windriver.com
Subject: [Patch 5/10] Use wrapper routines around debug registers in
	processor related functions
Message-ID: <20090129082901.GB7750@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20090129074845.GA5078@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090129074845.GA5078@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables the use of wrapper routines to access the debug/breakpoint
registers.

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
---
 arch/x86/kernel/smpboot.c |    3 +++
 arch/x86/power/cpu_32.c   |   16 +++-------------
 arch/x86/power/cpu_64.c   |   15 +++------------
 3 files changed, 9 insertions(+), 25 deletions(-)

Index: linux-hbkpt-lkml-29-rc2/arch/x86/power/cpu_32.c
===================================================================
--- linux-hbkpt-lkml-29-rc2.orig/arch/x86/power/cpu_32.c
+++ linux-hbkpt-lkml-29-rc2/arch/x86/power/cpu_32.c
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
+	disable_debug_registers();
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
Index: linux-hbkpt-lkml-29-rc2/arch/x86/power/cpu_64.c
===================================================================
--- linux-hbkpt-lkml-29-rc2.orig/arch/x86/power/cpu_64.c
+++ linux-hbkpt-lkml-29-rc2/arch/x86/power/cpu_64.c
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
+	disable_debug_registers();
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
Index: linux-hbkpt-lkml-29-rc2/arch/x86/kernel/smpboot.c
===================================================================
--- linux-hbkpt-lkml-29-rc2.orig/arch/x86/kernel/smpboot.c
+++ linux-hbkpt-lkml-29-rc2/arch/x86/kernel/smpboot.c
@@ -63,6 +63,7 @@
 #include <asm/vmi.h>
 #include <asm/genapic.h>
 #include <asm/setup.h>
+#include <asm/debugreg.h>
 #include <linux/mc146818rtc.h>
 
 #include <mach_apic.h>
@@ -337,6 +338,7 @@ notrace static void __cpuinit start_seco
 	setup_secondary_clock();
 
 	wmb();
+	load_debug_registers();
 	cpu_idle();
 }
 
@@ -1373,6 +1375,7 @@ void cpu_disable_common(void)
 	remove_cpu_from_maps(cpu);
 	unlock_vector_lock();
 	fixup_irqs();
+	disable_debug_registers();
 }
 
 int native_cpu_disable(void)
