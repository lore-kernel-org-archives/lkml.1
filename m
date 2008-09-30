Return-Path: <linux-kernel-owner+w=401wt.eu-S1753573AbYI3BzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573AbYI3BzF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 21:55:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752438AbYI3Byy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 21:54:54 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:11124 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbYI3Byx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 21:54:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Gmv/mO1vjSF1qBf3Pz1fCfRn9VPXsxchLw+KOJMMLNuJPffafE6/i/0d/kOcZ4Xga1
         3zsznk0EQQYnaxR4sXIW9/g7OFksN0TdW4styZKB+1YjETZCRvqyRHw4Pf1kX9p0jL5a
         YUtDWgq0c990VPsbyC0ZxGL/+FF4OjD4O2bK0=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 1/2] x86: mtrr_cleanup prepare to make gran_size to less 1M
Date: Mon, 29 Sep 2008 18:54:11 -0700
Message-Id: <1222739652-17169-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

make the print out right with size < 1M

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/cpu/mtrr/main.c |  109 ++++++++++++++++++++++++++++++----------
 1 file changed, 82 insertions(+), 27 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mtrr/main.c
+++ linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
@@ -905,6 +905,27 @@ set_var_mtrr_all(unsigned int address_bi
 	}
 }
 
+static unsigned long to_size_factor(unsigned long sizek, char *factorp)
+{
+	char factor;
+	unsigned long base = sizek;
+
+	if (base & ((1<<10) - 1)) {
+		/* not MB alignment */
+		factor = 'K';
+	} else if (base & ((1<<20) - 1)){
+		factor = 'M';
+		base >>= 10;
+	} else {
+		factor = 'G';
+		base >>= 20;
+	}
+
+	*factorp = factor;
+
+	return base;
+}
+
 static unsigned int __init
 range_to_mtrr(unsigned int reg, unsigned long range_startk,
 	      unsigned long range_sizek, unsigned char type)
@@ -926,13 +947,21 @@ range_to_mtrr(unsigned int reg, unsigned
 			align = max_align;
 
 		sizek = 1 << align;
-		if (debug_print)
+		if (debug_print) {
+			char start_factor = 'K', size_factor = 'K';
+			unsigned long start_base, size_base;
+
+			start_base = to_size_factor(range_startk, &start_factor),
+			size_base = to_size_factor(sizek, &size_factor),
+
 			printk(KERN_DEBUG "Setting variable MTRR %d, "
-				"base: %ldMB, range: %ldMB, type %s\n",
-				reg, range_startk >> 10, sizek >> 10,
+				"base: %ld%cB, range: %ld%cB, type %s\n",
+				reg, start_base, start_factor,
+				size_base, size_factor,
 				(type == MTRR_TYPE_UNCACHABLE)?"UC":
 				    ((type == MTRR_TYPE_WRBACK)?"WB":"Other")
 				);
+		}
 		save_var_mtrr(reg++, range_startk, sizek, type);
 		range_startk += sizek;
 		range_sizek -= sizek;
@@ -1244,6 +1273,8 @@ static int __init mtrr_cleanup(unsigned
 
 	if (mtrr_chunk_size && mtrr_gran_size) {
 		int num_reg;
+		char gran_factor, chunk_factor, lose_factor;
+		unsigned long gran_base, chunk_base, lose_base;
 
 		debug_print++;
 		/* convert ranges to var ranges state */
@@ -1269,12 +1300,15 @@ static int __init mtrr_cleanup(unsigned
 			result[i].lose_cover_sizek =
 				(range_sums - range_sums_new) << PSHIFT;
 
-		printk(KERN_INFO "%sgran_size: %ldM \tchunk_size: %ldM \t",
-			 result[i].bad?"*BAD*":" ", result[i].gran_sizek >> 10,
-			 result[i].chunk_sizek >> 10);
-		printk(KERN_CONT "num_reg: %d  \tlose cover RAM: %s%ldM \n",
+		gran_base = to_size_factor(result[i].gran_sizek, &gran_factor),
+		chunk_base = to_size_factor(result[i].chunk_sizek, &chunk_factor),
+		lose_base = to_size_factor(result[i].lose_cover_sizek, &lose_factor),
+		printk(KERN_INFO "%sgran_size: %ld%c \tchunk_size: %ld%c \t",
+			 result[i].bad?"*BAD*":" ",
+			 gran_base, gran_factor, chunk_base, chunk_factor);
+		printk(KERN_CONT "num_reg: %d  \tlose cover RAM: %s%ld%c\n",
 			 result[i].num_reg, result[i].bad?"-":"",
-			 result[i].lose_cover_sizek >> 10);
+			 lose_base, lose_factor);
 		if (!result[i].bad) {
 			set_var_mtrr_all(address_bits);
 			return 1;
@@ -1289,14 +1323,25 @@ static int __init mtrr_cleanup(unsigned
 	memset(min_loss_pfn, 0xff, sizeof(min_loss_pfn));
 	memset(result, 0, sizeof(result));
 	for (gran_size = (1ULL<<20); gran_size < (1ULL<<32); gran_size <<= 1) {
+		char gran_factor;
+		unsigned long gran_base;
+
+		if (debug_print)
+			gran_base = to_size_factor(gran_size >> 10, &gran_factor);
+
 		for (chunk_size = gran_size; chunk_size < (1ULL<<32);
 		     chunk_size <<= 1) {
 			int num_reg;
 
-			if (debug_print)
-				printk(KERN_INFO
-			       "\ngran_size: %lldM   chunk_size_size: %lldM\n",
-				       gran_size >> 20, chunk_size >> 20);
+			if (debug_print) {
+				char chunk_factor;
+				unsigned long chunk_base;
+
+				chunk_base = to_size_factor(chunk_size>>10, &chunk_factor),
+				printk(KERN_INFO "\n");
+				printk(KERN_INFO "gran_size: %ld%c   chunk_size: %ld%c \n",
+				       gran_base, gran_factor, chunk_base, chunk_factor);
+			}
 			if (i >= NUM_RESULT)
 				continue;
 
@@ -1339,12 +1384,18 @@ static int __init mtrr_cleanup(unsigned
 
 	/* print out all */
 	for (i = 0; i < NUM_RESULT; i++) {
-		printk(KERN_INFO "%sgran_size: %ldM \tchunk_size: %ldM \t",
-		       result[i].bad?"*BAD* ":" ", result[i].gran_sizek >> 10,
-		       result[i].chunk_sizek >> 10);
-		printk(KERN_CONT "num_reg: %d \tlose RAM: %s%ldM\n",
-		       result[i].num_reg, result[i].bad?"-":"",
-		       result[i].lose_cover_sizek >> 10);
+		char gran_factor, chunk_factor, lose_factor;
+		unsigned long gran_base, chunk_base, lose_base;
+
+		gran_base = to_size_factor(result[i].gran_sizek, &gran_factor),
+		chunk_base = to_size_factor(result[i].chunk_sizek, &chunk_factor),
+		lose_base = to_size_factor(result[i].lose_cover_sizek, &lose_factor),
+		printk(KERN_INFO "%sgran_size: %ld%c \tchunk_size: %ld%c \t",
+			 result[i].bad?"*BAD*":" ",
+			 gran_base, gran_factor, chunk_base, chunk_factor);
+		printk(KERN_CONT "num_reg: %d  \tlose cover RAM: %s%ld%c\n",
+			 result[i].num_reg, result[i].bad?"-":"",
+			 lose_base, lose_factor);
 	}
 
 	/* try to find the optimal index */
@@ -1369,14 +1420,18 @@ static int __init mtrr_cleanup(unsigned
 	}
 
 	if (index_good != -1) {
+		char gran_factor, chunk_factor, lose_factor;
+		unsigned long gran_base, chunk_base, lose_base;
+
 		printk(KERN_INFO "Found optimal setting for mtrr clean up\n");
 		i = index_good;
-		printk(KERN_INFO "gran_size: %ldM \tchunk_size: %ldM \t",
-				result[i].gran_sizek >> 10,
-				result[i].chunk_sizek >> 10);
-		printk(KERN_CONT "num_reg: %d \tlose RAM: %ldM\n",
-				result[i].num_reg,
-				result[i].lose_cover_sizek >> 10);
+		gran_base = to_size_factor(result[i].gran_sizek, &gran_factor),
+		chunk_base = to_size_factor(result[i].chunk_sizek, &chunk_factor),
+		lose_base = to_size_factor(result[i].lose_cover_sizek, &lose_factor),
+		printk(KERN_INFO "gran_size: %ld%c \tchunk_size: %ld%c \t",
+			 gran_base, gran_factor, chunk_base, chunk_factor);
+		printk(KERN_CONT "num_reg: %d  \tlose RAM: %ld%c\n",
+			 result[i].num_reg, lose_base, lose_factor);
 		/* convert ranges to var ranges state */
 		chunk_size = result[i].chunk_sizek;
 		chunk_size <<= 10;
