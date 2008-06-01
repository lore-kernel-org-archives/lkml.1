Return-Path: <linux-kernel-owner+w=401wt.eu-S1756740AbYFAF5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740AbYFAF5i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 01:57:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751470AbYFAF5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 01:57:04 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:9694 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbYFAF5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 01:57:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=VzbbnkUdrCpkpedVyrPaorgtNwhVRXpoJZ8BUrzTAXxCYnnVDC39dpPkGai4/ORSeKTouEZEjajEcdkivRcQAtOol7/0xzQYCws7FXugytzSgqSo39cSPu9jSgN7jeiYy2r+BwWcg6mtYYaEX828qM/kHt2D/LeXsF7lWdYxIaE=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] x86: change propagate_e820_map back to find_max_pfn -32bit
Date: Sat, 31 May 2008 22:52:47 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200805110030.15510.yhlu.kernel@gmail.com> <200805291625.56942.yhlu.kernel@gmail.com> <200805312251.52297.yhlu.kernel@gmail.com>
In-Reply-To: <200805312251.52297.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805312252.47727.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


we don't need to call memory_present that early.
numa dist and sparse will call memory_present later
and even fail, it will call memory_present for all range.

also for sparse it will call alloc_bootmem ... before we set up bootmem

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
@@ -742,10 +742,10 @@ void __init setup_arch(char **cmdline_p)
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
