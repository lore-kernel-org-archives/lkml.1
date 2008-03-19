Return-Path: <linux-kernel-owner+w=401wt.eu-S941307AbYCSW3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941307AbYCSW3n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:29:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965346AbYCSVDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:03:30 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:55319 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965335AbYCSVD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:03:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=reply-to:to:subject:user-agent:cc:references:in-reply-to:mime-version:content-disposition:x-length:x-uid:date:content-type:content-transfer-encoding:message-id:from;
        b=cJwvOiH8oE8+y8ryCWuwA9qZzu0Nh/Wy7HA+eyi42NhnRxnoEX5JyAQQ8tn0O9ea0gzktGg5x/he/lyNPVzT0E69MqkGpshv6XQTmAJ6jIEs/mF5cdXcqYeTjfJ0KW6c5KzOtlTmRBtaE9bvUpILACCvG6RsIUHTy9kRWlO7V7Y=
Reply-To: yhlu.kernel@gmail.com
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 12/12] x86_64: fix setup_node_bootmem to support big mem excluding with memmap
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Christoph Lameter <clameter@sgi.com>,
       kernel list <linux-kernel@vger.kernel.org>
References: <200803181237.33861.yhlu.kernel@gmail.com>
In-Reply-To: <200803181237.33861.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 6546
Date: Wed, 19 Mar 2008 14:05:03 -0700
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200803191405.03495.yhlu.kernel@gmail.com>
From: Yinghai Lu <yhlu.kernel.send@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86_64: fix setup_node_bootmem to support big mem excluding with memmap

typical case: four sockets system, every node has 4g ram, and we are using
	memmap=10g$4g to mask out memory on node1 and node2

when numa is enabled, early_node_mem is used to get node_data and node_bootmap

if it can not get from same node with find_e820_area, it will use alloc_bootmem
to get buff from previous nodes.

so check it and issue info about it.

need to move early_res_to_bootmem into every setup_node_bootmem.
and it takes range that node has. otherwise alloc_bootmem could return addr
that reserved early.

need to apply it after
	[PATCH] mm: make reserve_bootmem can crossed the nodes

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/arch/x86/mm/numa_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/numa_64.c
+++ linux-2.6/arch/x86/mm/numa_64.c
@@ -188,6 +188,7 @@ void __init setup_node_bootmem(int nodei
 	unsigned long bootmap_start, nodedata_phys;
 	void *bootmap;
 	const int pgdat_size = round_up(sizeof(pg_data_t), PAGE_SIZE);
+	int nid;
 
 	start = round_up(start, ZONE_ALIGN);
 
@@ -210,9 +211,20 @@ void __init setup_node_bootmem(int nodei
 	NODE_DATA(nodeid)->node_start_pfn = start_pfn;
 	NODE_DATA(nodeid)->node_spanned_pages = end_pfn - start_pfn;
 
-	/* Find a place for the bootmem map */
+	/*
+	 * Find a place for the bootmem map
+	 * nodedata_phys could be on other nodes by alloc_bootmem,
+	 * so need to sure bootmap_start not to be small, otherwise
+	 * early_node_mem will get that with find_e820_area instead
+	 * of alloc_bootmem, that could clash with reserved range
+	 */
 	bootmap_pages = bootmem_bootmap_pages(end_pfn - start_pfn);
-	bootmap_start = round_up(nodedata_phys + pgdat_size, PAGE_SIZE);
+	nid = phys_to_nid(nodedata_phys);
+	if (nid == nodeid)
+		bootmap_start = round_up(nodedata_phys + pgdat_size,
+					 PAGE_SIZE);
+	else
+		bootmap_start = round_up(start, PAGE_SIZE);
 	/*
 	 * SMP_CAHCE_BYTES could be enough, but init_bootmem_node like
 	 * to use that to align to PAGE_SIZE
@@ -237,10 +249,29 @@ void __init setup_node_bootmem(int nodei
 
 	free_bootmem_with_active_regions(nodeid, end);
 
-	reserve_bootmem_node(NODE_DATA(nodeid), nodedata_phys, pgdat_size,
-			BOOTMEM_DEFAULT);
-	reserve_bootmem_node(NODE_DATA(nodeid), bootmap_start,
-			bootmap_pages<<PAGE_SHIFT, BOOTMEM_DEFAULT);
+	/*
+	 * convert early reserve to bootmem reserve earlier
+	 * otherwise early_node_mem could use early reserved mem
+	 * on previous node
+	 */
+	early_res_to_bootmem(start, end);
+
+	/*
+	 * in some case early_node_mem could use alloc_bootmem
+	 * to get range on other node, don't reserve that again
+	 */
+	if (nid != nodeid)
+		printk(KERN_INFO "    NODE_DATA(%d) on node %d\n", nodeid, nid);
+	else
+		reserve_bootmem_node(NODE_DATA(nodeid), nodedata_phys,
+					pgdat_size, BOOTMEM_DEFAULT);
+	nid = phys_to_nid(bootmap_start);
+	if (nid != nodeid)
+		printk(KERN_INFO "    bootmap(%d) on node %d\n", nodeid, nid);
+	else
+		reserve_bootmem_node(NODE_DATA(nodeid), bootmap_start,
+				 bootmap_pages<<PAGE_SHIFT, BOOTMEM_DEFAULT);
+
 #ifdef CONFIG_ACPI_NUMA
 	srat_reserve_add_area(nodeid);
 #endif
Index: linux-2.6/arch/x86/kernel/e820_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820_64.c
+++ linux-2.6/arch/x86/kernel/e820_64.c
@@ -83,14 +83,19 @@ void __init reserve_early(unsigned long 
 		strncpy(r->name, name, sizeof(r->name) - 1);
 }
 
-void __init early_res_to_bootmem(void)
+void __init early_res_to_bootmem(unsigned long start, unsigned long end)
 {
 	int i;
+	unsigned long final_start, final_end;
 	for (i = 0; i < MAX_EARLY_RES && early_res[i].end; i++) {
 		struct early_res *r = &early_res[i];
-		printk(KERN_INFO "early res: %d [%lx-%lx] %s\n", i,
-			r->start, r->end - 1, r->name);
-		reserve_bootmem_generic(r->start, r->end - r->start);
+		final_start = max(start, r->start);
+		final_end = min(end, r->end);
+		if (final_start >= final_end)
+			continue;
+		printk(KERN_INFO "  early res: %d [%lx-%lx] %s\n", i,
+			final_start, final_end - 1, r->name);
+		reserve_bootmem_generic(final_start, final_end - final_start);
 	}
 }
 
Index: linux-2.6/include/asm-x86/e820_64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/e820_64.h
+++ linux-2.6/include/asm-x86/e820_64.h
@@ -41,7 +41,7 @@ extern struct e820map e820;
 extern void update_e820(void);
 
 extern void reserve_early(unsigned long start, unsigned long end, char *name);
-extern void early_res_to_bootmem(void);
+extern void early_res_to_bootmem(unsigned long start, unsigned long end);
 
 #endif/*!__ASSEMBLY__*/
 
Index: linux-2.6/arch/x86/kernel/setup_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_64.c
+++ linux-2.6/arch/x86/kernel/setup_64.c
@@ -190,6 +190,7 @@ contig_initmem_init(unsigned long start_
 	bootmap_size = init_bootmem(bootmap >> PAGE_SHIFT, end_pfn);
 	e820_register_active_regions(0, start_pfn, end_pfn);
 	free_bootmem_with_active_regions(0, end_pfn);
+	early_res_to_bootmem(0, end_pfn<<PAGE_SHIFT);
 	reserve_bootmem(bootmap, bootmap_size, BOOTMEM_DEFAULT);
 }
 #endif
@@ -395,8 +396,6 @@ void __init setup_arch(char **cmdline_p)
 	contig_initmem_init(0, end_pfn);
 #endif
 
-	early_res_to_bootmem();
-
 	dma32_reserve_bootmem();
 
 #ifdef CONFIG_ACPI_SLEEP
