Return-Path: <linux-kernel-owner+w=401wt.eu-S1757136AbYAJStO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757136AbYAJStO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 13:49:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754301AbYAJSs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 13:48:58 -0500
Received: from mga02.intel.com ([134.134.136.20]:50604 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752325AbYAJSs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 13:48:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,267,1196668800"; 
   d="scan'208";a="251983565"
Message-Id: <20080110184855.221164000@intel.com>
References: <20080110184840.927409000@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 10 Jan 2008 10:48:44 -0800
From: venkatesh.pallipadi@intel.com
To: ak@muc.de, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, gregkh@suse.de, airlied@skynet.ie,
       davej@redhat.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com,
       davem@davemloft.net
Cc: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 04/11] PAT x86: Basic PAT implementation
Content-Disposition: inline; filename=pat-base.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Originally based on a patch from Eric Biederman, but heavily changed.

PAT set as below
PAT(0,WB) | PAT(1,WT) | PAT(2,WC) | PAT(3,UC)
So, only change from boot setting is UC_MINUS -> WC.

Also, PAT WC is enabled only on recent Intel CPUs. Other CPUs can be added as
they are tested with these patches.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Index: linux-2.6.git/arch/x86/mm/Makefile_64
===================================================================
--- linux-2.6.git.orig/arch/x86/mm/Makefile_64	2008-01-08 12:42:58.000000000 -0800
+++ linux-2.6.git/arch/x86/mm/Makefile_64	2008-01-08 12:43:13.000000000 -0800
@@ -2,7 +2,7 @@
 # Makefile for the linux x86_64-specific parts of the memory manager.
 #
 
-obj-y	 := init_64.o fault_64.o ioremap_64.o extable.o pageattr_64.o mmap.o
+obj-y	 := init_64.o fault_64.o ioremap_64.o extable.o pageattr_64.o mmap.o pat.o
 obj-$(CONFIG_HUGETLB_PAGE) += hugetlbpage.o
 obj-$(CONFIG_NUMA) += numa_64.o
 obj-$(CONFIG_K8_NUMA) += k8topology_64.o
Index: linux-2.6.git/arch/x86/mm/pat.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.git/arch/x86/mm/pat.c	2008-01-08 12:43:13.000000000 -0800
@@ -0,0 +1,70 @@
+/* Handle caching attributes in page tables (PAT) */
+#include <linux/mm.h>
+#include <linux/kernel.h>
+#include <linux/gfp.h>
+#include <asm/msr.h>
+#include <asm/tlbflush.h>
+#include <asm/processor.h>
+
+static u64 boot_pat_state;
+int pat_wc_enabled = 0;
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
+static int pat_known_cpu(void)
+{
+	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL &&
+	    (boot_cpu_data.x86 == 0xF ||
+	     (boot_cpu_data.x86 == 0x6 && boot_cpu_data.x86_model >= 0x15)))
+		return cpu_has_pat;
+
+	return 0;
+}
+
+void pat_init(void)
+{
+	u64 pat;
+	if (!smp_processor_id() && !pat_known_cpu())
+		return;
+
+	if (smp_processor_id() && !pat_wc_enabled)
+		return;
+
+	/* Set PWT+PCD to Write-Combining. All other bits stay the same */
+	/* PTE encoding used in Linux:
+	      PAT
+	      |PCD
+	      ||PWT
+	      |||
+	      000 WB         default
+	      010 WC         _PAGE_WC
+	      011 UC         _PAGE_PCD
+		PAT bit unused */
+	pat = PAT(0,WB) | PAT(1,WT) | PAT(2,WC) | PAT(3,UC) |
+	      PAT(4,WB) | PAT(5,WT) | PAT(6,WC) | PAT(7,UC);
+
+	if (!pat_wc_enabled) {
+		rdmsrl(MSR_IA32_CR_PAT, boot_pat_state);
+		pat_wc_enabled = 1;
+	}
+
+	wrmsrl(MSR_IA32_CR_PAT, pat);
+	printk("cpu %d, old 0x%Lx, new 0x%Lx\n", smp_processor_id(),
+			boot_pat_state, pat);
+}
+
+#undef PAT
+
+void pat_shutdown(void)
+{
+}
+
Index: linux-2.6.git/arch/x86/pci/i386.c
===================================================================
--- linux-2.6.git.orig/arch/x86/pci/i386.c	2008-01-08 12:42:58.000000000 -0800
+++ linux-2.6.git/arch/x86/pci/i386.c	2008-01-08 12:43:13.000000000 -0800
@@ -301,7 +301,6 @@
 			enum pci_mmap_state mmap_state, int write_combine)
 {
 	unsigned long prot;
-
 	/* I/O space cannot be accessed via normal processor loads and
 	 * stores on this platform.
 	 */
@@ -311,14 +310,25 @@
 	/* Leave vm_pgoff as-is, the PCI space address is the physical
 	 * address on this platform.
 	 */
-	prot = pgprot_val(vma->vm_page_prot);
-	if (boot_cpu_data.x86 > 3)
-		prot |= _PAGE_PCD | _PAGE_PWT;
-	vma->vm_page_prot = __pgprot(prot);
+	if (pat_wc_enabled) {
+		if (write_combine) {
+			vma->vm_page_prot =
+				pgprot_writecombine(vma->vm_page_prot);
+		} else {
+			vma->vm_page_prot =
+				pgprot_noncached(vma->vm_page_prot);
+		}
+	} else {
+		/* Write-combine setting is ignored, it is changed via the mtrr
+		 * interfaces on this platform.
+		 */
+		prot = pgprot_val(vma->vm_page_prot);
+		if (boot_cpu_data.x86 > 3) {
+			prot |= _PAGE_PCD;
+		}
+		vma->vm_page_prot = __pgprot(prot);
+	}
 
-	/* Write-combine setting is ignored, it is changed via the mtrr
-	 * interfaces on this platform.
-	 */
 	if (io_remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
 			       vma->vm_end - vma->vm_start,
 			       vma->vm_page_prot))
Index: linux-2.6.git/include/asm-x86/cpufeature.h
===================================================================
--- linux-2.6.git.orig/include/asm-x86/cpufeature.h	2008-01-08 12:42:58.000000000 -0800
+++ linux-2.6.git/include/asm-x86/cpufeature.h	2008-01-08 12:43:13.000000000 -0800
@@ -167,6 +167,7 @@
 #define cpu_has_pebs		boot_cpu_has(X86_FEATURE_PEBS)
 #define cpu_has_clflush		boot_cpu_has(X86_FEATURE_CLFLSH)
 #define cpu_has_bts		boot_cpu_has(X86_FEATURE_BTS)
+#define cpu_has_pat		boot_cpu_has(X86_FEATURE_PAT)
 
 #if defined(CONFIG_X86_INVLPG) || defined(CONFIG_X86_64)
 # define cpu_has_invlpg		1
Index: linux-2.6.git/include/asm-x86/msr-index.h
===================================================================
--- linux-2.6.git.orig/include/asm-x86/msr-index.h	2008-01-08 12:42:58.000000000 -0800
+++ linux-2.6.git/include/asm-x86/msr-index.h	2008-01-08 12:43:13.000000000 -0800
@@ -70,6 +70,7 @@
 #define DEBUGCTLMSR_LBR		(1UL << _DEBUGCTLMSR_LBR)
 #define DEBUGCTLMSR_BTF		(1UL << _DEBUGCTLMSR_BTF)
 
+#define MSR_IA32_CR_PAT			0x00000277
 #define MSR_IA32_MC0_CTL		0x00000400
 #define MSR_IA32_MC0_STATUS		0x00000401
 #define MSR_IA32_MC0_ADDR		0x00000402
Index: linux-2.6.git/include/asm-x86/pgtable_64.h
===================================================================
--- linux-2.6.git.orig/include/asm-x86/pgtable_64.h	2008-01-08 12:42:58.000000000 -0800
+++ linux-2.6.git/include/asm-x86/pgtable_64.h	2008-01-08 12:43:13.000000000 -0800
@@ -158,7 +158,7 @@
 #define _PAGE_RW	(_AC(1, UL)<<_PAGE_BIT_RW)
 #define _PAGE_USER	(_AC(1, UL)<<_PAGE_BIT_USER)
 #define _PAGE_PWT	(_AC(1, UL)<<_PAGE_BIT_PWT)
-#define _PAGE_PCD	(_AC(1, UL)<<_PAGE_BIT_PCD)
+#define _PAGE_PCD	((_AC(1, UL)<<_PAGE_BIT_PCD) | _PAGE_PWT)
 #define _PAGE_ACCESSED	(_AC(1, UL)<<_PAGE_BIT_ACCESSED)
 #define _PAGE_DIRTY	(_AC(1, UL)<<_PAGE_BIT_DIRTY)
 /* 2MB page */
@@ -167,6 +167,10 @@
 #define _PAGE_FILE	(_AC(1, UL)<<_PAGE_BIT_FILE)
 /* Global TLB entry */
 #define _PAGE_GLOBAL	(_AC(1, UL)<<_PAGE_BIT_GLOBAL)
+/* We redefine PCD to be write combining. PAT bit is not used */
+#define _PAGE_WC	(_AC(1, UL)<<_PAGE_BIT_PCD)
+
+#define _PAGE_CACHE_MASK	(_PAGE_PCD)
 
 #define _PAGE_PROTNONE	0x080	/* If not present */
 #define _PAGE_NX        (_AC(1, UL)<<_PAGE_BIT_NX)
@@ -189,13 +193,15 @@
 #define __PAGE_KERNEL_EXEC \
 	(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY | _PAGE_ACCESSED)
 #define __PAGE_KERNEL_NOCACHE \
-	(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY | _PAGE_PCD | _PAGE_PWT | _PAGE_ACCESSED | _PAGE_NX)
+	(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY | _PAGE_PCD | _PAGE_ACCESSED | _PAGE_NX)
+#define __PAGE_KERNEL_WC \
+	(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY | _PAGE_WC | _PAGE_ACCESSED | _PAGE_NX)
 #define __PAGE_KERNEL_RO \
 	(_PAGE_PRESENT | _PAGE_DIRTY | _PAGE_ACCESSED | _PAGE_NX)
 #define __PAGE_KERNEL_VSYSCALL \
 	(_PAGE_PRESENT | _PAGE_USER | _PAGE_ACCESSED)
 #define __PAGE_KERNEL_VSYSCALL_NOCACHE \
-	(_PAGE_PRESENT | _PAGE_USER | _PAGE_ACCESSED | _PAGE_PCD | _PAGE_PWT)
+	(_PAGE_PRESENT | _PAGE_USER | _PAGE_ACCESSED | _PAGE_PCD)
 #define __PAGE_KERNEL_LARGE \
 	(__PAGE_KERNEL | _PAGE_PSE)
 #define __PAGE_KERNEL_LARGE_EXEC \
@@ -207,6 +213,7 @@
 #define PAGE_KERNEL_EXEC MAKE_GLOBAL(__PAGE_KERNEL_EXEC)
 #define PAGE_KERNEL_RO MAKE_GLOBAL(__PAGE_KERNEL_RO)
 #define PAGE_KERNEL_NOCACHE MAKE_GLOBAL(__PAGE_KERNEL_NOCACHE)
+#define PAGE_KERNEL_WC MAKE_GLOBAL(__PAGE_KERNEL_WC)
 #define PAGE_KERNEL_VSYSCALL32 __pgprot(__PAGE_KERNEL_VSYSCALL)
 #define PAGE_KERNEL_VSYSCALL MAKE_GLOBAL(__PAGE_KERNEL_VSYSCALL)
 #define PAGE_KERNEL_LARGE MAKE_GLOBAL(__PAGE_KERNEL_LARGE)
@@ -302,8 +309,24 @@
 
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
@@ -417,6 +440,7 @@
 #define pgtable_cache_init()   do { } while (0)
 #define check_pgt_cache()      do { } while (0)
 
+/* AGP users use MTRRs for now. Need to add an ioctl to agpgart for WC */
 #define PAGE_AGP    PAGE_KERNEL_NOCACHE
 #define HAVE_PAGE_AGP 1
 
Index: linux-2.6.git/arch/x86/kernel/cpu/mtrr/generic.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/mtrr/generic.c	2008-01-08 12:42:58.000000000 -0800
+++ linux-2.6.git/arch/x86/kernel/cpu/mtrr/generic.c	2008-01-08 12:43:13.000000000 -0800
@@ -79,19 +79,23 @@
 			base, base + step - 1, mtrr_attrib_to_str(*types));
 }
 
+static void prepare_set(void);
+static void post_set(void);
+
 /*  Grab all of the MTRR state for this CPU into *state  */
 void __init get_mtrr_state(void)
 {
 	unsigned int i;
 	struct mtrr_var_range *vrs;
 	unsigned lo, dummy;
+	unsigned long flags;
 
 	if (!mtrr_state.var_ranges) {
-		mtrr_state.var_ranges = kmalloc(num_var_ranges * sizeof (struct mtrr_var_range), 
+		mtrr_state.var_ranges = kmalloc(num_var_ranges * sizeof (struct mtrr_var_range),
 						GFP_KERNEL);
 		if (!mtrr_state.var_ranges)
 			return;
-	} 
+	}
 	vrs = mtrr_state.var_ranges;
 
 	rdmsr(MTRRcap_MSR, lo, dummy);
@@ -137,6 +141,16 @@
 				printk(KERN_INFO "MTRR %u disabled\n", i);
 		}
 	}
+
+	/* PAT setup for BP. we need to go through sync steps here */
+	local_irq_save(flags);
+	prepare_set();
+
+	pat_init();
+
+	post_set();
+	local_irq_restore(flags);
+
 }
 
 /*  Some BIOS's are fucked and don't set all MTRRs the same!  */
@@ -399,6 +413,9 @@
 	/* Actually set the state */
 	mask = set_mtrr_state();
 
+	/* also set PAT */
+	pat_init();
+
 	post_set();
 	local_irq_restore(flags);
 
Index: linux-2.6.git/arch/x86/mm/Makefile_32
===================================================================
--- linux-2.6.git.orig/arch/x86/mm/Makefile_32	2008-01-08 12:42:58.000000000 -0800
+++ linux-2.6.git/arch/x86/mm/Makefile_32	2008-01-08 12:43:13.000000000 -0800
@@ -2,7 +2,7 @@
 # Makefile for the linux i386-specific parts of the memory manager.
 #
 
-obj-y	:= init_32.o pgtable_32.o fault_32.o ioremap_32.o extable.o pageattr_32.o mmap.o
+obj-y	:= init_32.o pgtable_32.o fault_32.o ioremap_32.o extable.o pageattr_32.o mmap.o pat.o
 
 obj-$(CONFIG_NUMA) += discontig_32.o
 obj-$(CONFIG_HUGETLB_PAGE) += hugetlbpage.o
Index: linux-2.6.git/include/asm-x86/pgtable_32.h
===================================================================
--- linux-2.6.git.orig/include/asm-x86/pgtable_32.h	2008-01-08 12:42:58.000000000 -0800
+++ linux-2.6.git/include/asm-x86/pgtable_32.h	2008-01-08 12:43:36.000000000 -0800
@@ -107,7 +107,7 @@
 #define _PAGE_RW	0x002
 #define _PAGE_USER	0x004
 #define _PAGE_PWT	0x008
-#define _PAGE_PCD	0x010
+#define _PAGE_PCD	0x018
 #define _PAGE_ACCESSED	0x020
 #define _PAGE_DIRTY	0x040
 #define _PAGE_PSE	0x080	/* 4 MB (or 2MB) page, Pentium+, if present.. */
@@ -116,6 +116,12 @@
 #define _PAGE_UNUSED2	0x400
 #define _PAGE_UNUSED3	0x800
 
+/* We redefine PCD to be write combining. PAT bit is not used */
+
+#define _PAGE_WC	0x10
+
+#define _PAGE_CACHE_MASK	0x18
+
 /* If _PAGE_PRESENT is clear, we use these: */
 #define _PAGE_FILE	0x040	/* nonlinear file mapping, saved PTE; unset:swap */
 #define _PAGE_PROTNONE	0x080	/* if the user mapped it with PROT_NONE;
@@ -156,7 +162,7 @@
 extern unsigned long long __PAGE_KERNEL, __PAGE_KERNEL_EXEC;
 #define __PAGE_KERNEL_RO		(__PAGE_KERNEL & ~_PAGE_RW)
 #define __PAGE_KERNEL_RX		(__PAGE_KERNEL_EXEC & ~_PAGE_RW)
-#define __PAGE_KERNEL_NOCACHE		(__PAGE_KERNEL | _PAGE_PCD | _PAGE_PWT)
+#define __PAGE_KERNEL_NOCACHE		(__PAGE_KERNEL | _PAGE_PCD)
 #define __PAGE_KERNEL_LARGE		(__PAGE_KERNEL | _PAGE_PSE)
 #define __PAGE_KERNEL_LARGE_EXEC	(__PAGE_KERNEL_EXEC | _PAGE_PSE)
 
@@ -358,7 +364,18 @@
  * it, this is a no-op.
  */
 #define pgprot_noncached(prot)	((boot_cpu_data.x86 > 3)					  \
-				 ? (__pgprot(pgprot_val(prot) | _PAGE_PCD | _PAGE_PWT)) : (prot))
+				 ? (__pgprot(pgprot_val(prot) | _PAGE_PCD)) : (prot))
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
 
 /*
  * Conversion functions: convert a page and protection to a page entry,
Index: linux-2.6.git/include/asm-x86/processor.h
===================================================================
--- linux-2.6.git.orig/include/asm-x86/processor.h	2008-01-08 12:42:58.000000000 -0800
+++ linux-2.6.git/include/asm-x86/processor.h	2008-01-08 12:43:13.000000000 -0800
@@ -647,6 +647,10 @@
 
 extern int force_mwait;
 
+extern int pat_wc_enabled;
+extern void pat_init(void);
+extern void pat_shutdown(void);
+
 extern void select_idle_routine(const struct cpuinfo_x86 *c);
 
 extern unsigned long boot_option_idle_override;
Index: linux-2.6.git/include/asm-generic/pgtable.h
===================================================================
--- linux-2.6.git.orig/include/asm-generic/pgtable.h	2008-01-08 12:42:58.000000000 -0800
+++ linux-2.6.git/include/asm-generic/pgtable.h	2008-01-08 12:43:13.000000000 -0800
@@ -154,6 +154,10 @@
 })
 #endif
 
+#ifndef pgprot_writecombine
+#define pgprot_writecombine pgprot_noncached
+#endif
+
 /*
  * When walking page tables, we usually want to skip any p?d_none entries;
  * and any p?d_bad entries - reporting the error before resetting to none.
Index: linux-2.6.git/arch/x86/mm/ioremap_32.c
===================================================================
--- linux-2.6.git.orig/arch/x86/mm/ioremap_32.c	2008-01-08 12:42:58.000000000 -0800
+++ linux-2.6.git/arch/x86/mm/ioremap_32.c	2008-01-08 12:43:13.000000000 -0800
@@ -119,7 +119,7 @@
 void __iomem *ioremap_nocache (unsigned long phys_addr, unsigned long size)
 {
 	unsigned long last_addr;
-	void __iomem *p = __ioremap(phys_addr, size, _PAGE_PCD | _PAGE_PWT);
+	void __iomem *p = __ioremap(phys_addr, size, _PAGE_PCD);
 	if (!p) 
 		return p; 
 
Index: linux-2.6.git/arch/x86/mm/ioremap_64.c
===================================================================
--- linux-2.6.git.orig/arch/x86/mm/ioremap_64.c	2008-01-08 12:42:58.000000000 -0800
+++ linux-2.6.git/arch/x86/mm/ioremap_64.c	2008-01-08 12:43:13.000000000 -0800
@@ -138,7 +138,7 @@
 
 void __iomem *ioremap_nocache (unsigned long phys_addr, unsigned long size)
 {
-	return __ioremap(phys_addr, size, _PAGE_PCD | _PAGE_PWT);
+	return __ioremap(phys_addr, size, _PAGE_PCD);
 }
 EXPORT_SYMBOL(ioremap_nocache);
 

-- 
