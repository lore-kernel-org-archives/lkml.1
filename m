Return-Path: <linux-kernel-owner+w=401wt.eu-S1763652AbYDBVqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763652AbYDBVqs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 17:46:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760343AbYDBVoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 17:44:05 -0400
Received: from saeurebad.de ([85.214.36.134]:60176 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762980AbYDBVoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 17:44:04 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, mingo@elte.hu, davem@davemloft.net,
       hskinnemoen@atmel.com, cooloney@kernel.org, starvik@axis.com,
       dhowells@redhat.com, ysato@users.sourceforge.net, takata@linux-m32r.org,
       geert@linux-m68k.org, ralf@linux-mips.org, kyle@parisc-linux.org,
       paulus@samba.org, schwidefsky@de.ibm.com, lethal@linux-sh.org,
       jdike@addtoit.com, miles@gnu.org, chris@zankel.net,
       rmk@arm.linux.org.uk, tony.luck@intel.com
Subject: [RFC 12/22] mips: Use generic show_mem()
Date: Wed,  2 Apr 2008 22:40:18 +0200
Message-Id: <12071689633380-git-send-email-hannes@saeurebad.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <12071688283927-git-send-email-hannes@saeurebad.de>
References: <12071688283927-git-send-email-hannes@saeurebad.de>
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Johannes Weiner <hannes@saeurebad.de>

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 7c5a3c2..8724ed3 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -1736,9 +1736,6 @@ config NODES_SHIFT
 	default "6"
 	depends on NEED_MULTIPLE_NODES
 
-config HAVE_ARCH_SHOW_MEM
-	def_bool y
-
 source "mm/Kconfig"
 
 config SMP
diff --git a/arch/mips/mm/Makefile b/arch/mips/mm/Makefile
index c6f832e..4796b35 100644
--- a/arch/mips/mm/Makefile
+++ b/arch/mips/mm/Makefile
@@ -3,8 +3,7 @@
 #
 
 obj-y				+= cache.o dma-default.o extable.o fault.o \
-				   init.o pgtable.o tlbex.o tlbex-fault.o \
-				   uasm.o
+				   init.o tlbex.o tlbex-fault.o uasm.o
 
 obj-$(CONFIG_32BIT)		+= ioremap.o pgtable-32.o
 obj-$(CONFIG_64BIT)		+= pgtable-64.o
diff --git a/arch/mips/mm/pgtable.c b/arch/mips/mm/pgtable.c
deleted file mode 100644
index 57df1c3..0000000
--- a/arch/mips/mm/pgtable.c
+++ /dev/null
@@ -1,37 +0,0 @@
-#include <linux/kernel.h>
-#include <linux/mm.h>
-#include <linux/swap.h>
-
-void show_mem(void)
-{
-#ifndef CONFIG_NEED_MULTIPLE_NODES  /* XXX(hch): later.. */
-	int pfn, total = 0, reserved = 0;
-	int shared = 0, cached = 0;
-	int highmem = 0;
-	struct page *page;
-
-	printk("Mem-info:\n");
-	show_free_areas();
-	printk("Free swap:       %6ldkB\n", nr_swap_pages<<(PAGE_SHIFT-10));
-	pfn = max_mapnr;
-	while (pfn-- > 0) {
-		if (!pfn_valid(pfn))
-			continue;
-		page = pfn_to_page(pfn);
-		total++;
-		if (PageHighMem(page))
-			highmem++;
-		if (PageReserved(page))
-			reserved++;
-		else if (PageSwapCache(page))
-			cached++;
-		else if (page_count(page))
-			shared += page_count(page) - 1;
-	}
-	printk("%d pages of RAM\n", total);
-	printk("%d pages of HIGHMEM\n", highmem);
-	printk("%d reserved pages\n", reserved);
-	printk("%d pages shared\n", shared);
-	printk("%d pages swap cached\n", cached);
-#endif
-}
-- 
1.5.2.2

