Return-Path: <linux-kernel-owner+w=401wt.eu-S1756075AbYCUG4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075AbYCUG4z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 02:56:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753883AbYCUG4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 02:56:32 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:53848 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547AbYCUG4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 02:56:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=reply-to:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=NPmJInRhGlEGNsG5si7Ux3dzZwURGhQVGTlWZlol9SI5ltWRLhd9o7Yw08AgF6r+aN3p33wijrstmqTWkojFzDNyoT7b5XiWj/nLuLos4Mtr0VAAzwqE8aqCIUi8t95xjDX9owzxDtZNnUVl4BPaQIx6TiiF3LqjcVKYkKOTqjM=
Reply-To: yhlu.kernel@gmail.com
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86_64: early memtest to find bad ram
Date: Thu, 20 Mar 2008 23:58:33 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: kernel list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803202358.33722.yhlu.kernel@gmail.com>
From: Yinghai Lu <yhlu.kernel.send@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


do simple memtest after init_memory_mapping

use find_e820_area_size to find all ram range that is not reserved.

and do some simple bits test to find some bad ram.

if find some bad ram, use reserve_early to exclude that range.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/arch/x86/kernel/e820_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820_64.c
+++ linux-2.6/arch/x86/kernel/e820_64.c
@@ -119,6 +119,40 @@ again:
 	return changed;
 }
 
+/* Check for already reserved areas */
+static inline int
+bad_addr_size(unsigned long *addrp, unsigned long *sizep, unsigned long align)
+{
+	int i;
+	unsigned long addr = *addrp, last;
+	unsigned long size = *sizep;
+	int changed = 0;
+again:
+	last = addr + size;
+	for (i = 0; i < MAX_EARLY_RES && early_res[i].end; i++) {
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
 /*
  * This function checks if any part of the range <start,end> is mapped
  * with type.
@@ -195,7 +229,7 @@ unsigned long __init find_e820_area(unsi
 		ei_last = ei->addr + ei->size;
 		if (addr < start)
 			addr = round_up(start, align);
-		if (addr > ei_last)
+		if (addr >= ei_last)
 			continue;
 		while (bad_addr(&addr, size, align) && addr+size <= ei_last)
 			;
@@ -210,6 +244,40 @@ unsigned long __init find_e820_area(unsi
 }
 
 /*
+ * Find next free range after *start
+ */
+unsigned long __init find_e820_area_size(unsigned long start, unsigned long *sizep, unsigned long align)
+{
+	int i;
+
+	for (i = 0; i < e820.nr_map; i++) {
+		struct e820entry *ei = &e820.map[i];
+		unsigned long addr, last;
+		unsigned long ei_last;
+
+		if (ei->type != E820_RAM)
+			continue;
+		addr = round_up(ei->addr, align);
+		ei_last = ei->addr + ei->size;
+//		printk(KERN_DEBUG "find_e820_area_size : e820 %d [%llx, %lx]\n", i, ei->addr, ei_last);
+		if (addr < start)
+			addr = round_up(start, align);
+//		printk(KERN_DEBUG "find_e820_area_size : 0 [%lx, %lx]\n", addr, ei_last);
+		if (addr >= ei_last)
+			continue;
+		*sizep = ei_last - addr;
+		while (bad_addr_size(&addr, sizep, align) && addr+ *sizep <= ei_last)
+			;
+		last = addr + *sizep;
+//		printk(KERN_DEBUG "find_e820_area_size : 1 [%lx, %lx]\n", addr, last);
+		if (last > ei_last)
+			continue;
+		return addr;
+	}
+	return -1UL;
+
+}
+/*
  * Find the highest page frame number we have available
  */
 unsigned long __init e820_end_of_ram(void)
Index: linux-2.6/arch/x86/mm/init_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_64.c
+++ linux-2.6/arch/x86/mm/init_64.c
@@ -427,6 +427,106 @@ static void __init init_gbpages(void)
 		direct_gbpages = 0;
 }
 
+static void __init memtest(unsigned long start_phys, unsigned long size, unsigned pattern)
+{
+	unsigned long i;
+	unsigned long *start;
+	unsigned long start_bad;
+	unsigned long last_bad;
+	unsigned long val;
+	unsigned long start_phys_aligned;
+	unsigned long count;
+	unsigned long incr;
+
+	switch (pattern) {
+	case 0:
+		val = 0UL;
+		break;
+	case 1:
+		val = -1UL;
+		break;
+	case 2:
+		val = 0x5555555555555555UL;
+		break;
+	case 3:
+		val = 0xaaaaaaaaaaaaaaaaUL;
+		break;
+	default:
+		return;
+	}
+
+	incr = sizeof(unsigned long);
+	start_phys_aligned = ALIGN(start_phys, incr);
+	count = (size - (start_phys_aligned - start_phys))/incr;
+	start = __va(start_phys_aligned);
+	start_bad = 0;
+	last_bad = 0;
+
+	for (i = 0; i < count; i++)
+		start[i] = val;
+	for (i = 0; i < count; i++, start++, start_phys_aligned += incr) {
+		if (*start != val) {
+			if (start_phys_aligned == last_bad + incr) {
+				last_bad += incr;
+			} else {
+				if (start_bad) {
+					printk(KERN_INFO "  %016lxx bad mem addr %016lx - %016lx reserved\n",
+						val, start_bad, last_bad + incr);
+					reserve_early(start_bad, last_bad - start_bad, "BAD RAM");
+				}
+				start_bad = last_bad = start_phys_aligned;
+			}
+		}
+	}
+	if (start_bad) {
+		printk(KERN_INFO "  %016lx bad mem addr %016lx - %016lx reserved\n",
+			val, start_bad, last_bad + incr);
+		reserve_early(start_bad, last_bad - start_bad, "BAD RAM");
+	}
+
+}
+
+static int __initdata memtest_pattern;
+static int __init parse_memtest(char *arg)
+{
+	if (arg)
+		memtest_pattern = simple_strtoul(arg, NULL, 0) + 1;
+	return 0;
+}
+
+early_param("memtest", parse_memtest);
+
+static void __init early_memtest(unsigned long start, unsigned long end)
+{
+	unsigned long t_start, t_size;
+	unsigned pattern;
+
+	if (memtest_pattern)
+		printk(KERN_INFO "early_memtest: pattern num %d", memtest_pattern);
+	for (pattern = 0; pattern < memtest_pattern; pattern++) {
+		t_start = start;
+		t_size = 0;
+		while (t_start < end) {
+			t_start = find_e820_area_size(t_start, &t_size, 1);
+
+			/* done ? */
+			if (t_start >= end)
+				break;
+			if (t_start + t_size > end)
+				t_size = end - t_start;
+
+			printk(KERN_CONT "\n  %016lx - %016lx pattern %d",
+				t_start, t_start + t_size, pattern);
+
+			memtest(t_start, t_size, pattern);
+
+			t_start += t_size;
+		}
+	}
+	if (memtest_pattern)
+		printk(KERN_CONT "\n");
+}
+
 /*
  * Setup the direct mapping of the physical memory at PAGE_OFFSET.
  * This runs before bootmem is initialized and gets pages directly from
@@ -435,8 +535,9 @@ static void __init init_gbpages(void)
 void __init_refok init_memory_mapping(unsigned long start, unsigned long end)
 {
 	unsigned long next;
+	unsigned long start_phys = start, end_phys = end;
 
-	pr_debug("init_memory_mapping\n");
+	printk(KERN_INFO "init_memory_mapping\n");
 
 	/*
 	 * Find space for the kernel direct mapping tables.
@@ -479,6 +580,9 @@ void __init_refok init_memory_mapping(un
 	if (!after_bootmem)
 		reserve_early(table_start << PAGE_SHIFT,
 				 table_end << PAGE_SHIFT, "PGTABLE");
+
+	if (!after_bootmem)
+		early_memtest(start_phys, end_phys);
 }
 
 #ifndef CONFIG_NUMA
Index: linux-2.6/include/asm-x86/e820_64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/e820_64.h
+++ linux-2.6/include/asm-x86/e820_64.h
@@ -16,6 +16,9 @@
 #ifndef __ASSEMBLY__
 extern unsigned long find_e820_area(unsigned long start, unsigned long end, 
 				    unsigned long size, unsigned long align);
+extern unsigned long find_e820_area_size(unsigned long start,
+					 unsigned long *sizep,
+					 unsigned long align);
 extern void add_memory_region(unsigned long start, unsigned long size, 
 			      int type);
 extern void update_memory_range(u64 start, u64 size, unsigned old_type,
