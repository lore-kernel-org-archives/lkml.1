Return-Path: <linux-kernel-owner+w=401wt.eu-S1757453AbXIXLXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453AbXIXLXN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 07:23:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755337AbXIXLW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 07:22:58 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:56339 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754227AbXIXLW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 07:22:58 -0400
Message-ID: <46F79DE7.40402@linux.vnet.ibm.com>
Date: Mon, 24 Sep 2007 16:52:15 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [RFC][PATCH] mm: couple rcu and memory reclaim
References: <20070924104517.7d8126ae@twins> <46F7948B.7000802@linux.vnet.ibm.com> <20070924130616.4141a084@twins>
In-Reply-To: <20070924130616.4141a084@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Mon, 24 Sep 2007 16:12:19 +0530 Balbir Singh
> <balbir@linux.vnet.ibm.com> wrote:
> 
>> Peter Zijlstra wrote:
>>> Just an idea I had, it seems like a good idea to wait for RCU callbacks
>>> in reclaim so that we won't get all of memory stuck there.
>>>
>>> If this location is too aggressive we might stick it next to
>>> disable_swap_token().
>>>
>>> ---
>>> Couple RCU and reclaim.
>>>
>>> There could be a lot of memory stuck in RCU callbacks. Wait for RCU to
>>> finish before giving it another go.
>>>
>>> Placed in kswapd and not direct reclaim path because kswapd never holds
>>> rcu_read_lock() at this point and can thus not deadlock. Direct reclaim
>>> callers might hold rcu_read_lock() and would suffer from deadlocks if
>>> sync_rcu() were to be called.
>>>
>>> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>>> ---
>>>  mm/vmscan.c |    4 +++-
>>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>>
>>> Index: linux-2.6/mm/vmscan.c
>>> ===================================================================
>>> --- linux-2.6.orig/mm/vmscan.c
>>> +++ linux-2.6/mm/vmscan.c
>>> @@ -1435,8 +1435,10 @@ loop_again:
>>>  		unsigned long lru_pages = 0;
>>>
>>>  		/* The swap token gets in the way of swapout... */
>>> -		if (!priority)
>>> +		if (!priority) {
>>> +			synchronize_rcu();
> 
> Bah, it seems I send the wrong patch out :-/
> 

Looks like I reviewed the wrong thing then :-)

> this is the one against disable_swap_token(). I meant to send out this
> one:
> 
> @@ -1527,8 +1527,10 @@ loop_again:
>                  * OK, kswapd is getting into trouble.  Take a nap, then take
>                  * another pass across the zones.
>                  */
> -               if (total_scanned && priority < DEF_PRIORITY - 2)
> +               if (total_scanned && priority < DEF_PRIORITY - 2) {
> +                       synchronize_rcu();
>                         congestion_wait(WRITE, HZ/10);
> +               }
> 
> 
>> Interesting change
>>
>> 1. I suspect that synchronize_rcu() is most likely to free up
>>    slab pages, so shrink_slab() will clean up all the freed
>>    pages. Could we add a comment to indicate the same?
> 
> Yes indeed, will add such a comment.
> 
>> 2. Shouldn't we do this in balance_pgdat() as well?
> 
> Uhm, this is balance_pgdat() (both these changes) :-)
> 

Hmm.. Could you please generate the diff with -p.

> Only kswapd can do this, direct reclaim has deadlock potential.

Yes, but not in all cases, do you want to add any gfp_mask
based smartness for direct reclaim?


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
