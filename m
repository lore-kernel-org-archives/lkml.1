Return-Path: <linux-kernel-owner+w=401wt.eu-S935101AbZLKXkK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935101AbZLKXkK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:40:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934997AbZLKXju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:39:50 -0500
Received: from hera.kernel.org ([140.211.167.34]:57334 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934338AbZLKXhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:37:09 -0500
Message-ID: <4B22D71E.3010309@kernel.org>
Date: Fri, 11 Dec 2009 15:34:54 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: [PATCH 1/7] x86: move range related operation to one file
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/cpu/mtrr/cleanup.c |  180 +++----------------------------------
 arch/x86/kernel/mmconf-fam10h_64.c |    7 -
 arch/x86/pci/amd_bus.c             |   70 ++------------
 include/linux/range.h              |   22 ++++
 kernel/Makefile                    |    2 
 kernel/range.c                     |  154 +++++++++++++++++++++++++++++++
 6 files changed, 205 insertions(+), 230 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/mtrr/cleanup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mtrr/cleanup.c
+++ linux-2.6/arch/x86/kernel/cpu/mtrr/cleanup.c
@@ -22,10 +22,10 @@
 #include <linux/pci.h>
 #include <linux/smp.h>
 #include <linux/cpu.h>
-#include <linux/sort.h>
 #include <linux/mutex.h>
 #include <linux/uaccess.h>
 #include <linux/kvm_para.h>
+#include <linux/range.h>
 
 #include <asm/processor.h>
 #include <asm/e820.h>
@@ -34,11 +34,6 @@
 
 #include "mtrr.h"
 
-struct res_range {
-	unsigned long	start;
-	unsigned long	end;
-};
-
 struct var_mtrr_range_state {
 	unsigned long	base_pfn;
 	unsigned long	size_pfn;
@@ -56,7 +51,7 @@ struct var_mtrr_state {
 /* Should be related to MTRR_VAR_RANGES nums */
 #define RANGE_NUM				256
 
-static struct res_range __initdata		range[RANGE_NUM];
+static struct range __initdata		range[RANGE_NUM];
 static int __initdata				nr_range;
 
 static struct var_mtrr_range_state __initdata	range_state[RANGE_NUM];
@@ -64,152 +59,11 @@ static struct var_mtrr_range_state __ini
 static int __initdata debug_print;
 #define Dprintk(x...) do { if (debug_print) printk(KERN_DEBUG x); } while (0)
 
-
-static int __init
-add_range(struct res_range *range, int nr_range,
-	  unsigned long start, unsigned long end)
-{
-	/* Out of slots: */
-	if (nr_range >= RANGE_NUM)
-		return nr_range;
-
-	range[nr_range].start = start;
-	range[nr_range].end = end;
-
-	nr_range++;
-
-	return nr_range;
-}
-
-static int __init
-add_range_with_merge(struct res_range *range, int nr_range,
-		     unsigned long start, unsigned long end)
-{
-	int i;
-
-	/* Try to merge it with old one: */
-	for (i = 0; i < nr_range; i++) {
-		unsigned long final_start, final_end;
-		unsigned long common_start, common_end;
-
-		if (!range[i].end)
-			continue;
-
-		common_start = max(range[i].start, start);
-		common_end = min(range[i].end, end);
-		if (common_start > common_end + 1)
-			continue;
-
-		final_start = min(range[i].start, start);
-		final_end = max(range[i].end, end);
-
-		range[i].start = final_start;
-		range[i].end =  final_end;
-		return nr_range;
-	}
-
-	/* Need to add it: */
-	return add_range(range, nr_range, start, end);
-}
-
-static void __init
-subtract_range(struct res_range *range, unsigned long start, unsigned long end)
-{
-	int i, j;
-
-	for (j = 0; j < RANGE_NUM; j++) {
-		if (!range[j].end)
-			continue;
-
-		if (start <= range[j].start && end >= range[j].end) {
-			range[j].start = 0;
-			range[j].end = 0;
-			continue;
-		}
-
-		if (start <= range[j].start && end < range[j].end &&
-		    range[j].start < end + 1) {
-			range[j].start = end + 1;
-			continue;
-		}
-
-
-		if (start > range[j].start && end >= range[j].end &&
-		    range[j].end > start - 1) {
-			range[j].end = start - 1;
-			continue;
-		}
-
-		if (start > range[j].start && end < range[j].end) {
-			/* Find the new spare: */
-			for (i = 0; i < RANGE_NUM; i++) {
-				if (range[i].end == 0)
-					break;
-			}
-			if (i < RANGE_NUM) {
-				range[i].end = range[j].end;
-				range[i].start = end + 1;
-			} else {
-				printk(KERN_ERR "run of slot in ranges\n");
-			}
-			range[j].end = start - 1;
-			continue;
-		}
-	}
-}
-
-static int __init cmp_range(const void *x1, const void *x2)
-{
-	const struct res_range *r1 = x1;
-	const struct res_range *r2 = x2;
-	long start1, start2;
-
-	start1 = r1->start;
-	start2 = r2->start;
-
-	return start1 - start2;
-}
-
-static int __init clean_sort_range(struct res_range *range, int az)
-{
-	int i, j, k = az - 1, nr_range = 0;
-
-	for (i = 0; i < k; i++) {
-		if (range[i].end)
-			continue;
-		for (j = k; j > i; j--) {
-			if (range[j].end) {
-				k = j;
-				break;
-			}
-		}
-		if (j == i)
-			break;
-		range[i].start = range[k].start;
-		range[i].end   = range[k].end;
-		range[k].start = 0;
-		range[k].end   = 0;
-		k--;
-	}
-	/* count it */
-	for (i = 0; i < az; i++) {
-		if (!range[i].end) {
-			nr_range = i;
-			break;
-		}
-	}
-
-	/* sort them */
-	sort(range, nr_range, sizeof(struct res_range), cmp_range, NULL);
-
-	return nr_range;
-}
-
 #define BIOS_BUG_MSG KERN_WARNING \
 	"WARNING: BIOS bug: VAR MTRR %d contains strange UC entry under 1M, check with your system vendor!\n"
 
 static int __init
-x86_get_mtrr_mem_range(struct res_range *range, int nr_range,
+x86_get_mtrr_mem_range(struct range *range, int nr_range,
 		       unsigned long extra_remove_base,
 		       unsigned long extra_remove_size)
 {
@@ -223,13 +77,13 @@ x86_get_mtrr_mem_range(struct res_range
 			continue;
 		base = range_state[i].base_pfn;
 		size = range_state[i].size_pfn;
-		nr_range = add_range_with_merge(range, nr_range, base,
-						base + size - 1);
+		nr_range = add_range_with_merge(range, RANGE_NUM, nr_range,
+						base, base + size - 1);
 	}
 	if (debug_print) {
 		printk(KERN_DEBUG "After WB checking\n");
 		for (i = 0; i < nr_range; i++)
-			printk(KERN_DEBUG "MTRR MAP PFN: %016lx - %016lx\n",
+			printk(KERN_DEBUG "MTRR MAP PFN: %016llx - %016llx\n",
 				 range[i].start, range[i].end + 1);
 	}
 
@@ -252,10 +106,10 @@ x86_get_mtrr_mem_range(struct res_range
 			size -= (1<<(20-PAGE_SHIFT)) - base;
 			base = 1<<(20-PAGE_SHIFT);
 		}
-		subtract_range(range, base, base + size - 1);
+		subtract_range(range, RANGE_NUM, base, base + size - 1);
 	}
 	if (extra_remove_size)
-		subtract_range(range, extra_remove_base,
+		subtract_range(range, RANGE_NUM, extra_remove_base,
 				 extra_remove_base + extra_remove_size  - 1);
 
 	if  (debug_print) {
@@ -263,7 +117,7 @@ x86_get_mtrr_mem_range(struct res_range
 		for (i = 0; i < RANGE_NUM; i++) {
 			if (!range[i].end)
 				continue;
-			printk(KERN_DEBUG "MTRR MAP PFN: %016lx - %016lx\n",
+			printk(KERN_DEBUG "MTRR MAP PFN: %016llx - %016llx\n",
 				 range[i].start, range[i].end + 1);
 		}
 	}
@@ -273,20 +127,16 @@ x86_get_mtrr_mem_range(struct res_range
 	if  (debug_print) {
 		printk(KERN_DEBUG "After sorting\n");
 		for (i = 0; i < nr_range; i++)
-			printk(KERN_DEBUG "MTRR MAP PFN: %016lx - %016lx\n",
+			printk(KERN_DEBUG "MTRR MAP PFN: %016llx - %016llx\n",
 				 range[i].start, range[i].end + 1);
 	}
 
-	/* clear those is not used */
-	for (i = nr_range; i < RANGE_NUM; i++)
-		memset(&range[i], 0, sizeof(range[i]));
-
 	return nr_range;
 }
 
 #ifdef CONFIG_MTRR_SANITIZER
 
-static unsigned long __init sum_ranges(struct res_range *range, int nr_range)
+static unsigned long __init sum_ranges(struct range *range, int nr_range)
 {
 	unsigned long sum = 0;
 	int i;
@@ -621,7 +471,7 @@ static int __init parse_mtrr_spare_reg(c
 early_param("mtrr_spare_reg_nr", parse_mtrr_spare_reg);
 
 static int __init
-x86_setup_var_mtrrs(struct res_range *range, int nr_range,
+x86_setup_var_mtrrs(struct range *range, int nr_range,
 		    u64 chunk_size, u64 gran_size)
 {
 	struct var_mtrr_state var_state;
@@ -742,7 +592,7 @@ mtrr_calc_range_state(u64 chunk_size, u6
 		      unsigned long x_remove_base,
 		      unsigned long x_remove_size, int i)
 {
-	static struct res_range range_new[RANGE_NUM];
+	static struct range range_new[RANGE_NUM];
 	unsigned long range_sums_new;
 	static int nr_range_new;
 	int num_reg;
@@ -869,10 +719,10 @@ int __init mtrr_cleanup(unsigned address
 	 * [0, 1M) should always be covered by var mtrr with WB
 	 * and fixed mtrrs should take effect before var mtrr for it:
 	 */
-	nr_range = add_range_with_merge(range, nr_range, 0,
+	nr_range = add_range_with_merge(range, RANGE_NUM, nr_range, 0,
 					(1ULL<<(20 - PAGE_SHIFT)) - 1);
 	/* Sort the ranges: */
-	sort(range, nr_range, sizeof(struct res_range), cmp_range, NULL);
+	sort_range(range, nr_range);
 
 	range_sums = sum_ranges(range, nr_range);
 	printk(KERN_INFO "total RAM covered: %ldM\n",
Index: linux-2.6/include/linux/range.h
===================================================================
--- /dev/null
+++ linux-2.6/include/linux/range.h
@@ -0,0 +1,22 @@
+#ifndef _LINUX_RANGE_H
+#define _LINUX_RANGE_H
+
+struct range {
+	u64   start;
+	u64   end;
+};
+
+int add_range(struct range *range, int az, int nr_range,
+		u64 start, u64 end);
+
+
+int add_range_with_merge(struct range *range, int az, int nr_range,
+				u64 start, u64 end);
+
+void subtract_range(struct range *range, int az, u64 start, u64 end);
+
+int clean_sort_range(struct range *range, int az);
+
+void sort_range(struct range *range, int nr_range);
+
+#endif
Index: linux-2.6/kernel/Makefile
===================================================================
--- linux-2.6.orig/kernel/Makefile
+++ linux-2.6/kernel/Makefile
@@ -10,7 +10,7 @@ obj-y     = sched.o fork.o exec_domain.o
 	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
 	    hrtimer.o rwsem.o nsproxy.o srcu.o semaphore.o \
 	    notifier.o ksysfs.o pm_qos_params.o sched_clock.o cred.o \
-	    async.o
+	    async.o range.o
 obj-y += groups.o
 
 ifdef CONFIG_FUNCTION_TRACER
Index: linux-2.6/kernel/range.c
===================================================================
--- /dev/null
+++ linux-2.6/kernel/range.c
@@ -0,0 +1,154 @@
+/*
+ * Range add and subtract
+ */
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/sort.h>
+
+#include <linux/range.h>
+
+#ifndef ARRAY_SIZE
+#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
+#endif
+
+int add_range(struct range *range, int az, int nr_range, u64 start, u64 end)
+{
+	/* Out of slots: */
+	if (nr_range >= az)
+		return nr_range;
+
+	range[nr_range].start = start;
+	range[nr_range].end = end;
+
+	nr_range++;
+
+	return nr_range;
+}
+
+int add_range_with_merge(struct range *range, int az, int nr_range,
+		     u64 start, u64 end)
+{
+	int i;
+
+	/* Try to merge it with old one: */
+	for (i = 0; i < nr_range; i++) {
+		u64 final_start, final_end;
+		u64 common_start, common_end;
+
+		if (!range[i].end)
+			continue;
+
+		common_start = max(range[i].start, start);
+		common_end = min(range[i].end, end);
+		if (common_start > common_end + 1)
+			continue;
+
+		final_start = min(range[i].start, start);
+		final_end = max(range[i].end, end);
+
+		range[i].start = final_start;
+		range[i].end =  final_end;
+		return nr_range;
+	}
+
+	/* Need to add it: */
+	return add_range(range, az, nr_range, start, end);
+}
+
+void subtract_range(struct range *range, int az, u64 start, u64 end)
+{
+	int i, j;
+
+	for (j = 0; j < az; j++) {
+		if (!range[j].end)
+			continue;
+
+		if (start <= range[j].start && end >= range[j].end) {
+			range[j].start = 0;
+			range[j].end = 0;
+			continue;
+		}
+
+		if (start <= range[j].start && end < range[j].end &&
+		    range[j].start < end + 1) {
+			range[j].start = end + 1;
+			continue;
+		}
+
+
+		if (start > range[j].start && end >= range[j].end &&
+		    range[j].end > start - 1) {
+			range[j].end = start - 1;
+			continue;
+		}
+
+		if (start > range[j].start && end < range[j].end) {
+			/* Find the new spare: */
+			for (i = 0; i < az; i++) {
+				if (range[i].end == 0)
+					break;
+			}
+			if (i < az) {
+				range[i].end = range[j].end;
+				range[i].start = end + 1;
+			} else {
+				printk(KERN_ERR "run of slot in ranges\n");
+			}
+			range[j].end = start - 1;
+			continue;
+		}
+	}
+}
+
+static int cmp_range(const void *x1, const void *x2)
+{
+	const struct range *r1 = x1;
+	const struct range *r2 = x2;
+	s64 start1, start2;
+
+	start1 = r1->start;
+	start2 = r2->start;
+
+	return start1 - start2;
+}
+
+int clean_sort_range(struct range *range, int az)
+{
+	int i, j, k = az - 1, nr_range = 0;
+
+	for (i = 0; i < k; i++) {
+		if (range[i].end)
+			continue;
+		for (j = k; j > i; j--) {
+			if (range[j].end) {
+				k = j;
+				break;
+			}
+		}
+		if (j == i)
+			break;
+		range[i].start = range[k].start;
+		range[i].end   = range[k].end;
+		range[k].start = 0;
+		range[k].end   = 0;
+		k--;
+	}
+	/* count it */
+	for (i = 0; i < az; i++) {
+		if (!range[i].end) {
+			nr_range = i;
+			break;
+		}
+	}
+
+	/* sort them */
+	sort(range, nr_range, sizeof(struct range), cmp_range, NULL);
+
+	return nr_range;
+}
+
+void sort_range(struct range *range, int nr_range)
+{
+	/* sort them */
+	sort(range, nr_range, sizeof(struct range), cmp_range, NULL);
+}
Index: linux-2.6/arch/x86/kernel/mmconf-fam10h_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/mmconf-fam10h_64.c
+++ linux-2.6/arch/x86/kernel/mmconf-fam10h_64.c
@@ -7,6 +7,8 @@
 #include <linux/string.h>
 #include <linux/pci.h>
 #include <linux/dmi.h>
+#include <linux/range.h>
+
 #include <asm/pci-direct.h>
 #include <linux/sort.h>
 #include <asm/io.h>
@@ -30,11 +32,6 @@ static struct pci_hostbridge_probe pci_p
 	{ 0xff, 0, PCI_VENDOR_ID_AMD, 0x1200 },
 };
 
-struct range {
-	u64 start;
-	u64 end;
-};
-
 static int __cpuinit cmp_range(const void *x1, const void *x2)
 {
 	const struct range *r1 = x1;
Index: linux-2.6/arch/x86/pci/amd_bus.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/amd_bus.c
+++ linux-2.6/arch/x86/pci/amd_bus.c
@@ -2,6 +2,8 @@
 #include <linux/pci.h>
 #include <linux/topology.h>
 #include <linux/cpu.h>
+#include <linux/range.h>
+
 #include <asm/pci_x86.h>
 
 #ifdef CONFIG_X86_64
@@ -17,58 +19,6 @@
 
 #ifdef CONFIG_X86_64
 
-#define RANGE_NUM 16
-
-struct res_range {
-	size_t start;
-	size_t end;
-};
-
-static void __init update_range(struct res_range *range, size_t start,
-				size_t end)
-{
-	int i;
-	int j;
-
-	for (j = 0; j < RANGE_NUM; j++) {
-		if (!range[j].end)
-			continue;
-
-		if (start <= range[j].start && end >= range[j].end) {
-			range[j].start = 0;
-			range[j].end = 0;
-			continue;
-		}
-
-		if (start <= range[j].start && end < range[j].end && range[j].start < end + 1) {
-			range[j].start = end + 1;
-			continue;
-		}
-
-
-		if (start > range[j].start && end >= range[j].end && range[j].end > start - 1) {
-			range[j].end = start - 1;
-			continue;
-		}
-
-		if (start > range[j].start && end < range[j].end) {
-			/* find the new spare */
-			for (i = 0; i < RANGE_NUM; i++) {
-				if (range[i].end == 0)
-					break;
-			}
-			if (i < RANGE_NUM) {
-				range[i].end = range[j].end;
-				range[i].start = end + 1;
-			} else {
-				printk(KERN_ERR "run of slot in ranges\n");
-			}
-			range[j].end = start - 1;
-			continue;
-		}
-	}
-}
-
 struct pci_hostbridge_probe {
 	u32 bus;
 	u32 slot;
@@ -111,6 +61,8 @@ static void __init get_pci_mmcfg_amd_fam
 	fam10h_mmconf_end = base + (1ULL<<(segn_busn_bits + 20)) - 1;
 }
 
+#define RANGE_NUM 16
+
 /**
  * early_fill_mp_bus_to_node()
  * called before pcibios_scan_root and pci_scan_bus
@@ -132,7 +84,7 @@ static int __init early_fill_mp_bus_info
 	struct resource *res;
 	size_t start;
 	size_t end;
-	struct res_range range[RANGE_NUM];
+	struct range range[RANGE_NUM];
 	u64 val;
 	u32 address;
 
@@ -226,7 +178,7 @@ static int __init early_fill_mp_bus_info
 		if (end > 0xffff)
 			end = 0xffff;
 		update_res(info, start, end, IORESOURCE_IO, 1);
-		update_range(range, start, end);
+		subtract_range(range, RANGE_NUM, start, end);
 	}
 	/* add left over io port range to def node/link, [0, 0xffff] */
 	/* find the position */
@@ -256,14 +208,14 @@ static int __init early_fill_mp_bus_info
 	end = (val & 0xffffff800000ULL);
 	printk(KERN_INFO "TOM: %016lx aka %ldM\n", end, end>>20);
 	if (end < (1ULL<<32))
-		update_range(range, 0, end - 1);
+		subtract_range(range, RANGE_NUM, 0, end - 1);
 
 	/* get mmconfig */
 	get_pci_mmcfg_amd_fam10h_range();
 	/* need to take out mmconf range */
 	if (fam10h_mmconf_end) {
 		printk(KERN_DEBUG "Fam 10h mmconf [%llx, %llx]\n", fam10h_mmconf_start, fam10h_mmconf_end);
-		update_range(range, fam10h_mmconf_start, fam10h_mmconf_end);
+		subtract_range(range, RANGE_NUM, fam10h_mmconf_start, fam10h_mmconf_end);
 	}
 
 	/* mmio resource */
@@ -318,7 +270,7 @@ static int __init early_fill_mp_bus_info
 				/* we got a hole */
 				endx = fam10h_mmconf_start - 1;
 				update_res(info, start, endx, IORESOURCE_MEM, 0);
-				update_range(range, start, endx);
+				subtract_range(range, RANGE_NUM, start, endx);
 				printk(KERN_CONT " ==> [%llx, %llx]", (u64)start, endx);
 				start = fam10h_mmconf_end + 1;
 				changed = 1;
@@ -334,7 +286,7 @@ static int __init early_fill_mp_bus_info
 		}
 
 		update_res(info, start, end, IORESOURCE_MEM, 1);
-		update_range(range, start, end);
+		subtract_range(range, RANGE_NUM, start, end);
 		printk(KERN_CONT "\n");
 	}
 
@@ -349,7 +301,7 @@ static int __init early_fill_mp_bus_info
 		rdmsrl(address, val);
 		end = (val & 0xffffff800000ULL);
 		printk(KERN_INFO "TOM2: %016lx aka %ldM\n", end, end>>20);
-		update_range(range, 1ULL<<32, end - 1);
+		subtract_range(range, RANGE_NUM, 1ULL<<32, end - 1);
 	}
 
 	/*

