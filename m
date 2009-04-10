Return-Path: <linux-kernel-owner+w=401wt.eu-S1764661AbZDJKYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764661AbZDJKYV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 06:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760701AbZDJKX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 06:23:59 -0400
Received: from mail.gmx.net ([213.165.64.20]:33543 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1764007AbZDJKX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 06:23:58 -0400
Cc: akpm@linux-foundation.org, peterz@infradead.org, lowdanie@gmail.com
Content-Type: text/plain; charset="iso-8859-1"
Date: Fri, 10 Apr 2009 12:23:56 +0200
From: "Wolfram Strepp" <wstrepp@gmx.de>
Message-ID: <20090410102356.283330@gmx.net>
MIME-Version: 1.0
Subject: [PATCH 2/3] Further optimization of function rb_erase() in
 lib/rbtree.c
To: linux-kernel@vger.kernel.org
X-Authenticated: #14768304
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX19EH+pZS5hEf7TZYQeRQIua2s4sZBAdV4CeystAOm
 AqMnKxAdtpubUvDSzLNt2zMrNHp57XHsRZ6Q== 
Content-Transfer-Encoding: 8bit
X-GMX-UID: WHe6CMMafW47UIoClmVoL61udmllckWT
X-FuHaFi: 0.59
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two cases when a node, having 2 childs, is erased:
'normal case': the successor is not the right-hand-child of the node to be erased
'special case': the successor is the right-hand child of the node to be erased

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

Notice that for the special case we don't have to reconnect C to N.

Signed-off-by: Wolfram Strepp <wstrepp@gmx.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 lib/rbtree.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)
Index: linux-2.6/lib/rbtree.c
===================================================================
--- linux-2.6.orig/lib/rbtree.c
+++ linux-2.6/lib/rbtree.c
@@ -251,13 +251,13 @@ void rb_erase(struct rb_node *node, stru
 		parent = rb_parent(node);
 		color = rb_color(node);
 
-		if (child)
-			rb_set_parent(child, parent);
 		if (parent == old) {
-			parent->rb_right = child;
 			parent = node;
-		} else
+		} else {
+			if (child)
+				rb_set_parent(child, parent);
 			parent->rb_left = child;
+		}
 
 		node->rb_parent_color = old->rb_parent_color;
 		node->rb_right = old->rb_right;


-- 
Psssst! Schon vom neuen GMX MultiMessenger gehört? Der kann`s mit allen: http://www.gmx.net/de/go/multimessenger01
