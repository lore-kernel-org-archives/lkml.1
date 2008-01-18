Return-Path: <linux-kernel-owner+w=401wt.eu-S1761868AbYARCi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761868AbYARCi5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 21:38:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758095AbYARChF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 21:37:05 -0500
Received: from waste.org ([66.93.16.53]:40596 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760922AbYARChC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 21:37:02 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 06 of 12] random: make backtracking attacks harder
X-Mercurial-Node: 9569d3011032874785a4157260cbffec36fef63a
Message-Id: <9569d3011032874785a4.1200623628@cinder.waste.org>
In-Reply-To: <patchbomb.1200623622@cinder.waste.org>
Date: Thu, 17 Jan 2008 20:33:48 -0600
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At each extraction, we change (poolbits / 16) + 32 bits in the pool,
or 96 bits in the case of the secondary pools. Thus, a brute-force
backtracking attack on the pool state is less difficult than breaking
the hash. In certain cases, this difficulty may be is reduced to 2^64
iterations.

Instead, hash the entire pool in one go, then feedback the whole hash
(160 bits) in one go. This will make backtracking at least as hard as
inverting the hash.

Signed-off-by: Matt Mackall <mpm@selenic.com>

diff -r 42aa9f950f97 -r 9569d3011032 drivers/char/random.c
--- a/drivers/char/random.c	Thu Jan 17 20:25:23 2008 -0600
+++ b/drivers/char/random.c	Thu Jan 17 20:25:23 2008 -0600
@@ -768,37 +768,35 @@
 	int i;
 	__u32 extract[16], hash[5], workspace[SHA_WORKSPACE_WORDS];
 
+	/* Generate a hash across the pool, 16 words (512 bits) at a time */
 	sha_init(hash);
-	/*
-	 * As we hash the pool, we mix intermediate values of
-	 * the hash back into the pool.  This eliminates
-	 * backtracking attacks (where the attacker knows
-	 * the state of the pool plus the current outputs, and
-	 * attempts to find previous ouputs), unless the hash
-	 * function can be inverted.
-	 */
-	for (i = 0; i < r->poolinfo->poolwords; i += 16) {
-		/* hash blocks of 16 words = 512 bits */
+	for (i = 0; i < r->poolinfo->poolwords; i += 16)
 		sha_transform(hash, (__u8 *)(r->pool + i), workspace);
-		/* feed back portion of the resulting hash */
-		add_entropy_words(r, &hash[i % 5], 1);
-	}
 
 	/*
-	 * To avoid duplicates, we atomically extract a
-	 * portion of the pool while mixing, and hash one
-	 * final time.
+	 * We mix the hash back into the pool to prevent backtracking
+	 * attacks (where the attacker knows the state of the pool
+	 * plus the current outputs, and attempts to find previous
+	 * ouputs), unless the hash function can be inverted. By
+	 * mixing at least a SHA1 worth of hash data back, we make
+	 * brute-forcing the feedback as hard as brute-forcing the
+	 * hash.
 	 */
-	__add_entropy_words(r, &hash[i % 5], 1, extract);
+	__add_entropy_words(r, hash, 5, extract);
+
+	/*
+	 * To avoid duplicates, we atomically extract a portion of the
+	 * pool while mixing, and hash one final time.
+	 */
 	sha_transform(hash, (__u8 *)extract, workspace);
 	memset(extract, 0, sizeof(extract));
 	memset(workspace, 0, sizeof(workspace));
 
 	/*
-	 * In case the hash function has some recognizable
-	 * output pattern, we fold it in half.
+	 * In case the hash function has some recognizable output
+	 * pattern, we fold it in half. Thus, we always feed back
+	 * twice as much data as we output.
 	 */
-
 	hash[0] ^= hash[3];
 	hash[1] ^= hash[4];
 	hash[2] ^= rol32(hash[2], 16);
