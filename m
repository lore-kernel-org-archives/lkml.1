Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933922Ab0BQCmy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 21:42:54 -0500
Received: from hera.kernel.org ([140.211.167.34]:59907 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933879Ab0BQCmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 21:42:51 -0500
Message-ID: <4B7B5723.4070009@kernel.org>
Date: Tue, 16 Feb 2010 18:40:35 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 27/35] core: move early_res
References: <1265793639-15071-1-git-send-email-yinghai@kernel.org>	<1265793639-15071-28-git-send-email-yinghai@kernel.org> <20100215011615.e3d35121.sfr@canb.auug.org.au> <4B786110.9020806@kernel.org> <4B7B2E3B.9060903@zytor.com> <4B7B2FE1.1030700@kernel.org> <4B7B31F1.60203@zytor.com> <4B7B3B33.6010504@kernel.org> <4B7B3C4C.7060002@zytor.com> <4B7B41FC.9020902@kernel.org>
In-Reply-To: <4B7B41FC.9020902@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2010 05:10 PM, Yinghai Lu wrote:
> On 02/16/2010 04:46 PM, H. Peter Anvin wrote:
>> On 02/16/2010 04:41 PM, Yinghai Lu wrote:
>>>
>>> I would like to.
>>>
>>> but for x86, with CONFIG_NO_BOOTMEM set or not, early_res are all used.
>>>
>>> so we add CONFIG_HAVE_EARLY_RES ?
>>>
>>
>> Presumably, and force it true on x86.
>>
> 
> please use this one to replace the one in tip/x86/bootmem

sorry, please use this one instead.

Subject: [PATCH -v4 27/35] core: move early_res

from arch/x86 to kernel/

-v2: add get_max_mapped, max_pfn_mapped only defined in x86...
     to fix PPC compiling
-v3: according to hpa, add CONFIG_HAVE_EARLY_RES
-v4: fix typo about EALRY_RES in config

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/Kconfig                 |    3 
 arch/x86/include/asm/e820.h      |    2 
 arch/x86/include/asm/early_res.h |   21 -
 arch/x86/kernel/Makefile         |    2 
 arch/x86/kernel/e820.c           |   10 
 arch/x86/kernel/early_res.c      |  523 ---------------------------------------
 include/linux/early_res.h        |   22 +
 kernel/Makefile                  |    1 
 kernel/early_res.c               |  515 ++++++++++++++++++++++++++++++++++++++
 9 files changed, 552 insertions(+), 547 deletions(-)

Index: linux-2.6/arch/x86/include/asm/e820.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/e820.h
+++ linux-2.6/arch/x86/include/asm/e820.h
@@ -112,7 +112,7 @@ extern unsigned long end_user_pfn;
 extern u64 find_e820_area(u64 start, u64 end, u64 size, u64 align);
 extern u64 find_e820_area_size(u64 start, u64 *sizep, u64 align);
 extern u64 early_reserve_e820(u64 startt, u64 sizet, u64 align);
-#include <asm/early_res.h>
+#include <linux/early_res.h>
 
 extern unsigned long e820_end_of_ram_pfn(void);
 extern unsigned long e820_end_of_low_ram_pfn(void);
Index: linux-2.6/arch/x86/include/asm/early_res.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/early_res.h
+++ /dev/null
@@ -1,21 +0,0 @@
-#ifndef _ASM_X86_EARLY_RES_H
-#define _ASM_X86_EARLY_RES_H
-#ifdef __KERNEL__
-
-extern void reserve_early(u64 start, u64 end, char *name);
-extern void reserve_early_overlap_ok(u64 start, u64 end, char *name);
-extern void free_early(u64 start, u64 end);
-extern void early_res_to_bootmem(u64 start, u64 end);
-
-void reserve_early_without_check(u64 start, u64 end, char *name);
-u64 find_early_area(u64 ei_start, u64 ei_last, u64 start, u64 end,
-			 u64 size, u64 align);
-u64 find_early_area_size(u64 ei_start, u64 ei_last, u64 start,
-			 u64 *sizep, u64 align);
-u64 find_fw_memmap_area(u64 start, u64 end, u64 size, u64 align);
-#include <linux/range.h>
-int get_free_all_memory_range(struct range **rangep, int nodeid);
-
-#endif /* __KERNEL__ */
-
-#endif /* _ASM_X86_EARLY_RES_H */
Index: linux-2.6/arch/x86/kernel/Makefile
===================================================================
--- linux-2.6.orig/arch/x86/kernel/Makefile
+++ linux-2.6/arch/x86/kernel/Makefile
@@ -38,7 +38,7 @@ obj-$(CONFIG_X86_32)	+= probe_roms_32.o
 obj-$(CONFIG_X86_32)	+= sys_i386_32.o i386_ksyms_32.o
 obj-$(CONFIG_X86_64)	+= sys_x86_64.o x8664_ksyms_64.o
 obj-$(CONFIG_X86_64)	+= syscall_64.o vsyscall_64.o
-obj-y			+= bootflag.o e820.o early_res.o
+obj-y			+= bootflag.o e820.o
 obj-y			+= pci-dma.o quirks.o i8237.o topology.o kdebugfs.o
 obj-y			+= alternative.o i8253.o pci-nommu.o hw_breakpoint.o
 obj-y			+= tsc.o io_delay.o rtc.o
Index: linux-2.6/arch/x86/kernel/e820.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820.c
+++ linux-2.6/arch/x86/kernel/e820.c
@@ -17,7 +17,6 @@
 #include <linux/firmware-map.h>
 
 #include <asm/e820.h>
-#include <asm/early_res.h>
 #include <asm/proto.h>
 #include <asm/setup.h>
 
@@ -752,6 +751,15 @@ u64 __init find_fw_memmap_area(u64 start
 {
 	return find_e820_area(start, end, size, align);
 }
+
+u64 __init get_max_mapped(void)
+{
+	u64 end = max_pfn_mapped;
+
+	end <<= PAGE_SHIFT;
+
+	return end;
+}
 /*
  * Find next free range after *start
  */
Index: linux-2.6/arch/x86/kernel/early_res.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/early_res.c
+++ /dev/null
@@ -1,523 +0,0 @@
-/*
- * early_res, could be used to replace bootmem
- */
-#include <linux/kernel.h>
-#include <linux/types.h>
-#include <linux/init.h>
-#include <linux/bootmem.h>
-#include <linux/mm.h>
-
-#include <asm/early_res.h>
-
-/*
- * Early reserved memory areas.
- */
-/*
- * need to make sure this one is bigger enough before
- * find_fw_memmap_area could be used
- */
-#define MAX_EARLY_RES_X 32
-
-struct early_res {
-	u64 start, end;
-	char name[15];
-	char overlap_ok;
-};
-static struct early_res early_res_x[MAX_EARLY_RES_X] __initdata;
-
-static int max_early_res __initdata = MAX_EARLY_RES_X;
-static struct early_res *early_res __initdata = &early_res_x[0];
-static int early_res_count __initdata;
-
-static int __init find_overlapped_early(u64 start, u64 end)
-{
-	int i;
-	struct early_res *r;
-
-	for (i = 0; i < max_early_res && early_res[i].end; i++) {
-		r = &early_res[i];
-		if (end > r->start && start < r->end)
-			break;
-	}
-
-	return i;
-}
-
-/*
- * Drop the i-th range from the early reservation map,
- * by copying any higher ranges down one over it, and
- * clearing what had been the last slot.
- */
-static void __init drop_range(int i)
-{
-	int j;
-
-	for (j = i + 1; j < max_early_res && early_res[j].end; j++)
-		;
-
-	memmove(&early_res[i], &early_res[i + 1],
-	       (j - 1 - i) * sizeof(struct early_res));
-
-	early_res[j - 1].end = 0;
-	early_res_count--;
-}
-
-/*
- * Split any existing ranges that:
- *  1) are marked 'overlap_ok', and
- *  2) overlap with the stated range [start, end)
- * into whatever portion (if any) of the existing range is entirely
- * below or entirely above the stated range.  Drop the portion
- * of the existing range that overlaps with the stated range,
- * which will allow the caller of this routine to then add that
- * stated range without conflicting with any existing range.
- */
-static void __init drop_overlaps_that_are_ok(u64 start, u64 end)
-{
-	int i;
-	struct early_res *r;
-	u64 lower_start, lower_end;
-	u64 upper_start, upper_end;
-	char name[15];
-
-	for (i = 0; i < max_early_res && early_res[i].end; i++) {
-		r = &early_res[i];
-
-		/* Continue past non-overlapping ranges */
-		if (end <= r->start || start >= r->end)
-			continue;
-
-		/*
-		 * Leave non-ok overlaps as is; let caller
-		 * panic "Overlapping early reservations"
-		 * when it hits this overlap.
-		 */
-		if (!r->overlap_ok)
-			return;
-
-		/*
-		 * We have an ok overlap.  We will drop it from the early
-		 * reservation map, and add back in any non-overlapping
-		 * portions (lower or upper) as separate, overlap_ok,
-		 * non-overlapping ranges.
-		 */
-
-		/* 1. Note any non-overlapping (lower or upper) ranges. */
-		strncpy(name, r->name, sizeof(name) - 1);
-
-		lower_start = lower_end = 0;
-		upper_start = upper_end = 0;
-		if (r->start < start) {
-			lower_start = r->start;
-			lower_end = start;
-		}
-		if (r->end > end) {
-			upper_start = end;
-			upper_end = r->end;
-		}
-
-		/* 2. Drop the original ok overlapping range */
-		drop_range(i);
-
-		i--;		/* resume for-loop on copied down entry */
-
-		/* 3. Add back in any non-overlapping ranges. */
-		if (lower_end)
-			reserve_early_overlap_ok(lower_start, lower_end, name);
-		if (upper_end)
-			reserve_early_overlap_ok(upper_start, upper_end, name);
-	}
-}
-
-static void __init __reserve_early(u64 start, u64 end, char *name,
-						int overlap_ok)
-{
-	int i;
-	struct early_res *r;
-
-	i = find_overlapped_early(start, end);
-	if (i >= max_early_res)
-		panic("Too many early reservations");
-	r = &early_res[i];
-	if (r->end)
-		panic("Overlapping early reservations "
-		      "%llx-%llx %s to %llx-%llx %s\n",
-		      start, end - 1, name ? name : "", r->start,
-		      r->end - 1, r->name);
-	r->start = start;
-	r->end = end;
-	r->overlap_ok = overlap_ok;
-	if (name)
-		strncpy(r->name, name, sizeof(r->name) - 1);
-	early_res_count++;
-}
-
-/*
- * A few early reservtations come here.
- *
- * The 'overlap_ok' in the name of this routine does -not- mean it
- * is ok for these reservations to overlap an earlier reservation.
- * Rather it means that it is ok for subsequent reservations to
- * overlap this one.
- *
- * Use this entry point to reserve early ranges when you are doing
- * so out of "Paranoia", reserving perhaps more memory than you need,
- * just in case, and don't mind a subsequent overlapping reservation
- * that is known to be needed.
- *
- * The drop_overlaps_that_are_ok() call here isn't really needed.
- * It would be needed if we had two colliding 'overlap_ok'
- * reservations, so that the second such would not panic on the
- * overlap with the first.  We don't have any such as of this
- * writing, but might as well tolerate such if it happens in
- * the future.
- */
-void __init reserve_early_overlap_ok(u64 start, u64 end, char *name)
-{
-	drop_overlaps_that_are_ok(start, end);
-	__reserve_early(start, end, name, 1);
-}
-
-u64 __init __weak find_fw_memmap_area(u64 start, u64 end, u64 size, u64 align)
-{
-	panic("should have find_fw_memmap_area defined with arch");
-
-	return -1ULL;
-}
-
-static void __init __check_and_double_early_res(u64 ex_start, u64 ex_end)
-{
-	u64 start, end, size, mem;
-	struct early_res *new;
-
-	/* do we have enough slots left ? */
-	if ((max_early_res - early_res_count) > max(max_early_res/8, 2))
-		return;
-
-	/* double it */
-	mem = -1ULL;
-	size = sizeof(struct early_res) * max_early_res * 2;
-	if (early_res == early_res_x)
-		start = 0;
-	else
-		start = early_res[0].end;
-	end = ex_start;
-	if (start + size < end)
-		mem = find_fw_memmap_area(start, end, size,
-					 sizeof(struct early_res));
-	if (mem == -1ULL) {
-		start = ex_end;
-		end = max_pfn_mapped << PAGE_SHIFT;
-		if (start + size < end)
-			mem = find_fw_memmap_area(start, end, size,
-						 sizeof(struct early_res));
-	}
-	if (mem == -1ULL)
-		panic("can not find more space for early_res array");
-
-	new = __va(mem);
-	/* save the first one for own */
-	new[0].start = mem;
-	new[0].end = mem + size;
-	new[0].overlap_ok = 0;
-	/* copy old to new */
-	if (early_res == early_res_x) {
-		memcpy(&new[1], &early_res[0],
-			 sizeof(struct early_res) * max_early_res);
-		memset(&new[max_early_res+1], 0,
-			 sizeof(struct early_res) * (max_early_res - 1));
-		early_res_count++;
-	} else {
-		memcpy(&new[1], &early_res[1],
-			 sizeof(struct early_res) * (max_early_res - 1));
-		memset(&new[max_early_res], 0,
-			 sizeof(struct early_res) * max_early_res);
-	}
-	memset(&early_res[0], 0, sizeof(struct early_res) * max_early_res);
-	early_res = new;
-	max_early_res *= 2;
-	printk(KERN_DEBUG "early_res array is doubled to %d at [%llx - %llx]\n",
-		max_early_res, mem, mem + size - 1);
-}
-
-/*
- * Most early reservations come here.
- *
- * We first have drop_overlaps_that_are_ok() drop any pre-existing
- * 'overlap_ok' ranges, so that we can then reserve this memory
- * range without risk of panic'ing on an overlapping overlap_ok
- * early reservation.
- */
-void __init reserve_early(u64 start, u64 end, char *name)
-{
-	if (start >= end)
-		return;
-
-	__check_and_double_early_res(start, end);
-
-	drop_overlaps_that_are_ok(start, end);
-	__reserve_early(start, end, name, 0);
-}
-
-void __init reserve_early_without_check(u64 start, u64 end, char *name)
-{
-	struct early_res *r;
-
-	if (start >= end)
-		return;
-
-	__check_and_double_early_res(start, end);
-
-	r = &early_res[early_res_count];
-
-	r->start = start;
-	r->end = end;
-	r->overlap_ok = 0;
-	if (name)
-		strncpy(r->name, name, sizeof(r->name) - 1);
-	early_res_count++;
-}
-
-void __init free_early(u64 start, u64 end)
-{
-	struct early_res *r;
-	int i;
-
-	i = find_overlapped_early(start, end);
-	r = &early_res[i];
-	if (i >= max_early_res || r->end != end || r->start != start)
-		panic("free_early on not reserved area: %llx-%llx!",
-			 start, end - 1);
-
-	drop_range(i);
-}
-
-#ifdef CONFIG_NO_BOOTMEM
-static void __init subtract_early_res(struct range *range, int az)
-{
-	int i, count;
-	u64 final_start, final_end;
-	int idx = 0;
-
-	count  = 0;
-	for (i = 0; i < max_early_res && early_res[i].end; i++)
-		count++;
-
-	/* need to skip first one ?*/
-	if (early_res != early_res_x)
-		idx = 1;
-
-#define DEBUG_PRINT_EARLY_RES 1
-
-#if DEBUG_PRINT_EARLY_RES
-	printk(KERN_INFO "Subtract (%d early reservations)\n", count);
-#endif
-	for (i = idx; i < count; i++) {
-		struct early_res *r = &early_res[i];
-#if DEBUG_PRINT_EARLY_RES
-		printk(KERN_INFO "  #%d [%010llx - %010llx] %15s\n", i,
-			r->start, r->end, r->name);
-#endif
-		final_start = PFN_DOWN(r->start);
-		final_end = PFN_UP(r->end);
-		if (final_start >= final_end)
-			continue;
-		subtract_range(range, az, final_start, final_end);
-	}
-
-}
-
-int __init get_free_all_memory_range(struct range **rangep, int nodeid)
-{
-	int i, count;
-	u64 start = 0, end;
-	u64 size;
-	u64 mem;
-	struct range *range;
-	int nr_range;
-
-	count  = 0;
-	for (i = 0; i < max_early_res && early_res[i].end; i++)
-		count++;
-
-	count *= 2;
-
-	size = sizeof(struct range) * count;
-#ifdef MAX_DMA32_PFN
-	if (max_pfn_mapped > MAX_DMA32_PFN)
-		start = MAX_DMA32_PFN << PAGE_SHIFT;
-#endif
-	end = max_pfn_mapped << PAGE_SHIFT;
-	mem = find_fw_memmap_area(start, end, size, sizeof(struct range));
-	if (mem == -1ULL)
-		panic("can not find more space for range free");
-
-	range = __va(mem);
-	/* use early_node_map[] and early_res to get range array at first */
-	memset(range, 0, size);
-	nr_range = 0;
-
-	/* need to go over early_node_map to find out good range for node */
-	nr_range = add_from_early_node_map(range, count, nr_range, nodeid);
-#ifdef CONFIG_X86_32
-	subtract_range(range, count, max_low_pfn, -1ULL);
-#endif
-	subtract_early_res(range, count);
-	nr_range = clean_sort_range(range, count);
-
-	/* need to clear it ? */
-	if (nodeid == MAX_NUMNODES) {
-		memset(&early_res[0], 0,
-			 sizeof(struct early_res) * max_early_res);
-		early_res = NULL;
-		max_early_res = 0;
-	}
-
-	*rangep = range;
-	return nr_range;
-}
-#else
-void __init early_res_to_bootmem(u64 start, u64 end)
-{
-	int i, count;
-	u64 final_start, final_end;
-	int idx = 0;
-
-	count  = 0;
-	for (i = 0; i < max_early_res && early_res[i].end; i++)
-		count++;
-
-	/* need to skip first one ?*/
-	if (early_res != early_res_x)
-		idx = 1;
-
-	printk(KERN_INFO "(%d/%d early reservations) ==> bootmem [%010llx - %010llx]\n",
-			 count - idx, max_early_res, start, end);
-	for (i = idx; i < count; i++) {
-		struct early_res *r = &early_res[i];
-		printk(KERN_INFO "  #%d [%010llx - %010llx] %16s", i,
-			r->start, r->end, r->name);
-		final_start = max(start, r->start);
-		final_end = min(end, r->end);
-		if (final_start >= final_end) {
-			printk(KERN_CONT "\n");
-			continue;
-		}
-		printk(KERN_CONT " ==> [%010llx - %010llx]\n",
-			final_start, final_end);
-		reserve_bootmem_generic(final_start, final_end - final_start,
-				BOOTMEM_DEFAULT);
-	}
-	/* clear them */
-	memset(&early_res[0], 0, sizeof(struct early_res) * max_early_res);
-	early_res = NULL;
-	max_early_res = 0;
-	early_res_count = 0;
-}
-#endif
-
-/* Check for already reserved areas */
-static inline int __init bad_addr(u64 *addrp, u64 size, u64 align)
-{
-	int i;
-	u64 addr = *addrp;
-	int changed = 0;
-	struct early_res *r;
-again:
-	i = find_overlapped_early(addr, addr + size);
-	r = &early_res[i];
-	if (i < max_early_res && r->end) {
-		*addrp = addr = round_up(r->end, align);
-		changed = 1;
-		goto again;
-	}
-	return changed;
-}
-
-/* Check for already reserved areas */
-static inline int __init bad_addr_size(u64 *addrp, u64 *sizep, u64 align)
-{
-	int i;
-	u64 addr = *addrp, last;
-	u64 size = *sizep;
-	int changed = 0;
-again:
-	last = addr + size;
-	for (i = 0; i < max_early_res && early_res[i].end; i++) {
-		struct early_res *r = &early_res[i];
-		if (last > r->start && addr < r->start) {
-			size = r->start - addr;
-			changed = 1;
-			goto again;
-		}
-		if (last > r->end && addr < r->end) {
-			addr = round_up(r->end, align);
-			size = last - addr;
-			changed = 1;
-			goto again;
-		}
-		if (last <= r->end && addr >= r->start) {
-			(*sizep)++;
-			return 0;
-		}
-	}
-	if (changed) {
-		*addrp = addr;
-		*sizep = size;
-	}
-	return changed;
-}
-
-/*
- * Find a free area with specified alignment in a specific range.
- * only with the area.between start to end is active range from early_node_map
- * so they are good as RAM
- */
-u64 __init find_early_area(u64 ei_start, u64 ei_last, u64 start, u64 end,
-			 u64 size, u64 align)
-{
-	u64 addr, last;
-
-	addr = round_up(ei_start, align);
-	if (addr < start)
-		addr = round_up(start, align);
-	if (addr >= ei_last)
-		goto out;
-	while (bad_addr(&addr, size, align) && addr+size <= ei_last)
-		;
-	last = addr + size;
-	if (last > ei_last)
-		goto out;
-	if (last > end)
-		goto out;
-
-	return addr;
-
-out:
-	return -1ULL;
-}
-
-u64 __init find_early_area_size(u64 ei_start, u64 ei_last, u64 start,
-			 u64 *sizep, u64 align)
-{
-	u64 addr, last;
-
-	addr = round_up(ei_start, align);
-	if (addr < start)
-		addr = round_up(start, align);
-	if (addr >= ei_last)
-		goto out;
-	*sizep = ei_last - addr;
-	while (bad_addr_size(&addr, sizep, align) && addr + *sizep <= ei_last)
-		;
-	last = addr + *sizep;
-	if (last > ei_last)
-		goto out;
-
-	return addr;
-
-out:
-	return -1ULL;
-}
-
-
Index: linux-2.6/include/linux/early_res.h
===================================================================
--- /dev/null
+++ linux-2.6/include/linux/early_res.h
@@ -0,0 +1,22 @@
+#ifndef _LINUX_EARLY_RES_H
+#define _LINUX_EARLY_RES_H
+#ifdef __KERNEL__
+
+extern void reserve_early(u64 start, u64 end, char *name);
+extern void reserve_early_overlap_ok(u64 start, u64 end, char *name);
+extern void free_early(u64 start, u64 end);
+extern void early_res_to_bootmem(u64 start, u64 end);
+
+void reserve_early_without_check(u64 start, u64 end, char *name);
+u64 find_early_area(u64 ei_start, u64 ei_last, u64 start, u64 end,
+			 u64 size, u64 align);
+u64 find_early_area_size(u64 ei_start, u64 ei_last, u64 start,
+			 u64 *sizep, u64 align);
+u64 find_fw_memmap_area(u64 start, u64 end, u64 size, u64 align);
+u64 get_max_mapped(void);
+#include <linux/range.h>
+int get_free_all_memory_range(struct range **rangep, int nodeid);
+
+#endif /* __KERNEL__ */
+
+#endif /* _LINUX_EARLY_RES_H */
Index: linux-2.6/kernel/Makefile
===================================================================
--- linux-2.6.orig/kernel/Makefile
+++ linux-2.6/kernel/Makefile
@@ -11,6 +11,7 @@ obj-y     = sched.o fork.o exec_domain.o
 	    hrtimer.o rwsem.o nsproxy.o srcu.o semaphore.o \
 	    notifier.o ksysfs.o pm_qos_params.o sched_clock.o cred.o \
 	    async.o range.o
+obj-$(CONFIG_HAVE_EARLY_RES) += early_res.o
 obj-y += groups.o
 
 ifdef CONFIG_FUNCTION_TRACER
Index: linux-2.6/kernel/early_res.c
===================================================================
--- /dev/null
+++ linux-2.6/kernel/early_res.c
@@ -0,0 +1,515 @@
+/*
+ * early_res, could be used to replace bootmem
+ */
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/init.h>
+#include <linux/bootmem.h>
+#include <linux/mm.h>
+#include <linux/early_res.h>
+
+/*
+ * Early reserved memory areas.
+ */
+/*
+ * need to make sure this one is bigger enough before
+ * find_fw_memmap_area could be used
+ */
+#define MAX_EARLY_RES_X 32
+
+struct early_res {
+	u64 start, end;
+	char name[15];
+	char overlap_ok;
+};
+static struct early_res early_res_x[MAX_EARLY_RES_X] __initdata;
+
+static int max_early_res __initdata = MAX_EARLY_RES_X;
+static struct early_res *early_res __initdata = &early_res_x[0];
+static int early_res_count __initdata;
+
+static int __init find_overlapped_early(u64 start, u64 end)
+{
+	int i;
+	struct early_res *r;
+
+	for (i = 0; i < max_early_res && early_res[i].end; i++) {
+		r = &early_res[i];
+		if (end > r->start && start < r->end)
+			break;
+	}
+
+	return i;
+}
+
+/*
+ * Drop the i-th range from the early reservation map,
+ * by copying any higher ranges down one over it, and
+ * clearing what had been the last slot.
+ */
+static void __init drop_range(int i)
+{
+	int j;
+
+	for (j = i + 1; j < max_early_res && early_res[j].end; j++)
+		;
+
+	memmove(&early_res[i], &early_res[i + 1],
+	       (j - 1 - i) * sizeof(struct early_res));
+
+	early_res[j - 1].end = 0;
+	early_res_count--;
+}
+
+/*
+ * Split any existing ranges that:
+ *  1) are marked 'overlap_ok', and
+ *  2) overlap with the stated range [start, end)
+ * into whatever portion (if any) of the existing range is entirely
+ * below or entirely above the stated range.  Drop the portion
+ * of the existing range that overlaps with the stated range,
+ * which will allow the caller of this routine to then add that
+ * stated range without conflicting with any existing range.
+ */
+static void __init drop_overlaps_that_are_ok(u64 start, u64 end)
+{
+	int i;
+	struct early_res *r;
+	u64 lower_start, lower_end;
+	u64 upper_start, upper_end;
+	char name[15];
+
+	for (i = 0; i < max_early_res && early_res[i].end; i++) {
+		r = &early_res[i];
+
+		/* Continue past non-overlapping ranges */
+		if (end <= r->start || start >= r->end)
+			continue;
+
+		/*
+		 * Leave non-ok overlaps as is; let caller
+		 * panic "Overlapping early reservations"
+		 * when it hits this overlap.
+		 */
+		if (!r->overlap_ok)
+			return;
+
+		/*
+		 * We have an ok overlap.  We will drop it from the early
+		 * reservation map, and add back in any non-overlapping
+		 * portions (lower or upper) as separate, overlap_ok,
+		 * non-overlapping ranges.
+		 */
+
+		/* 1. Note any non-overlapping (lower or upper) ranges. */
+		strncpy(name, r->name, sizeof(name) - 1);
+
+		lower_start = lower_end = 0;
+		upper_start = upper_end = 0;
+		if (r->start < start) {
+			lower_start = r->start;
+			lower_end = start;
+		}
+		if (r->end > end) {
+			upper_start = end;
+			upper_end = r->end;
+		}
+
+		/* 2. Drop the original ok overlapping range */
+		drop_range(i);
+
+		i--;		/* resume for-loop on copied down entry */
+
+		/* 3. Add back in any non-overlapping ranges. */
+		if (lower_end)
+			reserve_early_overlap_ok(lower_start, lower_end, name);
+		if (upper_end)
+			reserve_early_overlap_ok(upper_start, upper_end, name);
+	}
+}
+
+static void __init __reserve_early(u64 start, u64 end, char *name,
+						int overlap_ok)
+{
+	int i;
+	struct early_res *r;
+
+	i = find_overlapped_early(start, end);
+	if (i >= max_early_res)
+		panic("Too many early reservations");
+	r = &early_res[i];
+	if (r->end)
+		panic("Overlapping early reservations "
+		      "%llx-%llx %s to %llx-%llx %s\n",
+		      start, end - 1, name ? name : "", r->start,
+		      r->end - 1, r->name);
+	r->start = start;
+	r->end = end;
+	r->overlap_ok = overlap_ok;
+	if (name)
+		strncpy(r->name, name, sizeof(r->name) - 1);
+	early_res_count++;
+}
+
+/*
+ * A few early reservtations come here.
+ *
+ * The 'overlap_ok' in the name of this routine does -not- mean it
+ * is ok for these reservations to overlap an earlier reservation.
+ * Rather it means that it is ok for subsequent reservations to
+ * overlap this one.
+ *
+ * Use this entry point to reserve early ranges when you are doing
+ * so out of "Paranoia", reserving perhaps more memory than you need,
+ * just in case, and don't mind a subsequent overlapping reservation
+ * that is known to be needed.
+ *
+ * The drop_overlaps_that_are_ok() call here isn't really needed.
+ * It would be needed if we had two colliding 'overlap_ok'
+ * reservations, so that the second such would not panic on the
+ * overlap with the first.  We don't have any such as of this
+ * writing, but might as well tolerate such if it happens in
+ * the future.
+ */
+void __init reserve_early_overlap_ok(u64 start, u64 end, char *name)
+{
+	drop_overlaps_that_are_ok(start, end);
+	__reserve_early(start, end, name, 1);
+}
+
+static void __init __check_and_double_early_res(u64 ex_start, u64 ex_end)
+{
+	u64 start, end, size, mem;
+	struct early_res *new;
+
+	/* do we have enough slots left ? */
+	if ((max_early_res - early_res_count) > max(max_early_res/8, 2))
+		return;
+
+	/* double it */
+	mem = -1ULL;
+	size = sizeof(struct early_res) * max_early_res * 2;
+	if (early_res == early_res_x)
+		start = 0;
+	else
+		start = early_res[0].end;
+	end = ex_start;
+	if (start + size < end)
+		mem = find_fw_memmap_area(start, end, size,
+					 sizeof(struct early_res));
+	if (mem == -1ULL) {
+		start = ex_end;
+		end = get_max_mapped();
+		if (start + size < end)
+			mem = find_fw_memmap_area(start, end, size,
+						 sizeof(struct early_res));
+	}
+	if (mem == -1ULL)
+		panic("can not find more space for early_res array");
+
+	new = __va(mem);
+	/* save the first one for own */
+	new[0].start = mem;
+	new[0].end = mem + size;
+	new[0].overlap_ok = 0;
+	/* copy old to new */
+	if (early_res == early_res_x) {
+		memcpy(&new[1], &early_res[0],
+			 sizeof(struct early_res) * max_early_res);
+		memset(&new[max_early_res+1], 0,
+			 sizeof(struct early_res) * (max_early_res - 1));
+		early_res_count++;
+	} else {
+		memcpy(&new[1], &early_res[1],
+			 sizeof(struct early_res) * (max_early_res - 1));
+		memset(&new[max_early_res], 0,
+			 sizeof(struct early_res) * max_early_res);
+	}
+	memset(&early_res[0], 0, sizeof(struct early_res) * max_early_res);
+	early_res = new;
+	max_early_res *= 2;
+	printk(KERN_DEBUG "early_res array is doubled to %d at [%llx - %llx]\n",
+		max_early_res, mem, mem + size - 1);
+}
+
+/*
+ * Most early reservations come here.
+ *
+ * We first have drop_overlaps_that_are_ok() drop any pre-existing
+ * 'overlap_ok' ranges, so that we can then reserve this memory
+ * range without risk of panic'ing on an overlapping overlap_ok
+ * early reservation.
+ */
+void __init reserve_early(u64 start, u64 end, char *name)
+{
+	if (start >= end)
+		return;
+
+	__check_and_double_early_res(start, end);
+
+	drop_overlaps_that_are_ok(start, end);
+	__reserve_early(start, end, name, 0);
+}
+
+void __init reserve_early_without_check(u64 start, u64 end, char *name)
+{
+	struct early_res *r;
+
+	if (start >= end)
+		return;
+
+	__check_and_double_early_res(start, end);
+
+	r = &early_res[early_res_count];
+
+	r->start = start;
+	r->end = end;
+	r->overlap_ok = 0;
+	if (name)
+		strncpy(r->name, name, sizeof(r->name) - 1);
+	early_res_count++;
+}
+
+void __init free_early(u64 start, u64 end)
+{
+	struct early_res *r;
+	int i;
+
+	i = find_overlapped_early(start, end);
+	r = &early_res[i];
+	if (i >= max_early_res || r->end != end || r->start != start)
+		panic("free_early on not reserved area: %llx-%llx!",
+			 start, end - 1);
+
+	drop_range(i);
+}
+
+#ifdef CONFIG_NO_BOOTMEM
+static void __init subtract_early_res(struct range *range, int az)
+{
+	int i, count;
+	u64 final_start, final_end;
+	int idx = 0;
+
+	count  = 0;
+	for (i = 0; i < max_early_res && early_res[i].end; i++)
+		count++;
+
+	/* need to skip first one ?*/
+	if (early_res != early_res_x)
+		idx = 1;
+
+#define DEBUG_PRINT_EARLY_RES 1
+
+#if DEBUG_PRINT_EARLY_RES
+	printk(KERN_INFO "Subtract (%d early reservations)\n", count);
+#endif
+	for (i = idx; i < count; i++) {
+		struct early_res *r = &early_res[i];
+#if DEBUG_PRINT_EARLY_RES
+		printk(KERN_INFO "  #%d [%010llx - %010llx] %15s\n", i,
+			r->start, r->end, r->name);
+#endif
+		final_start = PFN_DOWN(r->start);
+		final_end = PFN_UP(r->end);
+		if (final_start >= final_end)
+			continue;
+		subtract_range(range, az, final_start, final_end);
+	}
+
+}
+
+int __init get_free_all_memory_range(struct range **rangep, int nodeid)
+{
+	int i, count;
+	u64 start = 0, end;
+	u64 size;
+	u64 mem;
+	struct range *range;
+	int nr_range;
+
+	count  = 0;
+	for (i = 0; i < max_early_res && early_res[i].end; i++)
+		count++;
+
+	count *= 2;
+
+	size = sizeof(struct range) * count;
+	end = get_max_mapped();
+#ifdef MAX_DMA32_PFN
+	if (end > (MAX_DMA32_PFN << PAGE_SHIFT))
+		start = MAX_DMA32_PFN << PAGE_SHIFT;
+#endif
+	mem = find_fw_memmap_area(start, end, size, sizeof(struct range));
+	if (mem == -1ULL)
+		panic("can not find more space for range free");
+
+	range = __va(mem);
+	/* use early_node_map[] and early_res to get range array at first */
+	memset(range, 0, size);
+	nr_range = 0;
+
+	/* need to go over early_node_map to find out good range for node */
+	nr_range = add_from_early_node_map(range, count, nr_range, nodeid);
+#ifdef CONFIG_X86_32
+	subtract_range(range, count, max_low_pfn, -1ULL);
+#endif
+	subtract_early_res(range, count);
+	nr_range = clean_sort_range(range, count);
+
+	/* need to clear it ? */
+	if (nodeid == MAX_NUMNODES) {
+		memset(&early_res[0], 0,
+			 sizeof(struct early_res) * max_early_res);
+		early_res = NULL;
+		max_early_res = 0;
+	}
+
+	*rangep = range;
+	return nr_range;
+}
+#else
+void __init early_res_to_bootmem(u64 start, u64 end)
+{
+	int i, count;
+	u64 final_start, final_end;
+	int idx = 0;
+
+	count  = 0;
+	for (i = 0; i < max_early_res && early_res[i].end; i++)
+		count++;
+
+	/* need to skip first one ?*/
+	if (early_res != early_res_x)
+		idx = 1;
+
+	printk(KERN_INFO "(%d/%d early reservations) ==> bootmem [%010llx - %010llx]\n",
+			 count - idx, max_early_res, start, end);
+	for (i = idx; i < count; i++) {
+		struct early_res *r = &early_res[i];
+		printk(KERN_INFO "  #%d [%010llx - %010llx] %16s", i,
+			r->start, r->end, r->name);
+		final_start = max(start, r->start);
+		final_end = min(end, r->end);
+		if (final_start >= final_end) {
+			printk(KERN_CONT "\n");
+			continue;
+		}
+		printk(KERN_CONT " ==> [%010llx - %010llx]\n",
+			final_start, final_end);
+		reserve_bootmem_generic(final_start, final_end - final_start,
+				BOOTMEM_DEFAULT);
+	}
+	/* clear them */
+	memset(&early_res[0], 0, sizeof(struct early_res) * max_early_res);
+	early_res = NULL;
+	max_early_res = 0;
+	early_res_count = 0;
+}
+#endif
+
+/* Check for already reserved areas */
+static inline int __init bad_addr(u64 *addrp, u64 size, u64 align)
+{
+	int i;
+	u64 addr = *addrp;
+	int changed = 0;
+	struct early_res *r;
+again:
+	i = find_overlapped_early(addr, addr + size);
+	r = &early_res[i];
+	if (i < max_early_res && r->end) {
+		*addrp = addr = round_up(r->end, align);
+		changed = 1;
+		goto again;
+	}
+	return changed;
+}
+
+/* Check for already reserved areas */
+static inline int __init bad_addr_size(u64 *addrp, u64 *sizep, u64 align)
+{
+	int i;
+	u64 addr = *addrp, last;
+	u64 size = *sizep;
+	int changed = 0;
+again:
+	last = addr + size;
+	for (i = 0; i < max_early_res && early_res[i].end; i++) {
+		struct early_res *r = &early_res[i];
+		if (last > r->start && addr < r->start) {
+			size = r->start - addr;
+			changed = 1;
+			goto again;
+		}
+		if (last > r->end && addr < r->end) {
+			addr = round_up(r->end, align);
+			size = last - addr;
+			changed = 1;
+			goto again;
+		}
+		if (last <= r->end && addr >= r->start) {
+			(*sizep)++;
+			return 0;
+		}
+	}
+	if (changed) {
+		*addrp = addr;
+		*sizep = size;
+	}
+	return changed;
+}
+
+/*
+ * Find a free area with specified alignment in a specific range.
+ * only with the area.between start to end is active range from early_node_map
+ * so they are good as RAM
+ */
+u64 __init find_early_area(u64 ei_start, u64 ei_last, u64 start, u64 end,
+			 u64 size, u64 align)
+{
+	u64 addr, last;
+
+	addr = round_up(ei_start, align);
+	if (addr < start)
+		addr = round_up(start, align);
+	if (addr >= ei_last)
+		goto out;
+	while (bad_addr(&addr, size, align) && addr+size <= ei_last)
+		;
+	last = addr + size;
+	if (last > ei_last)
+		goto out;
+	if (last > end)
+		goto out;
+
+	return addr;
+
+out:
+	return -1ULL;
+}
+
+u64 __init find_early_area_size(u64 ei_start, u64 ei_last, u64 start,
+			 u64 *sizep, u64 align)
+{
+	u64 addr, last;
+
+	addr = round_up(ei_start, align);
+	if (addr < start)
+		addr = round_up(start, align);
+	if (addr >= ei_last)
+		goto out;
+	*sizep = ei_last - addr;
+	while (bad_addr_size(&addr, sizep, align) && addr + *sizep <= ei_last)
+		;
+	last = addr + *sizep;
+	if (last > ei_last)
+		goto out;
+
+	return addr;
+
+out:
+	return -1ULL;
+}
+
+
Index: linux-2.6/arch/x86/Kconfig
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig
+++ linux-2.6/arch/x86/Kconfig
@@ -184,6 +184,9 @@ config ARCH_SUPPORTS_OPTIMIZED_INLINING
 config ARCH_SUPPORTS_DEBUG_PAGEALLOC
 	def_bool y
 
+config HAVE_EARLY_RES
+	def_bool y
+
 config HAVE_INTEL_TXT
 	def_bool y
 	depends on EXPERIMENTAL && DMAR && ACPI
