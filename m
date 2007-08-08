Return-Path: <linux-kernel-owner+w=401wt.eu-S935665AbXHHQXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935665AbXHHQXz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 12:23:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935916AbXHHQXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 12:23:37 -0400
Received: from lazybastard.de ([212.112.238.170]:42384 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935869AbXHHQXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 12:23:35 -0400
Date: Wed, 8 Aug 2007 18:19:39 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, akpm@osdl.org,
       David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [Patch 10/18] fs/logfs/memtree.c
Message-ID: <20070808161939.GL15319@lazybastard.org>
References: <20070808161234.GB15319@lazybastard.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070808161234.GB15319@lazybastard.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- /dev/null	2007-08-05 21:14:35.622844160 +0200
+++ linux-2.6.21logfs/fs/logfs/memtree.c	2007-08-08 02:57:37.000000000 +0200
@@ -0,0 +1,258 @@
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
+#define BTREE_NODES 16	/* 32bit, 128 byte cacheline */
+
+struct btree_node {
+	long val;
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
+void *btree_lookup(struct btree_head *head, long val)
+{
+	int i, height = head->height;
+	struct btree_node *node = head->node;
+
+	if (val == 0)
+		return head->null_ptr;
+
+	if (height == 0)
+		return NULL;
+
+	for ( ; height > 1; height--) {
+		for (i=0; i<BTREE_NODES; i++)
+			if (node[i].val <= val)
+				break;
+		node = node[i].node;
+	}
+
+	for (i=0; i<BTREE_NODES; i++)
+		if (node[i].val == val)
+			return node[i].node;
+
+	return NULL;
+}
+
+static void find_pos(struct btree_node *node, long val, int *pos, int *fill)
+{
+	int i;
+
+	for (i=0; i<BTREE_NODES; i++)
+		if (node[i].val <= val)
+			break;
+	*pos = i;
+	for (i=*pos; i<BTREE_NODES; i++)
+		if (node[i].val == 0)
+			break;
+	*fill = i;
+}
+
+static struct btree_node *find_level(struct btree_head *head, long val,
+		int level)
+{
+	struct btree_node *node = head->node;
+	int i, height = head->height;
+
+	for ( ; height > level; height--) {
+		for (i=0; i<BTREE_NODES; i++)
+			if (node[i].val <= val)
+				break;
+		node = node[i].node;
+	}
+	return node;
+}
+
+static int btree_grow(struct btree_head *head)
+{
+	struct btree_node *node;
+
+	node = kcalloc(BTREE_NODES, sizeof(*node), GFP_KERNEL);
+	if (!node)
+		return -ENOMEM;
+	if (head->node) {
+		node->val = head->node[BTREE_NODES-1].val;
+		node->node = head->node;
+	}
+	head->node = node;
+	head->height++;
+	return 0;
+}
+
+static int btree_insert_level(struct btree_head *head, long val, void *ptr,
+		int level)
+{
+	struct btree_node *node;
+	int i, pos, fill, err;
+
+	if (val == 0) {
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
+	node = find_level(head, val, level);
+	find_pos(node, val, &pos, &fill);
+	BUG_ON(node[pos].val == val);
+
+	if (fill == BTREE_NODES) {
+		/* need to split node */
+		struct btree_node *new;
+
+		new = kcalloc(BTREE_NODES, sizeof(*node), GFP_KERNEL);
+		if (!new)
+			return -ENOMEM;
+		err = btree_insert_level(head, node[BTREE_NODES/2 - 1].val, new,
+				level+1);
+		if (err) {
+			kfree(new);
+			return err;
+		}
+		for (i=0; i<BTREE_NODES/2; i++) {
+			new[i].val = node[i].val;
+			new[i].node = node[i].node;
+			node[i].val = node[i + BTREE_NODES/2].val;
+			node[i].node = node[i + BTREE_NODES/2].node;
+			node[i + BTREE_NODES/2].val = 0;
+			node[i + BTREE_NODES/2].node = NULL;
+		}
+		goto retry;
+	}
+	BUG_ON(fill >= BTREE_NODES);
+
+	/* shift and insert */
+	for (i=fill; i>pos; i--) {
+		node[i].val = node[i-1].val;
+		node[i].node = node[i-1].node;
+	}
+	node[pos].val = val;
+	node[pos].node = ptr;
+
+	return 0;
+}
+
+int btree_insert(struct btree_head *head, long val, void *ptr)
+{
+	return btree_insert_level(head, val, ptr, 1);
+}
+
+static int btree_remove_level(struct btree_head *head, long val, int level)
+{
+	struct btree_node *node;
+	int i, pos, fill;
+
+	if (val == 0) {
+		/* 0 identifies empty slots, so special-case this */
+		head->null_ptr = NULL;
+		return 0;
+	}
+
+	node = find_level(head, val, level);
+	find_pos(node, val, &pos, &fill);
+	if (level == 1)
+		BUG_ON(node[pos].val != val);
+
+	/* remove and shift */
+	for (i=pos; i<fill-1; i++) {
+		node[i].val = node[i+1].val;
+		node[i].node = node[i+1].node;
+	}
+	node[fill-1].val = 0;
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
+		btree_remove_level(head, val, level+1);
+		kfree(node);
+		return 0;
+	}
+
+	return 0;
+}
+
+int btree_remove(struct btree_head *head, long val)
+{
+	return btree_remove_level(head, val, 1);
+}
