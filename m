Return-Path: <linux-kernel-owner+w=401wt.eu-S1755763AbZKTUW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763AbZKTUW5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 15:22:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755727AbZKTUWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 15:22:54 -0500
Received: from lazybastard.de ([212.112.238.170]:48503 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755508AbZKTUWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 15:22:43 -0500
X-Greylist: delayed 2655 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Nov 2009 15:22:42 EST
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mtd@lists.infradead.org
From: Joern Engel <joern@logfs.org>
Subject: [PATCH 15/17] [LogFS] btree headers
References: <20091120181113.GA2159@logfs.org>
Message-Id: <E1NBZJH-0003hw-FM@longford.logfs.org>
Date: Fri, 20 Nov 2009 20:38:23 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 include/linux/btree-128.h           |  109 ++
 include/linux/btree-type.h          |  147 +++
 include/linux/btree.h               |  243 ++++

diff --git a/include/linux/btree-128.h b/include/linux/btree-128.h
new file mode 100644
index 0000000..0b3414c
--- /dev/null
+++ b/include/linux/btree-128.h
@@ -0,0 +1,109 @@
+extern struct btree_geo btree_geo128;
+
+struct btree_head128 { struct btree_head h; };
+
+static inline void btree_init_mempool128(struct btree_head128 *head,
+					 mempool_t *mempool)
+{
+	btree_init_mempool(&head->h, mempool);
+}
+
+static inline int btree_init128(struct btree_head128 *head)
+{
+	return btree_init(&head->h);
+}
+
+static inline void btree_destroy128(struct btree_head128 *head)
+{
+	btree_destroy(&head->h);
+}
+
+static inline void *btree_lookup128(struct btree_head128 *head, u64 k1, u64 k2)
+{
+	u64 key[2] = {k1, k2};
+	return btree_lookup(&head->h, &btree_geo128, (unsigned long *)&key);
+}
+
+static inline void *btree_get_prev128(struct btree_head128 *head,
+				      u64 *k1, u64 *k2)
+{
+	u64 key[2] = {*k1, *k2};
+	void *val;
+
+	val = btree_get_prev(&head->h, &btree_geo128,
+			     (unsigned long *)&key);
+	*k1 = key[0];
+	*k2 = key[1];
+	return val;
+}
+
+static inline int btree_insert128(struct btree_head128 *head, u64 k1, u64 k2,
+				  void *val, gfp_t gfp)
+{
+	u64 key[2] = {k1, k2};
+	return btree_insert(&head->h, &btree_geo128,
+			    (unsigned long *)&key, val, gfp);
+}
+
+static inline int btree_update128(struct btree_head128 *head, u64 k1, u64 k2,
+				  void *val)
+{
+	u64 key[2] = {k1, k2};
+	return btree_update(&head->h, &btree_geo128,
+			    (unsigned long *)&key, val);
+}
+
+static inline void *btree_remove128(struct btree_head128 *head, u64 k1, u64 k2)
+{
+	u64 key[2] = {k1, k2};
+	return btree_remove(&head->h, &btree_geo128, (unsigned long *)&key);
+}
+
+static inline void *btree_last128(struct btree_head128 *head, u64 *k1, u64 *k2)
+{
+	u64 key[2];
+	void *val;
+
+	val = btree_last(&head->h, &btree_geo128, (unsigned long *)&key[0]);
+	if (val) {
+		*k1 = key[0];
+		*k2 = key[1];
+	}
+
+	return val;
+}
+
+static inline int btree_merge128(struct btree_head128 *target,
+				 struct btree_head128 *victim,
+				 gfp_t gfp)
+{
+	return btree_merge(&target->h, &victim->h, &btree_geo128, gfp);
+}
+
+void visitor128(void *elem, unsigned long opaque, unsigned long *__key,
+		size_t index, void *__func);
+
+typedef void (*visitor128_t)(void *elem, unsigned long opaque,
+			     u64 key1, u64 key2, size_t index);
+
+static inline size_t btree_visitor128(struct btree_head128 *head,
+				      unsigned long opaque,
+				      visitor128_t func2)
+{
+	return btree_visitor(&head->h, &btree_geo128, opaque,
+			     visitor128, func2);
+}
+
+static inline size_t btree_grim_visitor128(struct btree_head128 *head,
+					   unsigned long opaque,
+					   visitor128_t func2)
+{
+	return btree_grim_visitor(&head->h, &btree_geo128, opaque,
+				  visitor128, func2);
+}
+
+#define btree_for_each_safe128(head, k1, k2, val)	\
+	for (val = btree_last128(head, &k1, &k2);	\
+	     val;					\
+	     val = btree_get_prev128(head, &k1, &k2))
+
diff --git a/include/linux/btree-type.h b/include/linux/btree-type.h
new file mode 100644
index 0000000..9a1147e
--- /dev/null
+++ b/include/linux/btree-type.h
@@ -0,0 +1,147 @@
+#define __BTREE_TP(pfx, type, sfx)	pfx ## type ## sfx
+#define _BTREE_TP(pfx, type, sfx)	__BTREE_TP(pfx, type, sfx)
+#define BTREE_TP(pfx)			_BTREE_TP(pfx, BTREE_TYPE_SUFFIX,)
+#define BTREE_FN(name)			BTREE_TP(btree_ ## name)
+#define BTREE_TYPE_HEAD			BTREE_TP(struct btree_head)
+#define VISITOR_FN			BTREE_TP(visitor)
+#define VISITOR_FN_T			_BTREE_TP(visitor, BTREE_TYPE_SUFFIX, _t)
+
+BTREE_TYPE_HEAD {
+	struct btree_head h;
+};
+
+static inline void BTREE_FN(init_mempool)(BTREE_TYPE_HEAD *head,
+					  mempool_t *mempool)
+{
+	btree_init_mempool(&head->h, mempool);
+}
+
+static inline int BTREE_FN(init)(BTREE_TYPE_HEAD *head)
+{
+	return btree_init(&head->h);
+}
+
+static inline void BTREE_FN(destroy)(BTREE_TYPE_HEAD *head)
+{
+	btree_destroy(&head->h);
+}
+
+static inline int BTREE_FN(merge)(BTREE_TYPE_HEAD *target,
+				  BTREE_TYPE_HEAD *victim,
+				  gfp_t gfp)
+{
+	return btree_merge(&target->h, &victim->h, BTREE_TYPE_GEO, gfp);
+}
+
+#if (BITS_PER_LONG > BTREE_TYPE_BITS)
+static inline void *BTREE_FN(lookup)(BTREE_TYPE_HEAD *head, BTREE_KEYTYPE key)
+{
+	unsigned long _key = key;
+	return btree_lookup(&head->h, BTREE_TYPE_GEO, &_key);
+}
+
+static inline int BTREE_FN(insert)(BTREE_TYPE_HEAD *head, BTREE_KEYTYPE key,
+				   void *val, gfp_t gfp)
+{
+	unsigned long _key = key;
+	return btree_insert(&head->h, BTREE_TYPE_GEO, &_key, val, gfp);
+}
+
+static inline int BTREE_FN(update)(BTREE_TYPE_HEAD *head, BTREE_KEYTYPE key,
+		void *val)
+{
+	unsigned long _key = key;
+	return btree_update(&head->h, BTREE_TYPE_GEO, &_key, val);
+}
+
+static inline void *BTREE_FN(remove)(BTREE_TYPE_HEAD *head, BTREE_KEYTYPE key)
+{
+	unsigned long _key = key;
+	return btree_remove(&head->h, BTREE_TYPE_GEO, &_key);
+}
+
+static inline void *BTREE_FN(last)(BTREE_TYPE_HEAD *head, BTREE_KEYTYPE *key)
+{
+	unsigned long _key;
+	void *val = btree_last(&head->h, BTREE_TYPE_GEO, &_key);
+	if (val)
+		*key = _key;
+	return val;
+}
+
+static inline void *BTREE_FN(get_prev)(BTREE_TYPE_HEAD *head, BTREE_KEYTYPE *key)
+{
+	unsigned long _key = *key;
+	void *val = btree_get_prev(&head->h, BTREE_TYPE_GEO, &_key);
+	if (val)
+		*key = _key;
+	return val;
+}
+#else
+static inline void *BTREE_FN(lookup)(BTREE_TYPE_HEAD *head, BTREE_KEYTYPE key)
+{
+	return btree_lookup(&head->h, BTREE_TYPE_GEO, (unsigned long *)&key);
+}
+
+static inline int BTREE_FN(insert)(BTREE_TYPE_HEAD *head, BTREE_KEYTYPE key,
+			   void *val, gfp_t gfp)
+{
+	return btree_insert(&head->h, BTREE_TYPE_GEO, (unsigned long *)&key,
+			    val, gfp);
+}
+
+static inline int BTREE_FN(update)(BTREE_TYPE_HEAD *head, BTREE_KEYTYPE key,
+		void *val)
+{
+	return btree_update(&head->h, BTREE_TYPE_GEO, (unsigned long *)&key, val);
+}
+
+static inline void *BTREE_FN(remove)(BTREE_TYPE_HEAD *head, BTREE_KEYTYPE key)
+{
+	return btree_remove(&head->h, BTREE_TYPE_GEO, (unsigned long *)&key);
+}
+
+static inline void *BTREE_FN(last)(BTREE_TYPE_HEAD *head, BTREE_KEYTYPE *key)
+{
+	return btree_last(&head->h, BTREE_TYPE_GEO, (unsigned long *)key);
+}
+
+static inline void *BTREE_FN(get_prev)(BTREE_TYPE_HEAD *head, BTREE_KEYTYPE *key)
+{
+	return btree_get_prev(&head->h, BTREE_TYPE_GEO, (unsigned long *)key);
+}
+#endif
+
+void VISITOR_FN(void *elem, unsigned long opaque, unsigned long *key,
+		size_t index, void *__func);
+
+typedef void (*VISITOR_FN_T)(void *elem, unsigned long opaque,
+			     BTREE_KEYTYPE key, size_t index);
+
+static inline size_t BTREE_FN(visitor)(BTREE_TYPE_HEAD *head,
+				       unsigned long opaque,
+				       VISITOR_FN_T func2)
+{
+	return btree_visitor(&head->h, BTREE_TYPE_GEO, opaque,
+			     visitorl, func2);
+}
+
+static inline size_t BTREE_FN(grim_visitor)(BTREE_TYPE_HEAD *head,
+					    unsigned long opaque,
+					    VISITOR_FN_T func2)
+{
+	return btree_grim_visitor(&head->h, BTREE_TYPE_GEO, opaque,
+				  visitorl, func2);
+}
+
+#undef VISITOR_FN
+#undef VISITOR_FN_T
+#undef __BTREE_TP
+#undef _BTREE_TP
+#undef BTREE_TP
+#undef BTREE_FN
+#undef BTREE_TYPE_HEAD
+#undef BTREE_TYPE_SUFFIX
+#undef BTREE_TYPE_GEO
+#undef BTREE_KEYTYPE
+#undef BTREE_TYPE_BITS
diff --git a/include/linux/btree.h b/include/linux/btree.h
new file mode 100644
index 0000000..65b5bb0
--- /dev/null
+++ b/include/linux/btree.h
@@ -0,0 +1,243 @@
+#ifndef BTREE_H
+#define BTREE_H
+
+#include <linux/kernel.h>
+#include <linux/mempool.h>
+
+/**
+ * DOC: B+Tree basics
+ *
+ * A B+Tree is a data structure for looking up arbitrary (currently allowing
+ * unsigned long, u32, u64 and 2 * u64) keys into pointers. The data structure
+ * is described at http://en.wikipedia.org/wiki/B-tree, we currently do not
+ * use binary search to find the key on lookups.
+ *
+ * Each B+Tree consists of a head, that contains bookkeeping information and
+ * a variable number (starting with zero) nodes. Each node contains the keys
+ * and pointers to sub-nodes, or, for leaf nodes, the keys and values for the
+ * tree entries.
+ *
+ * Each node in this implementation has the following layout:
+ * [key1, key2, ..., keyN] [val1, val2, ..., valN]
+ *
+ * Each key here is an array of unsigned longs, geo->no_longs in total. The
+ * number of keys and values (N) is geo->no_pairs.
+ */
+
+/**
+ * struct btree_head - btree head
+ *
+ * @node: the first node in the tree
+ * @mempool: mempool used for node allocations
+ * @height: current of the tree
+ */
+struct btree_head {
+	unsigned long *node;
+	mempool_t *mempool;
+	int height;
+};
+
+/* btree geometry */
+struct btree_geo;
+
+/**
+ * btree_alloc - allocate function for the mempool
+ * @gfp_mask: gfp mask for the allocation
+ * @pool_data: unused
+ */
+void *btree_alloc(gfp_t gfp_mask, void *pool_data);
+
+/**
+ * btree_free - free function for the mempool
+ * @element: the element to free
+ * @pool_data: unused
+ */
+void btree_free(void *element, void *pool_data);
+
+/**
+ * btree_init_mempool - initialise a btree with given mempool
+ *
+ * @head: the btree head to initialise
+ * @mempool: the mempool to use
+ *
+ * When this function is used, there is no need to destroy
+ * the mempool.
+ */
+void btree_init_mempool(struct btree_head *head, mempool_t *mempool);
+
+/**
+ * btree_init - initialise a btree
+ *
+ * @head: the btree head to initialise
+ *
+ * This function allocates the memory pool that the
+ * btree needs. Returns zero or a negative error code
+ * (-%ENOMEM) when memory allocation fails.
+ *
+ */
+int __must_check btree_init(struct btree_head *head);
+
+/**
+ * btree_destroy - destroy mempool
+ *
+ * @head: the btree head to destroy
+ *
+ * This function destroys the internal memory pool, use only
+ * when using btree_init(), not with btree_init_mempool().
+ */
+void btree_destroy(struct btree_head *head);
+
+/**
+ * btree_lookup - look up a key in the btree
+ *
+ * @head: the btree to look in
+ * @geo: the btree geometry
+ * @key: the key to look up
+ *
+ * This function returns the value for the given key, or %NULL.
+ */
+void *btree_lookup(struct btree_head *head, struct btree_geo *geo,
+		   unsigned long *key);
+
+/**
+ * btree_insert - insert an entry into the btree
+ *
+ * @head: the btree to add to
+ * @geo: the btree geometry
+ * @key: the key to add (must not already be present)
+ * @val: the value to add (must not be %NULL)
+ * @gfp: allocation flags for node allocations
+ *
+ * This function returns 0 if the item could be added, or an
+ * error code if it failed (may fail due to memory pressure).
+ */
+int __must_check btree_insert(struct btree_head *head, struct btree_geo *geo,
+			      unsigned long *key, void *val, gfp_t gfp);
+/**
+ * btree_update - update an entry in the btree
+ *
+ * @head: the btree to update
+ * @geo: the btree geometry
+ * @key: the key to update
+ * @val: the value to change it to (must not be %NULL)
+ *
+ * This function returns 0 if the update was successful, or
+ * -%ENOENT if the key could not be found.
+ */
+int btree_update(struct btree_head *head, struct btree_geo *geo,
+		 unsigned long *key, void *val);
+/**
+ * btree_remove - remove an entry from the btree
+ *
+ * @head: the btree to update
+ * @geo: the btree geometry
+ * @key: the key to remove
+ *
+ * This function returns the removed entry, or %NULL if the key
+ * could not be found.
+ */
+void *btree_remove(struct btree_head *head, struct btree_geo *geo,
+		   unsigned long *key);
+
+/**
+ * btree_merge - merge two btrees
+ *
+ * @target: the tree that gets all the entries
+ * @victim: the tree that gets merged into @target
+ * @geo: the btree geometry
+ * @gfp: allocation flags
+ *
+ * The two trees @target and @victim may not contain the same keys,
+ * that is a bug and triggers a BUG(). This function returns zero
+ * if the trees were merged successfully, and may return a failure
+ * when memory allocation fails, in which case both trees might have
+ * been partially merged, i.e. some entries have been moved from
+ * @victim to @target.
+ */
+int btree_merge(struct btree_head *target, struct btree_head *victim,
+		struct btree_geo *geo, gfp_t gfp);
+
+/**
+ * btree_last - get last entry in btree
+ *
+ * @head: btree head
+ * @geo: btree geometry
+ * @key: last key
+ *
+ * Returns the last entry in the btree, and sets @key to the key
+ * of that entry; returns NULL if the tree is empty, in that case
+ * key is not changed.
+ */
+void *btree_last(struct btree_head *head, struct btree_geo *geo,
+		 unsigned long *key);
+
+/**
+ * btree_get_prev - get previous entry
+ *
+ * @head: btree head
+ * @geo: btree geometry
+ * @key: pointer to key
+ *
+ * The function returns the next item right before the value pointed to by
+ * @key, and updates @key with its key, or returns %NULL when there is no
+ * entry with a key smaller than the given key.
+ */
+void *btree_get_prev(struct btree_head *head, struct btree_geo *geo,
+		     unsigned long *key);
+
+
+/* internal use, use btree_visitor{l,32,64,128} */
+size_t btree_visitor(struct btree_head *head, struct btree_geo *geo,
+		     unsigned long opaque,
+		     void (*func)(void *elem, unsigned long opaque,
+				  unsigned long *key, size_t index,
+				  void *func2),
+		     void *func2);
+
+/* internal use, use btree_grim_visitor{l,32,64,128} */
+size_t btree_grim_visitor(struct btree_head *head, struct btree_geo *geo,
+			  unsigned long opaque,
+			  void (*func)(void *elem, unsigned long opaque,
+				       unsigned long *key,
+				       size_t index, void *func2),
+			  void *func2);
+
+
+#include <linux/btree-128.h>
+
+extern struct btree_geo btree_geo32;
+#define BTREE_TYPE_SUFFIX l
+#define BTREE_TYPE_BITS BITS_PER_LONG
+#define BTREE_TYPE_GEO &btree_geo32
+#define BTREE_KEYTYPE unsigned long
+#include <linux/btree-type.h>
+
+#define btree_for_each_safel(head, key, val)	\
+	for (val = btree_lastl(head, &key);	\
+	     val;				\
+	     val = btree_get_prevl(head, &key))
+
+#define BTREE_TYPE_SUFFIX 32
+#define BTREE_TYPE_BITS 32
+#define BTREE_TYPE_GEO &btree_geo32
+#define BTREE_KEYTYPE u32
+#include <linux/btree-type.h>
+
+#define btree_for_each_safe32(head, key, val)	\
+	for (val = btree_last32(head, &key);	\
+	     val;				\
+	     val = btree_get_prev32(head, &key))
+
+extern struct btree_geo btree_geo64;
+#define BTREE_TYPE_SUFFIX 64
+#define BTREE_TYPE_BITS 64
+#define BTREE_TYPE_GEO &btree_geo64
+#define BTREE_KEYTYPE u64
+#include <linux/btree-type.h>
+
+#define btree_for_each_safe64(head, key, val)	\
+	for (val = btree_last64(head, &key);	\
+	     val;				\
+	     val = btree_get_prev64(head, &key))
+
+#endif
