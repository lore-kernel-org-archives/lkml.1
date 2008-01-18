Return-Path: <linux-kernel-owner+w=401wt.eu-S1762145AbYARCkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762145AbYARCkw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 21:40:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760611AbYARChY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 21:37:24 -0500
Received: from waste.org ([66.93.16.53]:40664 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761323AbYARChT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 21:37:19 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 10 of 12] random: simplify add_ptr logic
X-Mercurial-Node: 8f286e22c84dfb98a8b956d08339ed1b29c0d23f
Message-Id: <8f286e22c84dfb98a8b9.1200623632@cinder.waste.org>
In-Reply-To: <patchbomb.1200623622@cinder.waste.org>
Date: Thu, 17 Jan 2008 20:33:52 -0600
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The add_ptr variable wasn't used in a sensible way, use only i instead.
i got reused later for a different purpose, use j instead.

While we're here, put tap0 first in the tap list and add a comment.

Signed-off-by: Matt Mackall <mpm@selenic.com>

diff -r bc31fa097d34 -r 8f286e22c84d drivers/char/random.c
--- a/drivers/char/random.c	Thu Jan 17 20:25:23 2008 -0600
+++ b/drivers/char/random.c	Thu Jan 17 20:25:23 2008 -0600
@@ -454,7 +454,7 @@
 	static __u32 const twist_table[8] = {
 		0x00000000, 0x3b6e20c8, 0x76dc4190, 0x4db26158,
 		0xedb88320, 0xd6d6a3e8, 0x9b64c2b0, 0xa00ae278 };
-	unsigned long i, add_ptr, tap1, tap2, tap3, tap4, tap5;
+	unsigned long i, j, tap1, tap2, tap3, tap4, tap5;
 	int input_rotate;
 	int wordmask = r->poolinfo->poolwords - 1;
 	__u32 w;
@@ -469,19 +469,21 @@
 
 	spin_lock_irqsave(&r->lock, flags);
 	input_rotate = r->input_rotate;
-	add_ptr = r->add_ptr;
+	i = r->add_ptr;
 
 	while (nwords--) {
 		w = rol32(*in++, input_rotate & 31);
-		i = add_ptr = (add_ptr - 1) & wordmask;
+		i = (i - 1) & wordmask;
 
 		/* XOR in the various taps */
+		w ^= r->pool[i];
 		w ^= r->pool[(i + tap1) & wordmask];
 		w ^= r->pool[(i + tap2) & wordmask];
 		w ^= r->pool[(i + tap3) & wordmask];
 		w ^= r->pool[(i + tap4) & wordmask];
 		w ^= r->pool[(i + tap5) & wordmask];
-		w ^= r->pool[i];
+
+		/* Mix the result back in with a twist */
 		r->pool[i] = (w >> 3) ^ twist_table[w & 7];
 
 		/*
@@ -494,14 +496,11 @@
 	}
 
 	r->input_rotate = input_rotate;
-	r->add_ptr = add_ptr;
+	r->add_ptr = i;
 
-	if (out) {
-		for (i = 0; i < 16; i++) {
-			out[i] = r->pool[add_ptr];
-			add_ptr = (add_ptr - 1) & wordmask;
-		}
-	}
+	if (out)
+		for (j = 0; j < 16; j++)
+			out[j] = r->pool[(i - j) & wordmask];
 
 	spin_unlock_irqrestore(&r->lock, flags);
 }
