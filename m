Return-Path: <linux-kernel-owner+w=401wt.eu-S1756535AbZD0Jy4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535AbZD0Jy4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 05:54:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755014AbZD0Jss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 05:48:48 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:60685 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754474AbZD0Jsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 05:48:46 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 07/30] microblaze_mmu_v1: MMU initialization
Date: Mon, 27 Apr 2009 10:31:56 +0200
Message-Id: <1240821139-7247-8-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1240821139-7247-7-git-send-email-monstr@monstr.eu>
References: <1240821139-7247-1-git-send-email-monstr@monstr.eu>
 <1240821139-7247-2-git-send-email-monstr@monstr.eu>
 <1240821139-7247-3-git-send-email-monstr@monstr.eu>
 <1240821139-7247-4-git-send-email-monstr@monstr.eu>
 <1240821139-7247-5-git-send-email-monstr@monstr.eu>
 <1240821139-7247-6-git-send-email-monstr@monstr.eu>
 <1240821139-7247-7-git-send-email-monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/mm/init.c |  168 ++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 167 insertions(+), 1 deletions(-)

diff --git a/arch/microblaze/mm/init.c b/arch/microblaze/mm/init.c
index b0c8213..32a54cb 100644
--- a/arch/microblaze/mm/init.c
+++ b/arch/microblaze/mm/init.c
@@ -23,9 +23,17 @@
 #include <asm/sections.h>
 #include <asm/tlb.h>
 
+#ifndef CONFIG_MMU
 unsigned int __page_offset;
 /* EXPORT_SYMBOL(__page_offset); */
 
+#else
+DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
+
+int mem_init_done;
+static int init_bootmem_done;
+#endif /* CONFIG_MMU */
+
 char *klimit = _end;
 
 /*
@@ -61,6 +69,7 @@ void __init setup_memory(void)
 {
 	int i;
 	unsigned long map_size;
+#ifndef CONFIG_MMU
 	u32 kernel_align_start, kernel_align_size;
 
 	/* Find main memory where is the kernel */
@@ -93,6 +102,7 @@ void __init setup_memory(void)
 		__func__, kernel_align_start, kernel_align_start
 			+ kernel_align_size, kernel_align_size);
 
+#endif
 	/*
 	 * Kernel:
 	 * start: base phys address of kernel - page align
@@ -121,9 +131,13 @@ void __init setup_memory(void)
 	 * for 4GB of memory, using 4kB pages), plus 1 page
 	 * (in case the address isn't page-aligned).
 	 */
+#ifndef CONFIG_MMU
 	map_size = init_bootmem_node(NODE_DATA(0), PFN_UP(TOPHYS((u32)_end)),
 					min_low_pfn, max_low_pfn);
-
+#else
+	map_size = init_bootmem_node(&contig_page_data,
+		PFN_UP(TOPHYS((u32)_end)), min_low_pfn, max_low_pfn);
+#endif
 	lmb_reserve(PFN_UP(TOPHYS((u32)_end)) << PAGE_SHIFT, map_size);
 
 	/* free bootmem is whole main memory */
@@ -137,6 +151,9 @@ void __init setup_memory(void)
 		reserve_bootmem(lmb.reserved.region[i].base,
 			lmb_size_bytes(&lmb.reserved, i) - 1, BOOTMEM_DEFAULT);
 	}
+#ifdef CONFIG_MMU
+	init_bootmem_done = 1;
+#endif
 	paging_init();
 }
 
@@ -191,11 +208,160 @@ void __init mem_init(void)
 	printk(KERN_INFO "Memory: %luk/%luk available\n",
 	       (unsigned long) nr_free_pages() << (PAGE_SHIFT-10),
 	       num_physpages << (PAGE_SHIFT-10));
+#ifdef CONFIG_MMU
+	mem_init_done = 1;
+#endif
 }
 
+#ifndef CONFIG_MMU
 /* Check against bounds of physical memory */
 int ___range_ok(unsigned long addr, unsigned long size)
 {
 	return ((addr < memory_start) ||
 		((addr + size) > memory_end));
 }
+
+#else
+int page_is_ram(unsigned long pfn)
+{
+	return pfn < max_low_pfn;
+}
+
+/*
+ * Check for command-line options that affect what MMU_init will do.
+ */
+static void MMU_setup(void)
+{
+#if 0
+	/* Check for nobats option (used in mapin_ram). */
+	if (strstr(cmd_line, "nobats"))
+		__map_without_bats = 1;
+
+	/* Look for mem= option on command line */
+	if (strstr(cmd_line, "mem=")) {
+		char *p, *q;
+		unsigned long maxmem = 0;
+
+		for (q = cmd_line; (p = strstr(q, "mem=")) != 0; ) {
+			q = p + 4;
+			if (p > cmd_line && p[-1] != ' ')
+				continue;
+			maxmem = strict_strtoul(q, &q, NULL);
+			if (*q == 'k' || *q == 'K') {
+				maxmem <<= 10;
+				++q;
+			} else if (*q == 'm' || *q == 'M') {
+				maxmem <<= 20;
+				++q;
+			}
+		}
+		__max_memory = maxmem;
+	}
+
+/*	if (__max_memory && memory_size > __max_memory)
+		memory_size = __max_memory; */
+
+#endif
+}
+
+/*
+ * MMU_init_hw does the chip-specific initialization of the MMU hardware.
+ */
+static void __init MMU_init_hw(void)
+{
+	/*
+	 * The Zone Protection Register (ZPR) defines how protection will
+	 * be applied to every page which is a member of a given zone. At
+	 * present, we utilize only two of the zones.
+	 * The zone index bits (of ZSEL) in the PTE are used for software
+	 * indicators, except the LSB.  For user access, zone 1 is used,
+	 * for kernel access, zone 0 is used.  We set all but zone 1
+	 * to zero, allowing only kernel access as indicated in the PTE.
+	 * For zone 1, we set a 01 binary (a value of 10 will not work)
+	 * to allow user access as indicated in the PTE.  This also allows
+	 * kernel access as indicated in the PTE.
+	 */
+	__asm__ __volatile__ ("ori r11, r0, 0x10000000;" \
+			"mts rzpr, r11;"
+			: : : "r11");
+}
+
+/*
+ * MMU_init sets up the basic memory mappings for the kernel,
+ * including both RAM and possibly some I/O regions,
+ * and sets up the page tables and the MMU hardware ready to go.
+ */
+
+/* called from head.S */
+asmlinkage void __init MMU_init(void)
+{
+	unsigned int kstart, ksize;
+
+	if (!lmb.reserved.cnt) {
+		printk(KERN_EMERG "Error memory count\n");
+		machine_restart(NULL);
+	}
+
+	if ((u32) lmb.memory.region[0].size < 0x1000000) {
+		printk(KERN_EMERG "Memory must be greater than 16MB\n");
+		machine_restart(NULL);
+	}
+	/* Find main memory where the kernel is */
+	memory_start = (u32) lmb.memory.region[0].base;
+	memory_end = (u32) lmb.memory.region[0].base +
+				(u32) lmb.memory.region[0].size;
+	memory_size = memory_end - memory_start;
+
+	MMU_setup(); /* FIXME parse args from command line - not used */
+
+	/*
+	 * Map out the kernel text/data/bss from the available physical
+	 * memory.
+	 */
+	kstart = __pa(CONFIG_KERNEL_START); /* kernel start */
+	/* kernel size */
+	ksize = PAGE_ALIGN(((u32)_end - (u32)CONFIG_KERNEL_START));
+	lmb_reserve(kstart, ksize);
+
+#if defined(CONFIG_BLK_DEV_INITRD)
+	/* Remove the init RAM disk from the available memory. */
+/*	if (initrd_start) {
+		mem_pieces_remove(&phys_avail, __pa(initrd_start),
+				  initrd_end - initrd_start, 1);
+	}*/
+#endif /* CONFIG_BLK_DEV_INITRD */
+
+	/* Initialize the MMU hardware */
+	MMU_init_hw();
+
+	/* Map in all of RAM starting at CONFIG_KERNEL_START */
+	mapin_ram();
+
+#ifdef HIGHMEM_START_BOOL
+	ioremap_base = HIGHMEM_START;
+#else
+	ioremap_base = 0xfe000000UL;	/* for now, could be 0xfffff000 */
+#endif /* CONFIG_HIGHMEM */
+	ioremap_bot = ioremap_base;
+
+	/* Initialize the context management stuff */
+	mmu_context_init();
+}
+
+/* This is only called until mem_init is done. */
+void __init *early_get_page(void)
+{
+	void *p;
+	if (init_bootmem_done) {
+		p = alloc_bootmem_pages(PAGE_SIZE);
+	} else {
+		/*
+		 * Mem start + 32MB -> here is limit
+		 * because of mem mapping from head.S
+		 */
+		p = __va(lmb_alloc_base(PAGE_SIZE, PAGE_SIZE,
+					memory_start + 0x2000000));
+	}
+	return p;
+}
+#endif /* CONFIG_MMU */
-- 
1.5.5.1

