Return-Path: <linux-kernel-owner+w=401wt.eu-S965271AbXD3Kaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965271AbXD3Kaw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 06:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754661AbXD3K2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 06:28:38 -0400
Received: from ns1.suse.de ([195.135.220.2]:51237 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965280AbXD3K2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 06:28:03 -0400
From: Andi Kleen <ak@suse.de>
References: <200704301227.598020000@suse.de>
In-Reply-To: <200704301227.598020000@suse.de>
To: jeremy@goop.org, rusty@rustcorp.com.au, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [28/40] i386: Fix UP gdt bugs
Message-Id: <20070430102802.B877C151D2@wotan.suse.de>
Date: Mon, 30 Apr 2007 12:28:02 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Jeremy Fitzhardinge <jeremy@goop.org>
Fixes two problems with the GDT when compiling for uniprocessor:
 - There's no percpu segment, so trying to load its selector into %fs fails.
   Use a null selector instead.
 - The real gdt needs to be loaded at some point.  Do it in cpu_init().

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>

---
 arch/i386/kernel/cpu/common.c |   13 +++++++++++++
 arch/i386/kernel/smpboot.c    |   12 ------------
 include/asm-i386/processor.h  |    1 +
 include/asm-i386/segment.h    |    4 ++++
 4 files changed, 18 insertions(+), 12 deletions(-)

===================================================================
Index: linux/arch/i386/kernel/cpu/common.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/common.c
+++ linux/arch/i386/kernel/cpu/common.c
@@ -638,6 +638,18 @@ struct pt_regs * __devinit idle_regs(str
 	return regs;
 }
 
+/* Current gdt points %fs at the "master" per-cpu area: after this,
+ * it's on the real one. */
+void switch_to_new_gdt(void)
+{
+	struct Xgt_desc_struct gdt_descr;
+
+	gdt_descr.address = (long)get_cpu_gdt_table(smp_processor_id());
+	gdt_descr.size = GDT_SIZE - 1;
+	load_gdt(&gdt_descr);
+	asm("mov %0, %%fs" : : "r" (__KERNEL_PERCPU) : "memory");
+}
+
 /*
  * cpu_init() initializes state that is per-CPU. Some data is already
  * initialized (naturally) in the bootstrap process, such as the GDT
@@ -668,6 +680,7 @@ void __cpuinit cpu_init(void)
 	}
 
 	load_idt(&idt_descr);
+	switch_to_new_gdt();
 
 	/*
 	 * Set up and load the per-CPU TSS and LDT
Index: linux/arch/i386/kernel/smpboot.c
===================================================================
--- linux.orig/arch/i386/kernel/smpboot.c
+++ linux/arch/i386/kernel/smpboot.c
@@ -1177,18 +1177,6 @@ void __init native_smp_prepare_cpus(unsi
 	smp_boot_cpus(max_cpus);
 }
 
-/* Current gdt points %fs at the "master" per-cpu area: after this,
- * it's on the real one. */
-static inline void switch_to_new_gdt(void)
-{
-	struct Xgt_desc_struct gdt_descr;
-
-	gdt_descr.address = (long)get_cpu_gdt_table(smp_processor_id());
-	gdt_descr.size = GDT_SIZE - 1;
-	load_gdt(&gdt_descr);
-	asm("mov %0, %%fs" : : "r" (__KERNEL_PERCPU) : "memory");
-}
-
 void __init native_smp_prepare_boot_cpu(void)
 {
 	unsigned int cpu = smp_processor_id();
Index: linux/include/asm-i386/processor.h
===================================================================
--- linux.orig/include/asm-i386/processor.h
+++ linux/include/asm-i386/processor.h
@@ -750,6 +750,7 @@ extern void enable_sep_cpu(void);
 extern int sysenter_setup(void);
 
 extern void cpu_set_gdt(int);
+extern void switch_to_new_gdt(void);
 extern void cpu_init(void);
 
 extern int force_mwait;
Index: linux/include/asm-i386/segment.h
===================================================================
--- linux.orig/include/asm-i386/segment.h
+++ linux/include/asm-i386/segment.h
@@ -75,7 +75,11 @@
 #define __ESPFIX_SS (GDT_ENTRY_ESPFIX_SS * 8)
 
 #define GDT_ENTRY_PERCPU			(GDT_ENTRY_KERNEL_BASE + 15)
+#ifdef CONFIG_SMP
 #define __KERNEL_PERCPU (GDT_ENTRY_PERCPU * 8)
+#else
+#define __KERNEL_PERCPU 0
+#endif
 
 #define GDT_ENTRY_DOUBLEFAULT_TSS	31
 
