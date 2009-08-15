Return-Path: <linux-kernel-owner+w=401wt.eu-S1753299AbZHOKi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299AbZHOKi2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 06:38:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753145AbZHOKi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 06:38:27 -0400
Received: from cantor.suse.de ([195.135.220.2]:46261 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752847AbZHOKi1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 06:38:27 -0400
Date: Sat, 15 Aug 2009 12:38:20 +0200
From: Nick Piggin <npiggin@suse.de>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Nadia Derbey <Nadia.Derbey@bull.net>,
       Pierre Peiffer <peifferp@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [patch 4a/4] ipc: sem optimise simple operations
Message-ID: <20090815103820.GC8954@wotan.suse.de>
References: <200908141946.n7EJkh7B018160@mail.q-ag.de> <20090815045237.GC19195@wotan.suse.de> <4A86899A.6050502@colorfullife.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A86899A.6050502@colorfullife.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 15, 2009 at 12:10:34PM +0200, Manfred Spraul wrote:
> On 08/15/2009 06:52 AM, Nick Piggin wrote:
> >
> >The problem with using the same algorithm is that we don't need to
> >"restart scanning" the simple-op lists when one of them succeeds.
> >This is because if a negative op fails, then no amount of subsequent
> >simple negative ops will make it succeed.
> >
> >With multi-ops, it can be adding and subtracting and waiting for
> >zero of different sems etc, so in order to try to stay strictly
> >FIFO, then we always have to recheck all previous failed ops after
> >one succeeds.
> >   
> What prevents us from optimizing the complex algorithm?
> 
> Right now, the rule is "restart if q->alter".
> What about "restart if at least one operation was an increment or if at 
> least one
> semaphore got 0"?

Well you could but it would still not be optimal for simple-op
case where you have outstanding -1 and 0 operations. Complex
operations are rare, so I preferred not to make it even more
complex by adding special cases but rather just add another
loop for doing simple ops which is much more obviously right.

I don't think it is a big deal to have multiple loops.


> >The other problem is that we have to scan all ops in the multi-op
> >list because we don't know what combination of sem values might
> >allow the op to succeed. With the single-op lists, we know if the
> >semval is 0, then we don't have to scan the negative list, and if
> >it is non-0 then we don't have to scan the zero list.
> >   
> If semval is 0, then the negative list is empty - it doesn't cost 
> anything to scan it, especially if the negative list is the first part 
> of a joint list.

No that's not the problem. If semval is 0, then you still have to
scan the complex list. If semval is 0, then you do not have to scan
the *negative* list. The problem is not the zero list.

 
> But you describe one difference between the simple and complex operations:
> - complex "increment" operations can be in the queue.
> - simple "increment" operations always succeed immediately.
> 
> Thus it is possible to stop scanning the simple queue if an "alter" 
> operation is found and the semaphore value is 0.

This is what I mean.


> For the complex queue, this optimization doesn't appear to be that simple.
> 
> AFAICS this is a realistic case:
> - 1000 threads are waiting with "decrement by 1".
> - semval is 0.
> - an increment by 1 arrives.
> 
> I've optimized that case, too - it's just one test.

If you have a significant number of wait-for-0 and the update goes to
non-zero it seems like it needelessly has to scan the wait-for-0
list. Subsequent decrements will cause the zero ops to be rescanned.

Also, your can_help logic is broken. 

> +		/* If we incremented a semaphore, or decremented
> +		 * a semaphore to 0, then this might allow other operations to
> +		 * proceed. Remember that.
> +		 * Note: helps is only an optimization, it doesn't matter that
> +		 * is is a bit conservative (e.g. decrement by 3, increment
> +		 * that sem by 2 doesn't help, but the code returns "helps=1").
> +		 */
> +		if (sem_op > 0 || (sem_op < 0 && result == 0))
> +			helps = 1;
>  		curr->semval = result;
>  	}
  
It is absolutely not true that decrements only help if they cause
the semaphore to reach 0.

Consider a multi-op semop which includes a decrement operation then
a wait-for-0 operation.

This, and...

> -static void update_queue (struct sem_array * sma)
> +static void update_queue(struct sem_array *sma, int semnum)
>  {
>  	struct sem_queue *q, *tq;
> +	struct list_head *pending_list;
> +
> +	/* if there are complex operations around, then knowing the semaphore
> +	 * that was modified doesn't help us. Assume that multiple semaphores
> +	 * were modified.
> +	 */
> +	if (sma->complex_count)
> +		semnum = -1;
> +
> +	if (semnum == -1)
> +		pending_list = &sma->sem_pending;
> +	else
> +		pending_list = &sma->sem_base[semnum].sem_pending;
>  
>  again:
> -	list_for_each_entry_safe(q, tq, &sma->sem_pending, list) {
> +	list_for_each_entry_safe(q, tq, pending_list, list) {
>  		int error;
> -		int alter;
> +		int could_help;
> +
> +		/* If we are looking for only one semaphore and that semaphore
> +		 * is 0, then it does not make sense to scan the "alter"
> +		 * entries: simple increments that affect only one entry
> +		 * succeed immediately and cannot be in the pending queue,
> +		 * and decrements cannot succeed if the value is already 0.
> +		 */
> +		if (semnum != -1 && sma->sem_base[semnum].semval == 0 &&
> +				q->alter)
> +			break;

These additional tests just seem to add complexity to me. Wheras my
code leaves complex list processing unchanged, and just adds some
simpler loops, yours adds additional complexity to an already complex
loop. I prefer my approach.


> With both optimizations, I see only one case left where your algorithm 
> is better:
> - semaphore value 1.
> - 1000 threads waiting for zero.
> - an increment by 1 arrives.
> 
> My code would scan the 1000 entries, your code doesn't.
> But: Does that exist in real life?

Don't know.

 
> Btw,
> - semaphore value 1
> - 1000 threads with "decrement 2" are waiting
> - an decrement by 1 arrives.
> My code doesn't scan at all, AFAICS you would scan all 1000 entries.
> The same argument applies:
> I would bet that this case doesn't exist in real life.

I don't see it. My code doesn't scan the negative queue at all if
the semaphore value is 0.

 
> Could you create a dump of the pending list from a test run?
> Does your database use "wait for zero", or increment/decrement 
> operations with offsets that are not +-1?

In this case I don't think it uses wait-for-zero. I don't have
access to the source code, I just created a really simple test
case. I just don't see the harm in optimizing more cases, and
with simpler loops.


> Do you see a common case where separate algorithms are necessary?
> 
> >Combine these two problems and that is where the O(n^2) behaviour
> >comes in to the complex-op algorithm.
> >   
> Yes - the worst case remains O(n^2), but only if there are increments.
> (to be fair: with the optimizations O(n*m) with n waiting tasks and m 
> increments)
> 
> But OTHO neither of our patches solves that.

Yeah I was talking about the O(n^2) remaining in your patch with
only single-op entries. Complex ops are tricky and I wasn't
concerned with optimising them for now.

