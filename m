Return-Path: <linux-kernel-owner+w=401wt.eu-S934835AbXLNAEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934835AbXLNAEg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 19:04:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934789AbXLNAEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 19:04:15 -0500
Received: from mga03.intel.com ([143.182.124.21]:58012 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933624AbXLNAEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 19:04:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,163,1196668800"; 
   d="scan'208";a="340710595"
Message-Id: <20071213235711.464325000@intel.com>
References: <20071213235543.568682000@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 13 Dec 2007 15:55:45 -0800
From: venkatesh.pallipadi@intel.com
To: ak@muc.de, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, gregkh@suse.de, airlied@skynet.ie,
       davej@redhat.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com
Cc: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [RFC PATCH 02/12] PAT 64b: Basic PAT implementation
Content-Disposition: inline; filename=pat-base.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Originally based on a patch from Eric Biederman, but heavily changed.

Forward port of pat-base.patch to x86 tree, with a bug fix.
Code was using 'PCD|PWT' i.e., PAT3 for WC mapping. So set the WC mapping at
correct PAT fields PA3/PA7.

TBD: KEXEC and other CPU offline paths may need pat_shutdown()?

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
Index: linux-2.6/arch/x86/kernel/setup64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup64.c	2007-12-11 03:30:46.000000000 -0800
+++ linux-2.6/arch/x86/kernel/setup64.c	2007-12-11 03:42:08.000000000 -0800
@@ -291,9 +291,11 @@
 
 	fpu_init(); 
 
+	pat_init();
 	raw_local_save_flags(kernel_eflags);
 }
 
 void cpu_shutdown(void)
 {
+	pat_shutdown();
 }
Index: linux-2.6/arch/x86/mm/Makefile_64
===================================================================
--- linux-2.6.orig/arch/x86/mm/Makefile_64	2007-12-11 03:30:34.000000000 -0800
+++ linux-2.6/arch/x86/mm/Makefile_64	2007-12-11 03:42:08.000000000 -0800
@@ -2,7 +2,7 @@
 # Makefile for the linux x86_64-specific parts of the memory manager.
 #
 
-obj-y	 := init_64.o fault_64.o ioremap_64.o extable_64.o pageattr_64.o mmap_64.o
+obj-y	 := init_64.o fault_64.o ioremap_64.o extable_64.o pageattr_64.o mmap_64.o pat.o
 obj-$(CONFIG_HUGETLB_PAGE) += hugetlbpage.o
 obj-$(CONFIG_NUMA) += numa_64.o
 obj-$(CONFIG_K8_NUMA) += k8topology_64.o
Index: linux-2.6/arch/x86/mm/pat.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/arch/x86/mm/pat.c	2007-12-11 04:12:47.000000000 -0800
@@ -0,0 +1,57 @@
+/* Handle caching attributes in page tables (PAT) */
+#include <linux/mm.h>
+#include <linux/kernel.h>
+#include <linux/rbtree.h>
+#include <linux/gfp.h>
+#include <asm/msr.h>
+#include <asm/tlbflush.h>
+#include <asm/processor.h>
+
+static u64 boot_pat_state;
+
+enum {
+	PAT_UC = 0,   	/* uncached */
+	PAT_WC = 1,		/* Write combining */
+	PAT_WT = 4,		/* Write Through */
+	PAT_WP = 5,		/* Write Protected */
+	PAT_WB = 6,		/* Write Back (default) */
+	PAT_UC_MINUS = 7,	/* UC, but can be overriden by MTRR */
+};
+
+#define PAT(x,y) ((u64)PAT_ ## y << ((x)*8))
+
+void __cpuinit pat_init(void)
+{
+	/* Set PWT+PCD to Write-Combining. All other bits stay the same */
+	if (cpu_has_pat) {
+		u64 pat;
+		/* PTE encoding used in Linux:
+                   PAT
+                   |PCD
+                   ||PWT
+                   |||
+		   000 WB         default
+		   010 UC_MINUS   _PAGE_PCD
+		   011 WC         _PAGE_WC
+		   PAT bit unused */
+		pat = PAT(0,WB) | PAT(1,WT) | PAT(2,UC_MINUS) | PAT(3,WC) |
+		      PAT(4,WB) | PAT(5,WT) | PAT(6,UC_MINUS) | PAT(7,WC);
+		rdmsrl(MSR_IA32_CR_PAT, boot_pat_state);
+		wrmsrl(MSR_IA32_CR_PAT, pat);
+		__flush_tlb_all();
+		asm volatile("wbinvd");
+	}
+}
+
+#undef PAT
+
+void pat_shutdown(void)
+{
+	/* Restore CPU default pat state */
+	if (cpu_has_pat) {
+		wrmsrl(MSR_IA32_CR_PAT, boot_pat_state);
+		__flush_tlb_all();
+		asm volatile("wbinvd");
+	}
+}
+
Index: linux-2.6/arch/x86/pci/i386.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/i386.c	2007-12-11 03:30:34.000000000 -0800
+++ linux-2.6/arch/x86/pci/i386.c	2007-12-11 03:42:08.000000000 -0800
@@ -300,8 +300,6 @@
 int pci_mmap_page_range(struct pci_dev *dev, struct vm_area_struct *vma,
 			enum pci_mmap_state mmap_state, int write_combine)
 {
-	unsigned long prot;
-
 	/* I/O space cannot be accessed via normal processor loads and
 	 * stores on this platform.
 	 */
@@ -311,14 +309,11 @@
 	/* Leave vm_pgoff as-is, the PCI space address is the physical
 	 * address on this platform.
 	 */
-	prot = pgprot_val(vma->vm_page_prot);
-	if (boot_cpu_data.x86 > 3)
-		prot |= _PAGE_PCD | _PAGE_PWT;
-	vma->vm_page_prot = __pgprot(prot);
+	if (write_combine)
+		vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
+	else
+		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 
-	/* Write-combine setting is ignored, it is changed via the mtrr
-	 * interfaces on this platform.
-	 */
 	if (io_remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
 			       vma->vm_end - vma->vm_start,
 			       vma->vm_page_prot))
Index: linux-2.6/include/asm-x86/cpufeature_32.h
===================================================================
--- linux-2.6.orig/include/asm-x86/cpufeature_32.h	2007-12-11 03:30:34.000000000 -0800
+++ linux-2.6/include/asm-x86/cpufeature_32.h	2007-12-11 03:42:08.000000000 -0800
@@ -166,6 +166,8 @@
 #define cpu_has_clflush		boot_cpu_has(X86_FEATURE_CLFLSH)
 #define cpu_has_bts 		boot_cpu_has(X86_FEATURE_BTS)
 
+#define cpu_has_pat		boot_cpu_has(X86_FEATURE_PAT)
+
 #endif /* __ASM_I386_CPUFEATURE_H */
 
 /* 
Index: linux-2.6/include/asm-x86/msr-index.h
===================================================================
--- linux-2.6.orig/include/asm-x86/msr-index.h	2007-12-11 03:30:34.000000000 -0800
+++ linux-2.6/include/asm-x86/msr-index.h	2007-12-11 03:42:08.000000000 -0800
@@ -63,6 +63,7 @@
 #define MSR_IA32_LASTINTFROMIP		0x000001dd
 #define MSR_IA32_LASTINTTOIP		0x000001de
 
+#define MSR_IA32_CR_PAT			0x00000277
 #define MSR_IA32_MC0_CTL		0x00000400
 #define MSR_IA32_MC0_STATUS		0x00000401
 #define MSR_IA32_MC0_ADDR		0x00000402
Index: linux-2.6/include/asm-x86/pgtable_64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/pgtable_64.h	2007-12-11 03:30:34.000000000 -0800
+++ linux-2.6/include/asm-x86/pgtable_64.h	2007-12-11 03:42:08.000000000 -0800
@@ -164,6 +164,12 @@
 #define _PAGE_FILE	0x040	/* nonlinear file mapping, saved PTE; unset:swap */
 #define _PAGE_GLOBAL	0x100	/* Global TLB entry */
 
+/* We redefine PWT|PCD to be write combining. PAT bit is not used */
+
+#define _PAGE_WC	(_PAGE_PWT|_PAGE_PCD)
+
+#define _PAGE_CACHE_MASK	(_PAGE_PWT|_PAGE_PCD)
+
 #define _PAGE_PROTNONE	0x080	/* If not present */
 #define _PAGE_NX        (_AC(1,UL)<<_PAGE_BIT_NX)
 
@@ -203,6 +209,7 @@
 #define PAGE_KERNEL_EXEC MAKE_GLOBAL(__PAGE_KERNEL_EXEC)
 #define PAGE_KERNEL_RO MAKE_GLOBAL(__PAGE_KERNEL_RO)
 #define PAGE_KERNEL_NOCACHE MAKE_GLOBAL(__PAGE_KERNEL_NOCACHE)
+#define PAGE_KERNEL_WC MAKE_GLOBAL(__PAGE_KERNEL_WC)
 #define PAGE_KERNEL_VSYSCALL32 __pgprot(__PAGE_KERNEL_VSYSCALL)
 #define PAGE_KERNEL_VSYSCALL MAKE_GLOBAL(__PAGE_KERNEL_VSYSCALL)
 #define PAGE_KERNEL_LARGE MAKE_GLOBAL(__PAGE_KERNEL_LARGE)
@@ -299,8 +306,24 @@
 
 /*
  * Macro to mark a page protection value as "uncacheable".
+ * Accesses through a uncached translation bypasses the cache
+ * and do not allow for consecutive writes to be combined.
  */
-#define pgprot_noncached(prot)	(__pgprot(pgprot_val(prot) | _PAGE_PCD | _PAGE_PWT))
+#define pgprot_noncached(prot) \
+	__pgprot((pgprot_val(prot) & ~_PAGE_CACHE_MASK) | _PAGE_PCD)
+
+/*
+ * Macro to make mark a page protection value as "write-combining".
+ * Accesses through a write-combining translation works bypasses the
+ * caches, but does allow for consecutive writes to be combined into
+ * single (but larger) write transactions.
+ * This is mostly useful for IO accesses, for memory it is often slower.
+ * It also implies uncached.
+ */
+#define pgprot_writecombine(prot) \
+	__pgprot((pgprot_val(prot) & ~_PAGE_CACHE_MASK) | _PAGE_WC)
+
+#define pgprot_nonstd(prot) (pgprot_val(prot) & _PAGE_CACHE_MASK)
 
 static inline int pmd_large(pmd_t pte) { 
 	return (pmd_val(pte) & __LARGE_PTE) == __LARGE_PTE; 
@@ -414,6 +437,7 @@
 #define pgtable_cache_init()   do { } while (0)
 #define check_pgt_cache()      do { } while (0)
 
+/* AGP users use MTRRs for now. Need to add an ioctl to agpgart for WC */
 #define PAGE_AGP    PAGE_KERNEL_NOCACHE
 #define HAVE_PAGE_AGP 1
 
Index: linux-2.6/include/asm-x86/processor_64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/processor_64.h	2007-12-11 03:30:46.000000000 -0800
+++ linux-2.6/include/asm-x86/processor_64.h	2007-12-11 03:42:08.000000000 -0800
@@ -105,6 +105,8 @@
 extern void init_scattered_cpuid_features(struct cpuinfo_x86 *c);
 extern unsigned int init_intel_cacheinfo(struct cpuinfo_x86 *c);
 extern unsigned short num_cache_leaves;
+extern void pat_init(void);
+extern void pat_shutdown(void);
 
 /*
  * Save the cr4 feature set we're using (ie

-- 
