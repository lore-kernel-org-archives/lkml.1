Return-Path: <linux-kernel-owner+w=401wt.eu-S932451AbXCUPmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932451AbXCUPmY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 11:42:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932471AbXCUPmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 11:42:24 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:32973 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932451AbXCUPmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 11:42:23 -0400
Date: Wed, 21 Mar 2007 17:42:22 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <christoph@lameter.com>
cc: Eric Dumazet <dada1@cosmosbay.com>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC, PATCH] SLAB : [NUMA] keep nodeid in struct page instead
 of struct slab
In-Reply-To: <Pine.LNX.4.64.0703210742080.1573@graphe.net>
Message-ID: <Pine.LNX.4.64.0703211740460.19583@sbz-30.cs.Helsinki.FI>
References: <20070321102231.7288f231.dada1@cosmosbay.com>
 <84144f020703210521q10ad95d4g760010bd4388c71f@mail.gmail.com>
 <Pine.LNX.4.64.0703210742080.1573@graphe.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2007, Christoph Lameter wrote:
> None of that please. The page flags already contain a node number that is 
> accessible via page_to_nid(). Just make sure that we never put a slab onto 
> the wrong node.

Oh well, here's a patch to find out. (I don't have a NUMA box.)

			Pekka

From: Pekka Enberg <penberg@cs.helsinki.fi>

This adds a virt_to_nodeid() for looking up the NUMA node ID for a
slab object. The current implementation uses slab->nodeid but adds a
WARN_ON to catch cases where page nid differs. Eventually, we can
change virt_to_nodeid() to use page_to_nid after which slab->nodeid
can be removed.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 mm/slab.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

Index: 2.6/mm/slab.c
===================================================================
--- 2.6.orig/mm/slab.c	2007-03-21 16:58:53.000000000 +0200
+++ 2.6/mm/slab.c	2007-03-21 16:59:26.000000000 +0200
@@ -623,6 +623,14 @@ static inline struct slab *virt_to_slab(
 	return page_get_slab(page);
 }
 
+static inline unsigned short virt_to_nodeid(const void *obj)
+{
+	struct page *page = virt_to_page(obj);
+	struct slab *slab = page_get_slab(page);
+	WARN_ON(slab->nodeid != page_to_nid(page));
+	return slab->nodeid;
+}
+
 static inline void *index_to_obj(struct kmem_cache *cache, struct slab *slab,
 				 unsigned int idx)
 {
@@ -1134,8 +1142,7 @@ 	int i = 0;
 
 static inline int cache_free_alien(struct kmem_cache *cachep, void *objp)
 {
-	struct slab *slabp = virt_to_slab(objp);
-	int nodeid = slabp->nodeid;
+	int nodeid = virt_to_nodeid(objp);
 	struct kmem_list3 *l3;
 	struct array_cache *alien = NULL;
 	int node;
@@ -1146,7 +1153,7 @@ static inline int cache_free_alien(struc
 	 * Make sure we are not freeing a object from another node to the array
 	 * cache on this cpu.
 	 */
-	if (likely(slabp->nodeid == node) || unlikely(!use_alien_caches))
+	if (likely(nodeid == node) || unlikely(!use_alien_caches))
 		return 0;
 
 	l3 = cachep->nodelists[node];
@@ -2665,7 +2672,7 @@ static void *slab_get_obj(struct kmem_ca
 	next = slab_bufctl(slabp)[slabp->free];
 #if DEBUG
 	slab_bufctl(slabp)[slabp->free] = BUFCTL_FREE;
-	WARN_ON(slabp->nodeid != nodeid);
+	WARN_ON(virt_to_nodeid(objp) != nodeid);
 #endif
 	slabp->free = next;
 
@@ -2679,7 +2686,7 @@ static void slab_put_obj(struct kmem_cac
 
 #if DEBUG
 	/* Verify that the slab belongs to the intended node */
-	WARN_ON(slabp->nodeid != nodeid);
+	WARN_ON(virt_to_nodeid(objp) != nodeid);
 
 	if (slab_bufctl(slabp)[objnr] + 1 <= SLAB_LIMIT + 1) {
 		printk(KERN_ERR "slab: double free detected in cache "
