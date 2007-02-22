Return-Path: <linux-kernel-owner+w=401wt.eu-S1946006AbXBVMhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946006AbXBVMhl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 07:37:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946004AbXBVMhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 07:37:40 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:45578 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946006AbXBVMhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 07:37:40 -0500
Date: Thu, 22 Feb 2007 14:37:38 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: akpm@linux-foundation.org
cc: linux-kernel@vger.kernel.org, wli@holomorphy.com, clameter@sgi.com
Subject: [PATCH] slab: remove colouroff from struct slab
Message-ID: <Pine.LNX.4.64.0702221436460.14523@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

As the color offset is always within the first page of the slab,
virt_to_page() works just fine without slabp->colouroff.

Cc: William Lee Irwin III <wli@holomorphy.com>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 mm/slab.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

Index: 2.6/mm/slab.c
===================================================================
--- 2.6.orig/mm/slab.c	2007-02-22 13:51:41.000000000 +0200
+++ 2.6/mm/slab.c	2007-02-22 13:57:39.000000000 +0200
@@ -219,7 +219,6 @@
  */
 struct slab {
 	struct list_head list;
-	unsigned long colouroff;
 	void *s_mem;		/* including colour offset */
 	unsigned int inuse;	/* num of objs active in slab */
 	kmem_bufctl_t free;
@@ -1908,18 +1907,16 @@
  */
 static void slab_destroy(struct kmem_cache *cachep, struct slab *slabp)
 {
-	void *addr = slabp->s_mem - slabp->colouroff;
-
 	slab_destroy_objs(cachep, slabp);
 	if (unlikely(cachep->flags & SLAB_DESTROY_BY_RCU)) {
 		struct slab_rcu *slab_rcu;
 
 		slab_rcu = (struct slab_rcu *)slabp;
 		slab_rcu->cachep = cachep;
-		slab_rcu->addr = addr;
+		slab_rcu->addr = slabp->s_mem;
 		call_rcu(&slab_rcu->head, kmem_rcu_free);
 	} else {
-		kmem_freepages(cachep, addr);
+		kmem_freepages(cachep, slabp->s_mem);
 		if (OFF_SLAB(cachep))
 			kmem_cache_free(cachep->slabp_cache, slabp);
 	}
@@ -2585,7 +2582,6 @@
 		colour_off += cachep->slab_size;
 	}
 	slabp->inuse = 0;
-	slabp->colouroff = colour_off;
 	slabp->s_mem = objp + colour_off;
 	slabp->nodeid = nodeid;
 	return slabp;
