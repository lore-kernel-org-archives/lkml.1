Return-Path: <linux-kernel-owner+w=401wt.eu-S1757253AbXKTBPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253AbXKTBPo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:15:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756184AbXKTBNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:13:41 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36857 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753423AbXKTBNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:13:34 -0500
Message-Id: <20071120011333.619991903@sgi.com>
References: <20071120011132.143632442@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 19 Nov 2007 17:11:40 -0800
From: clameter@sgi.com
From: Christoph Lameter <clameter@sgi.com>
To: ak@suse.de
Cc: akpm@linux-foundation.org
Cc: travis@sgi.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org
Subject: [rfc 08/45] cpu alloc: x86 support
Content-Disposition: inline; filename=cpu_alloc_x86_support
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

64 bit:

Set up a cpu area that allows the use of up 16MB for each processor.

Cpu memory use can grow a bit. F.e. if we assume that a pageset
occupies 64 bytes of memory and we have 3 zones in each of 1024 nodes
then we need 3 * 1k * 16k = 50 million pagesets or 3096 pagesets per
processor. This results in a total of 3.2 GB of page structs.
Each cpu needs around 200k of cpu storage for the page allocator alone.
So its a worth it to use a 2M huge mapping here.

For the UP and SMP case map the area using 4k ptes. Typical use of per cpu
data is around 16k for UP and SMP configurations. It goes up to 45k when the
per cpu area is managed by cpu_alloc (see special x86_64 patchset).
Allocating in 2M segments would be overkill.

For NUMA map the area using 2M PMDs. A large NUMA system may use
lots of cpu data for the page allocator data alone. We typically
have large amounts of memory around on those size. Using a 2M page size
reduces TLB pressure for that case.

Some numbers for envisioned maximum configurations of NUMA systems:

4k cpu configurations with 1k nodes:

	4096 * 16MB = 64TB of virtual space.

Maximum theoretical configuration 16384 processors 1k nodes:

	16384 * 16MB = 256TB of virtual space.

Both fit within the established limits established.

32 bit:

Setup a 256 kB area for the cpu areas below the FIXADDR area.

The use of the cpu alloc area is pretty minimal on i386. An 8p system
with no extras uses only ~8kb. So 256kb should be plenty. A configuration
that supports up to 8 processors takes up 2MB of the scarce
virtual address space

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 arch/x86/Kconfig                 |   13 +++++++++++++
 arch/x86/kernel/vmlinux_32.lds.S |    1 +
 arch/x86/kernel/vmlinux_64.lds.S |    3 +++
 arch/x86/mm/init_32.c            |    3 +++
 arch/x86/mm/init_64.c            |   38 ++++++++++++++++++++++++++++++++++++++
 include/asm-x86/pgtable_32.h     |    7 +++++--
 include/asm-x86/pgtable_64.h     |    1 +
 7 files changed, 64 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/mm/init_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_64.c	2007-11-19 15:45:07.602390533 -0800
+++ linux-2.6/arch/x86/mm/init_64.c	2007-11-19 15:55:53.165640248 -0800
@@ -781,3 +781,41 @@ int __meminit vmemmap_populate(struct pa
 	return 0;
 }
 #endif
+
+#ifdef CONFIG_NUMA
+int __meminit cpu_area_populate(void *start, unsigned long size,
+						gfp_t flags, int node)
+{
+	unsigned long addr = (unsigned long)start;
+	unsigned long end = addr + size;
+	unsigned long next;
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+
+	for (; addr < end; addr = next) {
+		next = pmd_addr_end(addr, end);
+
+		pgd = cpu_area_pgd_populate(addr, flags, node);
+		if (!pgd)
+			return -ENOMEM;
+		pud = cpu_area_pud_populate(pgd, addr, flags, node);
+		if (!pud)
+			return -ENOMEM;
+
+		pmd = pmd_offset(pud, addr);
+		if (pmd_none(*pmd)) {
+			pte_t entry;
+			void *p = cpu_area_alloc_block(PMD_SIZE, flags, node);
+			if (!p)
+				return -ENOMEM;
+
+			entry = pfn_pte(__pa(p) >> PAGE_SHIFT, PAGE_KERNEL);
+			mk_pte_huge(entry);
+			set_pmd(pmd, __pmd(pte_val(entry)));
+		}
+	}
+
+	return 0;
+}
+#endif
Index: linux-2.6/include/asm-x86/pgtable_64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/pgtable_64.h	2007-11-19 15:45:07.638390147 -0800
+++ linux-2.6/include/asm-x86/pgtable_64.h	2007-11-19 15:55:53.165640248 -0800
@@ -138,6 +138,7 @@ static inline pte_t ptep_get_and_clear_f
 #define VMALLOC_START    _AC(0xffffc20000000000, UL)
 #define VMALLOC_END      _AC(0xffffe1ffffffffff, UL)
 #define VMEMMAP_START	 _AC(0xffffe20000000000, UL)
+#define CPU_AREA_BASE	 _AC(0xffffffff84000000, UL)
 #define MODULES_VADDR    _AC(0xffffffff88000000, UL)
 #define MODULES_END      _AC(0xfffffffffff00000, UL)
 #define MODULES_LEN   (MODULES_END - MODULES_VADDR)
Index: linux-2.6/arch/x86/Kconfig
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig	2007-11-19 15:54:10.509139813 -0800
+++ linux-2.6/arch/x86/Kconfig	2007-11-19 15:55:53.165640248 -0800
@@ -159,6 +159,19 @@ config X86_TRAMPOLINE
 
 config KTIME_SCALAR
 	def_bool X86_32
+
+config CPU_AREA_VIRTUAL
+	bool
+	default y
+
+config CPU_AREA_ORDER
+	int
+	default "6"
+
+config CPU_AREA_ALLOC_ORDER
+	int
+	default "0"
+
 source "init/Kconfig"
 
 menu "Processor type and features"
Index: linux-2.6/arch/x86/mm/init_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_32.c	2007-11-19 15:45:07.610390367 -0800
+++ linux-2.6/arch/x86/mm/init_32.c	2007-11-19 15:55:53.165640248 -0800
@@ -674,6 +674,7 @@ void __init mem_init(void)
 #if 1 /* double-sanity-check paranoia */
 	printk("virtual kernel memory layout:\n"
 	       "    fixmap  : 0x%08lx - 0x%08lx   (%4ld kB)\n"
+	       "    cpu area: 0x%08lx - 0x%08lx   (%4ld kb)\n"
 #ifdef CONFIG_HIGHMEM
 	       "    pkmap   : 0x%08lx - 0x%08lx   (%4ld kB)\n"
 #endif
@@ -684,6 +685,8 @@ void __init mem_init(void)
 	       "      .text : 0x%08lx - 0x%08lx   (%4ld kB)\n",
 	       FIXADDR_START, FIXADDR_TOP,
 	       (FIXADDR_TOP - FIXADDR_START) >> 10,
+	       CPU_AREA_BASE, FIXADDR_START,
+	       (FIXADDR_START - CPU_AREA_BASE) >> 10,
 
 #ifdef CONFIG_HIGHMEM
 	       PKMAP_BASE, PKMAP_BASE+LAST_PKMAP*PAGE_SIZE,
Index: linux-2.6/include/asm-x86/pgtable_32.h
===================================================================
--- linux-2.6.orig/include/asm-x86/pgtable_32.h	2007-11-19 15:45:07.646390299 -0800
+++ linux-2.6/include/asm-x86/pgtable_32.h	2007-11-19 15:55:53.165640248 -0800
@@ -79,11 +79,14 @@ void paging_init(void);
 #define VMALLOC_START	(((unsigned long) high_memory + \
 			2*VMALLOC_OFFSET-1) & ~(VMALLOC_OFFSET-1))
 #ifdef CONFIG_HIGHMEM
-# define VMALLOC_END	(PKMAP_BASE-2*PAGE_SIZE)
+# define CPU_AREA_BASE	(PKMAP_BASE - NR_CPUS * \
+				(1 << (CONFIG_CPU_AREA_ORDER + PAGE_SHIFT)))
 #else
-# define VMALLOC_END	(FIXADDR_START-2*PAGE_SIZE)
+# define CPU_AREA_BASE	(FIXADDR_START - NR_CPUS * \
+				(1 << (CONFIG_CPU_AREA_ORDER + PAGE_SHIFT)))
 #endif
 
+#define VMALLOC_END	(CPU_AREA_BASE - 2 * PAGE_SIZE)
 /*
  * _PAGE_PSE set in the page directory entry just means that
  * the page directory entry points directly to a 4MB-aligned block of
Index: linux-2.6/arch/x86/kernel/vmlinux_32.lds.S
===================================================================
--- linux-2.6.orig/arch/x86/kernel/vmlinux_32.lds.S	2007-11-19 15:45:07.622390531 -0800
+++ linux-2.6/arch/x86/kernel/vmlinux_32.lds.S	2007-11-19 15:55:53.165640248 -0800
@@ -26,6 +26,7 @@ OUTPUT_FORMAT("elf32-i386", "elf32-i386"
 OUTPUT_ARCH(i386)
 ENTRY(phys_startup_32)
 jiffies = jiffies_64;
+cpu_area = CPU_AREA_BASE;
 
 PHDRS {
 	text PT_LOAD FLAGS(5);	/* R_E */
Index: linux-2.6/arch/x86/kernel/vmlinux_64.lds.S
===================================================================
--- linux-2.6.orig/arch/x86/kernel/vmlinux_64.lds.S	2007-11-19 15:45:07.630390395 -0800
+++ linux-2.6/arch/x86/kernel/vmlinux_64.lds.S	2007-11-19 15:55:53.165640248 -0800
@@ -6,6 +6,7 @@
 
 #include <asm-generic/vmlinux.lds.h>
 #include <asm/page.h>
+#include <asm/pgtable_64.h>
 
 #undef i386	/* in case the preprocessor is a 32bit one */
 
@@ -14,6 +15,8 @@ OUTPUT_ARCH(i386:x86-64)
 ENTRY(phys_startup_64)
 jiffies_64 = jiffies;
 _proxy_pda = 1;
+cpu_area = CPU_AREA_BASE;
+
 PHDRS {
 	text PT_LOAD FLAGS(5);	/* R_E */
 	data PT_LOAD FLAGS(7);	/* RWE */

-- 
