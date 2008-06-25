Return-Path: <linux-kernel-owner+w=401wt.eu-S1758013AbYFYEiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013AbYFYEiu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 00:38:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753226AbYFYEhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 00:37:11 -0400
Received: from 9.sub-70-198-159.myvzw.com ([70.198.159.9]:37427 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752589AbYFYEhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 00:37:06 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 17 of 36] x86: preallocate and prepopulate separately
X-Mercurial-Node: 70d47cd6a5c05cd4cd6f9e2adfaea61344538f8c
Message-Id: <70d47cd6a5c05cd4cd6f.1214367553@localhost>
In-Reply-To: <patchbomb.1214367536@localhost>
Date: Wed, 25 Jun 2008 00:19:13 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich points out that vmalloc_sync_all() assumes that the
kernel's pmd is always expected to be present in the pgd.  The current
pgd construction code will add the pgd to the pgd_list before its pmds
have been pre-populated, thereby making it visible to
vmalloc_sync_all().

However, because pgd_prepopulate_pmd also does the allocation, it may
block and cannot be done under spinlock.

The solution is to preallocate the pmds out of the spinlock, then
populate them while holding the pgd_list lock.

This patch also pulls the pmd preallocation and mop-up functions out
to be common, assuming that the compiler will generate no code for
them when PREALLOCTED_PMDS is 0.  Also, there's no need for pgd_ctor
to clear the pgd again, since it's allocated as a zeroed page.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Jan Beulich <jbeulich@novell.com>
---
 arch/x86/mm/pgtable.c |  177 +++++++++++++++++++++++++++++--------------------
 1 file changed, 105 insertions(+), 72 deletions(-)

diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -66,12 +66,6 @@
 static void pgd_ctor(void *p)
 {
 	pgd_t *pgd = p;
-	unsigned long flags;
-
-	/* Clear usermode parts of PGD */
-	memset(pgd, 0, KERNEL_PGD_BOUNDARY*sizeof(pgd_t));
-
-	spin_lock_irqsave(&pgd_lock, flags);
 
 	/* If the pgd points to a shared pagetable level (either the
 	   ptes in non-PAE, or shared PMD in PAE), then just copy the
@@ -91,8 +85,6 @@
 	/* list required to sync kernel mapping updates */
 	if (!SHARED_KERNEL_PMD)
 		pgd_list_add(pgd);
-
-	spin_unlock_irqrestore(&pgd_lock, flags);
 }
 
 static void pgd_dtor(void *pgd)
@@ -120,30 +112,6 @@
 
 #ifdef CONFIG_X86_PAE
 /*
- * Mop up any pmd pages which may still be attached to the pgd.
- * Normally they will be freed by munmap/exit_mmap, but any pmd we
- * preallocate which never got a corresponding vma will need to be
- * freed manually.
- */
-static void pgd_mop_up_pmds(struct mm_struct *mm, pgd_t *pgdp)
-{
-	int i;
-
-	for(i = 0; i < UNSHARED_PTRS_PER_PGD; i++) {
-		pgd_t pgd = pgdp[i];
-
-		if (pgd_val(pgd) != 0) {
-			pmd_t *pmd = (pmd_t *)pgd_page_vaddr(pgd);
-
-			pgdp[i] = native_make_pgd(0);
-
-			paravirt_release_pmd(pgd_val(pgd) >> PAGE_SHIFT);
-			pmd_free(mm, pmd);
-		}
-	}
-}
-
-/*
  * In PAE mode, we need to do a cr3 reload (=tlb flush) when
  * updating the top-level pagetable entries to guarantee the
  * processor notices the update.  Since this is expensive, and
@@ -154,31 +122,7 @@
  * not shared between pagetables (!SHARED_KERNEL_PMDS), we allocate
  * and initialize the kernel pmds here.
  */
-static int pgd_prepopulate_pmd(struct mm_struct *mm, pgd_t *pgd)
-{
-	pud_t *pud;
-	unsigned long addr;
-	int i;
-
-	pud = pud_offset(pgd, 0);
- 	for (addr = i = 0; i < UNSHARED_PTRS_PER_PGD;
-	     i++, pud++, addr += PUD_SIZE) {
-		pmd_t *pmd = pmd_alloc_one(mm, addr);
-
-		if (!pmd) {
-			pgd_mop_up_pmds(mm, pgd);
-			return 0;
-		}
-
-		if (i >= KERNEL_PGD_BOUNDARY)
-			memcpy(pmd, (pmd_t *)pgd_page_vaddr(swapper_pg_dir[i]),
-			       sizeof(pmd_t) * PTRS_PER_PMD);
-
-		pud_populate(mm, pud, pmd);
-	}
-
-	return 1;
-}
+#define PREALLOCATED_PMDS	UNSHARED_PTRS_PER_PGD
 
 void pud_populate(struct mm_struct *mm, pud_t *pudp, pmd_t *pmd)
 {
@@ -198,35 +142,124 @@
 		write_cr3(read_cr3());
 }
 #else  /* !CONFIG_X86_PAE */
+
 /* No need to prepopulate any pagetable entries in non-PAE modes. */
-static int pgd_prepopulate_pmd(struct mm_struct *mm, pgd_t *pgd)
+#define PREALLOCATED_PMDS	0
+
+#endif	/* CONFIG_X86_PAE */
+
+static void free_pmds(pmd_t *pmds[])
 {
-	return 1;
+	int i;
+
+	for(i = 0; i < PREALLOCATED_PMDS; i++)
+		if (pmds[i])
+			free_page((unsigned long)pmds[i]);
 }
 
-static void pgd_mop_up_pmds(struct mm_struct *mm, pgd_t *pgd)
+static int preallocate_pmds(pmd_t *pmds[])
 {
+	int i;
+	bool failed = false;
+
+	for(i = 0; i < PREALLOCATED_PMDS; i++) {
+		pmd_t *pmd = (pmd_t *)get_zeroed_page(GFP_KERNEL|__GFP_REPEAT);
+		if (pmd == NULL)
+			failed = true;
+		pmds[i] = pmd;
+	}
+
+	if (failed) {
+		free_pmds(pmds);
+		return -ENOMEM;
+	}
+
+	return 0;
 }
-#endif	/* CONFIG_X86_PAE */
+
+/*
+ * Mop up any pmd pages which may still be attached to the pgd.
+ * Normally they will be freed by munmap/exit_mmap, but any pmd we
+ * preallocate which never got a corresponding vma will need to be
+ * freed manually.
+ */
+static void pgd_mop_up_pmds(struct mm_struct *mm, pgd_t *pgdp)
+{
+	int i;
+
+	for(i = 0; i < PREALLOCATED_PMDS; i++) {
+		pgd_t pgd = pgdp[i];
+
+		if (pgd_val(pgd) != 0) {
+			pmd_t *pmd = (pmd_t *)pgd_page_vaddr(pgd);
+
+			pgdp[i] = native_make_pgd(0);
+
+			paravirt_release_pmd(pgd_val(pgd) >> PAGE_SHIFT);
+			pmd_free(mm, pmd);
+		}
+	}
+}
+
+static void pgd_prepopulate_pmd(struct mm_struct *mm, pgd_t *pgd, pmd_t *pmds[])
+{
+	pud_t *pud;
+	unsigned long addr;
+	int i;
+
+	pud = pud_offset(pgd, 0);
+
+ 	for (addr = i = 0; i < PREALLOCATED_PMDS;
+	     i++, pud++, addr += PUD_SIZE) {
+		pmd_t *pmd = pmds[i];
+
+		if (i >= KERNEL_PGD_BOUNDARY)
+			memcpy(pmd, (pmd_t *)pgd_page_vaddr(swapper_pg_dir[i]),
+			       sizeof(pmd_t) * PTRS_PER_PMD);
+
+		pud_populate(mm, pud, pmd);
+	}
+}
 
 pgd_t *pgd_alloc(struct mm_struct *mm)
 {
-	pgd_t *pgd = (pgd_t *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
+	pgd_t *pgd;
+	pmd_t *pmds[PREALLOCATED_PMDS];
+	unsigned long flags;
 
-	/* so that alloc_pmd can use it */
+	pgd = (pgd_t *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
+
+	if (pgd == NULL)
+		goto out;
+
 	mm->pgd = pgd;
-	if (pgd) {
-		pgd_ctor(pgd);
 
-		if (paravirt_pgd_alloc(mm) != 0 ||
-		    !pgd_prepopulate_pmd(mm, pgd)) {
-			pgd_dtor(pgd);
-			free_page((unsigned long)pgd);
-			pgd = NULL;
-		}
-	}
+	if (preallocate_pmds(pmds) != 0)
+		goto out_free_pgd;
+
+	if (paravirt_pgd_alloc(mm) != 0)
+		goto out_free_pmds;
+
+	/*
+	 * Make sure that pre-populating the pmds is atomic with
+	 * respect to anything walking the pgd_list, so that they
+	 * never see a partially populated pgd.
+	 */
+	spin_lock_irqsave(&pgd_lock, flags);
+
+	pgd_ctor(pgd);
+	pgd_prepopulate_pmd(mm, pgd, pmds);
+
+	spin_unlock_irqrestore(&pgd_lock, flags);
 
 	return pgd;
+
+out_free_pmds:
+	free_pmds(pmds);
+out_free_pgd:
+	free_page((unsigned long)pgd);
+out:
+	return NULL;
 }
 
 void pgd_free(struct mm_struct *mm, pgd_t *pgd)


