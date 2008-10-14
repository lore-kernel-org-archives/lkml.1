Return-Path: <linux-kernel-owner+w=401wt.eu-S1758064AbYJNBHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758064AbYJNBHh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 21:07:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752068AbYJNBH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 21:07:26 -0400
Received: from rv-out-0708.google.com ([209.85.198.241]:62329 "EHLO
	rv-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbYJNBHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 21:07:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:sender;
        b=BntH8BtOevWuVK1irSBiH5PYZmq2Og7aCOXw1pGLnSk07WOrletxeKQQGhqwhWGMaX
         po+6EzX0NpbV+8iouNISwJf+CYe4Ulvbry1/CGm/bw4T4xz+4/k2lsVdj2HJ75F7/fC8
         Mcmt/Xk3n2w8+QeiLtsmY8LjOrZHSwTKdQz50=
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH] x86: break mtrr_cleanup() to several small functions.
Date: Mon, 13 Oct 2008 18:06:43 -0700
Message-Id: <1223946403-11548-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo said mtrr_cleanup() is some big and ugly.

so break it into more functions and make it more readable.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/cpu/mtrr/main.c |  346 +++++++++++++++++++---------------------
 1 file changed, 171 insertions(+), 175 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mtrr/main.c
+++ linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
@@ -803,6 +803,7 @@ x86_get_mtrr_mem_range(struct res_range
 }
 
 static struct res_range __initdata range[RANGE_NUM];
+static int __initdata nr_range;
 
 #ifdef CONFIG_MTRR_SANITIZER
 
@@ -1206,39 +1207,43 @@ struct mtrr_cleanup_result {
 #define PSHIFT		(PAGE_SHIFT - 10)
 
 static struct mtrr_cleanup_result __initdata result[NUM_RESULT];
-static struct res_range __initdata range_new[RANGE_NUM];
 static unsigned long __initdata min_loss_pfn[RANGE_NUM];
 
-static int __init mtrr_cleanup(unsigned address_bits)
+static void __init print_out_mtrr_range_state(void)
 {
-	unsigned long extra_remove_base, extra_remove_size;
-	unsigned long base, size, def, dummy;
-	mtrr_type type;
-	int nr_range, nr_range_new;
-	u64 chunk_size, gran_size;
-	unsigned long range_sums, range_sums_new;
-	int index_good;
-	int num_reg_good;
 	int i;
+	char start_factor = 'K', size_factor = 'K';
+	unsigned long start_base, size_base;
+	mtrr_type type;
 
-	/* extra one for all 0 */
-	int num[MTRR_NUM_TYPES + 1];
+	for (i = 0; i < num_var_ranges; i++) {
 
-	if (!is_cpu(INTEL) || enable_mtrr_cleanup < 1)
-		return 0;
-	rdmsr(MTRRdefType_MSR, def, dummy);
-	def &= 0xff;
-	if (def != MTRR_TYPE_UNCACHABLE)
-		return 0;
+		size_base = range_state[i].size_pfn << (PAGE_SHIFT - 10);
+		if (!size_base)
+			continue;
 
-	/* get it and store it aside */
-	memset(range_state, 0, sizeof(range_state));
-	for (i = 0; i < num_var_ranges; i++) {
-		mtrr_if->get(i, &base, &size, &type);
-		range_state[i].base_pfn = base;
-		range_state[i].size_pfn = size;
-		range_state[i].type = type;
+		size_base = to_size_factor(size_base, &size_factor),
+		start_base = range_state[i].base_pfn << (PAGE_SHIFT - 10);
+		start_base = to_size_factor(start_base, &start_factor),
+		type = range_state[i].type;
+
+		printk(KERN_DEBUG "reg %d, base: %ld%cB, range: %ld%cB, type %s\n",
+			i, start_base, start_factor,
+			size_base, size_factor,
+			(type == MTRR_TYPE_UNCACHABLE) ? "UC" :
+			    ((type == MTRR_TYPE_WRPROT) ? "WP" :
+			     ((type == MTRR_TYPE_WRBACK) ? "WB" : "Other"))
+			);
 	}
+}
+
+static int __init mtrr_need_cleanup(void)
+{
+	int i;
+	mtrr_type type;
+	unsigned long size;
+	/* extra one for all 0 */
+	int num[MTRR_NUM_TYPES + 1];
 
 	/* check entries number */
 	memset(num, 0, sizeof(num));
@@ -1263,30 +1268,134 @@ static int __init mtrr_cleanup(unsigned
 		num_var_ranges - num[MTRR_NUM_TYPES])
 		return 0;
 
-	/* print original var MTRRs at first, for debugging: */
-	printk(KERN_DEBUG "original variable MTRRs\n");
-	for (i = 0; i < num_var_ranges; i++) {
-		char start_factor = 'K', size_factor = 'K';
-		unsigned long start_base, size_base;
+	return 1;
+}
 
-		size_base = range_state[i].size_pfn << (PAGE_SHIFT - 10);
-		if (!size_base)
-			continue;
+static unsigned long __initdata range_sums;
+static void __init mtrr_calc_range_state(u64 chunk_size, u64 gran_size,
+					 unsigned long extra_remove_base,
+					 unsigned long extra_remove_size,
+					 int i)
+{
+	int num_reg;
+	static struct res_range range_new[RANGE_NUM];
+	static int nr_range_new;
+	unsigned long range_sums_new;
+
+	/* convert ranges to var ranges state */
+	num_reg = x86_setup_var_mtrrs(range, nr_range,
+						chunk_size, gran_size);
+
+	/* we got new setting in range_state, check it */
+	memset(range_new, 0, sizeof(range_new));
+	nr_range_new = x86_get_mtrr_mem_range(range_new, 0,
+				extra_remove_base, extra_remove_size);
+	range_sums_new = sum_ranges(range_new, nr_range_new);
+
+	result[i].chunk_sizek = chunk_size >> 10;
+	result[i].gran_sizek = gran_size >> 10;
+	result[i].num_reg = num_reg;
+	if (range_sums < range_sums_new) {
+		result[i].lose_cover_sizek =
+			(range_sums_new - range_sums) << PSHIFT;
+		result[i].bad = 1;
+	} else
+		result[i].lose_cover_sizek =
+			(range_sums - range_sums_new) << PSHIFT;
+
+	/* double check it */
+	if (!result[i].bad && !result[i].lose_cover_sizek) {
+		if (nr_range_new != nr_range ||
+			memcmp(range, range_new, sizeof(range)))
+				result[i].bad = 1;
+	}
 
-		size_base = to_size_factor(size_base, &size_factor),
-		start_base = range_state[i].base_pfn << (PAGE_SHIFT - 10);
-		start_base = to_size_factor(start_base, &start_factor),
-		type = range_state[i].type;
+	if (!result[i].bad && (range_sums - range_sums_new <
+				min_loss_pfn[num_reg])) {
+		min_loss_pfn[num_reg] =
+			range_sums - range_sums_new;
+	}
+}
 
-		printk(KERN_DEBUG "reg %d, base: %ld%cB, range: %ld%cB, type %s\n",
-			i, start_base, start_factor,
-			size_base, size_factor,
-			(type == MTRR_TYPE_UNCACHABLE) ? "UC" :
-			    ((type == MTRR_TYPE_WRPROT) ? "WP" :
-			     ((type == MTRR_TYPE_WRBACK) ? "WB" : "Other"))
-			);
+static void __init mtrr_print_out_one_result(int i)
+{
+	char gran_factor, chunk_factor, lose_factor;
+	unsigned long gran_base, chunk_base, lose_base;
+
+	gran_base = to_size_factor(result[i].gran_sizek, &gran_factor),
+	chunk_base = to_size_factor(result[i].chunk_sizek, &chunk_factor),
+	lose_base = to_size_factor(result[i].lose_cover_sizek, &lose_factor),
+	printk(KERN_INFO "%sgran_size: %ld%c \tchunk_size: %ld%c \t",
+			result[i].bad ? "*BAD*" : " ",
+			gran_base, gran_factor, chunk_base, chunk_factor);
+	printk(KERN_CONT "num_reg: %d  \tlose cover RAM: %s%ld%c\n",
+			result[i].num_reg, result[i].bad ? "-" : "",
+			lose_base, lose_factor);
+}
+
+static int __init mtrr_search_optimal_index(void)
+{
+	int i;
+	int num_reg_good;
+	int index_good;
+
+	if (nr_mtrr_spare_reg >= num_var_ranges)
+		nr_mtrr_spare_reg = num_var_ranges - 1;
+	num_reg_good = -1;
+	for (i = num_var_ranges - nr_mtrr_spare_reg; i > 0; i--) {
+		if (!min_loss_pfn[i])
+			num_reg_good = i;
+	}
+
+	index_good = -1;
+	if (num_reg_good != -1) {
+		for (i = 0; i < NUM_RESULT; i++) {
+			if (!result[i].bad &&
+			    result[i].num_reg == num_reg_good &&
+			    !result[i].lose_cover_sizek) {
+				index_good = i;
+				break;
+			}
+		}
+	}
+
+	return index_good;
+}
+
+
+static int __init mtrr_cleanup(unsigned address_bits)
+{
+	unsigned long extra_remove_base, extra_remove_size;
+	unsigned long base, size, def, dummy;
+	mtrr_type type;
+	u64 chunk_size, gran_size;
+	int index_good;
+	int i;
+
+	if (!is_cpu(INTEL) || enable_mtrr_cleanup < 1)
+		return 0;
+	rdmsr(MTRRdefType_MSR, def, dummy);
+	def &= 0xff;
+	if (def != MTRR_TYPE_UNCACHABLE)
+		return 0;
+
+	/* get it and store it aside */
+	memset(range_state, 0, sizeof(range_state));
+	for (i = 0; i < num_var_ranges; i++) {
+		mtrr_if->get(i, &base, &size, &type);
+		range_state[i].base_pfn = base;
+		range_state[i].size_pfn = size;
+		range_state[i].type = type;
 	}
 
+	/* check if we need handle it and can handle it */
+	if (!mtrr_need_cleanup())
+		return 0;
+
+	/* print original var MTRRs at first, for debugging: */
+	printk(KERN_DEBUG "original variable MTRRs\n");
+	print_out_mtrr_range_state();
+
 	memset(range, 0, sizeof(range));
 	extra_remove_size = 0;
 	extra_remove_base = 1 << (32 - PAGE_SHIFT);
@@ -1309,176 +1418,64 @@ static int __init mtrr_cleanup(unsigned
 	       range_sums >> (20 - PAGE_SHIFT));
 
 	if (mtrr_chunk_size && mtrr_gran_size) {
-		int num_reg;
-		char gran_factor, chunk_factor, lose_factor;
-		unsigned long gran_base, chunk_base, lose_base;
-
-		debug_print++;
-		/* convert ranges to var ranges state */
-		num_reg = x86_setup_var_mtrrs(range, nr_range, mtrr_chunk_size,
-					      mtrr_gran_size);
+		i = 0;
+		mtrr_calc_range_state(mtrr_chunk_size, mtrr_gran_size,
+				      extra_remove_base, extra_remove_size, i);
 
-		/* we got new setting in range_state, check it */
-		memset(range_new, 0, sizeof(range_new));
-		nr_range_new = x86_get_mtrr_mem_range(range_new, 0,
-						      extra_remove_base,
-						      extra_remove_size);
-		range_sums_new = sum_ranges(range_new, nr_range_new);
+		mtrr_print_out_one_result(i);
 
-		i = 0;
-		result[i].chunk_sizek = mtrr_chunk_size >> 10;
-		result[i].gran_sizek = mtrr_gran_size >> 10;
-		result[i].num_reg = num_reg;
-		if (range_sums < range_sums_new) {
-			result[i].lose_cover_sizek =
-				(range_sums_new - range_sums) << PSHIFT;
-			result[i].bad = 1;
-		} else
-			result[i].lose_cover_sizek =
-				(range_sums - range_sums_new) << PSHIFT;
-
-		gran_base = to_size_factor(result[i].gran_sizek, &gran_factor),
-		chunk_base = to_size_factor(result[i].chunk_sizek, &chunk_factor),
-		lose_base = to_size_factor(result[i].lose_cover_sizek, &lose_factor),
-		printk(KERN_INFO "%sgran_size: %ld%c \tchunk_size: %ld%c \t",
-			 result[i].bad?"*BAD*":" ",
-			 gran_base, gran_factor, chunk_base, chunk_factor);
-		printk(KERN_CONT "num_reg: %d  \tlose cover RAM: %s%ld%c\n",
-			 result[i].num_reg, result[i].bad?"-":"",
-			 lose_base, lose_factor);
 		if (!result[i].bad) {
 			set_var_mtrr_all(address_bits);
 			return 1;
 		}
 		printk(KERN_INFO "invalid mtrr_gran_size or mtrr_chunk_size, "
 		       "will find optimal one\n");
-		debug_print--;
-		memset(result, 0, sizeof(result[0]));
 	}
 
 	i = 0;
 	memset(min_loss_pfn, 0xff, sizeof(min_loss_pfn));
 	memset(result, 0, sizeof(result));
 	for (gran_size = (1ULL<<16); gran_size < (1ULL<<32); gran_size <<= 1) {
-		char gran_factor;
-		unsigned long gran_base;
-
-		if (debug_print)
-			gran_base = to_size_factor(gran_size >> 10, &gran_factor);
 
 		for (chunk_size = gran_size; chunk_size < (1ULL<<32);
 		     chunk_size <<= 1) {
-			int num_reg;
 
-			if (debug_print) {
-				char chunk_factor;
-				unsigned long chunk_base;
-
-				chunk_base = to_size_factor(chunk_size>>10, &chunk_factor),
-				printk(KERN_INFO "\n");
-				printk(KERN_INFO "gran_size: %ld%c   chunk_size: %ld%c \n",
-				       gran_base, gran_factor, chunk_base, chunk_factor);
-			}
 			if (i >= NUM_RESULT)
 				continue;
 
-			/* convert ranges to var ranges state */
-			num_reg = x86_setup_var_mtrrs(range, nr_range,
-							 chunk_size, gran_size);
-
-			/* we got new setting in range_state, check it */
-			memset(range_new, 0, sizeof(range_new));
-			nr_range_new = x86_get_mtrr_mem_range(range_new, 0,
-					 extra_remove_base, extra_remove_size);
-			range_sums_new = sum_ranges(range_new, nr_range_new);
-
-			result[i].chunk_sizek = chunk_size >> 10;
-			result[i].gran_sizek = gran_size >> 10;
-			result[i].num_reg = num_reg;
-			if (range_sums < range_sums_new) {
-				result[i].lose_cover_sizek =
-					(range_sums_new - range_sums) << PSHIFT;
-				result[i].bad = 1;
-			} else
-				result[i].lose_cover_sizek =
-					(range_sums - range_sums_new) << PSHIFT;
-
-			/* double check it */
-			if (!result[i].bad && !result[i].lose_cover_sizek) {
-				if (nr_range_new != nr_range ||
-					memcmp(range, range_new, sizeof(range)))
-						result[i].bad = 1;
+			mtrr_calc_range_state(chunk_size, gran_size,
+				      extra_remove_base, extra_remove_size, i);
+			if (debug_print) {
+				mtrr_print_out_one_result(i);
+				printk(KERN_INFO "\n");
 			}
 
-			if (!result[i].bad && (range_sums - range_sums_new <
-					       min_loss_pfn[num_reg])) {
-				min_loss_pfn[num_reg] =
-					range_sums - range_sums_new;
-			}
 			i++;
 		}
 	}
 
-	/* print out all */
-	for (i = 0; i < NUM_RESULT; i++) {
-		char gran_factor, chunk_factor, lose_factor;
-		unsigned long gran_base, chunk_base, lose_base;
-
-		gran_base = to_size_factor(result[i].gran_sizek, &gran_factor),
-		chunk_base = to_size_factor(result[i].chunk_sizek, &chunk_factor),
-		lose_base = to_size_factor(result[i].lose_cover_sizek, &lose_factor),
-		printk(KERN_INFO "%sgran_size: %ld%c \tchunk_size: %ld%c \t",
-			 result[i].bad?"*BAD*":" ",
-			 gran_base, gran_factor, chunk_base, chunk_factor);
-		printk(KERN_CONT "num_reg: %d  \tlose cover RAM: %s%ld%c\n",
-			 result[i].num_reg, result[i].bad?"-":"",
-			 lose_base, lose_factor);
-	}
-
 	/* try to find the optimal index */
-	if (nr_mtrr_spare_reg >= num_var_ranges)
-		nr_mtrr_spare_reg = num_var_ranges - 1;
-	num_reg_good = -1;
-	for (i = num_var_ranges - nr_mtrr_spare_reg; i > 0; i--) {
-		if (!min_loss_pfn[i])
-			num_reg_good = i;
-	}
-
-	index_good = -1;
-	if (num_reg_good != -1) {
-		for (i = 0; i < NUM_RESULT; i++) {
-			if (!result[i].bad &&
-			    result[i].num_reg == num_reg_good &&
-			    !result[i].lose_cover_sizek) {
-				index_good = i;
-				break;
-			}
-		}
-	}
+	index_good = mtrr_search_optimal_index();
 
 	if (index_good != -1) {
-		char gran_factor, chunk_factor, lose_factor;
-		unsigned long gran_base, chunk_base, lose_base;
-
 		printk(KERN_INFO "Found optimal setting for mtrr clean up\n");
 		i = index_good;
-		gran_base = to_size_factor(result[i].gran_sizek, &gran_factor),
-		chunk_base = to_size_factor(result[i].chunk_sizek, &chunk_factor),
-		lose_base = to_size_factor(result[i].lose_cover_sizek, &lose_factor),
-		printk(KERN_INFO "gran_size: %ld%c \tchunk_size: %ld%c \t",
-			 gran_base, gran_factor, chunk_base, chunk_factor);
-		printk(KERN_CONT "num_reg: %d  \tlose RAM: %ld%c\n",
-			 result[i].num_reg, lose_base, lose_factor);
+		mtrr_print_out_one_result(i);
+
 		/* convert ranges to var ranges state */
 		chunk_size = result[i].chunk_sizek;
 		chunk_size <<= 10;
 		gran_size = result[i].gran_sizek;
 		gran_size <<= 10;
-		debug_print++;
 		x86_setup_var_mtrrs(range, nr_range, chunk_size, gran_size);
-		debug_print--;
 		set_var_mtrr_all(address_bits);
+		printk(KERN_DEBUG "New variable MTRRs\n");
+		print_out_mtrr_range_state();
 		return 1;
+	} else {
+		/* print out all */
+		for (i = 0; i < NUM_RESULT; i++)
+			mtrr_print_out_one_result(i);
 	}
 
 	printk(KERN_INFO "mtrr_cleanup: can not find optimal value\n");
@@ -1562,7 +1559,6 @@ int __init mtrr_trim_uncached_memory(uns
 {
 	unsigned long i, base, size, highest_pfn = 0, def, dummy;
 	mtrr_type type;
-	int nr_range;
 	u64 total_trim_size;
 
 	/* extra one for all 0 */
