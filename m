Return-Path: <linux-kernel-owner+w=401wt.eu-S1757239AbZCCEup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239AbZCCEup (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 23:50:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754125AbZCCEue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 23:50:34 -0500
Received: from smtp-out.google.com ([216.239.45.13]:3040 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601AbZCCEud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 23:50:33 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=xwZQJAIP2DNBSeMDyCg2uCDwr482ayZFSx8KX4DgNP0k6Bg3qbq+BeuYCO8XRDIr9
	vRuLtYAGFg8YdCbdNF8Yg==
Date: Mon, 2 Mar 2009 20:50:18 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>
cc: Paul Menage <menage@google.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: [patch 2/2] slub: enforce cpuset restrictions for cpu slabs
In-Reply-To: <alpine.DEB.2.00.0903022009490.17284@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.0903022011430.17284@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0903022009490.17284@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Slab allocations should respect cpuset hardwall restrictions.  Otherwise,
it is possible for tasks in a cpuset to fill slabs allocated on mems
assigned to a disjoint cpuset.

When an allocation is attempted for a cpu slab that resides on a node that
is not allowed by a task's cpuset, an appropriate partial slab or new slab
is allocated.

If an allocation is intended for a particular node that the task does not
have access to because of its cpuset, an allowed partial slab is used
instead of failing.

Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/slub.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1353,6 +1353,8 @@ static struct page *get_partial(struct kmem_cache *s, gfp_t flags, int node)
 	struct page *page;
 	int searchnode = (node == -1) ? numa_node_id() : node;
 
+	if (!cpuset_node_allowed_hardwall(searchnode, flags))
+		searchnode = cpuset_mem_spread_node();
 	page = get_partial_node(get_node(s, searchnode));
 	if (page || (flags & __GFP_THISNODE))
 		return page;
@@ -1477,13 +1479,13 @@ static void flush_all(struct kmem_cache *s)
  * Check if the objects in a per cpu structure fit numa
  * locality expectations.
  */
-static inline int node_match(struct kmem_cache_cpu *c, int node)
+static inline int node_match(struct kmem_cache_cpu *c, int node, gfp_t gfpflags)
 {
 #ifdef CONFIG_NUMA
 	if (node != -1 && c->node != node)
 		return 0;
 #endif
-	return 1;
+	return cpuset_node_allowed_hardwall(c->node, gfpflags);
 }
 
 /*
@@ -1517,7 +1519,7 @@ static void *__slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 		goto new_slab;
 
 	slab_lock(c->page);
-	if (unlikely(!node_match(c, node)))
+	if (unlikely(!node_match(c, node, gfpflags)))
 		goto another_slab;
 
 	stat(c, ALLOC_REFILL);
@@ -1604,7 +1606,7 @@ static __always_inline void *slab_alloc(struct kmem_cache *s,
 	local_irq_save(flags);
 	c = get_cpu_slab(s, smp_processor_id());
 	objsize = c->objsize;
-	if (unlikely(!c->freelist || !node_match(c, node)))
+	if (unlikely(!c->freelist || !node_match(c, node, gfpflags)))
 
 		object = __slab_alloc(s, gfpflags, node, addr, c);
 
