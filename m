Return-Path: <linux-kernel-owner+w=401wt.eu-S932266AbXDJAJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932266AbXDJAJl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 20:09:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753705AbXDJAJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 20:09:07 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:53707 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753681AbXDJAIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 20:08:41 -0400
Date: Mon, 9 Apr 2007 17:06:14 -0700
Message-Id: <200704100006.l3A06Enx020620@zach-dev.vmware.com>
Subject: [PATCH 5/10] Paravirt kmap_atomic_pte tidy.patch
From: Zachary Amsden <zach@vmware.com>
To: Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@muc.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Chris Wright <chrisw@sous-sol.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>
X-OriginalArrivalTime: 10 Apr 2007 00:08:40.0515 (UTC) FILETIME=[64D58930:01C77B04]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Don't implement native_kmap_atomic_pte for !HIGHPTE case; it is never needed,
never called, and leaving it in is just plain confusing.  Making it isolated
to the config where it is used may help find bugs.

Signed-off-by: Zachary Amsden <zach@vmware.com>

diff -r 5c03805411a6 arch/i386/kernel/paravirt.c
--- a/arch/i386/kernel/paravirt.c	Fri Apr 06 14:43:30 2007 -0700
+++ b/arch/i386/kernel/paravirt.c	Fri Apr 06 14:43:37 2007 -0700
@@ -217,13 +217,6 @@ static void native_flush_tlb_single(unsi
 {
 	__native_flush_tlb_single(addr);
 }
-
-#ifndef CONFIG_HIGHPTE
-static void *native_kmap_atomic_pte(struct page *page, enum km_type type)
-{
-	return kmap_atomic(page, type);
-}
-#endif
 
 /* These are in entry.S */
 extern void native_iret(void);
@@ -324,7 +317,9 @@ struct paravirt_ops paravirt_ops = {
 
 	.ptep_get_and_clear = native_ptep_get_and_clear,
 
-	.kmap_atomic_pte = native_kmap_atomic_pte,
+#ifdef CONFIG_HIGHPTE
+	.kmap_atomic_pte = kmap_atomic,
+#endif
 
 #ifdef CONFIG_X86_PAE
 	.set_pte_atomic = native_set_pte_atomic,
diff -r 5c03805411a6 include/asm-i386/highmem.h
--- a/include/asm-i386/highmem.h	Fri Apr 06 14:43:30 2007 -0700
+++ b/include/asm-i386/highmem.h	Fri Apr 06 14:43:37 2007 -0700
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
diff -r 5c03805411a6 include/asm-i386/paravirt.h
--- a/include/asm-i386/paravirt.h	Fri Apr 06 14:43:30 2007 -0700
+++ b/include/asm-i386/paravirt.h	Fri Apr 06 14:43:37 2007 -0700
@@ -190,7 +190,9 @@ struct paravirt_ops
 
  	pte_t (*ptep_get_and_clear)(pte_t *ptep);
 
+#ifdef CONFIG_HIGHPTE
 	void *(*kmap_atomic_pte)(struct page *page, enum km_type type);
+#endif
 
 #ifdef CONFIG_X86_PAE
 	void (*set_pte_atomic)(pte_t *ptep, pte_t pteval);
@@ -892,12 +894,14 @@ static inline void paravirt_release_pd(u
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
