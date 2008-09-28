Return-Path: <linux-kernel-owner+w=401wt.eu-S1753380AbYI1D04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380AbYI1D04 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 23:26:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752555AbYI1D0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 23:26:47 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:27300 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546AbYI1D0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 23:26:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=cgPhWVov2RFYdCbgQq+NHxFthjPzsET85jgAzljJx/+4jdv9gVOeNcoME/+MF/f9JP
         VHJykZUGZ//jZeY8hY4NNcF5vXBd4sc3kd52hIvAT5jTFBZlHcUEsKEgY3+b8o5nCymv
         QBB5XZ2InCCQZJ5hxFFTngHXxIxYwOrUr2dtw=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH] x86: mtrr_cleanup hole size should be less than half of chunk_size v2
Date: Sat, 27 Sep 2008 20:26:06 -0700
Message-Id: <1222572366-24424-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2: should check with half of range0 size instead of chunk_size

So don't have silly big hole.

in hpa's case we could auto detect instead of adding mtrr_chunk_size in command line

Ingo, please consider to squash this one to previous one
|  commit 2313c2793d290a8cc37c428f8622c53f3fe1d6dc
|  Author: Yinghai Lu <yhlu.kernel@gmail.com>
|  Date:   Sat Sep 27 00:30:08 2008 -0700
|
|      x86: mtrr_cleanup optimization, v2

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/cpu/mtrr/main.c |   74 +++++++++++++++++++++++-----------------
 1 file changed, 43 insertions(+), 31 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mtrr/main.c
+++ linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
@@ -992,22 +992,17 @@ range_to_mtrr_with_hole(struct var_mtrr_
 	/* only cut back, when it is not the last */
 	if (sizek) {
 		while (range0_basek + range0_sizek > (basek + sizek)) {
-			range0_sizek -= chunk_sizek;
+			if (range0_sizek >= chunk_sizek)
+				range0_sizek -= chunk_sizek;
+			else
+				range0_sizek = 0;
+
 			if (!range0_sizek)
 				break;
 		}
 	}
 
-	if (range0_sizek) {
-		if (debug_print)
-			printk(KERN_DEBUG "range0: %016lx - %016lx\n",
-				range0_basek<<10,
-				(range0_basek + range0_sizek)<<10);
-		state->reg = range_to_mtrr(state->reg, range0_basek,
-				range0_sizek, MTRR_TYPE_WRBACK);
-
-	}
-
+second_try:
 	range_basek = range0_basek + range0_sizek;
 
 	/* one hole in the middle */
@@ -1015,33 +1010,50 @@ range_to_mtrr_with_hole(struct var_mtrr_
 		second_sizek = range_basek - basek;
 
 	if (range0_sizek > state->range_sizek) {
-		unsigned long hole_basek, hole_sizek;
 
 		/* one hole in middle or at end */
 		hole_sizek = range0_sizek - state->range_sizek - second_sizek;
-		if (hole_sizek) {
-			hole_basek = range_basek - hole_sizek - second_sizek;
-			if (debug_print)
-				printk(KERN_DEBUG "hole: %016lx - %016lx\n",
-					 hole_basek<<10,
-					 (hole_basek + hole_sizek)<<10);
-			state->reg = range_to_mtrr(state->reg, hole_basek,
-						   hole_sizek,
-						   MTRR_TYPE_UNCACHABLE);
+
+		/* hole size should be less than half of range0 size */
+		if (hole_sizek > (range0_sizek >> 1) &&
+		    range0_sizek >= chunk_sizek) {
+			range0_sizek -= chunk_sizek;
+			second_sizek = 0;
+			hole_sizek = 0;
+
+			goto second_try;
 		}
-	} else  {
+	}
+
+	if (range0_sizek) {
+		if (debug_print)
+			printk(KERN_DEBUG "range0: %016lx - %016lx\n",
+				range0_basek<<10,
+				(range0_basek + range0_sizek)<<10);
+		state->reg = range_to_mtrr(state->reg, range0_basek,
+				range0_sizek, MTRR_TYPE_WRBACK);
+	}
+
+	if (range0_sizek < state->range_sizek) {
 		/* need to handle left over */
 		range_sizek = state->range_sizek - range0_sizek;
 
-		if (range_sizek) {
-			if (debug_print)
-				printk(KERN_DEBUG "range: %016lx - %016lx\n",
-					 range_basek<<10,
-					 (range_basek + range_sizek)<<10);
-			state->reg = range_to_mtrr(state->reg, range_basek,
-					 range_sizek,
-					 MTRR_TYPE_WRBACK);
-		}
+		if (debug_print)
+			printk(KERN_DEBUG "range: %016lx - %016lx\n",
+				 range_basek<<10,
+				 (range_basek + range_sizek)<<10);
+		state->reg = range_to_mtrr(state->reg, range_basek,
+				 range_sizek, MTRR_TYPE_WRBACK);
+	}
+
+	if (hole_sizek) {
+		hole_basek = range_basek - hole_sizek - second_sizek;
+		if (debug_print)
+			printk(KERN_DEBUG "hole: %016lx - %016lx\n",
+				 hole_basek<<10,
+				 (hole_basek + hole_sizek)<<10);
+		state->reg = range_to_mtrr(state->reg, hole_basek,
+				 hole_sizek, MTRR_TYPE_UNCACHABLE);
 	}
 
 	return second_sizek;
