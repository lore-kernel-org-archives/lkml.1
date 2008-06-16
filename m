Return-Path: <linux-kernel-owner+w=401wt.eu-S1758870AbYFPXK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758870AbYFPXK2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 19:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754958AbYFPXKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 19:10:19 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:16322 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754323AbYFPXKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 19:10:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :message-id;
        b=J4UxRQwuRzcw+8IsDGRjk1LZw3sPbqkqDPqRM6RjzeI3DP+/GqPxMWDzizvY0f6H/B
         idg/UjpUoQiqbSsihKgvTG7dtWqAVMnsfGL2j+DjS7a3gu8t1yZ2mdZvX+nut5NpLAOS
         BOUhEQCpZwz76qcULkd6tP65ZPaZdWd0LjYb8=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: kill bad_ppro
Date: Mon, 16 Jun 2008 16:11:08 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806161611.08952.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


so don't punish all other cpus without that problem when init highmem

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/arch/x86/kernel/setup_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_32.c
+++ linux-2.6/arch/x86/kernel/setup_32.c
@@ -69,6 +69,7 @@
 #include <asm/cacheflush.h>
 #include <asm/processor.h>
 #include <asm/efi.h>
+#include <asm/bugs.h>
 
 /* This value is set up by the early boot code to point to the value
    immediately after the boot time page tables.  It contains a *physical*
@@ -776,6 +777,14 @@ void __init setup_arch(char **cmdline_p)
 	if (efi_enabled)
 		efi_init();
 
+	if (ppro_with_ram_bug()) {
+		e820_update_range(0x70000000ULL, 0x40000ULL, E820_RAM,
+				  E820_RESERVED);
+		sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
+		printk(KERN_INFO "fixed physical RAM map:\n");
+		e820_print_map("bad_ppro");
+	}
+
 	e820_register_active_regions(0, 0, -1UL);
 	/*
 	 * partially used pages are not usable - thus
Index: linux-2.6/arch/x86/mm/discontig_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/discontig_32.c
+++ linux-2.6/arch/x86/mm/discontig_32.c
@@ -405,7 +405,7 @@ void __init zone_sizes_init(void)
 	return;
 }
 
-void __init set_highmem_pages_init(int bad_ppro) 
+void __init set_highmem_pages_init(void)
 {
 #ifdef CONFIG_HIGHMEM
 	struct zone *zone;
@@ -425,7 +425,7 @@ void __init set_highmem_pages_init(int b
 				zone->name, nid, zone_start_pfn, zone_end_pfn);
 
 		add_highpages_with_active_regions(nid, zone_start_pfn,
-				 zone_end_pfn, bad_ppro);
+				 zone_end_pfn);
 	}
 	totalram_pages += totalhigh_pages;
 #endif
Index: linux-2.6/arch/x86/mm/init_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_32.c
+++ linux-2.6/arch/x86/mm/init_32.c
@@ -225,13 +225,6 @@ static void __init kernel_physical_mappi
 	update_page_count(PG_LEVEL_4K, pages_4k);
 }
 
-static inline int page_kills_ppro(unsigned long pagenr)
-{
-	if (pagenr >= 0x70000 && pagenr <= 0x7003F)
-		return 1;
-	return 0;
-}
-
 /*
  * devmem_is_allowed() checks to see if /dev/mem access to a certain address
  * is valid. The argument is a physical page number.
@@ -292,22 +285,17 @@ static void __init permanent_kmaps_init(
 	pkmap_page_table = pte;
 }
 
-static void __init
-add_one_highpage_init(struct page *page, int pfn, int bad_ppro)
+static void __init add_one_highpage_init(struct page *page, int pfn)
 {
-	if (!(bad_ppro && page_kills_ppro(pfn))) {
-		ClearPageReserved(page);
-		init_page_count(page);
-		__free_page(page);
-		totalhigh_pages++;
-	} else
-		SetPageReserved(page);
+	ClearPageReserved(page);
+	init_page_count(page);
+	__free_page(page);
+	totalhigh_pages++;
 }
 
 struct add_highpages_data {
 	unsigned long start_pfn;
 	unsigned long end_pfn;
-	int bad_ppro;
 };
 
 static void __init add_highpages_work_fn(unsigned long start_pfn,
@@ -317,10 +305,8 @@ static void __init add_highpages_work_fn
 	struct page *page;
 	unsigned long final_start_pfn, final_end_pfn;
 	struct add_highpages_data *data;
-	int bad_ppro;
 
 	data = (struct add_highpages_data *)datax;
-	bad_ppro = data->bad_ppro;
 
 	final_start_pfn = max(start_pfn, data->start_pfn);
 	final_end_pfn = min(end_pfn, data->end_pfn);
@@ -332,29 +318,26 @@ static void __init add_highpages_work_fn
 		if (!pfn_valid(node_pfn))
 			continue;
 		page = pfn_to_page(node_pfn);
-		add_one_highpage_init(page, node_pfn, bad_ppro);
+		add_one_highpage_init(page, node_pfn);
 	}
 
 }
 
 void __init add_highpages_with_active_regions(int nid, unsigned long start_pfn,
-					      unsigned long end_pfn,
-					      int bad_ppro)
+					      unsigned long end_pfn)
 {
 	struct add_highpages_data data;
 
 	data.start_pfn = start_pfn;
 	data.end_pfn = end_pfn;
-	data.bad_ppro = bad_ppro;
 
 	work_with_active_regions(nid, add_highpages_work_fn, &data);
 }
 
 #ifndef CONFIG_NUMA
-static void __init set_highmem_pages_init(int bad_ppro)
+static void __init set_highmem_pages_init(void)
 {
-	add_highpages_with_active_regions(0, highstart_pfn, highend_pfn,
-						bad_ppro);
+	add_highpages_with_active_regions(0, highstart_pfn, highend_pfn);
 
 	totalram_pages += totalhigh_pages;
 }
@@ -363,7 +346,7 @@ static void __init set_highmem_pages_ini
 #else
 # define kmap_init()				do { } while (0)
 # define permanent_kmaps_init(pgd_base)		do { } while (0)
-# define set_highmem_pages_init(bad_ppro)	do { } while (0)
+# define set_highmem_pages_init()	do { } while (0)
 #endif /* CONFIG_HIGHMEM */
 
 pteval_t __PAGE_KERNEL = _PAGE_KERNEL;
@@ -610,13 +593,11 @@ static struct kcore_list kcore_mem, kcor
 void __init mem_init(void)
 {
 	int codesize, reservedpages, datasize, initsize;
-	int tmp, bad_ppro;
+	int tmp;
 
 #ifdef CONFIG_FLATMEM
 	BUG_ON(!mem_map);
 #endif
-	bad_ppro = ppro_with_ram_bug();
-
 	/* this will put all low memory onto the freelists */
 	totalram_pages += free_all_bootmem();
 
@@ -628,7 +609,7 @@ void __init mem_init(void)
 		if (page_is_ram(tmp) && PageReserved(pfn_to_page(tmp)))
 			reservedpages++;
 
-	set_highmem_pages_init(bad_ppro);
+	set_highmem_pages_init();
 
 	codesize =  (unsigned long) &_etext - (unsigned long) &_text;
 	datasize =  (unsigned long) &_edata - (unsigned long) &_etext;
Index: linux-2.6/include/asm-x86/highmem.h
===================================================================
--- linux-2.6.orig/include/asm-x86/highmem.h
+++ linux-2.6/include/asm-x86/highmem.h
@@ -75,7 +75,7 @@ struct page *kmap_atomic_to_page(void *p
 #define flush_cache_kmaps()	do { } while (0)
 
 extern void add_highpages_with_active_regions(int nid, unsigned long start_pfn,
-					unsigned long end_pfn, int bad_ppro);
+					unsigned long end_pfn);
 
 #endif /* __KERNEL__ */
 
Index: linux-2.6/include/asm-x86/numa_32.h
===================================================================
--- linux-2.6.orig/include/asm-x86/numa_32.h
+++ linux-2.6/include/asm-x86/numa_32.h
@@ -6,7 +6,7 @@ extern void numa_remove_cpu(int cpu);
 
 #ifdef CONFIG_NUMA
 extern void __init remap_numa_kva(void);
-extern void set_highmem_pages_init(int);
+extern void set_highmem_pages_init(void);
 #else
 static inline void remap_numa_kva(void)
 {
