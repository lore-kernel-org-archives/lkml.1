Return-Path: <linux-kernel-owner+w=401wt.eu-S1753980AbYFAURj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980AbYFAURj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 16:17:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751588AbYFAURb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 16:17:31 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:36544 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbYFAURa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 16:17:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=cMsBSY34GGbjieRhLDFvbcbmA60vATUI9T4WN+OPcFpGLiJfaHgmpNOJnJFMvdRVFJ6PgFkFQoIcJ3CqdNtTZNy1POYQf6cJ9lXXdu1bIFjme6UMC2xELuhlyKlqqiLGEHkmMblO5EP5GKumbJlEts/YkFpNfWP6nGdeFBzDn/g=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] x86: numa_32 print out debug info all kva v2
Date: Sun, 1 Jun 2008 13:15:22 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200805110030.15510.yhlu.kernel@gmail.com> <200805312253.47939.yhlu.kernel@gmail.com> <200805312256.12584.yhlu.kernel@gmail.com>
In-Reply-To: <200805312256.12584.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806011315.23013.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


also fix the print out of node_remap_end_vaddr
v2: fix non numa flat compling

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
@@ -3499,6 +3499,11 @@ void __paginginit free_area_init_node(in
 	calculate_node_totalpages(pgdat, zones_size, zholes_size);
 
 	alloc_node_mem_map(pgdat);
+#ifdef CONFIG_FLAT_NODE_MEM_MAP
+	printk(KERN_DEBUG "free_area_init_node: node %d, pgdat %08lx, node_mem_map %08lx\n",
+		nid, (unsigned long)pgdat,
+		(unsigned long)pgdat->node_mem_map);
+#endif
 
 	free_area_init_core(pgdat, zones_size, zholes_size);
 }
