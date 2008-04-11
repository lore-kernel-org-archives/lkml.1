Return-Path: <linux-kernel-owner+w=401wt.eu-S1761372AbYDKQVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761372AbYDKQVc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 12:21:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760769AbYDKQUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 12:20:35 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:34330 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760742AbYDKQUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 12:20:33 -0400
Message-Id: <20080411161959.113244000@bull.net>
References: <20080411161702.460410000@bull.net>
User-Agent: quilt/0.45-1
Date: Fri, 11 Apr 2008 18:17:06 +0200
From: Nadia.Derbey@bull.net
To: efault@gmx.de
Cc: manfred@colorfullife.com, linux-kernel@vger.kernel.org,
       paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
       peterz@infradead.org, xemul@openvz.org,
       Nadia Derbey <Nadia.Derbey@bull.net>
Subject: [PATCH 04/13] Fix ridr_alloc_layer()
Content-Disposition: inline; filename=ridr_alloc_layer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 04/13]

This patch only fixes the alloc_layer() portion of ridr.c, to make it use the
per-cpu pool of preloaded ridr layer structures.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>

---
 lib/ridr.c |   35 +++++++++++++++++++++++++----------
 1 file changed, 25 insertions(+), 10 deletions(-)

Index: linux-2.6.25-rc8-mm1/lib/ridr.c
===================================================================
--- linux-2.6.25-rc8-mm1.orig/lib/ridr.c	2008-04-11 17:40:13.000000000 +0200
+++ linux-2.6.25-rc8-mm1/lib/ridr.c	2008-04-11 17:43:44.000000000 +0200
@@ -22,20 +22,35 @@ struct ridr_preget {
 };
 DEFINE_PER_CPU(struct ridr_preget, ridr_pregets) = { 0, };
 
+static inline gfp_t ridr_gfp_mask(struct ridr *idp)
+{
+	return idp->gfp_mask & __GFP_BITS_MASK;
+}
+
 static struct ridr_layer *alloc_layer(struct ridr *idp)
 {
-	struct ridr_layer *p;
-	unsigned long flags;
+	struct ridr_layer *ret = NULL;
+	gfp_t gfp_mask = ridr_gfp_mask(idp);
 
-	spin_lock_irqsave(&idp->lock, flags);
-	p = idp->id_free;
-	if (p) {
-		idp->id_free = p->ary[0];
-		idp->id_free_cnt--;
-		p->ary[0] = NULL;
+	if (!(gfp_mask & __GFP_WAIT)) {
+		struct ridr_preget *ridp;
+
+		/*
+		 * Provided the caller has preloaded here, we will always
+		 * succeed in getting a node here (and never reach
+		 * kmem_cache_alloc)
+		 */
+		ridp = &__get_cpu_var(ridr_pregets);
+		if (ridp->nr) {
+			ret = ridp->layers[ridp->nr - 1];
+			ridp->layers[ridp->nr - 1] = NULL;
+			ridp->nr--;
+		}
 	}
-	spin_unlock_irqrestore(&idp->lock, flags);
-	return(p);
+	if (ret == NULL)
+		ret = kmem_cache_alloc(ridr_layer_cache, gfp_mask);
+
+	return ret;
 }
 
 /* only called when idp->lock is held */

--
