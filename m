Return-Path: <linux-kernel-owner+w=401wt.eu-S1760875AbYDBVrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760875AbYDBVrg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 17:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763000AbYDBVo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 17:44:27 -0400
Received: from saeurebad.de ([85.214.36.134]:60248 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760279AbYDBVo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 17:44:26 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, mingo@elte.hu, davem@davemloft.net,
       hskinnemoen@atmel.com, cooloney@kernel.org, starvik@axis.com,
       dhowells@redhat.com, ysato@users.sourceforge.net, takata@linux-m32r.org,
       geert@linux-m68k.org, ralf@linux-mips.org, kyle@parisc-linux.org,
       paulus@samba.org, schwidefsky@de.ibm.com, lethal@linux-sh.org,
       jdike@addtoit.com, miles@gnu.org, chris@zankel.net,
       rmk@arm.linux.org.uk, tony.luck@intel.com
Subject: [RFC 14/22] parisc: Use generic show_mem()
Date: Wed,  2 Apr 2008 22:40:20 +0200
Message-Id: <12071689863221-git-send-email-hannes@saeurebad.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <12071688283927-git-send-email-hannes@saeurebad.de>
References: <12071688283927-git-send-email-hannes@saeurebad.de>
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Johannes Weiner <hannes@saeurebad.de>

diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index 9ec4fcd..bc7a19d 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -240,9 +240,6 @@ config NODES_SHIFT
 	default "3"
 	depends on NEED_MULTIPLE_NODES
 
-config HAVE_ARCH_SHOW_MEM
-	def_bool y
-
 source "kernel/Kconfig.preempt"
 source "kernel/Kconfig.hz"
 source "mm/Kconfig"
diff --git a/arch/parisc/mm/init.c b/arch/parisc/mm/init.c
index eb80f5e..e8e9891 100644
--- a/arch/parisc/mm/init.c
+++ b/arch/parisc/mm/init.c
@@ -548,78 +548,6 @@ void __init mem_init(void)
 
 unsigned long *empty_zero_page __read_mostly;
 
-void show_mem(void)
-{
-	int i,free = 0,total = 0,reserved = 0;
-	int shared = 0, cached = 0;
-
-	printk(KERN_INFO "Mem-info:\n");
-	show_free_areas();
-	printk(KERN_INFO "Free swap:	 %6ldkB\n",
-				nr_swap_pages<<(PAGE_SHIFT-10));
-#ifndef CONFIG_DISCONTIGMEM
-	i = max_mapnr;
-	while (i-- > 0) {
-		total++;
-		if (PageReserved(mem_map+i))
-			reserved++;
-		else if (PageSwapCache(mem_map+i))
-			cached++;
-		else if (!page_count(&mem_map[i]))
-			free++;
-		else
-			shared += page_count(&mem_map[i]) - 1;
-	}
-#else
-	for (i = 0; i < npmem_ranges; i++) {
-		int j;
-
-		for (j = node_start_pfn(i); j < node_end_pfn(i); j++) {
-			struct page *p;
-			unsigned long flags;
-
-			pgdat_resize_lock(NODE_DATA(i), &flags);
-			p = nid_page_nr(i, j) - node_start_pfn(i);
-
-			total++;
-			if (PageReserved(p))
-				reserved++;
-			else if (PageSwapCache(p))
-				cached++;
-			else if (!page_count(p))
-				free++;
-			else
-				shared += page_count(p) - 1;
-			pgdat_resize_unlock(NODE_DATA(i), &flags);
-        	}
-	}
-#endif
-	printk(KERN_INFO "%d pages of RAM\n", total);
-	printk(KERN_INFO "%d reserved pages\n", reserved);
-	printk(KERN_INFO "%d pages shared\n", shared);
-	printk(KERN_INFO "%d pages swap cached\n", cached);
-
-
-#ifdef CONFIG_DISCONTIGMEM
-	{
-		struct zonelist *zl;
-		int i, j, k;
-
-		for (i = 0; i < npmem_ranges; i++) {
-			for (j = 0; j < MAX_NR_ZONES; j++) {
-				zl = NODE_DATA(i)->node_zonelists + j;
-
-				printk("Zone list for zone %d on node %d: ", j, i);
-				for (k = 0; zl->zones[k] != NULL; k++) 
-					printk("[%d/%s] ", zone_to_nid(zl->zones[k]), zl->zones[k]->name);
-				printk("\n");
-			}
-		}
-	}
-#endif
-}
-
-
 static void __init map_pages(unsigned long start_vaddr, unsigned long start_paddr, unsigned long size, pgprot_t pgprot)
 {
 	pgd_t *pg_dir;
-- 
1.5.2.2

