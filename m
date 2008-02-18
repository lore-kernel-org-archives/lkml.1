Return-Path: <linux-kernel-owner+w=401wt.eu-S1759034AbYBRPXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759034AbYBRPXh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 10:23:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755615AbYBRPX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 10:23:27 -0500
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:37148 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758328AbYBRPX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 10:23:26 -0500
Message-ID: <47B9A206.5000008@linux.vnet.ibm.com>
Date: Mon, 18 Feb 2008 20:49:34 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Regression with sched yield - 2.6.25-rc2-mm1
References: <47B9775F.1050203@linux.vnet.ibm.com> <1203338377.10858.3.camel@lappy>  <47B99AB4.3020604@linux.vnet.ibm.com> <1203347933.10858.8.camel@lappy>
In-Reply-To: <1203347933.10858.8.camel@lappy>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Mon, 2008-02-18 at 20:18 +0530, Balbir Singh wrote:
> 
>>> Humm, the check that should have avoided that is:
>>>
>>>         /*
>>>          * Are we the only task in the tree?
>>>          */
>>>         if (unlikely(rq->load.weight == curr->se.load.weight))
>>>                 return;
>>>
>>>
>>> But I guess that overlooks rt tasks, they also increase the load.
>>> So I guess something like this ought to fix it..
>>>
>> Peter,
>>
>> I don't remember any real time tasks running on the system, so I would be
>> surprised if that is indeed the case.
> 
> Various kthreads have rt prio. Notably the load_balancer_monitor().
> 

OK, but does it belong to the cfs_rq?

>>  Having said that, rightmost was indeed
>> NULL, so I need to figure out why it was. The other question is why would a real
>> time task be found by sched_yield_fair? 
> 
> Because a rt task contributes weight and would make the test above fail
> because rt->load would be larger than expected.
> 

I thought we were searching an RBtree for the fair group scheduler. If what you
say is indeed true, shouldn't we check if the task is an rt task in
sched_yield_fair() instead of the !rightmost check?

>>> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
>>> index b9ade89..83eb30c 100644
>>> --- a/kernel/sched_fair.c
>>> +++ b/kernel/sched_fair.c
>>> @@ -998,7 +998,7 @@ static void yield_task_fair(struct rq *rq)
>>>  	/*
>>>  	 * Already in the rightmost position?
>>>  	 */
>>> -	if (unlikely(rightmost->vruntime < se->vruntime))
>>> +	if (unlikely(!rightmost || rightmost->vruntime < se->vruntime))
>>>  		return;
>>>
>>>  	/*
>>>
> 


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
