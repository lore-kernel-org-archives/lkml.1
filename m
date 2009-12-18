Return-Path: <linux-kernel-owner+w=401wt.eu-S1753200AbZLRJt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200AbZLRJt4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 04:49:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753138AbZLRJtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 04:49:51 -0500
Received: from hera.kernel.org ([140.211.167.34]:55121 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753135AbZLRJts (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 04:49:48 -0500
Message-ID: <4B2B4FCF.3040401@kernel.org>
Date: Fri, 18 Dec 2009 01:47:59 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/9] x86: print bootmem free before pci_iommu_alloc and free_all_bootmem
 -v2
References: <4B2B4C19.6010402@kernel.org>
In-Reply-To: <4B2B4C19.6010402@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



so we could double check if we have enough low pages later

-v2: fix errors checkpatch.pl reported

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/mm/init_64.c   |    2 +
 include/linux/bootmem.h |    2 +
 mm/bootmem.c            |   92 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 96 insertions(+)

Index: linux-2.6/mm/bootmem.c
===================================================================
--- linux-2.6.orig/mm/bootmem.c
+++ linux-2.6/mm/bootmem.c
@@ -267,6 +267,98 @@ static void __init __free(bootmem_data_t
 			BUG();
 }
 
+static void __init print_all_bootmem_free_core(bootmem_data_t *bdata)
+{
+	int aligned;
+	unsigned long *map;
+	unsigned long start, end, count = 0;
+	unsigned long free_start = -1UL, free_end = 0;
+
+	if (!bdata->node_bootmem_map)
+		return;
+
+	start = bdata->node_min_pfn;
+	end = bdata->node_low_pfn;
+
+	/*
+	 * If the start is aligned to the machines wordsize, we might
+	 * be able to count it in bulks of that order.
+	 */
+	aligned = !(start & (BITS_PER_LONG - 1));
+
+	printk(KERN_DEBUG "nid=%td start=0x%010lx end=0x%010lx aligned=%d\n",
+		bdata - bootmem_node_data, start, end, aligned);
+	map = bdata->node_bootmem_map;
+
+	while (start < end) {
+		unsigned long idx, vec;
+
+		idx = start - bdata->node_min_pfn;
+		vec = ~map[idx / BITS_PER_LONG];
+
+		if (aligned && vec == ~0UL && start + BITS_PER_LONG < end) {
+			if (free_start == -1UL) {
+				free_start = idx;
+				free_end = free_start + BITS_PER_LONG;
+			} else {
+				if (free_end == idx) {
+					free_end += BITS_PER_LONG;
+				} else {
+					/* there is gap, print old */
+					printk(KERN_DEBUG "  free [0x%010lx - 0x%010lx]\n",
+							free_start + bdata->node_min_pfn,
+							free_end + bdata->node_min_pfn);
+					free_start = idx;
+					free_end = idx + BITS_PER_LONG;
+				}
+			}
+			count += BITS_PER_LONG;
+		} else {
+			unsigned long off = 0;
+
+			while (vec && off < BITS_PER_LONG) {
+				if (vec & 1) {
+					if (free_start == -1UL) {
+						free_start = idx + off;
+						free_end = free_start + 1;
+					} else {
+						if (free_end == (idx + off)) {
+							free_end++;
+						} else {
+							/* there is gap, print old */
+							printk(KERN_DEBUG "  free [0x%010lx - 0x%010lx]\n",
+								free_start + bdata->node_min_pfn,
+								free_end + bdata->node_min_pfn);
+							free_start = idx + off;
+							free_end = free_start + 1;
+						}
+					}
+					count++;
+				}
+				vec >>= 1;
+				off++;
+			}
+		}
+		start += BITS_PER_LONG;
+	}
+
+	/* last one */
+	if (free_start != -1UL)
+		printk(KERN_DEBUG "  free [0x%010lx - 0x%010lx]\n",
+			free_start + bdata->node_min_pfn,
+			free_end + bdata->node_min_pfn);
+	printk(KERN_DEBUG "  total free 0x%010lx\n", count);
+}
+
+void __init print_bootmem_free(void)
+{
+	bootmem_data_t *bdata;
+
+	list_for_each_entry(bdata, &bdata_list, list) {
+		print_all_bootmem_free_core(bdata);
+	}
+}
+
 static int __init __reserve(bootmem_data_t *bdata, unsigned long sidx,
 			unsigned long eidx, int flags)
 {
Index: linux-2.6/arch/x86/mm/init_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_64.c
+++ linux-2.6/arch/x86/mm/init_64.c
@@ -654,6 +654,8 @@ void __init mem_init(void)
 	long codesize, reservedpages, datasize, initsize;
 	unsigned long absent_pages;
 
+	print_bootmem_free();
+
 	pci_iommu_alloc();
 
 	/* clear_bss() already clear the empty_zero_page */
Index: linux-2.6/include/linux/bootmem.h
===================================================================
--- linux-2.6.orig/include/linux/bootmem.h
+++ linux-2.6/include/linux/bootmem.h
@@ -55,6 +55,8 @@ extern void free_bootmem_node(pg_data_t
 extern void free_bootmem(unsigned long addr, unsigned long size);
 extern void free_bootmem_late(unsigned long addr, unsigned long size);
 
+void print_bootmem_free(void);
+
 /*
  * Flags for reserve_bootmem (also if CONFIG_HAVE_ARCH_BOOTMEM_NODE,
  * the architecture-specific code should honor this).

