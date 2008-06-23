Return-Path: <linux-kernel-owner+w=401wt.eu-S1757996AbYFWItA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757996AbYFWItA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 04:49:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753976AbYFWIsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 04:48:53 -0400
Received: from mx1.suse.de ([195.135.220.2]:47617 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752566AbYFWIsv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 04:48:51 -0400
Date: Mon, 23 Jun 2008 10:48:46 +0200
From: Nick Piggin <npiggin@suse.de>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Luis Carlos Cobo <luisca@cozybit.com>,
       Steve Whitehouse <SteveW@acm.org>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       torvalds@linux-foundation.org
Subject: Re: [PATCH]rcu,inet,fib_trie,route,radix-tree,DECnet,mac80211: fix meaningless rcu_dereference(local_var)
Message-ID: <20080623084846.GA6899@wotan.suse.de>
References: <485CCFC9.2070007@cn.fujitsu.com> <200806231236.51341.nickpiggin@yahoo.com.au> <485F3638.5010305@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <485F3638.5010305@cn.fujitsu.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2008 at 01:35:52PM +0800, Lai Jiangshan wrote:
> Add CC: Linus Torvalds
> 
> Nick Piggin wrote:
> > On Saturday 21 June 2008 19:54, Lai Jiangshan wrote:
> > 
> >> diff --git a/lib/radix-tree.c b/lib/radix-tree.c
> >> index 169a2f8..bfae4e2 100644
> >> --- a/lib/radix-tree.c
> >> +++ b/lib/radix-tree.c
> >> @@ -703,9 +703,9 @@ __lookup(struct radix_tree_node *slot, void **results,
> >> unsigned long index, for (i = index & RADIX_TREE_MAP_MASK; i <
> >> RADIX_TREE_MAP_SIZE; i++) { struct radix_tree_node *node;
> >>  		index++;
> >> -		node = slot->slots[i];
> >> +		node = rcu_dereference(slot->slots[i]);
> >>  		if (node) {
> >> -			results[nr_found++] = rcu_dereference(node);
> >> +			results[nr_found++] = node;
> >>  			if (nr_found == max_items)
> >>  				goto out;
> >>  		}
> >> @@ -815,7 +815,7 @@ __lookup_tag(struct radix_tree_node *slot, void
> >> **results, unsigned long index, index++;
> >>  				if (!tag_get(slot, tag, j))
> >>  					continue;
> >> -				node = slot->slots[j];
> >> +				node = rcu_dereference(slot->slots[j]);
> >>  				/*
> >>  				 * Even though the tag was found set, we need to
> >>  				 * recheck that we have a non-NULL node, because
> >> @@ -827,7 +827,6 @@ __lookup_tag(struct radix_tree_node *slot, void
> >> **results, unsigned long index, * rely on its value remaining the same).
> >>  				 */
> >>  				if (node) {
> >> -					node = rcu_dereference(node);
> >>  					results[nr_found++] = node;
> >>  					if (nr_found == max_items)
> >>  						goto out;
> > 
> > This was done like this IIRC to avoid the barrier when possible.
> > 
> > 
> > 
> This(http://lkml.org/lkml/2008/4/20/217) shows why rcu_dereference(local_var)
> is meaningless. And why not use smp_read_barrier_depends() here?
 
It is "meaningless" in that it isn't being applied as the API is supposed
to, however it does provide the barrier that's required. I guess read
barrier depends could just be used instead, although I like the self
commenting nature of the rcu_dereference, even if it is not quite applied
correctly, the reader can easily see the intention.

I *think* it should even do the right thing WRT the access_once macro here,
and cause node not to be reloaded from source, but I could be wrong on that.


> I guessed somebody use rcu_dereference(local_var) in if-statements to avoid the
> barrier when possible, and I made this patch(http://lkml.org/lkml/2008/6/21/29),
> but it is incorrect.

So it doesn't help me ;)

I'm not sure what the best way to go is, but I would ask Paul for ideas
if he's not too busy.

In reality, the barriers probably don't matter much (but I'd really love
to have an Alpha to test it on :)), but I still try to avoid them as much
as possible. For the radix-tree as used by pagecache, it is a completely
usual operation to lookup non existing elements, so we are talking about
a fastpath of sorts...
