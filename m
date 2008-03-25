Return-Path: <linux-kernel-owner+w=401wt.eu-S1760711AbYCYV7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760711AbYCYV7V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 17:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753473AbYCYV7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 17:59:13 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:48453 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899AbYCYV7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 17:59:12 -0400
Date: Tue, 25 Mar 2008 23:59:08 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: akpm@linux-foundation.org
cc: mel@csn.ul.ie, olaf@aepfle.de, clameter@sgi.com, dan.yeisley@unisys.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH] slab: fix cache_cache bootstrap in kmem_cache_init()
Message-ID: <Pine.LNX.4.64.0803252357330.4422@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Yeisley <dan.yeisley@unisys.com>

Commit 556a169dab38b5100df6f4a45b655dddd3db94c1 ("slab: fix bootstrap on
memoryless node") introduced bootstrap-time cache_cache list3s for all nodes
but forgot that initkmem_list3 needs to be accessed by [somevalue + node]. This
patch fixes list_add() corruption in mm/slab.c seen on the ES7000.

Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Olaf Hering <olaf@aepfle.de>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Dan Yeisley <dan.yeisley@unisys.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
Andrew/Christoph, this needs to go into 2.6.25 and probably 2.6.24.x as 
well. Hopefully either Mel or Olaf can test this on their machines to 
confirm the fix doesn't break their setup.

 mm/slab.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/mm/slab.c
===================================================================
--- linux-2.6.orig/mm/slab.c
+++ linux-2.6/mm/slab.c
@@ -1481,7 +1481,7 @@ void __init kmem_cache_init(void)
 	list_add(&cache_cache.next, &cache_chain);
 	cache_cache.colour_off = cache_line_size();
 	cache_cache.array[smp_processor_id()] = &initarray_cache.cache;
-	cache_cache.nodelists[node] = &initkmem_list3[CACHE_CACHE];
+	cache_cache.nodelists[node] = &initkmem_list3[CACHE_CACHE + node];
 
 	/*
 	 * struct kmem_cache size depends on nr_node_ids, which
@@ -1602,7 +1602,7 @@ void __init kmem_cache_init(void)
 		int nid;
 
 		for_each_online_node(nid) {
-			init_list(&cache_cache, &initkmem_list3[CACHE_CACHE], nid);
+			init_list(&cache_cache, &initkmem_list3[CACHE_CACHE + nid], nid);
 
 			init_list(malloc_sizes[INDEX_AC].cs_cachep,
 				  &initkmem_list3[SIZE_AC + nid], nid);
