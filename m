Return-Path: <linux-kernel-owner+w=401wt.eu-S1756492AbYFZEuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492AbYFZEuU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 00:50:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750866AbYFZEuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 00:50:06 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:20368 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbYFZEuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 00:50:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=Uu5HXGj1/bKObIUz0LmQwEAvehG44KD+DDx6FSmAMi0wW0pItD3JxU1Qe0e+1SyukJ
         CsqRa8jtCfvkHbG6KhtLhR4o8c8LMl/BdqolA54NdBYN0RR1ByCGOJQ57cFIG4t99mc8
         pH0qxrskCf/Lnih30nQuSYOJ+HD1ZUUmK9ixQ=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] x86: move fix mapping page table range early
Date: Wed, 25 Jun 2008 21:51:28 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806251748.06743.yhlu.kernel@gmail.com>
In-Reply-To: <200806251748.06743.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806252151.29028.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


do that in init_memory_mapping

also remove one init_ohci1394_dma_on_all_controllers

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/setup.c |   23 +++++++++--------------
 arch/x86/mm/init_32.c   |   15 +++++++++++----
 2 files changed, 20 insertions(+), 18 deletions(-)

Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -615,11 +615,6 @@ void __init setup_arch(char **cmdline_p)
 
 #ifdef CONFIG_X86_32
 	probe_roms();
-#else
-# ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
-	if (init_ohci1394_dma_early)
-		init_ohci1394_dma_on_all_controllers();
-# endif
 #endif
 
 	/* after parse_early_param, so could debug it */
@@ -679,6 +674,15 @@ void __init setup_arch(char **cmdline_p)
 #endif
 	init_memory_mapping(0, (max_low_pfn << PAGE_SHIFT));
 
+	/*
+	 * NOTE: On x86-32, only from this point on, fixmaps are ready for use.
+	 */
+
+#ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
+	if (init_ohci1394_dma_early)
+		init_ohci1394_dma_on_all_controllers();
+#endif
+
 	reserve_initrd();
 
 #ifdef CONFIG_X86_64
@@ -746,15 +750,6 @@ void __init setup_arch(char **cmdline_p)
 	map_vsyscall();
 #endif
 
-	/*
-	 * NOTE: On x86-32, only from this point on, fixmaps are ready for use.
-	 */
-
-#if defined(CONFIG_PROVIDE_OHCI1394_DMA_INIT) && defined(CONFIG_X86_32)
-	if (init_ohci1394_dma_early)
-		init_ohci1394_dma_on_all_controllers();
-#endif
-
 #ifdef CONFIG_X86_GENERICARCH
 	generic_apic_probe();
 #endif
Index: linux-2.6/arch/x86/mm/init_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_32.c
+++ linux-2.6/arch/x86/mm/init_32.c
@@ -442,13 +442,10 @@ void __init native_pagetable_setup_done(
  * be partially populated, and so it avoids stomping on any existing
  * mappings.
  */
-static void __init pagetable_init(void)
+static void __init early_ioremap_page_table_range_init(pgd_t *pgd_base)
 {
-	pgd_t *pgd_base = swapper_pg_dir;
 	unsigned long vaddr, end;
 
-	paravirt_pagetable_setup_start(pgd_base);
-
 	/*
 	 * Fixed mappings, only the page table structure has to be
 	 * created - mappings will be set by set_fixmap():
@@ -458,6 +455,13 @@ static void __init pagetable_init(void)
 	end = (FIXADDR_TOP + PMD_SIZE - 1) & PMD_MASK;
 	page_table_range_init(vaddr, end, pgd_base);
 	early_ioremap_reset();
+}
+
+static void __init pagetable_init(void)
+{
+	pgd_t *pgd_base = swapper_pg_dir;
+
+	paravirt_pagetable_setup_start(pgd_base);
 
 	permanent_kmaps_init(pgd_base);
 
@@ -783,6 +787,8 @@ unsigned long __init_refok init_memory_m
 
 	kernel_physical_mapping_init(pgd_base, start, end);
 
+	early_ioremap_page_table_range_init(pgd_base);
+
 	load_cr3(swapper_pg_dir);
 
 	__flush_tlb_all();
@@ -794,6 +800,7 @@ unsigned long __init_refok init_memory_m
 	return end >> PAGE_SHIFT;
 }
 
+
 /*
  * paging_init() sets up the page tables - note that the first 8MB are
  * already mapped by head.S.
