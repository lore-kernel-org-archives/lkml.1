Return-Path: <linux-kernel-owner+w=401wt.eu-S1762989AbYGBH3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762989AbYGBH3e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 03:29:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759850AbYGBH30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 03:29:26 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:20427 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759386AbYGBH3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 03:29:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=QKNqCfzxr6UYM1+GgGZnTgtitzbkxNTxOyW5Lpc574fGTssixR+4EvdzA1HKBz/ddP
         MT54AAOHZoCRF775AkGxA4e26zvDIZUYHoSEiBcq2rf59xAHMtpn0Yw5v9DoEXeZ/mFY
         4FSM6D9rEGwDc7s+4zN0k5OPP1IvSpHT0/1Mg=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: merge zones_sizes_init for numa and non numa on 32bit
Date: Wed, 2 Jul 2008 00:31:02 -0700
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>
References: <200806301834.59156.yhlu.kernel@gmail.com>
In-Reply-To: <200806301834.59156.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807020031.02945.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


move out e820_register_active_regions from non numa zones_sizes_init()
and remove numa version zones_sizes_init().

and let 32 bit call remove_all_active_ranges in setup_arch directly like 64 bit

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/setup.c    |    2 --
 arch/x86/mm/discontig_32.c |   16 ----------------
 arch/x86/mm/init_32.c      |   10 ++++------
 include/asm-x86/page_32.h  |    1 -
 4 files changed, 4 insertions(+), 25 deletions(-)

Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -719,10 +719,8 @@ void __init setup_arch(char **cmdline_p)
 	 */
 	acpi_boot_table_init();
 
-#ifdef CONFIG_X86_64
 	/* Remove active ranges so rediscovery with NUMA-awareness happens */
 	remove_all_active_ranges();
-#endif
 
 #ifdef CONFIG_ACPI_NUMA
 	/*
Index: linux-2.6/arch/x86/mm/discontig_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/discontig_32.c
+++ linux-2.6/arch/x86/mm/discontig_32.c
@@ -327,7 +327,6 @@ void __init initmem_init(unsigned long s
 	 * and ZONE_HIGHMEM.
 	 */
 
-	remove_all_active_ranges();
 	get_memcfg_numa();
 
 	kva_pages = round_up(calculate_numa_remap_pages(), PTRS_PER_PTE);
@@ -390,21 +389,6 @@ void __init initmem_init(unsigned long s
 	setup_bootmem_allocator();
 }
 
-void __init zone_sizes_init(void)
-{
-	unsigned long max_zone_pfns[MAX_NR_ZONES];
-	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
-	max_zone_pfns[ZONE_DMA] =
-		virt_to_phys((char *)MAX_DMA_ADDRESS) >> PAGE_SHIFT;
-	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
-#ifdef CONFIG_HIGHMEM
-	max_zone_pfns[ZONE_HIGHMEM] = highend_pfn;
-#endif
-
-	free_area_init_nodes(max_zone_pfns);
-	return;
-}
-
 void __init set_highmem_pages_init(void)
 {
 #ifdef CONFIG_HIGHMEM
Index: linux-2.6/arch/x86/mm/init_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_32.c
+++ linux-2.6/arch/x86/mm/init_32.c
@@ -660,12 +660,14 @@ void __init initmem_init(unsigned long s
 	if (max_pfn > max_low_pfn)
 		highstart_pfn = max_low_pfn;
 	memory_present(0, 0, highend_pfn);
+	e820_register_active_regions(0, 0, highend_pfn);
 	printk(KERN_NOTICE "%ldMB HIGHMEM available.\n",
 		pages_to_mb(highend_pfn - highstart_pfn));
 	num_physpages = highend_pfn;
 	high_memory = (void *) __va(highstart_pfn * PAGE_SIZE - 1) + 1;
 #else
 	memory_present(0, 0, max_low_pfn);
+	e820_register_active_regions(0, 0, max_low_pfn);
 	num_physpages = max_low_pfn;
 	high_memory = (void *) __va(max_low_pfn * PAGE_SIZE - 1) + 1;
 #endif
@@ -677,25 +679,21 @@ void __init initmem_init(unsigned long s
 
 	setup_bootmem_allocator();
 }
+#endif /* !CONFIG_NEED_MULTIPLE_NODES */
 
-void __init zone_sizes_init(void)
+static void __init zone_sizes_init(void)
 {
 	unsigned long max_zone_pfns[MAX_NR_ZONES];
 	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
 	max_zone_pfns[ZONE_DMA] =
 		virt_to_phys((char *)MAX_DMA_ADDRESS) >> PAGE_SHIFT;
 	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
-	remove_all_active_ranges();
 #ifdef CONFIG_HIGHMEM
 	max_zone_pfns[ZONE_HIGHMEM] = highend_pfn;
-	e820_register_active_regions(0, 0, highend_pfn);
-#else
-	e820_register_active_regions(0, 0, max_low_pfn);
 #endif
 
 	free_area_init_nodes(max_zone_pfns);
 }
-#endif /* !CONFIG_NEED_MULTIPLE_NODES */
 
 void __init setup_bootmem_allocator(void)
 {
Index: linux-2.6/include/asm-x86/page_32.h
===================================================================
--- linux-2.6.orig/include/asm-x86/page_32.h
+++ linux-2.6/include/asm-x86/page_32.h
@@ -101,7 +101,6 @@ extern void find_low_pfn_range(void);
 extern unsigned long init_memory_mapping(unsigned long start,
 					 unsigned long end);
 extern void initmem_init(unsigned long, unsigned long);
-extern void zone_sizes_init(void);
 extern void setup_bootmem_allocator(void);
 
 
