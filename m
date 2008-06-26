Return-Path: <linux-kernel-owner+w=401wt.eu-S1762344AbYFZNEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762344AbYFZNEe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 09:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758164AbYFZMpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:45:51 -0400
Received: from 238.225.broadband7.iol.cz ([88.102.225.238]:23829 "EHLO
	monstr.eu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760025AbYFZMps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:45:48 -0400
From: monstr@seznam.cz
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, john.williams@petalogix.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       linuxppc-dev@ozlabs.org, vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk,
       hpa@zytor.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 31/60] microblaze_v4: memory inicialization, MMU, TLB
Date: Thu, 26 Jun 2008 14:30:00 +0200
Message-Id: <1214483429-32360-32-git-send-email-monstr@seznam.cz>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <1214483429-32360-31-git-send-email-monstr@seznam.cz>
References: <1214483429-32360-1-git-send-email-monstr@seznam.cz>
 <1214483429-32360-2-git-send-email-monstr@seznam.cz>
 <1214483429-32360-3-git-send-email-monstr@seznam.cz>
 <1214483429-32360-4-git-send-email-monstr@seznam.cz>
 <1214483429-32360-5-git-send-email-monstr@seznam.cz>
 <1214483429-32360-6-git-send-email-monstr@seznam.cz>
 <1214483429-32360-7-git-send-email-monstr@seznam.cz>
 <1214483429-32360-8-git-send-email-monstr@seznam.cz>
 <1214483429-32360-9-git-send-email-monstr@seznam.cz>
 <1214483429-32360-10-git-send-email-monstr@seznam.cz>
 <1214483429-32360-11-git-send-email-monstr@seznam.cz>
 <1214483429-32360-12-git-send-email-monstr@seznam.cz>
 <1214483429-32360-13-git-send-email-monstr@seznam.cz>
 <1214483429-32360-14-git-send-email-monstr@seznam.cz>
 <1214483429-32360-15-git-send-email-monstr@seznam.cz>
 <1214483429-32360-16-git-send-email-monstr@seznam.cz>
 <1214483429-32360-17-git-send-email-monstr@seznam.cz>
 <1214483429-32360-18-git-send-email-monstr@seznam.cz>
 <1214483429-32360-19-git-send-email-monstr@seznam.cz>
 <1214483429-32360-20-git-send-email-monstr@seznam.cz>
 <1214483429-32360-21-git-send-email-monstr@seznam.cz>
 <1214483429-32360-22-git-send-email-monstr@seznam.cz>
 <1214483429-32360-23-git-send-email-monstr@seznam.cz>
 <1214483429-32360-24-git-send-email-monstr@seznam.cz>
 <1214483429-32360-25-git-send-email-monstr@seznam.cz>
 <1214483429-32360-26-git-send-email-monstr@seznam.cz>
 <1214483429-32360-27-git-send-email-monstr@seznam.cz>
 <1214483429-32360-28-git-send-email-monstr@seznam.cz>
 <1214483429-32360-29-git-send-email-monstr@seznam.cz>
 <1214483429-32360-30-git-send-email-monstr@seznam.cz>
 <1214483429-32360-31-git-send-email-monstr@seznam.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/mm/init.c            |  184 ++++++++++++++++++++++++++++++++++
 include/asm-microblaze/mmu.h         |   17 +++
 include/asm-microblaze/mmu_context.h |   22 ++++
 include/asm-microblaze/tlb.h         |   16 +++
 include/asm-microblaze/tlbflush.h    |   20 ++++
 5 files changed, 259 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/mm/init.c
 create mode 100644 include/asm-microblaze/mmu.h
 create mode 100644 include/asm-microblaze/mmu_context.h
 create mode 100644 include/asm-microblaze/tlb.h
 create mode 100644 include/asm-microblaze/tlbflush.h

diff --git a/arch/microblaze/mm/init.c b/arch/microblaze/mm/init.c
new file mode 100644
index 0000000..5bb3e01
--- /dev/null
+++ b/arch/microblaze/mm/init.c
@@ -0,0 +1,184 @@
+/*
+ * arch/microblaze/mm/init.c
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2007-2008 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#undef DEBUG
+
+#include <linux/autoconf.h>
+#include <linux/init.h>
+#include <linux/mm.h>
+#include "../../../mm/internal.h"
+#include <linux/swap.h>
+#include <linux/bootmem.h>
+#include <linux/pfn.h>
+#include <linux/lmb.h>
+
+#include <asm/sections.h>
+#include <asm/uaccess.h>
+#include <asm/system.h>
+#include <asm/pgtable.h>
+
+char *klimit = _end;
+static unsigned int memory_start;
+unsigned int memory_end; /* due to mm/nommu.c */
+
+unsigned int __page_offset;
+/* EXPORT_SYMBOL(__page_offset); */
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
+			pr_debug("%s: Main mem: 0x%x-0x%x\n", __func__,
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
+	pr_debug("%s: kernel addr 0x%08x-0x%08x\n", __func__, start, end);
+
+	/* calculate free pages, etc. */
+	min_low_pfn = PFN_UP(start_pfn << PAGE_SHIFT);
+	max_mapnr = PFN_DOWN((end_pfn << PAGE_SHIFT));
+	max_low_pfn = max_mapnr - min_low_pfn;
+	num_physpages = max_mapnr - min_low_pfn + 1;
+	printk(KERN_INFO "%s: max_mapnr: %#lx\n", __func__, max_mapnr);
+	printk(KERN_INFO "%s: min_low_pfn: %#lx\n", __func__, min_low_pfn);
+	printk(KERN_INFO "%s: max_low_pfn: %#lx\n", __func__, max_low_pfn);
+
+	/* add place for data pages */
+	map_size = init_bootmem_node(NODE_DATA(0), PFN_UP(end),
+			min_low_pfn, max_mapnr);
+	lmb_reserve(PFN_UP(end) << PAGE_SHIFT, map_size);
+
+	/* free bootmem is whole main memory */
+	free_bootmem_node(NODE_DATA(0), start_pfn << PAGE_SHIFT,
+			((end_pfn - start_pfn) << PAGE_SHIFT) - 1);
+
+	/* reserve allocate blocks */
+	for (i = 0; i < lmb.reserved.cnt; i++) {
+		pr_debug("reserved %d - 0x%08x-0x%08x\n", i,
+			(u32) lmb.reserved.region[i].base,
+			(u32) lmb_size_bytes(&lmb.reserved, i));
+		reserve_bootmem(lmb.reserved.region[i].base,
+			lmb_size_bytes(&lmb.reserved, i) - 1, BOOTMEM_DEFAULT);
+	}
+}
+
+void __init paging_init(void)
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
+	printk(KERN_NOTICE "%s\n", __func__);
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
index 0000000..e9cd52d
--- /dev/null
+++ b/include/asm-microblaze/mmu.h
@@ -0,0 +1,17 @@
+/*
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_MICROBLAZE_MMU_H
+#define _ASM_MICROBLAZE_MMU_H
+
+typedef struct {
+	struct vm_list_struct	*vmlist;
+	unsigned long		end_brk;
+} mm_context_t;
+
+#endif /* _ASM_MICROBLAZE_MMU_H */
diff --git a/include/asm-microblaze/mmu_context.h b/include/asm-microblaze/mmu_context.h
new file mode 100644
index 0000000..bd4952a
--- /dev/null
+++ b/include/asm-microblaze/mmu_context.h
@@ -0,0 +1,22 @@
+/*
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_MICROBLAZE_MMU_CONTEXT_H
+#define _ASM_MICROBLAZE_MMU_CONTEXT_H
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
+#endif /* _ASM_MICROBLAZE_MMU_CONTEXT_H */
diff --git a/include/asm-microblaze/tlb.h b/include/asm-microblaze/tlb.h
new file mode 100644
index 0000000..d1dfe37
--- /dev/null
+++ b/include/asm-microblaze/tlb.h
@@ -0,0 +1,16 @@
+/*
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_MICROBLAZE_TLB_H
+#define _ASM_MICROBLAZE_TLB_H
+
+#define tlb_flush(tlb)	do {} while (0)
+
+#include <asm-generic/tlb.h>
+
+#endif /* _ASM_MICROBLAZE_TLB_H */
diff --git a/include/asm-microblaze/tlbflush.h b/include/asm-microblaze/tlbflush.h
new file mode 100644
index 0000000..d7fe762
--- /dev/null
+++ b/include/asm-microblaze/tlbflush.h
@@ -0,0 +1,20 @@
+/*
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_MICROBLAZE_TLBFLUSH_H
+#define _ASM_MICROBLAZE_TLBFLUSH_H
+
+#define flush_tlb()				BUG()
+#define flush_tlb_all()				BUG()
+#define flush_tlb_mm(mm)			BUG()
+#define flush_tlb_page(vma, addr)		BUG()
+#define flush_tlb_range(mm, start, end)		BUG()
+#define flush_tlb_pgtables(mm, start, end)	BUG()
+#define flush_tlb_kernel_range(start, end)	BUG()
+
+#endif /* _ASM_MICROBLAZE_TLBFLUSH_H */
-- 
1.5.4.GIT

