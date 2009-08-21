Return-Path: <linux-kernel-owner+w=401wt.eu-S932997AbZHUVcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932997AbZHUVcn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 17:32:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932990AbZHUVcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 17:32:42 -0400
Received: from www.tglx.de ([62.245.132.106]:51808 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932966AbZHUVcj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 17:32:39 -0400
Message-Id: <20090821205602.731684676@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 21 Aug 2009 21:31:05 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: x86 team <x86@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>, Avi Kivity <avi@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alok N Kataria <akataria@vmware.com>,
       Pan Jacob jun <jacob.jun.pan@intel.com>
Subject: [RFC patch 19/32] x86: Move xen_post_allocator_init into
	xen_pagetable_setup_done
References: <20090821205008.518392436@linutronix.de>
Content-Disposition: inline;
	filename=x86-move-post-allocator-init-to-page-table-setup-done.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We really do not need two paravirt/platform setup functions which are
called in two consecutive source lines. Move the only user of
post_allocator_init into the already existing pagetable_setup_done
function.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/paravirt.h |    9 ---------
 arch/x86/include/asm/setup.h    |    4 ----
 arch/x86/kernel/setup.c         |    1 -
 arch/x86/xen/enlighten.c        |    2 --
 arch/x86/xen/mmu.c              |    5 ++++-
 arch/x86/xen/xen-ops.h          |    2 --
 6 files changed, 4 insertions(+), 19 deletions(-)

Index: linux-2.6/arch/x86/include/asm/paravirt.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/paravirt.h
+++ linux-2.6/arch/x86/include/asm/paravirt.h
@@ -86,9 +86,6 @@ struct pv_init_ops {
 	unsigned (*patch)(u8 type, u16 clobber, void *insnbuf,
 			  unsigned long addr, unsigned len);
 
-	/* Basic arch-specific setup */
-	void (*post_allocator_init)(void);
-
 	/* Print a banner to identify the environment */
 	void (*banner)(void);
 };
@@ -1010,12 +1007,6 @@ static inline void setup_secondary_clock
 }
 #endif
 
-static inline void paravirt_post_allocator_init(void)
-{
-	if (pv_init_ops.post_allocator_init)
-		(*pv_init_ops.post_allocator_init)();
-}
-
 #ifdef CONFIG_SMP
 static inline void startup_ipi_hook(int phys_apicid, unsigned long start_eip,
 				    unsigned long start_esp)
Index: linux-2.6/arch/x86/include/asm/setup.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/setup.h
+++ linux-2.6/arch/x86/include/asm/setup.h
@@ -63,10 +63,6 @@ static inline int is_visws_box(void) { r
 extern struct x86_quirks *x86_quirks;
 extern unsigned long saved_video_mode;
 
-#ifndef CONFIG_PARAVIRT
-#define paravirt_post_allocator_init()	do {} while (0)
-#endif
-
 extern void reserve_standard_io_resources(void);
 extern void i386_reserve_resources(void);
 
Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -962,7 +962,6 @@ void __init setup_arch(char **cmdline_p)
 	platform_setup.paging.pagetable_setup_start(swapper_pg_dir);
 	paging_init();
 	platform_setup.paging.pagetable_setup_done(swapper_pg_dir);
-	paravirt_post_allocator_init();
 
 #ifdef CONFIG_X86_64
 	map_vsyscall();
Index: linux-2.6/arch/x86/xen/enlighten.c
===================================================================
--- linux-2.6.orig/arch/x86/xen/enlighten.c
+++ linux-2.6/arch/x86/xen/enlighten.c
@@ -839,8 +839,6 @@ static const struct pv_info xen_info __i
 
 static const struct pv_init_ops xen_init_ops __initdata = {
 	.patch = xen_patch,
-
-	.post_allocator_init = xen_post_allocator_init,
 };
 
 static const struct pv_time_ops xen_time_ops __initdata = {
Index: linux-2.6/arch/x86/xen/mmu.c
===================================================================
--- linux-2.6.orig/arch/x86/xen/mmu.c
+++ linux-2.6/arch/x86/xen/mmu.c
@@ -1229,9 +1229,12 @@ static __init void xen_pagetable_setup_s
 {
 }
 
+static void xen_post_allocator_init(void);
+
 static __init void xen_pagetable_setup_done(pgd_t *base)
 {
 	xen_setup_shared_info();
+	xen_post_allocator_init();
 }
 
 static void xen_write_cr2(unsigned long cr2)
@@ -1841,7 +1844,7 @@ static void xen_set_fixmap(unsigned idx,
 #endif
 }
 
-__init void xen_post_allocator_init(void)
+static __init void xen_post_allocator_init(void)
 {
 	pv_mmu_ops.set_pte = xen_set_pte;
 	pv_mmu_ops.set_pmd = xen_set_pmd;
Index: linux-2.6/arch/x86/xen/xen-ops.h
===================================================================
--- linux-2.6.orig/arch/x86/xen/xen-ops.h
+++ linux-2.6/arch/x86/xen/xen-ops.h
@@ -30,8 +30,6 @@ pgd_t *xen_setup_kernel_pagetable(pgd_t 
 void xen_ident_map_ISA(void);
 void xen_reserve_top(void);
 
-void xen_post_allocator_init(void);
-
 char * __init xen_memory_setup(void);
 void __init xen_arch_setup(void);
 void __init xen_init_IRQ(void);


