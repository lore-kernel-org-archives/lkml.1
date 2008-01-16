Return-Path: <linux-kernel-owner+w=401wt.eu-S1756936AbYAPW1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756936AbYAPW1z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 17:27:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754507AbYAPWPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 17:15:53 -0500
Received: from mx1.suse.de ([195.135.220.2]:55301 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754234AbYAPWPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 17:15:37 -0500
From: Andi Kleen <ak@suse.de>
References: <200801161114.239449000@suse.de>
In-Reply-To: <200801161114.239449000@suse.de>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       jbeulich@novell.com, venkatesh.pallipadi@intel.com
Subject: [PATCH] [36/36] Clean up pte_exec
Message-Id: <20080116221536.A5FE7150C8@wotan.suse.de>
Date: Wed, 16 Jan 2008 23:15:36 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


- Rename it to pte_exec() from pte_exec_kernel(). There is nothing
kernel specific in there.
- Move it into the common file because _PAGE_NX is 0 on !PAE and then
pte_exec() will be always evaluate to true.

Signed-off-by: Andi Kleen <ak@suse.de>
Acked-by: Jan Beulich <jbeulich@novell.com>

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
@@ -153,6 +153,7 @@ static inline int pte_write(pte_t pte)		
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
@@ -618,7 +618,7 @@ no_context:
 			int level;
 			pte_t *pte = lookup_address(address, &level);
 
-			if (pte && pte_present(*pte) && !pte_exec_kernel(*pte))
+			if (pte && pte_present(*pte) && !pte_exec(*pte))
 				printk(KERN_CRIT "kernel tried to execute "
 					"NX-protected page - exploit attempt? "
 					"(uid: %d)\n", current->uid);
