Return-Path: <linux-kernel-owner+w=401wt.eu-S1752999AbYI0C4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999AbYI0C4U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 22:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751611AbYI0C4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 22:56:11 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:40483 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbYI0C4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 22:56:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=NGoBOcTtmfpuyZ2fi7j1mtifrQ5eYFAsjxdSGBiFBnkdkso1EOWGt3aDucELDQ7Pbp
         KTzNeVQJGUz6khmCJZzN7Ec2yWF0kBFOSvcWLJqSuJmEjFbbxq1XUTD46BqFw7z4qTXS
         T2AKJLrRuFSlyPA3qxnrQd+Q9MR83mvUzonmQ=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH] x86: mtrr_cleanup optimization
Date: Fri, 26 Sep 2008 19:55:35 -0700
Message-Id: <1222484135-15694-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix hpa's t61 with 4g ram
1. add mtrr_cleanup_debug to print out more info about layout
2. change layout from
	(n - 1)*chunksize + chunk_size - NC
   to
	n*chunksize - NC
3. change back chunksize to 2g
   otherwise will get strange layout in 2G ram system like
     0 - 4g WB, 2040M - 2048M UC, 2048M -  4G NC
   instead of
     0 - 2g WB, 2040M - 2048M UC

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/cpu/mtrr/main.c |   72 +++++++++++++++++++++-------------------
 1 file changed, 39 insertions(+), 33 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mtrr/main.c
+++ linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
@@ -836,6 +836,13 @@ static int __init enable_mtrr_cleanup_se
 }
 early_param("enble_mtrr_cleanup", enable_mtrr_cleanup_setup);
 
+static int __init mtrr_cleanup_debug_setup(char *str)
+{
+	debug_print = 1;
+	return 0;
+}
+early_param("mtrr_cleanup_debug", mtrr_cleanup_debug_setup);
+
 struct var_mtrr_state {
 	unsigned long	range_startk;
 	unsigned long	range_sizek;
@@ -980,13 +987,12 @@ range_to_mtrr_with_hole(struct var_mtrr_
 		return 0;
 	}
 
-	range0_sizek -= chunk_sizek;
-	if (range0_sizek && sizek) {
-	    while (range0_basek + range0_sizek > (basek + sizek)) {
-		range0_sizek -= chunk_sizek;
-		if (!range0_sizek)
-			break;
-	    }
+	if (sizek) {
+		while (range0_basek + range0_sizek > (basek + sizek)) {
+			range0_sizek -= chunk_sizek;
+			if (!range0_sizek)
+				break;
+		}
 	}
 
 	if (range0_sizek) {
@@ -1000,39 +1006,38 @@ range_to_mtrr_with_hole(struct var_mtrr_
 	}
 
 	range_basek = range0_basek + range0_sizek;
-	range_sizek = chunk_sizek;
+	range_sizek = 0;
 
-	if (range_basek + range_sizek > basek &&
-	    range_basek + range_sizek <= (basek + sizek)) {
+	if (range_basek > basek &&
+	    range_basek <= (basek + sizek)) {
 		/* one hole */
 		second_basek = basek;
-		second_sizek = range_basek + range_sizek - basek;
+		second_sizek = range_basek - basek;
 	}
 
 	/* if last piece, only could one hole near end */
-	if ((second_basek || !basek) &&
-	    range_sizek - (state->range_sizek - range0_sizek) - second_sizek <
-	    (chunk_sizek >> 1)) {
+	if (range0_sizek > state->range_sizek) {
 		/*
 		 * one hole in middle (second_sizek is 0) or at end
 		 * (second_sizek is 0 )
 		 */
-		hole_sizek = range_sizek - (state->range_sizek - range0_sizek)
-				 - second_sizek;
-		hole_basek = range_basek + range_sizek - hole_sizek
+		hole_sizek = range0_sizek - state->range_sizek - second_sizek;
+		hole_basek = range_basek - hole_sizek
 				 - second_sizek;
-	} else {
-		/* fallback for big hole, or several holes */
+	} else  {
+		/* need to handle left over */
 		range_sizek = state->range_sizek - range0_sizek;
-		second_basek = 0;
-		second_sizek = 0;
 	}
 
-	if (debug_print)
-		printk(KERN_DEBUG "range: %016lx - %016lx\n", range_basek<<10,
-			 (range_basek + range_sizek)<<10);
-	state->reg = range_to_mtrr(state->reg, range_basek, range_sizek,
-					 MTRR_TYPE_WRBACK);
+	if (range_sizek) {
+		if (debug_print)
+			printk(KERN_DEBUG "range: %016lx - %016lx\n",
+				 range_basek<<10,
+				 (range_basek + range_sizek)<<10);
+		state->reg = range_to_mtrr(state->reg, range_basek, range_sizek,
+						 MTRR_TYPE_WRBACK);
+	}
+
 	if (hole_sizek) {
 		if (debug_print)
 			printk(KERN_DEBUG "hole: %016lx - %016lx\n",
@@ -1155,10 +1160,10 @@ struct mtrr_cleanup_result {
 
 /*
  * gran_size: 1M, 2M, ..., 2G
- * chunk size: gran_size, ..., 4G
- * so we need (2+13)*6
+ * chunk size: gran_size, ..., 2G
+ * so we need (1+12)*6
  */
-#define NUM_RESULT	90
+#define NUM_RESULT	78
 #define PSHIFT		(PAGE_SHIFT - 10)
 
 static struct mtrr_cleanup_result __initdata result[NUM_RESULT];
@@ -1231,7 +1236,7 @@ static int __init mtrr_cleanup(unsigned
 	if (mtrr_chunk_size && mtrr_gran_size) {
 		int num_reg;
 
-		debug_print = 1;
+		debug_print++;
 		/* convert ranges to var ranges state */
 		num_reg = x86_setup_var_mtrrs(range, nr_range, mtrr_chunk_size,
 					      mtrr_gran_size);
@@ -1267,7 +1272,7 @@ static int __init mtrr_cleanup(unsigned
 		}
 		printk(KERN_INFO "invalid mtrr_gran_size or mtrr_chunk_size, "
 		       "will find optimal one\n");
-		debug_print = 0;
+		debug_print--;
 		memset(result, 0, sizeof(result[0]));
 	}
 
@@ -1275,7 +1280,7 @@ static int __init mtrr_cleanup(unsigned
 	memset(min_loss_pfn, 0xff, sizeof(min_loss_pfn));
 	memset(result, 0, sizeof(result));
 	for (gran_size = (1ULL<<20); gran_size < (1ULL<<32); gran_size <<= 1) {
-		for (chunk_size = gran_size; chunk_size < (1ULL<<33);
+		for (chunk_size = gran_size; chunk_size < (1ULL<<32);
 		     chunk_size <<= 1) {
 			int num_reg;
 
@@ -1370,8 +1375,9 @@ static int __init mtrr_cleanup(unsigned
 		chunk_size <<= 10;
 		gran_size = result[i].gran_sizek;
 		gran_size <<= 10;
-		debug_print = 1;
+		debug_print++;
 		x86_setup_var_mtrrs(range, nr_range, chunk_size, gran_size);
+		debug_print--;
 		set_var_mtrr_all(address_bits);
 		return 1;
 	}
