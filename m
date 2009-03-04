Return-Path: <linux-kernel-owner+w=401wt.eu-S1756772AbZCDSJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772AbZCDSJw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 13:09:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753335AbZCDSJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 13:09:43 -0500
Received: from hera.kernel.org ([140.211.167.34]:54960 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438AbZCDSJn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 13:09:43 -0500
Message-ID: <49AEC395.8070808@kernel.org>
Date: Wed, 04 Mar 2009 10:08:21 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: fix bootmem cross node for 32bit numa -v2
References: <49AE485B.8000902@kernel.org>
In-Reply-To: <49AE485B.8000902@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Imapct: fix panic on system 2g x4 sockets

Found one system with 4 sockets and every sockets has 2g can boot with numa32
because boot mem is crossing nodes.

so try to have numa version setup_bootmem_allocator
v2: simplify the code


Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/mm/init_32.c |   50 +++++++++++++++++++++++++++++++++++++-------------
 arch/x86/mm/numa_32.c |    5 +++--
 2 files changed, 40 insertions(+), 15 deletions(-)

Index: linux-2.6/arch/x86/mm/init_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_32.c
+++ linux-2.6/arch/x86/mm/init_32.c
@@ -793,33 +793,57 @@ static void __init zone_sizes_init(void)
 	free_area_init_nodes(max_zone_pfns);
 }
 
+static unsigned long __init setup_node_bootmem(int nodeid,
+				 unsigned long start_pfn,
+				 unsigned long end_pfn,
+				 unsigned long bootmap)
+{
+	unsigned long bootmap_size;
+
+	if (start_pfn > max_low_pfn)
+		return bootmap;
+	if (end_pfn > max_low_pfn)
+		end_pfn = max_low_pfn;
+
+	/* don't touch min_low_pfn */
+	bootmap_size = init_bootmem_node(NODE_DATA(nodeid),
+					 bootmap >> PAGE_SHIFT,
+					 start_pfn, end_pfn);
+	printk(KERN_INFO "  node %d low ram: %08lx - %08lx\n",
+		nodeid, start_pfn<<PAGE_SHIFT, end_pfn<<PAGE_SHIFT);
+	printk(KERN_INFO "  node %d bootmap %08lx - %08lx\n",
+		 nodeid, bootmap, bootmap + bootmap_size);
+	free_bootmem_with_active_regions(nodeid, end_pfn);
+	early_res_to_bootmem(start_pfn<<PAGE_SHIFT, end_pfn<<PAGE_SHIFT);
+
+	return bootmap + bootmap_size;
+}
+
 void __init setup_bootmem_allocator(void)
 {
-	int i;
+	int nodeid;
 	unsigned long bootmap_size, bootmap;
 	/*
 	 * Initialize the boot-time allocator (with low memory only):
 	 */
 	bootmap_size = bootmem_bootmap_pages(max_low_pfn)<<PAGE_SHIFT;
-	bootmap = find_e820_area(min_low_pfn<<PAGE_SHIFT,
-				 max_pfn_mapped<<PAGE_SHIFT, bootmap_size,
+	bootmap = find_e820_area(0, max_pfn_mapped<<PAGE_SHIFT, bootmap_size,
 				 PAGE_SIZE);
 	if (bootmap == -1L)
 		panic("Cannot find bootmem map of size %ld\n", bootmap_size);
 	reserve_early(bootmap, bootmap + bootmap_size, "BOOTMAP");
 
-	/* don't touch min_low_pfn */
-	bootmap_size = init_bootmem_node(NODE_DATA(0), bootmap >> PAGE_SHIFT,
-					 min_low_pfn, max_low_pfn);
 	printk(KERN_INFO "  mapped low ram: 0 - %08lx\n",
 		 max_pfn_mapped<<PAGE_SHIFT);
-	printk(KERN_INFO "  low ram: %08lx - %08lx\n",
-		 min_low_pfn<<PAGE_SHIFT, max_low_pfn<<PAGE_SHIFT);
-	printk(KERN_INFO "  bootmap %08lx - %08lx\n",
-		 bootmap, bootmap + bootmap_size);
-	for_each_online_node(i)
-		free_bootmem_with_active_regions(i, max_low_pfn);
-	early_res_to_bootmem(0, max_low_pfn<<PAGE_SHIFT);
+	printk(KERN_INFO "  low ram: 0 - %08lx\n", max_low_pfn<<PAGE_SHIFT);
+
+#ifdef CONFIG_NEED_MULTIPLE_NODES
+	for_each_online_node(nodeid)
+		bootmap = setup_node_bootmem(nodeid, node_start_pfn[nodeid],
+					node_end_pfn[nodeid], bootmap);
+#else
+	bootmap = setup_node_bootmem(0, 0, max_low_pfn, bootmap);
+#endif
 
 	after_init_bootmem = 1;
 }
Index: linux-2.6/arch/x86/mm/numa_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/numa_32.c
+++ linux-2.6/arch/x86/mm/numa_32.c
@@ -416,10 +416,11 @@ void __init initmem_init(unsigned long s
 	for_each_online_node(nid)
 		propagate_e820_map_node(nid);
 
-	for_each_online_node(nid)
+	for_each_online_node(nid) {
 		memset(NODE_DATA(nid), 0, sizeof(struct pglist_data));
+		NODE_DATA(nid)->bdata = &bootmem_node_data[nid];
+	}
 
-	NODE_DATA(0)->bdata = &bootmem_node_data[0];
 	setup_bootmem_allocator();
 }
 
