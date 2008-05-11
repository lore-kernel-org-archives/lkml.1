Return-Path: <linux-kernel-owner+w=401wt.eu-S1753581AbYEKHaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581AbYEKHaW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 03:30:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751339AbYEKHaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 03:30:09 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:34160 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbYEKHaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 03:30:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=PfCRLVmgMKm/7fopaEPpzGF1+pBKG4vq2koFResK8gWlucS+Oct96zVVdbkQ4pqtLFunzHnwJ6TX5vL9AjaIdPBF5ADb5RGVgIFXmk9k3cOSiIPj83ydmCVXOpVCtUpwjXfgwiPUHQ8KcELiX7CaqNsTizn1EcaB/4+YHogSU2c=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] x86: make e820.c to have common functions
Date: Sun, 11 May 2008 00:30:15 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805110030.15510.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


remove the duplicated copy of these functions.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

 arch/x86/kernel/Makefile   |    2
 arch/x86/kernel/e820.c     |  475 +++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/e820_32.c  |  411 --------------------------------------
 arch/x86/kernel/e820_64.c  |  444 ------------------------------------------
 arch/x86/kernel/setup_32.c |    2
 include/asm-x86/e820.h     |   14 +
 include/asm-x86/e820_32.h  |   12 -
 include/asm-x86/e820_64.h  |   12 -
 8 files changed, 496 insertions(+), 876 deletions(-)


Index: linux-2.6/arch/x86/kernel/Makefile
===================================================================
--- linux-2.6.orig/arch/x86/kernel/Makefile
+++ linux-2.6/arch/x86/kernel/Makefile
@@ -31,7 +31,7 @@ obj-y			+= setup_$(BITS).o i8259_$(BITS)
 obj-$(CONFIG_X86_32)	+= sys_i386_32.o i386_ksyms_32.o
 obj-$(CONFIG_X86_64)	+= sys_x86_64.o x8664_ksyms_64.o
 obj-$(CONFIG_X86_64)	+= syscall_64.o vsyscall_64.o setup64.o
-obj-y			+= bootflag.o e820_$(BITS).o
+obj-y			+= bootflag.o e820_$(BITS).o e820.o
 obj-y			+= pci-dma.o quirks.o i8237.o topology.o kdebugfs.o
 obj-y			+= alternative.o i8253.o pci-nommu.o
 obj-$(CONFIG_X86_64)	+= bugs_64.o
Index: linux-2.6/arch/x86/kernel/e820_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820_32.c
+++ linux-2.6/arch/x86/kernel/e820_32.c
@@ -16,21 +16,6 @@
 #include <asm/e820.h>
 #include <asm/setup.h>
 
-struct e820map e820;
-struct change_member {
-	struct e820entry *pbios; /* pointer to original bios entry */
-	unsigned long long addr; /* address for this change point */
-};
-static struct change_member change_point_list[2*E820MAX] __initdata;
-static struct change_member *change_point[2*E820MAX] __initdata;
-static struct e820entry *overlap_list[E820MAX] __initdata;
-static struct e820entry new_bios[E820MAX] __initdata;
-/* For PCI or other memory-mapped resources */
-unsigned long pci_mem_start = 0x10000000;
-#ifdef CONFIG_PCI
-EXPORT_SYMBOL(pci_mem_start);
-#endif
-
 static struct resource system_rom_resource = {
 	.name	= "System ROM",
 	.start	= 0xf0000,
@@ -254,223 +239,6 @@ void __init e820_mark_nosave_regions(voi
 }
 #endif
 
-void __init add_memory_region(unsigned long long start,
-			      unsigned long long size, int type)
-{
-	int x;
-
-	x = e820.nr_map;
-
-	if (x == E820MAX) {
-		printk(KERN_ERR "Ooops! Too many entries in the memory map!\n");
-		return;
-	}
-
-	e820.map[x].addr = start;
-	e820.map[x].size = size;
-	e820.map[x].type = type;
-	e820.nr_map++;
-} /* add_memory_region */
-
-/*
- * Sanitize the BIOS e820 map.
- *
- * Some e820 responses include overlapping entries.  The following
- * replaces the original e820 map with a new one, removing overlaps.
- *
- */
-int __init sanitize_e820_map(struct e820entry * biosmap, char * pnr_map)
-{
-	struct change_member *change_tmp;
-	unsigned long current_type, last_type;
-	unsigned long long last_addr;
-	int chgidx, still_changing;
-	int overlap_entries;
-	int new_bios_entry;
-	int old_nr, new_nr, chg_nr;
-	int i;
-
-	/*
-		Visually we're performing the following (1,2,3,4 = memory types)...
-
-		Sample memory map (w/overlaps):
-		   ____22__________________
-		   ______________________4_
-		   ____1111________________
-		   _44_____________________
-		   11111111________________
-		   ____________________33__
-		   ___________44___________
-		   __________33333_________
-		   ______________22________
-		   ___________________2222_
-		   _________111111111______
-		   _____________________11_
-		   _________________4______
-
-		Sanitized equivalent (no overlap):
-		   1_______________________
-		   _44_____________________
-		   ___1____________________
-		   ____22__________________
-		   ______11________________
-		   _________1______________
-		   __________3_____________
-		   ___________44___________
-		   _____________33_________
-		   _______________2________
-		   ________________1_______
-		   _________________4______
-		   ___________________2____
-		   ____________________33__
-		   ______________________4_
-	*/
-	/* if there's only one memory region, don't bother */
-	if (*pnr_map < 2) {
-		return -1;
-	}
-
-	old_nr = *pnr_map;
-
-	/* bail out if we find any unreasonable addresses in bios map */
-	for (i=0; i<old_nr; i++)
-		if (biosmap[i].addr + biosmap[i].size < biosmap[i].addr) {
-			return -1;
-		}
-
-	/* create pointers for initial change-point information (for sorting) */
-	for (i=0; i < 2*old_nr; i++)
-		change_point[i] = &change_point_list[i];
-
-	/* record all known change-points (starting and ending addresses),
-	   omitting those that are for empty memory regions */
-	chgidx = 0;
-	for (i=0; i < old_nr; i++)	{
-		if (biosmap[i].size != 0) {
-			change_point[chgidx]->addr = biosmap[i].addr;
-			change_point[chgidx++]->pbios = &biosmap[i];
-			change_point[chgidx]->addr = biosmap[i].addr + biosmap[i].size;
-			change_point[chgidx++]->pbios = &biosmap[i];
-		}
-	}
-	chg_nr = chgidx;    	/* true number of change-points */
-
-	/* sort change-point list by memory addresses (low -> high) */
-	still_changing = 1;
-	while (still_changing)	{
-		still_changing = 0;
-		for (i=1; i < chg_nr; i++)  {
-			/* if <current_addr> > <last_addr>, swap */
-			/* or, if current=<start_addr> & last=<end_addr>, swap */
-			if ((change_point[i]->addr < change_point[i-1]->addr) ||
-				((change_point[i]->addr == change_point[i-1]->addr) &&
-				 (change_point[i]->addr == change_point[i]->pbios->addr) &&
-				 (change_point[i-1]->addr != change_point[i-1]->pbios->addr))
-			   )
-			{
-				change_tmp = change_point[i];
-				change_point[i] = change_point[i-1];
-				change_point[i-1] = change_tmp;
-				still_changing=1;
-			}
-		}
-	}
-
-	/* create a new bios memory map, removing overlaps */
-	overlap_entries=0;	 /* number of entries in the overlap table */
-	new_bios_entry=0;	 /* index for creating new bios map entries */
-	last_type = 0;		 /* start with undefined memory type */
-	last_addr = 0;		 /* start with 0 as last starting address */
-	/* loop through change-points, determining affect on the new bios map */
-	for (chgidx=0; chgidx < chg_nr; chgidx++)
-	{
-		/* keep track of all overlapping bios entries */
-		if (change_point[chgidx]->addr == change_point[chgidx]->pbios->addr)
-		{
-			/* add map entry to overlap list (> 1 entry implies an overlap) */
-			overlap_list[overlap_entries++]=change_point[chgidx]->pbios;
-		}
-		else
-		{
-			/* remove entry from list (order independent, so swap with last) */
-			for (i=0; i<overlap_entries; i++)
-			{
-				if (overlap_list[i] == change_point[chgidx]->pbios)
-					overlap_list[i] = overlap_list[overlap_entries-1];
-			}
-			overlap_entries--;
-		}
-		/* if there are overlapping entries, decide which "type" to use */
-		/* (larger value takes precedence -- 1=usable, 2,3,4,4+=unusable) */
-		current_type = 0;
-		for (i=0; i<overlap_entries; i++)
-			if (overlap_list[i]->type > current_type)
-				current_type = overlap_list[i]->type;
-		/* continue building up new bios map based on this information */
-		if (current_type != last_type)	{
-			if (last_type != 0)	 {
-				new_bios[new_bios_entry].size =
-					change_point[chgidx]->addr - last_addr;
-				/* move forward only if the new size was non-zero */
-				if (new_bios[new_bios_entry].size != 0)
-					if (++new_bios_entry >= E820MAX)
-						break; 	/* no more space left for new bios entries */
-			}
-			if (current_type != 0)	{
-				new_bios[new_bios_entry].addr = change_point[chgidx]->addr;
-				new_bios[new_bios_entry].type = current_type;
-				last_addr=change_point[chgidx]->addr;
-			}
-			last_type = current_type;
-		}
-	}
-	new_nr = new_bios_entry;   /* retain count for new bios entries */
-
-	/* copy new bios mapping into original location */
-	memcpy(biosmap, new_bios, new_nr*sizeof(struct e820entry));
-	*pnr_map = new_nr;
-
-	return 0;
-}
-
-/*
- * Copy the BIOS e820 map into a safe place.
- *
- * Sanity-check it while we're at it..
- *
- * If we're lucky and live on a modern system, the setup code
- * will have given us a memory map that we can use to properly
- * set up memory.  If we aren't, we'll fake a memory map.
- *
- * We check to see that the memory map contains at least 2 elements
- * before we'll use it, because the detection code in setup.S may
- * not be perfect and most every PC known to man has two memory
- * regions: one from 0 to 640k, and one from 1mb up.  (The IBM
- * thinkpad 560x, for example, does not cooperate with the memory
- * detection code.)
- */
-int __init copy_e820_map(struct e820entry *biosmap, int nr_map)
-{
-	/* Only one memory region (or negative)? Ignore it */
-	if (nr_map < 2)
-		return -1;
-
-	do {
-		u64 start = biosmap->addr;
-		u64 size = biosmap->size;
-		u64 end = start + size;
-		u32 type = biosmap->type;
-
-		/* Overflow in 64 bits? Ignore the memory map. */
-		if (start > end)
-			return -1;
-
-		add_memory_region(start, size, type);
-	} while (biosmap++, --nr_map);
-
-	return 0;
-}
-
 /*
  * Find the highest page frame number we have available
  */
@@ -535,86 +303,12 @@ void __init register_bootmem_low_pages(u
 	}
 }
 
-void __init e820_register_memory(void)
-{
-	unsigned long gapstart, gapsize, round;
-	unsigned long long last;
-	int i;
-
-	/*
-	 * Search for the biggest gap in the low 32 bits of the e820
-	 * memory space.
-	 */
-	last = 0x100000000ull;
-	gapstart = 0x10000000;
-	gapsize = 0x400000;
-	i = e820.nr_map;
-	while (--i >= 0) {
-		unsigned long long start = e820.map[i].addr;
-		unsigned long long end = start + e820.map[i].size;
-
-		/*
-		 * Since "last" is at most 4GB, we know we'll
-		 * fit in 32 bits if this condition is true
-		 */
-		if (last > end) {
-			unsigned long gap = last - end;
-
-			if (gap > gapsize) {
-				gapsize = gap;
-				gapstart = end;
-			}
-		}
-		if (start < last)
-			last = start;
-	}
-
-	/*
-	 * See how much we want to round up: start off with
-	 * rounding to the next 1MB area.
-	 */
-	round = 0x100000;
-	while ((gapsize >> 4) > round)
-		round += round;
-	/* Fun with two's complement */
-	pci_mem_start = (gapstart + round) & -round;
-
-	printk("Allocating PCI resources starting at %08lx (gap: %08lx:%08lx)\n",
-		pci_mem_start, gapstart, gapsize);
-}
-
-static void __init print_memory_map(char *who)
-{
-	int i;
-
-	for (i = 0; i < e820.nr_map; i++) {
-		printk(" %s: %016Lx - %016Lx ", who,
-			e820.map[i].addr,
-			e820.map[i].addr + e820.map[i].size);
-		switch (e820.map[i].type) {
-		case E820_RAM:	printk("(usable)\n");
-				break;
-		case E820_RESERVED:
-				printk("(reserved)\n");
-				break;
-		case E820_ACPI:
-				printk("(ACPI data)\n");
-				break;
-		case E820_NVS:
-				printk("(ACPI NVS)\n");
-				break;
-		default:	printk("type %u\n", e820.map[i].type);
-				break;
-		}
-	}
-}
-
 void __init limit_regions(unsigned long long size)
 {
 	unsigned long long current_addr;
 	int i;
 
-	print_memory_map("limit_regions start");
+	e820_print_map("limit_regions start");
 	for (i = 0; i < e820.nr_map; i++) {
 		current_addr = e820.map[i].addr + e820.map[i].size;
 		if (current_addr < size)
@@ -633,62 +327,10 @@ void __init limit_regions(unsigned long 
 			e820.nr_map = i + 1;
 			e820.map[i].size -= current_addr - size;
 		}
-		print_memory_map("limit_regions endfor");
+		e820_print_map("limit_regions endfor");
 		return;
 	}
-	print_memory_map("limit_regions endfunc");
-}
-
-/*
- * This function checks if any part of the range <start,end> is mapped
- * with type.
- */
-int
-e820_any_mapped(u64 start, u64 end, unsigned type)
-{
-	int i;
-	for (i = 0; i < e820.nr_map; i++) {
-		const struct e820entry *ei = &e820.map[i];
-		if (type && ei->type != type)
-			continue;
-		if (ei->addr >= end || ei->addr + ei->size <= start)
-			continue;
-		return 1;
-	}
-	return 0;
-}
-EXPORT_SYMBOL_GPL(e820_any_mapped);
-
- /*
-  * This function checks if the entire range <start,end> is mapped with type.
-  *
-  * Note: this function only works correct if the e820 table is sorted and
-  * not-overlapping, which is the case
-  */
-int __init
-e820_all_mapped(unsigned long s, unsigned long e, unsigned type)
-{
-	u64 start = s;
-	u64 end = e;
-	int i;
-	for (i = 0; i < e820.nr_map; i++) {
-		struct e820entry *ei = &e820.map[i];
-		if (type && ei->type != type)
-			continue;
-		/* is the region (part) in overlap with the current region ?*/
-		if (ei->addr >= end || ei->addr + ei->size <= start)
-			continue;
-		/* if the region is at the beginning of <start,end> we move
-		 * start to the end of the region since it's ok until there
-		 */
-		if (ei->addr <= start)
-			start = ei->addr + ei->size;
-		/* if start is now at or beyond end, we're done, full
-		 * coverage */
-		if (start >= end)
-			return 1; /* we're done */
-	}
-	return 0;
+	e820_print_map("limit_regions endfunc");
 }
 
 /* Overridden in paravirt.c if CONFIG_PARAVIRT */
@@ -700,7 +342,7 @@ char * __init __attribute__((weak)) memo
 void __init setup_memory_map(void)
 {
 	printk(KERN_INFO "BIOS-provided physical RAM map:\n");
-	print_memory_map(memory_setup());
+	e820_print_map(memory_setup());
 }
 
 static int __initdata user_defined_memmap;
@@ -783,55 +425,12 @@ static int __init parse_memmap(char *arg
 	return 0;
 }
 early_param("memmap", parse_memmap);
-u64 __init update_memory_range(u64 start, u64 size, unsigned old_type,
-				unsigned new_type)
-{
-	int i;
-	u64 real_updated_size = 0;
-
-	BUG_ON(old_type == new_type);
-
-	for (i = 0; i < e820.nr_map; i++) {
-		struct e820entry *ei = &e820.map[i];
-		u64 final_start, final_end;
-		if (ei->type != old_type)
-			continue;
-		/* totally covered? */
-		if (ei->addr >= start &&
-		    (ei->addr + ei->size) <= (start + size)) {
-			ei->type = new_type;
-			real_updated_size += ei->size;
-			continue;
-		}
-		/* partially covered */
-		final_start = max(start, ei->addr);
-		final_end = min(start + size, ei->addr + ei->size);
-		if (final_start >= final_end)
-			continue;
-		add_memory_region(final_start, final_end - final_start,
-					 new_type);
-		real_updated_size += final_end - final_start;
-	}
-
-	return real_updated_size;
-}
 
 void __init finish_e820_parsing(void)
 {
 	if (user_defined_memmap) {
 		printk(KERN_INFO "user-defined physical RAM map:\n");
-		print_memory_map("user");
+		e820_print_map("user");
 	}
 }
 
-void __init update_e820(void)
-{
-	u8 nr_map;
-
-	nr_map = e820.nr_map;
-	if (sanitize_e820_map(e820.map, &nr_map))
-		return;
-	e820.nr_map = nr_map;
-	printk(KERN_INFO "modified physical RAM map:\n");
-	print_memory_map("modified");
-}
Index: linux-2.6/arch/x86/kernel/e820_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820_64.c
+++ linux-2.6/arch/x86/kernel/e820_64.c
@@ -30,8 +30,6 @@
 #include <asm/kdebug.h>
 #include <asm/trampoline.h>
 
-struct e820map e820;
-
 /*
  * PFN of last memory page.
  */
@@ -177,62 +175,6 @@ again:
 	}
 	return changed;
 }
-/*
- * This function checks if any part of the range <start,end> is mapped
- * with type.
- */
-int
-e820_any_mapped(unsigned long start, unsigned long end, unsigned type)
-{
-	int i;
-
-	for (i = 0; i < e820.nr_map; i++) {
-		struct e820entry *ei = &e820.map[i];
-
-		if (type && ei->type != type)
-			continue;
-		if (ei->addr >= end || ei->addr + ei->size <= start)
-			continue;
-		return 1;
-	}
-	return 0;
-}
-EXPORT_SYMBOL_GPL(e820_any_mapped);
-
-/*
- * This function checks if the entire range <start,end> is mapped with type.
- *
- * Note: this function only works correct if the e820 table is sorted and
- * not-overlapping, which is the case
- */
-int __init e820_all_mapped(unsigned long start, unsigned long end,
-			   unsigned type)
-{
-	int i;
-
-	for (i = 0; i < e820.nr_map; i++) {
-		struct e820entry *ei = &e820.map[i];
-
-		if (type && ei->type != type)
-			continue;
-		/* is the region (part) in overlap with the current region ?*/
-		if (ei->addr >= end || ei->addr + ei->size <= start)
-			continue;
-
-		/* if the region is at the beginning of <start,end> we move
-		 * start to the end of the region since it's ok until there
-		 */
-		if (ei->addr <= start)
-			start = ei->addr + ei->size;
-		/*
-		 * if start is now at or beyond end, we're done, full
-		 * coverage
-		 */
-		if (start >= end)
-			return 1;
-	}
-	return 0;
-}
 
 /*
  * Find a free area with specified alignment in a specific range.
@@ -436,24 +378,6 @@ e820_register_active_regions(int nid, un
 }
 
 /*
- * Add a memory region to the kernel e820 map.
- */
-void __init add_memory_region(unsigned long start, unsigned long size, int type)
-{
-	int x = e820.nr_map;
-
-	if (x == E820MAX) {
-		printk(KERN_ERR "Ooops! Too many entries in the memory map!\n");
-		return;
-	}
-
-	e820.map[x].addr = start;
-	e820.map[x].size = size;
-	e820.map[x].type = type;
-	e820.nr_map++;
-}
-
-/*
  * Find the hole size (in bytes) in the memory range.
  * @start: starting address of the memory range to scan
  * @end: ending address of the memory range to scan
@@ -474,266 +398,6 @@ unsigned long __init e820_hole_size(unsi
 	return end - start - (ram << PAGE_SHIFT);
 }
 
-static void __init e820_print_map(char *who)
-{
-	int i;
-
-	for (i = 0; i < e820.nr_map; i++) {
-		printk(KERN_INFO " %s: %016Lx - %016Lx ", who,
-		       (unsigned long long) e820.map[i].addr,
-		       (unsigned long long)
-		       (e820.map[i].addr + e820.map[i].size));
-		switch (e820.map[i].type) {
-		case E820_RAM:
-			printk(KERN_CONT "(usable)\n");
-			break;
-		case E820_RESERVED:
-			printk(KERN_CONT "(reserved)\n");
-			break;
-		case E820_ACPI:
-			printk(KERN_CONT "(ACPI data)\n");
-			break;
-		case E820_NVS:
-			printk(KERN_CONT "(ACPI NVS)\n");
-			break;
-		default:
-			printk(KERN_CONT "type %u\n", e820.map[i].type);
-			break;
-		}
-	}
-}
-
-/*
- * Sanitize the BIOS e820 map.
- *
- * Some e820 responses include overlapping entries. The following
- * replaces the original e820 map with a new one, removing overlaps.
- *
- */
-static int __init sanitize_e820_map(struct e820entry *biosmap, char *pnr_map)
-{
-	struct change_member {
-		struct e820entry *pbios; /* pointer to original bios entry */
-		unsigned long long addr; /* address for this change point */
-	};
-	static struct change_member change_point_list[2*E820MAX] __initdata;
-	static struct change_member *change_point[2*E820MAX] __initdata;
-	static struct e820entry *overlap_list[E820MAX] __initdata;
-	static struct e820entry new_bios[E820MAX] __initdata;
-	struct change_member *change_tmp;
-	unsigned long current_type, last_type;
-	unsigned long long last_addr;
-	int chgidx, still_changing;
-	int overlap_entries;
-	int new_bios_entry;
-	int old_nr, new_nr, chg_nr;
-	int i;
-
-	/*
-		Visually we're performing the following
-		(1,2,3,4 = memory types)...
-
-		Sample memory map (w/overlaps):
-		   ____22__________________
-		   ______________________4_
-		   ____1111________________
-		   _44_____________________
-		   11111111________________
-		   ____________________33__
-		   ___________44___________
-		   __________33333_________
-		   ______________22________
-		   ___________________2222_
-		   _________111111111______
-		   _____________________11_
-		   _________________4______
-
-		Sanitized equivalent (no overlap):
-		   1_______________________
-		   _44_____________________
-		   ___1____________________
-		   ____22__________________
-		   ______11________________
-		   _________1______________
-		   __________3_____________
-		   ___________44___________
-		   _____________33_________
-		   _______________2________
-		   ________________1_______
-		   _________________4______
-		   ___________________2____
-		   ____________________33__
-		   ______________________4_
-	*/
-
-	/* if there's only one memory region, don't bother */
-	if (*pnr_map < 2)
-		return -1;
-
-	old_nr = *pnr_map;
-
-	/* bail out if we find any unreasonable addresses in bios map */
-	for (i = 0; i < old_nr; i++)
-		if (biosmap[i].addr + biosmap[i].size < biosmap[i].addr)
-			return -1;
-
-	/* create pointers for initial change-point information (for sorting) */
-	for (i = 0; i < 2 * old_nr; i++)
-		change_point[i] = &change_point_list[i];
-
-	/* record all known change-points (starting and ending addresses),
-	   omitting those that are for empty memory regions */
-	chgidx = 0;
-	for (i = 0; i < old_nr; i++)	{
-		if (biosmap[i].size != 0) {
-			change_point[chgidx]->addr = biosmap[i].addr;
-			change_point[chgidx++]->pbios = &biosmap[i];
-			change_point[chgidx]->addr = biosmap[i].addr +
-				biosmap[i].size;
-			change_point[chgidx++]->pbios = &biosmap[i];
-		}
-	}
-	chg_nr = chgidx;
-
-	/* sort change-point list by memory addresses (low -> high) */
-	still_changing = 1;
-	while (still_changing)	{
-		still_changing = 0;
-		for (i = 1; i < chg_nr; i++)  {
-			unsigned long long curaddr, lastaddr;
-			unsigned long long curpbaddr, lastpbaddr;
-
-			curaddr = change_point[i]->addr;
-			lastaddr = change_point[i - 1]->addr;
-			curpbaddr = change_point[i]->pbios->addr;
-			lastpbaddr = change_point[i - 1]->pbios->addr;
-
-			/*
-			 * swap entries, when:
-			 *
-			 * curaddr > lastaddr or
-			 * curaddr == lastaddr and curaddr == curpbaddr and
-			 * lastaddr != lastpbaddr
-			 */
-			if (curaddr < lastaddr ||
-			    (curaddr == lastaddr && curaddr == curpbaddr &&
-			     lastaddr != lastpbaddr)) {
-				change_tmp = change_point[i];
-				change_point[i] = change_point[i-1];
-				change_point[i-1] = change_tmp;
-				still_changing = 1;
-			}
-		}
-	}
-
-	/* create a new bios memory map, removing overlaps */
-	overlap_entries = 0;	 /* number of entries in the overlap table */
-	new_bios_entry = 0;	 /* index for creating new bios map entries */
-	last_type = 0;		 /* start with undefined memory type */
-	last_addr = 0;		 /* start with 0 as last starting address */
-
-	/* loop through change-points, determining affect on the new bios map */
-	for (chgidx = 0; chgidx < chg_nr; chgidx++) {
-		/* keep track of all overlapping bios entries */
-		if (change_point[chgidx]->addr ==
-		    change_point[chgidx]->pbios->addr) {
-			/*
-			 * add map entry to overlap list (> 1 entry
-			 * implies an overlap)
-			 */
-			overlap_list[overlap_entries++] =
-				change_point[chgidx]->pbios;
-		} else {
-			/*
-			 * remove entry from list (order independent,
-			 * so swap with last)
-			 */
-			for (i = 0; i < overlap_entries; i++) {
-				if (overlap_list[i] ==
-				    change_point[chgidx]->pbios)
-					overlap_list[i] =
-						overlap_list[overlap_entries-1];
-			}
-			overlap_entries--;
-		}
-		/*
-		 * if there are overlapping entries, decide which
-		 * "type" to use (larger value takes precedence --
-		 * 1=usable, 2,3,4,4+=unusable)
-		 */
-		current_type = 0;
-		for (i = 0; i < overlap_entries; i++)
-			if (overlap_list[i]->type > current_type)
-				current_type = overlap_list[i]->type;
-		/*
-		 * continue building up new bios map based on this
-		 * information
-		 */
-		if (current_type != last_type)	{
-			if (last_type != 0)	 {
-				new_bios[new_bios_entry].size =
-					change_point[chgidx]->addr - last_addr;
-				/*
-				 * move forward only if the new size
-				 * was non-zero
-				 */
-				if (new_bios[new_bios_entry].size != 0)
-					/*
-					 * no more space left for new
-					 * bios entries ?
-					 */
-					if (++new_bios_entry >= E820MAX)
-						break;
-			}
-			if (current_type != 0)	{
-				new_bios[new_bios_entry].addr =
-					change_point[chgidx]->addr;
-				new_bios[new_bios_entry].type = current_type;
-				last_addr = change_point[chgidx]->addr;
-			}
-			last_type = current_type;
-		}
-	}
-	/* retain count for new bios entries */
-	new_nr = new_bios_entry;
-
-	/* copy new bios mapping into original location */
-	memcpy(biosmap, new_bios, new_nr * sizeof(struct e820entry));
-	*pnr_map = new_nr;
-
-	return 0;
-}
-
-/*
- * Copy the BIOS e820 map into a safe place.
- *
- * Sanity-check it while we're at it..
- *
- * If we're lucky and live on a modern system, the setup code
- * will have given us a memory map that we can use to properly
- * set up memory.  If we aren't, we'll fake a memory map.
- */
-static int __init copy_e820_map(struct e820entry *biosmap, int nr_map)
-{
-	/* Only one memory region (or negative)? Ignore it */
-	if (nr_map < 2)
-		return -1;
-
-	do {
-		u64 start = biosmap->addr;
-		u64 size = biosmap->size;
-		u64 end = start + size;
-		u32 type = biosmap->type;
-
-		/* Overflow in 64 bits? Ignore the memory map. */
-		if (start > end)
-			return -1;
-
-		add_memory_region(start, size, type);
-	} while (biosmap++, --nr_map);
-	return 0;
-}
-
 static void early_panic(char *msg)
 {
 	early_printk(msg);
@@ -830,114 +494,6 @@ void __init finish_e820_parsing(void)
 	}
 }
 
-u64 __init update_memory_range(u64 start, u64 size, unsigned old_type,
-				unsigned new_type)
-{
-	int i;
-	u64 real_updated_size = 0;
-
-	BUG_ON(old_type == new_type);
-
-	for (i = 0; i < e820.nr_map; i++) {
-		struct e820entry *ei = &e820.map[i];
-		u64 final_start, final_end;
-		if (ei->type != old_type)
-			continue;
-		/* totally covered? */
-		if (ei->addr >= start &&
-		    (ei->addr + ei->size) <= (start + size)) {
-			ei->type = new_type;
-			real_updated_size += ei->size;
-			continue;
-		}
-		/* partially covered */
-		final_start = max(start, ei->addr);
-		final_end = min(start + size, ei->addr + ei->size);
-		if (final_start >= final_end)
-			continue;
-		add_memory_region(final_start, final_end - final_start,
-					 new_type);
-		real_updated_size += final_end - final_start;
-	}
-	return real_updated_size;
-}
-
-void __init update_e820(void)
-{
-	u8 nr_map;
-
-	nr_map = e820.nr_map;
-	if (sanitize_e820_map(e820.map, &nr_map))
-		return;
-	e820.nr_map = nr_map;
-	printk(KERN_INFO "modified physical RAM map:\n");
-	e820_print_map("modified");
-}
-
-unsigned long pci_mem_start = 0xaeedbabe;
-EXPORT_SYMBOL(pci_mem_start);
-
-/*
- * Search for the biggest gap in the low 32 bits of the e820
- * memory space.  We pass this space to PCI to assign MMIO resources
- * for hotplug or unconfigured devices in.
- * Hopefully the BIOS let enough space left.
- */
-__init void e820_setup_gap(void)
-{
-	unsigned long gapstart, gapsize, round;
-	unsigned long last;
-	int i;
-	int found = 0;
-
-	last = 0x100000000ull;
-	gapstart = 0x10000000;
-	gapsize = 0x400000;
-	i = e820.nr_map;
-	while (--i >= 0) {
-		unsigned long long start = e820.map[i].addr;
-		unsigned long long end = start + e820.map[i].size;
-
-		/*
-		 * Since "last" is at most 4GB, we know we'll
-		 * fit in 32 bits if this condition is true
-		 */
-		if (last > end) {
-			unsigned long gap = last - end;
-
-			if (gap > gapsize) {
-				gapsize = gap;
-				gapstart = end;
-				found = 1;
-			}
-		}
-		if (start < last)
-			last = start;
-	}
-
-	if (!found) {
-		gapstart = (end_pfn << PAGE_SHIFT) + 1024*1024;
-		printk(KERN_ERR "PCI: Warning: Cannot find a gap in the 32bit "
-		       "address range\n"
-		       KERN_ERR "PCI: Unassigned devices with 32bit resource "
-		       "registers may break!\n");
-	}
-
-	/*
-	 * See how much we want to round up: start off with
-	 * rounding to the next 1MB area.
-	 */
-	round = 0x100000;
-	while ((gapsize >> 4) > round)
-		round += round;
-	/* Fun with two's complement */
-	pci_mem_start = (gapstart + round) & -round;
-
-	printk(KERN_INFO
-	       "Allocating PCI resources starting at %lx (gap: %lx:%lx)\n",
-	       pci_mem_start, gapstart, gapsize);
-}
-
 int __init arch_get_ram_range(int slot, u64 *addr, u64 *size)
 {
 	int i;
Index: linux-2.6/include/asm-x86/e820.h
===================================================================
--- linux-2.6.orig/include/asm-x86/e820.h
+++ linux-2.6/include/asm-x86/e820.h
@@ -20,6 +20,20 @@ struct e820map {
 	__u32 nr_map;
 	struct e820entry map[E820MAX];
 };
+
+extern struct e820map e820;
+
+extern int e820_any_mapped(u64 start, u64 end, unsigned type);
+extern int e820_all_mapped(u64 start, u64 end, unsigned type);
+extern void add_memory_region(u64 start, u64 size, int type);
+extern void e820_print_map(char *who);
+extern int sanitize_e820_map(struct e820entry *biosmap, char *pnr_map);
+extern int copy_e820_map(struct e820entry *biosmap, int nr_map);
+extern u64 update_memory_range(u64 start, u64 size, unsigned old_type,
+                                unsigned new_type);
+extern void update_e820(void);
+extern void e820_setup_gap(void);
+
 #endif /* __ASSEMBLY__ */
 
 #define ISA_START_ADDRESS	0xa0000
Index: linux-2.6/include/asm-x86/e820_32.h
===================================================================
--- linux-2.6.orig/include/asm-x86/e820_32.h
+++ linux-2.6/include/asm-x86/e820_32.h
@@ -21,19 +21,8 @@
 extern void setup_memory_map(void);
 extern void finish_e820_parsing(void);
 
-extern struct e820map e820;
-extern void update_e820(void);
-
-extern int e820_all_mapped(unsigned long start, unsigned long end,
-			   unsigned type);
-extern int e820_any_mapped(u64 start, u64 end, unsigned type);
 extern void propagate_e820_map(void);
 extern void register_bootmem_low_pages(unsigned long max_low_pfn);
-extern void add_memory_region(unsigned long long start,
-			      unsigned long long size, int type);
-extern u64 update_memory_range(u64 start, u64 size, unsigned old_type,
-				unsigned new_type);
-extern void e820_register_memory(void);
 extern void limit_regions(unsigned long long size);
 extern void init_iomem_resources(struct resource *code_resource,
 				 struct resource *data_resource,
@@ -47,6 +36,5 @@ static inline void e820_mark_nosave_regi
 }
 #endif
 
-
 #endif/*!__ASSEMBLY__*/
 #endif/*__E820_HEADER*/
Index: linux-2.6/include/asm-x86/e820_64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/e820_64.h
+++ linux-2.6/include/asm-x86/e820_64.h
@@ -19,34 +19,22 @@ extern unsigned long find_e820_area(unsi
 extern unsigned long find_e820_area_size(unsigned long start,
 					 unsigned long *sizep,
 					 unsigned long align);
-extern void add_memory_region(unsigned long start, unsigned long size,
-			      int type);
-extern u64 update_memory_range(u64 start, u64 size, unsigned old_type,
-				unsigned new_type);
 extern void setup_memory_region(void);
 extern void contig_e820_setup(void);
 extern unsigned long e820_end_of_ram(void);
 extern void e820_reserve_resources(void);
 extern void e820_mark_nosave_regions(void);
-extern int e820_any_mapped(unsigned long start, unsigned long end,
-			   unsigned type);
-extern int e820_all_mapped(unsigned long start, unsigned long end,
-			   unsigned type);
 extern int e820_any_non_reserved(unsigned long start, unsigned long end);
 extern int is_memory_any_valid(unsigned long start, unsigned long end);
 extern int e820_all_non_reserved(unsigned long start, unsigned long end);
 extern int is_memory_all_valid(unsigned long start, unsigned long end);
 extern unsigned long e820_hole_size(unsigned long start, unsigned long end);
 
-extern void e820_setup_gap(void);
 extern void e820_register_active_regions(int nid, unsigned long start_pfn,
 					 unsigned long end_pfn);
 
 extern void finish_e820_parsing(void);
 
-extern struct e820map e820;
-extern void update_e820(void);
-
 extern void reserve_early(unsigned long start, unsigned long end, char *name);
 extern void free_early(unsigned long start, unsigned long end);
 extern void early_res_to_bootmem(unsigned long start, unsigned long end);
Index: linux-2.6/arch/x86/kernel/e820.c
===================================================================
--- /dev/null
+++ linux-2.6/arch/x86/kernel/e820.c
@@ -0,0 +1,475 @@
+/*
+ * Handle the memory map.
+ * The functions here do the job until bootmem takes over.
+ *
+ *  Getting sanitize_e820_map() in sync with i386 version by applying change:
+ *  -  Provisions for empty E820 memory regions (reported by certain BIOSes).
+ *     Alex Achenbach <xela@slit.de>, December 2002.
+ *  Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
+ *
+ */
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/init.h>
+#include <linux/bootmem.h>
+#include <linux/ioport.h>
+#include <linux/string.h>
+#include <linux/kexec.h>
+#include <linux/module.h>
+#include <linux/mm.h>
+#include <linux/pfn.h>
+
+#include <asm/pgtable.h>
+#include <asm/page.h>
+#include <asm/e820.h>
+#include <asm/setup.h>
+
+struct e820map e820;
+
+/* For PCI or other memory-mapped resources */
+unsigned long pci_mem_start = 0xaeedbabe;
+#ifdef CONFIG_PCI
+EXPORT_SYMBOL(pci_mem_start);
+#endif
+
+/*
+ * This function checks if any part of the range <start,end> is mapped
+ * with type.
+ */
+int
+e820_any_mapped(u64 start, u64 end, unsigned type)
+{
+	int i;
+
+	for (i = 0; i < e820.nr_map; i++) {
+		struct e820entry *ei = &e820.map[i];
+
+		if (type && ei->type != type)
+			continue;
+		if (ei->addr >= end || ei->addr + ei->size <= start)
+			continue;
+		return 1;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(e820_any_mapped);
+
+/*
+ * This function checks if the entire range <start,end> is mapped with type.
+ *
+ * Note: this function only works correct if the e820 table is sorted and
+ * not-overlapping, which is the case
+ */
+int __init e820_all_mapped(u64 start, u64 end, unsigned type)
+{
+	int i;
+
+	for (i = 0; i < e820.nr_map; i++) {
+		struct e820entry *ei = &e820.map[i];
+
+		if (type && ei->type != type)
+			continue;
+		/* is the region (part) in overlap with the current region ?*/
+		if (ei->addr >= end || ei->addr + ei->size <= start)
+			continue;
+
+		/* if the region is at the beginning of <start,end> we move
+		 * start to the end of the region since it's ok until there
+		 */
+		if (ei->addr <= start)
+			start = ei->addr + ei->size;
+		/*
+		 * if start is now at or beyond end, we're done, full
+		 * coverage
+		 */
+		if (start >= end)
+			return 1;
+	}
+	return 0;
+}
+
+/*
+ * Add a memory region to the kernel e820 map.
+ */
+void __init add_memory_region(u64 start, u64 size, int type)
+{
+	int x = e820.nr_map;
+
+	if (x == E820MAX) {
+		printk(KERN_ERR "Ooops! Too many entries in the memory map!\n");
+		return;
+	}
+
+	e820.map[x].addr = start;
+	e820.map[x].size = size;
+	e820.map[x].type = type;
+	e820.nr_map++;
+}
+
+void __init e820_print_map(char *who)
+{
+	int i;
+
+	for (i = 0; i < e820.nr_map; i++) {
+		printk(KERN_INFO " %s: %016Lx - %016Lx ", who,
+		       (unsigned long long) e820.map[i].addr,
+		       (unsigned long long)
+		       (e820.map[i].addr + e820.map[i].size));
+		switch (e820.map[i].type) {
+		case E820_RAM:
+			printk(KERN_CONT "(usable)\n");
+			break;
+		case E820_RESERVED:
+			printk(KERN_CONT "(reserved)\n");
+			break;
+		case E820_ACPI:
+			printk(KERN_CONT "(ACPI data)\n");
+			break;
+		case E820_NVS:
+			printk(KERN_CONT "(ACPI NVS)\n");
+			break;
+		default:
+			printk(KERN_CONT "type %u\n", e820.map[i].type);
+			break;
+		}
+	}
+}
+
+/*
+ * Sanitize the BIOS e820 map.
+ *
+ * Some e820 responses include overlapping entries. The following
+ * replaces the original e820 map with a new one, removing overlaps.
+ *
+ */
+int __init sanitize_e820_map(struct e820entry *biosmap, char *pnr_map)
+{
+	struct change_member {
+		struct e820entry *pbios; /* pointer to original bios entry */
+		unsigned long long addr; /* address for this change point */
+	};
+	static struct change_member change_point_list[2*E820MAX] __initdata;
+	static struct change_member *change_point[2*E820MAX] __initdata;
+	static struct e820entry *overlap_list[E820MAX] __initdata;
+	static struct e820entry new_bios[E820MAX] __initdata;
+	struct change_member *change_tmp;
+	unsigned long current_type, last_type;
+	unsigned long long last_addr;
+	int chgidx, still_changing;
+	int overlap_entries;
+	int new_bios_entry;
+	int old_nr, new_nr, chg_nr;
+	int i;
+
+	/*
+		Visually we're performing the following
+		(1,2,3,4 = memory types)...
+
+		Sample memory map (w/overlaps):
+		   ____22__________________
+		   ______________________4_
+		   ____1111________________
+		   _44_____________________
+		   11111111________________
+		   ____________________33__
+		   ___________44___________
+		   __________33333_________
+		   ______________22________
+		   ___________________2222_
+		   _________111111111______
+		   _____________________11_
+		   _________________4______
+
+		Sanitized equivalent (no overlap):
+		   1_______________________
+		   _44_____________________
+		   ___1____________________
+		   ____22__________________
+		   ______11________________
+		   _________1______________
+		   __________3_____________
+		   ___________44___________
+		   _____________33_________
+		   _______________2________
+		   ________________1_______
+		   _________________4______
+		   ___________________2____
+		   ____________________33__
+		   ______________________4_
+	*/
+
+	/* if there's only one memory region, don't bother */
+	if (*pnr_map < 2)
+		return -1;
+
+	old_nr = *pnr_map;
+
+	/* bail out if we find any unreasonable addresses in bios map */
+	for (i = 0; i < old_nr; i++)
+		if (biosmap[i].addr + biosmap[i].size < biosmap[i].addr)
+			return -1;
+
+	/* create pointers for initial change-point information (for sorting) */
+	for (i = 0; i < 2 * old_nr; i++)
+		change_point[i] = &change_point_list[i];
+
+	/* record all known change-points (starting and ending addresses),
+	   omitting those that are for empty memory regions */
+	chgidx = 0;
+	for (i = 0; i < old_nr; i++)	{
+		if (biosmap[i].size != 0) {
+			change_point[chgidx]->addr = biosmap[i].addr;
+			change_point[chgidx++]->pbios = &biosmap[i];
+			change_point[chgidx]->addr = biosmap[i].addr +
+				biosmap[i].size;
+			change_point[chgidx++]->pbios = &biosmap[i];
+		}
+	}
+	chg_nr = chgidx;
+
+	/* sort change-point list by memory addresses (low -> high) */
+	still_changing = 1;
+	while (still_changing)	{
+		still_changing = 0;
+		for (i = 1; i < chg_nr; i++)  {
+			unsigned long long curaddr, lastaddr;
+			unsigned long long curpbaddr, lastpbaddr;
+
+			curaddr = change_point[i]->addr;
+			lastaddr = change_point[i - 1]->addr;
+			curpbaddr = change_point[i]->pbios->addr;
+			lastpbaddr = change_point[i - 1]->pbios->addr;
+
+			/*
+			 * swap entries, when:
+			 *
+			 * curaddr > lastaddr or
+			 * curaddr == lastaddr and curaddr == curpbaddr and
+			 * lastaddr != lastpbaddr
+			 */
+			if (curaddr < lastaddr ||
+			    (curaddr == lastaddr && curaddr == curpbaddr &&
+			     lastaddr != lastpbaddr)) {
+				change_tmp = change_point[i];
+				change_point[i] = change_point[i-1];
+				change_point[i-1] = change_tmp;
+				still_changing = 1;
+			}
+		}
+	}
+
+	/* create a new bios memory map, removing overlaps */
+	overlap_entries = 0;	 /* number of entries in the overlap table */
+	new_bios_entry = 0;	 /* index for creating new bios map entries */
+	last_type = 0;		 /* start with undefined memory type */
+	last_addr = 0;		 /* start with 0 as last starting address */
+
+	/* loop through change-points, determining affect on the new bios map */
+	for (chgidx = 0; chgidx < chg_nr; chgidx++) {
+		/* keep track of all overlapping bios entries */
+		if (change_point[chgidx]->addr ==
+		    change_point[chgidx]->pbios->addr) {
+			/*
+			 * add map entry to overlap list (> 1 entry
+			 * implies an overlap)
+			 */
+			overlap_list[overlap_entries++] =
+				change_point[chgidx]->pbios;
+		} else {
+			/*
+			 * remove entry from list (order independent,
+			 * so swap with last)
+			 */
+			for (i = 0; i < overlap_entries; i++) {
+				if (overlap_list[i] ==
+				    change_point[chgidx]->pbios)
+					overlap_list[i] =
+						overlap_list[overlap_entries-1];
+			}
+			overlap_entries--;
+		}
+		/*
+		 * if there are overlapping entries, decide which
+		 * "type" to use (larger value takes precedence --
+		 * 1=usable, 2,3,4,4+=unusable)
+		 */
+		current_type = 0;
+		for (i = 0; i < overlap_entries; i++)
+			if (overlap_list[i]->type > current_type)
+				current_type = overlap_list[i]->type;
+		/*
+		 * continue building up new bios map based on this
+		 * information
+		 */
+		if (current_type != last_type)	{
+			if (last_type != 0)	 {
+				new_bios[new_bios_entry].size =
+					change_point[chgidx]->addr - last_addr;
+				/*
+				 * move forward only if the new size
+				 * was non-zero
+				 */
+				if (new_bios[new_bios_entry].size != 0)
+					/*
+					 * no more space left for new
+					 * bios entries ?
+					 */
+					if (++new_bios_entry >= E820MAX)
+						break;
+			}
+			if (current_type != 0)	{
+				new_bios[new_bios_entry].addr =
+					change_point[chgidx]->addr;
+				new_bios[new_bios_entry].type = current_type;
+				last_addr = change_point[chgidx]->addr;
+			}
+			last_type = current_type;
+		}
+	}
+	/* retain count for new bios entries */
+	new_nr = new_bios_entry;
+
+	/* copy new bios mapping into original location */
+	memcpy(biosmap, new_bios, new_nr * sizeof(struct e820entry));
+	*pnr_map = new_nr;
+
+	return 0;
+}
+
+/*
+ * Copy the BIOS e820 map into a safe place.
+ *
+ * Sanity-check it while we're at it..
+ *
+ * If we're lucky and live on a modern system, the setup code
+ * will have given us a memory map that we can use to properly
+ * set up memory.  If we aren't, we'll fake a memory map.
+ */
+int __init copy_e820_map(struct e820entry *biosmap, int nr_map)
+{
+	/* Only one memory region (or negative)? Ignore it */
+	if (nr_map < 2)
+		return -1;
+
+	do {
+		u64 start = biosmap->addr;
+		u64 size = biosmap->size;
+		u64 end = start + size;
+		u32 type = biosmap->type;
+
+		/* Overflow in 64 bits? Ignore the memory map. */
+		if (start > end)
+			return -1;
+
+		add_memory_region(start, size, type);
+	} while (biosmap++, --nr_map);
+	return 0;
+}
+
+u64 __init update_memory_range(u64 start, u64 size, unsigned old_type,
+				unsigned new_type)
+{
+	int i;
+	u64 real_updated_size = 0;
+
+	BUG_ON(old_type == new_type);
+
+	for (i = 0; i < e820.nr_map; i++) {
+		struct e820entry *ei = &e820.map[i];
+		u64 final_start, final_end;
+		if (ei->type != old_type)
+			continue;
+		/* totally covered? */
+		if (ei->addr >= start &&
+		    (ei->addr + ei->size) <= (start + size)) {
+			ei->type = new_type;
+			real_updated_size += ei->size;
+			continue;
+		}
+		/* partially covered */
+		final_start = max(start, ei->addr);
+		final_end = min(start + size, ei->addr + ei->size);
+		if (final_start >= final_end)
+			continue;
+		add_memory_region(final_start, final_end - final_start,
+					 new_type);
+		real_updated_size += final_end - final_start;
+	}
+	return real_updated_size;
+}
+
+void __init update_e820(void)
+{
+	u8 nr_map;
+
+	nr_map = e820.nr_map;
+	if (sanitize_e820_map(e820.map, &nr_map))
+		return;
+	e820.nr_map = nr_map;
+	printk(KERN_INFO "modified physical RAM map:\n");
+	e820_print_map("modified");
+}
+
+/*
+ * Search for the biggest gap in the low 32 bits of the e820
+ * memory space.  We pass this space to PCI to assign MMIO resources
+ * for hotplug or unconfigured devices in.
+ * Hopefully the BIOS let enough space left.
+ */
+__init void e820_setup_gap(void)
+{
+	unsigned long gapstart, gapsize, round;
+	unsigned long long last;
+	int i;
+	int found = 0;
+
+	last = 0x100000000ull;
+	gapstart = 0x10000000;
+	gapsize = 0x400000;
+	i = e820.nr_map;
+	while (--i >= 0) {
+		unsigned long long start = e820.map[i].addr;
+		unsigned long long end = start + e820.map[i].size;
+
+		/*
+		 * Since "last" is at most 4GB, we know we'll
+		 * fit in 32 bits if this condition is true
+		 */
+		if (last > end) {
+			unsigned long gap = last - end;
+
+			if (gap > gapsize) {
+				gapsize = gap;
+				gapstart = end;
+				found = 1;
+			}
+		}
+		if (start < last)
+			last = start;
+	}
+
+#ifdef CONFIG_X86_64
+	if (!found) {
+		gapstart = (end_pfn << PAGE_SHIFT) + 1024*1024;
+		printk(KERN_ERR "PCI: Warning: Cannot find a gap in the 32bit "
+		       "address range\n"
+		       KERN_ERR "PCI: Unassigned devices with 32bit resource "
+		       "registers may break!\n");
+	}
+#endif
+
+	/*
+	 * See how much we want to round up: start off with
+	 * rounding to the next 1MB area.
+	 */
+	round = 0x100000;
+	while ((gapsize >> 4) > round)
+		round += round;
+	/* Fun with two's complement */
+	pci_mem_start = (gapstart + round) & -round;
+
+	printk(KERN_INFO
+	       "Allocating PCI resources starting at %lx (gap: %lx:%lx)\n",
+	       pci_mem_start, gapstart, gapsize);
+}
+
Index: linux-2.6/arch/x86/kernel/setup_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_32.c
+++ linux-2.6/arch/x86/kernel/setup_32.c
@@ -851,7 +851,7 @@ void __init setup_arch(char **cmdline_p)
 		get_smp_config();
 #endif
 
-	e820_register_memory();
+	e820_setup_gap();
 	e820_mark_nosave_regions();
 
 #ifdef CONFIG_VT
