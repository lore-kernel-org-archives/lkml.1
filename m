Return-Path: <linux-kernel-owner+w=401wt.eu-S1757856AbYCRFbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757856AbYCRFbe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 01:31:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754165AbYCRFY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 01:24:26 -0400
Received: from gw.goop.org ([64.81.55.164]:37859 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684AbYCRFYL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 01:24:11 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 20 of 31] xen: unify pte operations on machine frames
X-Mercurial-Node: f7b7c9e73d61cb7001a5d9781659ab8bc5264f12
Message-Id: <f7b7c9e73d61cb7001a5.1205797031@localhost>
In-Reply-To: <patchbomb.1205797011@localhost>
Date: Mon, 17 Mar 2008 16:37:11 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Ian Campbell <ijc@hellion.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xen's pte operations on mfns can be unified like the kernel's pfn operations.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 include/xen/page.h |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/include/xen/page.h b/include/xen/page.h
--- a/include/xen/page.h
+++ b/include/xen/page.h
@@ -125,37 +125,37 @@
 #define virt_to_mfn(v)		(pfn_to_mfn(PFN_DOWN(__pa(v))))
 #define mfn_to_virt(m)		(__va(mfn_to_pfn(m) << PAGE_SHIFT))
 
-#ifdef CONFIG_X86_PAE
-#define pte_mfn(_pte) (((_pte).pte_low >> PAGE_SHIFT) |			\
-		       (((_pte).pte_high & 0xfff) << (32-PAGE_SHIFT)))
+static inline unsigned long pte_mfn(pte_t pte)
+{
+	return (pte.pte & ~_PAGE_NX) >> PAGE_SHIFT;
+}
 
 static inline pte_t mfn_pte(unsigned long page_nr, pgprot_t pgprot)
 {
 	pte_t pte;
 
-	pte.pte_high = (page_nr >> (32 - PAGE_SHIFT)) |
-		(pgprot_val(pgprot) >> 32);
-	pte.pte_high &= (__supported_pte_mask >> 32);
-	pte.pte_low = ((page_nr << PAGE_SHIFT) | pgprot_val(pgprot));
-	pte.pte_low &= __supported_pte_mask;
+	pte.pte = ((phys_addr_t)page_nr << PAGE_SHIFT) |
+		(pgprot_val(pgprot) & __supported_pte_mask);
 
 	return pte;
 }
 
-static inline unsigned long long pte_val_ma(pte_t x)
+static inline pteval_t pte_val_ma(pte_t pte)
 {
-	return x.pte;
+	return pte.pte;
 }
+
+static inline pte_t __pte_ma(pteval_t x)
+{
+	return (pte_t) { .pte = x };
+}
+
+#ifdef CONFIG_X86_PAE
 #define pmd_val_ma(v) ((v).pmd)
 #define pud_val_ma(v) ((v).pgd.pgd)
-#define __pte_ma(x)	((pte_t) { .pte = (x) })
 #define __pmd_ma(x)	((pmd_t) { (x) } )
 #else  /* !X86_PAE */
-#define pte_mfn(_pte) ((_pte).pte_low >> PAGE_SHIFT)
-#define mfn_pte(pfn, prot)	__pte_ma(((pfn) << PAGE_SHIFT) | pgprot_val(prot))
-#define pte_val_ma(x)	((x).pte)
 #define pmd_val_ma(v)	((v).pud.pgd.pgd)
-#define __pte_ma(x)	((pte_t) { (x) } )
 #endif	/* CONFIG_X86_PAE */
 
 #define pgd_val_ma(x)	((x).pgd)


