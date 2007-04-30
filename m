Return-Path: <linux-kernel-owner+w=401wt.eu-S1423477AbXD3PuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423477AbXD3PuK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 11:50:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423485AbXD3PuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 11:50:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34394 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423477AbXD3PuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 11:50:04 -0400
From: Andi Kleen <ak@suse.de>
References: <20070430549.617098000@suse.de>
In-Reply-To: <20070430549.617098000@suse.de>
To: zach@vmware.com, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [29/34] i386: pte simplify ops
Message-Id: <20070430155002.9305815206@wotan.suse.de>
Date: Mon, 30 Apr 2007 17:50:02 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Zachary Amsden <zach@vmware.com>

Add comment and condense code to make use of native_local_ptep_get_and_clear
function.  Also, it turns out the 2-level and 3-level paging definitions were
identical, so move the common definition into pgtable.h

Signed-off-by: Zachary Amsden <zach@vmware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 include/asm-i386/pgtable-2level.h |   10 ----------
 include/asm-i386/pgtable-3level.h |   10 ----------
 include/asm-i386/pgtable.h        |   17 +++++++++++++++--
 3 files changed, 15 insertions(+), 22 deletions(-)

Index: linux/include/asm-i386/pgtable-2level.h
===================================================================
--- linux.orig/include/asm-i386/pgtable-2level.h
+++ linux/include/asm-i386/pgtable-2level.h
@@ -41,16 +41,6 @@ static inline void native_pte_clear(stru
 	*xp = __pte(0);
 }
 
-/* local pte updates need not use xchg for locking */
-static inline pte_t native_local_ptep_get_and_clear(pte_t *ptep)
-{
-	pte_t res;
-
-	res = *ptep;
-	native_pte_clear(NULL, 0, ptep);
-	return res;
-}
-
 #ifdef CONFIG_SMP
 static inline pte_t native_ptep_get_and_clear(pte_t *xp)
 {
Index: linux/include/asm-i386/pgtable-3level.h
===================================================================
--- linux.orig/include/asm-i386/pgtable-3level.h
+++ linux/include/asm-i386/pgtable-3level.h
@@ -139,16 +139,6 @@ static inline void pud_clear (pud_t * pu
 #define pmd_offset(pud, address) ((pmd_t *) pud_page(*(pud)) + \
 			pmd_index(address))
 
-/* local pte updates need not use xchg for locking */
-static inline pte_t native_local_ptep_get_and_clear(pte_t *ptep)
-{
-	pte_t res;
-
-	res = *ptep;
-	native_pte_clear(NULL, 0, ptep);
-	return res;
-}
-
 #ifdef CONFIG_SMP
 static inline pte_t native_ptep_get_and_clear(pte_t *ptep)
 {
Index: linux/include/asm-i386/pgtable.h
===================================================================
--- linux.orig/include/asm-i386/pgtable.h
+++ linux/include/asm-i386/pgtable.h
@@ -269,6 +269,16 @@ extern void vmalloc_sync_all(void);
 #define pte_update_defer(mm, addr, ptep)	do { } while (0)
 #endif
 
+/* local pte updates need not use xchg for locking */
+static inline pte_t native_local_ptep_get_and_clear(pte_t *ptep)
+{
+	pte_t res = *ptep;
+
+	/* Pure native function needs no input for mm, addr */
+	native_pte_clear(NULL, 0, ptep);
+	return res;
+}
+
 /*
  * We only update the dirty/accessed state if we set
  * the dirty bit by hand in the kernel, since the hardware
@@ -343,8 +353,11 @@ static inline pte_t ptep_get_and_clear_f
 {
 	pte_t pte;
 	if (full) {
-		pte = *ptep;
-		native_pte_clear(mm, addr, ptep);
+		/*
+		 * Full address destruction in progress; paravirt does not
+		 * care about updates and native needs no locking
+		 */
+		pte = native_local_ptep_get_and_clear(ptep);
 	} else {
 		pte = ptep_get_and_clear(mm, addr, ptep);
 	}
