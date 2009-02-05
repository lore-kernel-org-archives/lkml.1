Return-Path: <linux-kernel-owner+w=401wt.eu-S1762607AbZBECdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762607AbZBECdx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 21:33:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755431AbZBECdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 21:33:43 -0500
Received: from gw.goop.org ([64.81.55.164]:57732 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753327AbZBECdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 21:33:42 -0500
Message-ID: <498A5002.9080408@goop.org>
Date: Wed, 04 Feb 2009 18:33:38 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
CC: William Lee Irwin III <wli@holomorphy.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: __supported_pte_mask breaks PROT_NONE pages
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On an x86 system which doesn't support global mappings, 
__supported_pte_mask has _PAGE_GLOBAL clear, to make sure it never 
appears in the PTE.  pfn_pte() and so on will enforce it with:

static inline pte_t pfn_pte(unsigned long page_nr, pgprot_t pgprot)
{
	return __pte((((phys_addr_t)page_nr << PAGE_SHIFT) |
		      pgprot_val(pgprot)) & __supported_pte_mask);
}


However, we overload _PAGE_GLOBAL with _PAGE_PROTNONE on non-present 
ptes to distinguish them from swap entries.  However, applying 
__supported_pte_mask indiscriminately will clear the bit and corrupt the 
pte.

I guess the best fix is to only apply __supported_pte_mask to present 
ptes.  This seems like the right solution to me, as it means we can 
completely ignore the issue of overlaps between the present pte bits and 
the non-present pte-as-swap entry use of the bits.  (Patch below.)

Alternatively we could filter the unwanted bits in set_pte and so on, 
but that seems to undermine the utility of __supported_pte_mask.

    J

Subject: x86: don't apply __supported_pte_mask to non-present ptes

__supported_pte_mask contains the set of flags we support on the
current hardware.  We also use bits in the pte for things like
logically present ptes with no permissions, and swap entries for
swapped out pages.  We should only apply __supported_pte_mask to
present ptes, because otherwise we may destroy other information being
stored in the ptes.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/pgtable.h  |   26 ++++++++++++++++++++------
 arch/x86/include/asm/xen/page.h |    2 +-
 2 files changed, 21 insertions(+), 7 deletions(-)

===================================================================
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -316,16 +316,30 @@
 
 extern pteval_t __supported_pte_mask;
 
+/*
+ * Mask out unsupported bits in a present pgprot.  Non-present pgprots
+ * can use those bits for other purposes, so leave them be.
+ */
+static inline pgprotval_t massage_pgprot(pgprot_t pgprot)
+{
+	pgprotval_t protval = pgprot_val(pgprot);
+
+	if (protval & _PAGE_PRESENT)
+		protval &= __supported_pte_mask;
+
+	return protval;
+}
+
 static inline pte_t pfn_pte(unsigned long page_nr, pgprot_t pgprot)
 {
-	return __pte((((phys_addr_t)page_nr << PAGE_SHIFT) |
-		      pgprot_val(pgprot)) & __supported_pte_mask);
+	return __pte(((phys_addr_t)page_nr << PAGE_SHIFT) |
+		     massage_pgprot(pgprot));
 }
 
 static inline pmd_t pfn_pmd(unsigned long page_nr, pgprot_t pgprot)
 {
-	return __pmd((((phys_addr_t)page_nr << PAGE_SHIFT) |
-		      pgprot_val(pgprot)) & __supported_pte_mask);
+	return __pmd(((phys_addr_t)page_nr << PAGE_SHIFT) |
+		     massage_pgprot(pgprot));
 }
 
 static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
@@ -337,7 +351,7 @@
 	 * the newprot (if present):
 	 */
 	val &= _PAGE_CHG_MASK;
-	val |= pgprot_val(newprot) & (~_PAGE_CHG_MASK) & __supported_pte_mask;
+	val |= massage_pgprot(newprot) & ~_PAGE_CHG_MASK;
 
 	return __pte(val);
 }
@@ -353,7 +367,7 @@
 
 #define pte_pgprot(x) __pgprot(pte_flags(x) & PTE_FLAGS_MASK)
 
-#define canon_pgprot(p) __pgprot(pgprot_val(p) & __supported_pte_mask)
+#define canon_pgprot(p) __pgprot(massage_pgprot(p))
 
 static inline int is_new_memtype_allowed(unsigned long flags,
 						unsigned long new_flags)
===================================================================
--- a/arch/x86/include/asm/xen/page.h
+++ b/arch/x86/include/asm/xen/page.h
@@ -137,7 +137,7 @@
 	pte_t pte;
 
 	pte.pte = ((phys_addr_t)page_nr << PAGE_SHIFT) |
-		(pgprot_val(pgprot) & __supported_pte_mask);
+			massage_pgprot(pgprot);
 
 	return pte;
 }


