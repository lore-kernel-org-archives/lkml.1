Return-Path: <linux-kernel-owner+w=401wt.eu-S1756707AbZGDKIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707AbZGDKIg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 06:08:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756559AbZGDKIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 06:08:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:47427 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756406AbZGDKIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 06:08:10 -0400
Date: Sat, 4 Jul 2009 10:07:26 GMT
From: tip-bot for Jaswinder Singh Rajput <jaswinder@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, jaswinder@kernel.org, alan@lxorguk.ukuu.org.uk,
       jaswinderrajput@gmail.com, akpm@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, jaswinder@kernel.org, alan@lxorguk.ukuu.org.uk,
       jaswinderrajput@gmail.com, akpm@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090703164225.GA21447@elte.hu>
References: <20090703164225.GA21447@elte.hu>
Subject: [tip:x86/cleanups] x86: Clean up mtrr/generic.c
Message-ID: <tip-a1a499a39911fcfecbebaba1f38588088909f918@git.kernel.org>
Git-Commit-ID: a1a499a39911fcfecbebaba1f38588088909f918
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 04 Jul 2009 10:07:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a1a499a39911fcfecbebaba1f38588088909f918
Gitweb:     http://git.kernel.org/tip/a1a499a39911fcfecbebaba1f38588088909f918
Author:     Jaswinder Singh Rajput <jaswinder@kernel.org>
AuthorDate: Sat, 4 Jul 2009 07:53:00 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 4 Jul 2009 11:10:47 +0200

x86: Clean up mtrr/generic.c

Fix following trivial style problems:

  ERROR: trailing whitespace X 4
  WARNING: Use #include <linux/io.h> instead of <asm/io.h>
  WARNING: braces {} are not necessary for single statement blocks X 3
  ERROR: "foo * bar" should be "foo *bar"
  WARNING: line over 80 characters X 6
  ERROR: "foo * bar" should be "foo *bar"
  ERROR: spaces required around that '=' (ctx:VxO)
  ERROR: space required before that '-' (ctx:OxV)
  WARNING: suspect code indent for conditional statements (8, 12)
  ERROR: spaces required around that '=' (ctx:VxV)
  ERROR: do not initialise statics to 0 or NULL
  ERROR: space prohibited after that open parenthesis '(' X 2
  ERROR: space prohibited before that close parenthesis ')' X 2
  ERROR: trailing statements should be on next line
  ERROR: return is not a function, parentheses are not required

Also use pr_debug and pr_warning where possible.

arch/x86/kernel/cpu/mtrr/generic.o:

   text	   data	    bss	    dec	    hex	filename
   5652	     77	   4224	   9953	   26e1	generic.o.before
   5652	     77	   4220	   9949	   26dd	generic.o.after

The md5 changed:
   b34d6c045f06daa4ed092b90cc760e8f  generic.o.before.asm
   a490c6251cfd8442fbffecc0e09a573d  generic.o.after.asm

Because mtrr_state moved from data to bss, changing its
offsets - and also because __LINE__ numbers changed.

Suggested-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <20090703164225.GA21447@elte.hu>
[ Further cleanups to make the code more consistent ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/mtrr/generic.c |  304 ++++++++++++++++++++----------------
 1 files changed, 169 insertions(+), 135 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index 0543f69..55da0c5 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -1,28 +1,34 @@
-/* This only handles 32bit MTRR on 32bit hosts. This is strictly wrong
-   because MTRRs can span upto 40 bits (36bits on most modern x86) */ 
+/*
+ * This only handles 32bit MTRR on 32bit hosts. This is strictly wrong
+ * because MTRRs can span upto 40 bits (36bits on most modern x86)
+ */
+#define DEBUG
+
+#include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
+#include <linux/io.h>
 #include <linux/mm.h>
-#include <linux/module.h>
-#include <asm/io.h>
-#include <asm/mtrr.h>
-#include <asm/msr.h>
-#include <asm/system.h>
-#include <asm/cpufeature.h>
+
 #include <asm/processor-flags.h>
+#include <asm/cpufeature.h>
 #include <asm/tlbflush.h>
+#include <asm/system.h>
+#include <asm/mtrr.h>
+#include <asm/msr.h>
 #include <asm/pat.h>
+
 #include "mtrr.h"
 
 struct fixed_range_block {
-	int base_msr; /* start address of an MTRR block */
-	int ranges;   /* number of MTRRs in this block  */
+	int base_msr;		/* start address of an MTRR block */
+	int ranges;		/* number of MTRRs in this block  */
 };
 
 static struct fixed_range_block fixed_range_blocks[] = {
-	{ MSR_MTRRfix64K_00000, 1 }, /* one  64k MTRR  */
-	{ MSR_MTRRfix16K_80000, 2 }, /* two  16k MTRRs */
-	{ MSR_MTRRfix4K_C0000,  8 }, /* eight 4k MTRRs */
+	{ MSR_MTRRfix64K_00000, 1 }, /* one   64k MTRR  */
+	{ MSR_MTRRfix16K_80000, 2 }, /* two   16k MTRRs */
+	{ MSR_MTRRfix4K_C0000,  8 }, /* eight  4k MTRRs */
 	{}
 };
 
@@ -30,10 +36,10 @@ static unsigned long smp_changes_mask;
 static int mtrr_state_set;
 u64 mtrr_tom2;
 
-struct mtrr_state_type mtrr_state = {};
+struct mtrr_state_type mtrr_state;
 EXPORT_SYMBOL_GPL(mtrr_state);
 
-/**
+/*
  * BIOS is expected to clear MtrrFixDramModEn bit, see for example
  * "BIOS and Kernel Developer's Guide for the AMD Athlon 64 and AMD
  * Opteron Processors" (26094 Rev. 3.30 February 2006), section
@@ -104,9 +110,8 @@ u8 mtrr_type_lookup(u64 start, u64 end)
 	 * Look of multiple ranges matching this address and pick type
 	 * as per MTRR precedence
 	 */
-	if (!(mtrr_state.enabled & 2)) {
+	if (!(mtrr_state.enabled & 2))
 		return mtrr_state.def_type;
-	}
 
 	prev_match = 0xFF;
 	for (i = 0; i < num_var_ranges; ++i) {
@@ -125,9 +130,8 @@ u8 mtrr_type_lookup(u64 start, u64 end)
 		if (start_state != end_state)
 			return 0xFE;
 
-		if ((start & mask) != (base & mask)) {
+		if ((start & mask) != (base & mask))
 			continue;
-		}
 
 		curr_match = mtrr_state.var_ranges[i].base_lo & 0xff;
 		if (prev_match == 0xFF) {
@@ -148,9 +152,8 @@ u8 mtrr_type_lookup(u64 start, u64 end)
 			curr_match = MTRR_TYPE_WRTHROUGH;
 		}
 
-		if (prev_match != curr_match) {
+		if (prev_match != curr_match)
 			return MTRR_TYPE_UNCACHABLE;
-		}
 	}
 
 	if (mtrr_tom2) {
@@ -164,7 +167,7 @@ u8 mtrr_type_lookup(u64 start, u64 end)
 	return mtrr_state.def_type;
 }
 
-/*  Get the MSR pair relating to a var range  */
+/* Get the MSR pair relating to a var range */
 static void
 get_mtrr_var_range(unsigned int index, struct mtrr_var_range *vr)
 {
@@ -172,7 +175,7 @@ get_mtrr_var_range(unsigned int index, struct mtrr_var_range *vr)
 	rdmsr(MTRRphysMask_MSR(index), vr->mask_lo, vr->mask_hi);
 }
 
-/*  fill the MSR pair relating to a var range  */
+/* Fill the MSR pair relating to a var range */
 void fill_mtrr_var_range(unsigned int index,
 		u32 base_lo, u32 base_hi, u32 mask_lo, u32 mask_hi)
 {
@@ -186,10 +189,9 @@ void fill_mtrr_var_range(unsigned int index,
 	vr[index].mask_hi = mask_hi;
 }
 
-static void
-get_fixed_ranges(mtrr_type * frs)
+static void get_fixed_ranges(mtrr_type *frs)
 {
-	unsigned int *p = (unsigned int *) frs;
+	unsigned int *p = (unsigned int *)frs;
 	int i;
 
 	k8_check_syscfg_dram_mod_en();
@@ -217,22 +219,22 @@ static void __init print_fixed_last(void)
 	if (!last_fixed_end)
 		return;
 
-	printk(KERN_DEBUG "  %05X-%05X %s\n", last_fixed_start,
-		last_fixed_end - 1, mtrr_attrib_to_str(last_fixed_type));
+	pr_debug("  %05X-%05X %s\n", last_fixed_start,
+		 last_fixed_end - 1, mtrr_attrib_to_str(last_fixed_type));
 
 	last_fixed_end = 0;
 }
 
 static void __init update_fixed_last(unsigned base, unsigned end,
-				       mtrr_type type)
+				     mtrr_type type)
 {
 	last_fixed_start = base;
 	last_fixed_end = end;
 	last_fixed_type = type;
 }
 
-static void __init print_fixed(unsigned base, unsigned step,
-			       const mtrr_type *types)
+static void __init
+print_fixed(unsigned base, unsigned step, const mtrr_type *types)
 {
 	unsigned i;
 
@@ -259,54 +261,55 @@ static void __init print_mtrr_state(void)
 	unsigned int i;
 	int high_width;
 
-	printk(KERN_DEBUG "MTRR default type: %s\n",
-			 mtrr_attrib_to_str(mtrr_state.def_type));
+	pr_debug("MTRR default type: %s\n",
+		 mtrr_attrib_to_str(mtrr_state.def_type));
 	if (mtrr_state.have_fixed) {
-		printk(KERN_DEBUG "MTRR fixed ranges %sabled:\n",
-		       mtrr_state.enabled & 1 ? "en" : "dis");
+		pr_debug("MTRR fixed ranges %sabled:\n",
+			 mtrr_state.enabled & 1 ? "en" : "dis");
 		print_fixed(0x00000, 0x10000, mtrr_state.fixed_ranges + 0);
 		for (i = 0; i < 2; ++i)
-			print_fixed(0x80000 + i * 0x20000, 0x04000, mtrr_state.fixed_ranges + (i + 1) * 8);
+			print_fixed(0x80000 + i * 0x20000, 0x04000,
+				    mtrr_state.fixed_ranges + (i + 1) * 8);
 		for (i = 0; i < 8; ++i)
-			print_fixed(0xC0000 + i * 0x08000, 0x01000, mtrr_state.fixed_ranges + (i + 3) * 8);
+			print_fixed(0xC0000 + i * 0x08000, 0x01000,
+				    mtrr_state.fixed_ranges + (i + 3) * 8);
 
 		/* tail */
 		print_fixed_last();
 	}
-	printk(KERN_DEBUG "MTRR variable ranges %sabled:\n",
-	       mtrr_state.enabled & 2 ? "en" : "dis");
+	pr_debug("MTRR variable ranges %sabled:\n",
+		 mtrr_state.enabled & 2 ? "en" : "dis");
 	if (size_or_mask & 0xffffffffUL)
 		high_width = ffs(size_or_mask & 0xffffffffUL) - 1;
 	else
 		high_width = ffs(size_or_mask>>32) + 32 - 1;
 	high_width = (high_width - (32 - PAGE_SHIFT) + 3) / 4;
+
 	for (i = 0; i < num_var_ranges; ++i) {
 		if (mtrr_state.var_ranges[i].mask_lo & (1 << 11))
-			printk(KERN_DEBUG "  %u base %0*X%05X000 mask %0*X%05X000 %s\n",
-			       i,
-			       high_width,
-			       mtrr_state.var_ranges[i].base_hi,
-			       mtrr_state.var_ranges[i].base_lo >> 12,
-			       high_width,
-			       mtrr_state.var_ranges[i].mask_hi,
-			       mtrr_state.var_ranges[i].mask_lo >> 12,
-			       mtrr_attrib_to_str(mtrr_state.var_ranges[i].base_lo & 0xff));
+			pr_debug("  %u base %0*X%05X000 mask %0*X%05X000 %s\n",
+				 i,
+				 high_width,
+				 mtrr_state.var_ranges[i].base_hi,
+				 mtrr_state.var_ranges[i].base_lo >> 12,
+				 high_width,
+				 mtrr_state.var_ranges[i].mask_hi,
+				 mtrr_state.var_ranges[i].mask_lo >> 12,
+				 mtrr_attrib_to_str(mtrr_state.var_ranges[i].base_lo & 0xff));
 		else
-			printk(KERN_DEBUG "  %u disabled\n", i);
-	}
-	if (mtrr_tom2) {
-		printk(KERN_DEBUG "TOM2: %016llx aka %lldM\n",
-				  mtrr_tom2, mtrr_tom2>>20);
+			pr_debug("  %u disabled\n", i);
 	}
+	if (mtrr_tom2)
+		pr_debug("TOM2: %016llx aka %lldM\n", mtrr_tom2, mtrr_tom2>>20);
 }
 
-/*  Grab all of the MTRR state for this CPU into *state  */
+/* Grab all of the MTRR state for this CPU into *state */
 void __init get_mtrr_state(void)
 {
-	unsigned int i;
 	struct mtrr_var_range *vrs;
-	unsigned lo, dummy;
 	unsigned long flags;
+	unsigned lo, dummy;
+	unsigned int i;
 
 	vrs = mtrr_state.var_ranges;
 
@@ -324,6 +327,7 @@ void __init get_mtrr_state(void)
 
 	if (amd_special_default_mtrr()) {
 		unsigned low, high;
+
 		/* TOP_MEM2 */
 		rdmsr(MSR_K8_TOP_MEM2, low, high);
 		mtrr_tom2 = high;
@@ -344,10 +348,9 @@ void __init get_mtrr_state(void)
 
 	post_set();
 	local_irq_restore(flags);
-
 }
 
-/*  Some BIOS's are fucked and don't set all MTRRs the same!  */
+/* Some BIOS's are messed up and don't set all MTRRs the same! */
 void __init mtrr_state_warn(void)
 {
 	unsigned long mask = smp_changes_mask;
@@ -355,28 +358,33 @@ void __init mtrr_state_warn(void)
 	if (!mask)
 		return;
 	if (mask & MTRR_CHANGE_MASK_FIXED)
-		printk(KERN_WARNING "mtrr: your CPUs had inconsistent fixed MTRR settings\n");
+		pr_warning("mtrr: your CPUs had inconsistent fixed MTRR settings\n");
 	if (mask & MTRR_CHANGE_MASK_VARIABLE)
-		printk(KERN_WARNING "mtrr: your CPUs had inconsistent variable MTRR settings\n");
+		pr_warning("mtrr: your CPUs had inconsistent variable MTRR settings\n");
 	if (mask & MTRR_CHANGE_MASK_DEFTYPE)
-		printk(KERN_WARNING "mtrr: your CPUs had inconsistent MTRRdefType settings\n");
+		pr_warning("mtrr: your CPUs had inconsistent MTRRdefType settings\n");
+
 	printk(KERN_INFO "mtrr: probably your BIOS does not setup all CPUs.\n");
 	printk(KERN_INFO "mtrr: corrected configuration.\n");
 }
 
-/* Doesn't attempt to pass an error out to MTRR users
-   because it's quite complicated in some cases and probably not
-   worth it because the best error handling is to ignore it. */
+/*
+ * Doesn't attempt to pass an error out to MTRR users
+ * because it's quite complicated in some cases and probably not
+ * worth it because the best error handling is to ignore it.
+ */
 void mtrr_wrmsr(unsigned msr, unsigned a, unsigned b)
 {
-	if (wrmsr_safe(msr, a, b) < 0)
+	if (wrmsr_safe(msr, a, b) < 0) {
 		printk(KERN_ERR
 			"MTRR: CPU %u: Writing MSR %x to %x:%x failed\n",
 			smp_processor_id(), msr, a, b);
+	}
 }
 
 /**
- * set_fixed_range - checks & updates a fixed-range MTRR if it differs from the value it should have
+ * set_fixed_range - checks & updates a fixed-range MTRR if it
+ *		     differs from the value it should have
  * @msr: MSR address of the MTTR which should be checked and updated
  * @changed: pointer which indicates whether the MTRR needed to be changed
  * @msrwords: pointer to the MSR values which the MSR should have
@@ -401,20 +409,23 @@ static void set_fixed_range(int msr, bool *changed, unsigned int *msrwords)
  *
  * Returns: The index of the region on success, else negative on error.
  */
-int generic_get_free_region(unsigned long base, unsigned long size, int replace_reg)
+int
+generic_get_free_region(unsigned long base, unsigned long size, int replace_reg)
 {
-	int i, max;
-	mtrr_type ltype;
 	unsigned long lbase, lsize;
+	mtrr_type ltype;
+	int i, max;
 
 	max = num_var_ranges;
 	if (replace_reg >= 0 && replace_reg < max)
 		return replace_reg;
+
 	for (i = 0; i < max; ++i) {
 		mtrr_if->get(i, &lbase, &lsize, &ltype);
 		if (lsize == 0)
 			return i;
 	}
+
 	return -ENOSPC;
 }
 
@@ -434,7 +445,7 @@ static void generic_get_mtrr(unsigned int reg, unsigned long *base,
 	rdmsr(MTRRphysMask_MSR(reg), mask_lo, mask_hi);
 
 	if ((mask_lo & 0x800) == 0) {
-		/*  Invalid (i.e. free) range  */
+		/*  Invalid (i.e. free) range */
 		*base = 0;
 		*size = 0;
 		*type = 0;
@@ -471,27 +482,31 @@ out_put_cpu:
 }
 
 /**
- * set_fixed_ranges - checks & updates the fixed-range MTRRs if they differ from the saved set
+ * set_fixed_ranges - checks & updates the fixed-range MTRRs if they
+ *		      differ from the saved set
  * @frs: pointer to fixed-range MTRR values, saved by get_fixed_ranges()
  */
-static int set_fixed_ranges(mtrr_type * frs)
+static int set_fixed_ranges(mtrr_type *frs)
 {
-	unsigned long long *saved = (unsigned long long *) frs;
+	unsigned long long *saved = (unsigned long long *)frs;
 	bool changed = false;
-	int block=-1, range;
+	int block = -1, range;
 
 	k8_check_syscfg_dram_mod_en();
 
-	while (fixed_range_blocks[++block].ranges)
-	    for (range=0; range < fixed_range_blocks[block].ranges; range++)
-		set_fixed_range(fixed_range_blocks[block].base_msr + range,
-		    &changed, (unsigned int *) saved++);
+	while (fixed_range_blocks[++block].ranges) {
+		for (range = 0; range < fixed_range_blocks[block].ranges; range++)
+			set_fixed_range(fixed_range_blocks[block].base_msr + range,
+					&changed, (unsigned int *)saved++);
+	}
 
 	return changed;
 }
 
-/*  Set the MSR pair relating to a var range. Returns TRUE if
-    changes are made  */
+/*
+ * Set the MSR pair relating to a var range.
+ * Returns true if changes are made.
+ */
 static bool set_mtrr_var_ranges(unsigned int index, struct mtrr_var_range *vr)
 {
 	unsigned int lo, hi;
@@ -501,6 +516,7 @@ static bool set_mtrr_var_ranges(unsigned int index, struct mtrr_var_range *vr)
 	if ((vr->base_lo & 0xfffff0ffUL) != (lo & 0xfffff0ffUL)
 	    || (vr->base_hi & (size_and_mask >> (32 - PAGE_SHIFT))) !=
 		(hi & (size_and_mask >> (32 - PAGE_SHIFT)))) {
+
 		mtrr_wrmsr(MTRRphysBase_MSR(index), vr->base_lo, vr->base_hi);
 		changed = true;
 	}
@@ -526,21 +542,26 @@ static u32 deftype_lo, deftype_hi;
  */
 static unsigned long set_mtrr_state(void)
 {
-	unsigned int i;
 	unsigned long change_mask = 0;
+	unsigned int i;
 
-	for (i = 0; i < num_var_ranges; i++)
+	for (i = 0; i < num_var_ranges; i++) {
 		if (set_mtrr_var_ranges(i, &mtrr_state.var_ranges[i]))
 			change_mask |= MTRR_CHANGE_MASK_VARIABLE;
+	}
 
 	if (mtrr_state.have_fixed && set_fixed_ranges(mtrr_state.fixed_ranges))
 		change_mask |= MTRR_CHANGE_MASK_FIXED;
 
-	/*  Set_mtrr_restore restores the old value of MTRRdefType,
-	   so to set it we fiddle with the saved value  */
+	/*
+	 * Set_mtrr_restore restores the old value of MTRRdefType,
+	 * so to set it we fiddle with the saved value:
+	 */
 	if ((deftype_lo & 0xff) != mtrr_state.def_type
 	    || ((deftype_lo & 0xc00) >> 10) != mtrr_state.enabled) {
-		deftype_lo = (deftype_lo & ~0xcff) | mtrr_state.def_type | (mtrr_state.enabled << 10);
+
+		deftype_lo = (deftype_lo & ~0xcff) | mtrr_state.def_type |
+			     (mtrr_state.enabled << 10);
 		change_mask |= MTRR_CHANGE_MASK_DEFTYPE;
 	}
 
@@ -548,33 +569,36 @@ static unsigned long set_mtrr_state(void)
 }
 
 
-static unsigned long cr4 = 0;
+static unsigned long cr4;
 static DEFINE_SPINLOCK(set_atomicity_lock);
 
 /*
- * Since we are disabling the cache don't allow any interrupts - they
- * would run extremely slow and would only increase the pain.  The caller must
- * ensure that local interrupts are disabled and are reenabled after post_set()
- * has been called.
+ * Since we are disabling the cache don't allow any interrupts,
+ * they would run extremely slow and would only increase the pain.
+ *
+ * The caller must ensure that local interrupts are disabled and
+ * are reenabled after post_set() has been called.
  */
-
 static void prepare_set(void) __acquires(set_atomicity_lock)
 {
 	unsigned long cr0;
 
-	/*  Note that this is not ideal, since the cache is only flushed/disabled
-	   for this CPU while the MTRRs are changed, but changing this requires
-	   more invasive changes to the way the kernel boots  */
+	/*
+	 * Note that this is not ideal
+	 * since the cache is only flushed/disabled for this CPU while the
+	 * MTRRs are changed, but changing this requires more invasive
+	 * changes to the way the kernel boots
+	 */
 
 	spin_lock(&set_atomicity_lock);
 
-	/*  Enter the no-fill (CD=1, NW=0) cache mode and flush caches. */
+	/* Enter the no-fill (CD=1, NW=0) cache mode and flush caches. */
 	cr0 = read_cr0() | X86_CR0_CD;
 	write_cr0(cr0);
 	wbinvd();
 
-	/*  Save value of CR4 and clear Page Global Enable (bit 7)  */
-	if ( cpu_has_pge ) {
+	/* Save value of CR4 and clear Page Global Enable (bit 7) */
+	if (cpu_has_pge) {
 		cr4 = read_cr4();
 		write_cr4(cr4 & ~X86_CR4_PGE);
 	}
@@ -582,26 +606,26 @@ static void prepare_set(void) __acquires(set_atomicity_lock)
 	/* Flush all TLBs via a mov %cr3, %reg; mov %reg, %cr3 */
 	__flush_tlb();
 
-	/*  Save MTRR state */
+	/* Save MTRR state */
 	rdmsr(MSR_MTRRdefType, deftype_lo, deftype_hi);
 
-	/*  Disable MTRRs, and set the default type to uncached  */
+	/* Disable MTRRs, and set the default type to uncached */
 	mtrr_wrmsr(MSR_MTRRdefType, deftype_lo & ~0xcff, deftype_hi);
 }
 
 static void post_set(void) __releases(set_atomicity_lock)
 {
-	/*  Flush TLBs (no need to flush caches - they are disabled)  */
+	/* Flush TLBs (no need to flush caches - they are disabled) */
 	__flush_tlb();
 
 	/* Intel (P6) standard MTRRs */
 	mtrr_wrmsr(MSR_MTRRdefType, deftype_lo, deftype_hi);
-		
-	/*  Enable caches  */
+
+	/* Enable caches */
 	write_cr0(read_cr0() & 0xbfffffff);
 
-	/*  Restore value of CR4  */
-	if ( cpu_has_pge )
+	/* Restore value of CR4 */
+	if (cpu_has_pge)
 		write_cr4(cr4);
 	spin_unlock(&set_atomicity_lock);
 }
@@ -623,24 +647,27 @@ static void generic_set_all(void)
 	post_set();
 	local_irq_restore(flags);
 
-	/*  Use the atomic bitops to update the global mask  */
+	/* Use the atomic bitops to update the global mask */
 	for (count = 0; count < sizeof mask * 8; ++count) {
 		if (mask & 0x01)
 			set_bit(count, &smp_changes_mask);
 		mask >>= 1;
 	}
-	
+
 }
 
+/**
+ * generic_set_mtrr - set variable MTRR register on the local CPU.
+ *
+ * @reg: The register to set.
+ * @base: The base address of the region.
+ * @size: The size of the region. If this is 0 the region is disabled.
+ * @type: The type of the region.
+ *
+ * Returns nothing.
+ */
 static void generic_set_mtrr(unsigned int reg, unsigned long base,
 			     unsigned long size, mtrr_type type)
-/*  [SUMMARY] Set variable MTRR register on the local CPU.
-    <reg> The register to set.
-    <base> The base address of the region.
-    <size> The size of the region. If this is 0 the region is disabled.
-    <type> The type of the region.
-    [RETURNS] Nothing.
-*/
 {
 	unsigned long flags;
 	struct mtrr_var_range *vr;
@@ -651,8 +678,10 @@ static void generic_set_mtrr(unsigned int reg, unsigned long base,
 	prepare_set();
 
 	if (size == 0) {
-		/* The invalid bit is kept in the mask, so we simply clear the
-		   relevant mask register to disable a range. */
+		/*
+		 * The invalid bit is kept in the mask, so we simply
+		 * clear the relevant mask register to disable a range.
+		 */
 		mtrr_wrmsr(MTRRphysMask_MSR(reg), 0, 0);
 		memset(vr, 0, sizeof(struct mtrr_var_range));
 	} else {
@@ -669,46 +698,50 @@ static void generic_set_mtrr(unsigned int reg, unsigned long base,
 	local_irq_restore(flags);
 }
 
-int generic_validate_add_page(unsigned long base, unsigned long size, unsigned int type)
+int generic_validate_add_page(unsigned long base, unsigned long size,
+			      unsigned int type)
 {
 	unsigned long lbase, last;
 
-	/*  For Intel PPro stepping <= 7, must be 4 MiB aligned 
-	    and not touch 0x70000000->0x7003FFFF */
+	/*
+	 * For Intel PPro stepping <= 7
+	 * must be 4 MiB aligned and not touch 0x70000000 -> 0x7003FFFF
+	 */
 	if (is_cpu(INTEL) && boot_cpu_data.x86 == 6 &&
 	    boot_cpu_data.x86_model == 1 &&
 	    boot_cpu_data.x86_mask <= 7) {
 		if (base & ((1 << (22 - PAGE_SHIFT)) - 1)) {
-			printk(KERN_WARNING "mtrr: base(0x%lx000) is not 4 MiB aligned\n", base);
+			pr_warning("mtrr: base(0x%lx000) is not 4 MiB aligned\n", base);
 			return -EINVAL;
 		}
 		if (!(base + size < 0x70000 || base > 0x7003F) &&
 		    (type == MTRR_TYPE_WRCOMB
 		     || type == MTRR_TYPE_WRBACK)) {
-			printk(KERN_WARNING "mtrr: writable mtrr between 0x70000000 and 0x7003FFFF may hang the CPU.\n");
+			pr_warning("mtrr: writable mtrr between 0x70000000 and 0x7003FFFF may hang the CPU.\n");
 			return -EINVAL;
 		}
 	}
 
-	/*  Check upper bits of base and last are equal and lower bits are 0
-	    for base and 1 for last  */
+	/*
+	 * Check upper bits of base and last are equal and lower bits are 0
+	 * for base and 1 for last
+	 */
 	last = base + size - 1;
 	for (lbase = base; !(lbase & 1) && (last & 1);
-	     lbase = lbase >> 1, last = last >> 1) ;
+	     lbase = lbase >> 1, last = last >> 1)
+		;
 	if (lbase != last) {
-		printk(KERN_WARNING "mtrr: base(0x%lx000) is not aligned on a size(0x%lx000) boundary\n",
-		       base, size);
+		pr_warning("mtrr: base(0x%lx000) is not aligned on a size(0x%lx000) boundary\n", base, size);
 		return -EINVAL;
 	}
 	return 0;
 }
 
-
 static int generic_have_wrcomb(void)
 {
 	unsigned long config, dummy;
 	rdmsr(MSR_MTRRcap, config, dummy);
-	return (config & (1 << 10));
+	return config & (1 << 10);
 }
 
 int positive_have_wrcomb(void)
@@ -716,14 +749,15 @@ int positive_have_wrcomb(void)
 	return 1;
 }
 
-/* generic structure...
+/*
+ * Generic structure...
  */
 struct mtrr_ops generic_mtrr_ops = {
-	.use_intel_if      = 1,
-	.set_all	   = generic_set_all,
-	.get               = generic_get_mtrr,
-	.get_free_region   = generic_get_free_region,
-	.set               = generic_set_mtrr,
-	.validate_add_page = generic_validate_add_page,
-	.have_wrcomb       = generic_have_wrcomb,
+	.use_intel_if		= 1,
+	.set_all		= generic_set_all,
+	.get			= generic_get_mtrr,
+	.get_free_region	= generic_get_free_region,
+	.set			= generic_set_mtrr,
+	.validate_add_page	= generic_validate_add_page,
+	.have_wrcomb		= generic_have_wrcomb,
 };
