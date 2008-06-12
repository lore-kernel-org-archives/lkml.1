Return-Path: <linux-kernel-owner+w=401wt.eu-S1756312AbYFLTsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312AbYFLTsT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 15:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752952AbYFLTsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 15:48:05 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:22371 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752518AbYFLTsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 15:48:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=YlvFP2d3enetFHLOZIpFng0FWg28ezdfrLYI3exoCKXPWSg8xulyQgy0BHE5mmDytuFIeSq9KTvXBjrs1hH5SmZFWf8N2HwzyYGZUqoTbbo5y9awKiqZJBbREPn/+x2pq9w/PwAAxp788hDlTAB6Dadh3w+Ci/ReuaJ7Wuw9/+Q=  ;
X-YMail-OSG: yVWgWW8VM1nPZz0jA5hgXL4YCng0aKFG9OslVy.sfk4x0uAxiBx2rJ1XO_IngJRKFC_rAMKJVnlOlwYUZEz6ausJ6Tm0yGGGmG5XZZwjBZDa5zRtq6aCX1mGx9uPdwZVrjA-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] radix-tree: fix small lockless radix-tree bug
Date: Fri, 13 Jun 2008 05:47:54 +1000
User-Agent: KMail/1.9.5
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org, paulmck@us.ibm.com
References: <200806130503.45369.nickpiggin@yahoo.com.au> <20080612123443.e4682b3f.akpm@linux-foundation.org>
In-Reply-To: <20080612123443.e4682b3f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806130547.54345.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 June 2008 05:34, Andrew Morton wrote:
> On Fri, 13 Jun 2008 05:03:45 +1000
>
> Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > @@ -124,6 +175,17 @@ static void radix_tree_node_rcu_free(str
> >  {
> >  	struct radix_tree_node *node =
> >  			container_of(head, struct radix_tree_node, rcu_head);
> > +
> > +	/*
> > +	 * must only free zeroed nodes into the slab. radix_tree_shrink
> > +	 * can leave us with a non-NULL entry in the first slot, so clear
> > +	 * that here to make sure.
> > +	 */
> > +	tag_clear(node, 0, 0);
> > +	tag_clear(node, 1, 0);
> > +	node->slots[0] = NULL;
> > +	node->count = 0;
> > +
> >  	kmem_cache_free(radix_tree_node_cachep, node);
> >  }
>
> oic, that stuff got moved from the synchronous case into the RCU callback
> case.

Yeah, it was annoying because the real change moved the first references
of a couple of those up. Then we have to move all of them to keep them
in one place.

The changelog I submitted looks like utter gibberish, btw. Rewritten one
here which should be a bit better.


We shrink a radix tree when its root node has only one child, in the left
most slot. The child becomes the new root node. To perform this operation
in a manner compatible with concurrent lockless lookups, we atomically
switch the root pointer from the parent to its child.

However a concurrent lockless lookup may now have loaded a pointer to the
parent (and is presently deciding what to do next). For this reason, we
also have to keep the parent node in a valid state after shrinking the
tree, until the next RCU grace period -- otherwise this lookup with the
parent pointer may not do the right thing. Notably, we need to keep the
child in the left most slot there in case that is requested by the lookup.

This is all pretty standard RCU stuff. It is worth repeating because
in my eagerness to obey the radix tree node constructor scheme, I had
broken it by zeroing the radix tree node before the grace period.

What could happen is that a lookup can load the parent pointer, then
decide it wants to follow the left most child slot, only to find the
slot contained NULL due to the concurrent shrinker having zeroed the
parent node before waiting for a grace period. The lookup would return
a false negative as a result.

Fix it by doing that clearing in the RCU callback. I would normally want
to rip out the constructor entirely, but radix tree nodes are one of those
places where they make sense (only few cachelines will be touched soon
after allocation).


This was never actually found in any lockless pagecache testing or by
the test harness, but by seeing the odd problem with my scalable vmap
rewrite. I have not tickled the test harness into reproducing it yet,
but I'll keep working at it.

Fortunately, it is not a problem anywhere lockless pagecache is used in
mainline kernels (pagecache probe is not a guarantee, and brd does not
have concurrent lookups and deletes).
