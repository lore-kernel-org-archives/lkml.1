Return-Path: <linux-kernel-owner+w=401wt.eu-S965158AbXD3Kau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965158AbXD3Kau (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 06:30:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965550AbXD3K2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 06:28:55 -0400
Received: from mx1.suse.de ([195.135.220.2]:51206 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754652AbXD3K14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 06:27:56 -0400
From: Andi Kleen <ak@suse.de>
References: <200704301227.598020000@suse.de>
In-Reply-To: <200704301227.598020000@suse.de>
To: jeremy@goop.org, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [21/40] i386: drop unused ptep_get_and_clear
Message-Id: <20070430102755.24114151CA@wotan.suse.de>
Date: Mon, 30 Apr 2007 12:27:55 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Jeremy Fitzhardinge <jeremy@goop.org>
In shadow mode hypervisors, ptep_get_and_clear achieves the desired
purpose of keeping the shadows in sync by issuing a native_get_and_clear,
followed by a call to pte_update, which indicates the PTE has been
modified.

Direct mode hypervisors (Xen) have no need for this anyway, and will trap
the update using writable pagetables.

This means no hypervisor makes use of ptep_get_and_clear; there is no
reason to have it in the paravirt-ops structure.  Change confusing
terminology about raw vs. native functions into consistent use of
native_pte_xxx for operations which do not invoke paravirt-ops.

Signed-off-by: Zachary Amsden <zach@vmware.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/kernel/paravirt.c |    2 --
 include/asm-i386/paravirt.h |   13 +------------
 include/asm-i386/pgtable.h  |    4 +---
 3 files changed, 2 insertions(+), 17 deletions(-)

===================================================================
Index: linux/arch/i386/kernel/paravirt.c
===================================================================
--- linux.orig/arch/i386/kernel/paravirt.c
+++ linux/arch/i386/kernel/paravirt.c
@@ -315,8 +315,6 @@ struct paravirt_ops paravirt_ops = {
 	.pte_update = paravirt_nop,
 	.pte_update_defer = paravirt_nop,
 
-	.ptep_get_and_clear = native_ptep_get_and_clear,
-
 #ifdef CONFIG_HIGHPTE
 	.kmap_atomic_pte = kmap_atomic,
 #endif
Index: linux/include/asm-i386/paravirt.h
===================================================================
--- linux.orig/include/asm-i386/paravirt.h
+++ linux/include/asm-i386/paravirt.h
@@ -188,8 +188,6 @@ struct paravirt_ops
 	void (*pte_update_defer)(struct mm_struct *mm,
 				 unsigned long addr, pte_t *ptep);
 
- 	pte_t (*ptep_get_and_clear)(pte_t *ptep);
-
 #ifdef CONFIG_HIGHPTE
 	void *(*kmap_atomic_pte)(struct page *page, enum km_type type);
 #endif
@@ -859,12 +857,8 @@ static inline void pmd_clear(pmd_t *pmdp
 	PVOP_VCALL1(pmd_clear, pmdp);
 }
 
-static inline pte_t raw_ptep_get_and_clear(pte_t *p)
-{
-	unsigned long long val = PVOP_CALL1(unsigned long long, ptep_get_and_clear, p);
-	return (pte_t) { val, val >> 32 };
-}
 #else  /* !CONFIG_X86_PAE */
+
 static inline pte_t __pte(unsigned long val)
 {
 	return (pte_t) { PVOP_CALL1(unsigned long, make_pte, val) };
@@ -900,11 +894,6 @@ static inline void set_pmd(pmd_t *pmdp, 
 {
 	PVOP_VCALL2(set_pmd, pmdp, pmdval.pud.pgd.pgd);
 }
-
-static inline pte_t raw_ptep_get_and_clear(pte_t *p)
-{
-	return (pte_t) { PVOP_CALL1(unsigned long, ptep_get_and_clear, p) };
-}
 #endif	/* CONFIG_X86_PAE */
 
 #define  __HAVE_ARCH_ENTER_LAZY_CPU_MODE
Index: linux/include/asm-i386/pgtable.h
===================================================================
--- linux.orig/include/asm-i386/pgtable.h
+++ linux/include/asm-i386/pgtable.h
@@ -267,8 +267,6 @@ extern void vmalloc_sync_all(void);
  */
 #define pte_update(mm, addr, ptep)		do { } while (0)
 #define pte_update_defer(mm, addr, ptep)	do { } while (0)
-
-#define raw_ptep_get_and_clear(xp)     native_ptep_get_and_clear(xp)
 #endif
 
 /*
@@ -335,7 +333,7 @@ do {									\
 #define __HAVE_ARCH_PTEP_GET_AND_CLEAR
 static inline pte_t ptep_get_and_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
 {
-	pte_t pte = raw_ptep_get_and_clear(ptep);
+	pte_t pte = native_ptep_get_and_clear(ptep);
 	pte_update(mm, addr, ptep);
 	return pte;
 }
