Return-Path: <linux-kernel-owner+w=401wt.eu-S1761297AbYDKSnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761297AbYDKSnj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 14:43:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760556AbYDKSna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 14:43:30 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:39054 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760349AbYDKSn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 14:43:29 -0400
Date: Fri, 11 Apr 2008 11:43:27 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-sparse <linux-sparse@vger.kernel.org>
Subject: Re: Using sparse to catch invalid RCU dereferences?
Message-ID: <20080411184327.GD29878@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1207605856.12481.35.camel@johannes.berg> <20080408155259.GA8381@linux.vnet.ibm.com> <1207937922.7524.17.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1207937922.7524.17.camel@twins>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2008 at 08:18:42PM +0200, Peter Zijlstra wrote:
> On Tue, 2008-04-08 at 08:52 -0700, Paul E. McKenney wrote:
> > On Tue, Apr 08, 2008 at 12:04:16AM +0200, Johannes Berg wrote:
> > > Hi,
> > > 
> > > Just a thought, I haven't tried this yet because I'm not entirely sure
> > > it's actually correct. I was just thinking it should be possible to
> > > introduce something like
> > > 
> > > 	#define __rcu	__attribute__((address_space(3)))
> > > 
> > > (for sparse only, of course) and then be able to say
> > > 
> > > 	struct myfoo *foo __rcu;
> > > 
> > > and sparse would warn on
> > > 
> > > 	struct myfoo *bar = foo;
> > > 
> > > but not on
> > > 
> > > 	struct myfoo *bar = rcu_dereference(foo);
> > 
> > Ah, "address_space" is a sparse-ism, no wonder I couldn't find it in
> > the gcc docs...
> > 
> > So the address_space attribute says what the pointer points to rather
> > than where the pointer resides, correct?
> > 
> > > by way of using __force inside rcu_dereference(), rcu_assign_pointer()
> > > etc.
> > > 
> > > Would this be feasible? Or should one actually use __bitwise/__force to
> > > also get the warning when assigning between two variables both marked
> > > __rcu?
> > 
> > It might be.  There are a number of places where it is legal to access
> > RCU-protected pointers directly, and all of these would need to be
> > changed.  For example, in the example above, one could do:
> > 
> > 	foo = NULL;
> > 
> > I recently tried to modify rcu_assign_pointer() to issue the memory
> > memory barrier only when the pointer was non-NULL, but this ended badly.
> > Probably because I am not the greatest gcc expert around...  We ended
> > up having to define an rcu_assign_index() to handle the possibility of
> > assigning a zero-value array index, but my attempts to do type-checking
> > backfired, and I eventually gave it up.  Again, someone a bit more clued
> > in to gcc than I am could probably pull it off.
> > 
> > In addition, it is legal to omit rcu_dereference() and rcu_assign_pointer()
> > when holding the update-side lock.
> 
> We could start by annotating those as well, for example:
> 
>  __rcu spinlock_t tree_lock;
> 
> Then we would know that when tree lock is held the data structure is
> stable and we can ommit the rcu_*() functions.

Good point!  Though IIRC there are are cases where we are updating
one RCU-protected data structure while in an RCU read-side critical
section with respect to another RCU-protected data structure.

But it would probably best to start as you say rather than trying
to classify different RCU uses.  :-)

						Thanx, Paul
