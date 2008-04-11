Return-Path: <linux-kernel-owner+w=401wt.eu-S1761276AbYDKQVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761276AbYDKQVS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 12:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760576AbYDKQU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 12:20:28 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:34258 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760404AbYDKQU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 12:20:27 -0400
Message-Id: <20080411161958.430185000@bull.net>
References: <20080411161702.460410000@bull.net>
User-Agent: quilt/0.45-1
Date: Fri, 11 Apr 2008 18:17:05 +0200
From: Nadia.Derbey@bull.net
To: efault@gmx.de
Cc: manfred@colorfullife.com, linux-kernel@vger.kernel.org,
       paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
       peterz@infradead.org, xemul@openvz.org,
       Nadia Derbey <Nadia.Derbey@bull.net>
Subject: [PATCH 03/13] Fix ridr_pre_get()
Content-Disposition: inline; filename=ridr_pre_get.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 03/13]

This patch only fixes the ridr_pre_get() portion of ridr.c, to introduce a
per-cpu pool of preloaded ridr layer structures, and define the
ridr_pre_get[_end]() routines.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>

---
 include/linux/ridr.h |    7 ++++++-
 lib/ridr.c           |   50 ++++++++++++++++++++++++++++++++++++--------------
 2 files changed, 42 insertions(+), 15 deletions(-)

Index: linux-2.6.25-rc8-mm1/include/linux/ridr.h
===================================================================
--- linux-2.6.25-rc8-mm1.orig/include/linux/ridr.h	2008-04-11 17:34:35.000000000 +0200
+++ linux-2.6.25-rc8-mm1/include/linux/ridr.h	2008-04-11 17:41:20.000000000 +0200
@@ -61,10 +61,15 @@ do {									\
  */
 
 void *ridr_find(struct ridr *idp, int id);
-int ridr_pre_get(struct ridr *idp, gfp_t gfp_mask);
+int ridr_pre_get(gfp_t gfp_mask);
 int ridr_get_new(struct ridr *idp, void *ptr, int *id);
 void ridr_remove(struct ridr *idp, int id);
 
 void __init ridr_init_cache(void);
 
+static inline void ridr_pre_get_end(void)
+{
+	preempt_enable();
+}
+
 #endif /* _RIDR_H_ */
Index: linux-2.6.25-rc8-mm1/lib/ridr.c
===================================================================
--- linux-2.6.25-rc8-mm1.orig/lib/ridr.c	2008-04-11 17:30:28.000000000 +0200
+++ linux-2.6.25-rc8-mm1/lib/ridr.c	2008-04-11 17:40:13.000000000 +0200
@@ -13,6 +13,15 @@
 
 static struct kmem_cache *ridr_layer_cache;
 
+/*
+ * Per-cpu pool of preloaded layers
+ */
+struct ridr_preget {
+	int nr;
+	struct ridr_layer *layers[MAX_LEVEL];
+};
+DEFINE_PER_CPU(struct ridr_preget, ridr_pregets) = { 0, };
+
 static struct ridr_layer *alloc_layer(struct ridr *idp)
 {
 	struct ridr_layer *p;
@@ -75,23 +84,36 @@ static void ridr_mark_full(struct ridr_l
  * @idp:	ridr handle
  * @gfp_mask:	memory allocation flags
  *
- * This function should be called prior to locking and calling the
- * following function.  It preallocates enough memory to satisfy
- * the worst possible allocation.
+ * Load up this CPU's ridr_layer buffer with sufficient objects to
+ * ensure that the addition of a single element in the tree cannot fail.
  *
- * If the system is REALLY out of memory this function returns 0,
- * otherwise 1.
+ * If the system is REALLY out of memory this function returns 0, with
+ * preemption enabled.
+ * Otherwise 1, with preemption disabled.
  */
-int ridr_pre_get(struct ridr *idp, gfp_t gfp_mask)
+int ridr_pre_get(gfp_t gfp_mask)
 {
-	while (idp->id_free_cnt < IDR_FREE_MAX) {
-		struct ridr_layer *new;
-		new = kmem_cache_alloc(ridr_layer_cache, gfp_mask);
-		if (new == NULL)
-			return (0);
-		free_layer(idp, new);
-	}
-	return 1;
+	struct ridr_preget *idp;
+	struct ridr_layer *layer;
+	int ret = 0;
+
+	preempt_disable();
+	idp = &__get_cpu_var(ridr_pregets);
+	while (idp->nr < ARRAY_SIZE(idp->layers)) {
+		preempt_enable();
+		layer = kmem_cache_alloc(ridr_layer_cache, gfp_mask);
+		if (layer == NULL)
+			goto out;
+		preempt_disable();
+		idp = &__get_cpu_var(ridr_pregets);
+		if (idp->nr < ARRAY_SIZE(idp->layers))
+			idp->layers[idp->nr++] = layer;
+		else
+			kmem_cache_free(ridr_layer_cache, layer);
+	}
+	ret = 1;
+out:
+	return ret;
 }
 EXPORT_SYMBOL(ridr_pre_get);
 

--
