Return-Path: <linux-kernel-owner+w=401wt.eu-S1761738AbZE0Hcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761738AbZE0Hcx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762412AbZE0H1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:27:08 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:46942 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761539AbZE0H1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:27:06 -0400
From: Michal Simek <monstr@monstr.eu>
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, microblaze-uclinux@itee.uq.edu.au,
       michal.simek@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 05/29] microblaze_mmu_v2: MMU initialization
Date: Wed, 27 May 2009 08:47:30 +0200
Message-Id: <1243406874-3917-6-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1243406874-3917-5-git-send-email-monstr@monstr.eu>
References: <1243406874-3917-1-git-send-email-monstr@monstr.eu>
 <1243406874-3917-2-git-send-email-monstr@monstr.eu>
 <1243406874-3917-3-git-send-email-monstr@monstr.eu>
 <1243406874-3917-4-git-send-email-monstr@monstr.eu>
 <1243406874-3917-5-git-send-email-monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/mm/init.c |  158 +++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 154 insertions(+), 4 deletions(-)

diff --git a/arch/microblaze/mm/init.c b/arch/microblaze/mm/init.c
index af789e2..b5a701c 100644
--- a/arch/microblaze/mm/init.c
+++ b/arch/microblaze/mm/init.c
@@ -23,18 +23,26 @@
 #include <asm/sections.h>
 #include <asm/tlb.h>
 
+#ifndef CONFIG_MMU
 unsigned int __page_offset;
 EXPORT_SYMBOL(__page_offset);
 
+#else
+DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
+
+int mem_init_done;
+static int init_bootmem_done;
+#endif /* CONFIG_MMU */
+
 char *klimit = _end;
 
 /*
  * Initialize the bootmem system and give it all the memory we
  * have available.
  */
-unsigned int memory_start;
-unsigned int memory_end; /* due to mm/nommu.c */
-unsigned int memory_size;
+unsigned long memory_start;
+unsigned long memory_end; /* due to mm/nommu.c */
+unsigned long memory_size;
 
 /*
  * paging_init() sets up the page tables - in fact we've already done this.
@@ -59,6 +67,7 @@ void __init setup_memory(void)
 {
 	int i;
 	unsigned long map_size;
+#ifndef CONFIG_MMU
 	u32 kernel_align_start, kernel_align_size;
 
 	/* Find main memory where is the kernel */
@@ -91,6 +100,7 @@ void __init setup_memory(void)
 		__func__, kernel_align_start, kernel_align_start
 			+ kernel_align_size, kernel_align_size);
 
+#endif
 	/*
 	 * Kernel:
 	 * start: base phys address of kernel - page align
@@ -119,9 +129,13 @@ void __init setup_memory(void)
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
@@ -135,6 +149,9 @@ void __init setup_memory(void)
 		reserve_bootmem(lmb.reserved.region[i].base,
 			lmb_size_bytes(&lmb.reserved, i) - 1, BOOTMEM_DEFAULT);
 	}
+#ifdef CONFIG_MMU
+	init_bootmem_done = 1;
+#endif
 	paging_init();
 }
 
@@ -189,8 +206,12 @@ void __init mem_init(void)
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
@@ -198,3 +219,132 @@ int ___range_ok(unsigned long addr, unsigned long size)
 		((addr + size) > memory_end));
 }
 EXPORT_SYMBOL(___range_ok);
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
+static void mm_cmdline_setup(void)
+{
+	unsigned long maxmem = 0;
+	char *p = cmd_line;
+
+	/* Look for mem= option on command line */
+	p = strstr(cmd_line, "mem=");
+	if (p) {
+		p += 4;
+		maxmem = memparse(p, &p);
+		if (maxmem && memory_size > maxmem) {
+			memory_size = maxmem;
+			memory_end = memory_start + memory_size;
+			lmb.memory.region[0].size = memory_size;
+		}
+	}
+}
+
+/*
+ * MMU_init_hw does the chip-specific initialization of the MMU hardware.
+ */
+static void __init mmu_init_hw(void)
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
+asmlinkage void __init mmu_init(void)
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
+	mm_cmdline_setup(); /* FIXME parse args from command line - not used */
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
+	mmu_init_hw();
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

