Return-Path: <linux-kernel-owner+w=401wt.eu-S1760107AbXHWGsE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760107AbXHWGsE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 02:48:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754990AbXHWGrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 02:47:37 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:49771 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754831AbXHWGrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 02:47:35 -0400
Message-Id: <20070823064734.558994491@sgi.com>
References: <20070823064653.081843729@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 22 Aug 2007 23:46:57 -0700
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [patch 4/6] SLUB: Avoid touching page struct when freeing to per cpu slab
Content-Disposition: inline; filename=0008-SLUB-Avoid-touching-page-struct-when-freeing-to-per.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Set c->node to -1 if we allocate from a debug slab instead for SlabDebug
which requires access the page struct cacheline.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 mm/slub.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6.23-rc3-mm1/mm/slub.c
===================================================================
--- linux-2.6.23-rc3-mm1.orig/mm/slub.c	2007-08-22 17:20:28.000000000 -0700
+++ linux-2.6.23-rc3-mm1/mm/slub.c	2007-08-22 17:20:33.000000000 -0700
@@ -1517,6 +1517,7 @@ debug:
 
 	c->page->inuse++;
 	c->page->freelist = object[c->offset];
+	c->node = -1;
 	slab_unlock(c->page);
 	return object;
 }
@@ -1540,8 +1541,7 @@ static void __always_inline *slab_alloc(
 
 	local_irq_save(flags);
 	c = get_cpu_slab(s, smp_processor_id());
-	if (unlikely(!c->page || !c->freelist ||
-					!node_match(c, node)))
+	if (unlikely(!c->freelist || !node_match(c, node)))
 
 		object = __slab_alloc(s, gfpflags, node, addr, c);
 
@@ -1650,7 +1650,7 @@ static void __always_inline slab_free(st
 	local_irq_save(flags);
 	debug_check_no_locks_freed(object, s->objsize);
 	c = get_cpu_slab(s, smp_processor_id());
-	if (likely(page == c->page && !SlabDebug(page))) {
+	if (likely(page == c->page && c->node >= 0)) {
 		object[c->offset] = c->freelist;
 		c->freelist = object;
 	} else

-- 
