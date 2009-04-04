Return-Path: <linux-kernel-owner+w=401wt.eu-S1760566AbZDDItO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760566AbZDDItO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 04:49:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755834AbZDDIs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 04:48:57 -0400
Received: from mail-qy0-f118.google.com ([209.85.221.118]:60016 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756150AbZDDIs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 04:48:56 -0400
Message-ID: <49D71EEE.30600@larces.uece.br>
Date: Sat, 04 Apr 2009 05:48:46 -0300
From: Sergio Luis <sergio@larces.uece.br>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: Linux-kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Lauro Salmito <laurosalmito@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@suse.cz>, x86 Maintainers <x86@kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 6/6] x86: unify power/cpu_(32|64).c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86: unify power/cpu_(32|64).c

This is the last unification step. Here we do remove one of the files
and rename the left one as cpu.c, as both are now the same.
Also update power/Makefile, telling it to build cpu.o, instead of
cpu_(32|64).o

Signed-off-by: Sergio Luis <sergio@larces.uece.br>
Signed-off-by: Lauro Salmito <laurosalmito@gmail.com>
---
 arch/x86/power/Makefile |    2 +-
 arch/x86/power/cpu.c    |  258 +++++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/power/cpu_32.c |  258 -----------------------------------------------
 arch/x86/power/cpu_64.c |  258 -----------------------------------------------
 4 files changed, 259 insertions(+), 517 deletions(-)
 create mode 100644 arch/x86/power/cpu.c
 delete mode 100644 arch/x86/power/cpu_32.c
 delete mode 100644 arch/x86/power/cpu_64.c

diff --git a/arch/x86/power/Makefile b/arch/x86/power/Makefile
index 9ff4d5b..a81a0d4 100644
--- a/arch/x86/power/Makefile
+++ b/arch/x86/power/Makefile
@@ -1,2 +1,2 @@
-obj-$(CONFIG_PM_SLEEP)		+= cpu_$(BITS).o
+obj-$(CONFIG_PM_SLEEP)		+= cpu.o
 obj-$(CONFIG_HIBERNATION)	+= hibernate_$(BITS).o hibernate_asm_$(BITS).o
diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
new file mode 100644
index 0000000..48cce37
--- /dev/null
+++ b/arch/x86/power/cpu.c
@@ -0,0 +1,258 @@
+/*
+ * Suspend support specific for i386/x86-64.
+ *
+ * Distribute under GPLv2
+ *
+ * Copyright (c) 2007 Rafael J. Wysocki <rjw@sisk.pl>
+ * Copyright (c) 2002 Pavel Machek <pavel@suse.cz>
+ * Copyright (c) 2001 Patrick Mochel <mochel@osdl.org>
+ */
+
+#include <linux/suspend.h>
+#include <linux/smp.h>
+
+#include <asm/pgtable.h>
+#include <asm/proto.h>
+#include <asm/mtrr.h>
+#include <asm/page.h>
+#include <asm/mce.h>
+#include <asm/xcr.h>
+
+#ifdef CONFIG_X86_32
+static struct saved_context saved_context;
+
+unsigned long saved_context_ebx;
+unsigned long saved_context_esp, saved_context_ebp;
+unsigned long saved_context_esi, saved_context_edi;
+unsigned long saved_context_eflags;
+#else
+/* CONFIG_X86_64 */
+struct saved_context saved_context;
+#endif
+
+/**
+ *	__save_processor_state - save CPU registers before creating a
+ *		hibernation image and before restoring the memory state from it
+ *	@ctxt - structure to store the registers contents in
+ *
+ *	NOTE: If there is a CPU register the modification of which by the
+ *	boot kernel (ie. the kernel used for loading the hibernation image)
+ *	might affect the operations of the restored target kernel (ie. the one
+ *	saved in the hibernation image), then its contents must be saved by this
+ *	function.  In other words, if kernel A is hibernated and different
+ *	kernel B is used for loading the hibernation image into memory, the
+ *	kernel A's __save_processor_state() function must save all registers
+ *	needed by kernel A, so that it can operate correctly after the resume
+ *	regardless of what kernel B does in the meantime.
+ */
+static void __save_processor_state(struct saved_context *ctxt)
+{
+#ifdef CONFIG_X86_32
+	mtrr_save_fixed_ranges(NULL);
+#endif
+	kernel_fpu_begin();
+
+	/*
+	 * descriptor tables
+	 */
+#ifdef CONFIG_X86_32
+	store_gdt(&ctxt->gdt);
+	store_idt(&ctxt->idt);
+#else
+/* CONFIG_X86_64 */
+	store_gdt((struct desc_ptr *)&ctxt->gdt_limit);
+	store_idt((struct desc_ptr *)&ctxt->idt_limit);
+#endif
+	store_tr(ctxt->tr);
+
+	/* XMM0..XMM15 should be handled by kernel_fpu_begin(). */
+	/*
+	 * segment registers
+	 */
+#ifdef CONFIG_X86_32
+	savesegment(es, ctxt->es);
+	savesegment(fs, ctxt->fs);
+	savesegment(gs, ctxt->gs);
+	savesegment(ss, ctxt->ss);
+#else
+/* CONFIG_X86_64 */
+	asm volatile ("movw %%ds, %0" : "=m" (ctxt->ds));
+	asm volatile ("movw %%es, %0" : "=m" (ctxt->es));
+	asm volatile ("movw %%fs, %0" : "=m" (ctxt->fs));
+	asm volatile ("movw %%gs, %0" : "=m" (ctxt->gs));
+	asm volatile ("movw %%ss, %0" : "=m" (ctxt->ss));
+
+	rdmsrl(MSR_FS_BASE, ctxt->fs_base);
+	rdmsrl(MSR_GS_BASE, ctxt->gs_base);
+	rdmsrl(MSR_KERNEL_GS_BASE, ctxt->gs_kernel_base);
+	mtrr_save_fixed_ranges(NULL);
+
+	rdmsrl(MSR_EFER, ctxt->efer);
+#endif
+
+	/*
+	 * control registers
+	 */
+	ctxt->cr0 = read_cr0();
+	ctxt->cr2 = read_cr2();
+	ctxt->cr3 = read_cr3();
+#ifdef CONFIG_X86_32
+	ctxt->cr4 = read_cr4_safe();
+#else
+/* CONFIG_X86_64 */
+	ctxt->cr4 = read_cr4();
+	ctxt->cr8 = read_cr8();
+#endif
+}
+
+/* Needed by apm.c */
+void save_processor_state(void)
+{
+	__save_processor_state(&saved_context);
+}
+#ifdef CONFIG_X86_32
+EXPORT_SYMBOL(save_processor_state);
+#endif
+
+static void do_fpu_end(void)
+{
+	/*
+	 * Restore FPU regs if necessary.
+	 */
+	kernel_fpu_end();
+}
+
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
+/**
+ *	__restore_processor_state - restore the contents of CPU registers saved
+ *		by __save_processor_state()
+ *	@ctxt - structure to load the registers contents from
+ */
+static void __restore_processor_state(struct saved_context *ctxt)
+{
+	/*
+	 * control registers
+	 */
+	/* cr4 was introduced in the Pentium CPU */
+#ifdef CONFIG_X86_32
+	if (ctxt->cr4)
+		write_cr4(ctxt->cr4);
+#else
+/* CONFIG X86_64 */
+	wrmsrl(MSR_EFER, ctxt->efer);
+	write_cr8(ctxt->cr8);
+	write_cr4(ctxt->cr4);
+#endif
+	write_cr3(ctxt->cr3);
+	write_cr2(ctxt->cr2);
+	write_cr0(ctxt->cr0);
+
+	/*
+	 * now restore the descriptor tables to their proper values
+	 * ltr is done i fix_processor_context().
+	 */
+#ifdef CONFIG_X86_32
+	load_gdt(&ctxt->gdt);
+	load_idt(&ctxt->idt);
+#else
+/* CONFIG_X86_64 */
+	load_gdt((const struct desc_ptr *)&ctxt->gdt_limit);
+	load_idt((const struct desc_ptr *)&ctxt->idt_limit);
+#endif
+
+	/*
+	 * segment registers
+	 */
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
+
+	/*
+	 * restore XCR0 for xsave capable cpu's.
+	 */
+	if (cpu_has_xsave)
+		xsetbv(XCR_XFEATURE_ENABLED_MASK, pcntxt_mask);
+
+	fix_processor_context();
+
+	do_fpu_end();
+	mtrr_ap_init();
+
+#ifdef CONFIG_X86_32
+	mcheck_init(&boot_cpu_data);
+#endif
+}
+
+/* Needed by apm.c */
+void restore_processor_state(void)
+{
+	__restore_processor_state(&saved_context);
+}
+#ifdef CONFIG_X86_32
+EXPORT_SYMBOL(restore_processor_state);
+#endif
diff --git a/arch/x86/power/cpu_32.c b/arch/x86/power/cpu_32.c
deleted file mode 100644
index 2285ac7..0000000
--- a/arch/x86/power/cpu_32.c
+++ /dev/null
@@ -1,258 +0,0 @@
-/*
- * Suspend and hibernation support for i386/x86-64.
- *
- * Distribute under GPLv2
- *
- * Copyright (c) 2007 Rafael J. Wysocki <rjw@sisk.pl>
- * Copyright (c) 2002 Pavel Machek <pavel@suse.cz>
- * Copyright (c) 2001 Patrick Mochel <mochel@osdl.org>
- */
-
-#include <linux/suspend.h>
-#include <linux/smp.h>
-
-#include <asm/pgtable.h>
-#include <asm/proto.h>
-#include <asm/mtrr.h>
-#include <asm/page.h>
-#include <asm/mce.h>
-#include <asm/xcr.h>
-
-#ifdef CONFIG_X86_32
-static struct saved_context saved_context;
-
-unsigned long saved_context_ebx;
-unsigned long saved_context_esp, saved_context_ebp;
-unsigned long saved_context_esi, saved_context_edi;
-unsigned long saved_context_eflags;
-#else
-/* CONFIG_X86_64 */
-struct saved_context saved_context;
-#endif
-
-/**
- *	__save_processor_state - save CPU registers before creating a
- *		hibernation image and before restoring the memory state from it
- *	@ctxt - structure to store the registers contents in
- *
- *	NOTE: If there is a CPU register the modification of which by the
- *	boot kernel (ie. the kernel used for loading the hibernation image)
- *	might affect the operations of the restored target kernel (ie. the one
- *	saved in the hibernation image), then its contents must be saved by this
- *	function.  In other words, if kernel A is hibernated and different
- *	kernel B is used for loading the hibernation image into memory, the
- *	kernel A's __save_processor_state() function must save all registers
- *	needed by kernel A, so that it can operate correctly after the resume
- *	regardless of what kernel B does in the meantime.
- */
-static void __save_processor_state(struct saved_context *ctxt)
-{
-#ifdef CONFIG_X86_32
-	mtrr_save_fixed_ranges(NULL);
-#endif
-	kernel_fpu_begin();
-
-	/*
-	 * descriptor tables
-	 */
-#ifdef CONFIG_X86_32
-	store_gdt(&ctxt->gdt);
-	store_idt(&ctxt->idt);
-#else
-/* CONFIG_X86_64 */
-	store_gdt((struct desc_ptr *)&ctxt->gdt_limit);
-	store_idt((struct desc_ptr *)&ctxt->idt_limit);
-#endif
-	store_tr(ctxt->tr);
-
-	/* XMM0..XMM15 should be handled by kernel_fpu_begin(). */
-	/*
-	 * segment registers
-	 */
-#ifdef CONFIG_X86_32
-	savesegment(es, ctxt->es);
-	savesegment(fs, ctxt->fs);
-	savesegment(gs, ctxt->gs);
-	savesegment(ss, ctxt->ss);
-#else
-/* CONFIG_X86_64 */
-	asm volatile ("movw %%ds, %0" : "=m" (ctxt->ds));
-	asm volatile ("movw %%es, %0" : "=m" (ctxt->es));
-	asm volatile ("movw %%fs, %0" : "=m" (ctxt->fs));
-	asm volatile ("movw %%gs, %0" : "=m" (ctxt->gs));
-	asm volatile ("movw %%ss, %0" : "=m" (ctxt->ss));
-
-	rdmsrl(MSR_FS_BASE, ctxt->fs_base);
-	rdmsrl(MSR_GS_BASE, ctxt->gs_base);
-	rdmsrl(MSR_KERNEL_GS_BASE, ctxt->gs_kernel_base);
-	mtrr_save_fixed_ranges(NULL);
-
-	rdmsrl(MSR_EFER, ctxt->efer);
-#endif
-
-	/*
-	 * control registers
-	 */
-	ctxt->cr0 = read_cr0();
-	ctxt->cr2 = read_cr2();
-	ctxt->cr3 = read_cr3();
-#ifdef CONFIG_X86_32
-	ctxt->cr4 = read_cr4_safe();
-#else
-/* CONFIG_X86_64 */
-	ctxt->cr4 = read_cr4();
-	ctxt->cr8 = read_cr8();
-#endif
-}
-
-/* Needed by apm.c */
-void save_processor_state(void)
-{
-	__save_processor_state(&saved_context);
-}
-#ifdef CONFIG_X86_32
-EXPORT_SYMBOL(save_processor_state);
-#endif
-
-static void do_fpu_end(void)
-{
-	/*
-	 * Restore FPU regs if necessary.
-	 */
-	kernel_fpu_end();
-}
-
-static void fix_processor_context(void)
-{
-	int cpu = smp_processor_id();
-	struct tss_struct *t = &per_cpu(init_tss, cpu);
-
-	set_tss_desc(cpu, t);	/*
-				 * This just modifies memory; should not be
-				 * necessary. But... This is necessary, because
-				 * 386 hardware has concept of busy TSS or some
-				 * similar stupidity.
-				 */
-
-#ifdef CONFIG_X86_64
-	get_cpu_gdt_table(cpu)[GDT_ENTRY_TSS].type = 9;
-
-	syscall_init();				/* This sets MSR_*STAR and related */
-#endif
-	load_TR_desc();				/* This does ltr */
-	load_LDT(&current->active_mm->context);	/* This does lldt */
-
-	/*
-	 * Now maybe reload the debug registers
-	 */
-	if (current->thread.debugreg7) {
-#ifdef CONFIG_X86_32
-		set_debugreg(current->thread.debugreg0, 0);
-		set_debugreg(current->thread.debugreg1, 1);
-		set_debugreg(current->thread.debugreg2, 2);
-		set_debugreg(current->thread.debugreg3, 3);
-		/* no 4 and 5 */
-		set_debugreg(current->thread.debugreg6, 6);
-		set_debugreg(current->thread.debugreg7, 7);
-#else
-		/* CONFIG_X86_64 */
-		loaddebug(&current->thread, 0);
-		loaddebug(&current->thread, 1);
-		loaddebug(&current->thread, 2);
-		loaddebug(&current->thread, 3);
-		/* no 4 and 5 */
-		loaddebug(&current->thread, 6);
-		loaddebug(&current->thread, 7);
-#endif
-	}
-
-}
-
-/**
- *	__restore_processor_state - restore the contents of CPU registers saved
- *		by __save_processor_state()
- *	@ctxt - structure to load the registers contents from
- */
-static void __restore_processor_state(struct saved_context *ctxt)
-{
-	/*
-	 * control registers
-	 */
-	/* cr4 was introduced in the Pentium CPU */
-#ifdef CONFIG_X86_32
-	if (ctxt->cr4)
-		write_cr4(ctxt->cr4);
-#else
-/* CONFIG X86_64 */
-	wrmsrl(MSR_EFER, ctxt->efer);
-	write_cr8(ctxt->cr8);
-	write_cr4(ctxt->cr4);
-#endif
-	write_cr3(ctxt->cr3);
-	write_cr2(ctxt->cr2);
-	write_cr0(ctxt->cr0);
-
-	/*
-	 * now restore the descriptor tables to their proper values
-	 * ltr is done i fix_processor_context().
-	 */
-#ifdef CONFIG_X86_32
-	load_gdt(&ctxt->gdt);
-	load_idt(&ctxt->idt);
-#else
-/* CONFIG_X86_64 */
-	load_gdt((const struct desc_ptr *)&ctxt->gdt_limit);
-	load_idt((const struct desc_ptr *)&ctxt->idt_limit);
-#endif
-
-	/*
-	 * segment registers
-	 */
-#ifdef CONFIG_X86_32
-	loadsegment(es, ctxt->es);
-	loadsegment(fs, ctxt->fs);
-	loadsegment(gs, ctxt->gs);
-	loadsegment(ss, ctxt->ss);
-
-	/*
-	 * sysenter MSRs
-	 */
-	if (boot_cpu_has(X86_FEATURE_SEP))
-		enable_sep_cpu();
-#else
-/* CONFIG_X86_64 */
-	asm volatile ("movw %0, %%ds" :: "r" (ctxt->ds));
-	asm volatile ("movw %0, %%es" :: "r" (ctxt->es));
-	asm volatile ("movw %0, %%fs" :: "r" (ctxt->fs));
-	load_gs_index(ctxt->gs);
-	asm volatile ("movw %0, %%ss" :: "r" (ctxt->ss));
-
-	wrmsrl(MSR_FS_BASE, ctxt->fs_base);
-	wrmsrl(MSR_GS_BASE, ctxt->gs_base);
-	wrmsrl(MSR_KERNEL_GS_BASE, ctxt->gs_kernel_base);
-#endif
-
-	/*
-	 * restore XCR0 for xsave capable cpu's.
-	 */
-	if (cpu_has_xsave)
-		xsetbv(XCR_XFEATURE_ENABLED_MASK, pcntxt_mask);
-
-	fix_processor_context();
-
-	do_fpu_end();
-	mtrr_ap_init();
-
-#ifdef CONFIG_X86_32
-	mcheck_init(&boot_cpu_data);
-#endif
-}
-
-/* Needed by apm.c */
-void restore_processor_state(void)
-{
-	__restore_processor_state(&saved_context);
-}
-#ifdef CONFIG_X86_32
-EXPORT_SYMBOL(restore_processor_state);
-#endif
diff --git a/arch/x86/power/cpu_64.c b/arch/x86/power/cpu_64.c
deleted file mode 100644
index 48cce37..0000000
--- a/arch/x86/power/cpu_64.c
+++ /dev/null
@@ -1,258 +0,0 @@
-/*
- * Suspend support specific for i386/x86-64.
- *
- * Distribute under GPLv2
- *
- * Copyright (c) 2007 Rafael J. Wysocki <rjw@sisk.pl>
- * Copyright (c) 2002 Pavel Machek <pavel@suse.cz>
- * Copyright (c) 2001 Patrick Mochel <mochel@osdl.org>
- */
-
-#include <linux/suspend.h>
-#include <linux/smp.h>
-
-#include <asm/pgtable.h>
-#include <asm/proto.h>
-#include <asm/mtrr.h>
-#include <asm/page.h>
-#include <asm/mce.h>
-#include <asm/xcr.h>
-
-#ifdef CONFIG_X86_32
-static struct saved_context saved_context;
-
-unsigned long saved_context_ebx;
-unsigned long saved_context_esp, saved_context_ebp;
-unsigned long saved_context_esi, saved_context_edi;
-unsigned long saved_context_eflags;
-#else
-/* CONFIG_X86_64 */
-struct saved_context saved_context;
-#endif
-
-/**
- *	__save_processor_state - save CPU registers before creating a
- *		hibernation image and before restoring the memory state from it
- *	@ctxt - structure to store the registers contents in
- *
- *	NOTE: If there is a CPU register the modification of which by the
- *	boot kernel (ie. the kernel used for loading the hibernation image)
- *	might affect the operations of the restored target kernel (ie. the one
- *	saved in the hibernation image), then its contents must be saved by this
- *	function.  In other words, if kernel A is hibernated and different
- *	kernel B is used for loading the hibernation image into memory, the
- *	kernel A's __save_processor_state() function must save all registers
- *	needed by kernel A, so that it can operate correctly after the resume
- *	regardless of what kernel B does in the meantime.
- */
-static void __save_processor_state(struct saved_context *ctxt)
-{
-#ifdef CONFIG_X86_32
-	mtrr_save_fixed_ranges(NULL);
-#endif
-	kernel_fpu_begin();
-
-	/*
-	 * descriptor tables
-	 */
-#ifdef CONFIG_X86_32
-	store_gdt(&ctxt->gdt);
-	store_idt(&ctxt->idt);
-#else
-/* CONFIG_X86_64 */
-	store_gdt((struct desc_ptr *)&ctxt->gdt_limit);
-	store_idt((struct desc_ptr *)&ctxt->idt_limit);
-#endif
-	store_tr(ctxt->tr);
-
-	/* XMM0..XMM15 should be handled by kernel_fpu_begin(). */
-	/*
-	 * segment registers
-	 */
-#ifdef CONFIG_X86_32
-	savesegment(es, ctxt->es);
-	savesegment(fs, ctxt->fs);
-	savesegment(gs, ctxt->gs);
-	savesegment(ss, ctxt->ss);
-#else
-/* CONFIG_X86_64 */
-	asm volatile ("movw %%ds, %0" : "=m" (ctxt->ds));
-	asm volatile ("movw %%es, %0" : "=m" (ctxt->es));
-	asm volatile ("movw %%fs, %0" : "=m" (ctxt->fs));
-	asm volatile ("movw %%gs, %0" : "=m" (ctxt->gs));
-	asm volatile ("movw %%ss, %0" : "=m" (ctxt->ss));
-
-	rdmsrl(MSR_FS_BASE, ctxt->fs_base);
-	rdmsrl(MSR_GS_BASE, ctxt->gs_base);
-	rdmsrl(MSR_KERNEL_GS_BASE, ctxt->gs_kernel_base);
-	mtrr_save_fixed_ranges(NULL);
-
-	rdmsrl(MSR_EFER, ctxt->efer);
-#endif
-
-	/*
-	 * control registers
-	 */
-	ctxt->cr0 = read_cr0();
-	ctxt->cr2 = read_cr2();
-	ctxt->cr3 = read_cr3();
-#ifdef CONFIG_X86_32
-	ctxt->cr4 = read_cr4_safe();
-#else
-/* CONFIG_X86_64 */
-	ctxt->cr4 = read_cr4();
-	ctxt->cr8 = read_cr8();
-#endif
-}
-
-/* Needed by apm.c */
-void save_processor_state(void)
-{
-	__save_processor_state(&saved_context);
-}
-#ifdef CONFIG_X86_32
-EXPORT_SYMBOL(save_processor_state);
-#endif
-
-static void do_fpu_end(void)
-{
-	/*
-	 * Restore FPU regs if necessary.
-	 */
-	kernel_fpu_end();
-}
-
-static void fix_processor_context(void)
-{
-	int cpu = smp_processor_id();
-	struct tss_struct *t = &per_cpu(init_tss, cpu);
-
-	set_tss_desc(cpu, t);	/*
-				 * This just modifies memory; should not be
-				 * necessary. But... This is necessary, because
-				 * 386 hardware has concept of busy TSS or some
-				 * similar stupidity.
-				 */
-
-#ifdef CONFIG_X86_64
-	get_cpu_gdt_table(cpu)[GDT_ENTRY_TSS].type = 9;
-
-	syscall_init();				/* This sets MSR_*STAR and related */
-#endif
-	load_TR_desc();				/* This does ltr */
-	load_LDT(&current->active_mm->context);	/* This does lldt */
-
-	/*
-	 * Now maybe reload the debug registers
-	 */
-	if (current->thread.debugreg7) {
-#ifdef CONFIG_X86_32
-		set_debugreg(current->thread.debugreg0, 0);
-		set_debugreg(current->thread.debugreg1, 1);
-		set_debugreg(current->thread.debugreg2, 2);
-		set_debugreg(current->thread.debugreg3, 3);
-		/* no 4 and 5 */
-		set_debugreg(current->thread.debugreg6, 6);
-		set_debugreg(current->thread.debugreg7, 7);
-#else
-		/* CONFIG_X86_64 */
-		loaddebug(&current->thread, 0);
-		loaddebug(&current->thread, 1);
-		loaddebug(&current->thread, 2);
-		loaddebug(&current->thread, 3);
-		/* no 4 and 5 */
-		loaddebug(&current->thread, 6);
-		loaddebug(&current->thread, 7);
-#endif
-	}
-
-}
-
-/**
- *	__restore_processor_state - restore the contents of CPU registers saved
- *		by __save_processor_state()
- *	@ctxt - structure to load the registers contents from
- */
-static void __restore_processor_state(struct saved_context *ctxt)
-{
-	/*
-	 * control registers
-	 */
-	/* cr4 was introduced in the Pentium CPU */
-#ifdef CONFIG_X86_32
-	if (ctxt->cr4)
-		write_cr4(ctxt->cr4);
-#else
-/* CONFIG X86_64 */
-	wrmsrl(MSR_EFER, ctxt->efer);
-	write_cr8(ctxt->cr8);
-	write_cr4(ctxt->cr4);
-#endif
-	write_cr3(ctxt->cr3);
-	write_cr2(ctxt->cr2);
-	write_cr0(ctxt->cr0);
-
-	/*
-	 * now restore the descriptor tables to their proper values
-	 * ltr is done i fix_processor_context().
-	 */
-#ifdef CONFIG_X86_32
-	load_gdt(&ctxt->gdt);
-	load_idt(&ctxt->idt);
-#else
-/* CONFIG_X86_64 */
-	load_gdt((const struct desc_ptr *)&ctxt->gdt_limit);
-	load_idt((const struct desc_ptr *)&ctxt->idt_limit);
-#endif
-
-	/*
-	 * segment registers
-	 */
-#ifdef CONFIG_X86_32
-	loadsegment(es, ctxt->es);
-	loadsegment(fs, ctxt->fs);
-	loadsegment(gs, ctxt->gs);
-	loadsegment(ss, ctxt->ss);
-
-	/*
-	 * sysenter MSRs
-	 */
-	if (boot_cpu_has(X86_FEATURE_SEP))
-		enable_sep_cpu();
-#else
-/* CONFIG_X86_64 */
-	asm volatile ("movw %0, %%ds" :: "r" (ctxt->ds));
-	asm volatile ("movw %0, %%es" :: "r" (ctxt->es));
-	asm volatile ("movw %0, %%fs" :: "r" (ctxt->fs));
-	load_gs_index(ctxt->gs);
-	asm volatile ("movw %0, %%ss" :: "r" (ctxt->ss));
-
-	wrmsrl(MSR_FS_BASE, ctxt->fs_base);
-	wrmsrl(MSR_GS_BASE, ctxt->gs_base);
-	wrmsrl(MSR_KERNEL_GS_BASE, ctxt->gs_kernel_base);
-#endif
-
-	/*
-	 * restore XCR0 for xsave capable cpu's.
-	 */
-	if (cpu_has_xsave)
-		xsetbv(XCR_XFEATURE_ENABLED_MASK, pcntxt_mask);
-
-	fix_processor_context();
-
-	do_fpu_end();
-	mtrr_ap_init();
-
-#ifdef CONFIG_X86_32
-	mcheck_init(&boot_cpu_data);
-#endif
-}
-
-/* Needed by apm.c */
-void restore_processor_state(void)
-{
-	__restore_processor_state(&saved_context);
-}
-#ifdef CONFIG_X86_32
-EXPORT_SYMBOL(restore_processor_state);
-#endif
