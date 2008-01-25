Return-Path: <linux-kernel-owner+w=401wt.eu-S1761629AbYAYVzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761629AbYAYVzu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 16:55:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759027AbYAYVwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 16:52:30 -0500
Received: from 42.sub-75-208-60.myvzw.com ([75.208.60.42]:37925 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760012AbYAYVw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 16:52:28 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 09 of 11] x86: preallocate pmds at pgd creation time
X-Mercurial-Node: 9e9568e9f481b44f50f72f7beef3554ae271960f
Message-Id: <9e9568e9f481b44f50f7.1201296198@localhost>
In-Reply-To: <patchbomb.1201296189@localhost>
Date: Fri, 25 Jan 2008 13:23:18 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Jan Beulich <jbeulich@novell.com>,
       Eduardo Pereira Habkost <ehabkost@redhat.com>,
       Ian Campbell <ijc@hellion.org.uk>, H Peter Anvin <hpa@zytor.com>,
       William Irwin <wli@holomorphy.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In PAE mode, an update to the pgd requires a cr3 reload to make sure
the processor notices the changes.  Since this also has the
side-effect of flushing the tlb, its an expensive operation which we
want to avoid where possible.

This patch mitigates the cost of installing the initial set of pmds on
process creation by preallocating them when the pgd is allocated.
This avoids up to three tlb flushes during exec, as it creates the new
process address space while the pagetable is in active use.

The pmds will be freed as part of the normal pagetable teardown in
free_pgtables, which is called in munmap and process exit.  However,
free_pgtables will only free parts of the pagetable which actually
contain mappings, so stray pmds may still be attached to the pgd at
pgd_free time.  We must mop them up to prevent a memory leak.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: William Irwin <wli@holomorphy.com>
---
 arch/x86/mm/pgtable_32.c |   70 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 70 insertions(+)

diff --git a/arch/x86/mm/pgtable_32.c b/arch/x86/mm/pgtable_32.c
--- a/arch/x86/mm/pgtable_32.c
+++ b/arch/x86/mm/pgtable_32.c
@@ -258,17 +258,87 @@ static void pgd_dtor(void *pgd)
 	spin_unlock_irqrestore(&pgd_lock, flags);
 }
 
+#ifdef CONFIG_X86_PAE
+/*
+ * Mop up any pmd pages which may still be attached to the pgd.
+ * Normally they will be freed by munmap/exit_mmap, but any pmd we
+ * preallocate which never got a corresponding vma will need to be
+ * freed manually.
+ */
+static void pgd_mop_up_pmds(pgd_t *pgdp)
+{
+	int i;
+
+	for(i = 0; i < USER_PTRS_PER_PGD; i++) {
+		pgd_t pgd = pgdp[i];
+
+		if (pgd_val(pgd) != 0) {
+			pmd_t *pmd = (pmd_t *)pgd_page_vaddr(pgd);
+
+			pgdp[i] = native_make_pgd(0);
+
+			paravirt_release_pd(pgd_val(pgd) >> PAGE_SHIFT);
+			pmd_free(pmd);
+		}
+	}
+}
+
+/*
+ * In PAE mode, we need to do a cr3 reload (=tlb flush) when
+ * updating the top-level pagetable entries to guarantee the
+ * processor notices the update.  Since this is expensive, and
+ * all 4 top-level entries are used almost immediately in a
+ * new process's life, we just pre-populate them here.
+ */
+static int pgd_prepopulate_pmd(struct mm_struct *mm, pgd_t *pgd)
+{
+	pud_t *pud;
+	unsigned long addr;
+	int i;
+
+	pud = pud_offset(pgd, 0);
+ 	for (addr = i = 0; i < USER_PTRS_PER_PGD; i++, pud++, addr += PUD_SIZE) {
+		pmd_t *pmd = pmd_alloc_one(mm, addr);
+
+		if (!pmd) {
+			pgd_mop_up_pmds(pgd);
+			return 0;
+		}
+
+		pud_populate(mm, pud, pmd);
+	}
+
+	return 1;
+}
+#else  /* !CONFIG_X86_PAE */
+/* No need to prepopulate any pagetable entries in non-PAE modes. */
+static int pgd_prepopulate_pmd(struct mm_struct *mm, pgd_t *pgd)
+{
+	return 1;
+}
+
+static void pgd_mop_up_pmds(pgd_t *pgd)
+{
+}
+#endif	/* CONFIG_X86_PAE */
+
 pgd_t *pgd_alloc(struct mm_struct *mm)
 {
 	pgd_t *pgd = quicklist_alloc(0, GFP_KERNEL, pgd_ctor);
 
 	mm->pgd = pgd;		/* so that alloc_pd can use it */
 
+	if (pgd && !pgd_prepopulate_pmd(mm, pgd)) {
+		quicklist_free(0, pgd_dtor, pgd);
+		pgd = NULL;
+	}
+
 	return pgd;
 }
 
 void pgd_free(pgd_t *pgd)
 {
+	pgd_mop_up_pmds(pgd);
 	quicklist_free(0, pgd_dtor, pgd);
 }
 


