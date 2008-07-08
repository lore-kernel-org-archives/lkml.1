Return-Path: <linux-kernel-owner+w=401wt.eu-S1756552AbYGHXPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552AbYGHXPO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 19:15:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755480AbYGHXOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 19:14:38 -0400
Received: from gw.goop.org ([64.81.55.164]:51188 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755035AbYGHXOh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 19:14:37 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 01 of 55] x86/paravirt: Call paravirt_pagetable_setup_{start,
	done}
X-Mercurial-Node: 33a67609b7ad72f2546711278b773694678ec21e
Message-Id: <33a67609b7ad72f25467.1215554783@localhost>
In-Reply-To: <patchbomb.1215554782@localhost>
Date: Tue, 08 Jul 2008 15:06:23 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eduardo Habkost <ehabkost@redhat.com>

Call paravirt_pagetable_setup_{start,done}

These paravirt_ops functions were not being called on x86_64.

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/paravirt.c   |    4 ++++
 arch/x86/kernel/setup.c      |    2 ++
 arch/x86/xen/enlighten.c     |    4 ++++
 include/asm-x86/pgtable.h    |   18 ++++++++++++++++++
 include/asm-x86/pgtable_32.h |   15 ---------------
 5 files changed, 28 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -29,6 +29,7 @@
 #include <asm/desc.h>
 #include <asm/setup.h>
 #include <asm/arch_hooks.h>
+#include <asm/pgtable.h>
 #include <asm/time.h>
 #include <asm/pgalloc.h>
 #include <asm/irq.h>
@@ -373,6 +374,9 @@
 #ifndef CONFIG_X86_64
 	.pagetable_setup_start = native_pagetable_setup_start,
 	.pagetable_setup_done = native_pagetable_setup_done,
+#else
+	.pagetable_setup_start = paravirt_nop,
+	.pagetable_setup_done = paravirt_nop,
 #endif
 
 	.read_cr2 = native_read_cr2,
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -793,7 +793,9 @@
 	vmi_init();
 #endif
 
+	paravirt_pagetable_setup_start(swapper_pg_dir);
 	paging_init();
+	paravirt_pagetable_setup_done(swapper_pg_dir);
 
 #ifdef CONFIG_X86_64
 	map_vsyscall();
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -841,6 +841,7 @@
 
 static __init void xen_pagetable_setup_start(pgd_t *base)
 {
+#ifdef CONFIG_X86_32
 	pgd_t *xen_pgd = (pgd_t *)xen_start_info->pt_base;
 	int i;
 
@@ -886,6 +887,7 @@
 	/* Unpin initial Xen pagetable */
 	pin_pagetable_pfn(MMUEXT_UNPIN_TABLE,
 			  PFN_DOWN(__pa(xen_start_info->pt_base)));
+#endif	/* CONFIG_X86_32 */
 }
 
 void xen_setup_shared_info(void)
@@ -927,9 +929,11 @@
 
 	xen_setup_shared_info();
 
+#ifdef CONFIG_X86_32
 	/* Actually pin the pagetable down, but we can't set PG_pinned
 	   yet because the page structures don't exist yet. */
 	pin_pagetable_pfn(MMUEXT_PIN_L3_TABLE, PFN_DOWN(__pa(base)));
+#endif
 }
 
 static __init void xen_post_allocator_init(void)
diff --git a/include/asm-x86/pgtable.h b/include/asm-x86/pgtable.h
--- a/include/asm-x86/pgtable.h
+++ b/include/asm-x86/pgtable.h
@@ -300,6 +300,14 @@
 /* Install a pte for a particular vaddr in kernel space. */
 void set_pte_vaddr(unsigned long vaddr, pte_t pte);
 
+#ifdef CONFIG_X86_32
+extern void native_pagetable_setup_start(pgd_t *base);
+extern void native_pagetable_setup_done(pgd_t *base);
+#else
+static inline void native_pagetable_setup_start(pgd_t *base) {}
+static inline void native_pagetable_setup_done(pgd_t *base) {}
+#endif
+
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
 #else  /* !CONFIG_PARAVIRT */
@@ -331,6 +339,16 @@
 
 #define pte_update(mm, addr, ptep)              do { } while (0)
 #define pte_update_defer(mm, addr, ptep)        do { } while (0)
+
+static inline void __init paravirt_pagetable_setup_start(pgd_t *base)
+{
+	native_pagetable_setup_start(base);
+}
+
+static inline void __init paravirt_pagetable_setup_done(pgd_t *base)
+{
+	native_pagetable_setup_done(base);
+}
 #endif	/* CONFIG_PARAVIRT */
 
 #endif	/* __ASSEMBLY__ */
diff --git a/include/asm-x86/pgtable_32.h b/include/asm-x86/pgtable_32.h
--- a/include/asm-x86/pgtable_32.h
+++ b/include/asm-x86/pgtable_32.h
@@ -177,21 +177,6 @@
  */
 #define update_mmu_cache(vma, address, pte) do { } while (0)
 
-extern void native_pagetable_setup_start(pgd_t *base);
-extern void native_pagetable_setup_done(pgd_t *base);
-
-#ifndef CONFIG_PARAVIRT
-static inline void __init paravirt_pagetable_setup_start(pgd_t *base)
-{
-	native_pagetable_setup_start(base);
-}
-
-static inline void __init paravirt_pagetable_setup_done(pgd_t *base)
-{
-	native_pagetable_setup_done(base);
-}
-#endif	/* !CONFIG_PARAVIRT */
-
 #endif /* !__ASSEMBLY__ */
 
 /*


