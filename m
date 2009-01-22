Return-Path: <linux-kernel-owner+w=401wt.eu-S1758557AbZAVWYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758557AbZAVWYg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 17:24:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752039AbZAVWY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 17:24:28 -0500
Received: from gw.goop.org ([64.81.55.164]:32842 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103AbZAVWY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 17:24:27 -0500
Message-ID: <4978F210.7050808@goop.org>
Date: Thu, 22 Jan 2009 14:24:16 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: [PATCH 1/2] x86/pvops: remove pte_flags pvop
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pte_flags() was introduced as a new pvop in order to extract just the
flags portion of a pte, which is a potentially cheaper operation than
extracting the page number as well.  It turns out this operation is
not needed, because simply using a mask to extract the flags from a
pte is sufficient for all current users.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/page.h     |    3 +--
 arch/x86/include/asm/paravirt.h |   18 ------------------
 arch/x86/kernel/paravirt.c      |    1 -
 arch/x86/xen/enlighten.c        |    1 -
 4 files changed, 1 insertion(+), 22 deletions(-)

===================================================================
--- a/arch/x86/include/asm/page.h
+++ b/arch/x86/include/asm/page.h
@@ -154,7 +154,7 @@
 	return pte.pte;
 }
 
-static inline pteval_t native_pte_flags(pte_t pte)
+static inline pteval_t pte_flags(pte_t pte)
 {
 	return native_pte_val(pte) & PTE_FLAGS_MASK;
 }
@@ -180,7 +180,6 @@
 #endif
 
 #define pte_val(x)	native_pte_val(x)
-#define pte_flags(x)	native_pte_flags(x)
 #define __pte(x)	native_make_pte(x)
 
 #endif	/* CONFIG_PARAVIRT */
===================================================================
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -280,7 +280,6 @@
 					pte_t *ptep, pte_t pte);
 
 	pteval_t (*pte_val)(pte_t);
-	pteval_t (*pte_flags)(pte_t);
 	pte_t (*make_pte)(pteval_t pte);
 
 	pgdval_t (*pgd_val)(pgd_t);
@@ -1088,23 +1087,6 @@
 	return ret;
 }
 
-static inline pteval_t pte_flags(pte_t pte)
-{
-	pteval_t ret;
-
-	if (sizeof(pteval_t) > sizeof(long))
-		ret = PVOP_CALL2(pteval_t, pv_mmu_ops.pte_flags,
-				 pte.pte, (u64)pte.pte >> 32);
-	else
-		ret = PVOP_CALL1(pteval_t, pv_mmu_ops.pte_flags,
-				 pte.pte);
-
-#ifdef CONFIG_PARAVIRT_DEBUG
-	BUG_ON(ret & PTE_PFN_MASK);
-#endif
-	return ret;
-}
-
 static inline pgd_t __pgd(pgdval_t val)
 {
 	pgdval_t ret;
===================================================================
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -435,7 +435,6 @@
 #endif /* PAGETABLE_LEVELS >= 3 */
 
 	.pte_val = native_pte_val,
-	.pte_flags = native_pte_flags,
 	.pgd_val = native_pgd_val,
 
 	.make_pte = native_make_pte,
===================================================================
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1348,7 +1348,6 @@
 	.ptep_modify_prot_commit = __ptep_modify_prot_commit,
 
 	.pte_val = xen_pte_val,
-	.pte_flags = native_pte_flags,
 	.pgd_val = xen_pgd_val,
 
 	.make_pte = xen_make_pte,


