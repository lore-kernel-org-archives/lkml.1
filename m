Return-Path: <linux-kernel-owner+w=401wt.eu-S1758238AbXKZXUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758238AbXKZXUo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 18:20:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756876AbXKZXTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 18:19:08 -0500
Received: from relay1.sgi.com ([192.48.171.29]:60634 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757643AbXKZXTG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 18:19:06 -0500
Date: Mon, 26 Nov 2007 15:19:04 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: randy.dunlap@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] x86 allnoconfig memory model
In-Reply-To: <20071126135756.980c7072.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0711261518090.26358@schroedinger.engr.sgi.com>
References: <20071120204525.ff27ac98.akpm@linux-foundation.org>
 <20071126111320.69d0aead.randy.dunlap@oracle.com>
 <Pine.LNX.4.64.0711261127250.23080@schroedinger.engr.sgi.com>
 <20071126124730.34c43da1.randy.dunlap@oracle.com>
 <Pine.LNX.4.64.0711261258480.25688@schroedinger.engr.sgi.com>
 <20071126132036.343e3ee0.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0711261351270.26057@schroedinger.engr.sgi.com>
 <20071126135756.980c7072.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Nov 2007, Andrew Morton wrote:

> b) I go direct to master.kernel.org.  Probably that's only worth five
> minutes nowadays - it used to be worth hours, but kernel.org got better.

Updated patch (including Randy's fix) against git-x86 mm.



x86_64: Make sparsemem/vmemmap the only memory model V3

V2->V3:
- Rediff against mm git-x86

V1->V2:
- Rediff against new upstream x86 code that unifies the Kconfig files.

Use sparsemem as the only memory model for UP, SMP and NUMA.
Measurements indicate that DISCONTIGMEM has a higher overhead
than sparsemem. And FLATMEMs benefits are minimal. So I think its
best to simply standardize on sparsemem.

Results of page allocator tests (test can be had via git from slab git
tree branch tests)

Measurements in cycle counts. 1000 allocations were performed and then the
average cycle count was calculated.

Order	FlatMem	Discontig	SparseMem
0	  639	  665		  641
1	  567	  647		  593
2	  679	  774		  692
3	  763	  967		  781
4	  961	 1501		  962
5	 1356	 2344		 1392
6	 2224	 3982		 2336
7	 4869	 7225		 5074
8	12500	14048		12732
9	27926	28223		28165
10	58578	58714		58682

(Note that FlatMem is an SMP config and the rest NUMA configurations)

Memory use:

SMP Sparsemem
-------------

Kernel size:

   text    data     bss     dec     hex filename
3849268  397739 1264856 5511863  541ab7 vmlinux

             total       used       free     shared    buffers     cached
Mem:       8242252      41164    8201088          0        352      11512
-/+ buffers/cache:      29300    8212952
Swap:      9775512          0    9775512

SMP Flatmem
-----------

Kernel size:

   text    data     bss     dec     hex filename
3844612  397739 1264536 5506887  540747 vmlinux

So 4.5k growth in text size vs. FLATMEM.

             total       used       free     shared    buffers     cached
Mem:       8244052      40544    8203508          0        352      11484
-/+ buffers/cache:      28708    8215344

2k growth in overall memory use after boot.



NUMA discontig:

   text    data     bss     dec     hex filename
3888124  470659 1276504 5635287  55fcd7 vmlinux

             total       used       free     shared    buffers     cached
Mem:       8256256      56908    8199348          0        352      11496
-/+ buffers/cache:      45060    8211196
Swap:      9775512          0    9775512

NUMA sparse:

   text    data     bss     dec     hex filename
3896428  470659 1276824 5643911  561e87 vmlinux


8k text growth. Given that we fully inline virt_to_page and friends now
that is rather good.

             total       used       free     shared    buffers     cached
Mem:       8264720      57240    8207480          0        352      11516
-/+ buffers/cache:      45372    8219348
Swap:      9775512          0    9775512

The total available memory is increased by 8k.


This patch makes sparsemem the default and removes discontig and
flatmem support from x86.

Acked-by: Andi Kleen <ak@suse.de>
Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 arch/x86/Kconfig                   |   22 +++++---------
 arch/x86/configs/x86_64_defconfig  |    9 -----
 arch/x86/kernel/machine_kexec_64.c |    5 ---
 arch/x86/mm/init_64.c              |   30 -------------------
 arch/x86/mm/ioremap_64.c           |   17 -----------
 arch/x86/mm/numa_64.c              |   21 -------------
 arch/x86/mm/srat_64.c              |   57 -------------------------------------
 include/asm-x86/mmzone_64.h        |    6 ---
 include/asm-x86/page_64.h          |    3 -
 9 files changed, 9 insertions(+), 161 deletions(-)

Index: linux-2.6-x86/arch/x86/configs/x86_64_defconfig
===================================================================
--- linux-2.6-x86.orig/arch/x86/configs/x86_64_defconfig	2007-11-26 13:53:18.927361771 -0800
+++ linux-2.6-x86/arch/x86/configs/x86_64_defconfig	2007-11-26 15:15:41.430361615 -0800
@@ -145,15 +145,6 @@ CONFIG_K8_NUMA=y
 CONFIG_NODES_SHIFT=6
 CONFIG_X86_64_ACPI_NUMA=y
 CONFIG_NUMA_EMU=y
-CONFIG_ARCH_DISCONTIGMEM_ENABLE=y
-CONFIG_ARCH_DISCONTIGMEM_DEFAULT=y
-CONFIG_ARCH_SPARSEMEM_ENABLE=y
-CONFIG_SELECT_MEMORY_MODEL=y
-# CONFIG_FLATMEM_MANUAL is not set
-CONFIG_DISCONTIGMEM_MANUAL=y
-# CONFIG_SPARSEMEM_MANUAL is not set
-CONFIG_DISCONTIGMEM=y
-CONFIG_FLAT_NODE_MEM_MAP=y
 CONFIG_NEED_MULTIPLE_NODES=y
 # CONFIG_SPARSEMEM_STATIC is not set
 CONFIG_SPLIT_PTLOCK_CPUS=4
Index: linux-2.6-x86/arch/x86/kernel/machine_kexec_64.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/machine_kexec_64.c	2007-11-26 13:53:18.939362118 -0800
+++ linux-2.6-x86/arch/x86/kernel/machine_kexec_64.c	2007-11-26 15:15:41.430361615 -0800
@@ -234,10 +234,5 @@ NORET_TYPE void machine_kexec(struct kim
 void arch_crash_save_vmcoreinfo(void)
 {
 	VMCOREINFO_SYMBOL(init_level4_pgt);
-
-#ifdef CONFIG_ARCH_DISCONTIGMEM_ENABLE
-	VMCOREINFO_SYMBOL(node_data);
-	VMCOREINFO_LENGTH(node_data, MAX_NUMNODES);
-#endif
 }
 
Index: linux-2.6-x86/arch/x86/mm/ioremap_64.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/mm/ioremap_64.c	2007-11-26 13:53:18.951362033 -0800
+++ linux-2.6-x86/arch/x86/mm/ioremap_64.c	2007-11-26 15:15:41.430361615 -0800
@@ -86,23 +86,6 @@ void __iomem * __ioremap(unsigned long p
 	if (phys_addr >= ISA_START_ADDRESS && last_addr < ISA_END_ADDRESS)
 		return (__force void __iomem *)phys_to_virt(phys_addr);
 
-#ifdef CONFIG_FLATMEM
-	/*
-	 * Don't allow anybody to remap normal RAM that we're using..
-	 */
-	if (last_addr < virt_to_phys(high_memory)) {
-		char *t_addr, *t_end;
- 		struct page *page;
-
-		t_addr = __va(phys_addr);
-		t_end = t_addr + (size - 1);
-	   
-		for(page = virt_to_page(t_addr); page <= virt_to_page(t_end); page++)
-			if(!PageReserved(page))
-				return NULL;
-	}
-#endif
-
 	pgprot = __pgprot(_PAGE_PRESENT | _PAGE_RW | _PAGE_GLOBAL
 			  | _PAGE_DIRTY | _PAGE_ACCESSED | flags);
 	/*
Index: linux-2.6-x86/arch/x86/mm/numa_64.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/mm/numa_64.c	2007-11-26 15:15:26.130611458 -0800
+++ linux-2.6-x86/arch/x86/mm/numa_64.c	2007-11-26 15:15:41.430361615 -0800
@@ -153,12 +153,10 @@ int __init compute_hash_shift(struct boo
 	return shift;
 }
 
-#ifdef CONFIG_SPARSEMEM
 int early_pfn_to_nid(unsigned long pfn)
 {
 	return phys_to_nid(pfn << PAGE_SHIFT);
 }
-#endif
 
 static void * __init early_node_mem(int nodeid, unsigned long start,
 				    unsigned long end, unsigned long size)
@@ -635,23 +633,4 @@ void __init init_cpu_to_node(void)
 	}
 }
 
-#ifdef CONFIG_DISCONTIGMEM
-/*
- * Functions to convert PFNs from/to per node page addresses.
- * These are out of line because they are quite big.
- * They could be all tuned by pre caching more state.
- * Should do that.
- */
 
-int pfn_valid(unsigned long pfn)
-{
-	unsigned nid;
-	if (pfn >= num_physpages)
-		return 0;
-	nid = pfn_to_nid(pfn);
-	if (nid == 0xff)
-		return 0;
-	return pfn >= node_start_pfn(nid) && (pfn) < node_end_pfn(nid);
-}
-EXPORT_SYMBOL(pfn_valid);
-#endif
Index: linux-2.6-x86/include/asm-x86/mmzone_64.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/mmzone_64.h	2007-11-26 15:15:26.471361483 -0800
+++ linux-2.6-x86/include/asm-x86/mmzone_64.h	2007-11-26 15:15:41.430361615 -0800
@@ -43,12 +43,6 @@ static inline __attribute__((pure)) int 
 
 extern int early_pfn_to_nid(unsigned long pfn);
 
-#ifdef CONFIG_DISCONTIGMEM
-#define pfn_to_nid(pfn) phys_to_nid((unsigned long)(pfn) << PAGE_SHIFT)
-
-extern int pfn_valid(unsigned long pfn);
-#endif
-
 #ifdef CONFIG_NUMA_EMU
 #define FAKE_NODE_MIN_SIZE	(64*1024*1024)
 #define FAKE_NODE_MIN_HASH_MASK	(~(FAKE_NODE_MIN_SIZE - 1uL))
Index: linux-2.6-x86/include/asm-x86/page_64.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/page_64.h	2007-11-26 15:15:26.475361591 -0800
+++ linux-2.6-x86/include/asm-x86/page_64.h	2007-11-26 15:15:41.430361615 -0800
@@ -127,9 +127,6 @@ extern unsigned long __phys_addr(unsigne
 #define __va(x)			((void *)((unsigned long)(x)+PAGE_OFFSET))
 #define __boot_va(x)		__va(x)
 #define __boot_pa(x)		__pa(x)
-#ifdef CONFIG_FLATMEM
-#define pfn_valid(pfn)		((pfn) < end_pfn)
-#endif
 
 #define virt_to_page(kaddr)	pfn_to_page(__pa(kaddr) >> PAGE_SHIFT)
 #define virt_addr_valid(kaddr)	pfn_valid(__pa(kaddr) >> PAGE_SHIFT)
Index: linux-2.6-x86/arch/x86/mm/init_64.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/mm/init_64.c	2007-11-26 15:15:26.122611468 -0800
+++ linux-2.6-x86/arch/x86/mm/init_64.c	2007-11-26 15:15:41.430361615 -0800
@@ -486,34 +486,6 @@ EXPORT_SYMBOL_GPL(memory_add_physaddr_to
 
 #endif /* CONFIG_MEMORY_HOTPLUG */
 
-#ifdef CONFIG_MEMORY_HOTPLUG_RESERVE
-/*
- * Memory Hotadd without sparsemem. The mem_maps have been allocated in advance,
- * just online the pages.
- */
-int __add_pages(struct zone *z, unsigned long start_pfn, unsigned long nr_pages)
-{
-	int err = -EIO;
-	unsigned long pfn;
-	unsigned long total = 0, mem = 0;
-	for (pfn = start_pfn; pfn < start_pfn + nr_pages; pfn++) {
-		if (pfn_valid(pfn)) {
-			online_page(pfn_to_page(pfn));
-			err = 0;
-			mem++;
-		}
-		total++;
-	}
-	if (!err) {
-		z->spanned_pages += total;
-		z->present_pages += mem;
-		z->zone_pgdat->node_spanned_pages += total;
-		z->zone_pgdat->node_present_pages += mem;
-	}
-	return err;
-}
-#endif
-
 static struct kcore_list kcore_mem, kcore_vmalloc, kcore_kernel, kcore_modules,
 			 kcore_vsyscall;
 
@@ -739,7 +711,6 @@ const char *arch_vma_name(struct vm_area
 	return NULL;
 }
 
-#ifdef CONFIG_SPARSEMEM_VMEMMAP
 /*
  * Initialise the sparsemem vmemmap using huge-pages at the PMD level.
  */
@@ -782,4 +753,3 @@ int __meminit vmemmap_populate(struct pa
 
 	return 0;
 }
-#endif
Index: linux-2.6-x86/arch/x86/mm/srat_64.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/mm/srat_64.c	2007-11-26 13:53:18.983361973 -0800
+++ linux-2.6-x86/arch/x86/mm/srat_64.c	2007-11-26 15:15:41.434361980 -0800
@@ -151,62 +151,6 @@ acpi_numa_processor_affinity_init(struct
 	       pxm, pa->apic_id, node);
 }
 
-#ifdef CONFIG_MEMORY_HOTPLUG_RESERVE
-/*
- * Protect against too large hotadd areas that would fill up memory.
- */
-static int hotadd_enough_memory(struct bootnode *nd)
-{
-	static unsigned long allocated;
-	static unsigned long last_area_end;
-	unsigned long pages = (nd->end - nd->start) >> PAGE_SHIFT;
-	long mem = pages * sizeof(struct page);
-	unsigned long addr;
-	unsigned long allowed;
-	unsigned long oldpages = pages;
-
-	if (mem < 0)
-		return 0;
-	allowed = (end_pfn - absent_pages_in_range(0, end_pfn)) * PAGE_SIZE;
-	allowed = (allowed / 100) * hotadd_percent;
-	if (allocated + mem > allowed) {
-		unsigned long range;
-		/* Give them at least part of their hotadd memory upto hotadd_percent
-		   It would be better to spread the limit out
-		   over multiple hotplug areas, but that is too complicated
-		   right now */
-		if (allocated >= allowed)
-			return 0;
-		range = allowed - allocated;
-		pages = (range / PAGE_SIZE);
-		mem = pages * sizeof(struct page);
-		nd->end = nd->start + range;
-	}
-	/* Not completely fool proof, but a good sanity check */
-	addr = find_e820_area(last_area_end, end_pfn<<PAGE_SHIFT, mem);
-	if (addr == -1UL)
-		return 0;
-	if (pages != oldpages)
-		printk(KERN_NOTICE "SRAT: Hotadd area limited to %lu bytes\n",
-			pages << PAGE_SHIFT);
-	last_area_end = addr + mem;
-	allocated += mem;
-	return 1;
-}
-
-static int update_end_of_memory(unsigned long end)
-{
-	found_add_area = 1;
-	if ((end >> PAGE_SHIFT) > end_pfn)
-		end_pfn = end >> PAGE_SHIFT;
-	return 1;
-}
-
-static inline int save_add_info(void)
-{
-	return hotadd_percent > 0;
-}
-#else
 int update_end_of_memory(unsigned long end) {return -1;}
 static int hotadd_enough_memory(struct bootnode *nd) {return 1;}
 #ifdef CONFIG_MEMORY_HOTPLUG_SPARSE
@@ -214,7 +158,6 @@ static inline int save_add_info(void) {r
 #else
 static inline int save_add_info(void) {return 0;}
 #endif
-#endif
 /*
  * Update nodes_add and decide if to include add are in the zone.
  * Both SPARSE and RESERVE need nodes_add infomation.
Index: linux-2.6-x86/arch/x86/Kconfig
===================================================================
--- linux-2.6-x86.orig/arch/x86/Kconfig	2007-11-26 15:15:25.194361726 -0800
+++ linux-2.6-x86/arch/x86/Kconfig	2007-11-26 15:17:40.310569645 -0800
@@ -912,25 +912,29 @@ config HAVE_ARCH_ALLOC_REMAP
 
 config ARCH_FLATMEM_ENABLE
 	def_bool y
-	depends on (X86_32 && ARCH_SELECT_MEMORY_MODEL && X86_PC) || (X86_64 && !NUMA)
+	depends on X86_32 && ARCH_SELECT_MEMORY_MODEL && X86_PC
 
 config ARCH_DISCONTIGMEM_ENABLE
 	def_bool y
-	depends on NUMA
+	depends on NUMA && X86_32
 
 config ARCH_DISCONTIGMEM_DEFAULT
 	def_bool y
-	depends on NUMA
+	depends on NUMA && X86_32
+
+config ARCH_SPARSEMEM_DEFAULT
+	def_bool y
+	depends on X86_64
 
 config ARCH_SPARSEMEM_ENABLE
 	def_bool y
-	depends on NUMA || (EXPERIMENTAL && (X86_PC || X86_64))
+	depends on X86_64 || NUMA || (EXPERIMENTAL && X86_PC)
 	select SPARSEMEM_STATIC if X86_32
 	select SPARSEMEM_VMEMMAP_ENABLE if X86_64
 
 config ARCH_SELECT_MEMORY_MODEL
 	def_bool y
-	depends on X86_32 && ARCH_SPARSEMEM_ENABLE
+	depends on ARCH_SPARSEMEM_ENABLE
 
 config ARCH_MEMORY_PROBE
 	def_bool X86_64
@@ -1228,18 +1232,10 @@ config ARCH_ENABLE_MEMORY_HOTPLUG
 	def_bool y
 	depends on X86_64 || (X86_32 && HIGHMEM)
 
-config MEMORY_HOTPLUG_RESERVE
-	def_bool X86_64
-	depends on (MEMORY_HOTPLUG && DISCONTIGMEM)
-
 config HAVE_ARCH_EARLY_PFN_TO_NID
 	def_bool X86_64
 	depends on NUMA
 
-config OUT_OF_LINE_PFN_TO_PAGE
-	def_bool X86_64
-	depends on DISCONTIGMEM
-
 menu "Power management options"
 	depends on !X86_VOYAGER
 
 
