Return-Path: <linux-kernel-owner+w=401wt.eu-S1763141AbXJMOwG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763141AbXJMOwG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 10:52:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762032AbXJMOmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 10:42:47 -0400
Received: from 1wt.eu ([62.212.114.60]:3016 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762021AbXJMOmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 10:42:46 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20071013143509.%N@1wt.eu>
References: <20071013142822.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Sat, 13 Oct 2007 17:28:51 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [2.6.20.21 review 29/35] crypto: blkcipher_get_spot() handling of buffer at end of page
Content-Disposition: inline; filename=0086-crypto-blkcipher_get_spot-handling-of-buffer-at-e.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This corresponds to upstream changesets
e4630f9fd8cdc14eb1caa08dafe649eb5ae09985 and
32528d0fbda1093eeeaa7d0a2c498bbb5154099d.

[CRYPTO] blkcipher: Fix handling of kmalloc page straddling

The function blkcipher_get_spot tries to return a buffer of
the specified length that does not straddle a page.  It has
an off-by-one bug so it may advance a page unnecessarily.

What's worse, one of its callers doesn't provide a buffer
that's sufficiently long for this operation.

This patch fixes both problems.  Thanks to Bob Gilligan for
diagnosing this problem and providing a fix.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 crypto/blkcipher.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

Index: 2.6/crypto/blkcipher.c
===================================================================
--- 2.6.orig/crypto/blkcipher.c
+++ 2.6/crypto/blkcipher.c
@@ -58,11 +58,13 @@ static inline void blkcipher_unmap_dst(s
 	scatterwalk_unmap(walk->dst.virt.addr, 1);
 }
 
+/* Get a spot of the specified length that does not straddle a page.
+ * The caller needs to ensure that there is enough space for this operation.
+ */
 static inline u8 *blkcipher_get_spot(u8 *start, unsigned int len)
 {
-	if (offset_in_page(start + len) < len)
-		return (u8 *)((unsigned long)(start + len) & PAGE_MASK);
-	return start;
+	u8 *end_page = (u8 *)(((unsigned long)(start + len - 1)) & PAGE_MASK);
+	return start > end_page ? start : end_page;
 }
 
 static inline unsigned int blkcipher_done_slow(struct crypto_blkcipher *tfm,
@@ -154,7 +156,8 @@ static inline int blkcipher_next_slow(st
 	if (walk->buffer)
 		goto ok;
 
-	n = bsize * 2 + (alignmask & ~(crypto_tfm_ctx_alignment() - 1));
+	n = bsize * 3 - (alignmask + 1) +
+	    (alignmask & ~(crypto_tfm_ctx_alignment() - 1));
 	walk->buffer = kmalloc(n, GFP_ATOMIC);
 	if (!walk->buffer)
 		return blkcipher_walk_done(desc, walk, -ENOMEM);

-- 
