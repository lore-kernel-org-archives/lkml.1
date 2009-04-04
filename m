Return-Path: <linux-kernel-owner+w=401wt.eu-S1760130AbZDDIsE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760130AbZDDIsE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 04:48:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751798AbZDDIrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 04:47:52 -0400
Received: from mail-qy0-f118.google.com ([209.85.221.118]:50706 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbZDDIru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 04:47:50 -0400
Message-ID: <49D71EAE.2020007@larces.uece.br>
Date: Sat, 04 Apr 2009 05:47:42 -0300
From: Sergio Luis <sergio@larces.uece.br>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: Linux-kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Lauro Salmito <laurosalmito@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@suse.cz>, x86 Maintainers <x86@kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 4/6] x86: unify power/cpu_(32|64) regarding restoring processor
 state
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86: unify power/cpu_(32|64) regarding restoring processor state

In this step we do unify cpu_32.c and cpu_64.c functions that
work on restoring the saved processor state. Also, we do
eliminate the forward declaration of fix_processor_context()
for X86_64, as it's not needed anymore.

Signed-off-by: Sergio Luis <sergio@larces.uece.br>
Signed-off-by: Lauro Salmito <laurosalmito@gmail.com>
---
 arch/x86/power/cpu_32.c |   55 +++++++++++++++++++++-
 arch/x86/power/cpu_64.c |  118 ++++++++++++++++++++++++++++++++--------------
 2 files changed, 135 insertions(+), 38 deletions(-)

diff --git a/arch/x86/power/cpu_32.c b/arch/x86/power/cpu_32.c
index dd32ecc..ef656e2 100644
--- a/arch/x86/power/cpu_32.c
+++ b/arch/x86/power/cpu_32.c
@@ -26,8 +26,6 @@ unsigned long saved_context_esi, saved_context_edi;
 unsigned long saved_context_eflags;
 #else
 /* CONFIG_X86_64 */
-static void fix_processor_context(void);
-
 struct saved_context saved_context;
 #endif
 
@@ -135,6 +133,11 @@ static void fix_processor_context(void)
 				 * similar stupidity.
 				 */
 
+#ifdef CONFIG_X86_64
+	get_cpu_gdt_table(cpu)[GDT_ENTRY_TSS].type = 9;
+
+	syscall_init();				/* This sets MSR_*STAR and related */
+#endif
 	load_TR_desc();				/* This does ltr */
 	load_LDT(&current->active_mm->context);	/* This does lldt */
 
@@ -142,6 +145,7 @@ static void fix_processor_context(void)
 	 * Now maybe reload the debug registers
 	 */
 	if (current->thread.debugreg7) {
+#ifdef CONFIG_X86_32
 		set_debugreg(current->thread.debugreg0, 0);
 		set_debugreg(current->thread.debugreg1, 1);
 		set_debugreg(current->thread.debugreg2, 2);
@@ -149,18 +153,40 @@ static void fix_processor_context(void)
 		/* no 4 and 5 */
 		set_debugreg(current->thread.debugreg6, 6);
 		set_debugreg(current->thread.debugreg7, 7);
+#else
+		/* CONFIG_X86_64 */
+		loaddebug(&current->thread, 0);
+		loaddebug(&current->thread, 1);
+		loaddebug(&current->thread, 2);
+		loaddebug(&current->thread, 3);
+		/* no 4 and 5 */
+		loaddebug(&current->thread, 6);
+		loaddebug(&current->thread, 7);
+#endif
 	}
 
 }
 
+/**
+ *	__restore_processor_state - restore the contents of CPU registers saved
+ *		by __save_processor_state()
+ *	@ctxt - structure to load the registers contents from
+ */
 static void __restore_processor_state(struct saved_context *ctxt)
 {
 	/*
 	 * control registers
 	 */
 	/* cr4 was introduced in the Pentium CPU */
+#ifdef CONFIG_X86_32
 	if (ctxt->cr4)
 		write_cr4(ctxt->cr4);
+#else
+/* CONFIG X86_64 */
+	wrmsrl(MSR_EFER, ctxt->efer);
+	write_cr8(ctxt->cr8);
+	write_cr4(ctxt->cr4);
+#endif
 	write_cr3(ctxt->cr3);
 	write_cr2(ctxt->cr2);
 	write_cr0(ctxt->cr0);
@@ -169,12 +195,19 @@ static void __restore_processor_state(struct saved_context *ctxt)
 	 * now restore the descriptor tables to their proper values
 	 * ltr is done i fix_processor_context().
 	 */
+#ifdef CONFIG_X86_32
 	load_gdt(&ctxt->gdt);
 	load_idt(&ctxt->idt);
+#else
+/* CONFIG_X86_64 */
+	load_gdt((const struct desc_ptr *)&ctxt->gdt_limit);
+	load_idt((const struct desc_ptr *)&ctxt->idt_limit);
+#endif
 
 	/*
 	 * segment registers
 	 */
+#ifdef CONFIG_X86_32
 	loadsegment(es, ctxt->es);
 	loadsegment(fs, ctxt->fs);
 	loadsegment(gs, ctxt->gs);
@@ -185,6 +218,18 @@ static void __restore_processor_state(struct saved_context *ctxt)
 	 */
 	if (boot_cpu_has(X86_FEATURE_SEP))
 		enable_sep_cpu();
+#else
+/* CONFIG_X86_64 */
+	asm volatile ("movw %0, %%ds" :: "r" (ctxt->ds));
+	asm volatile ("movw %0, %%es" :: "r" (ctxt->es));
+	asm volatile ("movw %0, %%fs" :: "r" (ctxt->fs));
+	load_gs_index(ctxt->gs);
+	asm volatile ("movw %0, %%ss" :: "r" (ctxt->ss));
+
+	wrmsrl(MSR_FS_BASE, ctxt->fs_base);
+	wrmsrl(MSR_GS_BASE, ctxt->gs_base);
+	wrmsrl(MSR_KERNEL_GS_BASE, ctxt->gs_kernel_base);
+#endif
 
 	/*
 	 * restore XCR0 for xsave capable cpu's.
@@ -193,9 +238,13 @@ static void __restore_processor_state(struct saved_context *ctxt)
 		xsetbv(XCR_XFEATURE_ENABLED_MASK, pcntxt_mask);
 
 	fix_processor_context();
+
 	do_fpu_end();
 	mtrr_ap_init();
+
+#ifdef CONFIG_X86_32
 	mcheck_init(&boot_cpu_data);
+#endif
 }
 
 /* Needed by apm.c */
@@ -203,4 +252,6 @@ void restore_processor_state(void)
 {
 	__restore_processor_state(&saved_context);
 }
+#ifdef CONFIG_X86_32
 EXPORT_SYMBOL(restore_processor_state);
+#endif
diff --git a/arch/x86/power/cpu_64.c b/arch/x86/power/cpu_64.c
index 5ababf8..8bd680a 100644
--- a/arch/x86/power/cpu_64.c
+++ b/arch/x86/power/cpu_64.c
@@ -27,8 +27,6 @@ unsigned long saved_context_esi, saved_context_edi;
 unsigned long saved_context_eflags;
 #else
 /* CONFIG_X86_64 */
-static void fix_processor_context(void);
-
 struct saved_context saved_context;
 #endif
 
@@ -119,11 +117,57 @@ EXPORT_SYMBOL(save_processor_state);
 static void do_fpu_end(void)
 {
 	/*
-	 * Restore FPU regs if necessary
+	 * Restore FPU regs if necessary.
 	 */
 	kernel_fpu_end();
 }
 
+static void fix_processor_context(void)
+{
+	int cpu = smp_processor_id();
+	struct tss_struct *t = &per_cpu(init_tss, cpu);
+
+	set_tss_desc(cpu, t);	/*
+				 * This just modifies memory; should not be
+				 * necessary. But... This is necessary, because
+				 * 386 hardware has concept of busy TSS or some
+				 * similar stupidity.
+				 */
+
+#ifdef CONFIG_X86_64
+	get_cpu_gdt_table(cpu)[GDT_ENTRY_TSS].type = 9;
+
+	syscall_init();				/* This sets MSR_*STAR and related */
+#endif
+	load_TR_desc();				/* This does ltr */
+	load_LDT(&current->active_mm->context);	/* This does lldt */
+
+	/*
+	 * Now maybe reload the debug registers
+	 */
+	if (current->thread.debugreg7) {
+#ifdef CONFIG_X86_32
+		set_debugreg(current->thread.debugreg0, 0);
+		set_debugreg(current->thread.debugreg1, 1);
+		set_debugreg(current->thread.debugreg2, 2);
+		set_debugreg(current->thread.debugreg3, 3);
+		/* no 4 and 5 */
+		set_debugreg(current->thread.debugreg6, 6);
+		set_debugreg(current->thread.debugreg7, 7);
+#else
+		/* CONFIG_X86_64 */
+		loaddebug(&current->thread, 0);
+		loaddebug(&current->thread, 1);
+		loaddebug(&current->thread, 2);
+		loaddebug(&current->thread, 3);
+		/* no 4 and 5 */
+		loaddebug(&current->thread, 6);
+		loaddebug(&current->thread, 7);
+#endif
+	}
+
+}
+
 /**
  *	__restore_processor_state - restore the contents of CPU registers saved
  *		by __save_processor_state()
@@ -134,9 +178,16 @@ static void __restore_processor_state(struct saved_context *ctxt)
 	/*
 	 * control registers
 	 */
+	/* cr4 was introduced in the Pentium CPU */
+#ifdef CONFIG_X86_32
+	if (ctxt->cr4)
+		write_cr4(ctxt->cr4);
+#else
+/* CONFIG X86_64 */
 	wrmsrl(MSR_EFER, ctxt->efer);
 	write_cr8(ctxt->cr8);
 	write_cr4(ctxt->cr4);
+#endif
 	write_cr3(ctxt->cr3);
 	write_cr2(ctxt->cr2);
 	write_cr0(ctxt->cr0);
@@ -145,13 +196,31 @@ static void __restore_processor_state(struct saved_context *ctxt)
 	 * now restore the descriptor tables to their proper values
 	 * ltr is done i fix_processor_context().
 	 */
+#ifdef CONFIG_X86_32
+	load_gdt(&ctxt->gdt);
+	load_idt(&ctxt->idt);
+#else
+/* CONFIG_X86_64 */
 	load_gdt((const struct desc_ptr *)&ctxt->gdt_limit);
 	load_idt((const struct desc_ptr *)&ctxt->idt_limit);
-
+#endif
 
 	/*
 	 * segment registers
 	 */
+#ifdef CONFIG_X86_32
+	loadsegment(es, ctxt->es);
+	loadsegment(fs, ctxt->fs);
+	loadsegment(gs, ctxt->gs);
+	loadsegment(ss, ctxt->ss);
+
+	/*
+	 * sysenter MSRs
+	 */
+	if (boot_cpu_has(X86_FEATURE_SEP))
+		enable_sep_cpu();
+#else
+/* CONFIG_X86_64 */
 	asm volatile ("movw %0, %%ds" :: "r" (ctxt->ds));
 	asm volatile ("movw %0, %%es" :: "r" (ctxt->es));
 	asm volatile ("movw %0, %%fs" :: "r" (ctxt->fs));
@@ -161,6 +230,7 @@ static void __restore_processor_state(struct saved_context *ctxt)
 	wrmsrl(MSR_FS_BASE, ctxt->fs_base);
 	wrmsrl(MSR_GS_BASE, ctxt->gs_base);
 	wrmsrl(MSR_KERNEL_GS_BASE, ctxt->gs_kernel_base);
+#endif
 
 	/*
 	 * restore XCR0 for xsave capable cpu's.
@@ -172,41 +242,17 @@ static void __restore_processor_state(struct saved_context *ctxt)
 
 	do_fpu_end();
 	mtrr_ap_init();
+
+#ifdef CONFIG_X86_32
+	mcheck_init(&boot_cpu_data);
+#endif
 }
 
+/* Needed by apm.c */
 void restore_processor_state(void)
 {
 	__restore_processor_state(&saved_context);
 }
-
-static void fix_processor_context(void)
-{
-	int cpu = smp_processor_id();
-	struct tss_struct *t = &per_cpu(init_tss, cpu);
-
-	/*
-	 * This just modifies memory; should not be necessary. But... This
-	 * is necessary, because 386 hardware has concept of busy TSS or some
-	 * similar stupidity.
-	 */
-	set_tss_desc(cpu, t);
-
-	get_cpu_gdt_table(cpu)[GDT_ENTRY_TSS].type = 9;
-
-	syscall_init();                         /* This sets MSR_*STAR and related */
-	load_TR_desc();				/* This does ltr */
-	load_LDT(&current->active_mm->context);	/* This does lldt */
-
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
-}
+#ifdef CONFIG_X86_32
+EXPORT_SYMBOL(restore_processor_state);
+#endif
