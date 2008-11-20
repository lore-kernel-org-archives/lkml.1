Return-Path: <linux-kernel-owner+w=401wt.eu-S1756665AbYKTTjE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665AbYKTTjE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 14:39:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754433AbYKTTix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 14:38:53 -0500
Received: from sing.entic.net ([208.64.63.147]:34671 "EHLO mail.q-ag.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827AbYKTTiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 14:38:52 -0500
X-Greylist: delayed 2112 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Nov 2008 14:38:52 EST
Message-Id: <200811201903.mAKJ3Fqu016272@mail.q-ag.de>
From: Manfred Spraul <manfred@colorfullife.com>
To: akpm@linux-foundation.org
Cc: Nadia.Derbey@bull.net
Cc: cboulte@gmail.com
Cc: linux-kernel@vger.kernel.org
Date: Thu, 20 Nov 2008 19:55:47 +0100
Subject: [PATCH] lib/idr.c: Fix rcu related race with idr_find
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2nd part of the fixes needed for
http://bugzilla.kernel.org/show_bug.cgi?id=11796.

When the idr tree is either grown or shrunk, then the update to the
number of layers and the top pointer were not atomic.
This race caused crashes.

The attached patch fixes that by replicating the layers counter in
each layer, thus idr_find doesn't need idp->layers anymore.

Andrew - could you add it to -mm? It survived some simple tests.
In the long run, it's something for the stable kernel, but it needs
more testing.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
---
 include/linux/idr.h |    3 ++-
 lib/idr.c           |   14 ++++++++++++--
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/include/linux/idr.h b/include/linux/idr.h
index fa035f9..dd846df 100644
--- a/include/linux/idr.h
+++ b/include/linux/idr.h
@@ -52,13 +52,14 @@ struct idr_layer {
 	unsigned long		 bitmap; /* A zero bit means "space here" */
 	struct idr_layer	*ary[1<<IDR_BITS];
 	int			 count;	 /* When zero, we can release it */
+	int			 layer;	 /* distance from leaf */
 	struct rcu_head		 rcu_head;
 };
 
 struct idr {
 	struct idr_layer *top;
 	struct idr_layer *id_free;
-	int		  layers;
+	int		  layers; /* only valid without concurrent changes */
 	int		  id_free_cnt;
 	spinlock_t	  lock;
 };
diff --git a/lib/idr.c b/lib/idr.c
index e728c7f..7a785a0 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -185,6 +185,7 @@ static int sub_alloc(struct idr *idp, int *starting_id, struct idr_layer **pa)
 			new = get_from_free_list(idp);
 			if (!new)
 				return -1;
+			new->layer = l-1;
 			rcu_assign_pointer(p->ary[m], new);
 			p->count++;
 		}
@@ -210,6 +211,7 @@ build_up:
 	if (unlikely(!p)) {
 		if (!(p = get_from_free_list(idp)))
 			return -1;
+		p->layer = 0;
 		layers = 1;
 	}
 	/*
@@ -237,6 +239,7 @@ build_up:
 		}
 		new->ary[0] = p;
 		new->count = 1;
+		new->layer = layers-1;
 		if (p->bitmap == IDR_FULL)
 			__set_bit(0, &new->bitmap);
 		p = new;
@@ -493,17 +496,21 @@ void *idr_find(struct idr *idp, int id)
 	int n;
 	struct idr_layer *p;
 
-	n = idp->layers * IDR_BITS;
 	p = rcu_dereference(idp->top);
+	if (!p)
+		return NULL;
+	n = (p->layer+1) * IDR_BITS;
 
 	/* Mask off upper bits we don't use for the search. */
 	id &= MAX_ID_MASK;
 
 	if (id >= (1 << n))
 		return NULL;
+	BUG_ON(n == 0);
 
 	while (n > 0 && p) {
 		n -= IDR_BITS;
+		BUG_ON(n != p->layer*IDR_BITS);
 		p = rcu_dereference(p->ary[(id >> n) & IDR_MASK]);
 	}
 	return((void *)p);
@@ -582,8 +589,11 @@ void *idr_replace(struct idr *idp, void *ptr, int id)
 	int n;
 	struct idr_layer *p, *old_p;
 
-	n = idp->layers * IDR_BITS;
 	p = idp->top;
+	if (!p)
+		return ERR_PTR(-EINVAL);
+
+	n = (p->layer+1) * IDR_BITS;
 
 	id &= MAX_ID_MASK;
 
-- 
1.5.6.5

