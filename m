Return-Path: <linux-kernel-owner+w=401wt.eu-S1755248AbYEGLjG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248AbYEGLjG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 07:39:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756513AbYEGLiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 07:38:11 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:56312 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914AbYEGLhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 07:37:37 -0400
Message-Id: <20080507113735.543603000@bull.net>
References: <20080507113553.395937000@bull.net>
User-Agent: quilt/0.45-1
Date: Wed, 07 May 2008 13:35:55 +0200
From: Nadia.Derbey@bull.net
To: manfred@colorfullife.com, paulmck@linux.vnet.ibm.com,
       lnxninja@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, efault@gmx.de, akpm@linux-foundation.org,
       Nadia Derbey <Nadia.Derbey@bull.net>
Subject: [PATCH 2/9] Rename some of the idr APIs internal routines
Content-Disposition: inline; filename=idr_rename_routines.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 02/09]

This is a trivial patch that renames:
   . alloc_layer to get_from_free_list since it idr_pre_get that actually
     allocates memory.
   . free_layer to move_to_free_list since memory is not actually freed there.

This makes things more clear for the next patches.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>

---
 lib/idr.c |   31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

Index: linux-2.6.25-mm1/lib/idr.c
===================================================================
--- linux-2.6.25-mm1.orig/lib/idr.c	2008-05-06 17:14:30.000000000 +0200
+++ linux-2.6.25-mm1/lib/idr.c	2008-05-06 17:36:36.000000000 +0200
@@ -35,7 +35,7 @@
 
 static struct kmem_cache *idr_layer_cache;
 
-static struct idr_layer *alloc_layer(struct idr *idp)
+static struct idr_layer *get_from_free_list(struct idr *idp)
 {
 	struct idr_layer *p;
 	unsigned long flags;
@@ -51,14 +51,14 @@ static struct idr_layer *alloc_layer(str
 }
 
 /* only called when idp->lock is held */
-static void __free_layer(struct idr *idp, struct idr_layer *p)
+static void __move_to_free_list(struct idr *idp, struct idr_layer *p)
 {
 	p->ary[0] = idp->id_free;
 	idp->id_free = p;
 	idp->id_free_cnt++;
 }
 
-static void free_layer(struct idr *idp, struct idr_layer *p)
+static void move_to_free_list(struct idr *idp, struct idr_layer *p)
 {
 	unsigned long flags;
 
@@ -66,7 +66,7 @@ static void free_layer(struct idr *idp, 
 	 * Depends on the return element being zeroed.
 	 */
 	spin_lock_irqsave(&idp->lock, flags);
-	__free_layer(idp, p);
+	__move_to_free_list(idp, p);
 	spin_unlock_irqrestore(&idp->lock, flags);
 }
 
@@ -109,7 +109,7 @@ int idr_pre_get(struct idr *idp, gfp_t g
 		new = kmem_cache_alloc(idr_layer_cache, gfp_mask);
 		if (new == NULL)
 			return (0);
-		free_layer(idp, new);
+		move_to_free_list(idp, new);
 	}
 	return 1;
 }
@@ -167,7 +167,8 @@ static int sub_alloc(struct idr *idp, in
 		 * Create the layer below if it is missing.
 		 */
 		if (!p->ary[m]) {
-			if (!(new = alloc_layer(idp)))
+			new = get_from_free_list(idp);
+			if (!new)
 				return -1;
 			p->ary[m] = new;
 			p->count++;
@@ -192,7 +193,7 @@ build_up:
 	p = idp->top;
 	layers = idp->layers;
 	if (unlikely(!p)) {
-		if (!(p = alloc_layer(idp)))
+		if (!(p = get_from_free_list(idp)))
 			return -1;
 		layers = 1;
 	}
@@ -204,7 +205,7 @@ build_up:
 		layers++;
 		if (!p->count)
 			continue;
-		if (!(new = alloc_layer(idp))) {
+		if (!(new = get_from_free_list(idp))) {
 			/*
 			 * The allocation failed.  If we built part of
 			 * the structure tear it down.
@@ -214,7 +215,7 @@ build_up:
 				p = p->ary[0];
 				new->ary[0] = NULL;
 				new->bitmap = new->count = 0;
-				__free_layer(idp, new);
+				__move_to_free_list(idp, new);
 			}
 			spin_unlock_irqrestore(&idp->lock, flags);
 			return -1;
@@ -351,7 +352,7 @@ static void sub_remove(struct idr *idp, 
 		__clear_bit(n, &p->bitmap);
 		p->ary[n] = NULL;
 		while(*paa && ! --((**paa)->count)){
-			free_layer(idp, **paa);
+			move_to_free_list(idp, **paa);
 			**paa-- = NULL;
 		}
 		if (!*paa)
@@ -378,12 +379,12 @@ void idr_remove(struct idr *idp, int id)
 
 		p = idp->top->ary[0];
 		idp->top->bitmap = idp->top->count = 0;
-		free_layer(idp, idp->top);
+		move_to_free_list(idp, idp->top);
 		idp->top = p;
 		--idp->layers;
 	}
 	while (idp->id_free_cnt >= IDR_FREE_MAX) {
-		p = alloc_layer(idp);
+		p = get_from_free_list(idp);
 		kmem_cache_free(idr_layer_cache, p);
 		return;
 	}
@@ -426,7 +427,7 @@ void idr_remove_all(struct idr *idp)
 		while (n < fls(id)) {
 			if (p) {
 				memset(p, 0, sizeof *p);
-				free_layer(idp, p);
+				move_to_free_list(idp, p);
 			}
 			n += IDR_BITS;
 			p = *--paa;
@@ -444,7 +445,7 @@ EXPORT_SYMBOL(idr_remove_all);
 void idr_destroy(struct idr *idp)
 {
 	while (idp->id_free_cnt) {
-		struct idr_layer *p = alloc_layer(idp);
+		struct idr_layer *p = get_from_free_list(idp);
 		kmem_cache_free(idr_layer_cache, p);
 	}
 }
@@ -749,7 +750,7 @@ int ida_get_new_above(struct ida *ida, i
 	 * allocation.
 	 */
 	if (ida->idr.id_free_cnt || ida->free_bitmap) {
-		struct idr_layer *p = alloc_layer(&ida->idr);
+		struct idr_layer *p = get_from_free_list(&ida->idr);
 		if (p)
 			kmem_cache_free(idr_layer_cache, p);
 	}

--
