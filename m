Return-Path: <linux-kernel-owner+w=401wt.eu-S1761973AbYDKQWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761973AbYDKQWz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 12:22:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760895AbYDKQUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 12:20:42 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:34384 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760875AbYDKQUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 12:20:41 -0400
Message-Id: <20080411162001.732385000@bull.net>
References: <20080411161702.460410000@bull.net>
User-Agent: quilt/0.45-1
Date: Fri, 11 Apr 2008 18:17:11 +0200
From: Nadia.Derbey@bull.net
To: efault@gmx.de
Cc: manfred@colorfullife.com, linux-kernel@vger.kernel.org,
       paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
       peterz@infradead.org, xemul@openvz.org,
       Nadia Derbey <Nadia.Derbey@bull.net>
Subject: [PATCH 09/13] Fix ridr_remove()
Content-Disposition: inline; filename=ridr_remove.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 09/13]

This patch only fixes the sub_remove() and ridr_remove() portions of ridr.c,
to make them RCU based.

Note: also fixes idr_remove(): looks like there is a return that is not at the
right place.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>

---
 include/linux/idr.h |    1 +
 lib/idr.c           |    9 +++++----
 lib/ridr.c          |   29 +++++++++++++----------------
 3 files changed, 19 insertions(+), 20 deletions(-)

Index: linux-2.6.25-rc8-mm1/lib/ridr.c
===================================================================
--- linux-2.6.25-rc8-mm1.orig/lib/ridr.c	2008-04-11 17:58:41.000000000 +0200
+++ linux-2.6.25-rc8-mm1/lib/ridr.c	2008-04-11 18:04:08.000000000 +0200
@@ -300,17 +300,12 @@ int ridr_get_new(struct ridr *idp, void 
 }
 EXPORT_SYMBOL(ridr_get_new);
 
-static void ridr_remove_warning(int id)
-{
-	printk("ridr_remove called for id=%d which is not allocated.\n", id);
-	dump_stack();
-}
-
 static void sub_remove(struct ridr *idp, int shift, int id)
 {
 	struct ridr_layer *p = idp->top;
 	struct ridr_layer **pa[MAX_LEVEL];
 	struct ridr_layer ***paa = &pa[0];
+	struct ridr_layer *to_free;
 	int n;
 
 	*paa = NULL;
@@ -327,14 +322,19 @@ static void sub_remove(struct ridr *idp,
 	if (likely(p != NULL && test_bit(n, &p->bitmap))) {
 		__clear_bit(n, &p->bitmap);
 		p->ary[n] = NULL;
+		to_free = NULL;
 		while (*paa && !--((**paa)->count)) {
-			free_layer(**paa);
+			if (to_free)
+				free_layer(to_free);
+			to_free = **paa;
 			**paa-- = NULL;
 		}
 		if (!*paa)
 			idp->layers = 0;
+		if (to_free)
+			free_layer(to_free);
 	} else
-		ridr_remove_warning(id);
+		idr_remove_warning("ridr_remove", id);
 }
 
 /**
@@ -344,7 +344,7 @@ static void sub_remove(struct ridr *idp,
  */
 void ridr_remove(struct ridr *idp, int id)
 {
-	struct ridr_layer *p;
+	struct ridr_layer *p, *to_free;
 
 	/* Mask off upper bits we don't use for the search. */
 	id &= MAX_ID_MASK;
@@ -353,17 +353,14 @@ void ridr_remove(struct ridr *idp, int i
 	if (idp->top && idp->top->count == 1 && (idp->layers > 1) &&
 	    idp->top->ary[0]) {  /* We can drop a layer */
 
+		to_free = idp->top;
 		p = idp->top->ary[0];
-		idp->top->bitmap = idp->top->count = 0;
-		free_layer(idp->top);
 		idp->top = p;
 		--idp->layers;
+		to_free->bitmap = to_free->count = 0;
+		free_layer(to_free);
 	}
-	while (idp->id_free_cnt >= IDR_FREE_MAX) {
-		p = alloc_layer(idp);
-		kmem_cache_free(ridr_layer_cache, p);
-		return;
-	}
+	return;
 }
 EXPORT_SYMBOL(ridr_remove);
 
Index: linux-2.6.25-rc8-mm1/include/linux/idr.h
===================================================================
--- linux-2.6.25-rc8-mm1.orig/include/linux/idr.h	2008-04-11 17:14:05.000000000 +0200
+++ linux-2.6.25-rc8-mm1/include/linux/idr.h	2008-04-11 18:05:09.000000000 +0200
@@ -117,5 +117,6 @@ void ida_destroy(struct ida *ida);
 void ida_init(struct ida *ida);
 
 void __init idr_init_cache(void);
+void idr_remove_warning(const char *, int);
 
 #endif /* __IDR_H__ */
Index: linux-2.6.25-rc8-mm1/lib/idr.c
===================================================================
--- linux-2.6.25-rc8-mm1.orig/lib/idr.c	2008-04-11 17:14:08.000000000 +0200
+++ linux-2.6.25-rc8-mm1/lib/idr.c	2008-04-11 18:06:46.000000000 +0200
@@ -323,9 +323,10 @@ int idr_get_new(struct idr *idp, void *p
 }
 EXPORT_SYMBOL(idr_get_new);
 
-static void idr_remove_warning(int id)
+void idr_remove_warning(const char *name, int id)
 {
-	printk("idr_remove called for id=%d which is not allocated.\n", id);
+	printk(KERN_WARNING
+		"%s called for id=%d which is not allocated.\n", name, id);
 	dump_stack();
 }
 
@@ -357,7 +358,7 @@ static void sub_remove(struct idr *idp, 
 		if (!*paa)
 			idp->layers = 0;
 	} else
-		idr_remove_warning(id);
+		idr_remove_warning("idr_remove", id);
 }
 
 /**
@@ -385,8 +386,8 @@ void idr_remove(struct idr *idp, int id)
 	while (idp->id_free_cnt >= IDR_FREE_MAX) {
 		p = alloc_layer(idp);
 		kmem_cache_free(idr_layer_cache, p);
-		return;
 	}
+	return;
 }
 EXPORT_SYMBOL(idr_remove);
 

--
