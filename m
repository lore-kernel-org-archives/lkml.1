Return-Path: <linux-kernel-owner+w=401wt.eu-S1762079AbYDKQXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762079AbYDKQXQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 12:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760933AbYDKQUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 12:20:45 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:34410 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760918AbYDKQUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 12:20:44 -0400
Message-Id: <20080411162002.049624000@bull.net>
References: <20080411161702.460410000@bull.net>
User-Agent: quilt/0.45-1
Date: Fri, 11 Apr 2008 18:17:12 +0200
From: Nadia.Derbey@bull.net
To: efault@gmx.de
Cc: manfred@colorfullife.com, linux-kernel@vger.kernel.org,
       paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
       peterz@infradead.org, xemul@openvz.org,
       Nadia Derbey <Nadia.Derbey@bull.net>
Subject: [PATCH 10/13] Fix ridr_find()
Content-Disposition: inline; filename=ridr_find.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 10/13]

This patch only fixes the ridr_find() portion of ridr.c,
to make it RCU based.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>

---
 lib/ridr.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.25-rc8-mm1/lib/ridr.c
===================================================================
--- linux-2.6.25-rc8-mm1.orig/lib/ridr.c	2008-04-11 18:04:08.000000000 +0200
+++ linux-2.6.25-rc8-mm1/lib/ridr.c	2008-04-11 18:09:00.000000000 +0200
@@ -381,7 +381,7 @@ void *ridr_find(struct ridr *idp, int id
 	struct ridr_layer *p;
 
 	n = idp->layers * IDR_BITS;
-	p = idp->top;
+	p = rcu_dereference(idp->top);
 
 	/* Mask off upper bits we don't use for the search. */
 	id &= MAX_ID_MASK;
@@ -391,7 +391,7 @@ void *ridr_find(struct ridr *idp, int id
 
 	while (n > 0 && p) {
 		n -= IDR_BITS;
-		p = p->ary[(id >> n) & IDR_MASK];
+		p = rcu_dereference(p->ary[(id >> n) & IDR_MASK]);
 	}
 	return((void *)p);
 }

--
