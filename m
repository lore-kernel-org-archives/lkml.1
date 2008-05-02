Return-Path: <linux-kernel-owner+w=401wt.eu-S932983AbYEBAwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932983AbYEBAwj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 20:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754730AbYEBAwb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 20:52:31 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:50786 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645AbYEBAw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 20:52:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=reply-to:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=vOrq5uDOfqWNciXg5HCFgLz3gC3in4V0y0Vg8KJ3v1i0UNQsBx+iKf9iItQSBtqqxlIPnoihHaWjKoy1BvIiJw6RDmH31GUWhT5ra3PfhbtvuPcmHfgEy0O8YtrDiOuN0ENvhLsxGdSYF1rI9FteLlWGhkxsfPSDohwOVAr00Hw=
Reply-To: yhlu.kernel@gmail.com
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Gabriel C <nix.or.die@googlemail.com>,
       Mika Fischer <mika.fischer@zoopnet.de>
Subject: [PATCH] x86: mtrr cleanup for converting continuous to discrete - auto detect v3
Date: Thu, 1 May 2008 17:52:41 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200804272337.40130.yhlu.kernel@gmail.com> <200805010100.34751.yhlu.kernel@gmail.com> <200805011157.00693.yhlu.kernel@gmail.com>
In-Reply-To: <200805011157.00693.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805011752.41632.yhlu.kernel@gmail.com>
From: Yinghai Lu <yhlu.kernel.send@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


loop mtrr chunk_size and gran_size from 1M to 2G to find out optimal value.

so user don't need to add mtrr_chunk_size and mtrr_gran_size

if optimal value is not found, print out all list to help select less optimal
value.

add mtrr_spare_reg_nr= so user could set 2 instead of 1, if the card need more entries.

v2: find the one with more spare entries
v3: fix hole_basek offset

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mtrr/main.c
+++ linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
@@ -610,28 +610,6 @@ static struct sysdev_driver mtrr_sysdev_
 	.resume		= mtrr_restore,
 };
 
-#ifdef CONFIG_MTRR_SANITIZER
-static int enable_mtrr_cleanup __initdata = CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT;
-#else
-static int enable_mtrr_cleanup __initdata = -1;
-#endif
-
-static int __init disable_mtrr_cleanup_setup(char *str)
-{
-	if (enable_mtrr_cleanup != -1)
-		enable_mtrr_cleanup = 0;
-	return 0;
-}
-early_param("disable_mtrr_cleanup", disable_mtrr_cleanup_setup);
-
-static int __init enable_mtrr_cleanup_setup(char *str)
-{
-	if (enable_mtrr_cleanup != -1)
-		enable_mtrr_cleanup = 1;
-	return 0;
-}
-early_param("enble_mtrr_cleanup", enable_mtrr_cleanup_setup);
-
 /* should be related to MTRR_VAR_RANGES nums */
 #define RANGE_NUM 256
 
@@ -702,13 +680,15 @@ subtract_range(struct res_range *range, 
 			continue;
 		}
 
-		if (start <= range[j].start && end < range[j].end && range[j].start < end + 1) {
+		if (start <= range[j].start && end < range[j].end &&
+		    range[j].start < end + 1) {
 			range[j].start = end + 1;
 			continue;
 		}
 
 
-		if (start > range[j].start && end >= range[j].end && range[j].end > start - 1) {
+		if (start > range[j].start && end >= range[j].end &&
+		    range[j].end > start - 1) {
 			range[j].end = start - 1;
 			continue;
 		}
@@ -743,18 +723,119 @@ static int __init cmp_range(const void *
 	return start1 - start2;
 }
 
+struct var_mtrr_range_state {
+	unsigned long base_pfn;
+	unsigned long size_pfn;
+	mtrr_type type;
+};
+
+struct var_mtrr_range_state __initdata range_state[RANGE_NUM];
+
+static int __init
+x86_get_mtrr_mem_range(struct res_range *range, int nr_range,
+		       unsigned long extra_remove_base,
+		       unsigned long extra_remove_size)
+{
+	unsigned long i, base, size;
+	mtrr_type type;
+
+	for (i = 0; i < num_var_ranges; i++) {
+		type = range_state[i].type;
+		if (type != MTRR_TYPE_WRBACK)
+			continue;
+		base = range_state[i].base_pfn;
+		size = range_state[i].size_pfn;
+		nr_range = add_range_with_merge(range, nr_range, base,
+						base + size - 1);
+	}
+	printk(KERN_DEBUG "After WB checking\n");
+	for (i = 0; i < nr_range; i++)
+		printk(KERN_DEBUG "MTRR MAP PFN: %016lx - %016lx\n",
+				 range[i].start, range[i].end + 1);
+
+	/* take out UC ranges */
+	for (i = 0; i < num_var_ranges; i++) {
+		type = range_state[i].type;
+		if (type != MTRR_TYPE_UNCACHABLE)
+			continue;
+		size = range_state[i].size_pfn;
+		if (!size)
+			continue;
+		base = range_state[i].base_pfn;
+		subtract_range(range, base, base + size - 1);
+	}
+	if (extra_remove_size)
+		subtract_range(range, extra_remove_base,
+				 extra_remove_base + extra_remove_size  - 1);
+
+	/* get new range num */
+	nr_range = 0;
+	for (i = 0; i < RANGE_NUM; i++) {
+		if (!range[i].end)
+			continue;
+		nr_range++;
+	}
+	printk(KERN_DEBUG "After UC checking\n");
+	for (i = 0; i < nr_range; i++)
+		printk(KERN_DEBUG "MTRR MAP PFN: %016lx - %016lx\n",
+			 range[i].start, range[i].end + 1);
+
+	/* sort the ranges */
+	sort(range, nr_range, sizeof(struct res_range), cmp_range, NULL);
+	printk(KERN_DEBUG "After sorting\n");
+	for (i = 0; i < nr_range; i++)
+		printk(KERN_DEBUG "MTRR MAP PFN: %016lx - %016lx\n",
+				 range[i].start, range[i].end + 1);
+
+	return nr_range;
+}
+
+static struct res_range __initdata range[RANGE_NUM];
+
+#ifdef CONFIG_MTRR_SANITIZER
+
+static unsigned long __init sum_ranges(struct res_range *range, int nr_range)
+{
+	unsigned long sum;
+	int i;
+
+	sum = 0;
+	for (i = 0; i < nr_range; i++)
+		sum += range[i].end + 1 - range[i].start;
+
+	return sum;
+}
+
+static int enable_mtrr_cleanup __initdata =
+				 CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT;
+
+static int __init disable_mtrr_cleanup_setup(char *str)
+{
+	if (enable_mtrr_cleanup != -1)
+		enable_mtrr_cleanup = 0;
+	return 0;
+}
+early_param("disable_mtrr_cleanup", disable_mtrr_cleanup_setup);
+
+static int __init enable_mtrr_cleanup_setup(char *str)
+{
+	if (enable_mtrr_cleanup != -1)
+		enable_mtrr_cleanup = 1;
+	return 0;
+}
+early_param("enble_mtrr_cleanup", enable_mtrr_cleanup_setup);
+
 struct var_mtrr_state {
 	unsigned long	range_startk;
 	unsigned long	range_sizek;
 	unsigned long	chunk_sizek;
 	unsigned long	gran_sizek;
 	unsigned int	reg;
-	unsigned int	address_bits;
 };
 
 static void __init
 set_var_mtrr(unsigned int reg, unsigned long basek, unsigned long sizek,
-		unsigned char type, unsigned address_bits)
+		unsigned char type, unsigned int address_bits)
 {
 	u32 base_lo, base_hi, mask_lo, mask_hi;
 	u64 base, mask;
@@ -781,10 +862,34 @@ set_var_mtrr(unsigned int reg, unsigned 
 	fill_mtrr_var_range(reg, base_lo, base_hi, mask_lo, mask_hi);
 }
 
+static void __init
+save_var_mtrr(unsigned int reg, unsigned long basek, unsigned long sizek,
+		unsigned char type)
+{
+	range_state[reg].base_pfn = basek >> (PAGE_SHIFT - 10);
+	range_state[reg].size_pfn = sizek >> (PAGE_SHIFT - 10);
+	range_state[reg].type = type;
+}
+
+static void __init
+set_var_mtrr_all(unsigned int address_bits)
+{
+	unsigned long basek, sizek;
+	unsigned char type;
+	unsigned int reg;
+
+	for (reg = 0; reg < num_var_ranges; reg++) {
+		basek = range_state[reg].base_pfn << (PAGE_SHIFT - 10);
+		sizek = range_state[reg].size_pfn << (PAGE_SHIFT - 10);
+		type = range_state[reg].type;
+
+		set_var_mtrr(reg, basek, sizek, type, address_bits);
+	}
+}
+
 static unsigned int __init
 range_to_mtrr(unsigned int reg, unsigned long range_startk,
-	      unsigned long range_sizek, unsigned char type,
-	      unsigned address_bits)
+	      unsigned long range_sizek, unsigned char type)
 {
 	if (!range_sizek || (reg >= num_var_ranges))
 		return reg;
@@ -803,12 +908,12 @@ range_to_mtrr(unsigned int reg, unsigned
 			align = max_align;
 
 		sizek = 1 << align;
-		printk(KERN_INFO "Setting variable MTRR %d, base: %ldMB, range: %ldMB, type %s\n",
+		printk(KERN_DEBUG "Setting variable MTRR %d, base: %ldMB, range: %ldMB, type %s\n",
 			reg, range_startk >> 10, sizek >> 10,
 			(type == MTRR_TYPE_UNCACHABLE)?"UC":
 			    ((type == MTRR_TYPE_WRBACK)?"WB":"Other")
 			);
-		set_var_mtrr(reg++, range_startk, sizek, type, address_bits);
+		save_var_mtrr(reg++, range_startk, sizek, type);
 		range_startk += sizek;
 		range_sizek -= sizek;
 		if (reg >= num_var_ranges)
@@ -817,10 +922,12 @@ range_to_mtrr(unsigned int reg, unsigned
 	return reg;
 }
 
-static void __init
-range_to_mtrr_with_hole(struct var_mtrr_state *state, unsigned long basek)
+static unsigned __init
+range_to_mtrr_with_hole(struct var_mtrr_state *state, unsigned long basek,
+			unsigned long sizek)
 {
 	unsigned long hole_basek, hole_sizek;
+	unsigned long second_basek, second_sizek;
 	unsigned long range0_basek, range0_sizek;
 	unsigned long range_basek, range_sizek;
 	unsigned long chunk_sizek;
@@ -828,64 +935,87 @@ range_to_mtrr_with_hole(struct var_mtrr_
 
 	hole_basek = 0;
 	hole_sizek = 0;
+	second_basek = 0;
+	second_sizek = 0;
 	chunk_sizek = state->chunk_sizek;
 	gran_sizek = state->gran_sizek;
 
 	/* align with gran size, prevent small block used up MTRRs */
 	range_basek = ALIGN(state->range_startk, gran_sizek);
 	if ((range_basek > basek) && basek)
-		return;
-	range_sizek = ALIGN(state->range_sizek - (range_basek - state->range_startk), gran_sizek);
+		return second_sizek;
+	state->range_sizek -= (range_basek - state->range_startk);
+	range_sizek = ALIGN(state->range_sizek, gran_sizek);
 
-	while (range_basek + range_sizek > (state->range_startk + state->range_sizek)) {
+	while (range_sizek > state->range_sizek) {
 		range_sizek -= gran_sizek;
 		if (!range_sizek)
-			return;
+			return second_sizek;
 	}
-	state->range_startk = range_basek;
 	state->range_sizek = range_sizek;
 
 	/* try to append some small hole */
 	range0_basek = state->range_startk;
 	range0_sizek = ALIGN(state->range_sizek, chunk_sizek);
 	if (range0_sizek == state->range_sizek) {
-			printk(KERN_INFO "rangeX: %016lx - %016lx\n", range0_basek<<10, (range0_basek + state->range_sizek)<<10);
-			state->reg = range_to_mtrr(state->reg, range0_basek,
-				state->range_sizek, MTRR_TYPE_WRBACK, state->address_bits);
-		return;
-	} else if (basek) {
-	    while (range0_basek + range0_sizek - chunk_sizek > basek) {
+		printk(KERN_DEBUG "rangeX: %016lx - %016lx\n", range0_basek<<10,
+				(range0_basek + state->range_sizek)<<10);
+		state->reg = range_to_mtrr(state->reg, range0_basek,
+				state->range_sizek, MTRR_TYPE_WRBACK);
+		return second_sizek;
+	}
+
+	range0_sizek -= chunk_sizek;
+	if (range0_sizek && sizek) {
+	    while (range0_basek + range0_sizek > (basek + sizek)) {
 		range0_sizek -= chunk_sizek;
 		if (!range0_sizek)
 			break;
 	    }
 	}
 
+	if (range0_sizek) {
+		printk(KERN_DEBUG "range0: %016lx - %016lx\n", range0_basek<<10,
+				(range0_basek + range0_sizek)<<10);
+		state->reg = range_to_mtrr(state->reg, range0_basek,
+				range0_sizek, MTRR_TYPE_WRBACK);
 
-	if (range0_sizek > chunk_sizek)
-		range0_sizek -= chunk_sizek;
-	printk(KERN_INFO "range0: %016lx - %016lx\n", range0_basek<<10, (range0_basek + range0_sizek)<<10);
-	state->reg = range_to_mtrr(state->reg, range0_basek,
-			range0_sizek, MTRR_TYPE_WRBACK, state->address_bits);
+	}
 
 	range_basek = range0_basek + range0_sizek;
 	range_sizek = chunk_sizek;
 
-	if ((range_sizek - (state->range_sizek - range0_sizek) < (chunk_sizek >> 1)) &&
-	    (range_basek + range_sizek <= basek)) {
-		hole_sizek = range_sizek - (state->range_sizek - range0_sizek);
-		hole_basek = range_basek + range_sizek - hole_sizek;
-	} else
+	if (range_basek + range_sizek > basek &&
+	    range_basek + range_sizek <= (basek + sizek)) {
+		second_basek = basek;
+		second_sizek = range_basek + range_sizek - basek;
+	}
+
+	if (range_sizek - (state->range_sizek - range0_sizek) - second_sizek
+	     < (chunk_sizek >> 1)) {
+		hole_sizek = range_sizek - (state->range_sizek - range0_sizek)
+				 - second_sizek;
+		hole_basek = range_basek + range_sizek - hole_sizek
+				 - second_sizek;
+	} else {
 		range_sizek = state->range_sizek - range0_sizek;
+		second_basek = 0;
+		second_sizek = 0;
+	}
 
-	printk(KERN_INFO "range: %016lx - %016lx\n", range_basek<<10, (range_basek + range_sizek)<<10);
-	state->reg = range_to_mtrr(state->reg, range_basek,
-			range_sizek, MTRR_TYPE_WRBACK, state->address_bits);
+	printk(KERN_DEBUG "range: %016lx - %016lx\n", range_basek<<10,
+			 (range_basek + range_sizek)<<10);
+	state->reg = range_to_mtrr(state->reg, range_basek, range_sizek,
+					 MTRR_TYPE_WRBACK);
 	if (hole_sizek) {
-		printk(KERN_INFO "hole: %016lx - %016lx\n", hole_basek<<10, (hole_basek + hole_sizek)<<10);
-		state->reg = range_to_mtrr(state->reg, hole_basek,
-				hole_sizek, MTRR_TYPE_UNCACHABLE, state->address_bits);
+		printk(KERN_DEBUG "hole: %016lx - %016lx\n", hole_basek<<10,
+				 (hole_basek + hole_sizek)<<10);
+		state->reg = range_to_mtrr(state->reg, hole_basek, hole_sizek,
+						 MTRR_TYPE_UNCACHABLE);
+
 	}
+
+	return second_sizek;
 }
 
 static void __init
@@ -893,6 +1023,7 @@ set_var_mtrr_range(struct var_mtrr_state
 		   unsigned long size_pfn)
 {
 	unsigned long basek, sizek;
+	unsigned long second_sizek = 0;
 
 	if (state->reg >= num_var_ranges)
 		return;
@@ -901,21 +1032,19 @@ set_var_mtrr_range(struct var_mtrr_state
 	sizek = size_pfn << (PAGE_SHIFT - 10);
 
 	/* See if I can merge with the last range */
-	if ((basek <= 1024) || (state->range_startk + state->range_sizek == basek)) {
+	if ((basek <= 1024) ||
+	    (state->range_startk + state->range_sizek == basek)) {
 		unsigned long endk = basek + sizek;
 		state->range_sizek = endk - state->range_startk;
 		return;
 	}
 	/* Write the range mtrrs */
-	if (state->range_sizek != 0) {
-		range_to_mtrr_with_hole(state, basek);
+	if (state->range_sizek != 0)
+		second_sizek = range_to_mtrr_with_hole(state, basek, sizek);
 
-		state->range_startk = 0;
-		state->range_sizek = 0;
-	}
 	/* Allocate an msr */
-	state->range_startk = basek;
-	state->range_sizek  = sizek;
+	state->range_startk = basek + second_sizek;
+	state->range_sizek  = sizek - second_sizek;
 }
 
 /* mininum size of mtrr block that can take hole */
@@ -931,7 +1060,7 @@ static int __init parse_mtrr_chunk_size_
 early_param("mtrr_chunk_size", parse_mtrr_chunk_size_opt);
 
 /* granity of mtrr of block */
-static u64 mtrr_gran_size __initdata = (1ULL<<20);
+static u64 mtrr_gran_size __initdata;
 
 static int __init parse_mtrr_gran_size_opt(char *p)
 {
@@ -942,91 +1071,79 @@ static int __init parse_mtrr_gran_size_o
 }
 early_param("mtrr_gran_size", parse_mtrr_gran_size_opt);
 
-static void __init
+static int nr_mtrr_spare_reg __initdata =
+				 CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT;
+
+static int __init parse_mtrr_spare_reg(char *arg)
+{
+	if (arg)
+		nr_mtrr_spare_reg = simple_strtoul(arg, NULL, 0);
+	return 0;
+}
+
+early_param("mtrr_spare_reg_nr", parse_mtrr_spare_reg);
+
+static int __init
 x86_setup_var_mtrrs(struct res_range *range, int nr_range,
-		    unsigned address_bits)
+		    u64 chunk_size, u64 gran_size)
 {
 	struct var_mtrr_state var_state;
 	int i;
+	int num_reg;
 
 	var_state.range_startk	= 0;
 	var_state.range_sizek	= 0;
 	var_state.reg		= 0;
-	var_state.address_bits	= address_bits;
-	var_state.chunk_sizek	= mtrr_chunk_size >> 10;
-	var_state.gran_sizek	= mtrr_gran_size >> 10;
+	var_state.chunk_sizek	= chunk_size >> 10;
+	var_state.gran_sizek	= gran_size >> 10;
+
+	memset(range_state, 0, sizeof(range_state));
 
 	/* Write the range etc */
 	for (i = 0; i < nr_range; i++)
-		set_var_mtrr_range(&var_state, range[i].start, range[i].end - range[i].start + 1);
+		set_var_mtrr_range(&var_state, range[i].start,
+				   range[i].end - range[i].start + 1);
 
 	/* Write the last range */
-	range_to_mtrr_with_hole(&var_state, 0);
-	printk(KERN_INFO "DONE variable MTRRs\n");
+	if (var_state.range_sizek != 0)
+		range_to_mtrr_with_hole(&var_state, 0, 0);
+	printk(KERN_DEBUG "DONE variable MTRRs\n");
+
+	num_reg = var_state.reg;
 	/* Clear out the extra MTRR's */
 	while (var_state.reg < num_var_ranges) {
-		set_var_mtrr(var_state.reg, 0, 0, 0, var_state.address_bits);
+		save_var_mtrr(var_state.reg, 0, 0, 0);
 		var_state.reg++;
 	}
-}
-
-static int __init
-x86_get_mtrr_mem_range(struct res_range *range, int nr_range,
-		       unsigned long extra_remove_base,
-		       unsigned long extra_remove_size)
-{
-	unsigned long i, base, size;
-	mtrr_type type;
-
-	for (i = 0; i < num_var_ranges; i++) {
-		mtrr_if->get(i, &base, &size, &type);
-		if (type != MTRR_TYPE_WRBACK)
-			continue;
-		nr_range = add_range_with_merge(range, nr_range, base, base + size - 1);
-	}
-	printk(KERN_INFO "After WB checking\n");
-	for (i = 0; i < nr_range; i++)
-		printk(KERN_INFO "MTRR MAP PFN: %016lx - %016lx\n", range[i].start, range[i].end + 1);
 
-	/* take out UC ranges */
-	for (i = 0; i < num_var_ranges; i++) {
-		mtrr_if->get(i, &base, &size, &type);
-		if (type != MTRR_TYPE_UNCACHABLE)
-			continue;
-		if (!size)
-			continue;
-		subtract_range(range, base, base + size - 1);
-	}
-	if (extra_remove_size)
-		subtract_range(range, extra_remove_base,  extra_remove_base + extra_remove_size  - 1);
+	return num_reg;
+}
 
-	/* get new range num */
-	nr_range = 0;
-	for (i = 0; i < RANGE_NUM; i++) {
-		if (!range[i].end)
-			continue;
-		nr_range++;
-	}
-	printk(KERN_INFO "After UC checking\n");
-	for (i = 0; i < nr_range; i++)
-		printk(KERN_INFO "MTRR MAP PFN: %016lx - %016lx\n", range[i].start, range[i].end + 1);
+struct mtrr_cleanup_result {
+	unsigned long gran_sizek;
+	unsigned long chunk_sizek;
+	unsigned long lose_cover_sizek;
+	unsigned int num_reg;
+	int bad;
+};
 
-	/* sort the ranges */
-	sort(range, nr_range, sizeof(struct res_range), cmp_range, NULL);
-	printk(KERN_INFO "After sorting\n");
-	for (i = 0; i < nr_range; i++)
-		printk(KERN_INFO "MTRR MAP PFN: %016lx - %016lx\n", range[i].start, range[i].end + 1);
+/* 2G, 1G, ..., 1M, so need 12 items and half maxtrix need 13*6 */
+#define NUM_RESULT 78
 
-	return nr_range;
-}
+static struct mtrr_cleanup_result __initdata result[NUM_RESULT];
+static struct res_range __initdata range_new[RANGE_NUM];
+static unsigned long __initdata min_loss_pfn[RANGE_NUM];
 
 static int __init mtrr_cleanup(unsigned address_bits)
 {
 	unsigned long extra_remove_base, extra_remove_size;
 	unsigned long i, base, size, def, dummy;
-	struct res_range range[RANGE_NUM];
 	mtrr_type type;
-	int nr_range;
+	int nr_range, nr_range_new;
+	u64 chunk_size, gran_size;
+	unsigned long range_sums, range_sums_new;
+	int index_good;
+	int num_reg_good;
 
 	/* extra one for all 0 */
 	int num[MTRR_NUM_TYPES + 1];
@@ -1038,10 +1155,20 @@ static int __init mtrr_cleanup(unsigned 
 	if (def != MTRR_TYPE_UNCACHABLE)
 		return 0;
 
+	/* get it and store it aside */
+	memset(range_state, 0, sizeof(range_state));
+	for (i = 0; i < num_var_ranges; i++) {
+		mtrr_if->get(i, &base, &size, &type);
+		range_state[i].base_pfn = base;
+		range_state[i].size_pfn = size;
+		range_state[i].type = type;
+	}
+
 	/* check entries number */
 	memset(num, 0, sizeof(num));
 	for (i = 0; i < num_var_ranges; i++) {
-		mtrr_if->get(i, &base, &size, &type);
+		type = range_state[i].type;
+		size = range_state[i].size_pfn;
 		if (type >= MTRR_NUM_TYPES)
 			continue;
 		if (!size)
@@ -1064,13 +1191,150 @@ static int __init mtrr_cleanup(unsigned 
 		extra_remove_base = 1 << (32 - PAGE_SHIFT);
 		extra_remove_size = (mtrr_tom2>>PAGE_SHIFT) - extra_remove_base;
 	}
-	nr_range = x86_get_mtrr_mem_range(range, 0, extra_remove_base, extra_remove_size);
+	nr_range = x86_get_mtrr_mem_range(range, 0, extra_remove_base,
+					  extra_remove_size);
+	range_sums = sum_ranges(range, nr_range);
+	printk(KERN_INFO "total RAM coverred: %ldM\n",
+			 range_sums >> (20 - PAGE_SHIFT));
+
+	if (mtrr_chunk_size && mtrr_gran_size) {
+		int num_reg;
+
+		/* convert ranges to var ranges state */
+		num_reg = x86_setup_var_mtrrs(range, nr_range, mtrr_chunk_size,
+						 mtrr_gran_size);
+
+		/* we got new setting in range_state, check it */
+		memset(range_new, 0, sizeof(range_new));
+		nr_range_new = x86_get_mtrr_mem_range(range_new, 0,
+					 extra_remove_base, extra_remove_size);
+		range_sums_new = sum_ranges(range_new, nr_range_new);
+
+		i = 0;
+		result[i].chunk_sizek = mtrr_chunk_size >> 10;
+		result[i].gran_sizek = mtrr_gran_size >> 10;
+		result[i].num_reg = num_reg;
+		if (range_sums < range_sums_new) {
+			result[i].lose_cover_sizek = (range_sums_new - range_sums) << (PAGE_SHIFT - 10);
+			result[i].bad = 1;
+		} else
+			result[i].lose_cover_sizek = (range_sums - range_sums_new) << (PAGE_SHIFT - 10);
+
+		printk(KERN_INFO " %sgran_size: %ldM  \tchunk_size: %ldM  \t",
+			 result[i].bad?" BAD ":"", result[i].gran_sizek >> 10,
+			 result[i].chunk_sizek >> 10);
+		printk(KERN_CONT "num_reg: %d  \tlose cover RAM: %s%ldM \n",
+			 result[i].num_reg, result[i].bad?"-":"",
+			 result[i].lose_cover_sizek >> 10);
+		if (!result[i].bad) {
+			set_var_mtrr_all(address_bits);
+			return 1;
+		}
+		printk(KERN_INFO "invalid mtrr_gran_size or mtrr_chunk_size, will find optimal one\n");
+		memset(result, 0, sizeof(result[0]));
+	}
 
-	/* convert ranges to var ranges state */
-	x86_setup_var_mtrrs(range, nr_range, address_bits);
+	i = 0;
+	memset(min_loss_pfn, 0xff, sizeof(min_loss_pfn));
+	memset(result, 0, sizeof(result));
+	for (gran_size = (1ULL<<20); gran_size < (1ULL<<32); gran_size <<= 1) {
+		for (chunk_size = gran_size; chunk_size < (1ULL<<32);
+		     chunk_size <<= 1) {
+			int num_reg;
+
+			printk(KERN_INFO "\ngran_size: %lldM   chunk_size_size: %lldM\n", gran_size >> 20, chunk_size >> 20);
+			if (i >= NUM_RESULT)
+				continue;
+
+			/* convert ranges to var ranges state */
+			num_reg = x86_setup_var_mtrrs(range, nr_range,
+							 chunk_size, gran_size);
+
+			/* we got new setting in range_state, check it */
+			memset(range_new, 0, sizeof(range_new));
+			nr_range_new = x86_get_mtrr_mem_range(range_new, 0,
+					 extra_remove_base, extra_remove_size);
+			range_sums_new = sum_ranges(range_new, nr_range_new);
+
+			result[i].chunk_sizek = chunk_size >> 10;
+			result[i].gran_sizek = gran_size >> 10;
+			result[i].num_reg = num_reg;
+			if (range_sums < range_sums_new) {
+				result[i].lose_cover_sizek = (range_sums_new - range_sums) << (PAGE_SHIFT - 10);
+				result[i].bad = 1;
+			} else
+				result[i].lose_cover_sizek = (range_sums - range_sums_new) << (PAGE_SHIFT - 10);
+
+			if (!result[i].bad && (range_sums - range_sums_new <
+				 min_loss_pfn[num_reg]))
+					min_loss_pfn[num_reg] = range_sums - range_sums_new;
+			i++;
+		}
+	}
 
-	return 1;
+	/* print out all */
+	for (i = 0; i < NUM_RESULT; i++) {
+		printk(KERN_INFO "%sgran_size: %ldM  \tchunk_size: %ldM  \t",
+			 result[i].bad?"*BAD* ":" ", result[i].gran_sizek >> 10,
+			 result[i].chunk_sizek >> 10);
+		printk(KERN_CONT "num_reg: %d  \tlose cover RAM: %s%ldM \n",
+			 result[i].num_reg, result[i].bad?"-":"",
+			 result[i].lose_cover_sizek >> 10);
+	}
+
+	/* try to find the optimal index */
+	if (nr_mtrr_spare_reg >= num_var_ranges)
+		nr_mtrr_spare_reg = num_var_ranges - 1;
+	num_reg_good = -1;
+	for (i = 1; i < num_var_ranges + 1 - nr_mtrr_spare_reg; i++) {
+		if (!min_loss_pfn[i]) {
+			num_reg_good = i;
+			break;
+		}
+	}
+
+	index_good = -1;
+	if (num_reg_good != -1) {
+		for (i = 0; i < NUM_RESULT; i++) {
+			if (!result[i].bad && result[i].num_reg == num_reg_good) {
+				index_good = i;
+				break;
+			}
+		}
+	}
+
+	if (index_good != -1) {
+		printk(KERN_INFO "Found optimal setting for mtrr clean up\n");
+		i = index_good;
+		printk(KERN_INFO "gran_size: %ldM  \tchunk_size: %ldM  \t",
+				result[i].gran_sizek >> 10,
+				result[i].chunk_sizek >> 10);
+		printk(KERN_CONT "num_reg: %d  \tlose cover RAM: %ldM \n",
+				result[i].num_reg,
+				result[i].lose_cover_sizek >> 10);
+		/* convert ranges to var ranges state */
+		chunk_size = result[i].chunk_sizek;
+		chunk_size <<= 10;
+		gran_size = result[i].gran_sizek;
+		gran_size <<= 10;
+		x86_setup_var_mtrrs(range, nr_range, chunk_size, gran_size);
+		set_var_mtrr_all(address_bits);
+		return 1;
+	}
+
+	printk(KERN_INFO "mtrr_cleanup: can not find optimal value\n");
+	printk(KERN_INFO "please specify mtrr_gran_size/mtrr_chunk_size\n");
+
+	return 0;
 }
+#else
+static int __init mtrr_cleanup(unsigned address_bits)
+{
+	return 0;
+}
+#endif
+
+static int __initdata changed_by_mtrr_cleanup;
 
 static int disable_mtrr_trim;
 
@@ -1111,7 +1375,8 @@ int __init amd_special_default_mtrr(void
 	return 0;
 }
 
-static u64 __init real_trim_memory(unsigned long start_pfn, unsigned long limit_pfn)
+static u64 __init real_trim_memory(unsigned long start_pfn,
+				   unsigned long limit_pfn)
 {
 	u64 trim_start, trim_size;
 	trim_start = start_pfn;
@@ -1138,9 +1403,8 @@ int __init mtrr_trim_uncached_memory(uns
 {
 	unsigned long i, base, size, highest_pfn = 0, def, dummy;
 	mtrr_type type;
-	struct res_range range[RANGE_NUM];
 	int nr_range;
-	u64 total_real_trim_size;
+	u64 total_trim_size;
 
 	/* extra one for all 0 */
 	int num[MTRR_NUM_TYPES + 1];
@@ -1155,11 +1419,22 @@ int __init mtrr_trim_uncached_memory(uns
 	if (def != MTRR_TYPE_UNCACHABLE)
 		return 0;
 
-	/* Find highest cached pfn */
+	/* get it and store it aside */
+	memset(range_state, 0, sizeof(range_state));
 	for (i = 0; i < num_var_ranges; i++) {
 		mtrr_if->get(i, &base, &size, &type);
+		range_state[i].base_pfn = base;
+		range_state[i].size_pfn = size;
+		range_state[i].type = type;
+	}
+
+	/* Find highest cached pfn */
+	for (i = 0; i < num_var_ranges; i++) {
+		type = range_state[i].type;
 		if (type != MTRR_TYPE_WRBACK)
 			continue;
+		base = range_state[i].base_pfn;
+		size = range_state[i].size_pfn;
 		if (highest_pfn < base + size)
 			highest_pfn = base + size;
 	}
@@ -1177,9 +1452,10 @@ int __init mtrr_trim_uncached_memory(uns
 	/* check entries number */
 	memset(num, 0, sizeof(num));
 	for (i = 0; i < num_var_ranges; i++) {
-		mtrr_if->get(i, &base, &size, &type);
+		type = range_state[i].type;
 		if (type >= MTRR_NUM_TYPES)
 			continue;
+		size = range_state[i].size_pfn;
 		if (!size)
 			type = MTRR_NUM_TYPES;
 		num[type]++;
@@ -1205,26 +1481,28 @@ int __init mtrr_trim_uncached_memory(uns
 	}
 	nr_range = x86_get_mtrr_mem_range(range, nr_range, 0, 0);
 
-	total_real_trim_size = 0;
+	total_trim_size = 0;
 	/* check the head */
 	if (range[0].start)
-		total_real_trim_size += real_trim_memory(0, range[0].start);
+		total_trim_size += real_trim_memory(0, range[0].start);
 	/* check the holes */
 	for (i = 0; i < nr_range - 1; i++) {
 		if (range[i].end + 1 < range[i+1].start)
-			total_real_trim_size += real_trim_memory(range[i].end + 1, range[i+1].start);
+			total_trim_size += real_trim_memory(range[i].end + 1,
+							    range[i+1].start);
 	}
 	/* check the top */
 	i = nr_range - 1;
 	if (range[i].end + 1 < end_pfn)
-		total_real_trim_size += real_trim_memory(range[i].end + 1, end_pfn);
+		total_trim_size += real_trim_memory(range[i].end + 1,
+							 end_pfn);
 
-	if (total_real_trim_size) {
+	if (total_trim_size) {
 		printk(KERN_WARNING "WARNING: BIOS bug: CPU MTRRs don't cover"
 			" all of memory, losing %lluMB of RAM.\n",
-			total_real_trim_size >> 20);
+			total_trim_size >> 20);
 
-		if (enable_mtrr_cleanup < 1)
+		if (!changed_by_mtrr_cleanup)
 			WARN_ON(1);
 
 		printk(KERN_INFO "update e820 for mtrr\n");
@@ -1314,8 +1592,10 @@ void __init mtrr_bp_init(void)
 		if (use_intel()) {
 			get_mtrr_state();
 
-			if (mtrr_cleanup(phys_addr))
+			if (mtrr_cleanup(phys_addr)) {
+				changed_by_mtrr_cleanup = 1;
 				mtrr_if->set_all();
+			}
 
 		}
 	}
@@ -1355,7 +1635,7 @@ static int __init mtrr_init_finialize(vo
 	if (!mtrr_if)
 		return 0;
 	if (use_intel()) {
-		if (enable_mtrr_cleanup < 1)
+		if (!changed_by_mtrr_cleanup)
 			mtrr_state_warn();
 	} else {
 		/* The CPUs haven't MTRR and seem to not support SMP. They have
Index: linux-2.6/Documentation/kernel-parameters.txt
===================================================================
--- linux-2.6.orig/Documentation/kernel-parameters.txt
+++ linux-2.6/Documentation/kernel-parameters.txt
@@ -613,8 +613,17 @@ and is between 256 and 4096 characters. 
 			that could hold holes aka. UC entries.
 
 	mtrr_gran_size=nn[KMG] [X86]
-			used for mtrr cleanup. It is granity of mtrr block.
-			Big value could prevent small alignment use up MTRRs.
+			Used for mtrr cleanup. It is granularity of mtrr block.
+			Default is 1.
+			Large value could prevent small alignment from
+			using up MTRRs.
+
+	mtrr_spare_reg_nr=n [X86]
+			Format: <integer>
+			Range: 0,7 : spare reg number
+			Default : 1
+			Used for mtrr cleanup. It is spare mtrr entries number.
+			Set to 2 or more if your graphical card needs more.
 
 	disable_mtrr_trim [X86, Intel and AMD only]
 			By default the kernel will trim any uncacheable
Index: linux-2.6/arch/x86/Kconfig
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig
+++ linux-2.6/arch/x86/Kconfig
@@ -1100,6 +1100,15 @@ config MTRR_SANITIZER_ENABLE_DEFAULT
 	help
 	  Enable mtrr cleanup default value
 
+config MTRR_SANITIZER_SPARE_REG_NR_DEFAULT
+	int "MTRR cleanup spare reg num (0-7)"
+	range 0 7
+	default "1"
+	depends on MTRR_SANITIZER
+	help
+	  mtrr cleanup spare entries default, it can be changed via
+	  mtrr_spare_reg_nr=
+
 config X86_PAT
 	bool
 	prompt "x86 PAT support"
