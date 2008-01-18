Return-Path: <linux-kernel-owner+w=401wt.eu-S1761812AbYARCki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761812AbYARCki (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 21:40:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758527AbYARChT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 21:37:19 -0500
Received: from waste.org ([66.93.16.53]:40644 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758360AbYARChQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 21:37:16 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 09 of 12] random: remove some prefetch logic
X-Mercurial-Node: bc31fa097d34c5c2470bbceb72dfbde5081407a1
Message-Id: <bc31fa097d34c5c2470b.1200623631@cinder.waste.org>
In-Reply-To: <patchbomb.1200623622@cinder.waste.org>
Date: Thu, 17 Jan 2008 20:33:51 -0600
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The urandom output pool (ie the fast path) fits in one cacheline, so
this is pretty unnecessary. Further, the output path has already
fetched the entire pool to hash it before calling in here.

(This was the only user of prefetch_range in the kernel, and it passed
in words rather than bytes!)

Signed-off-by: Matt Mackall <mpm@selenic.com>

diff -r f06a2e1b4d58 -r bc31fa097d34 drivers/char/random.c
--- a/drivers/char/random.c	Thu Jan 17 20:25:23 2008 -0600
+++ b/drivers/char/random.c	Thu Jan 17 20:25:23 2008 -0600
@@ -457,7 +457,7 @@
 	unsigned long i, add_ptr, tap1, tap2, tap3, tap4, tap5;
 	int input_rotate;
 	int wordmask = r->poolinfo->poolwords - 1;
-	__u32 w, next_w;
+	__u32 w;
 	unsigned long flags;
 
 	/* Taps are constant, so we can load them without holding r->lock.  */
@@ -466,17 +466,13 @@
 	tap3 = r->poolinfo->tap3;
 	tap4 = r->poolinfo->tap4;
 	tap5 = r->poolinfo->tap5;
-	next_w = *in++;
 
 	spin_lock_irqsave(&r->lock, flags);
-	prefetch_range(r->pool, wordmask);
 	input_rotate = r->input_rotate;
 	add_ptr = r->add_ptr;
 
 	while (nwords--) {
-		w = rol32(next_w, input_rotate & 31);
-		if (nwords > 0)
-			next_w = *in++;
+		w = rol32(*in++, input_rotate & 31);
 		i = add_ptr = (add_ptr - 1) & wordmask;
 
 		/* XOR in the various taps */
