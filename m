Return-Path: <linux-kernel-owner+w=401wt.eu-S932935AbYD2Ojw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932935AbYD2Ojw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 10:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761396AbYD2Ohx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 10:37:53 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:49836 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761380AbYD2Ohv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 10:37:51 -0400
Message-Id: <20080429143731.297122000@bull.net>
References: <20080429143304.741001000@bull.net>
User-Agent: quilt/0.45-1
Date: Tue, 29 Apr 2008 16:33:12 +0200
From: Nadia.Derbey@bull.net
To: manfred@colorfullife.com, paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, efault@gmx.de, akpm@linux-foundation.org,
       Nadia Derbey <Nadia.Derbey@bull.net>
Subject: [PATCH 08/10] Introduce ridr_remove()
Content-Disposition: inline; filename=ridr_remove.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 08/10]

This patch introduces the ridr_remove() routine.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>

---
 include/linux/idr.h  |    1 
 include/linux/ridr.h |    1 
 lib/idr.c            |    7 ++--
 lib/ridr.c           |   83 +++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 89 insertions(+), 3 deletions(-)

Index: linux-2.6.25-mm1/include/linux/ridr.h
===================================================================
--- linux-2.6.25-mm1.orig/include/linux/ridr.h	2008-04-29 14:31:43.000000000 +0200
+++ linux-2.6.25-mm1/include/linux/ridr.h	2008-04-29 14:34:53.000000000 +0200
@@ -63,6 +63,7 @@ void *ridr_find(struct ridr *, int);
 int ridr_pre_get(struct ridr *, gfp_t);
 int ridr_get_new(struct ridr *, void *, int *);
 int ridr_get_new_above(struct ridr *, void *, int, int *);
+void ridr_remove(struct ridr *, int);
 void ridr_init(struct ridr *);
 
 
Index: linux-2.6.25-mm1/include/linux/idr.h
===================================================================
--- linux-2.6.25-mm1.orig/include/linux/idr.h	2008-04-29 14:08:47.000000000 +0200
+++ linux-2.6.25-mm1/include/linux/idr.h	2008-04-29 14:35:37.000000000 +0200
@@ -91,6 +91,7 @@ static inline void _idr_set_new_slot(str
 
 void _idr_mark_full(struct idr_layer **, int);
 int _idr_sub_alloc(int *, int *, struct idr_layer **, struct idr_layer **);
+void _idr_remove_warning(const char *, int);
 
 /*
  * This is what we export.
Index: linux-2.6.25-mm1/lib/idr.c
===================================================================
--- linux-2.6.25-mm1.orig/lib/idr.c	2008-04-29 14:06:20.000000000 +0200
+++ linux-2.6.25-mm1/lib/idr.c	2008-04-29 14:40:12.000000000 +0200
@@ -356,9 +356,10 @@ int idr_get_new(struct idr *idp, void *p
 }
 EXPORT_SYMBOL(idr_get_new);
 
-static void idr_remove_warning(int id)
+void _idr_remove_warning(const char *caller, int id)
 {
-	printk("idr_remove called for id=%d which is not allocated.\n", id);
+	printk(KERN_INFO "%s called for id=%d which is not allocated.\n",
+		caller, id);
 	dump_stack();
 }
 
@@ -390,7 +391,7 @@ static void sub_remove(struct idr *idp, 
 		if (!*paa)
 			idp->layers = 0;
 	} else
-		idr_remove_warning(id);
+		_idr_remove_warning("idr_remove", id);
 }
 
 /**
Index: linux-2.6.25-mm1/lib/ridr.c
===================================================================
--- linux-2.6.25-mm1.orig/lib/ridr.c	2008-04-29 14:32:26.000000000 +0200
+++ linux-2.6.25-mm1/lib/ridr.c	2008-04-29 14:41:57.000000000 +0200
@@ -28,6 +28,19 @@ static struct ridr_layer *get_from_free_
 	return(q);
 }
 
+static void ridr_layer_rcu_free(struct rcu_head *head)
+{
+	struct ridr_layer *layer;
+
+	layer = container_of(head, struct ridr_layer, rcu_head);
+	kmem_cache_free(ridr_layer_cache, layer);
+}
+
+static inline void free_layer(struct ridr_layer *p)
+{
+	call_rcu(&p->rcu_head, ridr_layer_rcu_free);
+}
+
 /* only called when idp->lock is held */
 /* moves an ridr_layer to the free list */
 static void __move_to_free_list(struct ridr *idp, struct ridr_layer *p)
@@ -259,6 +272,76 @@ int ridr_get_new(struct ridr *idp, void 
 }
 EXPORT_SYMBOL(ridr_get_new);
 
+static void sub_remove(struct ridr *idp, int shift, int id)
+{
+	struct ridr_layer *p = idp->top;
+	struct ridr_layer **pa[MAX_LEVEL];
+	struct ridr_layer ***paa = &pa[0];
+	struct ridr_layer *to_free;
+	int n;
+
+	*paa = NULL;
+	*++paa = &idp->top;
+
+	while ((shift > 0) && p) {
+		n = (id >> shift) & IDR_MASK;
+		__clear_bit(n, &p->idr.bitmap);
+		*++paa = (struct ridr_layer **) &(p->idr.ary[n]);
+		p = p->idr.ary[n];
+		shift -= IDR_BITS;
+	}
+	n = id & IDR_MASK;
+	if (likely(p != NULL && test_bit(n, &p->idr.bitmap))) {
+		__clear_bit(n, &p->idr.bitmap);
+		rcu_assign_pointer(p->idr.ary[n], NULL);
+		to_free = NULL;
+		while (*paa && !--((**paa)->idr.count)) {
+			if (to_free)
+				free_layer(to_free);
+			to_free = **paa;
+			**paa-- = NULL;
+		}
+		if (!*paa)
+			idp->layers = 0;
+		if (to_free)
+			free_layer(to_free);
+	} else
+		_idr_remove_warning("ridr_remove", id);
+}
+/**
+ * ridr_remove - remove the given id and free it's slot
+ * @idp: ridr handle
+ * @id: unique key
+ */
+void ridr_remove(struct ridr *idp, int id)
+{
+	struct ridr_layer *p;
+	struct ridr_layer *to_free;
+
+	/* Mask off upper bits we don't use for the search. */
+	id &= MAX_ID_MASK;
+
+	sub_remove(idp, (idp->layers - 1) * IDR_BITS, id);
+	if (idp->top && idp->top->idr.count == 1 && (idp->layers > 1) &&
+	    idp->top->idr.ary[0]) {
+		/*
+		 * Single child at leftmost slot: we can shrink the tree.
+		 * This level is not needed anymore since when layers are
+		 * inserted, they are inserted at the top of the existing
+		 * tree.
+		 */
+		to_free = idp->top;
+		p = idp->top->idr.ary[0];
+		rcu_assign_pointer(idp->top, p);
+		--idp->layers;
+		to_free->idr.bitmap = to_free->idr.count = 0;
+		to_free->idr.ary[0] = NULL;
+		free_layer(to_free);
+	}
+	return;
+}
+EXPORT_SYMBOL(ridr_remove);
+
 /**
  * ridr_find - return pointer for given id
  * @idp: ridr handle

--
