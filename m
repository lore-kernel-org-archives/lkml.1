Return-Path: <linux-kernel-owner+w=401wt.eu-S1423476AbXD3Pyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423476AbXD3Pyc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 11:54:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423480AbXD3PxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 11:53:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:34389 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423476AbXD3PuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 11:50:04 -0400
From: Andi Kleen <ak@suse.de>
References: <20070430549.617098000@suse.de>
In-Reply-To: <20070430549.617098000@suse.de>
To: zach@vmware.com, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [28/34] i386: pte xchg optimization
Message-Id: <20070430155001.8525915209@wotan.suse.de>
Date: Mon, 30 Apr 2007 17:50:01 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Zachary Amsden <zach@vmware.com>

In situations where page table updates need only be made locally, and there is
no cross-processor A/D bit races involved, we need not use the heavyweight
xchg instruction to atomically fetch and clear page table entries.  Instead,
we can just read and clear them directly.

This introduces a neat optimization for non-SMP kernels; drop the atomic xchg
operations from page table updates.

Thanks to Michel Lespinasse for noting this potential optimization.

Signed-off-by: Zachary Amsden <zach@vmware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 include/asm-i386/pgtable-2level.h |   14 ++++++++++++++
 include/asm-i386/pgtable-3level.h |   14 ++++++++++++++
 2 files changed, 28 insertions(+)

Index: linux/include/asm-i386/pgtable-2level.h
===================================================================
--- linux.orig/include/asm-i386/pgtable-2level.h
+++ linux/include/asm-i386/pgtable-2level.h
@@ -41,10 +41,24 @@ static inline void native_pte_clear(stru
 	*xp = __pte(0);
 }
 
+/* local pte updates need not use xchg for locking */
+static inline pte_t native_local_ptep_get_and_clear(pte_t *ptep)
+{
+	pte_t res;
+
+	res = *ptep;
+	native_pte_clear(NULL, 0, ptep);
+	return res;
+}
+
+#ifdef CONFIG_SMP
 static inline pte_t native_ptep_get_and_clear(pte_t *xp)
 {
 	return __pte(xchg(&xp->pte_low, 0));
 }
+#else
+#define native_ptep_get_and_clear(xp) native_local_ptep_get_and_clear(xp)
+#endif
 
 #define pte_page(x)		pfn_to_page(pte_pfn(x))
 #define pte_none(x)		(!(x).pte_low)
Index: linux/include/asm-i386/pgtable-3level.h
===================================================================
--- linux.orig/include/asm-i386/pgtable-3level.h
+++ linux/include/asm-i386/pgtable-3level.h
@@ -139,6 +139,17 @@ static inline void pud_clear (pud_t * pu
 #define pmd_offset(pud, address) ((pmd_t *) pud_page(*(pud)) + \
 			pmd_index(address))
 
+/* local pte updates need not use xchg for locking */
+static inline pte_t native_local_ptep_get_and_clear(pte_t *ptep)
+{
+	pte_t res;
+
+	res = *ptep;
+	native_pte_clear(NULL, 0, ptep);
+	return res;
+}
+
+#ifdef CONFIG_SMP
 static inline pte_t native_ptep_get_and_clear(pte_t *ptep)
 {
 	pte_t res;
@@ -150,6 +161,9 @@ static inline pte_t native_ptep_get_and_
 
 	return res;
 }
+#else
+#define native_ptep_get_and_clear(xp) native_local_ptep_get_and_clear(xp)
+#endif
 
 #define __HAVE_ARCH_PTE_SAME
 static inline int pte_same(pte_t a, pte_t b)
