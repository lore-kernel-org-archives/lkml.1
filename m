Return-Path: <linux-kernel-owner+w=401wt.eu-S1759077AbXGCRI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759077AbXGCRI6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 13:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755514AbXGCRIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 13:08:37 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:51978 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754913AbXGCRIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 13:08:36 -0400
Message-Id: <20070703164516.075810998@polymtl.ca>
References: <20070703164046.645090494@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 03 Jul 2007 12:40:55 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 09/10] F00F bug fixup for i386 - use immediate values
Content-Disposition: inline; filename=f00f-bug-use-immediate-values.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue,  3 Jul 2007 17:08:32 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use the faster immediate values for F00F bug handling in do_page_fault.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 arch/i386/kernel/traps.c     |    4 ++++
 arch/i386/mm/fault.c         |    3 ++-
 include/asm-i386/processor.h |    3 +++
 3 files changed, 9 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng/arch/i386/kernel/traps.c
===================================================================
--- linux-2.6-lttng.orig/arch/i386/kernel/traps.c	2007-06-15 16:13:50.000000000 -0400
+++ linux-2.6-lttng/arch/i386/kernel/traps.c	2007-06-15 16:14:06.000000000 -0400
@@ -31,6 +31,7 @@
 #include <linux/uaccess.h>
 #include <linux/nmi.h>
 #include <linux/bug.h>
+#include <linux/immediate.h>
 
 #ifdef CONFIG_EISA
 #include <linux/ioport.h>
@@ -1149,6 +1150,8 @@
 #endif /* CONFIG_MATH_EMULATION */
 
 #ifdef CONFIG_X86_F00F_BUG
+immediate_t __read_mostly f00f_bug_fix;
+
 void __init trap_init_f00f_bug(void)
 {
 	__set_fixmap(FIX_F00F_IDT, __pa(&idt_table), PAGE_KERNEL_RO);
@@ -1159,6 +1162,7 @@
 	 */
 	idt_descr.address = fix_to_virt(FIX_F00F_IDT);
 	load_idt(&idt_descr);
+	immediate_arm(&f00f_bug_fix);
 }
 #endif
 
Index: linux-2.6-lttng/arch/i386/mm/fault.c
===================================================================
--- linux-2.6-lttng.orig/arch/i386/mm/fault.c	2007-06-15 16:13:51.000000000 -0400
+++ linux-2.6-lttng/arch/i386/mm/fault.c	2007-06-15 16:14:06.000000000 -0400
@@ -25,6 +25,7 @@
 #include <linux/kprobes.h>
 #include <linux/uaccess.h>
 #include <linux/kdebug.h>
+#include <linux/immediate.h>
 
 #include <asm/system.h>
 #include <asm/desc.h>
@@ -477,7 +478,7 @@
 	/*
 	 * Pentium F0 0F C7 C8 bug workaround.
 	 */
-	if (boot_cpu_data.f00f_bug) {
+	if (unlikely(immediate(f00f_bug_fix))) {
 		unsigned long nr;
 		
 		nr = (address - idt_descr.address) >> 3;
Index: linux-2.6-lttng/include/asm-i386/processor.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-i386/processor.h	2007-06-15 16:13:51.000000000 -0400
+++ linux-2.6-lttng/include/asm-i386/processor.h	2007-06-15 16:14:06.000000000 -0400
@@ -21,6 +21,7 @@
 #include <asm/percpu.h>
 #include <linux/cpumask.h>
 #include <linux/init.h>
+#include <linux/immediate.h>
 #include <asm/processor-flags.h>
 
 /* flag for disabling the tsc */
@@ -102,6 +103,8 @@
 extern struct tss_struct doublefault_tss;
 DECLARE_PER_CPU(struct tss_struct, init_tss);
 
+extern immediate_t __read_mostly f00f_bug_fix;
+
 #ifdef CONFIG_SMP
 extern struct cpuinfo_x86 cpu_data[];
 #define current_cpu_data cpu_data[smp_processor_id()]

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
