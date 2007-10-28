Return-Path: <linux-kernel-owner+w=401wt.eu-S1757943AbXJ1Dgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757943AbXJ1Dgt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 23:36:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691AbXJ1DdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 23:33:16 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:37616 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751156AbXJ1DdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 23:33:04 -0400
Message-Id: <20071028033300.733431806@sgi.com>
References: <20071028033156.022983073@sgi.com>
User-Agent: quilt/0.46-1
Date: Sat, 27 Oct 2007 20:32:06 -0700
From: Christoph Lameter <clameter@sgi.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [patch 10/10] SLUB: Restructure slab alloc
Content-Disposition: inline; filename=slub_restruct_alloc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Restructure slab_alloc so that the code flows in the sequence
it is usually executed.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/slub.c |   40 ++++++++++++++++++++++++----------------
 1 file changed, 24 insertions(+), 16 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2007-10-27 07:58:07.000000000 -0700
+++ linux-2.6/mm/slub.c	2007-10-27 07:58:36.000000000 -0700
@@ -1580,16 +1580,28 @@ static void *__slab_alloc(struct kmem_ca
 	local_irq_save(flags);
 	preempt_enable_no_resched();
 #endif
-	if (!c->page)
-		goto new_slab;
+	if (likely(c->page)) {
+		state = slab_lock(c->page);
+
+		if (unlikely(node_match(c, node) &&
+			c->page->freelist != c->page->end))
+				goto load_freelist;
+
+		deactivate_slab(s, c, state);
+	}
+
+another_slab:
+	state = get_partial(s, c, gfpflags, node);
+	if (!state)
+		goto grow_slab;
 
-	state = slab_lock(c->page);
-	if (unlikely(!node_match(c, node)))
-		goto another_slab;
 load_freelist:
-	object = c->page->freelist;
-	if (unlikely(object == c->page->end))
-		goto another_slab;
+	/*
+	 * slabs from the partial list must have at least
+	 * one free object.
+	 */
+	VM_BUG_ON(c->page->freelist == c->page->end);
+
 	if (unlikely(state & SLABDEBUG))
 		goto debug;
 
@@ -1607,20 +1619,16 @@ out:
 #endif
 	return object;
 
-another_slab:
-	deactivate_slab(s, c, state);
-
-new_slab:
-	state = get_partial(s, c, gfpflags, node);
-	if (state)
-		goto load_freelist;
-
+/* Extend the slabcache with a new slab */
+grow_slab:
 	state = get_new_slab(s, &c, gfpflags, node);
 	if (state)
 		goto load_freelist;
 
 	object = NULL;
 	goto out;
+
+/* Perform debugging */
 debug:
 	object = c->page->freelist;
 	if (!alloc_debug_processing(s, c->page, object, addr))

-- 
