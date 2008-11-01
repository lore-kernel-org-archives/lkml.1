Return-Path: <linux-kernel-owner+w=401wt.eu-S1752602AbYKAQA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602AbYKAQA1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 12:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751403AbYKAQAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 12:00:13 -0400
Received: from lazybastard.de ([212.112.238.170]:48936 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbYKAQAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 12:00:10 -0400
Date: Sat, 1 Nov 2008 16:59:58 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC] B+Tree library V2
Message-ID: <20081101155958.GA28776@logfs.org>
References: <20081026124643.GA1328@logfs.org> <1225449314.3535.23.camel@johannes.berg> <20081031112651.GD18182@logfs.org> <1225452761.3535.28.camel@johannes.berg> <20081031125453.GE18182@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081031125453.GE18182@logfs.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 October 2008 13:54:53 +0100, Jörn Engel wrote:
> On Fri, 31 October 2008 12:32:41 +0100, Johannes Berg wrote:
> > 
> > I guess not then for now, unless one of us wants to implement
> > resizing... I'll look for replacements another time, nobody has
> > complained yet about the huge hash table :)
> 
> I actually have something that compiles now.  It still needs a bit of
> water and soap before I'd consider it presentable, but turned out to be
> less complicated than expected.

Not only compiles, also survives muserspace test harness and no longer
looks like a bulldog with lipstick.

You might note that "less complicated than expected" means I'm still
bending the rules a bit.  I only merge underpopulated nodes with
neighbours.  If the neighbour is too full for a merge I don't steal
entries.  That bit is for someone else to implement. :)

Jörn

-- 
 on a false concept. This concept is that
people actually want to look at source code.
-- Rob Enderle

diff --git a/include/linux/btree.h b/include/linux/btree.h
new file mode 100644
index 0000000..d56a691
--- /dev/null
+++ b/include/linux/btree.h
@@ -0,0 +1,272 @@
+#ifndef BTREE_H
+#define BTREE_H
+
+#include <linux/kernel.h>
+#include <linux/mempool.h>
+
+/*
+ * B+Tree node format:
+ * [key0, key1, ..., keyN] [val0, val1, ..., valN]
+ * Each key is an array of unsigned longs, head->no_longs in total.
+ * Total number of keys and vals (N) is head->no_pairs.
+ */
+
+struct btree_head {
+	unsigned long *node;
+	mempool_t *mempool;
+	int height;
+	gfp_t gfp_mask;
+};
+
+struct btree_geo {
+	int keylen;
+	int no_pairs;
+};
+extern struct btree_geo btree_geo32;
+extern struct btree_geo btree_geo64;
+extern struct btree_geo btree_geo128;
+
+struct btree_headl { struct btree_head h; };
+struct btree_head32 { struct btree_head h; };
+struct btree_head64 { struct btree_head h; };
+struct btree_head128 { struct btree_head h; };
+
+/*
+ * These couple of functions are all there is to it.  The rest of this header
+ * consists only of wrappers that try to add some typesafety, make the code
+ * a little self-documenting and generally be nice to people.
+ */
+void *btree_alloc(gfp_t gfp_mask, void *pool_data);
+void btree_free(void *element, void *pool_data);
+void btree_init(struct btree_head *head, mempool_t *mempool, gfp_t gfp);
+void *btree_lookup(struct btree_head *head, struct btree_geo *geo,
+		unsigned long *key);
+int btree_insert(struct btree_head *head, struct btree_geo *geo,
+		unsigned long *key, void *val);
+void *btree_remove(struct btree_head *head, struct btree_geo *geo,
+		unsigned long *key);
+int btree_merge(struct btree_head *target, struct btree_head *victim,
+		struct btree_geo *geo, unsigned long *duplicate);
+unsigned long *btree_last(struct btree_head *head, struct btree_geo *geo);
+size_t btree_visitor(struct btree_head *head, struct btree_geo *geo,
+		long opaque,
+		void (*func)(void *elem, long opaque, unsigned long *key,
+			size_t index, void *func2), void *func2);
+size_t btree_grim_visitor(struct btree_head *head, struct btree_geo *geo,
+		long opaque,
+		void (*func)(void *elem, long opaque, unsigned long *key,
+			size_t index, void *func2), void *func2);
+
+/* key is unsigned long */
+static inline void btree_initl(struct btree_headl *head, mempool_t *mempool,
+		gfp_t gfp)
+{
+	btree_init(&head->h, mempool, gfp);
+}
+
+static inline void *btree_lookupl(struct btree_headl *head, unsigned long key)
+{
+	return btree_lookup(&head->h, &btree_geo32, &key);
+}
+
+static inline int btree_insertl(struct btree_headl *head, unsigned long key,
+		void *val)
+{
+	return btree_insert(&head->h, &btree_geo32, &key, val);
+}
+
+static inline void *btree_removel(struct btree_headl *head, unsigned long key)
+{
+	return btree_remove(&head->h, &btree_geo32, &key);
+}
+
+static inline int btree_mergel(struct btree_headl *target,
+		struct btree_headl *victim)
+{
+	unsigned long scratch;
+
+	return btree_merge(&target->h, &victim->h, &btree_geo32, &scratch);
+}
+
+void visitorl(void *elem, long opaque, unsigned long *key, size_t index,
+		void *__func);
+
+typedef void (*visitorl_t)(void *elem, long opaque, unsigned long key,
+		size_t index);
+
+static inline size_t btree_visitorl(struct btree_headl *head, long opaque,
+		visitorl_t func2)
+{
+	return btree_visitor(&head->h, &btree_geo32, opaque, visitorl, func2);
+}
+
+static inline size_t btree_grim_visitorl(struct btree_headl *head, long opaque,
+		visitorl_t func2)
+{
+	return btree_grim_visitor(&head->h, &btree_geo32, opaque, visitorl, func2);
+}
+
+/* key is u32 */
+static inline void btree_init32(struct btree_head32 *head, mempool_t *mempool,
+		gfp_t gfp)
+{
+	btree_init(&head->h, mempool, gfp);
+}
+
+static inline void *btree_lookup32(struct btree_head32 *head, u32 key)
+{
+	return btree_lookup(&head->h, &btree_geo32, (unsigned long *)&key);
+}
+
+static inline int btree_insert32(struct btree_head32 *head, u32 key,
+		void *val)
+{
+	return btree_insert(&head->h, &btree_geo32, (unsigned long *)&key, val);
+}
+
+static inline void *btree_remove32(struct btree_head32 *head, u32 key)
+{
+	return btree_remove(&head->h, &btree_geo32, (unsigned long *)&key);
+}
+
+static inline int btree_merge32(struct btree_head32 *target,
+		struct btree_head32 *victim)
+{
+	unsigned long scratch;
+
+	return btree_merge(&target->h, &victim->h, &btree_geo32, &scratch);
+}
+
+void visitor32(void *elem, long opaque, unsigned long *__key, size_t index,
+		void *__func);
+
+typedef void (*visitor32_t)(void *elem, long opaque, u32 key, size_t index);
+
+static inline size_t btree_visitor32(struct btree_head32 *head, long opaque,
+		visitor32_t func2)
+{
+	return btree_visitor(&head->h, &btree_geo32, opaque, visitor32, func2);
+}
+
+static inline size_t btree_grim_visitor32(struct btree_head32 *head, long opaque,
+		visitor32_t func2)
+{
+	return btree_grim_visitor(&head->h, &btree_geo32, opaque, visitor32, func2);
+}
+
+/* key is u64 */
+static inline void btree_init64(struct btree_head64 *head, mempool_t *mempool,
+		gfp_t gfp)
+{
+	btree_init(&head->h, mempool, gfp);
+}
+
+static inline void *btree_lookup64(struct btree_head64 *head, u64 key)
+{
+	return btree_lookup(&head->h, &btree_geo64, (unsigned long *)&key);
+}
+
+static inline int btree_insert64(struct btree_head64 *head, u64 key,
+		void *val)
+{
+	return btree_insert(&head->h, &btree_geo64, (unsigned long *)&key, val);
+}
+
+static inline void *btree_remove64(struct btree_head64 *head, u64 key)
+{
+	return btree_remove(&head->h, &btree_geo64, (unsigned long *)&key);
+}
+
+static inline int btree_merge64(struct btree_head64 *target,
+		struct btree_head64 *victim)
+{
+	u64 scratch;
+
+	return btree_merge(&target->h, &victim->h, &btree_geo64,
+			(unsigned long *)&scratch);
+}
+
+void visitor64(void *elem, long opaque, unsigned long *__key, size_t index,
+		void *__func);
+
+typedef void (*visitor64_t)(void *elem, long opaque, u64 key, size_t index);
+
+static inline size_t btree_visitor64(struct btree_head64 *head, long opaque,
+		visitor64_t func2)
+{
+	return btree_visitor(&head->h, &btree_geo64, opaque, visitor64, func2);
+}
+
+static inline size_t btree_grim_visitor64(struct btree_head64 *head, long opaque,
+		visitor64_t func2)
+{
+	return btree_grim_visitor(&head->h, &btree_geo64, opaque, visitor64, func2);
+}
+
+/* key is 128bit (two u64) */
+static inline void btree_init128(struct btree_head128 *head, mempool_t *mempool,
+		gfp_t gfp)
+{
+	btree_init(&head->h, mempool, gfp);
+}
+
+static inline void *btree_lookup128(struct btree_head128 *head, u64 k1, u64 k2)
+{
+	u64 key[2] = {k1, k2};
+	return btree_lookup(&head->h, &btree_geo128, (unsigned long *)&key);
+}
+
+static inline int btree_insert128(struct btree_head128 *head, u64 k1, u64 k2,
+		void *val)
+{
+	u64 key[2] = {k1, k2};
+	return btree_insert(&head->h, &btree_geo128, (unsigned long *)&key, val);
+}
+
+static inline void *btree_remove128(struct btree_head128 *head, u64 k1, u64 k2)
+{
+	u64 key[2] = {k1, k2};
+	return btree_remove(&head->h, &btree_geo128, (unsigned long *)&key);
+}
+
+static inline void btree_last128(struct btree_head128 *head, u64 *k1, u64 *k2)
+{
+	u64 *key = (u64 *)btree_last(&head->h, &btree_geo128);
+
+	if (key) {
+		*k1 = key[0];
+		*k2 = key[1];
+	} else {
+		*k1 = 0;
+		*k2 = 0;
+	}
+}
+
+static inline int btree_merge128(struct btree_head128 *target,
+		struct btree_head128 *victim)
+{
+	u64 scratch[2];
+
+	return btree_merge(&target->h, &victim->h, &btree_geo128,
+			(unsigned long *)scratch);
+}
+
+void visitor128(void *elem, long opaque, unsigned long *__key, size_t index,
+		void *__func);
+
+typedef void (*visitor128_t)(void *elem, long opaque, u64 key1, u64 key2,
+		size_t index);
+
+static inline size_t btree_visitor128(struct btree_head128 *head, long opaque,
+		visitor128_t func2)
+{
+	return btree_visitor(&head->h, &btree_geo128, opaque, visitor128, func2);
+}
+
+static inline size_t btree_grim_visitor128(struct btree_head128 *head, long opaque,
+		visitor128_t func2)
+{
+	return btree_grim_visitor(&head->h, &btree_geo128, opaque, visitor128, func2);
+}
+
+#endif
diff --git a/lib/Kconfig b/lib/Kconfig
index 8cc8e87..7614216 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -129,6 +129,9 @@ config TEXTSEARCH_FSM
 config PLIST
 	boolean
 
+config BTREE
+	boolean
+
 config HAS_IOMEM
 	boolean
 	depends on !NO_IOMEM
diff --git a/lib/Makefile b/lib/Makefile
index 2d7001b..b1eed60 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -34,6 +34,7 @@ lib-$(CONFIG_GENERIC_FIND_NEXT_BIT) += find_next_bit.o
 obj-$(CONFIG_GENERIC_HWEIGHT) += hweight.o
 obj-$(CONFIG_LOCK_KERNEL) += kernel_lock.o
 obj-$(CONFIG_PLIST) += plist.o
+obj-$(CONFIG_BTREE) += btree.o
 obj-$(CONFIG_DEBUG_PREEMPT) += smp_processor_id.o
 obj-$(CONFIG_DEBUG_LIST) += list_debug.o
 
diff --git a/lib/btree.c b/lib/btree.c
new file mode 100644
index 0000000..9562356
--- /dev/null
+++ b/lib/btree.c
@@ -0,0 +1,668 @@
+/*
+ * lib/btree.c	- Simple In-memory B+Tree
+ *
+ * As should be obvious for Linux kernel code, license is GPLv2
+ *
+ * Copyright (c) 2007-2008 Joern Engel <joern@logfs.org>
+ * Bits and pieces stolen from Peter Zijlstra's code, which is
+ * Copyright 2007, Red Hat Inc. Peter Zijlstra <pzijlstr@redhat.com>
+ * GPLv2
+ *
+ * see http://programming.kicks-ass.net/kernel-patches/vma_lookup/btree.patch
+ *
+ * A relatively simple B+Tree implementation.  I have written it as a learning
+ * excercise to understand how B+Trees work.  Turned out to be useful as well.
+ *
+ * B+Trees can be used similar to Linux radix trees (which don't have anything
+ * in common with textbook radix trees, beware).  Prerequisite for them working
+ * well is that access to a random tree node is much faster than a large number
+ * of operations within each node.
+ *
+ * Disks have fulfilled the prerequisite for a long time.  More recently DRAM
+ * has gained similar properties, as memory access times, when measured in cpu
+ * cycles, have increased.  Cacheline sizes have increased as well, which also
+ * helps B+Trees.
+ *
+ * Compared to radix trees, B+Trees are more efficient when dealing with a
+ * sparsely populated address space.  Between 25% and 50% of the memory is
+ * occupied with valid pointers.  When densely populated, radix trees contain
+ * ~98% pointers - hard to beat.  Very sparse radix trees contain only ~2%
+ * pointers.
+ *
+ * This particular implementation stores pointers identified by a long value.
+ * Storing NULL pointers is illegal, lookup will return NULL when no entry
+ * was found.
+ *
+ * Two tricks were used that are not commonly found in textbooks.  First, the
+ * lowest values are to the right, not to the left.  All used slots within a
+ * node are on the left, all unused slots contain NUL values.  Most operations
+ * simply loop once over all slots and terminate on the first NUL.
+ *
+ * Second trick is to special-case the key "0" or NUL.  As seen above, this
+ * value indicates an unused slot, so such a value should not be stored in the
+ * tree itself.  Instead it is stored in the null_ptr field in the btree_head.
+ */
+
+#include <linux/btree.h>
+#include <linux/cache.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+
+#define MAX(a, b) ((a) > (b) ? (a) : (b))
+#define NODESIZE MAX(L1_CACHE_BYTES, 128)
+
+struct btree_geo btree_geo32 = {
+	.keylen = 1,
+	.no_pairs = NODESIZE / sizeof(long) / 2,
+};
+
+#define LONG_PER_U64 (64 / BITS_PER_LONG)
+struct btree_geo btree_geo64 = {
+	.keylen = LONG_PER_U64,
+	.no_pairs = NODESIZE / sizeof(long) / (1 + LONG_PER_U64),
+};
+
+struct btree_geo btree_geo128 = {
+	.keylen = 2 * LONG_PER_U64,
+	.no_pairs = NODESIZE / sizeof(long) / (1 + 2 * LONG_PER_U64),
+};
+
+static struct kmem_cache *btree_cachep;
+
+void *btree_alloc(gfp_t gfp_mask, void *pool_data)
+{
+	return kmem_cache_alloc(btree_cachep, gfp_mask);
+}
+
+void btree_free(void *element, void *pool_data)
+{
+	kmem_cache_free(btree_cachep, element);
+}
+
+static unsigned long *btree_node_alloc(struct btree_head *head)
+{
+	unsigned long *node;
+
+	node = mempool_alloc(head->mempool, head->gfp_mask);
+	memset(node, 0, NODESIZE);
+	return node;
+}
+
+static int longcmp(const unsigned long *l1, const unsigned long *l2, size_t n)
+{
+	size_t i;
+
+	for (i = 0; i < n; i++) {
+		if (l1[i] < l2[i])
+			return -1;
+		if (l1[i] > l2[i])
+			return 1;
+	}
+	return 0;
+}
+
+static unsigned long *longcpy(unsigned long *dest, const unsigned long *src,
+		size_t n)
+{
+	size_t i;
+
+	for (i = 0; i < n; i++)
+		dest[i] = src[i];
+	return dest;
+}
+
+static unsigned long *longset(unsigned long *s, unsigned long c, size_t n)
+{
+	size_t i;
+
+	for (i = 0; i < n; i++)
+		s[i] = c;
+	return s;
+}
+
+/*
+ * B+Tree node format:
+ * [key0, key1, ..., keyN] [val0, val1, ..., valN]
+ * Each key is an array of unsigned longs, head->keylen in total.
+ * Total number of keys and vals (N) is head->no_pairs.
+ */
+
+static unsigned long *bkey(struct btree_geo *geo, unsigned long *node, int n)
+{
+	return &node[n * geo->keylen];
+}
+
+static unsigned long bval(struct btree_geo *geo, unsigned long *node, int n)
+{
+	return node[geo->no_pairs * geo->keylen + n];
+}
+
+static void setkey(struct btree_geo *geo, unsigned long *node,
+		unsigned long *key, int n)
+{
+	longcpy(bkey(geo, node, n), key, geo->keylen);
+}
+
+static void setval(struct btree_geo *geo, unsigned long *node,
+		unsigned long val, int n)
+{
+	node[geo->no_pairs * geo->keylen + n] = val;
+}
+
+static void clearpair(struct btree_geo *geo, unsigned long *node, int n)
+{
+	longset(bkey(geo, node, n), 0, geo->keylen);
+	node[geo->no_pairs * geo->keylen + n] = 0;
+}
+
+#if 0
+static void dumpkey(struct btree_geo *geo, unsigned long *key)
+{
+	int k;
+
+	printk("(%lx", key[0]);
+	for (k = 1; k < geo->keylen; k++)
+		printk(",%lx", key[k]);
+	printk(")");
+}
+
+static void dumpnode(struct btree_geo *geo, unsigned long *node)
+{
+	int i;
+	unsigned long *key;
+
+	printk("%p: ", node);
+	for (i = 0; i < geo->no_pairs; i++) {
+		key = bkey(geo, node, i);
+		dumpkey(geo, key);
+		printk(" %lx  ", bval(geo, node, i));
+	}
+	printk("\n");
+}
+
+static void __dumptree(struct btree_head *head, struct btree_geo *geo,
+		unsigned long *node, int height)
+{
+	int i;
+	unsigned long *child;
+
+	if (!height)
+		return;
+
+	printk("%2x ", height);
+	dumpnode(geo, node);
+	for (i = 0; i < geo->no_pairs; i++) {
+		child = (void *)bval(geo, node, i);
+		if (!child)
+			return;
+		__dumptree(head, geo, child, height - 1);
+	}
+}
+
+static void dumptree(struct btree_head *head, struct btree_geo *geo)
+{
+	__dumptree(head, geo, head->node, head->height);
+}
+#endif
+
+static inline void __btree_init(struct btree_head *head)
+{
+	head->node = NULL;
+	head->height = 0;
+}
+
+void btree_init(struct btree_head *head, mempool_t *mempool, gfp_t gfp)
+{
+	__btree_init(head);
+	head->mempool = mempool;
+	head->gfp_mask = gfp;
+}
+
+unsigned long *btree_last(struct btree_head *head, struct btree_geo *geo)
+{
+	int height = head->height;
+	unsigned long *node = head->node;
+
+	if (height == 0)
+		return NULL;
+
+	for ( ; height > 1; height--)
+		node = (unsigned long *)bval(geo, node, 0);
+
+	return bkey(geo, node, 0);
+}
+
+static int keycmp(struct btree_geo *geo, unsigned long *node, int pos,
+		unsigned long *key)
+{
+	return longcmp(bkey(geo, node, pos), key, geo->keylen);
+}
+
+void *btree_lookup(struct btree_head *head, struct btree_geo *geo,
+		unsigned long *key)
+{
+	int i, height = head->height;
+	unsigned long *node = head->node;
+
+	if (height == 0)
+		return NULL;
+
+	for ( ; height > 1; height--) {
+		for (i = 0; i < geo->no_pairs; i++)
+			if (keycmp(geo, node, i, key) <= 0)
+				break;
+		if (i == geo->no_pairs)
+			return NULL;
+		node = (unsigned long *)bval(geo, node, i);
+		if (!node)
+			return NULL;
+	}
+
+	if (!node)
+		return NULL;
+
+	for (i = 0; i < geo->no_pairs; i++)
+		if (keycmp(geo, node, i, key) == 0)
+			return (void *)bval(geo, node, i);
+	return NULL;
+}
+
+static int getpos(struct btree_geo *geo, unsigned long *node,
+		unsigned long *key)
+{
+	int i;
+
+	for (i = 0; i < geo->no_pairs; i++) {
+		if (keycmp(geo, node, i, key) <= 0)
+			break;
+	}
+	return i;
+}
+
+static int getfill(struct btree_geo *geo, unsigned long *node, int start)
+{
+	int i;
+
+	for (i = start; i < geo->no_pairs; i++)
+		if (bval(geo, node, i) == 0)
+			break;
+	return i;
+}
+
+/*
+ * locate the correct leaf node in the btree
+ */
+static unsigned long *find_level(struct btree_head *head, struct btree_geo *geo,
+		unsigned long *key, int level)
+{
+	unsigned long *node = head->node;
+	int i, height;
+
+	for (height = head->height; height > level; height--) {
+		for (i = 0; i < geo->no_pairs; i++)
+			if (keycmp(geo, node, i, key) <= 0)
+				break;
+
+		if ((i == geo->no_pairs) || !bval(geo, node, i)) {
+			/* right-most key is too large, update it */
+			/* FIXME: If the right-most key on higher levels is
+			 * always zero, this wouldn't be necessary. */
+			i--;
+			setkey(geo, node, key, i);
+		}
+		BUG_ON(i < 0);
+		node = (unsigned long *)bval(geo, node, i);
+	}
+	BUG_ON(!node);
+	return node;
+}
+
+static int btree_grow(struct btree_head *head, struct btree_geo *geo)
+{
+	unsigned long *node;
+	int fill;
+
+	node = btree_node_alloc(head);
+	if (!node)
+		return -ENOMEM;
+	if (head->node) {
+		fill = getfill(geo, head->node, 0);
+		setkey(geo, node, bkey(geo, head->node, fill - 1), 0);
+		setval(geo, node, (unsigned long)head->node, 0);
+	}
+	head->node = node;
+	head->height++;
+	return 0;
+}
+
+static void btree_shrink(struct btree_head *head, struct btree_geo *geo)
+{
+	unsigned long *node;
+	int fill;
+
+	if (head->height <= 1)
+		return;
+
+	node = head->node;
+	fill = getfill(geo, node, 0);
+	BUG_ON(fill > 1);
+	head->node = (unsigned long *)bval(geo, node, 0);
+	head->height--;
+	mempool_free(node, head->mempool);
+}
+
+static int btree_insert_level(struct btree_head *head, struct btree_geo *geo,
+		unsigned long *key, unsigned long val, int level)
+{
+	unsigned long *node;
+	int i, pos, fill, err;
+
+	BUG_ON(!val);
+	if (head->height < level) {
+		err = btree_grow(head, geo);
+		if (err)
+			return err;
+	}
+
+retry:
+	node = find_level(head, geo, key, level);
+	pos = getpos(geo, node, key);
+	fill = getfill(geo, node, pos);
+	/* two identical keys are not allowed */
+	BUG_ON(pos < fill && keycmp(geo, node, pos, key) == 0);
+
+	if (fill == geo->no_pairs) {
+		/* need to split node */
+		unsigned long *new;
+
+		new = btree_node_alloc(head);
+		if (!new)
+			return -ENOMEM;
+		err = btree_insert_level(head, geo,
+				bkey(geo, node, fill / 2 - 1),
+				(unsigned long)new, level + 1);
+		if (err) {
+			mempool_free(new, head->mempool);
+			return err;
+		}
+		for (i = 0; i < fill / 2; i++) {
+			setkey(geo, new, bkey(geo, node, i), i);
+			setval(geo, new, bval(geo, node, i), i);
+			setkey(geo, node, bkey(geo, node, i + fill / 2), i);
+			setval(geo, node, bval(geo, node, i + fill / 2), i);
+			clearpair(geo, node, i + fill / 2);
+		}
+		if (fill & 1) {
+			setkey(geo, node, bkey(geo, node, fill - 1), i);
+			setval(geo, node, bval(geo, node, fill - 1), i);
+			clearpair(geo, node, fill - 1);
+		}
+		goto retry;
+	}
+	BUG_ON(fill >= geo->no_pairs);
+
+	/* shift and insert */
+	for (i = fill; i > pos; i--) {
+		setkey(geo, node, bkey(geo, node, i - 1), i);
+		setval(geo, node, bval(geo, node, i - 1), i);
+	}
+	setkey(geo, node, key, pos);
+	setval(geo, node, val, pos);
+
+	return 0;
+}
+
+int btree_insert(struct btree_head *head, struct btree_geo *geo,
+		unsigned long *key, void *val)
+{
+	return btree_insert_level(head, geo, key, (unsigned long)val, 1);
+}
+
+static void *btree_remove_level(struct btree_head *head, struct btree_geo *geo,
+		unsigned long *key, int level);
+static void merge(struct btree_head *head, struct btree_geo *geo, int level,
+		unsigned long *left, int lfill,
+		unsigned long *right, int rfill,
+		unsigned long *parent, int lpos)
+{
+	int i;
+
+	for (i = 0; i < rfill; i++) {
+		/* Move all keys to the left */
+		setkey(geo, left, bkey(geo, right, i), lfill + i);
+		setval(geo, left, bval(geo, right, i), lfill + i);
+	}
+	/* Exchange left and right child in parent */
+	setval(geo, parent, (unsigned long)right, lpos);
+	setval(geo, parent, (unsigned long)left, lpos + 1);
+	/* Remove left (formerly right) child from parent */
+	btree_remove_level(head, geo, bkey(geo, parent, lpos), level + 1);
+	mempool_free(right, head->mempool);
+}
+
+static void rebalance(struct btree_head *head, struct btree_geo *geo,
+		unsigned long *key, int level, unsigned long *child, int fill)
+{
+	unsigned long *parent, *left = NULL, *right = NULL;
+	int i, no_left, no_right;
+
+	parent = find_level(head, geo, key, level + 1);
+	i = getpos(geo, parent, key);
+	BUG_ON(bval(geo, parent, i) != (unsigned long)child);
+
+	if (i > 0) {
+		left = (unsigned long *)bval(geo, parent, i - 1);
+		no_left = getfill(geo, left, 0);
+		if (fill + no_left <= geo->no_pairs) {
+			merge(head, geo, level,
+					left, no_left,
+					child, fill,
+					parent, i - 1);
+			return;
+		}
+	}
+	if (i + 1 < getfill(geo, parent, i)) {
+		right = (unsigned long *)bval(geo, parent, i + 1);
+		no_right = getfill(geo, right, 0);
+		if (fill + no_right <= geo->no_pairs) {
+			merge(head, geo, level,
+					child, fill,
+					right, no_right,
+					parent, i);
+			return;
+		}
+	}
+	/*
+	 * We could also try to steal one entry from the left or right
+	 * neighbor.  By not doing so we changed the invariant from
+	 * "all nodes are at least half full" to "no two neighboring
+	 * nodes can be merged".  Which means that the average fill of
+	 * all nodes is still half or better.
+	 */
+}
+
+static void *btree_remove_level(struct btree_head *head, struct btree_geo *geo,
+		unsigned long *key, int level)
+{
+	unsigned long *node;
+	int i, pos, fill;
+	void *ret;
+
+	if (level > head->height) {
+		/* we recursed all the way up */
+		head->height = 0;
+		head->node = NULL;
+		return NULL;
+	}
+
+	node = find_level(head, geo, key, level);
+	pos = getpos(geo, node, key);
+	fill = getfill(geo, node, pos);
+	if ((level == 1) && (keycmp(geo, node, pos, key) != 0))
+		return NULL;
+	ret = (void *)bval(geo, node, pos);
+
+	/* remove and shift */
+	for (i = pos; i < fill - 1; i++) {
+		setkey(geo, node, bkey(geo, node, i + 1), i);
+		setval(geo, node, bval(geo, node, i + 1), i);
+	}
+	clearpair(geo, node, fill - 1);
+
+	if (fill - 1 < geo->no_pairs / 2) {
+		if (level < head->height)
+			rebalance(head, geo, key, level, node, fill - 1);
+		else if (fill - 1 == 1)
+			btree_shrink(head, geo);
+	}
+
+	return ret;
+}
+
+void *btree_remove(struct btree_head *head, struct btree_geo *geo,
+		unsigned long *key)
+{
+	if (head->height == 0)
+		return NULL;
+
+	return btree_remove_level(head, geo, key, 1);
+}
+
+int btree_merge(struct btree_head *target, struct btree_head *victim,
+		struct btree_geo *geo, unsigned long *duplicate)
+{
+	unsigned long *key;
+	void *val;
+	int err;
+
+	BUG_ON(target == victim);
+
+	if (!(target->node)) {
+		/* target is empty, just copy fields over */
+		target->node = victim->node;
+		target->height = victim->height;
+		__btree_init(victim);
+		return 0;
+	}
+
+	for (;;) {
+		key = btree_last(victim, geo);
+		if (!key)
+			break;
+		val = btree_lookup(victim, geo, key);
+		err = btree_insert(target, geo, key, val);
+		if (err)
+			return err;
+		/* We must make a copy of the key, as the original will get
+		 * mangled inside btree_remove. */
+		longcpy(duplicate, key, geo->keylen);
+		btree_remove(victim, geo, duplicate);
+	}
+	return 0;
+}
+
+static size_t __btree_for_each(struct btree_head *head, struct btree_geo *geo,
+		unsigned long *node, long opaque,
+		void (*func)(void *elem, long opaque,
+			unsigned long *key, size_t index, void *func2),
+		void *func2, int reap, int height, size_t count)
+{
+	int i;
+	unsigned long *child;
+
+	for (i = 0; i < geo->no_pairs; i++) {
+		child = (void *)bval(geo, node, i);
+		if (!child)
+			break;
+		if (height > 1)
+			count = __btree_for_each(head, geo, child, opaque,
+					func, func2, reap, height - 1, count);
+		else
+			func(child, opaque, bkey(geo, node, i), count++,
+					func2);
+	}
+	if (reap)
+		mempool_free(node, head->mempool);
+	return count;
+}
+
+static void empty(void *elem, long opaque, unsigned long *key, size_t index,
+		void *func2)
+{
+}
+
+void visitorl(void *elem, long opaque, unsigned long *key, size_t index,
+		void *__func)
+{
+	visitorl_t func = __func;
+
+	func(elem, opaque, *key, index);
+}
+
+void visitor32(void *elem, long opaque, unsigned long *__key, size_t index,
+		void *__func)
+{
+	visitor32_t func = __func;
+	u32 *key = (void *)__key;
+
+	func(elem, opaque, *key, index);
+}
+
+void visitor64(void *elem, long opaque, unsigned long *__key, size_t index,
+		void *__func)
+{
+	visitor64_t func = __func;
+	u64 *key = (void *)__key;
+
+	func(elem, opaque, *key, index);
+}
+
+void visitor128(void *elem, long opaque, unsigned long *__key, size_t index,
+		void *__func)
+{
+	visitor128_t func = __func;
+	u64 *key = (void *)__key;
+
+	func(elem, opaque, key[0], key[1], index);
+}
+
+size_t btree_visitor(struct btree_head *head, struct btree_geo *geo,
+		long opaque,
+		void (*func)(void *elem, long opaque, unsigned long *key,
+			size_t index, void *func2), void *func2)
+{
+	size_t count = 0;
+
+	if (!func)
+		func = empty;
+	if (head->node)
+		count = __btree_for_each(head, geo, head->node, opaque, func,
+				func2, 0, head->height, 0);
+	return count;
+}
+
+size_t btree_grim_visitor(struct btree_head *head, struct btree_geo *geo,
+		long opaque,
+		void (*func)(void *elem, long opaque, unsigned long *key,
+			size_t index, void *func2), void *func2)
+{
+	size_t count = 0;
+
+	if (!func)
+		func = empty;
+	if (head->node)
+		count = __btree_for_each(head, geo, head->node, opaque, func,
+				func2, 1, head->height, 0);
+	__btree_init(head);
+	return count;
+}
+
+static int __init btree_module_init(void)
+{
+	btree_cachep = kmem_cache_create("btree_node", NODESIZE, 0,
+			SLAB_HWCACHE_ALIGN, NULL);
+	return 0;
+}
+
+/* If core code starts using btree, initialization should happen even earlier */
+module_init(btree_module_init);
