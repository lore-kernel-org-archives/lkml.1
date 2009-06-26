Return-Path: <linux-kernel-owner+w=401wt.eu-S1760079AbZFZMPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760079AbZFZMPI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 08:15:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759217AbZFZMLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 08:11:31 -0400
Received: from mail09.linbit.com ([212.69.161.110]:48136 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757480AbZFZMKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 08:10:47 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Greg KH <gregkh@suse.de>,
       Neil Brown <neilb@suse.de>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Sam Ravnborg <sam@ravnborg.org>, Dave Jones <davej@redhat.com>,
       Nikanth Karthikesan <knikanth@suse.de>,
       "Lars Marowsky-Bree" <lmb@suse.de>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       Kyle Moffett <kyle@moffetthome.net>,
       Bart Van Assche <bart.vanassche@gmail.com>, drbd-dev@lists.linbit.com,
       Lars Ellenberg <lars.ellenberg@linbit.com>,
       Philipp Reisner <philipp.reisner@linbit.com>
Subject: [PATCH 01/15] lru_cache: track a fixed size cache of equal sized objects
Date: Fri, 26 Jun 2009 14:01:41 +0200
Message-Id: <1246017715-9821-2-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1246017715-9821-1-git-send-email-philipp.reisner@linbit.com>
References: <1246017715-9821-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A helper framework to easily keep track of index:label associations,
and changes to an "active set" of objects, as well as pending transactions,
to persistently record those changes.

We use an LRU policy if it is necessary to "cool down" a region currently in
the active set before we can "heat" a previously unused region.

Because of this later property, it is called "lru_cache".

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>

---
diff --git a/include/linux/lru_cache.h b/include/linux/lru_cache.h
new file mode 100644
index 0000000..3a2b2d9
--- /dev/null
+++ b/include/linux/lru_cache.h
@@ -0,0 +1,294 @@
+/*
+   lru_cache.c
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
+#include <linux/slab.h>
+#include <linux/bitops.h>
+#include <linux/string.h> /* for memset */
+#include <linux/seq_file.h>
+
+/*
+This header file (and its .c file; kernel-doc of functions see there)
+  define a helper framework to easily keep track of index:label associations,
+  and changes to an "active set" of objects, as well as pending transactions,
+  to persistently record those changes.
+
+  We use an LRU policy if it is necessary to "cool down" a region currently in
+  the active set before we can "heat" a previously unused region.
+
+  Because of this later property, it is called "lru_cache".
+  As it actually Tracks Objects in an Active SeT, we could also call it
+  toast (incidentally that is what may happen to the data on the
+  backend storage uppon next resync, if we don't get it right).
+
+What for?
+
+We replicate IO (more or less synchronously) to local and remote disk.
+
+For crash recovery after replication node failure,
+  we need to resync all regions that have been target of in-flight WRITE IO
+  (in use, or "hot", regions), as we don't know wether or not those WRITEs have
+  made it to stable storage.
+
+  To avoid a "full resync", we need to persistently track these regions.
+
+  This is known as "write intent log", and can be implemented as on-disk
+  (coarse or fine grained) bitmap, or other meta data.
+
+  To avoid the overhead of frequent extra writes to this meta data area,
+  usually the condition is softened to regions that _may_ have been target of
+  in-flight WRITE IO, e.g. by only lazily clearing the on-disk write-intent
+  bitmap, trading frequency of meta data transactions against amount of
+  (possibly unneccessary) resync traffic.
+
+  If we set a hard limit on the area that may be "hot" at any given time, we
+  limit the amount of resync traffic needed for crash recovery.
+
+For recovery after replication link failure,
+  we need to resync all blocks that have been changed on the other replica
+  in the mean time, or, if both replica have been changed independently [*],
+  all blocks that have been changed on either replica in the mean time.
+  [*] usually as a result of a cluster split-brain and insufficient protection.
+      but there are valid use cases to do this on purpose.
+
+  Tracking those blocks can be implemented as "dirty bitmap".
+  Having it fine-grained reduces the amount of resync traffic.
+  It should also be persistent, to allow for reboots (or crashes)
+  while the replication link is down.
+
+There are various possible implementations for persistently storing
+write intent log information, three of which are mentioned here.
+
+"Chunk dirtying"
+  The on-disk "dirty bitmap" may be re-used as "write-intent" bitmap as well.
+  To reduce the frequency of bitmap updates for write-intent log purposes,
+  one could dirty "chunks" (of some size) at a time of the (fine grained)
+  on-disk bitmap, while keeping the in-memory "dirty" bitmap as clean as
+  possible, flushing it to disk again when a previously "hot" (and on-disk
+  dirtied as full chunk) area "cools down" again (no IO in flight anymore,
+  and none expected in the near future either).
+
+"Explicit (coarse) write intent bitmap"
+  An other implementation could chose a (probably coarse) explicit bitmap,
+  for write-intent log purposes, additionally to the fine grained dirty bitmap.
+
+"Activity log"
+  Yet an other implementation may keep track of the hot regions, by starting
+  with an empty set, and writing down a journal of region numbers that have
+  become "hot", or have "cooled down" again.
+
+  To be able to use a ring buffer for this journal of changes to the active
+  set, we not only record the actual changes to that set, but also record the
+  not changing members of the set in a round robin fashion. To do so, we use a
+  fixed (but configurable) number of slots which we can identify by index, and
+  associate region numbers (labels) with these indices.
+  For each transaction recording a change to the active set, we record the
+  change itself (index: -old_label, +new_label), and which index is associated
+  with which label (index: current_label) within a certain sliding window that
+  is moved further over the available indices with each such transaction.
+
+  Thus, for crash recovery, if the ringbuffer is sufficiently large, we can
+  accurately reconstruct the active set.
+
+  Sufficiently large depends only on maximum number of active objects, and the
+  size of the sliding window recording "index: current_label" associations within
+  each transaction.
+
+  This is what we call the "activity log".
+
+  Currently we need one activity log transaction per single label change, which
+  does not give much benefit over the "dirty chunks of bitmap" approach, other
+  than potentially less seeks.
+
+  We plan to change the transaction format to support multiple changes per
+  transaction, which then would reduce several (disjoint, "random") updates to
+  the bitmap into one transaction to the activity log ring buffer.
+*/
+
+/* this defines an element in a tracked set
+ * .colision is for hash table lookup.
+ * When we process a new IO request, we know its sector, thus can deduce the
+ * region number (label) easily.  To do the label -> object lookup without a
+ * full list walk, we use a simple hash table.
+ *
+ * .list is on one of three lists:
+ *  in_use: currently in use (refcnt > 0, lc_number != LC_FREE)
+ *     lru: unused but ready to be reused or recycled
+ *          (ts_refcnt == 0, lc_number != LC_FREE),
+ *    free: unused but ready to be recycled
+ *          (ts_refcnt == 0, lc_number == LC_FREE),
+ *
+ * an element is said to be "in the active set",
+ * if either on "in_use" or "lru", i.e. lc_number != LC_FREE.
+ *
+ * DRBD currently (May 2009) only uses 61 elements on the resync lru_cache
+ * (total memory usage 2 pages), and up to 3833 elements on the act_log
+ * lru_cache, totalling ~215 kB for 64bit architechture, ~53 pages.
+ *
+ * We usually do not actually free these objects again, but only "recycle"
+ * them, as the change "index: -old_label, +LC_FREE" would need a transaction
+ * as well.  Which also means that using a kmem_cache to allocate the objects
+ * from wastes some resources.
+ * But it avoids high order page allocations in kmalloc.
+ */
+struct lc_element {
+	struct hlist_node colision;
+	struct list_head list;		 /* LRU list or free list */
+	unsigned refcnt;
+	/* back "pointer" into ts_cache->element[index],
+	 * for paranoia, and for "ts_element_to_index" */
+	unsigned lc_index;
+	/* if we want to track a larger set of objects,
+	 * it needs to become arch independend u64 */
+	unsigned lc_number;
+
+	/* special label when on free list */
+#define LC_FREE (~0U)
+};
+
+struct lru_cache {
+	/* the least recently used item is kept at lru->prev */
+	struct list_head lru;
+	struct list_head free;
+	struct list_head in_use;
+
+	/* the pre-created kmem cache to allocate the objects from */
+	struct kmem_cache *lc_cache;
+
+	/* size of tracked objects, used to memset(,0,) them in lc_reset */
+	size_t element_size;
+	/* offset of struct lc_element member in the tracked object */
+	size_t element_off;
+
+	/* number of elements (indices) */
+	unsigned int  nr_elements;
+	/* Arbitrary limit on maximum tracked objects. Practical limit is much
+	 * lower due to allocation failures, probably. For typical use cases,
+	 * nr_elements should be a few thousand at most.
+	 * This also limits the maximum value of ts_element.ts_index, allowing the
+	 * 8 high bits of .ts_index to be overloaded with flags in the future. */
+#define LC_MAX_ACTIVE	(1<<24)
+
+	/* statistics */
+	unsigned used; /* number of lelements currently on in_use list */
+	unsigned long hits, misses, starving, dirty, changed;
+
+	/* see below: flag-bits for lru_cache */
+	unsigned long flags;
+
+	/* when changing the label of an index element */
+	unsigned int  new_number;
+
+	/* for paranoia when changing the label of an index element */
+	struct lc_element *changing_element;
+
+	void  *lc_private;
+	const char *name;
+
+	/* nr_elements there */
+	struct hlist_head *lc_slot;
+	struct lc_element **lc_element;
+};
+
+
+/* flag-bits for lru_cache */
+enum {
+	/* debugging aid, to catch concurrent access early.
+	 * user needs to guarantee exclusive access by proper locking! */
+	__LC_PARANOIA,
+	/* if we need to change the set, but currently there is a changing
+	 * transaction pending, we are "dirty", and must deferr further
+	 * changing requests */
+	__LC_DIRTY,
+	/* if we need to change the set, but currently there is no free nor
+	 * unused element available, we are "starving", and must not give out
+	 * further references, to guarantee that eventually some refcnt will
+	 * drop to zero and we will be able to make progress again, changing
+	 * the set, writing the transaction.
+	 * if the statistics say we are frequently starving,
+	 * nr_elements is too small. */
+	__LC_STARVING,
+};
+#define LC_PARANOIA (1<<__LC_PARANOIA)
+#define LC_DIRTY    (1<<__LC_DIRTY)
+#define LC_STARVING (1<<__LC_STARVING)
+
+extern struct lru_cache *lc_create(const char *name, struct kmem_cache *cache,
+		unsigned e_count, size_t e_size, size_t e_off);
+extern void lc_reset(struct lru_cache *lc);
+extern void lc_destroy(struct lru_cache *lc);
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
+extern size_t lc_seq_printf_stats(struct seq_file *seq, struct lru_cache *lc);
+
+extern void lc_seq_dump_details(struct seq_file *seq, struct lru_cache *lc, char *utext,
+				void (*detail) (struct seq_file *, struct lc_element *));
+
+/**
+ * lc_try_lock - can be used to stop lc_get() from changing the tracked set
+ * @lc: the lru cache to operate on
+ *
+ * Note that the reference counts and order on the active and lru lists may
+ * still change.  Returns true if we aquired the lock.
+ */
+static inline int lc_try_lock(struct lru_cache *lc)
+{
+	return !test_and_set_bit(__LC_DIRTY, &lc->flags);
+}
+
+/**
+ * lc_unlock - unlock @lc, allow lc_get() to change the set again
+ * @lc: the lru cache to operate on
+ */
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
+#define lc_entry(ptr, type, member) \
+	container_of(ptr, type, member)
+
+extern struct lc_element *lc_element_by_index(struct lru_cache *lc, unsigned i);
+extern unsigned int lc_index_of(struct lru_cache *lc, struct lc_element *e);
+
+#endif
diff --git a/lib/lru_cache.c b/lib/lru_cache.c
new file mode 100644
index 0000000..ab11a71
--- /dev/null
+++ b/lib/lru_cache.c
@@ -0,0 +1,560 @@
+/*
+   lru_cache.c
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
+#include <linux/module.h>
+#include <linux/bitops.h>
+#include <linux/slab.h>
+#include <linux/string.h> /* for memset */
+#include <linux/seq_file.h> /* for seq_printf */
+#include <linux/lru_cache.h>
+
+MODULE_AUTHOR("Philipp Reisner <phil@linbit.com>, "
+	      "Lars Ellenberg <lars@linbit.com>");
+MODULE_DESCRIPTION("lru_cache - Track sets of hot objects");
+MODULE_LICENSE("GPL");
+
+/* this is developers aid only.
+ * it catches concurrent access (lack of locking on the users part) */
+#define PARANOIA_ENTRY() do {		\
+	BUG_ON(!lc);			\
+	BUG_ON(!lc->nr_elements);	\
+	BUG_ON(test_and_set_bit(__LC_PARANOIA, &lc->flags)); \
+} while (0)
+
+#define RETURN(x...)     do { \
+	clear_bit(__LC_PARANOIA, &lc->flags); \
+	smp_mb__after_clear_bit(); return x ; } while (0)
+
+/* BUG() if e is not one of the elements tracked by lc */
+#define PARANOIA_LC_ELEMENT(lc, e) do {	\
+	struct lru_cache *lc_ = (lc);	\
+	struct lc_element *e_ = (e);	\
+	unsigned i = e_->lc_index;	\
+	BUG_ON(i >= lc_->nr_elements);	\
+	BUG_ON(lc_->lc_element[i] != e_); } while (0)
+
+/**
+ * lc_create - prepares to track objects in an active set
+ * @name: descriptive name only used in lc_seq_printf_stats and lc_seq_dump_details
+ * @e_count: number of elements allowed to be active simultaneously
+ * @e_size: size of the tracked objects
+ * @e_off: offset to the &struct lc_element member in a tracked object
+ *
+ * Returns a pointer to a newly initialized struct lru_cache on success,
+ * or NULL on (allocation) failure.
+ */
+struct lru_cache *lc_create(const char *name, struct kmem_cache *cache,
+		unsigned e_count, size_t e_size, size_t e_off)
+{
+	struct hlist_head *slot = NULL;
+	struct lc_element **element = NULL;
+	struct lru_cache *lc;
+	struct lc_element *e;
+	unsigned cache_obj_size = kmem_cache_size(cache);
+	unsigned i;
+
+	WARN_ON(cache_obj_size < e_size);
+	if (cache_obj_size < e_size)
+		return NULL;
+
+	/* e_count too big; would probably fail the allocation below anyways.
+	 * for typical use cases, e_count should be few thousand at most. */
+	if (e_count > LC_MAX_ACTIVE)
+		return NULL;
+
+	slot = kzalloc(e_count * sizeof(struct hlist_head*), GFP_KERNEL);
+	if (!slot)
+		goto out_fail;
+	element = kzalloc(e_count * sizeof(struct lc_element *), GFP_KERNEL);
+	if (!element)
+		goto out_fail;
+
+	lc = kzalloc(sizeof(*lc), GFP_KERNEL);
+	if (!lc)
+		goto out_fail;
+
+	INIT_LIST_HEAD(&lc->in_use);
+	INIT_LIST_HEAD(&lc->lru);
+	INIT_LIST_HEAD(&lc->free);
+
+	lc->name = name;
+	lc->element_size = e_size;
+	lc->element_off = e_off;
+	lc->nr_elements = e_count;
+	lc->new_number = LC_FREE;
+	lc->lc_cache = cache;
+	lc->lc_element = element;
+	lc->lc_slot = slot;
+
+	/* preallocate all objects */
+	for (i = 0; i < e_count; i++) {
+		void *p = kmem_cache_alloc(cache, GFP_KERNEL);
+		if (!p)
+			break;
+		memset(p, 0, lc->element_size);
+		e = p + e_off;
+		e->lc_index = i;
+		e->lc_number = LC_FREE;
+		list_add(&e->list, &lc->free);
+		element[i] = e;
+	}
+	if (i == e_count)
+		return lc;
+
+	/* else: could not allocate all elements, give up */
+	for (i--; i; i--) {
+		void *p = element[i];
+		kmem_cache_free(cache, p - e_off);
+	}
+	kfree(lc);
+out_fail:
+	kfree(element);
+	kfree(slot);
+	return NULL;
+}
+
+void lc_free_by_index(struct lru_cache *lc, unsigned i)
+{
+	void *p = lc->lc_element[i];
+	WARN_ON(!p);
+	if (p) {
+		p -= lc->element_off;
+		kmem_cache_free(lc->lc_cache, p);
+	}
+}
+
+/**
+ * lc_destroy - frees memory allocated by lc_create()
+ * @lc: the lru cache to destroy
+ */
+void lc_destroy(struct lru_cache *lc)
+{
+	unsigned i;
+	if (!lc)
+		return;
+	for (i = 0; i < lc->nr_elements; i++)
+		lc_free_by_index(lc, i);
+	kfree(lc->lc_element);
+	kfree(lc->lc_slot);
+	kfree(lc);
+}
+
+/**
+ * lc_reset - does a full reset for @lc and the hash table slots.
+ * @lc: the lru cache to operate on
+ *
+ * It is roughly the equivalent of re-allocating a fresh lru_cache object,
+ * basically a short cut to lc_destroy(lc); lc = lc_create(...);
+ */
+void lc_reset(struct lru_cache *lc)
+{
+	unsigned i;
+
+	INIT_LIST_HEAD(&lc->in_use);
+	INIT_LIST_HEAD(&lc->lru);
+	INIT_LIST_HEAD(&lc->free);
+	lc->used = 0;
+	lc->hits = 0;
+	lc->misses = 0;
+	lc->starving = 0;
+	lc->dirty = 0;
+	lc->changed = 0;
+	lc->flags = 0;
+	lc->changing_element = NULL;
+	lc->new_number = LC_FREE;
+	memset(lc->lc_slot, 0, sizeof(struct hlist_head) * lc->nr_elements);
+
+	for (i = 0; i < lc->nr_elements; i++) {
+		struct lc_element *e = lc->lc_element[i];
+		void *p = e;
+		p -= lc->element_off;
+		memset(p, 0, lc->element_size);
+		/* re-init it */
+		e->lc_index = i;
+		e->lc_number = LC_FREE;
+		list_add(&e->list, &lc->free);
+	}
+}
+
+/**
+ * lc_seq_printf_stats - print stats about @lc into @seq
+ * @seq: the seq_file to print into
+ * @lc: the lru cache to print statistics of
+ */
+size_t lc_seq_printf_stats(struct seq_file *seq, struct lru_cache *lc)
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
+static struct hlist_head *lc_hash_slot(struct lru_cache *lc, unsigned int enr)
+{
+	return  lc->lc_slot + (enr % lc->nr_elements);
+}
+
+
+/**
+ * lc_find - find element by label, if present in the hash table
+ * @lc: The lru_cache object
+ * @enr: element number
+ *
+ * Returns the pointer to an element, if the element with the requested
+ * "label" or element number is present in the hash table,
+ * or NULL if not found. Does not change the refcnt.
+ */
+struct lc_element *lc_find(struct lru_cache *lc, unsigned int enr)
+{
+	struct hlist_node *n;
+	struct lc_element *e;
+
+	BUG_ON(!lc);
+	BUG_ON(!lc->nr_elements);
+	hlist_for_each_entry(e, n, lc_hash_slot(lc, enr), colision) {
+		if (e->lc_number == enr)
+			return e;
+	}
+	return NULL;
+}
+
+/* returned element will be "recycled" immediately */
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
+	PARANOIA_LC_ELEMENT(lc, e);
+
+	list_del(&e->list);
+	hlist_del(&e->colision);
+	return e;
+}
+
+/**
+ * lc_del - removes an element from the cache
+ * @lc: The lru_cache object
+ * @e: The element to remove
+ *
+ * @e must be unused (refcnt == 0). Moves @e from "lru" to "free" list,
+ * sets @e->enr to %LC_FREE.
+ */
+void lc_del(struct lru_cache *lc, struct lc_element *e)
+{
+	PARANOIA_ENTRY();
+	PARANOIA_LC_ELEMENT(lc, e);
+	BUG_ON(e->refcnt);
+
+	e->lc_number = LC_FREE;
+	hlist_del_init(&e->colision);
+	list_move(&e->list, &lc->free);
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
+ * lc_get - get element by label, maybe change the active set
+ * @lc: the lru cache to operate on
+ * @enr: the label to look up
+ *
+ * Finds an element in the cache, increases its usage count,
+ * "touches" and returns it.
+ *
+ * In case the requested number is not present, it needs to be added to the
+ * cache. Therefore it is possible that an other element becomes eviced from
+ * the cache. In either case, the user is notified so he is able to e.g. keep
+ * a persistent log of the cache changes, and therefore the objects in use.
+ *
+ * Return values:
+ *  NULL
+ *     The cache was marked %LC_STARVING,
+ *     or the requested label was not in the active set
+ *     and a changing transaction is still pending (@lc was marked %LC_DIRTY).
+ *     Or no unused or free element could be recycled (@lc will be marked as
+ *     %LC_STARVING, blocking further lc_get() operations).
+ *
+ *  pointer to the element with the REQUESTED element number.
+ *     In this case, it can be used right away
+ *
+ *  pointer to an UNUSED element with some different element number,
+ *          where that different number may also be %LC_FREE.
+ *
+ *          In this case, the cache is marked %LC_DIRTY (blocking further changes),
+ *          and the returned element pointer is removed from the lru list and
+ *          hash collision chains.  The user now should do whatever houskeeping
+ *          is necessary.
+ *          Then he must call lc_changed(lc,element_pointer), to finish
+ *          the change.
+ *
+ * NOTE: The user needs to check the lc_number on EACH use, so he recognizes
+ *       any cache set change.
+ */
+struct lc_element *lc_get(struct lru_cache *lc, unsigned int enr)
+{
+	struct lc_element *e;
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
+	/* it was not present in the active set.
+	 * we are going to recycle an unused (or even "free") element.
+	 * user may need to commit a transaction to record that change.
+	 * we serialize on flags & TF_DIRTY */
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
+ * will be consolidated into one function.
+ */
+struct lc_element *lc_try_get(struct lru_cache *lc, unsigned int enr)
+{
+	struct lc_element *e;
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
+/**
+ * lc_changed - tell @lc that the change has been recorded
+ * @lc: the lru cache to operate on
+ * @e: the element pending label change
+ */
+void lc_changed(struct lru_cache *lc, struct lc_element *e)
+{
+	PARANOIA_ENTRY();
+	BUG_ON(e != lc->changing_element);
+	PARANOIA_LC_ELEMENT(lc, e);
+	++lc->changed;
+	e->lc_number = lc->new_number;
+	list_add(&e->list, &lc->in_use);
+	hlist_add_head(&e->colision, lc_hash_slot(lc, lc->new_number));
+	lc->changing_element = NULL;
+	lc->new_number = LC_FREE;
+	clear_bit(__LC_DIRTY, &lc->flags);
+	smp_mb__after_clear_bit();
+	RETURN();
+}
+
+
+/**
+ * lc_put - give up refcnt of @e
+ * @lc: the lru cache to operate on
+ * @e: the element to put
+ *
+ * If refcnt reaches zero, the element is moved to the lru list,
+ * and a %LC_STARVING (if set) is cleared.
+ * Returns the new (post-decrement) refcnt.
+ */
+unsigned int lc_put(struct lru_cache *lc, struct lc_element *e)
+{
+	PARANOIA_ENTRY();
+	PARANOIA_LC_ELEMENT(lc, e);
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
+/**
+ * lc_element_by_index
+ * @lc: the lru cache to operate on
+ * @i: the index of the element to return
+ */
+struct lc_element *lc_element_by_index(struct lru_cache *lc, unsigned i)
+{
+	BUG_ON(i >= lc->nr_elements);
+	BUG_ON(lc->lc_element[i] == NULL);
+	BUG_ON(lc->lc_element[i]->lc_index != i);
+	return lc->lc_element[i];
+}
+
+/**
+ * lc_index_of
+ * @lc: the lru cache to operate on
+ * @e: the element to query for its index position in lc->element
+ */
+unsigned int lc_index_of(struct lru_cache *lc, struct lc_element *e)
+{
+	PARANOIA_LC_ELEMENT(lc, e);
+	return e->lc_index;
+}
+
+/**
+ * lc_set - associate index with label
+ * @lc: the lru cache to operate on
+ * @enr: the label to set
+ * @index: the element index to associate label with.
+ *
+ * Used to initialize the active set to some previously recorded state.
+ */
+void lc_set(struct lru_cache *lc, unsigned int enr, int index)
+{
+	struct lc_element *e;
+
+	if (index < 0 || index >= lc->nr_elements)
+		return;
+
+	e = lc_element_by_index(lc, index);
+	e->lc_number = enr;
+
+	hlist_del_init(&e->colision);
+	hlist_add_head(&e->colision, lc_hash_slot(lc, enr));
+	list_move(&e->list, e->refcnt ? &lc->in_use : &lc->lru);
+}
+
+/**
+ * lc_dump - Dump a complete LRU cache to seq in textual form.
+ * @lc: the lru cache to operate on
+ * @seq: the &struct seq_file pointer to seq_printf into
+ * @utext: user supplied "heading" or other info
+ * @detail: function pointer the user may provide to dump further details
+ * of the object the lc_element is embeded in.
+ */
+void lc_seq_dump_details(struct seq_file *seq, struct lru_cache *lc, char *utext,
+	     void (*detail) (struct seq_file *, struct lc_element *))
+{
+	unsigned int nr_elements = lc->nr_elements;
+	struct lc_element *e;
+	int i;
+
+	seq_printf(seq, "\tnn: lc_number refcnt %s\n ", utext);
+	for (i = 0; i < nr_elements; i++) {
+		e = lc_element_by_index(lc, i);
+		if (e->lc_number == LC_FREE) {
+			seq_printf(seq, "\t%2d: FREE\n", i);
+		} else {
+			seq_printf(seq, "\t%2d: %4u %4u    ", i,
+				   e->lc_number, e->refcnt);
+			detail(seq, e);
+		}
+	}
+}
+
+EXPORT_SYMBOL(lc_create);
+EXPORT_SYMBOL(lc_reset);
+EXPORT_SYMBOL(lc_destroy);
+EXPORT_SYMBOL(lc_set);
+EXPORT_SYMBOL(lc_del);
+EXPORT_SYMBOL(lc_try_get);
+EXPORT_SYMBOL(lc_find);
+EXPORT_SYMBOL(lc_get);
+EXPORT_SYMBOL(lc_put);
+EXPORT_SYMBOL(lc_changed);
+EXPORT_SYMBOL(lc_element_by_index);
+EXPORT_SYMBOL(lc_index_of);
+EXPORT_SYMBOL(lc_seq_printf_stats);
+EXPORT_SYMBOL(lc_seq_dump_details);
diff --git a/lib/Kconfig b/lib/Kconfig
index bb1326d..1cfe516 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -200,4 +200,7 @@ config NLATTR
 config GENERIC_ATOMIC64
        bool
 
+config LRU_CACHE
+	tristate
+
 endmenu
diff --git a/lib/Makefile b/lib/Makefile
index b6d1857..70587e4 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -91,6 +91,8 @@ obj-$(CONFIG_DYNAMIC_DEBUG) += dynamic_debug.o
 
 obj-$(CONFIG_NLATTR) += nlattr.o
 
+obj-$(CONFIG_LRU_CACHE) += lru_cache.o
+
 obj-$(CONFIG_DMA_API_DEBUG) += dma-debug.o
 
 obj-$(CONFIG_GENERIC_CSUM) += checksum.o
