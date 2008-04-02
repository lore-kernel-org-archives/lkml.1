Return-Path: <linux-kernel-owner+w=401wt.eu-S1761114AbYDBVsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761114AbYDBVsy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 17:48:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763261AbYDBVpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 17:45:12 -0400
Received: from saeurebad.de ([85.214.36.134]:60347 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760723AbYDBVpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 17:45:11 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, mingo@elte.hu, davem@davemloft.net,
       hskinnemoen@atmel.com, cooloney@kernel.org, starvik@axis.com,
       dhowells@redhat.com, ysato@users.sourceforge.net, takata@linux-m32r.org,
       geert@linux-m68k.org, ralf@linux-mips.org, kyle@parisc-linux.org,
       paulus@samba.org, schwidefsky@de.ibm.com, lethal@linux-sh.org,
       jdike@addtoit.com, miles@gnu.org, chris@zankel.net,
       rmk@arm.linux.org.uk, tony.luck@intel.com
Subject: [RFC 18/22] sh: Use generic show_mem()
Date: Wed,  2 Apr 2008 22:40:24 +0200
Message-Id: <12071690311447-git-send-email-hannes@saeurebad.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <12071688283927-git-send-email-hannes@saeurebad.de>
References: <12071688283927-git-send-email-hannes@saeurebad.de>
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Johannes Weiner <hannes@saeurebad.de>

diff --git a/arch/sh/mm/Kconfig b/arch/sh/mm/Kconfig
index b74c4e7..5fd2184 100644
--- a/arch/sh/mm/Kconfig
+++ b/arch/sh/mm/Kconfig
@@ -138,9 +138,6 @@ config ARCH_MEMORY_PROBE
 	def_bool y
 	depends on MEMORY_HOTPLUG
 
-config HAVE_ARCH_SHOW_MEM
-	def_bool y
-
 choice
 	prompt "Kernel page size"
 	default PAGE_SIZE_8KB if X2TLB
diff --git a/arch/sh/mm/init.c b/arch/sh/mm/init.c
index 53dde06..ff81bfd 100644
--- a/arch/sh/mm/init.c
+++ b/arch/sh/mm/init.c
@@ -25,47 +25,6 @@ DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
 pgd_t swapper_pg_dir[PTRS_PER_PGD];
 unsigned long cached_to_uncached = 0;
 
-void show_mem(void)
-{
-	int total = 0, reserved = 0, free = 0;
-	int shared = 0, cached = 0, slab = 0;
-	pg_data_t *pgdat;
-
-	printk("Mem-info:\n");
-	show_free_areas();
-
-	for_each_online_pgdat(pgdat) {
-		unsigned long flags, i;
-
-		pgdat_resize_lock(pgdat, &flags);
-		for (i = 0; i < pgdat->node_spanned_pages; i++) {
-			struct page *page = pgdat_page_nr(pgdat, i);
-			total++;
-			if (PageReserved(page))
-				reserved++;
-			else if (PageSwapCache(page))
-				cached++;
-			else if (PageSlab(page))
-				slab++;
-			else if (!page_count(page))
-				free++;
-			else
-				shared += page_count(page) - 1;
-		}
-		pgdat_resize_unlock(pgdat, &flags);
-	}
-
-	printk("Free swap:       %6ldkB\n", nr_swap_pages<<(PAGE_SHIFT-10));
-	printk("%d pages of RAM\n", total);
-	printk("%d free pages\n", free);
-	printk("%d reserved pages\n", reserved);
-	printk("%d slab pages\n", slab);
-	printk("%d pages shared\n", shared);
-	printk("%d pages swap cached\n", cached);
-	printk(KERN_INFO "Total of %ld pages in page table cache\n",
-	       quicklist_total_size());
-}
-
 #ifdef CONFIG_MMU
 static void set_pte_phys(unsigned long addr, unsigned long phys, pgprot_t prot)
 {
-- 
1.5.2.2

