Return-Path: <linux-kernel-owner+w=401wt.eu-S1763565AbYEOR44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763565AbYEOR44 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 13:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763214AbYEOR4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 13:56:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50216 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763136AbYEOR4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 13:56:01 -0400
Message-Id: <20080515175431.177313424@redhat.com>
References: <20080515175357.636334082@redhat.com>
User-Agent: quilt/0.46-1
Date: Thu, 15 May 2008 13:54:01 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, ajackson@redhat.com, airlied@redhat.com,
       benh@kernel.crashing.org
Subject: [patch 4/5] powerpc ioremap_prot
Content-Disposition: inline; filename=04-powerpc-ioremap_prot.patch
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

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Rik van Riel <riel@redhat.com>
---

Index: ptrace-2.6.26-rc2-mm1/arch/powerpc/mm/pgtable_32.c
===================================================================
--- ptrace-2.6.26-rc2-mm1.orig/arch/powerpc/mm/pgtable_32.c	2008-05-15 13:16:51.000000000 -0400
+++ ptrace-2.6.26-rc2-mm1/arch/powerpc/mm/pgtable_32.c	2008-05-15 13:17:21.000000000 -0400
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
Index: ptrace-2.6.26-rc2-mm1/arch/powerpc/mm/pgtable_64.c
===================================================================
--- ptrace-2.6.26-rc2-mm1.orig/arch/powerpc/mm/pgtable_64.c	2008-05-15 13:16:51.000000000 -0400
+++ ptrace-2.6.26-rc2-mm1/arch/powerpc/mm/pgtable_64.c	2008-05-15 13:17:21.000000000 -0400
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
Index: ptrace-2.6.26-rc2-mm1/include/asm-powerpc/io.h
===================================================================
--- ptrace-2.6.26-rc2-mm1.orig/include/asm-powerpc/io.h	2008-05-15 13:16:51.000000000 -0400
+++ ptrace-2.6.26-rc2-mm1/include/asm-powerpc/io.h	2008-05-15 13:17:21.000000000 -0400
@@ -588,7 +588,8 @@ static inline void iosync(void)
  *   and can be hooked by the platform via ppc_md
  *
  * * ioremap_flags allows to specify the page flags as an argument and can
- *   also be hooked by the platform via ppc_md
+ *   also be hooked by the platform via ppc_md. ioremap_prot is the exact
+ *   same thing as ioremap_flags.
  *
  * * ioremap_nocache is identical to ioremap
  *
@@ -610,6 +611,8 @@ extern void __iomem *ioremap(phys_addr_t
 extern void __iomem *ioremap_flags(phys_addr_t address, unsigned long size,
 				   unsigned long flags);
 #define ioremap_nocache(addr, size)	ioremap((addr), (size))
+#define ioremap_prot(addr, size, prot)	ioremap_flags((addr), (size), (prot))
+
 extern void iounmap(volatile void __iomem *addr);
 
 extern void __iomem *__ioremap(phys_addr_t, unsigned long size,
Index: ptrace-2.6.26-rc2-mm1/include/asm-powerpc/pgtable-ppc32.h
===================================================================
--- ptrace-2.6.26-rc2-mm1.orig/include/asm-powerpc/pgtable-ppc32.h	2008-05-15 13:16:51.000000000 -0400
+++ ptrace-2.6.26-rc2-mm1/include/asm-powerpc/pgtable-ppc32.h	2008-05-15 13:21:47.000000000 -0400
@@ -388,6 +388,12 @@ extern int icache_44x_need_flush;
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
@@ -398,6 +404,12 @@ extern int icache_44x_need_flush;
 
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
@@ -531,6 +543,10 @@ static inline pte_t pte_mkyoung(pte_t pt
 	pte_val(pte) |= _PAGE_ACCESSED; return pte; }
 static inline pte_t pte_mkspecial(pte_t pte) {
 	return pte; }
+static inline unsigned long pte_pgprot(pte_t pte)
+{
+	return __pgprot(pte_val(pte)) & PAGE_PROT_BITS;
+}
 
 static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
 {
Index: ptrace-2.6.26-rc2-mm1/include/asm-powerpc/pgtable-ppc64.h
===================================================================
--- ptrace-2.6.26-rc2-mm1.orig/include/asm-powerpc/pgtable-ppc64.h	2008-05-15 13:16:51.000000000 -0400
+++ ptrace-2.6.26-rc2-mm1/include/asm-powerpc/pgtable-ppc64.h	2008-05-15 13:21:59.000000000 -0400
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
@@ -260,6 +264,10 @@ static inline pte_t pte_mkhuge(pte_t pte
 	return pte; }
 static inline pte_t pte_mkspecial(pte_t pte) {
 	return pte; }
+static inline unsigned long pte_pgprot(pte_t pte)
+{
+	return __pgprot(pte_val(pte)) & PAGE_PROT_BITS;
+}
 
 /* Atomic PTE updates */
 static inline unsigned long pte_update(struct mm_struct *mm,
Index: ptrace-2.6.26-rc2-mm1/include/asm-powerpc/pgtable-4k.h
===================================================================
--- ptrace-2.6.26-rc2-mm1.orig/include/asm-powerpc/pgtable-4k.h	2008-05-15 13:16:51.000000000 -0400
+++ ptrace-2.6.26-rc2-mm1/include/asm-powerpc/pgtable-4k.h	2008-05-15 13:17:21.000000000 -0400
@@ -50,6 +50,9 @@
 #define _PAGE_HPTEFLAGS (_PAGE_BUSY | _PAGE_HASHPTE | \
 			 _PAGE_SECONDARY | _PAGE_GROUP_IX)
 
+/* There is no 4K PFN hack on 4K pages */
+#define _PAGE_4K_PFN	0
+
 /* PAGE_MASK gives the right answer below, but only by accident */
 /* It should be preserving the high 48 bits and then specifically */
 /* preserving _PAGE_SECONDARY | _PAGE_GROUP_IX */
Index: ptrace-2.6.26-rc2-mm1/arch/powerpc/Kconfig
===================================================================
--- ptrace-2.6.26-rc2-mm1.orig/arch/powerpc/Kconfig	2008-05-15 13:16:51.000000000 -0400
+++ ptrace-2.6.26-rc2-mm1/arch/powerpc/Kconfig	2008-05-15 13:17:21.000000000 -0400
@@ -111,6 +111,7 @@ config PPC
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
 	select HAVE_LMB
+	select HAVE_IOREMAP_PROT
 
 config EARLY_PRINTK
 	bool

-- 
All Rights Reversed

