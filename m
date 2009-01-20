Return-Path: <linux-kernel-owner+w=401wt.eu-S1758985AbZATV6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758985AbZATV6v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 16:58:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753293AbZATV6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 16:58:42 -0500
Received: from mail.gmx.net ([213.165.64.20]:42866 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753173AbZATV6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 16:58:41 -0500
Cc: dwmw2@infradead.org, akpm@linux-foundation.org
Content-Type: text/plain; charset="iso-8859-1"
Date: Tue, 20 Jan 2009 22:58:39 +0100
From: "Wolfram Strepp" <wstrepp@gmx.de>
Message-ID: <20090120215839.74570@gmx.net>
MIME-Version: 1.0
Subject: [PATCH 2/2] Optimization of function rb_erase() in lib/rbtree.c
To: linux-kernel@vger.kernel.org
X-Authenticated: #14768304
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX1+fRZsjetOfoeKdKHq2UP252H9LmRttZduuX7ENJV
 OtURJuU13yZ3uxPKWcaJE1fVhWvzXN5gHuUw== 
Content-Transfer-Encoding: 8bit
X-GMX-UID: QDwXLUh8a0A7Q9E3lDEzuC0/Njh6dI4Q
X-FuHaFi: 0.57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch reorganizes some lines, and therefore one if-condition
can be omitted. Here an explanation.

There are two cases when a node is erased:
'normal case': the successor is not the right-hand-child of the node to be erased
'special case': the successor is the right-hand child of the node to be erased

In the normal case, the pointers from the nodes to its parents and vice-versa
have all to be reconnected to its new parents/childs. 
The current code basically ignores this special case, doing the reconnections
always in the way as if it were the normal case. This is ok, but not optimal.
The patch re-arranges the lines, such that it makes use of one particular
feature of the special case: when the node to be deleted is replaced by its successor,
it pulls it child behind - so no reconnection is necessary. As a result, the 
if-condition, which checks if this child is a NIL-leave, can be omitted.

Here some ascii-art, with following symbols (referring to the code):
O: node to be deleted
N: the successor of O
P: parent of N
C: child of N
L: some other node

normal case:

               O                         N
              / \                       / \
             /   \                     /   \
            L     \                   L     \
           / \     P      ---->      / \     P
                  / \                       / \
                 /                         /
                N                         C
                 \                       / \
                  \
                   C
                  / \


special case:
              O|P                        N
              / \                       / \
             /   \                     /   \
            L     \                   L     \
           / \     N      ---->      /       C
		          \                       / \
                     \
                      C
                     / \


Signed-off-by: Wolfram Strepp <wstrepp@gmx.de>

======================================

--- a/lib/rbtree.c
+++ b/lib/rbtree.c
@@ -231,22 +231,13 @@ void rb_erase(struct rb_node *node, struct rb_root *root)
 		node = node->rb_right;
 		while ((left = node->rb_left) != NULL)
 			node = left;
+
 		child = node->rb_right;
 		parent = rb_parent(node);
 		color = rb_color(node);
 
-		if (child)
-			rb_set_parent(child, parent);
-		if (parent == old) {
-			parent->rb_right = child;
-			parent = node;
-		} else
-			parent->rb_left = child;
-
+		/* connect 'node' with its new parent */
 		node->rb_parent_color = old->rb_parent_color;
-		node->rb_right = old->rb_right;
-		node->rb_left = old->rb_left;
-
 		if (rb_parent(old))
 		{
 			if (rb_parent(old)->rb_left == old)
@@ -256,9 +247,26 @@ void rb_erase(struct rb_node *node, struct rb_root *root)
 		} else
 			root->rb_node = node;
 
-		rb_set_parent(old->rb_left, node);
-		if (old->rb_right)
+
+		if (parent == old) {
+			/* special case: 'node' becomes parent, pulling its
+			child up behind --> no re-connecting necessary ! */
+			parent = node;
+		} else {
+			/* replace 'node' with its former child */
+			parent->rb_left = child;
+			if (child)
+				rb_set_parent(child, parent);
+			
+			/* connect 'node' to its new right-hand child */
+			node->rb_right = old->rb_right;
 			rb_set_parent(old->rb_right, node);
+		}
+
+		/* connect 'node' to its new left-hand child */
+		node->rb_left = old->rb_left;
+		rb_set_parent(old->rb_left, node);
+
 		goto color;
 	}


-- 
Psssst! Schon vom neuen GMX MultiMessenger gehört? Der kann`s mit allen: http://www.gmx.net/de/go/multimessenger
