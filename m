Return-Path: <linux-kernel-owner+w=401wt.eu-S1756255AbYANWSZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255AbYANWSZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 17:18:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753621AbYANWQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 17:16:39 -0500
Received: from cantor.suse.de ([195.135.220.2]:59629 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751593AbYANWQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 17:16:38 -0500
From: Andi Kleen <ak@suse.de>
References: <200801141116.534682000@suse.de>
In-Reply-To: <200801141116.534682000@suse.de>
To: linux-kernel@vger.kernel.org, jbeulich@novell.com, mingo@elte.hu,
       tglx@linutronix.de
Subject: [PATCH] [5/31] Don't drop NX bit in pte modifier functions for 32bit
Message-Id: <20080114221637.13BCA14F83@wotan.suse.de>
Date: Mon, 14 Jan 2008 23:16:37 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The pte_* modifier functions that cleared bits dropped the NX bit on 32bit
PAE because they only worked in int, but NX is in bit 63. Fix that
by adding appropiate casts so that the arithmetic happens as long long
on PAE kernels.

I decided to just use 64bit arithmetic instead of open coding like
pte_modify() because gcc should generate good enough code for that now.

While this looks in theory like a .24 candidate this might trigger
some subtle latent bugs so it's better to delay it for .25 for more
testing.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 include/asm-x86/pgtable.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: linux/include/asm-x86/pgtable.h
===================================================================
--- linux.orig/include/asm-x86/pgtable.h
+++ linux/include/asm-x86/pgtable.h
@@ -141,17 +141,17 @@ static inline int pmd_large(pmd_t pte) {
 		(_PAGE_PSE|_PAGE_PRESENT);
 }
 
-static inline pte_t pte_mkclean(pte_t pte)	{ return __pte(pte_val(pte) & ~_PAGE_DIRTY); }
-static inline pte_t pte_mkold(pte_t pte)	{ return __pte(pte_val(pte) & ~_PAGE_ACCESSED); }
-static inline pte_t pte_wrprotect(pte_t pte)	{ return __pte(pte_val(pte) & ~_PAGE_RW); }
-static inline pte_t pte_mkexec(pte_t pte)	{ return __pte(pte_val(pte) & ~_PAGE_NX); }
+static inline pte_t pte_mkclean(pte_t pte)	{ return __pte(pte_val(pte) & ~(pteval_t)_PAGE_DIRTY); }
+static inline pte_t pte_mkold(pte_t pte)	{ return __pte(pte_val(pte) & ~(pteval_t)_PAGE_ACCESSED); }
+static inline pte_t pte_wrprotect(pte_t pte)	{ return __pte(pte_val(pte) & ~(pteval_t)_PAGE_RW); }
+static inline pte_t pte_mkexec(pte_t pte)	{ return __pte(pte_val(pte) & ~(pteval_t)_PAGE_NX); }
 static inline pte_t pte_mkdirty(pte_t pte)	{ return __pte(pte_val(pte) | _PAGE_DIRTY); }
 static inline pte_t pte_mkyoung(pte_t pte)	{ return __pte(pte_val(pte) | _PAGE_ACCESSED); }
 static inline pte_t pte_mkwrite(pte_t pte)	{ return __pte(pte_val(pte) | _PAGE_RW); }
 static inline pte_t pte_mkhuge(pte_t pte)	{ return __pte(pte_val(pte) | _PAGE_PSE); }
-static inline pte_t pte_clrhuge(pte_t pte)	{ return __pte(pte_val(pte) & ~_PAGE_PSE); }
+static inline pte_t pte_clrhuge(pte_t pte)	{ return __pte(pte_val(pte) & ~(pteval_t)_PAGE_PSE); }
 static inline pte_t pte_mkglobal(pte_t pte)	{ return __pte(pte_val(pte) | _PAGE_GLOBAL); }
-static inline pte_t pte_clrglobal(pte_t pte)	{ return __pte(pte_val(pte) & ~_PAGE_GLOBAL); }
+static inline pte_t pte_clrglobal(pte_t pte)	{ return __pte(pte_val(pte) & ~(pteval_t)_PAGE_GLOBAL); }
 
 extern pteval_t __supported_pte_mask;
 
