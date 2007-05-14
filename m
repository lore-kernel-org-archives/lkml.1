Return-Path: <linux-kernel-owner+w=401wt.eu-S1758128AbXENVYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758128AbXENVYp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 17:24:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752336AbXENVYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 17:24:39 -0400
Received: from dodo.cs.umass.edu ([128.119.242.12]:46424 "EHLO
	dodo.cs.umass.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbXENVYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 17:24:38 -0400
Message-ID: <4648D381.6040808@cs.umass.edu>
Date: Mon, 14 May 2007 17:24:17 -0400
From: Ting Yang <tingy@cs.umass.edu>
Reply-To: tingy@cs.umass.edu
Organization: ALI Lab, CS Dept, UMASS
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: William Lee Irwin III <wli@holomorphy.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, efault@gmx.de,
       linux-kernel@vger.kernel.org
Subject: Re: fair clock use in CFS
References: <20070514083358.GA29775@in.ibm.com> <20070514102929.GL31925@holomorphy.com> <20070514103120.GA23766@elte.hu> <20070514110500.GV19966@holomorphy.com> <20070514115049.GA28721@elte.hu>
In-Reply-To: <20070514115049.GA28721@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Ingo Molnar wrote:
> * William Lee Irwin III <wli@holomorphy.com> wrote:
>
>   
>> On Mon, May 14, 2007 at 12:31:20PM +0200, Ingo Molnar wrote:
>>     
>>> please clarify - exactly what is a mistake? Thanks,
>>>       
>> The variability in ->fair_clock advancement rate was the mistake, at 
>> least according to my way of thinking. [...]
>>     
>
> you are quite wrong. Lets consider the following example:
>
> we have 10 tasks running (all at nice 0). The current task spends 20 
> msecs on the CPU and a new task is picked. How much CPU time did that 
> waiting task get entitled to during its 20 msecs wait? If fair_clock was 
> constant as you suggest then we'd give it 20 msecs - but its true 'fair 
> expectation' of CPU time was only 20/10 == 2 msecs!
>   
Exactly, once the queue virtual time is used, all other measures should 
be scaled onto virtual time for consistency, since at different time a 
unit of virtual time maps different amount wall clock time.

In CFS, the p->wait_runtime is in fact the lag against the ideal system, 
that is the difference between the amount of "really" done so far and 
the amount of work "should" be done so far. CFS really keeps a record 
for each task indicates how far away it is from the "should" case. If a 
task has p->wait_runtime = 0, it must have just received the exact share 
it entitled till now. Similarly negative means  faster than it "should" 
and positive  means slower than it "should".

I guess CFS may provides better "fairness" if it controls the negative 
wait_runtime can be accumulated by  a task. Higher priority allows more 
negative to be accumulated and low priority allows less. CFS has already 
done so by scaling granularity of preemption based on weight, the only 
issue is that the amount of negative wait_runtime can be accumulated is 
proportional to weight, which potentially can be O(n).

It is possible to do something like this in check_preemption ?
 
       delta = curr->fair_key - first->fair_key;

       if (delta > ??? [scale it as you wish] ||
            (curr->key > first->key) && (curr->wait_runtime > ??? 
[simple funtion of curr->weight]) )
              preempt

A limit control on wait_runtime may prevent a high weight task from 
running for too long, so that others get executed a little earlier. Just 
a thought :-)


Ting.


Ting

