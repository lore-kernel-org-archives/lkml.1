Return-Path: <linux-kernel-owner+w=401wt.eu-S1763309AbYDQBMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763309AbYDQBMP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 21:12:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755132AbYDQBHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 21:07:22 -0400
Received: from sous-sol.org ([216.99.217.87]:58829 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755130AbYDQBHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 21:07:20 -0400
Message-Id: <20080417010323.239220997@sous-sol.org>
References: <20080417010122.148289106@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Wed, 16 Apr 2008 18:01:34 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Pekka J Enberg <penberg@cs.helsinki.fi>, mel@csn.ul.ie, olaf@aepfle.de,
       dan.yeisley@unisys.com, clameter@sgi.com
Subject: slab: fix cache_cache bootstrap in kmem_cache_init()
Content-Disposition: inline; filename=slab-fix-cache_cache-bootstrap-in-kmem_cache_init.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Daniel Yeisley <dan.yeisley@unisys.com>

upstream commit: ec1f5eeeb5a79a0d48036de649a3498da42db565

Commit 556a169dab38b5100df6f4a45b655dddd3db94c1 ("slab: fix bootstrap on
memoryless node") introduced bootstrap-time cache_cache list3s for all nodes
but forgot that initkmem_list3 needs to be accessed by [somevalue + node]. This
patch fixes list_add() corruption in mm/slab.c seen on the ES7000.
 
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Olaf Hering <olaf@aepfle.de>
Signed-off-by: Dan Yeisley <dan.yeisley@unisys.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 mm/slab.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1484,7 +1484,7 @@ void __init kmem_cache_init(void)
 	list_add(&cache_cache.next, &cache_chain);
 	cache_cache.colour_off = cache_line_size();
 	cache_cache.array[smp_processor_id()] = &initarray_cache.cache;
-	cache_cache.nodelists[node] = &initkmem_list3[CACHE_CACHE];
+	cache_cache.nodelists[node] = &initkmem_list3[CACHE_CACHE + node];
 
 	/*
 	 * struct kmem_cache size depends on nr_node_ids, which
@@ -1605,7 +1605,7 @@ void __init kmem_cache_init(void)
 		int nid;
 
 		for_each_online_node(nid) {
-			init_list(&cache_cache, &initkmem_list3[CACHE_CACHE], nid);
+			init_list(&cache_cache, &initkmem_list3[CACHE_CACHE + nid], nid);
 
 			init_list(malloc_sizes[INDEX_AC].cs_cachep,
 				  &initkmem_list3[SIZE_AC + nid], nid);

-- 
