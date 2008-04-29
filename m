Return-Path: <linux-kernel-owner+w=401wt.eu-S933678AbYD2Pi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933678AbYD2Pi3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 11:38:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762749AbYD2Ph4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 11:37:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34256 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761256AbYD2Phy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 11:37:54 -0400
Date: Tue, 29 Apr 2008 11:33:48 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, ajackson@redhat.com, airlied@redhat.com,
       benh@kernel.crashing.org
Subject: [PATCH 2/3] powerpc ioremap_prot
Message-ID: <20080429113348.3f132ebc@cuia.boston.redhat.com>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds ioremap_prot and pte_pgprot() so that one can extract
protection bits from a PTE and use them to ioremap_prot() (in
order to support ptrace of VM_IO | VM_PFNMAP as per Rik's patch).

This moves a couple of flag checks around in the ioremap
implementations of arch/powerpc. There's a side effect of allowing
non-cacheable and non-guarded mappings on ppc32 which before would
always have _PAGE_GUARDED set whenever _PAGE_NO_CACHE is.

(standard ioremap will still set _PAGE_GUARDED, but ioremap_prot
will be capable of setting such a non guarded mapping).

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

Index: linux-work/arch/powerpc/mm/pgtable_32.c
===================================================================
--- linux-work.orig/arch/powerpc/mm/pgtable_32.c	2008-04-29 10:08:34.000000000 +1000
+++ linux-work/arch/powerpc/mm/pgtable_32.c	2008-04-29 15:23:02.000000000 +1000
@@ -145,13 +145,20 @@ void pte_free(struct mm_struct *mm, pgta
 void __iomem *
 ioremap(phys_addr_t addr, unsigned long size)
 {
-	return __ioremap(addr, size, _PAGE_NO_CACHE);
+	return __ioremap(addr, size, _PAGE_NO_CACHE | _PAGE_GUARDED);
 }
 EXPORT_SYMBOL(ioremap);
 
 void __iomem *
 ioremap_flags(phys_addr_t addr, unsigned long size, unsigned long flags)
 {
+	/* writeable implies dirty for kernel addresses */
+	if (flags & _PAGE_RW)
+		flags |= _PAGE_DIRTY | _PAGE_HWWRITE;
+
+	/* we don't want to let _PAGE_USER and _PAGE_EXEC leak out */
+	flags &= ~(_PAGE_USER | _PAGE_EXEC | _PAGE_HWEXEC);
+
 	return __ioremap(addr, size, flags);
 }
 EXPORT_SYMBOL(ioremap_flags);
@@ -163,6 +170,14 @@ __ioremap(phys_addr_t addr, unsigned lon
 	phys_addr_t p;
 	int err;
 
+	/* Make sure we have the base flags */
+	if ((flags & _PAGE_PRESENT) == 0)
+		flags |= _PAGE_KERNEL;
+
+	/* Non-cacheable page cannot be coherent */
+	if (flags & _PAGE_NO_CACHE)
+		flags &= ~_PAGE_COHERENT;
+
 	/*
 	 * Choose an address to map it to.
 	 * Once the vmalloc system is running, we use it.
@@ -219,11 +234,6 @@ __ioremap(phys_addr_t addr, unsigned lon
 		v = (ioremap_bot -= size);
 	}
 
-	if ((flags & _PAGE_PRESENT) == 0)
-		flags |= _PAGE_KERNEL;
-	if (flags & _PAGE_NO_CACHE)
-		flags |= _PAGE_GUARDED;
-
 	/*
 	 * Should check if it is a candidate for a BAT mapping
 	 */
Index: linux-work/arch/powerpc/mm/pgtable_64.c
===================================================================
--- linux-work.orig/arch/powerpc/mm/pgtable_64.c	2008-03-03 11:58:41.000000000 +1100
+++ linux-work/arch/powerpc/mm/pgtable_64.c	2008-04-29 15:24:18.000000000 +1000
@@ -107,9 +107,18 @@ void __iomem * __ioremap_at(phys_addr_t 
 {
 	unsigned long i;
 
+	/* Make sure we have the base flags */
 	if ((flags & _PAGE_PRESENT) == 0)
 		flags |= pgprot_val(PAGE_KERNEL);
 
+	/* Non-cacheable page cannot be coherent */
+	if (flags & _PAGE_NO_CACHE)
+		flags &= ~_PAGE_COHERENT;
+
+	/* We don't support the 4K PFN hack with ioremap */
+	if (flags & _PAGE_4K_PFN)
+		return NULL;
+
 	WARN_ON(pa & ~PAGE_MASK);
 	WARN_ON(((unsigned long)ea) & ~PAGE_MASK);
 	WARN_ON(size & ~PAGE_MASK);
@@ -190,6 +199,13 @@ void __iomem * ioremap(phys_addr_t addr,
 void __iomem * ioremap_flags(phys_addr_t addr, unsigned long size,
 			     unsigned long flags)
 {
+	/* writeable implies dirty for kernel addresses */
+	if (flags & _PAGE_RW)
+		flags |= _PAGE_DIRTY;
+
+	/* we don't want to let _PAGE_USER and _PAGE_EXEC leak out */
+	flags &= ~(_PAGE_USER | _PAGE_EXEC);
+
 	if (ppc_md.ioremap)
 		return ppc_md.ioremap(addr, size, flags);
 	return __ioremap(addr, size, flags);
Index: linux-work/include/asm-powerpc/io.h
===================================================================
--- linux-work.orig/include/asm-powerpc/io.h	2008-04-29 10:08:39.000000000 +1000
+++ linux-work/include/asm-powerpc/io.h	2008-04-29 13:21:00.000000000 +1000
@@ -585,7 +585,8 @@ static inline void iosync(void)
  *   and can be hooked by the platform via ppc_md
  *
  * * ioremap_flags allows to specify the page flags as an argument and can
- *   also be hooked by the platform via ppc_md
+ *   also be hooked by the platform via ppc_md. ioremap_prot is the exact
+ *   same thing as ioremap_flags.
  *
  * * ioremap_nocache is identical to ioremap
  *
@@ -607,6 +608,9 @@ extern void __iomem *ioremap(phys_addr_t
 extern void __iomem *ioremap_flags(phys_addr_t address, unsigned long size,
 				   unsigned long flags);
 #define ioremap_nocache(addr, size)	ioremap((addr), (size))
+#define ioremap_prot(addr, size, prot)	ioremap_flags((addr), (size), (prot))
+#define _HAVE_ARCH_IOREMAP_PROT		1
+
 extern void iounmap(volatile void __iomem *addr);
 
 extern void __iomem *__ioremap(phys_addr_t, unsigned long size,
Index: linux-work/include/asm-powerpc/pgtable-ppc32.h
===================================================================
--- linux-work.orig/include/asm-powerpc/pgtable-ppc32.h	2008-04-29 10:08:39.000000000 +1000
+++ linux-work/include/asm-powerpc/pgtable-ppc32.h	2008-04-29 13:04:03.000000000 +1000
@@ -381,6 +381,12 @@ extern int icache_44x_need_flush;
 #ifndef _PAGE_EXEC
 #define _PAGE_EXEC	0
 #endif
+#ifndef _PAGE_ENDIAN
+#define _PAGE_ENDIAN	0
+#endif
+#ifndef _PAGE_COHERENT
+#define _PAGE_COHERENT	0
+#endif
 #ifndef _PMD_PRESENT_MASK
 #define _PMD_PRESENT_MASK	_PMD_PRESENT
 #endif
@@ -391,6 +397,12 @@ extern int icache_44x_need_flush;
 
 #define _PAGE_CHG_MASK	(PAGE_MASK | _PAGE_ACCESSED | _PAGE_DIRTY)
 
+
+#define PAGE_PROT_BITS	__pgprot(_PAGE_GUARDED | _PAGE_COHERENT | _PAGE_NO_CACHE | \
+				 _PAGE_WRITETHRU | _PAGE_ENDIAN | \
+				 _PAGE_USER | _PAGE_ACCESSED | \
+				 _PAGE_RW | _PAGE_HWWRITE | _PAGE_DIRTY | \
+				 _PAGE_EXEC | _PAGE_HWEXEC)
 /*
  * Note: the _PAGE_COHERENT bit automatically gets set in the hardware
  * PTE if CONFIG_SMP is defined (hash_page does this); there is no need
@@ -524,6 +536,8 @@ static inline pte_t pte_mkyoung(pte_t pt
 	pte_val(pte) |= _PAGE_ACCESSED; return pte; }
 static inline pte_t pte_mkspecial(pte_t pte) {
 	return pte; }
+static inline unsigned long pte_pgprot(pte_t pte) {
+	return __pgprot(pte_val(pte)) & PAGE_PROT_BITS; }
 
 static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
 {
Index: linux-work/include/asm-powerpc/pgtable-ppc64.h
===================================================================
--- linux-work.orig/include/asm-powerpc/pgtable-ppc64.h	2008-04-29 10:08:39.000000000 +1000
+++ linux-work/include/asm-powerpc/pgtable-ppc64.h	2008-04-29 15:20:22.000000000 +1000
@@ -115,6 +115,10 @@
 #define PAGE_AGP	__pgprot(_PAGE_BASE | _PAGE_WRENABLE | _PAGE_NO_CACHE)
 #define HAVE_PAGE_AGP
 
+#define PAGE_PROT_BITS	__pgprot(_PAGE_GUARDED | _PAGE_COHERENT | \
+				 _PAGE_NO_CACHE | _PAGE_WRITETHRU | \
+				 _PAGE_4K_PFN | _PAGE_RW | _PAGE_USER | \
+ 				 _PAGE_ACCESSED | _PAGE_DIRTY | _PAGE_EXEC)
 /* PTEIDX nibble */
 #define _PTEIDX_SECONDARY	0x8
 #define _PTEIDX_GROUP_IX	0x7
@@ -260,6 +264,8 @@ static inline pte_t pte_mkhuge(pte_t pte
 	return pte; }
 static inline pte_t pte_mkspecial(pte_t pte) {
 	return pte; }
+static inline unsigned long pte_pgprot(pte_t pte) {
+	return __pgprot(pte_val(pte)) & PAGE_PROT_BITS; }
 
 /* Atomic PTE updates */
 static inline unsigned long pte_update(struct mm_struct *mm,
Index: linux-work/include/asm-powerpc/pgtable-4k.h
===================================================================
--- linux-work.orig/include/asm-powerpc/pgtable-4k.h	2008-04-29 15:19:34.000000000 +1000
+++ linux-work/include/asm-powerpc/pgtable-4k.h	2008-04-29 15:19:51.000000000 +1000
@@ -50,6 +50,9 @@
 #define _PAGE_HPTEFLAGS (_PAGE_BUSY | _PAGE_HASHPTE | \
 			 _PAGE_SECONDARY | _PAGE_GROUP_IX)
 
+/* There is no 4K PFN hack on 4K pages */
+#define _PAGE_4K_PFN	0
+
 /* PAGE_MASK gives the right answer below, but only by accident */
 /* It should be preserving the high 48 bits and then specifically */
 /* preserving _PAGE_SECONDARY | _PAGE_GROUP_IX */



-- 
All Rights Reversed
