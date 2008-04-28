Return-Path: <linux-kernel-owner+w=401wt.eu-S932200AbYD1JHM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200AbYD1JHM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 05:07:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752722AbYD1JG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 05:06:59 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:46072 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbYD1JG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 05:06:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=reply-to:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=sfZFMhnonP7Rl5gkftUlJ+vr1rtMExuEPMZx83hvdjtQajG8jHolhOYjidSmlCnR0XlS6fZCktW8yqhsKB3JsRxsUQZbYVdsIKxK8BZoV8+zHOmVfOsssuVnx/BeLuNXYn50WN5Vs6t2l61faKrxlHZ2HHOUD6jNg3kgJrKnD2s=
Reply-To: yhlu.kernel@gmail.com
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] x86: mtrr cleanup for converting continuous to discrete layout v2
Date: Mon, 28 Apr 2008 02:06:52 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200804272337.40130.yhlu.kernel@gmail.com>
In-Reply-To: <200804272337.40130.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804280206.52641.yhlu.kernel@gmail.com>
From: Yinghai Lu <yhlu.kernel.send@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


some BIOS like to use continus MTRR layout, and X driver can not add
WB entries for graphical cards when 4g or more RAM installed.

the patch will change MTRR to discrete.

mtrr_chunk_size= could be used to have smaller continuous block to hold holes.
default is 256m, could be set according to size of graphics card memory.

v2: fix -1 for UC 

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/arch/x86/kernel/cpu/mtrr/generic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mtrr/generic.c
+++ linux-2.6/arch/x86/kernel/cpu/mtrr/generic.c
@@ -158,6 +158,20 @@ get_mtrr_var_range(unsigned int index, s
 	rdmsr(MTRRphysMask_MSR(index), vr->mask_lo, vr->mask_hi);
 }
 
+/*  fill the MSR pair relating to a var range  */
+void fill_mtrr_var_range(unsigned int index,
+		u32 base_lo, u32 base_hi, u32 mask_lo, u32 mask_hi)
+{
+	struct mtrr_var_range *vr;
+
+	vr = mtrr_state.var_ranges;
+
+	vr[index].base_lo = base_lo;
+	vr[index].base_hi = base_hi;
+	vr[index].mask_lo = mask_lo;
+	vr[index].mask_hi = mask_hi;
+}
+
 static void
 get_fixed_ranges(mtrr_type * frs)
 {
Index: linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mtrr/main.c
+++ linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
@@ -37,6 +37,7 @@
 #include <linux/smp.h>
 #include <linux/cpu.h>
 #include <linux/mutex.h>
+#include <linux/sort.h>
 
 #include <asm/e820.h>
 #include <asm/mtrr.h>
@@ -609,6 +610,348 @@ static struct sysdev_driver mtrr_sysdev_
 	.resume		= mtrr_restore,
 };
 
+static int disable_mtrr_cleanup;
+
+static int __init disable_mtrr_cleanup_setup(char *str)
+{
+	disable_mtrr_cleanup = 1;
+	return 0;
+}
+early_param("disable_mtrr_cleanup", disable_mtrr_cleanup_setup);
+
+#define RANGE_NUM 256
+
+struct res_range {
+	size_t start;
+	size_t end;
+};
+
+static void __init subtract_range(struct res_range *range, size_t start,
+				size_t end)
+{
+	int i;
+	int j;
+
+	for (j = 0; j < RANGE_NUM; j++) {
+		if (!range[j].end)
+			continue;
+
+		if (start <= range[j].start && end >= range[j].end) {
+			range[j].start = 0;
+			range[j].end = 0;
+			continue;
+		}
+
+		if (start <= range[j].start && end < range[j].end && range[j].start < end + 1) {
+			range[j].start = end + 1;
+			continue;
+		}
+
+
+		if (start > range[j].start && end >= range[j].end && range[j].end > start - 1) {
+			range[j].end = start - 1;
+			continue;
+		}
+
+		if (start > range[j].start && end < range[j].end) {
+			/* find the new spare */
+			for (i = 0; i < RANGE_NUM; i++) {
+				if (range[i].end == 0)
+					break;
+			}
+			if (i < RANGE_NUM) {
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
+static int __cpuinit cmp_range(const void *x1, const void *x2)
+{
+	const struct res_range *r1 = x1;
+	const struct res_range *r2 = x2;
+	s64 start1, start2;
+
+	start1 = r1->start;
+	start2 = r2->start;
+
+	return start1 - start2;
+}
+
+struct var_mtrr_state {
+	unsigned long range_startk, range_sizek;
+	unsigned long chunk_sizek;
+	unsigned int reg;
+	unsigned address_bits;
+};
+
+static void __init set_var_mtrr(
+	unsigned int reg, unsigned long basek, unsigned long sizek,
+	unsigned char type, unsigned address_bits)
+{
+	u32 base_lo, base_hi, mask_lo, mask_hi;
+	unsigned address_mask_high;
+
+	if (!sizek) {
+		fill_mtrr_var_range(reg, 0, 0, 0, 0);
+		return;
+	}
+
+	address_mask_high = ((1u << (address_bits - 32u)) - 1u);
+
+	base_hi = basek >> 22;
+	base_lo  = basek << 10;
+
+	if (sizek < 4*1024*1024) {
+		mask_hi = address_mask_high;
+		mask_lo = ~((sizek << 10) - 1);
+	} else {
+		mask_hi = address_mask_high & (~((sizek >> 22) - 1));
+		mask_lo = 0;
+	}
+
+	base_lo |= type;
+	mask_lo |= 0x800;
+	fill_mtrr_var_range(reg, base_lo, base_hi, mask_lo, mask_hi);
+}
+
+static unsigned int __init range_to_mtrr(unsigned int reg,
+	unsigned long range_startk, unsigned long range_sizek,
+	unsigned long next_range_startk, unsigned char type, unsigned address_bits)
+{
+	if (!range_sizek || (reg >= num_var_ranges))
+		return reg;
+
+	while (range_sizek) {
+		unsigned long max_align, align;
+		unsigned long sizek;
+		/* Compute the maximum size I can make a range */
+		if (range_startk)
+			max_align = ffs(range_startk) - 1;
+		else
+			max_align = 32;
+		align = fls(range_sizek) - 1;
+		if (align > max_align)
+			align = max_align;
+
+		sizek = 1 << align;
+		printk(KERN_INFO "Setting variable MTRR %d, base: %ldMB, range: %ldMB, type %s\n",
+			reg, range_startk >> 10, sizek >> 10,
+			(type == MTRR_TYPE_UNCACHABLE)?"UC":
+			    ((type == MTRR_TYPE_WRBACK)?"WB":"Other")
+			);
+		set_var_mtrr(reg++, range_startk, sizek, type, address_bits);
+		range_startk += sizek;
+		range_sizek -= sizek;
+		if (reg >= num_var_ranges)
+			break;
+	}
+	return reg;
+}
+
+static void __init range_to_mtrr_with_hole(struct var_mtrr_state *state, unsigned long basek)
+{
+	unsigned long hole_basek, hole_sizek;
+	unsigned long range0_basek, range0_sizek;
+	unsigned long range_basek, range_sizek;
+	unsigned long next_basek;
+	unsigned long chunk_sizek;
+
+	hole_basek = 0;
+	hole_sizek = 0;
+	chunk_sizek = state->chunk_sizek;
+	range0_basek = state->range_startk;
+	next_basek = basek;
+
+	/* try to append some small hole */
+	range0_sizek = ALIGN(state->range_sizek, chunk_sizek);
+	if ((range0_sizek == state->range_sizek) ||
+		((range0_basek + range0_sizek > basek) && basek)) {
+			printk(KERN_INFO "rangeX: %016lx - %016lx\n", range0_basek<<10, (range0_basek + range0_sizek)<<10);
+			state->reg = range_to_mtrr(state->reg, range0_basek,
+				range0_sizek, next_basek, MTRR_TYPE_WRBACK, state->address_bits);
+		return;
+	}
+
+	range0_sizek -= chunk_sizek;
+	range_basek = range0_basek + range0_sizek;
+	printk(KERN_INFO "range0: %016lx - %016lx\n", range0_basek<<10, (range0_basek + range0_sizek)<<10);
+	state->reg = range_to_mtrr(state->reg, range0_basek,
+		range0_sizek, range_basek, MTRR_TYPE_WRBACK, state->address_bits);
+
+	range_sizek = chunk_sizek;
+	if (range_sizek - (state->range_sizek - range0_sizek) < (chunk_sizek >> 1)) {
+		hole_sizek = range_sizek - (state->range_sizek - range0_sizek);
+		next_basek = hole_basek = range_basek + range_sizek - hole_sizek;
+	} else {
+		range_sizek = state->range_sizek - range0_sizek;
+	}
+	printk(KERN_INFO "range: %016lx - %016lx\n", range_basek<<10, (range_basek + range_sizek)<<10);
+	state->reg = range_to_mtrr(state->reg, range_basek,
+		range_sizek, next_basek, MTRR_TYPE_WRBACK, state->address_bits);
+	if (hole_sizek) {
+		printk(KERN_INFO "hole: %016lx - %016lx\n", hole_basek<<10, (hole_basek + hole_sizek)<<10);
+		state->reg = range_to_mtrr(state->reg, hole_basek,
+			hole_sizek, basek, MTRR_TYPE_UNCACHABLE, state->address_bits);
+	}
+}
+
+static void __init set_var_mtrr_range(struct var_mtrr_state *state, size_t base_pfn, size_t size_pfn)
+{
+	unsigned long basek, sizek;
+
+	if (state->reg >= num_var_ranges)
+		return;
+
+	basek = base_pfn << (PAGE_SHIFT - 10);
+	sizek = size_pfn << (PAGE_SHIFT - 10);
+
+	/* See if I can merge with the last range */
+	if ((basek <= 1024) || (state->range_startk + state->range_sizek == basek)) {
+		unsigned long endk = basek + sizek;
+		state->range_sizek = endk - state->range_startk;
+		return;
+	}
+	/* Write the range mtrrs */
+	if (state->range_sizek != 0) {
+		range_to_mtrr_with_hole(state, basek);
+
+		state->range_startk = 0;
+		state->range_sizek = 0;
+	}
+	/* Allocate an msr */
+	state->range_startk = basek;
+	state->range_sizek  = sizek;
+}
+
+static u64 mtrr_chunk_size __initdata = (256ULL<<20);
+
+static int __init parse_mtrr_chunk_size_opt(char *p)
+{
+	if (!p)
+		return -EINVAL;
+	mtrr_chunk_size = memparse(p, &p);
+	return 0;
+}
+early_param("mtrr_chunk_size", parse_mtrr_chunk_size_opt);
+
+static void __init x86_setup_var_mtrrs(struct res_range *range, int nr_range, unsigned address_bits)
+{
+	struct var_mtrr_state var_state;
+	int i;
+
+	var_state.range_startk = 0;
+	var_state.range_sizek = 0;
+	var_state.reg = 0;
+	var_state.address_bits = address_bits;
+	var_state.chunk_sizek = mtrr_chunk_size >> 10;
+
+	/* Write the range etc */
+	for (i = 0; i < nr_range; i++)
+		set_var_mtrr_range(&var_state, range[i].start, range[i].end - range[i].start + 1);
+
+	/* Write the last range */
+	range_to_mtrr_with_hole(&var_state, 0);
+	printk(KERN_INFO "DONE variable MTRRs\n");
+	/* Clear out the extra MTRR's */
+	while (var_state.reg < num_var_ranges)
+		set_var_mtrr(var_state.reg++, 0, 0, 0, var_state.address_bits);
+}
+
+static int __init mtrr_cleanup(unsigned address_bits)
+{
+	unsigned long i, base, size, def, dummy;
+	mtrr_type type;
+	struct res_range range[RANGE_NUM];
+	int nr_range;
+
+	/* extra one for all 0 */
+	int num[MTRR_NUM_TYPES + 1];
+
+	if (!is_cpu(INTEL) || disable_mtrr_cleanup)
+		return 0;
+	rdmsr(MTRRdefType_MSR, def, dummy);
+	def &= 0xff;
+	if (def != MTRR_TYPE_UNCACHABLE)
+		return 0;
+
+	/* check entries number */
+	memset(num, 0, sizeof(num));
+	for (i = 0; i < num_var_ranges; i++) {
+		mtrr_if->get(i, &base, &size, &type);
+		if (type >= MTRR_NUM_TYPES)
+			continue;
+		if (!size)
+			type = MTRR_NUM_TYPES;
+		num[type]++;
+	}
+
+	/* check if we got UC entries */
+	if (!num[MTRR_TYPE_UNCACHABLE])
+		return 0;
+
+	/* check if we only had WB and UC */
+	if (num[MTRR_TYPE_WRBACK] + num[MTRR_TYPE_UNCACHABLE] !=
+		num_var_ranges - num[MTRR_NUM_TYPES])
+		return 0;
+
+	/*
+	 * get WB ranges at first
+	 * assume BIOS don't give us overlapping WB entries
+	 * or add add_range?
+	 */
+	memset(range, 0, sizeof(range));
+	nr_range = 0;
+	for (i = 0; i < num_var_ranges; i++) {
+		mtrr_if->get(i, &base, &size, &type);
+		if (type != MTRR_TYPE_WRBACK)
+			continue;
+		range[nr_range].start = base;
+		range[nr_range].end = base + size - 1;
+		nr_range++;
+	}
+	printk(KERN_INFO "After WB checking\n");
+	for (i = 0; i < nr_range; i++)
+		printk(KERN_INFO "MTRR MAP PFN: %016lx - %016lx\n", range[i].start, range[i].end + 1);
+
+	/* take out UC ranges */
+	for (i = 0; i < num_var_ranges; i++) {
+		mtrr_if->get(i, &base, &size, &type);
+		if (type != MTRR_TYPE_UNCACHABLE)
+			continue;
+		if (!size)
+			continue;
+		subtract_range(range, base, base + size - 1);
+	}
+	/* get new range num */
+	nr_range = 0;
+	for (i = 0; i < RANGE_NUM; i++) {
+		if (!range[i].end)
+			continue;
+		nr_range++;
+	}
+	printk(KERN_INFO "After UC checking\n");
+	for (i = 0; i < nr_range; i++)
+		printk(KERN_INFO "MTRR MAP PFN: %016lx - %016lx\n", range[i].start, range[i].end + 1);
+
+	/* sort the ranges */
+	sort(range, nr_range, sizeof(struct res_range), cmp_range, NULL);
+	printk(KERN_INFO "After sorting\n");
+	for (i = 0; i < nr_range; i++)
+		printk(KERN_INFO "MTRR MAP PFN: %016lx - %016lx\n", range[i].start, range[i].end + 1);
+
+	/* convert ranges to var ranges state */
+	x86_setup_var_mtrrs(range, nr_range, address_bits);
+
+	return 1;
+
+}
+
 static int disable_mtrr_trim;
 
 static int __init disable_mtrr_trim_setup(char *str)
@@ -729,18 +1072,21 @@ int __init mtrr_trim_uncached_memory(uns
  */
 void __init mtrr_bp_init(void)
 {
+	u32 phys_addr;
 	init_ifs();
 
+	phys_addr = 32;
+
 	if (cpu_has_mtrr) {
 		mtrr_if = &generic_mtrr_ops;
 		size_or_mask = 0xff000000;	/* 36 bits */
 		size_and_mask = 0x00f00000;
+		phys_addr = 36;
 
 		/* This is an AMD specific MSR, but we assume(hope?) that
 		   Intel will implement it to when they extend the address
 		   bus of the Xeon. */
 		if (cpuid_eax(0x80000000) >= 0x80000008) {
-			u32 phys_addr;
 			phys_addr = cpuid_eax(0x80000008) & 0xff;
 			/* CPUID workaround for Intel 0F33/0F34 CPU */
 			if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL &&
@@ -758,6 +1104,7 @@ void __init mtrr_bp_init(void)
 			   don't support PAE */
 			size_or_mask = 0xfff00000;	/* 32 bits */
 			size_and_mask = 0;
+			phys_addr = 32;
 		}
 	} else {
 		switch (boot_cpu_data.x86_vendor) {
@@ -791,8 +1138,13 @@ void __init mtrr_bp_init(void)
 	if (mtrr_if) {
 		set_num_var_ranges();
 		init_table();
-		if (use_intel())
+		if (use_intel()) {
 			get_mtrr_state();
+
+			if (mtrr_cleanup(phys_addr))
+				mtrr_if->set_all();
+
+		}
 	}
 }
 
Index: linux-2.6/arch/x86/kernel/cpu/mtrr/mtrr.h
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mtrr/mtrr.h
+++ linux-2.6/arch/x86/kernel/cpu/mtrr/mtrr.h
@@ -81,6 +81,8 @@ void set_mtrr_done(struct set_mtrr_conte
 void set_mtrr_cache_disable(struct set_mtrr_context *ctxt);
 void set_mtrr_prepare_save(struct set_mtrr_context *ctxt);
 
+void fill_mtrr_var_range(unsigned int index,
+		u32 base_lo, u32 base_hi, u32 mask_lo, u32 mask_hi);
 void get_mtrr_state(void);
 
 extern void set_mtrr_ops(struct mtrr_ops * ops);
Index: linux-2.6/Documentation/kernel-parameters.txt
===================================================================
--- linux-2.6.orig/Documentation/kernel-parameters.txt
+++ linux-2.6/Documentation/kernel-parameters.txt
@@ -595,6 +595,16 @@ and is between 256 and 4096 characters. 
 			See drivers/char/README.epca and
 			Documentation/digiepca.txt.
 
+	disable_mtrr_cleanup [X86]
+			By default the kernel will adjust mtrr from continuous
+			to discrete layout, to make x server driver could add
+			WB entry later. This parameter disables that behavior,
+			will not touch MTRRs.
+
+	mtrr_chunk_size=nn[KMG] [X86]
+			used for mtrr cleanup. It is largest continous chunk
+			that could hold holes aka. UC entries.
+
 	disable_mtrr_trim [X86, Intel and AMD only]
 			By default the kernel will trim any uncacheable
 			memory out of your available memory pool based on
