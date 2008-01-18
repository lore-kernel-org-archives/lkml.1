Return-Path: <linux-kernel-owner+w=401wt.eu-S1762001AbYARCjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762001AbYARCjm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 21:39:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761056AbYARChK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 21:37:10 -0500
Received: from waste.org ([66.93.16.53]:40612 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760960AbYARChI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 21:37:08 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 08 of 12] random: eliminate redundant new_rotate variable
X-Mercurial-Node: f06a2e1b4d588a02b8602514c4905159d9979ed4
Message-Id: <f06a2e1b4d588a02b860.1200623630@cinder.waste.org>
In-Reply-To: <patchbomb.1200623622@cinder.waste.org>
Date: Thu, 17 Jan 2008 20:33:50 -0600
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- eliminate new_rotate
- move input_rotate masking
- simplify input_rotate update
- move input_rotate update to end of inner loop for readability

Signed-off-by: Matt Mackall <mpm@selenic.com>

diff -r 70f981257057 -r f06a2e1b4d58 drivers/char/random.c
--- a/drivers/char/random.c	Thu Jan 17 20:25:23 2008 -0600
+++ b/drivers/char/random.c	Thu Jan 17 20:25:23 2008 -0600
@@ -455,7 +455,7 @@
 		0x00000000, 0x3b6e20c8, 0x76dc4190, 0x4db26158,
 		0xedb88320, 0xd6d6a3e8, 0x9b64c2b0, 0xa00ae278 };
 	unsigned long i, add_ptr, tap1, tap2, tap3, tap4, tap5;
-	int new_rotate, input_rotate;
+	int input_rotate;
 	int wordmask = r->poolinfo->poolwords - 1;
 	__u32 w, next_w;
 	unsigned long flags;
@@ -474,20 +474,10 @@
 	add_ptr = r->add_ptr;
 
 	while (nwords--) {
-		w = rol32(next_w, input_rotate);
+		w = rol32(next_w, input_rotate & 31);
 		if (nwords > 0)
 			next_w = *in++;
 		i = add_ptr = (add_ptr - 1) & wordmask;
-		/*
-		 * Normally, we add 7 bits of rotation to the pool.
-		 * At the beginning of the pool, add an extra 7 bits
-		 * rotation, so that successive passes spread the
-		 * input bits across the pool evenly.
-		 */
-		new_rotate = input_rotate + 14;
-		if (i)
-			new_rotate = input_rotate + 7;
-		input_rotate = new_rotate & 31;
 
 		/* XOR in the various taps */
 		w ^= r->pool[(i + tap1) & wordmask];
@@ -497,6 +487,14 @@
 		w ^= r->pool[(i + tap5) & wordmask];
 		w ^= r->pool[i];
 		r->pool[i] = (w >> 3) ^ twist_table[w & 7];
+
+		/*
+		 * Normally, we add 7 bits of rotation to the pool.
+		 * At the beginning of the pool, add an extra 7 bits
+		 * rotation, so that successive passes spread the
+		 * input bits across the pool evenly.
+		 */
+		input_rotate += i ? 7 : 14;
 	}
 
 	r->input_rotate = input_rotate;
