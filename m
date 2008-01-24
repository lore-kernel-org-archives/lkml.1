Return-Path: <linux-kernel-owner+w=401wt.eu-S1760221AbYAZQFP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760221AbYAZQFP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 11:05:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756733AbYAZP4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 10:56:25 -0500
Received: from 206-47-31-89.wifiinternet.cz ([89.31.47.206]:1177 "EHLO
	monstr.monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756654AbYAZP4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 10:56:22 -0500
From: monstr@monstr.eu
To: monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       john.williams@petalogix.com, microblaze-uclinux@itee.uq.edu.au
Subject: [PATCH 29/52] [microblaze] memory inicialization, MMU, TLB
Date: Thu, 24 Jan 2008 16:03:04 +0100
Message-Id: <7b0cfa6ae11749e20c941d0a4f03577141e022f8.1201107832.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.rc4.14.g6fc74
In-Reply-To: <48db19662b808ab6f5455dd7f2116e6544c50e95.1201107832.git.monstr@monstr.eu>
References: <1201187014-3979-1-git-send-email-monstr@monstr.eu>
 <dbff6b883dbcb108db53e5093994c473946e1240.1201107832.git.monstr@monstr.eu>
 <ac0947adfe718fcb4c0dc5f6f7ab64f8155541fb.1201107832.git.monstr@monstr.eu>
 <873c2bf1f67696aa11014886470f6ba46f04e8d2.1201107832.git.monstr@monstr.eu>
 <516d173b1789ea533431e8f5ad05751c6a353c88.1201107832.git.monstr@monstr.eu>
 <068508828aac6298b4cc65b0cd7b2737a61c466c.1201107832.git.monstr@monstr.eu>
 <010fc233f82a8f7a591c9f8315ae03f9951139aa.1201107832.git.monstr@monstr.eu>
 <68faaf69ea03196d4a56a263707355e7e7eb5c6a.1201107832.git.monstr@monstr.eu>
 <4b7d90fc1b9bcb3c0b1b308c6460390f7bdf3824.1201107832.git.monstr@monstr.eu>
 <eb28582e845efb4f2f26054630895f26fa69866e.1201107832.git.monstr@monstr.eu>
 <64e6e541db30cc4f1ee5cd85da4bdea6024f75b8.1201107832.git.monstr@monstr.eu>
 <90badb264d0e4ec49fdaa76842a5e5f259681299.1201107832.git.monstr@monstr.eu>
 <a013a2b7044186c64d55cdafc8c9b29bc73a7fc5.1201107832.git.monstr@monstr.eu>
 <60642f04ebcf9f76da50a1d40191755f258edcc5.1201107832.git.monstr@monstr.eu>
 <240998be1af3774635995fd19248f8b3a9e8a702.1201107832.git.monstr@monstr.eu>
 <3bcb9581bc512fdd0a124ac8322af9e2a8adc975.1201107832.git.monstr@monstr.eu>
 <db7f441df21cfe296a44744747b28f379e75fd49.1201107832.git.monstr@monstr.eu>
 <e6309af7cc6550ef5b399fc0902f1926f9e52e58.1201107832.git.monstr@monstr.eu>
 <2d11eef3abada1f41658a532a483c6121ded8054.1201107832.git.monstr@monstr.eu>
 <48db19662b808ab6f5455dd7f2116e6544c50e95.1201107832.git.monstr@monstr.eu>
In-Reply-To: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
References: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/mm/init.c            |  188 ++++++++++++++++++++++++++++++++++
 include/asm-microblaze/mmu.h         |   19 ++++
 include/asm-microblaze/mmu_context.h |   24 +++++
 include/asm-microblaze/tlb.h         |   18 ++++
 include/asm-microblaze/tlbflush.h    |   22 ++++
 5 files changed, 271 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/mm/init.c
 create mode 100644 include/asm-microblaze/mmu.h
 create mode 100644 include/asm-microblaze/mmu_context.h
 create mode 100644 include/asm-microblaze/tlb.h
 create mode 100644 include/asm-microblaze/tlbflush.h

diff --git a/arch/microblaze/mm/init.c b/arch/microblaze/mm/init.c
new file mode 100644
index 0000000..ebb71bf
--- /dev/null
+++ b/arch/microblaze/mm/init.c
@@ -0,0 +1,188 @@
+/*
+ * arch/microblaze/mm/init.c
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2007 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#include <linux/autoconf.h>
+#include <linux/init.h>
+#include <linux/mm.h>
+#include "../../../mm/internal.h"
+#include <linux/swap.h>
+#include <linux/bootmem.h>
+#include <linux/pfn.h>
+#include <asm/sections.h>
+
+#include <asm/lmb.h>
+#include <asm/uaccess.h>
+#include <asm/system.h>
+#include <asm/pgtable.h>
+
+#undef DEBUG
+
+#ifdef DEBUG
+#define DBG(fmt...) printk(fmt)
+#else
+#define DBG(fmt...)
+#endif
+
+char *klimit = _end;
+static unsigned int memory_start;
+static unsigned int memory_end;
+unsigned int PAGE_OFFSET;
+
+void __init setup_memory(void)
+{
+	int i;
+	unsigned int start, end;
+	unsigned long map_size;
+	unsigned long start_pfn = 0;
+	unsigned long end_pfn = 0;
+
+	/* Find main memory where is the kernel */
+	for (i = 0; i < lmb.memory.cnt; i++) {
+		start_pfn = lmb.memory.region[i].base >> PAGE_SHIFT;
+		end_pfn = start_pfn + lmb_size_pages(&lmb.memory, i);
+		if ((start_pfn <= (((int)_text) >> PAGE_SHIFT)) &&
+			(((int)_text >> PAGE_SHIFT) <= end_pfn)) {
+			memory_end = (end_pfn << PAGE_SHIFT) - 1;
+			PAGE_OFFSET = memory_start = start_pfn << PAGE_SHIFT;
+			DBG("%s: Main mem: 0x%x-0x%x\n", __FUNCTION__,
+				memory_start, memory_end);
+			break;
+		}
+	}
+	/*
+	 * start_pfn - start page - starting point
+	 * end_pfn - first unused page
+	 * memory_start - base physical address of main memory
+	 * memory_end - end physical address of main memory
+	 * PAGE_OFFSET - moving of first page
+	 *
+	 * Kernel:
+	 * start: base phys address of kernel - page align
+	 * end: base phys address of kernel - page align
+	 *
+	 * min_low_pfn - the first page (mm/bootmem.c - node_boot_start)
+	 * max_low_pfn
+	 * max_mapnr - the first unused page (mm/bootmem.c - node_low_pfn)
+	 * num_physpages - number of all pages
+	 *
+	 */
+
+	/* reservation of region where is the kernel */
+	start = PFN_DOWN((int)_text) << PAGE_SHIFT;
+	end = PAGE_ALIGN((unsigned long)klimit);
+	lmb_reserve(start, end - start);
+	DBG("%s: kernel addr 0x%08x-0x%08x\n", __FUNCTION__, start, end);
+
+	/* calculate free pages, etc. */
+	min_low_pfn = PFN_UP(start_pfn << PAGE_SHIFT);
+	max_mapnr = PFN_DOWN((end_pfn << PAGE_SHIFT));
+	max_low_pfn = max_mapnr - min_low_pfn;
+	num_physpages = max_mapnr - min_low_pfn + 1;
+	printk(KERN_INFO "%s: max_mapnr: %#lx\n", __FUNCTION__, max_mapnr);
+	printk(KERN_INFO "%s: min_low_pfn: %#lx\n", __FUNCTION__, min_low_pfn);
+	printk(KERN_INFO "%s: max_low_pfn: %#lx\n", __FUNCTION__, max_low_pfn);
+
+	/* add place for data pages */
+	map_size = init_bootmem_node(NODE_DATA(0), PFN_UP(end),
+			min_low_pfn, max_mapnr);
+	lmb_reserve(PFN_UP(end) << PAGE_SHIFT, map_size);
+
+	/* free bootmem is whole main memory */
+	free_bootmem(start_pfn << PAGE_SHIFT,
+			((end_pfn - start_pfn) << PAGE_SHIFT) - 1);
+
+	/* reserve allocate blocks */
+	for (i = 1; i < lmb.reserved.cnt; i++) {
+		DBG("reserved %d - 0x%08x-0x%08x\n", i,
+			(u32) lmb.reserved.region[i].base,
+			(u32) lmb_size_bytes(&lmb.reserved, i));
+		reserve_bootmem(lmb.reserved.region[i].base,
+			lmb_size_bytes(&lmb.reserved, i) - 1);
+	}
+}
+
+void paging_init(void)
+{
+	int i;
+	unsigned long zones_size[MAX_NR_ZONES];
+
+	/* we can DMA to/from any address.  put all page into
+	 * ZONE_DMA. */
+	zones_size[ZONE_NORMAL] = max_low_pfn;
+
+	/* every other zones are empty */
+	for (i = 1; i < MAX_NR_ZONES; i++)
+		zones_size[i] = 0;
+
+	free_area_init_node(0, NODE_DATA(0), zones_size,
+		NODE_DATA(0)->bdata->node_boot_start >> PAGE_SHIFT, NULL);
+}
+
+void free_init_pages(char *what, unsigned long begin, unsigned long end)
+{
+	unsigned long addr;
+
+	for (addr = begin; addr < end; addr += PAGE_SIZE) {
+		ClearPageReserved(virt_to_page(addr));
+		init_page_count(virt_to_page(addr));
+		memset((void *)addr, 0xcc, PAGE_SIZE);
+		free_page(addr);
+		totalram_pages++;
+	}
+	printk(KERN_INFO "Freeing %s: %ldk freed\n", what, (end - begin) >> 10);
+}
+
+#ifdef CONFIG_BLK_DEV_INITRD
+void free_initrd_mem(unsigned long start, unsigned long end)
+{
+	int pages = 0;
+	for (; start < end; start += PAGE_SIZE) {
+		ClearPageReserved(virt_to_page(start));
+		set_page_count(virt_to_page(start), 1);
+		free_page(start);
+		totalram_pages++;
+		pages++;
+	}
+	printk(KERN_NOTICE "Freeing initrd memory: %dk freed\n", pages);
+}
+#endif
+
+void free_initmem(void)
+{
+	free_init_pages("unused kernel memory",
+			(unsigned long)(&__init_begin),
+			(unsigned long)(&__init_end));
+}
+
+/* FIXME from arch/powerpc/mm/mem.c*/
+void show_mem(void)
+{
+	printk(KERN_NOTICE "%s\n", __FUNCTION__);
+}
+
+void __init mem_init(void)
+{
+	high_memory = (void *)(memory_end);
+
+	/* this will put all memory onto the freelists */
+	totalram_pages += free_all_bootmem();
+
+	printk(KERN_INFO "Memory: %luk/%luk available\n",
+	       (unsigned long) nr_free_pages() << (PAGE_SHIFT-10),
+	       num_physpages << (PAGE_SHIFT-10));
+}
+
+/* Check against bounds of physical memory */
+int ___range_ok(unsigned long addr, unsigned long size)
+{
+	return ((addr < memory_start) ||
+		((addr + size) >= memory_end));
+}
diff --git a/include/asm-microblaze/mmu.h b/include/asm-microblaze/mmu.h
new file mode 100644
index 0000000..c0d5e55
--- /dev/null
+++ b/include/asm-microblaze/mmu.h
@@ -0,0 +1,19 @@
+/*
+ * include/asm-microblaze/mmu.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_MMU_H
+#define _ASM_MMU_H
+
+typedef struct {
+	struct vm_list_struct	*vmlist;
+	unsigned long		end_brk;
+} mm_context_t;
+
+#endif /* _ASM_MMU_H */
diff --git a/include/asm-microblaze/mmu_context.h b/include/asm-microblaze/mmu_context.h
new file mode 100644
index 0000000..ad499fd
--- /dev/null
+++ b/include/asm-microblaze/mmu_context.h
@@ -0,0 +1,24 @@
+/*
+ * include/asm-microblaze/mmu_context.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_MMU_CONTEXT_H
+#define _ASM_MMU_CONTEXT_H
+
+#define init_new_context(tsk, mm)		({ 0; })
+
+#define enter_lazy_tlb(mm, tsk)			do {} while (0)
+#define change_mm_context(old, ctx, _pml4)	do {} while (0)
+#define destroy_context(mm)			do {} while (0)
+#define deactivate_mm(tsk, mm)			do {} while (0)
+#define switch_mm(prev, next, tsk)		do {} while (0)
+#define activate_mm(prev, next)			do {} while (0)
+
+
+#endif /* _ASM_MMU_CONTEXT_H */
diff --git a/include/asm-microblaze/tlb.h b/include/asm-microblaze/tlb.h
new file mode 100644
index 0000000..5ae1b1c
--- /dev/null
+++ b/include/asm-microblaze/tlb.h
@@ -0,0 +1,18 @@
+/*
+ * include/asm-microblaze/tlb.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_TLB_H
+#define _ASM_TLB_H
+
+#define tlb_flush(tlb)	do {} while (0)
+
+#include <asm-generic/tlb.h>
+
+#endif /* _ASM_TLB_H */
diff --git a/include/asm-microblaze/tlbflush.h b/include/asm-microblaze/tlbflush.h
new file mode 100644
index 0000000..57393ed
--- /dev/null
+++ b/include/asm-microblaze/tlbflush.h
@@ -0,0 +1,22 @@
+/*
+ * include/asm-microblaze/tlbflush.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_TLBFLUSH_H
+#define _ASM_TLBFLUSH_H
+
+#define flush_tlb()				BUG()
+#define flush_tlb_all()				BUG()
+#define flush_tlb_mm(mm)			BUG()
+#define flush_tlb_page(vma, addr)		BUG()
+#define flush_tlb_range(mm, start, end)		BUG()
+#define flush_tlb_pgtables(mm, start, end)	BUG()
+#define flush_tlb_kernel_range(start, end)	BUG()
+
+#endif /* _ASM_TLBFLUSH_H */
-- 
1.5.4.rc4.14.g6fc74

