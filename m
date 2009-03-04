Return-Path: <linux-kernel-owner+w=401wt.eu-S1757391AbZCDUW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391AbZCDUW4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 15:22:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756081AbZCDUWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 15:22:47 -0500
Received: from hera.kernel.org ([140.211.167.34]:54870 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754384AbZCDUWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 15:22:46 -0500
Message-ID: <49AEE2C4.2030602@kernel.org>
Date: Wed, 04 Mar 2009 12:21:24 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix bootmem cross node for 32bit numa -v2
References: <49AE485B.8000902@kernel.org> <49AEC395.8070808@kernel.org> <20090304195814.GC21488@elte.hu>
In-Reply-To: <20090304195814.GC21488@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Yinghai Lu <yinghai@kernel.org> wrote:
> 
>> Imapct: fix panic on system 2g x4 sockets
>>
>> Found one system with 4 sockets and every sockets has 2g can boot with numa32
>> because boot mem is crossing nodes.
>>
>> so try to have numa version setup_bootmem_allocator
>> v2: simplify the code
> 
> i've already applied v1 - mind sending the simplification as a 
> delta patch? Thanks.
> 

please check

[PATCH] x86: fix bootmem cross node for 32bit numa - fixup

Imapct: clean up

simplify the code, reuse some lines.
remove min_low_pfn referring, it is always 0

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/mm/init_32.c |   16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

Index: linux-2.6/arch/x86/mm/init_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_32.c
+++ linux-2.6/arch/x86/mm/init_32.c
@@ -776,7 +776,6 @@ static void __init zone_sizes_init(void)
 	free_area_init_nodes(max_zone_pfns);
 }
 
-#ifdef CONFIG_NEED_MULTIPLE_NODES
 static unsigned long __init setup_node_bootmem(int nodeid,
 				 unsigned long start_pfn,
 				 unsigned long end_pfn,
@@ -802,7 +801,6 @@ static unsigned long __init setup_node_b
 
 	return bootmap + bootmap_size;
 }
-#endif
 
 void __init setup_bootmem_allocator(void)
 {
@@ -812,8 +810,7 @@ void __init setup_bootmem_allocator(void
 	 * Initialize the boot-time allocator (with low memory only):
 	 */
 	bootmap_size = bootmem_bootmap_pages(max_low_pfn)<<PAGE_SHIFT;
-	bootmap = find_e820_area(min_low_pfn<<PAGE_SHIFT,
-				 max_pfn_mapped<<PAGE_SHIFT, bootmap_size,
+	bootmap = find_e820_area(0, max_pfn_mapped<<PAGE_SHIFT, bootmap_size,
 				 PAGE_SIZE);
 	if (bootmap == -1L)
 		panic("Cannot find bootmem map of size %ld\n", bootmap_size);
@@ -821,21 +818,14 @@ void __init setup_bootmem_allocator(void
 
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
