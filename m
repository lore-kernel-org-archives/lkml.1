Return-Path: <linux-kernel-owner+w=401wt.eu-S1759842AbYDCV2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759842AbYDCV2L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 17:28:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755546AbYDCV15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 17:27:57 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:54475 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325AbYDCV14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 17:27:56 -0400
Date: Thu, 3 Apr 2008 14:27:53 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Jens Axboe <jens.axboe@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kmemcheck caught read from freed memory (cfq_free_io_context)
Message-ID: <20080403212753.GL8770@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080402105539.GA5610@linux.vnet.ibm.com> <84144f020804020401j4e5863dcofd16662baa54574@mail.gmail.com> <20080402160809.GA4123@linux.vnet.ibm.com> <19f34abd0804020915k210277bbmb6b9aa28f282bb42@mail.gmail.com> <Pine.LNX.4.64.0804021924280.6839@sbz-30.cs.Helsinki.FI> <20080402182352.GF9333@linux.vnet.ibm.com> <84144f020804021253i7e08e83fve3f2707063fc64d1@mail.gmail.com> <20080402201551.GL9333@linux.vnet.ibm.com> <20080403151842.GA25193@linux.vnet.ibm.com> <Pine.LNX.4.64.0804032244510.15758@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804032244510.15758@sbz-30.cs.Helsinki.FI>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2008 at 10:49:23PM +0300, Pekka J Enberg wrote:
> Hi Paul,
> 
> On Thu, 3 Apr 2008, Paul E. McKenney wrote:
> > OK, so another approach would be to use a larger shadow block for
> > SLAB_DESTROY_BY_RCU slabs, so that each shadow location would have enough
> > room for an rcu_head and a size in addition to the flag.  That would
> > trivialize tracking, or, more accurately, delegate such tracking to the
> > RCU infrastructure.
> 
> Yeah, or just allocate some extra spaces for the RCU case and not 
> overload the current shadow pages. But sounds good to me.

As long as we have an rcu_head for each memory block in the slab, I am
not to worried about where they are allocated.

> On Thu, 3 Apr 2008, Paul E. McKenney wrote:
> > Of course, the case where the block gets reallocated before the RCU
> > grace period ends would also need to be handled (which my rough sketch
> > yesterday did -not- handle, by the way...).
> > 
> > There are a couple of ways of doing this.  Probably the easiest approach
> > is to add more state to the flag, so that the RCU callback would check
> > to see if reallocation had already happened.  If so, it would update the
> > state to indicate that the rcu_head was again available, and would need to
> > repost itself if the block had been freed again after being reallocated.
> > 
> > The other approach would be to defer actually adding the block to the
> > freelist until the grace period expired.  This would be more accurate,
> > but also quite a bit more intrusive.
> 
> We already talked about deferring the actual freeing in kmemcheck to 
> better detect these use-after-free conditions with Vegard. So it's 
> something that we probably want to do regardless of RCU.

Then it is especially important that the rcu_head be pre-allocated.
Otherwise we could get into out-of-memory deadlocks where a free
operation is blocked by an allocation operation.  ;-)

							Thanx, Paul
