Return-Path: <linux-kernel-owner+w=401wt.eu-S1756602AbZCDVNJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602AbZCDVNJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 16:13:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753225AbZCDVMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 16:12:55 -0500
Received: from hera.kernel.org ([140.211.167.34]:46981 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753097AbZCDVMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 16:12:54 -0500
Date: Wed, 4 Mar 2009 21:12:28 GMT
From: Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, akpm@linux-foundation.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, akpm@linux-foundation.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <49AEE2C4.2030602@kernel.org>
References: <49AEE2C4.2030602@kernel.org>
Subject: [tip:x86/mm] x86: fix bootmem cross node for 32bit numa, cleanup
Message-ID: <tip-fc5efe3941c47c0278fe1bbcf8cc02a03a74fcda@git.kernel.org>
Git-Commit-ID: fc5efe3941c47c0278fe1bbcf8cc02a03a74fcda
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 04 Mar 2009 21:12:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fc5efe3941c47c0278fe1bbcf8cc02a03a74fcda
Gitweb:     http://git.kernel.org/tip/fc5efe3941c47c0278fe1bbcf8cc02a03a74fcda
Author:     "Yinghai Lu" <yinghai@kernel.org>
AuthorDate: Wed, 4 Mar 2009 12:21:24 -0800
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 4 Mar 2009 22:09:59 +0100

x86: fix bootmem cross node for 32bit numa, cleanup

Impact: clean up

Simplify the code, reuse some lines.
Remove min_low_pfn reference, it is always 0

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <49AEE2C4.2030602@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/init_32.c |   16 +++-------------
 1 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index c69c6b1..c351456 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -776,7 +776,6 @@ static void __init zone_sizes_init(void)
 	free_area_init_nodes(max_zone_pfns);
 }
 
-#ifdef CONFIG_NEED_MULTIPLE_NODES
 static unsigned long __init setup_node_bootmem(int nodeid,
 				 unsigned long start_pfn,
 				 unsigned long end_pfn,
@@ -802,7 +801,6 @@ static unsigned long __init setup_node_bootmem(int nodeid,
 
 	return bootmap + bootmap_size;
 }
-#endif
 
 void __init setup_bootmem_allocator(void)
 {
@@ -812,8 +810,7 @@ void __init setup_bootmem_allocator(void)
 	 * Initialize the boot-time allocator (with low memory only):
 	 */
 	bootmap_size = bootmem_bootmap_pages(max_low_pfn)<<PAGE_SHIFT;
-	bootmap = find_e820_area(min_low_pfn<<PAGE_SHIFT,
-				 max_pfn_mapped<<PAGE_SHIFT, bootmap_size,
+	bootmap = find_e820_area(0, max_pfn_mapped<<PAGE_SHIFT, bootmap_size,
 				 PAGE_SIZE);
 	if (bootmap == -1L)
 		panic("Cannot find bootmem map of size %ld\n", bootmap_size);
@@ -821,21 +818,14 @@ void __init setup_bootmem_allocator(void)
 
 	printk(KERN_INFO "  mapped low ram: 0 - %08lx\n",
 		 max_pfn_mapped<<PAGE_SHIFT);
-	printk(KERN_INFO "  low ram: %08lx - %08lx\n",
-		 min_low_pfn<<PAGE_SHIFT, max_low_pfn<<PAGE_SHIFT);
+	printk(KERN_INFO "  low ram: 0 - %08lx\n", max_low_pfn<<PAGE_SHIFT);
 
 #ifdef CONFIG_NEED_MULTIPLE_NODES
 	for_each_online_node(nodeid)
 		bootmap = setup_node_bootmem(nodeid, node_start_pfn[nodeid],
 					node_end_pfn[nodeid], bootmap);
 #else
-	/* don't touch min_low_pfn */
-	bootmap_size = init_bootmem_node(NODE_DATA(0), bootmap >> PAGE_SHIFT,
-					 min_low_pfn, max_low_pfn);
-	printk(KERN_INFO "  bootmap %08lx - %08lx\n",
-		 bootmap, bootmap + bootmap_size);
-	free_bootmem_with_active_regions(0, max_low_pfn);
-	early_res_to_bootmem(0, max_low_pfn<<PAGE_SHIFT);
+	bootmap = setup_node_bootmem(0, 0, max_low_pfn, bootmap);
 #endif
 
 	after_init_bootmem = 1;
