Return-Path: <linux-kernel-owner+w=401wt.eu-S1758164AbYAPCmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758164AbYAPCmn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 21:42:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758029AbYAPClg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 21:41:36 -0500
Received: from mga03.intel.com ([143.182.124.21]:20057 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756484AbYAPClN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 21:41:13 -0500
X-ExtLoop1: 1
Message-Id: <20080116024111.611171000@intel.com>
References: <20080116023955.597433000@intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 15 Jan 2008 18:39:56 -0800
From: venkatesh.pallipadi@intel.com
To: ak@muc.de, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, gregkh@suse.de, airlied@skynet.ie,
       davej@redhat.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com,
       davem@davemloft.net
Cc: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 1/4] x86: PAT followup - Do not fold two bits in _PAGE_PCD
Content-Disposition: inline; filename=page_uc.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not fold PCD and PWT bits in _PAGE_PCD. Instead, introduce a new
_PAGE_UC which defines uncached mappings and use it in place of _PAGE_PCD.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

Index: linux-2.6.git/arch/x86/mm/ioremap_32.c
===================================================================
--- linux-2.6.git.orig/arch/x86/mm/ioremap_32.c	2008-01-15 03:29:38.000000000 -0800
+++ linux-2.6.git/arch/x86/mm/ioremap_32.c	2008-01-15 04:42:59.000000000 -0800
@@ -173,7 +173,7 @@
 
 void __iomem *ioremap_nocache (unsigned long phys_addr, unsigned long size)
 {
-	return __ioremap(phys_addr, size, _PAGE_PCD);
+	return __ioremap(phys_addr, size, _PAGE_UC);
 }
 EXPORT_SYMBOL(ioremap_nocache);
 
Index: linux-2.6.git/arch/x86/mm/ioremap_64.c
===================================================================
--- linux-2.6.git.orig/arch/x86/mm/ioremap_64.c	2008-01-15 03:29:38.000000000 -0800
+++ linux-2.6.git/arch/x86/mm/ioremap_64.c	2008-01-15 04:43:07.000000000 -0800
@@ -150,7 +150,7 @@
 
 void __iomem *ioremap_nocache (unsigned long phys_addr, unsigned long size)
 {
-	return __ioremap(phys_addr, size, _PAGE_PCD);
+	return __ioremap(phys_addr, size, _PAGE_UC);
 }
 EXPORT_SYMBOL(ioremap_nocache);
 
Index: linux-2.6.git/arch/x86/mm/pat.c
===================================================================
--- linux-2.6.git.orig/arch/x86/mm/pat.c	2008-01-15 03:29:38.000000000 -0800
+++ linux-2.6.git/arch/x86/mm/pat.c	2008-01-15 05:01:43.000000000 -0800
@@ -64,7 +64,7 @@
 	if (smp_processor_id() && !pat_wc_enabled)
 		return;
 
-	/* Set PWT+PCD to Write-Combining. All other bits stay the same */
+	/* Set PCD to Write-Combining. All other bits stay the same */
 	/* PTE encoding used in Linux:
 	      PAT
 	      |PCD
@@ -72,7 +72,7 @@
 	      |||
 	      000 WB         default
 	      010 WC         _PAGE_WC
-	      011 UC         _PAGE_PCD
+	      011 UC         _PAGE_UC
 		PAT bit unused */
 	pat = PAT(0,WB) | PAT(1,WT) | PAT(2,WC) | PAT(3,UC) |
 	      PAT(4,WB) | PAT(5,WT) | PAT(6,WC) | PAT(7,UC);
@@ -97,7 +97,7 @@
 {
 	switch (flags & _PAGE_CACHE_MASK) {
 	case _PAGE_WC:  return "write combining";
-	case _PAGE_PCD: return "uncached";
+	case _PAGE_UC: return "uncached";
 	case 0: 	return "default";
 	default: 	return "broken";
 	}
@@ -144,7 +144,7 @@
 			if (!fattr)
 				return -EINVAL;
 			else
-				*fattr  = _PAGE_PCD;
+				*fattr  = _PAGE_UC;
 		}
 
 		return 0;
@@ -227,13 +227,13 @@
 	unsigned long flags;
 	unsigned long want_flags = 0;
 	if (file->f_flags & O_SYNC)
-		want_flags = _PAGE_PCD;
+		want_flags = _PAGE_UC;
 
 #ifdef CONFIG_X86_32
 	/*
 	 * On the PPro and successors, the MTRRs are used to set
  	 * memory types for physical addresses outside main memory,
-	 * so blindly setting PCD or PWT on those pages is wrong.
+	 * so blindly setting UC or PWT on those pages is wrong.
 	 * For Pentiums and earlier, the surround logic should disable
 	 * caching for the high addresses through the KEN pin, but
 	 * we maintain the tradition of paranoia in this code.
@@ -244,7 +244,7 @@
 		test_bit(X86_FEATURE_CYRIX_ARR, boot_cpu_data.x86_capability) ||
 		test_bit(X86_FEATURE_CENTAUR_MCR, boot_cpu_data.x86_capability)) &&
 	   offset >= __pa(high_memory))
-		want_flags = _PAGE_PCD;
+		want_flags = _PAGE_UC;
 #endif
 
 	/* ignore error because we can't handle it here */
Index: linux-2.6.git/arch/x86/pci/i386.c
===================================================================
--- linux-2.6.git.orig/arch/x86/pci/i386.c	2008-01-15 03:29:38.000000000 -0800
+++ linux-2.6.git/arch/x86/pci/i386.c	2008-01-15 05:02:12.000000000 -0800
@@ -353,7 +353,7 @@
 		 */
 		prot = pgprot_val(vma->vm_page_prot);
 		if (boot_cpu_data.x86 > 3) {
-			prot |= _PAGE_PCD;
+			prot |= _PAGE_UC;
 		}
 		vma->vm_page_prot = __pgprot(prot);
 	}
Index: linux-2.6.git/include/asm-x86/pgtable.h
===================================================================
--- linux-2.6.git.orig/include/asm-x86/pgtable.h	2008-01-15 03:29:38.000000000 -0800
+++ linux-2.6.git/include/asm-x86/pgtable.h	2008-01-15 05:11:12.000000000 -0800
@@ -28,14 +28,16 @@
 #define _PAGE_RW	(_AC(1, L)<<_PAGE_BIT_RW)
 #define _PAGE_USER	(_AC(1, L)<<_PAGE_BIT_USER)
 #define _PAGE_PWT	(_AC(1, L)<<_PAGE_BIT_PWT)
-#define _PAGE_PCD	((_AC(1, L)<<_PAGE_BIT_PCD) | _PAGE_PWT)
+#define _PAGE_PCD	(_AC(1, L)<<_PAGE_BIT_PCD) /* Do not use PCD directly */
 #define _PAGE_ACCESSED	(_AC(1, L)<<_PAGE_BIT_ACCESSED)
 #define _PAGE_DIRTY	(_AC(1, L)<<_PAGE_BIT_DIRTY)
 #define _PAGE_PSE	(_AC(1, L)<<_PAGE_BIT_PSE)	/* 2MB page */
 #define _PAGE_GLOBAL	(_AC(1, L)<<_PAGE_BIT_GLOBAL)	/* Global TLB entry */
-/* We redefine PCD to be write combining. PAT bit is not used */
-#define _PAGE_WC	((_AC(1, L)<<_PAGE_BIT_PCD))
-#define _PAGE_CACHE_MASK (_PAGE_PCD)
+/* We redefine PCD to be WC, PCD|PWT to be UC. PAT bit is not used */
+#define _PAGE_WC	(_PAGE_PCD)
+#define _PAGE_UC	(_PAGE_PCD | _PAGE_PWT)
+#define _PAGE_CACHE_MASK (_PAGE_PCD | _PAGE_PWT)
+
 #define _PAGE_UNUSED1	(_AC(1, L)<<_PAGE_BIT_UNUSED1)
 #define _PAGE_UNUSED2	(_AC(1, L)<<_PAGE_BIT_UNUSED2)
 #define _PAGE_UNUSED3	(_AC(1, L)<<_PAGE_BIT_UNUSED3)
@@ -82,9 +84,9 @@
 
 #define __PAGE_KERNEL_RO		(__PAGE_KERNEL & ~_PAGE_RW)
 #define __PAGE_KERNEL_RX		(__PAGE_KERNEL_EXEC & ~_PAGE_RW)
-#define __PAGE_KERNEL_NOCACHE		(__PAGE_KERNEL | _PAGE_PCD)
+#define __PAGE_KERNEL_NOCACHE		(__PAGE_KERNEL | _PAGE_UC)
 #define __PAGE_KERNEL_VSYSCALL		(__PAGE_KERNEL_RX | _PAGE_USER)
-#define __PAGE_KERNEL_VSYSCALL_NOCACHE	(__PAGE_KERNEL_VSYSCALL | _PAGE_PCD)
+#define __PAGE_KERNEL_VSYSCALL_NOCACHE	(__PAGE_KERNEL_VSYSCALL | _PAGE_UC)
 #define __PAGE_KERNEL_LARGE		(__PAGE_KERNEL | _PAGE_PSE)
 #define __PAGE_KERNEL_LARGE_EXEC	(__PAGE_KERNEL_EXEC | _PAGE_PSE)
 
Index: linux-2.6.git/include/asm-x86/pgtable_32.h
===================================================================
--- linux-2.6.git.orig/include/asm-x86/pgtable_32.h	2008-01-15 03:29:38.000000000 -0800
+++ linux-2.6.git/include/asm-x86/pgtable_32.h	2008-01-15 04:42:16.000000000 -0800
@@ -121,7 +121,7 @@
  * it, this is a no-op.
  */
 #define pgprot_noncached(prot)	((boot_cpu_data.x86 > 3)					  \
-				 ? (__pgprot(pgprot_val(prot) | _PAGE_PCD)) : (prot))
+				 ? (__pgprot(pgprot_val(prot) | _PAGE_UC)) : (prot))
 
 /*
  * Macro to make mark a page protection value as "write-combining".
Index: linux-2.6.git/include/asm-x86/pgtable_64.h
===================================================================
--- linux-2.6.git.orig/include/asm-x86/pgtable_64.h	2008-01-15 03:29:38.000000000 -0800
+++ linux-2.6.git/include/asm-x86/pgtable_64.h	2008-01-15 04:41:37.000000000 -0800
@@ -170,7 +170,7 @@
  * and do not allow for consecutive writes to be combined.
  */
 #define pgprot_noncached(prot) \
-	__pgprot((pgprot_val(prot) & ~_PAGE_CACHE_MASK) | _PAGE_PCD)
+	__pgprot((pgprot_val(prot) & ~_PAGE_CACHE_MASK) | _PAGE_UC)
 
 /*
  * Macro to make mark a page protection value as "write-combining".

-- 
