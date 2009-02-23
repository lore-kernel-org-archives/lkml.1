Return-Path: <linux-kernel-owner+w=401wt.eu-S1756202AbZBWBkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202AbZBWBkn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 20:40:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752071AbZBWBkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 20:40:20 -0500
Received: from smtp-out.google.com ([216.239.33.17]:8401 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbZBWBkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 20:40:19 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:message-id:user-agent:
	mime-version:content-type:x-system-of-record;
	b=Q1PigpLHgaKSMWOMlp/nOgXAgh6DTcgTrhFcGnJ9iHVbbJhdI35CtMTzRD1KXNyNO
	We/Z5YV22I+mlFP6sjc/Q==
Date: Sun, 22 Feb 2009 17:40:07 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [patch 1/2] slub: move min_partial to struct kmem_cache
Message-ID: <alpine.DEB.2.00.0902221710430.26165@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Although it allows for better cacheline use, it is unnecessary to save a
copy of the cache's min_partial value in each kmem_cache_node.

Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 include/linux/slub_def.h |    2 +-
 mm/slub.c                |   29 ++++++++++++++++-------------
 2 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -46,7 +46,6 @@ struct kmem_cache_cpu {
 struct kmem_cache_node {
 	spinlock_t list_lock;	/* Protect partial list and nr_partial */
 	unsigned long nr_partial;
-	unsigned long min_partial;
 	struct list_head partial;
 #ifdef CONFIG_SLUB_DEBUG
 	atomic_long_t nr_slabs;
@@ -89,6 +88,7 @@ struct kmem_cache {
 	void (*ctor)(void *);
 	int inuse;		/* Offset to metadata */
 	int align;		/* Alignment */
+	unsigned long min_partial;
 	const char *name;	/* Name (only for display!) */
 	struct list_head list;	/* List of slab caches */
 #ifdef CONFIG_SLUB_DEBUG
diff --git a/mm/slub.c b/mm/slub.c
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1335,7 +1335,7 @@ static struct page *get_any_partial(struct kmem_cache *s, gfp_t flags)
 		n = get_node(s, zone_to_nid(zone));
 
 		if (n && cpuset_zone_allowed_hardwall(zone, flags) &&
-				n->nr_partial > n->min_partial) {
+				n->nr_partial > s->min_partial) {
 			page = get_partial_node(n);
 			if (page)
 				return page;
@@ -1387,7 +1387,7 @@ static void unfreeze_slab(struct kmem_cache *s, struct page *page, int tail)
 		slab_unlock(page);
 	} else {
 		stat(c, DEACTIVATE_EMPTY);
-		if (n->nr_partial < n->min_partial) {
+		if (n->nr_partial < s->min_partial) {
 			/*
 			 * Adding an empty slab to the partial slabs in order
 			 * to avoid page allocator overhead. This slab needs
@@ -1928,17 +1928,6 @@ static void
 init_kmem_cache_node(struct kmem_cache_node *n, struct kmem_cache *s)
 {
 	n->nr_partial = 0;
-
-	/*
-	 * The larger the object size is, the more pages we want on the partial
-	 * list to avoid pounding the page allocator excessively.
-	 */
-	n->min_partial = ilog2(s->size);
-	if (n->min_partial < MIN_PARTIAL)
-		n->min_partial = MIN_PARTIAL;
-	else if (n->min_partial > MAX_PARTIAL)
-		n->min_partial = MAX_PARTIAL;
-
 	spin_lock_init(&n->list_lock);
 	INIT_LIST_HEAD(&n->partial);
 #ifdef CONFIG_SLUB_DEBUG
@@ -2181,6 +2170,15 @@ static int init_kmem_cache_nodes(struct kmem_cache *s, gfp_t gfpflags)
 }
 #endif
 
+static void calculate_min_partial(struct kmem_cache *s, unsigned long min)
+{
+	if (min < MIN_PARTIAL)
+		min = MIN_PARTIAL;
+	else if (min > MAX_PARTIAL)
+		min = MAX_PARTIAL;
+	s->min_partial = min;
+}
+
 /*
  * calculate_sizes() determines the order and the distribution of data within
  * a slab object.
@@ -2319,6 +2317,11 @@ static int kmem_cache_open(struct kmem_cache *s, gfp_t gfpflags,
 	if (!calculate_sizes(s, -1))
 		goto error;
 
+	/*
+	 * The larger the object size is, the more pages we want on the partial
+	 * list to avoid pounding the page allocator excessively.
+	 */
+	calculate_min_partial(s, ilog2(s->size));
 	s->refcount = 1;
 #ifdef CONFIG_NUMA
 	s->remote_node_defrag_ratio = 1000;
