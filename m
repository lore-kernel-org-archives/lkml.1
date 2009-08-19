Return-Path: <linux-kernel-owner+w=401wt.eu-S1751492AbZHSRAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492AbZHSRAI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 13:00:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751178AbZHSRAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 13:00:07 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:54990 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbZHSRAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 13:00:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-disposition
         :content-type:content-transfer-encoding:message-id;
        b=j4eR3J4T3jZqyyusbGhiPL2uWYJnPQ3LDfiGmbHcnR+QTXeoh8P8tMmf1+9f9lbauz
         ST675+nbWcgnlw3/nsKGT4SeiQzceYydnnPODy+7Ih9IrEfiQQ19+CTIqNGj0YXUGXC/
         th8l9g8hv1uQ1/n5chIiMGGOKUbKlWmwrqXwM=
From: Miguel Boton <waninkoko@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Define alignment macros in "align.h" header
Date: Wed, 19 Aug 2009 18:59:57 +0000
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc6-zen0; KDE/4.2.4; i686; ; )
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200908191859.57605.mboton@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are many alignment macros defined along the kernel. These macros
should be declared once to remove redundant code.

We need a separate header to accomplish this instead of defining them
in "kernel.h" to avoid multiple definitions of "ALIGN" or circular
dependencies.

Signed-off-by: Miguel Boton <mboton@gmail.com>
---
 arch/microblaze/include/asm/page.h           |    7 ----
 arch/powerpc/include/asm/iommu.h             |    3 +-
 arch/powerpc/include/asm/page.h              |    8 +----
 arch/powerpc/include/asm/processor.h         |    3 +-
 arch/powerpc/kernel/head_booke.h             |    2 +-
 arch/powerpc/kernel/irq.c                    |    4 +-
 arch/powerpc/kernel/pci_64.c                 |    4 +-
 arch/powerpc/kernel/process.c                |    2 +-
 arch/powerpc/kernel/prom.c                   |   20 ++++++------
 arch/powerpc/kernel/prom_init.c              |   24 +++++++-------
 arch/powerpc/mm/slice.c                      |   16 +++++-----
 arch/powerpc/mm/tlb_hash64.c                 |    4 +-
 arch/powerpc/platforms/cell/iommu.c          |    6 ++--
 arch/powerpc/platforms/powermac/bootx_init.c |   14 ++++----
 arch/powerpc/platforms/ps3/mm.c              |   44 
+++++++++++++-------------
 arch/powerpc/platforms/ps3/setup.c           |    4 +-
 drivers/ps3/ps3-lpm.c                        |    6 ++--
 drivers/video/ps3fb.c                        |    4 +-
 include/linux/align.h                        |   17 ++++++++++
 include/linux/kernel.h                       |    6 +---
 sound/ppc/snd_ps3.c                          |    2 +-
 21 files changed, 101 insertions(+), 99 deletions(-)

diff --git a/arch/microblaze/include/asm/page.h 
b/arch/microblaze/include/asm/page.h
index 72aceae..cc7cc85 100644
--- a/arch/microblaze/include/asm/page.h
+++ b/arch/microblaze/include/asm/page.h
@@ -31,13 +31,6 @@
 #define PAGE_UP(addr)	(((addr)+((PAGE_SIZE)-1))&(~((PAGE_SIZE)-1)))
 #define PAGE_DOWN(addr)	((addr)&(~((PAGE_SIZE)-1)))
 
-/* align addr on a size boundary - adjust address up/down if needed */
-#define _ALIGN_UP(addr, size)	(((addr)+((size)-1))&(~((size)-1)))
-#define _ALIGN_DOWN(addr, size)	((addr)&(~((size)-1)))
-
-/* align addr on a size boundary - adjust address up if needed */
-#define _ALIGN(addr, size)	_ALIGN_UP(addr, size)
-
 #ifndef CONFIG_MMU
 /*
  * PAGE_OFFSET -- the first address of the first page of memory. When not
diff --git a/arch/powerpc/include/asm/iommu.h 
b/arch/powerpc/include/asm/iommu.h
index 7ead7c1..7b3be37 100644
--- a/arch/powerpc/include/asm/iommu.h
+++ b/arch/powerpc/include/asm/iommu.h
@@ -22,6 +22,7 @@
 #define _ASM_IOMMU_H
 #ifdef __KERNEL__
 
+#include <linux/align.h>
 #include <linux/compiler.h>
 #include <linux/spinlock.h>
 #include <linux/device.h>
@@ -33,7 +34,7 @@
 #define IOMMU_PAGE_SHIFT      12
 #define IOMMU_PAGE_SIZE       (ASM_CONST(1) << IOMMU_PAGE_SHIFT)
 #define IOMMU_PAGE_MASK       (~((1 << IOMMU_PAGE_SHIFT) - 1))
-#define IOMMU_PAGE_ALIGN(addr) _ALIGN_UP(addr, IOMMU_PAGE_SIZE)
+#define IOMMU_PAGE_ALIGN(addr) ALIGN_UP(addr, IOMMU_PAGE_SIZE)
 
 /* Cell page table entries */
 #define CBE_IOPTE_PP_W		0x8000000000000000ul /* protection: write */
diff --git a/arch/powerpc/include/asm/page.h b/arch/powerpc/include/asm/page.h
index 4940662..0d4c72a 100644
--- a/arch/powerpc/include/asm/page.h
+++ b/arch/powerpc/include/asm/page.h
@@ -15,6 +15,7 @@
 #else
 #include <asm/types.h>
 #endif
+#include <linux/align.h>
 #include <asm/asm-compat.h>
 #include <asm/kdump.h>
 
@@ -128,13 +129,6 @@ extern phys_addr_t kernstart_addr;
 #include <asm/page_32.h>
 #endif
 
-/* align addr on a size boundary - adjust address up/down if needed */
-#define _ALIGN_UP(addr,size)	(((addr)+((size)-1))&(~((size)-1)))
-#define _ALIGN_DOWN(addr,size)	((addr)&(~((size)-1)))
-
-/* align addr on a size boundary - adjust address up if needed */
-#define _ALIGN(addr,size)     _ALIGN_UP(addr,size)
-
 /*
  * Don't compare things with KERNELBASE or PAGE_OFFSET to test for
  * "kernelness", use is_kernel_addr() - it should do what you want.
diff --git a/arch/powerpc/include/asm/processor.h 
b/arch/powerpc/include/asm/processor.h
index 9eed29e..2651995 100644
--- a/arch/powerpc/include/asm/processor.h
+++ b/arch/powerpc/include/asm/processor.h
@@ -10,6 +10,7 @@
  * 2 of the License, or (at your option) any later version.
  */
 
+#include <linux/align.h>
 #include <asm/reg.h>
 
 #ifdef CONFIG_VSX
@@ -203,7 +204,7 @@ struct thread_struct {
 
 #define INIT_SP		(sizeof(init_stack) + (unsigned long) &init_stack)
 #define INIT_SP_LIMIT \
-	(_ALIGN_UP(sizeof(init_thread_info), 16) + (unsigned long) &init_stack)
+	(ALIGN_UP(sizeof(init_thread_info), 16) + (unsigned long) &init_stack)
 
 #ifdef CONFIG_SPE
 #define SPEFSCR_INIT .spefscr = SPEFSCR_FINVE | SPEFSCR_FDBZE | SPEFSCR_FUNFE 
| SPEFSCR_FOVFE,
diff --git a/arch/powerpc/kernel/head_booke.h 
b/arch/powerpc/kernel/head_booke.h
index 5f9febc..524d77d 100644
--- a/arch/powerpc/kernel/head_booke.h
+++ b/arch/powerpc/kernel/head_booke.h
@@ -417,7 +417,7 @@ struct exception_regs {
 };
 
 /* ensure this structure is always sized to a multiple of the stack alignment 
*/
-#define STACK_EXC_LVL_FRAME_SIZE	_ALIGN_UP(sizeof (struct exception_regs), 16)
+#define STACK_EXC_LVL_FRAME_SIZE	ALIGN_UP(sizeof (struct exception_regs), 16)
 
 #endif /* __ASSEMBLY__ */
 #endif /* __HEAD_BOOKE_H__ */
diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index f7f376e..a1ab0cf 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -285,7 +285,7 @@ static inline void handle_one_irq(unsigned int irq)
 			       (curtp->preempt_count & SOFTIRQ_MASK);
 
 	current->thread.ksp_limit = (unsigned long)irqtp +
-		_ALIGN_UP(sizeof(struct thread_info), 16);
+		ALIGN_UP(sizeof(struct thread_info), 16);
 
 	call_handle_irq(irq, desc, irqtp, desc->handle_irq);
 	current->thread.ksp_limit = saved_sp_limit;
@@ -422,7 +422,7 @@ static inline void do_softirq_onstack(void)
 	irqtp = softirq_ctx[smp_processor_id()];
 	irqtp->task = curtp->task;
 	current->thread.ksp_limit = (unsigned long)irqtp +
-				    _ALIGN_UP(sizeof(struct thread_info), 16);
+				    ALIGN_UP(sizeof(struct thread_info), 16);
 	call_do_softirq(irqtp);
 	current->thread.ksp_limit = saved_sp_limit;
 	irqtp->task = NULL;
diff --git a/arch/powerpc/kernel/pci_64.c b/arch/powerpc/kernel/pci_64.c
index 9e8902f..c885ab2 100644
--- a/arch/powerpc/kernel/pci_64.c
+++ b/arch/powerpc/kernel/pci_64.c
@@ -480,8 +480,8 @@ int __devinit pcibios_map_io_space(struct pci_bus *bus)
 
 	/* Get the host bridge */
 	hose = pci_bus_to_host(bus);
-	phys_page = _ALIGN_DOWN(hose->io_base_phys, PAGE_SIZE);
-	size_page = _ALIGN_UP(hose->pci_io_size, PAGE_SIZE);
+	phys_page = ALIGN_DOWN(hose->io_base_phys, PAGE_SIZE);
+	size_page = ALIGN_UP(hose->pci_io_size, PAGE_SIZE);
 
 	/* Make sure IO area address is clear */
 	hose->io_base_alloc = NULL;
diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index 892a9f2..92a5ab5 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -648,7 +648,7 @@ int copy_thread(unsigned long clone_flags, unsigned long 
usp,
 	sp -= STACK_FRAME_OVERHEAD;
 	p->thread.ksp = sp;
 	p->thread.ksp_limit = (unsigned long)task_stack_page(p) +
-				_ALIGN_UP(sizeof(struct thread_info), 16);
+				ALIGN_UP(sizeof(struct thread_info), 16);
 
 #ifdef CONFIG_PPC_STD_MMU_64
 	if (cpu_has_feature(CPU_FTR_SLB)) {
diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
index d4405b9..57ee22d 100644
--- a/arch/powerpc/kernel/prom.c
+++ b/arch/powerpc/kernel/prom.c
@@ -124,9 +124,9 @@ int __init of_scan_flat_dt(int (*it)(unsigned long node,
 			u32 sz = *((u32 *)p);
 			p += 8;
 			if (initial_boot_params->version < 0x10)
-				p = _ALIGN(p, sz >= 8 ? 8 : 4);
+				p = ALIGN(p, sz >= 8 ? 8 : 4);
 			p += sz;
-			p = _ALIGN(p, 4);
+			p = ALIGN(p, 4);
 			continue;
 		}
 		if (tag != OF_DT_BEGIN_NODE) {
@@ -136,7 +136,7 @@ int __init of_scan_flat_dt(int (*it)(unsigned long node,
 		}
 		depth++;
 		pathp = (char *)p;
-		p = _ALIGN(p + strlen(pathp) + 1, 4);
+		p = ALIGN(p + strlen(pathp) + 1, 4);
 		if ((*pathp) == '/') {
 			char *lp, *np;
 			for (lp = NULL, np = pathp; *np; np++)
@@ -162,7 +162,7 @@ unsigned long __init of_get_flat_dt_root(void)
 		p += 4;
 	BUG_ON (*((u32 *)p) != OF_DT_BEGIN_NODE);
 	p += 4;
-	return _ALIGN(p + strlen((char *)p) + 1, 4);
+	return ALIGN(p + strlen((char *)p) + 1, 4);
 }
 
 /**
@@ -189,7 +189,7 @@ void* __init of_get_flat_dt_prop(unsigned long node, const 
char *name,
 		noff = *((u32 *)(p + 4));
 		p += 8;
 		if (initial_boot_params->version < 0x10)
-			p = _ALIGN(p, sz >= 8 ? 8 : 4);
+			p = ALIGN(p, sz >= 8 ? 8 : 4);
 
 		nstr = find_flat_dt_string(noff);
 		if (nstr == NULL) {
@@ -203,7 +203,7 @@ void* __init of_get_flat_dt_prop(unsigned long node, const 
char *name,
 			return (void *)p;
 		}
 		p += sz;
-		p = _ALIGN(p, 4);
+		p = ALIGN(p, 4);
 	} while(1);
 }
 
@@ -231,7 +231,7 @@ static void *__init unflatten_dt_alloc(unsigned long *mem, 
unsigned long size,
 {
 	void *res;
 
-	*mem = _ALIGN(*mem, align);
+	*mem = ALIGN(*mem, align);
 	res = (void *)*mem;
 	*mem += size;
 
@@ -260,7 +260,7 @@ static unsigned long __init unflatten_dt_node(unsigned long 
mem,
 	*p += 4;
 	pathp = (char *)*p;
 	l = allocl = strlen(pathp) + 1;
-	*p = _ALIGN(*p + l, 4);
+	*p = ALIGN(*p + l, 4);
 
 	/* version 0x10 has a more compact unit name here instead of the full
 	 * path. we accumulate the full path size using "fpsize", we'll rebuild
@@ -339,7 +339,7 @@ static unsigned long __init unflatten_dt_node(unsigned long 
mem,
 		noff = *((u32 *)((*p) + 4));
 		*p += 8;
 		if (initial_boot_params->version < 0x10)
-			*p = _ALIGN(*p, sz >= 8 ? 8 : 4);
+			*p = ALIGN(*p, sz >= 8 ? 8 : 4);
 
 		pname = find_flat_dt_string(noff);
 		if (pname == NULL) {
@@ -365,7 +365,7 @@ static unsigned long __init unflatten_dt_node(unsigned long 
mem,
 			*prev_pp = pp;
 			prev_pp = &pp->next;
 		}
-		*p = _ALIGN((*p) + sz, 4);
+		*p = ALIGN((*p) + sz, 4);
 	}
 	/* with version 0x10 we may not have the name property, recreate
 	 * it here from the unit name if absent
diff --git a/arch/powerpc/kernel/prom_init.c b/arch/powerpc/kernel/prom_init.c
index a538824..a599e52 100644
--- a/arch/powerpc/kernel/prom_init.c
+++ b/arch/powerpc/kernel/prom_init.c
@@ -796,18 +796,18 @@ static unsigned long __init alloc_up(unsigned long size, 
unsigned long align)
 	unsigned long addr = 0;
 
 	if (align)
-		base = _ALIGN_UP(base, align);
+		base = ALIGN_UP(base, align);
 	prom_debug("alloc_up(%x, %x)\n", size, align);
 	if (RELOC(ram_top) == 0)
 		prom_panic("alloc_up() called with mem not initialized\n");
 
 	if (align)
-		base = _ALIGN_UP(RELOC(alloc_bottom), align);
+		base = ALIGN_UP(RELOC(alloc_bottom), align);
 	else
 		base = RELOC(alloc_bottom);
 
 	for(; (base + size) <= RELOC(alloc_top); 
-	    base = _ALIGN_UP(base + 0x100000, align)) {
+	    base = ALIGN_UP(base + 0x100000, align)) {
 		prom_debug("    trying: 0x%x\n\r", base);
 		addr = (unsigned long)prom_claim(base, size, 0);
 		if (addr != PROM_ERROR && addr != 0)
@@ -847,7 +847,7 @@ static unsigned long __init alloc_down(unsigned long size, 
unsigned long align,
 
 	if (highmem) {
 		/* Carve out storage for the TCE table. */
-		addr = _ALIGN_DOWN(RELOC(alloc_top_high) - size, align);
+		addr = ALIGN_DOWN(RELOC(alloc_top_high) - size, align);
 		if (addr <= RELOC(alloc_bottom))
 			return 0;
 		/* Will we bump into the RMO ? If yes, check out that we
@@ -865,9 +865,9 @@ static unsigned long __init alloc_down(unsigned long size, 
unsigned long align,
 		goto bail;
 	}
 
-	base = _ALIGN_DOWN(RELOC(alloc_top) - size, align);
+	base = ALIGN_DOWN(RELOC(alloc_top) - size, align);
 	for (; base > RELOC(alloc_bottom);
-	     base = _ALIGN_DOWN(base - 0x100000, align))  {
+	     base = ALIGN_DOWN(base - 0x100000, align))  {
 		prom_debug("    trying: 0x%x\n\r", base);
 		addr = (unsigned long)prom_claim(base, size, 0);
 		if (addr != PROM_ERROR && addr != 0)
@@ -933,8 +933,8 @@ static void __init reserve_mem(u64 base, u64 size)
 	 * have our terminator with "size" set to 0 since we are
 	 * dumb and just copy this entire array to the boot params
 	 */
-	base = _ALIGN_DOWN(base, PAGE_SIZE);
-	top = _ALIGN_UP(top, PAGE_SIZE);
+	base = ALIGN_DOWN(base, PAGE_SIZE);
+	top = ALIGN_UP(top, PAGE_SIZE);
 	size = top - base;
 
 	if (cnt >= (MEM_RESERVE_MAP_SIZE - 1))
@@ -1598,7 +1598,7 @@ static void __init *make_room(unsigned long *mem_start, 
unsigned long *mem_end,
 {
 	void *ret;
 
-	*mem_start = _ALIGN(*mem_start, align);
+	*mem_start = ALIGN(*mem_start, align);
 	while ((*mem_start + needed) > *mem_end) {
 		unsigned long room, chunk;
 
@@ -1730,7 +1730,7 @@ static void __init scan_dt_build_struct(phandle node, 
unsigned long *mem_start,
 				*lp++ = *p;
 		}
 		*lp = 0;
-		*mem_start = _ALIGN((unsigned long)lp + 1, 4);
+		*mem_start = ALIGN((unsigned long)lp + 1, 4);
 	}
 
 	/* get it again for debugging */
@@ -1783,7 +1783,7 @@ static void __init scan_dt_build_struct(phandle node, 
unsigned long *mem_start,
 		/* push property content */
 		valp = make_room(mem_start, mem_end, l, 4);
 		call_prom("getprop", 4, 1, node, RELOC(pname), valp, l);
-		*mem_start = _ALIGN(*mem_start, 4);
+		*mem_start = ALIGN(*mem_start, 4);
 	}
 
 	/* Add a "linux,phandle" property. */
@@ -1839,7 +1839,7 @@ static void __init flatten_device_tree(void)
 		prom_panic ("couldn't get device tree root\n");
 
 	/* Build header and make room for mem rsv map */ 
-	mem_start = _ALIGN(mem_start, 4);
+	mem_start = ALIGN(mem_start, 4);
 	hdr = make_room(&mem_start, &mem_end,
 			sizeof(struct boot_param_header), 4);
 	RELOC(dt_header_start) = (unsigned long)hdr;
diff --git a/arch/powerpc/mm/slice.c b/arch/powerpc/mm/slice.c
index ba51948..7ca8353 100644
--- a/arch/powerpc/mm/slice.c
+++ b/arch/powerpc/mm/slice.c
@@ -242,7 +242,7 @@ static unsigned long slice_find_area_bottomup(struct 
mm_struct *mm,
 
 full_search:
 	for (;;) {
-		addr = _ALIGN_UP(addr, 1ul << pshift);
+		addr = ALIGN_UP(addr, 1ul << pshift);
 		if ((TASK_SIZE - len) < addr)
 			break;
 		vma = find_vma(mm, addr);
@@ -251,9 +251,9 @@ full_search:
 		mask = slice_range_to_mask(addr, len);
 		if (!slice_check_fit(mask, available)) {
 			if (addr < SLICE_LOW_TOP)
-				addr = _ALIGN_UP(addr + 1,  1ul << SLICE_LOW_SHIFT);
+				addr = ALIGN_UP(addr + 1,  1ul << SLICE_LOW_SHIFT);
 			else
-				addr = _ALIGN_UP(addr + 1,  1ul << SLICE_HIGH_SHIFT);
+				addr = ALIGN_UP(addr + 1,  1ul << SLICE_HIGH_SHIFT);
 			continue;
 		}
 		if (!vma || addr + len <= vma->vm_start) {
@@ -302,7 +302,7 @@ static unsigned long slice_find_area_topdown(struct 
mm_struct *mm,
 
 		/* make sure it can fit in the remaining address space */
 		if (addr > len) {
-			addr = _ALIGN_DOWN(addr - len, 1ul << pshift);
+			addr = ALIGN_DOWN(addr - len, 1ul << pshift);
 			mask = slice_range_to_mask(addr, len);
 			if (slice_check_fit(mask, available) &&
 			    slice_area_is_free(mm, addr, len))
@@ -316,17 +316,17 @@ static unsigned long slice_find_area_topdown(struct 
mm_struct *mm,
 	addr = mm->mmap_base;
 	while (addr > len) {
 		/* Go down by chunk size */
-		addr = _ALIGN_DOWN(addr - len, 1ul << pshift);
+		addr = ALIGN_DOWN(addr - len, 1ul << pshift);
 
 		/* Check for hit with different page size */
 		mask = slice_range_to_mask(addr, len);
 		if (!slice_check_fit(mask, available)) {
 			if (addr < SLICE_LOW_TOP)
-				addr = _ALIGN_DOWN(addr, 1ul << SLICE_LOW_SHIFT);
+				addr = ALIGN_DOWN(addr, 1ul << SLICE_LOW_SHIFT);
 			else if (addr < (1ul << SLICE_HIGH_SHIFT))
 				addr = SLICE_LOW_TOP;
 			else
-				addr = _ALIGN_DOWN(addr, 1ul << SLICE_HIGH_SHIFT);
+				addr = ALIGN_DOWN(addr, 1ul << SLICE_HIGH_SHIFT);
 			continue;
 		}
 
@@ -428,7 +428,7 @@ unsigned long slice_get_unmapped_area(unsigned long addr, 
unsigned long len,
 
 	/* If hint, make sure it matches our alignment restrictions */
 	if (!fixed && addr) {
-		addr = _ALIGN_UP(addr, 1ul << pshift);
+		addr = ALIGN_UP(addr, 1ul << pshift);
 		slice_dbg(" aligned addr=%lx\n", addr);
 		/* Ignore hint if it's too large or overlaps a VMA */
 		if (addr > mm->task_size - len ||
diff --git a/arch/powerpc/mm/tlb_hash64.c b/arch/powerpc/mm/tlb_hash64.c
index 937eb90..48bb11e 100644
--- a/arch/powerpc/mm/tlb_hash64.c
+++ b/arch/powerpc/mm/tlb_hash64.c
@@ -179,8 +179,8 @@ void __flush_hash_table_range(struct mm_struct *mm, 
unsigned long start,
 {
 	unsigned long flags;
 
-	start = _ALIGN_DOWN(start, PAGE_SIZE);
-	end = _ALIGN_UP(end, PAGE_SIZE);
+	start = ALIGN_DOWN(start, PAGE_SIZE);
+	end = ALIGN_UP(end, PAGE_SIZE);
 
 	BUG_ON(!mm->pgd);
 
diff --git a/arch/powerpc/platforms/cell/iommu.c 
b/arch/powerpc/platforms/cell/iommu.c
index 5b34fc2..5265ac5 100644
--- a/arch/powerpc/platforms/cell/iommu.c
+++ b/arch/powerpc/platforms/cell/iommu.c
@@ -1066,7 +1066,7 @@ static int __init cell_iommu_fixed_mapping_init(void)
 		fbase = max(fbase, dbase + dsize);
 	}
 
-	fbase = _ALIGN_UP(fbase, 1 << IO_SEGMENT_SHIFT);
+	fbase = ALIGN_UP(fbase, 1 << IO_SEGMENT_SHIFT);
 	fsize = lmb_phys_mem_size();
 
 	if ((fbase + fsize) <= 0x800000000)
@@ -1086,8 +1086,8 @@ static int __init cell_iommu_fixed_mapping_init(void)
 		hend  = hbase + htab_size_bytes;
 
 		/* The window must start and end on a segment boundary */
-		if ((hbase != _ALIGN_UP(hbase, 1 << IO_SEGMENT_SHIFT)) ||
-		    (hend != _ALIGN_UP(hend, 1 << IO_SEGMENT_SHIFT))) {
+		if ((hbase != ALIGN_UP(hbase, 1 << IO_SEGMENT_SHIFT)) ||
+		    (hend != ALIGN_UP(hend, 1 << IO_SEGMENT_SHIFT))) {
 			pr_debug("iommu: hash window not segment aligned\n");
 			return -1;
 		}
diff --git a/arch/powerpc/platforms/powermac/bootx_init.c 
b/arch/powerpc/platforms/powermac/bootx_init.c
index cf66091..d6e85fb 100644
--- a/arch/powerpc/platforms/powermac/bootx_init.c
+++ b/arch/powerpc/platforms/powermac/bootx_init.c
@@ -110,7 +110,7 @@ static void * __init bootx_early_getprop(unsigned long 
base,
 
 #define dt_push_token(token, mem) \
 	do { \
-		*(mem) = _ALIGN_UP(*(mem),4); \
+		*(mem) = ALIGN_UP(*(mem),4); \
 		*((u32 *)*(mem)) = token; \
 		*(mem) += 4; \
 	} while(0)
@@ -152,7 +152,7 @@ static void __init bootx_dt_add_prop(char *name, void 
*data, int size,
 	/* push property content */
 	if (size && data) {
 		memcpy((void *)*mem_end, data, size);
-		*mem_end = _ALIGN_UP(*mem_end + size, 4);
+		*mem_end = ALIGN_UP(*mem_end + size, 4);
 	}
 }
 
@@ -305,7 +305,7 @@ static void __init bootx_scan_dt_build_struct(unsigned 
long base,
 			*lp++ = *p;
 	}
 	*lp = 0;
-	*mem_end = _ALIGN_UP((unsigned long)lp + 1, 4);
+	*mem_end = ALIGN_UP((unsigned long)lp + 1, 4);
 
 	/* get and store all properties */
 	while (*ppp) {
@@ -358,11 +358,11 @@ static unsigned long __init bootx_flatten_dt(unsigned 
long start)
 	/* Start using memory after the big blob passed by BootX, get
 	 * some space for the header
 	 */
-	mem_start = mem_end = _ALIGN_UP(((unsigned long)bi) + start, 4);
+	mem_start = mem_end = ALIGN_UP(((unsigned long)bi) + start, 4);
 	DBG("Boot params header at: %x\n", mem_start);
 	hdr = (struct boot_param_header *)mem_start;
 	mem_end += sizeof(struct boot_param_header);
-	rsvmap = (u64 *)(_ALIGN_UP(mem_end, 8));
+	rsvmap = (u64 *)(ALIGN_UP(mem_end, 8));
 	hdr->off_mem_rsvmap = ((unsigned long)rsvmap) - mem_start;
 	mem_end = ((unsigned long)rsvmap) + 8 * sizeof(u64);
 
@@ -388,7 +388,7 @@ static unsigned long __init bootx_flatten_dt(unsigned long 
start)
 	hdr->dt_strings_size = bootx_dt_strend - bootx_dt_strbase;
 
 	/* Build structure */
-	mem_end = _ALIGN(mem_end, 16);
+	mem_end = ALIGN(mem_end, 16);
 	DBG("Building device tree structure at: %x\n", mem_end);
 	hdr->off_dt_struct = mem_end - mem_start;
 	bootx_scan_dt_build_struct(base, 4, &mem_end);
@@ -406,7 +406,7 @@ static unsigned long __init bootx_flatten_dt(unsigned long 
start)
 	 * also bump mem_reserve_cnt to cause further reservations to
 	 * fail since it's too late.
 	 */
-	mem_end = _ALIGN(mem_end, PAGE_SIZE);
+	mem_end = ALIGN(mem_end, PAGE_SIZE);
 	DBG("End of boot params: %x\n", mem_end);
 	rsvmap[0] = mem_start;
 	rsvmap[1] = mem_end;
diff --git a/arch/powerpc/platforms/ps3/mm.c b/arch/powerpc/platforms/ps3/mm.c
index 846eb8b..0c96ecb 100644
--- a/arch/powerpc/platforms/ps3/mm.c
+++ b/arch/powerpc/platforms/ps3/mm.c
@@ -238,7 +238,7 @@ static int ps3_mm_region_create(struct mem_region *r, 
unsigned long size)
 	int result;
 	u64 muid;
 
-	r->size = _ALIGN_DOWN(size, 1 << PAGE_SHIFT_16M);
+	r->size = ALIGN_DOWN(size, 1 << PAGE_SHIFT_16M);
 
 	DBG("%s:%d requested  %lxh\n", __func__, __LINE__, size);
 	DBG("%s:%d actual     %llxh\n", __func__, __LINE__, r->size);
@@ -405,9 +405,9 @@ static struct dma_chunk * dma_find_chunk(struct 
ps3_dma_region *r,
 	unsigned long bus_addr, unsigned long len)
 {
 	struct dma_chunk *c;
-	unsigned long aligned_bus = _ALIGN_DOWN(bus_addr, 1 << r->page_size);
-	unsigned long aligned_len = _ALIGN_UP(len+bus_addr-aligned_bus,
-					      1 << r->page_size);
+	unsigned long aligned_bus = ALIGN_DOWN(bus_addr, 1 << r->page_size);
+	unsigned long aligned_len = ALIGN_UP(len+bus_addr-aligned_bus,
+					     1 << r->page_size);
 
 	list_for_each_entry(c, &r->chunk_list.head, link) {
 		/* intersection */
@@ -434,9 +434,9 @@ static struct dma_chunk *dma_find_chunk_lpar(struct 
ps3_dma_region *r,
 	unsigned long lpar_addr, unsigned long len)
 {
 	struct dma_chunk *c;
-	unsigned long aligned_lpar = _ALIGN_DOWN(lpar_addr, 1 << r->page_size);
-	unsigned long aligned_len = _ALIGN_UP(len + lpar_addr - aligned_lpar,
-					      1 << r->page_size);
+	unsigned long aligned_lpar = ALIGN_DOWN(lpar_addr, 1 << r->page_size);
+	unsigned long aligned_len = ALIGN_UP(len + lpar_addr - aligned_lpar,
+					     1 << r->page_size);
 
 	list_for_each_entry(c, &r->chunk_list.head, link) {
 		/* intersection */
@@ -788,9 +788,9 @@ static int dma_sb_map_area(struct ps3_dma_region *r, 
unsigned long virt_addr,
 	struct dma_chunk *c;
 	unsigned long phys_addr = is_kernel_addr(virt_addr) ? __pa(virt_addr)
 		: virt_addr;
-	unsigned long aligned_phys = _ALIGN_DOWN(phys_addr, 1 << r->page_size);
-	unsigned long aligned_len = _ALIGN_UP(len + phys_addr - aligned_phys,
-					      1 << r->page_size);
+	unsigned long aligned_phys = ALIGN_DOWN(phys_addr, 1 << r->page_size);
+	unsigned long aligned_len = ALIGN_UP(len + phys_addr - aligned_phys,
+					     1 << r->page_size);
 	*bus_addr = dma_sb_lpar_to_bus(r, ps3_mm_phys_to_lpar(phys_addr));
 
 	if (!USE_DYNAMIC_DMA) {
@@ -843,9 +843,9 @@ static int dma_ioc0_map_area(struct ps3_dma_region *r, 
unsigned long virt_addr,
 	struct dma_chunk *c;
 	unsigned long phys_addr = is_kernel_addr(virt_addr) ? __pa(virt_addr)
 		: virt_addr;
-	unsigned long aligned_phys = _ALIGN_DOWN(phys_addr, 1 << r->page_size);
-	unsigned long aligned_len = _ALIGN_UP(len + phys_addr - aligned_phys,
-					      1 << r->page_size);
+	unsigned long aligned_phys = ALIGN_DOWN(phys_addr, 1 << r->page_size);
+	unsigned long aligned_len = ALIGN_UP(len + phys_addr - aligned_phys,
+					     1 << r->page_size);
 
 	DBG(KERN_ERR "%s: vaddr=%#lx, len=%#lx\n", __func__,
 	    virt_addr, len);
@@ -902,9 +902,9 @@ static int dma_sb_unmap_area(struct ps3_dma_region *r, 
dma_addr_t bus_addr,
 	c = dma_find_chunk(r, bus_addr, len);
 
 	if (!c) {
-		unsigned long aligned_bus = _ALIGN_DOWN(bus_addr,
+		unsigned long aligned_bus = ALIGN_DOWN(bus_addr,
 			1 << r->page_size);
-		unsigned long aligned_len = _ALIGN_UP(len + bus_addr
+		unsigned long aligned_len = ALIGN_UP(len + bus_addr
 			- aligned_bus, 1 << r->page_size);
 		DBG("%s:%d: not found: bus_addr %llxh\n",
 			__func__, __LINE__, bus_addr);
@@ -939,11 +939,11 @@ static int dma_ioc0_unmap_area(struct ps3_dma_region *r,
 	c = dma_find_chunk(r, bus_addr, len);
 
 	if (!c) {
-		unsigned long aligned_bus = _ALIGN_DOWN(bus_addr,
-							1 << r->page_size);
-		unsigned long aligned_len = _ALIGN_UP(len + bus_addr
-						      - aligned_bus,
-						      1 << r->page_size);
+		unsigned long aligned_bus = ALIGN_DOWN(bus_addr,
+						       1 << r->page_size);
+		unsigned long aligned_len = ALIGN_UP(len + bus_addr
+						     - aligned_bus,
+						     1 << r->page_size);
 		DBG("%s:%d: not found: bus_addr %llxh\n",
 		    __func__, __LINE__, bus_addr);
 		DBG("%s:%d: not found: len %lxh\n",
@@ -987,7 +987,7 @@ static int dma_sb_region_create_linear(struct 
ps3_dma_region *r)
 			pr_info("%s:%d: forcing 16M pages for linear map\n",
 				__func__, __LINE__);
 			r->page_size = PS3_DMA_16M;
-			r->len = _ALIGN_UP(r->len, 1 << r->page_size);
+			r->len = ALIGN_UP(r->len, 1 << r->page_size);
 		}
 	}
 
@@ -1138,7 +1138,7 @@ int ps3_dma_region_init(struct ps3_system_bus_device 
*dev,
 	r->offset = lpar_addr;
 	if (r->offset >= map.rm.size)
 		r->offset -= map.r1.offset;
-	r->len = len ? len : _ALIGN_UP(map.total, 1 << r->page_size);
+	r->len = len ? len : ALIGN_UP(map.total, 1 << r->page_size);
 
 	switch (dev->dev_type) {
 	case PS3_DEVICE_TYPE_SB:
diff --git a/arch/powerpc/platforms/ps3/setup.c 
b/arch/powerpc/platforms/ps3/setup.c
index 149bea2..8ba1ad7 100644
--- a/arch/powerpc/platforms/ps3/setup.c
+++ b/arch/powerpc/platforms/ps3/setup.c
@@ -150,8 +150,8 @@ static int __init early_parse_ps3fb(char *p)
 	if (!p)
 		return 1;
 
-	ps3fb_videomemory.size = _ALIGN_UP(memparse(p, &p),
-					   ps3fb_videomemory.align);
+	ps3fb_videomemory.size = ALIGN_UP(memparse(p, &p),
+					  ps3fb_videomemory.align);
 	return 0;
 }
 early_param("ps3fb", early_parse_ps3fb);
diff --git a/drivers/ps3/ps3-lpm.c b/drivers/ps3/ps3-lpm.c
index fe96793..6782416 100644
--- a/drivers/ps3/ps3-lpm.c
+++ b/drivers/ps3/ps3-lpm.c
@@ -1107,8 +1107,8 @@ int ps3_lpm_open(enum ps3_lpm_tb_type tb_type, void 
*tb_cache,
 		lpm_priv->tb_cache_internal = NULL;
 		lpm_priv->tb_cache = NULL;
 	} else if (tb_cache) {
-		if (tb_cache != (void *)_ALIGN_UP((unsigned long)tb_cache, 128)
-			|| tb_cache_size != _ALIGN_UP(tb_cache_size, 128)) {
+		if (tb_cache != (void *)ALIGN_UP((unsigned long)tb_cache, 128)
+			|| tb_cache_size != ALIGN_UP(tb_cache_size, 128)) {
 			dev_err(sbd_core(), "%s:%u: unaligned tb_cache\n",
 				__func__, __LINE__);
 			result = -EINVAL;
@@ -1127,7 +1127,7 @@ int ps3_lpm_open(enum ps3_lpm_tb_type tb_type, void 
*tb_cache,
 			result = -ENOMEM;
 			goto fail_malloc;
 		}
-		lpm_priv->tb_cache = (void *)_ALIGN_UP(
+		lpm_priv->tb_cache = (void *)ALIGN_UP(
 			(unsigned long)lpm_priv->tb_cache_internal, 128);
 	}
 
diff --git a/drivers/video/ps3fb.c b/drivers/video/ps3fb.c
index c0af638..fe2359e 100644
--- a/drivers/video/ps3fb.c
+++ b/drivers/video/ps3fb.c
@@ -45,7 +45,7 @@
 #define GPU_CMD_BUF_SIZE			(2 * 1024 * 1024)
 #define GPU_FB_START				(64 * 1024)
 #define GPU_IOIF				(0x0d000000UL)
-#define GPU_ALIGN_UP(x)				_ALIGN_UP((x), 64)
+#define GPU_ALIGN_UP(x)				ALIGN_UP((x), 64)
 #define GPU_MAX_LINE_LENGTH			(65536 - 64)
 
 #define GPU_INTR_STATUS_VSYNC_0			0	/* vsync on head A */
@@ -1022,7 +1022,7 @@ static int __devinit ps3fb_probe(struct 
ps3_system_bus_device *dev)
 	}
 #endif
 
-	max_ps3fb_size = _ALIGN_UP(GPU_IOIF, 256*1024*1024) - GPU_IOIF;
+	max_ps3fb_size = ALIGN_UP(GPU_IOIF, 256*1024*1024) - GPU_IOIF;
 	if (ps3fb_videomemory.size > max_ps3fb_size) {
 		dev_info(&dev->core, "Limiting ps3fb mem size to %lu bytes\n",
 			 max_ps3fb_size);
diff --git a/include/linux/align.h b/include/linux/align.h
new file mode 100644
index 0000000..97d9275
--- /dev/null
+++ b/include/linux/align.h
@@ -0,0 +1,17 @@
+#ifndef _LINUX_ALIGN_H
+#define _LINUX_ALIGN_H
+
+/*
+ * Alignment macros
+ */
+#define ALIGN_UP(x,a)		__ALIGN_MASK(x,(typeof(x))(a)-1)
+#define ALIGN_DOWN(x,a)		__ALIGN_MASK(x-(a-1),(typeof(x))(a)-1)
+#define __ALIGN_MASK(x,mask)	(((x)+(mask))&~(mask))
+#define PTR_ALIGN(p, a)		((typeof(p))ALIGN_UP((unsigned long)(p), (a)))
+#define IS_ALIGNED(x, a)	(((x) & ((typeof(x))(a) - 1)) == 0)
+
+#ifndef __ASSEMBLY__
+#define ALIGN(x,a)		ALIGN_UP(x,a)
+#endif
+
+#endif
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index d6320a3..7dd411e 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -17,6 +17,7 @@
 #include <linux/typecheck.h>
 #include <linux/ratelimit.h>
 #include <linux/dynamic_debug.h>
+#include <linux/align.h>
 #include <asm/byteorder.h>
 #include <asm/bug.h>
 
@@ -38,11 +39,6 @@ extern const char linux_proc_banner[];
 
 #define STACK_MAGIC	0xdeadbeef
 
-#define ALIGN(x,a)		__ALIGN_MASK(x,(typeof(x))(a)-1)
-#define __ALIGN_MASK(x,mask)	(((x)+(mask))&~(mask))
-#define PTR_ALIGN(p, a)		((typeof(p))ALIGN((unsigned long)(p), (a)))
-#define IS_ALIGNED(x, a)		(((x) & ((typeof(x))(a) - 1)) == 0)
-
 #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + 
__must_be_array(arr))
 
 #define FIELD_SIZEOF(t, f) (sizeof(((t*)0)->f))
diff --git a/sound/ppc/snd_ps3.c b/sound/ppc/snd_ps3.c
index 53c81a5..e2cf154 100644
--- a/sound/ppc/snd_ps3.c
+++ b/sound/ppc/snd_ps3.c
@@ -960,7 +960,7 @@ static int __devinit snd_ps3_driver_probe(struct 
ps3_system_bus_device *dev)
 			    PAGE_SHIFT, /* use system page size */
 			    0, /* dma type; not used */
 			    NULL,
-			    _ALIGN_UP(SND_PS3_DMA_REGION_SIZE, PAGE_SIZE));
+			    ALIGN_UP(SND_PS3_DMA_REGION_SIZE, PAGE_SIZE));
 	dev->d_region->ioid = PS3_AUDIO_IOID;
 
 	ret = ps3_dma_region_create(dev->d_region);



