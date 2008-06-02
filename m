Return-Path: <linux-kernel-owner+w=401wt.eu-S1752867AbYFBEGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867AbYFBEGb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 00:06:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750788AbYFBEGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 00:06:21 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:34899 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbYFBEGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 00:06:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=rX6mNCR/E5w2ZTZi7SqOj0Vf6CuU4cXA2YQNYV1ZPJIBhGRe+mcKj6skhvE0brY6pSZpeo7XJEx+f/e6jDPqF6GxriIxUGz3FHmuG6WKP/Rb9r0JBgQRPMoOAkv3nvpjjUAarX9EbET/ynF2rnyUDB41QcgMo2d4V88fSVj+e14=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] x86: numa_32 avoid clash between ramdisk and kva
Date: Sun, 1 Jun 2008 21:06:31 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200805110030.15510.yhlu.kernel@gmail.com> <200805251000.10205.yhlu.kernel@gmail.com> <200805291625.56942.yhlu.kernel@gmail.com>
In-Reply-To: <200805291625.56942.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806012106.31650.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


use find_e820_area to get address space...

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/arch/x86/mm/discontig_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/discontig_32.c
+++ linux-2.6/arch/x86/mm/discontig_32.c
@@ -38,6 +38,7 @@
 #include <asm/setup.h>
 #include <asm/mmzone.h>
 #include <asm/bios_ebda.h>
+#include <asm/proto.h>
 
 struct pglist_data *node_data[MAX_NUMNODES] __read_mostly;
 EXPORT_SYMBOL(node_data);
@@ -304,7 +305,6 @@ unsigned long __init setup_memory(void)
 {
 	int nid;
 	unsigned long system_start_pfn, system_max_low_pfn;
-	unsigned long wasted_pages;
 
 	/*
 	 * When mapping a NUMA machine we allocate the node_mem_map arrays
@@ -315,29 +315,18 @@ unsigned long __init setup_memory(void)
 	 */
 	get_memcfg_numa();
 
-	kva_pages = calculate_numa_remap_pages();
+	kva_pages = round_up(calculate_numa_remap_pages(), PTRS_PER_PTE);
 
 	/* partially used pages are not usable - thus round upwards */
 	system_start_pfn = min_low_pfn = PFN_UP(init_pg_tables_end);
 
-	kva_start_pfn = find_max_low_pfn() - kva_pages;
-
-#ifdef CONFIG_BLK_DEV_INITRD
-	/* Numa kva area is below the initrd */
-	if (initrd_start)
-		kva_start_pfn = PFN_DOWN(initrd_start - PAGE_OFFSET)
-			- kva_pages;
-#endif
-
-	/*
-	 * We waste pages past at the end of the KVA for no good reason other
-	 * than how it is located. This is bad.
-	 */
-	wasted_pages = kva_start_pfn & (PTRS_PER_PTE-1);
-	kva_start_pfn -= wasted_pages;
-	kva_pages += wasted_pages;
-
 	system_max_low_pfn = max_low_pfn = find_max_low_pfn();
+	kva_start_pfn = round_down(max_low_pfn - kva_pages, PTRS_PER_PTE);
+	kva_start_pfn = find_e820_area(kva_start_pfn<<PAGE_SHIFT,
+				max_low_pfn<<PAGE_SHIFT,
+				kva_pages<<PAGE_SHIFT,
+				PTRS_PER_PTE<<PAGE_SHIFT) >> PAGE_SHIFT;
+
 	printk("kva_start_pfn ~ %ld find_max_low_pfn() ~ %ld\n",
 		kva_start_pfn, max_low_pfn);
 	printk("max_pfn = %ld\n", max_pfn);
