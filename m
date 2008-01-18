Return-Path: <linux-kernel-owner+w=401wt.eu-S1762065AbYARClO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762065AbYARClO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 21:41:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761327AbYARCh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 21:37:27 -0500
Received: from waste.org ([66.93.16.53]:40674 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758642AbYARChY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 21:37:24 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 11 of 12] random: make mixing interface byte-oriented
X-Mercurial-Node: a0689714301a7e6eef9878b71441cebadf574897
Message-Id: <a0689714301a7e6eef98.1200623633@cinder.waste.org>
In-Reply-To: <patchbomb.1200623622@cinder.waste.org>
Date: Thu, 17 Jan 2008 20:33:53 -0600
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch add_entropy_words to a byte-oriented interface, eliminating
numerous casts and byte/word size rounding issues. This also
reduces the overall bit/byte/word confusion in this code.

We now mix a byte at a time into the word-based pool. This takes four
times as many iterations, but should be negligible compared to hashing
overhead. This also increases our pool churn, which adds some depth
against some theoretical failure modes.

The function name is changed to emphasize pool mixing and deemphasize
entropy (the samples mixed in may not contain any). extract is added
to the core function to make it clear that it extracts from the pool.

diff -r 8f286e22c84d -r a0689714301a drivers/char/random.c
--- a/drivers/char/random.c	Thu Jan 17 20:25:23 2008 -0600
+++ b/drivers/char/random.c	Thu Jan 17 20:25:24 2008 -0600
@@ -439,7 +439,7 @@
 };
 
 /*
- * This function adds a byte into the entropy "pool".  It does not
+ * This function adds bytes into the entropy "pool".  It does not
  * update the entropy estimate.  The caller should call
  * credit_entropy_store if this is appropriate.
  *
@@ -448,8 +448,8 @@
  * it's cheap to do so and helps slightly in the expected case where
  * the entropy is concentrated in the low-order bits.
  */
-static void __add_entropy_words(struct entropy_store *r, const __u32 *in,
-				int nwords, __u32 out[16])
+static void mix_pool_bytes_extract(struct entropy_store *r, const void *in,
+				   int nbytes, __u8 out[64])
 {
 	static __u32 const twist_table[8] = {
 		0x00000000, 0x3b6e20c8, 0x76dc4190, 0x4db26158,
@@ -457,6 +457,7 @@
 	unsigned long i, j, tap1, tap2, tap3, tap4, tap5;
 	int input_rotate;
 	int wordmask = r->poolinfo->poolwords - 1;
+	const char *bytes = in;
 	__u32 w;
 	unsigned long flags;
 
@@ -471,8 +472,9 @@
 	input_rotate = r->input_rotate;
 	i = r->add_ptr;
 
-	while (nwords--) {
-		w = rol32(*in++, input_rotate & 31);
+	/* mix one byte at a time to simplify size handling and churn faster */
+	while (nbytes--) {
+		w = rol32(*bytes++, input_rotate & 31);
 		i = (i - 1) & wordmask;
 
 		/* XOR in the various taps */
@@ -500,15 +502,14 @@
 
 	if (out)
 		for (j = 0; j < 16; j++)
-			out[j] = r->pool[(i - j) & wordmask];
+			((__u32 *)out)[j] = r->pool[(i - j) & wordmask];
 
 	spin_unlock_irqrestore(&r->lock, flags);
 }
 
-static inline void add_entropy_words(struct entropy_store *r, const __u32 *in,
-				     int nwords)
+static void mix_pool_bytes(struct entropy_store *r, const void *in, int bytes)
 {
-	__add_entropy_words(r, in, nwords, NULL);
+       mix_pool_bytes_extract(r, in, bytes, NULL);
 }
 
 /*
@@ -584,7 +585,7 @@
 	sample.jiffies = jiffies;
 	sample.cycles = get_cycles();
 	sample.num = num;
-	add_entropy_words(&input_pool, (u32 *)&sample, sizeof(sample)/4);
+	mix_pool_bytes(&input_pool, &sample, sizeof(sample));
 
 	/*
 	 * Calculate number of bits of randomness we probably added.
@@ -701,7 +702,7 @@
 
 		bytes = extract_entropy(r->pull, tmp, bytes,
 					random_read_wakeup_thresh / 8, rsvd);
-		add_entropy_words(r, tmp, (bytes + 3) / 4);
+		mix_pool_bytes(r, tmp, bytes);
 		credit_entropy_store(r, bytes*8);
 	}
 }
@@ -759,7 +760,8 @@
 static void extract_buf(struct entropy_store *r, __u8 *out)
 {
 	int i;
-	__u32 extract[16], hash[5], workspace[SHA_WORKSPACE_WORDS];
+	__u32 hash[5], workspace[SHA_WORKSPACE_WORDS];
+	__u8 extract[64];
 
 	/* Generate a hash across the pool, 16 words (512 bits) at a time */
 	sha_init(hash);
@@ -775,13 +777,13 @@
 	 * brute-forcing the feedback as hard as brute-forcing the
 	 * hash.
 	 */
-	__add_entropy_words(r, hash, 5, extract);
+	mix_pool_bytes_extract(r, hash, sizeof(hash), extract);
 
 	/*
 	 * To avoid duplicates, we atomically extract a portion of the
 	 * pool while mixing, and hash one final time.
 	 */
-	sha_transform(hash, (__u8 *)extract, workspace);
+	sha_transform(hash, extract, workspace);
 	memset(extract, 0, sizeof(extract));
 	memset(workspace, 0, sizeof(workspace));
 
@@ -888,9 +890,8 @@
 	spin_unlock_irqrestore(&r->lock, flags);
 
 	now = ktime_get_real();
-	add_entropy_words(r, (__u32 *)&now, sizeof(now)/4);
-	add_entropy_words(r, (__u32 *)utsname(),
-			  sizeof(*(utsname()))/4);
+	mix_pool_bytes(r, &now, sizeof(now));
+	mix_pool_bytes(r, utsname(), sizeof(*(utsname())));
 }
 
 static int rand_initialize(void)
@@ -1031,7 +1032,7 @@
 		count -= bytes;
 		p += bytes;
 
-		add_entropy_words(r, buf, (bytes + 3) / 4);
+		mix_pool_bytes(r, buf, bytes);
 		cond_resched();
 	}
 
