Return-Path: <linux-kernel-owner+w=401wt.eu-S1760947AbYDKQUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760947AbYDKQUq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 12:20:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760276AbYDKQUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 12:20:24 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:34105 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760156AbYDKQUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 12:20:22 -0400
Message-Id: <20080411161957.510841000@bull.net>
References: <20080411161702.460410000@bull.net>
User-Agent: quilt/0.45-1
Date: Fri, 11 Apr 2008 18:17:03 +0200
From: Nadia.Derbey@bull.net
To: efault@gmx.de
Cc: manfred@colorfullife.com, linux-kernel@vger.kernel.org,
       paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
       peterz@infradead.org, xemul@openvz.org,
       Nadia Derbey <Nadia.Derbey@bull.net>
Subject: [PATCH 01/13] duplicate idr code
Content-Disposition: inline; filename=copy_idr_code.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 01/13]

This patch duplicates idr.c and idr.h, only changing the routines and
structures names where needed.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>

---
 include/linux/ridr.h |   58 +++++++
 lib/ridr.c           |  386 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 444 insertions(+)

Index: linux-2.6.25-rc8-mm1/include/linux/ridr.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.25-rc8-mm1/include/linux/ridr.h	2008-04-11 17:17:41.000000000 +0200
@@ -0,0 +1,58 @@
+/*
+ * include/linux/ridr.h
+ *
+ * Small id to pointer translation service avoiding fixed sized
+ * tables. RCU-based implmentation of IDRs.
+ */
+
+#ifndef _RIDR_H_
+#define _RIDR_H_
+
+#include <linux/idr.h>
+
+struct ridr_layer {
+	unsigned long		 bitmap; /* A zero bit means "space here" */
+	struct ridr_layer	*ary[1<<IDR_BITS];
+	int			 count;	 /* When zero, we can release it */
+};
+
+struct ridr {
+	struct ridr_layer *top;
+	struct ridr_layer *id_free;
+	int		  layers;
+	int		  id_free_cnt;
+	spinlock_t	  lock;
+};
+
+#define RIDR_INIT(name)						\
+{								\
+	.top		= NULL,					\
+	.id_free	= NULL,					\
+	.layers 	= 0,					\
+	.id_free_cnt	= 0,					\
+	.lock		= __SPIN_LOCK_UNLOCKED(name.lock),	\
+}
+#define DEFINE_RIDR(name)	struct ridr name = RIDR_INIT(name)
+
+#define INIT_RIDR(name)							\
+do {									\
+	(name)->top		= NULL;					\
+	(name)->id_free		= NULL;					\
+	(name)->layers		= 0;					\
+	(name)->id_free_cnt	= 0;					\
+	(name)->lock		= __SPIN_LOCK_UNLOCKED(name.lock);	\
+} while (0)
+
+
+/*
+ * This is what we export.
+ */
+
+void *ridr_find(struct ridr *idp, int id);
+int ridr_pre_get(struct ridr *idp, gfp_t gfp_mask);
+int ridr_get_new(struct ridr *idp, void *ptr, int *id);
+void ridr_remove(struct ridr *idp, int id);
+
+void __init ridr_init_cache(void);
+
+#endif /* _RIDR_H_ */
Index: linux-2.6.25-rc8-mm1/lib/ridr.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.25-rc8-mm1/lib/ridr.c	2008-04-11 17:30:28.000000000 +0200
@@ -0,0 +1,386 @@
+/*
+ * RCU-based idr API
+ */
+
+#ifndef TEST                        /* to test in user space... */
+#include <linux/slab.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#endif
+#include <linux/err.h>
+#include <linux/string.h>
+#include <linux/ridr.h>
+
+static struct kmem_cache *ridr_layer_cache;
+
+static struct ridr_layer *alloc_layer(struct ridr *idp)
+{
+	struct ridr_layer *p;
+	unsigned long flags;
+
+	spin_lock_irqsave(&idp->lock, flags);
+	p = idp->id_free;
+	if (p) {
+		idp->id_free = p->ary[0];
+		idp->id_free_cnt--;
+		p->ary[0] = NULL;
+	}
+	spin_unlock_irqrestore(&idp->lock, flags);
+	return(p);
+}
+
+/* only called when idp->lock is held */
+static void __free_layer(struct ridr *idp, struct ridr_layer *p)
+{
+	p->ary[0] = idp->id_free;
+	idp->id_free = p;
+	idp->id_free_cnt++;
+}
+
+static void free_layer(struct ridr *idp, struct ridr_layer *p)
+{
+	unsigned long flags;
+
+	/*
+	 * Depends on the return element being zeroed.
+	 */
+	spin_lock_irqsave(&idp->lock, flags);
+	__free_layer(idp, p);
+	spin_unlock_irqrestore(&idp->lock, flags);
+}
+
+static void ridr_mark_full(struct ridr_layer **pa, int id)
+{
+	struct ridr_layer *p = pa[0];
+	int l = 0;
+
+	__set_bit(id & IDR_MASK, &p->bitmap);
+	/*
+	 * If this layer is full mark the bit in the layer above to
+	 * show that this part of the radix tree is full.  This may
+	 * complete the layer above and require walking up the radix
+	 * tree.
+	 */
+	while (p->bitmap == IDR_FULL) {
+		p = pa[++l];
+		if (!p)
+			break;
+		id = id >> IDR_BITS;
+		__set_bit((id & IDR_MASK), &p->bitmap);
+	}
+}
+
+/**
+ * ridr_pre_get - reserver resources for ridr allocation
+ * @idp:	ridr handle
+ * @gfp_mask:	memory allocation flags
+ *
+ * This function should be called prior to locking and calling the
+ * following function.  It preallocates enough memory to satisfy
+ * the worst possible allocation.
+ *
+ * If the system is REALLY out of memory this function returns 0,
+ * otherwise 1.
+ */
+int ridr_pre_get(struct ridr *idp, gfp_t gfp_mask)
+{
+	while (idp->id_free_cnt < IDR_FREE_MAX) {
+		struct ridr_layer *new;
+		new = kmem_cache_alloc(ridr_layer_cache, gfp_mask);
+		if (new == NULL)
+			return (0);
+		free_layer(idp, new);
+	}
+	return 1;
+}
+EXPORT_SYMBOL(ridr_pre_get);
+
+static int sub_alloc(struct ridr *idp, int *starting_id,
+			struct ridr_layer **pa)
+{
+	int n, m, sh;
+	struct ridr_layer *p, *new;
+	int l, id, oid;
+	unsigned long bm;
+
+	id = *starting_id;
+ restart:
+	p = idp->top;
+	l = idp->layers;
+	pa[l--] = NULL;
+	while (1) {
+		/*
+		 * We run around this while until we reach the leaf node...
+		 */
+		n = (id >> (IDR_BITS*l)) & IDR_MASK;
+		bm = ~p->bitmap;
+		m = find_next_bit(&bm, IDR_SIZE, n);
+		if (m == IDR_SIZE) {
+			/* no space available go back to previous layer. */
+			l++;
+			oid = id;
+			id = (id | ((1 << (IDR_BITS * l)) - 1)) + 1;
+
+			/* if already at the top layer, we need to grow */
+			p = pa[l];
+			if (!p) {
+				*starting_id = id;
+				return -2;
+			}
+
+			/* If we need to go up one layer, continue the
+			 * loop; otherwise, restart from the top.
+			 */
+			sh = IDR_BITS * (l + 1);
+			if (oid >> sh == id >> sh)
+				continue;
+			else
+				goto restart;
+		}
+		if (m != n) {
+			sh = IDR_BITS*l;
+			id = ((id >> sh) ^ n ^ m) << sh;
+		}
+		if ((id >= MAX_ID_BIT) || (id < 0))
+			return -3;
+		if (l == 0)
+			break;
+		/*
+		 * Create the layer below if it is missing.
+		 */
+		if (!p->ary[m]) {
+			new = alloc_layer(idp);
+			if (!new)
+				return -1;
+			p->ary[m] = new;
+			p->count++;
+		}
+		pa[l--] = p;
+		p = p->ary[m];
+	}
+
+	pa[l] = p;
+	return id;
+}
+
+static int ridr_get_empty_slot(struct ridr *idp, int starting_id,
+			      struct ridr_layer **pa)
+{
+	struct ridr_layer *p, *new;
+	int layers, v, id;
+	unsigned long flags;
+
+	id = starting_id;
+build_up:
+	p = idp->top;
+	layers = idp->layers;
+	if (unlikely(!p)) {
+		p = alloc_layer(idp);
+		if (!p)
+			return -1;
+		layers = 1;
+	}
+	/*
+	 * Add a new layer to the top of the tree if the requested
+	 * id is larger than the currently allocated space.
+	 */
+	while ((layers < (MAX_LEVEL - 1)) && (id >= (1 << (layers*IDR_BITS)))) {
+		layers++;
+		if (!p->count)
+			continue;
+		new = alloc_layer(idp);
+		if (!new) {
+			/*
+			 * The allocation failed.  If we built part of
+			 * the structure tear it down.
+			 */
+			spin_lock_irqsave(&idp->lock, flags);
+			for (new = p; p && p != idp->top; new = p) {
+				p = p->ary[0];
+				new->ary[0] = NULL;
+				new->bitmap = new->count = 0;
+				__free_layer(idp, new);
+			}
+			spin_unlock_irqrestore(&idp->lock, flags);
+			return -1;
+		}
+		new->ary[0] = p;
+		new->count = 1;
+		if (p->bitmap == IDR_FULL)
+			__set_bit(0, &new->bitmap);
+		p = new;
+	}
+	idp->top = p;
+	idp->layers = layers;
+	v = sub_alloc(idp, &id, pa);
+	if (v == -2)
+		goto build_up;
+	return(v);
+}
+
+static int ridr_get_new_above_int(struct ridr *idp, void *ptr, int starting_id)
+{
+	struct ridr_layer *pa[MAX_LEVEL];
+	int id;
+
+	id = ridr_get_empty_slot(idp, starting_id, pa);
+	if (id >= 0) {
+		/*
+		 * Successfully found an empty slot.  Install the user
+		 * pointer and mark the slot full.
+		 */
+		pa[0]->ary[id & IDR_MASK] = (struct ridr_layer *)ptr;
+		pa[0]->count++;
+		ridr_mark_full(pa, id);
+	}
+
+	return id;
+}
+
+/**
+ * ridr_get_new - allocate new ridr entry
+ * @idp: ridr handle
+ * @ptr: pointer you want associated with the ide
+ * @id: pointer to the allocated handle
+ *
+ * This is the allocate id function.  It should be called with any
+ * required locks.
+ *
+ * If memory is required, it will return -EAGAIN, you should unlock
+ * and go back to the ridr_pre_get() call.  If the ridr is full, it will
+ * return -ENOSPC.
+ *
+ * @id returns a value in the range 0 ... 0x7fffffff
+ */
+int ridr_get_new(struct ridr *idp, void *ptr, int *id)
+{
+	int rv;
+
+	rv = ridr_get_new_above_int(idp, ptr, 0);
+	/*
+	 * This is a cheap hack until the IDR code can be fixed to
+	 * return proper error values.
+	 */
+	if (rv < 0) {
+		if (rv == -1)
+			return -EAGAIN;
+		else /* Will be -3 */
+			return -ENOSPC;
+	}
+	*id = rv;
+	return 0;
+}
+EXPORT_SYMBOL(ridr_get_new);
+
+static void ridr_remove_warning(int id)
+{
+	printk("ridr_remove called for id=%d which is not allocated.\n", id);
+	dump_stack();
+}
+
+static void sub_remove(struct ridr *idp, int shift, int id)
+{
+	struct ridr_layer *p = idp->top;
+	struct ridr_layer **pa[MAX_LEVEL];
+	struct ridr_layer ***paa = &pa[0];
+	int n;
+
+	*paa = NULL;
+	*++paa = &idp->top;
+
+	while ((shift > 0) && p) {
+		n = (id >> shift) & IDR_MASK;
+		__clear_bit(n, &p->bitmap);
+		*++paa = &p->ary[n];
+		p = p->ary[n];
+		shift -= IDR_BITS;
+	}
+	n = id & IDR_MASK;
+	if (likely(p != NULL && test_bit(n, &p->bitmap))) {
+		__clear_bit(n, &p->bitmap);
+		p->ary[n] = NULL;
+		while (*paa && !--((**paa)->count)) {
+			free_layer(idp, **paa);
+			**paa-- = NULL;
+		}
+		if (!*paa)
+			idp->layers = 0;
+	} else
+		ridr_remove_warning(id);
+}
+
+/**
+ * ridr_remove - remove the given id and free it's slot
+ * @idp: ridr handle
+ * @id: unique key
+ */
+void ridr_remove(struct ridr *idp, int id)
+{
+	struct ridr_layer *p;
+
+	/* Mask off upper bits we don't use for the search. */
+	id &= MAX_ID_MASK;
+
+	sub_remove(idp, (idp->layers - 1) * IDR_BITS, id);
+	if (idp->top && idp->top->count == 1 && (idp->layers > 1) &&
+	    idp->top->ary[0]) {  /* We can drop a layer */
+
+		p = idp->top->ary[0];
+		idp->top->bitmap = idp->top->count = 0;
+		free_layer(idp, idp->top);
+		idp->top = p;
+		--idp->layers;
+	}
+	while (idp->id_free_cnt >= IDR_FREE_MAX) {
+		p = alloc_layer(idp);
+		kmem_cache_free(ridr_layer_cache, p);
+		return;
+	}
+}
+EXPORT_SYMBOL(ridr_remove);
+
+/**
+ * ridr_find - return pointer for given id
+ * @idp: ridr handle
+ * @id: lookup key
+ *
+ * Return the pointer given the id it has been registered with.  A %NULL
+ * return indicates that @id is not valid or you passed %NULL in
+ * ridr_get_new().
+ *
+ * The caller must serialize ridr_find() vs ridr_get_new() and ridr_remove().
+ */
+void *ridr_find(struct ridr *idp, int id)
+{
+	int n;
+	struct ridr_layer *p;
+
+	n = idp->layers * IDR_BITS;
+	p = idp->top;
+
+	/* Mask off upper bits we don't use for the search. */
+	id &= MAX_ID_MASK;
+
+	if (id >= (1 << n))
+		return NULL;
+
+	while (n > 0 && p) {
+		n -= IDR_BITS;
+		p = p->ary[(id >> n) & IDR_MASK];
+	}
+	return((void *)p);
+}
+EXPORT_SYMBOL(ridr_find);
+
+static void ridr_cache_ctor(struct kmem_cache *ridr_layer_cache,
+				void *ridr_layer)
+{
+	memset(ridr_layer, 0, sizeof(struct ridr_layer));
+}
+
+void __init ridr_init_cache(void)
+{
+	ridr_layer_cache = kmem_cache_create("ridr_layer_cache",
+				sizeof(struct ridr_layer), 0, SLAB_PANIC,
+				ridr_cache_ctor);
+}

--
