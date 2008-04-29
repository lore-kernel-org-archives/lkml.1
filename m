Return-Path: <linux-kernel-owner+w=401wt.eu-S1763408AbYD2Oim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763408AbYD2Oim (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 10:38:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759570AbYD2Ohn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 10:37:43 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:49771 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760922AbYD2Ohm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 10:37:42 -0400
Message-Id: <20080429143729.421784000@bull.net>
References: <20080429143304.741001000@bull.net>
User-Agent: quilt/0.45-1
Date: Tue, 29 Apr 2008 16:33:07 +0200
From: Nadia.Derbey@bull.net
To: manfred@colorfullife.com, paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, efault@gmx.de, akpm@linux-foundation.org,
       Nadia Derbey <Nadia.Derbey@bull.net>
Subject: [PATCH 03/10] Introduce ridr_pre_get()
Content-Disposition: inline; filename=ridr_pre_get.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 03/10]

This patch introduces the ridr_pre_get() routine.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>

---
 include/linux/ridr.h |    1 +
 lib/ridr.c           |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+)

Index: linux-2.6.25-mm1/include/linux/ridr.h
===================================================================
--- linux-2.6.25-mm1.orig/include/linux/ridr.h	2008-04-29 13:08:00.000000000 +0200
+++ linux-2.6.25-mm1/include/linux/ridr.h	2008-04-29 13:14:56.000000000 +0200
@@ -43,6 +43,7 @@ struct ridr {
 /*
  * This is what we export.
  */
+int ridr_pre_get(struct ridr *, gfp_t);
 
 
 void __init ridr_init_cache(void);
Index: linux-2.6.25-mm1/lib/ridr.c
===================================================================
--- linux-2.6.25-mm1.orig/lib/ridr.c	2008-04-29 13:08:05.000000000 +0200
+++ linux-2.6.25-mm1/lib/ridr.c	2008-04-29 13:17:59.000000000 +0200
@@ -11,6 +11,52 @@
 static struct kmem_cache *ridr_layer_cache;
 
 
+/* only called when idp->lock is held */
+/* moves an ridr_layer to the free list */
+static void __move_to_free_list(struct ridr *idp, struct ridr_layer *p)
+{
+	p->idr.ary[0] = idp->id_free;
+	idp->id_free = p;
+	idp->id_free_cnt++;
+}
+
+static void move_to_free_list(struct ridr *idp, struct ridr_layer *p)
+{
+	unsigned long flags;
+
+	/*
+	 * Depends on the return element being zeroed.
+	 */
+	spin_lock_irqsave(&idp->lock, flags);
+	__move_to_free_list(idp, p);
+	spin_unlock_irqrestore(&idp->lock, flags);
+}
+
+/**
+ * ridr_pre_get - reserver resources for ridr allocation
+ * @idp:	ridr handle
+ * @gfp_mask:	memory allocation flags
+ *
+ * This function should be called prior to locking and calling the
+ * ridr_get_new* functions. It preallocates enough memory to satisfy
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
+		move_to_free_list(idp, new);
+	}
+	return 1;
+}
+EXPORT_SYMBOL(ridr_pre_get);
+
 static void ridr_cache_ctor(struct kmem_cache *ridr_layer_cache,
 			void *ridr_layer)
 {

--
