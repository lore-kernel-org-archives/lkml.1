Return-Path: <linux-kernel-owner+w=401wt.eu-S1757872AbZCDUCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757872AbZCDUCX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 15:02:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757010AbZCDUCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 15:02:07 -0500
Received: from hera.kernel.org ([140.211.167.34]:32996 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756988AbZCDUCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 15:02:03 -0500
Date: Wed, 4 Mar 2009 20:00:30 GMT
From: Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, akpm@linux-foundation.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, akpm@linux-foundation.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <49AE485B.8000902@kernel.org>
References: <49AE485B.8000902@kernel.org>
Subject: [tip:x86/mm] x86: fix bootmem cross node for 32bit numa
Message-ID: <tip-a71edd1f46c8a599509bda478fb4eea27fb0da63@git.kernel.org>
Git-Commit-ID: a71edd1f46c8a599509bda478fb4eea27fb0da63
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 04 Mar 2009 20:00:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a71edd1f46c8a599509bda478fb4eea27fb0da63
Gitweb:     http://git.kernel.org/tip/a71edd1f46c8a599509bda478fb4eea27fb0da63
Author:     "Yinghai Lu" <yinghai@kernel.org>
AuthorDate: Wed, 4 Mar 2009 01:22:35 -0800
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 4 Mar 2009 20:55:03 +0100

x86: fix bootmem cross node for 32bit numa

Impact: fix panic on system 2g x4 sockets

Found one system with 4 sockets and every sockets has 2g can not boot
with numa32 because boot mem is crossing nodes.

So try to have numa version of setup_bootmem_allocator().

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <49AE485B.8000902@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/init_32.c |   46 ++++++++++++++++++++++++++++++++++++++++------
 arch/x86/mm/numa_32.c |    5 +++--
 2 files changed, 43 insertions(+), 8 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 917c4e6..67bdb59 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -776,9 +776,37 @@ static void __init zone_sizes_init(void)
 	free_area_init_nodes(max_zone_pfns);
 }
 
+#ifdef CONFIG_NEED_MULTIPLE_NODES
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
+#endif
+
 void __init setup_bootmem_allocator(void)
 {
-	int i;
+	int nodeid;
 	unsigned long bootmap_size, bootmap;
 	/*
 	 * Initialize the boot-time allocator (with low memory only):
@@ -791,18 +819,24 @@ void __init setup_bootmem_allocator(void)
 		panic("Cannot find bootmem map of size %ld\n", bootmap_size);
 	reserve_early(bootmap, bootmap + bootmap_size, "BOOTMAP");
 
-	/* don't touch min_low_pfn */
-	bootmap_size = init_bootmem_node(NODE_DATA(0), bootmap >> PAGE_SHIFT,
-					 min_low_pfn, max_low_pfn);
 	printk(KERN_INFO "  mapped low ram: 0 - %08lx\n",
 		 max_pfn_mapped<<PAGE_SHIFT);
 	printk(KERN_INFO "  low ram: %08lx - %08lx\n",
 		 min_low_pfn<<PAGE_SHIFT, max_low_pfn<<PAGE_SHIFT);
+
+#ifdef CONFIG_NEED_MULTIPLE_NODES
+	for_each_online_node(nodeid)
+		bootmap = setup_node_bootmem(nodeid, node_start_pfn[nodeid],
+					node_end_pfn[nodeid], bootmap);
+#else
+	/* don't touch min_low_pfn */
+	bootmap_size = init_bootmem_node(NODE_DATA(0), bootmap >> PAGE_SHIFT,
+					 min_low_pfn, max_low_pfn);
 	printk(KERN_INFO "  bootmap %08lx - %08lx\n",
 		 bootmap, bootmap + bootmap_size);
-	for_each_online_node(i)
-		free_bootmem_with_active_regions(i, max_low_pfn);
+	free_bootmem_with_active_regions(0, max_low_pfn);
 	early_res_to_bootmem(0, max_low_pfn<<PAGE_SHIFT);
+#endif
 
 	after_init_bootmem = 1;
 }
diff --git a/arch/x86/mm/numa_32.c b/arch/x86/mm/numa_32.c
index 451fe95..3daefa0 100644
--- a/arch/x86/mm/numa_32.c
+++ b/arch/x86/mm/numa_32.c
@@ -416,10 +416,11 @@ void __init initmem_init(unsigned long start_pfn,
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
 
