Return-Path: <linux-kernel-owner+w=401wt.eu-S932773AbXH2Ppw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932773AbXH2Ppw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 11:45:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752060AbXH2Ppa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 11:45:30 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:37414 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755398AbXH2Pp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 11:45:28 -0400
Subject: [PATCH] avoid negative (and full-width) shifts in radix-tree.c,
	take 3
From: Peter Lund <firefly@vax64.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Christoph Lameter <clameter@sgi.com>, trivial@kernel.org,
       linux-kernel@vger.kernel.org, Momchil Velikov <velco@fadata.bg>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Content-Type: text/plain
Date: Wed, 29 Aug 2007 17:44:51 +0200
Message-Id: <1188402291.7216.90.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Lund <firefly@vax64.dk>

Negative shifts are not allowed in C (the result is undefined).
Same thing with full-width shifts.

It works on most platforms but not on the VAX with gcc 4.0.1 (it results in an
"operand reserved" fault).

Applies to Linux 2.6.22.

Signed-off-by: Peter Lund <firefly@vax64.dk>
---
Shifting by more than the width of the value on the left is also not allowed.
I think the extra '>> 1' tacked on at the end in the original code was an attempt
to work around that.  Getting rid of that is an extra feature of this patch.

Here's the chapter and verse, taken from the final draft of the C99 standard
("6.5.7 Bitwise shift operators", paragraph 3):

  "The integer promotions are performed on each of the operands. The
  type of the result is that of the promoted left operand. If the
  value of the right operand is negative or is greater than or equal
  to the width of the promoted left operand, the behavior is
  undefined."

Thank you to Jan-Benedict Glaw, Christoph Hellwig, Maciej Rozycki,
Pekka Enberg, and Andreas Schwab for review.  Special thanks to Andreas for
spotting something I knew but overlooked due to misfiring neurons.

I have kept the spacing between the variables and their types so the variable
names and the equal signs don't line up, which should keep the majority of my
reviewers happy.

--- linux-2.6.22/lib/radix-tree.c.orig	2007-07-09 01:32:17.000000000 +0200
+++ linux-2.6.22/lib/radix-tree.c	2007-08-29 17:32:00.000000000 +0200
@@ -980,12 +980,14 @@
 
 static __init unsigned long __maxindex(unsigned int height)
 {
-	unsigned int tmp = height * RADIX_TREE_MAP_SHIFT;
-	unsigned long index = (~0UL >> (RADIX_TREE_INDEX_BITS - tmp - 1)) >> 1;
+	unsigned int width = height * RADIX_TREE_MAP_SHIFT;
+	int shift = RADIX_TREE_INDEX_BITS - width;
 
-	if (tmp >= RADIX_TREE_INDEX_BITS)
-		index = ~0UL;
-	return index;
+	if (shift < 0)
+		return ~0UL;
+	if (shift >= 8 * sizeof(unsigned long))
+		return 0UL;
+	return ~0UL >> shift;
 }
 
 static __init void radix_tree_init_maxindex(void)


