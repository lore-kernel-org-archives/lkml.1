Return-Path: <linux-kernel-owner+w=401wt.eu-S933015AbZHUVdI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933015AbZHUVdI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 17:33:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932934AbZHUVce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 17:32:34 -0400
Received: from www.tglx.de ([62.245.132.106]:51779 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932952AbZHUVcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 17:32:31 -0400
Message-Id: <20090821205602.678425431@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 21 Aug 2009 21:30:57 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: x86 team <x86@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>, Avi Kivity <avi@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alok N Kataria <akataria@vmware.com>,
       Pan Jacob jun <jacob.jun.pan@intel.com>
Subject: [RFC patch 18/32] x86: Move paravirt pagetable_setup to platform
References: <20090821205008.518392436@linutronix.de>
Content-Disposition: inline;
	filename=x86-move-pagetable-setup-start-done-to-platform.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace more paravirt hackery by proper platform setup.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/paravirt.h      |   19 -------------------
 arch/x86/include/asm/pgtable.h       |   10 ----------
 arch/x86/include/asm/pgtable_types.h |    4 ++--
 arch/x86/include/asm/platform.h      |   13 +++++++++++++
 arch/x86/kernel/paravirt.c           |    7 -------
 arch/x86/kernel/platform_setup.c     |    6 ++++++
 arch/x86/kernel/setup.c              |    4 ++--
 arch/x86/xen/enlighten.c             |    2 +-
 arch/x86/xen/mmu.c                   |   11 +++++++----
 arch/x86/xen/mmu.h                   |    2 +-
 10 files changed, 32 insertions(+), 46 deletions(-)

Index: linux-2.6/arch/x86/include/asm/paravirt.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/paravirt.h
+++ linux-2.6/arch/x86/include/asm/paravirt.h
@@ -241,15 +241,6 @@ struct pv_apic_ops {
 };
 
 struct pv_mmu_ops {
-	/*
-	 * Called before/after init_mm pagetable setup. setup_start
-	 * may reset %cr3, and may pre-install parts of the pagetable;
-	 * pagetable setup is expected to preserve any existing
-	 * mapping.
-	 */
-	void (*pagetable_setup_start)(pgd_t *pgd_base);
-	void (*pagetable_setup_done)(pgd_t *pgd_base);
-
 	unsigned long (*read_cr2)(void);
 	void (*write_cr2)(unsigned long);
 
@@ -1025,16 +1016,6 @@ static inline void paravirt_post_allocat
 		(*pv_init_ops.post_allocator_init)();
 }
 
-static inline void paravirt_pagetable_setup_start(pgd_t *base)
-{
-	(*pv_mmu_ops.pagetable_setup_start)(base);
-}
-
-static inline void paravirt_pagetable_setup_done(pgd_t *base)
-{
-	(*pv_mmu_ops.pagetable_setup_done)(base);
-}
-
 #ifdef CONFIG_SMP
 static inline void startup_ipi_hook(int phys_apicid, unsigned long start_eip,
 				    unsigned long start_esp)
Index: linux-2.6/arch/x86/include/asm/pgtable.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/pgtable.h
+++ linux-2.6/arch/x86/include/asm/pgtable.h
@@ -55,16 +55,6 @@ extern struct list_head pgd_list;
 #define pte_update(mm, addr, ptep)              do { } while (0)
 #define pte_update_defer(mm, addr, ptep)        do { } while (0)
 
-static inline void __init paravirt_pagetable_setup_start(pgd_t *base)
-{
-	native_pagetable_setup_start(base);
-}
-
-static inline void __init paravirt_pagetable_setup_done(pgd_t *base)
-{
-	native_pagetable_setup_done(base);
-}
-
 #define pgd_val(x)	native_pgd_val(x)
 #define __pgd(x)	native_make_pgd(x)
 
Index: linux-2.6/arch/x86/include/asm/pgtable_types.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/pgtable_types.h
+++ linux-2.6/arch/x86/include/asm/pgtable_types.h
@@ -299,8 +299,8 @@ void set_pte_vaddr(unsigned long vaddr, 
 extern void native_pagetable_setup_start(pgd_t *base);
 extern void native_pagetable_setup_done(pgd_t *base);
 #else
-static inline void native_pagetable_setup_start(pgd_t *base) {}
-static inline void native_pagetable_setup_done(pgd_t *base) {}
+#define native_pagetable_setup_start platform_setup_pgd_noop
+#define native_pagetable_setup_done  platform_setup_pgd_noop
 #endif
 
 struct seq_file;
Index: linux-2.6/arch/x86/include/asm/platform.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/platform.h
+++ linux-2.6/arch/x86/include/asm/platform.h
@@ -1,6 +1,8 @@
 #ifndef _ASM_X86_PLATFORM_H
 #define _ASM_X86_PLATFORM_H
 
+#include <asm/pgtable_types.h>
+
 struct mpc_bus;
 struct mpc_cpu;
 struct mpc_table;
@@ -73,6 +75,16 @@ struct platform_setup_oem {
 };
 
 /**
+ * struct platform_setup_paging - platform specific paging functions
+ * @pagetable_setup_start:	platform specific pre paging_init() call
+ * @pagetable_setup_done:	platform specific post paging_init() call
+ */
+struct platform_setup_paging {
+	void (*pagetable_setup_start)(pgd_t *base);
+	void (*pagetable_setup_done)(pgd_t *base);
+};
+
+/**
  * struct platform_setup_ops - functions for platform specific setup
  *
  */
@@ -81,6 +93,7 @@ struct platform_setup_ops {
 	struct platform_setup_mpparse mpparse;
 	struct platform_setup_irqs irqs;
 	struct platform_setup_oem oem;
+	struct platform_setup_paging paging;
 	struct platform_setup_quirks quirks;
 };
 
Index: linux-2.6/arch/x86/kernel/paravirt.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/paravirt.c
+++ linux-2.6/arch/x86/kernel/paravirt.c
@@ -402,13 +402,6 @@ struct pv_apic_ops pv_apic_ops = {
 #endif
 
 struct pv_mmu_ops pv_mmu_ops = {
-#ifndef CONFIG_X86_64
-	.pagetable_setup_start = native_pagetable_setup_start,
-	.pagetable_setup_done = native_pagetable_setup_done,
-#else
-	.pagetable_setup_start = paravirt_nop,
-	.pagetable_setup_done = paravirt_nop,
-#endif
 
 	.read_cr2 = native_read_cr2,
 	.write_cr2 = native_write_cr2,
Index: linux-2.6/arch/x86/kernel/platform_setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/platform_setup.c
+++ linux-2.6/arch/x86/kernel/platform_setup.c
@@ -13,6 +13,7 @@
 
 void __cpuinit platform_setup_noop(void) { }
 void __init platform_setup_uint_noop(unsigned int unused) { }
+void __init platform_setup_pgd_noop(pgd_t *unused) { }
 
 /*
  * The platform setup functions are preset with the default functions
@@ -47,6 +48,11 @@ struct __initdata platform_setup_ops pla
 		.banner = default_banner,
 	},
 
+	.paging = {
+		.pagetable_setup_start = native_pagetable_setup_start,
+		.pagetable_setup_done = native_pagetable_setup_done,
+	},
+
 	.quirks = {
 		.mpc_record = platform_setup_uint_noop,
 	},
Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -959,9 +959,9 @@ void __init setup_arch(char **cmdline_p)
 	kvmclock_init();
 #endif
 
-	paravirt_pagetable_setup_start(swapper_pg_dir);
+	platform_setup.paging.pagetable_setup_start(swapper_pg_dir);
 	paging_init();
-	paravirt_pagetable_setup_done(swapper_pg_dir);
+	platform_setup.paging.pagetable_setup_done(swapper_pg_dir);
 	paravirt_post_allocator_init();
 
 #ifdef CONFIG_X86_64
Index: linux-2.6/arch/x86/xen/enlighten.c
===================================================================
--- linux-2.6.orig/arch/x86/xen/enlighten.c
+++ linux-2.6/arch/x86/xen/enlighten.c
@@ -981,12 +981,12 @@ asmlinkage void __init xen_start_kernel(
 	pv_time_ops = xen_time_ops;
 	pv_cpu_ops = xen_cpu_ops;
 	pv_apic_ops = xen_apic_ops;
-	pv_mmu_ops = xen_mmu_ops;
 
 	platform_setup.resources.memory_setup = xen_memory_setup;
 	platform_setup.oem.arch_setup = xen_arch_setup;
 	platform_setup.oem.banner = xen_banner;
 
+	xen_init_mmu_ops();
 	xen_init_irq_ops();
 
 	xen_init_cpuid_mask();
Index: linux-2.6/arch/x86/xen/mmu.c
===================================================================
--- linux-2.6.orig/arch/x86/xen/mmu.c
+++ linux-2.6/arch/x86/xen/mmu.c
@@ -1875,10 +1875,7 @@ static void xen_leave_lazy_mmu(void)
 	preempt_enable();
 }
 
-const struct pv_mmu_ops xen_mmu_ops __initdata = {
-	.pagetable_setup_start = xen_pagetable_setup_start,
-	.pagetable_setup_done = xen_pagetable_setup_done,
-
+static const struct pv_mmu_ops xen_mmu_ops __initdata = {
 	.read_cr2 = xen_read_cr2,
 	.write_cr2 = xen_write_cr2,
 
@@ -1954,6 +1951,12 @@ const struct pv_mmu_ops xen_mmu_ops __in
 	.set_fixmap = xen_set_fixmap,
 };
 
+void __init xen_init_mmu_ops(void)
+{
+	platform_setup.paging.pagetable_setup_start = xen_pagetable_setup_start;
+	platform_setup.paging.pagetable_setup_done = xen_pagetable_setup_done;
+	pv_mmu_ops = xen_mmu_ops;
+}
 
 #ifdef CONFIG_XEN_DEBUG_FS
 
Index: linux-2.6/arch/x86/xen/mmu.h
===================================================================
--- linux-2.6.orig/arch/x86/xen/mmu.h
+++ linux-2.6/arch/x86/xen/mmu.h
@@ -59,5 +59,5 @@ void  xen_ptep_modify_prot_commit(struct
 
 unsigned long xen_read_cr2_direct(void);
 
-extern const struct pv_mmu_ops xen_mmu_ops;
+extern void xen_init_mmu_ops(void);
 #endif	/* _XEN_MMU_H */


