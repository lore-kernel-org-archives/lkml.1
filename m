Return-Path: <linux-kernel-owner+w=401wt.eu-S1760790AbZLKHpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760790AbZLKHpq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 02:45:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757186AbZLKHpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 02:45:43 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64676 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754572AbZLKHpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 02:45:43 -0500
Message-ID: <4B21F89A.7000801@cn.fujitsu.com>
Date: Fri, 11 Dec 2009 15:45:30 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: [PATCH 1/2] tracing: Define kmem_cache_alloc_notrace ifdef CONFIG_TRACING
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define kmem_trace_alloc_{,node}_notrace() if CONFIG_TRACING is
enabled, otherwise perf-kmem will show wrong stats ifndef
CONFIG_KMEM_TRACE, because a kmalloc() memory allocation may
be traced by both trace_kmalloc() and trace_kmem_cache_alloc().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 include/linux/slab_def.h |    4 ++--
 include/linux/slub_def.h |    4 ++--
 mm/slab.c                |    6 +++---
 mm/slub.c                |    4 ++--
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/linux/slab_def.h b/include/linux/slab_def.h
index 850d057..ca6b2b3 100644
--- a/include/linux/slab_def.h
+++ b/include/linux/slab_def.h
@@ -110,7 +110,7 @@ extern struct cache_sizes malloc_sizes[];
 void *kmem_cache_alloc(struct kmem_cache *, gfp_t);
 void *__kmalloc(size_t size, gfp_t flags);
 
-#ifdef CONFIG_KMEMTRACE
+#ifdef CONFIG_TRACING
 extern void *kmem_cache_alloc_notrace(struct kmem_cache *cachep, gfp_t flags);
 extern size_t slab_buffer_size(struct kmem_cache *cachep);
 #else
@@ -166,7 +166,7 @@ found:
 extern void *__kmalloc_node(size_t size, gfp_t flags, int node);
 extern void *kmem_cache_alloc_node(struct kmem_cache *, gfp_t flags, int node);
 
-#ifdef CONFIG_KMEMTRACE
+#ifdef CONFIG_TRACING
 extern void *kmem_cache_alloc_node_notrace(struct kmem_cache *cachep,
 					   gfp_t flags,
 					   int nodeid);
diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index 5ad70a6..1e14beb 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -217,7 +217,7 @@ static __always_inline struct kmem_cache *kmalloc_slab(size_t size)
 void *kmem_cache_alloc(struct kmem_cache *, gfp_t);
 void *__kmalloc(size_t size, gfp_t flags);
 
-#ifdef CONFIG_KMEMTRACE
+#ifdef CONFIG_TRACING
 extern void *kmem_cache_alloc_notrace(struct kmem_cache *s, gfp_t gfpflags);
 #else
 static __always_inline void *
@@ -266,7 +266,7 @@ static __always_inline void *kmalloc(size_t size, gfp_t flags)
 void *__kmalloc_node(size_t size, gfp_t flags, int node);
 void *kmem_cache_alloc_node(struct kmem_cache *, gfp_t flags, int node);
 
-#ifdef CONFIG_KMEMTRACE
+#ifdef CONFIG_TRACING
 extern void *kmem_cache_alloc_node_notrace(struct kmem_cache *s,
 					   gfp_t gfpflags,
 					   int node);
diff --git a/mm/slab.c b/mm/slab.c
index 7dfa481..9733bb4 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -490,7 +490,7 @@ static void **dbg_userword(struct kmem_cache *cachep, void *objp)
 
 #endif
 
-#ifdef CONFIG_KMEMTRACE
+#ifdef CONFIG_TRACING
 size_t slab_buffer_size(struct kmem_cache *cachep)
 {
 	return cachep->buffer_size;
@@ -3558,7 +3558,7 @@ void *kmem_cache_alloc(struct kmem_cache *cachep, gfp_t flags)
 }
 EXPORT_SYMBOL(kmem_cache_alloc);
 
-#ifdef CONFIG_KMEMTRACE
+#ifdef CONFIG_TRACING
 void *kmem_cache_alloc_notrace(struct kmem_cache *cachep, gfp_t flags)
 {
 	return __cache_alloc(cachep, flags, __builtin_return_address(0));
@@ -3621,7 +3621,7 @@ void *kmem_cache_alloc_node(struct kmem_cache *cachep, gfp_t flags, int nodeid)
 }
 EXPORT_SYMBOL(kmem_cache_alloc_node);
 
-#ifdef CONFIG_KMEMTRACE
+#ifdef CONFIG_TRACING
 void *kmem_cache_alloc_node_notrace(struct kmem_cache *cachep,
 				    gfp_t flags,
 				    int nodeid)
diff --git a/mm/slub.c b/mm/slub.c
index 4996fc7..4a89c3d 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1754,7 +1754,7 @@ void *kmem_cache_alloc(struct kmem_cache *s, gfp_t gfpflags)
 }
 EXPORT_SYMBOL(kmem_cache_alloc);
 
-#ifdef CONFIG_KMEMTRACE
+#ifdef CONFIG_TRACING
 void *kmem_cache_alloc_notrace(struct kmem_cache *s, gfp_t gfpflags)
 {
 	return slab_alloc(s, gfpflags, -1, _RET_IP_);
@@ -1775,7 +1775,7 @@ void *kmem_cache_alloc_node(struct kmem_cache *s, gfp_t gfpflags, int node)
 EXPORT_SYMBOL(kmem_cache_alloc_node);
 #endif
 
-#ifdef CONFIG_KMEMTRACE
+#ifdef CONFIG_TRACING
 void *kmem_cache_alloc_node_notrace(struct kmem_cache *s,
 				    gfp_t gfpflags,
 				    int node)
-- 
1.6.3

