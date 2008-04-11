Return-Path: <linux-kernel-owner+w=401wt.eu-S1761473AbYDKQVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761473AbYDKQVo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 12:21:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760784AbYDKQUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 12:20:35 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:34326 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760744AbYDKQUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 12:20:33 -0400
Message-Id: <20080411161959.565271000@bull.net>
References: <20080411161702.460410000@bull.net>
User-Agent: quilt/0.45-1
Date: Fri, 11 Apr 2008 18:17:07 +0200
From: Nadia.Derbey@bull.net
To: efault@gmx.de
Cc: manfred@colorfullife.com, linux-kernel@vger.kernel.org,
       paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
       peterz@infradead.org, xemul@openvz.org,
       Nadia Derbey <Nadia.Derbey@bull.net>
Subject: [PATCH 05/13] Fix free_layer()
Content-Disposition: inline; filename=ridr_free_layer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 05/13]

This patch only fixes the free_layer() portion of ridr.c, to make it use
call_rcu().

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>

---
 lib/ridr.c |   27 ++++++++++-----------------
 1 file changed, 10 insertions(+), 17 deletions(-)

Index: linux-2.6.25-rc8-mm1/lib/ridr.c
===================================================================
--- linux-2.6.25-rc8-mm1.orig/lib/ridr.c	2008-04-11 17:43:44.000000000 +0200
+++ linux-2.6.25-rc8-mm1/lib/ridr.c	2008-04-11 17:47:48.000000000 +0200
@@ -53,24 +53,17 @@ static struct ridr_layer *alloc_layer(st
 	return ret;
 }
 
-/* only called when idp->lock is held */
-static void __free_layer(struct ridr *idp, struct ridr_layer *p)
+static void ridr_layer_rcu_free(struct rcu_head *head)
 {
-	p->ary[0] = idp->id_free;
-	idp->id_free = p;
-	idp->id_free_cnt++;
+	struct ridr_layer *layer;
+
+	layer = container_of(head, struct ridr_layer, rcu_head);
+	kmem_cache_free(ridr_layer_cache, layer);
 }
 
-static void free_layer(struct ridr *idp, struct ridr_layer *p)
+static inline void free_layer(struct ridr_layer *p)
 {
-	unsigned long flags;
-
-	/*
-	 * Depends on the return element being zeroed.
-	 */
-	spin_lock_irqsave(&idp->lock, flags);
-	__free_layer(idp, p);
-	spin_unlock_irqrestore(&idp->lock, flags);
+	call_rcu(&p->rcu_head, ridr_layer_rcu_free);
 }
 
 static void ridr_mark_full(struct ridr_layer **pa, int id)
@@ -236,7 +229,7 @@ build_up:
 				p = p->ary[0];
 				new->ary[0] = NULL;
 				new->bitmap = new->count = 0;
-				__free_layer(idp, new);
+				free_layer(new);
 			}
 			spin_unlock_irqrestore(&idp->lock, flags);
 			return -1;
@@ -337,7 +330,7 @@ static void sub_remove(struct ridr *idp,
 		__clear_bit(n, &p->bitmap);
 		p->ary[n] = NULL;
 		while (*paa && !--((**paa)->count)) {
-			free_layer(idp, **paa);
+			free_layer(**paa);
 			**paa-- = NULL;
 		}
 		if (!*paa)
@@ -364,7 +357,7 @@ void ridr_remove(struct ridr *idp, int i
 
 		p = idp->top->ary[0];
 		idp->top->bitmap = idp->top->count = 0;
-		free_layer(idp, idp->top);
+		free_layer(idp->top);
 		idp->top = p;
 		--idp->layers;
 	}

--
