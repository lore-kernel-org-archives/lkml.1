Return-Path: <linux-kernel-owner+w=401wt.eu-S1757806AbXKCSvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757806AbXKCSvi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 14:51:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755442AbXKCSva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 14:51:30 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:49372 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755408AbXKCSva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 14:51:30 -0400
Date: Sat, 3 Nov 2007 11:51:29 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] slub: fix leakage
In-Reply-To: <Pine.LNX.4.64.0711031143140.5527@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0711031149550.5527@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0711031708040.10266@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0711031143140.5527@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The fix against mm:


SLUB: Fix memory leak by not reusing cpu_slab

Fix the memory leak that may occur when we attempt to reuse a cpu_slab
that was allocated while we reenabled interrupts in order to be able to
grow a slab cache. The per cpu freelist may contain objects and in that
situation we may overwrite the per cpu freelist pointer loosing objects.
This only occurs if we find that the concurrently allocated slab fits
our allocation needs.

If we simply always deactivate the slab then the freelist will be properly
reintegrated and the memory leak will go away.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/slub.c |   19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2007-11-03 11:49:20.000000000 -0700
+++ linux-2.6/mm/slub.c	2007-11-03 11:49:29.000000000 -0700
@@ -1529,25 +1529,8 @@ static noinline unsigned long get_new_sl
 		return 0;
 
 	*pc = c = get_cpu_slab(s, smp_processor_id());
-	if (c->page) {
-		/*
-		 * Someone else populated the cpu_slab while we
-		 * enabled interrupts, or we have gotten scheduled
-		 * on another cpu. The page may not be on the
-		 * requested node even if __GFP_THISNODE was
-		 * specified. So we need to recheck.
-		 */
-		if (node_match(c, node)) {
-			/*
-			 * Current cpuslab is acceptable and we
-			 * want the current one since its cache hot
-			 */
-			discard_slab(s, page);
-			return slab_lock(c->page);
-		}
-		/* New slab does not fit our expectations */
+	if (c->page)
 		flush_slab(s, c);
-	}
 	c->page = page;
 	return slab_lock(page) | FROZEN;
 }

