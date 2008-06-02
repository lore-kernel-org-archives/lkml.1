Return-Path: <linux-kernel-owner+w=401wt.eu-S1757966AbYFBHA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966AbYFBHA0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 03:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752986AbYFBHAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 03:00:17 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:42475 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751AbYFBHAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 03:00:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=rPfKyn3/1YLYfd+x4mCgNDFLSt88rjIhJDFzYY62dkXSCidSanATTRqNvtZ+0VqxI9AQNHgt7iu2xCFTEER7Z2zmBn0TZ3/qljQV9wM70OtxQVnjWScQWOefi5XeOQvlq/OpneU9xSoCP9AyvijIg/AuQySJa8bwBohSzS7nO5g=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH] x86: cleanup max_pfn_mapped usage - 32bit
Date: Sun, 1 Jun 2008 23:53:50 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200805110030.15510.yhlu.kernel@gmail.com> <200805291625.56942.yhlu.kernel@gmail.com> <200806012106.31650.yhlu.kernel@gmail.com>
In-Reply-To: <200806012106.31650.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806012353.51213.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


32bit in head_32.S after initial page table is done, we get initial
max_pfn_mapped, and then kernel_physical_mapping_init will give us
final one.

We need to use that to make sure find_e820_area to get valid address for
boot_map and NODE_DATA(0) for numa32.

XEN PV and lguest may need to assign max_pfn_mapped too.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/arch/x86/kernel/head_32.S
===================================================================
--- linux-2.6.orig/arch/x86/kernel/head_32.S
+++ linux-2.6/arch/x86/kernel/head_32.S
@@ -220,6 +220,8 @@ default_entry:
 	jb 10b
 1:
 	movl %edi,pa(init_pg_tables_end)
+	shrl $12, %eax
+	movl %eax, pa(max_pfn_mapped)
 
 	/* Do early initialization of the fixmap area */
 	movl $pa(swapper_pg_fixmap)+PDE_ATTR,%eax
@@ -251,6 +253,8 @@ page_pde_offset = (__PAGE_OFFSET >> 20);
 	cmpl %ebp,%eax
 	jb 10b
 	movl %edi,pa(init_pg_tables_end)
+	shrl $12, %eax
+	movl %eax, pa(max_pfn_mapped)
 
 	/* Do early initialization of the fixmap area */
 	movl $pa(swapper_pg_fixmap)+PDE_ATTR,%eax
Index: linux-2.6/arch/x86/kernel/setup_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_32.c
+++ linux-2.6/arch/x86/kernel/setup_32.c
@@ -587,7 +587,7 @@ void __init setup_bootmem_allocator(void
 	 */
 	bootmap_size = bootmem_bootmap_pages(max_low_pfn)<<PAGE_SHIFT;
 	bootmap = find_e820_area(min_low_pfn<<PAGE_SHIFT,
-				 max_low_pfn<<PAGE_SHIFT, bootmap_size,
+				 max_pfn_mapped<<PAGE_SHIFT, bootmap_size,
 				 PAGE_SIZE);
 	if (bootmap == -1L)
 		panic("Cannot find bootmem map of size %ld\n", bootmap_size);
@@ -596,6 +596,8 @@ void __init setup_bootmem_allocator(void
 	reserve_initrd();
 #endif
 	bootmap_size = init_bootmem(bootmap >> PAGE_SHIFT, max_low_pfn);
+	printk(KERN_INFO "  mapped low ram: 0 - %08lx\n",
+		 max_pfn_mapped<<PAGE_SHIFT);
 	printk(KERN_INFO "  low ram: %08lx - %08lx\n",
 		 min_low_pfn<<PAGE_SHIFT, max_low_pfn<<PAGE_SHIFT);
 	printk(KERN_INFO "  bootmap %08lx - %08lx\n",
Index: linux-2.6/arch/x86/mm/discontig_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/discontig_32.c
+++ linux-2.6/arch/x86/mm/discontig_32.c
@@ -163,7 +163,8 @@ static void __init allocate_pgdat(int ni
 	else {
 		unsigned long pgdat_phys;
 		pgdat_phys = find_e820_area(min_low_pfn<<PAGE_SHIFT,
-				 max_low_pfn<<PAGE_SHIFT, sizeof(pg_data_t),
+				 (nid ? max_low_pfn:max_pfn_mapped)<<PAGE_SHIFT,
+				 sizeof(pg_data_t),
 				 PAGE_SIZE);
 		NODE_DATA(nid) = (pg_data_t *)(pfn_to_kaddr(pgdat_phys>>PAGE_SHIFT));
 		reserve_early(pgdat_phys, pgdat_phys + sizeof(pg_data_t),
