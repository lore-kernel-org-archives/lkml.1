Return-Path: <linux-kernel-owner+w=401wt.eu-S1758126AbZDKKH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758126AbZDKKH7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 06:07:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757914AbZDKKH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 06:07:29 -0400
Received: from mail.gmx.net ([213.165.64.20]:48741 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757954AbZDKKH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 06:07:28 -0400
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, lowdanie@gmail.com
Content-Type: text/plain; charset="iso-8859-1"
Date: Sat, 11 Apr 2009 12:07:26 +0200
From: "Wolfram Strepp" <wstrepp@gmx.de>
Message-ID: <20090411100726.51370@gmx.net>
MIME-Version: 1.0
Subject: [PATCH 3/3] rb_tree: remove redundant if()-condition in rb_erase()
To: akpm@linux-foundation.org
X-Authenticated: #14768304
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX19NHfER1XNNXfaC2qXghGrvLA6o+3ug/cPq0XtGuk
 4iYFxs1he5Rm/8T5eRv/GfJLeoh7HGMn6qAQ== 
Content-Transfer-Encoding: 8bit
X-GMX-UID: vweLIVhBTlI8SNg9lmhre61OU2poZVkp
X-FuHaFi: 0.64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Furthermore, notice that the initial checks:

	if (!node->rb_left)
		child = node->rb_right;
	else if (!node->rb_right)
		child = node->rb_left;
	else
	{
		...
	}
guarantee that old->rb_right is set in the final else branch, therefore
we can omit checking that again.

Signed-off-by: Wolfram Strepp <wstrepp@gmx.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 lib/rbtree.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)
Index: linux-2.6/lib/rbtree.c
===================================================================
--- linux-2.6.orig/lib/rbtree.c
+++ linux-2.6/lib/rbtree.c
@@ -257,15 +257,15 @@ void rb_erase(struct rb_node *node, stru
 			if (child)
 				rb_set_parent(child, parent);
 			parent->rb_left = child;
+
+			node->rb_right = old->rb_right;
+			rb_set_parent(old->rb_right, node);
 		}
 
 		node->rb_parent_color = old->rb_parent_color;
-		node->rb_right = old->rb_right;
 		node->rb_left = old->rb_left;
-
 		rb_set_parent(old->rb_left, node);
-		if (old->rb_right)
-			rb_set_parent(old->rb_right, node);
+
 		goto color;
 	}
 
-- 
Psssst! Schon vom neuen GMX MultiMessenger gehört? Der kann`s mit allen: http://www.gmx.net/de/go/multimessenger01
