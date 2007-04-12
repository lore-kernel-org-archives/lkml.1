Return-Path: <linux-kernel-owner+w=401wt.eu-S1422707AbXDLFdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422707AbXDLFdy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 01:33:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422710AbXDLFdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 01:33:53 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:56086 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422708AbXDLFdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 01:33:50 -0400
Date: Wed, 11 Apr 2007 22:31:08 -0700
Message-Id: <200704120531.l3C5V80F022840@zach-dev.vmware.com>
Subject: [PATCH 4/4] Pte simplify ops.patch
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

Add comment and condense code to make use of native_local_ptep_get_and_clear
function.  Also, it turns out the 2-level and 3-level paging definitions
were identical, so move the common definition into pgtable.h

Signed-off-by: Zachary Amsden <zach@vmware.com>

diff -r b3bbc1b5e085 include/asm-i386/pgtable-2level.h
--- a/include/asm-i386/pgtable-2level.h	Wed Apr 11 18:23:44 2007 -0700
+++ b/include/asm-i386/pgtable-2level.h	Wed Apr 11 18:24:07 2007 -0700
@@ -39,16 +39,6 @@ static inline void native_pte_clear(stru
 static inline void native_pte_clear(struct mm_struct *mm, unsigned long addr, pte_t *xp)
 {
 	*xp = __pte(0);
-}
-
-/* local pte updates need not use xchg for locking */
-static inline pte_t native_local_ptep_get_and_clear(pte_t *ptep)
-{
-	pte_t res;
-
-	res = *ptep;
-	native_pte_clear(NULL, 0, ptep);
-	return res;
 }
 
 #ifdef CONFIG_SMP
diff -r b3bbc1b5e085 include/asm-i386/pgtable-3level.h
--- a/include/asm-i386/pgtable-3level.h	Wed Apr 11 18:23:44 2007 -0700
+++ b/include/asm-i386/pgtable-3level.h	Wed Apr 11 18:23:49 2007 -0700
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
diff -r b3bbc1b5e085 include/asm-i386/pgtable.h
--- a/include/asm-i386/pgtable.h	Wed Apr 11 18:23:44 2007 -0700
+++ b/include/asm-i386/pgtable.h	Wed Apr 11 18:23:49 2007 -0700
@@ -267,6 +267,16 @@ static inline pte_t pte_mkhuge(pte_t pte
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
@@ -348,8 +358,11 @@ static inline pte_t ptep_get_and_clear_f
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
