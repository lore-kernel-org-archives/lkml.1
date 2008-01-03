Return-Path: <linux-kernel-owner+w=401wt.eu-S1757525AbYADFj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525AbYADFj5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 00:39:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752951AbYADFjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 00:39:33 -0500
Received: from gw.goop.org ([64.81.55.164]:48754 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752650AbYADFjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 00:39:31 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 2 of 8] x86: page.h: unify page copying and clearing
X-Mercurial-Node: 4d9a413a0f4c1d98dbea704f0366457b5117045d
Message-Id: <4d9a413a0f4c1d98dbea.1199391059@localhost>
In-Reply-To: <patchbomb.1199391057@localhost>
Date: Thu, 03 Jan 2008 12:10:59 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

# HG changeset patch
# User Jeremy Fitzhardinge <jeremy@xensource.com>
# Date 1199317362 28800
# Node ID 4d9a413a0f4c1d98dbea704f0366457b5117045d
# Parent  ba0ec40a50a7aef1a3153cea124c35e261f5a2df
x86: page.h: unify page copying and clearing

Move, and to some extent unify, the various page copying and clearing
functions.  The only unification here is that both architectures use
the same function for copying/clearing user and kernel pages.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

---
 include/asm-x86/page.h    |   55 +++++++++++++++++++++++++++++++++++++++++++++
 include/asm-x86/page_32.h |   53 -------------------------------------------
 include/asm-x86/page_64.h |   20 ----------------
 3 files changed, 55 insertions(+), 73 deletions(-)

diff --git a/include/asm-x86/page.h b/include/asm-x86/page.h
--- a/include/asm-x86/page.h
+++ b/include/asm-x86/page.h
@@ -70,6 +70,11 @@
 #define KERNEL_TEXT_SIZE  (40*1024*1024)
 #define KERNEL_TEXT_START _AC(0xffffffff80000000, UL)
 
+#ifndef __ASSEMBLY__
+void clear_page(void *page);
+void copy_page(void *to, void *from);
+#endif	/* !__ASSEMBLY__ */
+
 #endif	/* CONFIG_X86_64 */
 
 #ifdef CONFIG_X86_32
@@ -98,6 +103,34 @@
 #define HAVE_ARCH_HUGETLB_UNMAPPED_AREA
 #endif
 
+#ifndef __ASSEMBLY__
+#ifdef CONFIG_X86_USE_3DNOW
+#include <asm/mmx.h>
+
+static inline void clear_page(void *page)
+{
+	mmx_clear_page(page);
+}
+
+static inline void copy_page(void *to, void *from)
+{
+	mmx_copy_page(to, from);
+}
+#else  /* !CONFIG_X86_USE_3DNOW */
+#include <linux/string.h>
+
+static inline void clear_page(void *page)
+{
+	memset(page, 0, PAGE_SIZE);
+}
+
+static inline void copy_page(void *to, void *from)
+{
+	memcpy(to, from, PAGE_SIZE);
+}
+#endif	/* CONFIG_X86_3DNOW */
+#endif	/* !__ASSEMBLY__ */
+
 #endif	/* CONFIG_X86_32 */
 
 #define PAGE_OFFSET		((unsigned long)__PAGE_OFFSET)
@@ -107,6 +140,28 @@
 	 VM_READ | VM_WRITE | VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
 
 
+#ifndef __ASSEMBLY__
+struct page;
+
+static void inline clear_user_page(void *page, unsigned long vaddr,
+				struct page *pg)
+{
+	clear_page(page);
+}
+
+static void inline copy_user_page(void *to, void *from, unsigned long vaddr,
+				struct page *topage)
+{
+	copy_page(to, from);
+}
+
+#define __alloc_zeroed_user_highpage(movableflags, vma, vaddr) \
+	alloc_page_vma(GFP_HIGHUSER | __GFP_ZERO | movableflags, vma, vaddr)
+#define __HAVE_ARCH_ALLOC_ZEROED_USER_HIGHPAGE
+
+#endif	/* __ASSEMBLY__ */
+
+
 #ifdef CONFIG_X86_32
 # include "page_32.h"
 #else
diff --git a/include/asm-x86/page_32.h b/include/asm-x86/page_32.h
--- a/include/asm-x86/page_32.h
+++ b/include/asm-x86/page_32.h
@@ -3,59 +3,6 @@
 
 #ifdef __KERNEL__
 #ifndef __ASSEMBLY__
-
-#include <linux/string.h>
-
-#ifdef CONFIG_X86_USE_3DNOW
-
-#include <asm/mmx.h>
-
-static inline void clear_page(void *page)
-{
-	mmx_clear_page(page);
-}
-
-static inline void copy_page(void *to, void *from)
-{
-	mmx_copy_page(to, from);
-}
-
-#else
-
-/*
- *	On older X86 processors it's not a win to use MMX here it seems.
- *	Maybe the K6-III ?
- */
- 
-static inline void clear_page(void *page)
-{
-	memset(page, 0, PAGE_SIZE);
-}
-
-static inline void copy_page(void *to, void *from)
-{
-	memcpy(to, from, PAGE_SIZE);
-}
-
-#endif
-
-struct page;
-
-static void inline clear_user_page(void *page, unsigned long vaddr,
-				struct page *pg)
-{
-	clear_page(page);
-}
-
-static void inline copy_user_page(void *to, void *from, unsigned long vaddr,
-				struct page *topage)
-{
-	copy_page(to, from);
-}
-
-#define __alloc_zeroed_user_highpage(movableflags, vma, vaddr) \
-	alloc_page_vma(GFP_HIGHUSER | __GFP_ZERO | movableflags, vma, vaddr)
-#define __HAVE_ARCH_ALLOC_ZEROED_USER_HIGHPAGE
 
 /*
  * These are used to make use of C type-checking..
diff --git a/include/asm-x86/page_64.h b/include/asm-x86/page_64.h
--- a/include/asm-x86/page_64.h
+++ b/include/asm-x86/page_64.h
@@ -7,26 +7,6 @@ extern unsigned long end_pfn;
 extern unsigned long end_pfn;
 extern unsigned long end_pfn_map;
 
-void clear_page(void *page);
-void copy_page(void *to, void *from);
-
-struct page;
-
-static void inline clear_user_page(void *page, unsigned long vaddr,
-				struct page *pg)
-{
-	clear_page(page);
-}
-
-static void inline copy_user_page(void *to, void *from, unsigned long vaddr,
-				struct page *topage)
-{
-	copy_page(to, from);
-}
-
-#define __alloc_zeroed_user_highpage(movableflags, vma, vaddr) \
-	alloc_page_vma(GFP_HIGHUSER | __GFP_ZERO | movableflags, vma, vaddr)
-#define __HAVE_ARCH_ALLOC_ZEROED_USER_HIGHPAGE
 /*
  * These are used to make use of C type-checking..
  */


