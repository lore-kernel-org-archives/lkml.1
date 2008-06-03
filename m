Return-Path: <linux-kernel-owner+w=401wt.eu-S1756661AbYFCCRN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661AbYFCCRN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 22:17:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753747AbYFCCQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 22:16:59 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:53882 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700AbYFCCQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 22:16:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=q/fZxuJMKTj7QCU7LGose/xtAN9426uY7cW++5LLkO9ME79UXU5qDWMKbxShiFzIoHVPFw58qxppJKgnsbVmH35c6jT6XvwhYAIbAykTNeR1/AuM9sKj5NxTulowgCStPKLNYAWG+xEU0lPH48aXmYK7Siz/BfG9cb13fwM/q/Q=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] x86: change propagate_e820_map back to find_max_pfn -32bit -v2
Date: Mon, 2 Jun 2008 19:16:48 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200805110030.15510.yhlu.kernel@gmail.com> <200805312251.52297.yhlu.kernel@gmail.com> <200805312252.47727.yhlu.kernel@gmail.com>
In-Reply-To: <200805312252.47727.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806021916.49103.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


we don't need to call memory_present that early.
numa dist and sparse will call memory_present later
and even fail, it will call memory_present for all range.

v2: add memory_present calling for sparse and non numa

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/arch/x86/kernel/e820_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820_32.c
+++ linux-2.6/arch/x86/kernel/e820_32.c
@@ -210,7 +210,7 @@ void __init init_iomem_resources(struct 
 /*
  * Find the highest page frame number we have available
  */
-void __init propagate_e820_map(void)
+void __init find_max_pfn(void)
 {
 	int i;
 
@@ -227,7 +227,6 @@ void __init propagate_e820_map(void)
 			continue;
 		if (end > max_pfn)
 			max_pfn = end;
-		memory_present(0, start, end);
 	}
 }
 
@@ -361,7 +360,7 @@ static int __init parse_memmap(char *arg
 		 * size before original memory map is
 		 * reset.
 		 */
-		propagate_e820_map();
+		find_max_pfn();
 		saved_max_pfn = max_pfn;
 #endif
 		e820.nr_map = 0;
Index: linux-2.6/arch/x86/kernel/setup_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_32.c
+++ linux-2.6/arch/x86/kernel/setup_32.c
@@ -378,11 +378,13 @@ static unsigned long __init setup_memory
 	if (max_pfn > max_low_pfn) {
 		highstart_pfn = max_low_pfn;
 	}
+	memory_present(0, 0, highend_pfn);
 	printk(KERN_NOTICE "%ldMB HIGHMEM available.\n",
 		pages_to_mb(highend_pfn - highstart_pfn));
 	num_physpages = highend_pfn;
 	high_memory = (void *) __va(highstart_pfn * PAGE_SIZE - 1) + 1;
 #else
+	memory_present(0, 0, max_low_pfn);
 	num_physpages = max_low_pfn;
 	high_memory = (void *) __va(max_low_pfn * PAGE_SIZE - 1) + 1;
 #endif
@@ -742,10 +744,10 @@ void __init setup_arch(char **cmdline_p)
 		efi_init();
 
 	/* update e820 for memory not covered by WB MTRRs */
-	propagate_e820_map();
+	find_max_pfn();
 	mtrr_bp_init();
 	if (mtrr_trim_uncached_memory(max_pfn))
-		propagate_e820_map();
+		find_max_pfn();
 
 	max_low_pfn = setup_memory();
 
Index: linux-2.6/arch/x86/mm/discontig_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/discontig_32.c
+++ linux-2.6/arch/x86/mm/discontig_32.c
@@ -120,7 +120,7 @@ int __init get_memcfg_numa_flat(void)
 	printk("NUMA - single node, flat memory mode\n");
 
 	/* Run the memory configuration and find the top of memory. */
-	propagate_e820_map();
+	find_max_pfn();
 	node_start_pfn[0] = 0;
 	node_end_pfn[0] = max_pfn;
 	memory_present(0, 0, max_pfn);
Index: linux-2.6/include/asm-x86/e820_32.h
===================================================================
--- linux-2.6.orig/include/asm-x86/e820_32.h
+++ linux-2.6/include/asm-x86/e820_32.h
@@ -21,7 +21,7 @@
 extern void setup_memory_map(void);
 extern void finish_e820_parsing(void);
 
-extern void propagate_e820_map(void);
+extern void find_max_pfn(void);
 extern void register_bootmem_low_pages(unsigned long max_low_pfn);
 extern void limit_regions(unsigned long long size);
 extern void init_iomem_resources(struct resource *code_resource,
