Return-Path: <linux-kernel-owner+w=401wt.eu-S1759415AbYADFlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759415AbYADFlw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 00:41:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754096AbYADFji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 00:39:38 -0500
Received: from gw.goop.org ([64.81.55.164]:48769 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753386AbYADFjf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 00:39:35 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 6 of 8] x86: page.h: move remaining bits and pieces
X-Mercurial-Node: bba9287641ff90e836d090d80b5c0a846aab7162
Message-Id: <bba9287641ff90e836d0.1199391063@localhost>
In-Reply-To: <patchbomb.1199391057@localhost>
Date: Thu, 03 Jan 2008 12:11:03 -0800
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
# Date 1199319657 28800
# Node ID bba9287641ff90e836d090d80b5c0a846aab7162
# Parent  d617b72a0cc9d14bde2087d065c36d4ed3265761
x86: page.h: move remaining bits and pieces

Move the remaining odds and ends into page.h.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

---
 include/asm-x86/page.h    |   23 +++++++++++++++++++++++
 include/asm-x86/page_32.h |   17 -----------------
 include/asm-x86/page_64.h |   13 -------------
 3 files changed, 23 insertions(+), 30 deletions(-)

diff --git a/include/asm-x86/page.h b/include/asm-x86/page.h
--- a/include/asm-x86/page.h
+++ b/include/asm-x86/page.h
@@ -80,6 +80,10 @@ void clear_page(void *page);
 void clear_page(void *page);
 void copy_page(void *to, void *from);
 
+extern unsigned long end_pfn;
+extern unsigned long end_pfn_map;
+extern unsigned long phys_base;
+
 extern unsigned long __phys_addr(unsigned long);
 #define __phys_reloc_hide(x)	(x)
 
@@ -97,6 +101,8 @@ typedef struct { pteval_t pte; } pte_t;
 
 #define native_pte_val(x)	((x).pte)
 #define native_make_pte(x) ((pte_t) { (x) } )
+
+#define vmemmap ((struct page *)VMEMMAP_START)
 
 #endif	/* !__ASSEMBLY__ */
 
@@ -183,6 +189,19 @@ static inline pte_t native_make_pte(unsi
 #ifdef CONFIG_FLATMEM
 #define pfn_valid(pfn)		((pfn) < max_mapnr)
 #endif /* CONFIG_FLATMEM */
+
+extern int nx_enabled;
+
+/*
+ * This much address space is reserved for vmalloc() and iomap()
+ * as well as fixmap mappings.
+ */
+extern unsigned int __VMALLOC_RESERVE;
+extern int sysctl_legacy_va_layout;
+extern int page_is_ram(unsigned long pagenr);
+
+#define VMALLOC_RESERVE		((unsigned long)__VMALLOC_RESERVE)
+#define MAXMEM			(-__PAGE_OFFSET-__VMALLOC_RESERVE)
 
 #ifdef CONFIG_X86_USE_3DNOW
 #include <asm/mmx.h>
@@ -325,6 +344,10 @@ static inline pmdval_t native_pmd_val(pm
 
 #endif	/* __ASSEMBLY__ */
 
+#include <asm-generic/memory_model.h>
+#include <asm-generic/page.h>
+
+#define __HAVE_ARCH_GATE_AREA 1
 
 #ifdef CONFIG_X86_32
 # include "page_32.h"
diff --git a/include/asm-x86/page_32.h b/include/asm-x86/page_32.h
--- a/include/asm-x86/page_32.h
+++ b/include/asm-x86/page_32.h
@@ -7,7 +7,6 @@
 /*
  * These are used to make use of C type-checking..
  */
-extern int nx_enabled;
 
 #endif /* !__ASSEMBLY__ */
 
@@ -15,26 +14,10 @@ extern int nx_enabled;
 
 struct vm_area_struct;
 
-/*
- * This much address space is reserved for vmalloc() and iomap()
- * as well as fixmap mappings.
- */
-extern unsigned int __VMALLOC_RESERVE;
-
-extern int sysctl_legacy_va_layout;
-
-extern int page_is_ram(unsigned long pagenr);
-
 #endif /* __ASSEMBLY__ */
 
-#define VMALLOC_RESERVE		((unsigned long)__VMALLOC_RESERVE)
-#define MAXMEM			(-__PAGE_OFFSET-__VMALLOC_RESERVE)
 
 
-#include <asm-generic/memory_model.h>
-#include <asm-generic/page.h>
-
-#define __HAVE_ARCH_GATE_AREA 1
 #endif /* __KERNEL__ */
 
 #endif /* _I386_PAGE_H */
diff --git a/include/asm-x86/page_64.h b/include/asm-x86/page_64.h
--- a/include/asm-x86/page_64.h
+++ b/include/asm-x86/page_64.h
@@ -4,25 +4,12 @@
 #ifdef __KERNEL__
 #ifndef __ASSEMBLY__
 
-extern unsigned long end_pfn;
-extern unsigned long end_pfn_map;
-
-
-extern unsigned long phys_base;
-
 #endif /* !__ASSEMBLY__ */
 
 #ifndef __ASSEMBLY__
 
-#include <asm/bug.h>
 
 #endif /* __ASSEMBLY__ */
-
-#define __HAVE_ARCH_GATE_AREA 1	
-#define vmemmap ((struct page *)VMEMMAP_START)
-
-#include <asm-generic/memory_model.h>
-#include <asm-generic/page.h>
 
 #endif /* __KERNEL__ */
 


