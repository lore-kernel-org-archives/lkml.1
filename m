Return-Path: <linux-kernel-owner+w=401wt.eu-S1422694AbXDLFeK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422694AbXDLFeK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 01:34:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422708AbXDLFdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 01:33:54 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:56071 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422699AbXDLFdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 01:33:40 -0400
Date: Wed, 11 Apr 2007 22:30:58 -0700
Message-Id: <200704120530.l3C5UweV022834@zach-dev.vmware.com>
Subject: [PATCH 3/4] Pte xchg optimization.patch
From: Zachary Amsden <zach@vmware.com>
To: Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@muc.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Chris Wright <chrisw@sous-sol.org>, Hugh Dickins <hugh@veritas.com>,
       David Rientjes <rientjes@google.com>,
       Michel Lespinasse <walken@vmware.com>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In situations where page table updates need only be made locally, and there
is no cross-processor A/D bit races involved, we need not use the heavyweight
xchg instruction to atomically fetch and clear page table entries.  Instead,
we can just read and clear them directly.

This introduces a neat optimization for non-SMP kernels; drop the atomic
xchg operations from page table updates.

Thanks to Michel Lespinasse for noting this potential optimization.

Signed-off-by: Zachary Amsden <zach@vmware.com>

diff -r 47495b2532b3 include/asm-i386/pgtable-2level.h
--- a/include/asm-i386/pgtable-2level.h	Wed Apr 11 18:23:01 2007 -0700
+++ b/include/asm-i386/pgtable-2level.h	Wed Apr 11 18:23:39 2007 -0700
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
diff -r 47495b2532b3 include/asm-i386/pgtable-3level.h
--- a/include/asm-i386/pgtable-3level.h	Wed Apr 11 18:23:01 2007 -0700
+++ b/include/asm-i386/pgtable-3level.h	Wed Apr 11 18:23:05 2007 -0700
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
