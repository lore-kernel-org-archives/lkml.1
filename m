Return-Path: <linux-kernel-owner+w=401wt.eu-S1758029AbYCRFcO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758029AbYCRFcO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 01:32:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754167AbYCRFY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 01:24:27 -0400
Received: from gw.goop.org ([64.81.55.164]:37844 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752979AbYCRFYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 01:24:10 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 18 of 31] xen: unify pte operations
X-Mercurial-Node: d624d53ac6971de9c6c2c49a99c1588c0d40583f
Message-Id: <d624d53ac6971de9c6c2.1205797029@localhost>
In-Reply-To: <patchbomb.1205797011@localhost>
Date: Mon, 17 Mar 2008 16:37:09 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Ian Campbell <ijc@hellion.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can fold the essentially common pte functions together now.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/mmu.c |  125 ++++++++++++++++++----------------------------------
 1 file changed, 44 insertions(+), 81 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -171,6 +171,49 @@
 	xen_set_pte(ptep, pteval);
 }
 
+pteval_t xen_pte_val(pte_t pte)
+{
+	pteval_t ret = pte.pte;
+
+	if (ret & _PAGE_PRESENT)
+		ret = machine_to_phys(XMADDR(ret)).paddr | _PAGE_PRESENT;
+
+	return ret;
+}
+
+pgdval_t xen_pgd_val(pgd_t pgd)
+{
+	pgdval_t ret = pgd.pgd;
+	if (ret & _PAGE_PRESENT)
+		ret = machine_to_phys(XMADDR(ret)).paddr | _PAGE_PRESENT;
+	return ret;
+}
+
+pte_t xen_make_pte(pteval_t pte)
+{
+	if (pte & _PAGE_PRESENT) {
+		pte = phys_to_machine(XPADDR(pte)).maddr;
+		pte &= ~(_PAGE_PCD | _PAGE_PWT);
+	}
+
+	return (pte_t){ .pte = pte };
+}
+
+pgd_t xen_make_pgd(pgdval_t pgd)
+{
+	if (pgd & _PAGE_PRESENT)
+		pgd = phys_to_machine(XPADDR(pgd)).maddr;
+
+	return (pgd_t){ pgd };
+}
+
+pmdval_t xen_pmd_val(pmd_t pmd)
+{
+	pmdval_t ret = native_pmd_val(pmd);
+	if (ret & _PAGE_PRESENT)
+		ret = machine_to_phys(XMADDR(ret)).paddr | _PAGE_PRESENT;
+	return ret;
+}
 #ifdef CONFIG_X86_PAE
 void xen_set_pud(pud_t *ptr, pud_t val)
 {
@@ -214,97 +257,17 @@
 	xen_set_pmd(pmdp, __pmd(0));
 }
 
-pteval_t xen_pte_val(pte_t pte)
-{
-	pteval_t ret = pte.pte;
-
-	if (ret & _PAGE_PRESENT)
-		ret = machine_to_phys(XMADDR(ret)).paddr | _PAGE_PRESENT;
-
-	return ret;
-}
-
-pmdval_t xen_pmd_val(pmd_t pmd)
-{
-	pmdval_t ret = pmd.pmd;
-	if (ret & _PAGE_PRESENT)
-		ret = machine_to_phys(XMADDR(ret)).paddr | _PAGE_PRESENT;
-	return ret;
-}
-
-pgdval_t xen_pgd_val(pgd_t pgd)
-{
-	pgdval_t ret = pgd.pgd;
-	if (ret & _PAGE_PRESENT)
-		ret = machine_to_phys(XMADDR(ret)).paddr | _PAGE_PRESENT;
-	return ret;
-}
-
-pte_t xen_make_pte(pteval_t pte)
-{
-	if (pte & _PAGE_PRESENT) {
-		pte = phys_to_machine(XPADDR(pte)).maddr;
-		pte &= ~(_PAGE_PCD | _PAGE_PWT);
-	}
-
-	return (pte_t){ .pte = pte };
-}
-
 pmd_t xen_make_pmd(pmdval_t pmd)
 {
 	if (pmd & _PAGE_PRESENT)
 		pmd = phys_to_machine(XPADDR(pmd)).maddr;
 
-	return (pmd_t){ pmd };
-}
-
-pgd_t xen_make_pgd(pgdval_t pgd)
-{
-	if (pgd & _PAGE_PRESENT)
-		pgd = phys_to_machine(XPADDR(pgd)).maddr;
-
-	return (pgd_t){ pgd };
+	return native_make_pmd(pmd);
 }
 #else  /* !PAE */
 void xen_set_pte(pte_t *ptep, pte_t pte)
 {
 	*ptep = pte;
-}
-
-pteval_t xen_pte_val(pte_t pte)
-{
-	pteval_t ret = pte.pte;
-
-	if (ret & _PAGE_PRESENT)
-		ret = machine_to_phys(XMADDR(ret)).paddr;
-
-	return ret;
-}
-
-pgdval_t xen_pgd_val(pgd_t pgd)
-{
-	pteval_t ret = pgd.pgd;
-	if (ret & _PAGE_PRESENT)
-		ret = machine_to_phys(XMADDR(ret)).paddr | _PAGE_PRESENT;
-	return ret;
-}
-
-pte_t xen_make_pte(pteval_t pte)
-{
-	if (pte & _PAGE_PRESENT) {
-		pte = phys_to_machine(XPADDR(pte)).maddr;
-		pte &= ~(_PAGE_PCD | _PAGE_PWT);
-	}
-
-	return (pte_t){ pte };
-}
-
-pgd_t xen_make_pgd(pgdval_t pgd)
-{
-	if (pgd & _PAGE_PRESENT)
-		pgd = phys_to_machine(XPADDR(pgd)).maddr;
-
-	return (pgd_t){ pgd };
 }
 #endif	/* CONFIG_X86_PAE */
 


