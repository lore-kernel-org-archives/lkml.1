Return-Path: <linux-kernel-owner+w=401wt.eu-S932566AbXCUHWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932566AbXCUHWI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 03:22:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932074AbXCUHWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 03:22:08 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:45441 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933236AbXCUHWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 03:22:07 -0400
Message-ID: <4600DD13.80305@cosmosbay.com>
Date: Wed, 21 Mar 2007 08:21:55 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Christoph Lameter <christoph@lameter.com>,
       Andi Kleen <andi@firstfloor.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] SLAB : Dont allocate empty shared caches
References: <20070320181235.77d28864.dada1@cosmosbay.com> <Pine.LNX.4.64.0703201248530.12664@graphe.net> <20070320213218.GA13952@one.firstfloor.org> <46005B7D.3090701@cosmosbay.com> <Pine.LNX.4.64.0703201715110.17799@graphe.net> <4600D04B.6030305@cosmosbay.com> <4600D756.7070500@cosmosbay.com>
In-Reply-To: <4600D756.7070500@cosmosbay.com>
Content-Type: multipart/mixed;
 boundary="------------060507040506080508000305"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Wed, 21 Mar 2007 08:21:57 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060507040506080508000305
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

We can avoid allocating empty shared caches and avoid unecessary check of 
cache->limit. We save some memory. We avoid bringing into CPU cache unecessary 
cache lines.

All accesses to l3->shared are already checking NULL pointers so this patch is 
safe.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>

--------------060507040506080508000305
Content-Type: text/plain;
 name="dont_allocate_empty_arraycache.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dont_allocate_empty_arraycache.patch"

diff --git a/mm/slab.c b/mm/slab.c
index a69d0a5..abf46ae 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1223,19 +1223,20 @@ static int __cpuinit cpuup_callback(stru
 		 */
 		list_for_each_entry(cachep, &cache_chain, next) {
 			struct array_cache *nc;
-			struct array_cache *shared;
+			struct array_cache *shared = NULL;
 			struct array_cache **alien = NULL;
 
 			nc = alloc_arraycache(node, cachep->limit,
 						cachep->batchcount);
 			if (!nc)
 				goto bad;
-			shared = alloc_arraycache(node,
+			if (cachep->shared) {
+				shared = alloc_arraycache(node,
 					cachep->shared * cachep->batchcount,
 					0xbaadf00d);
-			if (!shared)
-				goto bad;
-
+				if (!shared)
+					goto bad;
+			}
 			if (use_alien_caches) {
                                 alien = alloc_alien_cache(node, cachep->limit);
                                 if (!alien)
@@ -1317,8 +1318,8 @@ #endif
 
 			shared = l3->shared;
 			if (shared) {
-				free_block(cachep, l3->shared->entry,
-					   l3->shared->avail, node);
+				free_block(cachep, shared->entry,
+					   shared->avail, node);
 				l3->shared = NULL;
 			}
 
@@ -3812,12 +3813,15 @@ static int alloc_kmemlist(struct kmem_ca
                                 goto fail;
                 }
 
-		new_shared = alloc_arraycache(node,
+		new_shared = NULL;
+		if (cachep->shared) {
+			new_shared = alloc_arraycache(node,
 				cachep->shared*cachep->batchcount,
 					0xbaadf00d);
-		if (!new_shared) {
-			free_alien_cache(new_alien);
-			goto fail;
+			if (!new_shared) {
+				free_alien_cache(new_alien);
+				goto fail;
+			}
 		}
 
 		l3 = cachep->nodelists[node];

--------------060507040506080508000305--
