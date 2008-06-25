Return-Path: <linux-kernel-owner+w=401wt.eu-S1760889AbYFYEte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760889AbYFYEte (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 00:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756786AbYFYEhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 00:37:52 -0400
Received: from 9.sub-70-198-159.myvzw.com ([70.198.159.9]:37479 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756150AbYFYEhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 00:37:37 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 26 of 36] x86_64: Split set_pte_vaddr()
X-Mercurial-Node: 4beca5493282852a73d68bc0a0ffc0711e04acf6
Message-Id: <4beca5493282852a73d6.1214367562@localhost>
In-Reply-To: <patchbomb.1214367536@localhost>
Date: Wed, 25 Jun 2008 00:19:22 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eduardo Habkost <ehabkost@redhat.com>

We will need to set a pte on l3_user_pgt. Extract set_pte_vaddr_pud()
from set_pte_vaddr(), that will accept the l3 page table as parameter.

This change should be a no-op for existing code.

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
Signed-off-by: Mark McLoughlin <markmc@redhat.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/mm/init_64.c        |   31 ++++++++++++++++++++-----------
 include/asm-x86/pgtable_64.h |    3 +++
 2 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -149,22 +149,13 @@
 }
 
 void
-set_pte_vaddr(unsigned long vaddr, pte_t new_pte)
+set_pte_vaddr_pud(pud_t *pud_page, unsigned long vaddr, pte_t new_pte)
 {
-	pgd_t *pgd;
 	pud_t *pud;
 	pmd_t *pmd;
 	pte_t *pte;
 
-	pr_debug("set_pte_vaddr %lx to %lx\n", vaddr, native_pte_val(new_pte));
-
-	pgd = pgd_offset_k(vaddr);
-	if (pgd_none(*pgd)) {
-		printk(KERN_ERR
-			"PGD FIXMAP MISSING, it should be setup in head.S!\n");
-		return;
-	}
-	pud = pud_offset(pgd, vaddr);
+	pud = pud_page + pud_index(vaddr);
 	if (pud_none(*pud)) {
 		pmd = (pmd_t *) spp_getpage();
 		pud_populate(&init_mm, pud, pmd);
@@ -195,6 +186,24 @@
 	 * (PGE mappings get flushed as well)
 	 */
 	__flush_tlb_one(vaddr);
+}
+
+void
+set_pte_vaddr(unsigned long vaddr, pte_t pteval)
+{
+	pgd_t *pgd;
+	pud_t *pud_page;
+
+	pr_debug("set_pte_vaddr %lx to %lx\n", vaddr, native_pte_val(pteval));
+
+	pgd = pgd_offset_k(vaddr);
+	if (pgd_none(*pgd)) {
+		printk(KERN_ERR
+			"PGD FIXMAP MISSING, it should be setup in head.S!\n");
+		return;
+	}
+	pud_page = (pud_t*)pgd_page_vaddr(*pgd);
+	set_pte_vaddr_pud(pud_page, vaddr, pteval);
 }
 
 /*
diff --git a/include/asm-x86/pgtable_64.h b/include/asm-x86/pgtable_64.h
--- a/include/asm-x86/pgtable_64.h
+++ b/include/asm-x86/pgtable_64.h
@@ -69,6 +69,9 @@
 #define pud_none(x)	(!pud_val(x))
 
 struct mm_struct;
+
+void set_pte_vaddr_pud(pud_t *pud_page, unsigned long vaddr, pte_t new_pte);
+
 
 static inline void native_pte_clear(struct mm_struct *mm, unsigned long addr,
 				    pte_t *ptep)


