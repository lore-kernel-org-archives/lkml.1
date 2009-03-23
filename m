Return-Path: <linux-kernel-owner+w=401wt.eu-S1757850AbZCWP4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757850AbZCWP4b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 11:56:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753578AbZCWPzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 11:55:55 -0400
Received: from mail09.linbit.com ([212.69.161.110]:48434 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbZCWPzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 11:55:53 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org
Cc: philipp.reisner@linbit.com, gregkh@suse.de
Subject: [PATCH 01/12] DRBD: lru_cache
Date: Mon, 23 Mar 2009 16:47:56 +0100
Message-Id: <1237823287-12734-2-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1237823287-12734-1-git-send-email-philipp.reisner@linbit.com>
References: <1237823287-12734-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The lru_cache is a fixed size cache of equal sized objects. It allows its
users to do arbitrary transactions in case an element in the cache needs to
be replaced. Its replacement policy is LRU.

---
diff -uNrp linux-2.6.29-rc8/drivers/block/drbd/lru_cache.h linux-2.6.29-rc8-drbd/drivers/block/drbd/lru_cache.h
--- linux-2.6.29-rc8/drivers/block/drbd/lru_cache.h	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.29-rc8-drbd/drivers/block/drbd/lru_cache.h	2009-03-23 11:25:50.991276000 +0100
@@ -0,0 +1,118 @@
+/*
+-*- linux-c -*-
+   lru_cache.c
+   Kernel module for 2.6.x Kernels
+
+   This file is part of DRBD by Philipp Reisner and Lars Ellenberg.
+
+   Copyright (C) 2003-2008, LINBIT Information Technologies GmbH.
+   Copyright (C) 2003-2008, Philipp Reisner <philipp.reisner@linbit.com>.
+   Copyright (C) 2003-2008, Lars Ellenberg <lars.ellenberg@linbit.com>.
+
+   drbd is free software; you can redistribute it and/or modify
+   it under the terms of the GNU General Public License as published by
+   the Free Software Foundation; either version 2, or (at your option)
+   any later version.
+
+   drbd is distributed in the hope that it will be useful,
+   but WITHOUT ANY WARRANTY; without even the implied warranty of
+   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+   GNU General Public License for more details.
+
+   You should have received a copy of the GNU General Public License
+   along with drbd; see the file COPYING.  If not, write to
+   the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
+
+ */
+
+#ifndef LRU_CACHE_H
+#define LRU_CACHE_H
+
+#include <linux/list.h>
+
+struct lc_element {
+	struct hlist_node colision;
+	struct list_head list;		 /* LRU list or free list */
+	unsigned int refcnt;
+	unsigned int lc_number;
+};
+
+struct lru_cache {
+	struct list_head lru;
+	struct list_head free;
+	struct list_head in_use;
+	size_t element_size;
+	unsigned int  nr_elements;
+	unsigned int  new_number;
+
+	unsigned int used;
+	unsigned long flags;
+	unsigned long hits, misses, starving, dirty, changed;
+	struct lc_element *changing_element; /* just for paranoia */
+
+	void  *lc_private;
+	const char *name;
+
+	struct hlist_head slot[0];
+	/* hash colision chains here, then element storage. */
+};
+
+
+/* flag-bits for lru_cache */
+enum {
+	__LC_PARANOIA,
+	__LC_DIRTY,
+	__LC_STARVING,
+};
+#define LC_PARANOIA (1<<__LC_PARANOIA)
+#define LC_DIRTY    (1<<__LC_DIRTY)
+#define LC_STARVING (1<<__LC_STARVING)
+
+extern struct lru_cache *lc_alloc(const char *name, unsigned int e_count,
+				  size_t e_size, void *private_p);
+extern void lc_reset(struct lru_cache *lc);
+extern void lc_free(struct lru_cache *lc);
+extern void lc_set(struct lru_cache *lc, unsigned int enr, int index);
+extern void lc_del(struct lru_cache *lc, struct lc_element *element);
+
+extern struct lc_element *lc_try_get(struct lru_cache *lc, unsigned int enr);
+extern struct lc_element *lc_find(struct lru_cache *lc, unsigned int enr);
+extern struct lc_element *lc_get(struct lru_cache *lc, unsigned int enr);
+extern unsigned int lc_put(struct lru_cache *lc, struct lc_element *e);
+extern void lc_changed(struct lru_cache *lc, struct lc_element *e);
+
+struct seq_file;
+extern size_t lc_printf_stats(struct seq_file *seq, struct lru_cache *lc);
+
+void lc_dump(struct lru_cache *lc, struct seq_file *seq, char *utext,
+	     void (*detail) (struct seq_file *, struct lc_element *));
+
+/* This can be used to stop lc_get from changing the set of active elements.
+ * Note that the reference counts and order on the lru list may still change.
+ * returns true if we aquired the lock.
+ */
+static inline int lc_try_lock(struct lru_cache *lc)
+{
+	return !test_and_set_bit(__LC_DIRTY, &lc->flags);
+}
+
+static inline void lc_unlock(struct lru_cache *lc)
+{
+	clear_bit(__LC_DIRTY, &lc->flags);
+	smp_mb__after_clear_bit();
+}
+
+static inline int lc_is_used(struct lru_cache *lc, unsigned int enr)
+{
+	struct lc_element *e = lc_find(lc, enr);
+	return e && e->refcnt;
+}
+
+#define LC_FREE (-1U)
+
+#define lc_e_base(lc)  ((char *)((lc)->slot + (lc)->nr_elements))
+#define lc_entry(lc, i) ((struct lc_element *) \
+		       (lc_e_base(lc) + (i)*(lc)->element_size))
+#define lc_index_of(lc, e) (((char *)(e) - lc_e_base(lc))/(lc)->element_size)
+
+#endif
diff -uNrp linux-2.6.29-rc8/drivers/block/drbd/lru_cache.c linux-2.6.29-rc8-drbd/drivers/block/drbd/lru_cache.c
--- linux-2.6.29-rc8/drivers/block/drbd/lru_cache.c	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.29-rc8-drbd/drivers/block/drbd/lru_cache.c	2009-03-23 11:25:50.991276000 +0100
@@ -0,0 +1,399 @@
+/*
+-*- linux-c -*-
+   lru_cache.c
+   Kernel module for 2.6.x Kernels
+
+   This file is part of DRBD by Philipp Reisner and Lars Ellenberg.
+
+   Copyright (C) 2003-2008, LINBIT Information Technologies GmbH.
+   Copyright (C) 2003-2008, Philipp Reisner <philipp.reisner@linbit.com>.
+   Copyright (C) 2003-2008, Lars Ellenberg <lars.ellenberg@linbit.com>.
+
+   drbd is free software; you can redistribute it and/or modify
+   it under the terms of the GNU General Public License as published by
+   the Free Software Foundation; either version 2, or (at your option)
+   any later version.
+
+   drbd is distributed in the hope that it will be useful,
+   but WITHOUT ANY WARRANTY; without even the implied warranty of
+   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+   GNU General Public License for more details.
+
+   You should have received a copy of the GNU General Public License
+   along with drbd; see the file COPYING.  If not, write to
+   the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
+
+ */
+
+#include <linux/bitops.h>
+#include <linux/vmalloc.h>
+#include <linux/string.h> /* for memset */
+#include <linux/seq_file.h> /* for seq_printf */
+#include "lru_cache.h"
+
+/* this is developers aid only! */
+#define PARANOIA_ENTRY() BUG_ON(test_and_set_bit(__LC_PARANOIA, &lc->flags))
+#define PARANOIA_LEAVE() do { clear_bit(__LC_PARANOIA, &lc->flags); smp_mb__after_clear_bit(); } while (0)
+#define RETURN(x...)     do { PARANOIA_LEAVE(); return x ; } while (0)
+
+static inline size_t size_of_lc(unsigned int e_count, size_t e_size)
+{
+	return sizeof(struct lru_cache)
+	     + e_count * (e_size + sizeof(struct hlist_head));
+}
+
+static inline void lc_init(struct lru_cache *lc,
+		const size_t bytes, const char *name,
+		const unsigned int e_count, const size_t e_size,
+		void *private_p)
+{
+	struct lc_element *e;
+	unsigned int i;
+
+	memset(lc, 0, bytes);
+	INIT_LIST_HEAD(&lc->in_use);
+	INIT_LIST_HEAD(&lc->lru);
+	INIT_LIST_HEAD(&lc->free);
+	lc->element_size = e_size;
+	lc->nr_elements  = e_count;
+	lc->new_number	 = -1;
+	lc->lc_private   = private_p;
+	lc->name         = name;
+	for (i = 0; i < e_count; i++) {
+		e = lc_entry(lc, i);
+		e->lc_number = LC_FREE;
+		list_add(&e->list, &lc->free);
+		/* memset(,0,) did the rest of init for us */
+	}
+}
+
+/**
+ * lc_alloc: allocates memory for @e_count objects of @e_size bytes plus the
+ * struct lru_cache, and the hash table slots.
+ * returns pointer to a newly initialized lru_cache object with said parameters.
+ */
+struct lru_cache *lc_alloc(const char *name, unsigned int e_count,
+			   size_t e_size, void *private_p)
+{
+	struct lru_cache   *lc;
+	size_t bytes;
+
+	BUG_ON(!e_count);
+	e_size = max(sizeof(struct lc_element), e_size);
+	bytes = size_of_lc(e_count, e_size);
+	lc = vmalloc(bytes);
+	if (lc)
+		lc_init(lc, bytes, name, e_count, e_size, private_p);
+	return lc;
+}
+
+/**
+ * lc_free: Frees memory allocated by lc_alloc.
+ * @lc: The lru_cache object
+ */
+void lc_free(struct lru_cache *lc)
+{
+	vfree(lc);
+}
+
+/**
+ * lc_reset: does a full reset for @lc and the hash table slots.
+ * It is roughly the equivalent of re-allocating a fresh lru_cache object,
+ * basically a short cut to lc_free(lc); lc = lc_alloc(...);
+ */
+void lc_reset(struct lru_cache *lc)
+{
+	lc_init(lc, size_of_lc(lc->nr_elements, lc->element_size), lc->name,
+			lc->nr_elements, lc->element_size, lc->lc_private);
+}
+
+size_t	lc_printf_stats(struct seq_file *seq, struct lru_cache *lc)
+{
+	/* NOTE:
+	 * total calls to lc_get are
+	 * (starving + hits + misses)
+	 * misses include "dirty" count (update from an other thread in
+	 * progress) and "changed", when this in fact lead to an successful
+	 * update of the cache.
+	 */
+	return seq_printf(seq, "\t%s: used:%u/%u "
+		"hits:%lu misses:%lu starving:%lu dirty:%lu changed:%lu\n",
+		lc->name, lc->used, lc->nr_elements,
+		lc->hits, lc->misses, lc->starving, lc->dirty, lc->changed);
+}
+
+static unsigned int lc_hash_fn(struct lru_cache *lc, unsigned int enr)
+{
+	return enr % lc->nr_elements;
+}
+
+
+/**
+ * lc_find: Returns the pointer to an element, if the element is present
+ * in the hash table. In case it is not this function returns NULL.
+ * @lc: The lru_cache object
+ * @enr: element number
+ */
+struct lc_element *lc_find(struct lru_cache *lc, unsigned int enr)
+{
+	struct hlist_node *n;
+	struct lc_element *e;
+
+	BUG_ON(!lc);
+	BUG_ON(!lc->nr_elements);
+	hlist_for_each_entry(e, n, lc->slot + lc_hash_fn(lc, enr), colision) {
+		if (e->lc_number == enr)
+			return e;
+	}
+	return NULL;
+}
+
+static struct lc_element *lc_evict(struct lru_cache *lc)
+{
+	struct list_head  *n;
+	struct lc_element *e;
+
+	if (list_empty(&lc->lru))
+		return NULL;
+
+	n = lc->lru.prev;
+	e = list_entry(n, struct lc_element, list);
+
+	list_del(&e->list);
+	hlist_del(&e->colision);
+	return e;
+}
+
+/**
+ * lc_del: Removes an element from the cache (and therefore adds the
+ * element's storage to the free list)
+ *
+ * @lc: The lru_cache object
+ * @e: The element to remove
+ */
+void lc_del(struct lru_cache *lc, struct lc_element *e)
+{
+	PARANOIA_ENTRY();
+	BUG_ON(e->refcnt);
+	list_del(&e->list);
+	hlist_del_init(&e->colision);
+	e->lc_number = LC_FREE;
+	e->refcnt = 0;
+	list_add(&e->list, &lc->free);
+	RETURN();
+}
+
+static struct lc_element *lc_get_unused_element(struct lru_cache *lc)
+{
+	struct list_head *n;
+
+	if (list_empty(&lc->free))
+		return lc_evict(lc);
+
+	n = lc->free.next;
+	list_del(n);
+	return list_entry(n, struct lc_element, list);
+}
+
+static int lc_unused_element_available(struct lru_cache *lc)
+{
+	if (!list_empty(&lc->free))
+		return 1; /* something on the free list */
+	if (!list_empty(&lc->lru))
+		return 1;  /* something to evict */
+
+	return 0;
+}
+
+
+/**
+ * lc_get: Finds an element in the cache, increases its usage count,
+ * "touches" and returns it.
+ * In case the requested number is not present, it needs to be added to the
+ * cache. Therefore it is possible that an other element becomes eviced from
+ * the cache. In either case, the user is notified so he is able to e.g. keep
+ * a persistent log of the cache changes, and therefore the objects in use.
+ *
+ * Return values:
+ *  NULL    if the requested element number was not in the cache, and no unused
+ *          element could be recycled
+ *  pointer to the element with the REQUESTED element number
+ *          In this case, it can be used right away
+ *
+ *  pointer to an UNUSED element with some different element number.
+ *          In this case, the cache is marked dirty, and the returned element
+ *          pointer is removed from the lru list and hash collision chains.
+ *          The user now should do whatever houskeeping is necessary. Then he
+ *          needs to call lc_element_changed(lc,element_pointer), to finish the
+ *          change.
+ *
+ * NOTE: The user needs to check the lc_number on EACH use, so he recognizes
+ *       any cache set change.
+ *
+ * @lc: The lru_cache object
+ * @enr: element number
+ */
+struct lc_element *lc_get(struct lru_cache *lc, unsigned int enr)
+{
+	struct lc_element *e;
+
+	BUG_ON(!lc);
+	BUG_ON(!lc->nr_elements);
+
+	PARANOIA_ENTRY();
+	if (lc->flags & LC_STARVING) {
+		++lc->starving;
+		RETURN(NULL);
+	}
+
+	e = lc_find(lc, enr);
+	if (e) {
+		++lc->hits;
+		if (e->refcnt++ == 0)
+			lc->used++;
+		list_move(&e->list, &lc->in_use); /* Not evictable... */
+		RETURN(e);
+	}
+
+	++lc->misses;
+
+	/* In case there is nothing available and we can not kick out
+	 * the LRU element, we have to wait ...
+	 */
+	if (!lc_unused_element_available(lc)) {
+		__set_bit(__LC_STARVING, &lc->flags);
+		RETURN(NULL);
+	}
+
+	/* it was not present in the cache, find an unused element,
+	 * which then is replaced.
+	 * we need to update the cache; serialize on lc->flags & LC_DIRTY
+	 */
+	if (test_and_set_bit(__LC_DIRTY, &lc->flags)) {
+		++lc->dirty;
+		RETURN(NULL);
+	}
+
+	e = lc_get_unused_element(lc);
+	BUG_ON(!e);
+
+	clear_bit(__LC_STARVING, &lc->flags);
+	BUG_ON(++e->refcnt != 1);
+	lc->used++;
+
+	lc->changing_element = e;
+	lc->new_number = enr;
+
+	RETURN(e);
+}
+
+/* similar to lc_get,
+ * but only gets a new reference on an existing element.
+ * you either get the requested element, or NULL.
+ */
+struct lc_element *lc_try_get(struct lru_cache *lc, unsigned int enr)
+{
+	struct lc_element *e;
+
+	BUG_ON(!lc);
+	BUG_ON(!lc->nr_elements);
+
+	PARANOIA_ENTRY();
+	if (lc->flags & LC_STARVING) {
+		++lc->starving;
+		RETURN(NULL);
+	}
+
+	e = lc_find(lc, enr);
+	if (e) {
+		++lc->hits;
+		if (e->refcnt++ == 0)
+			lc->used++;
+		list_move(&e->list, &lc->in_use); /* Not evictable... */
+	}
+	RETURN(e);
+}
+
+void lc_changed(struct lru_cache *lc, struct lc_element *e)
+{
+	PARANOIA_ENTRY();
+	BUG_ON(e != lc->changing_element);
+	++lc->changed;
+	e->lc_number = lc->new_number;
+	list_add(&e->list, &lc->in_use);
+	hlist_add_head(&e->colision,
+		lc->slot + lc_hash_fn(lc, lc->new_number));
+	lc->changing_element = NULL;
+	lc->new_number = -1;
+	clear_bit(__LC_DIRTY, &lc->flags);
+	smp_mb__after_clear_bit();
+	PARANOIA_LEAVE();
+}
+
+
+unsigned int lc_put(struct lru_cache *lc, struct lc_element *e)
+{
+	BUG_ON(!lc);
+	BUG_ON(!lc->nr_elements);
+	BUG_ON(!e);
+
+	PARANOIA_ENTRY();
+	BUG_ON(e->refcnt == 0);
+	BUG_ON(e == lc->changing_element);
+	if (--e->refcnt == 0) {
+		/* move it to the front of LRU. */
+		list_move(&e->list, &lc->lru);
+		lc->used--;
+		clear_bit(__LC_STARVING, &lc->flags);
+		smp_mb__after_clear_bit();
+	}
+	RETURN(e->refcnt);
+}
+
+
+/**
+ * lc_set: Sets an element in the cache. You might use this function to
+ * setup the cache. It is expected that the elements are properly initialized.
+ * @lc: The lru_cache object
+ * @enr: element number
+ * @index: The elements' position in the cache
+ */
+void lc_set(struct lru_cache *lc, unsigned int enr, int index)
+{
+	struct lc_element *e;
+
+	if (index < 0 || index >= lc->nr_elements)
+		return;
+
+	e = lc_entry(lc, index);
+	e->lc_number = enr;
+
+	hlist_del_init(&e->colision);
+	hlist_add_head(&e->colision, lc->slot + lc_hash_fn(lc, enr));
+	list_move(&e->list, e->refcnt ? &lc->in_use : &lc->lru);
+}
+
+/**
+ * lc_dump: Dump a complete LRU cache to seq in textual form.
+ */
+void lc_dump(struct lru_cache *lc, struct seq_file *seq, char *utext,
+	     void (*detail) (struct seq_file *, struct lc_element *))
+{
+	unsigned int nr_elements = lc->nr_elements;
+	struct lc_element *e;
+	int i;
+
+	seq_printf(seq, "\tnn: lc_number refcnt %s\n ", utext);
+	for (i = 0; i < nr_elements; i++) {
+		e = lc_entry(lc, i);
+		if (e->lc_number == LC_FREE) {
+			seq_printf(seq, "\t%2d: FREE\n", i);
+		} else {
+			seq_printf(seq, "\t%2d: %4u %4u    ", i,
+				   e->lc_number,
+				   e->refcnt);
+			detail(seq, e);
+		}
+	}
+}
+
