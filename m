Return-Path: <linux-kernel-owner+w=401wt.eu-S1757428AbYLDVAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428AbYLDVAG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 16:00:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755372AbYLDU7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 15:59:53 -0500
Received: from waste.org ([66.93.16.53]:40037 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755034AbYLDU7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 15:59:53 -0500
Subject: [PATCH] random: don't try to look at entropy_count outside the lock
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Theodore Tso <tytso@mit.edu>
Content-Type: text/plain
Date: Thu, 04 Dec 2008 14:58:24 -0600
Message-Id: <1228424304.3255.115.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a non-atomic value, it's only safe to look at entropy_count when
the pool lock is held, so we move the BUG_ON inside the lock for
correctness.

Also remove the spurious comment. It's ok for entropy_count to
temporarily exceed POOLBITS so long as it's left in a consistent state
when the lock is released.

This is a more correct, simple, and idiomatic fix for the bug in 8b76f46a2db.
I've left the reorderings introduced by that patch in place as they're
harmless, even though they don't properly deal with potential atomicity issues.

Signed-off-by: Matt Mackall <mpm@selenic.com>

diff -r 4d01a524fee5 drivers/char/random.c
--- a/drivers/char/random.c	Wed Sep 03 07:30:13 2008 -0700
+++ b/drivers/char/random.c	Wed Sep 17 17:20:14 2008 -0700
@@ -407,7 +407,7 @@
 	/* read-write data: */
 	spinlock_t lock;
 	unsigned add_ptr;
-	int entropy_count;	/* Must at no time exceed ->POOLBITS! */
+	int entropy_count;
 	int input_rotate;
 };
 
@@ -727,11 +727,10 @@
 {
 	unsigned long flags;
 
-	BUG_ON(r->entropy_count > r->poolinfo->POOLBITS);
-
 	/* Hold lock while accounting */
 	spin_lock_irqsave(&r->lock, flags);
 
+	BUG_ON(r->entropy_count > r->poolinfo->POOLBITS);
 	DEBUG_ENT("trying to extract %d bits from %s\n",
 		  nbytes * 8, r->name);
 

-- 
Mathematics is the supreme nostalgia of our time.

