Return-Path: <linux-kernel-owner+w=401wt.eu-S1761682AbYDKQWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761682AbYDKQWW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 12:22:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760850AbYDKQUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 12:20:39 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:34356 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760837AbYDKQUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 12:20:37 -0400
Message-Id: <20080411162000.819325000@bull.net>
References: <20080411161702.460410000@bull.net>
User-Agent: quilt/0.45-1
Date: Fri, 11 Apr 2008 18:17:09 +0200
From: Nadia.Derbey@bull.net
To: efault@gmx.de
Cc: manfred@colorfullife.com, linux-kernel@vger.kernel.org,
       paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
       peterz@infradead.org, xemul@openvz.org,
       Nadia Derbey <Nadia.Derbey@bull.net>
Subject: [PATCH 07/13] Fix get_empty_slot()
Content-Disposition: inline; filename=ridr_get_empty_slot.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 07/13]

This patch only fixes the ridr_get_empty_slot() portion of ridr.c, to make
it RCU based.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>

---
 lib/ridr.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

Index: linux-2.6.25-rc8-mm1/lib/ridr.c
===================================================================
--- linux-2.6.25-rc8-mm1.orig/lib/ridr.c	2008-04-11 17:51:34.000000000 +0200
+++ linux-2.6.25-rc8-mm1/lib/ridr.c	2008-04-11 17:55:37.000000000 +0200
@@ -198,7 +198,6 @@ static int ridr_get_empty_slot(struct ri
 {
 	struct ridr_layer *p, *new;
 	int layers, v, id;
-	unsigned long flags;
 
 	id = starting_id;
 build_up:
@@ -224,23 +223,21 @@ build_up:
 			 * The allocation failed.  If we built part of
 			 * the structure tear it down.
 			 */
-			spin_lock_irqsave(&idp->lock, flags);
 			for (new = p; p && p != idp->top; new = p) {
 				p = p->ary[0];
 				new->ary[0] = NULL;
 				new->bitmap = new->count = 0;
 				free_layer(new);
 			}
-			spin_unlock_irqrestore(&idp->lock, flags);
 			return -1;
 		}
-		new->ary[0] = p;
+		rcu_assign_pointer(new->ary[0], p);
 		new->count = 1;
 		if (p->bitmap == IDR_FULL)
 			__set_bit(0, &new->bitmap);
-		p = new;
+		rcu_assign_pointer(p, new);
 	}
-	idp->top = p;
+	rcu_assign_pointer(idp->top, p);
 	idp->layers = layers;
 	v = sub_alloc(idp, &id, pa);
 	if (v == -2)

--
