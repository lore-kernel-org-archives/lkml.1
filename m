Return-Path: <linux-kernel-owner+w=401wt.eu-S1756375AbYAOUa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756375AbYAOUa2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 15:30:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751059AbYAOUaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 15:30:21 -0500
Received: from mga02.intel.com ([134.134.136.20]:17588 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082AbYAOUaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 15:30:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,288,1196668800"; 
   d="scan'208";a="253790017"
Date: Tue, 15 Jan 2008 12:30:18 -0800
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: Folding _PAGE_PWT into _PAGE_PCD (was Re: unify pagetable accessors patch causes double fault II)
Message-ID: <20080115203018.GA19746@linux-os.sc.intel.com>
References: <20080114094814.GA28300@basil.nowhere.org> <20080114125638.GA9510@basil.nowhere.org> <20080114130620.GA14057@elte.hu> <20080114135811.GA16190@one.firstfloor.org> <478BDC43.6050105@goop.org> <20080114222349.GA23409@one.firstfloor.org> <478BE628.7090008@goop.org> <20080115135317.GA13493@elte.hu> <478CEA82.9010606@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <478CEA82.9010606@goop.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2008 at 09:16:50AM -0800, Jeremy Fitzhardinge wrote:
> Ingo Molnar wrote:
> >-#define _PAGE_PRESENT	(_AC(1, UL)<<_PAGE_BIT_PRESENT)
> >-#define _PAGE_RW	(_AC(1, UL)<<_PAGE_BIT_RW)
> >-#define _PAGE_USER	(_AC(1, UL)<<_PAGE_BIT_USER)
> >-#define _PAGE_PWT	(_AC(1, UL)<<_PAGE_BIT_PWT)
> >-#define _PAGE_PCD	((_AC(1, UL)<<_PAGE_BIT_PCD) | _PAGE_PWT)
> >  
> 
> BTW, I just noticed that _PAGE_PWT has been folded into _PAGE_PCD.  This 
> seems like a really bad idea to me, since it breaks the rule that 
> _PAGE_X == 1 << _PAGE_BIT_X.  I can't think of a specific place where 
> this would cause problems, but this kind of non-uniformity always ends 
> up biting someone in the arse.
> 
> I think having a specific _PAGE_NOCACHE which combines these bits is a 
> better approach.
> 
>    J

How about the patch below. It defines new _PAGE_UC. One concern is drivers
continuing to use _PAGE_PCD and getting wrong attributes. May be we need to
rename _PAGE_PCD to catch those errors as well?

Thanks,
Venki

Do not fold PCD and PWT bits in _PAGE_PCD. Instead, introduce a new
_PAGE_UC which defines uncached mappings and use it in place of _PAGE_PCD.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

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

