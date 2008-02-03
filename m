Return-Path: <linux-kernel-owner+w=401wt.eu-S1761563AbYBCRXG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761563AbYBCRXG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 12:23:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758061AbYBCRWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 12:22:53 -0500
Received: from theia.rz.uni-saarland.de ([134.96.7.31]:5892 "EHLO
	theia.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247AbYBCRWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 12:22:52 -0500
Date: Sun, 3 Feb 2008 18:21:48 +0100
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Sam Ravnborg <sam@ravnborg.org>, lkml <linux-kernel@vger.kernel.org>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>
Subject: Solve section mismatch for free_area_init_core.
Message-ID: <20080203172148.GA17875@mailshack.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (theia.rz.uni-saarland.de [134.96.7.31]); Sun, 03 Feb 2008 18:22:48 +0100 (CET)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.6.0.62; VDF: 7.0.2.82; host: AntiVir1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Solve section mismatch for free_area_init_core:

WARNING: vmlinux.o(.meminit.text+0x649): 
Section mismatch in reference from the 
function free_area_init_core() to the function .init.text:setup_usemap()
The function __meminit free_area_init_core() references
a function __init setup_usemap().
If free_area_init_core is only used by setup_usemap then
annotate free_area_init_core with a matching annotation.

The warning is covers this stack of functions in mm/page_alloc.c:

alloc_bootmem_node must be marked __init.
alloc_bootmem_node is used by setup_usemap, if !SPARSEMEM.
(usemap_size is only used by setup_usemap, if !SPARSEMEM.)
setup_usemap is only used by free_area_init_core.
free_area_init_core is only used by free_area_init_node.

free_area_init_node is used by:
arch/alpha/mm/numa.c: __init paging_init()
arch/arm/mm/init.c: __init bootmem_init_node()
arch/avr32/mm/init.c: __init paging_init()
arch/cris/arch-v10/mm/init.c: __init paging_init()
arch/cris/arch-v32/mm/init.c: __init paging_init()
arch/m32r/mm/discontig.c: __init zone_sizes_init()
arch/m32r/mm/init.c: __init zone_sizes_init()
arch/m68k/mm/motorola.c: __init paging_init()
arch/m68k/mm/sun3mmu.c: __init paging_init()
arch/mips/sgi-ip27/ip27-memory.c: __init paging_init()
arch/parisc/mm/init.c: __init paging_init()
arch/sparc/mm/srmmu.c: __init srmmu_paging_init()
arch/sparc/mm/sun4c.c: __init sun4c_paging_init()
arch/sparc64/mm/init.c: __init paging_init()
mm/page_alloc.c: __init free_area_init_nodes()
mm/page_alloc.c: __init free_area_init()
and
mm/memory_hotplug.c: hotadd_new_pgdat()

hotadd_new_pgdat can not be an __init function, but:

It is compiled for MEMORY_HOTPLUG configurations only
MEMORY_HOTPLUG depends on SPARSEMEM || X86_64_ACPI_NUMA
X86_64_ACPI_NUMA depends on X86_64
ARCH_FLATMEM_ENABLE depends on X86_32
ARCH_DISCONTIGMEM_ENABLE depends on X86_32
So X86_64_ACPI_NUMA implies SPARSEMEM, right?

So we can mark the stack of functions __init for !SPARSEMEM,
but we must mark them __meminit for SPARSEMEM configurations.
This is ok, because then the calls to alloc_bootmem_node are
also avoided.

Compile-tested on:
silly minimal config
defconfig x86_32
defconfig x86_64
defconfig x86_64 -HIBERNATION +MEMORY_HOTPLUG

Comments?

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>


diff --git a/mm/internal.h b/mm/internal.h
index 953f941..5b46b32 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -47,4 +47,17 @@ static inline unsigned long page_order(struct page *page)
 	VM_BUG_ON(!PageBuddy(page));
 	return page_private(page);
 }
+
+/*
+ * FLATMEM and DISCONTIGMEM configurations use alloc_bootmem_node,
+ * so all functions starting at paging_init should be marked __init
+ * in those cases. SPARSEMEM, however, allows for memory hotplug,
+ * and alloc_bootmem_node is not used.
+ */
+#ifdef CONFIG_SPARSEMEM
+#define __paginginit __meminit
+#else
+#define __paginginit __init
+#endif
+
 #endif
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index b2838c2..859be40 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3321,7 +3321,7 @@ static inline int pageblock_default_order(unsigned int order)
  *   - mark all memory queues empty
  *   - clear the memory bitmaps
  */
-static void __meminit free_area_init_core(struct pglist_data *pgdat,
+static void __paginginit free_area_init_core(struct pglist_data *pgdat,
 		unsigned long *zones_size, unsigned long *zholes_size)
 {
 	enum zone_type j;
@@ -3445,7 +3445,7 @@ static void __init_refok alloc_node_mem_map(struct pglist_data *pgdat)
 #endif /* CONFIG_FLAT_NODE_MEM_MAP */
 }
 
-void __meminit free_area_init_node(int nid, struct pglist_data *pgdat,
+void __paginginit free_area_init_node(int nid, struct pglist_data *pgdat,
 		unsigned long *zones_size, unsigned long node_start_pfn,
 		unsigned long *zholes_size)
 {
