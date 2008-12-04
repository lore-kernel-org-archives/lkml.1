Return-Path: <linux-kernel-owner+w=401wt.eu-S1759137AbYLDTOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759137AbYLDTOW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 14:14:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759811AbYLDTNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 14:13:34 -0500
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:53140 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759388AbYLDTNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 14:13:32 -0500
Date: Fri, 5 Dec 2008 00:43:25 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Roland McGrath <roland@redhat.com>,
       akpm@linux-foundation.org, mingo@elte.hu, richardj_moore@uk.ibm.com
Subject: [RFC Patch 5/9] Use wrapper routines around debug registers in
	processor related functions
Message-ID: <20081204191325.GE20563@in.ibm.com>
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

This patch enables the use of wrapper routines to access the debug/breakpoint
registers.

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
---
 arch/x86/kernel/smpboot.c |    3 +++
 arch/x86/power/cpu_32.c   |   16 +++-------------
 arch/x86/power/cpu_64.c   |   15 +++------------
 3 files changed, 9 insertions(+), 25 deletions(-)

Index: linux-2.6.28-rc5-bkpt-latest/arch/x86/power/cpu_32.c
===================================================================
--- linux-2.6.28-rc5-bkpt-latest.orig/arch/x86/power/cpu_32.c
+++ linux-2.6.28-rc5-bkpt-latest/arch/x86/power/cpu_32.c
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
Index: linux-2.6.28-rc5-bkpt-latest/arch/x86/power/cpu_64.c
===================================================================
--- linux-2.6.28-rc5-bkpt-latest.orig/arch/x86/power/cpu_64.c
+++ linux-2.6.28-rc5-bkpt-latest/arch/x86/power/cpu_64.c
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
Index: linux-2.6.28-rc5-bkpt-latest/arch/x86/kernel/smpboot.c
===================================================================
--- linux-2.6.28-rc5-bkpt-latest.orig/arch/x86/kernel/smpboot.c
+++ linux-2.6.28-rc5-bkpt-latest/arch/x86/kernel/smpboot.c
@@ -62,6 +62,7 @@
 #include <asm/mtrr.h>
 #include <asm/vmi.h>
 #include <asm/genapic.h>
+#include <asm/debugreg.h>
 #include <linux/mc146818rtc.h>
 
 #include <mach_apic.h>
@@ -350,6 +351,7 @@ static void __cpuinit start_secondary(vo
 	setup_secondary_clock();
 
 	wmb();
+	load_debug_registers();
 	cpu_idle();
 }
 
@@ -1356,6 +1358,7 @@ void cpu_disable_common(void)
 	remove_cpu_from_maps(cpu);
 	unlock_vector_lock();
 	fixup_irqs(cpu_online_map);
+	disable_debug_registers();
 }
 
 int native_cpu_disable(void)
