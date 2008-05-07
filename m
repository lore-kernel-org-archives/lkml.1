Return-Path: <linux-kernel-owner+w=401wt.eu-S1758691AbYEGLj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758691AbYEGLj4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 07:39:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756639AbYEGLiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 07:38:13 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:56385 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755238AbYEGLhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 07:37:45 -0400
Message-Id: <20080507113736.754796000@bull.net>
References: <20080507113553.395937000@bull.net>
User-Agent: quilt/0.45-1
Date: Wed, 07 May 2008 13:35:58 +0200
From: Nadia.Derbey@bull.net
To: manfred@colorfullife.com, paulmck@linux.vnet.ibm.com,
       lnxninja@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, efault@gmx.de, akpm@linux-foundation.org,
       Nadia Derbey <Nadia.Derbey@bull.net>
Subject: [PATCH 5/9] Make idr_get_new* rcu-safe
Content-Disposition: inline; filename=idr_get_new_rcu_safe.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 05/09]

This is a patch that make the idr_get_new* routines rcu-safe.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>

---
 lib/idr.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

Index: linux-2.6.25-mm1/lib/idr.c
===================================================================
--- linux-2.6.25-mm1.orig/lib/idr.c	2008-05-06 17:38:42.000000000 +0200
+++ linux-2.6.25-mm1/lib/idr.c	2008-05-06 18:02:07.000000000 +0200
@@ -6,6 +6,8 @@
  * Modified by George Anzinger to reuse immediately and to use
  * find bit instructions.  Also removed _irq on spinlocks.
  *
+ * Modified by Nadia Derbey to make it RCU safe.
+ *
  * Small id to pointer translation service.
  *
  * It uses a radix tree like structure as a sparse array indexed
@@ -96,7 +98,7 @@ static void idr_mark_full(struct idr_lay
  * @gfp_mask:	memory allocation flags
  *
  * This function should be called prior to locking and calling the
- * following function.  It preallocates enough memory to satisfy
+ * idr_get_new* functions. It preallocates enough memory to satisfy
  * the worst possible allocation.
  *
  * If the system is REALLY out of memory this function returns 0,
@@ -170,7 +172,8 @@ static int sub_alloc(struct idr *idp, in
 			new = get_from_free_list(idp);
 			if (!new)
 				return -1;
-			p->ary[m] = new;
+			INIT_RCU_HEAD(&new->rcu_head);
+			rcu_assign_pointer(p->ary[m], new);
 			p->count++;
 		}
 		pa[l--] = p;
@@ -195,6 +198,7 @@ build_up:
 	if (unlikely(!p)) {
 		if (!(p = get_from_free_list(idp)))
 			return -1;
+		INIT_RCU_HEAD(&p->rcu_head);
 		layers = 1;
 	}
 	/*
@@ -222,11 +226,12 @@ build_up:
 		}
 		new->ary[0] = p;
 		new->count = 1;
+		INIT_RCU_HEAD(&new->rcu_head);
 		if (p->bitmap == IDR_FULL)
 			__set_bit(0, &new->bitmap);
 		p = new;
 	}
-	idp->top = p;
+	rcu_assign_pointer(idp->top, p);
 	idp->layers = layers;
 	v = sub_alloc(idp, &id, pa);
 	if (v == IDR_NEED_TO_GROW)
@@ -245,7 +250,8 @@ static int idr_get_new_above_int(struct 
 		 * Successfully found an empty slot.  Install the user
 		 * pointer and mark the slot full.
 		 */
-		pa[0]->ary[id & IDR_MASK] = (struct idr_layer *)ptr;
+		rcu_assign_pointer(pa[0]->ary[id & IDR_MASK],
+				(struct idr_layer *)ptr);
 		pa[0]->count++;
 		idr_mark_full(pa, id);
 	}
@@ -710,7 +716,8 @@ int ida_get_new_above(struct ida *ida, i
 			return -EAGAIN;
 
 		memset(bitmap, 0, sizeof(struct ida_bitmap));
-		pa[0]->ary[idr_id & IDR_MASK] = (void *)bitmap;
+		rcu_assign_pointer(pa[0]->ary[idr_id & IDR_MASK],
+				(void *)bitmap);
 		pa[0]->count++;
 	}
 

--
