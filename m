Return-Path: <linux-kernel-owner+w=401wt.eu-S1755944AbYHSSu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944AbYHSSu0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 14:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752544AbYHSSuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 14:50:12 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:33674 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbYHSSuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 14:50:10 -0400
Date: Tue, 19 Aug 2008 21:50:07 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <cl@linux-foundation.org>
cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, rdunlap@xenotime.net,
       mpm@selenic.com, tglx@linutronix.de, rostedt@goodmis.org,
       mathieu.desnoyers@polymtl.ca, tzanussi@gmail.com
Subject: Re: [PATCH 3/5] SLUB: Replace __builtin_return_address(0) with
 _RET_IP_.
In-Reply-To: <48AB0D69.4090703@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0808192149340.21961@sbz-30.cs.Helsinki.FI>
References: <1219167807-5407-1-git-send-email-eduard.munteanu@linux360.ro>
 <1219167807-5407-2-git-send-email-eduard.munteanu@linux360.ro>
 <1219167807-5407-3-git-send-email-eduard.munteanu@linux360.ro>
 <48AB0D69.4090703@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eduard - Gabriel Munteanu wrote:
> >  void *kmem_cache_alloc(struct kmem_cache *s, gfp_t gfpflags)
> >  {
> > -	return slab_alloc(s, gfpflags, -1, __builtin_return_address(0));
> > +	return slab_alloc(s, gfpflags, -1, (void *) _RET_IP_);
> >  }
 
On Tue, 19 Aug 2008, Christoph Lameter wrote:
> Could you get rid of the casts by changing the type of parameter of slab_alloc()?

Yeah. How about something like this?

		Pekka

>From f4d0f88f5b460afb2fd5dff75d4fcc0033e85a48 Mon Sep 17 00:00:00 2001
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Date: Tue, 19 Aug 2008 20:43:25 +0300
Subject: [PATCH] SLUB: Replace __builtin_return_address(0) with _RET_IP_.

This patch replaces __builtin_return_address(0) with _RET_IP_, since a
previous patch moved _RET_IP_ and _THIS_IP_ to include/linux/kernel.h and
they're widely available now. This makes for shorter and easier to read
code.

[penberg@cs.helsinki.fi: remove _RET_IP_ casts to void pointer]
Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 include/linux/slab.h |    4 ++--
 mm/slab.c            |    8 ++++----
 mm/slub.c            |   44 ++++++++++++++++++++++----------------------
 3 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 5ff9676..5ebb8df 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -225,7 +225,7 @@ static inline void *kmem_cache_alloc_node(struct kmem_cache *cachep,
  * request comes from.
  */
 #if defined(CONFIG_DEBUG_SLAB) || defined(CONFIG_SLUB)
-extern void *__kmalloc_track_caller(size_t, gfp_t, void*);
+extern void *__kmalloc_track_caller(size_t, gfp_t, unsigned long);
 #define kmalloc_track_caller(size, flags) \
 	__kmalloc_track_caller(size, flags, __builtin_return_address(0))
 #else
@@ -243,7 +243,7 @@ extern void *__kmalloc_track_caller(size_t, gfp_t, void*);
  * allocation request comes from.
  */
 #if defined(CONFIG_DEBUG_SLAB) || defined(CONFIG_SLUB)
-extern void *__kmalloc_node_track_caller(size_t, gfp_t, int, void *);
+extern void *__kmalloc_node_track_caller(size_t, gfp_t, int, unsigned long);
 #define kmalloc_node_track_caller(size, flags, node) \
 	__kmalloc_node_track_caller(size, flags, node, \
 			__builtin_return_address(0))
diff --git a/mm/slab.c b/mm/slab.c
index e76eee4..6a0e633 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3685,9 +3685,9 @@ void *__kmalloc_node(size_t size, gfp_t flags, int node)
 EXPORT_SYMBOL(__kmalloc_node);
 
 void *__kmalloc_node_track_caller(size_t size, gfp_t flags,
-		int node, void *caller)
+		int node, unsigned long caller)
 {
-	return __do_kmalloc_node(size, flags, node, caller);
+	return __do_kmalloc_node(size, flags, node, (void *)caller);
 }
 EXPORT_SYMBOL(__kmalloc_node_track_caller);
 #else
@@ -3729,9 +3729,9 @@ void *__kmalloc(size_t size, gfp_t flags)
 }
 EXPORT_SYMBOL(__kmalloc);
 
-void *__kmalloc_track_caller(size_t size, gfp_t flags, void *caller)
+void *__kmalloc_track_caller(size_t size, gfp_t flags, unsigned long caller)
 {
-	return __do_kmalloc(size, flags, caller);
+	return __do_kmalloc(size, flags, (void *)caller);
 }
 EXPORT_SYMBOL(__kmalloc_track_caller);
 
diff --git a/mm/slub.c b/mm/slub.c
index 4f5b961..804ca82 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -177,7 +177,7 @@ static LIST_HEAD(slab_caches);
  * Tracking user of a slab.
  */
 struct track {
-	void *addr;		/* Called from address */
+	unsigned long addr;	/* Called from address */
 	int cpu;		/* Was running on cpu */
 	int pid;		/* Pid context */
 	unsigned long when;	/* When did the operation occur */
@@ -366,7 +366,7 @@ static struct track *get_track(struct kmem_cache *s, void *object,
 }
 
 static void set_track(struct kmem_cache *s, void *object,
-				enum track_item alloc, void *addr)
+			enum track_item alloc, unsigned long addr)
 {
 	struct track *p;
 
@@ -390,8 +390,8 @@ static void init_tracking(struct kmem_cache *s, void *object)
 	if (!(s->flags & SLAB_STORE_USER))
 		return;
 
-	set_track(s, object, TRACK_FREE, NULL);
-	set_track(s, object, TRACK_ALLOC, NULL);
+	set_track(s, object, TRACK_FREE, 0);
+	set_track(s, object, TRACK_ALLOC, 0);
 }
 
 static void print_track(const char *s, struct track *t)
@@ -400,7 +400,7 @@ static void print_track(const char *s, struct track *t)
 		return;
 
 	printk(KERN_ERR "INFO: %s in %pS age=%lu cpu=%u pid=%d\n",
-		s, t->addr, jiffies - t->when, t->cpu, t->pid);
+		s, (void *)t->addr, jiffies - t->when, t->cpu, t->pid);
 }
 
 static void print_tracking(struct kmem_cache *s, void *object)
@@ -865,7 +865,7 @@ static void setup_object_debug(struct kmem_cache *s, struct page *page,
 }
 
 static int alloc_debug_processing(struct kmem_cache *s, struct page *page,
-						void *object, void *addr)
+					void *object, unsigned long addr)
 {
 	if (!check_slab(s, page))
 		goto bad;
@@ -905,7 +905,7 @@ bad:
 }
 
 static int free_debug_processing(struct kmem_cache *s, struct page *page,
-						void *object, void *addr)
+					void *object, unsigned long addr)
 {
 	if (!check_slab(s, page))
 		goto fail;
@@ -1498,8 +1498,8 @@ static inline int node_match(struct kmem_cache_cpu *c, int node)
  * we need to allocate a new slab. This is the slowest path since it involves
  * a call to the page allocator and the setup of a new slab.
  */
-static void *__slab_alloc(struct kmem_cache *s,
-		gfp_t gfpflags, int node, void *addr, struct kmem_cache_cpu *c)
+static void *__slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
+			  unsigned long addr, struct kmem_cache_cpu *c)
 {
 	void **object;
 	struct page *new;
@@ -1583,7 +1583,7 @@ debug:
  * Otherwise we can simply pick the next object from the lockless free list.
  */
 static __always_inline void *slab_alloc(struct kmem_cache *s,
-		gfp_t gfpflags, int node, void *addr)
+		gfp_t gfpflags, int node, unsigned long addr)
 {
 	void **object;
 	struct kmem_cache_cpu *c;
@@ -1612,14 +1612,14 @@ static __always_inline void *slab_alloc(struct kmem_cache *s,
 
 void *kmem_cache_alloc(struct kmem_cache *s, gfp_t gfpflags)
 {
-	return slab_alloc(s, gfpflags, -1, __builtin_return_address(0));
+	return slab_alloc(s, gfpflags, -1, _RET_IP_);
 }
 EXPORT_SYMBOL(kmem_cache_alloc);
 
 #ifdef CONFIG_NUMA
 void *kmem_cache_alloc_node(struct kmem_cache *s, gfp_t gfpflags, int node)
 {
-	return slab_alloc(s, gfpflags, node, __builtin_return_address(0));
+	return slab_alloc(s, gfpflags, node, _RET_IP_);
 }
 EXPORT_SYMBOL(kmem_cache_alloc_node);
 #endif
@@ -1633,7 +1633,7 @@ EXPORT_SYMBOL(kmem_cache_alloc_node);
  * handling required then we can return immediately.
  */
 static void __slab_free(struct kmem_cache *s, struct page *page,
-				void *x, void *addr, unsigned int offset)
+			void *x, unsigned long addr, unsigned int offset)
 {
 	void *prior;
 	void **object = (void *)x;
@@ -1703,7 +1703,7 @@ debug:
  * with all sorts of special processing.
  */
 static __always_inline void slab_free(struct kmem_cache *s,
-			struct page *page, void *x, void *addr)
+			struct page *page, void *x, unsigned long addr)
 {
 	void **object = (void *)x;
 	struct kmem_cache_cpu *c;
@@ -1730,7 +1730,7 @@ void kmem_cache_free(struct kmem_cache *s, void *x)
 
 	page = virt_to_head_page(x);
 
-	slab_free(s, page, x, __builtin_return_address(0));
+	slab_free(s, page, x, _RET_IP_);
 }
 EXPORT_SYMBOL(kmem_cache_free);
 
@@ -2657,7 +2657,7 @@ void *__kmalloc(size_t size, gfp_t flags)
 	if (unlikely(ZERO_OR_NULL_PTR(s)))
 		return s;
 
-	return slab_alloc(s, flags, -1, __builtin_return_address(0));
+	return slab_alloc(s, flags, -1, _RET_IP_);
 }
 EXPORT_SYMBOL(__kmalloc);
 
@@ -2685,7 +2685,7 @@ void *__kmalloc_node(size_t size, gfp_t flags, int node)
 	if (unlikely(ZERO_OR_NULL_PTR(s)))
 		return s;
 
-	return slab_alloc(s, flags, node, __builtin_return_address(0));
+	return slab_alloc(s, flags, node, _RET_IP_);
 }
 EXPORT_SYMBOL(__kmalloc_node);
 #endif
@@ -2742,7 +2742,7 @@ void kfree(const void *x)
 		put_page(page);
 		return;
 	}
-	slab_free(page->slab, page, object, __builtin_return_address(0));
+	slab_free(page->slab, page, object, _RET_IP_);
 }
 EXPORT_SYMBOL(kfree);
 
@@ -3198,7 +3198,7 @@ static struct notifier_block __cpuinitdata slab_notifier = {
 
 #endif
 
-void *__kmalloc_track_caller(size_t size, gfp_t gfpflags, void *caller)
+void *__kmalloc_track_caller(size_t size, gfp_t gfpflags, unsigned long caller)
 {
 	struct kmem_cache *s;
 
@@ -3214,7 +3214,7 @@ void *__kmalloc_track_caller(size_t size, gfp_t gfpflags, void *caller)
 }
 
 void *__kmalloc_node_track_caller(size_t size, gfp_t gfpflags,
-					int node, void *caller)
+					int node, unsigned long caller)
 {
 	struct kmem_cache *s;
 
@@ -3425,7 +3425,7 @@ static void resiliency_test(void) {};
 
 struct location {
 	unsigned long count;
-	void *addr;
+	unsigned long addr;
 	long long sum_time;
 	long min_time;
 	long max_time;
@@ -3473,7 +3473,7 @@ static int add_location(struct loc_track *t, struct kmem_cache *s,
 {
 	long start, end, pos;
 	struct location *l;
-	void *caddr;
+	unsigned long caddr;
 	unsigned long age = jiffies - track->when;
 
 	start = -1;
-- 
1.5.4.3

