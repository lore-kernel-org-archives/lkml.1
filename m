Return-Path: <linux-kernel-owner+w=401wt.eu-S1753308AbYFVJqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308AbYFVJqQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 05:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751358AbYFVJqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 05:46:00 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:11679 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbYFVJp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 05:45:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=tZA++VYpMaJmItcOrCI3ztYTx/YJBRsZHU6puhdPnxSLWqasAdxKQkSBjdRNDPE3Gt
         IIUAXjwWxSmAaP/zLWztru4seZdt10cbaOeGNvg1A8XM7uaz/PGmDCHhW9fvKYWIPDMU
         3NJkq2niX85u3W97Un5oK8oZJHZXqsh7ldnPc=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] x86: introduce initmem_init for 64 bit
Date: Sun, 22 Jun 2008 02:44:49 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806180215.53755.yhlu.kernel@gmail.com> <200806212022.10077.yhlu.kernel@gmail.com> <200806212102.20941.yhlu.kernel@gmail.com>
In-Reply-To: <200806212102.20941.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806220244.50256.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/setup_64.c |   25 +------------------------
 arch/x86/mm/init_64.c      |   16 ++++++++++++++++
 arch/x86/mm/numa_64.c      |    2 +-
 include/asm-x86/numa_64.h  |    1 -
 include/asm-x86/page_64.h  |    1 +
 5 files changed, 19 insertions(+), 26 deletions(-)

Index: linux-2.6/arch/x86/kernel/setup_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_64.c
+++ linux-2.6/arch/x86/kernel/setup_64.c
@@ -130,25 +130,6 @@ static struct resource bss_resource = {
 	.flags = IORESOURCE_RAM,
 };
 
-#ifndef CONFIG_NUMA
-static void __init
-contig_initmem_init(unsigned long start_pfn, unsigned long end_pfn)
-{
-	unsigned long bootmap_size, bootmap;
-
-	bootmap_size = bootmem_bootmap_pages(end_pfn)<<PAGE_SHIFT;
-	bootmap = find_e820_area(0, end_pfn<<PAGE_SHIFT, bootmap_size,
-				 PAGE_SIZE);
-	if (bootmap == -1L)
-		panic("Cannot find bootmem map of size %ld\n", bootmap_size);
-	bootmap_size = init_bootmem(bootmap >> PAGE_SHIFT, end_pfn);
-	e820_register_active_regions(0, start_pfn, end_pfn);
-	free_bootmem_with_active_regions(0, end_pfn);
-	early_res_to_bootmem(0, end_pfn<<PAGE_SHIFT);
-	reserve_bootmem(bootmap, bootmap_size, BOOTMEM_DEFAULT);
-}
-#endif
-
 #if defined(CONFIG_EDD) || defined(CONFIG_EDD_MODULE)
 struct edd edd;
 #ifdef CONFIG_EDD_MODULE
@@ -309,11 +290,7 @@ void __init setup_arch(char **cmdline_p)
 	acpi_numa_init();
 #endif
 
-#ifdef CONFIG_NUMA
-	numa_initmem_init(0, end_pfn);
-#else
-	contig_initmem_init(0, end_pfn);
-#endif
+	initmem_init(0, end_pfn);
 
 	dma32_reserve_bootmem();
 
Index: linux-2.6/arch/x86/mm/init_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_64.c
+++ linux-2.6/arch/x86/mm/init_64.c
@@ -624,6 +624,22 @@ unsigned long __init_refok init_memory_m
 }
 
 #ifndef CONFIG_NUMA
+void __init initmem_init(unsigned long start_pfn, unsigned long end_pfn)
+{
+	unsigned long bootmap_size, bootmap;
+
+	bootmap_size = bootmem_bootmap_pages(end_pfn)<<PAGE_SHIFT;
+	bootmap = find_e820_area(0, end_pfn<<PAGE_SHIFT, bootmap_size,
+				 PAGE_SIZE);
+	if (bootmap == -1L)
+		panic("Cannot find bootmem map of size %ld\n", bootmap_size);
+	bootmap_size = init_bootmem(bootmap >> PAGE_SHIFT, end_pfn);
+	e820_register_active_regions(0, start_pfn, end_pfn);
+	free_bootmem_with_active_regions(0, end_pfn);
+	early_res_to_bootmem(0, end_pfn<<PAGE_SHIFT);
+	reserve_bootmem(bootmap, bootmap_size, BOOTMEM_DEFAULT);
+}
+
 void __init paging_init(void)
 {
 	unsigned long max_zone_pfns[MAX_NR_ZONES];
Index: linux-2.6/arch/x86/mm/numa_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/numa_64.c
+++ linux-2.6/arch/x86/mm/numa_64.c
@@ -514,7 +514,7 @@ out:
 }
 #endif /* CONFIG_NUMA_EMU */
 
-void __init numa_initmem_init(unsigned long start_pfn, unsigned long last_pfn)
+void __init initmem_init(unsigned long start_pfn, unsigned long last_pfn)
 {
 	int i;
 
Index: linux-2.6/include/asm-x86/numa_64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/numa_64.h
+++ linux-2.6/include/asm-x86/numa_64.h
@@ -22,7 +22,6 @@ extern int hotadd_percent;
 
 extern s16 apicid_to_node[MAX_LOCAL_APIC];
 
-extern void numa_initmem_init(unsigned long start_pfn, unsigned long end_pfn);
 extern unsigned long numa_free_all_bootmem(void);
 extern void setup_node_bootmem(int nodeid, unsigned long start,
 			       unsigned long end);
Index: linux-2.6/include/asm-x86/page_64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/page_64.h
+++ linux-2.6/include/asm-x86/page_64.h
@@ -83,6 +83,7 @@ typedef struct { pteval_t pte; } pte_t;
 extern unsigned long init_memory_mapping(unsigned long start,
 					 unsigned long end);
 
+extern void initmem_init(unsigned long start_pfn, unsigned long end_pfn);
 #endif	/* !__ASSEMBLY__ */
 
 #ifdef CONFIG_FLATMEM
