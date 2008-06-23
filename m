Return-Path: <linux-kernel-owner+w=401wt.eu-S1755612AbYFWKBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612AbYFWKBm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 06:01:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753538AbYFWKBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 06:01:34 -0400
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:38190 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804AbYFWKBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 06:01:33 -0400
Date: Mon, 23 Jun 2008 03:01:26 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Luis Carlos Cobo <luisca@cozybit.com>,
       Steve Whitehouse <SteveW@acm.org>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       torvalds@linux-foundation.org
Subject: Re: [PATCH]rcu,inet,fib_trie,route,radix-tree,DECnet,mac80211: fix meaningless rcu_dereference(local_var)
Message-ID: <20080623100126.GM22569@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <485CCFC9.2070007@cn.fujitsu.com> <200806231236.51341.nickpiggin@yahoo.com.au> <485F3638.5010305@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <485F3638.5010305@cn.fujitsu.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
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

One caution...  smp_read_barrier_depends() makes for difficult-to-read
code.  After a few years and patches to surrounding code, it becomes
quite difficult to figure out what the smp_read_barrier_depends() is
constraining.

I very strongly recommend using rcu_dereference() instead.  Especially
since rcu_dereference() is extremely lightweight on almost all machines
available today -- there aren't that many DEC Alphas running Linux,
from what I understand.

> I guessed somebody use rcu_dereference(local_var) in if-statements to avoid the
> barrier when possible, and I made this patch(http://lkml.org/lkml/2008/6/21/29),
> but it is incorrect.

On all but Alpha, it is quite possible that rcu_dereference() is cheaper
than a conditional branch.  ;-)

							Thanx, Paul
