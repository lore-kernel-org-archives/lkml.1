Return-Path: <linux-kernel-owner+w=401wt.eu-S1760896AbZDDIrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760896AbZDDIrS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 04:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750939AbZDDIrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 04:47:00 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:61178 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760233AbZDDIq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 04:46:59 -0400
Message-ID: <49D71E7B.10202@larces.uece.br>
Date: Sat, 04 Apr 2009 05:46:51 -0300
From: Sergio Luis <sergio@larces.uece.br>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: Linux-kernel Mailing List <linux-kernel@vger.kernel.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@suse.cz>,
       x86 Maintainers <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 3/6] x86: unify power/cpu_(32|64) regarding saving processor
 state
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86: unify power/cpu_(32|64) regarding saving processor state

In this step we do unify cpu_32.c and cpu_64.c functions that
work on saving the processor state.

Signed-off-by: Sergio Luis <sergio@larces.uece.br>
Signed-off-by: Lauro Salmito <laurosalmito@gmail.com>
---
 arch/x86/power/cpu_32.c |   48 +++++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/power/cpu_64.c |   29 +++++++++++++++++++++++++++-
 2 files changed, 76 insertions(+), 1 deletions(-)

diff --git a/arch/x86/power/cpu_32.c b/arch/x86/power/cpu_32.c
index e4bdc2a..dd32ecc 100644
--- a/arch/x86/power/cpu_32.c
+++ b/arch/x86/power/cpu_32.c
@@ -31,25 +31,65 @@ static void fix_processor_context(void);
 struct saved_context saved_context;
 #endif
 
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
 static void __save_processor_state(struct saved_context *ctxt)
 {
+#ifdef CONFIG_X86_32
 	mtrr_save_fixed_ranges(NULL);
+#endif
 	kernel_fpu_begin();
 
 	/*
 	 * descriptor tables
 	 */
+#ifdef CONFIG_X86_32
 	store_gdt(&ctxt->gdt);
 	store_idt(&ctxt->idt);
+#else
+/* CONFIG_X86_64 */
+	store_gdt((struct desc_ptr *)&ctxt->gdt_limit);
+	store_idt((struct desc_ptr *)&ctxt->idt_limit);
+#endif
 	store_tr(ctxt->tr);
 
+	/* XMM0..XMM15 should be handled by kernel_fpu_begin(). */
 	/*
 	 * segment registers
 	 */
+#ifdef CONFIG_X86_32
 	savesegment(es, ctxt->es);
 	savesegment(fs, ctxt->fs);
 	savesegment(gs, ctxt->gs);
 	savesegment(ss, ctxt->ss);
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
 
 	/*
 	 * control registers
@@ -57,7 +97,13 @@ static void __save_processor_state(struct saved_context *ctxt)
 	ctxt->cr0 = read_cr0();
 	ctxt->cr2 = read_cr2();
 	ctxt->cr3 = read_cr3();
+#ifdef CONFIG_X86_32
 	ctxt->cr4 = read_cr4_safe();
+#else
+/* CONFIG_X86_64 */
+	ctxt->cr4 = read_cr4();
+	ctxt->cr8 = read_cr8();
+#endif
 }
 
 /* Needed by apm.c */
@@ -65,7 +111,9 @@ void save_processor_state(void)
 {
 	__save_processor_state(&saved_context);
 }
+#ifdef CONFIG_X86_32
 EXPORT_SYMBOL(save_processor_state);
+#endif
 
 static void do_fpu_end(void)
 {
diff --git a/arch/x86/power/cpu_64.c b/arch/x86/power/cpu_64.c
index 1ee153e..5ababf8 100644
--- a/arch/x86/power/cpu_64.c
+++ b/arch/x86/power/cpu_64.c
@@ -49,19 +49,35 @@ struct saved_context saved_context;
  */
 static void __save_processor_state(struct saved_context *ctxt)
 {
+#ifdef CONFIG_X86_32
+	mtrr_save_fixed_ranges(NULL);
+#endif
 	kernel_fpu_begin();
 
 	/*
 	 * descriptor tables
 	 */
+#ifdef CONFIG_X86_32
+	store_gdt(&ctxt->gdt);
+	store_idt(&ctxt->idt);
+#else
+/* CONFIG_X86_64 */
 	store_gdt((struct desc_ptr *)&ctxt->gdt_limit);
 	store_idt((struct desc_ptr *)&ctxt->idt_limit);
+#endif
 	store_tr(ctxt->tr);
 
 	/* XMM0..XMM15 should be handled by kernel_fpu_begin(). */
 	/*
 	 * segment registers
 	 */
+#ifdef CONFIG_X86_32
+	savesegment(es, ctxt->es);
+	savesegment(fs, ctxt->fs);
+	savesegment(gs, ctxt->gs);
+	savesegment(ss, ctxt->ss);
+#else
+/* CONFIG_X86_64 */
 	asm volatile ("movw %%ds, %0" : "=m" (ctxt->ds));
 	asm volatile ("movw %%es, %0" : "=m" (ctxt->es));
 	asm volatile ("movw %%fs, %0" : "=m" (ctxt->fs));
@@ -73,21 +89,32 @@ static void __save_processor_state(struct saved_context *ctxt)
 	rdmsrl(MSR_KERNEL_GS_BASE, ctxt->gs_kernel_base);
 	mtrr_save_fixed_ranges(NULL);
 
+	rdmsrl(MSR_EFER, ctxt->efer);
+#endif
+
 	/*
 	 * control registers
 	 */
-	rdmsrl(MSR_EFER, ctxt->efer);
 	ctxt->cr0 = read_cr0();
 	ctxt->cr2 = read_cr2();
 	ctxt->cr3 = read_cr3();
+#ifdef CONFIG_X86_32
+	ctxt->cr4 = read_cr4_safe();
+#else
+/* CONFIG_X86_64 */
 	ctxt->cr4 = read_cr4();
 	ctxt->cr8 = read_cr8();
+#endif
 }
 
+/* Needed by apm.c */
 void save_processor_state(void)
 {
 	__save_processor_state(&saved_context);
 }
+#ifdef CONFIG_X86_32
+EXPORT_SYMBOL(save_processor_state);
+#endif
 
 static void do_fpu_end(void)
 {
