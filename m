Return-Path: <linux-kernel-owner+w=401wt.eu-S1753290Ab0ADDJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290Ab0ADDJx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 22:09:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753280Ab0ADDJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 22:09:49 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:56475 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925Ab0ADDH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 22:07:27 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Sun, 03 Jan 2010 19:04:58 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 20/29] x86: change range end to start+size
In-reply-to: <1262574307-17040-1-git-send-email-yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Message-id: <1262574307-17040-21-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1262574307-17040-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

so make interface more consistent with early_res.
later we can share some code with early_res.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/cpu/mtrr/cleanup.c |   32 ++++++++++++++++----------------
 arch/x86/kernel/e820.c             |    2 +-
 arch/x86/pci/amd_bus.c             |   24 ++++++++++++++----------
 kernel/range.c                     |   20 ++++++++++----------
 mm/bootmem.c                       |    2 +-
 mm/page_alloc.c                    |    2 +-
 6 files changed, 43 insertions(+), 39 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/cleanup.c b/arch/x86/kernel/cpu/mtrr/cleanup.c
index 669da09..06130b5 100644
--- a/arch/x86/kernel/cpu/mtrr/cleanup.c
+++ b/arch/x86/kernel/cpu/mtrr/cleanup.c
@@ -78,13 +78,13 @@ x86_get_mtrr_mem_range(struct range *range, int nr_range,
 		base = range_state[i].base_pfn;
 		size = range_state[i].size_pfn;
 		nr_range = add_range_with_merge(range, RANGE_NUM, nr_range,
-						base, base + size - 1);
+						base, base + size);
 	}
 	if (debug_print) {
 		printk(KERN_DEBUG "After WB checking\n");
 		for (i = 0; i < nr_range; i++)
 			printk(KERN_DEBUG "MTRR MAP PFN: %016llx - %016llx\n",
-				 range[i].start, range[i].end + 1);
+				 range[i].start, range[i].end);
 	}
 
 	/* Take out UC ranges: */
@@ -106,11 +106,11 @@ x86_get_mtrr_mem_range(struct range *range, int nr_range,
 			size -= (1<<(20-PAGE_SHIFT)) - base;
 			base = 1<<(20-PAGE_SHIFT);
 		}
-		subtract_range(range, RANGE_NUM, base, base + size - 1);
+		subtract_range(range, RANGE_NUM, base, base + size);
 	}
 	if (extra_remove_size)
 		subtract_range(range, RANGE_NUM, extra_remove_base,
-				 extra_remove_base + extra_remove_size  - 1);
+				 extra_remove_base + extra_remove_size);
 
 	if  (debug_print) {
 		printk(KERN_DEBUG "After UC checking\n");
@@ -118,7 +118,7 @@ x86_get_mtrr_mem_range(struct range *range, int nr_range,
 			if (!range[i].end)
 				continue;
 			printk(KERN_DEBUG "MTRR MAP PFN: %016llx - %016llx\n",
-				 range[i].start, range[i].end + 1);
+				 range[i].start, range[i].end);
 		}
 	}
 
@@ -128,7 +128,7 @@ x86_get_mtrr_mem_range(struct range *range, int nr_range,
 		printk(KERN_DEBUG "After sorting\n");
 		for (i = 0; i < nr_range; i++)
 			printk(KERN_DEBUG "MTRR MAP PFN: %016llx - %016llx\n",
-				 range[i].start, range[i].end + 1);
+				 range[i].start, range[i].end);
 	}
 
 	return nr_range;
@@ -142,7 +142,7 @@ static unsigned long __init sum_ranges(struct range *range, int nr_range)
 	int i;
 
 	for (i = 0; i < nr_range; i++)
-		sum += range[i].end + 1 - range[i].start;
+		sum += range[i].end - range[i].start;
 
 	return sum;
 }
@@ -489,7 +489,7 @@ x86_setup_var_mtrrs(struct range *range, int nr_range,
 	/* Write the range: */
 	for (i = 0; i < nr_range; i++) {
 		set_var_mtrr_range(&var_state, range[i].start,
-				   range[i].end - range[i].start + 1);
+				   range[i].end - range[i].start);
 	}
 
 	/* Write the last range: */
@@ -720,7 +720,7 @@ int __init mtrr_cleanup(unsigned address_bits)
 	 * and fixed mtrrs should take effect before var mtrr for it:
 	 */
 	nr_range = add_range_with_merge(range, RANGE_NUM, nr_range, 0,
-					(1ULL<<(20 - PAGE_SHIFT)) - 1);
+					1ULL<<(20 - PAGE_SHIFT));
 	/* Sort the ranges: */
 	sort_range(range, nr_range);
 
@@ -939,9 +939,9 @@ int __init mtrr_trim_uncached_memory(unsigned long end_pfn)
 	nr_range = 0;
 	if (mtrr_tom2) {
 		range[nr_range].start = (1ULL<<(32 - PAGE_SHIFT));
-		range[nr_range].end = (mtrr_tom2 >> PAGE_SHIFT) - 1;
-		if (highest_pfn < range[nr_range].end + 1)
-			highest_pfn = range[nr_range].end + 1;
+		range[nr_range].end = mtrr_tom2 >> PAGE_SHIFT;
+		if (highest_pfn < range[nr_range].end)
+			highest_pfn = range[nr_range].end;
 		nr_range++;
 	}
 	nr_range = x86_get_mtrr_mem_range(range, nr_range, 0, 0);
@@ -953,15 +953,15 @@ int __init mtrr_trim_uncached_memory(unsigned long end_pfn)
 
 	/* Check the holes: */
 	for (i = 0; i < nr_range - 1; i++) {
-		if (range[i].end + 1 < range[i+1].start)
-			total_trim_size += real_trim_memory(range[i].end + 1,
+		if (range[i].end < range[i+1].start)
+			total_trim_size += real_trim_memory(range[i].end,
 							    range[i+1].start);
 	}
 
 	/* Check the top: */
 	i = nr_range - 1;
-	if (range[i].end + 1 < end_pfn)
-		total_trim_size += real_trim_memory(range[i].end + 1,
+	if (range[i].end < end_pfn)
+		total_trim_size += real_trim_memory(range[i].end,
 							 end_pfn);
 
 	if (total_trim_size) {
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 155b2d6..bd6a361 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -1038,7 +1038,7 @@ static void __init subtract_early_res(struct range *range, int az)
 		printk(KERN_CONT " subtract pfn [%010llx - %010llx]\n",
 			final_start, final_end);
 #endif
-		subtract_range(range, az, final_start, final_end - 1);
+		subtract_range(range, az, final_start, final_end);
 	}
 
 }
diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
index ef4b3e7..05cb9ae 100644
--- a/arch/x86/pci/amd_bus.c
+++ b/arch/x86/pci/amd_bus.c
@@ -145,7 +145,7 @@ static int __init early_fill_mp_bus_info(void)
 	def_link = (reg >> 8) & 0x03;
 
 	memset(range, 0, sizeof(range));
-	range[0].end = 0xffff;
+	add_range(range, RANGE_NUM, 0, 0, 0xffff + 1);
 	/* io port resource */
 	for (i = 0; i < 4; i++) {
 		reg = read_pci_config(bus, slot, 1, 0xc0 + (i << 3));
@@ -175,7 +175,7 @@ static int __init early_fill_mp_bus_info(void)
 		if (end > 0xffff)
 			end = 0xffff;
 		update_res(info, start, end, IORESOURCE_IO, 1);
-		subtract_range(range, RANGE_NUM, start, end);
+		subtract_range(range, RANGE_NUM, start, end + 1);
 	}
 	/* add left over io port range to def node/link, [0, 0xffff] */
 	/* find the position */
@@ -190,14 +190,16 @@ static int __init early_fill_mp_bus_info(void)
 			if (!range[i].end)
 				continue;
 
-			update_res(info, range[i].start, range[i].end,
+			update_res(info, range[i].start, range[i].end - 1,
 				   IORESOURCE_IO, 1);
 		}
 	}
 
 	memset(range, 0, sizeof(range));
 	/* 0xfd00000000-0xffffffffff for HT */
-	range[0].end = cap_resource((0xfdULL<<32) - 1);
+	end = cap_resource((0xfdULL<<32) - 1);
+	end++;
+	add_range(range, RANGE_NUM, 0, 0, end);
 
 	/* need to take out [0, TOM) for RAM*/
 	address = MSR_K8_TOP_MEM1;
@@ -205,14 +207,15 @@ static int __init early_fill_mp_bus_info(void)
 	end = (val & 0xffffff800000ULL);
 	printk(KERN_INFO "TOM: %016llx aka %lldM\n", end, end>>20);
 	if (end < (1ULL<<32))
-		subtract_range(range, RANGE_NUM, 0, end - 1);
+		subtract_range(range, RANGE_NUM, 0, end);
 
 	/* get mmconfig */
 	get_pci_mmcfg_amd_fam10h_range();
 	/* need to take out mmconf range */
 	if (fam10h_mmconf_end) {
 		printk(KERN_DEBUG "Fam 10h mmconf [%llx, %llx]\n", fam10h_mmconf_start, fam10h_mmconf_end);
-		subtract_range(range, RANGE_NUM, fam10h_mmconf_start, fam10h_mmconf_end);
+		subtract_range(range, RANGE_NUM, fam10h_mmconf_start,
+				 fam10h_mmconf_end + 1);
 	}
 
 	/* mmio resource */
@@ -267,7 +270,8 @@ static int __init early_fill_mp_bus_info(void)
 				/* we got a hole */
 				endx = fam10h_mmconf_start - 1;
 				update_res(info, start, endx, IORESOURCE_MEM, 0);
-				subtract_range(range, RANGE_NUM, start, endx);
+				subtract_range(range, RANGE_NUM, start,
+						 endx + 1);
 				printk(KERN_CONT " ==> [%llx, %llx]", start, endx);
 				start = fam10h_mmconf_end + 1;
 				changed = 1;
@@ -284,7 +288,7 @@ static int __init early_fill_mp_bus_info(void)
 
 		update_res(info, cap_resource(start), cap_resource(end),
 				 IORESOURCE_MEM, 1);
-		subtract_range(range, RANGE_NUM, start, end);
+		subtract_range(range, RANGE_NUM, start, end + 1);
 		printk(KERN_CONT "\n");
 	}
 
@@ -299,7 +303,7 @@ static int __init early_fill_mp_bus_info(void)
 		rdmsrl(address, val);
 		end = (val & 0xffffff800000ULL);
 		printk(KERN_INFO "TOM2: %016llx aka %lldM\n", end, end>>20);
-		subtract_range(range, RANGE_NUM, 1ULL<<32, end - 1);
+		subtract_range(range, RANGE_NUM, 1ULL<<32, end);
 	}
 
 	/*
@@ -319,7 +323,7 @@ static int __init early_fill_mp_bus_info(void)
 				continue;
 
 			update_res(info, cap_resource(range[i].start),
-				   cap_resource(range[i].end),
+				   cap_resource(range[i].end - 1),
 				   IORESOURCE_MEM, 1);
 		}
 	}
diff --git a/kernel/range.c b/kernel/range.c
index 71e0021..74e2e61 100644
--- a/kernel/range.c
+++ b/kernel/range.c
@@ -13,7 +13,7 @@
 
 int add_range(struct range *range, int az, int nr_range, u64 start, u64 end)
 {
-	if (start > end)
+	if (start >= end)
 		return nr_range;
 
 	/* Out of slots: */
@@ -33,7 +33,7 @@ int add_range_with_merge(struct range *range, int az, int nr_range,
 {
 	int i;
 
-	if (start > end)
+	if (start >= end)
 		return nr_range;
 
 	/* Try to merge it with old one: */
@@ -46,7 +46,7 @@ int add_range_with_merge(struct range *range, int az, int nr_range,
 
 		common_start = max(range[i].start, start);
 		common_end = min(range[i].end, end);
-		if (common_start > common_end + 1)
+		if (common_start > common_end)
 			continue;
 
 		final_start = min(range[i].start, start);
@@ -65,7 +65,7 @@ void subtract_range(struct range *range, int az, u64 start, u64 end)
 {
 	int i, j;
 
-	if (start > end)
+	if (start >= end)
 		return;
 
 	for (j = 0; j < az; j++) {
@@ -79,15 +79,15 @@ void subtract_range(struct range *range, int az, u64 start, u64 end)
 		}
 
 		if (start <= range[j].start && end < range[j].end &&
-		    range[j].start < end + 1) {
-			range[j].start = end + 1;
+		    range[j].start < end) {
+			range[j].start = end;
 			continue;
 		}
 
 
 		if (start > range[j].start && end >= range[j].end &&
-		    range[j].end > start - 1) {
-			range[j].end = start - 1;
+		    range[j].end > start) {
+			range[j].end = start;
 			continue;
 		}
 
@@ -99,11 +99,11 @@ void subtract_range(struct range *range, int az, u64 start, u64 end)
 			}
 			if (i < az) {
 				range[i].end = range[j].end;
-				range[i].start = end + 1;
+				range[i].start = end;
 			} else {
 				printk(KERN_ERR "run of slot in ranges\n");
 			}
-			range[j].end = start - 1;
+			range[j].end = start;
 			continue;
 		}
 	}
diff --git a/mm/bootmem.c b/mm/bootmem.c
index 64a5000..bb7faad 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -215,7 +215,7 @@ unsigned long __init free_all_memory_core_early(int nodeid)
 
 	for (i = 0; i < nr_range; i++) {
 		start = range[i].start;
-		end = range[i].end + 1;
+		end = range[i].end;
 		count += end - start;
 		__free_pages_memory(start, end);
 	}
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2ca7b0f..e0ea57a 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3444,7 +3444,7 @@ int __init add_from_early_node_map(struct range *range, int az,
 	for_each_active_range_index_in_nid(i, nid) {
 		start = early_node_map[i].start_pfn;
 		end = early_node_map[i].end_pfn;
-		nr_range = add_range(range, az, nr_range, start, end - 1);
+		nr_range = add_range(range, az, nr_range, start, end);
 	}
 	return nr_range;
 }
-- 
1.6.4.2

