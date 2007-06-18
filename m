Return-Path: <linux-kernel-owner+w=401wt.eu-S1761314AbXFRJ70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761314AbXFRJ70 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 05:59:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759098AbXFRJ7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 05:59:16 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:47891 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758025AbXFRJ7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 05:59:15 -0400
Message-Id: <20070618095913.634860091@sgi.com>
References: <20070618095838.238615343@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 18 Jun 2007 02:58:39 -0700
From: clameter@sgi.com
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Pekka Enberg <penberg@cs.helsinki.fi>
Cc: suresh.b.siddha@intel.com
Subject: [patch 01/26] SLUB Debug: Fix initial object debug state of NUMA bootstrap objects
Content-Disposition: inline; filename=fix_numa_boostrap_debug
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The function we are calling to initialize object debug state during early
NUMA bootstrap sets up an inactive object giving it the wrong redzone
signature. The bootstrap nodes are active objects and should have active redzone
signatures.

Currently slab validation complains and reverts the object to active state.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

Index: linux-2.6.22-rc4-mm2/mm/slub.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/mm/slub.c	2007-06-17 23:51:43.000000000 -0700
+++ linux-2.6.22-rc4-mm2/mm/slub.c	2007-06-18 00:40:04.000000000 -0700
@@ -1925,7 +1925,8 @@ static struct kmem_cache_node * __init e
 	page->freelist = get_freepointer(kmalloc_caches, n);
 	page->inuse++;
 	kmalloc_caches->node[node] = n;
-	setup_object_debug(kmalloc_caches, page, n);
+	init_object(kmalloc_caches, n, 1);
+	init_tracking(kmalloc_caches, n);
 	init_kmem_cache_node(n);
 	atomic_long_inc(&n->nr_slabs);
 	add_partial(n, page);

-- 
