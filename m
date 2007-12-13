Return-Path: <linux-kernel-owner+w=401wt.eu-S1760735AbXLMJja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760735AbXLMJja (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 04:39:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753364AbXLMJjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 04:39:23 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:32596
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755826AbXLMJjW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 04:39:22 -0500
Message-Id: <47610C0C.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Thu, 13 Dec 2007 09:40:12 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: make __{save,restore}_processor_state static
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.. allowing to remove their declarations from a global include file
(the symbols don't exist for anything but x86).

Likewise for 64-bits' fix_processor_context(), just that that one was
properly declared in an arch-specific header.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

 arch/x86/kernel/suspend_64.c |    8 +++++---
 arch/x86/power/cpu.c         |    4 ++--
 include/asm-x86/suspend_64.h |    2 --
 include/linux/suspend.h      |    3 ---
 4 files changed, 7 insertions(+), 10 deletions(-)

--- linux-2.6.24-rc5/arch/x86/kernel/suspend_64.c	2007-12-12 11:28:18.000000000 +0100
+++ 2.6.24-rc5-x86-suspend-static/arch/x86/kernel/suspend_64.c	2007-12-05 15:57:55.000000000 +0100
@@ -17,9 +17,11 @@
 /* References to section boundaries */
 extern const void __nosave_begin, __nosave_end;
 
+static void fix_processor_context(void);
+
 struct saved_context saved_context;
 
-void __save_processor_state(struct saved_context *ctxt)
+static void __save_processor_state(struct saved_context *ctxt)
 {
 	kernel_fpu_begin();
 
@@ -69,7 +71,7 @@ static void do_fpu_end(void)
 	kernel_fpu_end();
 }
 
-void __restore_processor_state(struct saved_context *ctxt)
+static void __restore_processor_state(struct saved_context *ctxt)
 {
 	/*
 	 * control registers
@@ -113,7 +115,7 @@ void restore_processor_state(void)
 	__restore_processor_state(&saved_context);
 }
 
-void fix_processor_context(void)
+static void fix_processor_context(void)
 {
 	int cpu = smp_processor_id();
 	struct tss_struct *t = &per_cpu(init_tss, cpu);
--- linux-2.6.24-rc5/arch/x86/power/cpu.c	2007-12-12 11:28:18.000000000 +0100
+++ 2.6.24-rc5-x86-suspend-static/arch/x86/power/cpu.c	2007-12-05 15:54:57.000000000 +0100
@@ -19,7 +19,7 @@ unsigned long saved_context_esp, saved_c
 unsigned long saved_context_esi, saved_context_edi;
 unsigned long saved_context_eflags;
 
-void __save_processor_state(struct saved_context *ctxt)
+static void __save_processor_state(struct saved_context *ctxt)
 {
 	mtrr_save_fixed_ranges(NULL);
 	kernel_fpu_begin();
@@ -86,7 +86,7 @@ static void fix_processor_context(void)
 
 }
 
-void __restore_processor_state(struct saved_context *ctxt)
+static void __restore_processor_state(struct saved_context *ctxt)
 {
 	/*
 	 * control registers
--- linux-2.6.24-rc5/include/asm-x86/suspend_64.h	2007-12-12 11:29:31.000000000 +0100
+++ 2.6.24-rc5-x86-suspend-static/include/asm-x86/suspend_64.h	2007-12-05 15:49:36.000000000 +0100
@@ -38,8 +38,6 @@ struct saved_context {
 #define loaddebug(thread,register) \
 	set_debugreg((thread)->debugreg##register, register)
 
-extern void fix_processor_context(void);
-
 /* routines for saving/restoring kernel state */
 extern int acpi_save_state_mem(void);
 extern char core_restore_code;
--- linux-2.6.24-rc5/include/linux/suspend.h	2007-12-12 11:29:38.000000000 +0100
+++ 2.6.24-rc5-x86-suspend-static/include/linux/suspend.h	2007-12-05 15:54:33.000000000 +0100
@@ -211,9 +211,6 @@ static inline int hibernate(void) { retu
 #ifdef CONFIG_PM_SLEEP
 void save_processor_state(void);
 void restore_processor_state(void);
-struct saved_context;
-void __save_processor_state(struct saved_context *ctxt);
-void __restore_processor_state(struct saved_context *ctxt);
 
 /* kernel/power/main.c */
 extern struct blocking_notifier_head pm_chain_head;



