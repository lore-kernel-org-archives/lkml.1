Return-Path: <linux-kernel-owner+w=401wt.eu-S938086AbXG3FOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938086AbXG3FOl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 01:14:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756505AbXG3FOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 01:14:34 -0400
Received: from rex.snapgear.com ([203.143.235.140]:45452 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753701AbXG3FOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 01:14:33 -0400
Date: Mon, 30 Jul 2007 15:13:52 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200707300513.l6U5DqSw023959@goober>
To: linux-kernel@vger.kernel.org
Subject: changing include/asm-generic/pgtable.h for non-mmu
Cc: gerg@uclinux.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi All,

There are some parts of include/asm-generic/pgtable.h that are
relevant to the non-mmu architectures. To make it easier to include
this from them I would like to ifdef the relevant parts.
Does anyone object to something like the patch below?

Without this there is a handful of functions that are referenced
in here that are not defined on many non-mmu architectures. They
could be defined out ofcourse, as an alternative approach.

Regards
Greg




diff -Naur linux-2.6.23-rc1-git2/include/asm-generic/pgtable.h linux/include/asm-generic/pgtable.h
--- linux-2.6.23-rc1-git2/include/asm-generic/pgtable.h	2007-07-26 10:38:56.000000000 +1000
+++ linux/include/asm-generic/pgtable.h	2007-07-30 15:02:40.000000000 +1000
@@ -2,6 +2,7 @@
 #define _ASM_GENERIC_PGTABLE_H
 
 #ifndef __ASSEMBLY__
+#ifdef CONFIG_MMU
 
 #ifndef __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
 /*
@@ -133,41 +134,6 @@
 #endif
 
 /*
- * A facility to provide lazy MMU batching.  This allows PTE updates and
- * page invalidations to be delayed until a call to leave lazy MMU mode
- * is issued.  Some architectures may benefit from doing this, and it is
- * beneficial for both shadow and direct mode hypervisors, which may batch
- * the PTE updates which happen during this window.  Note that using this
- * interface requires that read hazards be removed from the code.  A read
- * hazard could result in the direct mode hypervisor case, since the actual
- * write to the page tables may not yet have taken place, so reads though
- * a raw PTE pointer after it has been modified are not guaranteed to be
- * up to date.  This mode can only be entered and left under the protection of
- * the page table locks for all page tables which may be modified.  In the UP
- * case, this is required so that preemption is disabled, and in the SMP case,
- * it must synchronize the delayed page table writes properly on other CPUs.
- */
-#ifndef __HAVE_ARCH_ENTER_LAZY_MMU_MODE
-#define arch_enter_lazy_mmu_mode()	do {} while (0)
-#define arch_leave_lazy_mmu_mode()	do {} while (0)
-#define arch_flush_lazy_mmu_mode()	do {} while (0)
-#endif
-
-/*
- * A facility to provide batching of the reload of page tables with the
- * actual context switch code for paravirtualized guests.  By convention,
- * only one of the lazy modes (CPU, MMU) should be active at any given
- * time, entry should never be nested, and entry and exits should always
- * be paired.  This is for sanity of maintaining and reasoning about the
- * kernel code.
- */
-#ifndef __HAVE_ARCH_ENTER_LAZY_CPU_MODE
-#define arch_enter_lazy_cpu_mode()	do {} while (0)
-#define arch_leave_lazy_cpu_mode()	do {} while (0)
-#define arch_flush_lazy_cpu_mode()	do {} while (0)
-#endif
-
-/*
  * When walking page tables, get the address of the next boundary,
  * or the end address of the range if that comes earlier.  Although no
  * vma end wraps to 0, rounded up __boundary may wrap to 0 throughout.
@@ -233,6 +199,43 @@
 	}
 	return 0;
 }
+#endif /* CONFIG_MMU */
+
+/*
+ * A facility to provide lazy MMU batching.  This allows PTE updates and
+ * page invalidations to be delayed until a call to leave lazy MMU mode
+ * is issued.  Some architectures may benefit from doing this, and it is
+ * beneficial for both shadow and direct mode hypervisors, which may batch
+ * the PTE updates which happen during this window.  Note that using this
+ * interface requires that read hazards be removed from the code.  A read
+ * hazard could result in the direct mode hypervisor case, since the actual
+ * write to the page tables may not yet have taken place, so reads though
+ * a raw PTE pointer after it has been modified are not guaranteed to be
+ * up to date.  This mode can only be entered and left under the protection of
+ * the page table locks for all page tables which may be modified.  In the UP
+ * case, this is required so that preemption is disabled, and in the SMP case,
+ * it must synchronize the delayed page table writes properly on other CPUs.
+ */
+#ifndef __HAVE_ARCH_ENTER_LAZY_MMU_MODE
+#define arch_enter_lazy_mmu_mode()	do {} while (0)
+#define arch_leave_lazy_mmu_mode()	do {} while (0)
+#define arch_flush_lazy_mmu_mode()	do {} while (0)
+#endif
+
+/*
+ * A facility to provide batching of the reload of page tables with the
+ * actual context switch code for paravirtualized guests.  By convention,
+ * only one of the lazy modes (CPU, MMU) should be active at any given
+ * time, entry should never be nested, and entry and exits should always
+ * be paired.  This is for sanity of maintaining and reasoning about the
+ * kernel code.
+ */
+#ifndef __HAVE_ARCH_ENTER_LAZY_CPU_MODE
+#define arch_enter_lazy_cpu_mode()	do {} while (0)
+#define arch_leave_lazy_cpu_mode()	do {} while (0)
+#define arch_flush_lazy_cpu_mode()	do {} while (0)
+#endif
+
 #endif /* !__ASSEMBLY__ */
 
 #endif /* _ASM_GENERIC_PGTABLE_H */
