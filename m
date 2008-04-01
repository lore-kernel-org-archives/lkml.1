Return-Path: <linux-kernel-owner+w=401wt.eu-S1760830AbYDCRP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760830AbYDCRP2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 13:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760571AbYDCRLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 13:11:22 -0400
Received: from lazybastard.de ([212.112.238.170]:43609 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760162AbYDCRKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 13:10:43 -0400
Message-Id: <20080401181332.853833010@logfs.org>
References: <20080401181308.512473173@logfs.org>
Date: Tue, 01 Apr 2008 20:13:08 +0200
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mtd@lists.infradead.org
Subject: [patch 10/15] fs/logfs/memtree.c
From: joern@logfs.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- /dev/null	2008-04-02 16:29:12.813336657 +0200
+++ linux-2.6.24logfs/fs/logfs/memtree.c	2008-04-01 21:43:14.593326689 +0200
@@ -0,0 +1,405 @@
+/*
+ * fs/logfs/memtree.c	- Simple In-memory B+Tree
+ *
+ * As should be obvious for Linux kernel code, license is GPLv2
+ *
+ * Copyright (c) 2007 Joern Engel <joern@logfs.org>
+ *
+ *
+ * This could possibly get moved to lib/.
+ *
+ * A relatively simple B+Tree implementation.  I have written it as a learning
+ * excercise to understand how B+Trees work.  Turned out to be useful as well.
+ *
+ * B+Trees can be used similar to Linux radix trees (which don't have anything
+ * in common with textbook radix trees, beware).  Prerequisite for them working
+ * well is that access to a random tree node is much faster than a large number
+ * of operations within each node.
+ *
+ * Disks have fulfilled the prerequite for a long time.  More recently DRAM
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
+/* FIXME: use mempool for allocations */
+#include "logfs.h"
+
+/*
+ * Prerequisite of B+Trees performing well is that node lookup is much slower
+ * than a large number of operations within a node.  That can be true if the
+ * node size is identical to cacheline size.  All that is highly
+ * machine-dependent, just like the #define below is not.
+ *
+ * Patches to do something smarter are welcome.  Just beware that too small
+ * node with less than 8 slots have a bad fan-out and won't perform well
+ * either.
+ */
+#if BITS_PER_LONG == 32
+#define BTREE_NODES 20	/* 32bit, 240 byte nodes */
+#else
+#define BTREE_NODES 16	/* 64bit, 256 byte nodes */
+#endif
+
+struct btree_node {
+	u64 key;
+	struct btree_node *node;
+};
+
+void btree_init(struct btree_head *head)
+{
+	head->node = NULL;
+	head->height = 0;
+	head->null_ptr = NULL;
+}
+
+#if 0
+static void __dump_tree(struct btree_node *node, int height)
+{
+	int i;
+
+	if (!height)
+		return;
+
+	printk(KERN_DEBUG"%p ", node);
+	for (i = 0; i < BTREE_NODES; i++)
+		printk("(%llx,%p) ", node[i].key, node[i].node);
+	printk("\n");
+
+	for (i = 0; i < BTREE_NODES; i++)
+		if (node[i].key)
+			__dump_tree(node[i].node, height-1);
+}
+
+static void dump_tree(struct btree_head *head)
+{
+	printk(KERN_DEBUG"%p\n", head->null_ptr);
+	__dump_tree(head->node, head->height);
+}
+#endif
+
+static u64 btree_last(struct btree_head *head)
+{
+	int height = head->height;
+	struct btree_node *node = head->node;
+
+	if (height == 0)
+		return 0;
+
+	for ( ; height > 1; height--)
+		node = node[0].node;
+
+	return node[0].key;
+}
+
+void *btree_lookup(struct btree_head *head, u64 key)
+{
+	int i, height = head->height;
+	struct btree_node *node = head->node;
+
+	if (key == 0)
+		return head->null_ptr;
+
+	if (height == 0)
+		return NULL;
+
+	for ( ; height > 1; height--) {
+		for (i = 0; i < BTREE_NODES; i++)
+			if (node[i].key <= key)
+				break;
+		node = node[i].node;
+		if (!node)
+			return NULL;
+	}
+
+	if (!node)
+		return NULL;
+
+	for (i = 0; i < BTREE_NODES; i++)
+		if (node[i].key == key)
+			return node[i].node;
+
+	return NULL;
+}
+
+/*
+ * Returns two values:
+ * pos - the position of the first slot equal or less than key
+ * fill - the number of positions filled with any value
+ */
+static void find_pos(struct btree_node *node, u64 key, int *pos, int *fill)
+{
+	int i;
+
+	for (i = 0; i < BTREE_NODES; i++)
+		if (node[i].key <= key)
+			break;
+	*pos = i;
+	for (i = *pos; i < BTREE_NODES; i++)
+		if (node[i].key == 0)
+			break;
+	*fill = i;
+}
+
+/*
+ * locate the correct leaf node in the btree
+ */
+static struct btree_node *find_level(struct btree_head *head, u64 key,
+		int level)
+{
+	struct btree_node *node = head->node;
+	int i, height;
+
+	for (height = head->height; height > level; height--) {
+		for (i = 0; i < BTREE_NODES; i++)
+			if (node[i].key <= key)
+				break;
+
+		if ((i == BTREE_NODES) || !node[i].key) {
+			/* right-most key is too large, update it */
+			i--;
+			node[i].key = key;
+		}
+		BUG_ON(i < 0);
+		node = node[i].node;
+	}
+	BUG_ON(!node);
+	return node;
+}
+
+static int btree_grow(struct btree_head *head)
+{
+	struct btree_node *node;
+
+	node = kcalloc(BTREE_NODES, sizeof(*node), GFP_KERNEL);
+	BUG_ON(!node);
+	if (!node)
+		return -ENOMEM;
+	if (head->node) {
+		node->key = head->node[BTREE_NODES-1].key;
+		node->node = head->node;
+	}
+	head->node = node;
+	head->height++;
+	return 0;
+}
+
+static int btree_insert_level(struct btree_head *head, u64 key, void *ptr,
+		int level)
+{
+	struct btree_node *node;
+	int i, pos, fill, err;
+
+	BUG_ON(!ptr);
+	if (key == 0) {
+		/* 0 identifies empty slots, so special-case this */
+		BUG_ON(level != 1);
+		head->null_ptr = ptr;
+		return 0;
+	}
+
+	if (head->height < level) {
+		err = btree_grow(head);
+		if (err)
+			return err;
+	}
+
+retry:
+	node = find_level(head, key, level);
+	find_pos(node, key, &pos, &fill);
+	BUG_ON(node[pos].key == key);
+
+	if (fill == BTREE_NODES) {
+		/* need to split node */
+		struct btree_node *new;
+
+		new = kcalloc(BTREE_NODES, sizeof(*node), GFP_KERNEL);
+		BUG_ON(!new);
+		if (!new)
+			return -ENOMEM;
+		err = btree_insert_level(head, node[BTREE_NODES/2 - 1].key, new,
+				level+1);
+		if (err) {
+			kfree(new);
+			return err;
+		}
+		for (i = 0; i < BTREE_NODES / 2; i++) {
+			new[i].key = node[i].key;
+			new[i].node = node[i].node;
+			node[i].key = node[i + BTREE_NODES/2].key;
+			node[i].node = node[i + BTREE_NODES/2].node;
+			node[i + BTREE_NODES/2].key = 0;
+			node[i + BTREE_NODES/2].node = NULL;
+		}
+		goto retry;
+	}
+	BUG_ON(fill >= BTREE_NODES);
+
+	/* shift and insert */
+	for (i = fill; i > pos; i--) {
+		node[i].key = node[i-1].key;
+		node[i].node = node[i-1].node;
+	}
+	node[pos].key = key;
+	node[pos].node = ptr;
+
+	return 0;
+}
+
+int btree_insert(struct btree_head *head, u64 key, void *ptr)
+{
+	BUG_ON(!ptr);
+	return btree_insert_level(head, key, ptr, 1);
+}
+
+static void *btree_remove_level(struct btree_head *head, u64 key, int level)
+{
+	struct btree_node *node;
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
+	node = find_level(head, key, level);
+	find_pos(node, key, &pos, &fill);
+	if ((level == 1) && (node[pos].key != key))
+		return NULL;
+	ret = node[pos].node;
+
+	/* remove and shift */
+	for (i = pos; i < fill-1; i++) {
+		node[i].key = node[i+1].key;
+		node[i].node = node[i+1].node;
+	}
+	node[fill-1].key = 0;
+	node[fill-1].node = NULL;
+
+	if (fill-1 < BTREE_NODES/2) {
+		/*
+		 * At this point there *should* be code to either merge with
+		 * a neighboring node or steal some entries from it to preserve
+		 * the btree invariant of only having nodes with n/2..n
+		 * elements.
+		 *
+		 * As you can see, that code is left as an excercise to the
+		 * reader or anyone noticing severe performance problems in
+		 * very rare cases.
+		 *
+		 * As-is this code "implements" a method called lazy deletion,
+		 * which according to text books is relatively common in
+		 * databases and usually works quite well.
+		 * Not so usually, the btree can degrade into very long lists
+		 * of 1-element nodes and perform accordingly.
+		 */
+	}
+	if (fill-1 == 0) {
+		btree_remove_level(head, key, level+1);
+		kfree(node);
+	}
+
+	return ret;
+}
+
+void *btree_remove(struct btree_head *head, u64 key)
+{
+	void *ret;
+
+	if (key == 0) {
+		/* 0 identifies empty slots, so special-case this */
+		ret = head->null_ptr;
+		head->null_ptr = NULL;
+		return ret;
+	}
+	if (head->height == 0)
+		return NULL;
+
+	return btree_remove_level(head, key, 1);
+}
+
+int btree_merge(struct btree_head *target, struct btree_head *victim)
+{
+	struct btree_node *node;
+	u64 key;
+	int err;
+
+	BUG_ON(target == victim);
+
+	if (!(target->node || target->null_ptr)) {
+		/* target is empty, just copy fields over */
+		target->null_ptr = victim->null_ptr;
+		target->node = victim->node;
+		target->height = victim->height;
+		btree_init(victim);
+		return 0;
+	}
+
+	for (;;) {
+		key = btree_last(victim);
+		node = btree_remove(victim, key);
+		if (!node)
+			break;
+		err = btree_insert(target, key, node);
+		if (err)
+			return err;
+	}
+	return 0;
+}
+
+static void __btree_for_each(struct btree_node *node, long opaque,
+		void (*func)(void *elem, long opaque, u64 key),  int reap,
+		int height)
+{
+	int i;
+
+	for (i = 0; i < BTREE_NODES && node[i].key; i++) {
+		if (height > 1)
+			__btree_for_each(node[i].node, opaque, func, reap,
+					height-1);
+		else
+			func(node[i].node, opaque, node[i].key);
+	}
+	if (reap)
+		kfree(node);
+}
+
+void btree_visitor(struct btree_head *head, long opaque,
+		void (*func)(void *elem, long opaque, u64 key))
+{
+	if (head->node)
+		__btree_for_each(head->node, opaque, func, 0, head->height);
+	if (head->null_ptr)
+		func(head->null_ptr, opaque, 0);
+}
+
+void btree_grim_visitor(struct btree_head *head, long opaque,
+		void (*func)(void *elem, long opaque, u64 key))
+{
+	if (head->node)
+		__btree_for_each(head->node, opaque, func, 1, head->height);
+	if (head->null_ptr)
+		func(head->null_ptr, opaque, 0);
+	btree_init(head);
+}

