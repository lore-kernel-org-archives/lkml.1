Return-Path: <linux-kernel-owner+w=401wt.eu-S1758516AbZIRTeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758516AbZIRTeU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 15:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758105AbZIRTeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 15:34:16 -0400
Received: from gir.skynet.ie ([193.1.99.77]:38503 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758036AbZIRTeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 15:34:09 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: Nick Piggin <npiggin@suse.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>
Cc: heiko.carstens@de.ibm.com, sachinp@in.ibm.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH 2/3] slqb: Treat pages freed on a memoryless node as local node
Date: Fri, 18 Sep 2009 20:34:10 +0100
Message-Id: <1253302451-27740-3-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1253302451-27740-1-git-send-email-mel@csn.ul.ie>
References: <1253302451-27740-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a page is being freed belonging to a remote node, it is added to a
separate list. When the node is memoryless, pages are always allocated
on the front for the per-cpu local and always freed remote. This is
similar to a leak and the machine quickly goes OOM and drives over the
cliff faster than Thelma and Louise.

This patch treats pages being freed from remote nodes as if they are local
if the CPU is on a memoryless node. It's now known at time of writing if this
is the best approach so reviewed-bys from those familiar with SLQB are needed.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 mm/slqb.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/slqb.c b/mm/slqb.c
index 4d72be2..0f46b56 100644
--- a/mm/slqb.c
+++ b/mm/slqb.c
@@ -1726,6 +1726,7 @@ static __always_inline void __slab_free(struct kmem_cache *s,
 	struct kmem_cache_cpu *c;
 	struct kmem_cache_list *l;
 	int thiscpu = smp_processor_id();
+	int thisnode = numa_node_id();
 
 	c = get_cpu_slab(s, thiscpu);
 	l = &c->list;
@@ -1733,12 +1734,14 @@ static __always_inline void __slab_free(struct kmem_cache *s,
 	slqb_stat_inc(l, FREE);
 
 	if (!NUMA_BUILD || !slab_numa(s) ||
-			likely(slqb_page_to_nid(page) == numa_node_id())) {
+			likely(slqb_page_to_nid(page) == numa_node_id() ||
+			!node_state(thisnode, N_HIGH_MEMORY))) {
 		/*
 		 * Freeing fastpath. Collects all local-node objects, not
 		 * just those allocated from our per-CPU list. This allows
 		 * fast transfer of objects from one CPU to another within
-		 * a given node.
+		 * a given node. If the current node is memoryless, the
+		 * pages are treated as local
 		 */
 		set_freepointer(s, object, l->freelist.head);
 		l->freelist.head = object;
-- 
1.6.3.3

