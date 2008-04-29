Return-Path: <linux-kernel-owner+w=401wt.eu-S933053AbYD2OkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933053AbYD2OkU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 10:40:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761398AbYD2Ohy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 10:37:54 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:49844 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761383AbYD2Ohw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 10:37:52 -0400
Message-Id: <20080429143730.898334000@bull.net>
References: <20080429143304.741001000@bull.net>
User-Agent: quilt/0.45-1
Date: Tue, 29 Apr 2008 16:33:11 +0200
From: Nadia.Derbey@bull.net
To: manfred@colorfullife.com, paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, efault@gmx.de, akpm@linux-foundation.org,
       Nadia Derbey <Nadia.Derbey@bull.net>
Subject: [PATCH 07/10] Introduce ridr_find()
Content-Disposition: inline; filename=ridr_find.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 07/10]

This patch introduces the ridr_find() routine.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>

---
 include/linux/ridr.h |   17 +++++++++++++++++
 lib/ridr.c           |   34 ++++++++++++++++++++++++++++++++++
 2 files changed, 51 insertions(+)

Index: linux-2.6.25-mm1/include/linux/ridr.h
===================================================================
--- linux-2.6.25-mm1.orig/include/linux/ridr.h	2008-04-29 14:16:09.000000000 +0200
+++ linux-2.6.25-mm1/include/linux/ridr.h	2008-04-29 14:31:43.000000000 +0200
@@ -40,9 +40,26 @@ struct ridr {
 #define idr_to_ridr(p) container_of((p), struct ridr_layer, idr)
 #define ridr_to_idr(p) (&((p)->idr))
 
+/**
+ * Ridr synchronization (see radix-tree.h)
+ *
+ * ridr_find() is able to be called locklessly, using RCU. The caller must
+ * ensure calls to this function are made within rcu_read_lock() regions.
+ * Other readers (lock-free or otherwise) and modifications may be running
+ * concurrently.
+ *
+ * It is still required that the caller manage the synchronization and
+ * lifetimes of the items. So if RCU lock-free lookups are used, typically
+ * this would mean that the items have their own locks, or are amenable to
+ * lock-free access; and that the items are freed by RCU (or only freed after
+ * having been deleted from the ridr tree *and* a synchronize_rcu() grace
+ * period).
+ */
+
 /*
  * This is what we export.
  */
+void *ridr_find(struct ridr *, int);
 int ridr_pre_get(struct ridr *, gfp_t);
 int ridr_get_new(struct ridr *, void *, int *);
 int ridr_get_new_above(struct ridr *, void *, int, int *);
Index: linux-2.6.25-mm1/lib/ridr.c
===================================================================
--- linux-2.6.25-mm1.orig/lib/ridr.c	2008-04-29 14:17:05.000000000 +0200
+++ linux-2.6.25-mm1/lib/ridr.c	2008-04-29 14:32:26.000000000 +0200
@@ -259,6 +259,40 @@ int ridr_get_new(struct ridr *idp, void 
 }
 EXPORT_SYMBOL(ridr_get_new);
 
+/**
+ * ridr_find - return pointer for given id
+ * @idp: ridr handle
+ * @id: lookup key
+ *
+ * Return the pointer given the id it has been registered with.  A %NULL
+ * return indicates that @id is not valid or you passed %NULL in
+ * ridr_get_new().
+ *
+ * This function can be called under rcu_read_lock(), given that the leaf
+ * pointers lifetimes are correctly managed.
+ */
+void *ridr_find(struct ridr *idp, int id)
+{
+	int n;
+	struct ridr_layer *p;
+
+	n = idp->layers * IDR_BITS;
+	p = rcu_dereference(idp->top);
+
+	/* Mask off upper bits we don't use for the search. */
+	id &= MAX_ID_MASK;
+
+	if (id >= (1 << n))
+		return NULL;
+
+	while (n > 0 && p) {
+		n -= IDR_BITS;
+		p = rcu_dereference(p->idr.ary[(id >> n) & IDR_MASK]);
+	}
+	return((void *)p);
+}
+EXPORT_SYMBOL(ridr_find);
+
 static void ridr_cache_ctor(struct kmem_cache *ridr_layer_cache,
 			void *ridr_layer)
 {

--
