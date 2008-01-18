Return-Path: <linux-kernel-owner+w=401wt.eu-S1761726AbYARCik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761726AbYARCik (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 21:38:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760861AbYARChA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 21:37:00 -0500
Received: from waste.org ([66.93.16.53]:40585 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760769AbYARCg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 21:36:59 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 05 of 12] random: improve variable naming, clear extract buffer
X-Mercurial-Node: 42aa9f950f97a57c860d4ce6d8740877b2d483aa
Message-Id: <42aa9f950f97a57c860d.1200623627@cinder.waste.org>
In-Reply-To: <patchbomb.1200623622@cinder.waste.org>
Date: Thu, 17 Jan 2008 20:33:47 -0600
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- split the SHA variables apart into hash and workspace
- rename data to extract
- wipe extract and workspace after hashing

Signed-off-by: Matt Mackall <mpm@selenic.com>

diff -r 3e0b0226df90 -r 42aa9f950f97 drivers/char/random.c
--- a/drivers/char/random.c	Thu Jan 17 20:25:23 2008 -0600
+++ b/drivers/char/random.c	Thu Jan 17 20:25:23 2008 -0600
@@ -766,9 +766,9 @@
 static void extract_buf(struct entropy_store *r, __u8 *out)
 {
 	int i;
-	__u32 data[16], buf[5 + SHA_WORKSPACE_WORDS];
+	__u32 extract[16], hash[5], workspace[SHA_WORKSPACE_WORDS];
 
-	sha_init(buf);
+	sha_init(hash);
 	/*
 	 * As we hash the pool, we mix intermediate values of
 	 * the hash back into the pool.  This eliminates
@@ -779,9 +779,9 @@
 	 */
 	for (i = 0; i < r->poolinfo->poolwords; i += 16) {
 		/* hash blocks of 16 words = 512 bits */
-		sha_transform(buf, (__u8 *)(r->pool + i), buf + 5);
+		sha_transform(hash, (__u8 *)(r->pool + i), workspace);
 		/* feed back portion of the resulting hash */
-		add_entropy_words(r, &buf[i % 5], 1);
+		add_entropy_words(r, &hash[i % 5], 1);
 	}
 
 	/*
@@ -789,19 +789,21 @@
 	 * portion of the pool while mixing, and hash one
 	 * final time.
 	 */
-	__add_entropy_words(r, &buf[i % 5], 1, data);
-	sha_transform(buf, (__u8 *)data, buf + 5);
+	__add_entropy_words(r, &hash[i % 5], 1, extract);
+	sha_transform(hash, (__u8 *)extract, workspace);
+	memset(extract, 0, sizeof(extract));
+	memset(workspace, 0, sizeof(workspace));
 
 	/*
 	 * In case the hash function has some recognizable
 	 * output pattern, we fold it in half.
 	 */
 
-	buf[0] ^= buf[3];
-	buf[1] ^= buf[4];
-	buf[2] ^= rol32(buf[2], 16);
-	memcpy(out, buf, EXTRACT_SIZE);
-	memset(buf, 0, sizeof(buf));
+	hash[0] ^= hash[3];
+	hash[1] ^= hash[4];
+	hash[2] ^= rol32(hash[2], 16);
+	memcpy(out, hash, EXTRACT_SIZE);
+	memset(hash, 0, sizeof(hash));
 }
 
 static ssize_t extract_entropy(struct entropy_store *r, void *buf,
