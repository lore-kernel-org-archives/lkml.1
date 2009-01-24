Return-Path: <linux-kernel-owner+w=401wt.eu-S1758251AbZAXQyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758251AbZAXQyR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 11:54:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754456AbZAXQyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 11:54:00 -0500
Received: from mail.gmx.net ([213.165.64.20]:47973 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753870AbZAXQyA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 11:54:00 -0500
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org,
       akpm@linux-foundation.org
Content-Type: text/plain; charset="iso-8859-1"
Date: Sat, 24 Jan 2009 17:53:57 +0100
From: "Wolfram Strepp" <wstrepp@gmx.de>
In-Reply-To: <1232801175.4859.61.camel@laptop>
Message-ID: <20090124165357.119090@gmx.net>
MIME-Version: 1.0
References: <20090120215839.74570@gmx.net> <1232801175.4859.61.camel@laptop>
Subject: Re: [PATCH 2/2] Optimization of function rb_erase() in lib/rbtree.c
To: Peter Zijlstra <peterz@infradead.org>
X-Authenticated: #14768304
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX1/ZS24bPbjZH+dN94gLPvIMmWbFdKay84xY5ODSlT
 nTGcU9w5tHvUssK6E1EI8E3qbDbCrzVXqjjg== 
Content-Transfer-Encoding: 8bit
X-GMX-UID: nXVIfe9nX1V6J4Q1jWFyzUR/SDc4NEw3
X-FuHaFi: 0.52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Peter,

> On Tue, 2009-01-20 at 22:58 +0100, Wolfram Strepp wrote:
> > This patch reorganizes some lines, and therefore one if-condition
> > can be omitted. Here an explanation.
> OK, this patch is better done in smaller steps.
> 
> I'll have to admit to not having tested any of the below patches, but
> they represent how I went about understanding your patch.
> 
> ---
> Subject: rbtree: code movement
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Sat Jan 24 13:14:11 CET 2009
> 
> Move some code around in order to make the next change more obvious.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  lib/rbtree.c |   19 ++++++++++---------
>  1 file changed, 10 insertions(+), 9 deletions(-)
> 
> Index: linux-2.6/lib/rbtree.c
> ===================================================================
> --- linux-2.6.orig/lib/rbtree.c
> +++ linux-2.6/lib/rbtree.c
> @@ -237,6 +237,16 @@ void rb_erase(struct rb_node *node, stru
>  		node = node->rb_right;
>  		while ((left = node->rb_left) != NULL)
>  			node = left;
> +
> +		if (rb_parent(old))
> +		{
> +			if (rb_parent(old)->rb_left == old)
> +				rb_parent(old)->rb_left = node;
> +			else
> +				rb_parent(old)->rb_right = node;
> +		} else
> +			root->rb_node = node;
> +
>  		child = node->rb_right;
>  		parent = rb_parent(node);
>  		color = rb_color(node);
> @@ -253,15 +263,6 @@ void rb_erase(struct rb_node *node, stru
>  		node->rb_right = old->rb_right;
>  		node->rb_left = old->rb_left;
>  
> -		if (rb_parent(old))
> -		{
> -			if (rb_parent(old)->rb_left == old)
> -				rb_parent(old)->rb_left = node;
> -			else
> -				rb_parent(old)->rb_right = node;
> -		} else
> -			root->rb_node = node;
> -
>  		rb_set_parent(old->rb_left, node);
>  		if (old->rb_right)
>  			rb_set_parent(old->rb_right, node);
> 
> 
> -------------------
> 
> Subject: rbtree: optimize a special case in rb_erase()
> From: Wolfram Strepp <wstrepp@gmx.de>
> Date: Sat Jan 24 13:17:04 CET 2009
> 
> There are two cases when a node is erased:
> 'normal case': the successor is not the right-hand-child of the node to be
> erased
> 'special case': the successor is the right-hand child of the node to be
> erased
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
>                     \                       / \
>                      \
>                       C
>                      / \
> 
> Notice that for the special case we don't have to reconnect C to N.
> 
> Signed-off-by: Wolfram Strepp <wstrepp@gmx.de>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  lib/rbtree.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> Index: linux-2.6/lib/rbtree.c
> ===================================================================
> --- linux-2.6.orig/lib/rbtree.c
> +++ linux-2.6/lib/rbtree.c
> @@ -251,13 +251,13 @@ void rb_erase(struct rb_node *node, stru
>  		parent = rb_parent(node);
>  		color = rb_color(node);
>  
> -		if (child)
> -			rb_set_parent(child, parent);
>  		if (parent == old) {
> -			parent->rb_right = child;
>  			parent = node;
> -		} else
> +		} else {
> +			if (child)
> +				rb_set_parent(child, parent);
>  			parent->rb_left = child;
> +		}
>  
>  		node->rb_parent_color = old->rb_parent_color;
>  		node->rb_right = old->rb_right;
> 
> 
> --------------
> 
> Subject: rbtree: further optimize the special case
> From: Wolfram Strepp <wstrepp@gmx.de>
> Date: Sat Jan 24 13:30:39 CET 2009
> 
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
>                     \                       / \
>                      \
>                       C
>                      / \
> 
> Notice that for the special case we don't have to reconnect N to C.
> 
> Furthermore, notice that the initial checks:
> 
> 	if (!node->rb_left)
> 		child = node->rb_right;
> 	else if (!node->rb_right)
> 		child = node->rb_left;
> 	else
> 	{
> 		...
> 	}
> 
> guarantee that old->rb_right is set in the final else branch, therefore
> we can omit checking that again.
> 
> Signed-off-by: Wolfram Strepp <wstrepp@gmx.de>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  lib/rbtree.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> Index: linux-2.6/lib/rbtree.c
> ===================================================================
> --- linux-2.6.orig/lib/rbtree.c
> +++ linux-2.6/lib/rbtree.c
> @@ -257,15 +257,15 @@ void rb_erase(struct rb_node *node, stru
>  			if (child)
>  				rb_set_parent(child, parent);
>  			parent->rb_left = child;
> +
> +			node->rb_right = old->rb_right;
> +			rb_set_parent(old->rb_right, node);
>  		}
>  
>  		node->rb_parent_color = old->rb_parent_color;
> -		node->rb_right = old->rb_right;
>  		node->rb_left = old->rb_left;
> -
>  		rb_set_parent(old->rb_left, node);
> -		if (old->rb_right)
> -			rb_set_parent(old->rb_right, node);
> +
>  		goto color;
>  	}
>  
> 
I'm fine with your reorganization.
Im just building a kernel to test it, but quite sure it will work.
Regards,

Wolfram
-- 
Psssst! Schon vom neuen GMX MultiMessenger gehört? Der kann`s mit allen: http://www.gmx.net/de/go/multimessenger
