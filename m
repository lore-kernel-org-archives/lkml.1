Return-Path: <linux-kernel-owner+w=401wt.eu-S933844AbXHYOsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933844AbXHYOsW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 10:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759964AbXHYOsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 10:48:13 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:40456 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759558AbXHYOsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 10:48:12 -0400
X-Greylist: delayed 1319 seconds by postgrey-1.27 at vger.kernel.org; Sat, 25 Aug 2007 10:48:12 EDT
Subject: [PATCH] avoid negative shifts in radix-tree.c
From: Peter Firefly Lund <firefly@vax64.dk>
To: Christoph Lameter <clameter@sgi.com>
Cc: Momchil Velikov <velco@fadata.bg>, Christoph Hellwig <hch@infradead.org>,
       linux-kernel@vger.kernel.org, trivial@kernel.org
Content-Type: text/plain
Date: Sat, 25 Aug 2007 16:26:07 +0200
Message-Id: <1188051967.18306.45.camel@ls-search>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(linux-vax@pergamentum.com only bcc'ed because it's subscribers only,
Lameter addressed because I think he touched the code last, Velikov and
Hellwig because they touched the code first.)

The current code in __max_index() will shift by a negative amount first
and only then fix the situation by ignoring the result if the shift
amount would have been negative.  This happens to work on almost any
architecture despite not being valid C.

Chapter and verse from the (draft) ISO C99 standard, "6.5.7 Bitwise
shift operators", paragraph 3:

  "The integer promotions are performed on each of the operands. The
   type of the result is that of the promoted left operand. If the
   value of the right operand is negative or is greater than or equal
   to the width of the promoted left operand, the behavior is
   undefined."

Right-shifting by a negative amount causes a "reserved operand fault" on
the VAX with some gcc versions.


Applies to 2.6.22.
Boot tested lightly on an emulated VAX.

(The function is called 7 times on booth with the values 0..6 -- I
checked that the return values were the same + that it returns ~0UL for
height==6 as was clearly the intention.)

-Peter

--- lib/radix-tree-old.c	2007-08-25 15:36:40.000000000 +0200
+++ lib/radix-tree.c	2007-08-25 15:36:51.000000000 +0200
@@ -980,12 +980,14 @@ radix_tree_node_ctor(void *node, struct 
 
 static __init unsigned long __maxindex(unsigned int height)
 {
-	unsigned int tmp = height * RADIX_TREE_MAP_SHIFT;
-	unsigned long index = (~0UL >> (RADIX_TREE_INDEX_BITS - tmp - 1)) >> 1;
-
-	if (tmp >= RADIX_TREE_INDEX_BITS)
-		index = ~0UL;
-	return index;
+	unsigned int	tmp   = height * RADIX_TREE_MAP_SHIFT;
+	int		shift = RADIX_TREE_INDEX_BITS - tmp;
+	unsigned long	index;
+
+	if (shift < 0)
+		return ~0UL;
+	else
+		return ~0UL >> shift;
 }
 
 static __init void radix_tree_init_maxindex(void)


