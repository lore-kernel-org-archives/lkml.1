Return-Path: <linux-kernel-owner+w=401wt.eu-S1758212AbZJEAyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758212AbZJEAyn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 20:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758174AbZJEAym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 20:54:42 -0400
Received: from mail.perches.com ([173.55.12.10]:1666 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758003AbZJEAyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 20:54:37 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [PATCH 03/21] mtrr: use pr_<level> and pr_fmt
Date: Sun,  4 Oct 2009 17:53:30 -0700
Message-Id: <1f9118dfbe7b0b0b67390a28fc73c553558a94d7.1254701151.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1254701151.git.joe@perches.com>
References: <cover.1254701151.git.joe@perches.com>
In-Reply-To: <cover.1254701151.git.joe@perches.com>
References: <cover.1254701151.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added #define pr_fmt(fmt) "mtrr: " fmt
Converted a few printks to pr_<level>
Used pr_dbg for non-optimized-away KERN_DEBUG levels
[FW_WARN] now is printed after "mtrr: ", was before
Fixed a spelling error

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/x86/kernel/cpu/mtrr/centaur.c |    4 ++-
 arch/x86/kernel/cpu/mtrr/cleanup.c |   59 +++++++++++++++++++-----------------
 arch/x86/kernel/cpu/mtrr/generic.c |   39 +++++++++++++-----------
 arch/x86/kernel/cpu/mtrr/main.c    |   32 ++++++++++---------
 4 files changed, 72 insertions(+), 62 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/centaur.c b/arch/x86/kernel/cpu/mtrr/centaur.c
index de89f14..a9168dd 100644
--- a/arch/x86/kernel/cpu/mtrr/centaur.c
+++ b/arch/x86/kernel/cpu/mtrr/centaur.c
@@ -1,3 +1,5 @@
+#define pr_fmt(fmt) "mtrr: " fmt
+
 #include <linux/init.h>
 #include <linux/mm.h>
 
@@ -103,7 +105,7 @@ centaur_validate_add_page(unsigned long base, unsigned long size, unsigned int t
 	 */
 	if (type != MTRR_TYPE_WRCOMB &&
 	    (centaur_mcr_type == 0 || type != MTRR_TYPE_UNCACHABLE)) {
-		pr_warning("mtrr: only write-combining%s supported\n",
+		pr_warning("only write-combining%s supported\n",
 			   centaur_mcr_type ? " and uncacheable are" : " is");
 		return -EINVAL;
 	}
diff --git a/arch/x86/kernel/cpu/mtrr/cleanup.c b/arch/x86/kernel/cpu/mtrr/cleanup.c
index 315738c..15bc2c1 100644
--- a/arch/x86/kernel/cpu/mtrr/cleanup.c
+++ b/arch/x86/kernel/cpu/mtrr/cleanup.c
@@ -17,6 +17,9 @@
  * License along with this library; if not, write to the Free
  * Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
+
+#define pr_fmt(fmt) "mtrr: " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/pci.h>
@@ -62,7 +65,8 @@ static int __initdata				nr_range;
 static struct var_mtrr_range_state __initdata	range_state[RANGE_NUM];
 
 static int __initdata debug_print;
-#define Dprintk(x...) do { if (debug_print) printk(KERN_DEBUG x); } while (0)
+#define Dprintk(fmt, ...)						\
+	do { if (debug_print) pr_dbg(fmt, ##__VA_ARGS__); } while (0)
 
 
 static int __init
@@ -150,7 +154,7 @@ subtract_range(struct res_range *range, unsigned long start, unsigned long end)
 				range[i].end = range[j].end;
 				range[i].start = end + 1;
 			} else {
-				printk(KERN_ERR "run of slot in ranges\n");
+				pr_err("run of slot in ranges\n");
 			}
 			range[j].end = start - 1;
 			continue;
@@ -170,9 +174,6 @@ static int __init cmp_range(const void *x1, const void *x2)
 	return start1 - start2;
 }
 
-#define BIOS_BUG_MSG KERN_WARNING \
-	"WARNING: BIOS bug: VAR MTRR %d contains strange UC entry under 1M, check with your system vendor!\n"
-
 static int __init
 x86_get_mtrr_mem_range(struct res_range *range, int nr_range,
 		       unsigned long extra_remove_base,
@@ -192,10 +193,10 @@ x86_get_mtrr_mem_range(struct res_range *range, int nr_range,
 						base + size - 1);
 	}
 	if (debug_print) {
-		printk(KERN_DEBUG "After WB checking\n");
+		pr_dbg( "After WB checking\n");
 		for (i = 0; i < nr_range; i++)
-			printk(KERN_DEBUG "MTRR MAP PFN: %016lx - %016lx\n",
-				 range[i].start, range[i].end + 1);
+			pr_dbg("MAP PFN: %016lx - %016lx\n",
+			       range[i].start, range[i].end + 1);
 	}
 
 	/* Take out UC ranges: */
@@ -211,7 +212,10 @@ x86_get_mtrr_mem_range(struct res_range *range, int nr_range,
 		if (base < (1<<(20-PAGE_SHIFT)) && mtrr_state.have_fixed &&
 		    (mtrr_state.enabled & 1)) {
 			/* Var MTRR contains UC entry below 1M? Skip it: */
-			printk(BIOS_BUG_MSG, i);
+			pr_warning("WARNING: BIOS bug: "
+				   "VAR MTRR %d contains strange UC entry under 1M, "
+				   "check with your system vendor!\n",
+				   i);
 			if (base + size <= (1<<(20-PAGE_SHIFT)))
 				continue;
 			size -= (1<<(20-PAGE_SHIFT)) - base;
@@ -231,19 +235,19 @@ x86_get_mtrr_mem_range(struct res_range *range, int nr_range,
 		nr_range++;
 	}
 	if  (debug_print) {
-		printk(KERN_DEBUG "After UC checking\n");
+		pr_dbg( "After UC checking\n");
 		for (i = 0; i < nr_range; i++)
-			printk(KERN_DEBUG "MTRR MAP PFN: %016lx - %016lx\n",
-				 range[i].start, range[i].end + 1);
+			pr_dbg("MAP PFN: %016lx - %016lx\n",
+			       range[i].start, range[i].end + 1);
 	}
 
 	/* sort the ranges */
 	sort(range, nr_range, sizeof(struct res_range), cmp_range, NULL);
 	if  (debug_print) {
-		printk(KERN_DEBUG "After sorting\n");
+		pr_dbg( "After sorting\n");
 		for (i = 0; i < nr_range; i++)
-			printk(KERN_DEBUG "MTRR MAP PFN: %016lx - %016lx\n",
-				 range[i].start, range[i].end + 1);
+			pr_dbg("MAP PFN: %016lx - %016lx\n",
+			       range[i].start, range[i].end + 1);
 	}
 
 	/* clear those is not used */
@@ -662,7 +666,7 @@ static void __init print_out_mtrr_range_state(void)
 		start_base = to_size_factor(start_base, &start_factor),
 		type = range_state[i].type;
 
-		printk(KERN_DEBUG "reg %d, base: %ld%cB, range: %ld%cB, type %s\n",
+		pr_dbg( "reg %d, base: %ld%cB, range: %ld%cB, type %s\n",
 			i, start_base, start_factor,
 			size_base, size_factor,
 			(type == MTRR_TYPE_UNCACHABLE) ? "UC" :
@@ -826,7 +830,7 @@ int __init mtrr_cleanup(unsigned address_bits)
 		return 0;
 
 	/* Print original var MTRRs at first, for debugging: */
-	printk(KERN_DEBUG "original variable MTRRs\n");
+	pr_dbg( "original variable MTRRs\n");
 	print_out_mtrr_range_state();
 
 	memset(range, 0, sizeof(range));
@@ -846,8 +850,7 @@ int __init mtrr_cleanup(unsigned address_bits)
 	sort(range, nr_range, sizeof(struct res_range), cmp_range, NULL);
 
 	range_sums = sum_ranges(range, nr_range);
-	printk(KERN_INFO "total RAM coverred: %ldM\n",
-	       range_sums >> (20 - PAGE_SHIFT));
+	pr_info("total RAM covered: %ldM\n", range_sums >> (20 - PAGE_SHIFT));
 
 	if (mtrr_chunk_size && mtrr_gran_size) {
 		i = 0;
@@ -858,12 +861,12 @@ int __init mtrr_cleanup(unsigned address_bits)
 
 		if (!result[i].bad) {
 			set_var_mtrr_all(address_bits);
-			printk(KERN_DEBUG "New variable MTRRs\n");
+			pr_dbg( "New variable MTRRs\n");
 			print_out_mtrr_range_state();
 			return 1;
 		}
-		printk(KERN_INFO "invalid mtrr_gran_size or mtrr_chunk_size, "
-		       "will find optimal one\n");
+		pr_info("invalid mtrr_gran_size or mtrr_chunk_size, "
+			"will find optimal one\n");
 	}
 
 	i = 0;
@@ -881,7 +884,7 @@ int __init mtrr_cleanup(unsigned address_bits)
 				      x_remove_base, x_remove_size, i);
 			if (debug_print) {
 				mtrr_print_out_one_result(i);
-				printk(KERN_INFO "\n");
+				pr_info("\n");
 			}
 
 			i++;
@@ -892,7 +895,7 @@ int __init mtrr_cleanup(unsigned address_bits)
 	index_good = mtrr_search_optimal_index();
 
 	if (index_good != -1) {
-		printk(KERN_INFO "Found optimal setting for mtrr clean up\n");
+		pr_info("Found optimal setting for mtrr clean up\n");
 		i = index_good;
 		mtrr_print_out_one_result(i);
 
@@ -903,7 +906,7 @@ int __init mtrr_cleanup(unsigned address_bits)
 		gran_size <<= 10;
 		x86_setup_var_mtrrs(range, nr_range, chunk_size, gran_size);
 		set_var_mtrr_all(address_bits);
-		printk(KERN_DEBUG "New variable MTRRs\n");
+		pr_dbg( "New variable MTRRs\n");
 		print_out_mtrr_range_state();
 		return 1;
 	} else {
@@ -912,8 +915,8 @@ int __init mtrr_cleanup(unsigned address_bits)
 			mtrr_print_out_one_result(i);
 	}
 
-	printk(KERN_INFO "mtrr_cleanup: can not find optimal value\n");
-	printk(KERN_INFO "please specify mtrr_gran_size/mtrr_chunk_size\n");
+	pr_info("%s: can not find optimal value\n", __func__);
+	pr_info("please specify mtrr_gran_size/mtrr_chunk_size\n");
 
 	return 0;
 }
@@ -1031,7 +1034,7 @@ int __init mtrr_trim_uncached_memory(unsigned long end_pfn)
 
 	/* kvm/qemu doesn't have mtrr set right, don't trim them all: */
 	if (!highest_pfn) {
-		printk(KERN_INFO "CPU MTRRs all blank - virtualized system.\n");
+		pr_info("CPU MTRRs all blank - virtualized system.\n");
 		return 0;
 	}
 
diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index 55da0c5..c8d5e8b 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -2,6 +2,9 @@
  * This only handles 32bit MTRR on 32bit hosts. This is strictly wrong
  * because MTRRs can span upto 40 bits (36bits on most modern x86)
  */
+
+#define pr_fmt(fmt) "mtrr: " fmt
+
 #define DEBUG
 
 #include <linux/module.h>
@@ -57,7 +60,7 @@ static inline void k8_check_syscfg_dram_mod_en(void)
 
 	rdmsr(MSR_K8_SYSCFG, lo, hi);
 	if (lo & K8_MTRRFIXRANGE_DRAM_MODIFY) {
-		printk(KERN_ERR FW_WARN "MTRR: CPU %u: SYSCFG[MtrrFixDramModEn]"
+		pr_err(FW_WARN "CPU %u: SYSCFG[MtrrFixDramModEn]"
 		       " not cleared by BIOS, clearing this bit\n",
 		       smp_processor_id());
 		lo &= ~K8_MTRRFIXRANGE_DRAM_MODIFY;
@@ -261,10 +264,10 @@ static void __init print_mtrr_state(void)
 	unsigned int i;
 	int high_width;
 
-	pr_debug("MTRR default type: %s\n",
+	pr_debug("default type: %s\n",
 		 mtrr_attrib_to_str(mtrr_state.def_type));
 	if (mtrr_state.have_fixed) {
-		pr_debug("MTRR fixed ranges %sabled:\n",
+		pr_debug("fixed ranges %sabled:\n",
 			 mtrr_state.enabled & 1 ? "en" : "dis");
 		print_fixed(0x00000, 0x10000, mtrr_state.fixed_ranges + 0);
 		for (i = 0; i < 2; ++i)
@@ -277,7 +280,7 @@ static void __init print_mtrr_state(void)
 		/* tail */
 		print_fixed_last();
 	}
-	pr_debug("MTRR variable ranges %sabled:\n",
+	pr_debug("variable ranges %sabled:\n",
 		 mtrr_state.enabled & 2 ? "en" : "dis");
 	if (size_or_mask & 0xffffffffUL)
 		high_width = ffs(size_or_mask & 0xffffffffUL) - 1;
@@ -358,14 +361,14 @@ void __init mtrr_state_warn(void)
 	if (!mask)
 		return;
 	if (mask & MTRR_CHANGE_MASK_FIXED)
-		pr_warning("mtrr: your CPUs had inconsistent fixed MTRR settings\n");
+		pr_warning("your CPUs had inconsistent fixed MTRR settings\n");
 	if (mask & MTRR_CHANGE_MASK_VARIABLE)
-		pr_warning("mtrr: your CPUs had inconsistent variable MTRR settings\n");
+		pr_warning("your CPUs had inconsistent variable MTRR settings\n");
 	if (mask & MTRR_CHANGE_MASK_DEFTYPE)
-		pr_warning("mtrr: your CPUs had inconsistent MTRRdefType settings\n");
+		pr_warning("your CPUs had inconsistent MTRRdefType settings\n");
 
-	printk(KERN_INFO "mtrr: probably your BIOS does not setup all CPUs.\n");
-	printk(KERN_INFO "mtrr: corrected configuration.\n");
+	pr_info("probably your BIOS does not setup all CPUs.\n");
+	pr_info("corrected configuration.\n");
 }
 
 /*
@@ -375,11 +378,9 @@ void __init mtrr_state_warn(void)
  */
 void mtrr_wrmsr(unsigned msr, unsigned a, unsigned b)
 {
-	if (wrmsr_safe(msr, a, b) < 0) {
-		printk(KERN_ERR
-			"MTRR: CPU %u: Writing MSR %x to %x:%x failed\n",
-			smp_processor_id(), msr, a, b);
-	}
+	if (wrmsr_safe(msr, a, b) < 0)
+		pr_err("CPU %u: Writing MSR %x to %x:%x failed\n",
+		       smp_processor_id(), msr, a, b);
 }
 
 /**
@@ -464,7 +465,7 @@ static void generic_get_mtrr(unsigned int reg, unsigned long *base,
 		tmp |= ~((1<<(hi - 1)) - 1);
 
 		if (tmp != mask_lo) {
-			WARN_ONCE(1, KERN_INFO "mtrr: your BIOS has set up an incorrect mask, fixing it up.\n");
+			WARN_ONCE(1, KERN_INFO pr_fmt("your BIOS has set up an incorrect mask, fixing it up.\n"));
 			mask_lo = tmp;
 		}
 	}
@@ -711,13 +712,14 @@ int generic_validate_add_page(unsigned long base, unsigned long size,
 	    boot_cpu_data.x86_model == 1 &&
 	    boot_cpu_data.x86_mask <= 7) {
 		if (base & ((1 << (22 - PAGE_SHIFT)) - 1)) {
-			pr_warning("mtrr: base(0x%lx000) is not 4 MiB aligned\n", base);
+			pr_warning("base(0x%lx000) is not 4 MiB aligned\n",
+				   base);
 			return -EINVAL;
 		}
 		if (!(base + size < 0x70000 || base > 0x7003F) &&
 		    (type == MTRR_TYPE_WRCOMB
 		     || type == MTRR_TYPE_WRBACK)) {
-			pr_warning("mtrr: writable mtrr between 0x70000000 and 0x7003FFFF may hang the CPU.\n");
+			pr_warning("writable mtrr between 0x70000000 and 0x7003FFFF may hang the CPU.\n");
 			return -EINVAL;
 		}
 	}
@@ -731,7 +733,8 @@ int generic_validate_add_page(unsigned long base, unsigned long size,
 	     lbase = lbase >> 1, last = last >> 1)
 		;
 	if (lbase != last) {
-		pr_warning("mtrr: base(0x%lx000) is not aligned on a size(0x%lx000) boundary\n", base, size);
+		pr_warning("base(0x%lx000) is not aligned on a size(0x%lx000) boundary\n",
+			   base, size);
 		return -EINVAL;
 	}
 	return 0;
diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index 84e83de..e6e4303 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -31,6 +31,8 @@
     System Programming Guide; Section 9.11. (1997 edition - PPro).
 */
 
+#define pr_fmt(fmt) "mtrr: " fmt
+
 #define DEBUG
 
 #include <linux/types.h> /* FIXME: kvm_para.h needs this */
@@ -90,7 +92,7 @@ static int have_wrcomb(void)
 		    dev->device == PCI_DEVICE_ID_SERVERWORKS_LE) {
 			pci_read_config_byte(dev, PCI_CLASS_REVISION, &rev);
 			if (rev <= 5) {
-				pr_info("mtrr: Serverworks LE rev < 6 detected. Write-combining disabled.\n");
+				pr_info("Serverworks LE rev < 6 detected. Write-combining disabled.\n");
 				pci_dev_put(dev);
 				return 0;
 			}
@@ -101,7 +103,7 @@ static int have_wrcomb(void)
 		 */
 		if (dev->vendor == PCI_VENDOR_ID_INTEL &&
 		    dev->device == PCI_DEVICE_ID_INTEL_82451NX) {
-			pr_info("mtrr: Intel 450NX MMC detected. Write-combining disabled.\n");
+			pr_info("Intel 450NX MMC detected. Write-combining disabled.\n");
 			pci_dev_put(dev);
 			return 0;
 		}
@@ -340,23 +342,23 @@ int mtrr_add_page(unsigned long base, unsigned long size,
 		return error;
 
 	if (type >= MTRR_NUM_TYPES) {
-		pr_warning("mtrr: type: %u invalid\n", type);
+		pr_warning("type: %u invalid\n", type);
 		return -EINVAL;
 	}
 
 	/* If the type is WC, check that this processor supports it */
 	if ((type == MTRR_TYPE_WRCOMB) && !have_wrcomb()) {
-		pr_warning("mtrr: your processor doesn't support write-combining\n");
+		pr_warning("your processor doesn't support write-combining\n");
 		return -ENOSYS;
 	}
 
 	if (!size) {
-		pr_warning("mtrr: zero sized request\n");
+		pr_warning("zero sized request\n");
 		return -EINVAL;
 	}
 
 	if (base & size_or_mask || size & size_or_mask) {
-		pr_warning("mtrr: base or size exceeds the MTRR width\n");
+		pr_warning("base or size exceeds the MTRR width\n");
 		return -EINVAL;
 	}
 
@@ -387,7 +389,7 @@ int mtrr_add_page(unsigned long base, unsigned long size,
 				} else if (types_compatible(type, ltype))
 					continue;
 			}
-			pr_warning("mtrr: 0x%lx000,0x%lx000 overlaps existing"
+			pr_warning("0x%lx000,0x%lx000 overlaps existing"
 				" 0x%lx000,0x%lx000\n", base, size, lbase,
 				lsize);
 			goto out;
@@ -396,7 +398,7 @@ int mtrr_add_page(unsigned long base, unsigned long size,
 		if (ltype != type) {
 			if (types_compatible(type, ltype))
 				continue;
-			pr_warning("mtrr: type mismatch for %lx000,%lx000 old: %s new: %s\n",
+			pr_warning("type mismatch for %lx000,%lx000 old: %s new: %s\n",
 				base, size, mtrr_attrib_to_str(ltype),
 				mtrr_attrib_to_str(type));
 			goto out;
@@ -422,7 +424,7 @@ int mtrr_add_page(unsigned long base, unsigned long size,
 			}
 		}
 	} else {
-		pr_info("mtrr: no more MTRRs available\n");
+		pr_info("no more MTRRs available\n");
 	}
 	error = i;
  out:
@@ -434,8 +436,8 @@ int mtrr_add_page(unsigned long base, unsigned long size,
 static int mtrr_check(unsigned long base, unsigned long size)
 {
 	if ((base & (PAGE_SIZE - 1)) || (size & (PAGE_SIZE - 1))) {
-		pr_warning("mtrr: size and base must be multiples of 4 kiB\n");
-		pr_debug("mtrr: size: 0x%lx  base: 0x%lx\n", size, base);
+		pr_warning("size and base must be multiples of 4 kiB\n");
+		pr_debug("size: 0x%lx  base: 0x%lx\n", size, base);
 		dump_stack();
 		return -1;
 	}
@@ -525,22 +527,22 @@ int mtrr_del_page(int reg, unsigned long base, unsigned long size)
 			}
 		}
 		if (reg < 0) {
-			pr_debug("mtrr: no MTRR for %lx000,%lx000 found\n",
+			pr_debug("no MTRR for %lx000,%lx000 found\n",
 				 base, size);
 			goto out;
 		}
 	}
 	if (reg >= max) {
-		pr_warning("mtrr: register: %d too big\n", reg);
+		pr_warning("register: %d too big\n", reg);
 		goto out;
 	}
 	mtrr_if->get(reg, &lbase, &lsize, &ltype);
 	if (lsize < 1) {
-		pr_warning("mtrr: MTRR %d not used\n", reg);
+		pr_warning("MTRR %d not used\n", reg);
 		goto out;
 	}
 	if (mtrr_usage_table[reg] < 1) {
-		pr_warning("mtrr: reg: %d has count=0\n", reg);
+		pr_warning("reg: %d has count=0\n", reg);
 		goto out;
 	}
 	if (--mtrr_usage_table[reg] < 1)
-- 
1.6.3.1.10.g659a0.dirty

