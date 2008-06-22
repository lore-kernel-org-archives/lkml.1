Return-Path: <linux-kernel-owner+w=401wt.eu-S1751966AbYFVJqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966AbYFVJqq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 05:46:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751783AbYFVJqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 05:46:06 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:11509 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbYFVJqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 05:46:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=AmGBpcuuPD3+YmAmhsdHXmgeTkSCiNnUb2y/2fr+yk1TXKOeJdT2Ly8uPopl9ko++4
         SwhggwOmsAkePQqMxi8gGAXbHGXvzBpSRBK+ZDm/BVEVu9oYkltd+FXqyLLDwm0h/2Jf
         fEqWqBs8NzanvjlCKfTsrxGx+YET3TI58FgR4=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] x86: introduce initmem_init for 32 bit
Date: Sun, 22 Jun 2008 02:45:39 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806180215.53755.yhlu.kernel@gmail.com> <200806212102.20941.yhlu.kernel@gmail.com> <200806220244.50256.yhlu.kernel@gmail.com>
In-Reply-To: <200806220244.50256.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806220245.39289.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/setup_32.c |   94 ---------------------------------------------
 arch/x86/mm/discontig_32.c |    4 -
 arch/x86/mm/init_32.c      |   90 +++++++++++++++++++++++++++++++++++++++++++
 include/asm-x86/page_32.h  |    5 ++
 4 files changed, 99 insertions(+), 94 deletions(-)

Index: linux-2.6/arch/x86/kernel/setup_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_32.c
+++ linux-2.6/arch/x86/kernel/setup_32.c
@@ -301,71 +301,11 @@ unsigned long __init find_max_low_pfn(vo
 	return max_low_pfn;
 }
 
-#ifndef CONFIG_NEED_MULTIPLE_NODES
-static void __init setup_bootmem_allocator(void);
-static unsigned long __init setup_memory(void)
-{
-	/*
-	 * partially used pages are not usable - thus
-	 * we are rounding upwards:
-	 */
-	min_low_pfn = PFN_UP(init_pg_tables_end);
-
-	max_low_pfn = find_max_low_pfn();
-
-#ifdef CONFIG_HIGHMEM
-	highstart_pfn = highend_pfn = max_pfn;
-	if (max_pfn > max_low_pfn) {
-		highstart_pfn = max_low_pfn;
-	}
-	memory_present(0, 0, highend_pfn);
-	printk(KERN_NOTICE "%ldMB HIGHMEM available.\n",
-		pages_to_mb(highend_pfn - highstart_pfn));
-	num_physpages = highend_pfn;
-	high_memory = (void *) __va(highstart_pfn * PAGE_SIZE - 1) + 1;
-#else
-	memory_present(0, 0, max_low_pfn);
-	num_physpages = max_low_pfn;
-	high_memory = (void *) __va(max_low_pfn * PAGE_SIZE - 1) + 1;
-#endif
-#ifdef CONFIG_FLATMEM
-	max_mapnr = num_physpages;
-#endif
-	printk(KERN_NOTICE "%ldMB LOWMEM available.\n",
-			pages_to_mb(max_low_pfn));
-
-	setup_bootmem_allocator();
-
-	return max_low_pfn;
-}
-
-static void __init zone_sizes_init(void)
-{
-	unsigned long max_zone_pfns[MAX_NR_ZONES];
-	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
-	max_zone_pfns[ZONE_DMA] =
-		virt_to_phys((char *)MAX_DMA_ADDRESS) >> PAGE_SHIFT;
-	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
-	remove_all_active_ranges();
-#ifdef CONFIG_HIGHMEM
-	max_zone_pfns[ZONE_HIGHMEM] = highend_pfn;
-	e820_register_active_regions(0, 0, highend_pfn);
-#else
-	e820_register_active_regions(0, 0, max_low_pfn);
-#endif
-
-	free_area_init_nodes(max_zone_pfns);
-}
-#else
-extern unsigned long __init setup_memory(void);
-extern void zone_sizes_init(void);
-#endif /* !CONFIG_NEED_MULTIPLE_NODES */
-
 #ifdef CONFIG_BLK_DEV_INITRD
 
 static bool do_relocate_initrd = false;
 
-static void __init reserve_initrd(void)
+void __init reserve_initrd(void)
 {
 	u64 ramdisk_image = boot_params.hdr.ramdisk_image;
 	u64 ramdisk_size  = boot_params.hdr.ramdisk_size;
@@ -481,36 +421,6 @@ static void __init relocate_initrd(void)
 
 #endif /* CONFIG_BLK_DEV_INITRD */
 
-void __init setup_bootmem_allocator(void)
-{
-	int i;
-	unsigned long bootmap_size, bootmap;
-	/*
-	 * Initialize the boot-time allocator (with low memory only):
-	 */
-	bootmap_size = bootmem_bootmap_pages(max_low_pfn)<<PAGE_SHIFT;
-	bootmap = find_e820_area(min_low_pfn<<PAGE_SHIFT,
-				 max_pfn_mapped<<PAGE_SHIFT, bootmap_size,
-				 PAGE_SIZE);
-	if (bootmap == -1L)
-		panic("Cannot find bootmem map of size %ld\n", bootmap_size);
-	reserve_early(bootmap, bootmap + bootmap_size, "BOOTMAP");
-#ifdef CONFIG_BLK_DEV_INITRD
-	reserve_initrd();
-#endif
-	bootmap_size = init_bootmem(bootmap >> PAGE_SHIFT, max_low_pfn);
-	printk(KERN_INFO "  mapped low ram: 0 - %08lx\n",
-		 max_pfn_mapped<<PAGE_SHIFT);
-	printk(KERN_INFO "  low ram: %08lx - %08lx\n",
-		 min_low_pfn<<PAGE_SHIFT, max_low_pfn<<PAGE_SHIFT);
-	printk(KERN_INFO "  bootmap %08lx - %08lx\n",
-		 bootmap, bootmap + bootmap_size);
-	for_each_online_node(i)
-		free_bootmem_with_active_regions(i, max_low_pfn);
-	early_res_to_bootmem(0, max_low_pfn<<PAGE_SHIFT);
-
-}
-
 /*
  * The node 0 pgdat is initialized before all of these because
  * it's needed for bootmem.  node>0 pgdats have their virtual
@@ -672,7 +582,7 @@ void __init setup_arch(char **cmdline_p)
         acpi_numa_init();
 #endif
 
-	max_low_pfn = setup_memory();
+	max_low_pfn = initmem_init(0, max_pfn);
 
 #ifdef CONFIG_ACPI_SLEEP
 	/*
Index: linux-2.6/arch/x86/mm/discontig_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/discontig_32.c
+++ linux-2.6/arch/x86/mm/discontig_32.c
@@ -309,8 +309,8 @@ static void init_remap_allocator(int nid
 		(ulong) node_remap_end_vaddr[nid]);
 }
 
-extern void setup_bootmem_allocator(void);
-unsigned long __init setup_memory(void)
+unsigned long __init initmem_init(unsigned long start_pfn,
+				  unsigned long end_pfn)
 {
 	int nid;
 	unsigned long system_start_pfn, system_max_low_pfn;
Index: linux-2.6/arch/x86/mm/init_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_32.c
+++ linux-2.6/arch/x86/mm/init_32.c
@@ -540,6 +540,96 @@ static void __init set_nx(void)
 }
 #endif
 
+#ifndef CONFIG_NEED_MULTIPLE_NODES
+extern unsigned long find_max_low_pfn(void);
+unsigned long __init initmem_init(unsigned long start_pfn,
+				  unsigned long end_pfn)
+{
+	/*
+	 * partially used pages are not usable - thus
+	 * we are rounding upwards:
+	 */
+	min_low_pfn = PFN_UP(init_pg_tables_end);
+
+	max_low_pfn = find_max_low_pfn();
+
+#ifdef CONFIG_HIGHMEM
+	highstart_pfn = highend_pfn = max_pfn;
+	if (max_pfn > max_low_pfn)
+		highstart_pfn = max_low_pfn;
+	memory_present(0, 0, highend_pfn);
+	printk(KERN_NOTICE "%ldMB HIGHMEM available.\n",
+		pages_to_mb(highend_pfn - highstart_pfn));
+	num_physpages = highend_pfn;
+	high_memory = (void *) __va(highstart_pfn * PAGE_SIZE - 1) + 1;
+#else
+	memory_present(0, 0, max_low_pfn);
+	num_physpages = max_low_pfn;
+	high_memory = (void *) __va(max_low_pfn * PAGE_SIZE - 1) + 1;
+#endif
+#ifdef CONFIG_FLATMEM
+	max_mapnr = num_physpages;
+#endif
+	printk(KERN_NOTICE "%ldMB LOWMEM available.\n",
+			pages_to_mb(max_low_pfn));
+
+	setup_bootmem_allocator();
+
+	return max_low_pfn;
+}
+
+void __init zone_sizes_init(void)
+{
+	unsigned long max_zone_pfns[MAX_NR_ZONES];
+	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
+	max_zone_pfns[ZONE_DMA] =
+		virt_to_phys((char *)MAX_DMA_ADDRESS) >> PAGE_SHIFT;
+	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
+	remove_all_active_ranges();
+#ifdef CONFIG_HIGHMEM
+	max_zone_pfns[ZONE_HIGHMEM] = highend_pfn;
+	e820_register_active_regions(0, 0, highend_pfn);
+#else
+	e820_register_active_regions(0, 0, max_low_pfn);
+#endif
+
+	free_area_init_nodes(max_zone_pfns);
+}
+#endif /* !CONFIG_NEED_MULTIPLE_NODES */
+
+extern void reserve_initrd(void);
+
+void __init setup_bootmem_allocator(void)
+{
+	int i;
+	unsigned long bootmap_size, bootmap;
+	/*
+	 * Initialize the boot-time allocator (with low memory only):
+	 */
+	bootmap_size = bootmem_bootmap_pages(max_low_pfn)<<PAGE_SHIFT;
+	bootmap = find_e820_area(min_low_pfn<<PAGE_SHIFT,
+				 max_pfn_mapped<<PAGE_SHIFT, bootmap_size,
+				 PAGE_SIZE);
+	if (bootmap == -1L)
+		panic("Cannot find bootmem map of size %ld\n", bootmap_size);
+	reserve_early(bootmap, bootmap + bootmap_size, "BOOTMAP");
+#ifdef CONFIG_BLK_DEV_INITRD
+	reserve_initrd();
+#endif
+	bootmap_size = init_bootmem(bootmap >> PAGE_SHIFT, max_low_pfn);
+	printk(KERN_INFO "  mapped low ram: 0 - %08lx\n",
+		 max_pfn_mapped<<PAGE_SHIFT);
+	printk(KERN_INFO "  low ram: %08lx - %08lx\n",
+		 min_low_pfn<<PAGE_SHIFT, max_low_pfn<<PAGE_SHIFT);
+	printk(KERN_INFO "  bootmap %08lx - %08lx\n",
+		 bootmap, bootmap + bootmap_size);
+	for_each_online_node(i)
+		free_bootmem_with_active_regions(i, max_low_pfn);
+	early_res_to_bootmem(0, max_low_pfn<<PAGE_SHIFT);
+
+}
+
+
 /*
  * paging_init() sets up the page tables - note that the first 8MB are
  * already mapped by head.S.
Index: linux-2.6/include/asm-x86/page_32.h
===================================================================
--- linux-2.6.orig/include/asm-x86/page_32.h
+++ linux-2.6/include/asm-x86/page_32.h
@@ -97,6 +97,11 @@ extern int sysctl_legacy_va_layout;
 #define VMALLOC_RESERVE		((unsigned long)__VMALLOC_RESERVE)
 #define MAXMEM			(-__PAGE_OFFSET - __VMALLOC_RESERVE)
 
+extern unsigned long initmem_init(unsigned long, unsigned long);
+extern void zone_sizes_init(void);
+extern void setup_bootmem_allocator(void);
+
+
 #ifdef CONFIG_X86_USE_3DNOW
 #include <asm/mmx.h>
 
