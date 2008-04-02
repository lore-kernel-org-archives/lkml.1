Return-Path: <linux-kernel-owner+w=401wt.eu-S1761625AbYDBVrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761625AbYDBVrw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 17:47:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763073AbYDBVoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 17:44:38 -0400
Received: from saeurebad.de ([85.214.36.134]:60280 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760707AbYDBVoh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 17:44:37 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, mingo@elte.hu, davem@davemloft.net,
       hskinnemoen@atmel.com, cooloney@kernel.org, starvik@axis.com,
       dhowells@redhat.com, ysato@users.sourceforge.net, takata@linux-m32r.org,
       geert@linux-m68k.org, ralf@linux-mips.org, kyle@parisc-linux.org,
       paulus@samba.org, schwidefsky@de.ibm.com, lethal@linux-sh.org,
       jdike@addtoit.com, miles@gnu.org, chris@zankel.net,
       rmk@arm.linux.org.uk, tony.luck@intel.com
Subject: [RFC 15/22] powerpc: Use generic show_mem()
Date: Wed,  2 Apr 2008 22:40:21 +0200
Message-Id: <12071689982382-git-send-email-hannes@saeurebad.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <12071688283927-git-send-email-hannes@saeurebad.de>
References: <12071688283927-git-send-email-hannes@saeurebad.de>
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Johannes Weiner <hannes@saeurebad.de>

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 8950e0c..1189d8d 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -350,9 +350,6 @@ config ARCH_SPARSEMEM_DEFAULT
 config ARCH_POPULATES_NODE_MAP
 	def_bool y
 
-config HAVE_ARCH_SHOW_MEM
-	def_bool y
-
 source "mm/Kconfig"
 
 config ARCH_MEMORY_PROBE
diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
index be5c506..fcbae37 100644
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -164,46 +164,6 @@ walk_memory_resource(unsigned long start_pfn, unsigned long nr_pages, void *arg,
 
 #endif /* CONFIG_MEMORY_HOTPLUG */
 
-void show_mem(void)
-{
-	unsigned long total = 0, reserved = 0;
-	unsigned long shared = 0, cached = 0;
-	unsigned long highmem = 0;
-	struct page *page;
-	pg_data_t *pgdat;
-	unsigned long i;
-
-	printk("Mem-info:\n");
-	show_free_areas();
-	printk("Free swap:       %6ldkB\n", nr_swap_pages<<(PAGE_SHIFT-10));
-	for_each_online_pgdat(pgdat) {
-		unsigned long flags;
-		pgdat_resize_lock(pgdat, &flags);
-		for (i = 0; i < pgdat->node_spanned_pages; i++) {
-			if (!pfn_valid(pgdat->node_start_pfn + i))
-				continue;
-			page = pgdat_page_nr(pgdat, i);
-			total++;
-			if (PageHighMem(page))
-				highmem++;
-			if (PageReserved(page))
-				reserved++;
-			else if (PageSwapCache(page))
-				cached++;
-			else if (page_count(page))
-				shared += page_count(page) - 1;
-		}
-		pgdat_resize_unlock(pgdat, &flags);
-	}
-	printk("%ld pages of RAM\n", total);
-#ifdef CONFIG_HIGHMEM
-	printk("%ld pages of HIGHMEM\n", highmem);
-#endif
-	printk("%ld reserved pages\n", reserved);
-	printk("%ld pages shared\n", shared);
-	printk("%ld pages swap cached\n", cached);
-}
-
 /*
  * Initialize the bootmem system and give it all the memory we
  * have available.  If we are using highmem, we only put the
-- 
1.5.2.2

