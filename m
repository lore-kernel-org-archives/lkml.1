Return-Path: <linux-kernel-owner+w=401wt.eu-S932576AbXH2Lje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932576AbXH2Lje (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 07:39:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755475AbXH2Lj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 07:39:26 -0400
Received: from cerber.ds.pg.gda.pl ([153.19.208.18]:33816 "EHLO
	cerber.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755126AbXH2LjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 07:39:25 -0400
Date: Wed, 29 Aug 2007 12:39:16 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Christoph Hellwig <hch@infradead.org>
cc: Peter Firefly Lund <firefly@vax64.dk>,
       Christoph Lameter <clameter@sgi.com>, Momchil Velikov <velco@fadata.bg>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] avoid negative shifts in radix-tree.c
In-Reply-To: <20070827132843.GB21970@infradead.org>
Message-ID: <Pine.LNX.4.64N.0708291232130.26167@blysk.ds.pg.gda.pl>
References: <1188051967.18306.45.camel@ls-search> <20070827132843.GB21970@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Aug 2007, Christoph Hellwig wrote:

> The conceptual change looks fine to me, but the code looks a little odd,
> what about:
> 
> static __init unsigned long __maxindex(unsigned int height)
> {
> 	unsigned int tmp = height * RADIX_TREE_MAP_SHIFT;
> 	int shift = RADIX_TREE_INDEX_BITS - tmp;
> 
> 	if (shift < 0)
> 		return ~0UL;
> 	return ~0UL >> shift;
> }
> 
> instead?

 This patch has been successfully tested on actual hardware (VAXstation 
4000/90).  If nobody objects, I'll push it to Andrew.

  Maciej

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>

patch-vax-2.6.17-rc4-20070111-radix-maxindex-0
diff -up --recursive --new-file linux-vax-2.6.17-rc4-20070111.macro/lib/radix-tree.c linux-vax-2.6.17-rc4-20070111/lib/radix-tree.c
--- linux-vax-2.6.17-rc4-20070111.macro/lib/radix-tree.c	2006-10-31 19:05:50.000000000 +0000
+++ linux-vax-2.6.17-rc4-20070111/lib/radix-tree.c	2007-01-22 01:24:17.000000000 +0000
@@ -825,9 +825,11 @@ radix_tree_node_ctor(void *node, kmem_ca
 static __init unsigned long __maxindex(unsigned int height)
 {
 	unsigned int tmp = height * RADIX_TREE_MAP_SHIFT;
-	unsigned long index = (~0UL >> (RADIX_TREE_INDEX_BITS - tmp - 1)) >> 1;
+	unsigned long index;
 
-	if (tmp >= RADIX_TREE_INDEX_BITS)
+	if (tmp < RADIX_TREE_INDEX_BITS)
+		index = (~0UL >> (RADIX_TREE_INDEX_BITS - tmp - 1)) >> 1;
+	else
 		index = ~0UL;
 	return index;
 }
