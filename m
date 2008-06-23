Return-Path: <linux-kernel-owner+w=401wt.eu-S1757332AbYFWD1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332AbYFWD1d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 23:27:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752852AbYFWD1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 23:27:25 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55631 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752840AbYFWD1Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 23:27:24 -0400
Message-ID: <485F17B2.5010700@cn.fujitsu.com>
Date: Mon, 23 Jun 2008 11:25:38 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] rcu classic: new algorithm for callbacks-processing
References: <4844BE83.5010401@cn.fujitsu.com> <20080608151844.GA18751@linux.vnet.ibm.com>
In-Reply-To: <20080608151844.GA18751@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I apologize for for so later response. I do not stop this works.
But some problems occurred when i tested. (Actually, i wanted to reply
you after all are fixed, my fault!)

Paul E. McKenney wrote:
> On Tue, Jun 03, 2008 at 11:46:11AM +0800, Lai Jiangshan wrote:
>> The code/algorithm of the implement of current callbacks-processing
>> is very efficient and technical. But when I studied it and I found
>> a disadvantage:
>>
>> In multi-CPU systems, when a new RCU callback is being
>> queued(call_rcu[_bh]), this callback will be invoked after the grace
>> period for the batch with batch number = rcp->cur+2 has completed
>> very very likely in current implement. Actually, this callback can be
>> invoked after the grace period for the batch with
>> batch number = rcp->cur+1 has completed. The delay of invocation means
>> that latency of synchronize_rcu() is extended. But more important thing
>> is that the callbacks usually free memory, and these works are delayed
>> too! it's necessary for reclaimer to free memory as soon as
>> possible when left memory is few.
> 
> Speeding up the RCU grace periods would indeed be a very good thing!
> 
>> A very simple way can solve this problem:
>> a field(struct rcu_head::batch) is added to record the batch number for
>> the RCU callback. And when a new RCU callback is being queued, we
>> determine the batch number for this callback(head->batch = rcp->cur+1)
>> and we move this callback to rdp->donelist if we find
>> that head->batch <= rcp->completed when we process callbacks.
>> This simple way reduces the wait time for invocation a lot. (about
>> 2.5Grace Period -> 1.5Grace Period in average in multi-CPU systems)
>>
>> This is my algorithm. But I do not add any field for struct rcu_head
>> in my implement. We just need to memorize the last 2 batches and
>> their batch number, because these 2 batches include all entries that
>> for whom the grace period hasn't completed. So we use a special
>> linked-list rather than add a field.
>> Please see the comment of struct rcu_data.
> 
> Maintaining the single list with multiple pointers into it certainly
> does seem to simplify the list processing, as does extracting the common
> code from call_rcu() and call_rcu_bh().  Just out of curiosity, why
> did you keep donelist as a separate list instead of an additional pointer
> into the mxtlist?
	donelist is only accessed in softirq(do not need irq disabled),
but nxtlist is not. i didn't want to modify rcu_do_batch().
> 
>> rcutourture was tested successfully(x86_64/4cpu i386/2cpu i386/1cpu).
> 
> Of course, RCU implementations need careful inspection, testing and
> validation.  Running rcutorture is a good first step, but unfortunately
> only a first step.  So I need to ask you the following questions:
> 
> 1.	How long did you run rcutorture?
	2 hours at the first time i run rcutorture , but no hotplug nor
test_no_idle_hz argument. How long would be appropriate?
> 
> 2.	Do you have access to weak-memory-order machines on which
> 	to do rcutorture testing?  (If not, I expect that we can
> 	motivate testing elsewhere.)
	I can't access to weak-memory-order machines. Could you please
test it after all my test are OK?
> 
> 3.	Did you run CPU hotplug while running rcutorture?  Doing so
> 	is extremely important, as RCU interacts with CPU hotplug.
	failed with the following script is run at the same time,
i hasn't found out the reason:
#!/bin/sh

# 4cpus

cpu1=1
cpu2=1
cpu3=1
while ((1))
do
	no=$(($RANDOM % 3 + 1))
	if ((!cpu$no))
	then
		echo 1 > /sys/devices/system/cpu/cpu$no/online
		((cpu$no=1))
	else
		echo 0 > /sys/devices/system/cpu/cpu$no/online
		((cpu$no=0))
	fi
	echo 1 $cpu1 $cpu2 $cpu3
	sleep 2
done

> 
> 4.	Did you use the rcutorture test_no_idle_hz and shuffle_interval
> 	arguments to test out RCU's interaction with CONFIG_NO_HZ?
> 	(This requires running a CONFIG_NO_HZ kernel.)
	test is OK with test_no_idle_hz=1 shuffle_interval=5.
It seems my patch changes nothing about NO_HZ.
> 
> 5.	One concern I have is the removal of a few memory barriers.
> 	Could you please tell me why it is safe to remove these?
	Yes, it is safe, it's may delay the processing a little
when read the old/error values for rcp->cur/rcp->next_pending.
I had fixed it. But it may still delay the processing when old value
for rcp->completed is read in rcu_pending().
> 
> Could you please run any additional combinations of tests that you
> are able to given the hardware you have access to?
	Yes, i will test and i want more advice.
> 
> And thank you very much for all your work in simplifying and speeding
> up RCU grace-period detection!  There may be some additional work
> required, but this patch does look promising!
> 
> 							Thanx, Paul
> 

	How can I test to find out whether a patch of rcu
advances system's performance?

	I didn't changed any code for batch's grace period. I just
insert callbacks into the right batch to speeding up their grace periods
in SMP.

	And I think broadcasting when a new batch is started will
speed up batch's grace period.

						Thanks, Lai Jiangshan

