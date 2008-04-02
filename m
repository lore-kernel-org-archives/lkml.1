Return-Path: <linux-kernel-owner+w=401wt.eu-S1764972AbYDBVwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764972AbYDBVwe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 17:52:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763417AbYDBVp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 17:45:58 -0400
Received: from saeurebad.de ([85.214.36.134]:60485 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763411AbYDBVp5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 17:45:57 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, mingo@elte.hu, davem@davemloft.net,
       hskinnemoen@atmel.com, cooloney@kernel.org, starvik@axis.com,
       dhowells@redhat.com, ysato@users.sourceforge.net, takata@linux-m32r.org,
       geert@linux-m68k.org, ralf@linux-mips.org, kyle@parisc-linux.org,
       paulus@samba.org, schwidefsky@de.ibm.com, lethal@linux-sh.org,
       jdike@addtoit.com, miles@gnu.org, chris@zankel.net,
       rmk@arm.linux.org.uk, tony.luck@intel.com
Subject: [RFC 22/22] alpha: Use generic show_mem()
Date: Wed,  2 Apr 2008 22:40:28 +0200
Message-Id: <12071690771658-git-send-email-hannes@saeurebad.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <12071688283927-git-send-email-hannes@saeurebad.de>
References: <12071688283927-git-send-email-hannes@saeurebad.de>
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Johannes Weiner <hannes@saeurebad.de>

diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index efffa92..c91629f 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -598,9 +598,6 @@ config ALPHA_LARGE_VMALLOC
 
 	  Say N unless you know you need gobs and gobs of vmalloc space.
 
-config HAVE_ARCH_SHOW_MEM
-	def_bool y
-
 config VERBOSE_MCHECK
 	bool "Verbose Machine Checks"
 
@@ -679,4 +676,3 @@ source "security/Kconfig"
 source "crypto/Kconfig"
 
 source "lib/Kconfig"
-
diff --git a/arch/alpha/mm/init.c b/arch/alpha/mm/init.c
index 40c15e7..234e42b 100644
--- a/arch/alpha/mm/init.c
+++ b/arch/alpha/mm/init.c
@@ -94,36 +94,6 @@ __bad_page(void)
 	return pte_mkdirty(mk_pte(virt_to_page(EMPTY_PGE), PAGE_SHARED));
 }
 
-#ifndef CONFIG_DISCONTIGMEM
-void
-show_mem(void)
-{
-	long i,free = 0,total = 0,reserved = 0;
-	long shared = 0, cached = 0;
-
-	printk("\nMem-info:\n");
-	show_free_areas();
-	printk("Free swap:       %6ldkB\n", nr_swap_pages<<(PAGE_SHIFT-10));
-	i = max_mapnr;
-	while (i-- > 0) {
-		total++;
-		if (PageReserved(mem_map+i))
-			reserved++;
-		else if (PageSwapCache(mem_map+i))
-			cached++;
-		else if (!page_count(mem_map+i))
-			free++;
-		else
-			shared += page_count(mem_map + i) - 1;
-	}
-	printk("%ld pages of RAM\n",total);
-	printk("%ld free pages\n",free);
-	printk("%ld reserved pages\n",reserved);
-	printk("%ld pages shared\n",shared);
-	printk("%ld pages swap cached\n",cached);
-}
-#endif
-
 static inline unsigned long
 load_PCB(struct pcb_struct *pcb)
 {
diff --git a/arch/alpha/mm/numa.c b/arch/alpha/mm/numa.c
index 10ab783..a460645 100644
--- a/arch/alpha/mm/numa.c
+++ b/arch/alpha/mm/numa.c
@@ -359,38 +359,3 @@ void __init mem_init(void)
 	mem_stress();
 #endif
 }
-
-void
-show_mem(void)
-{
-	long i,free = 0,total = 0,reserved = 0;
-	long shared = 0, cached = 0;
-	int nid;
-
-	printk("\nMem-info:\n");
-	show_free_areas();
-	printk("Free swap:       %6ldkB\n", nr_swap_pages<<(PAGE_SHIFT-10));
-	for_each_online_node(nid) {
-		unsigned long flags;
-		pgdat_resize_lock(NODE_DATA(nid), &flags);
-		i = node_spanned_pages(nid);
-		while (i-- > 0) {
-			struct page *page = nid_page_nr(nid, i);
-			total++;
-			if (PageReserved(page))
-				reserved++;
-			else if (PageSwapCache(page))
-				cached++;
-			else if (!page_count(page))
-				free++;
-			else
-				shared += page_count(page) - 1;
-		}
-		pgdat_resize_unlock(NODE_DATA(nid), &flags);
-	}
-	printk("%ld pages of RAM\n",total);
-	printk("%ld free pages\n",free);
-	printk("%ld reserved pages\n",reserved);
-	printk("%ld pages shared\n",shared);
-	printk("%ld pages swap cached\n",cached);
-}
-- 
1.5.2.2

