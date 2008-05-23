Return-Path: <linux-kernel-owner+w=401wt.eu-S1756018AbYEWNUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018AbYEWNUj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 09:20:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753918AbYEWNUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 09:20:32 -0400
Received: from gw.goop.org ([64.81.55.164]:55471 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753398AbYEWNUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 09:20:31 -0400
Message-ID: <4836C47F.1090100@goop.org>
Date: Fri, 23 May 2008 14:19:59 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Zachary Amsden <zach@vmware.com>
Subject: [PATCH] x86/paravirt: add pte_flags to just get pte flags
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add pte_flags() to extract the flags from a pte.  This is a special
case of pte_val() which is only guaranteed to return the pte's flags
correctly; the page number may be corrupted or missing.

The intent is to allow paravirt implementations to return pte flags
without having to do any translation of the page number (most notably,
Xen).

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/paravirt.c |    1 +
 arch/x86/xen/enlighten.c   |    1 +
 drivers/lguest/lg.h        |    1 -
 include/asm-x86/page.h     |    1 +
 include/asm-x86/paravirt.h |   15 +++++++++++++++
 include/asm-x86/pgtable.h  |   16 ++++++++--------
 6 files changed, 26 insertions(+), 9 deletions(-)

===================================================================
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -406,6 +406,7 @@
 #endif /* PAGETABLE_LEVELS >= 3 */
 
 	.pte_val = native_pte_val,
+	.pte_flags = native_pte_val,
 	.pgd_val = native_pgd_val,
 
 	.make_pte = native_make_pte,
===================================================================
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1102,6 +1102,7 @@
 	.set_pmd = xen_set_pmd,
 
 	.pte_val = xen_pte_val,
+	.pte_flags = native_pte_val,
 	.pgd_val = xen_pgd_val,
 
 	.make_pte = xen_make_pte,
===================================================================
--- a/drivers/lguest/lg.h
+++ b/drivers/lguest/lg.h
@@ -136,7 +136,6 @@
  * first step in the migration to the kernel types.  pte_pfn is already defined
  * in the kernel. */
 #define pgd_flags(x)	(pgd_val(x) & ~PAGE_MASK)
-#define pte_flags(x)	(pte_val(x) & ~PAGE_MASK)
 #define pgd_pfn(x)	(pgd_val(x) >> PAGE_SHIFT)
 
 /* interrupts_and_traps.c: */
===================================================================
--- a/include/asm-x86/page.h
+++ b/include/asm-x86/page.h
@@ -164,6 +164,7 @@
 #endif
 
 #define pte_val(x)	native_pte_val(x)
+#define pte_flags(x)	native_pte_val(x)
 #define __pte(x)	native_make_pte(x)
 
 #endif	/* CONFIG_PARAVIRT */
===================================================================
--- a/include/asm-x86/paravirt.h
+++ b/include/asm-x86/paravirt.h
@@ -240,6 +240,7 @@
 				 unsigned long addr, pte_t *ptep);
 
 	pteval_t (*pte_val)(pte_t);
+	pteval_t (*pte_flags)(pte_t);
 	pte_t (*make_pte)(pteval_t pte);
 
 	pgdval_t (*pgd_val)(pgd_t);
@@ -997,6 +998,20 @@
 	return ret;
 }
 
+static inline pteval_t pte_flags(pte_t pte)
+{
+	pteval_t ret;
+
+	if (sizeof(pteval_t) > sizeof(long))
+		ret = PVOP_CALL2(pteval_t, pv_mmu_ops.pte_flags,
+				 pte.pte, (u64)pte.pte >> 32);
+	else
+		ret = PVOP_CALL1(pteval_t, pv_mmu_ops.pte_flags,
+				 pte.pte);
+
+	return ret;
+}
+
 static inline pgd_t __pgd(pgdval_t val)
 {
 	pgdval_t ret;
===================================================================
--- a/include/asm-x86/pgtable.h
+++ b/include/asm-x86/pgtable.h
@@ -163,37 +163,37 @@
  */
 static inline int pte_dirty(pte_t pte)
 {
-	return pte_val(pte) & _PAGE_DIRTY;
+	return pte_flags(pte) & _PAGE_DIRTY;
 }
 
 static inline int pte_young(pte_t pte)
 {
-	return pte_val(pte) & _PAGE_ACCESSED;
+	return pte_flags(pte) & _PAGE_ACCESSED;
 }
 
 static inline int pte_write(pte_t pte)
 {
-	return pte_val(pte) & _PAGE_RW;
+	return pte_flags(pte) & _PAGE_RW;
 }
 
 static inline int pte_file(pte_t pte)
 {
-	return pte_val(pte) & _PAGE_FILE;
+	return pte_flags(pte) & _PAGE_FILE;
 }
 
 static inline int pte_huge(pte_t pte)
 {
-	return pte_val(pte) & _PAGE_PSE;
+	return pte_flags(pte) & _PAGE_PSE;
 }
 
 static inline int pte_global(pte_t pte)
 {
-	return pte_val(pte) & _PAGE_GLOBAL;
+	return pte_flags(pte) & _PAGE_GLOBAL;
 }
 
 static inline int pte_exec(pte_t pte)
 {
-	return !(pte_val(pte) & _PAGE_NX);
+	return !(pte_flags(pte) & _PAGE_NX);
 }
 
 static inline int pte_special(pte_t pte)
@@ -304,7 +304,7 @@
 	return __pgprot(preservebits | addbits);
 }
 
-#define pte_pgprot(x) __pgprot(pte_val(x) & ~PTE_MASK)
+#define pte_pgprot(x) __pgprot(pte_flags(x) & ~PTE_MASK)
 
 #define canon_pgprot(p) __pgprot(pgprot_val(p) & __supported_pte_mask)
 


