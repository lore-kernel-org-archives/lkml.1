Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842Ab0BST15 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 14:27:57 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:57198 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892Ab0BST1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 14:27:55 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 4/7] arm/devicetree: Reserve memory used by dtb blob
To: linux@arm.linux.org.uk, catalin.marinas@arm.com, jeremy.kerr@canonical.com,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: tim.bird@am.sony.com
Date: Fri, 19 Feb 2010 12:27:45 -0700
Message-ID: <20100219192734.15318.87375.stgit@angua>
In-Reply-To: <20100219185953.15318.4850.stgit@angua>
References: <20100219185953.15318.4850.stgit@angua>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device tree memory needs to be reserved as bootmem so that it doesn't
get overwritten by normal allocations later.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

 arch/arm/mm/init.c |  102 ++++++++++++++++++++++++++++++++++++++++++----------
 1 files changed, 83 insertions(+), 19 deletions(-)

diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index a340569..2ceb21b 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -17,6 +17,8 @@
 #include <linux/initrd.h>
 #include <linux/sort.h>
 #include <linux/highmem.h>
+#include <linux/of.h>
+#include <linux/of_fdt.h>
 
 #include <asm/mach-types.h>
 #include <asm/sections.h>
@@ -68,6 +70,20 @@ static int __init parse_tag_initrd2(const struct tag *tag)
 
 __tagtable(ATAG_INITRD2, parse_tag_initrd2);
 
+#if defined(CONFIG_OF_FLATTREE)
+static unsigned long phys_devtree_start __initdata = 0;
+static unsigned long phys_devtree_size __initdata = 0;
+
+static int __init parse_tag_devtree(const struct tag *tag)
+{
+	phys_devtree_start = tag->u.devtree.start;
+	phys_devtree_size = tag->u.devtree.size;
+	return 0;
+}
+
+__tagtable(ATAG_DEVTREE, parse_tag_devtree);
+#endif
+
 /*
  * This keeps memory configuration data used by a couple memory
  * initialization functions, as well as show_mem() for the skipping
@@ -191,29 +207,33 @@ find_bootmap_pfn(int node, struct meminfo *mi, unsigned int bootmap_pages)
 	return bootmap_pfn;
 }
 
-static int __init check_initrd(struct meminfo *mi)
+static int __init check_region(struct meminfo *mi,
+			       unsigned long start, unsigned long size)
 {
-	int initrd_node = -2;
-#ifdef CONFIG_BLK_DEV_INITRD
-	unsigned long end = phys_initrd_start + phys_initrd_size;
-
-	/*
-	 * Make sure that the initrd is within a valid area of
-	 * memory.
-	 */
-	if (phys_initrd_size) {
-		unsigned int i;
+	unsigned long end = start + size - 1;
+	unsigned int i;
 
-		initrd_node = -1;
+	if (!size)
+		return -2;
 
-		for (i = 0; i < mi->nr_banks; i++) {
-			struct membank *bank = &mi->bank[i];
-			if (bank_phys_start(bank) <= phys_initrd_start &&
-			    end <= bank_phys_end(bank))
-				initrd_node = bank->node;
-		}
+	/* Make sure that the region is within a valid bank of memory. */
+	for (i = 0; i < mi->nr_banks; i++) {
+		struct membank *bank = &mi->bank[i];
+		if (bank_phys_start(bank) <= start &&
+		    end <= bank_phys_end(bank))
+			return bank->node;
 	}
 
+	/* Region is outside of physical memory */
+	return -1;
+}
+
+static int __init check_initrd(struct meminfo *mi)
+{
+	int initrd_node = -2;
+
+#if defined(CONFIG_BLK_DEV_INITRD)
+	initrd_node = check_region(mi, phys_initrd_start, phys_initrd_size);
 	if (initrd_node == -1) {
 		printk(KERN_ERR "INITRD: 0x%08lx+0x%08lx extends beyond "
 		       "physical memory - disabling initrd\n",
@@ -225,6 +245,27 @@ static int __init check_initrd(struct meminfo *mi)
 	return initrd_node;
 }
 
+static int __init check_devtree(struct meminfo *mi)
+{
+	int node = -2;
+
+#if defined(CONFIG_OF_FLATTREE)
+	if ((phys_devtree_start == 0) || (phys_devtree_size == 0))
+		goto out;
+
+	node = check_region(mi, phys_devtree_start, phys_devtree_size);
+	if (node == -1) {
+		phys_devtree_start = phys_devtree_size = 0;
+		pr_err("DEVICETREE: 0x%08lx+0x%08lx extends beyond "
+		       "physical memory - disabling device tree\n",
+		       phys_devtree_start, phys_devtree_size);
+	}
+#endif
+
+ out:
+	return node;
+}
+
 static inline void map_memory_bank(struct membank *bank)
 {
 #ifdef CONFIG_MMU
@@ -305,6 +346,25 @@ static void __init bootmem_reserve_initrd(int node)
 #endif
 }
 
+static void __init bootmem_reserve_devtree(int node)
+{
+#if defined(CONFIG_OF_FLATTREE)
+	pg_data_t *pgdat = NODE_DATA(node);
+	int res;
+
+	res = reserve_bootmem_node(pgdat, phys_devtree_start,
+				   phys_devtree_size, BOOTMEM_EXCLUSIVE);
+	if (res) {
+		pr_err("DEVICETREE: 0x%08lx+0x%08lx overlaps in-use "
+		       "memory region - disabling device tree\n",
+			phys_devtree_start, phys_devtree_size);
+		return;
+	}
+
+	initial_boot_params = (void *)__phys_to_virt(phys_devtree_start);
+#endif
+}
+
 static void __init bootmem_free_node(int node, struct meminfo *mi)
 {
 	unsigned long zone_size[MAX_NR_ZONES], zhole_size[MAX_NR_ZONES];
@@ -397,7 +457,7 @@ void __init bootmem_init(void)
 {
 	struct meminfo *mi = &meminfo;
 	unsigned long min, max_low, max_high;
-	int node, initrd_node;
+	int node, initrd_node, devtree_node;
 
 	sort(&mi->bank, mi->nr_banks, sizeof(mi->bank[0]), meminfo_cmp, NULL);
 
@@ -405,6 +465,7 @@ void __init bootmem_init(void)
 	 * Locate which node contains the ramdisk image, if any.
 	 */
 	initrd_node = check_initrd(mi);
+	devtree_node = check_devtree(mi);
 
 	max_low = max_high = 0;
 
@@ -438,9 +499,12 @@ void __init bootmem_init(void)
 
 		/*
 		 * If the initrd is in this node, reserve its memory.
+		 * and do the same for the device tree blob
 		 */
 		if (node == initrd_node)
 			bootmem_reserve_initrd(node);
+		if (node == devtree_node)
+			bootmem_reserve_devtree(node);
 
 		/*
 		 * Sparsemem tries to allocate bootmem in memory_present(),

