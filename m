Return-Path: <linux-kernel-owner+w=401wt.eu-S1760275AbYBUHpJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760275AbYBUHpJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 02:45:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751198AbYBUHo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 02:44:56 -0500
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:59896 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992AbYBUHoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 02:44:55 -0500
Message-ID: <47BD2A99.3010608@linux.vnet.ibm.com>
Date: Thu, 21 Feb 2008 13:09:05 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peter@programming.kicks-ass.net>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: Make yield_task_fair more efficient
References: <20080221053321.GA26918@balbir.in.ibm.com> <20080221060427.GA9159@elte.hu> <47BD1F75.5030506@linux.vnet.ibm.com> <20080221070733.GA13694@elte.hu>
In-Reply-To: <20080221070733.GA13694@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
>> I disagree. The cost is only adding a field to cfs_rq [...]
> 
> wrong. The cost is "only" of adding a field to cfs_rq and _updating it_, 
> in the hottest paths of the scheduler:
> 
> @@ -256,6 +257,7 @@ static void __enqueue_entity(struct cfs_
>                  */
>                 if (key < entity_key(cfs_rq, entry)) {
>                         link = &parent->rb_left;
> +                       rightmost = 0;

That's an update when we move leftwards.

>                 } else {
>                         link = &parent->rb_right;
>                         leftmost = 0;
> @@ -268,6 +270,8 @@ static void __enqueue_entity(struct cfs_
>          */
>         if (leftmost)
>                 cfs_rq->rb_leftmost = &se->run_node;
> +       if (rightmost)
> +               cfs_rq->rb_rightmost = &se->run_node;
> 

&se->run_node is already in the cache, we are assigning cfs_rq->rb_rightmost to it.

>> [...] For a large number of tasks - say 10000, we need to walk 14 
>> levels before we reach the node (each time). [...]
> 
> 10,000 yield-ing tasks is not a common workload we care about. It's not 
> even a rare workload we care about. _Especially_ we dont care about it 
> if it slows down every other workload (a tiny bit).
> 

sched_yield() is supported API and also look at
http://lkml.org/lkml/2007/9/19/351. I am trying to make sched_yield() efficient
when compat_sched_yield is turned on (which is most likely), since people will
want that behaviour (Hint, please read the man-page for sched_yield).There are
already several applications using sched_yield(), so they all suffer.

>> [...] Doesn't matter if the data is cached, we are still spending CPU 
>> time looking through pointers and walking to the right node. [...]
> 
> have you actually measured how much it takes to walk the tree that deep
> on recent hardware? I have.

I have measured how much time can be saved by not doing that and it's quite a lot.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
