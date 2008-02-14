Return-Path: <linux-kernel-owner+w=401wt.eu-S935074AbYBNBKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935074AbYBNBKf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 20:10:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932680AbYBNBJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 20:09:52 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43579
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933100AbYBNBJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 20:09:48 -0500
Date: Wed, 13 Feb 2008 17:10:19 -0800 (PST)
Message-Id: <20080213.171019.153124516.davem@davemloft.net>
To: linuxppc-dev@ozlabs.org
CC: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4]: [LIB]: Make PowerPC LMB code generic so sparc64 can
 use it too.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[LIB]: Make PowerPC LMB code generic so sparc64 can use it too.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 arch/powerpc/Kconfig                    |    1 +
 arch/powerpc/kernel/btext.c             |    3 +-
 arch/powerpc/kernel/crash.c             |    3 +-
 arch/powerpc/kernel/crash_dump.c        |    3 +-
 arch/powerpc/kernel/machine_kexec.c     |    3 +-
 arch/powerpc/kernel/prom.c              |    2 +-
 arch/powerpc/kernel/rtas.c              |    2 +-
 arch/powerpc/kernel/setup-common.c      |    2 +-
 arch/powerpc/kernel/setup_64.c          |    2 +-
 arch/powerpc/kernel/vdso.c              |    3 +-
 arch/powerpc/mm/Makefile                |    2 +-
 arch/powerpc/mm/hash_utils_64.c         |    3 +-
 arch/powerpc/mm/init_32.c               |    2 +-
 arch/powerpc/mm/init_64.c               |    2 +-
 arch/powerpc/mm/lmb.c                   |  357 -------------------------------
 arch/powerpc/mm/mem.c                   |    2 +-
 arch/powerpc/mm/numa.c                  |    3 +-
 arch/powerpc/mm/ppc_mmu_32.c            |    2 +-
 arch/powerpc/mm/stab.c                  |    4 +-
 arch/powerpc/platforms/cell/iommu.c     |    2 +-
 arch/powerpc/platforms/maple/setup.c    |    2 +-
 arch/powerpc/platforms/powermac/setup.c |    2 +-
 arch/powerpc/platforms/ps3/htab.c       |    3 +-
 arch/powerpc/platforms/ps3/mm.c         |    3 +-
 arch/powerpc/platforms/ps3/os-area.c    |    3 +-
 arch/powerpc/sysdev/dart_iommu.c        |    2 +-
 arch/sparc64/Kconfig                    |    1 +
 include/asm-powerpc/abs_addr.h          |    3 +-
 include/asm-powerpc/lmb.h               |   82 +-------
 include/asm-sparc64/lmb.h               |   10 +
 include/linux/lmb.h                     |   83 +++++++
 lib/Kconfig                             |    3 +
 lib/Makefile                            |    2 +
 lib/lmb.c                               |  354 ++++++++++++++++++++++++++++++
 34 files changed, 500 insertions(+), 456 deletions(-)
 delete mode 100644 arch/powerpc/mm/lmb.c
 create mode 100644 include/asm-sparc64/lmb.h
 create mode 100644 include/linux/lmb.h
 create mode 100644 lib/lmb.c

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 485513c..bd645f0 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -90,6 +90,7 @@ config PPC
 	select HAVE_IDE
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
+	select HAVE_LMB
 
 config EARLY_PRINTK
 	bool
diff --git a/arch/powerpc/kernel/btext.c b/arch/powerpc/kernel/btext.c
index 80e2eef..9f93777 100644
--- a/arch/powerpc/kernel/btext.c
+++ b/arch/powerpc/kernel/btext.c
@@ -7,6 +7,7 @@
 #include <linux/string.h>
 #include <linux/init.h>
 #include <linux/module.h>
+#include <linux/lmb.h>
 
 #include <asm/sections.h>
 #include <asm/prom.h>
@@ -15,7 +16,7 @@
 #include <asm/mmu.h>
 #include <asm/pgtable.h>
 #include <asm/io.h>
-#include <asm/lmb.h>
+#include <asm/prom.h>
 #include <asm/processor.h>
 #include <asm/udbg.h>
 
diff --git a/arch/powerpc/kernel/crash.c b/arch/powerpc/kernel/crash.c
index 571132e..eae401d 100644
--- a/arch/powerpc/kernel/crash.c
+++ b/arch/powerpc/kernel/crash.c
@@ -24,12 +24,13 @@
 #include <linux/init.h>
 #include <linux/irq.h>
 #include <linux/types.h>
+#include <linux/lmb.h>
 
 #include <asm/processor.h>
 #include <asm/machdep.h>
 #include <asm/kexec.h>
 #include <asm/kdump.h>
-#include <asm/lmb.h>
+#include <asm/prom.h>
 #include <asm/firmware.h>
 #include <asm/smp.h>
 #include <asm/system.h>
diff --git a/arch/powerpc/kernel/crash_dump.c b/arch/powerpc/kernel/crash_dump.c
index 29ff77c..9ee3c52 100644
--- a/arch/powerpc/kernel/crash_dump.c
+++ b/arch/powerpc/kernel/crash_dump.c
@@ -13,8 +13,9 @@
 
 #include <linux/crash_dump.h>
 #include <linux/bootmem.h>
+#include <linux/lmb.h>
 #include <asm/kdump.h>
-#include <asm/lmb.h>
+#include <asm/prom.h>
 #include <asm/firmware.h>
 #include <asm/uaccess.h>
 
diff --git a/arch/powerpc/kernel/machine_kexec.c b/arch/powerpc/kernel/machine_kexec.c
index c0c8e8c..2d202f2 100644
--- a/arch/powerpc/kernel/machine_kexec.c
+++ b/arch/powerpc/kernel/machine_kexec.c
@@ -12,8 +12,9 @@
 #include <linux/kexec.h>
 #include <linux/reboot.h>
 #include <linux/threads.h>
+#include <linux/lmb.h>
 #include <asm/machdep.h>
-#include <asm/lmb.h>
+#include <asm/prom.h>
 
 void machine_crash_shutdown(struct pt_regs *regs)
 {
diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
index 8b5efbc..c17a585 100644
--- a/arch/powerpc/kernel/prom.c
+++ b/arch/powerpc/kernel/prom.c
@@ -31,10 +31,10 @@
 #include <linux/kexec.h>
 #include <linux/debugfs.h>
 #include <linux/irq.h>
+#include <linux/lmb.h>
 
 #include <asm/prom.h>
 #include <asm/rtas.h>
-#include <asm/lmb.h>
 #include <asm/page.h>
 #include <asm/processor.h>
 #include <asm/irq.h>
diff --git a/arch/powerpc/kernel/rtas.c b/arch/powerpc/kernel/rtas.c
index 52e95c2..e2e78d9 100644
--- a/arch/powerpc/kernel/rtas.c
+++ b/arch/powerpc/kernel/rtas.c
@@ -22,6 +22,7 @@
 #include <linux/smp.h>
 #include <linux/completion.h>
 #include <linux/cpumask.h>
+#include <linux/lmb.h>
 
 #include <asm/prom.h>
 #include <asm/rtas.h>
@@ -34,7 +35,6 @@
 #include <asm/system.h>
 #include <asm/delay.h>
 #include <asm/uaccess.h>
-#include <asm/lmb.h>
 #include <asm/udbg.h>
 #include <asm/syscalls.h>
 #include <asm/smp.h>
diff --git a/arch/powerpc/kernel/setup-common.c b/arch/powerpc/kernel/setup-common.c
index 6adb5a1..12cc41c 100644
--- a/arch/powerpc/kernel/setup-common.c
+++ b/arch/powerpc/kernel/setup-common.c
@@ -34,6 +34,7 @@
 #include <linux/serial_8250.h>
 #include <linux/debugfs.h>
 #include <linux/percpu.h>
+#include <linux/lmb.h>
 #include <asm/io.h>
 #include <asm/prom.h>
 #include <asm/processor.h>
@@ -56,7 +57,6 @@
 #include <asm/cache.h>
 #include <asm/page.h>
 #include <asm/mmu.h>
-#include <asm/lmb.h>
 #include <asm/xmon.h>
 #include <asm/cputhreads.h>
 
diff --git a/arch/powerpc/kernel/setup_64.c b/arch/powerpc/kernel/setup_64.c
index 3b1529c..2c2d831 100644
--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -33,6 +33,7 @@
 #include <linux/serial_8250.h>
 #include <linux/bootmem.h>
 #include <linux/pci.h>
+#include <linux/lmb.h>
 #include <asm/io.h>
 #include <asm/kdump.h>
 #include <asm/prom.h>
@@ -55,7 +56,6 @@
 #include <asm/cache.h>
 #include <asm/page.h>
 #include <asm/mmu.h>
-#include <asm/lmb.h>
 #include <asm/firmware.h>
 #include <asm/xmon.h>
 #include <asm/udbg.h>
diff --git a/arch/powerpc/kernel/vdso.c b/arch/powerpc/kernel/vdso.c
index 3702df7..d715048 100644
--- a/arch/powerpc/kernel/vdso.c
+++ b/arch/powerpc/kernel/vdso.c
@@ -21,13 +21,14 @@
 #include <linux/elf.h>
 #include <linux/security.h>
 #include <linux/bootmem.h>
+#include <linux/lmb.h>
 
 #include <asm/pgtable.h>
 #include <asm/system.h>
 #include <asm/processor.h>
 #include <asm/mmu.h>
 #include <asm/mmu_context.h>
-#include <asm/lmb.h>
+#include <asm/prom.h>
 #include <asm/machdep.h>
 #include <asm/cputable.h>
 #include <asm/sections.h>
diff --git a/arch/powerpc/mm/Makefile b/arch/powerpc/mm/Makefile
index 41649a5..1c00e01 100644
--- a/arch/powerpc/mm/Makefile
+++ b/arch/powerpc/mm/Makefile
@@ -6,7 +6,7 @@ ifeq ($(CONFIG_PPC64),y)
 EXTRA_CFLAGS	+= -mno-minimal-toc
 endif
 
-obj-y				:= fault.o mem.o lmb.o \
+obj-y				:= fault.o mem.o \
 				   init_$(CONFIG_WORD_SIZE).o \
 				   pgtable_$(CONFIG_WORD_SIZE).o \
 				   mmu_context_$(CONFIG_WORD_SIZE).o
diff --git a/arch/powerpc/mm/hash_utils_64.c b/arch/powerpc/mm/hash_utils_64.c
index 32f4161..73b7848 100644
--- a/arch/powerpc/mm/hash_utils_64.c
+++ b/arch/powerpc/mm/hash_utils_64.c
@@ -31,6 +31,7 @@
 #include <linux/cache.h>
 #include <linux/init.h>
 #include <linux/signal.h>
+#include <linux/lmb.h>
 
 #include <asm/processor.h>
 #include <asm/pgtable.h>
@@ -41,7 +42,7 @@
 #include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/machdep.h>
-#include <asm/lmb.h>
+#include <asm/prom.h>
 #include <asm/abs_addr.h>
 #include <asm/tlbflush.h>
 #include <asm/io.h>
diff --git a/arch/powerpc/mm/init_32.c b/arch/powerpc/mm/init_32.c
index 977cb1e..59a725b 100644
--- a/arch/powerpc/mm/init_32.c
+++ b/arch/powerpc/mm/init_32.c
@@ -30,6 +30,7 @@
 #include <linux/highmem.h>
 #include <linux/initrd.h>
 #include <linux/pagemap.h>
+#include <linux/lmb.h>
 
 #include <asm/pgalloc.h>
 #include <asm/prom.h>
@@ -41,7 +42,6 @@
 #include <asm/machdep.h>
 #include <asm/btext.h>
 #include <asm/tlb.h>
-#include <asm/lmb.h>
 #include <asm/sections.h>
 
 #include "mmu_decl.h"
diff --git a/arch/powerpc/mm/init_64.c b/arch/powerpc/mm/init_64.c
index c0f5cff..abeb0eb 100644
--- a/arch/powerpc/mm/init_64.c
+++ b/arch/powerpc/mm/init_64.c
@@ -38,11 +38,11 @@
 #include <linux/nodemask.h>
 #include <linux/module.h>
 #include <linux/poison.h>
+#include <linux/lmb.h>
 
 #include <asm/pgalloc.h>
 #include <asm/page.h>
 #include <asm/prom.h>
-#include <asm/lmb.h>
 #include <asm/rtas.h>
 #include <asm/io.h>
 #include <asm/mmu_context.h>
diff --git a/arch/powerpc/mm/lmb.c b/arch/powerpc/mm/lmb.c
deleted file mode 100644
index 4ce23bc..0000000
--- a/arch/powerpc/mm/lmb.c
+++ /dev/null
@@ -1,357 +0,0 @@
-/*
- * Procedures for maintaining information about logical memory blocks.
- *
- * Peter Bergner, IBM Corp.	June 2001.
- * Copyright (C) 2001 Peter Bergner.
- * 
- *      This program is free software; you can redistribute it and/or
- *      modify it under the terms of the GNU General Public License
- *      as published by the Free Software Foundation; either version
- *      2 of the License, or (at your option) any later version.
- */
-
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/bitops.h>
-#include <asm/types.h>
-#include <asm/page.h>
-#include <asm/prom.h>
-#include <asm/lmb.h>
-#ifdef CONFIG_PPC32
-#include "mmu_decl.h"		/* for __max_low_memory */
-#endif
-
-#undef DEBUG
-
-#ifdef DEBUG
-#include <asm/udbg.h>
-#define DBG(fmt...) udbg_printf(fmt)
-#else
-#define DBG(fmt...)
-#endif
-
-#define LMB_ALLOC_ANYWHERE	0
-
-struct lmb lmb;
-
-void lmb_dump_all(void)
-{
-#ifdef DEBUG
-	unsigned long i;
-
-	DBG("lmb_dump_all:\n");
-	DBG("    memory.cnt		  = 0x%lx\n", lmb.memory.cnt);
-	DBG("    memory.size		  = 0x%lx\n", lmb.memory.size);
-	for (i=0; i < lmb.memory.cnt ;i++) {
-		DBG("    memory.region[0x%x].base       = 0x%lx\n",
-			    i, lmb.memory.region[i].base);
-		DBG("		      .size     = 0x%lx\n",
-			    lmb.memory.region[i].size);
-	}
-
-	DBG("\n    reserved.cnt	  = 0x%lx\n", lmb.reserved.cnt);
-	DBG("    reserved.size	  = 0x%lx\n", lmb.reserved.size);
-	for (i=0; i < lmb.reserved.cnt ;i++) {
-		DBG("    reserved.region[0x%x].base       = 0x%lx\n",
-			    i, lmb.reserved.region[i].base);
-		DBG("		      .size     = 0x%lx\n",
-			    lmb.reserved.region[i].size);
-	}
-#endif /* DEBUG */
-}
-
-static unsigned long __init lmb_addrs_overlap(unsigned long base1,
-		unsigned long size1, unsigned long base2, unsigned long size2)
-{
-	return ((base1 < (base2+size2)) && (base2 < (base1+size1)));
-}
-
-static long __init lmb_addrs_adjacent(unsigned long base1, unsigned long size1,
-		unsigned long base2, unsigned long size2)
-{
-	if (base2 == base1 + size1)
-		return 1;
-	else if (base1 == base2 + size2)
-		return -1;
-
-	return 0;
-}
-
-static long __init lmb_regions_adjacent(struct lmb_region *rgn,
-		unsigned long r1, unsigned long r2)
-{
-	unsigned long base1 = rgn->region[r1].base;
-	unsigned long size1 = rgn->region[r1].size;
-	unsigned long base2 = rgn->region[r2].base;
-	unsigned long size2 = rgn->region[r2].size;
-
-	return lmb_addrs_adjacent(base1, size1, base2, size2);
-}
-
-static void __init lmb_remove_region(struct lmb_region *rgn, unsigned long r)
-{
-	unsigned long i;
-
-	for (i = r; i < rgn->cnt - 1; i++) {
-		rgn->region[i].base = rgn->region[i + 1].base;
-		rgn->region[i].size = rgn->region[i + 1].size;
-	}
-	rgn->cnt--;
-}
-
-/* Assumption: base addr of region 1 < base addr of region 2 */
-static void __init lmb_coalesce_regions(struct lmb_region *rgn,
-		unsigned long r1, unsigned long r2)
-{
-	rgn->region[r1].size += rgn->region[r2].size;
-	lmb_remove_region(rgn, r2);
-}
-
-/* This routine called with relocation disabled. */
-void __init lmb_init(void)
-{
-	/* Create a dummy zero size LMB which will get coalesced away later.
-	 * This simplifies the lmb_add() code below...
-	 */
-	lmb.memory.region[0].base = 0;
-	lmb.memory.region[0].size = 0;
-	lmb.memory.cnt = 1;
-
-	/* Ditto. */
-	lmb.reserved.region[0].base = 0;
-	lmb.reserved.region[0].size = 0;
-	lmb.reserved.cnt = 1;
-}
-
-/* This routine may be called with relocation disabled. */
-void __init lmb_analyze(void)
-{
-	int i;
-
-	lmb.memory.size = 0;
-
-	for (i = 0; i < lmb.memory.cnt; i++)
-		lmb.memory.size += lmb.memory.region[i].size;
-}
-
-/* This routine called with relocation disabled. */
-static long __init lmb_add_region(struct lmb_region *rgn, unsigned long base,
-				  unsigned long size)
-{
-	unsigned long coalesced = 0;
-	long adjacent, i;
-
-	/* First try and coalesce this LMB with another. */
-	for (i=0; i < rgn->cnt; i++) {
-		unsigned long rgnbase = rgn->region[i].base;
-		unsigned long rgnsize = rgn->region[i].size;
-
-		if ((rgnbase == base) && (rgnsize == size))
-			/* Already have this region, so we're done */
-			return 0;
-
-		adjacent = lmb_addrs_adjacent(base,size,rgnbase,rgnsize);
-		if ( adjacent > 0 ) {
-			rgn->region[i].base -= size;
-			rgn->region[i].size += size;
-			coalesced++;
-			break;
-		}
-		else if ( adjacent < 0 ) {
-			rgn->region[i].size += size;
-			coalesced++;
-			break;
-		}
-	}
-
-	if ((i < rgn->cnt-1) && lmb_regions_adjacent(rgn, i, i+1) ) {
-		lmb_coalesce_regions(rgn, i, i+1);
-		coalesced++;
-	}
-
-	if (coalesced)
-		return coalesced;
-	if (rgn->cnt >= MAX_LMB_REGIONS)
-		return -1;
-
-	/* Couldn't coalesce the LMB, so add it to the sorted table. */
-	for (i = rgn->cnt-1; i >= 0; i--) {
-		if (base < rgn->region[i].base) {
-			rgn->region[i+1].base = rgn->region[i].base;
-			rgn->region[i+1].size = rgn->region[i].size;
-		} else {
-			rgn->region[i+1].base = base;
-			rgn->region[i+1].size = size;
-			break;
-		}
-	}
-	rgn->cnt++;
-
-	return 0;
-}
-
-/* This routine may be called with relocation disabled. */
-long __init lmb_add(unsigned long base, unsigned long size)
-{
-	struct lmb_region *_rgn = &(lmb.memory);
-
-	/* On pSeries LPAR systems, the first LMB is our RMO region. */
-	if (base == 0)
-		lmb.rmo_size = size;
-
-	return lmb_add_region(_rgn, base, size);
-
-}
-
-long __init lmb_reserve(unsigned long base, unsigned long size)
-{
-	struct lmb_region *_rgn = &(lmb.reserved);
-
-	BUG_ON(0 == size);
-
-	return lmb_add_region(_rgn, base, size);
-}
-
-long __init lmb_overlaps_region(struct lmb_region *rgn, unsigned long base,
-				unsigned long size)
-{
-	unsigned long i;
-
-	for (i=0; i < rgn->cnt; i++) {
-		unsigned long rgnbase = rgn->region[i].base;
-		unsigned long rgnsize = rgn->region[i].size;
-		if ( lmb_addrs_overlap(base,size,rgnbase,rgnsize) ) {
-			break;
-		}
-	}
-
-	return (i < rgn->cnt) ? i : -1;
-}
-
-unsigned long __init lmb_alloc(unsigned long size, unsigned long align)
-{
-	return lmb_alloc_base(size, align, LMB_ALLOC_ANYWHERE);
-}
-
-unsigned long __init lmb_alloc_base(unsigned long size, unsigned long align,
-				    unsigned long max_addr)
-{
-	unsigned long alloc;
-
-	alloc = __lmb_alloc_base(size, align, max_addr);
-
-	if (alloc == 0)
-		panic("ERROR: Failed to allocate 0x%lx bytes below 0x%lx.\n",
-				size, max_addr);
-
-	return alloc;
-}
-
-unsigned long __init __lmb_alloc_base(unsigned long size, unsigned long align,
-				    unsigned long max_addr)
-{
-	long i, j;
-	unsigned long base = 0;
-
-	BUG_ON(0 == size);
-
-#ifdef CONFIG_PPC32
-	/* On 32-bit, make sure we allocate lowmem */
-	if (max_addr == LMB_ALLOC_ANYWHERE)
-		max_addr = __max_low_memory;
-#endif
-	for (i = lmb.memory.cnt-1; i >= 0; i--) {
-		unsigned long lmbbase = lmb.memory.region[i].base;
-		unsigned long lmbsize = lmb.memory.region[i].size;
-
-		if (max_addr == LMB_ALLOC_ANYWHERE)
-			base = _ALIGN_DOWN(lmbbase + lmbsize - size, align);
-		else if (lmbbase < max_addr) {
-			base = min(lmbbase + lmbsize, max_addr);
-			base = _ALIGN_DOWN(base - size, align);
-		} else
-			continue;
-
-		while ((lmbbase <= base) &&
-		       ((j = lmb_overlaps_region(&lmb.reserved, base, size)) >= 0) )
-			base = _ALIGN_DOWN(lmb.reserved.region[j].base - size,
-					   align);
-
-		if ((base != 0) && (lmbbase <= base))
-			break;
-	}
-
-	if (i < 0)
-		return 0;
-
-	lmb_add_region(&lmb.reserved, base, size);
-
-	return base;
-}
-
-/* You must call lmb_analyze() before this. */
-unsigned long __init lmb_phys_mem_size(void)
-{
-	return lmb.memory.size;
-}
-
-unsigned long __init lmb_end_of_DRAM(void)
-{
-	int idx = lmb.memory.cnt - 1;
-
-	return (lmb.memory.region[idx].base + lmb.memory.region[idx].size);
-}
-
-/* You must call lmb_analyze() after this. */
-void __init lmb_enforce_memory_limit(unsigned long memory_limit)
-{
-	unsigned long i, limit;
-	struct lmb_property *p;
-
-	if (! memory_limit)
-		return;
-
-	/* Truncate the lmb regions to satisfy the memory limit. */
-	limit = memory_limit;
-	for (i = 0; i < lmb.memory.cnt; i++) {
-		if (limit > lmb.memory.region[i].size) {
-			limit -= lmb.memory.region[i].size;
-			continue;
-		}
-
-		lmb.memory.region[i].size = limit;
-		lmb.memory.cnt = i + 1;
-		break;
-	}
-
-	if (lmb.memory.region[0].size < lmb.rmo_size)
-		lmb.rmo_size = lmb.memory.region[0].size;
-
-	/* And truncate any reserves above the limit also. */
-	for (i = 0; i < lmb.reserved.cnt; i++) {
-		p = &lmb.reserved.region[i];
-
-		if (p->base > memory_limit)
-			p->size = 0;
-		else if ((p->base + p->size) > memory_limit)
-			p->size = memory_limit - p->base;
-
-		if (p->size == 0) {
-			lmb_remove_region(&lmb.reserved, i);
-			i--;
-		}
-	}
-}
-
-int __init lmb_is_reserved(unsigned long addr)
-{
-	int i;
-
-	for (i = 0; i < lmb.reserved.cnt; i++) {
-		unsigned long upper = lmb.reserved.region[i].base +
-				      lmb.reserved.region[i].size - 1;
-		if ((addr >= lmb.reserved.region[i].base) && (addr <= upper))
-			return 1;
-	}
-	return 0;
-}
diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
index be5c506..60c019c 100644
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -31,6 +31,7 @@
 #include <linux/initrd.h>
 #include <linux/pagemap.h>
 #include <linux/suspend.h>
+#include <linux/lmb.h>
 
 #include <asm/pgalloc.h>
 #include <asm/prom.h>
@@ -42,7 +43,6 @@
 #include <asm/machdep.h>
 #include <asm/btext.h>
 #include <asm/tlb.h>
-#include <asm/lmb.h>
 #include <asm/sections.h>
 #include <asm/vdso.h>
 
diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
index a300d25..1efd631 100644
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -17,8 +17,9 @@
 #include <linux/nodemask.h>
 #include <linux/cpu.h>
 #include <linux/notifier.h>
+#include <linux/lmb.h>
 #include <asm/sparsemem.h>
-#include <asm/lmb.h>
+#include <asm/prom.h>
 #include <asm/system.h>
 #include <asm/smp.h>
 
diff --git a/arch/powerpc/mm/ppc_mmu_32.c b/arch/powerpc/mm/ppc_mmu_32.c
index 5c45d47..72de3c7 100644
--- a/arch/powerpc/mm/ppc_mmu_32.c
+++ b/arch/powerpc/mm/ppc_mmu_32.c
@@ -26,11 +26,11 @@
 #include <linux/mm.h>
 #include <linux/init.h>
 #include <linux/highmem.h>
+#include <linux/lmb.h>
 
 #include <asm/prom.h>
 #include <asm/mmu.h>
 #include <asm/machdep.h>
-#include <asm/lmb.h>
 
 #include "mmu_decl.h"
 
diff --git a/arch/powerpc/mm/stab.c b/arch/powerpc/mm/stab.c
index 50448d5..efbbd13 100644
--- a/arch/powerpc/mm/stab.c
+++ b/arch/powerpc/mm/stab.c
@@ -12,12 +12,14 @@
  *      2 of the License, or (at your option) any later version.
  */
 
+#include <linux/lmb.h>
+
 #include <asm/pgtable.h>
 #include <asm/mmu.h>
 #include <asm/mmu_context.h>
 #include <asm/paca.h>
 #include <asm/cputable.h>
-#include <asm/lmb.h>
+#include <asm/prom.h>
 #include <asm/abs_addr.h>
 #include <asm/firmware.h>
 #include <asm/iseries/hv_call.h>
diff --git a/arch/powerpc/platforms/cell/iommu.c b/arch/powerpc/platforms/cell/iommu.c
index edab631..6138158 100644
--- a/arch/powerpc/platforms/cell/iommu.c
+++ b/arch/powerpc/platforms/cell/iommu.c
@@ -28,13 +28,13 @@
 #include <linux/notifier.h>
 #include <linux/of.h>
 #include <linux/of_platform.h>
+#include <linux/lmb.h>
 
 #include <asm/prom.h>
 #include <asm/iommu.h>
 #include <asm/machdep.h>
 #include <asm/pci-bridge.h>
 #include <asm/udbg.h>
-#include <asm/lmb.h>
 #include <asm/firmware.h>
 #include <asm/cell-regs.h>
 
diff --git a/arch/powerpc/platforms/maple/setup.c b/arch/powerpc/platforms/maple/setup.c
index 3ce2d73..dadf33b 100644
--- a/arch/powerpc/platforms/maple/setup.c
+++ b/arch/powerpc/platforms/maple/setup.c
@@ -43,6 +43,7 @@
 #include <linux/smp.h>
 #include <linux/bitops.h>
 #include <linux/of_device.h>
+#include <linux/lmb.h>
 
 #include <asm/processor.h>
 #include <asm/sections.h>
@@ -57,7 +58,6 @@
 #include <asm/dma.h>
 #include <asm/cputable.h>
 #include <asm/time.h>
-#include <asm/lmb.h>
 #include <asm/mpic.h>
 #include <asm/rtas.h>
 #include <asm/udbg.h>
diff --git a/arch/powerpc/platforms/powermac/setup.c b/arch/powerpc/platforms/powermac/setup.c
index 36ff1b6..59404ba 100644
--- a/arch/powerpc/platforms/powermac/setup.c
+++ b/arch/powerpc/platforms/powermac/setup.c
@@ -53,6 +53,7 @@
 #include <linux/suspend.h>
 #include <linux/of_device.h>
 #include <linux/of_platform.h>
+#include <linux/lmb.h>
 
 #include <asm/reg.h>
 #include <asm/sections.h>
@@ -74,7 +75,6 @@
 #include <asm/iommu.h>
 #include <asm/smu.h>
 #include <asm/pmc.h>
-#include <asm/lmb.h>
 #include <asm/udbg.h>
 
 #include "pmac.h"
diff --git a/arch/powerpc/platforms/ps3/htab.c b/arch/powerpc/platforms/ps3/htab.c
index 7382f19..1cf901f 100644
--- a/arch/powerpc/platforms/ps3/htab.c
+++ b/arch/powerpc/platforms/ps3/htab.c
@@ -19,9 +19,10 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/lmb.h>
 
 #include <asm/machdep.h>
-#include <asm/lmb.h>
+#include <asm/prom.h>
 #include <asm/udbg.h>
 #include <asm/lv1call.h>
 #include <asm/ps3fb.h>
diff --git a/arch/powerpc/platforms/ps3/mm.c b/arch/powerpc/platforms/ps3/mm.c
index 6890047..5b3fb2b 100644
--- a/arch/powerpc/platforms/ps3/mm.c
+++ b/arch/powerpc/platforms/ps3/mm.c
@@ -21,9 +21,10 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/memory_hotplug.h>
+#include <linux/lmb.h>
 
 #include <asm/firmware.h>
-#include <asm/lmb.h>
+#include <asm/prom.h>
 #include <asm/udbg.h>
 #include <asm/lv1call.h>
 
diff --git a/arch/powerpc/platforms/ps3/os-area.c b/arch/powerpc/platforms/ps3/os-area.c
index b9ea09d..c73379e 100644
--- a/arch/powerpc/platforms/ps3/os-area.c
+++ b/arch/powerpc/platforms/ps3/os-area.c
@@ -24,8 +24,9 @@
 #include <linux/fs.h>
 #include <linux/syscalls.h>
 #include <linux/ctype.h>
+#include <linux/lmb.h>
 
-#include <asm/lmb.h>
+#include <asm/prom.h>
 
 #include "platform.h"
 
diff --git a/arch/powerpc/sysdev/dart_iommu.c b/arch/powerpc/sysdev/dart_iommu.c
index e0e24b0..005c2ec 100644
--- a/arch/powerpc/sysdev/dart_iommu.c
+++ b/arch/powerpc/sysdev/dart_iommu.c
@@ -37,6 +37,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/vmalloc.h>
 #include <linux/suspend.h>
+#include <linux/lmb.h>
 #include <asm/io.h>
 #include <asm/prom.h>
 #include <asm/iommu.h>
@@ -44,7 +45,6 @@
 #include <asm/machdep.h>
 #include <asm/abs_addr.h>
 #include <asm/cacheflush.h>
-#include <asm/lmb.h>
 #include <asm/ppc-pci.h>
 
 #include "dart.h"
diff --git a/arch/sparc64/Kconfig b/arch/sparc64/Kconfig
index 3af378d..b18d24d 100644
--- a/arch/sparc64/Kconfig
+++ b/arch/sparc64/Kconfig
@@ -15,6 +15,7 @@ config SPARC64
 	bool
 	default y
 	select HAVE_IDE
+	select HAVE_LMB
 	help
 	  SPARC is a family of RISC microprocessors designed and marketed by
 	  Sun Microsystems, incorporated.  This port covers the newer 64-bit
diff --git a/include/asm-powerpc/abs_addr.h b/include/asm-powerpc/abs_addr.h
index 4aa2207..98324c5 100644
--- a/include/asm-powerpc/abs_addr.h
+++ b/include/asm-powerpc/abs_addr.h
@@ -12,10 +12,11 @@
  * 2 of the License, or (at your option) any later version.
  */
 
+#include <linux/lmb.h>
+
 #include <asm/types.h>
 #include <asm/page.h>
 #include <asm/prom.h>
-#include <asm/lmb.h>
 #include <asm/firmware.h>
 
 struct mschunks_map {
diff --git a/include/asm-powerpc/lmb.h b/include/asm-powerpc/lmb.h
index 5d1dc48..028184b 100644
--- a/include/asm-powerpc/lmb.h
+++ b/include/asm-powerpc/lmb.h
@@ -1,81 +1,15 @@
 #ifndef _ASM_POWERPC_LMB_H
 #define _ASM_POWERPC_LMB_H
-#ifdef __KERNEL__
 
-/*
- * Definitions for talking to the Open Firmware PROM on
- * Power Macintosh computers.
- *
- * Copyright (C) 2001 Peter Bergner, IBM Corp.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
+#include <asm/udbg.h>
 
-#include <linux/init.h>
-#include <asm/prom.h>
+#define LMB_DBG(fmt...) udbg_printf(fmt)
 
-#define MAX_LMB_REGIONS 128
+#ifdef CONFIG_PPC32
+extern unsigned long __max_low_memory;
+#define LMB_REAL_LIMIT	__max_low_memory
+#else
+#define LMB_REAL_LIMIT	0
+#endif
 
-struct lmb_property {
-	unsigned long base;
-	unsigned long size;
-};
-
-struct lmb_region {
-	unsigned long cnt;
-	unsigned long size;
-	struct lmb_property region[MAX_LMB_REGIONS+1];
-};
-
-struct lmb {
-	unsigned long debug;
-	unsigned long rmo_size;
-	struct lmb_region memory;
-	struct lmb_region reserved;
-};
-
-extern struct lmb lmb;
-
-extern void __init lmb_init(void);
-extern void __init lmb_analyze(void);
-extern long __init lmb_add(unsigned long base, unsigned long size);
-extern long __init lmb_reserve(unsigned long base, unsigned long size);
-extern unsigned long __init lmb_alloc(unsigned long size, unsigned long align);
-extern unsigned long __init lmb_alloc_base(unsigned long size,
-		unsigned long align, unsigned long max_addr);
-extern unsigned long __init __lmb_alloc_base(unsigned long size,
-		unsigned long align, unsigned long max_addr);
-extern unsigned long __init lmb_phys_mem_size(void);
-extern unsigned long __init lmb_end_of_DRAM(void);
-extern void __init lmb_enforce_memory_limit(unsigned long memory_limit);
-extern int __init lmb_is_reserved(unsigned long addr);
-
-extern void lmb_dump_all(void);
-
-static inline unsigned long
-lmb_size_bytes(struct lmb_region *type, unsigned long region_nr)
-{
-	return type->region[region_nr].size;
-}
-static inline unsigned long
-lmb_size_pages(struct lmb_region *type, unsigned long region_nr)
-{
-	return lmb_size_bytes(type, region_nr) >> PAGE_SHIFT;
-}
-static inline unsigned long
-lmb_start_pfn(struct lmb_region *type, unsigned long region_nr)
-{
-	return type->region[region_nr].base >> PAGE_SHIFT;
-}
-static inline unsigned long
-lmb_end_pfn(struct lmb_region *type, unsigned long region_nr)
-{
-	return lmb_start_pfn(type, region_nr) +
-	       lmb_size_pages(type, region_nr);
-}
-
-#endif /* __KERNEL__ */
 #endif /* _ASM_POWERPC_LMB_H */
diff --git a/include/asm-sparc64/lmb.h b/include/asm-sparc64/lmb.h
new file mode 100644
index 0000000..6a352cb
--- /dev/null
+++ b/include/asm-sparc64/lmb.h
@@ -0,0 +1,10 @@
+#ifndef _SPARC64_LMB_H
+#define _SPARC64_LMB_H
+
+#include <asm/oplib.h>
+
+#define LMB_DBG(fmt...) prom_printf(fmt)
+
+#define LMB_REAL_LIMIT	0
+
+#endif /* !(_SPARC64_LMB_H) */
diff --git a/include/linux/lmb.h b/include/linux/lmb.h
new file mode 100644
index 0000000..8b93f63
--- /dev/null
+++ b/include/linux/lmb.h
@@ -0,0 +1,83 @@
+#ifndef _LINUX_LMB_H
+#define _LINUX_LMB_H
+#ifdef __KERNEL__
+
+/*
+ * Logical memory blocks.
+ *
+ * Copyright (C) 2001 Peter Bergner, IBM Corp.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/init.h>
+#include <linux/mm.h>
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
+extern int __init lmb_is_reserved(unsigned long addr);
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
+	       lmb_size_pages(type, region_nr);
+}
+
+#include <asm/lmb.h>
+
+#endif /* __KERNEL__ */
+
+#endif /* _LINUX_LMB_H */
diff --git a/lib/Kconfig b/lib/Kconfig
index ba3d104..2d53dc0 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -141,4 +141,7 @@ config HAS_DMA
 config CHECK_SIGNATURE
 	bool
 
+config HAVE_LMB
+	boolean
+
 endmenu
diff --git a/lib/Makefile b/lib/Makefile
index 23de261..61bba16 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -70,6 +70,8 @@ obj-$(CONFIG_FAULT_INJECTION) += fault-inject.o
 
 lib-$(CONFIG_GENERIC_BUG) += bug.o
 
+obj-$(CONFIG_HAVE_LMB) += lmb.o
+
 hostprogs-y	:= gen_crc32table
 clean-files	:= crc32table.h
 
diff --git a/lib/lmb.c b/lib/lmb.c
new file mode 100644
index 0000000..98078b4
--- /dev/null
+++ b/lib/lmb.c
@@ -0,0 +1,354 @@
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
+#include <linux/lmb.h>
+
+#undef DEBUG
+
+#ifdef DEBUG
+#define DBG(fmt...) LMB_DBG(fmt)
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
+	unsigned long i;
+
+	DBG("lmb_dump_all:\n");
+	DBG("    memory.cnt		  = 0x%lx\n", lmb.memory.cnt);
+	DBG("    memory.size		  = 0x%lx\n", lmb.memory.size);
+	for (i=0; i < lmb.memory.cnt ;i++) {
+		DBG("    memory.region[0x%x].base       = 0x%lx\n",
+			    i, lmb.memory.region[i].base);
+		DBG("		      .size     = 0x%lx\n",
+			    lmb.memory.region[i].size);
+	}
+
+	DBG("\n    reserved.cnt	  = 0x%lx\n", lmb.reserved.cnt);
+	DBG("    reserved.size	  = 0x%lx\n", lmb.reserved.size);
+	for (i=0; i < lmb.reserved.cnt ;i++) {
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
+	unsigned long coalesced = 0;
+	long adjacent, i;
+
+	/* First try and coalesce this LMB with another. */
+	for (i=0; i < rgn->cnt; i++) {
+		unsigned long rgnbase = rgn->region[i].base;
+		unsigned long rgnsize = rgn->region[i].size;
+
+		if ((rgnbase == base) && (rgnsize == size))
+			/* Already have this region, so we're done */
+			return 0;
+
+		adjacent = lmb_addrs_adjacent(base,size,rgnbase,rgnsize);
+		if ( adjacent > 0 ) {
+			rgn->region[i].base -= size;
+			rgn->region[i].size += size;
+			coalesced++;
+			break;
+		}
+		else if ( adjacent < 0 ) {
+			rgn->region[i].size += size;
+			coalesced++;
+			break;
+		}
+	}
+
+	if ((i < rgn->cnt-1) && lmb_regions_adjacent(rgn, i, i+1) ) {
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
+	for (i=0; i < rgn->cnt; i++) {
+		unsigned long rgnbase = rgn->region[i].base;
+		unsigned long rgnsize = rgn->region[i].size;
+		if ( lmb_addrs_overlap(base,size,rgnbase,rgnsize) ) {
+			break;
+		}
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
+static unsigned long lmb_align_down(unsigned long addr, unsigned long size)
+{
+	return addr & ~(size - 1);
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
+	/* On some platforms, make sure we allocate lowmem */
+	if (max_addr == LMB_ALLOC_ANYWHERE)
+		max_addr = LMB_REAL_LIMIT;
+
+	for (i = lmb.memory.cnt-1; i >= 0; i--) {
+		unsigned long lmbbase = lmb.memory.region[i].base;
+		unsigned long lmbsize = lmb.memory.region[i].size;
+
+		if (max_addr == LMB_ALLOC_ANYWHERE)
+			base = lmb_align_down(lmbbase + lmbsize - size, align);
+		else if (lmbbase < max_addr) {
+			base = min(lmbbase + lmbsize, max_addr);
+			base = lmb_align_down(base - size, align);
+		} else
+			continue;
+
+		while ((lmbbase <= base) &&
+		       ((j = lmb_overlaps_region(&lmb.reserved, base, size)) >= 0) )
+			base = lmb_align_down(lmb.reserved.region[j].base - size,
+					      align);
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
+	if (! memory_limit)
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
+
+int __init lmb_is_reserved(unsigned long addr)
+{
+	int i;
+
+	for (i = 0; i < lmb.reserved.cnt; i++) {
+		unsigned long upper = lmb.reserved.region[i].base +
+				      lmb.reserved.region[i].size - 1;
+		if ((addr >= lmb.reserved.region[i].base) && (addr <= upper))
+			return 1;
+	}
+	return 0;
+}
-- 
1.5.4.29.gb828fe

