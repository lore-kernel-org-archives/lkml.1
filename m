Return-Path: <linux-kernel-owner+w=401wt.eu-S1762446AbXIXQh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762446AbXIXQh2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758878AbXIXQ1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:27:17 -0400
Received: from canuck.infradead.org ([209.217.80.40]:57969 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760797AbXIXQ1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:27:14 -0400
Date: Mon, 24 Sep 2007 09:21:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Bob Gilligan <gilligan@vyatta.com>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: [33/50] crypto: blkcipher_get_spot() handling of buffer at end of
	page
Message-ID: <20070924162153.GH13510@kroah.com>
References: <20070924161246.983665021@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="crypto-blkcipher_get_spot-handling-of-buffer-at-end-of-page.patch"
In-Reply-To: <20070924161733.GA13510@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

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
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/crypto/blkcipher.c
+++ b/crypto/blkcipher.c
@@ -59,11 +59,13 @@ static inline void blkcipher_unmap_dst(s
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
@@ -155,7 +157,8 @@ static inline int blkcipher_next_slow(st
 	if (walk->buffer)
 		goto ok;
 
-	n = bsize * 2 + (alignmask & ~(crypto_tfm_ctx_alignment() - 1));
+	n = bsize * 3 - (alignmask + 1) +
+	    (alignmask & ~(crypto_tfm_ctx_alignment() - 1));
 	walk->buffer = kmalloc(n, GFP_ATOMIC);
 	if (!walk->buffer)
 		return blkcipher_walk_done(desc, walk, -ENOMEM);

-- 
