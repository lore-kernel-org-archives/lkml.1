Return-Path: <linux-kernel-owner+w=401wt.eu-S936952AbZDCWrJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936952AbZDCWrJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 18:47:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755390AbZDCWqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 18:46:55 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:32867 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753017AbZDCWqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 18:46:54 -0400
Date: Sat, 4 Apr 2009 00:46:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT PULL] x86 fixes
Message-ID: <20090403224640.GA28595@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

 Thanks,

	Ingo

------------------>
Akinobu Mita (1):
      x86, mm: fix misuse of debug_kmap_atomic

Andrew Morton (1):
      x86: fix is_io_mapping_possible() build warning on i386 allnoconfig

H. Peter Anvin (1):
      x86, setup: compile with -DDISABLE_BRANCH_PROFILING

Hiroshi Shimamoto (1):
      x86: signal: check sas_ss_size instead of sas_ss_flags()

Ingo Molnar (1):
      x86, mtrr: remove debug message

Joerg Roedel (1):
      x86/dma: unify definition of pci_unmap_addr* and pci_unmap_len macros

Joseph Cihula (1):
      x86: disable stack-protector for __restore_processor_state()

Tejun Heo (1):
      x86,percpu: fix inverted NUMA test in setup_pcpu_remap()

Yinghai Lu (1):
      x86: remove duplicated code with pcpu_need_numa()


 arch/x86/boot/Makefile             |    3 ++-
 arch/x86/boot/compressed/Makefile  |    1 +
 arch/x86/include/asm/pci.h         |   36 ++++++++++++++++++++++++++++++++----
 arch/x86/include/asm/pci_32.h      |   34 ----------------------------------
 arch/x86/include/asm/pci_64.h      |   22 ----------------------
 arch/x86/kernel/cpu/mtrr/generic.c |    3 ---
 arch/x86/kernel/setup_percpu.c     |   16 +---------------
 arch/x86/kernel/signal.c           |    2 +-
 arch/x86/mm/highmem_32.c           |    1 -
 arch/x86/mm/iomap_32.c             |    4 ++--
 arch/x86/power/Makefile            |    5 +++++
 11 files changed, 44 insertions(+), 83 deletions(-)
 delete mode 100644 arch/x86/include/asm/pci_32.h

diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
index fb737ce..6633b6e 100644
--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -57,6 +57,7 @@ $(obj)/cpustr.h: $(obj)/mkcpustr FORCE
 # How to compile the 16-bit code.  Note we always compile for -march=i386,
 # that way we can complain to the user if the CPU is insufficient.
 KBUILD_CFLAGS	:= $(LINUXINCLUDE) -g -Os -D_SETUP -D__KERNEL__ \
+		   -DDISABLE_BRANCH_PROFILING \
 		   -Wall -Wstrict-prototypes \
 		   -march=i386 -mregparm=3 \
 		   -include $(srctree)/$(src)/code16gcc.h \
@@ -66,7 +67,7 @@ KBUILD_CFLAGS	:= $(LINUXINCLUDE) -g -Os -D_SETUP -D__KERNEL__ \
 			$(call cc-option, -fno-unit-at-a-time)) \
 		   $(call cc-option, -fno-stack-protector) \
 		   $(call cc-option, -mpreferred-stack-boundary=2)
-KBUILD_CFLAGS +=   $(call cc-option,-m32)
+KBUILD_CFLAGS	+= $(call cc-option, -m32)
 KBUILD_AFLAGS	:= $(KBUILD_CFLAGS) -D__ASSEMBLY__
 
 $(obj)/bzImage: asflags-y  := $(SVGA_MODE)
diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index 3ca4c19..65551c9 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -8,6 +8,7 @@ targets := vmlinux vmlinux.bin vmlinux.bin.gz vmlinux.bin.bz2 vmlinux.bin.lzma h
 
 KBUILD_CFLAGS := -m$(BITS) -D__KERNEL__ $(LINUX_INCLUDE) -O2
 KBUILD_CFLAGS += -fno-strict-aliasing -fPIC
+KBUILD_CFLAGS += -DDISABLE_BRANCH_PROFILING
 cflags-$(CONFIG_X86_64) := -mcmodel=small
 KBUILD_CFLAGS += $(cflags-y)
 KBUILD_CFLAGS += $(call cc-option,-ffreestanding)
diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
index a0301bf..e545ea0 100644
--- a/arch/x86/include/asm/pci.h
+++ b/arch/x86/include/asm/pci.h
@@ -89,12 +89,40 @@ extern void pci_iommu_alloc(void);
 /* MSI arch hook */
 #define arch_setup_msi_irqs arch_setup_msi_irqs
 
-#endif  /* __KERNEL__ */
+#define PCI_DMA_BUS_IS_PHYS (dma_ops->is_phys)
+
+#if defined(CONFIG_X86_64) || defined(CONFIG_DMA_API_DEBUG)
+
+#define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)       \
+	        dma_addr_t ADDR_NAME;
+#define DECLARE_PCI_UNMAP_LEN(LEN_NAME)         \
+	        __u32 LEN_NAME;
+#define pci_unmap_addr(PTR, ADDR_NAME)                  \
+	        ((PTR)->ADDR_NAME)
+#define pci_unmap_addr_set(PTR, ADDR_NAME, VAL)         \
+	        (((PTR)->ADDR_NAME) = (VAL))
+#define pci_unmap_len(PTR, LEN_NAME)                    \
+	        ((PTR)->LEN_NAME)
+#define pci_unmap_len_set(PTR, LEN_NAME, VAL)           \
+	        (((PTR)->LEN_NAME) = (VAL))
 
-#ifdef CONFIG_X86_32
-# include "pci_32.h"
 #else
-# include "pci_64.h"
+
+#define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)       dma_addr_t ADDR_NAME[0];
+#define DECLARE_PCI_UNMAP_LEN(LEN_NAME) unsigned LEN_NAME[0];
+#define pci_unmap_addr(PTR, ADDR_NAME)  sizeof((PTR)->ADDR_NAME)
+#define pci_unmap_addr_set(PTR, ADDR_NAME, VAL) \
+	        do { break; } while (pci_unmap_addr(PTR, ADDR_NAME))
+#define pci_unmap_len(PTR, LEN_NAME)            sizeof((PTR)->LEN_NAME)
+#define pci_unmap_len_set(PTR, LEN_NAME, VAL) \
+	        do { break; } while (pci_unmap_len(PTR, LEN_NAME))
+
+#endif
+
+#endif  /* __KERNEL__ */
+
+#ifdef CONFIG_X86_64
+#include "pci_64.h"
 #endif
 
 /* implement the pci_ DMA API in terms of the generic device dma_ one */
diff --git a/arch/x86/include/asm/pci_32.h b/arch/x86/include/asm/pci_32.h
deleted file mode 100644
index 6f1213a..0000000
--- a/arch/x86/include/asm/pci_32.h
+++ /dev/null
@@ -1,34 +0,0 @@
-#ifndef _ASM_X86_PCI_32_H
-#define _ASM_X86_PCI_32_H
-
-
-#ifdef __KERNEL__
-
-
-/* Dynamic DMA mapping stuff.
- * i386 has everything mapped statically.
- */
-
-struct pci_dev;
-
-/* The PCI address space does equal the physical memory
- * address space.  The networking and block device layers use
- * this boolean for bounce buffer decisions.
- */
-#define PCI_DMA_BUS_IS_PHYS	(1)
-
-/* pci_unmap_{page,single} is a nop so... */
-#define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)	dma_addr_t ADDR_NAME[0];
-#define DECLARE_PCI_UNMAP_LEN(LEN_NAME)	unsigned LEN_NAME[0];
-#define pci_unmap_addr(PTR, ADDR_NAME)	sizeof((PTR)->ADDR_NAME)
-#define pci_unmap_addr_set(PTR, ADDR_NAME, VAL) \
-	do { break; } while (pci_unmap_addr(PTR, ADDR_NAME))
-#define pci_unmap_len(PTR, LEN_NAME)		sizeof((PTR)->LEN_NAME)
-#define pci_unmap_len_set(PTR, LEN_NAME, VAL) \
-	do { break; } while (pci_unmap_len(PTR, LEN_NAME))
-
-
-#endif /* __KERNEL__ */
-
-
-#endif /* _ASM_X86_PCI_32_H */
diff --git a/arch/x86/include/asm/pci_64.h b/arch/x86/include/asm/pci_64.h
index 4da2079..ae5e40f 100644
--- a/arch/x86/include/asm/pci_64.h
+++ b/arch/x86/include/asm/pci_64.h
@@ -24,28 +24,6 @@ extern int (*pci_config_write)(int seg, int bus, int dev, int fn,
 
 extern void dma32_reserve_bootmem(void);
 
-/* The PCI address space does equal the physical memory
- * address space.  The networking and block device layers use
- * this boolean for bounce buffer decisions
- *
- * On AMD64 it mostly equals, but we set it to zero if a hardware
- * IOMMU (gart) of sotware IOMMU (swiotlb) is available.
- */
-#define PCI_DMA_BUS_IS_PHYS (dma_ops->is_phys)
-
-#define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)	\
-	dma_addr_t ADDR_NAME;
-#define DECLARE_PCI_UNMAP_LEN(LEN_NAME)		\
-	__u32 LEN_NAME;
-#define pci_unmap_addr(PTR, ADDR_NAME)			\
-	((PTR)->ADDR_NAME)
-#define pci_unmap_addr_set(PTR, ADDR_NAME, VAL)		\
-	(((PTR)->ADDR_NAME) = (VAL))
-#define pci_unmap_len(PTR, LEN_NAME)			\
-	((PTR)->LEN_NAME)
-#define pci_unmap_len_set(PTR, LEN_NAME, VAL)		\
-	(((PTR)->LEN_NAME) = (VAL))
-
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_X86_PCI_64_H */
diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index 37f28fc..0b776c0 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -462,9 +462,6 @@ static void generic_get_mtrr(unsigned int reg, unsigned long *base,
 	*base = base_hi << (32 - PAGE_SHIFT) | base_lo >> PAGE_SHIFT;
 	*type = base_lo & 0xff;
 
-	printk(KERN_DEBUG "  get_mtrr: cpu%d reg%02d base=%010lx size=%010lx %s\n",
-			cpu, reg, *base, *size,
-			mtrr_attrib_to_str(*type & 0xff));
 out_put_cpu:
 	put_cpu();
 }
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 400331b..3a97a4c 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -153,7 +153,6 @@ static struct page * __init pcpur_get_page(unsigned int cpu, int pageno)
 static ssize_t __init setup_pcpu_remap(size_t static_size)
 {
 	static struct vm_struct vm;
-	pg_data_t *last;
 	size_t ptrs_size, dyn_size;
 	unsigned int cpu;
 	ssize_t ret;
@@ -162,22 +161,9 @@ static ssize_t __init setup_pcpu_remap(size_t static_size)
 	 * If large page isn't supported, there's no benefit in doing
 	 * this.  Also, on non-NUMA, embedding is better.
 	 */
-	if (!cpu_has_pse || pcpu_need_numa())
+	if (!cpu_has_pse || !pcpu_need_numa())
 		return -EINVAL;
 
-	last = NULL;
-	for_each_possible_cpu(cpu) {
-		int node = early_cpu_to_node(cpu);
-
-		if (node_online(node) && NODE_DATA(node) &&
-		    last && last != NODE_DATA(node))
-			goto proceed;
-
-		last = NODE_DATA(node);
-	}
-	return -EINVAL;
-
-proceed:
 	/*
 	 * Currently supports only single page.  Supporting multiple
 	 * pages won't be too difficult if it ever becomes necessary.
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index dfcc74a..1442516 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -221,7 +221,7 @@ get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, size_t frame_size,
 	if (!onsigstack) {
 		/* This is the X/Open sanctioned signal stack switching.  */
 		if (ka->sa.sa_flags & SA_ONSTACK) {
-			if (sas_ss_flags(sp) == 0)
+			if (current->sas_ss_size)
 				sp = current->sas_ss_sp + current->sas_ss_size;
 		} else {
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/mm/highmem_32.c b/arch/x86/mm/highmem_32.c
index 5bc5d16..8126e8d 100644
--- a/arch/x86/mm/highmem_32.c
+++ b/arch/x86/mm/highmem_32.c
@@ -40,7 +40,6 @@ void *kmap_atomic_prot(struct page *page, enum km_type type, pgprot_t prot)
 
 	debug_kmap_atomic(type);
 
-	debug_kmap_atomic(type);
 	idx = type + KM_TYPE_NR*smp_processor_id();
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 	BUG_ON(!pte_none(*(kmap_pte-idx)));
diff --git a/arch/x86/mm/iomap_32.c b/arch/x86/mm/iomap_32.c
index bff0c90..8056545 100644
--- a/arch/x86/mm/iomap_32.c
+++ b/arch/x86/mm/iomap_32.c
@@ -23,7 +23,7 @@
 
 int is_io_mapping_possible(resource_size_t base, unsigned long size)
 {
-#ifndef CONFIG_X86_PAE
+#if !defined(CONFIG_X86_PAE) && defined(CONFIG_PHYS_ADDR_T_64BIT)
 	/* There is no way to map greater than 1 << 32 address without PAE */
 	if (base + size > 0x100000000ULL)
 		return 0;
@@ -39,6 +39,7 @@ void *kmap_atomic_prot_pfn(unsigned long pfn, enum km_type type, pgprot_t prot)
 
 	pagefault_disable();
 
+	debug_kmap_atomic(type);
 	idx = type + KM_TYPE_NR * smp_processor_id();
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 	set_pte(kmap_pte - idx, pfn_pte(pfn, prot));
@@ -72,7 +73,6 @@ iounmap_atomic(void *kvaddr, enum km_type type)
 	unsigned long vaddr = (unsigned long) kvaddr & PAGE_MASK;
 	enum fixed_addresses idx = type + KM_TYPE_NR*smp_processor_id();
 
-	debug_kmap_atomic(type);
 	/*
 	 * Force other mappings to Oops if they'll try to access this pte
 	 * without first remap it.  Keeping stale mappings around is a bad idea
diff --git a/arch/x86/power/Makefile b/arch/x86/power/Makefile
index 9ff4d5b..58b32db 100644
--- a/arch/x86/power/Makefile
+++ b/arch/x86/power/Makefile
@@ -1,2 +1,7 @@
+# __restore_processor_state() restores %gs after S3 resume and so should not
+# itself be stack-protected
+nostackp := $(call cc-option, -fno-stack-protector)
+CFLAGS_cpu_$(BITS).o	:= $(nostackp)
+
 obj-$(CONFIG_PM_SLEEP)		+= cpu_$(BITS).o
 obj-$(CONFIG_HIBERNATION)	+= hibernate_$(BITS).o hibernate_asm_$(BITS).o
