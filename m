Return-Path: <linux-kernel-owner+w=401wt.eu-S1758697AbZDGGgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758697AbZDGGgn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 02:36:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758180AbZDGGgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 02:36:19 -0400
Received: from e28smtp08.in.ibm.com ([59.145.155.8]:43516 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755979AbZDGGgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 02:36:17 -0400
Date: Tue, 7 Apr 2009 12:06:11 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, maneesh@linux.vnet.ibm.com,
       Roland McGrath <roland@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>
Subject: [Patch 05/11] Use wrapper routines around debug registers in
	processor related functions
Message-ID: <20090407063611.GF17461@in.ibm.com>
References: <20090407063058.301701787@prasadkr_t60p.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=modify_processor_related_05
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

Index: arch/x86/kernel/smpboot.c
===================================================================
--- arch/x86/kernel/smpboot.c.orig	2009-04-01 20:53:43.000000000 +0530
+++ arch/x86/kernel/smpboot.c	2009-04-01 20:54:37.000000000 +0530
@@ -63,6 +63,7 @@
 #include <asm/apic.h>
 #include <asm/setup.h>
 #include <asm/uv/uv.h>
+#include <asm/debugreg.h>
 #include <linux/mc146818rtc.h>
 
 #include <asm/smpboot_hooks.h>
@@ -326,6 +327,7 @@
 	setup_secondary_clock();
 
 	wmb();
+	load_debug_registers();
 	cpu_idle();
 }
 
@@ -1250,6 +1252,7 @@
 	remove_cpu_from_maps(cpu);
 	unlock_vector_lock();
 	fixup_irqs();
+	hw_breakpoint_disable();
 }
 
 int native_cpu_disable(void)
Index: arch/x86/power/cpu_32.c
===================================================================
--- arch/x86/power/cpu_32.c.orig	2009-04-01 20:53:43.000000000 +0530
+++ arch/x86/power/cpu_32.c	2009-04-01 20:54:37.000000000 +0530
@@ -12,6 +12,7 @@
 #include <asm/mtrr.h>
 #include <asm/mce.h>
 #include <asm/xcr.h>
+#include <asm/debugreg.h>
 
 static struct saved_context saved_context;
 
@@ -47,6 +48,7 @@
 	ctxt->cr2 = read_cr2();
 	ctxt->cr3 = read_cr3();
 	ctxt->cr4 = read_cr4_safe();
+	hw_breakpoint_disable();
 }
 
 /* Needed by apm.c */
@@ -79,19 +81,7 @@
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
Index: arch/x86/power/cpu_64.c
===================================================================
--- arch/x86/power/cpu_64.c.orig	2009-04-01 20:53:43.000000000 +0530
+++ arch/x86/power/cpu_64.c	2009-04-01 20:54:37.000000000 +0530
@@ -15,6 +15,7 @@
 #include <asm/pgtable.h>
 #include <asm/mtrr.h>
 #include <asm/xcr.h>
+#include <asm/debugreg.h>
 
 static void fix_processor_context(void);
 
@@ -70,6 +71,7 @@
 	ctxt->cr3 = read_cr3();
 	ctxt->cr4 = read_cr4();
 	ctxt->cr8 = read_cr8();
+	hw_breakpoint_disable();
 }
 
 void save_processor_state(void)
@@ -158,16 +160,5 @@
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

