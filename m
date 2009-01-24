Return-Path: <linux-kernel-owner+w=401wt.eu-S1758127AbZAXIn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758127AbZAXIn7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 03:43:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751147AbZAXInu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 03:43:50 -0500
Received: from casper.infradead.org ([85.118.1.10]:50546 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbZAXInu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 03:43:50 -0500
Subject: Re: [PATCH 1/2] Optimization of function rb_erase() in lib/rbtree.c
From: Peter Zijlstra <peterz@infradead.org>
To: Wolfram Strepp <wstrepp@gmx.de>
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org,
       akpm@linux-foundation.org
In-Reply-To: <20090120215556.74580@gmx.net>
References: <20090120215556.74580@gmx.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 24 Jan 2009 09:43:41 +0100
Message-Id: <1232786621.4859.35.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-20 at 22:55 +0100, Wolfram Strepp wrote:
> Hello,
> 
> i have reviewed the code of the rb-tree implementation
> in the kernel, and distilled two small patches for file lib/rbtree.c,
> which optimize and cleanup the code of functions rb_erase() and __rb_erase_color().
> In summary, there are 5 if()-conditions which can be eliminated.
> The patches reduce the code size (normal kernel build on x86)
> of this functions by 23 bytes, or 4.5 %.
> 
> So although this is not a dramatic change, i think its worth it,
> given the many places in the kernel where it is used
> (and given the fact that processors dont like if-conditions).
> 
> The patches are tested on x86.
> 
> ------------------------------------------
> 
> The first patch was already posted some years ago, see:
> http://lkml.org/lkml/2002/11/22/146
> and:
> http://lkml.org/lkml/2002/11/24/122
> 
> It was finally merged by the original author of the rb-tree
> implementation, Andrea Arcangeli, in one of his kernel trees.
> Citing from http://lkml.org/lkml/2002/12/25/51:
> 
> >Only in 2.4.21pre2aa1: 00_rbtree-cleanups-1
> >
> >	Merged rbtree cleanups/microoptimizations from Érsek László after
> >	verifying their math correctness also with the help of Paolo Carlini
> >	and of some gentle reminder from Rusty, they are obviously right,
> >	thanks.
> 
> But obviousely, it never found is way into the mainline kernel,
> so here it is again.


The above is not a proper changelog, please ammend it, and write it in
the form found in Paolo's STL email.

"
	if ((!A || B) && C)
           {
             //
           }
         else
           {
             if (C)
               {
                 if (A) __w->_M_left->_M_color = _M_black;
                 //
               }
             //
           }


Therefore, the check for A (_w->_M_left, that is) in the innermost if
is definitely redundant. "

But add the extra redundant case in our code.

Then resend, and you can add

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

> Signed-off-by: Wolfram Strepp <wstrepp@gmx.de>
> 
> ====================================================
> --- a/lib/rbtree.c
> +++ b/lib/rbtree.c
> @@ -163,17 +163,14 @@ static void __rb_erase_color(struct rb_node *node, struct rb_node *parent,
>  			{
>  				if (!other->rb_right || rb_is_black(other->rb_right))
>  				{
> -					struct rb_node *o_left;
> -					if ((o_left = other->rb_left))
> -						rb_set_black(o_left);
> +					rb_set_black(other->rb_left);
>  					rb_set_red(other);
>  					__rb_rotate_right(other, root);
>  					other = parent->rb_right;
>  				}
>  				rb_set_color(other, rb_color(parent));
>  				rb_set_black(parent);
> -				if (other->rb_right)
> -					rb_set_black(other->rb_right);
> +				rb_set_black(other->rb_right);
>  				__rb_rotate_left(parent, root);
>  				node = root->rb_node;
>  				break;
> @@ -200,17 +197,14 @@ static void __rb_erase_color(struct rb_node *node, struct rb_node *parent,
>  			{
>  				if (!other->rb_left || rb_is_black(other->rb_left))
>  				{
> -					register struct rb_node *o_right;
> -					if ((o_right = other->rb_right))
> -						rb_set_black(o_right);
> +					rb_set_black(other->rb_right);
>  					rb_set_red(other);
>  					__rb_rotate_left(other, root);
>  					other = parent->rb_left;
>  				}
>  				rb_set_color(other, rb_color(parent));
>  				rb_set_black(parent);
> -				if (other->rb_left)
> -					rb_set_black(other->rb_left);
> +				rb_set_black(other->rb_left);
>  				__rb_rotate_right(parent, root);
>  				node = root->rb_node;
>  				break;
> 

