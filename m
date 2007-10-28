Return-Path: <linux-kernel-owner+w=401wt.eu-S1756935AbXJ1Den@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935AbXJ1Den (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 23:34:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751639AbXJ1DdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 23:33:08 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:37592 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751180AbXJ1DdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 23:33:00 -0400
Message-Id: <20071028033259.263401839@sgi.com>
References: <20071028033156.022983073@sgi.com>
User-Agent: quilt/0.46-1
Date: Sat, 27 Oct 2007 20:32:00 -0700
From: Christoph Lameter <clameter@sgi.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [patch 04/10] SLUB: Avoid checking for a valid object before zeroing on the fast path
Content-Disposition: inline; filename=slub_slab_alloc_move_oom
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The fast path always results in a valid object. Move the check
for the NULL pointer to the slow branch that calls
__slab_alloc. Only __slab_alloc can return NULL if there is no
memory available anymore and that case is exceedingly rare.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/slub.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2007-10-25 19:37:38.000000000 -0700
+++ linux-2.6/mm/slub.c	2007-10-25 19:38:14.000000000 -0700
@@ -1573,19 +1573,22 @@ static void __always_inline *slab_alloc(
 
 	local_irq_save(flags);
 	c = get_cpu_slab(s, smp_processor_id());
-	if (unlikely(!c->freelist || !node_match(c, node)))
+	if (unlikely(!c->freelist || !node_match(c, node))) {
 
 		object = __slab_alloc(s, gfpflags, node, addr, c);
-
-	else {
+		if (unlikely(!object)) {
+			local_irq_restore(flags);
+			goto out;
+		}
+	} else {
 		object = c->freelist;
 		c->freelist = object[c->offset];
 	}
 	local_irq_restore(flags);
 
-	if (unlikely((gfpflags & __GFP_ZERO) && object))
+	if (unlikely((gfpflags & __GFP_ZERO)))
 		memset(object, 0, c->objsize);
-
+out:
 	return object;
 }
 

-- 
