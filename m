Return-Path: <linux-kernel-owner+w=401wt.eu-S1756386AbYAQCbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386AbYAQCbi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 21:31:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753568AbYAQC3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 21:29:32 -0500
Received: from gw.goop.org ([64.81.55.164]:46850 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753114AbYAQC31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 21:29:27 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 2 of 8] x86/paravirt: rearrange common mmu_ops
X-Mercurial-Node: 06e18fa89ef4d260ae20bef812d59a345d322c6f
Message-Id: <06e18fa89ef4d260ae20.1200526040@localhost>
In-Reply-To: <patchbomb.1200526038@localhost>
Date: Wed, 16 Jan 2008 15:27:20 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rearrange the various pagetable mmu_ops to remove duplication.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
---
 include/asm-x86/paravirt.h |   30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/include/asm-x86/paravirt.h b/include/asm-x86/paravirt.h
--- a/include/asm-x86/paravirt.h
+++ b/include/asm-x86/paravirt.h
@@ -230,28 +230,32 @@ struct pv_mmu_ops {
 	void (*pte_update_defer)(struct mm_struct *mm,
 				 unsigned long addr, pte_t *ptep);
 
+	pteval_t (*pte_val)(pte_t);
+	pte_t (*make_pte)(pteval_t pte);
+
+	pgdval_t (*pgd_val)(pgd_t);
+	pgd_t (*make_pgd)(pgdval_t pgd);
+
+#if PAGETABLE_LEVELS >= 3
 #ifdef CONFIG_X86_PAE
 	void (*set_pte_atomic)(pte_t *ptep, pte_t pteval);
 	void (*set_pte_present)(struct mm_struct *mm, unsigned long addr,
 				pte_t *ptep, pte_t pte);
-	void (*set_pud)(pud_t *pudp, pud_t pudval);
 	void (*pte_clear)(struct mm_struct *mm, unsigned long addr, pte_t *ptep);
 	void (*pmd_clear)(pmd_t *pmdp);
 
-	unsigned long long (*pte_val)(pte_t);
-	unsigned long long (*pmd_val)(pmd_t);
-	unsigned long long (*pgd_val)(pgd_t);
+#endif	/* CONFIG_X86_PAE */
 
-	pte_t (*make_pte)(unsigned long long pte);
-	pmd_t (*make_pmd)(unsigned long long pmd);
-	pgd_t (*make_pgd)(unsigned long long pgd);
-#else
-	unsigned long (*pte_val)(pte_t);
-	unsigned long (*pgd_val)(pgd_t);
+	void (*set_pud)(pud_t *pudp, pud_t pudval);
 
-	pte_t (*make_pte)(unsigned long pte);
-	pgd_t (*make_pgd)(unsigned long pgd);
-#endif
+	pmdval_t (*pmd_val)(pmd_t);
+	pmd_t (*make_pmd)(pmdval_t pmd);
+
+#if PAGETABLE_LEVELS == 4
+	pudval_t (*pud_val)(pud_t);
+	pud_t (*make_pud)(pudval_t pud);
+#endif	/* PAGETABLE_LEVELS == 4 */
+#endif	/* PAGETABLE_LEVELS >= 3 */
 
 #ifdef CONFIG_HIGHPTE
 	void *(*kmap_atomic_pte)(struct page *page, enum km_type type);


