Return-Path: <linux-kernel-owner+w=401wt.eu-S1753499AbYEJFlM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499AbYEJFlM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 01:41:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751227AbYEJFk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 01:40:56 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:53420 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbYEJFkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 01:40:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=VqWgGdgQKcWUDOtWmDcap6OrASlIPVhzqRQuzXQLj8fx9T5V0oFGOYK40fXx0ZRre7q5mK5v4KCWORqNFtvqVk//bqMzCvsg056aBoPFfUqUgM4eAuajlpi8ropJLMREJ1CgAamlBl3/1ng4jispQKJEU18k7eXmP5hrsE1iVI8=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: yhlu.kernel@gmail.com
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] x86: mtrr cleanup for converting continuous to discrete layout - fix #2
Date: Fri, 9 May 2008 22:40:52 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805092240.52875.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


disable the noisy print out.
also use the one the less spare mtrr reg.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mtrr/main.c
+++ linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
@@ -730,6 +730,7 @@ struct var_mtrr_range_state {
 };
 
 struct var_mtrr_range_state __initdata range_state[RANGE_NUM];
+static int __initdata debug_print;
 
 static int __init
 x86_get_mtrr_mem_range(struct res_range *range, int nr_range,
@@ -748,10 +749,12 @@ x86_get_mtrr_mem_range(struct res_range 
 		nr_range = add_range_with_merge(range, nr_range, base,
 						base + size - 1);
 	}
-	printk(KERN_DEBUG "After WB checking\n");
-	for (i = 0; i < nr_range; i++)
-		printk(KERN_DEBUG "MTRR MAP PFN: %016lx - %016lx\n",
+	if (debug_print) {
+		printk(KERN_DEBUG "After WB checking\n");
+		for (i = 0; i < nr_range; i++)
+			printk(KERN_DEBUG "MTRR MAP PFN: %016lx - %016lx\n",
 				 range[i].start, range[i].end + 1);
+	}
 
 	/* take out UC ranges */
 	for (i = 0; i < num_var_ranges; i++) {
@@ -775,17 +778,21 @@ x86_get_mtrr_mem_range(struct res_range 
 			continue;
 		nr_range++;
 	}
-	printk(KERN_DEBUG "After UC checking\n");
-	for (i = 0; i < nr_range; i++)
-		printk(KERN_DEBUG "MTRR MAP PFN: %016lx - %016lx\n",
-			 range[i].start, range[i].end + 1);
+	if  (debug_print) {
+		printk(KERN_DEBUG "After UC checking\n");
+		for (i = 0; i < nr_range; i++)
+			printk(KERN_DEBUG "MTRR MAP PFN: %016lx - %016lx\n",
+				 range[i].start, range[i].end + 1);
+	}
 
 	/* sort the ranges */
 	sort(range, nr_range, sizeof(struct res_range), cmp_range, NULL);
-	printk(KERN_DEBUG "After sorting\n");
-	for (i = 0; i < nr_range; i++)
-		printk(KERN_DEBUG "MTRR MAP PFN: %016lx - %016lx\n",
+	if  (debug_print) {
+		printk(KERN_DEBUG "After sorting\n");
+		for (i = 0; i < nr_range; i++)
+			printk(KERN_DEBUG "MTRR MAP PFN: %016lx - %016lx\n",
 				 range[i].start, range[i].end + 1);
+	}
 
 	/* clear those is not used */
 	for (i = nr_range; i < RANGE_NUM; i++)
@@ -912,12 +919,13 @@ range_to_mtrr(unsigned int reg, unsigned
 			align = max_align;
 
 		sizek = 1 << align;
-		printk(KERN_DEBUG "Setting variable MTRR %d, base: %ldMB, "
-		       "range: %ldMB, type %s\n",
-			reg, range_startk >> 10, sizek >> 10,
-			(type == MTRR_TYPE_UNCACHABLE)?"UC":
-			    ((type == MTRR_TYPE_WRBACK)?"WB":"Other")
-			);
+		if (debug_print)
+			printk(KERN_DEBUG "Setting variable MTRR %d, "
+				"base: %ldMB, range: %ldMB, type %s\n",
+				reg, range_startk >> 10, sizek >> 10,
+				(type == MTRR_TYPE_UNCACHABLE)?"UC":
+				    ((type == MTRR_TYPE_WRBACK)?"WB":"Other")
+				);
 		save_var_mtrr(reg++, range_startk, sizek, type);
 		range_startk += sizek;
 		range_sizek -= sizek;
@@ -963,7 +971,9 @@ range_to_mtrr_with_hole(struct var_mtrr_
 	range0_basek = state->range_startk;
 	range0_sizek = ALIGN(state->range_sizek, chunk_sizek);
 	if (range0_sizek == state->range_sizek) {
-		printk(KERN_DEBUG "rangeX: %016lx - %016lx\n", range0_basek<<10,
+		if (debug_print)
+			printk(KERN_DEBUG "rangeX: %016lx - %016lx\n",
+				range0_basek<<10,
 				(range0_basek + state->range_sizek)<<10);
 		state->reg = range_to_mtrr(state->reg, range0_basek,
 				state->range_sizek, MTRR_TYPE_WRBACK);
@@ -980,7 +990,9 @@ range_to_mtrr_with_hole(struct var_mtrr_
 	}
 
 	if (range0_sizek) {
-		printk(KERN_DEBUG "range0: %016lx - %016lx\n", range0_basek<<10,
+		if (debug_print)
+			printk(KERN_DEBUG "range0: %016lx - %016lx\n",
+				range0_basek<<10,
 				(range0_basek + range0_sizek)<<10);
 		state->reg = range_to_mtrr(state->reg, range0_basek,
 				range0_sizek, MTRR_TYPE_WRBACK);
@@ -1016,13 +1028,15 @@ range_to_mtrr_with_hole(struct var_mtrr_
 		second_sizek = 0;
 	}
 
-	printk(KERN_DEBUG "range: %016lx - %016lx\n", range_basek<<10,
+	if (debug_print)
+		printk(KERN_DEBUG "range: %016lx - %016lx\n", range_basek<<10,
 			 (range_basek + range_sizek)<<10);
 	state->reg = range_to_mtrr(state->reg, range_basek, range_sizek,
 					 MTRR_TYPE_WRBACK);
 	if (hole_sizek) {
-		printk(KERN_DEBUG "hole: %016lx - %016lx\n", hole_basek<<10,
-				 (hole_basek + hole_sizek)<<10);
+		if (debug_print)
+			printk(KERN_DEBUG "hole: %016lx - %016lx\n",
+				 hole_basek<<10, (hole_basek + hole_sizek)<<10);
 		state->reg = range_to_mtrr(state->reg, hole_basek, hole_sizek,
 						 MTRR_TYPE_UNCACHABLE);
 
@@ -1120,7 +1134,6 @@ x86_setup_var_mtrrs(struct res_range *ra
 	/* Write the last range */
 	if (var_state.range_sizek != 0)
 		range_to_mtrr_with_hole(&var_state, 0, 0);
-	printk(KERN_DEBUG "DONE variable MTRRs\n");
 
 	num_reg = var_state.reg;
 	/* Clear out the extra MTRR's */
@@ -1219,6 +1232,7 @@ static int __init mtrr_cleanup(unsigned 
 	if (mtrr_chunk_size && mtrr_gran_size) {
 		int num_reg;
 
+		debug_print = 1;
 		/* convert ranges to var ranges state */
 		num_reg = x86_setup_var_mtrrs(range, nr_range, mtrr_chunk_size,
 					      mtrr_gran_size);
@@ -1242,8 +1256,8 @@ static int __init mtrr_cleanup(unsigned 
 			result[i].lose_cover_sizek =
 				(range_sums - range_sums_new) << PSHIFT;
 
-		printk(KERN_INFO " %sgran_size: %ldM  \tchunk_size: %ldM  \t",
-			 result[i].bad?" BAD ":"", result[i].gran_sizek >> 10,
+		printk(KERN_INFO "%sgran_size: %ldM \tchunk_size: %ldM \t",
+			 result[i].bad?"*BAD*":" ", result[i].gran_sizek >> 10,
 			 result[i].chunk_sizek >> 10);
 		printk(KERN_CONT "num_reg: %d  \tlose cover RAM: %s%ldM \n",
 			 result[i].num_reg, result[i].bad?"-":"",
@@ -1254,6 +1268,7 @@ static int __init mtrr_cleanup(unsigned 
 		}
 		printk(KERN_INFO "invalid mtrr_gran_size or mtrr_chunk_size, "
 		       "will find optimal one\n");
+		debug_print = 0;
 		memset(result, 0, sizeof(result[0]));
 	}
 
@@ -1265,9 +1280,10 @@ static int __init mtrr_cleanup(unsigned 
 		     chunk_size <<= 1) {
 			int num_reg;
 
-			printk(KERN_INFO
+			if (debug_print)
+				printk(KERN_INFO
 			       "\ngran_size: %lldM   chunk_size_size: %lldM\n",
-			       gran_size >> 20, chunk_size >> 20);
+				       gran_size >> 20, chunk_size >> 20);
 			if (i >= NUM_RESULT)
 				continue;
 
@@ -1310,10 +1326,10 @@ static int __init mtrr_cleanup(unsigned 
 
 	/* print out all */
 	for (i = 0; i < NUM_RESULT; i++) {
-		printk(KERN_INFO "%sgran_size: %ldM  \tchunk_size: %ldM  \t",
+		printk(KERN_INFO "%sgran_size: %ldM \tchunk_size: %ldM \t",
 		       result[i].bad?"*BAD* ":" ", result[i].gran_sizek >> 10,
 		       result[i].chunk_sizek >> 10);
-		printk(KERN_CONT "num_reg: %d  \tlose cover RAM: %s%ldM \n",
+		printk(KERN_CONT "num_reg: %d \tlose RAM: %s%ldM\n",
 		       result[i].num_reg, result[i].bad?"-":"",
 		       result[i].lose_cover_sizek >> 10);
 	}
@@ -1322,7 +1338,7 @@ static int __init mtrr_cleanup(unsigned 
 	if (nr_mtrr_spare_reg >= num_var_ranges)
 		nr_mtrr_spare_reg = num_var_ranges - 1;
 	num_reg_good = -1;
-	for (i = 1; i < num_var_ranges + 1 - nr_mtrr_spare_reg; i++) {
+	for (i = num_var_ranges - nr_mtrr_spare_reg; i > 0; i--) {
 		if (!min_loss_pfn[i]) {
 			num_reg_good = i;
 			break;
@@ -1344,10 +1360,10 @@ static int __init mtrr_cleanup(unsigned 
 	if (index_good != -1) {
 		printk(KERN_INFO "Found optimal setting for mtrr clean up\n");
 		i = index_good;
-		printk(KERN_INFO "gran_size: %ldM  \tchunk_size: %ldM  \t",
+		printk(KERN_INFO "gran_size: %ldM \tchunk_size: %ldM \t",
 				result[i].gran_sizek >> 10,
 				result[i].chunk_sizek >> 10);
-		printk(KERN_CONT "num_reg: %d  \tlose cover RAM: %ldM \n",
+		printk(KERN_CONT "num_reg: %d \tlose RAM: %ldM\n",
 				result[i].num_reg,
 				result[i].lose_cover_sizek >> 10);
 		/* convert ranges to var ranges state */
@@ -1355,6 +1371,7 @@ static int __init mtrr_cleanup(unsigned 
 		chunk_size <<= 10;
 		gran_size = result[i].gran_sizek;
 		gran_size <<= 10;
+		debug_print = 1;
 		x86_setup_var_mtrrs(range, nr_range, chunk_size, gran_size);
 		set_var_mtrr_all(address_bits);
 		return 1;
