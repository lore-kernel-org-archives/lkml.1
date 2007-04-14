Return-Path: <linux-kernel-owner+w=401wt.eu-S1753885AbXDNV22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885AbXDNV22 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 17:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753903AbXDNVVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 17:21:09 -0400
Received: from gw.goop.org ([64.81.55.164]:59573 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753881AbXDNVUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 17:20:24 -0400
Message-Id: <20070414204924.796018144@goop.org>
References: <20070414204154.871250608@goop.org>
User-Agent: quilt/0.46-1
Date: Sat, 14 Apr 2007 13:42:13 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>, Zachary Amsden <zach@vmware.com>
Subject: [PATCH 19/28] Dont implement native_kmap_atomic_pte for !HIGHPTE
Content-Disposition: inline; filename=paravirt-kmap_atomic_pte-tidy.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Don't implement native_kmap_atomic_pte for !HIGHPTE case; it is never needed,
never called, and leaving it in is just plain confusing.  Making it isolated
to the config where it is used may help find bugs.

From: Zachary Amsden <zach@vmware.com>
Signed-off-by: Zachary Amsden <zach@vmware.com>
Acked-by: Jeremy Fitzhardinge <jeremy@xensource.com>

---
 arch/i386/kernel/paravirt.c |    4 +---
 include/asm-i386/highmem.h  |    5 -----
 include/asm-i386/paravirt.h |    4 ++++
 3 files changed, 5 insertions(+), 8 deletions(-)

===================================================================
--- a/arch/i386/kernel/paravirt.c
+++ b/arch/i386/kernel/paravirt.c
@@ -318,9 +318,7 @@ struct paravirt_ops paravirt_ops = {
 	.ptep_get_and_clear = native_ptep_get_and_clear,
 
 #ifdef CONFIG_HIGHPTE
-	.kmap_atomic_pte = native_kmap_atomic_pte,
-#else
-	.kmap_atomic_pte = paravirt_nop,
+	.kmap_atomic_pte = kmap_atomic,
 #endif
 
 #ifdef CONFIG_X86_PAE
===================================================================
--- a/include/asm-i386/highmem.h
+++ b/include/asm-i386/highmem.h
@@ -74,11 +74,6 @@ void *kmap_atomic_pfn(unsigned long pfn,
 void *kmap_atomic_pfn(unsigned long pfn, enum km_type type);
 struct page *kmap_atomic_to_page(void *ptr);
 
-static inline void *native_kmap_atomic_pte(struct page *page, enum km_type type)
-{
-	return kmap_atomic(page, type);
-}
-
 #ifndef CONFIG_PARAVIRT
 #define kmap_atomic_pte(page, type)	kmap_atomic(page, type)
 #endif
===================================================================
--- a/include/asm-i386/paravirt.h
+++ b/include/asm-i386/paravirt.h
@@ -190,7 +190,9 @@ struct paravirt_ops
 
  	pte_t (*ptep_get_and_clear)(pte_t *ptep);
 
+#ifdef CONFIG_HIGHPTE
 	void *(*kmap_atomic_pte)(struct page *page, enum km_type type);
+#endif
 
 #ifdef CONFIG_X86_PAE
 	void (*set_pte_atomic)(pte_t *ptep, pte_t pteval);
@@ -759,12 +761,14 @@ static inline void paravirt_release_pd(u
 	PVOP_VCALL1(release_pd, pfn);
 }
 
+#ifdef CONFIG_HIGHPTE
 static inline void *kmap_atomic_pte(struct page *page, enum km_type type)
 {
 	unsigned long ret;
 	ret = PVOP_CALL2(unsigned long, kmap_atomic_pte, page, type);
 	return (void *)ret;
 }
+#endif
 
 static inline void pte_update(struct mm_struct *mm, unsigned long addr,
 			      pte_t *ptep)

-- 

