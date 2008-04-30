Return-Path: <linux-kernel-owner+w=401wt.eu-S1759626AbYD3D0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759626AbYD3D0b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 23:26:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753132AbYD3DZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 23:25:59 -0400
Received: from hu-out-0506.google.com ([72.14.214.235]:21451 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbYD3DZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 23:25:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=reply-to:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding:from;
        b=sArxwwbTdXMUD4ZDpWtvYEuPAxvBjzeKUQS8P7TKVoxtfqoUOnMtjEgpzWqCXqpOk4eRNZGtfrdEku4Y0sYp7kPi+bfj0N6MdM+swmf9tLOftt6j6sLL6AIBTNJd1//jY/HmgL6ROJYlQxPNfZmq5SKvdSCtmdlAoyxypRUpcjc=
Reply-To: yhlu.kernel@gmail.com
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Gabriel C <nix.or.die@googlemail.com>,
       Mika Fischer <mika.fischer@zoopnet.de>
Subject: [PATCH] x86: mtrr cleanup for converting continuous to discrete layout v8 - fix
Date: Tue, 29 Apr 2008 20:25:58 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200804272337.40130.yhlu.kernel@gmail.com> <200804290200.33459.yhlu.kernel@gmail.com> <200804290352.33543.yhlu.kernel@gmail.com>
In-Reply-To: <200804290352.33543.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804292025.58268.yhlu.kernel@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
From: Yinghai Lu <yhlu.kernel.send@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


v9: address format change requests by Ingo
    more case handling in range_to_var_with_hole

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/arch/x86/Kconfig
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig
+++ linux-2.6/arch/x86/Kconfig
@@ -1092,13 +1092,12 @@ config MTRR_SANITIZER
 	  If unsure, say Y.
 
 config MTRR_SANITIZER_ENABLE_DEFAULT
-	def_bool y
-	prompt "Enable MTRR cleanup by default"
+	int "MTRR cleanup enable value (0-1)"
+	range 0 1
+	default "0"
 	depends on MTRR_SANITIZER
 	help
-	  Enable mtrr cleanup by default
-
-	  If unsure, say Y.
+	  Enable mtrr cleanup default value
 
 config X86_PAT
 	bool
Index: linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mtrr/main.c
+++ linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
@@ -611,17 +611,9 @@ static struct sysdev_driver mtrr_sysdev_
 };
 
 #ifdef CONFIG_MTRR_SANITIZER
-
-#ifdef CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT
-static int enable_mtrr_cleanup __initdata = 1;
-#else
-static int enable_mtrr_cleanup __initdata;
-#endif
-
+static int enable_mtrr_cleanup __initdata = CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT;
 #else
-
 static int enable_mtrr_cleanup __initdata = -1;
-
 #endif
 
 static int __init disable_mtrr_cleanup_setup(char *str)
@@ -640,6 +632,7 @@ static int __init enable_mtrr_cleanup_se
 }
 early_param("enble_mtrr_cleanup", enable_mtrr_cleanup_setup);
 
+/* should be related to MTRR_VAR_RANGES nums */
 #define RANGE_NUM 256
 
 struct res_range {
@@ -647,13 +640,27 @@ struct res_range {
 	unsigned long end;
 };
 
-static int __init add_range(struct res_range *range, int nr_range, unsigned long start,
-			      unsigned long end, int merge)
+static int __init
+add_range(struct res_range *range, int nr_range, unsigned long start,
+			      unsigned long end)
 {
-	int i;
+	/* out of slots */
+	if (nr_range >= RANGE_NUM)
+		return nr_range;
 
-	if (!merge)
-		goto addit;
+	range[nr_range].start = start;
+	range[nr_range].end = end;
+
+	nr_range++;
+
+	return nr_range;
+}
+
+static int __init
+add_range_with_merge(struct res_range *range, int nr_range, unsigned long start,
+			      unsigned long end)
+{
+	int i;
 
 	/* try to merge it with old one */
 	for (i = 0; i < nr_range; i++) {
@@ -676,24 +683,14 @@ static int __init add_range(struct res_r
 		return nr_range;
 	}
 
-addit:
 	/* need to add that */
-	if (nr_range >= RANGE_NUM)
-		return nr_range;
-
-	range[nr_range].start = start;
-	range[nr_range].end = end;
-
-	nr_range++;
-
-	return nr_range;
-
+	return add_range(range, nr_range, start, end);
 }
-static void __init subtract_range(struct res_range *range, unsigned long start,
-				unsigned long end)
+
+static void __init
+subtract_range(struct res_range *range, unsigned long start, unsigned long end)
 {
-	int i;
-	int j;
+	int i, j;
 
 	for (j = 0; j < RANGE_NUM; j++) {
 		if (!range[j].end)
@@ -747,46 +744,47 @@ static int __init cmp_range(const void *
 }
 
 struct var_mtrr_state {
-	unsigned long range_startk, range_sizek;
-	unsigned long chunk_sizek;
-	unsigned long gran_sizek;
-	unsigned int reg;
-	unsigned address_bits;
+	unsigned long	range_startk;
+	unsigned long	range_sizek;
+	unsigned long	chunk_sizek;
+	unsigned long	gran_sizek;
+	unsigned int	reg;
+	unsigned int	address_bits;
 };
 
-static void __init set_var_mtrr(
-	unsigned int reg, unsigned long basek, unsigned long sizek,
-	unsigned char type, unsigned address_bits)
+static void __init
+set_var_mtrr(unsigned int reg, unsigned long basek, unsigned long sizek,
+		unsigned char type, unsigned address_bits)
 {
 	u32 base_lo, base_hi, mask_lo, mask_hi;
-	unsigned address_mask_high;
+	u64 base, mask;
 
 	if (!sizek) {
 		fill_mtrr_var_range(reg, 0, 0, 0, 0);
 		return;
 	}
 
-	address_mask_high = ((1u << (address_bits - 32u)) - 1u);
+	mask = (1ULL << address_bits) - 1;
+	mask &= ~((((u64)sizek) << 10) - 1);
 
-	base_hi = basek >> 22;
-	base_lo  = basek << 10;
+	base  = ((u64)basek) << 10;
 
-	if (sizek < 4*1024*1024) {
-		mask_hi = address_mask_high;
-		mask_lo = ~((sizek << 10) - 1);
-	} else {
-		mask_hi = address_mask_high & (~((sizek >> 22) - 1));
-		mask_lo = 0;
-	}
+	base |= type;
+	mask |= 0x800;
+
+	base_lo = base & ((1ULL<<32) - 1);
+	base_hi = base >> 32;
+
+	mask_lo = mask & ((1ULL<<32) - 1);
+	mask_hi = mask >> 32;
 
-	base_lo |= type;
-	mask_lo |= 0x800;
 	fill_mtrr_var_range(reg, base_lo, base_hi, mask_lo, mask_hi);
 }
 
-static unsigned int __init range_to_mtrr(unsigned int reg,
-	unsigned long range_startk, unsigned long range_sizek,
-	unsigned char type, unsigned address_bits)
+static unsigned int __init
+range_to_mtrr(unsigned int reg, unsigned long range_startk,
+	      unsigned long range_sizek, unsigned char type,
+	      unsigned address_bits)
 {
 	if (!range_sizek || (reg >= num_var_ranges))
 		return reg;
@@ -794,6 +792,7 @@ static unsigned int __init range_to_mtrr
 	while (range_sizek) {
 		unsigned long max_align, align;
 		unsigned long sizek;
+
 		/* Compute the maximum size I can make a range */
 		if (range_startk)
 			max_align = ffs(range_startk) - 1;
@@ -818,7 +817,8 @@ static unsigned int __init range_to_mtrr
 	return reg;
 }
 
-static void __init range_to_mtrr_with_hole(struct var_mtrr_state *state, unsigned long basek)
+static void __init
+range_to_mtrr_with_hole(struct var_mtrr_state *state, unsigned long basek)
 {
 	unsigned long hole_basek, hole_sizek;
 	unsigned long range0_basek, range0_sizek;
@@ -848,23 +848,31 @@ static void __init range_to_mtrr_with_ho
 	/* try to append some small hole */
 	range0_basek = state->range_startk;
 	range0_sizek = ALIGN(state->range_sizek, chunk_sizek);
-	if ((range0_sizek == state->range_sizek) ||
-	    ((range0_basek + range0_sizek - chunk_sizek > basek) && basek)) {
+	if (range0_sizek == state->range_sizek) {
 			printk(KERN_INFO "rangeX: %016lx - %016lx\n", range0_basek<<10, (range0_basek + state->range_sizek)<<10);
 			state->reg = range_to_mtrr(state->reg, range0_basek,
 				state->range_sizek, MTRR_TYPE_WRBACK, state->address_bits);
 		return;
+	} else if (basek) {
+	    while (range0_basek + range0_sizek - chunk_sizek > basek) {
+		range0_sizek -= chunk_sizek;
+		if (!range0_sizek)
+			break;
+	    }
 	}
 
 
-	range0_sizek -= chunk_sizek;
+	if (range0_sizek > chunk_sizek)
+		range0_sizek -= chunk_sizek;
 	printk(KERN_INFO "range0: %016lx - %016lx\n", range0_basek<<10, (range0_basek + range0_sizek)<<10);
 	state->reg = range_to_mtrr(state->reg, range0_basek,
 			range0_sizek, MTRR_TYPE_WRBACK, state->address_bits);
 
 	range_basek = range0_basek + range0_sizek;
 	range_sizek = chunk_sizek;
-	if (range_sizek - (state->range_sizek - range0_sizek) < (chunk_sizek >> 1)) {
+
+	if ((range_sizek - (state->range_sizek - range0_sizek) < (chunk_sizek >> 1)) &&
+	    (range_basek + range_sizek <= basek)) {
 		hole_sizek = range_sizek - (state->range_sizek - range0_sizek);
 		hole_basek = range_basek + range_sizek - hole_sizek;
 	} else
@@ -880,7 +888,9 @@ static void __init range_to_mtrr_with_ho
 	}
 }
 
-static void __init set_var_mtrr_range(struct var_mtrr_state *state, unsigned long base_pfn, unsigned long size_pfn)
+static void __init
+set_var_mtrr_range(struct var_mtrr_state *state, unsigned long base_pfn,
+		   unsigned long size_pfn)
 {
 	unsigned long basek, sizek;
 
@@ -921,7 +931,7 @@ static int __init parse_mtrr_chunk_size_
 early_param("mtrr_chunk_size", parse_mtrr_chunk_size_opt);
 
 /* granity of mtrr of block */
-static u64 mtrr_gran_size __initdata = (64ULL<<20);
+static u64 mtrr_gran_size __initdata = (1ULL<<20);
 
 static int __init parse_mtrr_gran_size_opt(char *p)
 {
@@ -932,17 +942,19 @@ static int __init parse_mtrr_gran_size_o
 }
 early_param("mtrr_gran_size", parse_mtrr_gran_size_opt);
 
-static void __init x86_setup_var_mtrrs(struct res_range *range, int nr_range, unsigned address_bits)
+static void __init
+x86_setup_var_mtrrs(struct res_range *range, int nr_range,
+		    unsigned address_bits)
 {
 	struct var_mtrr_state var_state;
 	int i;
 
-	var_state.range_startk = 0;
-	var_state.range_sizek = 0;
-	var_state.reg = 0;
-	var_state.address_bits = address_bits;
-	var_state.chunk_sizek = mtrr_chunk_size >> 10;
-	var_state.gran_sizek = mtrr_gran_size >> 10;
+	var_state.range_startk	= 0;
+	var_state.range_sizek	= 0;
+	var_state.reg		= 0;
+	var_state.address_bits	= address_bits;
+	var_state.chunk_sizek	= mtrr_chunk_size >> 10;
+	var_state.gran_sizek	= mtrr_gran_size >> 10;
 
 	/* Write the range etc */
 	for (i = 0; i < nr_range; i++)
@@ -952,11 +964,16 @@ static void __init x86_setup_var_mtrrs(s
 	range_to_mtrr_with_hole(&var_state, 0);
 	printk(KERN_INFO "DONE variable MTRRs\n");
 	/* Clear out the extra MTRR's */
-	while (var_state.reg < num_var_ranges)
-		set_var_mtrr(var_state.reg++, 0, 0, 0, var_state.address_bits);
+	while (var_state.reg < num_var_ranges) {
+		set_var_mtrr(var_state.reg, 0, 0, 0, var_state.address_bits);
+		var_state.reg++;
+	}
 }
 
-static int __init x86_get_mtrr_mem_range(struct res_range *range, int nr_range, unsigned long extra_remove_base, unsigned long extra_remove_size)
+static int __init
+x86_get_mtrr_mem_range(struct res_range *range, int nr_range,
+		       unsigned long extra_remove_base,
+		       unsigned long extra_remove_size)
 {
 	unsigned long i, base, size;
 	mtrr_type type;
@@ -965,7 +982,7 @@ static int __init x86_get_mtrr_mem_range
 		mtrr_if->get(i, &base, &size, &type);
 		if (type != MTRR_TYPE_WRBACK)
 			continue;
-		nr_range = add_range(range, nr_range, base, base + size - 1, 1);
+		nr_range = add_range_with_merge(range, nr_range, base, base + size - 1);
 	}
 	printk(KERN_INFO "After WB checking\n");
 	for (i = 0; i < nr_range; i++)
@@ -1005,11 +1022,11 @@ static int __init x86_get_mtrr_mem_range
 
 static int __init mtrr_cleanup(unsigned address_bits)
 {
+	unsigned long extra_remove_base, extra_remove_size;
 	unsigned long i, base, size, def, dummy;
-	mtrr_type type;
 	struct res_range range[RANGE_NUM];
+	mtrr_type type;
 	int nr_range;
-	unsigned long extra_remove_base, extra_remove_size;
 
 	/* extra one for all 0 */
 	int num[MTRR_NUM_TYPES + 1];
@@ -1053,7 +1070,6 @@ static int __init mtrr_cleanup(unsigned 
 	x86_setup_var_mtrrs(range, nr_range, address_bits);
 
 	return 1;
-
 }
 
 static int disable_mtrr_trim;
