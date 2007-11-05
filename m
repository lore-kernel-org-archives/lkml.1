Return-Path: <linux-kernel-owner+w=401wt.eu-S1754906AbXKETYG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906AbXKETYG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 14:24:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752467AbXKETXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 14:23:53 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:32902 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751887AbXKETXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 14:23:52 -0500
Date: Mon, 5 Nov 2007 11:23:51 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: stable@kernel.org
cc: Hugh Dickins <hugh@veritas.com>,
       =?iso-8859-1?Q?Oliv=E9r_Pint=E9r?= <oliver.pntr@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Willy Tarreau <w@1wt.eu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] slub: fix leakage
In-Reply-To: <Pine.LNX.4.64.0711051114560.14913@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0711051123130.15999@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0711031708040.10266@blonde.wat.veritas.com>
 <6101e8c40711031027x3f946b28p324dadeab7c1b2c3@mail.gmail.com>
 <Pine.LNX.4.64.0711031741160.10953@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0711031847450.13845@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0711031935510.15611@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0711031247250.5828@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0711031950300.17078@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0711031253580.6080@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0711032007060.17942@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0711031326450.6227@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0711041103030.8179@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0711051036250.13139@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0711051901330.28390@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0711051114560.14913@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix against 2.6.22 (the .23 fix also applies with some offsets)


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

Index: linux-2.6.22/mm/slub.c
===================================================================
--- linux-2.6.22.orig/mm/slub.c	2007-07-08 16:32:17.000000000 -0700
+++ linux-2.6.22/mm/slub.c	2007-11-05 11:19:15.000000000 -0800
@@ -1431,28 +1431,8 @@ new_slab:
 	page = new_slab(s, gfpflags, node);
 	if (page) {
 		cpu = smp_processor_id();
-		if (s->cpu_slab[cpu]) {
-			/*
-			 * Someone else populated the cpu_slab while we
-			 * enabled interrupts, or we have gotten scheduled
-			 * on another cpu. The page may not be on the
-			 * requested node even if __GFP_THISNODE was
-			 * specified. So we need to recheck.
-			 */
-			if (node == -1 ||
-				page_to_nid(s->cpu_slab[cpu]) == node) {
-				/*
-				 * Current cpuslab is acceptable and we
-				 * want the current one since its cache hot
-				 */
-				discard_slab(s, page);
-				page = s->cpu_slab[cpu];
-				slab_lock(page);
-				goto load_freelist;
-			}
-			/* New slab does not fit our expectations */
+		if (s->cpu_slab[cpu])
 			flush_slab(s, s->cpu_slab[cpu], cpu);
-		}
 		slab_lock(page);
 		SetSlabFrozen(page);
 		s->cpu_slab[cpu] = page;
