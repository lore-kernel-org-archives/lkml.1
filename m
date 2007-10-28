Return-Path: <linux-kernel-owner+w=401wt.eu-S1756548AbXJ1De2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548AbXJ1De2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 23:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751570AbXJ1DdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 23:33:07 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:37595 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751164AbXJ1DdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 23:33:00 -0400
Message-Id: <20071028033259.504765424@sgi.com>
References: <20071028033156.022983073@sgi.com>
User-Agent: quilt/0.46-1
Date: Sat, 27 Oct 2007 20:32:01 -0700
From: Christoph Lameter <clameter@sgi.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [patch 05/10] SLUB: __slab_alloc() exit path consolidation
Content-Disposition: inline; filename=slub_slab_alloc_exit_paths
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use a single exit path by using goto's to the hottest exit path.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/slub.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2007-10-25 19:38:14.000000000 -0700
+++ linux-2.6/mm/slub.c	2007-10-25 19:38:47.000000000 -0700
@@ -1493,7 +1493,9 @@ load_freelist:
 	c->page->inuse = s->objects;
 	c->page->freelist = NULL;
 	c->node = page_to_nid(c->page);
+unlock_out:
 	slab_unlock(c->page);
+out:
 	return object;
 
 another_slab:
@@ -1541,7 +1543,8 @@ new_slab:
 		c->page = new;
 		goto load_freelist;
 	}
-	return NULL;
+	object = NULL;
+	goto out;
 debug:
 	object = c->page->freelist;
 	if (!alloc_debug_processing(s, c->page, object, addr))
@@ -1550,8 +1553,7 @@ debug:
 	c->page->inuse++;
 	c->page->freelist = object[c->offset];
 	c->node = -1;
-	slab_unlock(c->page);
-	return object;
+	goto unlock_out;
 }
 
 /*

-- 
