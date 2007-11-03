Return-Path: <linux-kernel-owner+w=401wt.eu-S1757364AbXKCSsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364AbXKCSsU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 14:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755264AbXKCSsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 14:48:12 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:58237 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755232AbXKCSsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 14:48:11 -0400
Date: Sat, 3 Nov 2007 11:48:10 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Hugh Dickins <hugh@veritas.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] slub: fix leakage
In-Reply-To: <Pine.LNX.4.64.0711031708040.10266@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0711031143140.5527@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0711031708040.10266@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Nov 2007, Hugh Dickins wrote:

> Which fixes the leakage: Objects and Partials then remain stable.

Well this code is just an optimization for a rare case. Your patch may not 
handle the debug situation the right way. We could just remove it.



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
 mm/slub.c |   20 +-------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2007-11-03 11:41:58.000000000 -0700
+++ linux-2.6/mm/slub.c	2007-11-03 11:42:12.000000000 -0700
@@ -1511,26 +1511,8 @@ new_slab:
 
 	if (new) {
 		c = get_cpu_slab(s, smp_processor_id());
-		if (c->page) {
-			/*
-			 * Someone else populated the cpu_slab while we
-			 * enabled interrupts, or we have gotten scheduled
-			 * on another cpu. The page may not be on the
-			 * requested node even if __GFP_THISNODE was
-			 * specified. So we need to recheck.
-			 */
-			if (node_match(c, node)) {
-				/*
-				 * Current cpuslab is acceptable and we
-				 * want the current one since its cache hot
-				 */
-				discard_slab(s, new);
-				slab_lock(c->page);
-				goto load_freelist;
-			}
-			/* New slab does not fit our expectations */
+		if (c->page)
 			flush_slab(s, c);
-		}
 		slab_lock(new);
 		SetSlabFrozen(new);
 		c->page = new;
