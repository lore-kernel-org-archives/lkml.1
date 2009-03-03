Return-Path: <linux-kernel-owner+w=401wt.eu-S1755880AbZCCN3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880AbZCCN3b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 08:29:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753475AbZCCN3D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 08:29:03 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51058 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753216AbZCCN3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 08:29:01 -0500
Message-ID: <49AD3038.7010907@cn.fujitsu.com>
Date: Tue, 03 Mar 2009 21:27:20 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Nick Piggin <npiggin@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH -mm] slqb: cleanup for concatenating kmlist
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


move duplicate code into a inline functions.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/mm/slqb.c b/mm/slqb.c
index 07bf5b3..48bdf3b 100644
--- a/mm/slqb.c
+++ b/mm/slqb.c
@@ -307,6 +307,23 @@ static inline void set_freepointer(struct kmem_cache *s, void *object, void *fp)
 	*(void **)(object + s->offset) = fp;
 }
 
+static inline void __kmlist_concat(struct kmem_cache *s, struct kmlist *dest,
+		void **head, void **tail, int nr)
+{
+	if (!dest->head)
+		dest->head = head;
+	else
+		set_freepointer(s, dest->tail, head);
+	dest->tail = tail;
+	dest->nr += nr;
+}
+
+static inline void kmlist_concat(struct kmem_cache *s, struct kmlist *dest,
+		struct kmlist *src)
+{
+	__kmlist_concat(s, dest, src->head, src->tail, src->nr);
+}
+
 /* Loop over all objects in a slab */
 #define for_each_object(__p, __s, __addr) \
 	for (__p = (__addr); __p < (__addr) + (__s)->objects * (__s)->size;\
@@ -1152,8 +1169,7 @@ static void flush_free_list_all(struct kmem_cache *s, struct kmem_cache_list *l)
 static void claim_remote_free_list(struct kmem_cache *s,
 					struct kmem_cache_list *l)
 {
-	void **head, **tail;
-	int nr;
+	struct kmlist tmp_list;
 
 	if (!l->remote_free.list.nr)
 		return;
@@ -1161,29 +1177,20 @@ static void claim_remote_free_list(struct kmem_cache *s,
 	spin_lock(&l->remote_free.lock);
 
 	l->remote_free_check = 0;
-	head = l->remote_free.list.head;
+	tmp_list = l->remote_free.list;
+
 	l->remote_free.list.head = NULL;
-	tail = l->remote_free.list.tail;
 	l->remote_free.list.tail = NULL;
-	nr = l->remote_free.list.nr;
 	l->remote_free.list.nr = 0;
 
 	spin_unlock(&l->remote_free.lock);
 
-	VM_BUG_ON(!nr);
-
-	if (!l->freelist.nr) {
-		/* Get head hot for likely subsequent allocation or flush */
-		prefetchw(head);
-		l->freelist.head = head;
-	} else
-		set_freepointer(s, l->freelist.tail, head);
-	l->freelist.tail = tail;
+	VM_BUG_ON(!tmp_list.nr);
 
-	l->freelist.nr += nr;
+	kmlist_concat(s, &l->freelist, &tmp_list);
 
 	slqb_stat_inc(l, CLAIM_REMOTE_LIST);
-	slqb_stat_add(l, CLAIM_REMOTE_LIST_OBJECTS, nr);
+	slqb_stat_add(l, CLAIM_REMOTE_LIST_OBJECTS, tmp_list.nr);
 }
 #endif
 
@@ -1549,22 +1556,16 @@ static void flush_remote_free_cache(struct kmem_cache *s,
 
 	spin_lock(&dst->remote_free.lock);
 
-	if (!dst->remote_free.list.head)
-		dst->remote_free.list.head = src->head;
-	else
-		set_freepointer(s, dst->remote_free.list.tail, src->head);
-	dst->remote_free.list.tail = src->tail;
-
-	src->head = NULL;
-	src->tail = NULL;
-	src->nr = 0;
-
 	if (dst->remote_free.list.nr < slab_freebatch(s))
 		set = 1;
 	else
 		set = 0;
 
-	dst->remote_free.list.nr += nr;
+	kmlist_concat(s, &dst->remote_free.list, src);
+
+	src->head = NULL;
+	src->tail = NULL;
+	src->nr = 0;
 
 	if (unlikely(dst->remote_free.list.nr >= slab_freebatch(s) && set))
 		dst->remote_free_check = 1;
@@ -1593,13 +1594,8 @@ static noinline void slab_free_to_remote(struct kmem_cache *s,
 	}
 
 	r = &c->rlist;
-	if (!r->head)
-		r->head = object;
-	else
-		set_freepointer(s, r->tail, object);
 	set_freepointer(s, object, NULL);
-	r->tail = object;
-	r->nr++;
+	__kmlist_concat(s, r, object, object, 1);
 
 	if (unlikely(r->nr > slab_freebatch(s)))
 		flush_remote_free_cache(s, c);


