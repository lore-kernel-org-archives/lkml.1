Return-Path: <linux-kernel-owner+w=401wt.eu-S1758997AbYCZRwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758997AbYCZRwy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 13:52:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752485AbYCZRwq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 13:52:46 -0400
Received: from relay2.sgi.com ([192.48.171.30]:50542 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753985AbYCZRwq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 13:52:46 -0400
Date: Wed, 26 Mar 2008 10:50:47 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: torvalds@linux-foundation.org
cc: akpm@linux-foundation.org, Pekka J Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org
Subject: [git pull] slab fixes for 2.6.25-rc7
Message-ID: <Pine.LNX.4.64.0803261047270.29812@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another fix to the memoryless node support in SLAB and a patch to avoid a 
compiler warning in SLUB if neither CONFIG_SLABINFO nor CONFIG_SLUB_DEBUG 
is et.

The following changes since commit 05dda977f2574c3341abef9b74c27d2b362e1e3a:
  Linus Torvalds (1):
        Linux 2.6.25-rc7

are available in the git repository at:

  git://master.kernel.org/pub/scm/linux/kernel/git/christoph/vm.git slab-linus

Christoph Lameter (1):
      count_partial() is not used if !SLUB_DEBUG and !CONFIG_SLABINFO

Daniel Yeisley (1):
      slab: fix cache_cache bootstrap in kmem_cache_init()

 mm/slab.c |    4 ++--
 mm/slub.c |    2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index bb4070e..04b308c 100644
--- a/mm/slab.c
+++ b/mm/slab.c
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
diff --git a/mm/slub.c b/mm/slub.c
index ca71d5b..b72bc98 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2685,6 +2685,7 @@ void kfree(const void *x)
 }
 EXPORT_SYMBOL(kfree);
 
+#if defined(SLUB_DEBUG) || defined(CONFIG_SLABINFO)
 static unsigned long count_partial(struct kmem_cache_node *n)
 {
 	unsigned long flags;
@@ -2697,6 +2698,7 @@ static unsigned long count_partial(struct kmem_cache_node *n)
 	spin_unlock_irqrestore(&n->list_lock, flags);
 	return x;
 }
+#endif
 
 /*
  * kmem_cache_shrink removes empty slabs from the partial lists and sorts
