Return-Path: <linux-kernel-owner+w=401wt.eu-S1753914AbZDKAK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914AbZDKAK5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 20:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751472AbZDKAKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 20:10:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47256 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751421AbZDKAKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 20:10:47 -0400
Date: Fri, 10 Apr 2009 17:07:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Wolfram Strepp" <wstrepp@gmx.de>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, lowdanie@gmail.com
Subject: Re: [PATCH 1/3] Further optimization of function rb_erase() in
 lib/rbtree.c
Message-Id: <20090410170734.3f3e1122.akpm@linux-foundation.org>
In-Reply-To: <20090410102346.320840@gmx.net>
References: <20090410102346.320840@gmx.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Subject: [PATCH 1/3] Further optimization of function rb_erase() in lib/rbtree.c

Three distinct patches, all with the same title.

Please carefully choose a unique title for each patch in the series.

We push thousands and thousands of patches into Linux and it all gets
complex and confusing.  These little organisational things help us to
manage the volume and the complexity.

On Fri, 10 Apr 2009 12:23:46 +0200
"Wolfram Strepp" <wstrepp@gmx.de> wrote:

> This small patch-series reorganizes some lines in function rb_erase()
> in lib/rbtree.c, and as a result one if-condition can be omitted.
> Tested on x86.
> 
> 
> First, move some code around in order to make the next change more obvious.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Wolfram Strepp <wstrepp@gmx.de>
> 
> ---
>  lib/rbtree.c |   19 ++++++++++---------
>  1 file changed, 10 insertions(+), 9 deletions(-)
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

You may as well fix the obvious coding-style error while moving the
code.  scripts/checkpatch.pl will detect this one.

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

