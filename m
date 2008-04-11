Return-Path: <linux-kernel-owner+w=401wt.eu-S1761570AbYDKQV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761570AbYDKQV5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 12:21:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760845AbYDKQUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 12:20:38 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:34347 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760825AbYDKQUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 12:20:37 -0400
Message-Id: <20080411162000.154513000@bull.net>
References: <20080411161702.460410000@bull.net>
User-Agent: quilt/0.45-1
Date: Fri, 11 Apr 2008 18:17:08 +0200
From: Nadia.Derbey@bull.net
To: efault@gmx.de
Cc: manfred@colorfullife.com, linux-kernel@vger.kernel.org,
       paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
       peterz@infradead.org, xemul@openvz.org,
       Nadia Derbey <Nadia.Derbey@bull.net>
Subject: [PATCH 06/13] Fix sub_alloc()
Content-Disposition: inline; filename=ridr_sub_alloc.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 06/13]

This patch only fixes the sub_alloc() portion of ridr.c, to make it RCU based.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>

---
 lib/ridr.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: linux-2.6.25-rc8-mm1/lib/ridr.c
===================================================================
--- linux-2.6.25-rc8-mm1.orig/lib/ridr.c	2008-04-11 17:47:48.000000000 +0200
+++ linux-2.6.25-rc8-mm1/lib/ridr.c	2008-04-11 17:51:34.000000000 +0200
@@ -135,9 +135,9 @@ static int sub_alloc(struct ridr *idp, i
 
 	id = *starting_id;
  restart:
-	p = idp->top;
+	rcu_assign_pointer(p, idp->top);
 	l = idp->layers;
-	pa[l--] = NULL;
+	rcu_assign_pointer(pa[l--], NULL);
 	while (1) {
 		/*
 		 * We run around this while until we reach the leaf node...
@@ -152,7 +152,7 @@ static int sub_alloc(struct ridr *idp, i
 			id = (id | ((1 << (IDR_BITS * l)) - 1)) + 1;
 
 			/* if already at the top layer, we need to grow */
-			p = pa[l];
+			rcu_assign_pointer(p, pa[l]);
 			if (!p) {
 				*starting_id = id;
 				return -2;
@@ -182,14 +182,14 @@ static int sub_alloc(struct ridr *idp, i
 			new = alloc_layer(idp);
 			if (!new)
 				return -1;
-			p->ary[m] = new;
+			rcu_assign_pointer(p->ary[m], new);
 			p->count++;
 		}
-		pa[l--] = p;
+		rcu_assign_pointer(pa[l--], p);
 		p = p->ary[m];
 	}
 
-	pa[l] = p;
+	rcu_assign_pointer(pa[l], p);
 	return id;
 }
 

--
