Return-Path: <linux-kernel-owner+w=401wt.eu-S1757006AbYHGDSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757006AbYHGDSW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 23:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753143AbYHGDSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 23:18:13 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:35633 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954AbYHGDSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 23:18:12 -0400
Date: Wed, 6 Aug 2008 20:18:06 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, akpm@linux-foundation.org,
       oleg@tv-sign.ru, dipankar@in.ibm.com, rostedt@goodmis.org,
       dvhltc@us.ibm.com, niv@us.ibm.com
Subject: Re: [PATCH tip/core/rcu] classic RCU locking and memory-barrier
	cleanups
Message-ID: <20080807031806.GA6910@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080805162144.GA8297@linux.vnet.ibm.com> <489936E5.7020509@colorfullife.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <489936E5.7020509@colorfullife.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2008 at 07:30:13AM +0200, Manfred Spraul wrote:
> Hi Paul,
>
> Paul E. McKenney wrote:
>> This patch is in preparation for moving to a hierarchical
>> algorithm to allow the very large SMP machines -- requested by some
>> people at OLS, and there seem to have been a few recent patches in the
>> 4096-CPU direction as well.
>
> I thought about hierarchical RCU, but I never found the time to implement 
> it.
> Do you have a concept in mind?

Actually, you did submit a patch for a two-level hierarchy some years
back:

http://marc.theaimsgroup.com/?l=linux-kernel&m=108546384711797&w=2

I am looking to allow multiple levels to accommodate 4096 CPUs, which
pushes me towards locking on the nodes in the hierarchy.  I have
a roughed-out design that (I hope!) avoids deadlock and that allows
adapting to machine topology.  I am also trying to minimize the amount
of arch-specific code needed to construct the hierarchy -- hopefully
just a pair of config parameters.

More as it starts working...

> Right now, I try to understand the current code first - and some of it 
> doesn't make much sense.
>
> There are three per-cpu lists:
> ->nxt
> ->cur
> ->done.
>
> Obviously, there must be a quiescent state between cur and done.
> But why does the code require a quiescent state between nxt and cur?
> I think that's superflous. The only thing that is required is that all cpus 
> have moved their callbacks from nxt to cur. That doesn't need a quiescent 
> state, this operation could be done in hard interrupt as well.

The deal is that we have to put incoming callbacks somewhere while
the batch in ->cur waits for an RCU grace period.  That somewhere is
->nxt.  So to be painfully pedantic, the callbacks in ->nxt are not
waiting for an RCU grace period.  Instead, they are waiting for the
callbacks in ->cur to get out of the way.

> Thus I think this should work:
>
> 1) A callback is inserted into ->nxt.

Yep.

> 2) As soon as too many objects are sitting in the ->nxt lists, a new rcu 
> cycle is started.

Yep, call_rcu() and friends now do this. (In response to denial of
services attacks some years back.)

> 3) As soon as a cpu sees that a new rcu cycle is started, it moves it's 
> callbacks from ->nxt to ->cur. No checks for hard_irq_count & friends 
> necessary. Especially: same rule for _bh and normal.

Yep.  The checks for hard_irq_count are instead intended to determine
if this CPU is already in a quiescent state for the newly started RCU
grace period.  As long as we took the scheduling clock interrupt,
we might as well get our money's worth, right?

> 4) As soon as all cpus have moved their lists from ->nxt to ->cur, the real 
> grace period is started.

Jiangshan took a slightly different approach to handling this situation,
but yes, more or less.  The trick is that the processing in (4) for
->nxt is overlapped with the processing in (5) for ->cur.

> 5) As soon as all cpus passed a quiescent state (i.e.: now with tests for 
> hard_irq_count, different rules for _bh and normal), the list is moved from 
> ->cur to ->completed. Once in completed, they can be destroyed by 
> performing the callbacks.

To ->done rather than ->completed, but yes.

> What do you think? would that work? It doesn't make much sense that step 3) 
> tests for a quiescent state.

The trick is that the work for grace period n and grace period n+1
are overlapped.

> Step 2) could depend memory pressure.

Yep.

> Step 3) and 4) could be accelerated by force_quiescent_state(), if the 
> memory pressure is too high.

Yep -- though we haven't done this except on paper.

							Thanx, Paul

> --
>    Manfred
> -> nxt
>
