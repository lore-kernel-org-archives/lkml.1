Return-Path: <linux-kernel-owner+w=401wt.eu-S1754453AbYEWM6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453AbYEWM6p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 08:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752499AbYEWM6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 08:58:35 -0400
Received: from gw.goop.org ([64.81.55.164]:42500 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067AbYEWM6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 08:58:34 -0400
Message-ID: <4836BF57.2040501@goop.org>
Date: Fri, 23 May 2008 13:57:59 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Hugh Dickens <hugh@veritas.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] x86: use pteval_t for _PAGE_*
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than making _PAGE_* constants signed, and then relying on
sign-extension to make sure that masks derived from them are wide
enough, just explicitly type them pteval_t.  This guarantees that they
and any derived values are the right size for the current pte format.

The reliance on sign extension is fragile, and invokes some very
subtle corners of the C type system.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 include/asm-x86/pgtable.h |   49 ++++++++++++++++++++-------------------------
 1 file changed, 22 insertions(+), 27 deletions(-)

===================================================================
--- a/include/asm-x86/pgtable.h
+++ b/include/asm-x86/pgtable.h
@@ -20,30 +20,25 @@
 #define _PAGE_BIT_HIDDEN	11
 #define _PAGE_BIT_NX           63       /* No execute: only valid after cpuid check */
 
-/*
- * Note: we use _AC(1, L) instead of _AC(1, UL) so that we get a
- * sign-extended value on 32-bit with all 1's in the upper word,
- * which preserves the upper pte values on 64-bit ptes:
- */
-#define _PAGE_PRESENT	(_AC(1, L)<<_PAGE_BIT_PRESENT)
-#define _PAGE_RW	(_AC(1, L)<<_PAGE_BIT_RW)
-#define _PAGE_USER	(_AC(1, L)<<_PAGE_BIT_USER)
-#define _PAGE_PWT	(_AC(1, L)<<_PAGE_BIT_PWT)
-#define _PAGE_PCD	(_AC(1, L)<<_PAGE_BIT_PCD)
-#define _PAGE_ACCESSED	(_AC(1, L)<<_PAGE_BIT_ACCESSED)
-#define _PAGE_DIRTY	(_AC(1, L)<<_PAGE_BIT_DIRTY)
-#define _PAGE_PSE	(_AC(1, L)<<_PAGE_BIT_PSE)	/* 2MB page */
-#define _PAGE_GLOBAL	(_AC(1, L)<<_PAGE_BIT_GLOBAL)	/* Global TLB entry */
-#define _PAGE_UNUSED1	(_AC(1, L)<<_PAGE_BIT_UNUSED1)
-#define _PAGE_UNUSED2	(_AC(1, L)<<_PAGE_BIT_UNUSED2)
-#define _PAGE_PAT	(_AC(1, L)<<_PAGE_BIT_PAT)
-#define _PAGE_PAT_LARGE (_AC(1, L)<<_PAGE_BIT_PAT_LARGE)
-#define _PAGE_HIDDEN	(_AC(1, L)<<_PAGE_BIT_HIDDEN)
+#define _PAGE_PRESENT	(_AT(pteval_t, 1) << _PAGE_BIT_PRESENT)
+#define _PAGE_RW	(_AT(pteval_t, 1) << _PAGE_BIT_RW)
+#define _PAGE_USER	(_AT(pteval_t, 1) << _PAGE_BIT_USER)
+#define _PAGE_PWT	(_AT(pteval_t, 1) << _PAGE_BIT_PWT)
+#define _PAGE_PCD	(_AT(pteval_t, 1) << _PAGE_BIT_PCD)
+#define _PAGE_ACCESSED	(_AT(pteval_t, 1) << _PAGE_BIT_ACCESSED)
+#define _PAGE_DIRTY	(_AT(pteval_t, 1) << _PAGE_BIT_DIRTY)
+#define _PAGE_PSE	(_AT(pteval_t, 1) << _PAGE_BIT_PSE)
+#define _PAGE_GLOBAL	(_AT(pteval_t, 1) << _PAGE_BIT_GLOBAL)
+#define _PAGE_UNUSED1	(_AT(pteval_t, 1) << _PAGE_BIT_UNUSED1)
+#define _PAGE_UNUSED2	(_AT(pteval_t, 1) << _PAGE_BIT_UNUSED2)
+#define _PAGE_PAT	(_AT(pteval_t, 1) << _PAGE_BIT_PAT)
+#define _PAGE_PAT_LARGE (_AT(pteval_t, 1) << _PAGE_BIT_PAT_LARGE)
+#define _PAGE_HIDDEN	(_AT(pteval_t, 1) << _PAGE_BIT_HIDDEN)
 
 #if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
-#define _PAGE_NX	(_AC(1, ULL) << _PAGE_BIT_NX)
+#define _PAGE_NX	(_AT(pteval_t, 1) << _PAGE_BIT_NX)
 #else
-#define _PAGE_NX	0
+#define _PAGE_NX	(_AT(pteval_t, 0))
 #endif
 
 /* If _PAGE_PRESENT is clear, we use these: */
@@ -210,22 +205,22 @@
 
 static inline pte_t pte_mkclean(pte_t pte)
 {
-	return __pte(pte_val(pte) & ~(pteval_t)_PAGE_DIRTY);
+	return __pte(pte_val(pte) & ~_PAGE_DIRTY);
 }
 
 static inline pte_t pte_mkold(pte_t pte)
 {
-	return __pte(pte_val(pte) & ~(pteval_t)_PAGE_ACCESSED);
+	return __pte(pte_val(pte) & ~_PAGE_ACCESSED);
 }
 
 static inline pte_t pte_wrprotect(pte_t pte)
 {
-	return __pte(pte_val(pte) & ~(pteval_t)_PAGE_RW);
+	return __pte(pte_val(pte) & ~_PAGE_RW);
 }
 
 static inline pte_t pte_mkexec(pte_t pte)
 {
-	return __pte(pte_val(pte) & ~(pteval_t)_PAGE_NX);
+	return __pte(pte_val(pte) & ~_PAGE_NX);
 }
 
 static inline pte_t pte_mkdirty(pte_t pte)
@@ -250,7 +245,7 @@
 
 static inline pte_t pte_clrhuge(pte_t pte)
 {
-	return __pte(pte_val(pte) & ~(pteval_t)_PAGE_PSE);
+	return __pte(pte_val(pte) & ~_PAGE_PSE);
 }
 
 static inline pte_t pte_mkglobal(pte_t pte)
@@ -260,7 +255,7 @@
 
 static inline pte_t pte_clrglobal(pte_t pte)
 {
-	return __pte(pte_val(pte) & ~(pteval_t)_PAGE_GLOBAL);
+	return __pte(pte_val(pte) & ~_PAGE_GLOBAL);
 }
 
 static inline pte_t pte_mkspecial(pte_t pte)


