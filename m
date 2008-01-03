Return-Path: <linux-kernel-owner+w=401wt.eu-S1757988AbYADFkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757988AbYADFkZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 00:40:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbYADFje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 00:39:34 -0500
Received: from gw.goop.org ([64.81.55.164]:48757 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752728AbYADFjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 00:39:31 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 5 of 8] x86: page.h: move pa and va related things
X-Mercurial-Node: d617b72a0cc9d14bde2087d065c36d4ed3265761
Message-Id: <d617b72a0cc9d14bde20.1199391062@localhost>
In-Reply-To: <patchbomb.1199391057@localhost>
Date: Thu, 03 Jan 2008 12:11:02 -0800
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
# Date 1199319656 28800
# Node ID d617b72a0cc9d14bde2087d065c36d4ed3265761
# Parent  3bd7db6e85e66e7f3362874802df26a82fcb2d92
x86: page.h: move pa and va related things

Move and unify the virtual<->physical address space conversion
functions.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

---
 include/asm-x86/page.h    |   24 ++++++++++++++++++++++++
 include/asm-x86/page_32.h |   11 -----------
 include/asm-x86/page_64.h |   13 -------------
 3 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/include/asm-x86/page.h b/include/asm-x86/page.h
--- a/include/asm-x86/page.h
+++ b/include/asm-x86/page.h
@@ -79,6 +79,9 @@
 #ifndef __ASSEMBLY__
 void clear_page(void *page);
 void copy_page(void *to, void *from);
+
+extern unsigned long __phys_addr(unsigned long);
+#define __phys_reloc_hide(x)	(x)
 
 /*
  * These are used to make use of C type-checking..
@@ -174,6 +177,13 @@ static inline pte_t native_make_pte(unsi
 #endif
 
 #ifndef __ASSEMBLY__
+#define __phys_addr(x)		((x)-PAGE_OFFSET)
+#define __phys_reloc_hide(x)	RELOC_HIDE((x), 0)
+
+#ifdef CONFIG_FLATMEM
+#define pfn_valid(pfn)		((pfn) < max_mapnr)
+#endif /* CONFIG_FLATMEM */
+
 #ifdef CONFIG_X86_USE_3DNOW
 #include <asm/mmx.h>
 
@@ -299,6 +309,20 @@ static inline pmdval_t native_pmd_val(pm
 
 #endif	/* CONFIG_PARAVIRT */
 
+#define __pa(x)		__phys_addr((unsigned long)(x))
+/* __pa_symbol should be used for C visible symbols.
+   This seems to be the official gcc blessed way to do such arithmetic. */
+#define __pa_symbol(x)	__pa(__phys_reloc_hide((unsigned long)(x)))
+
+#define __va(x)			((void *)((unsigned long)(x)+PAGE_OFFSET))
+
+#define __boot_va(x)		__va(x)
+#define __boot_pa(x)		__pa(x)
+
+#define virt_to_page(kaddr)	pfn_to_page(__pa(kaddr) >> PAGE_SHIFT)
+#define pfn_to_kaddr(pfn)      __va((pfn) << PAGE_SHIFT)
+#define virt_addr_valid(kaddr)	pfn_valid(__pa(kaddr) >> PAGE_SHIFT)
+
 #endif	/* __ASSEMBLY__ */
 
 
diff --git a/include/asm-x86/page_32.h b/include/asm-x86/page_32.h
--- a/include/asm-x86/page_32.h
+++ b/include/asm-x86/page_32.h
@@ -29,18 +29,7 @@ extern int page_is_ram(unsigned long pag
 
 #define VMALLOC_RESERVE		((unsigned long)__VMALLOC_RESERVE)
 #define MAXMEM			(-__PAGE_OFFSET-__VMALLOC_RESERVE)
-#define __pa(x)			((unsigned long)(x)-PAGE_OFFSET)
-/* __pa_symbol should be used for C visible symbols.
-   This seems to be the official gcc blessed way to do such arithmetic. */
-#define __pa_symbol(x)          __pa(RELOC_HIDE((unsigned long)(x),0))
-#define __va(x)			((void *)((unsigned long)(x)+PAGE_OFFSET))
-#define pfn_to_kaddr(pfn)      __va((pfn) << PAGE_SHIFT)
-#ifdef CONFIG_FLATMEM
-#define pfn_valid(pfn)		((pfn) < max_mapnr)
-#endif /* CONFIG_FLATMEM */
-#define virt_to_page(kaddr)	pfn_to_page(__pa(kaddr) >> PAGE_SHIFT)
 
-#define virt_addr_valid(kaddr)	pfn_valid(__pa(kaddr) >> PAGE_SHIFT)
 
 #include <asm-generic/memory_model.h>
 #include <asm-generic/page.h>
diff --git a/include/asm-x86/page_64.h b/include/asm-x86/page_64.h
--- a/include/asm-x86/page_64.h
+++ b/include/asm-x86/page_64.h
@@ -16,20 +16,7 @@ extern unsigned long phys_base;
 
 #include <asm/bug.h>
 
-extern unsigned long __phys_addr(unsigned long);
-
 #endif /* __ASSEMBLY__ */
-
-#define __pa(x)		__phys_addr((unsigned long)(x))
-#define __pa_symbol(x)	__phys_addr((unsigned long)(x))
-
-#define __va(x)			((void *)((unsigned long)(x)+PAGE_OFFSET))
-#define __boot_va(x)		__va(x)
-#define __boot_pa(x)		__pa(x)
-
-#define virt_to_page(kaddr)	pfn_to_page(__pa(kaddr) >> PAGE_SHIFT)
-#define virt_addr_valid(kaddr)	pfn_valid(__pa(kaddr) >> PAGE_SHIFT)
-#define pfn_to_kaddr(pfn)      __va((pfn) << PAGE_SHIFT)
 
 #define __HAVE_ARCH_GATE_AREA 1	
 #define vmemmap ((struct page *)VMEMMAP_START)


