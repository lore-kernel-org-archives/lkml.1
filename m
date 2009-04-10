Return-Path: <linux-kernel-owner+w=401wt.eu-S1764093AbZDJKX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764093AbZDJKX6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 06:23:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752907AbZDJKXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 06:23:49 -0400
Received: from mail.gmx.net ([213.165.64.20]:51344 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752685AbZDJKXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 06:23:48 -0400
Cc: akpm@linux-foundation.org, peterz@infradead.org, lowdanie@gmail.com
Content-Type: text/plain; charset="iso-8859-1"
Date: Fri, 10 Apr 2009 12:23:46 +0200
From: "Wolfram Strepp" <wstrepp@gmx.de>
Message-ID: <20090410102346.320840@gmx.net>
MIME-Version: 1.0
Subject: [PATCH 1/3] Further optimization of function rb_erase() in
 lib/rbtree.c
To: linux-kernel@vger.kernel.org
X-Authenticated: #14768304
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX19btvA9OTlbegxaobzfU+ENd97gEVkT5IUAwnNb0t
 E+2Dxephg/adjXSMiv18dofXyw47UAu+tlow== 
Content-Transfer-Encoding: 8bit
X-GMX-UID: Ayz5YX3aLi50AJh8i2tp9pJrZml1ZFgg
X-FuHaFi: 0.58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This small patch-series reorganizes some lines in function rb_erase()
in lib/rbtree.c, and as a result one if-condition can be omitted.
Tested on x86.


First, move some code around in order to make the next change more obvious.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Wolfram Strepp <wstrepp@gmx.de>

---
 lib/rbtree.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)
Index: linux-2.6/lib/rbtree.c
===================================================================
--- linux-2.6.orig/lib/rbtree.c
+++ linux-2.6/lib/rbtree.c
@@ -237,6 +237,16 @@ void rb_erase(struct rb_node *node, stru
 		node = node->rb_right;
 		while ((left = node->rb_left) != NULL)
 			node = left;
+
+		if (rb_parent(old))
+		{
+			if (rb_parent(old)->rb_left == old)
+				rb_parent(old)->rb_left = node;
+			else
+				rb_parent(old)->rb_right = node;
+		} else
+			root->rb_node = node;
+
 		child = node->rb_right;
 		parent = rb_parent(node);
 		color = rb_color(node);
@@ -253,15 +263,6 @@ void rb_erase(struct rb_node *node, stru
 		node->rb_right = old->rb_right;
 		node->rb_left = old->rb_left;
 
-		if (rb_parent(old))
-		{
-			if (rb_parent(old)->rb_left == old)
-				rb_parent(old)->rb_left = node;
-			else
-				rb_parent(old)->rb_right = node;
-		} else
-			root->rb_node = node;
-
 		rb_set_parent(old->rb_left, node);
 		if (old->rb_right)
 			rb_set_parent(old->rb_right, node);

-- 
Neu: GMX FreeDSL Komplettanschluss mit DSL 6.000 Flatrate + Telefonanschluss für nur 17,95 Euro/mtl.!* http://dslspecial.gmx.de/freedsl-surfflat/?ac=OM.AD.PD003K11308T4569a
