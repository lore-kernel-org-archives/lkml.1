Return-Path: <linux-kernel-owner+w=401wt.eu-S1757888AbXKFTxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757888AbXKFTxc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 14:53:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756972AbXKFTwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 14:52:09 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45362 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755438AbXKFTwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 14:52:00 -0500
Message-Id: <20071106195158.107939214@sgi.com>
References: <20071106195144.983665861@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 06 Nov 2007 11:51:46 -0800
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-mm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 02/28] cpu alloc: x86_64 support
Content-Disposition: inline; filename=cpu_alloc_x86_64
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Set up a cpu area that allows the use of up 256MB for each processor.

Cpu memory use can grow rapidly. F.e. if we assume that a page struct
occupies 64 bytes of memory and we have 3 zones per node then we need
3 * 1k * 16k = 50 million pagesets or 3096 pagesets per processor.
This results in a total of 3.2 GB of page structs. So each cpu needs
around 200k of cpu storage for the page allocator alone.

For the UP and SMP case map the area using 4k ptes. Typical use of per cpu
data is around 16k for UP and SMP configurations. Allocating a 2M
segment would be overkill. There is enough reserve around to run
a few 100000 ip tunnels if one wants to and other lots of other frills.

For NUMA map the area using 2M PMDs. A large NUMA system may use
lots of cpu data for the page allocator data alone. We typically
have large amounts of memory around. Using a 2M page size reduces
TLB pressure.

Some numbers for envisioned maximum configurations of NUMA systems:

4k cpu configurations with 256 nodes:

	4096 * 256MB = 1TB of virtual space.

Maximum theoretical configuration 16384 processors 1k nodes:

	16384 * 256MB = 4TB of virtual space.

Both fit within the established limits established.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 arch/x86/Kconfig.x86_64      |   13 +++++++++++++
 arch/x86/mm/init_64.c        |   39 +++++++++++++++++++++++++++++++++++++++
 include/asm-x86/pgtable_64.h |    1 +
 3 files changed, 53 insertions(+)

Index: linux-2.6/arch/x86/mm/init_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_64.c	2007-11-04 09:45:12.000000000 -0800
+++ linux-2.6/arch/x86/mm/init_64.c	2007-11-04 16:34:05.000000000 -0800
@@ -28,6 +28,7 @@
 #include <linux/module.h>
 #include <linux/memory_hotplug.h>
 #include <linux/nmi.h>
+#include <linux/cpu_alloc.h>
 
 #include <asm/processor.h>
 #include <asm/system.h>
@@ -781,3 +782,41 @@ int __meminit vmemmap_populate(struct pa
 	return 0;
 }
 #endif
+
+#ifdef CONFIG_NUMA
+int __meminit cpu_area_populate(void *start, unsigned long size,
+						gfp_t flags, int node)
+{
+	unsigned long addr = (unsigned long)start;
+	unsigned long end = addr + size;
+	unsigned long next;
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+
+	for (; addr < end; addr = next) {
+		next = pmd_addr_end(addr, end);
+
+		pgd = cpu_area_pgd_populate(addr, flags, node);
+		if (!pgd)
+			return -ENOMEM;
+		pud = cpu_area_pud_populate(pgd, addr, flags, node);
+		if (!pud)
+			return -ENOMEM;
+
+		pmd = pmd_offset(pud, addr);
+		if (pmd_none(*pmd)) {
+			pte_t entry;
+			void *p = cpu_area_alloc_block(PMD_SIZE, flags, node);
+			if (!p)
+				return -ENOMEM;
+
+			entry = pfn_pte(__pa(p) >> PAGE_SHIFT, PAGE_KERNEL);
+			mk_pte_huge(entry);
+			set_pmd(pmd, __pmd(pte_val(entry)));
+		}
+	}
+
+	return 0;
+}
+#endif
Index: linux-2.6/arch/x86/Kconfig.x86_64
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig.x86_64	2007-11-04 09:45:12.000000000 -0800
+++ linux-2.6/arch/x86/Kconfig.x86_64	2007-11-04 16:16:06.000000000 -0800
@@ -137,6 +137,19 @@ config ARCH_HAS_ILOG2_U64
 	bool
 	default n
 
+config CPU_AREA_VIRTUAL
+	bool
+	default y
+
+config CPU_AREA_ORDER
+	int
+	default "16"
+
+config CPU_AREA_ALLOC_ORDER
+	int
+	default "9" if NUMA
+	default "0" if !NUMA
+
 source "init/Kconfig"
 
 
Index: linux-2.6/include/asm-x86/pgtable_64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/pgtable_64.h	2007-11-04 09:45:12.000000000 -0800
+++ linux-2.6/include/asm-x86/pgtable_64.h	2007-11-04 16:16:06.000000000 -0800
@@ -138,6 +138,7 @@ static inline pte_t ptep_get_and_clear_f
 #define VMALLOC_START    _AC(0xffffc20000000000, UL)
 #define VMALLOC_END      _AC(0xffffe1ffffffffff, UL)
 #define VMEMMAP_START	 _AC(0xffffe20000000000, UL)
+#define CPU_AREA_BASE	 _AC(0xfffff20000000000, UL)
 #define MODULES_VADDR    _AC(0xffffffff88000000, UL)
 #define MODULES_END      _AC(0xfffffffffff00000, UL)
 #define MODULES_LEN   (MODULES_END - MODULES_VADDR)

-- 
