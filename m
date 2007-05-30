Return-Path: <linux-kernel-owner+w=401wt.eu-S1756792AbXE3OEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792AbXE3OEn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 10:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756060AbXE3ODN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 10:03:13 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:46557 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756040AbXE3ODL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 10:03:11 -0400
Message-Id: <20070530140229.491376274@polymtl.ca>
References: <20070530140025.917261793@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 30 May 2007 10:00:33 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 8/9] F00F bug fixup for i386 - use conditional calls
Content-Disposition: inline; filename=f00f-bug-use-cond-calls.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Wed, 30 May 2007 14:02:29 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use the faster conditional calls for F00F bug handling in do_page_fault.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

---
 arch/i386/Kconfig.cpu    |    1 +
 arch/i386/kernel/traps.c |    2 ++
 arch/i386/mm/fault.c     |   35 ++++++++++++++++++++++-------------
 3 files changed, 25 insertions(+), 13 deletions(-)

Index: linux-2.6-lttng/arch/i386/kernel/traps.c
===================================================================
--- linux-2.6-lttng.orig/arch/i386/kernel/traps.c	2007-05-29 11:05:30.000000000 -0400
+++ linux-2.6-lttng/arch/i386/kernel/traps.c	2007-05-29 11:07:07.000000000 -0400
@@ -31,6 +31,7 @@
 #include <linux/uaccess.h>
 #include <linux/nmi.h>
 #include <linux/bug.h>
+#include <linux/condcall.h>
 
 #ifdef CONFIG_EISA
 #include <linux/ioport.h>
@@ -1084,6 +1085,7 @@
 	 */
 	idt_descr.address = fix_to_virt(FIX_F00F_IDT);
 	load_idt(&idt_descr);
+	BUG_ON(cond_call_arm("fix_f00f"));
 }
 #endif
 
Index: linux-2.6-lttng/arch/i386/mm/fault.c
===================================================================
--- linux-2.6-lttng.orig/arch/i386/mm/fault.c	2007-05-29 11:05:48.000000000 -0400
+++ linux-2.6-lttng/arch/i386/mm/fault.c	2007-05-29 11:13:16.000000000 -0400
@@ -25,6 +25,7 @@
 #include <linux/kprobes.h>
 #include <linux/uaccess.h>
 #include <linux/kdebug.h>
+#include <linux/condcall.h>
 
 #include <asm/system.h>
 #include <asm/desc.h>
@@ -221,6 +222,25 @@
 
 fastcall void do_invalid_op(struct pt_regs *, unsigned long);
 
+#ifdef CONFIG_X86_F00F_BUG
+/*
+ * Pentium F0 0F C7 C8 bug workaround.
+ */
+static inline int do_f00f_workaround(struct pt_regs *regs,
+		unsigned long address)
+{
+	unsigned long nr;
+
+	nr = (address - idt_descr.address) >> 3;
+
+	if (nr == 6) {
+		do_invalid_op(regs, 0);
+		return 1;
+	}
+	return 0;
+}
+#endif
+
 static inline pmd_t *vmalloc_sync_one(pgd_t *pgd, unsigned long address)
 {
 	unsigned index = pgd_index(address);
@@ -474,19 +494,8 @@
 	}
 
 #ifdef CONFIG_X86_F00F_BUG
-	/*
-	 * Pentium F0 0F C7 C8 bug workaround.
-	 */
-	if (boot_cpu_data.f00f_bug) {
-		unsigned long nr;
-		
-		nr = (address - idt_descr.address) >> 3;
-
-		if (nr == 6) {
-			do_invalid_op(regs, 0);
-			return;
-		}
-	}
+	if (cond_call(fix_f00f, do_f00f_workaround(regs, address)))
+		return;
 #endif
 
 no_context:
Index: linux-2.6-lttng/arch/i386/Kconfig.cpu
===================================================================
--- linux-2.6-lttng.orig/arch/i386/Kconfig.cpu	2007-05-29 11:51:46.000000000 -0400
+++ linux-2.6-lttng/arch/i386/Kconfig.cpu	2007-05-29 11:52:08.000000000 -0400
@@ -275,6 +275,7 @@
 config X86_F00F_BUG
 	bool
 	depends on M586MMX || M586TSC || M586 || M486 || M386
+	select COND_CALL
 	default y
 
 config X86_WP_WORKS_OK

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
