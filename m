Return-Path: <linux-kernel-owner+w=401wt.eu-S1757419AbZAXMqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757419AbZAXMqc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 07:46:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751864AbZAXMqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 07:46:23 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:35893 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794AbZAXMqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 07:46:22 -0500
Subject: Re: [PATCH 2/2] Optimization of function rb_erase() in lib/rbtree.c
From: Peter Zijlstra <peterz@infradead.org>
To: Wolfram Strepp <wstrepp@gmx.de>
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org,
       akpm@linux-foundation.org
In-Reply-To: <20090120215839.74570@gmx.net>
References: <20090120215839.74570@gmx.net>
Content-Type: text/plain
Date: Sat, 24 Jan 2009 13:46:15 +0100
Message-Id: <1232801175.4859.61.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-20 at 22:58 +0100, Wolfram Strepp wrote:
> This patch reorganizes some lines, and therefore one if-condition
> can be omitted. Here an explanation.
> 
> There are two cases when a node is erased:
> 'normal case': the successor is not the right-hand-child of the node to be erased
> 'special case': the successor is the right-hand child of the node to be erased
> 
> In the normal case, the pointers from the nodes to its parents and vice-versa
> have all to be reconnected to its new parents/childs. 
> The current code basically ignores this special case, doing the reconnections
> always in the way as if it were the normal case. This is ok, but not optimal.
> The patch re-arranges the lines, such that it makes use of one particular
> feature of the special case: when the node to be deleted is replaced by its successor,
> it pulls it child behind - so no reconnection is necessary. As a result, the 
> if-condition, which checks if this child is a NIL-leave, can be omitted.
> 
> Here some ascii-art, with following symbols (referring to the code):
> O: node to be deleted
> N: the successor of O
> P: parent of N
> C: child of N
> L: some other node
> 
> normal case:
> 
>                O                         N
>               / \                       / \
>              /   \                     /   \
>             L     \                   L     \
>            / \     P      ---->      / \     P
>                   / \                       / \
>                  /                         /
>                 N                         C
>                  \                       / \
>                   \
>                    C
>                   / \
> 
> 
> special case:
>               O|P                        N
>               / \                       / \
>              /   \                     /   \
>             L     \                   L     \
>            / \     N      ---->      /       C
> 		          \                       / \
>                      \
>                       C
>                      / \
> 
> 
> Signed-off-by: Wolfram Strepp <wstrepp@gmx.de>
> 
> ======================================
> 
> --- a/lib/rbtree.c
> +++ b/lib/rbtree.c
> @@ -231,22 +231,13 @@ void rb_erase(struct rb_node *node, struct rb_root *root)
>  		node = node->rb_right;
>  		while ((left = node->rb_left) != NULL)
>  			node = left;
> +
>  		child = node->rb_right;
>  		parent = rb_parent(node);
>  		color = rb_color(node);
>  
> -		if (child)
> -			rb_set_parent(child, parent);
> -		if (parent == old) {
> -			parent->rb_right = child;
> -			parent = node;
> -		} else
> -			parent->rb_left = child;
> -
> +		/* connect 'node' with its new parent */
>  		node->rb_parent_color = old->rb_parent_color;
> -		node->rb_right = old->rb_right;
> -		node->rb_left = old->rb_left;
> -
>  		if (rb_parent(old))
>  		{
>  			if (rb_parent(old)->rb_left == old)
> @@ -256,9 +247,26 @@ void rb_erase(struct rb_node *node, struct rb_root *root)
>  		} else
>  			root->rb_node = node;
>  
> -		rb_set_parent(old->rb_left, node);
> -		if (old->rb_right)
> +
> +		if (parent == old) {
> +			/* special case: 'node' becomes parent, pulling its
> +			child up behind --> no re-connecting necessary ! */
> +			parent = node;
> +		} else {
> +			/* replace 'node' with its former child */
> +			parent->rb_left = child;
> +			if (child)
> +				rb_set_parent(child, parent);
> +			
> +			/* connect 'node' to its new right-hand child */
> +			node->rb_right = old->rb_right;
>  			rb_set_parent(old->rb_right, node);
> +		}
> +
> +		/* connect 'node' to its new left-hand child */
> +		node->rb_left = old->rb_left;
> +		rb_set_parent(old->rb_left, node);
> +
>  		goto color;
>  	}

OK, this patch is better done in smaller steps.

I'll have to admit to not having tested any of the below patches, but
they represent how I went about understanding your patch.

---
Subject: rbtree: code movement
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Sat Jan 24 13:14:11 CET 2009

Move some code around in order to make the next change more obvious.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
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


-------------------

Subject: rbtree: optimize a special case in rb_erase()
From: Wolfram Strepp <wstrepp@gmx.de>
Date: Sat Jan 24 13:17:04 CET 2009

There are two cases when a node is erased:
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


--------------

Subject: rbtree: further optimize the special case
From: Wolfram Strepp <wstrepp@gmx.de>
Date: Sat Jan 24 13:30:39 CET 2009


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

Notice that for the special case we don't have to reconnect N to C.

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
 


