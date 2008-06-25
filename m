Return-Path: <linux-kernel-owner+w=401wt.eu-S1756771AbYFYEhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771AbYFYEhv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 00:37:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752667AbYFYEhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 00:37:06 -0400
Received: from 9.sub-70-198-159.myvzw.com ([70.198.159.9]:37420 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752526AbYFYEhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 00:37:04 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 16 of 36] x86/paravirt: add a pgd_alloc/free hooks
X-Mercurial-Node: e7d48c92678300c08791d9e6f4d771be1e19de96
Message-Id: <e7d48c92678300c08791.1214367552@localhost>
In-Reply-To: <patchbomb.1214367536@localhost>
Date: Wed, 25 Jun 2008 00:19:12 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add hooks which are called at pgd_alloc/free time.  The pgd_alloc hook
may return an error code, which if non-zero, causes the pgd allocation
to be failed.  The hooks may be used to allocate/free auxillary
per-pgd information.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/paravirt.c |    4 ++++
 arch/x86/mm/pgtable.c      |   13 ++++++++-----
 arch/x86/xen/enlighten.c   |    4 ++++
 include/asm-x86/paravirt.h |   19 ++++++++++++++++++-
 include/asm-x86/pgalloc.h  |    4 ++++
 5 files changed, 38 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -30,6 +30,7 @@
 #include <asm/setup.h>
 #include <asm/arch_hooks.h>
 #include <asm/time.h>
+#include <asm/pgalloc.h>
 #include <asm/irq.h>
 #include <asm/delay.h>
 #include <asm/fixmap.h>
@@ -369,6 +370,9 @@
 	.flush_tlb_single = native_flush_tlb_single,
 	.flush_tlb_others = native_flush_tlb_others,
 
+	.pgd_alloc = __paravirt_pgd_alloc,
+	.pgd_free = paravirt_nop,
+
 	.alloc_pte = paravirt_nop,
 	.alloc_pmd = paravirt_nop,
 	.alloc_pmd_clone = paravirt_nop,
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -215,13 +215,15 @@
 
 	/* so that alloc_pmd can use it */
 	mm->pgd = pgd;
-	if (pgd)
+	if (pgd) {
 		pgd_ctor(pgd);
 
-	if (pgd && !pgd_prepopulate_pmd(mm, pgd)) {
-		pgd_dtor(pgd);
-		free_page((unsigned long)pgd);
-		pgd = NULL;
+		if (paravirt_pgd_alloc(mm) != 0 ||
+		    !pgd_prepopulate_pmd(mm, pgd)) {
+			pgd_dtor(pgd);
+			free_page((unsigned long)pgd);
+			pgd = NULL;
+		}
 	}
 
 	return pgd;
@@ -231,6 +233,7 @@
 {
 	pgd_mop_up_pmds(mm, pgd);
 	pgd_dtor(pgd);
+	paravirt_pgd_free(mm, pgd);
 	free_page((unsigned long)pgd);
 }
 
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -45,6 +45,7 @@
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 #include <asm/reboot.h>
+#include <asm/pgalloc.h>
 
 #include "xen-ops.h"
 #include "mmu.h"
@@ -1151,6 +1152,9 @@
 	.pte_update = paravirt_nop,
 	.pte_update_defer = paravirt_nop,
 
+	.pgd_alloc = __paravirt_pgd_alloc,
+	.pgd_free = paravirt_nop,
+
 	.alloc_pte = xen_alloc_pte_init,
 	.release_pte = xen_release_pte_init,
 	.alloc_pmd = xen_alloc_pte_init,
diff --git a/include/asm-x86/paravirt.h b/include/asm-x86/paravirt.h
--- a/include/asm-x86/paravirt.h
+++ b/include/asm-x86/paravirt.h
@@ -220,7 +220,14 @@
 	void (*flush_tlb_others)(const cpumask_t *cpus, struct mm_struct *mm,
 				 unsigned long va);
 
-	/* Hooks for allocating/releasing pagetable pages */
+	/* Hooks for allocating and freeing a pagetable top-level */
+	int  (*pgd_alloc)(struct mm_struct *mm);
+	void (*pgd_free)(struct mm_struct *mm, pgd_t *pgd);
+
+	/*
+	 * Hooks for allocating/releasing pagetable pages when they're
+	 * attached to a pagetable
+	 */
 	void (*alloc_pte)(struct mm_struct *mm, u32 pfn);
 	void (*alloc_pmd)(struct mm_struct *mm, u32 pfn);
 	void (*alloc_pmd_clone)(u32 pfn, u32 clonepfn, u32 start, u32 count);
@@ -926,6 +933,16 @@
 	PVOP_VCALL3(pv_mmu_ops.flush_tlb_others, &cpumask, mm, va);
 }
 
+static inline int paravirt_pgd_alloc(struct mm_struct *mm)
+{
+	return PVOP_CALL1(int, pv_mmu_ops.pgd_alloc, mm);
+}
+
+static inline void paravirt_pgd_free(struct mm_struct *mm, pgd_t *pgd)
+{
+	PVOP_VCALL2(pv_mmu_ops.pgd_free, mm, pgd);
+}
+
 static inline void paravirt_alloc_pte(struct mm_struct *mm, unsigned pfn)
 {
 	PVOP_VCALL2(pv_mmu_ops.alloc_pte, mm, pfn);
diff --git a/include/asm-x86/pgalloc.h b/include/asm-x86/pgalloc.h
--- a/include/asm-x86/pgalloc.h
+++ b/include/asm-x86/pgalloc.h
@@ -5,9 +5,13 @@
 #include <linux/mm.h>		/* for struct page */
 #include <linux/pagemap.h>
 
+static inline int  __paravirt_pgd_alloc(struct mm_struct *mm) { return 0; }
+
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
 #else
+#define paravirt_pgd_alloc(mm)	__paravirt_pgd_alloc(mm)
+static inline void paravirt_pgd_free(struct mm_struct *mm, pgd_t *) {}
 static inline void paravirt_alloc_pte(struct mm_struct *mm, unsigned long pfn)	{}
 static inline void paravirt_alloc_pmd(struct mm_struct *mm, unsigned long pfn)	{}
 static inline void paravirt_alloc_pmd_clone(unsigned long pfn, unsigned long clonepfn,


