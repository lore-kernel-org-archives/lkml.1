Return-Path: <linux-kernel-owner+w=401wt.eu-S1759994AbYE2T7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759994AbYE2T7v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 15:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759451AbYE2T7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 15:59:11 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:34417 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757884AbYE2T7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 15:59:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=whGI7N3KiOO6CYHOC0rgKsdeY92Ov6Tpqx99ZEYEHpeg3w3IfChGWbA6xFZN0wMIWtIrLYgIs/PJd/fhrp8mkIbwd1cR4NEFQT8YbrrGiM6vwVNOOjaSm0N1a9ajYX+A4XrrXOADnLGLmvQtaw8oFsMwciaMIxkkDT2BuRld9eA=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH] x86: extend e820 early_res support 32bit -fix #5
Date: Thu, 29 May 2008 12:58:37 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200805110030.15510.yhlu.kernel@gmail.com> <200805211840.18619.yhlu.kernel@gmail.com> <200805251000.10205.yhlu.kernel@gmail.com>
In-Reply-To: <200805251000.10205.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805291258.38067.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


reserve early numa kva, so it will not clash with new RAMDISK

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/arch/x86/kernel/setup_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_32.c
+++ linux-2.6/arch/x86/kernel/setup_32.c
@@ -615,7 +615,6 @@ void __init setup_bootmem_allocator(void
 	 */
 	find_smp_config();
 #endif
-	numa_kva_reserve();
 	reserve_crashkernel();
 
 	reserve_ibft_region();
Index: linux-2.6/arch/x86/mm/discontig_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/discontig_32.c
+++ linux-2.6/arch/x86/mm/discontig_32.c
@@ -334,6 +334,11 @@ unsigned long __init setup_memory(void)
 	printk("kva_start_pfn ~ %ld find_max_low_pfn() ~ %ld\n",
 		kva_start_pfn, max_low_pfn);
 	printk("max_pfn = %ld\n", max_pfn);
+
+	/* avoid clash with initrd */
+	reserve_early(kva_start_pfn<<PAGE_SHIFT,
+		      (kva_start_pfn + kva_pages)<<PAGE_SHIFT,
+		     "KVA PG");
 #ifdef CONFIG_HIGHMEM
 	highstart_pfn = highend_pfn = max_pfn;
 	if (max_pfn > system_max_low_pfn)
@@ -369,13 +374,6 @@ unsigned long __init setup_memory(void)
 	return max_low_pfn;
 }
 
-void __init numa_kva_reserve(void)
-{
-	if (kva_pages)
-		reserve_bootmem(PFN_PHYS(kva_start_pfn), PFN_PHYS(kva_pages),
-				BOOTMEM_DEFAULT);
-}
-
 void __init zone_sizes_init(void)
 {
 	int nid;
Index: linux-2.6/include/asm-x86/mmzone_32.h
===================================================================
--- linux-2.6.orig/include/asm-x86/mmzone_32.h
+++ linux-2.6/include/asm-x86/mmzone_32.h
@@ -38,16 +38,12 @@ static inline void get_memcfg_numa(void)
 }
 
 extern int early_pfn_to_nid(unsigned long pfn);
-extern void numa_kva_reserve(void);
 
 #else /* !CONFIG_NUMA */
 
 #define get_memcfg_numa get_memcfg_numa_flat
 #define get_zholes_size(n) (0)
 
-static inline void numa_kva_reserve(void)
-{
-}
 #endif /* CONFIG_NUMA */
 
 #ifdef CONFIG_DISCONTIGMEM
