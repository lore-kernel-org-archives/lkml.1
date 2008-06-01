Return-Path: <linux-kernel-owner+w=401wt.eu-S1756405AbYFAF6N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756405AbYFAF6N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 01:58:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778AbYFAF5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 01:57:06 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:9694 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbYFAF5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 01:57:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=AIoqWT8hDG2BbSJncapWT3URi8TPvOU6NntRFarr5v+8b/dVq4YQJ/hnucnvw6AQ5swYuW+adCcufXxc9TFVYEcvvU1pJxP4AdB5Jju45ULpjyoJKONElR/luM1jMi16pmbxv5ICKCsF4+JD9017lXPH43A832YL79kKjCmkfjg=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] x86: numa_32 print out debug info all kva
Date: Sat, 31 May 2008 22:56:12 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200805110030.15510.yhlu.kernel@gmail.com> <200805312252.47727.yhlu.kernel@gmail.com> <200805312253.47939.yhlu.kernel@gmail.com>
In-Reply-To: <200805312253.47939.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805312256.12584.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


also fix the print out of node_remap_end_vaddr

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/arch/x86/mm/discontig_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/discontig_32.c
+++ linux-2.6/arch/x86/mm/discontig_32.c
@@ -168,6 +168,8 @@ static void __init allocate_pgdat(int ni
 		reserve_early(pgdat_phys, pgdat_phys + sizeof(pg_data_t),
 			      "NODE_DATA");
 	}
+	printk(KERN_DEBUG "allocate_pgdat: node %d NODE_DATA %08lx\n",
+		nid, (unsigned long)NODE_DATA(nid));
 }
 
 /*
@@ -205,8 +207,12 @@ void __init remap_numa_kva(void)
 	int node;
 
 	for_each_online_node(node) {
+		printk(KERN_DEBUG "remap_numa_kva: node %d\n", node);
 		for (pfn=0; pfn < node_remap_size[node]; pfn += PTRS_PER_PTE) {
 			vaddr = node_remap_start_vaddr[node]+(pfn<<PAGE_SHIFT);
+			printk(KERN_DEBUG "remap_numa_kva: %08lx to pfn %08lx\n",
+				(unsigned long)vaddr,
+				node_remap_start_pfn[node] + pfn);
 			set_pmd_pfn((ulong) vaddr, 
 				node_remap_start_pfn[node] + pfn, 
 				PAGE_KERNEL_LARGE);
@@ -290,8 +296,7 @@ static void init_remap_allocator(int nid
 
 	printk ("node %d will remap to vaddr %08lx - %08lx\n", nid,
 		(ulong) node_remap_start_vaddr[nid],
-		(ulong) pfn_to_kaddr(highstart_pfn
-		   + node_remap_offset[nid] + node_remap_size[nid]));
+		(ulong) node_remap_end_vaddr[nid]);
 }
 
 extern void setup_bootmem_allocator(void);
Index: linux-2.6/mm/page_alloc.c
===================================================================
--- linux-2.6.orig/mm/page_alloc.c
+++ linux-2.6/mm/page_alloc.c
@@ -3499,6 +3499,9 @@ void __paginginit free_area_init_node(in
 	calculate_node_totalpages(pgdat, zones_size, zholes_size);
 
 	alloc_node_mem_map(pgdat);
+	printk(KERN_DEBUG "free_area_init_node: node %d, pgdat %08lx, node_mem_map %08lx\n",
+		nid, (unsigned long)pgdat,
+		(unsigned long)pgdat->node_mem_map);
 
 	free_area_init_core(pgdat, zones_size, zholes_size);
 }
