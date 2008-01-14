Return-Path: <linux-kernel-owner+w=401wt.eu-S1758247AbYANW2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758247AbYANW2R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 17:28:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756096AbYANWRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 17:17:22 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55164 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755930AbYANWRF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 17:17:05 -0500
From: Andi Kleen <ak@suse.de>
References: <200801141116.534682000@suse.de>
In-Reply-To: <200801141116.534682000@suse.de>
To: linux-kernel@vger.kernel.org, jbeulich@novell.com, mingo@elte.hu,
       tglx@linutronix.de
Subject: [PATCH] [31/31] Clean up pte_exec
Message-Id: <20080114221704.B1ED914F83@wotan.suse.de>
Date: Mon, 14 Jan 2008 23:17:04 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


- Rename it to pte_exec() from pte_exec_kernel(). There is nothing
kernel specific in there.
- Move it into the common file because _PAGE_NX is 0 on !PAE and then
pte_exec() will be always evaluate to true.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/mm/fault_32.c           |    2 +-
 include/asm-x86/pgtable-2level.h |    8 --------
 include/asm-x86/pgtable-3level.h |    8 --------
 include/asm-x86/pgtable.h        |    1 +
 4 files changed, 2 insertions(+), 17 deletions(-)

Index: linux/include/asm-x86/pgtable-2level.h
===================================================================
--- linux.orig/include/asm-x86/pgtable-2level.h
+++ linux/include/asm-x86/pgtable-2level.h
@@ -56,14 +56,6 @@ static inline pte_t native_ptep_get_and_
 #define pte_pfn(x)		(pte_val(x) >> PAGE_SHIFT)
 
 /*
- * All present pages are kernel-executable:
- */
-static inline int pte_exec_kernel(pte_t pte)
-{
-	return 1;
-}
-
-/*
  * Bits 0, 6 and 7 are taken, split up the 29 bits of offset
  * into this range:
  */
Index: linux/include/asm-x86/pgtable.h
===================================================================
--- linux.orig/include/asm-x86/pgtable.h
+++ linux/include/asm-x86/pgtable.h
@@ -143,6 +143,7 @@ static inline int pte_write(pte_t pte)		
 static inline int pte_file(pte_t pte)		{ return pte_val(pte) & _PAGE_FILE; }
 static inline int pte_huge(pte_t pte)		{ return pte_val(pte) & _PAGE_PSE; }
 static inline int pte_global(pte_t pte) 	{ return pte_val(pte) & _PAGE_GLOBAL; }
+static inline int pte_exec(pte_t pte)		{ return !(pte_val(pte) & _PAGE_NX); }
 
 static inline int pmd_large(pmd_t pte) {
 	return (pmd_val(pte) & (_PAGE_PSE|_PAGE_PRESENT)) ==
Index: linux/include/asm-x86/pgtable-3level.h
===================================================================
--- linux.orig/include/asm-x86/pgtable-3level.h
+++ linux/include/asm-x86/pgtable-3level.h
@@ -19,14 +19,6 @@
 #define pud_bad(pud)				0
 #define pud_present(pud)			1
 
-/*
- * All present pages with !NX bit are kernel-executable:
- */
-static inline int pte_exec_kernel(pte_t pte)
-{
-	return !(pte_val(pte) & _PAGE_NX);
-}
-
 /* Rules for using set_pte: the pte being assigned *must* be
  * either not present or in a state where the hardware will
  * not attempt to update the pte.  In places where this is
Index: linux/arch/x86/mm/fault_32.c
===================================================================
--- linux.orig/arch/x86/mm/fault_32.c
+++ linux/arch/x86/mm/fault_32.c
@@ -574,7 +574,7 @@ no_context:
 			int level;
 			pte_t *pte = lookup_address(address, &level);
 
-			if (pte && pte_present(*pte) && !pte_exec_kernel(*pte))
+			if (pte && pte_present(*pte) && !pte_exec(*pte))
 				printk(KERN_CRIT "kernel tried to execute "
 					"NX-protected page - exploit attempt? "
 					"(uid: %d)\n", current->uid);
