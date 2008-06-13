Return-Path: <linux-kernel-owner+w=401wt.eu-S1759542AbYFMIBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759542AbYFMIBP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 04:01:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754186AbYFMIA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 04:00:57 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:41496 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718AbYFMIA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 04:00:56 -0400
Date: Fri, 13 Jun 2008 00:53:17 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: akpm@linux-foundation.org, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] radix-tree: fix small lockless radix-tree bug
Message-ID: <20080613075317.GF8331@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <200806130503.45369.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806130503.45369.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2008 at 05:03:45AM +1000, Nick Piggin wrote:
> Hi guys,
> 
> Although this doesn't seem like cause for alarm (as per the analysis),
> it may still be a good 2.6.26 candidate as we should have a few more
> weeks of testing left.
> 
> It should definitely go in -mm with the lockless pagecache patch.

Good catch!!!

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Thanks,
> Nick

> When shrinking a radix-tree, we do it in a lockless manner by atomically
> switching the root pointer away from the redundant node (one that only
> has a single entry in the left most slot), and switching it over to its
> lone child.
> 
> Because a lockless lookup may have got a reference to the parent and be
> in the middle of deciding what to do with it while it is being swapped
> away for its child. For this reason, we also have to keep it around and
> in a valid state for the lookup to proceed and give a valid result, for
> at least an RCU grace period. So we need to keep the child in the left
> most slot there in case that is requested by the lookup.
> 
> This is all pretty standard RCU stuff. It is worth repeating because
> in my eagerness to obey the radix tree node constructor scheme, I had
> broken this by zeroing the radix tree node before the grace period.
> 
> Fix it by clearing those fields in the RCU callback. I would normally
> want to rip out the constructor entirely, but radix tree nodes are one
> of those places where they make sense (only few cachelines will be
> touched soon after allocation).
> 
> 
> This was never actually observed in any lockless pagecache testing or
> using the test harness, but as a rare problem testing my scalable vmap
> rewrite.
> 
> Fortunately, it is not a problem anywhere lockless pagecache is used in
> mainline kernels (pagecache probe is not a guarantee, and brd does not
> have concurrent lookups and deletes).
> 
> However, it would eventually pop up for someone using lockless pagecache :P
> 
> Signed-off-by: Nick Piggin <npiggin@suse.de>
> ---
> Index: linux-2.6/lib/radix-tree.c
> ===================================================================
> --- linux-2.6.orig/lib/radix-tree.c	2008-06-13 04:26:31.000000000 +1000
> +++ linux-2.6/lib/radix-tree.c	2008-06-13 04:31:38.000000000 +1000
> @@ -88,6 +88,57 @@ static inline gfp_t root_gfp_mask(struct
>  	return root->gfp_mask & __GFP_BITS_MASK;
>  }
> 
> +static inline void tag_set(struct radix_tree_node *node, unsigned int tag,
> +		int offset)
> +{
> +	__set_bit(offset, node->tags[tag]);
> +}
> +
> +static inline void tag_clear(struct radix_tree_node *node, unsigned int tag,
> +		int offset)
> +{
> +	__clear_bit(offset, node->tags[tag]);
> +}
> +
> +static inline int tag_get(struct radix_tree_node *node, unsigned int tag,
> +		int offset)
> +{
> +	return test_bit(offset, node->tags[tag]);
> +}
> +
> +static inline void root_tag_set(struct radix_tree_root *root, unsigned int tag)
> +{
> +	root->gfp_mask |= (__force gfp_t)(1 << (tag + __GFP_BITS_SHIFT));
> +}
> +
> +static inline void root_tag_clear(struct radix_tree_root *root, unsigned int tag)
> +{
> +	root->gfp_mask &= (__force gfp_t)~(1 << (tag + __GFP_BITS_SHIFT));
> +}
> +
> +static inline void root_tag_clear_all(struct radix_tree_root *root)
> +{
> +	root->gfp_mask &= __GFP_BITS_MASK;
> +}
> +
> +static inline int root_tag_get(struct radix_tree_root *root, unsigned int tag)
> +{
> +	return (__force unsigned)root->gfp_mask & (1 << (tag + __GFP_BITS_SHIFT));
> +}
> +
> +/*
> + * Returns 1 if any slot in the node has this tag set.
> + * Otherwise returns 0.
> + */
> +static inline int any_tag_set(struct radix_tree_node *node, unsigned int tag)
> +{
> +	int idx;
> +	for (idx = 0; idx < RADIX_TREE_TAG_LONGS; idx++) {
> +		if (node->tags[tag][idx])
> +			return 1;
> +	}
> +	return 0;
> +}
>  /*
>   * This assumes that the caller has performed appropriate preallocation, and
>   * that the caller has pinned this thread of control to the current CPU.
> @@ -124,6 +175,17 @@ static void radix_tree_node_rcu_free(str
>  {
>  	struct radix_tree_node *node =
>  			container_of(head, struct radix_tree_node, rcu_head);
> +
> +	/*
> +	 * must only free zeroed nodes into the slab. radix_tree_shrink
> +	 * can leave us with a non-NULL entry in the first slot, so clear
> +	 * that here to make sure.
> +	 */
> +	tag_clear(node, 0, 0);
> +	tag_clear(node, 1, 0);
> +	node->slots[0] = NULL;
> +	node->count = 0;
> +
>  	kmem_cache_free(radix_tree_node_cachep, node);
>  }
> 
> @@ -165,59 +227,6 @@ out:
>  }
>  EXPORT_SYMBOL(radix_tree_preload);
> 
> -static inline void tag_set(struct radix_tree_node *node, unsigned int tag,
> -		int offset)
> -{
> -	__set_bit(offset, node->tags[tag]);
> -}
> -
> -static inline void tag_clear(struct radix_tree_node *node, unsigned int tag,
> -		int offset)
> -{
> -	__clear_bit(offset, node->tags[tag]);
> -}
> -
> -static inline int tag_get(struct radix_tree_node *node, unsigned int tag,
> -		int offset)
> -{
> -	return test_bit(offset, node->tags[tag]);
> -}
> -
> -static inline void root_tag_set(struct radix_tree_root *root, unsigned int tag)
> -{
> -	root->gfp_mask |= (__force gfp_t)(1 << (tag + __GFP_BITS_SHIFT));
> -}
> -
> -
> -static inline void root_tag_clear(struct radix_tree_root *root, unsigned int tag)
> -{
> -	root->gfp_mask &= (__force gfp_t)~(1 << (tag + __GFP_BITS_SHIFT));
> -}
> -
> -static inline void root_tag_clear_all(struct radix_tree_root *root)
> -{
> -	root->gfp_mask &= __GFP_BITS_MASK;
> -}
> -
> -static inline int root_tag_get(struct radix_tree_root *root, unsigned int tag)
> -{
> -	return (__force unsigned)root->gfp_mask & (1 << (tag + __GFP_BITS_SHIFT));
> -}
> -
> -/*
> - * Returns 1 if any slot in the node has this tag set.
> - * Otherwise returns 0.
> - */
> -static inline int any_tag_set(struct radix_tree_node *node, unsigned int tag)
> -{
> -	int idx;
> -	for (idx = 0; idx < RADIX_TREE_TAG_LONGS; idx++) {
> -		if (node->tags[tag][idx])
> -			return 1;
> -	}
> -	return 0;
> -}
> -
>  /*
>   *	Return the maximum key which can be store into a
>   *	radix tree with height HEIGHT.
> @@ -930,11 +939,6 @@ static inline void radix_tree_shrink(str
>  			newptr = radix_tree_ptr_to_indirect(newptr);
>  		root->rnode = newptr;
>  		root->height--;
> -		/* must only free zeroed nodes into the slab */
> -		tag_clear(to_free, 0, 0);
> -		tag_clear(to_free, 1, 0);
> -		to_free->slots[0] = NULL;
> -		to_free->count = 0;
>  		radix_tree_node_free(to_free);
>  	}
>  }

