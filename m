Return-Path: <linux-kernel-owner+w=401wt.eu-S1756025AbZFBWp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025AbZFBWp3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 18:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754955AbZFBWnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 18:43:49 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:21888 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755211AbZFBWnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 18:43:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=HWZp3r23XdM2avOQaj2u64bf6WXlOuNU6BeiGJ8TAd1Eb7dwafw8JkIAK+NL3T1yAv
         rRT91rBSquapZqqXU7ThKQtjTIVedMUvTS2y9OYaicdJ4kFy73c/O4KYp/A4RXuD+9qV
         KSmKjfk7GxonmjeEdZwLW1KPgGhg5wJoPl1v8=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 05/12] hw-breakpoints: use wrapper routines around debug registers in processor related functions
Date: Wed,  3 Jun 2009 00:43:29 +0200
Message-Id: <1243982616-18212-6-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1243982616-18212-1-git-send-email-fweisbec@gmail.com>
References: <1243982616-18212-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: K.Prasad <prasad@linux.vnet.ibm.com>

This patch enables the use of wrapper routines to access the debug/breakpoint
registers on cpu management.

The hardcoded debug registers save and restore operations for threads
breakpoints are replaced by wrappers.

And now that we handle the kernel breakpoints too, we also need to handle them
on cpu hotplug operations.

[ Impact: adapt new hardware breakpoint api to cpu hotplug ]

Original-patch-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/kernel/smpboot.c |    3 +++
 arch/x86/power/cpu_32.c   |   13 +++----------
 arch/x86/power/cpu_64.c   |   12 +++---------
 3 files changed, 9 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 58d24ef..2b2652d 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -63,6 +63,7 @@
 #include <asm/apic.h>
 #include <asm/setup.h>
 #include <asm/uv/uv.h>
+#include <asm/debugreg.h>
 #include <linux/mc146818rtc.h>
 
 #include <asm/smpboot_hooks.h>
@@ -326,6 +327,7 @@ notrace static void __cpuinit start_secondary(void *unused)
 	setup_secondary_clock();
 
 	wmb();
+	load_debug_registers();
 	cpu_idle();
 }
 
@@ -1250,6 +1252,7 @@ void cpu_disable_common(void)
 	remove_cpu_from_maps(cpu);
 	unlock_vector_lock();
 	fixup_irqs();
+	hw_breakpoint_disable();
 }
 
 int native_cpu_disable(void)
diff --git a/arch/x86/power/cpu_32.c b/arch/x86/power/cpu_32.c
index 5199139..2bc3b01 100644
--- a/arch/x86/power/cpu_32.c
+++ b/arch/x86/power/cpu_32.c
@@ -13,6 +13,7 @@
 #include <asm/mce.h>
 #include <asm/xcr.h>
 #include <asm/suspend.h>
+#include <asm/debugreg.h>
 
 static struct saved_context saved_context;
 
@@ -48,6 +49,7 @@ static void __save_processor_state(struct saved_context *ctxt)
 	ctxt->cr2 = read_cr2();
 	ctxt->cr3 = read_cr3();
 	ctxt->cr4 = read_cr4_safe();
+	hw_breakpoint_disable();
 }
 
 /* Needed by apm.c */
@@ -83,16 +85,7 @@ static void fix_processor_context(void)
 	/*
 	 * Now maybe reload the debug registers
 	 */
-	if (current->thread.debugreg7) {
-		set_debugreg(current->thread.debugreg[0], 0);
-		set_debugreg(current->thread.debugreg[1], 1);
-		set_debugreg(current->thread.debugreg[2], 2);
-		set_debugreg(current->thread.debugreg[3], 3);
-		/* no 4 and 5 */
-		set_debugreg(current->thread.debugreg6, 6);
-		set_debugreg(current->thread.debugreg7, 7);
-	}
-
+	load_debug_registers();
 }
 
 static void __restore_processor_state(struct saved_context *ctxt)
diff --git a/arch/x86/power/cpu_64.c b/arch/x86/power/cpu_64.c
index 1e3bdcc..46866a1 100644
--- a/arch/x86/power/cpu_64.c
+++ b/arch/x86/power/cpu_64.c
@@ -16,6 +16,7 @@
 #include <asm/mtrr.h>
 #include <asm/xcr.h>
 #include <asm/suspend.h>
+#include <asm/debugreg.h>
 
 static void fix_processor_context(void);
 
@@ -71,6 +72,7 @@ static void __save_processor_state(struct saved_context *ctxt)
 	ctxt->cr3 = read_cr3();
 	ctxt->cr4 = read_cr4();
 	ctxt->cr8 = read_cr8();
+	hw_breakpoint_disable();
 }
 
 void save_processor_state(void)
@@ -162,13 +164,5 @@ static void fix_processor_context(void)
 	/*
 	 * Now maybe reload the debug registers
 	 */
-	if (current->thread.debugreg7){
-		set_debugreg(current->thread.debugreg[0], 0);
-		set_debugreg(current->thread.debugreg[1], 1);
-		set_debugreg(current->thread.debugreg[2], 2);
-		set_debugreg(current->thread.debugreg[3], 3);
-                /* no 4 and 5 */
-                loaddebug(&current->thread, 6);
-                loaddebug(&current->thread, 7);
-	}
+	load_debug_registers();
 }
-- 
1.6.2.3

