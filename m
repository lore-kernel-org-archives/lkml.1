Return-Path: <linux-kernel-owner+w=401wt.eu-S1760845AbYAZQGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760845AbYAZQGi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 11:06:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756684AbYAZP4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 10:56:42 -0500
Received: from 206-47-31-89.wifiinternet.cz ([89.31.47.206]:1177 "EHLO
	monstr.monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753533AbYAZP4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 10:56:40 -0500
From: monstr@monstr.eu
To: monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       john.williams@petalogix.com, microblaze-uclinux@itee.uq.edu.au
Subject: [PATCH 12/52] [microblaze] lmb support
Date: Thu, 24 Jan 2008 16:02:47 +0100
Message-Id: <873c2bf1f67696aa11014886470f6ba46f04e8d2.1201107832.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.rc4.14.g6fc74
In-Reply-To: <ac0947adfe718fcb4c0dc5f6f7ab64f8155541fb.1201107832.git.monstr@monstr.eu>
References: <1201187014-3979-1-git-send-email-monstr@monstr.eu>
 <dbff6b883dbcb108db53e5093994c473946e1240.1201107832.git.monstr@monstr.eu>
 <ac0947adfe718fcb4c0dc5f6f7ab64f8155541fb.1201107832.git.monstr@monstr.eu>
In-Reply-To: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
References: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/mm/lmb.c     |  342 ++++++++++++++++++++++++++++++++++++++++++
 include/asm-microblaze/lmb.h |   84 ++++++++++
 2 files changed, 426 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/mm/lmb.c
 create mode 100644 include/asm-microblaze/lmb.h

diff --git a/arch/microblaze/mm/lmb.c b/arch/microblaze/mm/lmb.c
new file mode 100644
index 0000000..993ea49
--- /dev/null
+++ b/arch/microblaze/mm/lmb.c
@@ -0,0 +1,342 @@
+/*
+ * Procedures for maintaining information about logical memory blocks.
+ *
+ * Peter Bergner, IBM Corp.	June 2001.
+ * Copyright (C) 2001 Peter Bergner.
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of the GNU General Public License
+ *      as published by the Free Software Foundation; either version
+ *      2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/bitops.h>
+#include <asm/types.h>
+#include <asm/page.h>
+#include <asm/prom.h>
+#include <asm/lmb.h>
+#ifdef CONFIG_PPC32
+#include "mmu_decl.h"		/* for __max_low_memory */
+#endif
+
+#define DEBUG
+
+#ifdef DEBUG
+#define DBG(fmt...) printk(fmt)
+#else
+#define DBG(fmt...)
+#endif
+
+#define LMB_ALLOC_ANYWHERE	0
+
+struct lmb lmb;
+
+void lmb_dump_all(void)
+{
+#ifdef DEBUG
+	unsigned int i;
+
+	DBG("lmb_dump_all:\n");
+	DBG("    memory.cnt		  = 0x%lx\n", lmb.memory.cnt);
+	DBG("    memory.size		  = 0x%lx\n", lmb.memory.size);
+	for (i = 0; i < lmb.memory.cnt ; i++) {
+		DBG("    memory.region[0x%x].base       = 0x%lx\n",
+			    i, lmb.memory.region[i].base);
+		DBG("		      .size     = 0x%lx\n",
+			    lmb.memory.region[i].size);
+	}
+
+	DBG("\n    reserved.cnt	  = 0x%lx\n", lmb.reserved.cnt);
+	DBG("    reserved.size	  = 0x%lx\n", lmb.reserved.size);
+	for (i = 0; i < lmb.reserved.cnt ; i++) {
+		DBG("    reserved.region[0x%x].base       = 0x%lx\n",
+			    i, lmb.reserved.region[i].base);
+		DBG("		      .size     = 0x%lx\n",
+			    lmb.reserved.region[i].size);
+	}
+#endif /* DEBUG */
+}
+
+static unsigned long __init lmb_addrs_overlap(unsigned long base1,
+		unsigned long size1, unsigned long base2, unsigned long size2)
+{
+	return ((base1 < (base2+size2)) && (base2 < (base1+size1)));
+}
+
+static long __init lmb_addrs_adjacent(unsigned long base1, unsigned long size1,
+		unsigned long base2, unsigned long size2)
+{
+	if (base2 == base1 + size1)
+		return 1;
+	else if (base1 == base2 + size2)
+		return -1;
+
+	return 0;
+}
+
+static long __init lmb_regions_adjacent(struct lmb_region *rgn,
+		unsigned long r1, unsigned long r2)
+{
+	unsigned long base1 = rgn->region[r1].base;
+	unsigned long size1 = rgn->region[r1].size;
+	unsigned long base2 = rgn->region[r2].base;
+	unsigned long size2 = rgn->region[r2].size;
+
+	return lmb_addrs_adjacent(base1, size1, base2, size2);
+}
+
+static void __init lmb_remove_region(struct lmb_region *rgn, unsigned long r)
+{
+	unsigned long i;
+
+	for (i = r; i < rgn->cnt - 1; i++) {
+		rgn->region[i].base = rgn->region[i + 1].base;
+		rgn->region[i].size = rgn->region[i + 1].size;
+	}
+	rgn->cnt--;
+}
+
+/* Assumption: base addr of region 1 < base addr of region 2 */
+static void __init lmb_coalesce_regions(struct lmb_region *rgn,
+		unsigned long r1, unsigned long r2)
+{
+	rgn->region[r1].size += rgn->region[r2].size;
+	lmb_remove_region(rgn, r2);
+}
+
+/* This routine called with relocation disabled. */
+void __init lmb_init(void)
+{
+	/* Create a dummy zero size LMB which will get coalesced away later.
+	 * This simplifies the lmb_add() code below...
+	 */
+	lmb.memory.region[0].base = 0;
+	lmb.memory.region[0].size = 0;
+	lmb.memory.cnt = 1;
+
+	/* Ditto. */
+	lmb.reserved.region[0].base = 0;
+	lmb.reserved.region[0].size = 0;
+	lmb.reserved.cnt = 1;
+}
+
+/* This routine may be called with relocation disabled. */
+void __init lmb_analyze(void)
+{
+	int i;
+
+	lmb.memory.size = 0;
+
+	for (i = 0; i < lmb.memory.cnt; i++)
+		lmb.memory.size += lmb.memory.region[i].size;
+}
+
+/* This routine called with relocation disabled. */
+static long __init lmb_add_region(struct lmb_region *rgn, unsigned long base,
+				  unsigned long size)
+{
+	unsigned long i, coalesced = 0;
+	long adjacent;
+
+	/* First try and coalesce this LMB with another. */
+	for (i = 0; i < rgn->cnt; i++) {
+		unsigned long rgnbase = rgn->region[i].base;
+		unsigned long rgnsize = rgn->region[i].size;
+
+		if ((rgnbase == base) && (rgnsize == size))
+			/* Already have this region, so we're done */
+			return 0;
+
+		adjacent = lmb_addrs_adjacent(base, size, rgnbase, rgnsize);
+		if (adjacent > 0) {
+			rgn->region[i].base -= size;
+			rgn->region[i].size += size;
+			coalesced++;
+			break;
+		} else if (adjacent < 0) {
+				rgn->region[i].size += size;
+				coalesced++;
+				break;
+		}
+	}
+
+	if ((i < rgn->cnt-1) && lmb_regions_adjacent(rgn, i, i + 1)) {
+		lmb_coalesce_regions(rgn, i, i+1);
+		coalesced++;
+	}
+
+	if (coalesced)
+		return coalesced;
+	if (rgn->cnt >= MAX_LMB_REGIONS)
+		return -1;
+
+	/* Couldn't coalesce the LMB, so add it to the sorted table. */
+	for (i = rgn->cnt-1; i >= 0; i--) {
+		if (base < rgn->region[i].base) {
+			rgn->region[i+1].base = rgn->region[i].base;
+			rgn->region[i+1].size = rgn->region[i].size;
+		} else {
+			rgn->region[i+1].base = base;
+			rgn->region[i+1].size = size;
+			break;
+		}
+	}
+	rgn->cnt++;
+
+	return 0;
+}
+
+/* This routine may be called with relocation disabled. */
+long __init lmb_add(unsigned long base, unsigned long size)
+{
+	struct lmb_region *_rgn = &(lmb.memory);
+
+	/* On pSeries LPAR systems, the first LMB is our RMO region. */
+	if (base == 0)
+		lmb.rmo_size = size;
+
+	return lmb_add_region(_rgn, base, size);
+
+}
+
+long __init lmb_reserve(unsigned long base, unsigned long size)
+{
+	struct lmb_region *_rgn = &(lmb.reserved);
+
+	BUG_ON(0 == size);
+
+	return lmb_add_region(_rgn, base, size);
+}
+
+long __init lmb_overlaps_region(struct lmb_region *rgn, unsigned long base,
+				unsigned long size)
+{
+	unsigned long i;
+
+	for (i = 0; i < rgn->cnt; i++) {
+		unsigned long rgnbase = rgn->region[i].base;
+		unsigned long rgnsize = rgn->region[i].size;
+		if (lmb_addrs_overlap(base, size, rgnbase, rgnsize))
+			break;
+	}
+
+	return (i < rgn->cnt) ? i : -1;
+}
+
+unsigned long __init lmb_alloc(unsigned long size, unsigned long align)
+{
+	return lmb_alloc_base(size, align, LMB_ALLOC_ANYWHERE);
+}
+
+unsigned long __init lmb_alloc_base(unsigned long size, unsigned long align,
+				    unsigned long max_addr)
+{
+	unsigned long alloc;
+
+	alloc = __lmb_alloc_base(size, align, max_addr);
+
+	if (alloc == 0)
+		panic("ERROR: Failed to allocate 0x%lx bytes below 0x%lx.\n",
+				size, max_addr);
+
+	return alloc;
+}
+
+unsigned long __init __lmb_alloc_base(unsigned long size, unsigned long align,
+				    unsigned long max_addr)
+{
+	long i, j;
+	unsigned long base = 0;
+
+	BUG_ON(0 == size);
+
+#ifdef CONFIG_PPC32
+	/* On 32-bit, make sure we allocate lowmem */
+	if (max_addr == LMB_ALLOC_ANYWHERE)
+		max_addr = __max_low_memory;
+#endif
+	for (i = lmb.memory.cnt-1; i >= 0; i--) {
+		unsigned long lmbbase = lmb.memory.region[i].base;
+		unsigned long lmbsize = lmb.memory.region[i].size;
+
+		if (max_addr == LMB_ALLOC_ANYWHERE)
+			base = _ALIGN_DOWN(lmbbase + lmbsize - size, align);
+		else if (lmbbase < max_addr) {
+			base = min(lmbbase + lmbsize, max_addr);
+			base = _ALIGN_DOWN(base - size, align);
+		} else
+			continue;
+
+		while ((lmbbase <= base) &&
+		       ((j = lmb_overlaps_region(&lmb.reserved, base, size))
+						>= 0))
+			base = _ALIGN_DOWN(lmb.reserved.region[j].base - size,
+					   align);
+
+		if ((base != 0) && (lmbbase <= base))
+			break;
+	}
+
+	if (i < 0)
+		return 0;
+
+	lmb_add_region(&lmb.reserved, base, size);
+
+	return base;
+}
+
+/* You must call lmb_analyze() before this. */
+unsigned long __init lmb_phys_mem_size(void)
+{
+	return lmb.memory.size;
+}
+
+unsigned long __init lmb_end_of_DRAM(void)
+{
+	int idx = lmb.memory.cnt - 1;
+
+	return (lmb.memory.region[idx].base + lmb.memory.region[idx].size);
+}
+
+/* You must call lmb_analyze() after this. */
+void __init lmb_enforce_memory_limit(unsigned long memory_limit)
+{
+	unsigned long i, limit;
+	struct lmb_property *p;
+
+	if (!memory_limit)
+		return;
+
+	/* Truncate the lmb regions to satisfy the memory limit. */
+	limit = memory_limit;
+	for (i = 0; i < lmb.memory.cnt; i++) {
+		if (limit > lmb.memory.region[i].size) {
+			limit -= lmb.memory.region[i].size;
+			continue;
+		}
+
+		lmb.memory.region[i].size = limit;
+		lmb.memory.cnt = i + 1;
+		break;
+	}
+
+	if (lmb.memory.region[0].size < lmb.rmo_size)
+		lmb.rmo_size = lmb.memory.region[0].size;
+
+	/* And truncate any reserves above the limit also. */
+	for (i = 0; i < lmb.reserved.cnt; i++) {
+		p = &lmb.reserved.region[i];
+
+		if (p->base > memory_limit)
+			p->size = 0;
+		else if ((p->base + p->size) > memory_limit)
+			p->size = memory_limit - p->base;
+
+		if (p->size == 0) {
+			lmb_remove_region(&lmb.reserved, i);
+			i--;
+		}
+	}
+}
diff --git a/include/asm-microblaze/lmb.h b/include/asm-microblaze/lmb.h
new file mode 100644
index 0000000..f27bb13
--- /dev/null
+++ b/include/asm-microblaze/lmb.h
@@ -0,0 +1,84 @@
+/*
+ * include/asm-microblaze/lmb.h
+ *
+ * Definitions for talking to the Open Firmware PROM on
+ * Power Macintosh computers.
+ *
+ * Copyright (C) 2001 Peter Bergner, IBM Corp.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _ASM_LMB_H
+#define _ASM_LMB_H
+#ifdef __KERNEL__
+
+#include <linux/init.h>
+#include <asm/prom.h>
+
+#define MAX_LMB_REGIONS 128
+
+struct lmb_property {
+	unsigned long base;
+	unsigned long size;
+};
+
+struct lmb_region {
+	unsigned long cnt;
+	unsigned long size;
+	struct lmb_property region[MAX_LMB_REGIONS+1];
+};
+
+struct lmb {
+	unsigned long debug;
+	unsigned long rmo_size;
+	struct lmb_region memory;
+	struct lmb_region reserved;
+};
+
+extern struct lmb lmb;
+
+extern void __init lmb_init(void);
+extern void __init lmb_analyze(void);
+extern long __init lmb_add(unsigned long base, unsigned long size);
+extern long __init lmb_reserve(unsigned long base, unsigned long size);
+extern unsigned long __init lmb_alloc(unsigned long size, unsigned long align);
+extern unsigned long __init lmb_alloc_base(unsigned long size,
+		unsigned long align, unsigned long max_addr);
+extern unsigned long __init __lmb_alloc_base(unsigned long size,
+		unsigned long align, unsigned long max_addr);
+extern unsigned long __init lmb_phys_mem_size(void);
+extern unsigned long __init lmb_end_of_DRAM(void);
+extern void __init lmb_enforce_memory_limit(unsigned long memory_limit);
+extern long __init lmb_overlaps_region(struct lmb_region *rgn,
+			unsigned long base, unsigned long size);
+
+extern void lmb_dump_all(void);
+
+static inline unsigned long
+lmb_size_bytes(struct lmb_region *type, unsigned long region_nr)
+{
+	return type->region[region_nr].size;
+}
+static inline unsigned long
+lmb_size_pages(struct lmb_region *type, unsigned long region_nr)
+{
+	return lmb_size_bytes(type, region_nr) >> PAGE_SHIFT;
+}
+static inline unsigned long
+lmb_start_pfn(struct lmb_region *type, unsigned long region_nr)
+{
+	return type->region[region_nr].base >> PAGE_SHIFT;
+}
+static inline unsigned long
+lmb_end_pfn(struct lmb_region *type, unsigned long region_nr)
+{
+	return lmb_start_pfn(type, region_nr) +
+		lmb_size_pages(type, region_nr);
+}
+
+#endif /* __KERNEL__ */
+#endif /* _ASM_LMB_H */
-- 
1.5.4.rc4.14.g6fc74

