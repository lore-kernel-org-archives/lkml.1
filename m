Return-Path: <linux-kernel-owner+w=401wt.eu-S1753489AbYI0Hb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489AbYI0Hb2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 03:31:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752284AbYI0Hat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 03:30:49 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:60541 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162AbYI0Has (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 03:30:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=tg3c4znJ8YmvFaY3MyXbPiMqbnO6TrVWgRGMOLWk1va9MgiXXPNdnKmOKDU5j03iCX
         r70OpEzgUlDaR+/+zXH/RLw4VJ8yAb0OsfufL153nN4DW1aVY5rfE5A1FRrLzdwn6qxI
         UPu/QpzYphYw/aD49YbVoVctYdFAWdFbrA86s=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 3/3] x86: mtrr_cleanup optimization v2
Date: Sat, 27 Sep 2008 00:30:08 -0700
Message-Id: <1222500608-14855-3-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1222500608-14855-1-git-send-email-yhlu.kernel@gmail.com>
References: <1222500608-14855-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix hpa's t61 with 4g ram
   change layout from
	(n - 1)*chunksize + chunk_size - NC
   to
	n*chunksize - NC

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/cpu/mtrr/main.c |   81 ++++++++++++++++++----------------------
 1 file changed, 38 insertions(+), 43 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mtrr/main.c
+++ linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
@@ -977,6 +977,8 @@ range_to_mtrr_with_hole(struct var_mtrr_
 	/* try to append some small hole */
 	range0_basek = state->range_startk;
 	range0_sizek = ALIGN(state->range_sizek, chunk_sizek);
+
+	/* no increase */
 	if (range0_sizek == state->range_sizek) {
 		if (debug_print)
 			printk(KERN_DEBUG "rangeX: %016lx - %016lx\n",
@@ -987,13 +989,13 @@ range_to_mtrr_with_hole(struct var_mtrr_
 		return 0;
 	}
 
-	range0_sizek -= chunk_sizek;
-	if (range0_sizek && sizek) {
-	    while (range0_basek + range0_sizek > (basek + sizek)) {
-		range0_sizek -= chunk_sizek;
-		if (!range0_sizek)
-			break;
-	    }
+	/* only cut back, when it is not the last */
+	if (sizek) {
+		while (range0_basek + range0_sizek > (basek + sizek)) {
+			range0_sizek -= chunk_sizek;
+			if (!range0_sizek)
+				break;
+		}
 	}
 
 	if (range0_sizek) {
@@ -1007,46 +1009,39 @@ range_to_mtrr_with_hole(struct var_mtrr_
 	}
 
 	range_basek = range0_basek + range0_sizek;
-	range_sizek = chunk_sizek;
-
-	if (range_basek + range_sizek > basek &&
-	    range_basek + range_sizek <= (basek + sizek)) {
-		/* one hole */
-		second_basek = basek;
-		second_sizek = range_basek + range_sizek - basek;
-	}
 
-	/* if last piece, only could one hole near end */
-	if ((second_basek || !basek) &&
-	    range_sizek - (state->range_sizek - range0_sizek) - second_sizek <
-	    (chunk_sizek >> 1)) {
-		/*
-		 * one hole in middle (second_sizek is 0) or at end
-		 * (second_sizek is 0 )
-		 */
-		hole_sizek = range_sizek - (state->range_sizek - range0_sizek)
-				 - second_sizek;
-		hole_basek = range_basek + range_sizek - hole_sizek
-				 - second_sizek;
-	} else {
-		/* fallback for big hole, or several holes */
+	/* one hole in the middle */
+	if (range_basek > basek && range_basek <= (basek + sizek))
+		second_sizek = range_basek - basek;
+
+	if (range0_sizek > state->range_sizek) {
+		unsigned long hole_basek, hole_sizek;
+
+		/* one hole in middle or at end */
+		hole_sizek = range0_sizek - state->range_sizek - second_sizek;
+		if (hole_sizek) {
+			hole_basek = range_basek - hole_sizek - second_sizek;
+			if (debug_print)
+				printk(KERN_DEBUG "hole: %016lx - %016lx\n",
+					 hole_basek<<10,
+					 (hole_basek + hole_sizek)<<10);
+			state->reg = range_to_mtrr(state->reg, hole_basek,
+						   hole_sizek,
+						   MTRR_TYPE_UNCACHABLE);
+		}
+	} else  {
+		/* need to handle left over */
 		range_sizek = state->range_sizek - range0_sizek;
-		second_basek = 0;
-		second_sizek = 0;
-	}
 
-	if (debug_print)
-		printk(KERN_DEBUG "range: %016lx - %016lx\n", range_basek<<10,
-			 (range_basek + range_sizek)<<10);
-	state->reg = range_to_mtrr(state->reg, range_basek, range_sizek,
+		if (range_sizek) {
+			if (debug_print)
+				printk(KERN_DEBUG "range: %016lx - %016lx\n",
+					 range_basek<<10,
+					 (range_basek + range_sizek)<<10);
+			state->reg = range_to_mtrr(state->reg, range_basek,
+					 range_sizek,
 					 MTRR_TYPE_WRBACK);
-	if (hole_sizek) {
-		if (debug_print)
-			printk(KERN_DEBUG "hole: %016lx - %016lx\n",
-				 hole_basek<<10, (hole_basek + hole_sizek)<<10);
-		state->reg = range_to_mtrr(state->reg, hole_basek, hole_sizek,
-						 MTRR_TYPE_UNCACHABLE);
-
+		}
 	}
 
 	return second_sizek;
