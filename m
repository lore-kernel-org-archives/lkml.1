Return-Path: <linux-kernel-owner+w=401wt.eu-S1758299AbYGHXWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758299AbYGHXWV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 19:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757732AbYGHXOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 19:14:53 -0400
Received: from gw.goop.org ([64.81.55.164]:51209 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755967AbYGHXOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 19:14:44 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 36 of 55] xen: use set_pte_vaddr
X-Mercurial-Node: 31bd2d6c187ede8029d2e6f11e352f79fc1f3ee7
Message-Id: <31bd2d6c187ede8029d2.1215554818@localhost>
In-Reply-To: <patchbomb.1215554782@localhost>
Date: Tue, 08 Jul 2008 15:06:58 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make Xen's set_pte_mfn() use set_pte_vaddr rather than copying it.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
Signed-off-by: Mark McLoughlin <markmc@redhat.com>
---
 arch/x86/xen/mmu.c |   30 +-----------------------------
 1 file changed, 1 insertion(+), 29 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -282,35 +282,7 @@
  */
 void set_pte_mfn(unsigned long vaddr, unsigned long mfn, pgprot_t flags)
 {
-	pgd_t *pgd;
-	pud_t *pud;
-	pmd_t *pmd;
-	pte_t *pte;
-
-	pgd = swapper_pg_dir + pgd_index(vaddr);
-	if (pgd_none(*pgd)) {
-		BUG();
-		return;
-	}
-	pud = pud_offset(pgd, vaddr);
-	if (pud_none(*pud)) {
-		BUG();
-		return;
-	}
-	pmd = pmd_offset(pud, vaddr);
-	if (pmd_none(*pmd)) {
-		BUG();
-		return;
-	}
-	pte = pte_offset_kernel(pmd, vaddr);
-	/* <mfn,flags> stored as-is, to permit clearing entries */
-	xen_set_pte(pte, mfn_pte(mfn, flags));
-
-	/*
-	 * It's enough to flush this one mapping.
-	 * (PGE mappings get flushed as well)
-	 */
-	__flush_tlb_one(vaddr);
+	set_pte_vaddr(vaddr, mfn_pte(mfn, flags));
 }
 
 void xen_set_pte_at(struct mm_struct *mm, unsigned long addr,


