Return-Path: <linux-kernel-owner+w=401wt.eu-S1754333AbXH2SNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333AbXH2SNX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 14:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758296AbXH2SNB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 14:13:01 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:54561 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759169AbXH2SNA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 14:13:00 -0400
Subject: [PATCH] avoid negative (and full-width) shifts in radix-tree.c,
	take 4
From: Peter Lund <firefly@vax64.dk>
To: Christoph Lameter <clameter@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, trivial@kernel.org,
       linux-kernel@vger.kernel.org, Momchil Velikov <velco@fadata.bg>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Content-Type: text/plain
Date: Wed, 29 Aug 2007 20:12:56 +0200
Message-Id: <1188411176.7216.137.camel@localhost.localdomain>
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
Take 4 uses BITS_PER_LONG instead of 8 * sizeof(unsigned long)
Take 3 checks for shifts >= the width of the left value (after promotion)
Take 2 removes index, a variable I'd forgotten to remove
Take 1 avoided negative shifts, which cause a problem on the VAX

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
Pekka Enberg, Andreas Schwab, and Christoph Lameter for review.  Special
thanks to Andreas for spotting that my fix only removed half the undefined
behaviour.

--- linux-2.6.22/lib/radix-tree.c.orig	2007-08-29 20:00:16.000000000 +0200
+++ linux-2.6.22/lib/radix-tree.c	2007-08-29 20:05:01.000000000 +0200
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
+	if (shift >= BITS_PER_LONG)
+		return 0UL;
+	return ~0UL >> shift;
 }
 
 static __init void radix_tree_init_maxindex(void)


